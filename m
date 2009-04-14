Return-Path: <linux-kernel-owner+w=401wt.eu-S1756483AbZDNR20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbZDNR20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755956AbZDNR0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:26:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64729 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbZDNR0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:26:44 -0400
Message-Id: <20090414172641.914374182@goodmis.org>
References: <20090414172337.280621613@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 14 Apr 2009 13:23:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>
Subject: [PATCH 7/8] tracing/events: add export symbols for trace events in modules
Content-Disposition: inline; filename=0007-tracing-events-add-export-symbols-for-trace-events.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: let modules add trace events

The trace event code requires some functions to be exported to allow
modules to use TRACE_EVENT. This patch adds EXPORT_SYMBOL_GPL to the
necessary functions.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c               |    3 +++
 kernel/trace/trace_events.c        |    1 +
 kernel/trace/trace_events_filter.c |    2 ++
 kernel/trace/trace_output.c        |    3 +++
 4 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c0047fc..2d69b26 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -176,6 +176,7 @@ int filter_current_check_discard(struct ftrace_event_call *call, void *rec,
 {
 	return filter_check_discard(call, rec, global_trace.buffer, event);
 }
+EXPORT_SYMBOL_GPL(filter_current_check_discard);
 
 cycle_t ftrace_now(int cpu)
 {
@@ -886,6 +887,7 @@ trace_current_buffer_lock_reserve(unsigned char type, unsigned long len,
 	return trace_buffer_lock_reserve(&global_trace,
 					 type, len, flags, pc);
 }
+EXPORT_SYMBOL(trace_current_buffer_lock_reserve);
 
 void trace_current_buffer_unlock_commit(struct ring_buffer_event *event,
 					unsigned long flags, int pc)
@@ -903,6 +905,7 @@ void trace_current_buffer_discard_commit(struct ring_buffer_event *event)
 {
 	ring_buffer_discard_commit(global_trace.buffer, event);
 }
+EXPORT_SYMBOL_GPL(trace_nowake_buffer_unlock_commit);
 
 void
 trace_function(struct trace_array *tr,
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 5c66aaf..8b9e621 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -53,6 +53,7 @@ err:
 
 	return -ENOMEM;
 }
+EXPORT_SYMBOL_GPL(trace_define_field);
 
 static void ftrace_clear_events(void)
 {
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index d30b06b..f8e5eab 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -110,6 +110,7 @@ int filter_match_preds(struct ftrace_event_call *call, void *rec)
 
 	return 1;
 }
+EXPORT_SYMBOL_GPL(filter_match_preds);
 
 void filter_print_preds(struct filter_pred **preds, int n_preds,
 			struct trace_seq *s)
@@ -220,6 +221,7 @@ oom:
 
 	return -ENOMEM;
 }
+EXPORT_SYMBOL_GPL(init_preds);
 
 void filter_free_subsystem_preds(struct event_subsystem *system)
 {
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 0e70fb0..83a8abb 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -94,6 +94,7 @@ trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 
 	return len;
 }
+EXPORT_SYMBOL_GPL(trace_seq_printf);
 
 int trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
 {
@@ -538,6 +539,7 @@ int register_ftrace_event(struct trace_event *event)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(register_ftrace_event);
 
 /**
  * unregister_ftrace_event - remove a no longer used event
@@ -551,6 +553,7 @@ int unregister_ftrace_event(struct trace_event *event)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(unregister_ftrace_event);
 
 /*
  * Standard events
-- 
1.6.2.1

-- 
