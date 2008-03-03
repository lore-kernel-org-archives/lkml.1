Return-Path: <linux-kernel-owner+w=401wt.eu-S1757263AbYCCBjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263AbYCCBjY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 20:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756337AbYCCBh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 20:37:59 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:65433 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963AbYCCBh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 20:37:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AWz+KRvOIznmMs9U2AHNDFfR80OYtWdxfTBCStG7M6EjtXGajGCJJRDCITJAMDSUsLEia7P+3sjPvZyMB8SyWtFGT5ZaR0DDVFnbvygErOdyH820Qwa8wVpWXAHnHjU4C7dYO6scxSJixNx3nM/kn911nyLIKx6JISDi3K6Py/U=
Subject: [RFC PATCH 2/5] block: remove remaining __FUNCTION__ occurances
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 02 Mar 2008 17:37:56 -0800
Message-Id: <1204508276.3266.5.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 block/blk-barrier.c  |    3 +--
 block/blk-core.c     |    5 ++---
 block/blk-settings.c |   20 ++++++++++----------
 block/blk-tag.c      |    8 ++++----
 block/bsg.c          |    2 +-
 block/elevator.c     |    5 ++---
 6 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index 6901eed..7d6436b 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -26,8 +26,7 @@ int blk_queue_ordered(struct request_queue *q, unsigned ordered,
 {
 	if (ordered & (QUEUE_ORDERED_PREFLUSH | QUEUE_ORDERED_POSTFLUSH) &&
 	    prepare_flush_fn == NULL) {
-		printk(KERN_ERR "%s: prepare_flush_fn required\n",
-								__FUNCTION__);
+		printk(KERN_ERR "%s: prepare_flush_fn required\n", __func__);
 		return -EINVAL;
 	}
 
diff --git a/block/blk-core.c b/block/blk-core.c
index 775c851..f757a6a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -156,7 +156,7 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
 
 		if (unlikely(nbytes > bio->bi_size)) {
 			printk(KERN_ERR "%s: want %u bytes done, %u left\n",
-			       __FUNCTION__, nbytes, bio->bi_size);
+			       __func__, nbytes, bio->bi_size);
 			nbytes = bio->bi_size;
 		}
 
@@ -1575,8 +1575,7 @@ static int __end_that_request_first(struct request *req, int error,
 			if (unlikely(bio->bi_idx >= bio->bi_vcnt)) {
 				blk_dump_rq_flags(req, "__end_that");
 				printk(KERN_ERR "%s: bio idx %d >= vcnt %d\n",
-						__FUNCTION__, bio->bi_idx,
-						bio->bi_vcnt);
+				       __func__, bio->bi_idx, bio->bi_vcnt);
 				break;
 			}
 
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 9a8ffdd..7a12749 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -169,8 +169,8 @@ void blk_queue_max_sectors(struct request_queue *q, unsigned int max_sectors)
 {
 	if ((max_sectors << 9) < PAGE_CACHE_SIZE) {
 		max_sectors = 1 << (PAGE_CACHE_SHIFT - 9);
-		printk(KERN_INFO "%s: set to minimum %d\n", __FUNCTION__,
-							max_sectors);
+		printk(KERN_INFO "%s: set to minimum %d\n",
+		       __func__, max_sectors);
 	}
 
 	if (BLK_DEF_MAX_SECTORS > max_sectors)
@@ -197,8 +197,8 @@ void blk_queue_max_phys_segments(struct request_queue *q,
 {
 	if (!max_segments) {
 		max_segments = 1;
-		printk(KERN_INFO "%s: set to minimum %d\n", __FUNCTION__,
-							max_segments);
+		printk(KERN_INFO "%s: set to minimum %d\n",
+		       __func__, max_segments);
 	}
 
 	q->max_phys_segments = max_segments;
@@ -221,8 +221,8 @@ void blk_queue_max_hw_segments(struct request_queue *q,
 {
 	if (!max_segments) {
 		max_segments = 1;
-		printk(KERN_INFO "%s: set to minimum %d\n", __FUNCTION__,
-							max_segments);
+		printk(KERN_INFO "%s: set to minimum %d\n",
+		       __func__, max_segments);
 	}
 
 	q->max_hw_segments = max_segments;
@@ -242,8 +242,8 @@ void blk_queue_max_segment_size(struct request_queue *q, unsigned int max_size)
 {
 	if (max_size < PAGE_CACHE_SIZE) {
 		max_size = PAGE_CACHE_SIZE;
-		printk(KERN_INFO "%s: set to minimum %d\n", __FUNCTION__,
-							max_size);
+		printk(KERN_INFO "%s: set to minimum %d\n",
+		       __func__, max_size);
 	}
 
 	q->max_segment_size = max_size;
@@ -342,8 +342,8 @@ void blk_queue_segment_boundary(struct request_queue *q, unsigned long mask)
 {
 	if (mask < PAGE_CACHE_SIZE - 1) {
 		mask = PAGE_CACHE_SIZE - 1;
-		printk(KERN_INFO "%s: set to minimum %lx\n", __FUNCTION__,
-							mask);
+		printk(KERN_INFO "%s: set to minimum %lx\n",
+		       __func__, mask);
 	}
 
 	q->seg_boundary_mask = mask;
diff --git a/block/blk-tag.c b/block/blk-tag.c
index a8c37d4..f33d7bb 100644
--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -110,7 +110,7 @@ init_tag_map(struct request_queue *q, struct blk_queue_tag *tags, int depth)
 	if (q && depth > q->nr_requests * 2) {
 		depth = q->nr_requests * 2;
 		printk(KERN_ERR "%s: adjusted depth to %d\n",
-				__FUNCTION__, depth);
+		       __func__, depth);
 	}
 
 	tag_index = kzalloc(depth * sizeof(struct request *), GFP_ATOMIC);
@@ -294,13 +294,13 @@ void blk_queue_end_tag(struct request_queue *q, struct request *rq)
 
 	if (unlikely(bqt->tag_index[tag] == NULL))
 		printk(KERN_ERR "%s: tag %d is missing\n",
-		       __FUNCTION__, tag);
+		       __func__, tag);
 
 	bqt->tag_index[tag] = NULL;
 
 	if (unlikely(!test_bit(tag, bqt->tag_map))) {
 		printk(KERN_ERR "%s: attempt to clear non-busy tag (%d)\n",
-		       __FUNCTION__, tag);
+		       __func__, tag);
 		return;
 	}
 	/*
@@ -338,7 +338,7 @@ int blk_queue_start_tag(struct request_queue *q, struct request *rq)
 	if (unlikely((rq->cmd_flags & REQ_QUEUED))) {
 		printk(KERN_ERR
 		       "%s: request %p for device [%s] already tagged %d",
-		       __FUNCTION__, rq,
+		       __func__, rq,
 		       rq->rq_disk ? rq->rq_disk->disk_name : "?", rq->tag);
 		BUG();
 	}
diff --git a/block/bsg.c b/block/bsg.c
index 7f3c095..e0b66cc 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -58,7 +58,7 @@ enum {
 #undef BSG_DEBUG
 
 #ifdef BSG_DEBUG
-#define dprintk(fmt, args...) printk(KERN_ERR "%s: " fmt, __FUNCTION__, ##args)
+#define dprintk(fmt, args...) printk(KERN_ERR "%s: " fmt, __func__, ##args)
 #else
 #define dprintk(fmt, args...)
 #endif
diff --git a/block/elevator.c b/block/elevator.c
index 88318c3..ef75968 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -647,7 +647,7 @@ void elv_insert(struct request_queue *q, struct request *rq, int where)
 
 	default:
 		printk(KERN_ERR "%s: bad insertion point %d\n",
-		       __FUNCTION__, where);
+		       __func__, where);
 		BUG();
 	}
 
@@ -805,8 +805,7 @@ struct request *elv_next_request(struct request_queue *q)
 			rq->cmd_flags |= REQ_QUIET;
 			end_queued_request(rq, 0);
 		} else {
-			printk(KERN_ERR "%s: bad return=%d\n", __FUNCTION__,
-								ret);
+			printk(KERN_ERR "%s: bad return=%d\n", __func__, ret);
 			break;
 		}
 	}
-- 
1.5.4.3.409.g8811


