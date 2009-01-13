Return-Path: <linux-kernel-owner+w=401wt.eu-S1760721AbZAMObn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760721AbZAMObn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 09:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbZAMObe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 09:31:34 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:49124 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbZAMObd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 09:31:33 -0500
Subject: [PATCH] backlight: don't default y
From: Johannes Berg <johannes@sipsolutions.net>
To: Richard Purdie <rpurdie@openedhand.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 13 Jan 2009 15:29:57 +0100
Message-Id: <1231856997.3671.38.camel@johannes>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all the backlight drivers make sense, especially not the "generic"
one that works on some sharp devices. "default n" is also absolutely
pointless, and not everybody needs LCD backlight support either.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/video/backlight/Kconfig |   13 -------------
 1 file changed, 13 deletions(-)

--- wireless-testing.orig/drivers/video/backlight/Kconfig	2009-01-13 15:28:04.000000000 +0100
+++ wireless-testing/drivers/video/backlight/Kconfig	2009-01-13 15:29:06.000000000 +0100
@@ -14,7 +14,6 @@ menuconfig BACKLIGHT_LCD_SUPPORT
 config LCD_CLASS_DEVICE
         tristate "Lowlevel LCD controls"
 	depends on BACKLIGHT_LCD_SUPPORT
-	default m
 	help
 	  This framework adds support for low-level control of LCD.
 	  Some framebuffer devices connect to platform-specific LCD modules
@@ -34,7 +33,6 @@ config LCD_CORGI
 config LCD_LTV350QV
 	tristate "Samsung LTV350QV LCD Panel"
 	depends on LCD_CLASS_DEVICE && SPI_MASTER
-	default n
 	help
 	  If you have a Samsung LTV350QV LCD panel, say y to include a
 	  power control driver for it.  The panel starts up in power
@@ -46,7 +44,6 @@ config LCD_LTV350QV
 config LCD_ILI9320
 	tristate
 	depends on LCD_CLASS_DEVICE && BACKLIGHT_LCD_SUPPORT
-	default n
 	help
 	  If you have a panel based on the ILI9320 controller chip
 	  then say y to include a power driver for it.
@@ -54,7 +51,6 @@ config LCD_ILI9320
 config LCD_TDO24M
 	tristate "Toppoly TDO24M  and TDO35S LCD Panels support"
 	depends on LCD_CLASS_DEVICE && SPI_MASTER
-	default n
 	help
 	  If you have a Toppoly TDO24M/TDO35S series LCD panel, say y here to
 	  include the support for it.
@@ -63,7 +59,6 @@ config LCD_VGG2432A4
 	tristate "VGG2432A4 LCM device support"
 	depends on BACKLIGHT_LCD_SUPPORT && LCD_CLASS_DEVICE && SPI_MASTER
 	select LCD_ILI9320
-	default n
 	help
 	  If you have a VGG2432A4 panel based on the ILI9320 controller chip
 	  then say y to include a power driver for it.
@@ -79,7 +74,6 @@ config LCD_TOSA
 	tristate "Sharp SL-6000 LCD Driver"
 	depends on LCD_CLASS_DEVICE && SPI
 	depends on MACH_TOSA
-	default n
 	help
 	  If you have an Sharp SL-6000 Zaurus say Y to enable a driver
 	  for its LCD.
@@ -114,7 +108,6 @@ config BACKLIGHT_ATMEL_LCDC
 config BACKLIGHT_ATMEL_PWM
 	tristate "Atmel PWM backlight control"
 	depends on BACKLIGHT_CLASS_DEVICE && ATMEL_PWM
-	default n
 	help
 	  Say Y here if you want to use the PWM peripheral in Atmel AT91 and
 	  AVR32 devices. This driver will need additional platform data to know
@@ -126,7 +119,6 @@ config BACKLIGHT_ATMEL_PWM
 config BACKLIGHT_GENERIC
 	tristate "Generic (aka Sharp Corgi) Backlight Driver"
 	depends on BACKLIGHT_CLASS_DEVICE
-	default y
 	help
 	  Say y to enable the generic platform backlight driver previously
 	  known as the Corgi backlight driver. If you have a Sharp Zaurus
@@ -160,7 +152,6 @@ config BACKLIGHT_HP680
 config BACKLIGHT_PROGEAR
 	tristate "Frontpath ProGear Backlight Driver"
 	depends on BACKLIGHT_CLASS_DEVICE && PCI && X86
-	default n
 	help
 	  If you have a Frontpath ProGear say Y to enable the
 	  backlight driver.
@@ -168,7 +159,6 @@ config BACKLIGHT_PROGEAR
 config BACKLIGHT_CARILLO_RANCH
 	tristate "Intel Carillo Ranch Backlight Driver"
 	depends on BACKLIGHT_CLASS_DEVICE && LCD_CLASS_DEVICE && PCI && X86 && FB_LE80578
-	default n
 	help
 	  If you have a Intel LE80578 (Carillo Ranch) say Y to enable the
 	  backlight driver.
@@ -190,7 +180,6 @@ config BACKLIGHT_DA903X
 config BACKLIGHT_MBP_NVIDIA
        tristate "MacBook Pro Nvidia Backlight Driver"
        depends on BACKLIGHT_CLASS_DEVICE && X86
-       default n
        help
          If you have an Apple Macbook Pro with Nvidia graphics hardware say Y
 	 to enable a driver for its backlight
@@ -199,7 +188,6 @@ config BACKLIGHT_TOSA
 	tristate "Sharp SL-6000 Backlight Driver"
 	depends on BACKLIGHT_CLASS_DEVICE && I2C
 	depends on MACH_TOSA && LCD_TOSA
-	default n
 	help
 	  If you have an Sharp SL-6000 Zaurus say Y to enable a driver
 	  for its backlight
@@ -207,7 +195,6 @@ config BACKLIGHT_TOSA
 config BACKLIGHT_SAHARA
 	tristate "Tabletkiosk Sahara Touch-iT Backlight Driver"
 	depends on BACKLIGHT_CLASS_DEVICE && X86
-	default n
 	help
 	  If you have a Tabletkiosk Sahara Touch-iT, say y to enable the
 	  backlight driver.


