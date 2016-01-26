//
//  ViewController.m
//  TaskManager
//
//  Created by 佐毅 on 16/1/26.
//  Copyright © 2016年 上海乐住信息技术有限公司. All rights reserved.
//

#import "ViewController.h"
#import "iCarousel.h"

@interface ViewController ()<iCarouselDataSource,iCarouselDelegate>

@property (strong,nonatomic) iCarousel *carousel;

@property (nonatomic,assign) CGSize     taskCardSize;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat taskCardWidth = [UIScreen mainScreen].bounds.size.width*5.0/7.0;
    self.taskCardSize =CGSizeMake(taskCardWidth, taskCardWidth*16.0/9.0);
    
    _carousel = [[iCarousel alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [_carousel setDelegate:self];
    [_carousel setDataSource:self];
    [_carousel setType:iCarouselTypeCustom];
    [_carousel setBounceDistance:0.1f];
    [self.view addSubview:self.carousel];

    
    
    
}
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return 8;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    UIView *taskCardView = view;
    if (!taskCardView) {
       taskCardView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.taskCardSize.width, self.taskCardSize.height)];
       
        UIImageView *cardImageView = [[UIImageView alloc]initWithFrame:taskCardView.bounds];
        cardImageView.contentMode = UIViewContentModeScaleAspectFill;
        cardImageView.backgroundColor = [UIColor orangeColor];
        [taskCardView addSubview:cardImageView];
        [cardImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",index+1]]];
        [taskCardView.layer setShadowPath:[UIBezierPath bezierPathWithRoundedRect:cardImageView.frame cornerRadius:5.0f].CGPath];
        [taskCardView.layer setShadowRadius:3.0f];
       
        CAShapeLayer *layer = [CAShapeLayer layer];
        [layer setFrame:cardImageView.frame];
        [layer setPath:[UIBezierPath bezierPathWithRoundedRect:cardImageView.frame cornerRadius:5.0f].CGPath];
        
        [cardImageView.layer setMask:layer];
    }
    return taskCardView;
}

- (CGFloat )calcScaleWithOffset:(CGFloat)offset{
    return offset*0.02f+1.0f;
}

- (CGFloat )calaTranslationWithOffset:(CGFloat )offset{
    CGFloat z = 5.0f/4.0f;
    CGFloat a = 5.0f/8.0f;
    
    //移除屏幕
    if (offset>=z/a) {
        return 2.0f;
    }
    
    return 1/(z-a*offset)-1/z;
    
}

-(CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform{
    CGFloat scale = [self calcScaleWithOffset:offset];
    CGFloat translation = [self calaTranslationWithOffset:offset];
    return CATransform3DScale(CATransform3DTranslate(transform, translation*self.taskCardSize.width, 0, offset),scale,scale,1.0f);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
