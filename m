Return-Path: <linux-kernel-owner+w=401wt.eu-S1762060AbZDQQ2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762060AbZDQQ2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 12:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761728AbZDQQ22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 12:28:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:53413 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761616AbZDQQ20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:28:26 -0400
Date: Fri, 17 Apr 2009 16:27:48 GMT
From: tip-bot for Zhaolei <zhaolei@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, zhaolei@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tzanussi@gmail.com, rostedt@goodmis.org,
       zhaolei@cn.fujitsu.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49E7EF37.2080205@cn.fujitsu.com>
References: <49E7EF37.2080205@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing: Remove include/trace/kmem_event_types.h
Message-ID: <tip-46de405f25f1d9fa73b657ffbb752aa0cc87a91d@git.kernel.org>
Git-Commit-ID: 46de405f25f1d9fa73b657ffbb752aa0cc87a91d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 17 Apr 2009 16:27:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  46de405f25f1d9fa73b657ffbb752aa0cc87a91d
Gitweb:     http://git.kernel.org/tip/46de405f25f1d9fa73b657ffbb752aa0cc87a91d
Author:     Zhaolei <zhaolei@cn.fujitsu.com>
AuthorDate: Fri, 17 Apr 2009 10:53:43 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 17 Apr 2009 18:26:42 +0200

tracing: Remove include/trace/kmem_event_types.h

kmem_event_types.h is no longer necessary since tracepoint definitions
are put into include/trace/events/kmem.h

[ Impact: remove now-unused file. ]

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <49E7EF37.2080205@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/trace/kmem_event_types.h |  193 --------------------------------------
 1 files changed, 0 insertions(+), 193 deletions(-)

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
