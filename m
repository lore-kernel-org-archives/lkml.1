Return-Path: <linux-kernel-owner+w=401wt.eu-S1758123AbYFSKSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123AbYFSKSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 06:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755490AbYFSKS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 06:18:28 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:30725 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389AbYFSKS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 06:18:27 -0400
X-IronPort-AV: E=Sophos;i="4.27,672,1204520400"; 
   d="scan'208";a="70443804"
From: Bryan Wu <cooloney@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Cc: Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 2/2] [MTD] Blackfin NFC Driver: fix bug - hw ecc calc by making sure we extract 11 bits from each register instead of 10
Date: Thu, 19 Jun 2008 18:18:29 +0800
Message-Id: <1213870709-17356-3-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1213870709-17356-1-git-send-email-cooloney@kernel.org>
References: <1213870709-17356-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/mtd/nand/bf5xx_nand.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/bf5xx_nand.c b/drivers/mtd/nand/bf5xx_nand.c
index 3254348..fc58afe 100644
--- a/drivers/mtd/nand/bf5xx_nand.c
+++ b/drivers/mtd/nand/bf5xx_nand.c
@@ -298,7 +298,7 @@ static int bf5xx_nand_calculate_ecc(struct mtd_info *mtd,
 	ecc0 = bfin_read_NFC_ECC0();
 	ecc1 = bfin_read_NFC_ECC1();
 
-	code[0] = (ecc0 & 0x3FF) | ((ecc1 & 0x3FF) << 11);
+	code[0] = (ecc0 & 0x7ff) | ((ecc1 & 0x7ff) << 11);
 
 	dev_dbg(info->device, "returning ecc 0x%08x\n", code[0]);
 
@@ -310,7 +310,7 @@ static int bf5xx_nand_calculate_ecc(struct mtd_info *mtd,
 	if (page_size == 512) {
 		ecc0 = bfin_read_NFC_ECC2();
 		ecc1 = bfin_read_NFC_ECC3();
-		code[1] = (ecc0 & 0x3FF) | ((ecc1 & 0x3FF) << 11);
+		code[1] = (ecc0 & 0x7ff) | ((ecc1 & 0x7ff) << 11);
 
 		/* second 3 bytes in ecc_code for second 256
 		 * bytes of 512 page size
-- 
1.5.6
