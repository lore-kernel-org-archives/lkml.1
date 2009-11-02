Return-Path: <linux-kernel-owner+w=401wt.eu-S932392AbZKBU1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392AbZKBU1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 15:27:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932319AbZKBU1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 15:27:54 -0500
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:58087 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932309AbZKBU1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 15:27:53 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-17.arcor-online.net 9FE203B23C9
Subject: Re: [Bug 12309] Large I/O operations result in slow performance
 and high iowait times
From: Thomas Pilarski <thomas.pi@arcor.de>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1257177364.10173.23.camel@marge.simson.net>
References: <20091101134207.b97e4f5f.akpm@linux-foundation.org>
	 <1257177364.10173.23.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Nov 2009 21:26:49 +0100
Message-Id: <1257193609.2378.28.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

Am Montag, den 02.11.2009, 16:56 +0100 schrieb Mike Galbraith: 
> > --- Comment #412 from Thomas Pilarski <thomas.pi@arcor.de>  2009-11-01 21:28:24 ---
> > Created an attachment (id=23618)
> >  --> (http://bugzilla.kernel.org/attachment.cgi?id=23618)
> > Simple sleeper test case
> > 
> > [...]
> 
> Can you please try the latest -rc?  I spent the day trying to coax a
> latency spike out of -tip, including thumping disk with dd, mysql+oltp
> rw test et al, and failed.

I have just tries the rc5 and the spikes are still there, but much
shorter. The test case does not show latencies <15ms. For these tests, I
have reduced the minimum printout time to 3ms. The notebook with the
first generation ssd in not available for testing, till next weekend.

The freezes still exists with the kernel 32, but the freezes are more
seldom and shorter. But I am not sure, as the X-Server is unusable on my
machine in vesa mode with the rc5 kernel.  

Here are the results with the rc5 kernel and the fedora kernel
vmlinuz-2.6.31.5-96.fc12.x86_64. I have changed my system yesterday.

This test was made during a kernel build.

Kernel 32:
Timediff     220114:    3.01ms Total:   9.44ms
Timediff     222460:    3.58ms Total:  10.82ms
Timediff     234968:    3.23ms Total:   9.99ms
Timediff     235916:    3.19ms Total:  11.50ms
Timediff     236448:    3.55ms Total:  12.71ms
Timediff     236485:    3.56ms Total:  16.14ms
Timediff     236793:    3.49ms Total:  10.54ms
Timediff     237076:    3.58ms Total:  11.29ms
Timediff     237417:    3.88ms Total:  12.05ms
Timediff     237694:    4.03ms Total:  15.36ms
Timediff     238039:    3.55ms Total:  11.64ms
Timediff     238347:    3.57ms Total:  10.23ms
Timediff     278945:    4.82ms Total:  11.25ms
Timediff     306303:    3.14ms Total:  10.22ms
Timediff     310378:    3.00ms Total:   9.49ms
Timediff     312685:    3.08ms Total:   9.53ms
Timediff     323824:    3.93ms Total:  10.37ms
Timediff     324150:    3.25ms Total:   9.90ms

With the kernel 31 the latencies are ~3-5ms with about 10 spikes every
10 seconds >15ms.



This test was made with eight concurrent writing operations. With kernel
32, the system freezes for up to 5 seconds. With the 31 kernel the
system is unusable and freezes for more than 15 seconds.

Kernel 32:
Timediff     541833:    5.45ms Total:  13.96ms
Timediff     541835:    5.96ms Total:  20.69ms
Timediff     562105:   47.17ms Total:  54.12ms
Timediff     562108:    4.72ms Total:  62.26ms
Timediff     562873:    3.51ms Total:   9.87ms
Timediff     562965:    4.80ms Total:  14.66ms
Timediff     563258:    5.82ms Total:  12.06ms
Timediff     564122:    4.54ms Total:  10.64ms
Timediff     564320:    4.41ms Total:  15.62ms
Timediff     565994:    3.52ms Total:  11.82ms
Timediff     571837:    4.84ms Total:  13.08ms
Timediff     574202:    6.26ms Total:  15.30ms
Timediff     580009:    4.26ms Total:  12.17ms
Timediff     581148:    5.97ms Total:  14.01ms
Timediff     604232:    8.06ms Total:  18.51ms
Timediff     607985:   36.17ms Total:  43.24ms
Timediff     607988:    6.44ms Total:  51.55ms
Timediff     607991:    3.96ms Total:  57.71ms
Timediff     608839:    3.15ms Total:  11.97ms
Timediff     621034:   11.70ms Total:  18.12ms
Timediff     626739:   14.79ms Total:  21.28ms
Timediff     628626:    4.29ms Total:  10.76ms
Timediff     630171:    3.17ms Total:  11.80ms
Timediff     630230:    4.68ms Total:  16.98ms
Timediff     645119:    5.24ms Total:  14.22ms
Timediff     645126:    3.01ms Total:  18.15ms
Timediff     665520:   23.39ms Total:  30.43ms
Timediff     665522:    7.21ms Total:  38.46ms
Timediff     665524:    4.05ms Total:  45.33ms
Timediff     665525:   12.37ms Total:  57.62ms
Timediff     665526:    8.55ms Total:  66.10ms
Timediff     666559:    7.40ms Total:  13.55ms
Timediff     666722:    9.98ms Total:  17.39ms
Timediff     692704:    3.91ms Total:  14.77ms
Timediff     709733:    5.22ms Total:  12.83ms
Timediff     713358:    9.96ms Total:  16.92ms
Timediff     713711:    6.71ms Total:  13.14ms
Timediff     713762:    9.60ms Total:  22.32ms
Timediff     715036:    6.61ms Total:  13.02ms
Timediff     715333:    8.16ms Total:  14.72ms
Timediff     716295:    5.69ms Total:  11.85ms
Timediff     717586:   13.30ms Total:  19.65ms
Timediff     720534:    4.00ms Total:  11.11ms
Timediff     724444:    3.78ms Total:  11.39ms
Timediff     742710:    5.91ms Total:  16.60ms
Timediff     746094:    9.36ms Total:  16.82ms
Timediff     746253:    3.01ms Total:  10.58ms
Timediff     750732:    3.12ms Total:   9.07ms
Timediff     750970:    4.66ms Total:  10.74ms
Timediff     751004:   11.48ms Total:  22.13ms
Timediff     751344:    3.24ms Total:  10.00ms
Timediff     752615:    6.09ms Total:  12.77ms
Timediff     752692:   10.48ms Total:  23.34ms
Timediff     752750:    5.66ms Total:  24.95ms
Timediff     753517:    5.40ms Total:  11.87ms
Timediff     764817:    3.01ms Total:  10.55ms
Timediff     780410:    7.68ms Total:  14.25ms
Timediff     781238:    3.22ms Total:   9.80ms
Timediff     781751:    4.32ms Total:  10.41ms
Timediff     783193:    3.02ms Total:   9.11ms
Timediff     783376:    5.04ms Total:  13.13ms
Timediff     783443:   10.43ms Total:  21.73ms
Timediff     783849:    3.56ms Total:   9.63ms
Timediff     783998:    4.75ms Total:  11.03ms
Timediff     789922:   14.12ms Total:  23.77ms
Timediff     791834:   10.17ms Total:  17.70ms
Timediff     791968:    4.33ms Total:  10.70ms
Timediff     803919:    8.23ms Total:  18.95ms
Timediff     814559:   22.20ms Total:  29.33ms
Timediff     814561:    8.97ms Total:  39.13ms
Timediff     814562:    9.33ms Total:  48.39ms
Timediff     814564:    3.54ms Total:  52.41ms
Timediff     814565:   11.44ms Total:  63.78ms
Timediff     814959:    6.00ms Total:  12.12ms
Timediff     816641:    7.36ms Total:  14.17ms
Timediff     817586:    8.70ms Total:  17.21ms
Timediff     817600:    3.01ms Total:  23.88ms
Timediff     818541:   11.60ms Total:  17.78ms
Timediff     836524:    9.60ms Total:  18.08ms
Timediff     847263:    7.33ms Total:  14.82ms
Timediff     847581:    3.92ms Total:  10.61ms
Timediff     857510:    5.21ms Total:  16.21ms
Timediff     875426:   34.63ms Total:  42.72ms
Timediff     875428:   15.56ms Total:  58.63ms
Timediff     875430:    4.25ms Total:  64.14ms
Timediff     875432:    9.90ms Total:  74.97ms


Kernel 31:
Timediff    3051355:    3.56ms Total:  12.01ms
Timediff    3052075:    3.04ms Total:  11.18ms
Timediff    3052727:    5.05ms Total:  11.98ms
Timediff    3052728:    6.32ms Total:  18.23ms
Timediff    3064913:  209.00ms Total: 215.89ms
Timediff    3087930:    7.33ms Total:  13.96ms
Timediff    3087931:    8.93ms Total:  22.84ms
Timediff    3088666:   10.73ms Total:  17.63ms
Timediff    3129442:   50.38ms Total:  57.85ms
Timediff    3129443:    6.97ms Total:  64.75ms
Timediff    3129444:    3.97ms Total:  68.64ms
Timediff    3129561:    9.71ms Total:  15.97ms
Timediff    3147899:  195.24ms Total: 202.19ms
Timediff    3202247:    4.25ms Total:  12.78ms
Timediff    3202480:   12.92ms Total:  19.53ms
Timediff    3202811:    8.06ms Total:  14.62ms
Timediff    3202812:    9.92ms Total:  24.48ms
Timediff    3207028:   10.27ms Total:  19.03ms
Timediff    3221487:  155.74ms Total: 162.68ms
Timediff    3245089:   16.85ms Total:  23.19ms
Timediff    3245090:    5.94ms Total:  29.07ms
Timediff    3245091:    8.93ms Total:  37.95ms
Timediff    3245092:    8.97ms Total:  46.85ms
Timediff    3283440:   33.92ms Total:  41.07ms

And this test during coping a file from one encrypted ext4 to a ext3
(data=ordered) partition. 

Kernel 32:
Timediff    3519663:    4.30ms Total:  12.02ms
Timediff    3519949:    5.09ms Total:  15.30ms
Timediff    3520668:    4.49ms Total:  13.65ms
Timediff    3524199:    3.56ms Total:  12.34ms
Timediff    3525677:    4.10ms Total:  10.87ms
Timediff    3526071:   13.81ms Total:  21.45ms
Timediff    3526347:   11.53ms Total:  18.21ms
Timediff    3526606:   10.62ms Total:  17.31ms
Timediff    3526847:    9.90ms Total:  16.45ms
Timediff    3527074:    9.07ms Total:  15.46ms
Timediff    3529137:    5.50ms Total:  14.79ms
Timediff    3563927:    3.39ms Total:  13.19ms
Timediff    3622363:    3.96ms Total:  11.33ms
Timediff    3626268:    6.53ms Total:  14.77ms
Timediff    3626270:    5.92ms Total:  21.57ms
Timediff    3644582:   11.01ms Total:  21.53ms
Timediff    3654125:    8.69ms Total:  16.16ms
Timediff    3663323:    6.19ms Total:  12.83ms
Timediff    3663471:    5.55ms Total:  12.51ms
Timediff    3669593:    4.50ms Total:  11.63ms
Timediff    3679411:    4.84ms Total:  12.92ms
Timediff    3710494:    8.88ms Total:  18.84ms

Kernel 31:
Timediff     418897:    7.69ms Total:  32.66ms
Timediff     419046:   12.44ms Total:  21.66ms
Timediff     419048:    4.89ms Total:  26.98ms
Timediff     419788:    3.12ms Total:  13.01ms
Timediff     424485:    3.96ms Total:  12.58ms
Timediff     424492:    8.26ms Total:  20.69ms
Timediff     424909:   12.77ms Total:  22.17ms
Timediff     425081:    4.48ms Total:  23.68ms
Timediff     425362:   10.47ms Total:  19.98ms
Timediff     425365:    8.95ms Total:  28.83ms
Timediff     438326:   11.14ms Total:  21.51ms
Timediff     438534:    4.49ms Total:  24.64ms
Timediff     438817:    4.50ms Total:  26.54ms
Timediff     439276:    3.35ms Total:  10.78ms
Timediff     439278:   12.95ms Total:  23.66ms
Timediff     439717:   17.05ms Total:  26.49ms
Timediff     439937:   15.20ms Total:  22.50ms
Timediff     451047:    4.21ms Total:  12.41ms
Timediff     451454:   10.25ms Total:  19.86ms
Timediff     451606:    3.56ms Total:  23.22ms
Timediff     451984:    5.60ms Total:  18.60ms

The last test: dd if=/dev/zero of=test1 bs=1M count=8K to a ext3
(data=ordered) partition

Kernel 32: (Throughput 34,3 MB/s)
Timediff    3758684:    3.95ms Total:  14.74ms
Timediff    3761994:    3.53ms Total:  13.84ms
Timediff    3765917:    3.32ms Total:  14.68ms
Timediff    3770973:    3.63ms Total:  14.05ms
Timediff    3771301:    3.27ms Total:  13.44ms
Timediff    3774010:    3.02ms Total:  13.68ms
Timediff    3774263:    3.96ms Total:  14.41ms
Timediff    3777798:    4.01ms Total:  15.53ms
Timediff    3787290:    3.55ms Total:  14.39ms
Timediff    3787611:    3.60ms Total:  14.21ms
Timediff    3790433:    3.37ms Total:  14.14ms
Timediff    3790676:    3.09ms Total:  13.66ms
Timediff    3792464:    3.25ms Total:  13.16ms
Timediff    3792747:    3.34ms Total:  14.28ms
Timediff    3795961:    3.60ms Total:  13.72ms
Timediff    3797212:    4.00ms Total:  14.60ms
Timediff    3798908:    3.76ms Total:  14.49ms
Timediff    3803617:    4.48ms Total:  14.85ms
Timediff    3803855:    4.06ms Total:  14.67ms
Timediff    3805129:    3.71ms Total:  14.51ms
Timediff    3805431:    4.52ms Total:  15.55ms
Timediff    3807400:    4.17ms Total:  15.40ms
Timediff    3809013:    5.45ms Total:  16.39ms
Timediff    3811439:    3.51ms Total:  12.84ms
Timediff    3811680:    3.75ms Total:  14.83ms
Timediff    3823024:    4.02ms Total:  14.95ms
Timediff    3828474:    4.25ms Total:  14.74ms
Timediff    3836624:    3.03ms Total:  13.54ms
Timediff    3836919:    4.86ms Total:  16.72ms
Timediff    3845647:    3.74ms Total:  14.55ms
Timediff    3847453:    4.41ms Total:  15.06ms
Timediff    3847758:    3.12ms Total:  12.52ms
Timediff    3860736:    3.26ms Total:  14.12ms
Timediff    3860824:    5.95ms Total:  19.24ms
Timediff    3864060:    4.24ms Total:  14.29ms
Timediff    3866621:    4.02ms Total:  14.38ms
Timediff    3866863:    3.25ms Total:  13.00ms
Timediff    3871055:    4.54ms Total:  15.55ms
Timediff    3876891:    3.66ms Total:  15.05ms
Timediff    3883110:    4.13ms Total:  14.36ms
Timediff    3883432:    4.69ms Total:  15.04ms
Timediff    3890870:    4.31ms Total:  15.56ms
Timediff    3899279:    4.50ms Total:  15.60ms
Timediff    3906261:    3.82ms Total:  12.61ms
Timediff    3906605:    4.85ms Total:  15.35ms
Timediff    3908836:    4.27ms Total:  15.62ms
Timediff    3909079:    4.50ms Total:  15.37ms
Timediff    3910731:    3.57ms Total:  12.76ms
Timediff    3911044:    4.70ms Total:  14.80ms
Timediff    3912716:    4.67ms Total:  15.22ms
Timediff    3913027:    4.59ms Total:  15.39ms
Timediff    3914187:    4.00ms Total:  13.14ms
Timediff    3919700:    3.11ms Total:  14.77ms
Timediff    3921904:    4.76ms Total:  15.35ms
Timediff    3926853:    3.32ms Total:  14.19ms
Timediff    3926920:    4.03ms Total:  17.92ms
Timediff    3929504:    3.73ms Total:  14.70ms
Timediff    3929767:    4.13ms Total:  13.80ms
Timediff    3931576:    3.62ms Total:  14.70ms
Timediff    3931670:    3.04ms Total:  16.53ms
Timediff    3933039:    5.11ms Total:  16.19ms
Timediff    3935405:    3.83ms Total:  15.33ms
Timediff    3939429:    3.23ms Total:  14.50ms
Timediff    3940606:    4.34ms Total:  15.47ms
Timediff    3940825:    3.20ms Total:  15.06ms
Timediff    3950448:    3.14ms Total:  14.98ms
Timediff    3950727:    3.16ms Total:  14.17ms
Timediff    3968492:    3.16ms Total:  14.46ms


Kernel 31: (Throughput 33,7 MB/s)
Timediff    3759425:    8.49ms Total:  16.14ms
Timediff    3766033:    7.79ms Total:  15.44ms
Timediff    3786336:   10.13ms Total:  17.75ms
Timediff    3788547:    4.97ms Total:  12.63ms
Timediff    3790714:    4.80ms Total:  12.82ms
Timediff    3792863:    4.82ms Total:  12.52ms
Timediff    3795029:    5.45ms Total:  13.28ms
Timediff    3797198:    4.78ms Total:  13.02ms
Timediff    3797664:  109.83ms Total: 118.02ms
Timediff    3800212:    4.91ms Total:  13.50ms
Timediff    3806437:    5.78ms Total:  15.46ms
Timediff    3807558:   14.73ms Total:  23.01ms
Timediff    3808257:   16.44ms Total:  24.05ms
Timediff    3810303:   14.62ms Total:  23.92ms
Timediff    3812049:   18.96ms Total:  27.83ms
Timediff    3813914:   11.95ms Total:  20.75ms
Timediff    3814444:    4.79ms Total:  12.90ms
Timediff    3818132:    5.22ms Total:  14.41ms
Timediff    3831185:    5.02ms Total:  14.17ms
Timediff    3833362:    5.75ms Total:  13.66ms
Timediff    3845301:    8.16ms Total:  18.06ms

As you can see, the spikes are still there, but much more seldom and
shorter. Perhaps the opposite way, a delay or something equal in the
block-layer or scheduler to maximize this problem, can help to locate
the culprit.


Thomas

