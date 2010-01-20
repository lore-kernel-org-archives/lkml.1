Return-Path: <linux-kernel-owner+w=401wt.eu-S1753660Ab0ATXIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab0ATXIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 18:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065Ab0ATXIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 18:08:34 -0500
Received: from [206.15.93.42] ([206.15.93.42]:14193 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751931Ab0ATXIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 18:08:32 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] leds: Kconfig cleanup
Date: Wed, 20 Jan 2010 16:08:30 -0700
Cc: rpurdie@rpsys.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001201608.30694.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the need for "depends on LEDS_CLASS" by wrapping the affected
config options in an if/endif block. Similar for "depends on LEDS_TRIGGERS".

LEDS_COBALT_RAQ still has a "depends on LEDS_CLASS=y" since it cannot
be selected to build as a module.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Richard Purdie <rpurdie@rpsys.net>

---

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 8a0e1ec..fc02f57 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -15,77 +15,79 @@ config LEDS_CLASS
 	  This option enables the led sysfs class in /sys/class/leds.  You'll
 	  need this to do anything useful with LEDs.  If unsure, say N.
 
+if LEDS_CLASS
+
 comment "LED drivers"
 
 config LEDS_ATMEL_PWM
 	tristate "LED Support using Atmel PWM outputs"
-	depends on LEDS_CLASS && ATMEL_PWM
+	depends on ATMEL_PWM
 	help
 	  This option enables support for LEDs driven using outputs
 	  of the dedicated PWM controller found on newer Atmel SOCs.
 
 config LEDS_LOCOMO
 	tristate "LED Support for Locomo device"
-	depends on LEDS_CLASS && SHARP_LOCOMO
+	depends on SHARP_LOCOMO
 	help
 	  This option enables support for the LEDs on Sharp Locomo.
 	  Zaurus models SL-5500 and SL-5600.
 
 config LEDS_MIKROTIK_RB532
 	tristate "LED Support for Mikrotik Routerboard 532"
-	depends on LEDS_CLASS && MIKROTIK_RB532
+	depends on MIKROTIK_RB532
 	help
 	  This option enables support for the so called "User LED" of
 	  Mikrotik's Routerboard 532.
 
 config LEDS_S3C24XX
 	tristate "LED Support for Samsung S3C24XX GPIO LEDs"
-	depends on LEDS_CLASS && ARCH_S3C2410
+	depends on ARCH_S3C2410
 	help
 	  This option enables support for LEDs connected to GPIO lines
 	  on Samsung S3C24XX series CPUs, such as the S3C2410 and S3C2440.
 
 config LEDS_AMS_DELTA
 	tristate "LED Support for the Amstrad Delta (E3)"
-	depends on LEDS_CLASS && MACH_AMS_DELTA
+	depends on MACH_AMS_DELTA
 	help
 	  This option enables support for the LEDs on Amstrad Delta (E3).
 
 config LEDS_NET48XX
 	tristate "LED Support for Soekris net48xx series Error LED"
-	depends on LEDS_CLASS && SCx200_GPIO
+	depends on SCx200_GPIO
 	help
 	  This option enables support for the Soekris net4801 and net4826 error
 	  LED.
 
 config LEDS_FSG
 	tristate "LED Support for the Freecom FSG-3"
-	depends on LEDS_CLASS && MACH_FSG
+	depends on MACH_FSG
 	help
 	  This option enables support for the LEDs on the Freecom FSG-3.
 
 config LEDS_WRAP
 	tristate "LED Support for the WRAP series LEDs"
-	depends on LEDS_CLASS && SCx200_GPIO
+	depends on SCx200_GPIO
 	help
 	  This option enables support for the PCEngines WRAP programmable LEDs.
 
 config LEDS_ALIX2
 	tristate "LED Support for ALIX.2 and ALIX.3 series"
-	depends on LEDS_CLASS && X86 && EXPERIMENTAL
+	depends on X86 && EXPERIMENTAL
 	help
 	  This option enables support for the PCEngines ALIX.2 and ALIX.3 LEDs.
 	  You have to set leds-alix2.force=1 for boards with Award BIOS.
 
 config LEDS_H1940
 	tristate "LED Support for iPAQ H1940 device"
-	depends on LEDS_CLASS && ARCH_H1940
+	depends on ARCH_H1940
 	help
 	  This option enables support for the LEDs on the h1940.
 
 config LEDS_COBALT_QUBE
 	tristate "LED Support for the Cobalt Qube series front LED"
-	depends on LEDS_CLASS && MIPS_COBALT
+	depends on MIPS_COBALT
 	help
 	  This option enables support for the front LED on Cobalt Qube series
 
@@ -98,7 +100,7 @@ config LEDS_COBALT_RAQ
 
 config LEDS_SUNFIRE
 	tristate "LED support for SunFire servers."
-	depends on LEDS_CLASS && SPARC64
+	depends on SPARC64
 	select LEDS_TRIGGERS
 	help
 	  This option enables support for the Left, Middle, and Right
@@ -106,14 +108,14 @@ config LEDS_SUNFIRE
 
 config LEDS_HP6XX
 	tristate "LED Support for the HP Jornada 6xx"
-	depends on LEDS_CLASS && SH_HP6XX
+	depends on SH_HP6XX
 	help
 	  This option enables LED support for the handheld
 	  HP Jornada 620/660/680/690.
 
 config LEDS_PCA9532
 	tristate "LED driver for PCA9532 dimmer"
-	depends on LEDS_CLASS && I2C && INPUT && EXPERIMENTAL
+	depends on I2C && INPUT && EXPERIMENTAL
 	help
 	  This option enables support for NXP pca9532
 	  LED controller. It is generally only useful
@@ -121,7 +123,7 @@ config LEDS_PCA9532
 
 config LEDS_GPIO
 	tristate "LED Support for GPIO connected LEDs"
-	depends on LEDS_CLASS && GENERIC_GPIO
+	depends on GENERIC_GPIO
 	help
 	  This option enables support for the LEDs connected to GPIO
 	  outputs. To be useful the particular board must have LEDs
@@ -148,7 +150,7 @@ config LEDS_GPIO_OF
 
 config LEDS_LP3944
 	tristate "LED Support for N.S. LP3944 (Fun Light) I2C chip"
-	depends on LEDS_CLASS && I2C
+	depends on I2C
 	help
 	  This option enables support for LEDs connected to the National
 	  Semiconductor LP3944 Lighting Management Unit (LMU) also known as
@@ -159,7 +161,7 @@ config LEDS_LP3944
 
 config LEDS_CLEVO_MAIL
 	tristate "Mail LED on Clevo notebook"
-	depends on LEDS_CLASS && X86 && SERIO_I8042 && DMI
+	depends on X86 && SERIO_I8042 && DMI
 	help
 	  This driver makes the mail LED accessible from userspace
 	  programs through the leds subsystem. This LED have three
@@ -189,7 +191,7 @@ config LEDS_CLEVO_MAIL
 
 config LEDS_PCA955X
 	tristate "LED Support for PCA955x I2C chips"
-	depends on LEDS_CLASS && I2C
+	depends on I2C
 	help
 	  This option enables support for LEDs connected to PCA955x
 	  LED driver chips accessed via the I2C bus.  Supported
@@ -197,54 +199,54 @@ config LEDS_PCA955X
 
 config LEDS_WM831X_STATUS
 	tristate "LED support for status LEDs on WM831x PMICs"
-	depends on LEDS_CLASS && MFD_WM831X
+	depends on MFD_WM831X
 	help
 	  This option enables support for the status LEDs of the WM831x
           series of PMICs.
 
 config LEDS_WM8350
 	tristate "LED Support for WM8350 AudioPlus PMIC"
-	depends on LEDS_CLASS && MFD_WM8350
+	depends on MFD_WM8350
 	help
 	  This option enables support for LEDs driven by the Wolfson
 	  Microelectronics WM8350 AudioPlus PMIC.
 
 config LEDS_DA903X
 	tristate "LED Support for DA9030/DA9034 PMIC"
-	depends on LEDS_CLASS && PMIC_DA903X
+	depends on PMIC_DA903X
 	help
 	  This option enables support for on-chip LED drivers found
 	  on Dialog Semiconductor DA9030/DA9034 PMICs.
 
 config LEDS_DAC124S085
 	tristate "LED Support for DAC124S085 SPI DAC"
-	depends on LEDS_CLASS && SPI
+	depends on SPI
 	help
 	  This option enables support for DAC124S085 SPI DAC from NatSemi,
 	  which can be used to control up to four LEDs.
 
 config LEDS_PWM
 	tristate "PWM driven LED Support"
-	depends on LEDS_CLASS && HAVE_PWM
+	depends on HAVE_PWM
 	help
 	  This option enables support for pwm driven LEDs
 
 config LEDS_REGULATOR
 	tristate "REGULATOR driven LED support"
-	depends on LEDS_CLASS && REGULATOR
+	depends on REGULATOR
 	help
 	  This option enables support for regulator driven LEDs.
 
 config LEDS_BD2802
 	tristate "LED driver for BD2802 RGB LED"
-	depends on LEDS_CLASS && I2C
+	depends on I2C
 	help
 	  This option enables support for BD2802GU RGB LED driver chips
 	  accessed via the I2C bus.
 
 config LEDS_INTEL_SS4200
 	tristate "LED driver for Intel NAS SS4200 series"
-	depends on LEDS_CLASS && PCI && DMI
+	depends on PCI && DMI
 	help
 	  This option enables support for the Intel SS4200 series of
 	  Network Attached Storage servers.  You may control the hard
@@ -253,7 +255,7 @@ config LEDS_INTEL_SS4200
 
 config LEDS_LT3593
 	tristate "LED driver for LT3593 controllers"
-	depends on LEDS_CLASS && GENERIC_GPIO
+	depends on GENERIC_GPIO
 	help
 	  This option enables support for LEDs driven by a Linear Technology
 	  LT3593 controller. This controller uses a special one-wire pulse
@@ -261,7 +263,7 @@ config LEDS_LT3593
 
 config LEDS_ADP5520
 	tristate "LED Support for ADP5520/ADP5501 PMIC"
-	depends on LEDS_CLASS && PMIC_ADP5520
+	depends on PMIC_ADP5520
 	help
 	  This option enables support for on-chip LED drivers found
 	  on Analog Devices ADP5520/ADP5501 PMICs.
@@ -269,8 +271,6 @@ config LEDS_ADP5520
 	  To compile this driver as a module, choose M here: the module will
 	  be called leds-adp5520.
 
-comment "LED Triggers"
-
 config LEDS_TRIGGERS
 	bool "LED Trigger support"
 	help
@@ -278,9 +278,12 @@ config LEDS_TRIGGERS
 	  These triggers allow kernel events to drive the LEDs and can
 	  be configured via sysfs. If unsure, say Y.
 
+if LEDS_TRIGGERS
+
+comment "LED Triggers"
+
 config LEDS_TRIGGER_TIMER
 	tristate "LED Timer Trigger"
-	depends on LEDS_TRIGGERS
 	help
 	  This allows LEDs to be controlled by a programmable timer
 	  via sysfs. Some LED hardware can be programmed to start
@@ -291,14 +294,13 @@ config LEDS_TRIGGER_TIMER
 
 config LEDS_TRIGGER_IDE_DISK
 	bool "LED IDE Disk Trigger"
-	depends on LEDS_TRIGGERS && IDE_GD_ATA
+	depends on IDE_GD_ATA
 	help
 	  This allows LEDs to be controlled by IDE disk activity.
 	  If unsure, say Y.
 
 config LEDS_TRIGGER_HEARTBEAT
 	tristate "LED Heartbeat Trigger"
-	depends on LEDS_TRIGGERS
 	help
 	  This allows LEDs to be controlled by a CPU load average.
 	  The flash frequency is a hyperbolic function of the 1-minute
@@ -307,7 +309,6 @@ config LEDS_TRIGGER_HEARTBEAT
 
 config LEDS_TRIGGER_BACKLIGHT
 	tristate "LED backlight Trigger"
-	depends on LEDS_TRIGGERS
 	help
 	  This allows LEDs to be controlled as a backlight device: they
 	  turn off and on when the display is blanked and unblanked.
@@ -316,7 +317,6 @@ config LEDS_TRIGGER_BACKLIGHT
 
 config LEDS_TRIGGER_GPIO
 	tristate "LED GPIO Trigger"
-	depends on LEDS_TRIGGERS
 	depends on GPIOLIB
 	help
 	  This allows LEDs to be controlled by gpio events. It's good
@@ -329,7 +329,6 @@ config LEDS_TRIGGER_GPIO
 
 config LEDS_TRIGGER_DEFAULT_ON
 	tristate "LED Default ON Trigger"
-	depends on LEDS_TRIGGERS
 	help
 	  This allows LEDs to be initialised in the ON state.
 	  If unsure, say Y.
@@ -337,4 +336,8 @@ config LEDS_TRIGGER_DEFAULT_ON
 comment "iptables trigger is under Netfilter config (LED target)"
 	depends on LEDS_TRIGGERS
 
+endif # LEDS_TRIGGERS
+
+endif # LEDS_CLASS
+
 endif # NEW_LEDS
