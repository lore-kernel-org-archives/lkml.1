Return-Path: <linux-kernel-owner+w=401wt.eu-S1756222AbYGNCxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222AbYGNCxf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 22:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbYGNCx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 22:53:27 -0400
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:51420 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754550AbYGNCx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 22:53:26 -0400
Subject: Re: [PATCH] V4L: Link tuner before saa7134
From: hermann pitton <hermann-pitton@arcor.de>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: v4l-dvb-maintainer@linuxtv.org, Linux DVB <linux-dvb@linuxtv.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <487A4A3D.9040809@simon.arlott.org.uk>
References: <4878F314.6090608@simon.arlott.org.uk>
	 <1215919227.2662.3.camel@pc10.localdom.local>
	 <487A4A3D.9040809@simon.arlott.org.uk>
Content-Type: text/plain
Date: Mon, 14 Jul 2008 04:48:30 +0200
Message-Id: <1216003710.2649.24.camel@pc10.localdom.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am Sonntag, den 13.07.2008, 19:32 +0100 schrieb Simon Arlott:
> >From cde790c56ffe76f3d0bf6f38d89f4e671a5218c6 Mon Sep 17 00:00:00 2001
> From: Simon Arlott <simon@redrum.invalid>
> Date: Sun, 13 Jul 2008 19:24:53 +0100
> Subject: [PATCH] V4L: Link tuner before saa7134
> 
> If saa7134_init is run before v4l2_i2c_drv_init (tuner),
> then saa7134_board_init2 will try to set the tuner type
> for devices that don't exist yet. This moves tuner to
> before all of the device-specific drivers so that it's
> loaded early enough on boot.
> 
> Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
> ---
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

Thanks a lot for working on it!

I must admit that I have not tested it yet.

Remaining issues are.

#1 users can't set the tuner type anymore,
   but the few cases of tuner detection from eeprom we have should
   work again for that price.

#2 We still don't have any sufficient HDTV support in the kernel ;)

#0 On 2.6.25, without dedicated TV subnorm selection possible anymore
   and known auto detection flaws, fixed now, folks should have 
   complained about it.

   Interestingly nothing like that happened.
 
   What could that mean?

Cheers,
Hermann


