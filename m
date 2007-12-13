Return-Path: <linux-kernel-owner+w=401wt.eu-S1763335AbXLMHYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763335AbXLMHYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762375AbXLMHNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 02:13:30 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52016 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764293AbXLMHN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 02:13:29 -0500
Date: Thu, 13 Dec 2007 16:13:11 +0900
From: Kyungmin Park <kyungmin.park@samsung.com>
To: drzeus-list@drzeus.cx
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH][MMC] Fix wrong EXT_CSD_REV handling
Message-ID: <20071213071311.GA2970@party>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It already checked the ext_csd_struct is less than 2,
so it doesn't need to check it.
Current code only accepts the revision 1.2.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 68c0e3b..7689760 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -217,15 +217,13 @@ static int mmc_read_ext_csd(struct mmc_card *card)
 		goto out;
 	}
 
-	if (ext_csd_struct >= 2) {
-		card->ext_csd.sectors =
-			ext_csd[EXT_CSD_SEC_CNT + 0] << 0 |
-			ext_csd[EXT_CSD_SEC_CNT + 1] << 8 |
-			ext_csd[EXT_CSD_SEC_CNT + 2] << 16 |
-			ext_csd[EXT_CSD_SEC_CNT + 3] << 24;
-		if (card->ext_csd.sectors)
-			mmc_card_set_blockaddr(card);
-	}
+	card->ext_csd.sectors =
+		ext_csd[EXT_CSD_SEC_CNT + 0] << 0 |
+		ext_csd[EXT_CSD_SEC_CNT + 1] << 8 |
+		ext_csd[EXT_CSD_SEC_CNT + 2] << 16 |
+		ext_csd[EXT_CSD_SEC_CNT + 3] << 24;
+	if (card->ext_csd.sectors)
+		mmc_card_set_blockaddr(card);
 
 	switch (ext_csd[EXT_CSD_CARD_TYPE]) {
 	case EXT_CSD_CARD_TYPE_52 | EXT_CSD_CARD_TYPE_26:
