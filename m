Return-Path: <linux-kernel-owner+w=401wt.eu-S1757576AbYCKBf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbYCKBf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 21:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbYCKBfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 21:35:50 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:56119 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbYCKBft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 21:35:49 -0400
Message-ID: <47D5E1ED.3020804@tiscali.nl>
Date: Tue, 11 Mar 2008 02:35:41 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: jens.axboe@oracle.com
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] block/blk-merge.c: inverted likeliness in ll_back_merge_fn()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In my likely profile it appears this one is inverted.
---
Invert likeliness

Signed-off-by: Roel Kluin <12o3l@tiscali.nl> 
---
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 0f58616..b17777a 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -305,7 +305,7 @@ int ll_back_merge_fn(struct request_queue *q, struct request *req,
 	}
 	if (unlikely(!bio_flagged(req->biotail, BIO_SEG_VALID)))
 		blk_recount_segments(q, req->biotail);
-	if (unlikely(!bio_flagged(bio, BIO_SEG_VALID)))
+	if (likely(!bio_flagged(bio, BIO_SEG_VALID)))
 		blk_recount_segments(q, bio);
 	len = req->biotail->bi_hw_back_size + bio->bi_hw_front_size;
 	if (BIOVEC_VIRT_MERGEABLE(__BVEC_END(req->biotail), __BVEC_START(bio))
