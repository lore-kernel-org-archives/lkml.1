Return-Path: <linux-kernel-owner+w=401wt.eu-S1764051AbXEUKOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764051AbXEUKOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761946AbXEUKJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:09:36 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:27800 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761176AbXEUKJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:09:18 -0400
X-IronPort-AV: i="4.14,560,1170651600"; 
   d="scan'208"; a="39510264:sNHT34173209"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 02/32] Blackfin arch: add SPI MMC driver support on bf533-stamp, tested on STAMP-BF533
Date: Mon, 21 May 2007 18:09:10 +0800
Message-Id: <1179742181341-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1179742180228-git-send-email-bryan.wu@analog.com>
References: <1179742180228-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/mach-bf533/boards/stamp.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/mach-bf533/boards/stamp.c b/arch/blackfin/mach-bf533/boards/stamp.c
index d7b3a5d..7d3dfcb 100644
--- a/arch/blackfin/mach-bf533/boards/stamp.c
+++ b/arch/blackfin/mach-bf533/boards/stamp.c
@@ -164,6 +164,13 @@ static struct bfin5xx_spi_chip ad5304_chip_info = {
 };
 #endif
 
+#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
+static struct bfin5xx_spi_chip spi_mmc_chip_info = {
+	.enable_dma = 1,
+	.bits_per_word = 8,
+};
+#endif
+
 static struct spi_board_info bfin_spi_board_info[] __initdata = {
 #if defined(CONFIG_MTD_M25P80) || defined(CONFIG_MTD_M25P80_MODULE)
 	{
@@ -199,6 +206,27 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
+#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
+	{
+		.modalias = "spi_mmc_dummy",
+		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 1,
+		.chip_select = 0,
+		.platform_data = NULL,
+		.controller_data = &spi_mmc_chip_info,
+		.mode = SPI_MODE_3,
+	},
+	{
+		.modalias = "spi_mmc",
+		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 1,
+		.chip_select = CONFIG_SPI_MMC_CS_CHAN,
+		.platform_data = NULL,
+		.controller_data = &spi_mmc_chip_info,
+		.mode = SPI_MODE_3,
+	},
+#endif
+
 #if defined(CONFIG_PBX)
 	{
 		.modalias	= "fxs-spi",
-- 
1.5.1.2
