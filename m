Return-Path: <linux-kernel-owner+w=401wt.eu-S1030994AbXD3Lao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030994AbXD3Lao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031067AbXD3Lao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:30:44 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:33718 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030994AbXD3LaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:30:16 -0400
Date: Mon, 30 Apr 2007 13:28:29 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Jean Delvare <khali@linux-fr.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org
Subject: [PATCH 08/36] Use menuconfig objects II - hwmon
In-Reply-To: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704301327500.29151@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	0.0 UPPERCASE_25_50        message body is 25-50% uppercase
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Change Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to
enter the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 drivers/hwmon/Kconfig |  109 ++++++++++++++++++++++++--------------------------
 1 file changed, 53 insertions(+), 56 deletions(-)

--- linux-2.6.21-mm_20070428.orig/drivers/hwmon/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/hwmon/Kconfig
@@ -2,9 +2,7 @@
 # Hardware monitoring chip drivers configuration
 #
 
-menu "Hardware Monitoring support"
-
-config HWMON
+menuconfig HWMON
 	tristate "Hardware Monitoring support"
 	default y
 	help
@@ -23,13 +21,15 @@ config HWMON
 	  This support can also be built as a module.  If so, the module
 	  will be called hwmon.
 
+if HWMON
+
 config HWMON_VID
 	tristate
 	default n
 
 config SENSORS_ABITUGURU
 	tristate "Abit uGuru"
-	depends on HWMON && EXPERIMENTAL
+	depends on EXPERIMENTAL
 	help
 	  If you say yes here you get support for the Abit uGuru chips
 	  sensor part. The voltage and frequency control parts of the Abit
@@ -41,7 +41,7 @@ config SENSORS_ABITUGURU
 
 config SENSORS_AD7418
 	tristate "Analog Devices AD7416, AD7417 and AD7418"
-	depends on HWMON && I2C && EXPERIMENTAL
+	depends on I2C && EXPERIMENTAL
 	help
 	  If you say yes here you get support for the Analog Devices
 	  AD7416, AD7417 and AD7418 temperature monitoring chips.
@@ -51,7 +51,7 @@ config SENSORS_AD7418
 
 config SENSORS_ADM1021
 	tristate "Analog Devices ADM1021 and compatibles"
-	depends on HWMON && I2C
+	depends on I2C
 	help
 	  If you say yes here you get support for Analog Devices ADM1021
 	  and ADM1023 sensor chips and clones: Maxim MAX1617 and MAX1617A,
@@ -63,7 +63,7 @@ config SENSORS_ADM1021
 
 config SENSORS_ADM1025
 	tristate "Analog Devices ADM1025 and compatibles"
-	depends on HWMON && I2C
+	depends on I2C
 	select HWMON_VID
 	help
 	  If you say yes here you get support for Analog Devices ADM1025
@@ -74,7 +74,7 @@ config SENSORS_ADM1025
 
 config SENSORS_ADM1026
 	tristate "Analog Devices ADM1026 and compatibles"
-	depends on HWMON && I2C && EXPERIMENTAL
+	depends on I2C && EXPERIMENTAL
 	select HWMON_VID
 	help
 	  If you say yes here you get support for Analog Devices ADM1026
@@ -85,7 +85,7 @@ config SENSORS_ADM1026
 
 config SENSORS_ADM1029
 	tristate "Analog Devices ADM1029"
-	depends on HWMON && I2C && EXPERIMENTAL
+	depends on I2C && EXPERIMENTAL
 	help
 	  If you say yes here you get support for Analog Devices ADM1029
 	  sensor chip.
@@ -96,7 +96,7 @@ config SENSORS_ADM1029
 
 config SENSORS_ADM1031
 	tristate "Analog Devices ADM1031 and compatibles"
-	depends on HWMON && I2C && EXPERIMENTAL
+	depends on I2C && EXPERIMENTAL
 	help
 	  If you say yes here you get support for Analog Devices ADM1031
 	  and ADM1030 sensor chips.
@@ -106,7 +106,7 @@ config SENSORS_ADM1031
 
 config SENSORS_ADM9240
 	tristate "Analog Devices ADM9240 and compatibles"
-	depends on HWMON && I2C && EXPERIMENTAL
+	depends on I2C && EXPERIMENTAL
 	select HWMON_VID
 	help
 	  If you say yes here you get support for Analog Devices ADM9240,
@@ -117,7 +117,7 @@ config SENSORS_ADM9240
 
 config SENSORS_K8TEMP
 	tristate "AMD Athlon64/FX or Opteron temperature sensor"
-	depends on HWMON && X86 && PCI && EXPERIMENTAL
+	depends on X86 && PCI && EXPERIMENTAL
 	help
 	  If you say yes here you get support for the temperature
 	  sensor(s) inside your CPU. Supported is whole AMD K8
@@ -129,7 +129,7 @@ config SENSORS_K8TEMP
 
 config SENSORS_AMS
 	tristate "Apple Motion Sensor driver"
-	depends on HWMON && PPC_PMAC && !PPC64 && INPUT && ((ADB_PMU && I2C = y) || (ADB_PMU && !I2C) || I2C) && EXPERIMENTAL
+	depends on PPC_PMAC && !PPC64 && INPUT && ((ADB_PMU && I2C = y) || (ADB_PMU && !I2C) || I2C) && EXPERIMENTAL
 	help
 	  Support for the motion sensor included in PowerBooks. Includes
 	  implementations for PMU and I2C.
@@ -154,7 +154,7 @@ config SENSORS_AMS_I2C
 
 config SENSORS_ASB100
 	tristate "Asus ASB100 Bach"
-	depends on HWMON && I2C && EXPERIMENTAL
+	depends on I2C && EXPERIMENTAL
 	select HWMON_VID
 	help
 	  If you say yes here you get support for the ASB100 Bach sensor
@@ -165,7 +165,7 @@ config SENSORS_ASB100
 
 config SENSORS_ATXP1
 	tristate "Attansic ATXP1 VID controller"
-	depends on HWMON && I2C && EXPERIMENTAL
+	depends on I2C && EXPERIMENTAL
 	select HWMON_VID
 	help
 	  If you say yes here you get support for the Attansic ATXP1 VID
@@ -179,7 +179,7 @@ config SENSORS_ATXP1
 
 config SENSORS_DS1621
 	tristate "Dallas Semiconductor DS1621 and DS1625"
-	depends on HWMON && I2C
+	depends on I2C
 	help
 	  If you say yes here you get support for Dallas Semiconductor
 	  DS1621 and DS1625 sensor chips.
@@ -189,7 +189,7 @@ config SENSORS_DS1621
 
 config SENSORS_F71805F
 	tristate "Fintek F71805F/FG and F71872F/FG"
-	depends on HWMON && EXPERIMENTAL
+	depends on EXPERIMENTAL
 	help
 	  If you say yes here you get support for hardware monitoring
 	  features of the Fintek F71805F/FG and F71872F/FG Super-I/O
@@ -200,7 +200,7 @@ config SENSORS_F71805F
 
 config SENSORS_FSCHER
 	tristate "FSC Hermes"
-	depends on HWMON && I2C
+	depends on I2C
 	help
 	  If you say yes here you get support for Fujitsu Siemens
 	  Computers Hermes sensor chips.
@@ -210,7 +210,7 @@ config SENSORS_FSCHER
 
 config SENSORS_FSCPOS
 	tristate "FSC Poseidon"
-	depends on HWMON && I2C
+	depends on I2C
 	help
 	  If you say yes here you get support for Fujitsu Siemens
 	  Computers Poseidon sensor chips.
@@ -220,7 +220,7 @@ config SENSORS_FSCPOS
 
 config SENSORS_GL518SM
 	tristate "Genesys Logic GL518SM"
-	depends on HWMON && I2C
+	depends on I2C
 	help
 	  If you say yes here you get support for Genesys Logic GL518SM
 	  sensor chips.
@@ -230,7 +230,7 @@ config SENSORS_GL518SM
 
 config SENSORS_GL520SM
 	tristate "Genesys Logic GL520SM"
-	depends on HWMON && I2C
+	depends on I2C
 	select HWMON_VID
 	help
 	  If you say yes here you get support for Genesys Logic GL520SM
@@ -241,7 +241,7 @@ config SENSORS_GL520SM
 
 config SENSORS_CORETEMP
 	tristate "Intel Core (2) Duo/Solo temperature sensor"
-	depends on HWMON && X86 && EXPERIMENTAL
+	depends on X86 && EXPERIMENTAL
 	help
 	  If you say yes here you get support for the temperature
 	  sensor inside your CPU. Supported all are all known variants
@@ -249,7 +249,7 @@ config SENSORS_CORETEMP
 
 config SENSORS_IT87
 	tristate "ITE IT87xx and compatibles"
-	depends on HWMON && I2C
+	depends on I2C
 	select I2C_ISA
 	select HWMON_VID
 	help
@@ -261,7 +261,7 @@ config SENSORS_IT87
 
 config SENSORS_LM63
 	tristate "National Semiconductor LM63"
-	depends on HWMON && I2C
+	depends on I2C
 	help
 	  If you say yes here you get support for the National Semiconductor
 	  LM63 remote diode digital temperature sensor with integrated fan
@@ -273,7 +273,7 @@ config SENSORS_LM63
 
 config SENSORS_LM70
 	tristate "National Semiconductor LM70"
-	depends on HWMON && SPI_MASTER && EXPERIMENTAL
+	depends on SPI_MASTER && EXPERIMENTAL
 	help
 	  If you say yes here you get support for the National Semiconductor
 	  LM70 digital temperature sensor chip.
@@ -283,7 +283,7 @@ config SENSORS_LM70
 
 config SENSORS_LM75
 	tristate "National Semiconductor LM75 and compatibles"
-	depends on HWMON && I2C
+	depends on I2C
 	help
 	  If you say yes here you get support for National Semiconductor LM75
 	  sensor chips and clones: Dallas Semiconductor DS75 and DS1775 (in
@@ -298,7 +298,7 @@ config SENSORS_LM75
 
 config SENSORS_LM77
 	tristate "National Semiconductor LM77"
-	depends on HWMON && I2C
+	depends on I2C
 	help
 	  If you say yes here you get support for National Semiconductor LM77
 	  sensor chips.
@@ -308,7 +308,7 @@ config SENSORS_LM77
 
 config SENSORS_LM78
 	tristate "National Semiconductor LM78 and compatibles"
-	depends on HWMON && I2C
+	depends on I2C
 	select HWMON_VID
 	help
 	  If you say yes here you get support for National Semiconductor LM78,
@@ -319,7 +319,7 @@ config SENSORS_LM78
 
 config SENSORS_LM80
 	tristate "National Semiconductor LM80"
-	depends on HWMON && I2C && EXPERIMENTAL
+	depends on I2C && EXPERIMENTAL
 	help
 	  If you say yes here you get support for National Semiconductor
 	  LM80 sensor chips.
@@ -329,7 +329,7 @@ config SENSORS_LM80
 
 config SENSORS_LM83
 	tristate "National Semiconductor LM83 and compatibles"
-	depends on HWMON && I2C
+	depends on I2C
 	help
 	  If you say yes here you get support for National Semiconductor
 	  LM82 and LM83 sensor chips.
@@ -339,7 +339,7 @@ config SENSORS_LM83
 
 config SENSORS_LM85
 	tristate "National Semiconductor LM85 and compatibles"
-	depends on HWMON && I2C && EXPERIMENTAL
+	depends on I2C && EXPERIMENTAL
 	select HWMON_VID
 	help
 	  If you say yes here you get support for National Semiconductor LM85
@@ -350,7 +350,7 @@ config SENSORS_LM85
 
 config SENSORS_LM87
 	tristate "National Semiconductor LM87"
-	depends on HWMON && I2C
+	depends on I2C
 	select HWMON_VID
 	help
 	  If you say yes here you get support for National Semiconductor LM87
@@ -361,7 +361,7 @@ config SENSORS_LM87
 
 config SENSORS_LM90
 	tristate "National Semiconductor LM90 and compatibles"
-	depends on HWMON && I2C
+	depends on I2C
 	help
 	  If you say yes here you get support for National Semiconductor LM90,
 	  LM86, LM89 and LM99, Analog Devices ADM1032 and Maxim MAX6657 and
@@ -375,7 +375,7 @@ config SENSORS_LM90
 
 config SENSORS_LM92
 	tristate "National Semiconductor LM92 and compatibles"
-	depends on HWMON && I2C
+	depends on I2C
 	help
 	  If you say yes here you get support for National Semiconductor LM92
 	  and Maxim MAX6635 sensor chips.
@@ -385,7 +385,7 @@ config SENSORS_LM92
 
 config SENSORS_MAX1619
 	tristate "Maxim MAX1619 sensor chip"
-	depends on HWMON && I2C
+	depends on I2C
 	help
 	  If you say yes here you get support for MAX1619 sensor chip.
 
@@ -394,7 +394,7 @@ config SENSORS_MAX1619
 
 config SENSORS_MAX6650
 	tristate "Maxim MAX6650 sensor chip"
-	depends on HWMON && I2C && EXPERIMENTAL
+	depends on I2C && EXPERIMENTAL
 	help
 	  If you say yes here you get support for the MAX6650 / MAX6651
 	  sensor chips.
@@ -404,7 +404,7 @@ config SENSORS_MAX6650
 
 config SENSORS_PC87360
 	tristate "National Semiconductor PC87360 family"
-	depends on HWMON && I2C && EXPERIMENTAL
+	depends on I2C && EXPERIMENTAL
 	select I2C_ISA
 	select HWMON_VID
 	help
@@ -419,7 +419,7 @@ config SENSORS_PC87360
 
 config SENSORS_PC87427
 	tristate "National Semiconductor PC87427"
-	depends on HWMON && EXPERIMENTAL
+	depends on EXPERIMENTAL
 	help
 	  If you say yes here you get access to the hardware monitoring
 	  functions of the National Semiconductor PC87427 Super-I/O chip.
@@ -432,7 +432,7 @@ config SENSORS_PC87427
 
 config SENSORS_SIS5595
 	tristate "Silicon Integrated Systems Corp. SiS5595"
-	depends on HWMON && I2C && PCI && EXPERIMENTAL
+	depends on I2C && PCI && EXPERIMENTAL
 	select I2C_ISA
 	help
 	  If you say yes here you get support for the integrated sensors in
@@ -443,7 +443,6 @@ config SENSORS_SIS5595
 
 config SENSORS_SMSC47M1
 	tristate "SMSC LPC47M10x and compatibles"
-	depends on HWMON
 	help
 	  If you say yes here you get support for the integrated fan
 	  monitoring and control capabilities of the SMSC LPC47B27x,
@@ -460,7 +459,7 @@ config SENSORS_SMSC47M1
 
 config SENSORS_SMSC47M192
 	tristate "SMSC LPC47M192 and compatibles"
-	depends on HWMON && I2C && EXPERIMENTAL
+	depends on I2C && EXPERIMENTAL
 	select HWMON_VID
 	help
 	  If you say yes here you get support for the temperature and
@@ -477,7 +476,7 @@ config SENSORS_SMSC47M192
 
 config SENSORS_SMSC47B397
 	tristate "SMSC LPC47B397-NC"
-	depends on HWMON && EXPERIMENTAL
+	depends on EXPERIMENTAL
 	help
 	  If you say yes here you get support for the SMSC LPC47B397-NC
 	  sensor chip.
@@ -487,7 +486,7 @@ config SENSORS_SMSC47B397
 
 config SENSORS_VIA686A
 	tristate "VIA686A"
-	depends on HWMON && I2C && PCI
+	depends on I2C && PCI
 	select I2C_ISA
 	help
 	  If you say yes here you get support for the integrated sensors in
@@ -498,7 +497,7 @@ config SENSORS_VIA686A
 
 config SENSORS_VT1211
 	tristate "VIA VT1211"
-	depends on HWMON && EXPERIMENTAL
+	depends on EXPERIMENTAL
 	select HWMON_VID
 	help
 	  If you say yes here then you get support for hardware monitoring
@@ -509,7 +508,7 @@ config SENSORS_VT1211
 
 config SENSORS_VT8231
 	tristate "VIA VT8231"
-	depends on HWMON && I2C && PCI && EXPERIMENTAL
+	depends on I2C && PCI && EXPERIMENTAL
 	select HWMON_VID
 	select I2C_ISA
 	help
@@ -521,7 +520,7 @@ config SENSORS_VT8231
 
 config SENSORS_W83781D
 	tristate "Winbond W83781D, W83782D, W83783S, W83627HF, Asus AS99127F"
-	depends on HWMON && I2C
+	depends on I2C
 	select HWMON_VID
 	help
 	  If you say yes here you get support for the Winbond W8378x series
@@ -533,7 +532,7 @@ config SENSORS_W83781D
 
 config SENSORS_W83791D
 	tristate "Winbond W83791D"
-	depends on HWMON && I2C && EXPERIMENTAL
+	depends on I2C && EXPERIMENTAL
 	select HWMON_VID
 	help
 	  If you say yes here you get support for the Winbond W83791D chip.
@@ -543,7 +542,7 @@ config SENSORS_W83791D
 
 config SENSORS_W83792D
 	tristate "Winbond W83792D"
-	depends on HWMON && I2C && EXPERIMENTAL
+	depends on I2C && EXPERIMENTAL
 	help
 	  If you say yes here you get support for the Winbond W83792D chip.
 
@@ -552,7 +551,7 @@ config SENSORS_W83792D
 
 config SENSORS_W83793
 	tristate "Winbond W83793"
-	depends on HWMON && I2C && EXPERIMENTAL
+	depends on I2C && EXPERIMENTAL
 	select HWMON_VID
 	help
 	  If you say yes here you get support for the Winbond W83793
@@ -563,7 +562,7 @@ config SENSORS_W83793
 
 config SENSORS_W83L785TS
 	tristate "Winbond W83L785TS-S"
-	depends on HWMON && I2C && EXPERIMENTAL
+	depends on I2C && EXPERIMENTAL
 	help
 	  If you say yes here you get support for the Winbond W83L785TS-S
 	  sensor chip, which is used on the Asus A7N8X, among other
@@ -574,7 +573,6 @@ config SENSORS_W83L785TS
 
 config SENSORS_W83627HF
 	tristate "Winbond W83627HF, W83627THF, W83637HF, W83687THF, W83697HF"
-	depends on HWMON
 	select HWMON_VID
 	help
 	  If you say yes here you get support for the Winbond W836X7 series
@@ -586,7 +584,7 @@ config SENSORS_W83627HF
 
 config SENSORS_W83627EHF
 	tristate "Winbond W83627EHF"
-	depends on HWMON && I2C && EXPERIMENTAL
+	depends on I2C && EXPERIMENTAL
 	select I2C_ISA
 	help
 	  If you say yes here you get preliminary support for the hardware
@@ -602,7 +600,7 @@ config SENSORS_W83627EHF
 
 config SENSORS_HDAPS
 	tristate "IBM Hard Drive Active Protection System (hdaps)"
-	depends on HWMON && INPUT && X86
+	depends on INPUT && X86
 	default n
 	help
 	  This driver provides support for the IBM Hard Drive Active Protection
@@ -621,7 +619,7 @@ config SENSORS_HDAPS
 
 config SENSORS_APPLESMC
 	tristate "Apple SMC (Motion sensor, light sensor, keyboard backlight)"
-	depends on HWMON && INPUT && X86
+	depends on INPUT && X86
 	select NEW_LEDS
 	select LEDS_CLASS
 	default n
@@ -645,7 +643,6 @@ config SENSORS_APPLESMC
 
 config HWMON_DEBUG_CHIP
 	bool "Hardware Monitoring Chip debugging messages"
-	depends on HWMON
 	default n
 	help
 	  Say Y here if you want the I2C chip drivers to produce a bunch of
@@ -653,4 +650,4 @@ config HWMON_DEBUG_CHIP
 	  a problem with I2C support and want to see more of what is going
 	  on.
 
-endmenu
+endif # HWMON
