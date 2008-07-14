Return-Path: <linux-kernel-owner+w=401wt.eu-S1756345AbYGNOoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbYGNOoj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 10:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbYGNOob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 10:44:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34182 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823AbYGNOoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 10:44:30 -0400
Date: Mon, 14 Jul 2008 16:44:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] core/stacktrace changes for v2.6.27
Message-ID: <20080714144420.GA21632@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core/stacktrace git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core/stacktrace

Thanks,

	Ingo

------------------>
Ingo Molnar (3):
      debugging: make stacktrace independent from DEBUG_KERNEL
      stacktrace: fix modular build, export print_stack_trace and save_stack_trace
      stacktrace: export save_stack_trace[_tsk]

Johannes Berg (1):
      stacktrace: don't crash on invalid stack trace structs

Stephen Rothwell (1):
      stacktrace: fix build failure on sparc64

Vegard Nossum (3):
      stacktrace: print_stack_trace() cleanup
      stacktrace: add saved stack traces to backtrace self-test
      backtrace: replace timer with tasklet + completions


 arch/arm/kernel/stacktrace.c     |    1 +
 arch/avr32/kernel/stacktrace.c   |    1 +
 arch/mips/kernel/stacktrace.c    |    1 +
 arch/powerpc/kernel/stacktrace.c |    1 +
 arch/s390/kernel/stacktrace.c    |    2 +
 arch/sh/kernel/stacktrace.c      |    1 +
 arch/sparc64/kernel/stacktrace.c |    2 +
 arch/x86/kernel/stacktrace.c     |    2 +
 kernel/backtracetest.c           |   65 +++++++++++++++++++++++++++++++------
 kernel/stacktrace.c              |   14 +++++---
 lib/Kconfig.debug                |    4 ++-
 11 files changed, 76 insertions(+), 18 deletions(-)

diff --git a/arch/arm/kernel/stacktrace.c b/arch/arm/kernel/stacktrace.c
index ae31deb..6b3ffde 100644
--- a/arch/arm/kernel/stacktrace.c
+++ b/arch/arm/kernel/stacktrace.c
@@ -66,4 +66,5 @@ void save_stack_trace(struct stack_trace *trace)
 
 	walk_stackframe(fp, base, base + THREAD_SIZE, save_trace, &data);
 }
+EXPORT_SYMBOL_GPL(save_stack_trace);
 #endif
diff --git a/arch/avr32/kernel/stacktrace.c b/arch/avr32/kernel/stacktrace.c
index 9a68190..f4bdb44 100644
--- a/arch/avr32/kernel/stacktrace.c
+++ b/arch/avr32/kernel/stacktrace.c
@@ -51,3 +51,4 @@ void save_stack_trace(struct stack_trace *trace)
 		fp = frame->fp;
 	}
 }
+EXPORT_SYMBOL_GPL(save_stack_trace);
diff --git a/arch/mips/kernel/stacktrace.c b/arch/mips/kernel/stacktrace.c
index ebd9db8..5eb4681 100644
--- a/arch/mips/kernel/stacktrace.c
+++ b/arch/mips/kernel/stacktrace.c
@@ -73,3 +73,4 @@ void save_stack_trace(struct stack_trace *trace)
 	prepare_frametrace(regs);
 	save_context_stack(trace, regs);
 }
+EXPORT_SYMBOL_GPL(save_stack_trace);
diff --git a/arch/powerpc/kernel/stacktrace.c b/arch/powerpc/kernel/stacktrace.c
index 9629440..9861f17 100644
--- a/arch/powerpc/kernel/stacktrace.c
+++ b/arch/powerpc/kernel/stacktrace.c
@@ -44,3 +44,4 @@ void save_stack_trace(struct stack_trace *trace)
 		sp = newsp;
 	}
 }
+EXPORT_SYMBOL_GPL(save_stack_trace);
diff --git a/arch/s390/kernel/stacktrace.c b/arch/s390/kernel/stacktrace.c
index 85e46a5..57571f1 100644
--- a/arch/s390/kernel/stacktrace.c
+++ b/arch/s390/kernel/stacktrace.c
@@ -81,6 +81,7 @@ void save_stack_trace(struct stack_trace *trace)
 			   S390_lowcore.thread_info,
 			   S390_lowcore.thread_info + THREAD_SIZE, 1);
 }
+EXPORT_SYMBOL_GPL(save_stack_trace);
 
 void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
 {
@@ -93,3 +94,4 @@ void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
 	if (trace->nr_entries < trace->max_entries)
 		trace->entries[trace->nr_entries++] = ULONG_MAX;
 }
+EXPORT_SYMBOL_GPL(save_stack_trace_tsk);
diff --git a/arch/sh/kernel/stacktrace.c b/arch/sh/kernel/stacktrace.c
index d41e561..1b2ae35 100644
--- a/arch/sh/kernel/stacktrace.c
+++ b/arch/sh/kernel/stacktrace.c
@@ -34,3 +34,4 @@ void save_stack_trace(struct stack_trace *trace)
 		}
 	}
 }
+EXPORT_SYMBOL_GPL(save_stack_trace);
diff --git a/arch/sparc64/kernel/stacktrace.c b/arch/sparc64/kernel/stacktrace.c
index c73ce3f..b3e3737 100644
--- a/arch/sparc64/kernel/stacktrace.c
+++ b/arch/sparc64/kernel/stacktrace.c
@@ -1,6 +1,7 @@
 #include <linux/sched.h>
 #include <linux/stacktrace.h>
 #include <linux/thread_info.h>
+#include <linux/module.h>
 #include <asm/ptrace.h>
 #include <asm/stacktrace.h>
 
@@ -47,3 +48,4 @@ void save_stack_trace(struct stack_trace *trace)
 			trace->entries[trace->nr_entries++] = pc;
 	} while (trace->nr_entries < trace->max_entries);
 }
+EXPORT_SYMBOL_GPL(save_stack_trace);
diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index c28c342..a03e7f6 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -74,6 +74,7 @@ void save_stack_trace(struct stack_trace *trace)
 	if (trace->nr_entries < trace->max_entries)
 		trace->entries[trace->nr_entries++] = ULONG_MAX;
 }
+EXPORT_SYMBOL_GPL(save_stack_trace);
 
 void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
 {
@@ -81,3 +82,4 @@ void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
 	if (trace->nr_entries < trace->max_entries)
 		trace->entries[trace->nr_entries++] = ULONG_MAX;
 }
+EXPORT_SYMBOL_GPL(save_stack_trace_tsk);
diff --git a/kernel/backtracetest.c b/kernel/backtracetest.c
index d1a7605..a5e026b 100644
--- a/kernel/backtracetest.c
+++ b/kernel/backtracetest.c
@@ -10,30 +10,73 @@
  * of the License.
  */
 
+#include <linux/completion.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/sched.h>
-#include <linux/delay.h>
+#include <linux/stacktrace.h>
+
+static void backtrace_test_normal(void)
+{
+	printk("Testing a backtrace from process context.\n");
+	printk("The following trace is a kernel self test and not a bug!\n");
 
-static struct timer_list backtrace_timer;
+	dump_stack();
+}
 
-static void backtrace_test_timer(unsigned long data)
+static DECLARE_COMPLETION(backtrace_work);
+
+static void backtrace_test_irq_callback(unsigned long data)
+{
+	dump_stack();
+	complete(&backtrace_work);
+}
+
+static DECLARE_TASKLET(backtrace_tasklet, &backtrace_test_irq_callback, 0);
+
+static void backtrace_test_irq(void)
 {
 	printk("Testing a backtrace from irq context.\n");
 	printk("The following trace is a kernel self test and not a bug!\n");
-	dump_stack();
+
+	init_completion(&backtrace_work);
+	tasklet_schedule(&backtrace_tasklet);
+	wait_for_completion(&backtrace_work);
+}
+
+#ifdef CONFIG_STACKTRACE
+static void backtrace_test_saved(void)
+{
+	struct stack_trace trace;
+	unsigned long entries[8];
+
+	printk("Testing a saved backtrace.\n");
+	printk("The following trace is a kernel self test and not a bug!\n");
+
+	trace.nr_entries = 0;
+	trace.max_entries = ARRAY_SIZE(entries);
+	trace.entries = entries;
+	trace.skip = 0;
+
+	save_stack_trace(&trace);
+	print_stack_trace(&trace, 0);
+}
+#else
+static void backtrace_test_saved(void)
+{
+	printk("Saved backtrace test skipped.\n");
 }
+#endif
+
 static int backtrace_regression_test(void)
 {
 	printk("====[ backtrace testing ]===========\n");
-	printk("Testing a backtrace from process context.\n");
-	printk("The following trace is a kernel self test and not a bug!\n");
-	dump_stack();
 
-	init_timer(&backtrace_timer);
-	backtrace_timer.function = backtrace_test_timer;
-	mod_timer(&backtrace_timer, jiffies + 10);
+	backtrace_test_normal();
+	backtrace_test_irq();
+	backtrace_test_saved();
 
-	msleep(10);
 	printk("====[ end of backtrace testing ]====\n");
 	return 0;
 }
diff --git a/kernel/stacktrace.c b/kernel/stacktrace.c
index b71816e..94b527e 100644
--- a/kernel/stacktrace.c
+++ b/kernel/stacktrace.c
@@ -6,19 +6,21 @@
  *  Copyright (C) 2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
  */
 #include <linux/sched.h>
+#include <linux/module.h>
 #include <linux/kallsyms.h>
 #include <linux/stacktrace.h>
 
 void print_stack_trace(struct stack_trace *trace, int spaces)
 {
-	int i, j;
+	int i;
 
-	for (i = 0; i < trace->nr_entries; i++) {
-		unsigned long ip = trace->entries[i];
+	if (WARN_ON(!trace->entries))
+		return;
 
-		for (j = 0; j < spaces + 1; j++)
-			printk(" ");
-		print_ip_sym(ip);
+	for (i = 0; i < trace->nr_entries; i++) {
+		printk("%*c", 1 + spaces, ' ');
+		print_ip_sym(trace->entries[i]);
 	}
 }
+EXPORT_SYMBOL_GPL(print_stack_trace);
 
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index d2099f4..6263e2d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -419,7 +419,6 @@ config DEBUG_LOCKING_API_SELFTESTS
 
 config STACKTRACE
 	bool
-	depends on DEBUG_KERNEL
 	depends on STACKTRACE_SUPPORT
 
 config DEBUG_KOBJECT
@@ -563,6 +562,9 @@ config BACKTRACE_SELF_TEST
 	  for distributions or general kernels, but only for kernel
 	  developers working on architecture code.
 
+	  Note that if you want to also test saved backtraces, you will
+	  have to enable STACKTRACE as well.
+
 	  Say N if you are unsure.
 
 config LKDTM
