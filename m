Return-Path: <linux-kernel-owner+w=401wt.eu-S1756538AbZBEHaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbZBEHaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 02:30:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbZBEHaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 02:30:06 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:65402 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbZBEHaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 02:30:05 -0500
X-IronPort-AV: E=Sophos;i="4.37,384,1231131600"; 
   d="scan'208";a="82344248"
From: Bryan Wu <cooloney@kernel.org>
To: drzeus-mmc@drzeus.cx
Cc: linux-kernel@vger.kernel.org, Yi Li <yi.li@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH] MMC: fix bug - SDHC card capacity not correct
Date: Thu,  5 Feb 2009 15:31:57 +0800
Message-Id: <1233819117-7102-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yi Li <yi.li@analog.com>

Signed-off-by: Yi Li <yi.li@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/mmc/card/block.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 45b1f43..513eb09 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -584,7 +584,7 @@ static int mmc_blk_probe(struct mmc_card *card)
 	if (err)
 		goto out;
 
-	string_get_size(get_capacity(md->disk) << 9, STRING_UNITS_2,
+	string_get_size((u64)get_capacity(md->disk) << 9, STRING_UNITS_2,
 			cap_str, sizeof(cap_str));
 	printk(KERN_INFO "%s: %s %s %s %s\n",
 		md->disk->disk_name, mmc_card_id(card), mmc_card_name(card),
-- 
1.5.6.3
