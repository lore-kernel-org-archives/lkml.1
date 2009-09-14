Return-Path: <linux-kernel-owner+w=401wt.eu-S933639AbZINUQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933639AbZINUQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:16:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933614AbZINUQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:16:05 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54127 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933602AbZINUIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:51 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Barry Song <barry.song@analog.com>
Subject: [PATCH 46/72] Blackfin: bf537-stamp: update ad1836 resources
Date: Mon, 14 Sep 2009 16:07:50 -0400
Message-Id: <1252958896-25150-47-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Barry Song <barry.song@analog.com>

Update the ad1836 resources for the new ASoC driver.

Signed-off-by: Barry Song <barry.song@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf537/boards/stamp.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index 9b67006..d438ca4 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -532,8 +532,8 @@ static struct bfin5xx_spi_chip spi_adc_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_SND_BLACKFIN_AD1836) \
-	|| defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
+#if defined(CONFIG_SND_BF5XX_SOC_AD1836) \
+	|| defined(CONFIG_SND_BF5XX_SOC_AD1836_MODULE)
 static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
 	.enable_dma = 0,
 	.bits_per_word = 16,
@@ -883,14 +883,15 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_SND_BLACKFIN_AD1836) \
-	|| defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
+#if defined(CONFIG_SND_BF5XX_SOC_AD1836) \
+	|| defined(CONFIG_SND_BF5XX_SOC_AD1836_MODULE)
 	{
 		.modalias = "ad1836-spi",
 		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0,
-		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
+		.chip_select = 4,/* CONFIG_SND_BLACKFIN_SPI_PFBIT */
 		.controller_data = &ad1836_spi_chip_info,
+		.mode = SPI_MODE_3,
 	},
 #endif
 
@@ -1628,6 +1629,13 @@ static struct platform_device bfin_dpmc = {
 	},
 };
 
+#if defined(CONFIG_SND_BF5XX_TDM) || defined(CONFIG_SND_BF5XX_TDM_MODULE)
+static struct platform_device bfin_tdm = {
+	.name = "bfin-tdm",
+	/* TODO: add platform data here */
+};
+#endif
+
 static struct platform_device *stamp_devices[] __initdata = {
 
 	&bfin_dpmc,
@@ -1733,6 +1741,10 @@ static struct platform_device *stamp_devices[] __initdata = {
 #if defined(CONFIG_MTD_PHYSMAP) || defined(CONFIG_MTD_PHYSMAP_MODULE)
 	&stamp_flash_device,
 #endif
+
+#if defined(CONFIG_SND_BF5XX_TDM) || defined(CONFIG_SND_BF5XX_TDM_MODULE)
+	&bfin_tdm,
+#endif
 };
 
 static int __init stamp_init(void)
-- 
1.6.4.2

