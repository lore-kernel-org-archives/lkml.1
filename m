Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648Ab0CJHvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 02:51:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234Ab0CJHvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 02:51:18 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHv2 3/4] tracing: graph output support for preemptirqsoff/preemptoff tracers
Date: Wed, 10 Mar 2010 08:51:09 +0100
Message-Id: <1268207470-2880-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1268207470-2880-1-git-send-email-jolsa@redhat.com>
References: <1268207470-2880-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

adding support for graph output for preemptirqsoff/preemptoff tracers.

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/trace_irqsoff.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index d0c6d6c..e8b4acf 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -583,9 +583,15 @@ static struct tracer preemptoff_tracer __read_mostly =
 	.start		= irqsoff_tracer_start,
 	.stop		= irqsoff_tracer_stop,
 	.print_max	= 1,
+	.flags		= &tracer_flags,
+	.set_flag	= irqsoff_set_flag,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_preemptoff,
 #endif
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	.open		= irqsoff_trace_open,
+	.close		= irqsoff_trace_close,
+#endif
 };
 # define register_preemptoff(trace) register_tracer(&trace)
 #else
@@ -611,9 +617,15 @@ static struct tracer preemptirqsoff_tracer __read_mostly =
 	.start		= irqsoff_tracer_start,
 	.stop		= irqsoff_tracer_stop,
 	.print_max	= 1,
+	.flags		= &tracer_flags,
+	.set_flag	= irqsoff_set_flag,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_preemptirqsoff,
 #endif
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	.open		= irqsoff_trace_open,
+	.close		= irqsoff_trace_close,
+#endif
 };
 
 # define register_preemptirqsoff(trace) register_tracer(&trace)
-- 
1.6.6

