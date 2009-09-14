Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbZINQeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbZINQeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 12:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756121AbZINQek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 12:34:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53288 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163AbZINQed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 12:34:33 -0400
Message-Id: <20090914163436.712717061@goodmis.org>
References: <20090914163355.162375454@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 14 Sep 2009 12:33:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 3/6] tracing: fix F_printk() typos
Content-Disposition: inline; filename=0003-tracing-fix-F_printk-typos.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

I found some typos in F_printk(), so I wrote compile-time check
for it, and triggered some compile errors and warnings.

I've fixed them on x86_32, but I have no x86_64 in my hand, so there
may still be some compile warnings on 64bits.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4AADF60B.5070407@cn.fujitsu.com>

[ tested on x86_64, and works fine ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_entries.h |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace_entries.h b/kernel/trace/trace_entries.h
index c866d34..0c10095 100644
--- a/kernel/trace/trace_entries.h
+++ b/kernel/trace/trace_entries.h
@@ -78,7 +78,7 @@ FTRACE_ENTRY(funcgraph_entry, ftrace_graph_ent_entry,
 		__field_desc(	int,		graph_ent,	depth		)
 	),
 
-	F_printk("--> %lx (%d)", __entry->graph_ent.func, __entry->depth)
+	F_printk("--> %lx (%d)", __entry->func, __entry->depth)
 );
 
 /* Function return entry */
@@ -97,8 +97,8 @@ FTRACE_ENTRY(funcgraph_exit, ftrace_graph_ret_entry,
 
 	F_printk("<-- %lx (%d) (start: %llx  end: %llx) over: %d",
 		 __entry->func, __entry->depth,
-		 __entry->calltime, __entry->rettim,
-		 __entrty->depth)
+		 __entry->calltime, __entry->rettime,
+		 __entry->depth)
 );
 
 /*
@@ -133,7 +133,7 @@ FTRACE_ENTRY(context_switch, ctx_switch_entry,
 		FTRACE_CTX_FIELDS
 	),
 
-	F_printk(b"%u:%u:%u  ==> %u:%u:%u [%03u]",
+	F_printk("%u:%u:%u  ==> %u:%u:%u [%03u]",
 		 __entry->prev_pid, __entry->prev_prio, __entry->prev_state,
 		 __entry->next_pid, __entry->next_prio, __entry->next_state,
 		 __entry->next_cpu
@@ -257,8 +257,8 @@ FTRACE_ENTRY(mmiotrace_rw, trace_mmiotrace_rw,
 		__field_desc(	unsigned char,	rw,	width	)
 	),
 
-	F_printk("%lx %lx %lx %d %lx %lx",
-		 __entry->phs, __entry->value, __entry->pc,
+	F_printk("%lx %lx %lx %d %x %x",
+		 (unsigned long)__entry->phys, __entry->value, __entry->pc,
 		 __entry->map_id, __entry->opcode, __entry->width)
 );
 
@@ -275,8 +275,8 @@ FTRACE_ENTRY(mmiotrace_map, trace_mmiotrace_map,
 		__field_desc(	unsigned char,	map,	opcode	)
 	),
 
-	F_printk("%lx %lx %lx %d %lx",
-		 __entry->phs, __entry->virt, __entry->len,
+	F_printk("%lx %lx %lx %d %x",
+		 (unsigned long)__entry->phys, __entry->virt, __entry->len,
 		 __entry->map_id, __entry->opcode)
 );
 
@@ -370,7 +370,7 @@ FTRACE_ENTRY(kmem_alloc, kmemtrace_alloc_entry,
 		__field(	int,			node		)
 	),
 
-	F_printk("type:%u call_site:%lx ptr:%p req:%lu alloc:%lu"
+	F_printk("type:%u call_site:%lx ptr:%p req:%zi alloc:%zi"
 		 " flags:%x node:%d",
 		 __entry->type_id, __entry->call_site, __entry->ptr,
 		 __entry->bytes_req, __entry->bytes_alloc,
-- 
1.6.3.3

-- 
