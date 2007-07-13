Return-Path: <linux-kernel-owner+w=401wt.eu-S935358AbXGMSNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935358AbXGMSNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 14:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932512AbXGMSNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 14:13:09 -0400
Received: from deeprooted.net ([216.254.16.51]:38939 "EHLO paris.hilman.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759850AbXGMSNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 14:13:06 -0400
Message-Id: <20070713175228.311226264@mvista.com>
References: <20070713175214.336577416@mvista.com>
User-Agent: quilt/0.45-1
Date: Fri, 13 Jul 2007 10:52:17 -0700
From: Kevin Hilman <khilman@mvista.com>
To: tglx@linutronix.de, mingo@elte.hu
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH -rt 3/6] Compile fix for PREEMPT_TIMING on and TRACE_IRQFLAGS off
Content-Disposition: inline; filename=latency-trace-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix compile of latency_trace.c in the case where
CRITICAL_PREEMPT_TIMING=y and TRACE_IRQFLAGS=n (because DEBUG_KERNEL
is disabled)

Signed-off-by: Kevin Hilman <khilman@mvista.com>
---
 kernel/latency_trace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.21/kernel/latency_trace.c
===================================================================
--- linux-2.6.21.orig/kernel/latency_trace.c
+++ linux-2.6.21/kernel/latency_trace.c
@@ -2151,7 +2151,7 @@ void notrace unmask_preempt_count(unsign
 }
 EXPORT_SYMBOL(unmask_preempt_count);
 
-#ifdef CONFIG_CRITICAL_PREEMPT_TIMING
+#if defined(CONFIG_CRITICAL_PREEMPT_TIMING) && defined(CONFIG_TRACE_IRQFLAGS)
 
 /* Some archs do their cpu_idle with preemption on. Don't measure it */
 void notrace trace_preempt_enter_idle(void)

--
