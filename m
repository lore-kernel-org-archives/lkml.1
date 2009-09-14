Return-Path: <linux-kernel-owner+w=401wt.eu-S933641AbZINUYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933641AbZINUYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933829AbZINUYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:24:16 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:53977 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756910AbZINUIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:15 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Yi Li <yi.li@analog.com>
Subject: [PATCH 02/72] Blackfin: bf537-stamp: declare SPI IRQ resources
Date: Mon, 14 Sep 2009 16:07:06 -0400
Message-Id: <1252958896-25150-3-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yi Li <yi.li@analog.com>

Signed-off-by: Yi Li <yi.li@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/bfin5xx_spi.h |    1 +
 arch/blackfin/mach-bf537/boards/stamp.c |    6 ++++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/include/asm/bfin5xx_spi.h b/arch/blackfin/include/asm/bfin5xx_spi.h
index aaeb4df..c281c63 100644
--- a/arch/blackfin/include/asm/bfin5xx_spi.h
+++ b/arch/blackfin/include/asm/bfin5xx_spi.h
@@ -127,6 +127,7 @@ struct bfin5xx_spi_chip {
 	u32 cs_gpio;
 	/* Value to send if no TX value is supplied, usually 0x0 or 0xFFFF */
 	u16 idle_tx_val;
+	u8 pio_interrupt; /* Enable spi data irq */
 };
 
 #endif /* _SPI_CHANNEL_H_ */
diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index b8e8c92..d619313 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -555,6 +555,7 @@ static struct mmc_spi_platform_data bfin_mmc_spi_pdata = {
 static struct bfin5xx_spi_chip  mmc_spi_chip_info = {
 	.enable_dma = 0,
 	.bits_per_word = 8,
+	.pio_interrupt = 0,
 };
 #endif
 
@@ -864,6 +865,11 @@ static struct resource bfin_spi0_resource[] = {
 	[1] = {
 		.start = CH_SPI,
 		.end   = CH_SPI,
+		.flags = IORESOURCE_DMA,
+	},
+	[2] = {
+		.start = IRQ_SPI,
+		.end   = IRQ_SPI,
 		.flags = IORESOURCE_IRQ,
 	},
 };
-- 
1.6.4.2

