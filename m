Return-Path: <linux-kernel-owner+w=401wt.eu-S933686AbZINUJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933686AbZINUJM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933671AbZINUJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:09:09 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54142 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933624AbZINUIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:55 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 51/72] Blackfin: drop board resources for dead devices (pbx/ad9960)
Date: Mon, 14 Sep 2009 16:07:55 -0400
Message-Id: <1252958896-25150-52-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These hardware devices are dead and the drivers never cleaned up/merged,
so punt the useless board resource info.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf518/boards/ezbrd.c     |   27 ----------------
 arch/blackfin/mach-bf527/boards/cm_bf527.c  |   43 --------------------------
 arch/blackfin/mach-bf527/boards/ezbrd.c     |   27 ----------------
 arch/blackfin/mach-bf527/boards/ezkit.c     |   43 --------------------------
 arch/blackfin/mach-bf533/boards/H8606.c     |   26 ----------------
 arch/blackfin/mach-bf533/boards/stamp.c     |   28 -----------------
 arch/blackfin/mach-bf537/boards/cm_bf537.c  |   17 ----------
 arch/blackfin/mach-bf537/boards/pnav10.c    |   16 ----------
 arch/blackfin/mach-bf537/boards/stamp.c     |   44 ---------------------------
 arch/blackfin/mach-bf537/boards/tcm_bf537.c |   17 ----------
 arch/blackfin/mach-bf561/boards/cm_bf561.c  |   16 ----------
 11 files changed, 0 insertions(+), 304 deletions(-)

diff --git a/arch/blackfin/mach-bf518/boards/ezbrd.c b/arch/blackfin/mach-bf518/boards/ezbrd.c
index 4c594e6..03e4a99 100644
--- a/arch/blackfin/mach-bf518/boards/ezbrd.c
+++ b/arch/blackfin/mach-bf518/boards/ezbrd.c
@@ -199,15 +199,6 @@ static struct bfin5xx_spi_chip mmc_spi_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_PBX)
-static struct bfin5xx_spi_chip spi_si3xxx_chip_info = {
-	.ctl_reg	= 0x4, /* send zero */
-	.enable_dma	= 0,
-	.bits_per_word	= 8,
-	.cs_change_per_word = 1,
-};
-#endif
-
 #if defined(CONFIG_TOUCHSCREEN_AD7877) || defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
 static struct bfin5xx_spi_chip spi_ad7877_chip_info = {
 	.enable_dma = 0,
@@ -296,24 +287,6 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.mode = SPI_MODE_3,
 	},
 #endif
-#if defined(CONFIG_PBX)
-	{
-		.modalias = "fxs-spi",
-		.max_speed_hz = 12500000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = 8 - CONFIG_J11_JUMPER,
-		.controller_data = &spi_si3xxx_chip_info,
-		.mode = SPI_MODE_3,
-	},
-	{
-		.modalias = "fxo-spi",
-		.max_speed_hz = 12500000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = 8 - CONFIG_J19_JUMPER,
-		.controller_data = &spi_si3xxx_chip_info,
-		.mode = SPI_MODE_3,
-	},
-#endif
 #if defined(CONFIG_TOUCHSCREEN_AD7877) || defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
 	{
 		.modalias		= "ad7877",
diff --git a/arch/blackfin/mach-bf527/boards/cm_bf527.c b/arch/blackfin/mach-bf527/boards/cm_bf527.c
index 18b9bd7..fdd518c 100644
--- a/arch/blackfin/mach-bf527/boards/cm_bf527.c
+++ b/arch/blackfin/mach-bf527/boards/cm_bf527.c
@@ -495,13 +495,6 @@ static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_AD9960) || defined(CONFIG_AD9960_MODULE)
-static struct bfin5xx_spi_chip ad9960_spi_chip_info = {
-	.enable_dma = 0,
-	.bits_per_word = 16,
-};
-#endif
-
 #if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 static struct bfin5xx_spi_chip  mmc_spi_chip_info = {
 	.enable_dma = 0,
@@ -509,15 +502,6 @@ static struct bfin5xx_spi_chip  mmc_spi_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_PBX)
-static struct bfin5xx_spi_chip spi_si3xxx_chip_info = {
-	.ctl_reg	= 0x4, /* send zero */
-	.enable_dma	= 0,
-	.bits_per_word	= 8,
-	.cs_change_per_word = 1,
-};
-#endif
-
 #if defined(CONFIG_TOUCHSCREEN_AD7877) || defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
 static struct bfin5xx_spi_chip spi_ad7877_chip_info = {
 	.enable_dma = 0,
@@ -591,15 +575,6 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.controller_data = &ad1836_spi_chip_info,
 	},
 #endif
-#if defined(CONFIG_AD9960) || defined(CONFIG_AD9960_MODULE)
-	{
-		.modalias = "ad9960-spi",
-		.max_speed_hz = 10000000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = 1,
-		.controller_data = &ad9960_spi_chip_info,
-	},
-#endif
 #if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 	{
 		.modalias = "mmc_spi",
@@ -610,24 +585,6 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.mode = SPI_MODE_3,
 	},
 #endif
-#if defined(CONFIG_PBX)
-	{
-		.modalias = "fxs-spi",
-		.max_speed_hz = 12500000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = 8 - CONFIG_J11_JUMPER,
-		.controller_data = &spi_si3xxx_chip_info,
-		.mode = SPI_MODE_3,
-	},
-	{
-		.modalias = "fxo-spi",
-		.max_speed_hz = 12500000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = 8 - CONFIG_J19_JUMPER,
-		.controller_data = &spi_si3xxx_chip_info,
-		.mode = SPI_MODE_3,
-	},
-#endif
 #if defined(CONFIG_TOUCHSCREEN_AD7877) || defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
 	{
 		.modalias		= "ad7877",
diff --git a/arch/blackfin/mach-bf527/boards/ezbrd.c b/arch/blackfin/mach-bf527/boards/ezbrd.c
index 809c790..68b4c80 100644
--- a/arch/blackfin/mach-bf527/boards/ezbrd.c
+++ b/arch/blackfin/mach-bf527/boards/ezbrd.c
@@ -263,15 +263,6 @@ static struct bfin5xx_spi_chip mmc_spi_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_PBX)
-static struct bfin5xx_spi_chip spi_si3xxx_chip_info = {
-	.ctl_reg	= 0x4, /* send zero */
-	.enable_dma	= 0,
-	.bits_per_word	= 8,
-	.cs_change_per_word = 1,
-};
-#endif
-
 #if defined(CONFIG_TOUCHSCREEN_AD7877) || defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
 static struct bfin5xx_spi_chip spi_ad7877_chip_info = {
 	.enable_dma = 0,
@@ -376,24 +367,6 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.mode = SPI_MODE_3,
 	},
 #endif
-#if defined(CONFIG_PBX)
-	{
-		.modalias = "fxs-spi",
-		.max_speed_hz = 12500000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = 8 - CONFIG_J11_JUMPER,
-		.controller_data = &spi_si3xxx_chip_info,
-		.mode = SPI_MODE_3,
-	},
-	{
-		.modalias = "fxo-spi",
-		.max_speed_hz = 12500000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = 8 - CONFIG_J19_JUMPER,
-		.controller_data = &spi_si3xxx_chip_info,
-		.mode = SPI_MODE_3,
-	},
-#endif
 #if defined(CONFIG_TOUCHSCREEN_AD7877) || defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
 	{
 		.modalias		= "ad7877",
diff --git a/arch/blackfin/mach-bf527/boards/ezkit.c b/arch/blackfin/mach-bf527/boards/ezkit.c
index 617a287..4ab9cfa 100644
--- a/arch/blackfin/mach-bf527/boards/ezkit.c
+++ b/arch/blackfin/mach-bf527/boards/ezkit.c
@@ -512,13 +512,6 @@ static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_AD9960) || defined(CONFIG_AD9960_MODULE)
-static struct bfin5xx_spi_chip ad9960_spi_chip_info = {
-	.enable_dma = 0,
-	.bits_per_word = 16,
-};
-#endif
-
 #if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 static struct bfin5xx_spi_chip  mmc_spi_chip_info = {
 	.enable_dma = 0,
@@ -526,15 +519,6 @@ static struct bfin5xx_spi_chip  mmc_spi_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_PBX)
-static struct bfin5xx_spi_chip spi_si3xxx_chip_info = {
-	.ctl_reg	= 0x4, /* send zero */
-	.enable_dma	= 0,
-	.bits_per_word	= 8,
-	.cs_change_per_word = 1,
-};
-#endif
-
 #if defined(CONFIG_TOUCHSCREEN_AD7877) || defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
 static struct bfin5xx_spi_chip spi_ad7877_chip_info = {
 	.enable_dma = 0,
@@ -632,15 +616,6 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.controller_data = &ad1836_spi_chip_info,
 	},
 #endif
-#if defined(CONFIG_AD9960) || defined(CONFIG_AD9960_MODULE)
-	{
-		.modalias = "ad9960-spi",
-		.max_speed_hz = 10000000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = 1,
-		.controller_data = &ad9960_spi_chip_info,
-	},
-#endif
 #if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 	{
 		.modalias = "mmc_spi",
@@ -652,24 +627,6 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_PBX)
-	{
-		.modalias = "fxs-spi",
-		.max_speed_hz = 12500000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = 8 - CONFIG_J11_JUMPER,
-		.controller_data = &spi_si3xxx_chip_info,
-		.mode = SPI_MODE_3,
-	},
-	{
-		.modalias = "fxo-spi",
-		.max_speed_hz = 12500000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = 8 - CONFIG_J19_JUMPER,
-		.controller_data = &spi_si3xxx_chip_info,
-		.mode = SPI_MODE_3,
-	},
-#endif
 #if defined(CONFIG_TOUCHSCREEN_AD7877) || defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
 	{
 		.modalias		= "ad7877",
diff --git a/arch/blackfin/mach-bf533/boards/H8606.c b/arch/blackfin/mach-bf533/boards/H8606.c
index 1bd8b61..30ff3c4 100644
--- a/arch/blackfin/mach-bf533/boards/H8606.c
+++ b/arch/blackfin/mach-bf533/boards/H8606.c
@@ -201,15 +201,6 @@ static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_PBX)
-static struct bfin5xx_spi_chip spi_si3xxx_chip_info = {
-	.ctl_reg	= 0x1c04,
-	.enable_dma	= 0,
-	.bits_per_word	= 8,
-	.cs_change_per_word = 1,
-};
-#endif
-
 /* Notice: for blackfin, the speed_hz is the value of register
  * SPI_BAUD, not the real baudrate */
 static struct spi_board_info bfin_spi_board_info[] __initdata = {
@@ -248,23 +239,6 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_PBX)
-	{
-		.modalias	 = "fxs-spi",
-		.max_speed_hz	 = 4,
-		.bus_num	 = 1,
-		.chip_select	 = 3,
-		.controller_data = &spi_si3xxx_chip_info,
-	},
-
-	{
-		.modalias	 = "fxo-spi",
-		.max_speed_hz	 = 4,
-		.bus_num	 = 1,
-		.chip_select	 = 2,
-		.controller_data = &spi_si3xxx_chip_info,
-	},
-#endif
 };
 
 /* SPI (0) */
diff --git a/arch/blackfin/mach-bf533/boards/stamp.c b/arch/blackfin/mach-bf533/boards/stamp.c
index f3dc283..3954baa 100644
--- a/arch/blackfin/mach-bf533/boards/stamp.c
+++ b/arch/blackfin/mach-bf533/boards/stamp.c
@@ -219,15 +219,6 @@ static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_PBX)
-static struct bfin5xx_spi_chip spi_si3xxx_chip_info = {
-	.ctl_reg	= 0x4, /* send zero */
-	.enable_dma	= 0,
-	.bits_per_word	= 8,
-	.cs_change_per_word = 1,
-};
-#endif
-
 #if defined(CONFIG_SPI_SPIDEV) || defined(CONFIG_SPI_SPIDEV_MODULE)
 static struct bfin5xx_spi_chip spidev_chip_info = {
 	.enable_dma = 0,
@@ -298,25 +289,6 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_PBX)
-	{
-		.modalias = "fxs-spi",
-		.max_speed_hz = 12500000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = 8 - CONFIG_J11_JUMPER,
-		.controller_data = &spi_si3xxx_chip_info,
-		.mode = SPI_MODE_3,
-	},
-	{
-		.modalias = "fxo-spi",
-		.max_speed_hz = 12500000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = 8 - CONFIG_J19_JUMPER,
-		.controller_data = &spi_si3xxx_chip_info,
-		.mode = SPI_MODE_3,
-	},
-#endif
-
 #if defined(CONFIG_SPI_SPIDEV) || defined(CONFIG_SPI_SPIDEV_MODULE)
 	{
 		.modalias = "spidev",
diff --git a/arch/blackfin/mach-bf537/boards/cm_bf537.c b/arch/blackfin/mach-bf537/boards/cm_bf537.c
index 3681d2c..159e5b2 100644
--- a/arch/blackfin/mach-bf537/boards/cm_bf537.c
+++ b/arch/blackfin/mach-bf537/boards/cm_bf537.c
@@ -101,13 +101,6 @@ static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_AD9960) || defined(CONFIG_AD9960_MODULE)
-static struct bfin5xx_spi_chip ad9960_spi_chip_info = {
-	.enable_dma = 0,
-	.bits_per_word = 16,
-};
-#endif
-
 #if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 static struct bfin5xx_spi_chip  mmc_spi_chip_info = {
 	.enable_dma = 0,
@@ -150,16 +143,6 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_AD9960) || defined(CONFIG_AD9960_MODULE)
-	{
-		.modalias = "ad9960-spi",
-		.max_speed_hz = 10000000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = 1,
-		.controller_data = &ad9960_spi_chip_info,
-	},
-#endif
-
 #if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 	{
 		.modalias = "mmc_spi",
diff --git a/arch/blackfin/mach-bf537/boards/pnav10.c b/arch/blackfin/mach-bf537/boards/pnav10.c
index 3bbe102..0d93bbe 100644
--- a/arch/blackfin/mach-bf537/boards/pnav10.c
+++ b/arch/blackfin/mach-bf537/boards/pnav10.c
@@ -293,13 +293,6 @@ static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_AD9960) || defined(CONFIG_AD9960_MODULE)
-static struct bfin5xx_spi_chip ad9960_spi_chip_info = {
-	.enable_dma = 0,
-	.bits_per_word = 16,
-};
-#endif
-
 #if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 static struct bfin5xx_spi_chip mmc_spi_chip_info = {
 	.enable_dma = 0,
@@ -366,15 +359,6 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.controller_data = &ad1836_spi_chip_info,
 	},
 #endif
-#if defined(CONFIG_AD9960) || defined(CONFIG_AD9960_MODULE)
-	{
-		.modalias = "ad9960-spi",
-		.max_speed_hz = 10000000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = 1,
-		.controller_data = &ad9960_spi_chip_info,
-	},
-#endif
 #if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 	{
 		.modalias = "mmc_spi",
diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index d438ca4..d5aabee 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -549,13 +549,6 @@ static struct bfin5xx_spi_chip ad1938_spi_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_AD9960) || defined(CONFIG_AD9960_MODULE)
-static struct bfin5xx_spi_chip ad9960_spi_chip_info = {
-	.enable_dma = 0,
-	.bits_per_word = 16,
-};
-#endif
-
 #if defined(CONFIG_INPUT_EVAL_AD7147EBZ)
 #include <linux/input.h>
 #include <linux/input/ad714x.h>
@@ -698,15 +691,6 @@ static struct bfin5xx_spi_chip  mmc_spi_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_PBX)
-static struct bfin5xx_spi_chip spi_si3xxx_chip_info = {
-	.ctl_reg	= 0x4, /* send zero */
-	.enable_dma	= 0,
-	.bits_per_word	= 8,
-	.cs_change_per_word = 1,
-};
-#endif
-
 #if defined(CONFIG_TOUCHSCREEN_AD7877) || defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
 #include <linux/spi/ad7877.h>
 static struct bfin5xx_spi_chip spi_ad7877_chip_info = {
@@ -906,16 +890,6 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_AD9960) || defined(CONFIG_AD9960_MODULE)
-	{
-		.modalias = "ad9960-spi",
-		.max_speed_hz = 10000000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = 1,
-		.controller_data = &ad9960_spi_chip_info,
-	},
-#endif
-
 #if defined(CONFIG_INPUT_EVAL_AD7147EBZ)
 	{
 		.modalias = "ad714x_captouch",
@@ -940,24 +914,6 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.mode = SPI_MODE_3,
 	},
 #endif
-#if defined(CONFIG_PBX)
-	{
-		.modalias = "fxs-spi",
-		.max_speed_hz = 12500000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = 8 - CONFIG_J11_JUMPER,
-		.controller_data = &spi_si3xxx_chip_info,
-		.mode = SPI_MODE_3,
-	},
-	{
-		.modalias = "fxo-spi",
-		.max_speed_hz = 12500000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = 8 - CONFIG_J19_JUMPER,
-		.controller_data = &spi_si3xxx_chip_info,
-		.mode = SPI_MODE_3,
-	},
-#endif
 #if defined(CONFIG_TOUCHSCREEN_AD7877) || defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
 	{
 		.modalias		= "ad7877",
diff --git a/arch/blackfin/mach-bf537/boards/tcm_bf537.c b/arch/blackfin/mach-bf537/boards/tcm_bf537.c
index 97a86b4..88eade8 100644
--- a/arch/blackfin/mach-bf537/boards/tcm_bf537.c
+++ b/arch/blackfin/mach-bf537/boards/tcm_bf537.c
@@ -101,13 +101,6 @@ static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_AD9960) || defined(CONFIG_AD9960_MODULE)
-static struct bfin5xx_spi_chip ad9960_spi_chip_info = {
-	.enable_dma = 0,
-	.bits_per_word = 16,
-};
-#endif
-
 #if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 static struct bfin5xx_spi_chip mmc_spi_chip_info = {
 	.enable_dma = 0,
@@ -150,16 +143,6 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_AD9960) || defined(CONFIG_AD9960_MODULE)
-	{
-		.modalias = "ad9960-spi",
-		.max_speed_hz = 10000000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = 1,
-		.controller_data = &ad9960_spi_chip_info,
-	},
-#endif
-
 #if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 	{
 		.modalias = "mmc_spi",
diff --git a/arch/blackfin/mach-bf561/boards/cm_bf561.c b/arch/blackfin/mach-bf561/boards/cm_bf561.c
index ebb0755..cedcc3c 100644
--- a/arch/blackfin/mach-bf561/boards/cm_bf561.c
+++ b/arch/blackfin/mach-bf561/boards/cm_bf561.c
@@ -98,13 +98,6 @@ static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_AD9960) || defined(CONFIG_AD9960_MODULE)
-static struct bfin5xx_spi_chip ad9960_spi_chip_info = {
-	.enable_dma = 0,
-	.bits_per_word = 16,
-};
-#endif
-
 #if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 static struct bfin5xx_spi_chip mmc_spi_chip_info = {
 	.enable_dma = 0,
@@ -146,15 +139,6 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.controller_data = &ad1836_spi_chip_info,
 	},
 #endif
-#if defined(CONFIG_AD9960) || defined(CONFIG_AD9960_MODULE)
-	{
-		.modalias = "ad9960-spi",
-		.max_speed_hz = 10000000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = 1,
-		.controller_data = &ad9960_spi_chip_info,
-	},
-#endif
 #if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 	{
 		.modalias = "mmc_spi",
-- 
1.6.4.2

