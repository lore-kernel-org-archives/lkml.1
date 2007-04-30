Return-Path: <linux-kernel-owner+w=401wt.eu-S1031525AbXD3L5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031525AbXD3L5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031548AbXD3L5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:57:41 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:33279 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031543AbXD3L5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:57:36 -0400
Date: Mon, 30 Apr 2007 13:56:42 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Wim Van Sebroeck <wim@iguana.be>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 34/36] Use menuconfig objects II - watchdog
In-Reply-To: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704301356180.29151@yvahk01.tjqt.qr>
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
 drivers/char/watchdog/Kconfig |  123 ++++++++++++++++++++----------------------
 1 file changed, 60 insertions(+), 63 deletions(-)

--- linux-2.6.21-mm_20070428.orig/drivers/char/watchdog/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/char/watchdog/Kconfig
@@ -2,9 +2,7 @@
 # Watchdog device configuration
 #
 
-menu "Watchdog Cards"
-
-config WATCHDOG
+menuconfig WATCHDOG
 	bool "Watchdog Timer Support"
 	---help---
 	  If you say Y here (and to one of the following options) and create a
@@ -28,9 +26,10 @@ config WATCHDOG
 
 	  If unsure, say N.
 
+if WATCHDOG
+
 config WATCHDOG_NOWAYOUT
 	bool "Disable watchdog shutdown on close"
-	depends on WATCHDOG
 	help
 	  The default watchdog behaviour (which you get if you say N here) is
 	  to stop the timer if the process managing it closes the file
@@ -43,13 +42,11 @@ config WATCHDOG_NOWAYOUT
 #
 
 comment "Watchdog Device Drivers"
-	depends on WATCHDOG
 
 # Architecture Independent
 
 config SOFT_WATCHDOG
 	tristate "Software watchdog"
-	depends on WATCHDOG
 	help
 	  A software monitoring watchdog. This will fail to reboot your system
 	  from some situations that the hardware watchdog will recover
@@ -62,14 +59,14 @@ config SOFT_WATCHDOG
 
 config AT91RM9200_WATCHDOG
 	tristate "AT91RM9200 watchdog"
-	depends on WATCHDOG && ARCH_AT91RM9200
+	depends on ARCH_AT91RM9200
 	help
 	  Watchdog timer embedded into AT91RM9200 chips. This will reboot your
 	  system when the timeout is reached.
 
 config 21285_WATCHDOG
 	tristate "DC21285 watchdog"
-	depends on WATCHDOG && FOOTBRIDGE
+	depends on FOOTBRIDGE
 	help
 	  The Intel Footbridge chip contains a built-in watchdog circuit. Say Y
 	  here if you wish to use this. Alternatively say M to compile the
@@ -83,7 +80,7 @@ config 21285_WATCHDOG
 
 config 977_WATCHDOG
 	tristate "NetWinder WB83C977 watchdog"
-	depends on WATCHDOG && FOOTBRIDGE && ARCH_NETWINDER
+	depends on FOOTBRIDGE && ARCH_NETWINDER
 	help
 	  Say Y here to include support for the WB977 watchdog included in
 	  NetWinder machines. Alternatively say M to compile the driver as
@@ -93,7 +90,7 @@ config 977_WATCHDOG
 
 config IXP2000_WATCHDOG
 	tristate "IXP2000 Watchdog"
-	depends on WATCHDOG && ARCH_IXP2000
+	depends on ARCH_IXP2000
 	help
 	  Say Y here if to include support for the watchdog timer
 	  in the Intel IXP2000(2400, 2800, 2850) network processors.
@@ -104,7 +101,7 @@ config IXP2000_WATCHDOG
 
 config IXP4XX_WATCHDOG
 	tristate "IXP4xx Watchdog"
-	depends on WATCHDOG && ARCH_IXP4XX
+	depends on ARCH_IXP4XX
 	help
 	  Say Y here if to include support for the watchdog timer
 	  in the Intel IXP4xx network processors. This driver can
@@ -120,7 +117,7 @@ config IXP4XX_WATCHDOG
 
 config S3C2410_WATCHDOG
 	tristate "S3C2410 Watchdog"
-	depends on WATCHDOG && ARCH_S3C2410
+	depends on ARCH_S3C2410
 	help
 	  Watchdog timer block in the Samsung S3C2410 chips. This will
 	  reboot the system when the timer expires with the watchdog
@@ -136,7 +133,7 @@ config S3C2410_WATCHDOG
 
 config SA1100_WATCHDOG
 	tristate "SA1100/PXA2xx watchdog"
-	depends on WATCHDOG && ( ARCH_SA1100 || ARCH_PXA )
+	depends on ARCH_SA1100 || ARCH_PXA
 	help
 	  Watchdog timer embedded into SA11x0 and PXA2xx chips. This will
 	  reboot your system when timeout is reached.
@@ -148,7 +145,7 @@ config SA1100_WATCHDOG
 
 config MPCORE_WATCHDOG
 	tristate "MPcore watchdog"
-	depends on WATCHDOG && ARM_MPCORE_PLATFORM && LOCAL_TIMERS
+	depends on ARM_MPCORE_PLATFORM && LOCAL_TIMERS
 	help
 	  Watchdog timer embedded into the MPcore system.
 
@@ -157,7 +154,7 @@ config MPCORE_WATCHDOG
 
 config EP93XX_WATCHDOG
 	tristate "EP93xx Watchdog"
-	depends on WATCHDOG && ARCH_EP93XX
+	depends on ARCH_EP93XX
 	help
 	  Say Y here if to include support for the watchdog timer
 	  embedded in the Cirrus Logic EP93xx family of devices.
@@ -167,14 +164,14 @@ config EP93XX_WATCHDOG
 
 config OMAP_WATCHDOG
 	tristate "OMAP Watchdog"
-	depends on WATCHDOG && (ARCH_OMAP16XX || ARCH_OMAP24XX)
+	depends on ARCH_OMAP16XX || ARCH_OMAP24XX
 	help
 	  Support for TI OMAP1610/OMAP1710/OMAP2420 watchdog.  Say 'Y' here to
 	  enable the OMAP1610/OMAP1710 watchdog timer.
 
 config PNX4008_WATCHDOG
 	tristate "PNX4008 Watchdog"
-	depends on WATCHDOG && ARCH_PNX4008
+	depends on ARCH_PNX4008
 	help
 	  Say Y here if to include support for the watchdog timer
 	  in the PNX4008 processor.
@@ -187,7 +184,7 @@ config PNX4008_WATCHDOG
 
 config ACQUIRE_WDT
 	tristate "Acquire SBC Watchdog Timer"
-	depends on WATCHDOG && X86
+	depends on X86
 	---help---
 	  This is the driver for the hardware watchdog on Single Board
 	  Computers produced by Acquire Inc (and others). This watchdog
@@ -201,7 +198,7 @@ config ACQUIRE_WDT
 
 config ADVANTECH_WDT
 	tristate "Advantech SBC Watchdog Timer"
-	depends on WATCHDOG && X86
+	depends on X86
 	help
 	  If you are configuring a Linux kernel for the Advantech single-board
 	  computer, say `Y' here to support its built-in watchdog timer
@@ -210,7 +207,7 @@ config ADVANTECH_WDT
 
 config ALIM1535_WDT
 	tristate "ALi M1535 PMU Watchdog Timer"
-	depends on WATCHDOG && X86 && PCI
+	depends on X86 && PCI
 	---help---
 	  This is the driver for the hardware watchdog on the ALi M1535 PMU.
 
@@ -221,7 +218,7 @@ config ALIM1535_WDT
 
 config ALIM7101_WDT
 	tristate "ALi M7101 PMU Computer Watchdog"
-	depends on WATCHDOG && X86 && PCI
+	depends on X86 && PCI
 	help
 	  This is the driver for the hardware watchdog on the ALi M7101 PMU
 	  as used in the x86 Cobalt servers.
@@ -233,7 +230,7 @@ config ALIM7101_WDT
 
 config SC520_WDT
 	tristate "AMD Elan SC520 processor Watchdog"
-	depends on WATCHDOG && X86
+	depends on X86
 	help
 	  This is the driver for the hardware watchdog built in to the
 	  AMD "Elan" SC520 microcomputer commonly used in embedded systems.
@@ -246,7 +243,7 @@ config SC520_WDT
 
 config EUROTECH_WDT
 	tristate "Eurotech CPU-1220/1410 Watchdog Timer"
-	depends on WATCHDOG && X86
+	depends on X86
 	help
 	  Enable support for the watchdog timer on the Eurotech CPU-1220 and
 	  CPU-1410 cards.  These are PC/104 SBCs. Spec sheets and product
@@ -254,7 +251,7 @@ config EUROTECH_WDT
 
 config IB700_WDT
 	tristate "IB700 SBC Watchdog Timer"
-	depends on WATCHDOG && X86
+	depends on X86
 	---help---
 	  This is the driver for the hardware watchdog on the IB700 Single
 	  Board Computer produced by TMC Technology (www.tmc-uk.com). This watchdog
@@ -270,7 +267,7 @@ config IB700_WDT
 
 config IBMASR
 	tristate "IBM Automatic Server Restart"
-	depends on WATCHDOG && X86
+	depends on X86
 	help
 	  This is the driver for the IBM Automatic Server Restart watchdog
 	  timer built-in into some eServer xSeries machines.
@@ -280,7 +277,7 @@ config IBMASR
 
 config WAFER_WDT
 	tristate "ICP Wafer 5823 Single Board Computer Watchdog"
-	depends on WATCHDOG && X86
+	depends on X86
 	help
 	  This is a driver for the hardware watchdog on the ICP Wafer 5823
 	  Single Board Computer (and probably other similar models).
@@ -290,7 +287,7 @@ config WAFER_WDT
 
 config I6300ESB_WDT
 	tristate "Intel 6300ESB Timer/Watchdog"
-	depends on WATCHDOG && X86 && PCI
+	depends on X86 && PCI
 	---help---
 	  Hardware driver for the watchdog timer built into the Intel
 	  6300ESB controller hub.
@@ -300,7 +297,7 @@ config I6300ESB_WDT
 
 config I8XX_TCO
 	tristate "Intel i8xx TCO Timer/Watchdog"
-	depends on WATCHDOG && (X86 || IA64) && PCI
+	depends on (X86 || IA64) && PCI
 	default n
 	---help---
 	  Hardware driver for the TCO timer built into the Intel 82801
@@ -322,7 +319,7 @@ config I8XX_TCO
 
 config ITCO_WDT
 	tristate "Intel TCO Timer/Watchdog"
-	depends on WATCHDOG && (X86 || IA64) && PCI
+	depends on (X86 || IA64) && PCI
 	---help---
 	  Hardware driver for the intel TCO timer based watchdog devices.
 	  These drivers are included in the Intel 82801 I/O Controller
@@ -351,7 +348,7 @@ config ITCO_VENDOR_SUPPORT
 
 config SC1200_WDT
 	tristate "National Semiconductor PC87307/PC97307 (ala SC1200) Watchdog"
-	depends on WATCHDOG && X86
+	depends on X86
 	help
 	  This is a driver for National Semiconductor PC87307/PC97307 hardware
 	  watchdog cards as found on the SC1200. This watchdog is mainly used
@@ -365,7 +362,7 @@ config SC1200_WDT
 
 config SCx200_WDT
 	tristate "National Semiconductor SCx200 Watchdog"
-	depends on WATCHDOG && SCx200 && PCI
+	depends on SCx200 && PCI
 	help
 	  Enable the built-in watchdog timer support on the National
 	  Semiconductor SCx200 processors.
@@ -374,7 +371,7 @@ config SCx200_WDT
 
 config PC87413_WDT
 	tristate "NS PC87413 watchdog"
-	depends on WATCHDOG && X86
+	depends on X86
 	---help---
 	  This is the driver for the hardware watchdog on the PC87413 chipset
 	  This watchdog simply watches your kernel to make sure it doesn't
@@ -388,7 +385,7 @@ config PC87413_WDT
  
 config 60XX_WDT
 	tristate "SBC-60XX Watchdog Timer"
-	depends on WATCHDOG && X86
+	depends on X86
 	help
 	  This driver can be used with the watchdog timer found on some
 	  single board computers, namely the 6010 PII based computer.
@@ -402,7 +399,7 @@ config 60XX_WDT
 
 config SBC8360_WDT
 	tristate "SBC8360 Watchdog Timer"
-	depends on WATCHDOG && X86
+	depends on X86
 	---help---
 
 	  This is the driver for the hardware watchdog on the SBC8360 Single
@@ -415,7 +412,7 @@ config SBC8360_WDT
 
 config CPU5_WDT
 	tristate "SMA CPU5 Watchdog"
-	depends on WATCHDOG && X86
+	depends on X86
 	---help---
 	  TBD.
 	  To compile this driver as a module, choose M here: the
@@ -423,7 +420,7 @@ config CPU5_WDT
 
 config SMSC37B787_WDT
 	tristate "Winbond SMsC37B787 Watchdog Timer"
-	depends on WATCHDOG && X86
+	depends on X86
 	---help---
 	  This is the driver for the hardware watchdog component on the
 	  Winbond SMsC37B787 chipset as used on the NetRunner Mainboard
@@ -443,7 +440,7 @@ config SMSC37B787_WDT
 
 config W83627HF_WDT
 	tristate "W83627HF Watchdog Timer"
-	depends on WATCHDOG && X86
+	depends on X86
 	---help---
 	  This is the driver for the hardware watchdog on the W83627HF chipset
 	  as used in Advantech PC-9578 and Tyan S2721-533 motherboards
@@ -458,7 +455,7 @@ config W83627HF_WDT
 
 config W83697HF_WDT
 	tristate "W83697HF/W83697HG Watchdog Timer"
-	depends on WATCHDOG && X86
+	depends on X86
 	---help---
 	  This is the driver for the hardware watchdog on the W83697HF/HG
 	  chipset as used in Dedibox/VIA motherboards (and likely others).
@@ -473,7 +470,7 @@ config W83697HF_WDT
 
 config W83877F_WDT
 	tristate "W83877F (EMACS) Watchdog Timer"
-	depends on WATCHDOG && X86
+	depends on X86
 	---help---
 	  This is the driver for the hardware watchdog on the W83877F chipset
 	  as used in EMACS PC-104 motherboards (and likely others).  This
@@ -488,7 +485,7 @@ config W83877F_WDT
 
 config W83977F_WDT
 	tristate "W83977F (PCM-5335) Watchdog Timer"
-	depends on WATCHDOG && X86
+	depends on X86
 	---help---
 	  This is the driver for the hardware watchdog on the W83977F I/O chip
 	  as used in AAEON's PCM-5335 SBC (and likely others).  This
@@ -501,7 +498,7 @@ config W83977F_WDT
 
 config MACHZ_WDT
 	tristate "ZF MachZ Watchdog"
-	depends on WATCHDOG && X86
+	depends on X86
 	---help---
 	  If you are using a ZF Micro MachZ processor, say Y here, otherwise
 	  N.  This is the driver for the watchdog timer built-in on that
@@ -514,7 +511,7 @@ config MACHZ_WDT
 
 config SBC_EPX_C3_WATCHDOG
 	tristate "Winsystems SBC EPX-C3 watchdog"
-	depends on WATCHDOG && X86
+	depends on X86
 	---help---
 	  This is the driver for the built-in watchdog timer on the EPX-C3
 	  Single-board computer made by Winsystems, Inc.
@@ -537,19 +534,19 @@ config SBC_EPX_C3_WATCHDOG
 
 config 8xx_WDT
 	tristate "MPC8xx Watchdog Timer"
-	depends on WATCHDOG && 8xx
+	depends on 8xx
 
 config 83xx_WDT
 	tristate "MPC83xx Watchdog Timer"
-	depends on WATCHDOG && PPC_83xx
+	depends on PPC_83xx
 
 config MV64X60_WDT
 	tristate "MV64X60 (Marvell Discovery) Watchdog Timer"
-	depends on WATCHDOG && MV64X60
+	depends on MV64X60
 
 config BOOKE_WDT
 	tristate "PowerPC Book-E Watchdog Timer"
-	depends on WATCHDOG && (BOOKE || 4xx)
+	depends on BOOKE || 4xx
 	---help---
 	  Please see Documentation/watchdog/watchdog-api.txt for
 	  more information.
@@ -558,7 +555,7 @@ config BOOKE_WDT
 
 config WATCHDOG_RTAS
 	tristate "RTAS watchdog"
-	depends on WATCHDOG && PPC_RTAS
+	depends on PPC_RTAS
 	help
 	  This driver adds watchdog support for the RTAS watchdog.
 
@@ -569,7 +566,7 @@ config WATCHDOG_RTAS
 
 config INDYDOG
 	tristate "Indy/I2 Hardware Watchdog"
-	depends on WATCHDOG && SGI_IP22
+	depends on SGI_IP22
 	help
 	  Hardware driver for the Indy's/I2's watchdog. This is a
 	  watchdog timer that will reboot the machine after a 60 second
@@ -578,7 +575,7 @@ config INDYDOG
 
 config WDT_RM9K_GPI
 	tristate "RM9000/GPI hardware watchdog"
-	depends on WATCHDOG && CPU_RM9000
+	depends on CPU_RM9000
 	help
 	  Watchdog implementation using the GPI hardware found on
 	  PMC-Sierra RM9xxx CPUs.
@@ -590,7 +587,7 @@ config WDT_RM9K_GPI
 
 config ZVM_WATCHDOG
 	tristate "z/VM Watchdog Timer"
-	depends on WATCHDOG && S390
+	depends on S390
 	help
 	  IBM s/390 and zSeries machines running under z/VM 5.1 or later
 	  provide a virtual watchdog timer to their guest that cause a
@@ -604,7 +601,7 @@ config ZVM_WATCHDOG
 
 config SH_WDT
 	tristate "SuperH Watchdog"
-	depends on WATCHDOG && SUPERH
+	depends on SUPERH
 	help
 	  This driver adds watchdog support for the integrated watchdog in the
 	  SuperH processors. If you have one of these processors and wish
@@ -631,7 +628,7 @@ config SH_WDT_MMAP
 
 config WATCHDOG_CP1XXX
 	tristate "CP1XXX Hardware Watchdog support"
-	depends on WATCHDOG && SPARC64 && PCI
+	depends on SPARC64 && PCI
 	---help---
 	  This is the driver for the hardware watchdog timers present on
 	  Sun Microsystems CompactPCI models CP1400 and CP1500.
@@ -645,7 +642,7 @@ config WATCHDOG_CP1XXX
 
 config WATCHDOG_RIO
 	tristate "RIO Hardware Watchdog support"
-	depends on WATCHDOG && SPARC64 && PCI
+	depends on SPARC64 && PCI
 	help
 	  Say Y here to support the hardware watchdog capability on Sun RIO
 	  machines.  The watchdog timeout period is normally one minute but
@@ -656,11 +653,11 @@ config WATCHDOG_RIO
 #
 
 comment "ISA-based Watchdog Cards"
-	depends on WATCHDOG && ISA
+	depends on ISA
 
 config PCWATCHDOG
 	tristate "Berkshire Products ISA-PC Watchdog"
-	depends on WATCHDOG && ISA
+	depends on ISA
 	---help---
 	  This is the driver for the Berkshire Products ISA-PC Watchdog card.
 	  This card simply watches your kernel to make sure it doesn't freeze,
@@ -676,7 +673,7 @@ config PCWATCHDOG
 
 config MIXCOMWD
 	tristate "Mixcom Watchdog"
-	depends on WATCHDOG && ISA
+	depends on ISA
 	---help---
 	  This is a driver for the Mixcom hardware watchdog cards.  This
 	  watchdog simply watches your kernel to make sure it doesn't freeze,
@@ -690,7 +687,7 @@ config MIXCOMWD
 
 config WDT
 	tristate "WDT Watchdog timer"
-	depends on WATCHDOG && ISA
+	depends on ISA
 	---help---
 	  If you have a WDT500P or WDT501P watchdog board, say Y here,
 	  otherwise N. It is not possible to probe for this board, which means
@@ -720,11 +717,11 @@ config WDT_501
 #
 
 comment "PCI-based Watchdog Cards"
-	depends on WATCHDOG && PCI
+	depends on PCI
 
 config PCIPCWATCHDOG
 	tristate "Berkshire Products PCI-PC Watchdog"
-	depends on WATCHDOG && PCI
+	depends on PCI
 	---help---
 	  This is the driver for the Berkshire Products PCI-PC Watchdog card.
 	  This card simply watches your kernel to make sure it doesn't freeze,
@@ -739,7 +736,7 @@ config PCIPCWATCHDOG
 
 config WDTPCI
 	tristate "PCI-WDT500/501 Watchdog timer"
-	depends on WATCHDOG && PCI
+	depends on PCI
 	---help---
 	  If you have a PCI-WDT500/501 watchdog board, say Y here, otherwise N.
 
@@ -766,11 +763,11 @@ config WDT_501_PCI
 #
 
 comment "USB-based Watchdog Cards"
-	depends on WATCHDOG && USB
+	depends on USB
 
 config USBPCWATCHDOG
 	tristate "Berkshire Products USB-PC Watchdog"
-	depends on WATCHDOG && USB
+	depends on USB
 	---help---
 	  This is the driver for the Berkshire Products USB-PC Watchdog card.
 	  This card simply watches your kernel to make sure it doesn't freeze,
@@ -783,4 +780,4 @@ config USBPCWATCHDOG
 
 	  Most people will say N.
 
-endmenu
+endif # WATCHDOG
