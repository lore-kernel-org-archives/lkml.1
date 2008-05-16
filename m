Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbYEPJZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbYEPJZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 05:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbYEPJZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 05:25:08 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:43988 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbYEPJZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 05:25:07 -0400
Date: Fri, 16 May 2008 11:25:43 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, video4linux-list@redhat.com
Subject: Re: [2.6 patch] always enter drivers/media/video/
Message-ID: <20080516092543.GB31432@uranus.ravnborg.org>
References: <200805151515.28249.toralf.foerster@gmx.de> <20080516080113.GO1936@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080516080113.GO1936@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 11:01:13AM +0300, Adrian Bunk wrote:
> After commit 039d40019f3c5e26ea50ec5af4270189f63365e1
> (V4L/DVB (7898): Fix VIDEO_MEDIA Kconfig logic)
> VIDEO_MEDIA is no longer usable in Makefile's for deciding
> which directories we enter, resulting in compile errors like the 
> following with CONFIG_VIDEO_DEV=y, CONFIG_DVB_CORE=m:
> 
> <--  snip  -->
> 
> ...
>   MODPOST 187 modules
> ERROR: "video_exclusive_release" [drivers/media/radio/radio-zoltrix.ko] undefined!
> ERROR: "video_exclusive_open" [drivers/media/radio/radio-zoltrix.ko] undefined!
> ERROR: "video_ioctl2" [drivers/media/radio/radio-zoltrix.ko] undefined!
> ERROR: "video_register_device" [drivers/media/radio/radio-zoltrix.ko] undefined!
> ERROR: "video_devdata" [drivers/media/radio/radio-zoltrix.ko] undefined!
> ERROR: "video_unregister_device" [drivers/media/radio/radio-zoltrix.ko] undefined!
> ...
> make[2]: *** [__modpost] Error 1
> 
> <--  snip  -->
> 
> The easiest solution is to always enter video/
> 
> Reported-by: Toralf Förster <toralf.foerster@gmx.de>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 62aa0f0990ec569868b34764c255268a5e425486 diff --git a/drivers/media/Makefile b/drivers/media/Makefile
> index cc11c4c..09a829d 100644
> --- a/drivers/media/Makefile
> +++ b/drivers/media/Makefile
> @@ -2,12 +2,7 @@
>  # Makefile for the kernel multimedia device drivers.
>  #
>  
> -obj-y := common/
> -
> -obj-$(CONFIG_VIDEO_MEDIA) += common/
> -
> -# Since hybrid devices are here, should be compiled if DVB and/or V4L
> -obj-$(CONFIG_VIDEO_MEDIA) += video/
> +obj-y += common/ video/
>  
>  obj-$(CONFIG_VIDEO_DEV) += radio/
>  obj-$(CONFIG_DVB_CORE)  += dvb/

Looks good. We end up with a simpler Makefile.

	Sam
