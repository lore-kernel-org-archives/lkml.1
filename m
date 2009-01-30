Return-Path: <linux-kernel-owner+w=401wt.eu-S1753255AbZA3Lp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbZA3Lp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 06:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755159AbZA3Ln7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 06:43:59 -0500
Received: from www.tglx.de ([62.245.132.106]:40369 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755102AbZA3Ln6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 06:43:58 -0500
Message-Id: <20090130114307.157239063@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 30 Jan 2009 11:43:46 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Carsten Emde <cbe@osadl.org>,
       Carsten Emde <C.Emde@osadl.org>
Subject: [patch-rt 5/5] trace: warn if irqs already enabled in irqs_off
	latency check
References: <20090130114230.100052140@linutronix.de>
Content-Disposition: inline;
	filename=warn-if-irqs-already-enabled-in-irqs-off-latency-check.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Be consistent: Warn if irqs are already enabled in irqs_off latency
processing, same as in preempt_off and in irqs_off && preempt_off. This
warning can now safely be inserted, after a problem was fixed that
caused false positives.

Signed-off-by: Carsten Emde <C.Emde@osadl.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 kernel/trace/trace_hist.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.26.8/kernel/trace/trace_hist.c
===================================================================
--- linux-2.6.26.8.orig/kernel/trace/trace_hist.c
+++ linux-2.6.26.8/kernel/trace/trace_hist.c
@@ -356,6 +356,7 @@ notrace void tracing_hist_preempt_stop(i
 #ifdef CONFIG_INTERRUPT_OFF_HIST
 	if (irqs_on &&
 	    per_cpu(hist_irqsoff_tracing, cpu)) {
+		WARN_ON(!irqs_disabled());
 		stop = ftrace_now(cpu);
 		stop_set++;
 		start = per_cpu(hist_irqsoff_start, cpu);


