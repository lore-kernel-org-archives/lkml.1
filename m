Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbXFVNYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbXFVNYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 09:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbXFVNYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 09:24:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42463 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbXFVNYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 09:24:13 -0400
Subject: Kconfig troubles when using menuconfig - Was: [patch]Re:
	[linux-usb-devel] linux-2.6.22-rc5-gf1518a0 build #300 failed in
	zc0301_core.c
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Oliver Neukum <oneukum@suse.de>, linux-usb-devel@lists.sourceforge.net,
       video4linux-list@redhat.com,
       Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       luca.risolia@studio.unibo.it, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200706211350.14526.oneukum@suse.de>
References: <200706211117.55908.toralf.foerster@gmx.de>
	 <200706211231.53898.luca.risolia@studio.unibo.it>
	 <200706211326.45031.toralf.foerster@gmx.de>
	 <200706211350.14526.oneukum@suse.de>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 22 Jun 2007 10:22:46 -0300
Message-Id: <1182518566.14289.20.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 8bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roman,

Several instabilities on Kconfig started to happen after replacing
Kconfig menus to use menuconfig, as this one, reported by Oliver:

Em Qui, 2007-06-21 às 13:50 +0200, Oliver Neukum escreveu:
> Am Donnerstag, 21. Juni 2007 schrieb Toralf Förster:
> > Right, but IMHO this issue is typical for a problem with the Kconfig definitions of this module.
> > 
> > I'll set USB devs as Cc: therefore.
> 
> The Kconfig there is incomplete.
> Mauro, please apply.
> 
> 	Regards
> 		Oliver
> Signed-off-by: Oliver Neukum <oneukum@suse.de>
>
> --- a/drivers/media/video/zc0301/Kconfig        2007-06-21 13:44:14.000000000 +0200
> +++ b/drivers/media/video/zc0301/Kconfig        2007-06-21 13:44:33.000000000 +0200
> @@ -1,6 +1,6 @@
>  config USB_ZC0301
>         tristate "USB ZC0301[P] Image Processor and Control Chip support"
> -       depends on VIDEO_V4L1
> +       depends on VIDEO_V4L1 && USB
>         ---help---
>           Say Y here if you want support for cameras based on the ZC0301 or
>           ZC0301P Image Processors and Control Chips.
> 

In this specific case, all V4L USB drivers depends on V4L_USB_DRIVERS,
that depends, in turn, on USB. So, if USB is not selected,
V4L_USB_DRIVERS should be unselected, unselecting zc0301.

Unfortunately, the Kernel building system is not properly handling it.

This is the (snipped) media/video/Kconfig:

menuconfig V4L_USB_DRIVERS
        bool "V4L USB devices"
        depends on USB
        default y

if V4L_USB_DRIVERS

source "drivers/media/video/pvrusb2/Kconfig"

<snip/>

source "drivers/media/video/zc0301/Kconfig"

<snip/>

endif # V4L_USB_DRIVERS

-- 
Cheers,
Mauro

