Return-Path: <linux-kernel-owner+w=401wt.eu-S1758722AbYG0G3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722AbYG0G3b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758281AbYG0G3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:29:16 -0400
Received: from po-out-1718.google.com ([72.14.252.154]:28204 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758260AbYG0G3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:29:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=N8UC4o30VXTr9wbqtdQkjV0kSLAwp9ZIHHXOmPk3l42etEOj6jvD6XhGrsWThFT5S3
         cDgabFnN8odNMU8a4ZG7chd0fOPkZW960eGY8QaBmA6PGYvPBC3zIsutZPuSuZJUBVke
         YQF6tMTTwv1BTUXq8zJkWDQQaixUH8+DxLlGw=
From: Bryan Wu <cooloney@kernel.org>
To: dwmw2@infradead.org, akpm@linux-foundation.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 4/7] [MTD] Blackfin NFC Driver: add proper devinit/devexit markings to probe/remove functions
Date: Sun, 27 Jul 2008 14:27:56 +0800
Message-Id: <1217140079-20014-5-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1217140079-20014-1-git-send-email-cooloney@kernel.org>
References: <1217140079-20014-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/mtd/nand/bf5xx_nand.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/bf5xx_nand.c b/drivers/mtd/nand/bf5xx_nand.c
index 3555f6b..e259a7b 100644
--- a/drivers/mtd/nand/bf5xx_nand.c
+++ b/drivers/mtd/nand/bf5xx_nand.c
@@ -640,7 +640,7 @@ static int bf5xx_nand_add_partition(struct bf5xx_nand_info *info)
 #endif
 }
 
-static int bf5xx_nand_remove(struct platform_device *pdev)
+static int __devexit bf5xx_nand_remove(struct platform_device *pdev)
 {
 	struct bf5xx_nand_info *info = to_nand_info(pdev);
 	struct mtd_info *mtd = NULL;
@@ -673,7 +673,7 @@ static int bf5xx_nand_remove(struct platform_device *pdev)
  * it can allocate all necessary resources then calls the
  * nand layer to look for devices
  */
-static int bf5xx_nand_probe(struct platform_device *pdev)
+static int __devinit bf5xx_nand_probe(struct platform_device *pdev)
 {
 	struct bf5xx_nand_platform *plat = to_nand_plat(pdev);
 	struct bf5xx_nand_info *info = NULL;
@@ -815,7 +815,7 @@ static int bf5xx_nand_resume(struct platform_device *dev)
 /* driver device registration */
 static struct platform_driver bf5xx_nand_driver = {
 	.probe		= bf5xx_nand_probe,
-	.remove		= bf5xx_nand_remove,
+	.remove		= __devexit_p(bf5xx_nand_remove),
 	.suspend	= bf5xx_nand_suspend,
 	.resume		= bf5xx_nand_resume,
 	.driver		= {
-- 
1.5.6

