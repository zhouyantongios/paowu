//
//  ViewController.m
//  paowu
//
//  Created by zhouyantong on 14/12/21.
//  Copyright (c) 2014年 zhouyantong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
/**
 *  商品加入购物车动画
 *
 *  @author
 *
 *  @since
 *
 *  第一步:因为控件的父控件不同,在动画执行的时候会因父坐标而受影响,所以需要将控件的
 *  坐标取出来,然后放到window上,便于坐标管理
 *  第二步:动画分为两部分:①抛物动画:可以用UIBezierPath类实现,坐标填写目的地坐标
 *  ②缩小动画:动画的缩小(缩小动画结束后移除动画)
 *  第三步:创建动画组,然后将上述的两个动画加入动画组来实现购物车效果
 *
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(20, 300, 50,90);
   
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(enjoy:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    //设置商品图
    _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1.jpg"]];
    _imageView.frame=CGRectMake(100, 300, 90, 130);
    [self.view addSubview:_imageView];
    
    
    //设置购物车图
    _ShoppingImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1.jpg"]];
    _ShoppingImageView.frame =CGRectMake(200, 30, 100, 130);
    [self.view addSubview:_ShoppingImageView];
    
}
- (void)enjoy:(UIButton *)btn
{
    
    CALayer *transitionLayer = [[CALayer alloc] init];
    //开启一个动画事务
    [CATransaction begin];
    
//CATransaction 事务类,可以对多个layer的属性同时进行修改.它分隐式事务,和显式事务.
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    transitionLayer.opacity = 0.6;
    //contents是layer的一个属性
    transitionLayer.contents = (id)_imageView.layer.contents;
    
    //父类不同,所以需要坐标系统的转换，必须是处于同一window内
    transitionLayer.frame = [[UIApplication sharedApplication].keyWindow convertRect:_imageView.bounds fromView:_imageView];
    
    
    [[UIApplication sharedApplication].keyWindow.layer addSublayer:transitionLayer];
    
    [UIView beginAnimations:@"imageViewAnimation" context:(__bridge void *)(_imageView)];
    [CATransaction commit];
    
    
    
    
    //路径曲线:贝塞尔曲线，使动画按照你所设定的贝塞尔曲线运动
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    [movePath moveToPoint:transitionLayer.position];
    //传入购物车的坐标(X,Y)
    CGPoint toPoint = CGPointMake(_ShoppingImageView.center.x, _ShoppingImageView.center.y  );
    //
    [movePath addQuadCurveToPoint:toPoint
                     controlPoint:CGPointMake(_ShoppingImageView.center.x,transitionLayer.position.y-50)];
    
    
    //关键帧
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.path = movePath.CGPath;
    positionAnimation.removedOnCompletion = YES;
    
    
    //缩小动画
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)];
    //缩小动画结束移除
    scaleAnim.removedOnCompletion = YES;

    
    //将抛物动画和缩小动画加入动画组，可以执行多个动画，并且设置动画的执行时间
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.beginTime = CACurrentMediaTime();
    group.duration = 0.7;
    group.animations = [NSArray arrayWithObjects:positionAnimation,scaleAnim,nil];
    group.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = YES;
    group.autoreverses= NO;
    [transitionLayer addAnimation:group forKey:@"opacity"];
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
