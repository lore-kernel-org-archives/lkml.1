Return-Path: <linux-kernel-owner+w=401wt.eu-S933396AbZINUX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933396AbZINUX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933641AbZINUXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:23:50 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:53982 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756898AbZINUIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:16 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Barry Song <barry.song@analog.com>
Subject: [PATCH 03/72] Blackfin: bf537-stamp: add resources for AD1938 audio card
Date: Mon, 14 Sep 2009 16:07:07 -0400
Message-Id: <1252958896-25150-4-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Barry Song <barry.song@analog.com>

Signed-off-by: Barry Song <barry.song@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf537/boards/stamp.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index d619313..b9da979 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -524,6 +524,15 @@ static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
 };
 #endif
 
+#if defined(CONFIG_SND_BF5XX_SOC_AD1938) \
+	|| defined(CONFIG_SND_BF5XX_SOC_AD1938_MODULE)
+static struct bfin5xx_spi_chip ad1938_spi_chip_info = {
+	.enable_dma = 0,
+	.bits_per_word = 8,
+	.cs_gpio = GPIO_PF5,
+};
+#endif
+
 #if defined(CONFIG_AD9960) || defined(CONFIG_AD9960_MODULE)
 static struct bfin5xx_spi_chip ad9960_spi_chip_info = {
 	.enable_dma = 0,
@@ -754,6 +763,18 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.controller_data = &ad1836_spi_chip_info,
 	},
 #endif
+
+#if defined(CONFIG_SND_BF5XX_SOC_AD1938) || defined(CONFIG_SND_BF5XX_SOC_AD1938_MODULE)
+	{
+		.modalias = "ad1938-spi",
+		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0,
+		.chip_select = 0,/* CONFIG_SND_BLACKFIN_SPI_PFBIT */
+		.controller_data = &ad1938_spi_chip_info,
+		.mode = SPI_MODE_3,
+	},
+#endif
+
 #if defined(CONFIG_AD9960) || defined(CONFIG_AD9960_MODULE)
 	{
 		.modalias = "ad9960-spi",
-- 
1.6.4.2

