Return-Path: <linux-kernel-owner+w=401wt.eu-S1752835AbYG0G2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbYG0G2h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756984AbYG0G21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:28:27 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:35709 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbYG0G20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:28:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=JSJndqv/uo4OYjRDnxTUjuqZVUFk9sgZXUPcWGQWbzBrOiyvxP33frIacX8KtPEQzG
         gYgggTkEWMi7XiNtWkPc4dW9tQwGKLlUz4cJU/BkrEzpqCqyMHPHnQ+0+iUBKPU9DFG2
         HBkPvaVI++vJgIogtzyuD+MiB8MFENNCLKxgM=
From: Bryan Wu <cooloney@kernel.org>
To: dwmw2@infradead.org, akpm@linux-foundation.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/7] [MTD] Blackfin NFC Driver: fix bug - do not clobber the status from the first 256 bytes if operating on 512 pages
Date: Sun, 27 Jul 2008 14:27:53 +0800
Message-Id: <1217140079-20014-2-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1217140079-20014-1-git-send-email-cooloney@kernel.org>
References: <1217140079-20014-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Singed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/mtd/nand/bf5xx_nand.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/bf5xx_nand.c b/drivers/mtd/nand/bf5xx_nand.c
index e87a572..3254348 100644
--- a/drivers/mtd/nand/bf5xx_nand.c
+++ b/drivers/mtd/nand/bf5xx_nand.c
@@ -273,7 +273,7 @@ static int bf5xx_nand_correct_data(struct mtd_info *mtd, u_char *dat,
 		dat += 256;
 		read_ecc += 8;
 		calc_ecc += 8;
-		ret = bf5xx_nand_correct_data_256(mtd, dat, read_ecc, calc_ecc);
+		ret |= bf5xx_nand_correct_data_256(mtd, dat, read_ecc, calc_ecc);
 	}
 
 	return ret;
-- 
1.5.6

