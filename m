Return-Path: <linux-kernel-owner+w=401wt.eu-S1751498AbZKLFso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498AbZKLFso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 00:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbZKLFsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 00:48:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58823 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbZKLFsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 00:48:41 -0500
Message-Id: <20091112054845.801761406@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 12 Nov 2009 00:43:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: [PATCH 2/3][RFC] tracing: Make the trace_clock_local and trace_normalize_local weak
References: <20091112054354.838746008@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Make-the-trace_clock_local-and-trace_normali.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The function trace_clock_local uses sched_clock for taking the time
stamp. For some archs this is not the most efficient method.
Making the trace_clock_local and trace_normalize_local functions weak
allow for archs to override what they are defined as.

This patch also removes some "notrace" annotations from the trace_clock.c
file since the entire trace directory has the -pg option removed
from compiling.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_clock.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 168bf59..2b21f61 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -28,7 +28,7 @@
  * Useful for tracing that does not cross to other CPUs nor
  * does it go through idle events.
  */
-u64 notrace trace_clock_local(void)
+u64 __weak trace_clock_local(void)
 {
 	u64 clock;
 	int resched;
@@ -52,7 +52,7 @@ u64 notrace trace_clock_local(void)
  *
  * Normalize the trace_clock_local value.
  */
-void notrace trace_normalize_local(int cpu, u64 *ts)
+void __weak trace_normalize_local(int cpu, u64 *ts)
 {
 	/* nop */
 }
@@ -65,7 +65,7 @@ void notrace trace_normalize_local(int cpu, u64 *ts)
  * jitter between CPUs. So it's a pretty scalable clock, but there
  * can be offsets in the trace data.
  */
-u64 notrace trace_clock(void)
+u64 trace_clock(void)
 {
 	return cpu_clock(raw_smp_processor_id());
 }
@@ -89,7 +89,7 @@ static struct {
 		.lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED,
 	};
 
-u64 notrace trace_clock_global(void)
+u64 trace_clock_global(void)
 {
 	unsigned long flags;
 	int this_cpu;
-- 
1.6.5


