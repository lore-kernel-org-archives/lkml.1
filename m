Return-Path: <linux-kernel-owner+w=401wt.eu-S1756151AbYGJAC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbYGJAC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 20:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbYGJACD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 20:02:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:53467 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbYGJACB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 20:02:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,333,1212390000"; 
   d="scan'208";a="304842053"
From: Tomas Winkler <tomas.winkler@intel.com>
To: drzeus-list@drzeus.cx
Cc: linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] MMC: sido_io.c Fix sparse warnings
Date: Thu, 10 Jul 2008 03:01:56 +0300
Message-Id: <1215648116-2070-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.5.4.1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfold nested macros it creates not readable code and
sparse warnings
sdio_io.c:190:9: warning: symbol '_min1' shadows an earlier one

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/mmc/core/sdio_io.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/core/sdio_io.c b/drivers/mmc/core/sdio_io.c
index 0888df6..f61fc2d 100755
--- a/drivers/mmc/core/sdio_io.c
+++ b/drivers/mmc/core/sdio_io.c
@@ -187,11 +187,10 @@ EXPORT_SYMBOL_GPL(sdio_set_block_size);
  */
 static inline unsigned int sdio_max_byte_size(struct sdio_func *func)
 {
-	return min(min(min(
-		func->card->host->max_seg_size,
-		func->card->host->max_blk_size),
-		func->max_blksize),
-		512u); /* maximum size for byte mode */
+	unsigned mval =	min(func->card->host->max_seg_size,
+			    func->card->host->max_blk_size);
+	mval = min(mval, func->max_blksize);
+	return min(mval, 512u); /* maximum size for byte mode */
 }
 
 /**
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

