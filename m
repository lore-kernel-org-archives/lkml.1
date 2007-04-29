Return-Path: <linux-kernel-owner+w=401wt.eu-S1754494AbXD2DXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbXD2DXp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 23:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754424AbXD2DXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 23:23:09 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:29994 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317AbXD2DWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 23:22:32 -0400
X-IronPort-AV: i="4.14,465,1170651600"; 
   d="scan'208"; a="28603022:sNHT27089020"
From: Bryan Wu <bryan.wu@analog.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 5/7] blackfin arch: convert most blackfin specific spi register settings to common spi framework settings
Date: Sun, 29 Apr 2007 11:23:11 +0800
Message-Id: <11778169951670-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11778169933996-git-send-email-bryan.wu@analog.com>
References: <11778169933996-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(mostly drop the MSTR bit as our bus handles that and convert CHPA/CPOL into SPI_MODE_#)

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/mach-bf533/boards/cm_bf533.c      |    4 +--
 arch/blackfin/mach-bf533/boards/ezkit.c         |    4 +--
 arch/blackfin/mach-bf533/boards/stamp.c         |   10 ++----
 arch/blackfin/mach-bf537/boards/cm_bf537.c      |    8 ++---
 arch/blackfin/mach-bf537/boards/generic_board.c |    5 +--
 arch/blackfin/mach-bf537/boards/pnav10.c        |   16 ++++-----
 arch/blackfin/mach-bf537/boards/stamp.c         |   37 ++++++++++------------
 arch/blackfin/mach-bf561/boards/cm_bf561.c      |    7 +---
 arch/blackfin/mach-bf561/boards/ezkit.c         |    1 -
 9 files changed, 36 insertions(+), 56 deletions(-)

diff --git a/arch/blackfin/mach-bf533/boards/cm_bf533.c b/arch/blackfin/mach-bf533/boards/cm_bf533.c
index 8cf7865..23a7f60 100644
--- a/arch/blackfin/mach-bf533/boards/cm_bf533.c
+++ b/arch/blackfin/mach-bf533/boards/cm_bf533.c
@@ -71,21 +71,18 @@ static struct flash_platform_data bfin_spi_flash_data = {
 
 /* SPI flash chip (m25p64) */
 static struct bfin5xx_spi_chip spi_flash_chip_info = {
-	.ctl_reg = 0x1C00,       /* with enable bit unset */
 	.enable_dma = 0,         /* use dma transfer with this chip*/
 	.bits_per_word = 8,
 };
 
 /* SPI ADC chip */
 static struct bfin5xx_spi_chip spi_adc_chip_info = {
-	.ctl_reg = 0x1500,
 	.enable_dma = 1,         /* use dma transfer with this chip*/
 	.bits_per_word = 16,
 };
 
 #if defined(CONFIG_SND_BLACKFIN_AD1836) || defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
 static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
-	.ctl_reg = 0x1000,
 	.enable_dma = 0,
 	.bits_per_word = 16,
 };
@@ -100,6 +97,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.chip_select = 1,           /* Framework chip select. On STAMP537 it is SPISSEL1*/
 		.platform_data = &bfin_spi_flash_data,
 		.controller_data = &spi_flash_chip_info,
+		.mode = SPI_MODE_3,
 	},{
 		.modalias = "bfin_spi_adc", /* Name of spi_driver for this device */
 		.max_speed_hz = 6250000,     /* max spi clock (SCK) speed in HZ */
diff --git a/arch/blackfin/mach-bf533/boards/ezkit.c b/arch/blackfin/mach-bf533/boards/ezkit.c
index 59970f7..747298e 100644
--- a/arch/blackfin/mach-bf533/boards/ezkit.c
+++ b/arch/blackfin/mach-bf533/boards/ezkit.c
@@ -105,7 +105,6 @@ static struct flash_platform_data bfin_spi_flash_data = {
 
 /* SPI flash chip (m25p64) */
 static struct bfin5xx_spi_chip spi_flash_chip_info = {
-	.ctl_reg = 0x1C00,       /* with enable bit unset */
 	.enable_dma = 0,         /* use dma transfer with this chip*/
 	.bits_per_word = 8,
 };
@@ -114,7 +113,6 @@ static struct bfin5xx_spi_chip spi_flash_chip_info = {
 #if defined(CONFIG_SPI_ADC_BF533) || defined(CONFIG_SPI_ADC_BF533_MODULE)
 /* SPI ADC chip */
 static struct bfin5xx_spi_chip spi_adc_chip_info = {
-	.ctl_reg = 0x1000,
 	.enable_dma = 1,         /* use dma transfer with this chip*/
 	.bits_per_word = 16,
 };
@@ -122,7 +120,6 @@ static struct bfin5xx_spi_chip spi_adc_chip_info = {
 
 #if defined(CONFIG_SND_BLACKFIN_AD1836) || defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
 static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
-	.ctl_reg = 0x1000,
 	.enable_dma = 0,
 	.bits_per_word = 16,
 };
@@ -138,6 +135,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.chip_select = 2, /* Framework chip select. On STAMP537 it is SPISSEL2*/
 		.platform_data = &bfin_spi_flash_data,
 		.controller_data = &spi_flash_chip_info,
+		.mode = SPI_MODE_3,
 	},
 #endif
 
diff --git a/arch/blackfin/mach-bf533/boards/stamp.c b/arch/blackfin/mach-bf533/boards/stamp.c
index 891118b..d7b3a5d 100644
--- a/arch/blackfin/mach-bf533/boards/stamp.c
+++ b/arch/blackfin/mach-bf533/boards/stamp.c
@@ -128,7 +128,6 @@ static struct flash_platform_data bfin_spi_flash_data = {
 
 /* SPI flash chip (m25p64) */
 static struct bfin5xx_spi_chip spi_flash_chip_info = {
-	.ctl_reg = 0x1C00,       /* with enable bit unset */
 	.enable_dma = 0,         /* use dma transfer with this chip*/
 	.bits_per_word = 8,
 };
@@ -137,7 +136,6 @@ static struct bfin5xx_spi_chip spi_flash_chip_info = {
 #if defined(CONFIG_SPI_ADC_BF533) || defined(CONFIG_SPI_ADC_BF533_MODULE)
 /* SPI ADC chip */
 static struct bfin5xx_spi_chip spi_adc_chip_info = {
-	.ctl_reg = 0x1000,
 	.enable_dma = 1,         /* use dma transfer with this chip*/
 	.bits_per_word = 16,
 };
@@ -145,7 +143,6 @@ static struct bfin5xx_spi_chip spi_adc_chip_info = {
 
 #if defined(CONFIG_SND_BLACKFIN_AD1836) || defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
 static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
-	.ctl_reg = 0x1000,
 	.enable_dma = 0,
 	.bits_per_word = 16,
 };
@@ -153,7 +150,7 @@ static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
 
 #if defined(CONFIG_PBX)
 static struct bfin5xx_spi_chip spi_si3xxx_chip_info = {
-	.ctl_reg	= 0x1c04,
+	.ctl_reg	= 0x4, /* send zero */
 	.enable_dma	= 0,
 	.bits_per_word	= 8,
 	.cs_change_per_word = 1,
@@ -162,7 +159,6 @@ static struct bfin5xx_spi_chip spi_si3xxx_chip_info = {
 
 #if defined(CONFIG_AD5304) || defined(CONFIG_AD5304_MODULE)
 static struct bfin5xx_spi_chip ad5304_chip_info = {
-	.ctl_reg = 0x1000 | CPOL,
 	.enable_dma = 0,
 	.bits_per_word = 16,
 };
@@ -178,6 +174,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.chip_select = 2, /* Framework chip select. On STAMP537 it is SPISSEL2*/
 		.platform_data = &bfin_spi_flash_data,
 		.controller_data = &spi_flash_chip_info,
+		.mode = SPI_MODE_3,
 	},
 #endif
 
@@ -209,14 +206,15 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.bus_num	= 1,
 		.chip_select	= 3,
 		.controller_data= &spi_si3xxx_chip_info,
+		.mode = SPI_MODE_3,
 	},
-
 	{
 		.modalias	= "fxo-spi",
 		.max_speed_hz	= 12500000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num	= 1,
 		.chip_select	= 2,
 		.controller_data= &spi_si3xxx_chip_info,
+		.mode = SPI_MODE_3,
 	},
 #endif
 
diff --git a/arch/blackfin/mach-bf537/boards/cm_bf537.c b/arch/blackfin/mach-bf537/boards/cm_bf537.c
index a16bf58..6a60618 100644
--- a/arch/blackfin/mach-bf537/boards/cm_bf537.c
+++ b/arch/blackfin/mach-bf537/boards/cm_bf537.c
@@ -73,7 +73,6 @@ static struct flash_platform_data bfin_spi_flash_data = {
 
 /* SPI flash chip (m25p64) */
 static struct bfin5xx_spi_chip spi_flash_chip_info = {
-	.ctl_reg = 0x1C00,       /* with enable bit unset */
 	.enable_dma = 0,         /* use dma transfer with this chip*/
 	.bits_per_word = 8,
 };
@@ -82,7 +81,6 @@ static struct bfin5xx_spi_chip spi_flash_chip_info = {
 #if defined(CONFIG_SPI_ADC_BF533) || defined(CONFIG_SPI_ADC_BF533_MODULE)
 /* SPI ADC chip */
 static struct bfin5xx_spi_chip spi_adc_chip_info = {
-	.ctl_reg = 0x1000,
 	.enable_dma = 1,         /* use dma transfer with this chip*/
 	.bits_per_word = 16,
 };
@@ -90,7 +88,6 @@ static struct bfin5xx_spi_chip spi_adc_chip_info = {
 
 #if defined(CONFIG_SND_BLACKFIN_AD1836) || defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
 static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
-	.ctl_reg = 0x1000,
 	.enable_dma = 0,
 	.bits_per_word = 16,
 };
@@ -98,7 +95,6 @@ static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
 
 #if defined(CONFIG_AD9960) || defined(CONFIG_AD9960_MODULE)
 static struct bfin5xx_spi_chip ad9960_spi_chip_info = {
-	.ctl_reg = 0x1000,
 	.enable_dma = 0,
 	.bits_per_word = 16,
 };
@@ -106,7 +102,6 @@ static struct bfin5xx_spi_chip ad9960_spi_chip_info = {
 
 #if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
 static struct bfin5xx_spi_chip spi_mmc_chip_info = {
-	.ctl_reg = 0x1c00,
 	.enable_dma = 1,
 	.bits_per_word = 8,
 };
@@ -122,6 +117,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.chip_select = 1, /* Framework chip select. On STAMP537 it is SPISSEL1*/
 		.platform_data = &bfin_spi_flash_data,
 		.controller_data = &spi_flash_chip_info,
+		.mode = SPI_MODE_3,
 	},
 #endif
 
@@ -164,6 +160,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.chip_select = 7,
 		.platform_data = NULL,
 		.controller_data = &spi_mmc_chip_info,
+		.mode = SPI_MODE_3,
 	},
 	{
 		.modalias = "spi_mmc",
@@ -172,6 +169,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.chip_select = CONFIG_SPI_MMC_CS_CHAN,
 		.platform_data = NULL,
 		.controller_data = &spi_mmc_chip_info,
+		.mode = SPI_MODE_3,
 	},
 #endif
 };
diff --git a/arch/blackfin/mach-bf537/boards/generic_board.c b/arch/blackfin/mach-bf537/boards/generic_board.c
index 5bf5ed1..9019c0e 100644
--- a/arch/blackfin/mach-bf537/boards/generic_board.c
+++ b/arch/blackfin/mach-bf537/boards/generic_board.c
@@ -273,7 +273,6 @@ static struct flash_platform_data bfin_spi_flash_data = {
 
 /* SPI flash chip (m25p64) */
 static struct bfin5xx_spi_chip spi_flash_chip_info = {
-	.ctl_reg = 0x1C00,       /* with enable bit unset */
 	.enable_dma = 0,         /* use dma transfer with this chip*/
 	.bits_per_word = 8,
 };
@@ -283,7 +282,6 @@ static struct bfin5xx_spi_chip spi_flash_chip_info = {
 	|| defined(CONFIG_SPI_ADC_BF533_MODULE)
 /* SPI ADC chip */
 static struct bfin5xx_spi_chip spi_adc_chip_info = {
-	.ctl_reg = 0x1000,
 	.enable_dma = 1,         /* use dma transfer with this chip*/
 	.bits_per_word = 16,
 };
@@ -292,7 +290,6 @@ static struct bfin5xx_spi_chip spi_adc_chip_info = {
 #if defined(CONFIG_SND_BLACKFIN_AD1836) \
 	|| defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
 static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
-	.ctl_reg = 0x1000,
 	.enable_dma = 0,
 	.bits_per_word = 16,
 };
@@ -300,7 +297,6 @@ static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
 
 #if defined(CONFIG_AD9960) || defined(CONFIG_AD9960_MODULE)
 static struct bfin5xx_spi_chip ad9960_spi_chip_info = {
-	.ctl_reg = 0x1000,
 	.enable_dma = 0,
 	.bits_per_word = 16,
 };
@@ -316,6 +312,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.chip_select = 2, /* Framework chip select. On STAMP537 it is SPISSEL1*/
 		.platform_data = &bfin_spi_flash_data,
 		.controller_data = &spi_flash_chip_info,
+		.mode = SPI_MODE_3,
 	},
 #endif
 
diff --git a/arch/blackfin/mach-bf537/boards/pnav10.c b/arch/blackfin/mach-bf537/boards/pnav10.c
index 83bf0a8..40d3a1b 100644
--- a/arch/blackfin/mach-bf537/boards/pnav10.c
+++ b/arch/blackfin/mach-bf537/boards/pnav10.c
@@ -258,7 +258,6 @@ static struct flash_platform_data bfin_spi_flash_data = {
 
 /* SPI flash chip (m25p64) */
 static struct bfin5xx_spi_chip spi_flash_chip_info = {
-	.ctl_reg = 0x1C00,       /* with enable bit unset */
 	.enable_dma = 0,         /* use dma transfer with this chip*/
 	.bits_per_word = 8,
 };
@@ -268,7 +267,6 @@ static struct bfin5xx_spi_chip spi_flash_chip_info = {
 	|| defined(CONFIG_SPI_ADC_BF533_MODULE)
 /* SPI ADC chip */
 static struct bfin5xx_spi_chip spi_adc_chip_info = {
-	.ctl_reg = 0x1000,
 	.enable_dma = 1,         /* use dma transfer with this chip*/
 	.bits_per_word = 16,
 };
@@ -277,7 +275,6 @@ static struct bfin5xx_spi_chip spi_adc_chip_info = {
 #if defined(CONFIG_SND_BLACKFIN_AD1836) \
 	|| defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
 static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
-	.ctl_reg = 0x1000,
 	.enable_dma = 0,
 	.bits_per_word = 16,
 };
@@ -285,7 +282,6 @@ static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
 
 #if defined(CONFIG_AD9960) || defined(CONFIG_AD9960_MODULE)
 static struct bfin5xx_spi_chip ad9960_spi_chip_info = {
-	.ctl_reg = 0x1000,
 	.enable_dma = 0,
 	.bits_per_word = 16,
 };
@@ -293,7 +289,6 @@ static struct bfin5xx_spi_chip ad9960_spi_chip_info = {
 
 #if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
 static struct bfin5xx_spi_chip spi_mmc_chip_info = {
-	.ctl_reg = 0x1c00,
 	.enable_dma = 1,
 	.bits_per_word = 8,
 };
@@ -301,7 +296,7 @@ static struct bfin5xx_spi_chip spi_mmc_chip_info = {
 
 #if defined(CONFIG_PBX)
 static struct bfin5xx_spi_chip spi_si3xxx_chip_info = {
-	.ctl_reg	= 0x1c04,
+	.ctl_reg	= 0x4, /* send zero */
 	.enable_dma	= 0,
 	.bits_per_word	= 8,
 	.cs_change_per_word = 1,
@@ -312,7 +307,6 @@ static struct bfin5xx_spi_chip spi_si3xxx_chip_info = {
 #if defined(CONFIG_TOUCHSCREEN_AD7877) || defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
 static struct bfin5xx_spi_chip spi_ad7877_chip_info = {
 	.cs_change_per_word = 1,
-	.ctl_reg = 0x1000,
 	.enable_dma = 0,
 	.bits_per_word = 16,
 };
@@ -343,6 +337,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.chip_select = 1, /* Framework chip select. On STAMP537 it is SPISSEL1*/
 		.platform_data = &bfin_spi_flash_data,
 		.controller_data = &spi_flash_chip_info,
+		.mode = SPI_MODE_3,
 	},
 #endif
 
@@ -385,6 +380,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.chip_select = 7,
 		.platform_data = NULL,
 		.controller_data = &spi_mmc_chip_info,
+		.mode = SPI_MODE_3,
 	},
 	{
 		.modalias = "spi_mmc",
@@ -393,7 +389,8 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.chip_select = CONFIG_SPI_MMC_CS_CHAN,
 		.platform_data = NULL,
 		.controller_data = &spi_mmc_chip_info,
-},
+		.mode = SPI_MODE_3,
+	},
 #endif
 #if defined(CONFIG_PBX)
 	{
@@ -402,14 +399,15 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.bus_num	= 1,
 		.chip_select	= 3,
 		.controller_data= &spi_si3xxx_chip_info,
+		.mode = SPI_MODE_3,
 	},
-
 	{
 		.modalias	= "fxo-spi",
 		.max_speed_hz	= 12500000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num	= 1,
 		.chip_select	= 2,
 		.controller_data= &spi_si3xxx_chip_info,
+		.mode = SPI_MODE_3,
 	},
 #endif
 #if defined(CONFIG_TOUCHSCREEN_AD7877) || defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index a4219df..ba2f875 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -307,7 +307,6 @@ static struct flash_platform_data bfin_spi_flash_data = {
 
 /* SPI flash chip (m25p64) */
 static struct bfin5xx_spi_chip spi_flash_chip_info = {
-	.ctl_reg = 0x1C00,       /* with enable bit unset */
 	.enable_dma = 0,         /* use dma transfer with this chip*/
 	.bits_per_word = 8,
 };
@@ -317,7 +316,6 @@ static struct bfin5xx_spi_chip spi_flash_chip_info = {
 	|| defined(CONFIG_SPI_ADC_BF533_MODULE)
 /* SPI ADC chip */
 static struct bfin5xx_spi_chip spi_adc_chip_info = {
-	.ctl_reg = 0x1000,
 	.enable_dma = 1,         /* use dma transfer with this chip*/
 	.bits_per_word = 16,
 };
@@ -326,7 +324,6 @@ static struct bfin5xx_spi_chip spi_adc_chip_info = {
 #if defined(CONFIG_SND_BLACKFIN_AD1836) \
 	|| defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
 static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
-	.ctl_reg = 0x1000,
 	.enable_dma = 0,
 	.bits_per_word = 16,
 };
@@ -334,7 +331,6 @@ static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
 
 #if defined(CONFIG_AD9960) || defined(CONFIG_AD9960_MODULE)
 static struct bfin5xx_spi_chip ad9960_spi_chip_info = {
-	.ctl_reg = 0x1000,
 	.enable_dma = 0,
 	.bits_per_word = 16,
 };
@@ -342,7 +338,6 @@ static struct bfin5xx_spi_chip ad9960_spi_chip_info = {
 
 #if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
 static struct bfin5xx_spi_chip spi_mmc_chip_info = {
-	.ctl_reg = 0x1c00,
 	.enable_dma = 1,
 	.bits_per_word = 8,
 };
@@ -350,7 +345,7 @@ static struct bfin5xx_spi_chip spi_mmc_chip_info = {
 
 #if defined(CONFIG_PBX)
 static struct bfin5xx_spi_chip spi_si3xxx_chip_info = {
-	.ctl_reg	= 0x1c04,
+	.ctl_reg	= 0x4, /* send zero */
 	.enable_dma	= 0,
 	.bits_per_word	= 8,
 	.cs_change_per_word = 1,
@@ -359,7 +354,6 @@ static struct bfin5xx_spi_chip spi_si3xxx_chip_info = {
 
 #if defined(CONFIG_AD5304) || defined(CONFIG_AD5304_MODULE)
 static struct bfin5xx_spi_chip ad5304_chip_info = {
-	.ctl_reg = 0x1000 | CPOL,
 	.enable_dma = 0,
 	.bits_per_word = 16,
 };
@@ -368,7 +362,6 @@ static struct bfin5xx_spi_chip ad5304_chip_info = {
 #if defined(CONFIG_TOUCHSCREEN_AD7877) || defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
 static struct bfin5xx_spi_chip spi_ad7877_chip_info = {
 //	.cs_change_per_word = 1,
-	.ctl_reg = 0x1000,
 	.enable_dma = 0,
 	.bits_per_word = 16,
 };
@@ -399,6 +392,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.chip_select = 1, /* Framework chip select. On STAMP537 it is SPISSEL1*/
 		.platform_data = &bfin_spi_flash_data,
 		.controller_data = &spi_flash_chip_info,
+		.mode = SPI_MODE_3,
 	},
 #endif
 
@@ -441,6 +435,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.chip_select = 0,
 		.platform_data = NULL,
 		.controller_data = &spi_mmc_chip_info,
+		.mode = SPI_MODE_3,
 	},
 	{
 		.modalias = "spi_mmc",
@@ -449,7 +444,8 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.chip_select = CONFIG_SPI_MMC_CS_CHAN,
 		.platform_data = NULL,
 		.controller_data = &spi_mmc_chip_info,
-},
+		.mode = SPI_MODE_3,
+	},
 #endif
 #if defined(CONFIG_PBX)
 	{
@@ -458,20 +454,21 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.bus_num	= 1,
 		.chip_select	= 3,
 		.controller_data= &spi_si3xxx_chip_info,
+		.mode = SPI_MODE_3,
 	},
-
 	{
 		.modalias	= "fxo-spi",
 		.max_speed_hz	= 12500000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num	= 1,
 		.chip_select	= 2,
 		.controller_data= &spi_si3xxx_chip_info,
+		.mode = SPI_MODE_3,
 	},
 #endif
 #if defined(CONFIG_AD5304) || defined(CONFIG_AD5304_MODULE)
 	{
 		.modalias = "ad5304_spi",
-		.max_speed_hz	= 1000000,     /* max spi clock (SCK) speed in HZ */
+		.max_speed_hz = 1250000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 1,
 		.chip_select = 2,
 		.platform_data = NULL,
@@ -480,15 +477,15 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 #if defined(CONFIG_TOUCHSCREEN_AD7877) || defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
-{
-	.modalias		= "ad7877",
-	.platform_data		= &bfin_ad7877_ts_info,
-	.irq			= IRQ_PF6,
-	.max_speed_hz	= 12500000,     /* max spi clock (SCK) speed in HZ */
-	.bus_num	= 1,
-	.chip_select  = 1,
-	.controller_data = &spi_ad7877_chip_info,
-},
+	{
+		.modalias		= "ad7877",
+		.platform_data		= &bfin_ad7877_ts_info,
+		.irq			= IRQ_PF6,
+		.max_speed_hz	= 12500000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num	= 1,
+		.chip_select  = 1,
+		.controller_data = &spi_ad7877_chip_info,
+	},
 #endif
 };
 
diff --git a/arch/blackfin/mach-bf561/boards/cm_bf561.c b/arch/blackfin/mach-bf561/boards/cm_bf561.c
index 06a5e54..6824e95 100644
--- a/arch/blackfin/mach-bf561/boards/cm_bf561.c
+++ b/arch/blackfin/mach-bf561/boards/cm_bf561.c
@@ -72,7 +72,6 @@ static struct flash_platform_data bfin_spi_flash_data = {
 
 /* SPI flash chip (m25p64) */
 static struct bfin5xx_spi_chip spi_flash_chip_info = {
-	.ctl_reg = 0x1C00,       /* with enable bit unset */
 	.enable_dma = 0,         /* use dma transfer with this chip*/
 	.bits_per_word = 8,
 };
@@ -81,7 +80,6 @@ static struct bfin5xx_spi_chip spi_flash_chip_info = {
 #if defined(CONFIG_SPI_ADC_BF533) || defined(CONFIG_SPI_ADC_BF533_MODULE)
 /* SPI ADC chip */
 static struct bfin5xx_spi_chip spi_adc_chip_info = {
-	.ctl_reg = 0x1000,
 	.enable_dma = 1,         /* use dma transfer with this chip*/
 	.bits_per_word = 16,
 };
@@ -89,7 +87,6 @@ static struct bfin5xx_spi_chip spi_adc_chip_info = {
 
 #if defined(CONFIG_SND_BLACKFIN_AD1836) || defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
 static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
-	.ctl_reg = 0x1000,
 	.enable_dma = 0,
 	.bits_per_word = 16,
 };
@@ -97,7 +94,6 @@ static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
 
 #if defined(CONFIG_AD9960) || defined(CONFIG_AD9960_MODULE)
 static struct bfin5xx_spi_chip ad9960_spi_chip_info = {
-	.ctl_reg = 0x1000,
 	.enable_dma = 0,
 	.bits_per_word = 16,
 };
@@ -105,7 +101,6 @@ static struct bfin5xx_spi_chip ad9960_spi_chip_info = {
 
 #if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
 static struct bfin5xx_spi_chip spi_mmc_chip_info = {
-	.ctl_reg = 0x1c00,
 	.enable_dma = 1,
 	.bits_per_word = 8,
 };
@@ -121,6 +116,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.chip_select = 1, /* Framework chip select. On STAMP537 it is SPISSEL1*/
 		.platform_data = &bfin_spi_flash_data,
 		.controller_data = &spi_flash_chip_info,
+		.mode = SPI_MODE_3,
 	},
 #endif
 
@@ -161,6 +157,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.chip_select = CONFIG_SPI_MMC_CS_CHAN,
 		.platform_data = NULL,
 		.controller_data = &spi_mmc_chip_info,
+		.mode = SPI_MODE_3,
 	},
 #endif
 };
diff --git a/arch/blackfin/mach-bf561/boards/ezkit.c b/arch/blackfin/mach-bf561/boards/ezkit.c
index 4d53322..14eb4f9 100644
--- a/arch/blackfin/mach-bf561/boards/ezkit.c
+++ b/arch/blackfin/mach-bf561/boards/ezkit.c
@@ -86,7 +86,6 @@ static struct platform_device bfin_uart_device = {
 #if defined(CONFIG_SND_BLACKFIN_AD1836) \
 	|| defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
 static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
-	.ctl_reg = 0x1000,
 	.enable_dma = 0,
 	.bits_per_word = 16,
 };
-- 
1.5.1.2
