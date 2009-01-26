Return-Path: <linux-kernel-owner+w=401wt.eu-S1752853AbZAZRBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbZAZRBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 12:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbZAZRBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 12:01:16 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50403 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbZAZRBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 12:01:15 -0500
Date: Mon, 26 Jan 2009 15:00:56 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip][1/1] Fixup checkpatch reported problems in ftrace
	plugin patch
Message-ID: <20090126170056.GH1455@ghostprotocols.net>
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

blktrace: Fixup checkpatch reported problems in ftrace plugin patch
    
Also make sure sparse (make C=2 block/blktrace.o) is happy too.
    
Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/block/blktrace.c b/block/blktrace.c
index 630f167..1b2267c 100644
--- a/block/blktrace.c
+++ b/block/blktrace.c
@@ -37,7 +37,7 @@ static int __read_mostly  blk_tracer_enabled;
 
 static struct tracer_opt blk_tracer_opts[] = {
 	/* Default disable the minimalistic output */
-	{ TRACER_OPT(blk_classic, TRACE_BLK_OPT_CLASSIC ) },
+	{ TRACER_OPT(blk_classic, TRACE_BLK_OPT_CLASSIC) },
 	{ }
 };
 
@@ -169,7 +169,8 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 	pid_t pid;
 	int cpu, pc = 0;
 
-	if (unlikely(bt->trace_state != Blktrace_running || !blk_tracer_enabled))
+	if (unlikely(bt->trace_state != Blktrace_running ||
+		     !blk_tracer_enabled))
 		return;
 
 	what |= ddir_act[rw & WRITE];
@@ -192,7 +193,7 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 						 sizeof(*t) + pdu_len, &flags);
 		if (!event)
 			return;
-		
+
 		ent = ring_buffer_event_data(event);
 		t = (struct blk_io_trace *)ent;
 		pc = preempt_count();
@@ -234,7 +235,7 @@ record_it:
 		if (blk_tr) {
 			ring_buffer_unlock_commit(blk_tr->buffer, event, flags);
 			if (pid != 0 &&
-			    (blk_tracer_flags.val & TRACE_BLK_OPT_CLASSIC) == 0 &&
+			    !(blk_tracer_flags.val & TRACE_BLK_OPT_CLASSIC) &&
 			    (trace_flags & TRACE_ITER_STACKTRACE) != 0)
 				__trace_stack(blk_tr, NULL, flags, 5, pc);
 			trace_wake_up();
@@ -955,19 +956,27 @@ static void blk_unregister_tracepoints(void)
 
 static void fill_rwbs(char *rwbs, const struct blk_io_trace *t)
 {
-        int i = 0;
+	int i = 0;
 
-        if (t->action & BLK_TC_DISCARD)	   rwbs[i++] = 'D';
-        else if (t->action & BLK_TC_WRITE) rwbs[i++] = 'W';
-        else if (t->bytes)		   rwbs[i++] = 'R';
-        else				   rwbs[i++] = 'N';
+	if (t->action & BLK_TC_DISCARD)
+		rwbs[i++] = 'D';
+	else if (t->action & BLK_TC_WRITE)
+		rwbs[i++] = 'W';
+	else if (t->bytes)
+		rwbs[i++] = 'R';
+	else
+		rwbs[i++] = 'N';
 
-        if (t->action & BLK_TC_AHEAD)	   rwbs[i++] = 'A';
-        if (t->action & BLK_TC_BARRIER)	   rwbs[i++] = 'B';
-        if (t->action & BLK_TC_SYNC)	   rwbs[i++] = 'S';
-        if (t->action & BLK_TC_META)	   rwbs[i++] = 'M';
+	if (t->action & BLK_TC_AHEAD)
+		rwbs[i++] = 'A';
+	if (t->action & BLK_TC_BARRIER)
+		rwbs[i++] = 'B';
+	if (t->action & BLK_TC_SYNC)
+		rwbs[i++] = 'S';
+	if (t->action & BLK_TC_META)
+		rwbs[i++] = 'M';
 
-        rwbs[i] = '\0';
+	rwbs[i] = '\0';
 }
 
 static inline
@@ -1049,7 +1058,8 @@ static int blk_log_generic(struct trace_seq *s, const struct trace_entry *ent)
 	return trace_seq_printf(s, "[%s]\n", cmd);
 }
 
-static int blk_log_with_error(struct trace_seq *s, const struct trace_entry *ent)
+static int blk_log_with_error(struct trace_seq *s,
+			      const struct trace_entry *ent)
 {
 	if (t_sec(ent))
 		return trace_seq_printf(s, "%llu + %u [%d]\n", t_sector(ent),
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 01714ef..8a17f7e 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -19,6 +19,7 @@
 #include <linux/kmod.h>
 #include <linux/ctype.h>
 #include <linux/genhd.h>
+#include <linux/blktrace_api.h>
 
 #include "check.h"
 
@@ -268,10 +269,6 @@ ssize_t part_fail_store(struct device *dev,
 }
 #endif
 
-#ifdef CONFIG_BLK_DEV_IO_TRACE
-extern struct attribute_group blk_trace_attr_group;
-#endif
-
 static DEVICE_ATTR(partition, S_IRUGO, part_partition_show, NULL);
 static DEVICE_ATTR(start, S_IRUGO, part_start_show, NULL);
 static DEVICE_ATTR(size, S_IRUGO, part_size_show, NULL);
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index e9ef923..f231929 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -144,6 +144,9 @@ struct blk_user_trace_setup {
 
 #ifdef __KERNEL__
 #if defined(CONFIG_BLK_DEV_IO_TRACE)
+
+#include <linux/sysfs.h>
+
 struct blk_trace {
 	int trace_state;
 	struct rchan *rchan;
@@ -194,6 +197,8 @@ extern int blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 extern int blk_trace_startstop(struct request_queue *q, int start);
 extern int blk_trace_remove(struct request_queue *q);
 
+extern struct attribute_group blk_trace_attr_group;
+
 #else /* !CONFIG_BLK_DEV_IO_TRACE */
 #define blk_trace_ioctl(bdev, cmd, arg)		(-ENOTTY)
 #define blk_trace_shutdown(q)			do { } while (0)
