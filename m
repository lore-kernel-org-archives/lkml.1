Return-Path: <linux-kernel-owner+w=401wt.eu-S1757803AbYG0GaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803AbYG0GaG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757886AbYG0G3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:29:51 -0400
Received: from po-out-1718.google.com ([72.14.252.154]:28275 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758796AbYG0G3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:29:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=G60AO4ot2kskxjHHkysIWYd6w0EhqHvMYphSt3JZ9CI1XyejiLCgLsIam+UfZavLzP
         jx2xurOzXI1htn4cmi1K2zDMrQlpdVJlt3tPHqlwMIMouM5v2uJgpOjZXI7EVwjPLAp0
         excZFxiZv2EZs28dCjcNqsL9+TBv+lYuW9xFY=
From: Bryan Wu <cooloney@kernel.org>
To: dwmw2@infradead.org, akpm@linux-foundation.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 6/7] [MTD] Blackfin NFC Driver: use standard dev_err() rather than printk()
Date: Sun, 27 Jul 2008 14:27:58 +0800
Message-Id: <1217140079-20014-7-git-send-email-cooloney@kernel.org>
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
 drivers/mtd/nand/bf5xx_nand.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/bf5xx_nand.c b/drivers/mtd/nand/bf5xx_nand.c
index e259a7b..6cf7fb8 100644
--- a/drivers/mtd/nand/bf5xx_nand.c
+++ b/drivers/mtd/nand/bf5xx_nand.c
@@ -684,8 +684,7 @@ static int __devinit bf5xx_nand_probe(struct platform_device *pdev)
 	dev_dbg(&pdev->dev, "(%p)\n", pdev);
 
 	if (peripheral_request_list(bfin_nfc_pin_req, DRV_NAME)) {
-		printk(KERN_ERR DRV_NAME
-		": Requesting Peripherals failed\n");
+		dev_err(&pdev->dev, "requesting Peripherals failed\n");
 		return -EFAULT;
 	}
 
-- 
1.5.6

