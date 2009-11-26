Return-Path: <linux-kernel-owner+w=401wt.eu-S1759516AbZKZIQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759516AbZKZIQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 03:16:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759454AbZKZIQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 03:16:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:57505 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759450AbZKZIQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 03:16:57 -0500
Date: Thu, 26 Nov 2009 08:16:21 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, penberg@cs.helsinki.fi,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4B0E286A.2000405@cn.fujitsu.com>
References: <4B0E286A.2000405@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] events: Rename TRACE_EVENT_TEMPLATE() to DECLARE_EVENT_CLASS()
Message-ID: <tip-091ad3658e3c76c5fb05f65bfb64a0246f8f31b5@git.kernel.org>
Git-Commit-ID: 091ad3658e3c76c5fb05f65bfb64a0246f8f31b5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  091ad3658e3c76c5fb05f65bfb64a0246f8f31b5
Gitweb:     http://git.kernel.org/tip/091ad3658e3c76c5fb05f65bfb64a0246f8f31b5
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 26 Nov 2009 09:04:55 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Nov 2009 09:04:55 +0100

events: Rename TRACE_EVENT_TEMPLATE() to DECLARE_EVENT_CLASS()

It is not quite obvious at first sight what TRACE_EVENT_TEMPLATE
does: does it define an event as well beyond defining a template?

To clarify this, rename it to DECLARE_EVENT_CLASS, which follows
the various 'DECLARE_*()' idioms we already have in the kernel:

  DECLARE_EVENT_CLASS(class)

    DEFINE_EVENT(class, event1)
    DEFINE_EVENT(class, event2)
    DEFINE_EVENT(class, event3)

To complete this logic we should also rename TRACE_EVENT() to:

  DEFINE_SINGLE_EVENT(single_event)

... but in a more quiet moment of the kernel cycle.

Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4B0E286A.2000405@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/tracepoint.h   |    2 +-
 include/trace/define_trace.h |    2 +-
 include/trace/events/sched.h |    6 ++--
 include/trace/ftrace.h       |   46 +++++++++++++++++++++---------------------
 4 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 7063383..f59604e 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -280,7 +280,7 @@ static inline void tracepoint_synchronize_unregister(void)
  * TRACE_EVENT_FN to perform any (un)registration work.
  */
 
-#define TRACE_EVENT_TEMPLATE(name, proto, args, tstruct, assign, print)
+#define DECLARE_EVENT_CLASS(name, proto, args, tstruct, assign, print)
 #define DEFINE_EVENT(template, name, proto, args)		\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index 5d7d855..5acfb1e 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -71,7 +71,7 @@
 
 #undef TRACE_EVENT
 #undef TRACE_EVENT_FN
-#undef TRACE_EVENT_TEMPLATE
+#undef DECLARE_EVENT_CLASS
 #undef DEFINE_EVENT
 #undef DEFINE_EVENT_PRINT
 #undef TRACE_HEADER_MULTI_READ
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 238f74b..5ce7950 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -83,7 +83,7 @@ TRACE_EVENT(sched_wait_task,
  * (NOTE: the 'rq' argument is not used by generic trace events,
  *        but used by the latency tracer plugin. )
  */
-TRACE_EVENT_TEMPLATE(sched_wakeup_template,
+DECLARE_EVENT_CLASS(sched_wakeup_template,
 
 	TP_PROTO(struct rq *rq, struct task_struct *p, int success),
 
@@ -197,7 +197,7 @@ TRACE_EVENT(sched_migrate_task,
 		  __entry->orig_cpu, __entry->dest_cpu)
 );
 
-TRACE_EVENT_TEMPLATE(sched_process_template,
+DECLARE_EVENT_CLASS(sched_process_template,
 
 	TP_PROTO(struct task_struct *p),
 
@@ -316,7 +316,7 @@ TRACE_EVENT(sched_signal_send,
  * XXX the below sched_stat tracepoints only apply to SCHED_OTHER/BATCH/IDLE
  *     adding sched_stat support to SCHED_FIFO/RR would be welcome.
  */
-TRACE_EVENT_TEMPLATE(sched_stat_template,
+DECLARE_EVENT_CLASS(sched_stat_template,
 
 	TP_PROTO(struct task_struct *tsk, u64 delay),
 
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index b046177..2c9c073 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -19,17 +19,17 @@
 #include <linux/ftrace_event.h>
 
 /*
- * TRACE_EVENT_TEMPLATE can be used to add a generic function
+ * DECLARE_EVENT_CLASS can be used to add a generic function
  * handlers for events. That is, if all events have the same
  * parameters and just have distinct trace points.
  * Each tracepoint can be defined with DEFINE_EVENT and that
- * will map the TRACE_EVENT_TEMPLATE to the tracepoint.
+ * will map the DECLARE_EVENT_CLASS to the tracepoint.
  *
  * TRACE_EVENT is a one to one mapping between tracepoint and template.
  */
 #undef TRACE_EVENT
 #define TRACE_EVENT(name, proto, args, tstruct, assign, print) \
-	TRACE_EVENT_TEMPLATE(name,			       \
+	DECLARE_EVENT_CLASS(name,			       \
 			     PARAMS(proto),		       \
 			     PARAMS(args),		       \
 			     PARAMS(tstruct),		       \
@@ -56,8 +56,8 @@
 #undef TP_STRUCT__entry
 #define TP_STRUCT__entry(args...) args
 
-#undef TRACE_EVENT_TEMPLATE
-#define TRACE_EVENT_TEMPLATE(name, proto, args, tstruct, assign, print)	\
+#undef DECLARE_EVENT_CLASS
+#define DECLARE_EVENT_CLASS(name, proto, args, tstruct, assign, print)	\
 	struct ftrace_raw_##name {					\
 		struct trace_entry	ent;				\
 		tstruct							\
@@ -115,8 +115,8 @@
 #undef __string
 #define __string(item, src) __dynamic_array(char, item, -1)
 
-#undef TRACE_EVENT_TEMPLATE
-#define TRACE_EVENT_TEMPLATE(call, proto, args, tstruct, assign, print)	\
+#undef DECLARE_EVENT_CLASS
+#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 	struct ftrace_data_offsets_##call {				\
 		tstruct;						\
 	};
@@ -203,8 +203,8 @@
 #undef TP_perf_assign
 #define TP_perf_assign(args...)
 
-#undef TRACE_EVENT_TEMPLATE
-#define TRACE_EVENT_TEMPLATE(call, proto, args, tstruct, func, print)	\
+#undef DECLARE_EVENT_CLASS
+#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, func, print)	\
 static int								\
 ftrace_format_setup_##call(struct ftrace_event_call *unused,		\
 			   struct trace_seq *s)				\
@@ -321,8 +321,8 @@ ftrace_format_##name(struct ftrace_event_call *unused,			\
 		ftrace_print_symbols_seq(p, value, symbols);		\
 	})
 
-#undef TRACE_EVENT_TEMPLATE
-#define TRACE_EVENT_TEMPLATE(call, proto, args, tstruct, assign, print)	\
+#undef DECLARE_EVENT_CLASS
+#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 static enum print_line_t						\
 ftrace_raw_output_id_##call(int event_id, const char *name,		\
 			    struct trace_iterator *iter, int flags)	\
@@ -428,8 +428,8 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 #undef __string
 #define __string(item, src) __dynamic_array(char, item, -1)
 
-#undef TRACE_EVENT_TEMPLATE
-#define TRACE_EVENT_TEMPLATE(call, proto, args, tstruct, func, print)	\
+#undef DECLARE_EVENT_CLASS
+#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, func, print)	\
 static int								\
 ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 {									\
@@ -480,8 +480,8 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 #undef __string
 #define __string(item, src) __dynamic_array(char, item, strlen(src) + 1)
 
-#undef TRACE_EVENT_TEMPLATE
-#define TRACE_EVENT_TEMPLATE(call, proto, args, tstruct, assign, print)	\
+#undef DECLARE_EVENT_CLASS
+#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 static inline int ftrace_get_offsets_##call(				\
 	struct ftrace_data_offsets_##call *__data_offsets, proto)       \
 {									\
@@ -521,8 +521,8 @@ static inline int ftrace_get_offsets_##call(				\
  *
  */
 
-#undef TRACE_EVENT_TEMPLATE
-#define TRACE_EVENT_TEMPLATE(call, proto, args, tstruct, assign, print)
+#undef DECLARE_EVENT_CLASS
+#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)
 
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, name, proto, args)			\
@@ -681,8 +681,8 @@ static void ftrace_profile_disable_##name(struct ftrace_event_call *unused)\
 #define __assign_str(dst, src)						\
 	strcpy(__get_str(dst), src);
 
-#undef TRACE_EVENT_TEMPLATE
-#define TRACE_EVENT_TEMPLATE(call, proto, args, tstruct, assign, print)	\
+#undef DECLARE_EVENT_CLASS
+#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 									\
 static void ftrace_raw_event_id_##call(struct ftrace_event_call *event_call, \
 				       proto)				\
@@ -764,8 +764,8 @@ static int ftrace_raw_init_event_##call(struct ftrace_event_call *unused)\
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
-#undef TRACE_EVENT_TEMPLATE
-#define TRACE_EVENT_TEMPLATE(call, proto, args, tstruct, assign, print)
+#undef DECLARE_EVENT_CLASS
+#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)
 
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, call, proto, args)			\
@@ -885,8 +885,8 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 #undef __perf_count
 #define __perf_count(c) __count = (c)
 
-#undef TRACE_EVENT_TEMPLATE
-#define TRACE_EVENT_TEMPLATE(call, proto, args, tstruct, assign, print)	\
+#undef DECLARE_EVENT_CLASS
+#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 static void								\
 ftrace_profile_templ_##call(struct ftrace_event_call *event_call,	\
 			    proto)					\
