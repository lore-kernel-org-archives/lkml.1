Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbZFEIHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbZFEIHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755200AbZFEIF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:05:29 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37454 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbZFEIFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:17 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Yi Li <yi.li@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 03/62] Blackfin: bf527-ezkit: add support for mmc-spi
Date: Fri,  5 Jun 2009 04:04:12 -0400
Message-Id: <1244189111-19639-4-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yi Li <yi.li@analog.com>

Signed-off-by: Yi Li <yi.li@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 arch/blackfin/mach-bf527/boards/ezkit.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/mach-bf527/boards/ezkit.c b/arch/blackfin/mach-bf527/boards/ezkit.c
index d086411..9ab8d8c 100644
--- a/arch/blackfin/mach-bf527/boards/ezkit.c
+++ b/arch/blackfin/mach-bf527/boards/ezkit.c
@@ -509,6 +509,13 @@ static struct bfin5xx_spi_chip ad9960_spi_chip_info = {
 };
 #endif
 
+#if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
+static struct bfin5xx_spi_chip  mmc_spi_chip_info = {
+	.enable_dma = 0,
+	.bits_per_word = 8,
+};
+#endif
+
 #if defined(CONFIG_PBX)
 static struct bfin5xx_spi_chip spi_si3xxx_chip_info = {
 	.ctl_reg	= 0x4, /* send zero */
@@ -624,6 +631,17 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.controller_data = &ad9960_spi_chip_info,
 	},
 #endif
+#if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
+	{
+		.modalias = "mmc_spi",
+		.max_speed_hz = 20000000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0,
+		.chip_select = 3,
+		.controller_data = &mmc_spi_chip_info,
+		.mode = SPI_MODE_0,
+	},
+#endif
+
 #if defined(CONFIG_PBX)
 	{
 		.modalias = "fxs-spi",
-- 
1.6.3.1

