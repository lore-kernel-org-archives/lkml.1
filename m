Return-Path: <linux-kernel-owner+w=401wt.eu-S1757514AbXI2AJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514AbXI2AJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 20:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755193AbXI2AJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 20:09:39 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:31981 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbXI2AJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 20:09:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Yrmq+FOnqoNh+3QXX3ZkwSaYozngEMAmTRv3WExBAM8D1ZkgY9HN4Ke/MGM/u170n++m2JZ5DkKv0//Q6IqwCKq1vzRwt3sSldJERMl3EG5gP46pJIOQPhhHPulpzARaqr1ORIIwySkpGJFWnO3zI3LKgpJswrvs97STJvevTUw=
Subject: Re: [PATCH 2/2] [VIDEO FRAMEBUFFER] Blackfin BF54x framebuffer
	device driver for a SHARP LQ043T1DG01 TFT LCD
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: bryan.wu@analog.com
Cc: linux-fbdev-devel@lists.sourceforge.net,
       Michael Hennerich <michael.hennerich@analog.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel@blackfin.uclinux.org
In-Reply-To: <1190778219.18676.13.camel@roc-laptop>
References: <1190778219.18676.13.camel@roc-laptop>
Content-Type: text/plain
Date: Sat, 29 Sep 2007 08:09:30 +0800
Message-Id: <1191024570.5273.4.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-26 at 11:43 +0800, Bryan Wu wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
> Date: Wed, 26 Sep 2007 11:33:01 +0800
> Subject: [PATCH 2/2] [VIDEO FRAMEBUFFER] Blackfin BF54x framebuffer device driver for a SHARP LQ043T1DG01 TFT LCD
> 
> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> ---
>  drivers/video/Kconfig                         |    9 +
>  drivers/video/Makefile                        |    1 +
>  drivers/video/bf54x-lq043.c                   |  786 +++++++++++++++++++++++++
>  include/asm-blackfin/mach-bf548/bf54x-lq043.h |   30 +
>  4 files changed, 826 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/video/bf54x-lq043.c
>  create mode 100644 include/asm-blackfin/mach-bf548/bf54x-lq043.h
> 
> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> index 5216c11..41fae00 100644
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -535,6 +535,15 @@ config FB_VGA16
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called vga16fb.
>  
> +config FB_BF54X_LQ043
> +	tristate "SHARP LQ043 TFT LCD (BF548 EZKIT)"
> +	depends on FB && (BF54x)
> +	select FB_CFB_FILLRECT
> +	select FB_CFB_COPYAREA
> +	select FB_CFB_IMAGEBLIT
> +	help
> +	 This is the framebuffer device driver for a SHARP LQ043T1DG01 TFT LCD
> +
>  config FB_STI
>  	tristate "HP STI frame buffer device support"
>  	depends on FB && PARISC
> diff --git a/drivers/video/Makefile b/drivers/video/Makefile
> index 06eec7b..359e560 100644
> --- a/drivers/video/Makefile
> +++ b/drivers/video/Makefile
> @@ -122,6 +122,7 @@ obj-$(CONFIG_FB_OF)               += offb.o
>  
>  # the test framebuffer is last
>  obj-$(CONFIG_FB_VIRTUAL)          += vfb.o
> +obj-$(CONFIG_FB_BF54X_LQ043)	  += bf54x-lq043.o

It's standard that we suffix all framebuffer drivers with an 'fb'. I'm
making it so in my tree.

Also, you shouldn't place your driver after vfb, that's why there's a
comment that the test framebuffer is last. If someone accidentally
enables vfb, he/she will get a blank screen. So I'm moving it under the
platform driver section. 

Tony



