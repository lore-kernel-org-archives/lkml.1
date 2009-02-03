Return-Path: <linux-kernel-owner+w=401wt.eu-S1755595AbZBCN6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbZBCN6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 08:58:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488AbZBCN6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 08:58:44 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35585 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbZBCN6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 08:58:43 -0500
Date: Tue, 3 Feb 2009 11:58:29 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip 1/1] blktrace: fix coding style in recent patches
Message-ID: <20090203135829.GH17781@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup
    
I introduced some, then, while testing with checkpatch --file
block/blktrace.c I saw some long lines and fixed those too, some were
even from older patches I sent, shame on me ;-\
    
Cc: Jens Axboe <jens.axboe@oracle.com>
Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/block/blktrace.c b/block/blktrace.c
index 4f45b34..8f5c37b 100644
--- a/block/blktrace.c
+++ b/block/blktrace.c
@@ -24,7 +24,7 @@
 #include <linux/debugfs.h>
 #include <linux/time.h>
 #include <trace/block.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <../kernel/trace/trace_output.h>
 
 static unsigned int blktrace_seq __read_mostly = 1;
@@ -148,11 +148,12 @@ static int act_log_check(struct blk_trace *bt, u32 what, sector_t sector,
 /*
  * Data direction bit lookup
  */
-static u32 ddir_act[2] __read_mostly = { BLK_TC_ACT(BLK_TC_READ), BLK_TC_ACT(BLK_TC_WRITE) };
+static u32 ddir_act[2] __read_mostly = { BLK_TC_ACT(BLK_TC_READ),
+					 BLK_TC_ACT(BLK_TC_WRITE) };
 
 /* The ilog2() calls fall out because they're constant */
-#define MASK_TC_BIT(rw, __name) ( (rw & (1 << BIO_RW_ ## __name)) << \
-	  (ilog2(BLK_TC_ ## __name) + BLK_TC_SHIFT - BIO_RW_ ## __name) )
+#define MASK_TC_BIT(rw, __name) ((rw & (1 << BIO_RW_ ## __name)) << \
+	  (ilog2(BLK_TC_ ## __name) + BLK_TC_SHIFT - BIO_RW_ ## __name))
 
 /*
  * The worker for the various blk_add_trace*() types. Fills out a
@@ -221,13 +222,13 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 		t->time = ktime_to_ns(ktime_get());
 record_it:
 		/*
- 		 * These two are not needed in ftrace as they are in the
- 		 * generic trace_entry, filled by tracing_generic_entry_update,
- 		 * but for the trace_event->bin() synthesizer benefit we do it
- 		 * here too.
- 		 */
- 		t->cpu = cpu;
- 		t->pid = pid;
+		 * These two are not needed in ftrace as they are in the
+		 * generic trace_entry, filled by tracing_generic_entry_update,
+		 * but for the trace_event->bin() synthesizer benefit we do it
+		 * here too.
+		 */
+		t->cpu = cpu;
+		t->pid = pid;
 
 		t->sector = sector;
 		t->bytes = bytes;
@@ -453,7 +454,8 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 	atomic_set(&bt->dropped, 0);
 
 	ret = -EIO;
-	bt->dropped_file = debugfs_create_file("dropped", 0444, dir, bt, &blk_dropped_fops);
+	bt->dropped_file = debugfs_create_file("dropped", 0444, dir, bt,
+					       &blk_dropped_fops);
 	if (!bt->dropped_file)
 		goto err;
 
@@ -535,10 +537,10 @@ EXPORT_SYMBOL_GPL(blk_trace_setup);
 
 int blk_trace_startstop(struct request_queue *q, int start)
 {
-	struct blk_trace *bt;
 	int ret;
+	struct blk_trace *bt = q->blk_trace;
 
-	if ((bt = q->blk_trace) == NULL)
+	if (bt == NULL)
 		return -EINVAL;
 
 	/*
@@ -674,12 +676,14 @@ static void blk_add_trace_rq_issue(struct request_queue *q, struct request *rq)
 	blk_add_trace_rq(q, rq, BLK_TA_ISSUE);
 }
 
-static void blk_add_trace_rq_requeue(struct request_queue *q, struct request *rq)
+static void blk_add_trace_rq_requeue(struct request_queue *q,
+				     struct request *rq)
 {
 	blk_add_trace_rq(q, rq, BLK_TA_REQUEUE);
 }
 
-static void blk_add_trace_rq_complete(struct request_queue *q, struct request *rq)
+static void blk_add_trace_rq_complete(struct request_queue *q,
+				      struct request *rq)
 {
 	blk_add_trace_rq(q, rq, BLK_TA_COMPLETE);
 }
@@ -716,12 +720,14 @@ static void blk_add_trace_bio_complete(struct request_queue *q, struct bio *bio)
 	blk_add_trace_bio(q, bio, BLK_TA_COMPLETE);
 }
 
-static void blk_add_trace_bio_backmerge(struct request_queue *q, struct bio *bio)
+static void blk_add_trace_bio_backmerge(struct request_queue *q,
+					struct bio *bio)
 {
 	blk_add_trace_bio(q, bio, BLK_TA_BACKMERGE);
 }
 
-static void blk_add_trace_bio_frontmerge(struct request_queue *q, struct bio *bio)
+static void blk_add_trace_bio_frontmerge(struct request_queue *q,
+					 struct bio *bio)
 {
 	blk_add_trace_bio(q, bio, BLK_TA_FRONTMERGE);
 }
@@ -731,7 +737,8 @@ static void blk_add_trace_bio_queue(struct request_queue *q, struct bio *bio)
 	blk_add_trace_bio(q, bio, BLK_TA_QUEUE);
 }
 
-static void blk_add_trace_getrq(struct request_queue *q, struct bio *bio, int rw)
+static void blk_add_trace_getrq(struct request_queue *q,
+				struct bio *bio, int rw)
 {
 	if (bio)
 		blk_add_trace_bio(q, bio, BLK_TA_GETRQ);
@@ -744,7 +751,8 @@ static void blk_add_trace_getrq(struct request_queue *q, struct bio *bio, int rw
 }
 
 
-static void blk_add_trace_sleeprq(struct request_queue *q, struct bio *bio, int rw)
+static void blk_add_trace_sleeprq(struct request_queue *q,
+				  struct bio *bio, int rw)
 {
 	if (bio)
 		blk_add_trace_bio(q, bio, BLK_TA_SLEEPRQ);
@@ -752,7 +760,8 @@ static void blk_add_trace_sleeprq(struct request_queue *q, struct bio *bio, int
 		struct blk_trace *bt = q->blk_trace;
 
 		if (bt)
-			__blk_add_trace(bt, 0, 0, rw, BLK_TA_SLEEPRQ, 0, 0, NULL);
+			__blk_add_trace(bt, 0, 0, rw, BLK_TA_SLEEPRQ,
+					0, 0, NULL);
 	}
 }
 
