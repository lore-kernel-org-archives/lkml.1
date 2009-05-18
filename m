Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbZERII1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbZERII1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 04:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbZERIIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 04:08:04 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:46520 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbZERIID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 04:08:03 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mtd@lists.infradead.org
Subject: [PATCH] plat_nand: add missing __devexit_p()
Date: Mon, 18 May 2009 04:08:01 -0400
Message-Id: <1242634081-16593-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The remove function uses __devexit, so the .remove assignment needs
__devexit_p() to fix a build error with hotplug disabled.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
CC: linux-mtd@lists.infradead.org
---
 drivers/mtd/nand/plat_nand.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/plat_nand.c b/drivers/mtd/nand/plat_nand.c
index 86e1d08..28ffd4e 100644
--- a/drivers/mtd/nand/plat_nand.c
+++ b/drivers/mtd/nand/plat_nand.c
@@ -128,7 +128,7 @@ static int __devexit plat_nand_remove(struct platform_device *pdev)
 
 static struct platform_driver plat_nand_driver = {
 	.probe		= plat_nand_probe,
-	.remove		= plat_nand_remove,
+	.remove		= __devexit_p(plat_nand_remove),
 	.driver		= {
 		.name	= "gen_nand",
 		.owner	= THIS_MODULE,
-- 
1.6.3

