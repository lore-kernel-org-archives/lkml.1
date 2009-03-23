Return-Path: <linux-kernel-owner+w=401wt.eu-S1759073AbZCWPWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759073AbZCWPWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758754AbZCWPUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:20:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:41288 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758697AbZCWPUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:20:19 -0400
Date: Mon, 23 Mar 2009 15:19:21 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       eduard.munteanu@linux360.ro, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       eduard.munteanu@linux360.ro, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <161be9ca8a27b432c4a6ab79f47788c4521652ae.1237813499.git.eduard.munteanu@linux360.ro>
References: <161be9ca8a27b432c4a6ab79f47788c4521652ae.1237813499.git.eduard.munteanu@linux360.ro>
Subject: [tip:tracing/kmemtrace] kmemtrace: small cleanups
Message-ID: <tip-c23852c1566d67efb841461d90d2a0f178685e38@git.kernel.org>
Git-Commit-ID: c23852c1566d67efb841461d90d2a0f178685e38
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 23 Mar 2009 15:19:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c23852c1566d67efb841461d90d2a0f178685e38
Gitweb:     http://git.kernel.org/tip/c23852c1566d67efb841461d90d2a0f178685e38
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 23 Mar 2009 16:14:13 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Mar 2009 16:15:00 +0100

kmemtrace: small cleanups

Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
LKML-Reference: <161be9ca8a27b432c4a6ab79f47788c4521652ae.1237813499.git.eduard.munteanu@linux360.ro>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/kmemtrace.c |  128 ++++++++++++++++++++++++----------------------
 1 files changed, 67 insertions(+), 61 deletions(-)

diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index 26ec3c3..53b9c7c 100644
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -6,15 +6,16 @@
  * Copyright (C) 2008 Frederic Weisbecker <fweisbec@gmail.com>
  */
 
-#include <linux/dcache.h>
+#include <linux/tracepoint.h>
+#include <linux/seq_file.h>
 #include <linux/debugfs.h>
+#include <linux/dcache.h>
 #include <linux/fs.h>
-#include <linux/seq_file.h>
-#include <linux/tracepoint.h>
+
 #include <trace/kmemtrace.h>
 
-#include "trace.h"
 #include "trace_output.h"
+#include "trace.h"
 
 /* Tracepoints definitions. */
 DEFINE_TRACE(kmalloc);
@@ -41,8 +42,8 @@ static struct tracer_opt kmem_opts[] = {
 };
 
 static struct tracer_flags kmem_tracer_flags = {
-	.val = 0,
-	.opts = kmem_opts
+	.val			= 0,
+	.opts			= kmem_opts
 };
 
 static struct trace_array *kmemtrace_array;
@@ -56,24 +57,25 @@ static inline void kmemtrace_alloc(enum kmemtrace_type_id type_id,
 				   gfp_t gfp_flags,
 				   int node)
 {
-	struct ring_buffer_event *event;
-	struct kmemtrace_alloc_entry *entry;
 	struct trace_array *tr = kmemtrace_array;
+	struct kmemtrace_alloc_entry *entry;
+	struct ring_buffer_event *event;
 
 	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
 	if (!event)
 		return;
-	entry	= ring_buffer_event_data(event);
+
+	entry = ring_buffer_event_data(event);
 	tracing_generic_entry_update(&entry->ent, 0, 0);
 
-	entry->ent.type = TRACE_KMEM_ALLOC;
-	entry->type_id = type_id;
-	entry->call_site = call_site;
-	entry->ptr = ptr;
-	entry->bytes_req = bytes_req;
-	entry->bytes_alloc = bytes_alloc;
-	entry->gfp_flags = gfp_flags;
-	entry->node	=	node;
+	entry->ent.type		= TRACE_KMEM_ALLOC;
+	entry->type_id		= type_id;
+	entry->call_site	= call_site;
+	entry->ptr		= ptr;
+	entry->bytes_req	= bytes_req;
+	entry->bytes_alloc	= bytes_alloc;
+	entry->gfp_flags	= gfp_flags;
+	entry->node		= node;
 
 	ring_buffer_unlock_commit(tr->buffer, event);
 
@@ -84,9 +86,9 @@ static inline void kmemtrace_free(enum kmemtrace_type_id type_id,
 				  unsigned long call_site,
 				  const void *ptr)
 {
-	struct ring_buffer_event *event;
-	struct kmemtrace_free_entry *entry;
 	struct trace_array *tr = kmemtrace_array;
+	struct kmemtrace_free_entry *entry;
+	struct ring_buffer_event *event;
 
 	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry));
 	if (!event)
@@ -94,10 +96,10 @@ static inline void kmemtrace_free(enum kmemtrace_type_id type_id,
 	entry	= ring_buffer_event_data(event);
 	tracing_generic_entry_update(&entry->ent, 0, 0);
 
-	entry->ent.type = TRACE_KMEM_FREE;
-	entry->type_id	= type_id;
-	entry->call_site = call_site;
-	entry->ptr = ptr;
+	entry->ent.type		= TRACE_KMEM_FREE;
+	entry->type_id		= type_id;
+	entry->call_site	= call_site;
+	entry->ptr		= ptr;
 
 	ring_buffer_unlock_commit(tr->buffer, event);
 
@@ -231,48 +233,50 @@ static void kmemtrace_headers(struct seq_file *s)
 #define KMEMTRACE_USER_FREE	1
 
 struct kmemtrace_user_event {
-	u8		event_id;
-	u8		type_id;
-	u16		event_size;
-	u32		cpu;
-	u64		timestamp;
-	unsigned long	call_site;
-	unsigned long	ptr;
+	u8			event_id;
+	u8			type_id;
+	u16			event_size;
+	u32			cpu;
+	u64			timestamp;
+	unsigned long		call_site;
+	unsigned long		ptr;
 };
 
 struct kmemtrace_user_event_alloc {
-	size_t		bytes_req;
-	size_t		bytes_alloc;
-	unsigned	gfp_flags;
-	int		node;
+	size_t			bytes_req;
+	size_t			bytes_alloc;
+	unsigned		gfp_flags;
+	int			node;
 };
 
 static enum print_line_t
 kmemtrace_print_alloc_user(struct trace_iterator *iter,
 			   struct kmemtrace_alloc_entry *entry)
 {
+	struct kmemtrace_user_event_alloc *ev_alloc;
 	struct trace_seq *s = &iter->seq;
 	struct kmemtrace_user_event *ev;
-	struct kmemtrace_user_event_alloc *ev_alloc;
 
 	ev = trace_seq_reserve(s, sizeof(*ev));
 	if (!ev)
 		return TRACE_TYPE_PARTIAL_LINE;
-	ev->event_id = KMEMTRACE_USER_ALLOC;
-	ev->type_id = entry->type_id;
-	ev->event_size = sizeof(*ev) + sizeof(*ev_alloc);
-	ev->cpu = iter->cpu;
-	ev->timestamp = iter->ts;
-	ev->call_site = entry->call_site; 
-	ev->ptr = (unsigned long) entry->ptr;
+
+	ev->event_id		= KMEMTRACE_USER_ALLOC;
+	ev->type_id		= entry->type_id;
+	ev->event_size		= sizeof(*ev) + sizeof(*ev_alloc);
+	ev->cpu			= iter->cpu;
+	ev->timestamp		= iter->ts;
+	ev->call_site		= entry->call_site;
+	ev->ptr			= (unsigned long)entry->ptr;
 
 	ev_alloc = trace_seq_reserve(s, sizeof(*ev_alloc));
 	if (!ev_alloc)
 		return TRACE_TYPE_PARTIAL_LINE;
-	ev_alloc->bytes_req = entry->bytes_req;
-	ev_alloc->bytes_alloc = entry->bytes_alloc;
-	ev_alloc->gfp_flags = entry->gfp_flags;
-	ev_alloc->node = entry->node;
+
+	ev_alloc->bytes_req	= entry->bytes_req;
+	ev_alloc->bytes_alloc	= entry->bytes_alloc;
+	ev_alloc->gfp_flags	= entry->gfp_flags;
+	ev_alloc->node		= entry->node;
 
 	return TRACE_TYPE_HANDLED;
 }
@@ -287,13 +291,14 @@ kmemtrace_print_free_user(struct trace_iterator *iter,
 	ev = trace_seq_reserve(s, sizeof(*ev));
 	if (!ev)
 		return TRACE_TYPE_PARTIAL_LINE;
-	ev->event_id = KMEMTRACE_USER_FREE;
-	ev->type_id = entry->type_id;
-	ev->event_size = sizeof(*ev);
-	ev->cpu = iter->cpu;
-	ev->timestamp = iter->ts;
-	ev->call_site = entry->call_site; 
-	ev->ptr = (unsigned long) entry->ptr;
+
+	ev->event_id		= KMEMTRACE_USER_FREE;
+	ev->type_id		= entry->type_id;
+	ev->event_size		= sizeof(*ev);
+	ev->cpu			= iter->cpu;
+	ev->timestamp		= iter->ts;
+	ev->call_site		= entry->call_site;
+	ev->ptr			= (unsigned long)entry->ptr;
 
 	return TRACE_TYPE_HANDLED;
 }
@@ -369,7 +374,7 @@ kmemtrace_print_alloc_compress(struct trace_iterator *iter,
 
 static enum print_line_t
 kmemtrace_print_free_compress(struct trace_iterator *iter,
-				struct kmemtrace_free_entry *entry)
+			      struct kmemtrace_free_entry *entry)
 {
 	struct trace_seq *s = &iter->seq;
 	int ret;
@@ -430,6 +435,7 @@ static enum print_line_t kmemtrace_print_line(struct trace_iterator *iter)
 	switch (entry->type) {
 	case TRACE_KMEM_ALLOC: {
 		struct kmemtrace_alloc_entry *field;
+
 		trace_assign_type(field, entry);
 		if (kmem_tracer_flags.val & TRACE_KMEM_OPT_MINIMAL)
 			return kmemtrace_print_alloc_compress(iter, field);
@@ -439,6 +445,7 @@ static enum print_line_t kmemtrace_print_line(struct trace_iterator *iter)
 
 	case TRACE_KMEM_FREE: {
 		struct kmemtrace_free_entry *field;
+
 		trace_assign_type(field, entry);
 		if (kmem_tracer_flags.val & TRACE_KMEM_OPT_MINIMAL)
 			return kmemtrace_print_free_compress(iter, field);
@@ -452,12 +459,12 @@ static enum print_line_t kmemtrace_print_line(struct trace_iterator *iter)
 }
 
 static struct tracer kmem_tracer __read_mostly = {
-	.name		= "kmemtrace",
-	.init		= kmem_trace_init,
-	.reset		= kmem_trace_reset,
-	.print_line	= kmemtrace_print_line,
-	.print_header = kmemtrace_headers,
-	.flags		= &kmem_tracer_flags
+	.name			= "kmemtrace",
+	.init			= kmem_trace_init,
+	.reset			= kmem_trace_reset,
+	.print_line		= kmemtrace_print_line,
+	.print_header		= kmemtrace_headers,
+	.flags			= &kmem_tracer_flags
 };
 
 void kmemtrace_init(void)
@@ -469,5 +476,4 @@ static int __init init_kmem_tracer(void)
 {
 	return register_tracer(&kmem_tracer);
 }
-
 device_initcall(init_kmem_tracer);
