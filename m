Return-Path: <linux-kernel-owner+w=401wt.eu-S1756455AbYGNPGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455AbYGNPGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 11:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbYGNPF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 11:05:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37446 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975AbYGNPFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 11:05:54 -0400
Date: Mon, 14 Jul 2008 17:05:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] kmemcheck for v2.6.27
Message-ID: <20080714150523.GA24990@elte.hu>
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

Please pull the kmemcheck feature git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git kmemcheck-for-linus

kmemcheck has been written by Vegard Nossum and Pekka Enberg, with some 
help from the x86 guys as well. Bears the ACKs of all subsystems 
affected. (x86 and SLUB)

[ NOTE, this tree has been merged on top of x86/for-linus +
  tracing/for-linus, so please pull it only after having pulled those
  trees. ]

Thanks,

	Ingo

------------------>
Pekka Enberg (5):
      x86: __show_registers() and __show_regs() API unification
      slab: move struct kmem_cache to headers
      kmemcheck: add Vegard and Pekka to MAINTAINERS
      x86: add hooks for kmemcheck on x86_64
      slab: add hooks for kmemcheck

Vegard Nossum (16):
      x86: add save_stack_trace_bp() for tracing from a specific stack frame
      stacktrace: add forward-declaration struct task_struct
      tasklets: new tasklet scheduling function
      kmemcheck: add the kmemcheck core
      x86: add hooks for kmemcheck
      kmemcheck: add mm functions
      slub: add hooks for kmemcheck
      kmemcheck: enable in the x86 Kconfig
      kmemcheck: fix sparse warnings
      softirq: raise the right softirq
      kmemcheck: use the proper comment style
      kmemcheck: fix use of uninitialized spinlock
      kmemcheck: constrain tracking to non-debugged caches
      kmemcheck: mark SMP support BROKEN
      kmemcheck: use capital Y/N in kconfig help-texts
      kmemcheck: remove unnecessary tests in the slab allocator


 Documentation/kmemcheck.txt       |  135 ++++++++++
 MAINTAINERS                       |    8 +
 arch/x86/Kconfig.debug            |  109 +++++++++
 arch/x86/kernel/process.c         |    2 +-
 arch/x86/kernel/process_32.c      |    4 +-
 arch/x86/kernel/process_64.c      |   12 +-
 arch/x86/kernel/stacktrace.c      |    7 +
 arch/x86/kernel/traps_32.c        |   11 +-
 arch/x86/kernel/traps_64.c        |   11 +-
 arch/x86/mm/Makefile              |    2 +
 arch/x86/mm/fault.c               |   18 ++-
 arch/x86/mm/kmemcheck/Makefile    |    3 +
 arch/x86/mm/kmemcheck/error.c     |  216 ++++++++++++++++
 arch/x86/mm/kmemcheck/error.h     |   15 ++
 arch/x86/mm/kmemcheck/kmemcheck.c |  485 +++++++++++++++++++++++++++++++++++++
 arch/x86/mm/kmemcheck/opcode.c    |   72 ++++++
 arch/x86/mm/kmemcheck/opcode.h    |    9 +
 arch/x86/mm/kmemcheck/pte.c       |   22 ++
 arch/x86/mm/kmemcheck/pte.h       |   10 +
 arch/x86/mm/kmemcheck/shadow.c    |  175 +++++++++++++
 arch/x86/mm/kmemcheck/shadow.h    |   16 ++
 arch/x86/mm/kmemcheck/smp.c       |   80 ++++++
 arch/x86/mm/kmemcheck/smp.h       |   23 ++
 arch/x86/mm/kmemcheck/string.c    |   95 +++++++
 include/asm-x86/kdebug.h          |    3 +-
 include/asm-x86/kmemcheck.h       |   36 +++
 include/asm-x86/pgtable.h         |    4 +-
 include/asm-x86/pgtable_32.h      |    6 +
 include/asm-x86/pgtable_64.h      |    6 +
 include/asm-x86/string_32.h       |    8 +
 include/asm-x86/string_64.h       |    1 +
 include/linux/gfp.h               |    3 +-
 include/linux/interrupt.h         |   14 +
 include/linux/kmemcheck.h         |   70 ++++++
 include/linux/mm_types.h          |    4 +
 include/linux/slab.h              |    7 +
 include/linux/slab_def.h          |   81 ++++++
 include/linux/stacktrace.h        |    3 +
 init/main.c                       |    2 +
 kernel/fork.c                     |   16 +-
 kernel/softirq.c                  |   11 +
 kernel/sysctl.c                   |   12 +
 mm/Makefile                       |    2 +-
 mm/kmemcheck.c                    |   97 ++++++++
 mm/slab.c                         |  101 ++-------
 mm/slub.c                         |   20 ++-
 46 files changed, 1936 insertions(+), 111 deletions(-)
 create mode 100644 Documentation/kmemcheck.txt
 create mode 100644 arch/x86/mm/kmemcheck/Makefile
 create mode 100644 arch/x86/mm/kmemcheck/error.c
 create mode 100644 arch/x86/mm/kmemcheck/error.h
 create mode 100644 arch/x86/mm/kmemcheck/kmemcheck.c
 create mode 100644 arch/x86/mm/kmemcheck/opcode.c
 create mode 100644 arch/x86/mm/kmemcheck/opcode.h
 create mode 100644 arch/x86/mm/kmemcheck/pte.c
 create mode 100644 arch/x86/mm/kmemcheck/pte.h
 create mode 100644 arch/x86/mm/kmemcheck/shadow.c
 create mode 100644 arch/x86/mm/kmemcheck/shadow.h
 create mode 100644 arch/x86/mm/kmemcheck/smp.c
 create mode 100644 arch/x86/mm/kmemcheck/smp.h
 create mode 100644 arch/x86/mm/kmemcheck/string.c
 create mode 100644 include/asm-x86/kmemcheck.h
 create mode 100644 include/linux/kmemcheck.h
 create mode 100644 mm/kmemcheck.c

diff --git a/Documentation/kmemcheck.txt b/Documentation/kmemcheck.txt
new file mode 100644
index 0000000..843a63c
--- /dev/null
+++ b/Documentation/kmemcheck.txt
@@ -0,0 +1,135 @@
+Contents
+========
+
+  1. How to use
+  2. Technical description
+  3. Changes to the slab allocators
+  4. Problems
+  5. Parameters
+  6. Future enhancements
+
+
+How to use (IMPORTANT)
+======================
+
+Always remember this: kmemcheck _will_ give false positives. So don't enable
+it and spam the mailing list with its reports; you are not going to be heard,
+and it will make people's skins thicker for when the real errors are found.
+
+Instead, I encourage maintainers and developers to find errors in _their_
+_own_ code. And if you find false positives, you can try to work around them,
+try to figure out if it's a real bug or not, or simply ignore them. Most
+developers know their own code and will quickly and efficiently determine the
+root cause of a kmemcheck report. This is therefore also the most efficient
+way to work with kmemcheck.
+
+If you still want to run kmemcheck to inspect others' code, the rule of thumb
+should be: If it's not obvious (to you), don't tell us about it either. Most
+likely the code is correct and you'll only waste our time. If you can work
+out the error, please do send the maintainer a heads up and/or a patch, but
+don't expect him/her to fix something that wasn't wrong in the first place.
+
+
+Technical description
+=====================
+
+kmemcheck works by marking memory pages non-present. This means that whenever
+somebody attempts to access the page, a page fault is generated. The page
+fault handler notices that the page was in fact only hidden, and so it calls
+on the kmemcheck code to make further investigations.
+
+When the investigations are completed, kmemcheck "shows" the page by marking
+it present (as it would be under normal circumstances). This way, the
+interrupted code can continue as usual.
+
+But after the instruction has been executed, we should hide the page again, so
+that we can catch the next access too! Now kmemcheck makes use of a debugging
+feature of the processor, namely single-stepping. When the processor has
+finished the one instruction that generated the memory access, a debug
+exception is raised. From here, we simply hide the page again and continue
+execution, this time with the single-stepping feature turned off.
+
+
+Changes to the slab allocators
+==============================
+
+kmemcheck requires some assistance from the memory allocator in order to work.
+The memory allocator needs to
+
+1. Tell kmemcheck about newly allocated pages and pages that are about to
+   be freed. This allows kmemcheck to set up and tear down the shadow memory
+   for the pages in question. The shadow memory stores the status of each byte
+   in the allocation proper, e.g. whether it is initialized or uninitialized.
+2. Tell kmemcheck which parts of memory should be marked uninitialized. There
+   are actually a few more states, such as "not yet allocated" and "recently
+   freed".
+
+If a slab cache is set up using the SLAB_NOTRACK flag, it will never return
+memory that can take page faults because of kmemcheck.
+
+If a slab cache is NOT set up using the SLAB_NOTRACK flag, callers can still
+request memory with the __GFP_NOTRACK flag. This does not prevent the page
+faults from occurring, however, but marks the object in question as being
+initialized so that no warnings will ever be produced for this object.
+
+Currently, the SLAB and SLUB allocators are supported by kmemcheck.
+
+
+Problems
+========
+
+The most prominent problem seems to be that of bit-fields. kmemcheck can only
+track memory with byte granularity. Therefore, when gcc generates code to
+access only one bit in a bit-field, there is really no way for kmemcheck to
+know which of the other bits will be used or thrown away. Consequently, there
+may be bogus warnings for bit-field accesses. There is some experimental
+support to detect this automatically, though it is probably better to work
+around this by explicitly initializing whole bit-fields at once.
+
+Some allocations are used for DMA. As DMA doesn't go through the paging
+mechanism, we have absolutely no way to detect DMA writes. This means that
+spurious warnings may be seen on access to DMA memory. DMA allocations should
+be annotated with the __GFP_NOTRACK flag or allocated from caches marked
+SLAB_NOTRACK to work around this problem.
+
+
+Parameters
+==========
+
+In addition to enabling CONFIG_KMEMCHECK before the kernel is compiled, the
+parameter kmemcheck=1 must be passed to the kernel when it is started in order
+to actually do the tracking. So by default, there is only a very small
+(probably negligible) overhead for enabling the config option.
+
+Similarly, kmemcheck may be turned on or off at run-time using, respectively:
+
+echo 1 > /proc/sys/kernel/kmemcheck
+	and
+echo 0 > /proc/sys/kernel/kmemcheck
+
+Note that this is a lazy setting; once turned off, the old allocations will
+still have to take a single page fault exception before tracking is turned off
+for that particular page. Enabling kmemcheck on will only enable tracking for
+allocations made from that point onwards.
+
+The default mode is the one-shot mode, where only the first error is reported
+before kmemcheck is disabled. This mode can be enabled by passing kmemcheck=2
+to the kernel at boot, or running
+
+echo 2 > /proc/sys/kernel/kmemcheck
+
+when the kernel is already running.
+
+
+Future enhancements
+===================
+
+There is already some preliminary support for catching use-after-free errors.
+What still needs to be done is delaying kfree() so that memory is not
+reallocated immediately after freeing it. [Suggested by Pekka Enberg.]
+
+It should be possible to allow SMP systems by duplicating the page tables for
+each processor in the system. This is probably extremely difficult, however.
+[Suggested by Ingo Molnar.]
+
+Support for instruction set extensions like XMM, SSE2, etc.
diff --git a/MAINTAINERS b/MAINTAINERS
index 1528e58..6ef8b00 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2431,6 +2431,14 @@ M:	jason.wessel@windriver.com
 L:	kgdb-bugreport@lists.sourceforge.net
 S:	Maintained
 
+KMEMCHECK
+P:	Vegard Nossum
+M:	vegardno@ifi.uio.no
+P	Pekka Enberg
+M:	penberg@cs.helsinki.fi
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+
 KPROBES
 P:	Ananth N Mavinakayanahalli
 M:	ananth@in.ibm.com
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index acc0271..d55f653 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -245,6 +245,115 @@ config DEFAULT_IO_DELAY_TYPE
 	default IO_DELAY_TYPE_NONE
 endif
 
+menuconfig KMEMCHECK
+	bool "kmemcheck: trap use of uninitialized memory"
+	depends on X86
+	depends on !X86_USE_3DNOW
+	depends on SLUB || (SLAB && !DEBUG_SLAB)
+	depends on !CC_OPTIMIZE_FOR_SIZE
+	depends on !DEBUG_PAGEALLOC
+	select FRAME_POINTER
+	select STACKTRACE
+	default n
+	help
+	  This option enables tracing of dynamically allocated kernel memory
+	  to see if memory is used before it has been given an initial value.
+	  Be aware that this requires half of your memory for bookkeeping and
+	  will insert extra code at *every* read and write to tracked memory
+	  thus slow down the kernel code (but user code is unaffected).
+
+	  The kernel may be started with kmemcheck=0 or kmemcheck=1 to disable
+	  or enable kmemcheck at boot-time. If the kernel is started with
+	  kmemcheck=0, the large memory and CPU overhead is not incurred.
+
+choice
+	prompt "kmemcheck: default mode at boot"
+	depends on KMEMCHECK
+	default KMEMCHECK_ONESHOT_BY_DEFAULT
+	help
+	  This option controls the default behaviour of kmemcheck when the
+	  kernel boots and no kmemcheck= parameter is given.
+
+config KMEMCHECK_DISABLED_BY_DEFAULT
+	bool "disabled"
+	depends on KMEMCHECK
+
+config KMEMCHECK_ENABLED_BY_DEFAULT
+	bool "enabled"
+	depends on KMEMCHECK
+
+config KMEMCHECK_ONESHOT_BY_DEFAULT
+	bool "one-shot"
+	depends on KMEMCHECK
+	help
+	  In one-shot mode, only the first error detected is reported before
+	  kmemcheck is disabled.
+
+endchoice
+
+config KMEMCHECK_USE_SMP
+	bool "kmemcheck: use multiple CPUs"
+	depends on KMEMCHECK
+	depends on SMP
+	depends on BROKEN
+	default n
+	help
+	  This option will prevent kmemcheck from disabling all but one CPU
+	  on boot. This means that whenever a page fault is taken, all the
+	  other CPUs in the system are halted. This is potentially extremely
+	  expensive, depending on the number of CPUs in the system (the more
+	  the worse).
+
+	  The upside is that kmemcheck can be compiled into the kernel with
+	  very little overhead by default if kmemcheck is disabled at run-
+	  time.
+
+	  If you want to compile a kernel specifically for the purpose of
+	  playing with kmemcheck, you should say N here. If you want a normal
+	  kernel with the possibility of enabling kmemcheck without
+	  recompiling, you should say Y here.
+
+config KMEMCHECK_QUEUE_SIZE
+	int "kmemcheck: error queue size"
+	depends on KMEMCHECK
+	default 64
+	help
+	  Select the maximum number of errors to store in the queue. This
+	  queue will be emptied once every second, so this is effectively a
+	  limit on how many reports to print in one go. Note however, that
+	  if the number of errors occuring between two bursts is larger than
+	  this number, the extra error reports will get lost.
+
+config KMEMCHECK_SHADOW_COPY_SHIFT
+	int "kmemcheck: shadow copy size (5 => 32 bytes, 6 => 64 bytes)"
+	depends on KMEMCHECK
+	range 2 8
+	default 6
+	help
+	  Select the number of shadow bytes to save along with each entry of
+	  the queue. These bytes indicate what parts of an allocation are
+	  initialized, uninitialized, etc. and will be displayed when an
+	  error is detected to help the debugging of a particular problem.
+
+config KMEMCHECK_PARTIAL_OK
+	bool "kmemcheck: allow partially uninitialized memory"
+	depends on KMEMCHECK
+	default y
+	help
+	  This option works around certain GCC optimizations that produce
+	  32-bit reads from 16-bit variables where the upper 16 bits are
+	  thrown away afterwards. This may of course also hide some real
+	  bugs.
+
+config KMEMCHECK_BITOPS_OK
+	bool "kmemcheck: allow bit-field manipulation"
+	depends on KMEMCHECK
+	default n
+	help
+	  This option silences warnings that would be generated for bit-field
+	  accesses where not all the bits are initialized at the same time.
+	  This may also hide some real bugs.
+
 config DEBUG_BOOT_PARAMS
 	bool "Debug boot parameters"
 	depends on DEBUG_KERNEL
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 4061d63..1450e0f 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -43,7 +43,7 @@ void arch_task_cache_init(void)
         task_xstate_cachep =
         	kmem_cache_create("task_xstate", xstate_size,
 				  __alignof__(union thread_xstate),
-				  SLAB_PANIC, NULL);
+				  SLAB_PANIC | SLAB_NOTRACK, NULL);
 }
 
 /*
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 9a139f6..adb9d3a 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -151,7 +151,7 @@ void cpu_idle(void)
 	}
 }
 
-void __show_registers(struct pt_regs *regs, int all)
+void __show_regs(struct pt_regs *regs, int all)
 {
 	unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L;
 	unsigned long d0, d1, d2, d3, d6, d7;
@@ -212,7 +212,7 @@ void __show_registers(struct pt_regs *regs, int all)
 
 void show_regs(struct pt_regs *regs)
 {
-	__show_registers(regs, 1);
+	__show_regs(regs, 1);
 	show_trace(NULL, regs, &regs->sp, regs->bp);
 }
 
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index db5eb96..1f7c9ed 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -149,7 +149,7 @@ void cpu_idle(void)
 }
 
 /* Prints also some state that isn't saved in the pt_regs */
-void __show_regs(struct pt_regs * regs)
+void __show_regs(struct pt_regs * regs, int all)
 {
 	unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L, fs, gs, shadowgs;
 	unsigned long d0, d1, d2, d3, d6, d7;
@@ -188,13 +188,17 @@ void __show_regs(struct pt_regs * regs)
 	rdmsrl(MSR_GS_BASE, gs); 
 	rdmsrl(MSR_KERNEL_GS_BASE, shadowgs); 
 
+	printk("FS:  %016lx(%04x) GS:%016lx(%04x) knlGS:%016lx\n",
+	       fs,fsindex,gs,gsindex,shadowgs);
+
+	if (!all)
+		return;
+
 	cr0 = read_cr0();
 	cr2 = read_cr2();
 	cr3 = read_cr3();
 	cr4 = read_cr4();
 
-	printk("FS:  %016lx(%04x) GS:%016lx(%04x) knlGS:%016lx\n", 
-	       fs,fsindex,gs,gsindex,shadowgs); 
 	printk("CS:  %04x DS: %04x ES: %04x CR0: %016lx\n", cs, ds, es, cr0); 
 	printk("CR2: %016lx CR3: %016lx CR4: %016lx\n", cr2, cr3, cr4);
 
@@ -211,7 +215,7 @@ void __show_regs(struct pt_regs * regs)
 void show_regs(struct pt_regs *regs)
 {
 	printk("CPU %d:", smp_processor_id());
-	__show_regs(regs);
+	__show_regs(regs, 1);
 	show_trace(NULL, regs, (void *)(regs + 1), regs->bp);
 }
 
diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index c28c342..97202ad 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -75,6 +75,13 @@ void save_stack_trace(struct stack_trace *trace)
 		trace->entries[trace->nr_entries++] = ULONG_MAX;
 }
 
+void save_stack_trace_bp(struct stack_trace *trace, unsigned long bp)
+{
+	dump_trace(current, NULL, NULL, bp, &save_stack_ops, trace);
+	if (trace->nr_entries < trace->max_entries)
+		trace->entries[trace->nr_entries++] = ULONG_MAX;
+}
+
 void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
 {
 	dump_trace(tsk, NULL, NULL, 0, &save_stack_ops_nosched, trace);
diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 8a76897..188b1a3 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -58,6 +58,7 @@
 #include <asm/nmi.h>
 #include <asm/smp.h>
 #include <asm/io.h>
+#include <asm/kmemcheck.h>
 
 #include "mach_traps.h"
 
@@ -330,7 +331,7 @@ void show_registers(struct pt_regs *regs)
 	int i;
 
 	print_modules();
-	__show_registers(regs, 0);
+	__show_regs(regs, 0);
 
 	printk(KERN_EMERG "Process %.*s (pid: %d, ti=%p task=%p task.ti=%p)",
 		TASK_COMM_LEN, current->comm, task_pid_nr(current),
@@ -908,6 +909,14 @@ void __kprobes do_debug(struct pt_regs *regs, long error_code)
 
 	get_debugreg(condition, 6);
 
+	/* Catch kmemcheck conditions first of all! */
+	if (condition & DR_STEP) {
+		if (kmemcheck_active(regs)) {
+			kmemcheck_hide(regs);
+			return;
+		}
+	}
+
 	/*
 	 * The processor cleared BTF, so don't mark that we need it set.
 	 */
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 74e9929..22c85a2 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -48,6 +48,7 @@
 #include <asm/nmi.h>
 #include <asm/smp.h>
 #include <asm/io.h>
+#include <asm/kmemcheck.h>
 #include <asm/pgalloc.h>
 #include <asm/proto.h>
 #include <asm/pda.h>
@@ -462,7 +463,7 @@ void show_registers(struct pt_regs *regs)
 
 	sp = regs->sp;
 	printk("CPU %d ", cpu);
-	__show_regs(regs);
+	__show_regs(regs, 1);
 	printk("Process %s (pid: %d, threadinfo %p, task %p)\n",
 		cur->comm, cur->pid, task_thread_info(cur), cur);
 
@@ -937,6 +938,14 @@ asmlinkage void __kprobes do_debug(struct pt_regs * regs,
 
 	get_debugreg(condition, 6);
 
+	/* Catch kmemcheck conditions first of all! */
+	if (condition & DR_STEP) {
+		if (kmemcheck_active(regs)) {
+			kmemcheck_hide(regs);
+			return;
+		}
+	}
+
 	/*
 	 * The processor cleared BTF, so don't mark that we need it set.
 	 */
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index c107641..c872826 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -8,6 +8,8 @@ obj-$(CONFIG_X86_PTDUMP)	+= dump_pagetables.o
 
 obj-$(CONFIG_HIGHMEM)		+= highmem_32.o
 
+obj-$(CONFIG_KMEMCHECK)		+= kmemcheck/
+
 ifeq ($(CONFIG_X86_32),y)
 obj-$(CONFIG_NUMA)		+= discontig_32.o
 else
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index d0f5fce..c1ce230 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -33,6 +33,7 @@
 #include <asm/smp.h>
 #include <asm/tlbflush.h>
 #include <asm/proto.h>
+#include <asm/kmemcheck.h>
 #include <asm-generic/sections.h>
 
 /*
@@ -596,6 +597,13 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 
 	si_code = SEGV_MAPERR;
 
+	/*
+	 * Detect and handle instructions that would cause a page fault for
+	 * both a tracked kernel page and a userspace page.
+	 */
+	if(kmemcheck_active(regs))
+		kmemcheck_hide(regs);
+
 	if (notify_page_fault(regs))
 		return;
 
@@ -617,9 +625,13 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 #else
 	if (unlikely(address >= TASK_SIZE64)) {
 #endif
-		if (!(error_code & (PF_RSVD|PF_USER|PF_PROT)) &&
-		    vmalloc_fault(address) >= 0)
-			return;
+		if (!(error_code & (PF_RSVD | PF_USER | PF_PROT))) {
+			if (vmalloc_fault(address) >= 0)
+				return;
+
+			if (kmemcheck_fault(regs, address, error_code))
+				return;
+		}
 
 		/* Can handle a stale RO->RW TLB */
 		if (spurious_fault(address, error_code))
diff --git a/arch/x86/mm/kmemcheck/Makefile b/arch/x86/mm/kmemcheck/Makefile
new file mode 100644
index 0000000..f888b5c
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/Makefile
@@ -0,0 +1,3 @@
+obj-y := error.o kmemcheck.o opcode.o pte.o shadow.o string.o
+
+obj-$(CONFIG_KMEMCHECK_USE_SMP) += smp.o
diff --git a/arch/x86/mm/kmemcheck/error.c b/arch/x86/mm/kmemcheck/error.c
new file mode 100644
index 0000000..56410c6
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/error.c
@@ -0,0 +1,216 @@
+#include <linux/interrupt.h>
+#include <linux/kdebug.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/ptrace.h>
+#include <linux/stacktrace.h>
+#include <linux/string.h>
+
+#include "error.h"
+#include "shadow.h"
+
+enum kmemcheck_error_type {
+	KMEMCHECK_ERROR_INVALID_ACCESS,
+	KMEMCHECK_ERROR_BUG,
+};
+
+#define SHADOW_COPY_SIZE (1 << CONFIG_KMEMCHECK_SHADOW_COPY_SHIFT)
+
+struct kmemcheck_error {
+	enum kmemcheck_error_type type;
+
+	union {
+		/* KMEMCHECK_ERROR_INVALID_ACCESS */
+		struct {
+			/* Kind of access that caused the error */
+			enum kmemcheck_shadow state;
+			/* Address and size of the erroneous read */
+			unsigned long	address;
+			unsigned int	size;
+		};
+	};
+
+	struct pt_regs		regs;
+	struct stack_trace	trace;
+	unsigned long		trace_entries[32];
+
+	/* We compress it to a char. */
+	unsigned char		shadow_copy[SHADOW_COPY_SIZE];
+};
+
+/*
+ * Create a ring queue of errors to output. We can't call printk() directly
+ * from the kmemcheck traps, since this may call the console drivers and
+ * result in a recursive fault.
+ */
+static struct kmemcheck_error error_fifo[CONFIG_KMEMCHECK_QUEUE_SIZE];
+static unsigned int error_count;
+static unsigned int error_rd;
+static unsigned int error_wr;
+static unsigned int error_missed_count;
+
+static struct kmemcheck_error *error_next_wr(void)
+{
+	struct kmemcheck_error *e;
+
+	if (error_count == ARRAY_SIZE(error_fifo)) {
+		++error_missed_count;
+		return NULL;
+	}
+
+	e = &error_fifo[error_wr];
+	if (++error_wr == ARRAY_SIZE(error_fifo))
+		error_wr = 0;
+	++error_count;
+	return e;
+}
+
+static struct kmemcheck_error *error_next_rd(void)
+{
+	struct kmemcheck_error *e;
+
+	if (error_count == 0)
+		return NULL;
+
+	e = &error_fifo[error_rd];
+	if (++error_rd == ARRAY_SIZE(error_fifo))
+		error_rd = 0;
+	--error_count;
+	return e;
+}
+
+static void do_wakeup(unsigned long);
+static DECLARE_TASKLET(kmemcheck_tasklet, &do_wakeup, 0);
+
+/*
+ * Save the context of an error report.
+ */
+void kmemcheck_error_save(enum kmemcheck_shadow state,
+	unsigned long address, unsigned int size, struct pt_regs *regs)
+{
+	static unsigned long prev_ip;
+
+	struct kmemcheck_error *e;
+	enum shadow *shadow_copy;
+
+	/* Don't report several adjacent errors from the same EIP. */
+	if (regs->ip == prev_ip)
+		return;
+	prev_ip = regs->ip;
+
+	e = error_next_wr();
+	if (!e)
+		return;
+
+	e->type = KMEMCHECK_ERROR_INVALID_ACCESS;
+
+	e->state = state;
+	e->address = address;
+	e->size = size;
+
+	/* Save regs */
+	memcpy(&e->regs, regs, sizeof(*regs));
+
+	/* Save stack trace */
+	e->trace.nr_entries = 0;
+	e->trace.entries = e->trace_entries;
+	e->trace.max_entries = ARRAY_SIZE(e->trace_entries);
+	e->trace.skip = 0;
+	save_stack_trace_bp(&e->trace, regs->bp);
+
+	/* Round address down to nearest 16 bytes */
+	shadow_copy = kmemcheck_shadow_lookup(address
+		& ~(SHADOW_COPY_SIZE - 1));
+	BUG_ON(!shadow_copy);
+
+	memcpy(e->shadow_copy, shadow_copy, SHADOW_COPY_SIZE);
+
+	tasklet_hi_schedule_first(&kmemcheck_tasklet);
+}
+
+/*
+ * Save the context of a kmemcheck bug.
+ */
+void kmemcheck_error_save_bug(struct pt_regs *regs)
+{
+	struct kmemcheck_error *e;
+
+	e = error_next_wr();
+	if (!e)
+		return;
+
+	e->type = KMEMCHECK_ERROR_BUG;
+
+	memcpy(&e->regs, regs, sizeof(*regs));
+
+	e->trace.nr_entries = 0;
+	e->trace.entries = e->trace_entries;
+	e->trace.max_entries = ARRAY_SIZE(e->trace_entries);
+	e->trace.skip = 1;
+	save_stack_trace(&e->trace);
+
+	tasklet_hi_schedule_first(&kmemcheck_tasklet);
+}
+
+void kmemcheck_error_recall(void)
+{
+	static const char *desc[] = {
+		[KMEMCHECK_SHADOW_UNALLOCATED]		= "unallocated",
+		[KMEMCHECK_SHADOW_UNINITIALIZED]	= "uninitialized",
+		[KMEMCHECK_SHADOW_INITIALIZED]		= "initialized",
+		[KMEMCHECK_SHADOW_FREED]		= "freed",
+	};
+
+	static const char short_desc[] = {
+		[KMEMCHECK_SHADOW_UNALLOCATED]		= 'a',
+		[KMEMCHECK_SHADOW_UNINITIALIZED]	= 'u',
+		[KMEMCHECK_SHADOW_INITIALIZED]		= 'i',
+		[KMEMCHECK_SHADOW_FREED]		= 'f',
+	};
+
+	struct kmemcheck_error *e;
+	unsigned int i;
+
+	e = error_next_rd();
+	if (!e)
+		return;
+
+	switch (e->type) {
+	case KMEMCHECK_ERROR_INVALID_ACCESS:
+		printk(KERN_ERR  "kmemcheck: Caught %d-bit read "
+			"from %s memory (%p)\n",
+			e->size, e->state < ARRAY_SIZE(desc) ?
+				desc[e->state] : "(invalid shadow state)",
+			(void *) e->address);
+
+		printk(KERN_INFO);
+		for (i = 0; i < SHADOW_COPY_SIZE; ++i) {
+			if (e->shadow_copy[i] < ARRAY_SIZE(short_desc))
+				printk("%c", short_desc[e->shadow_copy[i]]);
+			else
+				printk("?");
+		}
+		printk("\n");
+		printk(KERN_INFO "%*c\n",
+			1 + (int) (e->address & (SHADOW_COPY_SIZE - 1)), '^');
+		break;
+	case KMEMCHECK_ERROR_BUG:
+		printk(KERN_EMERG "kmemcheck: Fatal error\n");
+		break;
+	}
+
+	__show_regs(&e->regs, 1);
+	print_stack_trace(&e->trace, 0);
+}
+
+static void do_wakeup(unsigned long data)
+{
+	while (error_count > 0)
+		kmemcheck_error_recall();
+
+	if (error_missed_count > 0) {
+		printk(KERN_WARNING "kmemcheck: Lost %d error reports because "
+			"the queue was too small\n", error_missed_count);
+		error_missed_count = 0;
+	}
+}
diff --git a/arch/x86/mm/kmemcheck/error.h b/arch/x86/mm/kmemcheck/error.h
new file mode 100644
index 0000000..0efc2e8
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/error.h
@@ -0,0 +1,15 @@
+#ifndef ARCH__X86__MM__KMEMCHECK__ERROR_H
+#define ARCH__X86__MM__KMEMCHECK__ERROR_H
+
+#include <linux/ptrace.h>
+
+#include "shadow.h"
+
+void kmemcheck_error_save(enum kmemcheck_shadow state,
+	unsigned long address, unsigned int size, struct pt_regs *regs);
+
+void kmemcheck_error_save_bug(struct pt_regs *regs);
+
+void kmemcheck_error_recall(void);
+
+#endif
diff --git a/arch/x86/mm/kmemcheck/kmemcheck.c b/arch/x86/mm/kmemcheck/kmemcheck.c
new file mode 100644
index 0000000..37949c3
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/kmemcheck.c
@@ -0,0 +1,485 @@
+/**
+ * kmemcheck - a heavyweight memory checker for the linux kernel
+ * Copyright (C) 2007, 2008  Vegard Nossum <vegardno@ifi.uio.no>
+ * (With a lot of help from Ingo Molnar and Pekka Enberg.)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (version 2) as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/kallsyms.h>
+#include <linux/kernel.h>
+#include <linux/kmemcheck.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/page-flags.h>
+#include <linux/percpu.h>
+#include <linux/ptrace.h>
+#include <linux/string.h>
+#include <linux/types.h>
+
+#include <asm/cacheflush.h>
+#include <asm/kmemcheck.h>
+#include <asm/pgtable.h>
+#include <asm/tlbflush.h>
+
+#include "error.h"
+#include "opcode.h"
+#include "pte.h"
+#include "shadow.h"
+#include "smp.h"
+
+void __init kmemcheck_init(void)
+{
+	printk(KERN_INFO "kmemcheck: \"Bugs, beware!\"\n");
+
+	kmemcheck_smp_init();
+
+#if defined(CONFIG_SMP) && !defined(CONFIG_KMEMCHECK_USE_SMP)
+	/*
+	 * Limit SMP to use a single CPU. We rely on the fact that this code
+	 * runs before SMP is set up.
+	 */
+	if (setup_max_cpus > 1) {
+		printk(KERN_INFO
+			"kmemcheck: Limiting number of CPUs to 1.\n");
+		setup_max_cpus = 1;
+	}
+#endif
+}
+
+#ifdef CONFIG_KMEMCHECK_DISABLED_BY_DEFAULT
+int kmemcheck_enabled = 0;
+#endif
+
+#ifdef CONFIG_KMEMCHECK_ENABLED_BY_DEFAULT
+int kmemcheck_enabled = 1;
+#endif
+
+#ifdef CONFIG_KMEMCHECK_ONESHOT_BY_DEFAULT
+int kmemcheck_enabled = 2;
+#endif
+
+/*
+ * We need to parse the kmemcheck= option before any memory is allocated.
+ */
+static int __init param_kmemcheck(char *str)
+{
+	if (!str)
+		return -EINVAL;
+
+	sscanf(str, "%d", &kmemcheck_enabled);
+	return 0;
+}
+
+early_param("kmemcheck", param_kmemcheck);
+
+int kmemcheck_show_addr(unsigned long address)
+{
+	pte_t *pte;
+
+	pte = kmemcheck_pte_lookup(address);
+	if (!pte)
+		return 0;
+
+	set_pte(pte, __pte(pte_val(*pte) | _PAGE_PRESENT));
+	__flush_tlb_one(address);
+	return 1;
+}
+
+int kmemcheck_hide_addr(unsigned long address)
+{
+	pte_t *pte;
+
+	pte = kmemcheck_pte_lookup(address);
+	if (!pte)
+		return 0;
+
+	set_pte(pte, __pte(pte_val(*pte) & ~_PAGE_PRESENT));
+	__flush_tlb_one(address);
+	return 1;
+}
+
+struct kmemcheck_context {
+	bool busy;
+	int balance;
+
+	unsigned long addr1;
+	unsigned long addr2;
+	unsigned long flags;
+};
+
+static DEFINE_PER_CPU(struct kmemcheck_context, kmemcheck_context);
+
+bool kmemcheck_active(struct pt_regs *regs)
+{
+	struct kmemcheck_context *data = &__get_cpu_var(kmemcheck_context);
+
+	return data->balance > 0;
+}
+
+/*
+ * Called from the #PF handler.
+ */
+void kmemcheck_show(struct pt_regs *regs)
+{
+	struct kmemcheck_context *data = &__get_cpu_var(kmemcheck_context);
+	int n;
+
+	BUG_ON(!irqs_disabled());
+
+	kmemcheck_pause_allbutself();
+
+	if (unlikely(data->balance != 0)) {
+		kmemcheck_show_addr(data->addr1);
+		kmemcheck_show_addr(data->addr2);
+		kmemcheck_error_save_bug(regs);
+		data->balance = 0;
+		kmemcheck_resume();
+		return;
+	}
+
+	n = 0;
+	n += kmemcheck_show_addr(data->addr1);
+	n += kmemcheck_show_addr(data->addr2);
+
+	/*
+	 * None of the addresses actually belonged to kmemcheck. Note that
+	 * this is not an error.
+	 */
+	if (n == 0) {
+		kmemcheck_resume();
+		return;
+	}
+
+	++data->balance;
+
+	/*
+	 * The IF needs to be cleared as well, so that the faulting
+	 * instruction can run "uninterrupted". Otherwise, we might take
+	 * an interrupt and start executing that before we've had a chance
+	 * to hide the page again.
+	 *
+	 * NOTE: In the rare case of multiple faults, we must not override
+	 * the original flags:
+	 */
+	if (!(regs->flags & X86_EFLAGS_TF))
+		data->flags = regs->flags;
+
+	regs->flags |= X86_EFLAGS_TF;
+	regs->flags &= ~X86_EFLAGS_IF;
+}
+
+/*
+ * Called from the #DB handler.
+ */
+void kmemcheck_hide(struct pt_regs *regs)
+{
+	struct kmemcheck_context *data = &__get_cpu_var(kmemcheck_context);
+	int n;
+
+	BUG_ON(!irqs_disabled());
+
+	if (data->balance == 0) {
+		kmemcheck_resume();
+		return;
+	}
+
+	if (unlikely(data->balance != 1)) {
+		kmemcheck_show_addr(data->addr1);
+		kmemcheck_show_addr(data->addr2);
+		kmemcheck_error_save_bug(regs);
+		data->addr1 = 0;
+		data->addr2 = 0;
+		data->balance = 0;
+
+		if (!(data->flags & X86_EFLAGS_TF))
+			regs->flags &= ~X86_EFLAGS_TF;
+		if (data->flags & X86_EFLAGS_IF)
+			regs->flags |= X86_EFLAGS_IF;
+		kmemcheck_resume();
+		return;
+	}
+
+	n = 0;
+	if (kmemcheck_enabled) {
+		n += kmemcheck_hide_addr(data->addr1);
+		n += kmemcheck_hide_addr(data->addr2);
+	} else {
+		n += kmemcheck_show_addr(data->addr1);
+		n += kmemcheck_show_addr(data->addr2);
+	}
+
+	if (n == 0) {
+		kmemcheck_resume();
+		return;
+	}
+
+	--data->balance;
+
+	data->addr1 = 0;
+	data->addr2 = 0;
+
+	if (!(data->flags & X86_EFLAGS_TF))
+		regs->flags &= ~X86_EFLAGS_TF;
+	if (data->flags & X86_EFLAGS_IF)
+		regs->flags |= X86_EFLAGS_IF;
+	kmemcheck_resume();
+}
+
+void kmemcheck_show_pages(struct page *p, unsigned int n)
+{
+	unsigned int i;
+
+	for (i = 0; i < n; ++i) {
+		unsigned long address;
+		pte_t *pte;
+		unsigned int level;
+
+		address = (unsigned long) page_address(&p[i]);
+		pte = lookup_address(address, &level);
+		BUG_ON(!pte);
+		BUG_ON(level != PG_LEVEL_4K);
+
+		set_pte(pte, __pte(pte_val(*pte) | _PAGE_PRESENT));
+		set_pte(pte, __pte(pte_val(*pte) & ~_PAGE_HIDDEN));
+		__flush_tlb_one(address);
+	}
+}
+
+bool kmemcheck_page_is_tracked(struct page *p)
+{
+	/* This will also check the "hidden" flag of the PTE. */
+	return kmemcheck_pte_lookup((unsigned long) page_address(p));
+}
+
+void kmemcheck_hide_pages(struct page *p, unsigned int n)
+{
+	unsigned int i;
+
+	set_memory_4k((unsigned long) page_address(p), n);
+
+	for (i = 0; i < n; ++i) {
+		unsigned long address;
+		pte_t *pte;
+		unsigned int level;
+
+		address = (unsigned long) page_address(&p[i]);
+		pte = lookup_address(address, &level);
+		BUG_ON(!pte);
+		BUG_ON(level != PG_LEVEL_4K);
+
+		set_pte(pte, __pte(pte_val(*pte) & ~_PAGE_PRESENT));
+		set_pte(pte, __pte(pte_val(*pte) | _PAGE_HIDDEN));
+		__flush_tlb_one(address);
+	}
+}
+
+/*
+ * Check that an access does not span across two different pages, because
+ * that will mess up our shadow lookup.
+ */
+static bool check_page_boundary(struct pt_regs *regs,
+	unsigned long addr, unsigned int size)
+{
+	if (size == 8)
+		return false;
+	if (size == 16 && (addr & PAGE_MASK) == ((addr + 1) & PAGE_MASK))
+		return false;
+	if (size == 32 && (addr & PAGE_MASK) == ((addr + 3) & PAGE_MASK))
+		return false;
+#ifdef CONFIG_X86_64
+	if (size == 64 && (addr & PAGE_MASK) == ((addr + 7) & PAGE_MASK))
+		return false;
+#endif
+
+	/*
+	 * XXX: The addr/size data is also really interesting if this
+	 * case ever triggers. We should make a separate class of errors
+	 * for this case. -Vegard
+	 */
+	kmemcheck_error_save_bug(regs);
+	return true;
+}
+
+static void kmemcheck_read(struct pt_regs *regs,
+	unsigned long address, unsigned int size)
+{
+	void *shadow;
+	enum kmemcheck_shadow status;
+
+	shadow = kmemcheck_shadow_lookup(address);
+	if (!shadow)
+		return;
+
+	if (check_page_boundary(regs, address, size))
+		return;
+
+	status = kmemcheck_shadow_test(shadow, size);
+	if (status == KMEMCHECK_SHADOW_INITIALIZED)
+		return;
+
+	if (kmemcheck_enabled)
+		kmemcheck_error_save(status, address, size, regs);
+
+	if (kmemcheck_enabled == 2)
+		kmemcheck_enabled = 0;
+
+	/* Don't warn about it again. */
+	kmemcheck_shadow_set(shadow, size);
+}
+
+static void kmemcheck_write(struct pt_regs *regs,
+	unsigned long address, unsigned int size)
+{
+	void *shadow;
+
+	shadow = kmemcheck_shadow_lookup(address);
+	if (!shadow)
+		return;
+
+	if (check_page_boundary(regs, address, size))
+		return;
+
+	kmemcheck_shadow_set(shadow, size);
+}
+
+enum kmemcheck_method {
+	KMEMCHECK_READ,
+	KMEMCHECK_WRITE,
+};
+
+static void kmemcheck_access(struct pt_regs *regs,
+	unsigned long fallback_address, enum kmemcheck_method fallback_method)
+{
+	const uint8_t *insn;
+	const uint8_t *insn_primary;
+	unsigned int size;
+
+	struct kmemcheck_context *data = &__get_cpu_var(kmemcheck_context);
+
+	/* Recursive fault -- ouch. */
+	if (data->busy) {
+		kmemcheck_show_addr(fallback_address);
+		kmemcheck_error_save_bug(regs);
+		return;
+	}
+
+	data->busy = true;
+
+	insn = (const uint8_t *) regs->ip;
+	insn_primary = kmemcheck_opcode_get_primary(insn);
+
+	size = kmemcheck_opcode_get_size(insn);
+
+	switch (insn_primary[0]) {
+#ifdef CONFIG_KMEMCHECK_BITOPS_OK
+		/* AND, OR, XOR */
+		/*
+		 * Unfortunately, these instructions have to be excluded from
+		 * our regular checking since they access only some (and not
+		 * all) bits. This clears out "bogus" bitfield-access warnings.
+		 */
+	case 0x80:
+	case 0x81:
+	case 0x82:
+	case 0x83:
+		switch ((insn_primary[1] >> 3) & 7) {
+			/* OR */
+		case 1:
+			/* AND */
+		case 4:
+			/* XOR */
+		case 6:
+			kmemcheck_write(regs, fallback_address, size);
+			data->addr1 = fallback_address;
+			data->addr2 = 0;
+			data->busy = false;
+			return;
+
+			/* ADD */
+		case 0:
+			/* ADC */
+		case 2:
+			/* SBB */
+		case 3:
+			/* SUB */
+		case 5:
+			/* CMP */
+		case 7:
+			break;
+		}
+		break;
+#endif
+
+		/* MOVS, MOVSB, MOVSW, MOVSD */
+	case 0xa4:
+	case 0xa5:
+		/*
+		 * These instructions are special because they take two
+		 * addresses, but we only get one page fault.
+		 */
+		kmemcheck_read(regs, regs->si, size);
+		kmemcheck_write(regs, regs->di, size);
+		data->addr1 = regs->si;
+		data->addr2 = regs->di;
+		data->busy = false;
+		return;
+
+		/* CMPS, CMPSB, CMPSW, CMPSD */
+	case 0xa6:
+	case 0xa7:
+		kmemcheck_read(regs, regs->si, size);
+		kmemcheck_read(regs, regs->di, size);
+		data->addr1 = regs->si;
+		data->addr2 = regs->di;
+		data->busy = false;
+		return;
+	}
+
+	/*
+	 * If the opcode isn't special in any way, we use the data from the
+	 * page fault handler to determine the address and type of memory
+	 * access.
+	 */
+	switch (fallback_method) {
+	case KMEMCHECK_READ:
+		kmemcheck_read(regs, fallback_address, size);
+		data->addr1 = fallback_address;
+		data->addr2 = 0;
+		data->busy = false;
+		return;
+	case KMEMCHECK_WRITE:
+		kmemcheck_write(regs, fallback_address, size);
+		data->addr1 = fallback_address;
+		data->addr2 = 0;
+		data->busy = false;
+		return;
+	}
+}
+
+bool kmemcheck_fault(struct pt_regs *regs, unsigned long address,
+	unsigned long error_code)
+{
+	pte_t *pte;
+	unsigned int level;
+
+	pte = lookup_address(address, &level);
+	if (!pte)
+		return false;
+	if (level != PG_LEVEL_4K)
+		return false;
+	if (!pte_hidden(*pte))
+		return false;
+
+	if (error_code & 2)
+		kmemcheck_access(regs, address, KMEMCHECK_WRITE);
+	else
+		kmemcheck_access(regs, address, KMEMCHECK_READ);
+
+	kmemcheck_show(regs);
+	return true;
+}
diff --git a/arch/x86/mm/kmemcheck/opcode.c b/arch/x86/mm/kmemcheck/opcode.c
new file mode 100644
index 0000000..194aeee
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/opcode.c
@@ -0,0 +1,72 @@
+#include <linux/types.h>
+
+#include "opcode.h"
+
+static bool opcode_is_prefix(uint8_t b)
+{
+	return
+		/* Group 1 */
+		b == 0xf0 || b == 0xf2 || b == 0xf3
+		/* Group 2 */
+		|| b == 0x2e || b == 0x36 || b == 0x3e || b == 0x26
+		|| b == 0x64 || b == 0x65 || b == 0x2e || b == 0x3e
+		/* Group 3 */
+		|| b == 0x66
+		/* Group 4 */
+		|| b == 0x67;
+}
+
+static bool opcode_is_rex_prefix(uint8_t b)
+{
+	return (b & 0xf0) == 0x40;
+}
+
+/*
+ * This is a VERY crude opcode decoder. We only need to find the size of the
+ * load/store that caused our #PF and this should work for all the opcodes
+ * that we care about. Moreover, the ones who invented this instruction set
+ * should be shot.
+ */
+unsigned int kmemcheck_opcode_get_size(const uint8_t *op)
+{
+	/* Default operand size */
+	int operand_size_override = 32;
+
+	/* prefixes */
+	for (; opcode_is_prefix(*op); ++op) {
+		if (*op == 0x66)
+			operand_size_override = 16;
+	}
+
+#ifdef CONFIG_X86_64
+	/* REX prefix */
+	if (opcode_is_rex_prefix(*op)) {
+		if (*op & 0x08)
+			return 64;
+		++op;
+	}
+#endif
+
+	/* escape opcode */
+	if (*op == 0x0f) {
+		++op;
+
+		if (*op == 0xb6)
+			return 8;
+		if (*op == 0xb7)
+			return 16;
+	}
+
+	return (*op & 1) ? operand_size_override : 8;
+}
+
+const uint8_t *kmemcheck_opcode_get_primary(const uint8_t *op)
+{
+	/* skip prefixes */
+	while (opcode_is_prefix(*op))
+		++op;
+	if (opcode_is_rex_prefix(*op))
+		++op;
+	return op;
+}
+
diff --git a/arch/x86/mm/kmemcheck/opcode.h b/arch/x86/mm/kmemcheck/opcode.h
new file mode 100644
index 0000000..a19b8fa
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/opcode.h
@@ -0,0 +1,9 @@
+#ifndef ARCH__X86__MM__KMEMCHECK__OPCODE_H
+#define ARCH__X86__MM__KMEMCHECK__OPCODE_H
+
+#include <linux/types.h>
+
+unsigned int kmemcheck_opcode_get_size(const uint8_t *op);
+const uint8_t *kmemcheck_opcode_get_primary(const uint8_t *op);
+
+#endif
diff --git a/arch/x86/mm/kmemcheck/pte.c b/arch/x86/mm/kmemcheck/pte.c
new file mode 100644
index 0000000..4ead26e
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/pte.c
@@ -0,0 +1,22 @@
+#include <linux/mm.h>
+
+#include <asm/pgtable.h>
+
+#include "pte.h"
+
+pte_t *kmemcheck_pte_lookup(unsigned long address)
+{
+	pte_t *pte;
+	unsigned int level;
+
+	pte = lookup_address(address, &level);
+	if (!pte)
+		return NULL;
+	if (level != PG_LEVEL_4K)
+		return NULL;
+	if (!pte_hidden(*pte))
+		return NULL;
+
+	return pte;
+}
+
diff --git a/arch/x86/mm/kmemcheck/pte.h b/arch/x86/mm/kmemcheck/pte.h
new file mode 100644
index 0000000..9f59664
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/pte.h
@@ -0,0 +1,10 @@
+#ifndef ARCH__X86__MM__KMEMCHECK__PTE_H
+#define ARCH__X86__MM__KMEMCHECK__PTE_H
+
+#include <linux/mm.h>
+
+#include <asm/pgtable.h>
+
+pte_t *kmemcheck_pte_lookup(unsigned long address);
+
+#endif
diff --git a/arch/x86/mm/kmemcheck/shadow.c b/arch/x86/mm/kmemcheck/shadow.c
new file mode 100644
index 0000000..0cb144f
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/shadow.c
@@ -0,0 +1,175 @@
+#include <linux/kmemcheck.h>
+#include <linux/mm.h>
+
+#include <asm/page.h>
+#include <asm/pgtable.h>
+
+#include "pte.h"
+#include "shadow.h"
+
+/*
+ * Return the shadow address for the given address. Returns NULL if the
+ * address is not tracked.
+ *
+ * We need to be extremely careful not to follow any invalid pointers,
+ * because this function can be called for *any* possible address.
+ */
+void *kmemcheck_shadow_lookup(unsigned long address)
+{
+	pte_t *pte;
+	struct page *page;
+
+	if (!virt_addr_valid(address))
+		return NULL;
+
+	pte = kmemcheck_pte_lookup(address);
+	if (!pte)
+		return NULL;
+
+	page = virt_to_page(address);
+	if (!page->shadow)
+		return NULL;
+	return page->shadow + (address & (PAGE_SIZE - 1));
+}
+
+static void mark_shadow(void *address, unsigned int n,
+	enum kmemcheck_shadow status)
+{
+	void *shadow;
+
+	shadow = kmemcheck_shadow_lookup((unsigned long) address);
+	if (!shadow)
+		return;
+	__memset(shadow, status, n);
+}
+
+void kmemcheck_mark_unallocated(void *address, unsigned int n)
+{
+	mark_shadow(address, n, KMEMCHECK_SHADOW_UNALLOCATED);
+}
+
+void kmemcheck_mark_uninitialized(void *address, unsigned int n)
+{
+	mark_shadow(address, n, KMEMCHECK_SHADOW_UNINITIALIZED);
+}
+
+/*
+ * Fill the shadow memory of the given address such that the memory at that
+ * address is marked as being initialized.
+ */
+void kmemcheck_mark_initialized(void *address, unsigned int n)
+{
+	mark_shadow(address, n, KMEMCHECK_SHADOW_INITIALIZED);
+}
+
+void kmemcheck_mark_freed(void *address, unsigned int n)
+{
+	mark_shadow(address, n, KMEMCHECK_SHADOW_FREED);
+}
+
+void kmemcheck_mark_unallocated_pages(struct page *p, unsigned int n)
+{
+	unsigned int i;
+
+	for (i = 0; i < n; ++i)
+		kmemcheck_mark_unallocated(page_address(&p[i]), PAGE_SIZE);
+}
+
+void kmemcheck_mark_uninitialized_pages(struct page *p, unsigned int n)
+{
+	unsigned int i;
+
+	for (i = 0; i < n; ++i)
+		kmemcheck_mark_uninitialized(page_address(&p[i]), PAGE_SIZE);
+}
+
+enum kmemcheck_shadow kmemcheck_shadow_test(void *shadow, unsigned int size)
+{
+	uint8_t *x;
+
+	x = shadow;
+
+#ifdef CONFIG_KMEMCHECK_PARTIAL_OK
+	/*
+	 * Make sure _some_ bytes are initialized. Gcc frequently generates
+	 * code to access neighboring bytes.
+	 */
+	switch (size) {
+#ifdef CONFIG_X86_64
+	case 64:
+		if (x[7] == KMEMCHECK_SHADOW_INITIALIZED)
+			return x[7];
+		if (x[6] == KMEMCHECK_SHADOW_INITIALIZED)
+			return x[6];
+		if (x[5] == KMEMCHECK_SHADOW_INITIALIZED)
+			return x[5];
+		if (x[4] == KMEMCHECK_SHADOW_INITIALIZED)
+			return x[4];
+#endif
+	case 32:
+		if (x[3] == KMEMCHECK_SHADOW_INITIALIZED)
+			return x[3];
+		if (x[2] == KMEMCHECK_SHADOW_INITIALIZED)
+			return x[2];
+	case 16:
+		if (x[1] == KMEMCHECK_SHADOW_INITIALIZED)
+			return x[1];
+	case 8:
+		if (x[0] == KMEMCHECK_SHADOW_INITIALIZED)
+			return x[0];
+	}
+#else
+	switch (size) {
+#ifdef CONFIG_X86_64
+	case 64:
+		if (x[7] != KMEMCHECK_SHADOW_INITIALIZED)
+			return x[7];
+		if (x[6] != KMEMCHECK_SHADOW_INITIALIZED)
+			return x[6];
+		if (x[5] != KMEMCHECK_SHADOW_INITIALIZED)
+			return x[5];
+		if (x[4] != KMEMCHECK_SHADOW_INITIALIZED)
+			return x[4];
+#endif
+	case 32:
+		if (x[3] != KMEMCHECK_SHADOW_INITIALIZED)
+			return x[3];
+		if (x[2] != KMEMCHECK_SHADOW_INITIALIZED)
+			return x[2];
+	case 16:
+		if (x[1] != KMEMCHECK_SHADOW_INITIALIZED)
+			return x[1];
+	case 8:
+		if (x[0] != KMEMCHECK_SHADOW_INITIALIZED)
+			return x[0];
+	}
+#endif
+
+	return x[0];
+}
+
+void kmemcheck_shadow_set(void *shadow, unsigned int size)
+{
+	uint8_t *x;
+
+	x = shadow;
+
+	switch (size) {
+#ifdef CONFIG_X86_64
+	case 64:
+		x[7] = KMEMCHECK_SHADOW_INITIALIZED;
+		x[6] = KMEMCHECK_SHADOW_INITIALIZED;
+		x[5] = KMEMCHECK_SHADOW_INITIALIZED;
+		x[4] = KMEMCHECK_SHADOW_INITIALIZED;
+#endif
+	case 32:
+		x[3] = KMEMCHECK_SHADOW_INITIALIZED;
+		x[2] = KMEMCHECK_SHADOW_INITIALIZED;
+	case 16:
+		x[1] = KMEMCHECK_SHADOW_INITIALIZED;
+	case 8:
+		x[0] = KMEMCHECK_SHADOW_INITIALIZED;
+	}
+
+	return;
+}
diff --git a/arch/x86/mm/kmemcheck/shadow.h b/arch/x86/mm/kmemcheck/shadow.h
new file mode 100644
index 0000000..af46d9a
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/shadow.h
@@ -0,0 +1,16 @@
+#ifndef ARCH__X86__MM__KMEMCHECK__SHADOW_H
+#define ARCH__X86__MM__KMEMCHECK__SHADOW_H
+
+enum kmemcheck_shadow {
+	KMEMCHECK_SHADOW_UNALLOCATED,
+	KMEMCHECK_SHADOW_UNINITIALIZED,
+	KMEMCHECK_SHADOW_INITIALIZED,
+	KMEMCHECK_SHADOW_FREED,
+};
+
+void *kmemcheck_shadow_lookup(unsigned long address);
+
+enum kmemcheck_shadow kmemcheck_shadow_test(void *shadow, unsigned int size);
+void kmemcheck_shadow_set(void *shadow, unsigned int size);
+
+#endif
diff --git a/arch/x86/mm/kmemcheck/smp.c b/arch/x86/mm/kmemcheck/smp.c
new file mode 100644
index 0000000..62b6049
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/smp.c
@@ -0,0 +1,80 @@
+#include <linux/kdebug.h>
+#include <linux/notifier.h>
+#include <linux/smp.h>
+
+#include <mach_ipi.h>
+
+#include "smp.h"
+#include <asm/irq_vectors.h>
+
+static DEFINE_SPINLOCK(nmi_spinlock);
+
+static atomic_t nmi_wait;
+static atomic_t nmi_resume;
+static atomic_t paused;
+
+static int nmi_notifier(struct notifier_block *self,
+	unsigned long val, void *data)
+{
+	if (val != DIE_NMI_IPI || !atomic_read(&nmi_wait))
+		return NOTIFY_DONE;
+
+	atomic_inc(&paused);
+
+	/* Pause until the fault has been handled */
+	while (!atomic_read(&nmi_resume))
+		cpu_relax();
+
+	atomic_dec(&paused);
+
+	return NOTIFY_STOP;
+}
+
+static struct notifier_block nmi_nb = {
+	.notifier_call = &nmi_notifier,
+};
+
+void kmemcheck_smp_init(void)
+{
+	int err;
+
+	err = register_die_notifier(&nmi_nb);
+	BUG_ON(err);
+}
+
+void kmemcheck_pause_allbutself(void)
+{
+	int cpus;
+	cpumask_t mask = cpu_online_map;
+
+	spin_lock(&nmi_spinlock);
+
+	cpus = num_online_cpus() - 1;
+
+	atomic_set(&paused, 0);
+	atomic_set(&nmi_wait, 1);
+	atomic_set(&nmi_resume, 0);
+
+	cpu_clear(safe_smp_processor_id(), mask);
+	if (!cpus_empty(mask))
+		send_IPI_mask(mask, NMI_VECTOR);
+
+	while (atomic_read(&paused) != cpus)
+		cpu_relax();
+
+	atomic_set(&nmi_wait, 0);
+}
+
+void kmemcheck_resume(void)
+{
+	int cpus;
+
+	cpus = num_online_cpus() - 1;
+
+	atomic_set(&nmi_resume, 1);
+
+	while (atomic_read(&paused) != 0)
+		cpu_relax();
+
+	spin_unlock(&nmi_spinlock);
+}
diff --git a/arch/x86/mm/kmemcheck/smp.h b/arch/x86/mm/kmemcheck/smp.h
new file mode 100644
index 0000000..dc65f16
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/smp.h
@@ -0,0 +1,23 @@
+#ifndef ARCH__X86__MM__KMEMCHECK__SMP_H
+#define ARCH__X86__MM__KMEMCHECK__SMP_H
+
+#ifdef CONFIG_KMEMCHECK_USE_SMP
+void kmemcheck_smp_init(void);
+
+void kmemcheck_pause_allbutself(void);
+void kmemcheck_resume(void);
+#else
+static inline void kmemcheck_smp_init(void)
+{
+}
+
+static inline void kmemcheck_pause_allbutself(void)
+{
+}
+
+static inline void kmemcheck_resume(void)
+{
+}
+#endif
+
+#endif
diff --git a/arch/x86/mm/kmemcheck/string.c b/arch/x86/mm/kmemcheck/string.c
new file mode 100644
index 0000000..1a62bf0
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/string.c
@@ -0,0 +1,95 @@
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/kmemcheck.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/types.h>
+
+#include "shadow.h"
+#include "smp.h"
+
+/*
+ * A faster implementation of memset() when tracking is enabled where the
+ * whole memory area is within a single page.
+ */
+static void memset_one_page(void *s, int c, size_t n)
+{
+	unsigned long addr;
+	void *x;
+	unsigned long flags;
+
+	addr = (unsigned long) s;
+
+	x = kmemcheck_shadow_lookup(addr);
+	if (!x) {
+		/* The page isn't being tracked. */
+		__memset(s, c, n);
+		return;
+	}
+
+	/*
+	 * While we are not guarding the page in question, nobody else
+	 * should be able to change them.
+	 */
+	local_irq_save(flags);
+
+	kmemcheck_pause_allbutself();
+	kmemcheck_show_addr(addr);
+	__memset(s, c, n);
+	__memset(x, KMEMCHECK_SHADOW_INITIALIZED, n);
+	if (kmemcheck_enabled)
+		kmemcheck_hide_addr(addr);
+	kmemcheck_resume();
+
+	local_irq_restore(flags);
+}
+
+/*
+ * A faster implementation of memset() when tracking is enabled. We cannot
+ * assume that all pages within the range are tracked, so copying has to be
+ * split into page-sized (or smaller, for the ends) chunks.
+ */
+void *kmemcheck_memset(void *s, int c, size_t n)
+{
+	unsigned long addr;
+	unsigned long start_page, start_offset;
+	unsigned long end_page, end_offset;
+	unsigned long i;
+
+	if (!n)
+		return s;
+
+	if (!slab_is_available()) {
+		__memset(s, c, n);
+		return s;
+	}
+
+	addr = (unsigned long) s;
+
+	start_page = addr & PAGE_MASK;
+	end_page = (addr + n) & PAGE_MASK;
+
+	if (start_page == end_page) {
+		/*
+		 * The entire area is within the same page. Good, we only
+		 * need one memset().
+		 */
+		memset_one_page(s, c, n);
+		return s;
+	}
+
+	start_offset = addr & ~PAGE_MASK;
+	end_offset = (addr + n) & ~PAGE_MASK;
+
+	/* Clear the head, body, and tail of the memory area. */
+	if (start_offset < PAGE_SIZE)
+		memset_one_page(s, c, PAGE_SIZE - start_offset);
+	for (i = start_page + PAGE_SIZE; i < end_page; i += PAGE_SIZE)
+		memset_one_page((void *) i, c, PAGE_SIZE);
+	if (end_offset > 0)
+		memset_one_page((void *) end_page, c, end_offset);
+
+	return s;
+}
+
+EXPORT_SYMBOL(kmemcheck_memset);
diff --git a/include/asm-x86/kdebug.h b/include/asm-x86/kdebug.h
index 96651bb..fe1fbde 100644
--- a/include/asm-x86/kdebug.h
+++ b/include/asm-x86/kdebug.h
@@ -27,10 +27,9 @@ extern void printk_address(unsigned long address, int reliable);
 extern void die(const char *, struct pt_regs *,long);
 extern int __must_check __die(const char *, struct pt_regs *, long);
 extern void show_registers(struct pt_regs *regs);
-extern void __show_registers(struct pt_regs *, int all);
 extern void show_trace(struct task_struct *t, struct pt_regs *regs,
 		       unsigned long *sp, unsigned long bp);
-extern void __show_regs(struct pt_regs *regs);
+extern void __show_regs(struct pt_regs *regs, int all);
 extern void show_regs(struct pt_regs *regs);
 extern unsigned long oops_begin(void);
 extern void oops_end(unsigned long, struct pt_regs *, int signr);
diff --git a/include/asm-x86/kmemcheck.h b/include/asm-x86/kmemcheck.h
new file mode 100644
index 0000000..f625398
--- /dev/null
+++ b/include/asm-x86/kmemcheck.h
@@ -0,0 +1,36 @@
+#ifndef ASM_X86_KMEMCHECK_H
+#define ASM_X86_KMEMCHECK_H
+
+#include <linux/types.h>
+#include <asm/ptrace.h>
+
+#ifdef CONFIG_KMEMCHECK
+bool kmemcheck_active(struct pt_regs *regs);
+
+void kmemcheck_show(struct pt_regs *regs);
+void kmemcheck_hide(struct pt_regs *regs);
+
+bool kmemcheck_fault(struct pt_regs *regs,
+	unsigned long address, unsigned long error_code);
+#else
+static inline bool kmemcheck_active(struct pt_regs *regs)
+{
+	return false;
+}
+
+static inline void kmemcheck_show(struct pt_regs *regs)
+{
+}
+
+static inline void kmemcheck_hide(struct pt_regs *regs)
+{
+}
+
+static inline bool kmemcheck_fault(struct pt_regs *regs,
+	unsigned long address, unsigned long error_code)
+{
+	return false;
+}
+#endif /* CONFIG_KMEMCHECK */
+
+#endif
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
index 49cbd76..69058cd 100644
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -16,7 +16,7 @@
 #define _PAGE_BIT_GLOBAL	8	/* Global TLB entry PPro+ */
 #define _PAGE_BIT_UNUSED1	9	/* available for programmer */
 #define _PAGE_BIT_UNUSED2	10
-#define _PAGE_BIT_UNUSED3	11
+#define _PAGE_BIT_HIDDEN	11	/* hidden by kmemcheck */
 #define _PAGE_BIT_PAT_LARGE	12	/* On 2MB or 1GB pages */
 #define _PAGE_BIT_NX           63       /* No execute: only valid after cpuid check */
 
@@ -31,7 +31,7 @@
 #define _PAGE_GLOBAL	(_AT(pteval_t, 1) << _PAGE_BIT_GLOBAL)
 #define _PAGE_UNUSED1	(_AT(pteval_t, 1) << _PAGE_BIT_UNUSED1)
 #define _PAGE_UNUSED2	(_AT(pteval_t, 1) << _PAGE_BIT_UNUSED2)
-#define _PAGE_UNUSED3	(_AT(pteval_t, 1) << _PAGE_BIT_UNUSED3)
+#define _PAGE_HIDDEN	(_AT(pteval_t, 1) << _PAGE_BIT_HIDDEN)
 #define _PAGE_PAT	(_AT(pteval_t, 1) << _PAGE_BIT_PAT)
 #define _PAGE_PAT_LARGE (_AT(pteval_t, 1) << _PAGE_BIT_PAT_LARGE)
 
diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
index ec871c4..8b5f658 100644
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -85,6 +85,12 @@ extern unsigned long pg0[];
 
 #define pte_present(x)	((x).pte_low & (_PAGE_PRESENT | _PAGE_PROTNONE))
 
+#ifdef CONFIG_KMEMCHECK
+#define pte_hidden(x)	((x).pte_low & (_PAGE_HIDDEN))
+#else
+#define pte_hidden(x)	0
+#endif
+
 /* To avoid harmful races, pmd_none(x) should check only the lower when PAE */
 #define pmd_none(x)	(!(unsigned long)pmd_val((x)))
 #define pmd_present(x)	(pmd_val((x)) & _PAGE_PRESENT)
diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
index fa7208b..7388fd8 100644
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -172,6 +172,12 @@ static inline int pmd_bad(pmd_t pmd)
 #define pte_none(x)	(!pte_val((x)))
 #define pte_present(x)	(pte_val((x)) & (_PAGE_PRESENT | _PAGE_PROTNONE))
 
+#ifdef CONFIG_KMEMCHECK
+#define pte_hidden(x)	(pte_val((x)) & (_PAGE_HIDDEN))
+#else
+#define pte_hidden(x)	0
+#endif
+
 #define pages_to_mb(x)	((x) >> (20 - PAGE_SHIFT))   /* FIXME: is this right? */
 #define pte_page(x)	pfn_to_page(pte_pfn((x)))
 #define pte_pfn(x)	((pte_val((x)) & __PHYSICAL_MASK) >> PAGE_SHIFT)
diff --git a/include/asm-x86/string_32.h b/include/asm-x86/string_32.h
index 193578c..a68be24 100644
--- a/include/asm-x86/string_32.h
+++ b/include/asm-x86/string_32.h
@@ -315,6 +315,14 @@ void *__constant_c_and_count_memset(void *s, unsigned long pattern,
 				 (count))				\
 	 : __memset((s), (c), (count)))
 
+/* If kmemcheck is enabled, our best bet is a custom memset() that disables
+ * checking in order to save a whole lot of (unnecessary) page faults. */
+#ifdef CONFIG_KMEMCHECK
+void *kmemcheck_memset(void *s, int c, size_t n);
+#undef memset
+#define memset(s, c, n) kmemcheck_memset((s), (c), (n))
+#endif
+
 /*
  * find the first occurrence of byte 'c', or 1 past the area if none
  */
diff --git a/include/asm-x86/string_64.h b/include/asm-x86/string_64.h
index 52b5ab3..49874fd 100644
--- a/include/asm-x86/string_64.h
+++ b/include/asm-x86/string_64.h
@@ -45,6 +45,7 @@ extern void *__memcpy(void *to, const void *from, size_t len);
 
 #define __HAVE_ARCH_MEMSET
 void *memset(void *s, int c, size_t n);
+void *__memset(void *s, int c, size_t n);
 
 #define __HAVE_ARCH_MEMMOVE
 void *memmove(void *dest, const void *src, size_t count);
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index b414be3..7c1db87 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -50,8 +50,9 @@ struct vm_area_struct;
 #define __GFP_THISNODE	((__force gfp_t)0x40000u)/* No fallback, no policies */
 #define __GFP_RECLAIMABLE ((__force gfp_t)0x80000u) /* Page is reclaimable */
 #define __GFP_MOVABLE	((__force gfp_t)0x100000u)  /* Page is movable */
+#define __GFP_NOTRACK	((__force gfp_t)0x200000u)  /* Don't track with kmemcheck */
 
-#define __GFP_BITS_SHIFT 21	/* Room for 21 __GFP_FOO bits */
+#define __GFP_BITS_SHIFT 22	/* Room for 22 __GFP_FOO bits */
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 
 /* This equals 0, but use constants in case they ever change */
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index f1fc747..ce0598b 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -377,6 +377,20 @@ static inline void tasklet_hi_schedule(struct tasklet_struct *t)
 		__tasklet_hi_schedule(t);
 }
 
+extern void __tasklet_hi_schedule_first(struct tasklet_struct *t);
+
+/*
+ * This version avoids touching any other tasklets. Needed for kmemcheck
+ * in order not to take any page faults while enqueueing this tasklet;
+ * consider VERY carefully whether you really need this or
+ * tasklet_hi_schedule()...
+ */
+static inline void tasklet_hi_schedule_first(struct tasklet_struct *t)
+{
+	if (!test_and_set_bit(TASKLET_STATE_SCHED, &t->state))
+		__tasklet_hi_schedule_first(t);
+}
+
 
 static inline void tasklet_disable_nosync(struct tasklet_struct *t)
 {
diff --git a/include/linux/kmemcheck.h b/include/linux/kmemcheck.h
new file mode 100644
index 0000000..b2d83ef
--- /dev/null
+++ b/include/linux/kmemcheck.h
@@ -0,0 +1,70 @@
+#ifndef LINUX_KMEMCHECK_H
+#define LINUX_KMEMCHECK_H
+
+#include <linux/mm_types.h>
+#include <linux/types.h>
+
+#ifdef CONFIG_KMEMCHECK
+extern int kmemcheck_enabled;
+
+void kmemcheck_init(void);
+
+/* The slab-related functions. */
+void kmemcheck_alloc_shadow(struct kmem_cache *s, gfp_t flags, int node,
+			    struct page *page, int order);
+void kmemcheck_free_shadow(struct kmem_cache *s, struct page *page, int order);
+void kmemcheck_slab_alloc(struct kmem_cache *s, gfp_t gfpflags, void *object,
+			  size_t size);
+void kmemcheck_slab_free(struct kmem_cache *s, void *object, size_t size);
+
+void kmemcheck_show_pages(struct page *p, unsigned int n);
+void kmemcheck_hide_pages(struct page *p, unsigned int n);
+
+bool kmemcheck_page_is_tracked(struct page *p);
+
+void kmemcheck_mark_unallocated(void *address, unsigned int n);
+void kmemcheck_mark_uninitialized(void *address, unsigned int n);
+void kmemcheck_mark_initialized(void *address, unsigned int n);
+void kmemcheck_mark_freed(void *address, unsigned int n);
+
+void kmemcheck_mark_unallocated_pages(struct page *p, unsigned int n);
+void kmemcheck_mark_uninitialized_pages(struct page *p, unsigned int n);
+
+int kmemcheck_show_addr(unsigned long address);
+int kmemcheck_hide_addr(unsigned long address);
+#else
+#define kmemcheck_enabled 0
+
+static inline void kmemcheck_init(void)
+{
+}
+
+static inline void
+kmemcheck_alloc_shadow(struct kmem_cache *s, gfp_t flags, int node,
+		       struct page *page, int order)
+{
+}
+
+static inline void
+kmemcheck_free_shadow(struct kmem_cache *s, struct page *page, int order)
+{
+}
+
+static inline void
+kmemcheck_slab_alloc(struct kmem_cache *s, gfp_t gfpflags, void *object,
+		     size_t size)
+{
+}
+
+static inline void kmemcheck_slab_free(struct kmem_cache *s, void *object,
+				       size_t size)
+{
+}
+
+static inline bool kmemcheck_page_is_tracked(struct page *p)
+{
+	return false;
+}
+#endif /* CONFIG_KMEMCHECK */
+
+#endif /* LINUX_KMEMCHECK_H */
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 02a27ae..f54e52a 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -94,6 +94,10 @@ struct page {
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 	unsigned long page_cgroup;
 #endif
+
+#ifdef CONFIG_KMEMCHECK
+	void *shadow;
+#endif
 };
 
 /*
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 9aa90a6..faff12b 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -34,6 +34,13 @@
 # define SLAB_DEBUG_OBJECTS	0x00000000UL
 #endif
 
+/* Don't track use of uninitialized memory */
+#ifdef CONFIG_KMEMCHECK
+# define SLAB_NOTRACK		0x00800000UL
+#else
+# define SLAB_NOTRACK		0x00000000UL
+#endif
+
 /* The following flags affect the page allocator grouping pages by mobility */
 #define SLAB_RECLAIM_ACCOUNT	0x00020000UL		/* Objects are reclaimable */
 #define SLAB_TEMPORARY		SLAB_RECLAIM_ACCOUNT	/* Objects are short-lived */
diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index 39c3a5e..37b4837 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -15,6 +15,87 @@
 #include <asm/cache.h>		/* kmalloc_sizes.h needs L1_CACHE_BYTES */
 #include <linux/compiler.h>
 
+/*
+ * struct kmem_cache
+ *
+ * manages a cache.
+ */
+
+struct kmem_cache {
+/* 1) per-cpu data, touched during every alloc/free */
+	struct array_cache *array[NR_CPUS];
+/* 2) Cache tunables. Protected by cache_chain_mutex */
+	unsigned int batchcount;
+	unsigned int limit;
+	unsigned int shared;
+
+	unsigned int buffer_size;
+	u32 reciprocal_buffer_size;
+/* 3) touched by every alloc & free from the backend */
+
+	unsigned int flags;		/* constant flags */
+	unsigned int num;		/* # of objs per slab */
+
+/* 4) cache_grow/shrink */
+	/* order of pgs per slab (2^n) */
+	unsigned int gfporder;
+
+	/* force GFP flags, e.g. GFP_DMA */
+	gfp_t gfpflags;
+
+	size_t colour;			/* cache colouring range */
+	unsigned int colour_off;	/* colour offset */
+	struct kmem_cache *slabp_cache;
+	unsigned int slab_size;
+	unsigned int dflags;		/* dynamic flags */
+
+	/* constructor func */
+	void (*ctor)(struct kmem_cache *, void *);
+
+/* 5) cache creation/removal */
+	const char *name;
+	struct list_head next;
+
+/* 6) statistics */
+#ifdef CONFIG_DEBUG_SLAB
+	unsigned long num_active;
+	unsigned long num_allocations;
+	unsigned long high_mark;
+	unsigned long grown;
+	unsigned long reaped;
+	unsigned long errors;
+	unsigned long max_freeable;
+	unsigned long node_allocs;
+	unsigned long node_frees;
+	unsigned long node_overflow;
+	atomic_t allochit;
+	atomic_t allocmiss;
+	atomic_t freehit;
+	atomic_t freemiss;
+
+	/*
+	 * If debugging is enabled, then the allocator can add additional
+	 * fields and/or padding to every object. buffer_size contains the total
+	 * object size including these internal fields, the following two
+	 * variables contain the offset to the user object and its size.
+	 */
+	int obj_offset;
+	int obj_size;
+#endif /* CONFIG_DEBUG_SLAB */
+
+	/*
+	 * We put nodelists[] at the end of kmem_cache, because we want to size
+	 * this array to nr_node_ids slots instead of MAX_NUMNODES
+	 * (see kmem_cache_init())
+	 * We still use [MAX_NUMNODES] and not [1] or [0] because cache_cache
+	 * is statically defined, so we reserve the max number of nodes.
+	 */
+	struct kmem_list3 *nodelists[MAX_NUMNODES];
+	/*
+	 * Do not add fields after nodelists[]
+	 */
+};
+
 /* Size description struct for general caches. */
 struct cache_sizes {
 	size_t		 	cs_size;
diff --git a/include/linux/stacktrace.h b/include/linux/stacktrace.h
index 5da9794..519ad2d 100644
--- a/include/linux/stacktrace.h
+++ b/include/linux/stacktrace.h
@@ -2,6 +2,8 @@
 #define __LINUX_STACKTRACE_H
 
 #ifdef CONFIG_STACKTRACE
+struct task_struct;
+
 struct stack_trace {
 	unsigned int nr_entries, max_entries;
 	unsigned long *entries;
@@ -9,6 +11,7 @@ struct stack_trace {
 };
 
 extern void save_stack_trace(struct stack_trace *trace);
+extern void save_stack_trace_bp(struct stack_trace *trace, unsigned long bp);
 extern void save_stack_trace_tsk(struct task_struct *tsk,
 				struct stack_trace *trace);
 
diff --git a/init/main.c b/init/main.c
index f7fb200..39a9ec4 100644
--- a/init/main.c
+++ b/init/main.c
@@ -60,6 +60,7 @@
 #include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/idr.h>
+#include <linux/kmemcheck.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -779,6 +780,7 @@ static void __init do_pre_smp_initcalls(void)
 {
 	extern int spawn_ksoftirqd(void);
 
+	kmemcheck_init();
 	migration_init();
 	spawn_ksoftirqd();
 	if (!nosoftlockup)
diff --git a/kernel/fork.c b/kernel/fork.c
index 19908b2..25c2aa3 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -150,7 +150,7 @@ void __init fork_init(unsigned long mempages)
 	/* create a slab on which task_structs can be allocated */
 	task_struct_cachep =
 		kmem_cache_create("task_struct", sizeof(struct task_struct),
-			ARCH_MIN_TASKALIGN, SLAB_PANIC, NULL);
+			ARCH_MIN_TASKALIGN, SLAB_PANIC | SLAB_NOTRACK, NULL);
 #endif
 
 	/* do the arch specific task caches init */
@@ -1415,23 +1415,23 @@ void __init proc_caches_init(void)
 {
 	sighand_cachep = kmem_cache_create("sighand_cache",
 			sizeof(struct sighand_struct), 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_DESTROY_BY_RCU,
-			sighand_ctor);
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_DESTROY_BY_RCU|
+			SLAB_NOTRACK, sighand_ctor);
 	signal_cachep = kmem_cache_create("signal_cache",
 			sizeof(struct signal_struct), 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK, NULL);
 	files_cachep = kmem_cache_create("files_cache",
 			sizeof(struct files_struct), 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK, NULL);
 	fs_cachep = kmem_cache_create("fs_cache",
 			sizeof(struct fs_struct), 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK, NULL);
 	vm_area_cachep = kmem_cache_create("vm_area_struct",
 			sizeof(struct vm_area_struct), 0,
-			SLAB_PANIC, NULL);
+			SLAB_PANIC|SLAB_NOTRACK, NULL);
 	mm_cachep = kmem_cache_create("mm_struct",
 			sizeof(struct mm_struct), ARCH_MIN_MMSTRUCT_ALIGN,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK, NULL);
 }
 
 /*
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 36e0617..23dc889 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -393,6 +393,17 @@ void __tasklet_hi_schedule(struct tasklet_struct *t)
 
 EXPORT_SYMBOL(__tasklet_hi_schedule);
 
+void __tasklet_hi_schedule_first(struct tasklet_struct *t)
+{
+	BUG_ON(!irqs_disabled());
+
+	t->next = __get_cpu_var(tasklet_hi_vec).head;
+	__get_cpu_var(tasklet_hi_vec).head = t;
+	__raise_softirq_irqoff(HI_SOFTIRQ);
+}
+
+EXPORT_SYMBOL(__tasklet_hi_schedule_first);
+
 static void tasklet_action(struct softirq_action *a)
 {
 	struct tasklet_struct *list;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 2911665..69a32c1 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -27,6 +27,7 @@
 #include <linux/security.h>
 #include <linux/ctype.h>
 #include <linux/utsname.h>
+#include <linux/kmemcheck.h>
 #include <linux/smp_lock.h>
 #include <linux/fs.h>
 #include <linux/init.h>
@@ -813,6 +814,17 @@ static struct ctl_table kern_table[] = {
 		.child		= key_sysctls,
 	},
 #endif
+#ifdef CONFIG_KMEMCHECK
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "kmemcheck",
+		.data		= &kmemcheck_enabled,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
+
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt
diff --git a/mm/Makefile b/mm/Makefile
index 18c143b..4801918 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -27,10 +27,10 @@ obj-$(CONFIG_TINY_SHMEM) += tiny-shmem.o
 obj-$(CONFIG_SLOB) += slob.o
 obj-$(CONFIG_SLAB) += slab.o
 obj-$(CONFIG_SLUB) += slub.o
+obj-$(CONFIG_KMEMCHECK) += kmemcheck.o
 obj-$(CONFIG_MEMORY_HOTPLUG) += memory_hotplug.o
 obj-$(CONFIG_FS_XIP) += filemap_xip.o
 obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_SMP) += allocpercpu.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o
-
diff --git a/mm/kmemcheck.c b/mm/kmemcheck.c
new file mode 100644
index 0000000..4efdf1e
--- /dev/null
+++ b/mm/kmemcheck.c
@@ -0,0 +1,97 @@
+#include <linux/mm_types.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/kmemcheck.h>
+
+void kmemcheck_alloc_shadow(struct kmem_cache *s, gfp_t flags, int node,
+			   struct page *page, int order)
+{
+	struct page *shadow;
+	int pages;
+	int i;
+
+	pages = 1 << order;
+
+	/*
+	 * With kmemcheck enabled, we need to allocate a memory area for the
+	 * shadow bits as well.
+	 */
+	shadow = alloc_pages_node(node, flags, order);
+	if (!shadow) {
+		if (printk_ratelimit())
+			printk(KERN_ERR "kmemcheck: failed to allocate "
+				"shadow bitmap\n");
+		return;
+	}
+
+	for(i = 0; i < pages; ++i)
+		page[i].shadow = page_address(&shadow[i]);
+
+	/*
+	 * Mark it as non-present for the MMU so that our accesses to
+	 * this memory will trigger a page fault and let us analyze
+	 * the memory accesses.
+	 */
+	kmemcheck_hide_pages(page, pages);
+
+	/*
+	 * Objects from caches that have a constructor don't get
+	 * cleared when they're allocated, so we need to do it here.
+	 */
+	if (s->ctor)
+		kmemcheck_mark_uninitialized_pages(page, pages);
+	else
+		kmemcheck_mark_unallocated_pages(page, pages);
+}
+
+void kmemcheck_free_shadow(struct kmem_cache *s, struct page *page, int order)
+{
+	struct page *shadow;
+	int pages;
+	int i;
+
+	pages = 1 << order;
+
+	kmemcheck_show_pages(page, pages);
+
+	shadow = virt_to_page(page[0].shadow);
+
+	for(i = 0; i < pages; ++i)
+		page[i].shadow = NULL;
+
+	__free_pages(shadow, order);
+}
+
+void kmemcheck_slab_alloc(struct kmem_cache *s, gfp_t gfpflags, void *object,
+			  size_t size)
+{
+	if (gfpflags & __GFP_ZERO)
+		return;
+	if (s->flags & SLAB_NOTRACK)
+		return;
+
+	if (!kmemcheck_enabled || gfpflags & __GFP_NOTRACK) {
+		/*
+		 * Allow notracked objects to be allocated from
+		 * tracked caches. Note however that these objects
+		 * will still get page faults on access, they just
+		 * won't ever be flagged as uninitialized. If page
+		 * faults are not acceptable, the slab cache itself
+		 * should be marked NOTRACK.
+		 */
+		kmemcheck_mark_initialized(object, size);
+	} else if (!s->ctor) {
+		/*
+		 * New objects should be marked uninitialized before
+		 * they're returned to the called.
+		 */
+		kmemcheck_mark_uninitialized(object, size);
+	}
+}
+
+void kmemcheck_slab_free(struct kmem_cache *s, void *object, size_t size)
+{
+	/* TODO: RCU freeing is unsupported for now; hide false positives. */
+	if (!s->ctor && !(s->flags & SLAB_DESTROY_BY_RCU))
+		kmemcheck_mark_freed(object, size);
+}
diff --git a/mm/slab.c b/mm/slab.c
index 046607f..9c44366 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -111,6 +111,7 @@
 #include	<linux/rtmutex.h>
 #include	<linux/reciprocal_div.h>
 #include	<linux/debugobjects.h>
+#include	<linux/kmemcheck.h>
 
 #include	<asm/cacheflush.h>
 #include	<asm/tlbflush.h>
@@ -176,13 +177,13 @@
 			 SLAB_STORE_USER | \
 			 SLAB_RECLAIM_ACCOUNT | SLAB_PANIC | \
 			 SLAB_DESTROY_BY_RCU | SLAB_MEM_SPREAD | \
-			 SLAB_DEBUG_OBJECTS)
+			 SLAB_DEBUG_OBJECTS | SLAB_NOTRACK)
 #else
 # define CREATE_MASK	(SLAB_HWCACHE_ALIGN | \
 			 SLAB_CACHE_DMA | \
 			 SLAB_RECLAIM_ACCOUNT | SLAB_PANIC | \
 			 SLAB_DESTROY_BY_RCU | SLAB_MEM_SPREAD | \
-			 SLAB_DEBUG_OBJECTS)
+			 SLAB_DEBUG_OBJECTS | SLAB_NOTRACK)
 #endif
 
 /*
@@ -371,87 +372,6 @@ static void kmem_list3_init(struct kmem_list3 *parent)
 	MAKE_LIST((cachep), (&(ptr)->slabs_free), slabs_free, nodeid);	\
 	} while (0)
 
-/*
- * struct kmem_cache
- *
- * manages a cache.
- */
-
-struct kmem_cache {
-/* 1) per-cpu data, touched during every alloc/free */
-	struct array_cache *array[NR_CPUS];
-/* 2) Cache tunables. Protected by cache_chain_mutex */
-	unsigned int batchcount;
-	unsigned int limit;
-	unsigned int shared;
-
-	unsigned int buffer_size;
-	u32 reciprocal_buffer_size;
-/* 3) touched by every alloc & free from the backend */
-
-	unsigned int flags;		/* constant flags */
-	unsigned int num;		/* # of objs per slab */
-
-/* 4) cache_grow/shrink */
-	/* order of pgs per slab (2^n) */
-	unsigned int gfporder;
-
-	/* force GFP flags, e.g. GFP_DMA */
-	gfp_t gfpflags;
-
-	size_t colour;			/* cache colouring range */
-	unsigned int colour_off;	/* colour offset */
-	struct kmem_cache *slabp_cache;
-	unsigned int slab_size;
-	unsigned int dflags;		/* dynamic flags */
-
-	/* constructor func */
-	void (*ctor)(struct kmem_cache *, void *);
-
-/* 5) cache creation/removal */
-	const char *name;
-	struct list_head next;
-
-/* 6) statistics */
-#if STATS
-	unsigned long num_active;
-	unsigned long num_allocations;
-	unsigned long high_mark;
-	unsigned long grown;
-	unsigned long reaped;
-	unsigned long errors;
-	unsigned long max_freeable;
-	unsigned long node_allocs;
-	unsigned long node_frees;
-	unsigned long node_overflow;
-	atomic_t allochit;
-	atomic_t allocmiss;
-	atomic_t freehit;
-	atomic_t freemiss;
-#endif
-#if DEBUG
-	/*
-	 * If debugging is enabled, then the allocator can add additional
-	 * fields and/or padding to every object. buffer_size contains the total
-	 * object size including these internal fields, the following two
-	 * variables contain the offset to the user object and its size.
-	 */
-	int obj_offset;
-	int obj_size;
-#endif
-	/*
-	 * We put nodelists[] at the end of kmem_cache, because we want to size
-	 * this array to nr_node_ids slots instead of MAX_NUMNODES
-	 * (see kmem_cache_init())
-	 * We still use [MAX_NUMNODES] and not [1] or [0] because cache_cache
-	 * is statically defined, so we reserve the max number of nodes.
-	 */
-	struct kmem_list3 *nodelists[MAX_NUMNODES];
-	/*
-	 * Do not add fields after nodelists[]
-	 */
-};
-
 #define CFLGS_OFF_SLAB		(0x80000000UL)
 #define	OFF_SLAB(x)	((x)->flags & CFLGS_OFF_SLAB)
 
@@ -1692,6 +1612,10 @@ static void *kmem_getpages(struct kmem_cache *cachep, gfp_t flags, int nodeid)
 			NR_SLAB_UNRECLAIMABLE, nr_pages);
 	for (i = 0; i < nr_pages; i++)
 		__SetPageSlab(page + i);
+
+	if (kmemcheck_enabled && !(cachep->flags & SLAB_NOTRACK))
+		kmemcheck_alloc_shadow(cachep, flags, nodeid, page, cachep->gfporder);
+
 	return page_address(page);
 }
 
@@ -1704,6 +1628,9 @@ static void kmem_freepages(struct kmem_cache *cachep, void *addr)
 	struct page *page = virt_to_page(addr);
 	const unsigned long nr_freed = i;
 
+	if (kmemcheck_page_is_tracked(page))
+		kmemcheck_free_shadow(cachep, page, cachep->gfporder);
+
 	if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
 		sub_zone_page_state(page_zone(page),
 				NR_SLAB_RECLAIMABLE, nr_freed);
@@ -3421,6 +3348,9 @@ __cache_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid,
 	local_irq_restore(save_flags);
 	ptr = cache_alloc_debugcheck_after(cachep, flags, ptr, caller);
 
+	if (likely(ptr))
+		kmemcheck_slab_alloc(cachep, flags, ptr, obj_size(cachep));
+
 	if (unlikely((flags & __GFP_ZERO) && ptr))
 		memset(ptr, 0, obj_size(cachep));
 
@@ -3475,6 +3405,9 @@ __cache_alloc(struct kmem_cache *cachep, gfp_t flags, void *caller)
 	objp = cache_alloc_debugcheck_after(cachep, flags, objp, caller);
 	prefetchw(objp);
 
+	if (likely(objp))
+		kmemcheck_slab_alloc(cachep, flags, objp, obj_size(cachep));
+
 	if (unlikely((flags & __GFP_ZERO) && objp))
 		memset(objp, 0, obj_size(cachep));
 
@@ -3590,6 +3523,8 @@ static inline void __cache_free(struct kmem_cache *cachep, void *objp)
 	check_irq_off();
 	objp = cache_free_debugcheck(cachep, objp, __builtin_return_address(0));
 
+	kmemcheck_slab_free(cachep, objp, obj_size(cachep));
+
 	/*
 	 * Skip calling cache_free_alien() when the platform is not numa.
 	 * This will avoid cache misses that happen while accessing slabp (which
diff --git a/mm/slub.c b/mm/slub.c
index 315c392..dbbd455 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -23,6 +23,7 @@
 #include <linux/kallsyms.h>
 #include <linux/memory.h>
 #include <linux/math64.h>
+#include <linux/kmemcheck.h>
 
 /*
  * Lock order:
@@ -174,7 +175,7 @@ static inline void ClearSlabDebug(struct page *page)
 		SLAB_TRACE | SLAB_DESTROY_BY_RCU)
 
 #define SLUB_MERGE_SAME (SLAB_DEBUG_FREE | SLAB_RECLAIM_ACCOUNT | \
-		SLAB_CACHE_DMA)
+		SLAB_CACHE_DMA | SLAB_NOTRACK)
 
 #ifndef ARCH_KMALLOC_MINALIGN
 #define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
@@ -1122,6 +1123,13 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 
 		stat(get_cpu_slab(s, raw_smp_processor_id()), ORDER_FALLBACK);
 	}
+
+	if (kmemcheck_enabled
+		&& !(s->flags & (SLAB_NOTRACK | DEBUG_DEFAULT_FLAGS)))
+	{
+		kmemcheck_alloc_shadow(s, flags, node, page, compound_order(page));
+	}
+
 	page->objects = oo_objects(oo);
 	mod_zone_page_state(page_zone(page),
 		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
@@ -1195,6 +1203,9 @@ static void __free_slab(struct kmem_cache *s, struct page *page)
 		ClearSlabDebug(page);
 	}
 
+	if (kmemcheck_page_is_tracked(page))
+		kmemcheck_free_shadow(s, page, compound_order(page));
+
 	mod_zone_page_state(page_zone(page),
 		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
 		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
@@ -1647,6 +1658,7 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
 	if (unlikely((gfpflags & __GFP_ZERO) && object))
 		memset(object, 0, objsize);
 
+	kmemcheck_slab_alloc(s, gfpflags, object, c->objsize);
 	return object;
 }
 
@@ -1751,6 +1763,7 @@ static __always_inline void slab_free(struct kmem_cache *s,
 
 	local_irq_save(flags);
 	c = get_cpu_slab(s, smp_processor_id());
+	kmemcheck_slab_free(s, object, c->objsize);
 	debug_check_no_locks_freed(object, c->objsize);
 	if (!(s->flags & SLAB_DEBUG_OBJECTS))
 		debug_check_no_obj_freed(object, s->objsize);
@@ -2602,7 +2615,8 @@ static noinline struct kmem_cache *dma_kmalloc_cache(int index, gfp_t flags)
 
 	if (!s || !text || !kmem_cache_open(s, flags, text,
 			realsize, ARCH_KMALLOC_MINALIGN,
-			SLAB_CACHE_DMA|__SYSFS_ADD_DEFERRED, NULL)) {
+			SLAB_CACHE_DMA|SLAB_NOTRACK|__SYSFS_ADD_DEFERRED,
+			NULL)) {
 		kfree(s);
 		kfree(text);
 		goto unlock_out;
@@ -4308,6 +4322,8 @@ static char *create_unique_id(struct kmem_cache *s)
 		*p++ = 'a';
 	if (s->flags & SLAB_DEBUG_FREE)
 		*p++ = 'F';
+	if (!(s->flags & SLAB_NOTRACK))
+		*p++ = 't';
 	if (p != name + 1)
 		*p++ = '-';
 	p += sprintf(p, "%07d", s->size);
