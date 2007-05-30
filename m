Return-Path: <linux-kernel-owner+w=401wt.eu-S1758721AbXE3Tnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721AbXE3Tnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 15:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756255AbXE3TnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 15:43:17 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:56185 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755761AbXE3TnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 15:43:15 -0400
Date: Wed, 30 May 2007 21:39:26 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: kkeil@suse.de, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       hjlipp@web.de, tilman@imap.cc, gigaset307x-common@lists.sourceforge.net
Subject: [PATCH 03/06] Use menuconfig objects 4 - ISDN part 3/6
 (CONFIG_ISDN_DRV_GIGASET)
In-Reply-To: <200705301906.l4UJ62hC002388@shell0.pdx.osdl.net>
Message-ID: <Pine.LNX.4.61.0705302138340.11140@yvahk01.tjqt.qr>
References: <200705301906.l4UJ62hC002388@shell0.pdx.osdl.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Transform Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to enter
the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 drivers/isdn/gigaset/Kconfig |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

Index: linux-2.6.22-rc3-git1/drivers/isdn/gigaset/Kconfig
===================================================================
--- linux-2.6.22-rc3-git1.orig/drivers/isdn/gigaset/Kconfig
+++ linux-2.6.22-rc3-git1/drivers/isdn/gigaset/Kconfig
@@ -1,6 +1,4 @@
-menu "Siemens Gigaset"
-
-config ISDN_DRV_GIGASET
+menuconfig ISDN_DRV_GIGASET
 	tristate "Siemens Gigaset support (isdn)"
 	select CRC_CCITT
 	select BITREVERSE
@@ -13,11 +11,11 @@ config ISDN_DRV_GIGASET
 	  one of the connection specific parts that follow.
 	  This will build a module called "gigaset".
 
-if ISDN_DRV_GIGASET!=n
+if ISDN_DRV_GIGASET
 
 config GIGASET_BASE
 	tristate "Gigaset base station support"
-	depends on ISDN_DRV_GIGASET && USB
+	depends on USB
 	help
 	  Say M here if you want to use the USB interface of the Gigaset
 	  base for connection to your system.
@@ -25,7 +23,7 @@ config GIGASET_BASE
 
 config GIGASET_M105
 	tristate "Gigaset M105 support"
-	depends on ISDN_DRV_GIGASET && USB
+	depends on USB
 	help
 	  Say M here if you want to connect to the Gigaset base via DECT
 	  using a Gigaset M105 (Sinus 45 Data 2) USB DECT device.
@@ -33,7 +31,6 @@ config GIGASET_M105
 
 config GIGASET_M101
 	tristate "Gigaset M101 support"
-	depends on ISDN_DRV_GIGASET
 	help
 	  Say M here if you want to connect to the Gigaset base via DECT
 	  using a Gigaset M101 (Sinus 45 Data 1) RS232 DECT device.
@@ -53,6 +50,4 @@ config GIGASET_UNDOCREQ
 	  features like configuration mode of M105, say yes. If you
 	  care about your device, say no.
 
-endif
-
-endmenu
+endif # ISDN_DRV_GIGASET

