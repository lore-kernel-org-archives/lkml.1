Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548Ab0AGBsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab0AGBsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 20:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755909Ab0AGBsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 20:48:51 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:54414 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873Ab0AGBsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 20:48:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Uu3YCDLVS4/ggmcCdWOBwsupcGZcTCkTAmTFGigBbRdG+GVI5ajdIIXe42iGP4phXt
         KhIi4AAA7/4NoLbxMf2yjdgDwcUCz70OndC3L+scyR2zOph10d483dwpFGQE1E1XHSv+
         5J/c8FF7KBCOBwnIOsss3DKhS1oxrEEW3Pai0=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 1/4] mtd: mxc_nand: avoid NULL pointer dereference
Date: Thu,  7 Jan 2010 04:48:38 +0300
Message-Id: <1262828921-29517-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assign nand_chip and host only if host is not NULL.

Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/mtd/nand/mxc_nand.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
index 45dec57..4ace54c 100644
--- a/drivers/mtd/nand/mxc_nand.c
+++ b/drivers/mtd/nand/mxc_nand.c
@@ -881,12 +881,14 @@ static int __devexit mxcnd_remove(struct platform_device *pdev)
 static int mxcnd_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	struct mtd_info *mtd = platform_get_drvdata(pdev);
-	struct nand_chip *nand_chip = mtd->priv;
-	struct mxc_nand_host *host = nand_chip->priv;
+	struct nand_chip *nand_chip;
+	struct mxc_nand_host *host;
 	int ret = 0;
 
 	DEBUG(MTD_DEBUG_LEVEL0, "MXC_ND : NAND suspend\n");
 	if (mtd) {
+		nand_chip = mtd->priv;
+		host = nand_chip->priv;
 		ret = mtd->suspend(mtd);
 		/* Disable the NFC clock */
 		clk_disable(host->clk);
@@ -898,13 +900,15 @@ static int mxcnd_suspend(struct platform_device *pdev, pm_message_t state)
 static int mxcnd_resume(struct platform_device *pdev)
 {
 	struct mtd_info *mtd = platform_get_drvdata(pdev);
-	struct nand_chip *nand_chip = mtd->priv;
-	struct mxc_nand_host *host = nand_chip->priv;
+	struct nand_chip *nand_chip;
+	struct mxc_nand_host *host;
 	int ret = 0;
 
 	DEBUG(MTD_DEBUG_LEVEL0, "MXC_ND : NAND resume\n");
 
 	if (mtd) {
+		nand_chip = mtd->priv;
+		host = nand_chip->priv;
 		/* Enable the NFC clock */
 		clk_enable(host->clk);
 		mtd->resume(mtd);
-- 
1.6.6

