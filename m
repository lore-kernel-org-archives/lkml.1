Return-Path: <linux-kernel-owner+w=401wt.eu-S1752389AbYBJPuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbYBJPuG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 10:50:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbYBJPtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 10:49:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbYBJPtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 10:49:51 -0500
Date: Sun, 10 Feb 2008 23:49:23 +0800
From: Eugene Teo <eugeneteo@kernel.sg>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] ftrace: remove unused tracing_sched_switch_enabled
Message-ID: <20080210154923.GA15451@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
References: <20080210072050.GN4100@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210072050.GN4100@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tracing_sched_switch_enabled isn't used anywhere.

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
---
 kernel/trace/trace.h              |    1 -
 kernel/trace/trace_sched_switch.c |    9 +--------
 2 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index ac851b2..3173a93 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -138,7 +138,6 @@ void unregister_tracer(struct tracer *type);
 
 extern unsigned long nsecs_to_usecs(unsigned long nsecs);
 
-extern int tracing_sched_switch_enabled;
 extern unsigned long tracing_max_latency;
 extern unsigned long tracing_thresh;
 
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 412c226..c4e0134 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -16,7 +16,6 @@
 
 static struct trace_array	*ctx_trace;
 static int __read_mostly	tracer_enabled;
-int __read_mostly		tracing_sched_switch_enabled;
 
 static void notrace
 ctx_switch_func(struct task_struct *prev, struct task_struct *next)
@@ -114,12 +113,6 @@ __init static int init_sched_switch_trace(void)
 {
 	int ret;
 
-	ret = register_tracer(&sched_switch_trace);
-	if (ret)
-		return ret;
-
-	tracing_sched_switch_enabled = 1;
-
-	return ret;
+	return register_tracer(&sched_switch_trace);
 }
 device_initcall(init_sched_switch_trace);

