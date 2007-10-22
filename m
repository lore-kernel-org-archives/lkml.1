Return-Path: <linux-kernel-owner+w=401wt.eu-S1752504AbXJVSMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbXJVSMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 14:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbXJVSMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 14:12:25 -0400
Received: from brick.kernel.dk ([87.55.233.238]:22163 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302AbXJVSMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 14:12:24 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 02/10] [SG] Update block layer to use sg helpers
Date: Mon, 22 Oct 2007 20:10:56 +0200
Message-Id: <1193076664-13652-3-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.3.GIT
In-Reply-To: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/ll_rw_blk.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 8025d64..61c2e39 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -1354,8 +1354,9 @@ new_segment:
 			else
 				sg = sg_next(sg);
 
-			memset(sg, 0, sizeof(*sg));
-			sg->page = bvec->bv_page;
+			sg_dma_len(sg) = 0;
+			sg_dma_address(sg) = 0;
+			sg_set_page(sg, bvec->bv_page);
 			sg->length = nbytes;
 			sg->offset = bvec->bv_offset;
 			nsegs++;
@@ -1363,6 +1364,9 @@ new_segment:
 		bvprv = bvec;
 	} /* segments in rq */
 
+	if (sg)
+		__sg_mark_end(sg);
+
 	return nsegs;
 }
 
-- 
1.5.3.GIT

