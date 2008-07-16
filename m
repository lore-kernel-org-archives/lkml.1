Return-Path: <linux-kernel-owner+w=401wt.eu-S1757878AbYGPHPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbYGPHPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 03:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758329AbYGPHPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 03:15:04 -0400
Received: from ozlabs.org ([203.10.76.45]:56471 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757746AbYGPHPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 03:15:03 -0400
To: <srostedt@redhat.com>
Cc: Andrew Morton <akpm@osdl.org>, <linux-kernel@vger.kernel.org>
Message-Id: <ea127060ce3764c4b714406be0521171b925a847.1216192501.git.michael@ellerman.id.au>
From: Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH] ftrace: Make output nicely spaced for up to 999 cpus
Date: Wed, 16 Jul 2008 17:15:01 +1000 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently some of the ftrace output goes skewiff if you have more
than 9 cpus, and some if you have more than 99.

Twiddle with the headers and format strings to make up to 999 cpus
display without causing spacing problems.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 kernel/trace/trace.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 868e121..be92a79 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1334,21 +1334,21 @@ seq_print_ip_sym(struct trace_seq *s, unsigned long ip, unsigned long sym_flags)
 
 static void print_lat_help_header(struct seq_file *m)
 {
-	seq_puts(m, "#                _------=> CPU#            \n");
-	seq_puts(m, "#               / _-----=> irqs-off        \n");
-	seq_puts(m, "#              | / _----=> need-resched    \n");
-	seq_puts(m, "#              || / _---=> hardirq/softirq \n");
-	seq_puts(m, "#              ||| / _--=> preempt-depth   \n");
-	seq_puts(m, "#              |||| /                      \n");
-	seq_puts(m, "#              |||||     delay             \n");
-	seq_puts(m, "#  cmd     pid ||||| time  |   caller      \n");
-	seq_puts(m, "#     \\   /    |||||   \\   |   /           \n");
+	seq_puts(m, "#                  _------=> CPU#            \n");
+	seq_puts(m, "#                 / _-----=> irqs-off        \n");
+	seq_puts(m, "#                | / _----=> need-resched    \n");
+	seq_puts(m, "#                || / _---=> hardirq/softirq \n");
+	seq_puts(m, "#                ||| / _--=> preempt-depth   \n");
+	seq_puts(m, "#                |||| /                      \n");
+	seq_puts(m, "#                |||||     delay             \n");
+	seq_puts(m, "#  cmd     pid   ||||| time  |   caller      \n");
+	seq_puts(m, "#     \\   /      |||||   \\   |   /           \n");
 }
 
 static void print_func_help_header(struct seq_file *m)
 {
-	seq_puts(m, "#           TASK-PID   CPU#    TIMESTAMP  FUNCTION\n");
-	seq_puts(m, "#              | |      |          |         |\n");
+	seq_puts(m, "#           TASK-PID    CPU#    TIMESTAMP  FUNCTION\n");
+	seq_puts(m, "#              | |       |          |         |\n");
 }
 
 
@@ -1432,7 +1432,7 @@ lat_print_generic(struct trace_seq *s, struct trace_entry *entry, int cpu)
 	comm = trace_find_cmdline(entry->pid);
 
 	trace_seq_printf(s, "%8.8s-%-5d ", comm, entry->pid);
-	trace_seq_printf(s, "%d", cpu);
+	trace_seq_printf(s, "%3d", cpu);
 	trace_seq_printf(s, "%c%c",
 			(entry->flags & TRACE_FLAG_IRQS_OFF) ? 'd' : '.',
 			((entry->flags & TRACE_FLAG_NEED_RESCHED) ? 'N' : '.'));
@@ -1497,7 +1497,7 @@ print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
 
 	if (verbose) {
 		comm = trace_find_cmdline(entry->pid);
-		trace_seq_printf(s, "%16s %5d %d %d %08x %08x [%08lx]"
+		trace_seq_printf(s, "%16s %5d %3d %d %08x %08x [%08lx]"
 				 " %ld.%03ldms (+%ld.%03ldms): ",
 				 comm,
 				 entry->pid, cpu, entry->flags,
@@ -1580,7 +1580,7 @@ static int print_trace_fmt(struct trace_iterator *iter)
 	ret = trace_seq_printf(s, "%16s-%-5d ", comm, entry->pid);
 	if (!ret)
 		return 0;
-	ret = trace_seq_printf(s, "[%02d] ", iter->cpu);
+	ret = trace_seq_printf(s, "[%03d] ", iter->cpu);
 	if (!ret)
 		return 0;
 	ret = trace_seq_printf(s, "%5lu.%06lu: ", secs, usec_rem);
-- 
1.5.5

