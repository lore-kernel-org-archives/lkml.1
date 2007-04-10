Return-Path: <linux-kernel-owner+w=401wt.eu-S1752820AbXDJVgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752820AbXDJVgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbXDJVgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:36:36 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:55273 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752820AbXDJVgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:36:35 -0400
Date: Tue, 10 Apr 2007 23:35:00 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Mike Phillips <mikep@linuxtr.net>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, linux-tr@linuxtr.net
Subject: [PATCH 22/30] Use menuconfig objects - toeknring
In-Reply-To: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704102333500.32056@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Use menuconfigs instead of menus, so the whole menu can be disabled at        
once instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

Index: linux-2.6.21-rc5/drivers/net/tokenring/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/drivers/net/tokenring/Kconfig
+++ linux-2.6.21-rc5/drivers/net/tokenring/Kconfig
@@ -2,12 +2,10 @@
 # Token Ring driver configuration
 #
 
-menu "Token Ring devices"
-	depends on NETDEVICES && !UML
-
 # So far, we only have PCI, ISA, and MCA token ring devices
-config TR
+menuconfig TR
 	bool "Token Ring driver support"
+	depends on NETDEVICES && !UML
 	depends on (PCI || ISA || MCA || CCW)
 	select LLC
 	help
@@ -20,9 +18,11 @@ config TR
 	  from <http://www.tldp.org/docs.html#howto>. Most people can
 	  say N here.
 
+if TR
+
 config IBMTR
 	tristate "IBM Tropic chipset based adapter support"
-	depends on TR && (ISA || MCA)
+	depends on ISA || MCA
 	---help---
 	  This is support for all IBM Token Ring cards that don't use DMA. If
 	  you have such a beast, say Y and read the Token-Ring mini-HOWTO,
@@ -36,7 +36,7 @@ config IBMTR
 
 config IBMOL
 	tristate "IBM Olympic chipset PCI adapter support"
-	depends on TR && PCI
+	depends on PCI
 	---help---
 	  This is support for all non-Lanstreamer IBM PCI Token Ring Cards.
 	  Specifically this is all IBM PCI, PCI Wake On Lan, PCI II, PCI II
@@ -54,7 +54,7 @@ config IBMOL
 
 config IBMLS
 	tristate "IBM Lanstreamer chipset PCI adapter support"
-	depends on TR && PCI && !64BIT
+	depends on PCI && !64BIT
 	help
 	  This is support for IBM Lanstreamer PCI Token Ring Cards.
 
@@ -66,7 +66,7 @@ config IBMLS
 
 config 3C359
 	tristate "3Com 3C359 Token Link Velocity XL adapter support"
-	depends on TR && PCI
+	depends on PCI
 	---help---
 	  This is support for the 3Com PCI Velocity XL cards, specifically
 	  the 3Com 3C359, please note this is not for the 3C339 cards, you
@@ -84,7 +84,7 @@ config 3C359
 
 config TMS380TR
 	tristate "Generic TMS380 Token Ring ISA/PCI adapter support"
-	depends on TR && (PCI || ISA && ISA_DMA_API || MCA)
+	depends on PCI || ISA && ISA_DMA_API || MCA
 	select FW_LOADER
 	---help---
 	  This driver provides generic support for token ring adapters
@@ -108,7 +108,7 @@ config TMS380TR
 
 config TMSPCI
 	tristate "Generic TMS380 PCI support"
-	depends on TR && TMS380TR && PCI
+	depends on TMS380TR && PCI
 	---help---
 	  This tms380 module supports generic TMS380-based PCI cards.
 
@@ -123,7 +123,7 @@ config TMSPCI
 
 config SKISA
 	tristate "SysKonnect TR4/16 ISA support"
-	depends on TR && TMS380TR && ISA
+	depends on TMS380TR && ISA
 	help
 	  This tms380 module supports SysKonnect TR4/16 ISA cards.
 
@@ -135,7 +135,7 @@ config SKISA
 
 config PROTEON
 	tristate "Proteon ISA support"
-	depends on TR && TMS380TR && ISA
+	depends on TMS380TR && ISA
 	help
 	  This tms380 module supports Proteon ISA cards.
 
@@ -148,7 +148,7 @@ config PROTEON
 
 config ABYSS
 	tristate "Madge Smart 16/4 PCI Mk2 support"
-	depends on TR && TMS380TR && PCI
+	depends on TMS380TR && PCI
 	help
 	  This tms380 module supports the Madge Smart 16/4 PCI Mk2
 	  cards (51-02).
@@ -158,7 +158,7 @@ config ABYSS
 
 config MADGEMC
 	tristate "Madge Smart 16/4 Ringnode MicroChannel"
-	depends on TR && TMS380TR && MCA
+	depends on TMS380TR && MCA
 	help
 	  This tms380 module supports the Madge Smart 16/4 MC16 and MC32
 	  MicroChannel adapters.
@@ -168,7 +168,7 @@ config MADGEMC
 
 config SMCTR
 	tristate "SMC ISA/MCA adapter support"
-	depends on TR && (ISA || MCA_LEGACY) && (BROKEN || !64BIT)
+	depends on (ISA || MCA_LEGACY) && (BROKEN || !64BIT)
 	---help---
 	  This is support for the ISA and MCA SMC Token Ring cards,
 	  specifically SMC TokenCard Elite (8115T) and SMC TokenCard Elite/A
@@ -182,5 +182,4 @@ config SMCTR
 	  To compile this driver as a module, choose M here: the module will be
 	  called smctr.
 
-endmenu
-
+endif # TR
#<EOF>
