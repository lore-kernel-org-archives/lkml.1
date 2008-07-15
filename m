Return-Path: <linux-kernel-owner+w=401wt.eu-S1757029AbYGOXQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029AbYGOXQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 19:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753726AbYGOXQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 19:16:46 -0400
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:60666 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752189AbYGOXQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 19:16:45 -0400
Subject: Re: [PATCH] V4L: Link tuner before saa7134
From: hermann pitton <hermann-pitton@arcor.de>
To: Simon Arlott <simon@fire.lp0.eu>,
       Hartmut Hackmann <hartmut.hackmann@t-online.de>
Cc: v4l-dvb-maintainer@linuxtv.org, Linux DVB <linux-dvb@linuxtv.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <487D1964.7050607@simon.arlott.org.uk>
References: <4878F314.6090608@simon.arlott.org.uk>
	 <1215919227.2662.3.camel@pc10.localdom.local>
	 <487D1964.7050607@simon.arlott.org.uk>
Content-Type: text/plain
Date: Wed, 16 Jul 2008 01:12:16 +0200
Message-Id: <1216163536.4290.17.camel@pc10.localdom.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

Am Dienstag, den 15.07.2008, 22:40 +0100 schrieb Simon Arlott:
> If saa7134_init is run before v4l2_i2c_drv_init (tuner),
> then saa7134_board_init2 will try to set the tuner type
> for devices that don't exist yet. This moves tuner to
> before all of the device-specific drivers so that it's
> loaded early enough on boot.
> 
> Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
> ---
> Resend... I accidentally left the git-send-email headers in.
> 
> Mailman appears to be easily confused too: 
> http://www.linuxtv.org/pipermail/linux-dvb/2008-July/027205.html

the saa713x maintainer after Gerd is actually Hartmut.

He might not have always the time for it immediately, but should have a
copy of what is going on.

Actually, these problems are within the build system and should not even
come down to a driver maintainer.

The crowd here is used to have some trouble concerning the build, best
was when guys like Trent did watch out for it before we had some impact.

Cheers,
Hermann

>  drivers/media/video/Makefile |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index ecbbfaa..6b0af12 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -18,6 +18,8 @@ ifeq ($(CONFIG_VIDEO_V4L1_COMPAT),y)
>    obj-$(CONFIG_VIDEO_DEV) += v4l1-compat.o
>  endif
>  
> +obj-$(CONFIG_VIDEO_TUNER) += tuner.o
> +
>  obj-$(CONFIG_VIDEO_BT848) += bt8xx/
>  obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
>  obj-$(CONFIG_VIDEO_TVAUDIO) += tvaudio.o
> @@ -84,8 +86,6 @@ obj-$(CONFIG_VIDEO_HEXIUM_GEMINI) += hexium_gemini.o
>  obj-$(CONFIG_VIDEO_DPC) += dpc7146.o
>  obj-$(CONFIG_TUNER_3036) += tuner-3036.o
>  
> -obj-$(CONFIG_VIDEO_TUNER) += tuner.o
> -
>  obj-$(CONFIG_VIDEOBUF_GEN) += videobuf-core.o
>  obj-$(CONFIG_VIDEOBUF_DMA_SG) += videobuf-dma-sg.o
>  obj-$(CONFIG_VIDEOBUF_VMALLOC) += videobuf-vmalloc.o
> -- 
> 1.5.6.2
> 

