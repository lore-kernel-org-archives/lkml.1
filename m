Return-Path: <linux-kernel-owner+w=401wt.eu-S1762161AbXGUS5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762161AbXGUS5M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 14:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756166AbXGUS45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 14:56:57 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:51183 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756371AbXGUS4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 14:56:55 -0400
Date: Sat, 21 Jul 2007 20:56:54 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: akpm@linux-foundation.org
cc: a.zummo@towertech.it, david-b@pacbell.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Use menuconfig objects - RTC
In-Reply-To: <200705150600.l4F60F99002783@shell0.pdx.osdl.net>
Message-ID: <Pine.LNX.4.64.0707182036030.5385@fbirervta.pbzchgretzou.qr>
References: <200705150600.l4F60F99002783@shell0.pdx.osdl.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On May 14 2007 23:00, akpm@linux-foundation.org wrote:
>The patch titled
>     Use menuconfig objects II - RTC
>has been removed from the -mm tree.  Its filename was
>     use-menuconfig-objects-ii-rtc.patch
>
>This patch was dropped because other stuff trashed it

Heh. Here is an updated version.


Thanks,
	Jan
===

Change Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to
enter the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 drivers/rtc/Kconfig |   79 +++++++++++++++++++++-------------------------------
 1 file changed, 32 insertions(+), 47 deletions(-)

Index: linux-2.6.23/drivers/rtc/Kconfig
===================================================================
--- linux-2.6.23.orig/drivers/rtc/Kconfig
+++ linux-2.6.23/drivers/rtc/Kconfig
@@ -2,15 +2,13 @@
 # RTC class/drivers configuration
 #
 
-menu "Real Time Clock"
-	depends on !S390
-
 config RTC_LIB
 	tristate
 
-config RTC_CLASS
-	tristate "RTC class"
+menuconfig RTC_CLASS
+	tristate "Real Time Clock"
 	default n
+	depends on !S390
 	select RTC_LIB
 	help
 	  Generic RTC class support. If you say yes here, you will
@@ -20,6 +18,8 @@ config RTC_CLASS
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-class.
 
+if RTC_CLASS
+
 config RTC_HCTOSYS
 	bool "Set system time from RTC on startup and resume"
 	depends on RTC_CLASS = y
@@ -55,11 +55,10 @@ config RTC_DEBUG
 	  and individual RTC drivers.
 
 comment "RTC interfaces"
-	depends on RTC_CLASS
 
 config RTC_INTF_SYSFS
 	boolean "/sys/class/rtc/rtcN (sysfs)"
-	depends on RTC_CLASS && SYSFS
+	depends on SYSFS
 	default RTC_CLASS
 	help
 	  Say yes here if you want to use your RTCs using sysfs interfaces,
@@ -70,7 +69,7 @@ config RTC_INTF_SYSFS
 
 config RTC_INTF_PROC
 	boolean "/proc/driver/rtc (procfs for rtc0)"
-	depends on RTC_CLASS && PROC_FS
+	depends on PROC_FS
 	default RTC_CLASS
 	help
 	  Say yes here if you want to use your first RTC through the proc
@@ -82,7 +81,6 @@ config RTC_INTF_PROC
 
 config RTC_INTF_DEV
 	boolean "/dev/rtcN (character devices)"
-	depends on RTC_CLASS
 	default RTC_CLASS
 	help
 	  Say yes here if you want to use your RTCs using the /dev
@@ -104,7 +102,6 @@ config RTC_INTF_DEV_UIE_EMUL
 
 config RTC_DRV_TEST
 	tristate "Test driver/device"
-	depends on RTC_CLASS
 	help
 	  If you say yes here you get support for the
 	  RTC test driver. It's a software RTC which can be
@@ -118,11 +115,12 @@ config RTC_DRV_TEST
 	  will be called rtc-test.
 
 comment "I2C RTC drivers"
-	depends on RTC_CLASS && I2C
+	depends on I2C
+
+if I2C
 
 config RTC_DRV_DS1307
 	tristate "Dallas/Maxim DS1307/37/38/39/40, ST M41T00"
-	depends on RTC_CLASS && I2C
 	help
 	  If you say yes here you get support for various compatible RTC
 	  chips (often with battery backup) connected with I2C.  This driver
@@ -140,7 +138,6 @@ config RTC_DRV_DS1307
 
 config RTC_DRV_DS1672
 	tristate "Dallas/Maxim DS1672"
-	depends on RTC_CLASS && I2C
 	help
 	  If you say yes here you get support for the
 	  Dallas/Maxim DS1672 timekeeping chip.
@@ -150,7 +147,6 @@ config RTC_DRV_DS1672
 
 config RTC_DRV_MAX6900
 	tristate "Maxim 6900"
-	depends on RTC_CLASS && I2C
 	help
 	  If you say yes here you will get support for the
 	  Maxim MAX6900 I2C RTC chip.
@@ -160,7 +156,6 @@ config RTC_DRV_MAX6900
 
 config RTC_DRV_RS5C372
 	tristate "Ricoh RS5C372A/B, RV5C386, RV5C387A"
-	depends on RTC_CLASS && I2C
 	help
 	  If you say yes here you get support for the
 	  Ricoh RS5C372A, RS5C372B, RV5C386, and RV5C387A RTC chips.
@@ -170,7 +165,6 @@ config RTC_DRV_RS5C372
 
 config RTC_DRV_ISL1208
 	tristate "Intersil 1208"
-	depends on RTC_CLASS && I2C
 	help
 	  If you say yes here you get support for the
 	  Intersil 1208 RTC chip.
@@ -180,7 +174,6 @@ config RTC_DRV_ISL1208
 
 config RTC_DRV_X1205
 	tristate "Xicor/Intersil X1205"
-	depends on RTC_CLASS && I2C
 	help
 	  If you say yes here you get support for the
 	  Xicor/Intersil X1205 RTC chip.
@@ -190,7 +183,6 @@ config RTC_DRV_X1205
 
 config RTC_DRV_PCF8563
 	tristate "Philips PCF8563/Epson RTC8564"
-	depends on RTC_CLASS && I2C
 	help
 	  If you say yes here you get support for the
 	  Philips PCF8563 RTC chip. The Epson RTC8564
@@ -201,7 +193,6 @@ config RTC_DRV_PCF8563
 
 config RTC_DRV_PCF8583
 	tristate "Philips PCF8583"
-	depends on RTC_CLASS && I2C
 	help
 	  If you say yes here you get support for the Philips PCF8583
 	  RTC chip found on Acorn RiscPCs. This driver supports the
@@ -214,7 +205,6 @@ config RTC_DRV_PCF8583
 
 config RTC_DRV_M41T80
 	tristate "ST M41T80 series RTC"
-	depends on RTC_CLASS && I2C
 	help
 	  If you say Y here you will get support for the
 	  ST M41T80 RTC chips series. Currently following chips are
@@ -233,19 +223,21 @@ config RTC_DRV_M41T80_WDT
 
 config RTC_DRV_TWL92330
 	boolean "TI TWL92330/Menelaus"
-	depends on RTC_CLASS && I2C && MENELAUS
+	depends on MENELAUS
 	help
 	  If you say yes here you get support for the RTC on the
 	  TWL92330 "Menelaus" power mangement chip, used with OMAP2
 	  platforms.  The support is integrated with the rest of
 	  the Menelaus driver; it's not separate module.
 
+endif # I2C
+
 comment "SPI RTC drivers"
-	depends on RTC_CLASS && SPI_MASTER
+
+if SPI_MASTER
 
 config RTC_DRV_RS5C348
 	tristate "Ricoh RS5C348A/B"
-	depends on RTC_CLASS && SPI_MASTER
 	help
 	  If you say yes here you get support for the
 	  Ricoh RS5C348A and RS5C348B RTC chips.
@@ -255,7 +247,6 @@ config RTC_DRV_RS5C348
 
 config RTC_DRV_MAX6902
 	tristate "Maxim 6902"
-	depends on RTC_CLASS && SPI_MASTER
 	help
 	  If you say yes here you will get support for the
 	  Maxim MAX6902 SPI RTC chip.
@@ -263,8 +254,9 @@ config RTC_DRV_MAX6902
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-max6902.
 
+endif # SPI_MASTER
+
 comment "Platform RTC drivers"
-	depends on RTC_CLASS
 
 # this 'CMOS' RTC driver is arch dependent because <asm-generic/rtc.h>
 # requires <asm/mc146818rtc.h> defining CMOS_READ/CMOS_WRITE, and a
@@ -272,8 +264,8 @@ comment "Platform RTC drivers"
 
 config RTC_DRV_CMOS
 	tristate "PC-style 'CMOS'"
-	depends on RTC_CLASS && (X86 || ALPHA || ARM26 || ARM \
-		|| M32R || ATARI || PPC || MIPS)
+	depends on X86 || ALPHA || ARM26 || ARM || \
+		M32R || ATARI || PPC || MIPS
 	help
 	  Say "yes" here to get direct support for the real time clock
 	  found in every PC or ACPI-based system, and some other boards.
@@ -291,13 +283,12 @@ config RTC_DRV_CMOS
 
 config RTC_DRV_DS1216
 	tristate "Dallas DS1216"
-	depends on RTC_CLASS && SNI_RM
+	depends on SNI_RM
 	help
 	  If you say yes here you get support for the Dallas DS1216 RTC chips.
 
 config RTC_DRV_DS1553
 	tristate "Dallas DS1553"
-	depends on RTC_CLASS
 	help
 	  If you say yes here you get support for the
 	  Dallas DS1553 timekeeping chip.
@@ -307,7 +298,6 @@ config RTC_DRV_DS1553
 
 config RTC_DRV_DS1742
 	tristate "Dallas DS1742/1743"
-	depends on RTC_CLASS
 	help
 	  If you say yes here you get support for the
 	  Dallas DS1742/1743 timekeeping chip.
@@ -317,7 +307,6 @@ config RTC_DRV_DS1742
 
 config RTC_DRV_M48T86
 	tristate "ST M48T86/Dallas DS12887"
-	depends on RTC_CLASS
 	help
 	  If you say Y here you will get support for the
 	  ST M48T86 and Dallas DS12887 RTC chips.
@@ -327,7 +316,6 @@ config RTC_DRV_M48T86
 
 config RTC_DRV_M48T59
 	tristate "ST M48T59"
-	depends on RTC_CLASS
 	help
 	  If you say Y here you will get support for the
 	  ST M48T59 RTC chip.
@@ -337,7 +325,6 @@ config RTC_DRV_M48T59
 
 config RTC_DRV_V3020
 	tristate "EM Microelectronic V3020"
-	depends on RTC_CLASS
 	help
 	  If you say yes here you will get support for the
 	  EM Microelectronic v3020 RTC chip.
@@ -346,19 +333,17 @@ config RTC_DRV_V3020
 	  will be called rtc-v3020.
 
 comment "on-CPU RTC drivers"
-	depends on RTC_CLASS
 
 config RTC_DRV_OMAP
 	tristate "TI OMAP1"
-	depends on RTC_CLASS && ( \
-		ARCH_OMAP15XX || ARCH_OMAP16XX || ARCH_OMAP730 )
+	depends on ARCH_OMAP15XX || ARCH_OMAP16XX || ARCH_OMAP730
 	help
 	  Say "yes" here to support the real time clock on TI OMAP1 chips.
 	  This driver can also be built as a module called rtc-omap.
 
 config RTC_DRV_S3C
 	tristate "Samsung S3C series SoC RTC"
-	depends on RTC_CLASS && ARCH_S3C2410
+	depends on ARCH_S3C2410
 	help
 	  RTC (Realtime Clock) driver for the clock inbuilt into the
 	  Samsung S3C24XX series of SoCs. This can provide periodic
@@ -374,7 +359,7 @@ config RTC_DRV_S3C
 
 config RTC_DRV_EP93XX
 	tristate "Cirrus Logic EP93XX"
-	depends on RTC_CLASS && ARCH_EP93XX
+	depends on ARCH_EP93XX
 	help
 	  If you say yes here you get support for the
 	  RTC embedded in the Cirrus Logic EP93XX processors.
@@ -384,7 +369,7 @@ config RTC_DRV_EP93XX
 
 config RTC_DRV_SA1100
 	tristate "SA11x0/PXA2xx"
-	depends on RTC_CLASS && (ARCH_SA1100 || ARCH_PXA)
+	depends on ARCH_SA1100 || ARCH_PXA
 	help
 	  If you say Y here you will get access to the real time clock
 	  built into your SA11x0 or PXA2xx CPU.
@@ -394,7 +379,7 @@ config RTC_DRV_SA1100
 
 config RTC_DRV_SH
 	tristate "SuperH On-Chip RTC"
-	depends on RTC_CLASS && SUPERH
+	depends on SUPERH
 	help
 	  Say Y here to enable support for the on-chip RTC found in
 	  most SuperH processors.
@@ -404,7 +389,7 @@ config RTC_DRV_SH
 
 config RTC_DRV_VR41XX
 	tristate "NEC VR41XX"
-	depends on RTC_CLASS && CPU_VR41XX
+	depends on CPU_VR41XX
 	help
 	  If you say Y here you will get access to the real time clock
 	  built into your NEC VR41XX CPU.
@@ -414,7 +399,7 @@ config RTC_DRV_VR41XX
 
 config RTC_DRV_PL031
 	tristate "ARM AMBA PL031 RTC"
-	depends on RTC_CLASS && ARM_AMBA
+	depends on ARM_AMBA
 	help
 	  If you say Y here you will get access to ARM AMBA
 	  PrimeCell PL031 RTC found on certain ARM SOCs.
@@ -424,20 +409,20 @@ config RTC_DRV_PL031
 
 config RTC_DRV_AT32AP700X
 	tristate "AT32AP700X series RTC"
-	depends on RTC_CLASS && PLATFORM_AT32AP
+	depends on PLATFORM_AT32AP
 	help
 	  Driver for the internal RTC (Realtime Clock) on Atmel AVR32
 	  AT32AP700x family processors.
 
 config RTC_DRV_AT91RM9200
 	tristate "AT91RM9200"
-	depends on RTC_CLASS && ARCH_AT91RM9200
+	depends on ARCH_AT91RM9200
 	help
 	  Driver for the Atmel AT91RM9200's internal RTC (Realtime Clock).
 
 config RTC_DRV_BFIN
 	tristate "Blackfin On-Chip RTC"
-	depends on RTC_CLASS && BFIN
+	depends on BFIN
 	help
 	  If you say yes here you will get support for the
 	  Blackfin On-Chip Real Time Clock.
@@ -447,8 +432,8 @@ config RTC_DRV_BFIN
 
 config RTC_DRV_RS5C313
 	tristate "Ricoh RS5C313"
-	depends on RTC_CLASS && SH_LANDISK
+	depends on SH_LANDISK
 	help
 	  If you say yes here you get support for the Ricoh RS5C313 RTC chips.
 
-endmenu
+endif # RTC_CLASS
