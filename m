Return-Path: <linux-kernel-owner+w=401wt.eu-S1753780AbZGTNb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbZGTNb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 09:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbZGTNby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 09:31:54 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45829 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753723AbZGTNbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 09:31:53 -0400
From: balajitk@ti.com
To: linux-kernel@vger.kernel.org
Cc: tony@atomide.com, khilman@deeprootsystems.com, david-b@pacbell.net,
       linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
       sameo@openedhand.com, wim@iguana.be, timo.t.kokkonen@nokia.com,
       ben-linux@fluff.org, lrg@slimlogic.co.uk,
       broonie@opensource.wolfsonmicro.com,
       Santosh Shilimkar <santosh.shilimkar@ti.com>,
       Rajendra Nayak <rnayak@ti.com>, Balaji T K <balajitk@ti.com>
Subject: [PATCH 1/4] ARM: OMAP: Rename twl4030* driver files to enable re-use
Date: Mon, 20 Jul 2009 19:01:11 +0530
Message-Id: <1248096671-13828-1-git-send-email-balajitk@ti.com>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santosh Shilimkar <santosh.shilimkar@ti.com>

The upcoming TWL6030 is companion chip for OMAP4 like the current TWL4030
for OMAP3. The common modules like RTC, Regulator creates opportunity
to re-use the most of the code from twl4030.

This patch renames few common drivers twl4030* files to twl* to enable
the code re-use.

Signed-off-by: Rajendra Nayak <rnayak@ti.com>
Signed-off-by: Balaji T K <balajitk@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 arch/arm/mach-omap2/board-2430sdp.c                |    2 +-
 arch/arm/mach-omap2/board-3430sdp.c                |    2 +-
 arch/arm/mach-omap2/board-ldp.c                    |    2 +-
 arch/arm/mach-omap2/board-omap3beagle.c            |    2 +-
 arch/arm/mach-omap2/board-omap3pandora.c           |    2 +-
 arch/arm/mach-omap2/board-overo.c                  |    2 +-
 drivers/gpio/twl4030-gpio.c                        |    2 +-
 drivers/mfd/Makefile                               |    2 +-
 drivers/mfd/{twl4030-core.c => twl-core.c}         |    8 +++-----
 drivers/mfd/twl4030-irq.c                          |    2 +-
 drivers/regulator/Makefile                         |    2 +-
 .../{twl4030-regulator.c => twl-regulator.c}       |    6 +++---
 drivers/rtc/Makefile                               |    2 +-
 drivers/rtc/{rtc-twl4030.c => rtc-twl.c}           |    2 +-
 drivers/usb/otg/twl4030-usb.c                      |    2 +-
 include/linux/i2c/{twl4030.h => twl.h}             |    5 ++++-
 sound/soc/codecs/twl4030.c                         |    2 +-
 17 files changed, 24 insertions(+), 23 deletions(-)
 rename drivers/mfd/{twl4030-core.c => twl-core.c} (99%)
 rename drivers/regulator/{twl4030-regulator.c => twl-regulator.c} (99%)
 rename drivers/rtc/{rtc-twl4030.c => rtc-twl.c} (99%)
 rename include/linux/i2c/{twl4030.h => twl.h} (98%)

diff --git a/arch/arm/mach-omap2/board-2430sdp.c b/arch/arm/mach-omap2/board-2430sdp.c
index 9c3fdcd..7f5aac5 100644
--- a/arch/arm/mach-omap2/board-2430sdp.c
+++ b/arch/arm/mach-omap2/board-2430sdp.c
@@ -19,7 +19,7 @@
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
 #include <linux/delay.h>
-#include <linux/i2c/twl4030.h>
+#include <linux/i2c/twl.h>
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/io.h>
diff --git a/arch/arm/mach-omap2/board-3430sdp.c b/arch/arm/mach-omap2/board-3430sdp.c
index 496a90e..fa6645e 100644
--- a/arch/arm/mach-omap2/board-3430sdp.c
+++ b/arch/arm/mach-omap2/board-3430sdp.c
@@ -19,7 +19,7 @@
 #include <linux/input.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/ads7846.h>
-#include <linux/i2c/twl4030.h>
+#include <linux/i2c/twl.h>
 #include <linux/regulator/machine.h>
 #include <linux/io.h>
 #include <linux/gpio.h>
diff --git a/arch/arm/mach-omap2/board-ldp.c b/arch/arm/mach-omap2/board-ldp.c
index d8bc0a7..cf8244a 100644
--- a/arch/arm/mach-omap2/board-ldp.c
+++ b/arch/arm/mach-omap2/board-ldp.c
@@ -23,7 +23,7 @@
 #include <linux/spi/spi.h>
 #include <linux/spi/ads7846.h>
 #include <linux/regulator/machine.h>
-#include <linux/i2c/twl4030.h>
+#include <linux/i2c/twl.h>
 #include <linux/io.h>
 #include <linux/smsc911x.h>
 
diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index 991ac9c..455f65d 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -29,7 +29,7 @@
 #include <linux/mtd/nand.h>
 
 #include <linux/regulator/machine.h>
-#include <linux/i2c/twl4030.h>
+#include <linux/i2c/twl.h>
 
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
diff --git a/arch/arm/mach-omap2/board-omap3pandora.c b/arch/arm/mach-omap2/board-omap3pandora.c
index e32aa23..47b5ee4 100644
--- a/arch/arm/mach-omap2/board-omap3pandora.c
+++ b/arch/arm/mach-omap2/board-omap3pandora.c
@@ -24,7 +24,7 @@
 #include <linux/spi/spi.h>
 #include <linux/spi/ads7846.h>
 #include <linux/regulator/machine.h>
-#include <linux/i2c/twl4030.h>
+#include <linux/i2c/twl.h>
 #include <linux/leds.h>
 #include <linux/input.h>
 #include <linux/gpio_keys.h>
diff --git a/arch/arm/mach-omap2/board-overo.c b/arch/arm/mach-omap2/board-overo.c
index dff5528..744ff80 100644
--- a/arch/arm/mach-omap2/board-overo.c
+++ b/arch/arm/mach-omap2/board-overo.c
@@ -26,7 +26,7 @@
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
-#include <linux/i2c/twl4030.h>
+#include <linux/i2c/twl.h>
 #include <linux/regulator/machine.h>
 
 #include <linux/mtd/mtd.h>
diff --git a/drivers/gpio/twl4030-gpio.c b/drivers/gpio/twl4030-gpio.c
index afad147..8446399 100644
--- a/drivers/gpio/twl4030-gpio.c
+++ b/drivers/gpio/twl4030-gpio.c
@@ -34,7 +34,7 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 
-#include <linux/i2c/twl4030.h>
+#include <linux/i2c/twl.h>
 
 
 /*
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 6f8a9a1..4e9d513 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -22,7 +22,7 @@ obj-$(CONFIG_MFD_WM8350_I2C)	+= wm8350-i2c.o
 obj-$(CONFIG_TPS65010)		+= tps65010.o
 obj-$(CONFIG_MENELAUS)		+= menelaus.o
 
-obj-$(CONFIG_TWL4030_CORE)	+= twl4030-core.o twl4030-irq.o
+obj-$(CONFIG_TWL4030_CORE)	+= twl-core.o twl4030-irq.o
 
 obj-$(CONFIG_MFD_CORE)		+= mfd-core.o
 
diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl-core.c
similarity index 99%
rename from drivers/mfd/twl4030-core.c
rename to drivers/mfd/twl-core.c
index ca54996..97eb9a0 100644
--- a/drivers/mfd/twl4030-core.c
+++ b/drivers/mfd/twl-core.c
@@ -36,7 +36,7 @@
 #include <linux/regulator/machine.h>
 
 #include <linux/i2c.h>
-#include <linux/i2c/twl4030.h>
+#include <linux/i2c/twl.h>
 
 #if defined(CONFIG_ARCH_OMAP2) || defined(CONFIG_ARCH_OMAP3)
 #include <mach/cpu.h>
@@ -717,9 +717,6 @@ static void clocks_init(struct device *dev)
 
 /*----------------------------------------------------------------------*/
 
-int twl_init_irq(int irq_num, unsigned irq_base, unsigned irq_end);
-int twl_exit_irq(void);
-
 static int twl4030_remove(struct i2c_client *client)
 {
 	unsigned i;
@@ -792,7 +789,8 @@ twl4030_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	if (client->irq
 			&& pdata->irq_base
 			&& pdata->irq_end > pdata->irq_base) {
-		status = twl_init_irq(client->irq, pdata->irq_base, pdata->irq_end);
+		status = twl_init_irq(client->irq, pdata->irq_base,
+			 pdata->irq_end);
 		if (status < 0)
 			goto fail;
 	}
diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index bae61b2..6827e8f 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -32,7 +32,7 @@
 #include <linux/irq.h>
 #include <linux/kthread.h>
 
-#include <linux/i2c/twl4030.h>
+#include <linux/i2c/twl.h>
 
 
 /*
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 4d762c4..0653ce8 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -11,7 +11,7 @@ obj-$(CONFIG_REGULATOR_USERSPACE_CONSUMER) += userspace-consumer.o
 obj-$(CONFIG_REGULATOR_BQ24022) += bq24022.o
 obj-$(CONFIG_REGULATOR_LP3971) += lp3971.o
 obj-$(CONFIG_REGULATOR_MAX1586) += max1586.o
-obj-$(CONFIG_REGULATOR_TWL4030) += twl4030-regulator.o
+obj-$(CONFIG_REGULATOR_TWL4030) += twl-regulator.o
 obj-$(CONFIG_REGULATOR_WM8350) += wm8350-regulator.o
 obj-$(CONFIG_REGULATOR_WM8400) += wm8400-regulator.o
 obj-$(CONFIG_REGULATOR_DA903X)	+= da903x.o
diff --git a/drivers/regulator/twl4030-regulator.c b/drivers/regulator/twl-regulator.c
similarity index 99%
rename from drivers/regulator/twl4030-regulator.c
rename to drivers/regulator/twl-regulator.c
index e2032fb..78b618f 100644
--- a/drivers/regulator/twl4030-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -15,7 +15,7 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
-#include <linux/i2c/twl4030.h>
+#include <linux/i2c/twl.h>
 
 
 /*
@@ -172,12 +172,12 @@ static int twl4030reg_set_mode(struct regulator_dev *rdev, unsigned mode)
 		return -EACCES;
 
 	status = twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER,
-			message >> 8, 0x15 /* PB_WORD_MSB */ );
+			message >> 8, 0x15/* PB_WORD_MSB */);
 	if (status >= 0)
 		return status;
 
 	return twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER,
-			message, 0x16 /* PB_WORD_LSB */ );
+			message, 0x16/* PB_WORD_LSB */);
 }
 
 /*----------------------------------------------------------------------*/
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index 3c0f2b2..e331b1c 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -70,7 +70,7 @@ obj-$(CONFIG_RTC_DRV_SA1100)	+= rtc-sa1100.o
 obj-$(CONFIG_RTC_DRV_SH)	+= rtc-sh.o
 obj-$(CONFIG_RTC_DRV_STK17TA8)	+= rtc-stk17ta8.o
 obj-$(CONFIG_RTC_DRV_TEST)	+= rtc-test.o
-obj-$(CONFIG_RTC_DRV_TWL4030)	+= rtc-twl4030.o
+obj-$(CONFIG_RTC_DRV_TWL4030)	+= rtc-twl.o
 obj-$(CONFIG_RTC_DRV_TX4939)	+= rtc-tx4939.o
 obj-$(CONFIG_RTC_DRV_V3020)	+= rtc-v3020.o
 obj-$(CONFIG_RTC_DRV_VR41XX)	+= rtc-vr41xx.o
diff --git a/drivers/rtc/rtc-twl4030.c b/drivers/rtc/rtc-twl.c
similarity index 99%
rename from drivers/rtc/rtc-twl4030.c
rename to drivers/rtc/rtc-twl.c
index 9c8c70c..93565be 100644
--- a/drivers/rtc/rtc-twl4030.c
+++ b/drivers/rtc/rtc-twl.c
@@ -28,7 +28,7 @@
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 
-#include <linux/i2c/twl4030.h>
+#include <linux/i2c/twl.h>
 
 
 /*
diff --git a/drivers/usb/otg/twl4030-usb.c b/drivers/usb/otg/twl4030-usb.c
index 9e3e7a5..591334d 100644
--- a/drivers/usb/otg/twl4030-usb.c
+++ b/drivers/usb/otg/twl4030-usb.c
@@ -33,7 +33,7 @@
 #include <linux/io.h>
 #include <linux/delay.h>
 #include <linux/usb/otg.h>
-#include <linux/i2c/twl4030.h>
+#include <linux/i2c/twl.h>
 #include <linux/regulator/consumer.h>
 #include <linux/err.h>
 
diff --git a/include/linux/i2c/twl4030.h b/include/linux/i2c/twl.h
similarity index 98%
rename from include/linux/i2c/twl4030.h
rename to include/linux/i2c/twl.h
index 0dc80ef..277d05f 100644
--- a/include/linux/i2c/twl4030.h
+++ b/include/linux/i2c/twl.h
@@ -257,7 +257,7 @@ int twl4030_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes);
  */
 
 #define MSG_BROADCAST(devgrp, grp, type, type2, state) \
-	( (devgrp) << 13 | 1 << 12 | (grp) << 9 | (type2) << 7 \
+	((devgrp) << 13 | 1 << 12 | (grp) << 9 | (type2) << 7 \
 	| (type) << 4 | (state))
 
 #define MSG_SINGULAR(devgrp, id, state) \
@@ -399,4 +399,7 @@ int twl4030_sih_setup(int module);
 #define TWL4030_REG_VUSB1V8	18
 #define TWL4030_REG_VUSB3V1	19
 
+int twl_init_irq(int irq_num, unsigned irq_base, unsigned irq_end);
+int twl_exit_irq(void);
+
 #endif /* End of __TWL4030_H */
diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
index 4dbb853..2c47240 100644
--- a/sound/soc/codecs/twl4030.c
+++ b/sound/soc/codecs/twl4030.c
@@ -26,7 +26,7 @@
 #include <linux/pm.h>
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
-#include <linux/i2c/twl4030.h>
+#include <linux/i2c/twl.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
-- 
1.5.4.7

