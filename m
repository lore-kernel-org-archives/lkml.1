Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbZDWM2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbZDWM2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 08:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754552AbZDWM1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 08:27:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:38552 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbZDWM1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 08:27:20 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, joerg@dorchain.net,
       geert@linux-m68k.org, donari75@gmail.com, davem@davemloft.net,
       jdike@linux.intel.com, benh@kernel.crashing.org, Laurent@lvivier.info
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/12] block-update-end_cur
Date: Thu, 23 Apr 2009 21:25:42 +0900
Message-Id: <1240489553-15724-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1240489553-15724-1-git-send-email-tj@kernel.org>
References: <1240489553-15724-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 23 Apr 2009 12:26:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 include/linux/blkdev.h |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 12c545e..3a5b1bd 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -903,10 +903,14 @@ static inline void blk_end_request_all(struct request *rq, int error)
  *
  * Description:
  *     Complete the current consecutively mapped chunk from @rq.
+ *
+ * Return:
+ *     %false - we are done with this request
+ *     %true  - still buffers pending for this request
  */
-static inline void blk_end_request_cur(struct request *rq, int error)
+static inline bool blk_end_request_cur(struct request *rq, int error)
 {
-	blk_end_request(rq, error, rq->hard_cur_sectors << 9);
+	return blk_end_request(rq, error, rq->hard_cur_sectors << 9);
 }
 
 /**
@@ -952,10 +956,14 @@ static inline void __blk_end_request_all(struct request *rq, int error)
  * Description:
  *     Complete the current consecutively mapped chunk from @rq.  Must
  *     be called with queue lock held.
+ *
+ * Return:
+ *     %false - we are done with this request
+ *     %true  - still buffers pending for this request
  */
-static inline void __blk_end_request_cur(struct request *rq, int error)
+static inline bool __blk_end_request_cur(struct request *rq, int error)
 {
-	__blk_end_request(rq, error, rq->hard_cur_sectors << 9);
+	return __blk_end_request(rq, error, rq->hard_cur_sectors << 9);
 }
 
 extern void blk_complete_request(struct request *);
-- 
1.6.0.2

