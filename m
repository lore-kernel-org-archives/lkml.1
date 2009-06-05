Return-Path: <linux-kernel-owner+w=401wt.eu-S1757031AbZFEIW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031AbZFEIW3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755933AbZFEIG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:06:58 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37486 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755671AbZFEIGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:06:09 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH 48/62] Blackfin: bf548-ezkit: add resources for ADXL345/346
Date: Fri,  5 Jun 2009 04:04:57 -0400
Message-Id: <1244189111-19639-49-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf548/boards/ezkit.c |   83 +++++++++++++++++++++++++++----
 1 files changed, 73 insertions(+), 10 deletions(-)

diff --git a/arch/blackfin/mach-bf548/boards/ezkit.c b/arch/blackfin/mach-bf548/boards/ezkit.c
index 2780e41..add5a17 100644
--- a/arch/blackfin/mach-bf548/boards/ezkit.c
+++ b/arch/blackfin/mach-bf548/boards/ezkit.c
@@ -208,6 +208,43 @@ static struct platform_device bfin_rotary_device = {
 };
 #endif
 
+#if defined(CONFIG_INPUT_ADXL34X) || defined(CONFIG_INPUT_ADXL34X_MODULE)
+#include <linux/input.h>
+#include <linux/spi/adxl34x.h>
+static const struct adxl34x_platform_data adxl34x_info = {
+	.x_axis_offset = 0,
+	.y_axis_offset = 0,
+	.z_axis_offset = 0,
+	.tap_threshold = 0x31,
+	.tap_duration = 0x10,
+	.tap_latency = 0x60,
+	.tap_window = 0xF0,
+	.tap_axis_control = ADXL_TAP_X_EN | ADXL_TAP_Y_EN | ADXL_TAP_Z_EN,
+	.act_axis_control = 0xFF,
+	.activity_threshold = 5,
+	.inactivity_threshold = 3,
+	.inactivity_time = 4,
+	.free_fall_threshold = 0x7,
+	.free_fall_time = 0x20,
+	.data_rate = 0x8,
+	.data_range = ADXL_FULL_RES,
+
+	.ev_type = EV_ABS,
+	.ev_code_x = ABS_X,		/* EV_REL */
+	.ev_code_y = ABS_Y,		/* EV_REL */
+	.ev_code_z = ABS_Z,		/* EV_REL */
+
+	.ev_code_tap_x = BTN_TOUCH,		/* EV_KEY */
+	.ev_code_tap_y = BTN_TOUCH,		/* EV_KEY */
+	.ev_code_tap_z = BTN_TOUCH,		/* EV_KEY */
+
+/*	.ev_code_ff = KEY_F,*/		/* EV_KEY */
+/*	.ev_code_act_inactivity = KEY_A,*/	/* EV_KEY */
+	.power_mode = ADXL_AUTO_SLEEP | ADXL_LINK,
+	.fifo_mode = ADXL_FIFO_STREAM,
+};
+#endif
+
 #if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
 static struct platform_device rtc_device = {
 	.name = "rtc-bfin",
@@ -628,6 +665,14 @@ static struct bfin5xx_spi_chip spidev_chip_info = {
 };
 #endif
 
+#if defined(CONFIG_INPUT_ADXL34X_SPI) || defined(CONFIG_INPUT_ADXL34X_SPI_MODULE)
+static struct bfin5xx_spi_chip spi_adxl34x_chip_info = {
+	.enable_dma = 0,         /* use dma transfer with this chip*/
+	.bits_per_word = 8,
+	.cs_change_per_word = 0,
+};
+#endif
+
 static struct spi_board_info bfin_spi_board_info[] __initdata = {
 #if defined(CONFIG_MTD_M25P80) \
 	|| defined(CONFIG_MTD_M25P80_MODULE)
@@ -653,15 +698,15 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 #if defined(CONFIG_TOUCHSCREEN_AD7877) || defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
-{
-	.modalias		= "ad7877",
-	.platform_data		= &bfin_ad7877_ts_info,
-	.irq			= IRQ_PB4,	/* old boards (<=Rev 1.3) use IRQ_PJ11 */
-	.max_speed_hz		= 12500000,     /* max spi clock (SCK) speed in HZ */
-	.bus_num		= 0,
-	.chip_select  		= 2,
-	.controller_data = &spi_ad7877_chip_info,
-},
+	{
+		.modalias		= "ad7877",
+		.platform_data		= &bfin_ad7877_ts_info,
+		.irq			= IRQ_PB4,	/* old boards (<=Rev 1.3) use IRQ_PJ11 */
+		.max_speed_hz		= 12500000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num		= 0,
+		.chip_select  		= 2,
+		.controller_data = &spi_ad7877_chip_info,
+	},
 #endif
 #if defined(CONFIG_SPI_SPIDEV) || defined(CONFIG_SPI_SPIDEV_MODULE)
 	{
@@ -672,8 +717,19 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.controller_data = &spidev_chip_info,
 	},
 #endif
+#if defined(CONFIG_INPUT_ADXL34X_SPI) || defined(CONFIG_INPUT_ADXL34X_SPI_MODULE)
+	{
+		.modalias		= "adxl34x",
+		.platform_data		= &adxl34x_info,
+		.irq			= IRQ_PC5,
+		.max_speed_hz		= 5000000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num		= 1,
+		.chip_select  		= 2,
+		.controller_data = &spi_adxl34x_chip_info,
+		.mode = SPI_MODE_3,
+	},
+#endif
 };
-
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
 /* SPI (0) */
 static struct resource bfin_spi0_resource[] = {
@@ -797,6 +853,13 @@ static struct i2c_board_info __initdata bfin_i2c_board_info1[] = {
 		.irq = 212,
 	},
 #endif
+#if defined(CONFIG_INPUT_ADXL34X_I2C) || defined(CONFIG_INPUT_ADXL34X_I2C_MODULE)
+	{
+		I2C_BOARD_INFO("adxl34x", 0x53),
+		.irq = IRQ_PC5,
+		.platform_data = (void *)&adxl34x_info,
+	},
+#endif
 };
 #endif
 
-- 
1.6.3.1

