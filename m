Return-Path: <linux-kernel-owner+w=401wt.eu-S933669AbZINUQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933669AbZINUQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933587AbZINUIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:08:48 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54080 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933526AbZINUIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:40 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Barry Song <barry.song@analog.com>
Subject: [PATCH 33/72] Blackfin: bf537-stamp: update AD714x resources
Date: Mon, 14 Sep 2009 16:07:37 -0400
Message-Id: <1252958896-25150-34-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Barry Song <barry.song@analog.com>

Push the device table to the board resources as data interpretation can be
changed on a per-board basis.

Signed-off-by: Barry Song <barry.song@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf537/boards/stamp.c |  133 ++++++++++++++++++++++++++++++-
 1 files changed, 131 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index 72d11de..e5fffe7 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -540,6 +540,120 @@ static struct bfin5xx_spi_chip ad9960_spi_chip_info = {
 };
 #endif
 
+#if defined(CONFIG_INPUT_EVAL_AD7147EBZ)
+#include <linux/input.h>
+#include <linux/input/ad714x.h>
+static struct bfin5xx_spi_chip ad7147_spi_chip_info = {
+	.enable_dma = 0,
+	.bits_per_word = 16,
+};
+
+static struct ad714x_slider_plat slider_plat[] = {
+	{
+		.start_stage = 0,
+		.end_stage = 7,
+		.max_coord = 128,
+	},
+};
+
+static struct ad714x_button_plat button_plat[] = {
+	{
+		.keycode = BTN_FORWARD,
+		.l_mask = 0,
+		.h_mask = 0x600,
+	},
+	{
+		.keycode = BTN_LEFT,
+		.l_mask = 0,
+		.h_mask = 0x500,
+	},
+	{
+		.keycode = BTN_MIDDLE,
+		.l_mask = 0,
+		.h_mask = 0x800,
+	},
+	{
+		.keycode = BTN_RIGHT,
+		.l_mask = 0x100,
+		.h_mask = 0x400,
+	},
+	{
+		.keycode = BTN_BACK,
+		.l_mask = 0x200,
+		.h_mask = 0x400,
+	},
+};
+static struct ad714x_platform_data ad7147_platfrom_data = {
+	.slider_num = 1,
+	.button_num = 5,
+	.slider = slider_plat,
+	.button = button_plat,
+	.stage_cfg_reg =  {
+		{0xFBFF, 0x1FFF, 0, 0x2626, 1600, 1600, 1600, 1600},
+		{0xEFFF, 0x1FFF, 0, 0x2626, 1650, 1650, 1650, 1650},
+		{0xFFFF, 0x1FFE, 0, 0x2626, 1650, 1650, 1650, 1650},
+		{0xFFFF, 0x1FFB, 0, 0x2626, 1650, 1650, 1650, 1650},
+		{0xFFFF, 0x1FEF, 0, 0x2626, 1650, 1650, 1650, 1650},
+		{0xFFFF, 0x1FBF, 0, 0x2626, 1650, 1650, 1650, 1650},
+		{0xFFFF, 0x1EFF, 0, 0x2626, 1650, 1650, 1650, 1650},
+		{0xFFFF, 0x1BFF, 0, 0x2626, 1600, 1600, 1600, 1600},
+		{0xFF7B, 0x3FFF, 0x506,  0x2626, 1100, 1100, 1150, 1150},
+		{0xFDFE, 0x3FFF, 0x606,  0x2626, 1100, 1100, 1150, 1150},
+		{0xFEBA, 0x1FFF, 0x1400, 0x2626, 1200, 1200, 1300, 1300},
+		{0xFFEF, 0x1FFF, 0x0,    0x2626, 1100, 1100, 1150, 1150},
+	},
+	.sys_cfg_reg = {0x2B2, 0x0, 0x3233, 0x819, 0x832, 0xCFF, 0xCFF, 0x0},
+};
+#endif
+
+#if defined(CONFIG_INPUT_EVAL_AD7142EB)
+#include <linux/input.h>
+#include <linux/input/ad714x.h>
+static struct ad714x_button_plat button_plat[] = {
+	{
+		.keycode = BTN_1,
+		.l_mask = 0,
+		.h_mask = 0x1,
+	},
+	{
+		.keycode = BTN_2,
+		.l_mask = 0,
+		.h_mask = 0x2,
+	},
+	{
+		.keycode = BTN_3,
+		.l_mask = 0,
+		.h_mask = 0x4,
+	},
+	{
+		.keycode = BTN_4,
+		.l_mask = 0x0,
+		.h_mask = 0x8,
+	},
+};
+static struct ad714x_platform_data ad7142_platfrom_data = {
+	.button_num = 4,
+	.button = button_plat,
+	.stage_cfg_reg =  {
+		/* fixme: figure out right setting for all comoponent according
+		 * to hardware feature of EVAL-AD7142EB board */
+		{0xE7FF, 0x3FFF, 0x0005, 0x2626, 0x01F4, 0x01F4, 0x028A, 0x028A},
+		{0xFDBF, 0x3FFF, 0x0001, 0x2626, 0x01F4, 0x01F4, 0x028A, 0x028A},
+		{0xFFFF, 0x2DFF, 0x0001, 0x2626, 0x01F4, 0x01F4, 0x028A, 0x028A},
+		{0xFFFF, 0x37BF, 0x0001, 0x2626, 0x01F4, 0x01F4, 0x028A, 0x028A},
+		{0xFFFF, 0x3FFF, 0x0000, 0x0606, 0x01F4, 0x01F4, 0x0320, 0x0320},
+		{0xFFFF, 0x3FFF, 0x0000, 0x0606, 0x01F4, 0x01F4, 0x0320, 0x0320},
+		{0xFFFF, 0x3FFF, 0x0000, 0x0606, 0x01F4, 0x01F4, 0x0320, 0x0320},
+		{0xFFFF, 0x3FFF, 0x0000, 0x0606, 0x01F4, 0x01F4, 0x0320, 0x0320},
+		{0xFFFF, 0x3FFF, 0x0000, 0x0606, 0x01F4, 0x01F4, 0x0320, 0x0320},
+		{0xFFFF, 0x3FFF, 0x0000, 0x0606, 0x01F4, 0x01F4, 0x0320, 0x0320},
+		{0xFFFF, 0x3FFF, 0x0000, 0x0606, 0x01F4, 0x01F4, 0x0320, 0x0320},
+		{0xFFFF, 0x3FFF, 0x0000, 0x0606, 0x01F4, 0x01F4, 0x0320, 0x0320},
+	},
+	.sys_cfg_reg = {0x0B2, 0x0, 0x690, 0x664, 0x290F, 0xF, 0xF, 0x0},
+};
+#endif
+
 #if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 #define MMC_SPI_CARD_DETECT_INT IRQ_PF5
 
@@ -784,6 +898,20 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.controller_data = &ad9960_spi_chip_info,
 	},
 #endif
+
+#if defined(CONFIG_INPUT_EVAL_AD7147EBZ)
+	{
+		.modalias = "ad714x_captouch",
+		.max_speed_hz = 1000000,     /* max spi clock (SCK) speed in HZ */
+		.irq = IRQ_PF4,
+		.bus_num = 0,
+		.chip_select = 5,
+		.mode = SPI_MODE_3,
+		.platform_data = &ad7147_platfrom_data,
+		.controller_data = &ad7147_spi_chip_info,
+	},
+#endif
+
 #if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 	{
 		.modalias = "mmc_spi",
@@ -1337,10 +1465,11 @@ static struct adp5520_platform_data adp5520_pdev_data = {
 #endif
 
 static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
-#if defined(CONFIG_JOYSTICK_AD7142) || defined(CONFIG_JOYSTICK_AD7142_MODULE)
+#if defined(CONFIG_INPUT_EVAL_AD7142EB)
 	{
-		I2C_BOARD_INFO("ad7142_joystick", 0x2C),
+		I2C_BOARD_INFO("ad7142_captouch", 0x2C),
 		.irq = IRQ_PG5,
+		.platform_data = (void *)&ad7142_platfrom_data,
 	},
 #endif
 #if defined(CONFIG_BFIN_TWI_LCD) || defined(CONFIG_BFIN_TWI_LCD_MODULE)
-- 
1.6.4.2

