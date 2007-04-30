Return-Path: <linux-kernel-owner+w=401wt.eu-S1161540AbXD3Llh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161540AbXD3Llh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161662AbXD3Llg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:41:36 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:46560 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161657AbXD3Lld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:41:33 -0400
Date: Mon, 30 Apr 2007 13:40:44 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 18/36] Use menuconfig objects II - MMC
In-Reply-To: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704301340180.29151@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Change Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to
enter the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 drivers/mmc/Kconfig      |   10 +++++-----
 drivers/mmc/card/Kconfig |    3 +--
 drivers/mmc/host/Kconfig |   19 +++++++++----------
 3 files changed, 15 insertions(+), 17 deletions(-)

--- linux-2.6.21-mm_20070428.orig/drivers/mmc/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/mmc/Kconfig
@@ -2,10 +2,8 @@
 # MMC subsystem configuration
 #
 
-menu "MMC/SD Card support"
-
-config MMC
-	tristate "MMC support"
+menuconfig MMC
+	tristate "MMC/SD card support"
 	help
 	  MMC is the "multi-media card" bus protocol.
 
@@ -19,8 +17,10 @@ config MMC_DEBUG
 	  This is an option for use by developers; most people should
 	  say N here.  This enables MMC core and driver debugging.
 
+if MMC
+
 source "drivers/mmc/card/Kconfig"
 
 source "drivers/mmc/host/Kconfig"
 
-endmenu
+endif # MMC
--- linux-2.6.21-mm_20070428.orig/drivers/mmc/card/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/mmc/card/Kconfig
@@ -3,11 +3,10 @@
 #
 
 comment "MMC/SD Card Drivers"
-	depends MMC
 
 config MMC_BLOCK
 	tristate "MMC block device driver"
-	depends on MMC && BLOCK
+	depends on BLOCK
 	default y
 	help
 	  Say Y here to enable the MMC block device driver support.
--- linux-2.6.21-mm_20070428.orig/drivers/mmc/host/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/mmc/host/Kconfig
@@ -3,11 +3,10 @@
 #
 
 comment "MMC/SD Host Controller Drivers"
-	depends on MMC
 
 config MMC_ARMMMCI
 	tristate "ARM AMBA Multimedia Card Interface support"
-	depends on ARM_AMBA && MMC
+	depends on ARM_AMBA
 	help
 	  This selects the ARM(R) AMBA(R) PrimeCell Multimedia Card
 	  Interface (PL180 and PL181) support.  If you have an ARM(R)
@@ -17,7 +16,7 @@ config MMC_ARMMMCI
 
 config MMC_PXA
 	tristate "Intel PXA25x/26x/27x Multimedia Card Interface support"
-	depends on ARCH_PXA && MMC
+	depends on ARCH_PXA
 	help
 	  This selects the Intel(R) PXA(R) Multimedia card Interface.
 	  If you have a PXA(R) platform with a Multimedia Card slot,
@@ -27,7 +26,7 @@ config MMC_PXA
 
 config MMC_SDHCI
 	tristate "Secure Digital Host Controller Interface support  (EXPERIMENTAL)"
-	depends on PCI && MMC && EXPERIMENTAL
+	depends on PCI && EXPERIMENTAL
 	help
 	  This select the generic Secure Digital Host Controller Interface.
 	  It is used by manufacturers such as Texas Instruments(R), Ricoh(R)
@@ -38,7 +37,7 @@ config MMC_SDHCI
 
 config MMC_OMAP
 	tristate "TI OMAP Multimedia Card Interface support"
-	depends on ARCH_OMAP && MMC
+	depends on ARCH_OMAP
 	select TPS65010 if MACH_OMAP_H2
 	help
 	  This selects the TI OMAP Multimedia card Interface.
@@ -49,7 +48,7 @@ config MMC_OMAP
 
 config MMC_WBSD
 	tristate "Winbond W83L51xD SD/MMC Card Interface support"
-	depends on MMC && ISA_DMA_API
+	depends on ISA_DMA_API
 	help
 	  This selects the Winbond(R) W83L51xD Secure digital and
           Multimedia card Interface.
@@ -60,7 +59,7 @@ config MMC_WBSD
 
 config MMC_AU1X
 	tristate "Alchemy AU1XX0 MMC Card Interface support"
-	depends on MMC && SOC_AU1200
+	depends on SOC_AU1200
 	help
 	  This selects the AMD Alchemy(R) Multimedia card interface.
 	  If you have a Alchemy platform with a MMC slot, say Y or M here.
@@ -69,7 +68,7 @@ config MMC_AU1X
 
 config MMC_AT91
 	tristate "AT91 SD/MMC Card Interface support"
-	depends on ARCH_AT91 && MMC
+	depends on ARCH_AT91
 	help
 	  This selects the AT91 MCI controller.
 
@@ -77,7 +76,7 @@ config MMC_AT91
 
 config MMC_IMX
 	tristate "Motorola i.MX Multimedia Card Interface support"
-	depends on ARCH_IMX && MMC
+	depends on ARCH_IMX
 	help
 	  This selects the Motorola i.MX Multimedia card Interface.
 	  If you have a i.MX platform with a Multimedia Card slot,
@@ -87,7 +86,7 @@ config MMC_IMX
 
 config MMC_TIFM_SD
 	tristate "TI Flash Media MMC/SD Interface support  (EXPERIMENTAL)"
-	depends on MMC && EXPERIMENTAL && PCI
+	depends on EXPERIMENTAL && PCI
 	select TIFM_CORE
 	help
 	  Say Y here if you want to be able to access MMC/SD cards with
