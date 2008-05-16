Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbYEPJYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbYEPJYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 05:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbYEPJYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 05:24:05 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:35444 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbYEPJYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 05:24:04 -0400
Date: Fri, 16 May 2008 11:24:40 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] drivers/media/video build fix for certain modular builds
Message-ID: <20080516092440.GA31432@uranus.ravnborg.org>
References: <20080516071029.GA13147@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080516071029.GA13147@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 09:10:29AM +0200, Ingo Molnar wrote:
> 
> testing of the -tip tree found the following missing symbols build bug:
> 
>     LD      init/built-in.o
>     LD      .tmp_vmlinux1
>     drivers/built-in.o: In function `vidioc_g_ctrl':
>     radio-maxiradio.c:(.text+0xd3337): undefined reference to `video_devdata'
>     drivers/built-in.o: In function `vidioc_g_frequency':
>     radio-maxiradio.c:(.text+0xd3368): undefined reference to `video_devdata'
>     drivers/built-in.o: In function `vidioc_s_ctrl':
>     [...]
> 
> which happens if certain media drivers are modular:
> 
>     http://redhat.com/~mingo/misc/config-Thu_May_15_18_10_27_CEST_2008.bad
> 
> the problem is:
> 
>     CONFIG_VIDEO_MEDIA=m
>     CONFIG_VIDEO_DEV=y
>     CONFIG_RADIO_MAXIRADIO=y
>     CONFIG_VIDEO_V4L2=y
> 
> Connecting the build dependencies tree from drivers/media/ to 
> drivers/media/video/ allows the built-in drivers(s) to pick up the 
> CONFIG_VIDEO_DEV=y symbols.
> 
> ---
>  drivers/media/Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux/drivers/media/Makefile
> ===================================================================
> --- linux.orig/drivers/media/Makefile
> +++ linux/drivers/media/Makefile
> @@ -2,7 +2,7 @@
>  # Makefile for the kernel multimedia device drivers.
>  #
>  
> -obj-y := common/
> +obj-y := common/ video/
>  
>  obj-$(CONFIG_VIDEO_MEDIA) += common/
>  

Adrian just posted a similar fix that I like better because it
cleans up the Makefile a bit.
The obj-$(CONFIG_VIDEO_MEDIA) += common/ assignment in the
above is for example now redundant.

But otherwise obviously correct.

	Sam

