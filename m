Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab0BIUrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 15:47:20 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:33344 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab0BIUqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 15:46:37 -0500
From: Bill Gatliff <bgat@billgatliff.com>
To: linux-embedded@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bill Gatliff <bgat@billgatliff.com>
Subject: [PWM PATCH 6/7] Incorporate PWM API code into KBuild
Date: Tue,  9 Feb 2010 14:46:33 -0600
Message-Id: <1b70ab4f8fdfc90eea12d6570be347f990abc8a9.1265748264.git.bgat@billgatliff.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <e5f3ecb7c7220a75184525a71ca668f91e5667c7.1265748264.git.bgat@billgatliff.com>
References: <cover.1265748263.git.bgat@billgatliff.com>
 <b7afd475c3fce08f459bceff7814de57ffce7bd0.1265748264.git.bgat@billgatliff.com>
 <7178097a5a8af15f61656f11b6bef68b0da71498.1265748264.git.bgat@billgatliff.com>
 <6ba8043e7749806f88b685ecd5ad7c4e1062bc91.1265748264.git.bgat@billgatliff.com>
 <0b1e9d2f93d366f003348f4d31fdfbf8da4594b2.1265748264.git.bgat@billgatliff.com>
 <e5f3ecb7c7220a75184525a71ca668f91e5667c7.1265748264.git.bgat@billgatliff.com>
In-Reply-To: <cover.1265748263.git.bgat@billgatliff.com>
References: <cover.1265748263.git.bgat@billgatliff.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bill Gatliff <bgat@billgatliff.com>
---
 drivers/Kconfig       |    2 ++
 drivers/Makefile      |    2 ++
 drivers/leds/Kconfig  |   33 +++++++++++++++++++++------------
 drivers/leds/Makefile |    2 ++
 drivers/pwm/Kconfig   |   31 +++++++++++++++++++++++++++++++
 drivers/pwm/Makefile  |    6 ++++++
 6 files changed, 64 insertions(+), 12 deletions(-)
 create mode 100644 drivers/pwm/Kconfig
 create mode 100644 drivers/pwm/Makefile

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 368ae6d..54d7b16 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -54,6 +54,8 @@ source "drivers/pps/Kconfig"
 
 source "drivers/gpio/Kconfig"
 
+source "drivers/pwm/Kconfig"
+
 source "drivers/w1/Kconfig"
 
 source "drivers/power/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index 6ee53c7..e6143f3 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -6,6 +6,8 @@
 #
 
 obj-y				+= gpio/
+obj-$(CONFIG_GENERIC_PWM)	+= pwm/
+
 obj-$(CONFIG_PCI)		+= pci/
 obj-$(CONFIG_PARISC)		+= parisc/
 obj-$(CONFIG_RAPIDIO)		+= rapidio/
diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 8a0e1ec..d9547d4 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -17,12 +17,11 @@ config LEDS_CLASS
 
 comment "LED drivers"
 
-config LEDS_ATMEL_PWM
-	tristate "LED Support using Atmel PWM outputs"
-	depends on LEDS_CLASS && ATMEL_PWM
-	help
-	  This option enables support for LEDs driven using outputs
-	  of the dedicated PWM controller found on newer Atmel SOCs.
+config LEDS_PWM
+       tristate "LED Support for PWM connected LEDs"
+       depends on LEDS_CLASS && GENERIC_PWM
+       help
+         Enables support for LEDs connected to PWM outputs.
 
 config LEDS_LOCOMO
 	tristate "LED Support for Locomo device"
@@ -223,12 +222,6 @@ config LEDS_DAC124S085
 	  This option enables support for DAC124S085 SPI DAC from NatSemi,
 	  which can be used to control up to four LEDs.
 
-config LEDS_PWM
-	tristate "PWM driven LED Support"
-	depends on LEDS_CLASS && HAVE_PWM
-	help
-	  This option enables support for pwm driven LEDs
-
 config LEDS_REGULATOR
 	tristate "REGULATOR driven LED support"
 	depends on LEDS_CLASS && REGULATOR
@@ -305,6 +298,14 @@ config LEDS_TRIGGER_HEARTBEAT
 	  load average.
 	  If unsure, say Y.
 
+config LEDS_TRIGGER_DIM
+	tristate "LED Dimmer Trigger"
+	depends on LEDS_TRIGGERS
+	help
+	  Regulates the brightness of an LED based on the 1-minute CPU
+	  load average. Ideal for PWM-driven LEDs.
+	  If unsure, say Y.
+
 config LEDS_TRIGGER_BACKLIGHT
 	tristate "LED backlight Trigger"
 	depends on LEDS_TRIGGERS
@@ -327,6 +328,14 @@ config LEDS_TRIGGER_GPIO
 
 	  If unsure, say N.
 
+config LEDS_TRIGGER_DIM
+       tristate "LED Dimmer Trigger"
+       depends on LEDS_TRIGGERS
+       help
+         Regulates the brightness of an LED based on the 1-minute CPU
+         load average.  Ideal for PWM-driven LEDs.
+         If unsure, say Y.
+
 config LEDS_TRIGGER_DEFAULT_ON
 	tristate "LED Default ON Trigger"
 	depends on LEDS_TRIGGERS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 9e63869..9b4971e 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_LEDS_COBALT_RAQ)		+= leds-cobalt-raq.o
 obj-$(CONFIG_LEDS_SUNFIRE)		+= leds-sunfire.o
 obj-$(CONFIG_LEDS_PCA9532)		+= leds-pca9532.o
 obj-$(CONFIG_LEDS_GPIO)			+= leds-gpio.o
+obj-$(CONFIG_LEDS_PWM)			+= leds-pwm.o
 obj-$(CONFIG_LEDS_LP3944)		+= leds-lp3944.o
 obj-$(CONFIG_LEDS_CLEVO_MAIL)		+= leds-clevo-mail.o
 obj-$(CONFIG_LEDS_HP6XX)		+= leds-hp6xx.o
@@ -41,6 +42,7 @@ obj-$(CONFIG_LEDS_DAC124S085)		+= leds-dac124s085.o
 obj-$(CONFIG_LEDS_TRIGGER_TIMER)	+= ledtrig-timer.o
 obj-$(CONFIG_LEDS_TRIGGER_IDE_DISK)	+= ledtrig-ide-disk.o
 obj-$(CONFIG_LEDS_TRIGGER_HEARTBEAT)	+= ledtrig-heartbeat.o
+obj-$(CONFIG_LEDS_TRIGGER_DIM)		+= ledtrig-dim.o
 obj-$(CONFIG_LEDS_TRIGGER_BACKLIGHT)	+= ledtrig-backlight.o
 obj-$(CONFIG_LEDS_TRIGGER_GPIO)		+= ledtrig-gpio.o
 obj-$(CONFIG_LEDS_TRIGGER_DEFAULT_ON)	+= ledtrig-default-on.o
diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
new file mode 100644
index 0000000..1c24e11
--- /dev/null
+++ b/drivers/pwm/Kconfig
@@ -0,0 +1,31 @@
+#
+# PWM infrastructure and devices
+#
+
+menuconfig GENERIC_PWM
+	tristate "PWM Support"
+	depends on SYSFS
+	help
+	  This enables PWM support through the generic PWM library.
+	  If unsure, say N.
+
+if GENERIC_PWM
+
+config ATMEL_PWM
+	tristate "Atmel AT32/AT91 PWM support"
+	depends on AVR32 || ARCH_AT91
+	help
+	  This option enables device driver support for the PWMC
+	  peripheral channels found on certain Atmel processors.
+	  Pulse Width Modulation is used many for purposes, including
+	  software controlled power-efficient backlights on LCD
+	  displays, motor control, and waveform generation.  If
+	  unsure, say N.
+
+config GPIO_PWM
+       tristate "PWM emulation using GPIO"
+       help
+         This option enables a single-channel PWM device using
+	 a kernel interval timer and a GPIO pin.  If unsure, say N.
+
+endif
diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
new file mode 100644
index 0000000..e8cacc5
--- /dev/null
+++ b/drivers/pwm/Makefile
@@ -0,0 +1,6 @@
+#
+# Makefile for pwm devices
+#
+obj-y := pwm.o
+obj-$(CONFIG_ATMEL_PWM)		+= atmel-pwm.o
+obj-$(CONFIG_GPIO_PWM)		+= gpio.o
-- 
1.6.5

