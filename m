Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063AbZLZWLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbZLZWLL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 17:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753956AbZLZWLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 17:11:09 -0500
Received: from toro.web-alm.net ([62.245.132.31]:35207 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867AbZLZWLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 17:11:01 -0500
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Dec 2009 17:10:54 EST
Message-Id: <20091226214229.238699028@osadl.org>
User-Agent: quilt/0.47-1
Date: Sat, 26 Dec 2009 22:41:15 +0100
From: Carsten Emde <C.Emde@osadl.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       RT-users <linux-rt-users@vger.kernel.org>,
       Carsten Emde <C.Emde@osadl.org>
Subject: [PATCH 1/2] add-tracing_max_latency-may-not-be-worst-case-system-latency-to-ftrace-docs.patch
References: <20091226214114.843059850@osadl.org>
Content-Disposition: inline; filename=add-tracing_max_latency-may-not-be-worst-case-system-latency-to-ftrace-docs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Explain the background of the trace variable
tracing_max_latency in the context of the
wakeup and the wakeup_rt tracer and why it
does not necessarily measure the worst-case
latency of the system.

Signed-off-by: Carsten Emde <C.Emde@osadl.org>

Index: linux-2.6.33-rc2/Documentation/trace/ftrace.txt
===================================================================
--- linux-2.6.33-rc2.orig/Documentation/trace/ftrace.txt
+++ linux-2.6.33-rc2/Documentation/trace/ftrace.txt
@@ -117,9 +117,25 @@ of ftrace. Here is a list of some of the
 	For example, the time interrupts are disabled.
 	This time is saved in this file. The max trace
 	will also be stored, and displayed by "trace".
-	A new max trace will only be recorded if the
+	A new max trace will only be recorded, if the
 	latency is greater than the value in this
-	file. (in microseconds)
+	file (in microseconds). NOTE: The max latency
+	recorded by the wakeup and the wakeup_rt tracer
+	do not necessarily reflect the worst-case latency
+	of the system. If two or more processes share the
+	highest priority of the system and may be woken
+	up shortly after each other, the max latency
+	recorded by the wakeup and the wakeup_rt tracers
+	equal the worst-case latency of the system *plus*
+	the longest possible runtime duration of all tasks
+	that share the same priority. An exact measurement
+	of the worst-case wakeup latency of the system can
+	be achieved using the wakekup latency histograms
+	that are part of the PREEMPT_RT patches. These
+	histograms separately determine the wakeup latency
+	of a task that exclusively uses the highest
+	priority of the system and of tasks that share the
+	highest priority of the system with other tasks.
 
   buffer_size_kb:
 

