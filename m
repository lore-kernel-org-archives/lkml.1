Return-Path: <linux-kernel-owner+w=401wt.eu-S1752440AbYDYEIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbYDYEIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 00:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbYDYEH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 00:07:58 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:55293 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbYDYEH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 00:07:57 -0400
X-IronPort-AV: E=Sophos;i="4.25,706,1199682000"; 
   d="scan'208";a="67099940"
From: Bryan Wu <cooloney@kernel.org>
To: linux-mtd@lists.infradead.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org
Cc: Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/3] [mtd] bf5xx_nand driver: Fix BUG - nand driver on bf527 ezkit board crashes if bfin_mac installed
Date: Fri, 25 Apr 2008 12:07:31 +0800
Message-Id: <1209096453-21610-2-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1209096453-21610-1-git-send-email-cooloney@kernel.org>
References: <1209096453-21610-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=4053

Singed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/mtd/nand/bf5xx_nand.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/nand/bf5xx_nand.c b/drivers/mtd/nand/bf5xx_nand.c
index 747042a..a7afe35 100644
--- a/drivers/mtd/nand/bf5xx_nand.c
+++ b/drivers/mtd/nand/bf5xx_nand.c
@@ -1,6 +1,6 @@
 /* linux/drivers/mtd/nand/bf5xx_nand.c
  *
- * Copyright 2006-2007 Analog Devices Inc.
+ * Copyright 2006-2008 Analog Devices Inc.
  *	http://blackfin.uclinux.org/
  *	Bryan Wu <bryan.wu@analog.com>
  *
@@ -74,7 +74,7 @@ static int hardware_ecc = 1;
 static int hardware_ecc;
 #endif
 
-static unsigned short bfin_nfc_pin_req[] =
+static const unsigned short bfin_nfc_pin_req[] =
 	{P_NAND_CE,
 	 P_NAND_RB,
 	 P_NAND_D0,
@@ -581,12 +581,6 @@ static int bf5xx_nand_hw_init(struct bf5xx_nand_info *info)
 	bfin_write_NFC_IRQSTAT(val);
 	SSYNC();
 
-	if (peripheral_request_list(bfin_nfc_pin_req, DRV_NAME)) {
-		printk(KERN_ERR DRV_NAME
-		": Requesting Peripherals failed\n");
-		return -EFAULT;
-	}
-
 	/* DMA initialization  */
 	if (bf5xx_nand_dma_init(info))
 		err = -ENXIO;
@@ -654,6 +648,12 @@ static int bf5xx_nand_probe(struct platform_device *pdev)
 
 	dev_dbg(&pdev->dev, "(%p)\n", pdev);
 
+	if (peripheral_request_list(bfin_nfc_pin_req, DRV_NAME)) {
+		printk(KERN_ERR DRV_NAME
+		": Requesting Peripherals failed\n");
+		return -EFAULT;
+	}
+
 	if (!plat) {
 		dev_err(&pdev->dev, "no platform specific information\n");
 		goto exit_error;
-- 
1.5.5
