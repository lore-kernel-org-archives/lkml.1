Return-Path: <linux-kernel-owner+w=401wt.eu-S932234AbXDJVTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234AbXDJVTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753894AbXDJVTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:19:08 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:48734 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888AbXDJVTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:19:05 -0400
Date: Tue, 10 Apr 2007 23:17:15 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Ben Collins <bcollins@debian.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: linux1394-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/30] Use menuconfig objects - IEEE1394
In-Reply-To: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704102316160.32056@yvahk01.tjqt.qr>
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

Index: linux-2.6.21-rc5/drivers/ieee1394/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/drivers/ieee1394/Kconfig
+++ linux-2.6.21-rc5/drivers/ieee1394/Kconfig
@@ -1,8 +1,6 @@
 # -*- shell-script -*-
 
-menu "IEEE 1394 (FireWire) support"
-
-config IEEE1394
+menuconfig IEEE1394
 	tristate "IEEE 1394 (FireWire) support"
 	depends on PCI || BROKEN
 	select NET
@@ -19,12 +17,12 @@ config IEEE1394
 	  To compile this driver as a module, say M here: the
 	  module will be called ieee1394.
 
+if IEEE1394
+
 comment "Subsystem Options"
-	depends on IEEE1394
 
 config IEEE1394_VERBOSEDEBUG
 	bool "Excessive debugging output"
-	depends on IEEE1394
 	help
 	  If you say Y here, you will get very verbose debugging logs from
 	  the subsystem which includes a dump of the header of every sent
@@ -37,7 +35,6 @@ config IEEE1394_VERBOSEDEBUG
 
 config IEEE1394_EXTRA_CONFIG_ROMS
 	bool "Build in extra config rom entries for certain functionality"
-	depends on IEEE1394
 	help
 	  Some IEEE1394 functionality depends on extra config rom entries
 	  being available in the host adapters CSR. These options will
@@ -45,7 +42,7 @@ config IEEE1394_EXTRA_CONFIG_ROMS
 
 config IEEE1394_CONFIG_ROM_IP1394
 	bool "IP-1394 Entry"
-	depends on IEEE1394_EXTRA_CONFIG_ROMS && IEEE1394
+	depends on IEEE1394_EXTRA_CONFIG_ROMS
 	help
 	  Adds an entry for using IP-over-1394. If you want to use your
 	  IEEE1394 bus as a network for IP systems (including interacting
@@ -53,14 +50,13 @@ config IEEE1394_CONFIG_ROM_IP1394
 	  eth1394 option below.
 
 comment "Device Drivers"
-	depends on IEEE1394
 
 comment "Texas Instruments PCILynx requires I2C"
-	depends on IEEE1394 && I2C=n
+	depends on I2C=n
 
 config IEEE1394_PCILYNX
 	tristate "Texas Instruments PCILynx support"
-	depends on PCI && IEEE1394 && I2C
+	depends on PCI && I2C
 	select I2C_ALGOBIT
 	help
 	  Say Y here if you have an IEEE-1394 controller with the Texas
@@ -72,7 +68,7 @@ config IEEE1394_PCILYNX
 
 config IEEE1394_OHCI1394
 	tristate "OHCI-1394 support"
-	depends on PCI && IEEE1394
+	depends on PCI
 	help
 	  Enable this driver if you have an IEEE 1394 controller based on the
 	  OHCI-1394 specification. The current driver is only tested with OHCI
@@ -84,22 +80,21 @@ config IEEE1394_OHCI1394
 	  module will be called ohci1394.
 
 comment "Protocol Drivers"
-	depends on IEEE1394
 
 config IEEE1394_VIDEO1394
 	tristate "OHCI-1394 Video support"
-	depends on IEEE1394 && IEEE1394_OHCI1394
+	depends on IEEE1394_OHCI1394
 	help
 	  This option enables video device usage for OHCI-1394 cards.  Enable
 	  this option only if you have an IEEE 1394 video device connected to
 	  an OHCI-1394 card.
 
 comment "SBP-2 support (for storage devices) requires SCSI"
-	depends on IEEE1394 && SCSI=n
+	depends on SCSI=n
 
 config IEEE1394_SBP2
 	tristate "SBP-2 support (Harddisks etc.)"
-	depends on IEEE1394 && SCSI
+	depends on SCSI
 	help
 	  This option enables you to use SBP-2 devices connected to an IEEE
 	  1394 bus.  SBP-2 devices include storage devices like harddisks and
@@ -110,7 +105,7 @@ config IEEE1394_SBP2
 
 config IEEE1394_SBP2_PHYS_DMA
 	bool "Enable replacement for physical DMA in SBP2"
-	depends on IEEE1394 && IEEE1394_SBP2 && EXPERIMENTAL && (X86_32 || PPC_32)
+	depends on IEEE1394_SBP2 && EXPERIMENTAL && (X86_32 || PPC_32)
 	help
 	  This builds sbp2 for use with non-OHCI host adapters which do not
 	  support physical DMA or for when ohci1394 is run with phys_dma=0.
@@ -123,7 +118,7 @@ config IEEE1394_SBP2_PHYS_DMA
 
 config IEEE1394_ETH1394
 	tristate "Ethernet over 1394"
-	depends on IEEE1394 && EXPERIMENTAL && INET
+	depends on EXPERIMENTAL && INET
 	select IEEE1394_CONFIG_ROM_IP1394
 	select IEEE1394_EXTRA_CONFIG_ROMS
 	help
@@ -136,7 +131,7 @@ config IEEE1394_ETH1394
 
 config IEEE1394_DV1394
 	tristate "OHCI-DV I/O support (deprecated)"
-	depends on IEEE1394 && IEEE1394_OHCI1394
+	depends on IEEE1394_OHCI1394
 	help
 	  The dv1394 driver will be removed from Linux in a future release.
 	  Its functionality is now provided by raw1394 together with libraries
@@ -144,7 +139,6 @@ config IEEE1394_DV1394
 
 config IEEE1394_RAWIO
 	tristate "Raw IEEE1394 I/O support"
-	depends on IEEE1394
 	help
 	  Say Y here if you want support for the raw device. This is generally
 	  a good idea, so you should say Y here. The raw device enables
@@ -154,4 +148,4 @@ config IEEE1394_RAWIO
 	  To compile this driver as a module, say M here: the
 	  module will be called raw1394.
 
-endmenu
+endif # IEEE1394
#<EOF>
