Return-Path: <linux-kernel-owner+w=401wt.eu-S1764711AbZAPEzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764711AbZAPEzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 23:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756754AbZAPEyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 23:54:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37344 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228AbZAPEyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 23:54:20 -0500
Message-Id: <20090116045418.484916995@goodmis.org>
References: <20090116045342.748642160@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 15 Jan 2009 23:53:47 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 5/6] ftrace: remove static from function tracer functions
Content-Disposition: inline; filename=0005-ftrace-remove-static-from-function-tracer-functions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

After reorganizing the functions in trace.c and trace_function.c,
they no longer need to be in global context. This patch makes the
functions and one variable into static.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c           |    3 ---
 kernel/trace/trace.h           |   10 ----------
 kernel/trace/trace_functions.c |   10 ++++++++--
 3 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 2585ffb..7de6a94 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -187,9 +187,6 @@ int tracing_is_enabled(void)
 	return tracer_enabled;
 }
 
-/* function tracing enabled */
-int				ftrace_function_enabled;
-
 /*
  * trace_buf_size is the size in bytes that is allocated
  * for a buffer. Note, the number of bytes is always rounded
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index bf39a36..54b7278 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -464,16 +464,6 @@ void __trace_stack(struct trace_array *tr,
 
 extern cycle_t ftrace_now(int cpu);
 
-#ifdef CONFIG_FUNCTION_TRACER
-void tracing_start_function_trace(void);
-void tracing_stop_function_trace(void);
-#else
-# define tracing_start_function_trace()		do { } while (0)
-# define tracing_stop_function_trace()		do { } while (0)
-#endif
-
-extern int ftrace_function_enabled;
-
 #ifdef CONFIG_CONTEXT_SWITCH_TRACER
 typedef void
 (*tracer_switch_func_t)(void *private,
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 61d0b73..b3a320f 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -16,8 +16,14 @@
 
 #include "trace.h"
 
+/* function tracing enabled */
+static int			ftrace_function_enabled;
+
 static struct trace_array	*func_trace;
 
+static void tracing_start_function_trace(void);
+static void tracing_stop_function_trace(void);
+
 static void start_function_trace(struct trace_array *tr)
 {
 	func_trace = tr;
@@ -177,7 +183,7 @@ static struct tracer_flags func_flags = {
 	.opts = func_opts
 };
 
-void tracing_start_function_trace(void)
+static void tracing_start_function_trace(void)
 {
 	ftrace_function_enabled = 0;
 
@@ -194,7 +200,7 @@ void tracing_start_function_trace(void)
 	ftrace_function_enabled = 1;
 }
 
-void tracing_stop_function_trace(void)
+static void tracing_stop_function_trace(void)
 {
 	ftrace_function_enabled = 0;
 	/* OK if they are not registered */
-- 
1.5.6.5

-- 
