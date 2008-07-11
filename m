Return-Path: <linux-kernel-owner+w=401wt.eu-S1759280AbYGKBAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280AbYGKBAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 21:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755810AbYGKA7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 20:59:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60112 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbYGKA7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 20:59:52 -0400
Message-Id: <20080711005950.395979871@goodmis.org>
References: <20080711005808.316194101@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jul 2008 20:58:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/8] ftrace: define function trace nop
Content-Disposition: inline; filename=ftrace-function-record-nop.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_FTRACE is not enabled, the tracing_start_functon_trace
and tracing_stop_function_trace should be nops.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.h |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Index: linux-tip.git/kernel/trace/trace.h
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.h	2008-06-26 14:58:55.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.h	2008-06-30 22:39:15.000000000 -0400
@@ -216,8 +216,6 @@ void trace_function(struct trace_array *
 		    unsigned long parent_ip,
 		    unsigned long flags);
 
-void tracing_start_function_trace(void);
-void tracing_stop_function_trace(void);
 void tracing_start_cmdline_record(void);
 void tracing_stop_cmdline_record(void);
 int register_tracer(struct tracer *type);
@@ -234,6 +232,14 @@ void update_max_tr_single(struct trace_a
 
 extern cycle_t ftrace_now(int cpu);
 
+#ifdef CONFIG_FTRACE
+void tracing_start_function_trace(void);
+void tracing_stop_function_trace(void);
+#else
+# define tracing_start_function_trace()		do { } while (0)
+# define tracing_stop_function_trace()		do { } while (0)
+#endif
+
 #ifdef CONFIG_CONTEXT_SWITCH_TRACER
 typedef void
 (*tracer_switch_func_t)(void *private,

-- 
