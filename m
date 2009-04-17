Return-Path: <linux-kernel-owner+w=401wt.eu-S1756966AbZDQCyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966AbZDQCyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 22:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbZDQCyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 22:54:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64042 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752250AbZDQCyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 22:54:13 -0400
Message-ID: <49E7EF37.2080205@cn.fujitsu.com>
Date: Fri, 17 Apr 2009 10:53:43 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: Remove include/trace/kmem_event_types.h
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmem_event_types.h is no longer necessary since tracepoint definitions
are put into include/trace/events/kmem.h

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 include/trace/kmem_event_types.h |  193 --------------------------------------
 1 files changed, 0 insertions(+), 193 deletions(-)
 delete mode 100644 include/trace/kmem_event_types.h

diff --git a/include/trace/kmem_event_types.h b/include/trace/kmem_event_types.h
deleted file mode 100644
index 4ff420f..0000000
--- a/include/trace/kmem_event_types.h
+++ /dev/null
@@ -1,193 +0,0 @@
-
-/* use <trace/kmem.h> instead */
-#ifndef TRACE_EVENT
-# error Do not include this file directly.
-# error Unless you know what you are doing.
-#endif
-
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM kmem
-
-TRACE_EVENT(kmalloc,
-
-	TP_PROTO(unsigned long call_site,
-		 const void *ptr,
-		 size_t bytes_req,
-		 size_t bytes_alloc,
-		 gfp_t gfp_flags),
-
-	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags),
-
-	TP_STRUCT__entry(
-		__field(	unsigned long,	call_site	)
-		__field(	const void *,	ptr		)
-		__field(	size_t,		bytes_req	)
-		__field(	size_t,		bytes_alloc	)
-		__field(	gfp_t,		gfp_flags	)
-	),
-
-	TP_fast_assign(
-		__entry->call_site	= call_site;
-		__entry->ptr		= ptr;
-		__entry->bytes_req	= bytes_req;
-		__entry->bytes_alloc	= bytes_alloc;
-		__entry->gfp_flags	= gfp_flags;
-	),
-
-	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%08x",
-		__entry->call_site,
-		__entry->ptr,
-		__entry->bytes_req,
-		__entry->bytes_alloc,
-		__entry->gfp_flags)
-);
-
-TRACE_EVENT(kmem_cache_alloc,
-
-	TP_PROTO(unsigned long call_site,
-		 const void *ptr,
-		 size_t bytes_req,
-		 size_t bytes_alloc,
-		 gfp_t gfp_flags),
-
-	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags),
-
-	TP_STRUCT__entry(
-		__field(	unsigned long,	call_site	)
-		__field(	const void *,	ptr		)
-		__field(	size_t,		bytes_req	)
-		__field(	size_t,		bytes_alloc	)
-		__field(	gfp_t,		gfp_flags	)
-	),
-
-	TP_fast_assign(
-		__entry->call_site	= call_site;
-		__entry->ptr		= ptr;
-		__entry->bytes_req	= bytes_req;
-		__entry->bytes_alloc	= bytes_alloc;
-		__entry->gfp_flags	= gfp_flags;
-	),
-
-	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%08x",
-		__entry->call_site,
-		__entry->ptr,
-		__entry->bytes_req,
-		__entry->bytes_alloc,
-		__entry->gfp_flags)
-);
-
-TRACE_EVENT(kmalloc_node,
-
-	TP_PROTO(unsigned long call_site,
-		 const void *ptr,
-		 size_t bytes_req,
-		 size_t bytes_alloc,
-		 gfp_t gfp_flags,
-		 int node),
-
-	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node),
-
-	TP_STRUCT__entry(
-		__field(	unsigned long,	call_site	)
-		__field(	const void *,	ptr		)
-		__field(	size_t,		bytes_req	)
-		__field(	size_t,		bytes_alloc	)
-		__field(	gfp_t,		gfp_flags	)
-		__field(	int,		node		)
-	),
-
-	TP_fast_assign(
-		__entry->call_site	= call_site;
-		__entry->ptr		= ptr;
-		__entry->bytes_req	= bytes_req;
-		__entry->bytes_alloc	= bytes_alloc;
-		__entry->gfp_flags	= gfp_flags;
-		__entry->node		= node;
-	),
-
-	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%08x node=%d",
-		__entry->call_site,
-		__entry->ptr,
-		__entry->bytes_req,
-		__entry->bytes_alloc,
-		__entry->gfp_flags,
-		__entry->node)
-);
-
-TRACE_EVENT(kmem_cache_alloc_node,
-
-	TP_PROTO(unsigned long call_site,
-		 const void *ptr,
-		 size_t bytes_req,
-		 size_t bytes_alloc,
-		 gfp_t gfp_flags,
-		 int node),
-
-	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node),
-
-	TP_STRUCT__entry(
-		__field(	unsigned long,	call_site	)
-		__field(	const void *,	ptr		)
-		__field(	size_t,		bytes_req	)
-		__field(	size_t,		bytes_alloc	)
-		__field(	gfp_t,		gfp_flags	)
-		__field(	int,		node		)
-	),
-
-	TP_fast_assign(
-		__entry->call_site	= call_site;
-		__entry->ptr		= ptr;
-		__entry->bytes_req	= bytes_req;
-		__entry->bytes_alloc	= bytes_alloc;
-		__entry->gfp_flags	= gfp_flags;
-		__entry->node		= node;
-	),
-
-	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%08x node=%d",
-		__entry->call_site,
-		__entry->ptr,
-		__entry->bytes_req,
-		__entry->bytes_alloc,
-		__entry->gfp_flags,
-		__entry->node)
-);
-
-TRACE_EVENT(kfree,
-
-	TP_PROTO(unsigned long call_site, const void *ptr),
-
-	TP_ARGS(call_site, ptr),
-
-	TP_STRUCT__entry(
-		__field(	unsigned long,	call_site	)
-		__field(	const void *,	ptr		)
-	),
-
-	TP_fast_assign(
-		__entry->call_site	= call_site;
-		__entry->ptr		= ptr;
-	),
-
-	TP_printk("call_site=%lx ptr=%p", __entry->call_site, __entry->ptr)
-);
-
-TRACE_EVENT(kmem_cache_free,
-
-	TP_PROTO(unsigned long call_site, const void *ptr),
-
-	TP_ARGS(call_site, ptr),
-
-	TP_STRUCT__entry(
-		__field(	unsigned long,	call_site	)
-		__field(	const void *,	ptr		)
-	),
-
-	TP_fast_assign(
-		__entry->call_site	= call_site;
-		__entry->ptr		= ptr;
-	),
-
-	TP_printk("call_site=%lx ptr=%p", __entry->call_site, __entry->ptr)
-);
-
-#undef TRACE_SYSTEM
-- 
1.5.5.3


