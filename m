Return-Path: <linux-kernel-owner+w=401wt.eu-S936121AbXGMSOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936121AbXGMSOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 14:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933154AbXGMSNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 14:13:13 -0400
Received: from deeprooted.net ([216.254.16.51]:38937 "EHLO paris.hilman.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760102AbXGMSNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 14:13:07 -0400
Message-Id: <20070713175229.239602308@mvista.com>
References: <20070713175214.336577416@mvista.com>
User-Agent: quilt/0.45-1
Date: Fri, 13 Jul 2007 10:52:20 -0700
From: Kevin Hilman <khilman@mvista.com>
To: tglx@linutronix.de, mingo@elte.hu
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH -rt 6/6] Compile fix for PREEMPT_TIMING on and IRQSOFF_TIMING off
Content-Disposition: inline; filename=trace-cpu-idle.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The per-cpu trace_cpu_idle variable is used when timing *either*
IRQs-off or preempt sections.

---
 kernel/latency_trace.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/latency_trace.c
===================================================================
--- linux-2.6.orig/kernel/latency_trace.c
+++ linux-2.6/kernel/latency_trace.c
@@ -85,9 +85,13 @@ static inline int DEBUG_WARN_ON(int cond
 }
 #endif
 
+#if defined(CONFIG_CRITICAL_IRQSOFF_TIMING) || \
+    defined(CONFIG_CRITICAL_PREEMPT_TIMING)
+   static DEFINE_PER_CPU(int, trace_cpu_idle);
+#endif
+
 #ifdef CONFIG_CRITICAL_IRQSOFF_TIMING
 # ifdef CONFIG_CRITICAL_PREEMPT_TIMING
-   static DEFINE_PER_CPU(int, trace_cpu_idle);
 #  define irqs_off_preempt_count() (preempt_count() && !__get_cpu_var(trace_cpu_idle))
 # else
 #  define irqs_off_preempt_count() 0

--
