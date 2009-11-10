Return-Path: <linux-kernel-owner+w=401wt.eu-S1756271AbZKJMm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbZKJMm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 07:42:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755068AbZKJMmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 07:42:25 -0500
Received: from smtp.nokia.com ([192.100.122.233]:52688 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991AbZKJMmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 07:42:21 -0500
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net, daniel@caiaq.de, pavel@ucw.cz
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [PATCH v2 03/10] lis3: Update documentation and comments
Date: Tue, 10 Nov 2009 14:41:05 +0200
Message-Id: <1257856872-11612-4-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1257856872-11612-3-git-send-email-samu.p.onkalo@nokia.com>
References: <1257856872-11612-1-git-send-email-samu.p.onkalo@nokia.com>
 <1257856872-11612-2-git-send-email-samu.p.onkalo@nokia.com>
 <1257856872-11612-3-git-send-email-samu.p.onkalo@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 10 Nov 2009 12:41:25.0109 (UTC) FILETIME=[1D656A50:01CA6203]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Éric Piel <eric.piel@tremplin-utc.net>

Most of the documentation and comments were written when the driver was
only supporting one type of chip, only via ACPI/HP. Update the info to
the much clearer understanding that we have now.

Signed-off-by: Éric Piel <eric.piel@tremplin-utc.net>
---
 Documentation/hwmon/lis3lv02d |   24 ++++++++++++++----------
 drivers/hwmon/Kconfig         |   22 ++++++++++++----------
 drivers/hwmon/lis3lv02d.c     |   20 ++++++++++----------
 drivers/hwmon/lis3lv02d.h     |   28 ++++++++++++++++------------
 4 files changed, 52 insertions(+), 42 deletions(-)

diff --git a/Documentation/hwmon/lis3lv02d b/Documentation/hwmon/lis3lv02d
index effe949..21f0902 100644
--- a/Documentation/hwmon/lis3lv02d
+++ b/Documentation/hwmon/lis3lv02d
@@ -3,7 +3,8 @@ Kernel driver lis3lv02d
 
 Supported chips:
 
-  * STMicroelectronics LIS3LV02DL and LIS3LV02DQ
+  * STMicroelectronics LIS3LV02DL, LIS3LV02DQ (12 bits precision)
+  * STMicroelectronics LIS302DL, LIS3L02DQ, LIS331DL (8 bits)
 
 Authors:
         Yan Burman <burman.yan@gmail.com>
@@ -13,13 +14,12 @@ Authors:
 Description
 -----------
 
-This driver provides support for the accelerometer found in various HP
-laptops sporting the feature officially called "HP Mobile Data
-Protection System 3D" or "HP 3D DriveGuard". It detects automatically
-laptops with this sensor. Known models (for now the HP 2133, nc6420,
-nc2510, nc8510, nc84x0, nw9440 and nx9420) will have their axis
-automatically oriented on standard way (eg: you can directly play
-neverball).  The accelerometer data is readable via
+This driver provides support for the accelerometer found in various HP laptops
+sporting the feature officially called "HP Mobile Data Protection System 3D" or
+"HP 3D DriveGuard". It detects automatically laptops with this sensor. Known
+models (full list can be found in drivers/hwmon/hp_accel.c) will have their
+axis automatically oriented on standard way (eg: you can directly play
+neverball). The accelerometer data is readable via
 /sys/devices/platform/lis3lv02d.
 
 Sysfs attributes under /sys/devices/platform/lis3lv02d/:
@@ -33,12 +33,16 @@ rate - reports the sampling rate of the accelerometer device in HZ
 This driver also provides an absolute input class device, allowing
 the laptop to act as a pinball machine-esque joystick.
 
+On HP laptops, if the led infrastructure is activated, support for a led
+indicating disk protection will be provided as /sys/class/leds/hp::hddprotect.
+
 Another feature of the driver is misc device called "freefall" that
 acts similar to /dev/rtc and reacts on free-fall interrupts received
 from the device. It supports blocking operations, poll/select and
 fasync operation modes. You must read 1 bytes from the device.  The
 result is number of free-fall interrupts since the last successful
-read (or 255 if number of interrupts would not fit).
+read (or 255 if number of interrupts would not fit). See the hpfall.c
+file for an example on using the device.
 
 
 Axes orientation
@@ -55,7 +59,7 @@ the accelerometer are converted into a "standard" organisation of the axes
  * If the laptop is put upside-down, Z becomes negative
 
 If your laptop model is not recognized (cf "dmesg"), you can send an
-email to the authors to add it to the database.  When reporting a new
+email to the maintainer to add it to the database.  When reporting a new
 laptop, please include the output of "dmidecode" plus the value of
 /sys/devices/platform/lis3lv02d/position in these four cases.
 
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 700e93a..a9afb1b 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -1025,25 +1025,27 @@ config SENSORS_ATK0110
 	  will be called asus_atk0110.
 
 config SENSORS_LIS3LV02D
-	tristate "STMicroeletronics LIS3LV02Dx three-axis digital accelerometer"
+	tristate "STMicroeletronics LIS3* three-axis digital accelerometer"
 	depends on INPUT
 	select INPUT_POLLDEV
 	select NEW_LEDS
 	select LEDS_CLASS
 	default n
 	help
-	  This driver provides support for the LIS3LV02Dx accelerometer. In
-	  particular, it can be found in a number of HP laptops, which have the
-	  "Mobile Data Protection System 3D" or "3D DriveGuard" feature. On such
-	  systems the driver should load automatically (via ACPI). The
-	  accelerometer might also be found in other systems, connected via SPI
-	  or I2C.  The accelerometer data is readable via
-	  /sys/devices/platform/lis3lv02d.
+	  This driver provides support for the LIS3* accelerometers, such as the
+	  LIS3LV02DL or the LIS331DL. In particular, it can be found in a number
+	  of HP laptops, which have the "Mobile Data Protection System 3D" or
+	  "3D DriveGuard" feature. On such systems the driver should load
+	  automatically (via ACPI alias). The accelerometer might also be found
+	  in other systems, connected via SPI or I2C. The accelerometer data is
+	  readable via /sys/devices/platform/lis3lv02d.
 
 	  This driver also provides an absolute input class device, allowing
-	  the laptop to act as a pinball machine-esque joystick. On HP laptops,
+	  a laptop to act as a pinball machine-esque joystick. It provides also
+	  a misc device which can be used to detect free-fall. On HP laptops,
 	  if the led infrastructure is activated, support for a led indicating
-	  disk protection will be provided as hp:red:hddprotection.
+	  disk protection will be provided as hp::hddprotect. For more
+	  information on the feature, refer to Documentation/hwmon/lis3lv02d.
 
 	  This driver can also be built as modules.  If so, the core module
 	  will be called lis3lv02d and a specific module for HP laptops will be
diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index dbd0b05..1c8f108 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -43,7 +43,7 @@
 #define MDPS_POLL_INTERVAL 50
 /*
  * The sensor can also generate interrupts (DRDY) but it's pretty pointless
- * because their are generated even if the data do not change. So it's better
+ * because they are generated even if the data do not change. So it's better
  * to keep the interrupt for the free-fall event. The values are updated at
  * 40Hz (at the lowest frequency), but as it can be pretty time consuming on
  * some low processor, we poll the sensor only at 20Hz... enough for the
@@ -65,7 +65,7 @@ static s16 lis3lv02d_read_8(struct lis3lv02d *lis3, int reg)
 	return lo;
 }
 
-static s16 lis3lv02d_read_16(struct lis3lv02d *lis3, int reg)
+static s16 lis3lv02d_read_12(struct lis3lv02d *lis3, int reg)
 {
 	u8 lo, hi;
 
@@ -411,20 +411,20 @@ EXPORT_SYMBOL_GPL(lis3lv02d_remove_fs);
 
 /*
  * Initialise the accelerometer and the various subsystems.
- * Should be rather independant of the bus system.
+ * Should be rather independent of the bus system.
  */
 int lis3lv02d_init_device(struct lis3lv02d *dev)
 {
 	dev->whoami = lis3lv02d_read_8(dev, WHO_AM_I);
 
 	switch (dev->whoami) {
-	case LIS_DOUBLE_ID:
-		printk(KERN_INFO DRIVER_NAME ": 2-byte sensor found\n");
-		dev->read_data = lis3lv02d_read_16;
+	case WAI_12B:
+		printk(KERN_INFO DRIVER_NAME ": 12 bits sensor found\n");
+		dev->read_data = lis3lv02d_read_12;
 		dev->mdps_max_val = 2048;
 		break;
-	case LIS_SINGLE_ID:
-		printk(KERN_INFO DRIVER_NAME ": 1-byte sensor found\n");
+	case WAI_8B:
+		printk(KERN_INFO DRIVER_NAME ": 8 bits sensor found\n");
 		dev->read_data = lis3lv02d_read_8;
 		dev->mdps_max_val = 128;
 		break;
@@ -445,7 +445,7 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 	if (dev->pdata) {
 		struct lis3lv02d_platform_data *p = dev->pdata;
 
-		if (p->click_flags && (dev->whoami == LIS_SINGLE_ID)) {
+		if (p->click_flags && (dev->whoami == WAI_8B)) {
 			dev->write(dev, CLICK_CFG, p->click_flags);
 			dev->write(dev, CLICK_TIMELIMIT, p->click_time_limit);
 			dev->write(dev, CLICK_LATENCY, p->click_latency);
@@ -456,7 +456,7 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 					(p->click_thresh_y << 4));
 		}
 
-		if (p->wakeup_flags && (dev->whoami == LIS_SINGLE_ID)) {
+		if (p->wakeup_flags && (dev->whoami == WAI_8B)) {
 			dev->write(dev, FF_WU_CFG_1, p->wakeup_flags);
 			dev->write(dev, FF_WU_THS_1, p->wakeup_thresh & 0x7f);
 			/* default to 2.5ms for now */
diff --git a/drivers/hwmon/lis3lv02d.h b/drivers/hwmon/lis3lv02d.h
index 3e1ff46..2431c51 100644
--- a/drivers/hwmon/lis3lv02d.h
+++ b/drivers/hwmon/lis3lv02d.h
@@ -2,7 +2,7 @@
  *  lis3lv02d.h - ST LIS3LV02DL accelerometer driver
  *
  *  Copyright (C) 2007-2008 Yan Burman
- *  Copyright (C) 2008 Eric Piel
+ *  Copyright (C) 2008-2009 Eric Piel
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -22,20 +22,18 @@
 #include <linux/input-polldev.h>
 
 /*
- * The actual chip is STMicroelectronics LIS3LV02DL or LIS3LV02DQ that seems to
- * be connected via SPI. There exists also several similar chips (such as LIS302DL or
- * LIS3L02DQ) and they have slightly different registers, but we can provide a
- * common interface for all of them.
- * They can also be connected via I²C.
+ * This driver tries to support the "digital" accelerometer chips from
+ * STMicroelectronics such as LIS3LV02DL, LIS302DL, LIS3L02DQ, LIS331DL,
+ * LIS35DE, or LIS202DL. They are very similar in terms of programming, with
+ * almost the same registers. In addition to differing on physical properties,
+ * they differ on the number of axes (2/3), precision (8/12 bits), and special
+ * features (freefall detection, click...). Unfortunately, not all the
+ * differences can be probed via a register.
+ * They can be connected either via I²C or SPI.
  */
 
 #include <linux/lis3lv02d.h>
 
-/* 2-byte registers */
-#define LIS_DOUBLE_ID	0x3A /* LIS3LV02D[LQ] */
-/* 1-byte registers */
-#define LIS_SINGLE_ID	0x3B /* LIS[32]02DL and others */
-
 enum lis3_reg {
 	WHO_AM_I	= 0x0F,
 	OFFSET_X	= 0x16,
@@ -94,6 +92,12 @@ enum lis3lv02d_reg {
 	DD_THSE_H	= 0x3F,
 };
 
+enum lis3_who_am_i {
+	WAI_12B		= 0x3A, /* 12 bits: LIS3LV02D[LQ]... */
+	WAI_8B		= 0x3B, /* 8 bits: LIS[23]02D[LQ]... */
+	WAI_6B		= 0x52, /* 6 bits: LIS331DLF - not supported */
+};
+
 enum lis3lv02d_ctrl1 {
 	CTRL1_Xen	= 0x01,
 	CTRL1_Yen	= 0x02,
@@ -194,7 +198,7 @@ struct lis3lv02d {
 	int (*write) (struct lis3lv02d *lis3, int reg, u8 val);
 	int (*read) (struct lis3lv02d *lis3, int reg, u8 *ret);
 
-	u8			whoami;    /* 3Ah: 2-byte registries, 3Bh: 1-byte registries */
+	u8			whoami;    /* indicates measurement precision */
 	s16 (*read_data) (struct lis3lv02d *lis3, int reg);
 	int			mdps_max_val;
 
-- 
1.5.6.3

