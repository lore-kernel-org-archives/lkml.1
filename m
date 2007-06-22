Return-Path: <linux-kernel-owner+w=401wt.eu-S1756358AbXFVNp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358AbXFVNp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 09:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbXFVNpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 09:45:16 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:64712 "EHLO
	outbound2-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751078AbXFVNpN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 09:45:13 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Fri, 22 Jun 2007 15:46:05 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
cc: "Roman Zippel" <zippel@linux-m68k.org>, "Oliver Neukum" <oneukum@suse.de>,
       linux-usb-devel@lists.sourceforge.net, video4linux-list@redhat.com,
       "Toralf =?iso-8859-1?Q?F=F6rster?=" <toralf.foerster@gmx.de>,
       luca.risolia@studio.unibo.it,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: Kconfig troubles when using menuconfig - Was: [patch]Re:
 [linux-usb-devel] linux-2.6.22-rc5-gf1518a0 build #300 failed in
 zc0301_core.c
Message-ID: <20070622134605.GN5193@alberich.amd.com>
References: <200706211117.55908.toralf.foerster@gmx.de>
 <200706211231.53898.luca.risolia@studio.unibo.it>
 <200706211326.45031.toralf.foerster@gmx.de>
 <200706211350.14526.oneukum@suse.de>
 <1182518566.14289.20.camel@gaivota>
MIME-Version: 1.0
In-Reply-To: <1182518566.14289.20.camel@gaivota>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 22 Jun 2007 13:44:56.0633 (UTC)
 FILETIME=[8507D290:01C7B4D3]
X-WSS-ID: 6A650DD11S41139639-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2007 at 10:22:46AM -0300, Mauro Carvalho Chehab wrote:
> Hi Roman,
> 
> Several instabilities on Kconfig started to happen after replacing
> Kconfig menus to use menuconfig, as this one, reported by Oliver:
> 
> Em Qui, 2007-06-21 às 13:50 +0200, Oliver Neukum escreveu:
> > Am Donnerstag, 21. Juni 2007 schrieb Toralf Förster:
> > > Right, but IMHO this issue is typical for a problem with the Kconfig definitions of this module.
> > > 
> > > I'll set USB devs as Cc: therefore.
> > 
> > The Kconfig there is incomplete.
> > Mauro, please apply.
> > 
> > 	Regards
> > 		Oliver
> > Signed-off-by: Oliver Neukum <oneukum@suse.de>
> >
> > --- a/drivers/media/video/zc0301/Kconfig        2007-06-21 13:44:14.000000000 +0200
> > +++ b/drivers/media/video/zc0301/Kconfig        2007-06-21 13:44:33.000000000 +0200
> > @@ -1,6 +1,6 @@
> >  config USB_ZC0301
> >         tristate "USB ZC0301[P] Image Processor and Control Chip support"
> > -       depends on VIDEO_V4L1
> > +       depends on VIDEO_V4L1 && USB
> >         ---help---
> >           Say Y here if you want support for cameras based on the ZC0301 or
> >           ZC0301P Image Processors and Control Chips.
> > 
> 
> In this specific case, all V4L USB drivers depends on V4L_USB_DRIVERS,
> that depends, in turn, on USB. So, if USB is not selected,
> V4L_USB_DRIVERS should be unselected, unselecting zc0301.
> 
> Unfortunately, the Kernel building system is not properly handling it.
> 
> This is the (snipped) media/video/Kconfig:
> 
> menuconfig V4L_USB_DRIVERS
>         bool "V4L USB devices"
>         depends on USB
>         default y
> 
> if V4L_USB_DRIVERS
> 
> source "drivers/media/video/pvrusb2/Kconfig"
> 
> <snip/>
> 
> source "drivers/media/video/zc0301/Kconfig"
> 
> <snip/>
> 
> endif # V4L_USB_DRIVERS
> 
> -- 
> Cheers,
> Mauro
> 


Hi,

I am not sure whether it is related or not
But if you select USB as module but build your v4l_usb driver
into the kernel you also get compile errors.
Attached is a patch which will prevent this by changing the menuconfig
from bool to tristate.


Regards,

Andreas

--
Correct Kconfig to avoid compile errors like
    
 drivers/built-in.o: In function `sn9c102_usb_disconnect':
 sn9c102_core.c:(.text+0x8d840): undefined reference to `usb_get_dev'
    
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 4cca551..4754d98 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -687,7 +687,7 @@ config VIDEO_CAFE_CCIC
 #
 
 menuconfig V4L_USB_DRIVERS
-	bool "V4L USB devices"
+	tristate "V4L USB devices"
 	depends on USB
 	default y
 



