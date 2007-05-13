Return-Path: <linux-kernel-owner+w=401wt.eu-S1757421AbXEMArW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421AbXEMArW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 20:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756451AbXEMArP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 20:47:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51943 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbXEMArP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 20:47:15 -0400
Subject: Re: default y idiocy
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.61.0705122212180.9570@yvahk01.tjqt.qr>
References: <20070512182343.GO4629@kernel.dk>
	 <Pine.LNX.4.61.0705122121340.9570@yvahk01.tjqt.qr>
	 <20070512192726.GQ4629@kernel.dk>
	 <Pine.LNX.4.61.0705122135510.9570@yvahk01.tjqt.qr>
	 <20070512194510.GR4629@kernel.dk>
	 <Pine.LNX.4.61.0705122212180.9570@yvahk01.tjqt.qr>
Content-Type: text/plain
Date: Sat, 12 May 2007 21:46:58 -0300
Message-Id: <1179017218.4022.41.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

All the submenus bellow are dependent of VIDEO_DEV (Video4Linux core).
If someone wants V4L, it is very likely that he will select a radio or a
video adapter, since the subsystem is useless without the drivers (*).

(*) Except if you are using an out-of-tree driver.

> diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
> index a6ac82a..0486780 100644
> --- a/drivers/media/radio/Kconfig
> +++ b/drivers/media/radio/Kconfig
> @@ -5,7 +5,6 @@
>  menuconfig RADIO_ADAPTERS
>  	bool "Radio Adapters"
>  	depends on VIDEO_DEV
> -	default y
>  	---help---
>  	  Say Y here to enable selecting AM/FM radio adapters.
>  
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 5cb3f54..ca33d55 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -5,7 +5,6 @@
>  menuconfig VIDEO_CAPTURE_DRIVERS
>  	bool "Video capture adapters"
>  	depends on VIDEO_DEV
> -	default y
>  	---help---
>  	  Say Y here to enable selecting the video adapters for
>  	  webcams, analog TV, and hybrid analog/digital TV.
> @@ -689,7 +688,6 @@ config VIDEO_CAFE_CCIC
>  menuconfig V4L_USB_DRIVERS
>  	bool "V4L USB devices"
>  	depends on USB
> -	default y

It should be noticed that selecting the "Drivers" Kconfig items won't
produce any code. No drivers are marked with default.

Those items are just used to better organize Multimedia menu. The result
of having 'y' is just to have the submenus open by default. For me, it
makes sense to keep default y, especially if we consider the arguments
at:

http://lkml.org/lkml/2007/5/8/76

This is also the same case for DVB drivers submenu:

menuconfig DVB_CAPTURE_DRIVERS
        bool "DVB/ATSC adapters"
        depends on DVB_CORE
        default y
        ---help---
          Say Y to select Digital TV adapters

Just to keep the entire menu coherent, "default y" were added for DAB:

config DAB
        boolean "DAB adapters"
        default y
        ---help---
          Allow selecting support for for Digital Audio Broadcasting (DAB)
          Receiver adapters.

if DAB
config USB_DABUSB
        tristate "DABUSB driver"
        depends on USB
        ---help---
          A Digital Audio Broadcasting (DAB) Receiver for USB and Linux
          brought to you by the DAB-Team
          <http://wwwbode.cs.tum.edu/Par/arch/dab/>.  This driver can be taken
          as an example for URB-based bulk, control, and isochronous
          transactions. URB's are explained in
          <Documentation/usb/URB.txt>.

          To compile this driver as a module, choose M here: the
          module will be called dabusb.
endif # DAB

It is fine for me to remove "default y" for DAB, although i would prefer
to have it marked as 'y' just for coherence.
 
Cheers,
Mauro

