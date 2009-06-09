Return-Path: <linux-kernel-owner+w=401wt.eu-S1752036AbZFISYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbZFISYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 14:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbZFISYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 14:24:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46429 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbZFISYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 14:24:08 -0400
Date: Tue, 9 Jun 2009 14:24:07 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: linux-kernel@vger.kernel.org
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] tracing/events: convert block trace points to
 TRACE_EVENT()
In-Reply-To: <20090609163754.619632066@goodmis.org>
Message-ID: <alpine.DEB.2.00.0906091421370.17452@gandalf.stny.rr.com>
References: <20090609163657.557589106@goodmis.org> <20090609163754.619632066@goodmis.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I added the patch the fix the compiler warnings on top of my last pull 
request.

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (1):
      tracing: fix the block trace points print size

----
 include/trace/events/block.h |   45 ++++++++++++++++++++++++++++--------------
 1 files changed, 30 insertions(+), 15 deletions(-)
---------------------------
commit 6556d1df88fe68f9836beeb43342a336691cb67c
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Tue Jun 9 14:04:26 2009 -0400

    tracing: fix the block trace points print size
    
    The sector field is either u64 or unsigned long depending on
    the arch. This patch casts the sector to unsigned long long to
    prevent the printf warnings.
    
    [ Impact: remove compile warnings ]
    
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index a99d1e5..53effd4 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -37,7 +37,8 @@ TRACE_EVENT(block_rq_abort,
 	TP_printk("%d,%d %s (%s) %llu + %u [%d]",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->rwbs, __get_str(cmd),
-		  __entry->sector, __entry->nr_sector, __entry->errors)
+		  (unsigned long long)__entry->sector,
+		  __entry->nr_sector, __entry->errors)
 );
 
 TRACE_EVENT(block_rq_insert,
@@ -71,7 +72,8 @@ TRACE_EVENT(block_rq_insert,
 	TP_printk("%d,%d %s %u (%s) %llu + %u [%s]",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->rwbs, __entry->bytes, __get_str(cmd),
-		  __entry->sector, __entry->nr_sector, __entry->comm)
+		  (unsigned long long)__entry->sector,
+		  __entry->nr_sector, __entry->comm)
 );
 
 TRACE_EVENT(block_rq_issue,
@@ -105,7 +107,8 @@ TRACE_EVENT(block_rq_issue,
 	TP_printk("%d,%d %s %u (%s) %llu + %u [%s]",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->rwbs, __entry->bytes, __get_str(cmd),
-		  __entry->sector, __entry->nr_sector, __entry->comm)
+		  (unsigned long long)__entry->sector,
+		  __entry->nr_sector, __entry->comm)
 );
 
 TRACE_EVENT(block_rq_requeue,
@@ -137,7 +140,8 @@ TRACE_EVENT(block_rq_requeue,
 	TP_printk("%d,%d %s (%s) %llu + %u [%d]",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->rwbs, __get_str(cmd),
-		  __entry->sector, __entry->nr_sector, __entry->errors)
+		  (unsigned long long)__entry->sector,
+		  __entry->nr_sector, __entry->errors)
 );
 
 TRACE_EVENT(block_rq_complete,
@@ -169,7 +173,8 @@ TRACE_EVENT(block_rq_complete,
 	TP_printk("%d,%d %s (%s) %llu + %u [%d]",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->rwbs, __get_str(cmd),
-		  __entry->sector, __entry->nr_sector, __entry->errors)
+		  (unsigned long long)__entry->sector,
+		  __entry->nr_sector, __entry->errors)
 );
 TRACE_EVENT(block_bio_bounce,
 
@@ -195,7 +200,8 @@ TRACE_EVENT(block_bio_bounce,
 
 	TP_printk("%d,%d %s %llu + %u [%s]",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
-		  __entry->sector, __entry->nr_sector, __entry->comm)
+		  (unsigned long long)__entry->sector,
+		  __entry->nr_sector, __entry->comm)
 );
 
 TRACE_EVENT(block_bio_complete,
@@ -221,7 +227,8 @@ TRACE_EVENT(block_bio_complete,
 
 	TP_printk("%d,%d %s %llu + %u [%d]",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
-		  __entry->sector, __entry->nr_sector, __entry->error)
+		  (unsigned long long)__entry->sector,
+		  __entry->nr_sector, __entry->error)
 );
 
 TRACE_EVENT(block_bio_backmerge,
@@ -248,7 +255,8 @@ TRACE_EVENT(block_bio_backmerge,
 
 	TP_printk("%d,%d %s %llu + %u [%s]",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
-		  __entry->sector, __entry->nr_sector, __entry->comm)
+		  (unsigned long long)__entry->sector,
+		  __entry->nr_sector, __entry->comm)
 );
 
 TRACE_EVENT(block_bio_frontmerge,
@@ -275,7 +283,8 @@ TRACE_EVENT(block_bio_frontmerge,
 
 	TP_printk("%d,%d %s %llu + %u [%s]",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
-		  __entry->sector, __entry->nr_sector, __entry->comm)
+		  (unsigned long long)__entry->sector,
+		  __entry->nr_sector, __entry->comm)
 );
 
 TRACE_EVENT(block_bio_queue,
@@ -302,7 +311,8 @@ TRACE_EVENT(block_bio_queue,
 
 	TP_printk("%d,%d %s %llu + %u [%s]",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
-		  __entry->sector, __entry->nr_sector, __entry->comm)
+		  (unsigned long long)__entry->sector,
+		  __entry->nr_sector, __entry->comm)
 );
 
 TRACE_EVENT(block_getrq,
@@ -330,7 +340,8 @@ TRACE_EVENT(block_getrq,
 
 	TP_printk("%d,%d %s %llu + %u [%s]",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
-		  __entry->sector, __entry->nr_sector, __entry->comm)
+		  (unsigned long long)__entry->sector,
+		  __entry->nr_sector, __entry->comm)
 );
 
 TRACE_EVENT(block_sleeprq,
@@ -358,7 +369,8 @@ TRACE_EVENT(block_sleeprq,
 
 	TP_printk("%d,%d %s %llu + %u [%s]",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
-		  __entry->sector, __entry->nr_sector, __entry->comm)
+		  (unsigned long long)__entry->sector,
+		  __entry->nr_sector, __entry->comm)
 );
 
 TRACE_EVENT(block_plug,
@@ -441,7 +453,9 @@ TRACE_EVENT(block_split,
 
 	TP_printk("%d,%d %s %llu / %llu [%s]",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
-		  __entry->sector, __entry->new_sector, __entry->comm)
+		  (unsigned long long)__entry->sector,
+		  (unsigned long long)__entry->new_sector,
+		  __entry->comm)
 );
 
 TRACE_EVENT(block_remap,
@@ -471,9 +485,10 @@ TRACE_EVENT(block_remap,
 
 	TP_printk("%d,%d %s %llu + %u <- (%d,%d) %llu",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
-		  __entry->sector, __entry->nr_sector,
+		  (unsigned long long)__entry->sector,
+		  __entry->nr_sector,
 		  MAJOR(__entry->old_dev), MINOR(__entry->old_dev),
-		  __entry->old_sector)
+		  (unsigned long long)__entry->old_sector)
 );
 
 #endif /* _TRACE_BLOCK_H */


