Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbXJ3JIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbXJ3JIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbXJ3JIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:08:41 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:36466 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbXJ3JIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:08:40 -0400
X-IronPort-AV: i="4.21,346,1188792000"; 
   d="scan'208"; a="42688820:sNHT33580533"
From: Bryan Wu <bryan.wu@analog.com>
To: dwmw2@infradead.org, linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 1/1] [MTD/NAND]: Add Blackfin BF52x on-chip NAND Flash controller driver support in bf5xx_nand driver
Date: Tue, 30 Oct 2007 17:08:29 +0800
Message-Id: <1193735309-7270-1-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/mtd/nand/Kconfig      |    2 +-
 drivers/mtd/nand/bf5xx_nand.c |   20 ++++++++++++++++++--
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 246d451..bf0e9b0 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -93,7 +93,7 @@ config MTD_NAND_AU1550
 
 config MTD_NAND_BF5XX
 	tristate "Blackfin on-chip NAND Flash Controller driver"
-	depends on BF54x && MTD_NAND
+	depends on (BF54x || BF52x) && MTD_NAND
 	help
 	  This enables the Blackfin on-chip NAND flash controller
 
diff --git a/drivers/mtd/nand/bf5xx_nand.c b/drivers/mtd/nand/bf5xx_nand.c
index 1657ecd..542850c 100644
--- a/drivers/mtd/nand/bf5xx_nand.c
+++ b/drivers/mtd/nand/bf5xx_nand.c
@@ -74,7 +74,22 @@ static int hardware_ecc = 1;
 static int hardware_ecc;
 #endif
 
-static unsigned short bfin_nfc_pin_req[] = {P_NAND_CE, P_NAND_RB, 0};
+static unsigned short bfin_nfc_pin_req[] =
+	{P_NAND_CE,
+	 P_NAND_RB,
+	 P_NAND_D0,
+	 P_NAND_D1,
+	 P_NAND_D2,
+	 P_NAND_D3,
+	 P_NAND_D4,
+	 P_NAND_D5,
+	 P_NAND_D6,
+	 P_NAND_D7,
+	 P_NAND_WE,
+	 P_NAND_RE,
+	 P_NAND_CLE,
+	 P_NAND_ALE,
+	 0};
 
 /*
  * Data structures for bf5xx nand flash controller driver
@@ -507,12 +522,13 @@ static int bf5xx_nand_dma_init(struct bf5xx_nand_info *info)
 
 	init_completion(&info->dma_completion);
 
+#ifdef CONFIG_BF54x
 	/* Setup DMAC1 channel mux for NFC which shared with SDH */
 	val = bfin_read_DMAC1_PERIMUX();
 	val &= 0xFFFE;
 	bfin_write_DMAC1_PERIMUX(val);
 	SSYNC();
-
+#endif
 	/* Request NFC DMA channel */
 	ret = request_dma(CH_NFC, "BF5XX NFC driver");
 	if (ret < 0) {
-- 
1.5.3.4
