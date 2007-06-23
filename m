Return-Path: <linux-kernel-owner+w=401wt.eu-S1754923AbXFWW14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbXFWW14 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 18:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbXFWW1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 18:27:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33786 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbXFWW1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 18:27:48 -0400
Subject: Re: [patch] 2.6.22-rc Kconfig troubles when using menuconfig
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux and Kernel Video <video4linux-list@redhat.com>,
       Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       Luca Risolia <luca.risolia@studio.unibo.it>,
       LKML <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Oliver Neukum <oneukum@suse.de>, Trent Piepho <xyzzy@speakeasy.org>
In-Reply-To: <Pine.LNX.4.64.0706230915540.26568@fbirervta.pbzchgretzou.qr>
References: <200706211117.55908.toralf.foerster@gmx.de>
	 <200706211231.53898.luca.risolia@studio.unibo.it>
	 <200706211326.45031.toralf.foerster@gmx.de>
	 <200706211350.14526.oneukum@suse.de> <1182518566.14289.20.camel@gaivota>
	 <Pine.LNX.4.58.0706221259500.4914@shell4.speakeasy.net>
	 <Pine.LNX.4.64.0706230915540.26568@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=utf-8
Date: Sat, 23 Jun 2007 19:26:26 -0300
Message-Id: <1182637586.10174.36.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,



Your patch seems OK to me, providing that we also add the Andreas patch:

---

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
 

Em Sáb, 2007-06-23 às 09:20 +0200, Jan Engelhardt escreveu:
> Anyone with strong objections to this patch? (Hopefully) fixes the 
> kconfig issue for now.
> 
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>
	(for both Andreas and your patch)

-- 
Cheers,
Mauro

