Return-Path: <linux-kernel-owner+w=401wt.eu-S1758676AbXE3Tlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676AbXE3Tlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 15:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758577AbXE3Tlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 15:41:32 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:55492 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757641AbXE3Tla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 15:41:30 -0400
Date: Wed, 30 May 2007 21:40:42 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: kkeil@suse.de, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/06] Use menuconfig objects 4 - ISDN part 5/6 (CONFIG_CAPI_AVM)
In-Reply-To: <200705301906.l4UJ62hC002388@shell0.pdx.osdl.net>
Message-ID: <Pine.LNX.4.61.0705302140210.11140@yvahk01.tjqt.qr>
References: <200705301906.l4UJ62hC002388@shell0.pdx.osdl.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	0.0 UPPERCASE_25_50        message body is 25-50% uppercase
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Transform Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to enter
the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 drivers/isdn/hardware/avm/Kconfig |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

Index: linux-2.6.22-rc3-git1/drivers/isdn/hardware/avm/Kconfig
===================================================================
--- linux-2.6.22-rc3-git1.orig/drivers/isdn/hardware/avm/Kconfig
+++ linux-2.6.22-rc3-git1/drivers/isdn/hardware/avm/Kconfig
@@ -2,22 +2,22 @@
 # ISDN AVM drivers
 #
 
-menu "Active AVM cards"
-
-config CAPI_AVM
-	bool "Support AVM cards"
+menuconfig CAPI_AVM
+	bool "Active AVM cards"
 	help
 	  Enable support for AVM active ISDN cards.
 
+if CAPI_AVM
+
 config ISDN_DRV_AVMB1_B1ISA
 	tristate "AVM B1 ISA support"
-	depends on CAPI_AVM && ISA
+	depends on ISA
 	help
 	  Enable support for the ISA version of the AVM B1 card.
 
 config ISDN_DRV_AVMB1_B1PCI
 	tristate "AVM B1 PCI support"
-	depends on CAPI_AVM && PCI
+	depends on PCI
 	help
 	  Enable support for the PCI version of the AVM B1 card.
 
@@ -29,14 +29,13 @@ config ISDN_DRV_AVMB1_B1PCIV4
 
 config ISDN_DRV_AVMB1_T1ISA
 	tristate "AVM T1/T1-B ISA support"
-	depends on CAPI_AVM && ISA
+	depends on ISA
 	help
 	  Enable support for the AVM T1 T1B card.
 	  Note: This is a PRI card and handle 30 B-channels.
 
 config ISDN_DRV_AVMB1_B1PCMCIA
 	tristate "AVM B1/M1/M2 PCMCIA support"
-	depends on CAPI_AVM
 	help
 	  Enable support for the PCMCIA version of the AVM B1 card.
 
@@ -49,17 +48,16 @@ config ISDN_DRV_AVMB1_AVM_CS
 
 config ISDN_DRV_AVMB1_T1PCI
 	tristate "AVM T1/T1-B PCI support"
-	depends on CAPI_AVM && PCI
+	depends on PCI
 	help
 	  Enable support for the AVM T1 T1B card.
 	  Note: This is a PRI card and handle 30 B-channels.
 
 config ISDN_DRV_AVMB1_C4
 	tristate "AVM C4/C2 support"
-	depends on CAPI_AVM && PCI
+	depends on PCI
 	help
 	  Enable support for the AVM C4/C2 PCI cards.
 	  These cards handle 4/2 BRI ISDN lines (8/4 channels).
 
-endmenu
-
+endif # CAPI_AVM
