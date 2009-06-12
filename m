Return-Path: <linux-kernel-owner+w=401wt.eu-S1764833AbZFLNHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764833AbZFLNHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764693AbZFLNGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:06:10 -0400
Received: from ozlabs.org ([203.10.76.45]:49204 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764691AbZFLNGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:06:09 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: rostedt@goodmis.org
Subject: [PATCH] cpumask: use new operators in kernel/trace
Date: Fri, 12 Jun 2009 22:36:05 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906122236.06459.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
To: rostedt@goodmis.org
---
 kernel/trace/kmemtrace.c   |    2 +-
 kernel/trace/ring_buffer.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -182,7 +182,7 @@ static int kmem_trace_init(struct trace_
 	int cpu;
 	kmemtrace_array = tr;
 
-	for_each_cpu_mask(cpu, cpu_possible_map)
+	for_each_cpu(cpu, cpu_possible_mask)
 		tracing_reset(tr, cpu);
 
 	kmemtrace_start_probes();
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2870,7 +2870,7 @@ static int rb_cpu_notify(struct notifier
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		if (cpu_isset(cpu, *buffer->cpumask))
+		if (cpumask_test_cpu(cpu, buffer->cpumask))
 			return NOTIFY_OK;
 
 		buffer->buffers[cpu] =
@@ -2881,7 +2881,7 @@ static int rb_cpu_notify(struct notifier
 			return NOTIFY_OK;
 		}
 		smp_wmb();
-		cpu_set(cpu, *buffer->cpumask);
+		cpumask_set_cpu(cpu, buffer->cpumask);
 		break;
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:

