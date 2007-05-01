Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278AbXEAP67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbXEAP67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 11:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbXEAP67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 11:58:59 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:50661 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278AbXEAP65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 11:58:57 -0400
Message-ID: <4637636C.50704@drzeus.cx>
Date: Tue, 01 May 2007 17:57:32 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070414)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_hera.drzeus.cx-9895-1178035136-0001-2"
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 18/36] Use menuconfig objects II - MMC
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr> <Pine.LNX.4.61.0704301340180.29151@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0704301340180.29151@yvahk01.tjqt.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-9895-1178035136-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Jan Engelhardt wrote:
> Change Kconfig objects from "menu, config" into "menuconfig" so
> that the user can disable the whole feature without having to
> enter the menu first.
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
> 

As promised, an updated patch.


-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

--=_hera.drzeus.cx-9895-1178035136-0001-2
Content-Type: text/x-patch; name="menuconfig.patch"; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="menuconfig.patch"

diff --git a/drivers/mmc/Kconfig b/drivers/mmc/Kconfig
index 6c97491..45b7d53 100644
--- a/drivers/mmc/Kconfig
+++ b/drivers/mmc/Kconfig
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
 
@@ -19,10 +17,12 @@ config MMC_DEBUG
 	  This is an option for use by developers; most people should
 	  say N here.  This enables MMC core and driver debugging.
 
+if MMC
+
 source "drivers/mmc/core/Kconfig"
 
 source "drivers/mmc/card/Kconfig"
 
 source "drivers/mmc/host/Kconfig"
 
-endmenu
+endif # MMC
diff --git a/drivers/mmc/card/Kconfig b/drivers/mmc/card/Kconfig
index 01a9fd3..9320a8c 100644
--- a/drivers/mmc/card/Kconfig
+++ b/drivers/mmc/card/Kconfig
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
diff --git a/drivers/mmc/core/Kconfig b/drivers/mmc/core/Kconfig
index 94222b9..ab37a6d 100644
--- a/drivers/mmc/core/Kconfig
+++ b/drivers/mmc/core/Kconfig
@@ -4,7 +4,6 @@
 
 config MMC_UNSAFE_RESUME
 	bool "Allow unsafe resume (DANGEROUS)"
-	depends on MMC != n
 	help
 	  If you say Y here, the MMC layer will assume that all cards
 	  stayed in their respective slots during the suspend. The
diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index ed4deab..e23082f 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
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

--=_hera.drzeus.cx-9895-1178035136-0001-2--
