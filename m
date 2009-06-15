Return-Path: <linux-kernel-owner+w=401wt.eu-S932906AbZFOSNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932906AbZFOSNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759340AbZFOSNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:13:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:42601 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755804AbZFOSNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:13:21 -0400
Date: Mon, 15 Jun 2009 18:12:50 GMT
From: tip-bot for Rusty Russell <rusty@rustcorp.com.au>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, rusty@rustcorp.com.au, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <200906122115.30787.rusty@rustcorp.com.au>
References: <200906122115.30787.rusty@rustcorp.com.au>
Subject: [tip:tracing/urgent] cpumask: use new operators in kernel/trace
Message-ID: <tip-3f237a79ddeea34dda67e9eedece3a22918df75e@git.kernel.org>
Git-Commit-ID: 3f237a79ddeea34dda67e9eedece3a22918df75e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 15 Jun 2009 18:12:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3f237a79ddeea34dda67e9eedece3a22918df75e
Gitweb:     http://git.kernel.org/tip/3f237a79ddeea34dda67e9eedece3a22918df75e
Author:     Rusty Russell <rusty@rustcorp.com.au>
AuthorDate: Fri, 12 Jun 2009 21:15:30 +0930
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 15 Jun 2009 11:36:42 -0400

cpumask: use new operators in kernel/trace

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
