Return-Path: <linux-kernel-owner+w=401wt.eu-S1758786AbZFJFpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786AbZFJFpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 01:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755935AbZFJFnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 01:43:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45704 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457AbZFJFmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 01:42:53 -0400
Message-Id: <20090610054255.029219112@goodmis.org>
References: <20090610054206.510574695@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 10 Jun 2009 01:42:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [PATCH 11/11] tracing: move > to out of macros and into print statement
Content-Disposition: inline; filename=0011-tracing-move-to-out-of-macros-and-into-print-stateme.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Frederic Weisbecker stated that it is confusing to see a unmatched
'<', when the '>' is hidden inside a macro. This patch moves it out
back to the string.

Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/irq.h  |    8 +++++---
 include/trace/events/kmem.h |   12 +++++++-----
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index c6c0ff1..4294a6d 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -9,7 +9,7 @@
 
 #define softirq_name(sirq) sirq##_SOFTIRQ, #sirq
 #define show_softirq_name_format(val)					\
-	"%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s>"
+	"%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s"
 #define show_softirq_name_args()					\
 		softirq_name(HI),					\
 		softirq_name(TIMER),					\
@@ -106,7 +106,8 @@ TRACE_EVENT(softirq_entry,
 		__entry->vec = (int)(h - vec);
 	),
 
-	TP_FORMAT("softirq=<int:vec> action=<sym:vec:" show_softirq_name_format(),
+	TP_FORMAT("softirq=<int:vec> action=<sym:vec:"
+		  show_softirq_name_format() ">",
 		  show_softirq_name_args())
 );
 
@@ -135,7 +136,8 @@ TRACE_EVENT(softirq_exit,
 		__entry->vec = (int)(h - vec);
 	),
 
-	TP_FORMAT("softirq=<int:vec> action=<sym:vec:" show_softirq_name_format(),
+	TP_FORMAT("softirq=<int:vec> action=<sym:vec:"
+		  show_softirq_name_format() ">",
 		  show_softirq_name_args())
 );
 
diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index 5c8f942..32c93da 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -22,7 +22,7 @@
 	"0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s," \
 	"0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s," \
 	"0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s," \
-	"0x%lx=%s,0x%lx=%s>"
+	"0x%lx=%s,0x%lx=%s"
 #define show_gfp_flags_args()						\
 	(unsigned long)GFP_HIGHUSER_MOVABLE,	"GFP_HIGHUSER_MOVABLE", \
 	(unsigned long)GFP_HIGHUSER,		"GFP_HIGHUSER",		\
@@ -76,7 +76,7 @@ TRACE_EVENT(kmalloc,
 
 	TP_FORMAT("call_site=<hex:call_site> ptr=<ptr:ptr> bytes_req=<int:bytes_req> "
 		  "bytes_alloc=<int:bytes_alloc> gfp_flags=<mask:gfp_flags:|:"
-		  show_gfp_flags_format(), show_gfp_flags_args())
+		  show_gfp_flags_format() ">", show_gfp_flags_args())
 );
 
 TRACE_EVENT(kmem_cache_alloc,
@@ -107,7 +107,7 @@ TRACE_EVENT(kmem_cache_alloc,
 
 	TP_FORMAT("call_site=<hex:call_site> ptr=<ptr:ptr> bytes_req=<int:bytes_req> "
 		  "bytes_alloc=<int:bytes_alloc> gfp_flags=<mask:gfp_flags:|:"
-		  show_gfp_flags_format(), show_gfp_flags_args())
+		  show_gfp_flags_format() ">", show_gfp_flags_args())
 );
 
 TRACE_EVENT(kmalloc_node,
@@ -141,7 +141,8 @@ TRACE_EVENT(kmalloc_node,
 
 	TP_FORMAT("call_site=<hex:call_site> ptr=<ptr:ptr> bytes_req=<int:bytes_req> "
 		  "bytes_alloc=<int:bytes_alloc> gfp_flags=<mask:gfp_flags:|:"
-		  show_gfp_flags_format() " node=<int:node>", show_gfp_flags_args())
+		  show_gfp_flags_format() "> node=<int:node>",
+		  show_gfp_flags_args())
 );
 
 TRACE_EVENT(kmem_cache_alloc_node,
@@ -175,7 +176,8 @@ TRACE_EVENT(kmem_cache_alloc_node,
 
 	TP_FORMAT("call_site=<hex:call_site> ptr=<ptr:ptr> bytes_req=<int:bytes_req> "
 		  "bytes_alloc=<int:bytes_alloc> gfp_flags=<mask:gfp_flags:|:"
-		  show_gfp_flags_format() " node=<int:node>", show_gfp_flags_args())
+		  show_gfp_flags_format() "> node=<int:node>",
+		  show_gfp_flags_args())
 );
 
 TRACE_EVENT(kfree,
-- 
1.6.3.1

-- 
