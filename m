Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbZKBOkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbZKBOkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 09:40:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755224AbZKBOkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 09:40:49 -0500
Received: from mba.ocn.ne.jp ([122.28.14.163]:51906 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257AbZKBOko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 09:40:44 -0500
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
To: linux-mtd@lists.infradead.org
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] txx9ndfmc: Use nand_release() to free resources
Date: Mon,  2 Nov 2009 23:40:48 +0900
Message-Id: <1257172848-6282-1-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes memory leak on chip->bbt and chip->buffers.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 drivers/mtd/nand/txx9ndfmc.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/txx9ndfmc.c b/drivers/mtd/nand/txx9ndfmc.c
index 73af832..863513c 100644
--- a/drivers/mtd/nand/txx9ndfmc.c
+++ b/drivers/mtd/nand/txx9ndfmc.c
@@ -429,11 +429,10 @@ static int __exit txx9ndfmc_remove(struct platform_device *dev)
 		chip = mtd->priv;
 		txx9_priv = chip->priv;
 
+		nand_release(mtd);
 #ifdef CONFIG_MTD_PARTITIONS
-		del_mtd_partitions(mtd);
 		kfree(drvdata->parts[i]);
 #endif
-		del_mtd_device(mtd);
 		kfree(txx9_priv->mtdname);
 		kfree(txx9_priv);
 	}
-- 
1.5.6.5

