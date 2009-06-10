Return-Path: <linux-kernel-owner+w=401wt.eu-S1761117AbZFJRDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761117AbZFJRDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 13:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760381AbZFJRAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 13:00:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59585 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756488AbZFJQ77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 12:59:59 -0400
Message-Id: <20090610170000.965684702@goodmis.org>
References: <20090610165306.794813861@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 10 Jun 2009 12:53:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mel@csn.ul.ie>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [PATCH 11/11] tracing: convert the block trace points to use the new tag format
Content-Disposition: inline; filename=0011-tracing-convert-the-block-trace-points-to-use-the-ne.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Convert the block trace points to use the new tag format for easier parsing
by userspace tools.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/block.h |  101 ++++++++++++++----------------------------
 1 files changed, 34 insertions(+), 67 deletions(-)

diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 53effd4..f12cee3 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -34,11 +34,8 @@ TRACE_EVENT(block_rq_abort,
 		blk_dump_cmd(__get_str(cmd), rq);
 	),
 
-	TP_printk("%d,%d %s (%s) %llu + %u [%d]",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->rwbs, __get_str(cmd),
-		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, __entry->errors)
+	TP_FORMAT("<major:dev>,<minor:dev> <strarray:rwbs> (<string:cmd>) "
+		  "<uint:sector> + <uint:nr_sector> [<int:errors>]")
 );
 
 TRACE_EVENT(block_rq_insert,
@@ -69,11 +66,9 @@ TRACE_EVENT(block_rq_insert,
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
 
-	TP_printk("%d,%d %s %u (%s) %llu + %u [%s]",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->rwbs, __entry->bytes, __get_str(cmd),
-		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, __entry->comm)
+	TP_FORMAT("<major:dev>,<minor:dev> <strarray:rwbs> <uint:bytes>"
+		  " (<string:cmd>) <uint:sector> + <uint:nr_sector>"
+		  " [<strarray:comm>]")
 );
 
 TRACE_EVENT(block_rq_issue,
@@ -104,11 +99,9 @@ TRACE_EVENT(block_rq_issue,
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
 
-	TP_printk("%d,%d %s %u (%s) %llu + %u [%s]",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->rwbs, __entry->bytes, __get_str(cmd),
-		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, __entry->comm)
+	TP_FORMAT("<major:dev>,<minor:dev> <strarray:rwbs> <uint:bytes>"
+		  " (<string:cmd>) <uint:sector> + <uint:nr_sector>"
+		  " [<strarray:comm>]")
 );
 
 TRACE_EVENT(block_rq_requeue,
@@ -137,11 +130,8 @@ TRACE_EVENT(block_rq_requeue,
 		blk_dump_cmd(__get_str(cmd), rq);
 	),
 
-	TP_printk("%d,%d %s (%s) %llu + %u [%d]",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->rwbs, __get_str(cmd),
-		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, __entry->errors)
+	TP_FORMAT("<major:dev>,<minor:dev> <strarray:rwbs> (<string:cmd>)"
+		  " <uint:sector> + <uint:nr_sector> [<int:errors>]")
 );
 
 TRACE_EVENT(block_rq_complete,
@@ -170,11 +160,8 @@ TRACE_EVENT(block_rq_complete,
 		blk_dump_cmd(__get_str(cmd), rq);
 	),
 
-	TP_printk("%d,%d %s (%s) %llu + %u [%d]",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->rwbs, __get_str(cmd),
-		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, __entry->errors)
+	TP_FORMAT("<major:dev>,<minor:dev> <strarray:rwbs> (<string:cmd>) "
+		  "<uint:sector> + <uint:nr_sector> [<int:errors>]")
 );
 TRACE_EVENT(block_bio_bounce,
 
@@ -198,10 +185,8 @@ TRACE_EVENT(block_bio_bounce,
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
 
-	TP_printk("%d,%d %s %llu + %u [%s]",
-		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
-		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, __entry->comm)
+	TP_FORMAT("<major:dev>,<minor:dev> <strarray:rwbs> "
+		  "<uint:sector> + <uint:nr_sector> [<strarray:comm>]")
 );
 
 TRACE_EVENT(block_bio_complete,
@@ -225,10 +210,8 @@ TRACE_EVENT(block_bio_complete,
 		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
 	),
 
-	TP_printk("%d,%d %s %llu + %u [%d]",
-		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
-		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, __entry->error)
+	TP_FORMAT("<major:dev>,<minor:dev> <strarray:rwbs> <uint:sector>"
+		  " + <uint:nr_sector> [<int:error>]")
 );
 
 TRACE_EVENT(block_bio_backmerge,
@@ -253,10 +236,8 @@ TRACE_EVENT(block_bio_backmerge,
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
 
-	TP_printk("%d,%d %s %llu + %u [%s]",
-		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
-		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, __entry->comm)
+	TP_FORMAT("<major:dev>,<minor:dev> <strarray:rwbs> "
+		  "<uint:sector> + <uint:nr_sector> [<strarray:comm>]")
 );
 
 TRACE_EVENT(block_bio_frontmerge,
@@ -281,10 +262,8 @@ TRACE_EVENT(block_bio_frontmerge,
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
 
-	TP_printk("%d,%d %s %llu + %u [%s]",
-		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
-		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, __entry->comm)
+	TP_FORMAT("<major:dev>,<minor:dev> <strarray:rwbs> "
+		  "<uint:sector> + <uint:nr_sector> [<strarray:comm>]")
 );
 
 TRACE_EVENT(block_bio_queue,
@@ -309,10 +288,8 @@ TRACE_EVENT(block_bio_queue,
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
 
-	TP_printk("%d,%d %s %llu + %u [%s]",
-		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
-		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, __entry->comm)
+	TP_FORMAT("<major:dev>,<minor:dev> <strarray:rwbs> "
+		  "<uint:sector> + <uint:nr_sector> [<strarray:comm>]")
 );
 
 TRACE_EVENT(block_getrq,
@@ -338,10 +315,8 @@ TRACE_EVENT(block_getrq,
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
         ),
 
-	TP_printk("%d,%d %s %llu + %u [%s]",
-		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
-		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, __entry->comm)
+	TP_FORMAT("<major:dev>,<minor:dev> <strarray:rwbs> "
+		  "<uint:sector> + <uint:nr_sector> [<strarray:comm>]")
 );
 
 TRACE_EVENT(block_sleeprq,
@@ -367,10 +342,8 @@ TRACE_EVENT(block_sleeprq,
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
 
-	TP_printk("%d,%d %s %llu + %u [%s]",
-		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
-		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, __entry->comm)
+	TP_FORMAT("<major:dev>,<minor:dev> <strarray:rwbs> "
+		  "<uint:sector> + <uint:nr_sector> [<strarray:comm>]")
 );
 
 TRACE_EVENT(block_plug,
@@ -387,7 +360,7 @@ TRACE_EVENT(block_plug,
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
 
-	TP_printk("[%s]", __entry->comm)
+	TP_FORMAT("[<strarray:comm>]")
 );
 
 TRACE_EVENT(block_unplug_timer,
@@ -406,7 +379,7 @@ TRACE_EVENT(block_unplug_timer,
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
 
-	TP_printk("[%s] %d", __entry->comm, __entry->nr_rq)
+	TP_FORMAT("[<strarray:comm>] <int:nr_rq>")
 );
 
 TRACE_EVENT(block_unplug_io,
@@ -425,7 +398,7 @@ TRACE_EVENT(block_unplug_io,
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
 
-	TP_printk("[%s] %d", __entry->comm, __entry->nr_rq)
+	TP_FORMAT("[<strarray:comm>] <int:nr_rq>")
 );
 
 TRACE_EVENT(block_split,
@@ -451,11 +424,8 @@ TRACE_EVENT(block_split,
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
 
-	TP_printk("%d,%d %s %llu / %llu [%s]",
-		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
-		  (unsigned long long)__entry->sector,
-		  (unsigned long long)__entry->new_sector,
-		  __entry->comm)
+	TP_FORMAT("<major:dev>,<minor:dev> <strarray:rwbs> <uint:sector> / "
+		  "<uint:new_sector> [<strarray:comm>]")
 );
 
 TRACE_EVENT(block_remap,
@@ -483,12 +453,9 @@ TRACE_EVENT(block_remap,
 		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
 	),
 
-	TP_printk("%d,%d %s %llu + %u <- (%d,%d) %llu",
-		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
-		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector,
-		  MAJOR(__entry->old_dev), MINOR(__entry->old_dev),
-		  (unsigned long long)__entry->old_sector)
+	TP_FORMAT("<major:dev>,<minor:dev> <strarray:rwbs> <uint:sector> + "
+		  "<uint:nr_sector> <<- (<major:old_dev>,<minor:old_dev>) "
+		  "<uint:old_sector>")
 );
 
 #endif /* _TRACE_BLOCK_H */
-- 
1.6.3.1

-- 
