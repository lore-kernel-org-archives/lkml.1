Return-Path: <linux-kernel-owner+w=401wt.eu-S1751314AbYITIBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314AbYITIBO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 04:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751413AbYITIAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 04:00:48 -0400
Received: from qb-out-0506.google.com ([72.14.204.239]:54294 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbYITIAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 04:00:47 -0400
From: Steven Noonan <steven@uplinklabs.net>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu,
       Steven Noonan <steven@uplinklabs.net>
Subject: [PATCH] trace: remove pointless ifdefs
Date: Sat, 20 Sep 2008 01:00:38 -0700
Message-Id: <1221897638-16272-2-git-send-email-steven@uplinklabs.net>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1221897638-16272-1-git-send-email-steven@uplinklabs.net>
References: <20080920061659.GF25713@elte.hu>
 <1221897638-16272-1-git-send-email-steven@uplinklabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions are already 'extern' anyway, so there's no problem
with linkage. Removing these ifdefs also helps find any potential
compiler errors.

Signed-off-by: Steven Noonan <steven@uplinklabs.net>
---
 kernel/trace/trace.h |   16 ----------------
 1 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 447d4b9..c8c6870 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -319,38 +319,22 @@ extern int DYN_FTRACE_TEST_NAME(void);
 #endif
 
 #ifdef CONFIG_FTRACE_STARTUP_TEST
-#ifdef CONFIG_FTRACE
 extern int trace_selftest_startup_function(struct tracer *trace,
 					   struct trace_array *tr);
-#endif
-#ifdef CONFIG_IRQSOFF_TRACER
 extern int trace_selftest_startup_irqsoff(struct tracer *trace,
 					  struct trace_array *tr);
-#endif
-#ifdef CONFIG_PREEMPT_TRACER
 extern int trace_selftest_startup_preemptoff(struct tracer *trace,
 					     struct trace_array *tr);
-#endif
-#if defined(CONFIG_IRQSOFF_TRACER) && defined(CONFIG_PREEMPT_TRACER)
 extern int trace_selftest_startup_preemptirqsoff(struct tracer *trace,
 						 struct trace_array *tr);
-#endif
-#ifdef CONFIG_SCHED_TRACER
 extern int trace_selftest_startup_wakeup(struct tracer *trace,
 					 struct trace_array *tr);
-#endif
-#ifdef CONFIG_NOP_TRACER
 extern int trace_selftest_startup_nop(struct tracer *trace,
 					 struct trace_array *tr);
-#endif
-#ifdef CONFIG_CONTEXT_SWITCH_TRACER
 extern int trace_selftest_startup_sched_switch(struct tracer *trace,
 					       struct trace_array *tr);
-#endif
-#ifdef CONFIG_SYSPROF_TRACER
 extern int trace_selftest_startup_sysprof(struct tracer *trace,
 					       struct trace_array *tr);
-#endif
 #endif /* CONFIG_FTRACE_STARTUP_TEST */
 
 extern void *head_page(struct trace_array_cpu *data);
-- 
1.6.0.2

