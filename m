Return-Path: <linux-kernel-owner+w=401wt.eu-S936397AbXGMXWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936397AbXGMXWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 19:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760382AbXGMXW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 19:22:27 -0400
Received: from h155.mvista.com ([63.81.120.158]:7301 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759161AbXGMXW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 19:22:27 -0400
Message-ID: <46980935.3060509@mvista.com>
Date: Fri, 13 Jul 2007 16:22:29 -0700
From: Kevin Hilman <khilman@mvista.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Kevin Hilman <khilman@mvista.com>
Cc: tglx@linutronix.de, mingo@elte.hu, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -rt 6/6] Compile fix for PREEMPT_TIMING on and IRQSOFF_TIMING
 off
References: <20070713175214.336577416@mvista.com> <20070713175229.239602308@mvista.com>
In-Reply-To: <20070713175229.239602308@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Minor update to avoid a compiler warning in the case of DEBUG_KERNEL=n]

Compile fix for PREEMPT_TIMING on and IRQSOFF_TIMING off

The per-cpu trace_cpu_idle variable is used when timing *either*
IRQs-off or preempt sections.

Signed-off-by: Kevin Hilman <khilman@mvista.com>
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
+   (defined(CONFIG_CRITICAL_PREEMPT_TIMING) &&
defined(CONFIG_TRACE_IRQFLAGS))
+   static DEFINE_PER_CPU(int, trace_cpu_idle);
+#endif
+
 #ifdef CONFIG_CRITICAL_IRQSOFF_TIMING
 # ifdef CONFIG_CRITICAL_PREEMPT_TIMING
-   static DEFINE_PER_CPU(int, trace_cpu_idle);
 #  define irqs_off_preempt_count() (preempt_count() &&
!__get_cpu_var(trace_cpu_idle))
 # else
 #  define irqs_off_preempt_count() 0

