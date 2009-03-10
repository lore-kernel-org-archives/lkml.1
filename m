Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbZCJFAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbZCJFAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 01:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbZCJE6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 00:58:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62438 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbZCJE6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 00:58:15 -0400
Message-Id: <20090310045811.930011828@goodmis.org>
References: <20090310045710.286915983@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 10 Mar 2009 00:57:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Larry Woodman <lwoodman@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 7/7] tracing: remove obsolete TRACE_EVENT_FORMAT macro
Content-Disposition: inline; filename=0007-tracing-remove-obsolete-TRACE_EVENT_FORMAT-macro.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

The TRACE_EVENT_FORMAT macro is no longer used by trace points
and only the DECLARE_TRACE, TRACE_FORMAT or TRACE_EVENT macros should
be used by them. Although the TRACE_EVENT_FORMAT macro is still used
by the internal tracing utility, it should not be used in core
kernel code.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/tracepoint.h          |    3 ---
 include/trace/lockdep_event_types.h |    2 +-
 include/trace/sched_event_types.h   |    2 +-
 kernel/trace/trace_events_stage_1.h |    3 ---
 kernel/trace/trace_events_stage_3.h |    6 +-----
 5 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 6b4f1bb..69b5698 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -157,9 +157,6 @@ static inline void tracepoint_synchronize_unregister(void)
 #define TRACE_FORMAT(name, proto, args, fmt)		\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 
-#define TRACE_EVENT_FORMAT(name, proto, args, fmt, struct, tpfmt)	\
-	TRACE_FORMAT(name, PARAMS(proto), PARAMS(args), PARAMS(fmt))
-
 #define TRACE_EVENT(name, proto, args, struct, print, assign)	\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 
diff --git a/include/trace/lockdep_event_types.h b/include/trace/lockdep_event_types.h
index 1f00e8b..adccfcd 100644
--- a/include/trace/lockdep_event_types.h
+++ b/include/trace/lockdep_event_types.h
@@ -1,5 +1,5 @@
 
-#ifndef TRACE_EVENT_FORMAT
+#ifndef TRACE_FORMAT
 # error Do not include this file directly.
 # error Unless you know what you are doing.
 #endif
diff --git a/include/trace/sched_event_types.h b/include/trace/sched_event_types.h
index 0bbbf41..fb37af6 100644
--- a/include/trace/sched_event_types.h
+++ b/include/trace/sched_event_types.h
@@ -1,6 +1,6 @@
 
 /* use <trace/sched.h> instead */
-#ifndef TRACE_EVENT_FORMAT
+#ifndef TRACE_EVENT
 # error Do not include this file directly.
 # error Unless you know what you are doing.
 #endif
diff --git a/kernel/trace/trace_events_stage_1.h b/kernel/trace/trace_events_stage_1.h
index edfcbd3..15e9bf9 100644
--- a/kernel/trace/trace_events_stage_1.h
+++ b/kernel/trace/trace_events_stage_1.h
@@ -17,9 +17,6 @@
 #undef TRACE_FORMAT
 #define TRACE_FORMAT(call, proto, args, fmt)
 
-#undef TRACE_EVENT_FORMAT
-#define TRACE_EVENT_FORMAT(name, proto, args, fmt, tstruct, tpfmt)
-
 #undef __array
 #define __array(type, item, len)	type	item[len];
 
diff --git a/kernel/trace/trace_events_stage_3.h b/kernel/trace/trace_events_stage_3.h
index 8e398d8..3ba55d4 100644
--- a/kernel/trace/trace_events_stage_3.h
+++ b/kernel/trace/trace_events_stage_3.h
@@ -35,7 +35,7 @@
  * }
  *
  *
- * For those macros defined with TRACE_EVENT_FORMAT:
+ * For those macros defined with TRACE_EVENT:
  *
  * static struct ftrace_event_call event_<call>;
  *
@@ -144,10 +144,6 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.unregfunc		= ftrace_unreg_event_##call,		\
 }
 
-#undef TRACE_EVENT_FORMAT
-#define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, raw)	\
-	TRACE_FORMAT(call, PARAMS(proto), PARAMS(args), PARAMS(fmt))
-
 #undef __entry
 #define __entry entry
 
-- 
1.6.1.3

-- 
