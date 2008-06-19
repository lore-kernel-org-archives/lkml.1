Return-Path: <linux-kernel-owner+w=401wt.eu-S1758281AbYFSKTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281AbYFSKTJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 06:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755572AbYFSKS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 06:18:28 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:32834 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397AbYFSKS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 06:18:27 -0400
X-IronPort-AV: E=Sophos;i="4.27,672,1204520400"; 
   d="scan'208";a="55405266"
From: Bryan Wu <cooloney@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Cc: Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/2] [MTD] Blackfin NFC Driver: fix bug - do not clobber the status from the first 256 bytes if operating on 512 pages
Date: Thu, 19 Jun 2008 18:18:28 +0800
Message-Id: <1213870709-17356-2-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1213870709-17356-1-git-send-email-cooloney@kernel.org>
References: <1213870709-17356-1-git-send-email-cooloney@kernel.org>
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
