Return-Path: <linux-kernel-owner+w=401wt.eu-S1763258AbZFOPpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763258AbZFOPpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761359AbZFOPoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:44:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38256 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031AbZFOPoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:44:09 -0400
Message-Id: <20090615154410.524308621@goodmis.org>
References: <20090615154226.058101204@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 15 Jun 2009 11:42:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 1/7] cpumask: use new operators in kernel/trace
Content-Disposition: inline; filename=0001-cpumask-use-new-operators-in-kernel-trace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
LKML-Reference: <200906122115.30787.rusty@rustcorp.com.au>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/kmemtrace.c   |    2 +-
 kernel/trace/ring_buffer.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index 86cdf67..1edaa95 100644
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -186,7 +186,7 @@ static int kmem_trace_init(struct trace_array *tr)
 	int cpu;
 	kmemtrace_array = tr;
 
-	for_each_cpu_mask(cpu, cpu_possible_map)
+	for_each_cpu(cpu, cpu_possible_mask)
 		tracing_reset(tr, cpu);
 
 	kmemtrace_start_probes();
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 2e642b2..9c31c9f 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3105,7 +3105,7 @@ static int rb_cpu_notify(struct notifier_block *self,
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		if (cpu_isset(cpu, *buffer->cpumask))
+		if (cpumask_test_cpu(cpu, buffer->cpumask))
 			return NOTIFY_OK;
 
 		buffer->buffers[cpu] =
@@ -3116,7 +3116,7 @@ static int rb_cpu_notify(struct notifier_block *self,
 			return NOTIFY_OK;
 		}
 		smp_wmb();
-		cpu_set(cpu, *buffer->cpumask);
+		cpumask_set_cpu(cpu, buffer->cpumask);
 		break;
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
-- 
1.6.3.1

-- 
