Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbZIKTUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbZIKTUm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755918AbZIKTUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:20:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40594 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756093AbZIKTUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:20:30 -0400
Date: Fri, 11 Sep 2009 21:19:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [GIT PULL] perfcounters/core for v2.6.32
Message-ID: <20090911191958.GA18615@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 3.8
X-ELTE-SpamLevel: sss
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=3.8 required=5.9 tests=BAYES_00,FM_LIKE_STOCKS,TVD_STOCK1 autolearn=no SpamAssassin version=3.2.5
	3.8 TVD_STOCK1             BODY: TVD_STOCK1
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	1.5 FM_LIKE_STOCKS         It looks like a duck, it's a duck!
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perfcounters-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perfcounters-core-for-linus

Highlights:

 - New 'perf trace' tool
 - Output channel multiplexing
 - Updated statistics model for perf stat --repeat
 - x86 BTS branch recording
 - Call-chain support on PowerPC

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (1):
      perf top: Show RIP only in verbose mode

Brice Goglin (2):
      perf report: Fix and improve the displaying of per-thread event counters
      perf report: Add raw displaying of per-thread counters

Frederic Weisbecker (23):
      perf tools: Factorize high level dso helpers
      perf tools: Factorize the event structure definitions in a single file
      perf tools: Factorize the map helpers
      perf tools: Factorize the thread code in a dedicated file
      perf tools: Substract -Wformat-nonliteral from Wformat=2 in extra flags
      perf tools: Factorize the dprintf definition
      perf tools: Put the show mode into the event headers files
      perf tools: Librarize sample type and attr finding from headers
      perf tools: Librarize trace_event() helper
      perf tools: Add perf trace
      perf tools: Fix spelling mistake in callchain error
      perf tools: Warn while running perf trace without sample
      perf tools: Record events info also when :record suffix is used.
      perf tools: Make trace event format parser aware of cast to pointers
      perf tools: Fix comm column adjusting
      perf tools: Save partial non-overlapping map
      perf tools: Only save the event formats we need
      perf tools: Fix missing string field printing in perf trace
      perf tools: Add missing parameters documentation
      perf tools: Librarize idle thread registration
      perf tools: Resolve idle thread cmdline for perf trace
      perf tools: Unify swapper tasks naming
      perf tools: Complete support for dynamic strings

Ingo Molnar (13):
      perf: Enable more compiler warnings
      perf: Build with stack-protector and with -D_FORTIFY_SOURCE=2
      perf tools: Remove obsolete defines
      perf tools: Clean up warnings list in the Makefile
      perf tools: Work around strict aliasing related warnings
      perf trace: Sample the CPU too
      perf_counter: Introduce new (non-)paranoia level to allow raw tracepoint access
      perf trace: Sample timestamps as well
      perf trace: Fix parsing of perf.data
      perf tools: Seek to the end of the header area
      perf trace: Print out in nanoseconds
      perf trace: Fix read_string()
      perf_counter: Fix output-sharing error path

Markus Metzger (1):
      x86, perf_counter, bts: Add BTS support to perfcounters

Masami Hiramatsu (1):
      perf trace: Add OPT_END to option array of perf-trace

Paul Mackerras (4):
      powerpc/32: Always order writes to halves of 64-bit PTEs
      powerpc: Allow perf_counters to access user memory at interrupt time
      perf_counter: powerpc: Add callchain support
      perf_counter: Start counting time enabled when group leader gets enabled

Peter Zijlstra (7):
      perf tools: Add some comments to the event definitions
      perf_counter: Allow sharing of output channels
      perf stat: Change noise calculation to use stddev
      perf stat: Remove the limit on repeat
      perf stat: Use stddev_mean in stead of stddev
      perf stat: More advanced variance computation
      perf stat: Clean up statistics calculations a bit more

Pierre Habouzit (1):
      perf tools: do not complain if root is owning perf.data

Steven Rostedt (3):
      perf tools: Add trace event debugfs IO handler
      perf tools: Add trace event debugfs stream reader
      perf tools: Add trace event information parser

Ulrich Drepper (1):
      perf tools: Avoid unnecessary work in directory lookups

markus.t.metzger@intel.com (3):
      x86, perf_counter, bts: Fail if BTS is not available
      x86, perf_counter, bts: Correct pointer-to-u64 casts
      x86, perf_counter, bts: Do not allow kernel BTS tracing for now


 arch/powerpc/include/asm/pgtable.h       |    6 +-
 arch/powerpc/kernel/Makefile             |    2 +-
 arch/powerpc/kernel/asm-offsets.c        |    2 +
 arch/powerpc/kernel/exceptions-64s.S     |   19 +
 arch/powerpc/kernel/perf_callchain.c     |  527 ++++++
 arch/powerpc/mm/slb.c                    |   37 +-
 arch/powerpc/mm/stab.c                   |   11 +-
 arch/x86/include/asm/perf_counter.h      |   10 +
 arch/x86/kernel/cpu/perf_counter.c       |  329 ++++-
 include/linux/perf_counter.h             |    5 +
 kernel/perf_counter.c                    |  173 ++-
 tools/perf/Documentation/perf-record.txt |    4 +
 tools/perf/Documentation/perf-report.txt |   13 +
 tools/perf/Makefile                      |   39 +-
 tools/perf/builtin-annotate.c            |  472 +-----
 tools/perf/builtin-help.c                |    1 +
 tools/perf/builtin-record.c              |   38 +-
 tools/perf/builtin-report.c              |  719 ++------
 tools/perf/builtin-stat.c                |  239 +--
 tools/perf/builtin-top.c                 |   66 +-
 tools/perf/builtin-trace.c               |  297 +++
 tools/perf/builtin.h                     |    1 +
 tools/perf/perf.c                        |    1 +
 tools/perf/util/abspath.c                |    3 +-
 tools/perf/util/cache.h                  |    1 -
 tools/perf/util/callchain.c              |    2 +
 tools/perf/util/callchain.h              |    1 +
 tools/perf/util/color.c                  |   16 +-
 tools/perf/util/color.h                  |    3 +-
 tools/perf/util/config.c                 |   22 +-
 tools/perf/util/debug.c                  |   95 +
 tools/perf/util/debug.h                  |    8 +
 tools/perf/util/event.h                  |   96 +
 tools/perf/util/exec_cmd.c               |    1 -
 tools/perf/util/header.c                 |   37 +-
 tools/perf/util/header.h                 |    4 +
 tools/perf/util/map.c                    |   97 +
 tools/perf/util/module.c                 |    4 +-
 tools/perf/util/parse-events.c           |  139 +-
 tools/perf/util/parse-events.h           |   17 +-
 tools/perf/util/parse-options.c          |   22 +
 tools/perf/util/path.c                   |   25 +-
 tools/perf/util/run-command.c            |    6 +-
 tools/perf/util/symbol.c                 |  199 ++-
 tools/perf/util/symbol.h                 |   14 +-
 tools/perf/util/thread.c                 |  175 ++
 tools/perf/util/thread.h                 |   21 +
 tools/perf/util/trace-event-info.c       |  539 ++++++
 tools/perf/util/trace-event-parse.c      | 2942 ++++++++++++++++++++++++++++++
 tools/perf/util/trace-event-read.c       |  512 ++++++
 tools/perf/util/trace-event.h            |  240 +++
 tools/perf/util/util.h                   |    6 +-
 tools/perf/util/values.c                 |  230 +++
 tools/perf/util/values.h                 |   27 +
 54 files changed, 7110 insertions(+), 1405 deletions(-)
 create mode 100644 arch/powerpc/kernel/perf_callchain.c
 create mode 100644 tools/perf/builtin-trace.c
 create mode 100644 tools/perf/util/debug.c
 create mode 100644 tools/perf/util/debug.h
 create mode 100644 tools/perf/util/event.h
 create mode 100644 tools/perf/util/map.c
 create mode 100644 tools/perf/util/thread.c
 create mode 100644 tools/perf/util/thread.h
 create mode 100644 tools/perf/util/trace-event-info.c
 create mode 100644 tools/perf/util/trace-event-parse.c
 create mode 100644 tools/perf/util/trace-event-read.c
 create mode 100644 tools/perf/util/trace-event.h
 create mode 100644 tools/perf/util/values.c
 create mode 100644 tools/perf/util/values.h

diff --git a/arch/powerpc/include/asm/pgtable.h b/arch/powerpc/include/asm/pgtable.h
index eb17da7..2a5da06 100644
--- a/arch/powerpc/include/asm/pgtable.h
+++ b/arch/powerpc/include/asm/pgtable.h
@@ -104,8 +104,8 @@ static inline void __set_pte_at(struct mm_struct *mm, unsigned long addr,
 	else
 		pte_update(ptep, ~_PAGE_HASHPTE, pte_val(pte));
 
-#elif defined(CONFIG_PPC32) && defined(CONFIG_PTE_64BIT) && defined(CONFIG_SMP)
-	/* Second case is 32-bit with 64-bit PTE in SMP mode. In this case, we
+#elif defined(CONFIG_PPC32) && defined(CONFIG_PTE_64BIT)
+	/* Second case is 32-bit with 64-bit PTE.  In this case, we
 	 * can just store as long as we do the two halves in the right order
 	 * with a barrier in between. This is possible because we take care,
 	 * in the hash code, to pre-invalidate if the PTE was already hashed,
@@ -140,7 +140,7 @@ static inline void __set_pte_at(struct mm_struct *mm, unsigned long addr,
 
 #else
 	/* Anything else just stores the PTE normally. That covers all 64-bit
-	 * cases, and 32-bit non-hash with 64-bit PTEs in UP mode
+	 * cases, and 32-bit non-hash with 32-bit PTEs.
 	 */
 	*ptep = pte;
 #endif
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index b73396b..9619285 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -97,7 +97,7 @@ obj64-$(CONFIG_AUDIT)		+= compat_audit.o
 
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o
-obj-$(CONFIG_PPC_PERF_CTRS)	+= perf_counter.o
+obj-$(CONFIG_PPC_PERF_CTRS)	+= perf_counter.o perf_callchain.o
 obj64-$(CONFIG_PPC_PERF_CTRS)	+= power4-pmu.o ppc970-pmu.o power5-pmu.o \
 				   power5+-pmu.o power6-pmu.o power7-pmu.o
 obj32-$(CONFIG_PPC_PERF_CTRS)	+= mpc7450-pmu.o
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index 561b646..197b156 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -67,6 +67,8 @@ int main(void)
 	DEFINE(MMCONTEXTID, offsetof(struct mm_struct, context.id));
 #ifdef CONFIG_PPC64
 	DEFINE(AUDITCONTEXT, offsetof(struct task_struct, audit_context));
+	DEFINE(SIGSEGV, SIGSEGV);
+	DEFINE(NMI_MASK, NMI_MASK);
 #else
 	DEFINE(THREAD_INFO, offsetof(struct task_struct, stack));
 #endif /* CONFIG_PPC64 */
diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index eb89811..8ac85e0 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -729,6 +729,11 @@ BEGIN_FTR_SECTION
 	bne-	do_ste_alloc		/* If so handle it */
 END_FTR_SECTION_IFCLR(CPU_FTR_SLB)
 
+	clrrdi	r11,r1,THREAD_SHIFT
+	lwz	r0,TI_PREEMPT(r11)	/* If we're in an "NMI" */
+	andis.	r0,r0,NMI_MASK@h	/* (i.e. an irq when soft-disabled) */
+	bne	77f			/* then don't call hash_page now */
+
 	/*
 	 * On iSeries, we soft-disable interrupts here, then
 	 * hard-enable interrupts so that the hash_page code can spin on
@@ -833,6 +838,20 @@ handle_page_fault:
 	bl	.low_hash_fault
 	b	.ret_from_except
 
+/*
+ * We come here as a result of a DSI at a point where we don't want
+ * to call hash_page, such as when we are accessing memory (possibly
+ * user memory) inside a PMU interrupt that occurred while interrupts
+ * were soft-disabled.  We want to invoke the exception handler for
+ * the access, or panic if there isn't a handler.
+ */
+77:	bl	.save_nvgprs
+	mr	r4,r3
+	addi	r3,r1,STACK_FRAME_OVERHEAD
+	li	r5,SIGSEGV
+	bl	.bad_page_fault
+	b	.ret_from_except
+
 	/* here we have a segment miss */
 do_ste_alloc:
 	bl	.ste_allocate		/* try to insert stab entry */
diff --git a/arch/powerpc/kernel/perf_callchain.c b/arch/powerpc/kernel/perf_callchain.c
new file mode 100644
index 0000000..f74b62c
--- /dev/null
+++ b/arch/powerpc/kernel/perf_callchain.c
@@ -0,0 +1,527 @@
+/*
+ * Performance counter callchain support - powerpc architecture code
+ *
+ * Copyright © 2009 Paul Mackerras, IBM Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/perf_counter.h>
+#include <linux/percpu.h>
+#include <linux/uaccess.h>
+#include <linux/mm.h>
+#include <asm/ptrace.h>
+#include <asm/pgtable.h>
+#include <asm/sigcontext.h>
+#include <asm/ucontext.h>
+#include <asm/vdso.h>
+#ifdef CONFIG_PPC64
+#include "ppc32.h"
+#endif
+
+/*
+ * Store another value in a callchain_entry.
+ */
+static inline void callchain_store(struct perf_callchain_entry *entry, u64 ip)
+{
+	unsigned int nr = entry->nr;
+
+	if (nr < PERF_MAX_STACK_DEPTH) {
+		entry->ip[nr] = ip;
+		entry->nr = nr + 1;
+	}
+}
+
+/*
+ * Is sp valid as the address of the next kernel stack frame after prev_sp?
+ * The next frame may be in a different stack area but should not go
+ * back down in the same stack area.
+ */
+static int valid_next_sp(unsigned long sp, unsigned long prev_sp)
+{
+	if (sp & 0xf)
+		return 0;		/* must be 16-byte aligned */
+	if (!validate_sp(sp, current, STACK_FRAME_OVERHEAD))
+		return 0;
+	if (sp >= prev_sp + STACK_FRAME_OVERHEAD)
+		return 1;
+	/*
+	 * sp could decrease when we jump off an interrupt stack
+	 * back to the regular process stack.
+	 */
+	if ((sp & ~(THREAD_SIZE - 1)) != (prev_sp & ~(THREAD_SIZE - 1)))
+		return 1;
+	return 0;
+}
+
+static void perf_callchain_kernel(struct pt_regs *regs,
+				  struct perf_callchain_entry *entry)
+{
+	unsigned long sp, next_sp;
+	unsigned long next_ip;
+	unsigned long lr;
+	long level = 0;
+	unsigned long *fp;
+
+	lr = regs->link;
+	sp = regs->gpr[1];
+	callchain_store(entry, PERF_CONTEXT_KERNEL);
+	callchain_store(entry, regs->nip);
+
+	if (!validate_sp(sp, current, STACK_FRAME_OVERHEAD))
+		return;
+
+	for (;;) {
+		fp = (unsigned long *) sp;
+		next_sp = fp[0];
+
+		if (next_sp == sp + STACK_INT_FRAME_SIZE &&
+		    fp[STACK_FRAME_MARKER] == STACK_FRAME_REGS_MARKER) {
+			/*
+			 * This looks like an interrupt frame for an
+			 * interrupt that occurred in the kernel
+			 */
+			regs = (struct pt_regs *)(sp + STACK_FRAME_OVERHEAD);
+			next_ip = regs->nip;
+			lr = regs->link;
+			level = 0;
+			callchain_store(entry, PERF_CONTEXT_KERNEL);
+
+		} else {
+			if (level == 0)
+				next_ip = lr;
+			else
+				next_ip = fp[STACK_FRAME_LR_SAVE];
+
+			/*
+			 * We can't tell which of the first two addresses
+			 * we get are valid, but we can filter out the
+			 * obviously bogus ones here.  We replace them
+			 * with 0 rather than removing them entirely so
+			 * that userspace can tell which is which.
+			 */
+			if ((level == 1 && next_ip == lr) ||
+			    (level <= 1 && !kernel_text_address(next_ip)))
+				next_ip = 0;
+
+			++level;
+		}
+
+		callchain_store(entry, next_ip);
+		if (!valid_next_sp(next_sp, sp))
+			return;
+		sp = next_sp;
+	}
+}
+
+#ifdef CONFIG_PPC64
+
+#ifdef CONFIG_HUGETLB_PAGE
+#define is_huge_psize(pagesize)	(HPAGE_SHIFT && mmu_huge_psizes[pagesize])
+#else
+#define is_huge_psize(pagesize)	0
+#endif
+
+/*
+ * On 64-bit we don't want to invoke hash_page on user addresses from
+ * interrupt context, so if the access faults, we read the page tables
+ * to find which page (if any) is mapped and access it directly.
+ */
+static int read_user_stack_slow(void __user *ptr, void *ret, int nb)
+{
+	pgd_t *pgdir;
+	pte_t *ptep, pte;
+	int pagesize;
+	unsigned long addr = (unsigned long) ptr;
+	unsigned long offset;
+	unsigned long pfn;
+	void *kaddr;
+
+	pgdir = current->mm->pgd;
+	if (!pgdir)
+		return -EFAULT;
+
+	pagesize = get_slice_psize(current->mm, addr);
+
+	/* align address to page boundary */
+	offset = addr & ((1ul << mmu_psize_defs[pagesize].shift) - 1);
+	addr -= offset;
+
+	if (is_huge_psize(pagesize))
+		ptep = huge_pte_offset(current->mm, addr);
+	else
+		ptep = find_linux_pte(pgdir, addr);
+
+	if (ptep == NULL)
+		return -EFAULT;
+	pte = *ptep;
+	if (!pte_present(pte) || !(pte_val(pte) & _PAGE_USER))
+		return -EFAULT;
+	pfn = pte_pfn(pte);
+	if (!page_is_ram(pfn))
+		return -EFAULT;
+
+	/* no highmem to worry about here */
+	kaddr = pfn_to_kaddr(pfn);
+	memcpy(ret, kaddr + offset, nb);
+	return 0;
+}
+
+static int read_user_stack_64(unsigned long __user *ptr, unsigned long *ret)
+{
+	if ((unsigned long)ptr > TASK_SIZE - sizeof(unsigned long) ||
+	    ((unsigned long)ptr & 7))
+		return -EFAULT;
+
+	if (!__get_user_inatomic(*ret, ptr))
+		return 0;
+
+	return read_user_stack_slow(ptr, ret, 8);
+}
+
+static int read_user_stack_32(unsigned int __user *ptr, unsigned int *ret)
+{
+	if ((unsigned long)ptr > TASK_SIZE - sizeof(unsigned int) ||
+	    ((unsigned long)ptr & 3))
+		return -EFAULT;
+
+	if (!__get_user_inatomic(*ret, ptr))
+		return 0;
+
+	return read_user_stack_slow(ptr, ret, 4);
+}
+
+static inline int valid_user_sp(unsigned long sp, int is_64)
+{
+	if (!sp || (sp & 7) || sp > (is_64 ? TASK_SIZE : 0x100000000UL) - 32)
+		return 0;
+	return 1;
+}
+
+/*
+ * 64-bit user processes use the same stack frame for RT and non-RT signals.
+ */
+struct signal_frame_64 {
+	char		dummy[__SIGNAL_FRAMESIZE];
+	struct ucontext	uc;
+	unsigned long	unused[2];
+	unsigned int	tramp[6];
+	struct siginfo	*pinfo;
+	void		*puc;
+	struct siginfo	info;
+	char		abigap[288];
+};
+
+static int is_sigreturn_64_address(unsigned long nip, unsigned long fp)
+{
+	if (nip == fp + offsetof(struct signal_frame_64, tramp))
+		return 1;
+	if (vdso64_rt_sigtramp && current->mm->context.vdso_base &&
+	    nip == current->mm->context.vdso_base + vdso64_rt_sigtramp)
+		return 1;
+	return 0;
+}
+
+/*
+ * Do some sanity checking on the signal frame pointed to by sp.
+ * We check the pinfo and puc pointers in the frame.
+ */
+static int sane_signal_64_frame(unsigned long sp)
+{
+	struct signal_frame_64 __user *sf;
+	unsigned long pinfo, puc;
+
+	sf = (struct signal_frame_64 __user *) sp;
+	if (read_user_stack_64((unsigned long __user *) &sf->pinfo, &pinfo) ||
+	    read_user_stack_64((unsigned long __user *) &sf->puc, &puc))
+		return 0;
+	return pinfo == (unsigned long) &sf->info &&
+		puc == (unsigned long) &sf->uc;
+}
+
+static void perf_callchain_user_64(struct pt_regs *regs,
+				   struct perf_callchain_entry *entry)
+{
+	unsigned long sp, next_sp;
+	unsigned long next_ip;
+	unsigned long lr;
+	long level = 0;
+	struct signal_frame_64 __user *sigframe;
+	unsigned long __user *fp, *uregs;
+
+	next_ip = regs->nip;
+	lr = regs->link;
+	sp = regs->gpr[1];
+	callchain_store(entry, PERF_CONTEXT_USER);
+	callchain_store(entry, next_ip);
+
+	for (;;) {
+		fp = (unsigned long __user *) sp;
+		if (!valid_user_sp(sp, 1) || read_user_stack_64(fp, &next_sp))
+			return;
+		if (level > 0 && read_user_stack_64(&fp[2], &next_ip))
+			return;
+
+		/*
+		 * Note: the next_sp - sp >= signal frame size check
+		 * is true when next_sp < sp, which can happen when
+		 * transitioning from an alternate signal stack to the
+		 * normal stack.
+		 */
+		if (next_sp - sp >= sizeof(struct signal_frame_64) &&
+		    (is_sigreturn_64_address(next_ip, sp) ||
+		     (level <= 1 && is_sigreturn_64_address(lr, sp))) &&
+		    sane_signal_64_frame(sp)) {
+			/*
+			 * This looks like an signal frame
+			 */
+			sigframe = (struct signal_frame_64 __user *) sp;
+			uregs = sigframe->uc.uc_mcontext.gp_regs;
+			if (read_user_stack_64(&uregs[PT_NIP], &next_ip) ||
+			    read_user_stack_64(&uregs[PT_LNK], &lr) ||
+			    read_user_stack_64(&uregs[PT_R1], &sp))
+				return;
+			level = 0;
+			callchain_store(entry, PERF_CONTEXT_USER);
+			callchain_store(entry, next_ip);
+			continue;
+		}
+
+		if (level == 0)
+			next_ip = lr;
+		callchain_store(entry, next_ip);
+		++level;
+		sp = next_sp;
+	}
+}
+
+static inline int current_is_64bit(void)
+{
+	/*
+	 * We can't use test_thread_flag() here because we may be on an
+	 * interrupt stack, and the thread flags don't get copied over
+	 * from the thread_info on the main stack to the interrupt stack.
+	 */
+	return !test_ti_thread_flag(task_thread_info(current), TIF_32BIT);
+}
+
+#else  /* CONFIG_PPC64 */
+/*
+ * On 32-bit we just access the address and let hash_page create a
+ * HPTE if necessary, so there is no need to fall back to reading
+ * the page tables.  Since this is called at interrupt level,
+ * do_page_fault() won't treat a DSI as a page fault.
+ */
+static int read_user_stack_32(unsigned int __user *ptr, unsigned int *ret)
+{
+	if ((unsigned long)ptr > TASK_SIZE - sizeof(unsigned int) ||
+	    ((unsigned long)ptr & 3))
+		return -EFAULT;
+
+	return __get_user_inatomic(*ret, ptr);
+}
+
+static inline void perf_callchain_user_64(struct pt_regs *regs,
+					  struct perf_callchain_entry *entry)
+{
+}
+
+static inline int current_is_64bit(void)
+{
+	return 0;
+}
+
+static inline int valid_user_sp(unsigned long sp, int is_64)
+{
+	if (!sp || (sp & 7) || sp > TASK_SIZE - 32)
+		return 0;
+	return 1;
+}
+
+#define __SIGNAL_FRAMESIZE32	__SIGNAL_FRAMESIZE
+#define sigcontext32		sigcontext
+#define mcontext32		mcontext
+#define ucontext32		ucontext
+#define compat_siginfo_t	struct siginfo
+
+#endif /* CONFIG_PPC64 */
+
+/*
+ * Layout for non-RT signal frames
+ */
+struct signal_frame_32 {
+	char			dummy[__SIGNAL_FRAMESIZE32];
+	struct sigcontext32	sctx;
+	struct mcontext32	mctx;
+	int			abigap[56];
+};
+
+/*
+ * Layout for RT signal frames
+ */
+struct rt_signal_frame_32 {
+	char			dummy[__SIGNAL_FRAMESIZE32 + 16];
+	compat_siginfo_t	info;
+	struct ucontext32	uc;
+	int			abigap[56];
+};
+
+static int is_sigreturn_32_address(unsigned int nip, unsigned int fp)
+{
+	if (nip == fp + offsetof(struct signal_frame_32, mctx.mc_pad))
+		return 1;
+	if (vdso32_sigtramp && current->mm->context.vdso_base &&
+	    nip == current->mm->context.vdso_base + vdso32_sigtramp)
+		return 1;
+	return 0;
+}
+
+static int is_rt_sigreturn_32_address(unsigned int nip, unsigned int fp)
+{
+	if (nip == fp + offsetof(struct rt_signal_frame_32,
+				 uc.uc_mcontext.mc_pad))
+		return 1;
+	if (vdso32_rt_sigtramp && current->mm->context.vdso_base &&
+	    nip == current->mm->context.vdso_base + vdso32_rt_sigtramp)
+		return 1;
+	return 0;
+}
+
+static int sane_signal_32_frame(unsigned int sp)
+{
+	struct signal_frame_32 __user *sf;
+	unsigned int regs;
+
+	sf = (struct signal_frame_32 __user *) (unsigned long) sp;
+	if (read_user_stack_32((unsigned int __user *) &sf->sctx.regs, &regs))
+		return 0;
+	return regs == (unsigned long) &sf->mctx;
+}
+
+static int sane_rt_signal_32_frame(unsigned int sp)
+{
+	struct rt_signal_frame_32 __user *sf;
+	unsigned int regs;
+
+	sf = (struct rt_signal_frame_32 __user *) (unsigned long) sp;
+	if (read_user_stack_32((unsigned int __user *) &sf->uc.uc_regs, &regs))
+		return 0;
+	return regs == (unsigned long) &sf->uc.uc_mcontext;
+}
+
+static unsigned int __user *signal_frame_32_regs(unsigned int sp,
+				unsigned int next_sp, unsigned int next_ip)
+{
+	struct mcontext32 __user *mctx = NULL;
+	struct signal_frame_32 __user *sf;
+	struct rt_signal_frame_32 __user *rt_sf;
+
+	/*
+	 * Note: the next_sp - sp >= signal frame size check
+	 * is true when next_sp < sp, for example, when
+	 * transitioning from an alternate signal stack to the
+	 * normal stack.
+	 */
+	if (next_sp - sp >= sizeof(struct signal_frame_32) &&
+	    is_sigreturn_32_address(next_ip, sp) &&
+	    sane_signal_32_frame(sp)) {
+		sf = (struct signal_frame_32 __user *) (unsigned long) sp;
+		mctx = &sf->mctx;
+	}
+
+	if (!mctx && next_sp - sp >= sizeof(struct rt_signal_frame_32) &&
+	    is_rt_sigreturn_32_address(next_ip, sp) &&
+	    sane_rt_signal_32_frame(sp)) {
+		rt_sf = (struct rt_signal_frame_32 __user *) (unsigned long) sp;
+		mctx = &rt_sf->uc.uc_mcontext;
+	}
+
+	if (!mctx)
+		return NULL;
+	return mctx->mc_gregs;
+}
+
+static void perf_callchain_user_32(struct pt_regs *regs,
+				   struct perf_callchain_entry *entry)
+{
+	unsigned int sp, next_sp;
+	unsigned int next_ip;
+	unsigned int lr;
+	long level = 0;
+	unsigned int __user *fp, *uregs;
+
+	next_ip = regs->nip;
+	lr = regs->link;
+	sp = regs->gpr[1];
+	callchain_store(entry, PERF_CONTEXT_USER);
+	callchain_store(entry, next_ip);
+
+	while (entry->nr < PERF_MAX_STACK_DEPTH) {
+		fp = (unsigned int __user *) (unsigned long) sp;
+		if (!valid_user_sp(sp, 0) || read_user_stack_32(fp, &next_sp))
+			return;
+		if (level > 0 && read_user_stack_32(&fp[1], &next_ip))
+			return;
+
+		uregs = signal_frame_32_regs(sp, next_sp, next_ip);
+		if (!uregs && level <= 1)
+			uregs = signal_frame_32_regs(sp, next_sp, lr);
+		if (uregs) {
+			/*
+			 * This looks like an signal frame, so restart
+			 * the stack trace with the values in it.
+			 */
+			if (read_user_stack_32(&uregs[PT_NIP], &next_ip) ||
+			    read_user_stack_32(&uregs[PT_LNK], &lr) ||
+			    read_user_stack_32(&uregs[PT_R1], &sp))
+				return;
+			level = 0;
+			callchain_store(entry, PERF_CONTEXT_USER);
+			callchain_store(entry, next_ip);
+			continue;
+		}
+
+		if (level == 0)
+			next_ip = lr;
+		callchain_store(entry, next_ip);
+		++level;
+		sp = next_sp;
+	}
+}
+
+/*
+ * Since we can't get PMU interrupts inside a PMU interrupt handler,
+ * we don't need separate irq and nmi entries here.
+ */
+static DEFINE_PER_CPU(struct perf_callchain_entry, callchain);
+
+struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
+{
+	struct perf_callchain_entry *entry = &__get_cpu_var(callchain);
+
+	entry->nr = 0;
+
+	if (current->pid == 0)		/* idle task? */
+		return entry;
+
+	if (!user_mode(regs)) {
+		perf_callchain_kernel(regs, entry);
+		if (current->mm)
+			regs = task_pt_regs(current);
+		else
+			regs = NULL;
+	}
+
+	if (regs) {
+		if (current_is_64bit())
+			perf_callchain_user_64(regs, entry);
+		else
+			perf_callchain_user_32(regs, entry);
+	}
+
+	return entry;
+}
diff --git a/arch/powerpc/mm/slb.c b/arch/powerpc/mm/slb.c
index 5b7038f..a685652 100644
--- a/arch/powerpc/mm/slb.c
+++ b/arch/powerpc/mm/slb.c
@@ -92,15 +92,13 @@ static inline void create_shadowed_slbe(unsigned long ea, int ssize,
 		     : "memory" );
 }
 
-void slb_flush_and_rebolt(void)
+static void __slb_flush_and_rebolt(void)
 {
 	/* If you change this make sure you change SLB_NUM_BOLTED
 	 * appropriately too. */
 	unsigned long linear_llp, vmalloc_llp, lflags, vflags;
 	unsigned long ksp_esid_data, ksp_vsid_data;
 
-	WARN_ON(!irqs_disabled());
-
 	linear_llp = mmu_psize_defs[mmu_linear_psize].sllp;
 	vmalloc_llp = mmu_psize_defs[mmu_vmalloc_psize].sllp;
 	lflags = SLB_VSID_KERNEL | linear_llp;
@@ -117,12 +115,6 @@ void slb_flush_and_rebolt(void)
 		ksp_vsid_data = get_slb_shadow()->save_area[2].vsid;
 	}
 
-	/*
-	 * We can't take a PMU exception in the following code, so hard
-	 * disable interrupts.
-	 */
-	hard_irq_disable();
-
 	/* We need to do this all in asm, so we're sure we don't touch
 	 * the stack between the slbia and rebolting it. */
 	asm volatile("isync\n"
@@ -139,6 +131,21 @@ void slb_flush_and_rebolt(void)
 		     : "memory");
 }
 
+void slb_flush_and_rebolt(void)
+{
+
+	WARN_ON(!irqs_disabled());
+
+	/*
+	 * We can't take a PMU exception in the following code, so hard
+	 * disable interrupts.
+	 */
+	hard_irq_disable();
+
+	__slb_flush_and_rebolt();
+	get_paca()->slb_cache_ptr = 0;
+}
+
 void slb_vmalloc_update(void)
 {
 	unsigned long vflags;
@@ -180,12 +187,20 @@ static inline int esids_match(unsigned long addr1, unsigned long addr2)
 /* Flush all user entries from the segment table of the current processor. */
 void switch_slb(struct task_struct *tsk, struct mm_struct *mm)
 {
-	unsigned long offset = get_paca()->slb_cache_ptr;
+	unsigned long offset;
 	unsigned long slbie_data = 0;
 	unsigned long pc = KSTK_EIP(tsk);
 	unsigned long stack = KSTK_ESP(tsk);
 	unsigned long unmapped_base;
 
+	/*
+	 * We need interrupts hard-disabled here, not just soft-disabled,
+	 * so that a PMU interrupt can't occur, which might try to access
+	 * user memory (to get a stack trace) and possible cause an SLB miss
+	 * which would update the slb_cache/slb_cache_ptr fields in the PACA.
+	 */
+	hard_irq_disable();
+	offset = get_paca()->slb_cache_ptr;
 	if (!cpu_has_feature(CPU_FTR_NO_SLBIE_B) &&
 	    offset <= SLB_CACHE_ENTRIES) {
 		int i;
@@ -200,7 +215,7 @@ void switch_slb(struct task_struct *tsk, struct mm_struct *mm)
 		}
 		asm volatile("isync" : : : "memory");
 	} else {
-		slb_flush_and_rebolt();
+		__slb_flush_and_rebolt();
 	}
 
 	/* Workaround POWER5 < DD2.1 issue */
diff --git a/arch/powerpc/mm/stab.c b/arch/powerpc/mm/stab.c
index 98cd1dc..ab5fb48 100644
--- a/arch/powerpc/mm/stab.c
+++ b/arch/powerpc/mm/stab.c
@@ -164,7 +164,7 @@ void switch_stab(struct task_struct *tsk, struct mm_struct *mm)
 {
 	struct stab_entry *stab = (struct stab_entry *) get_paca()->stab_addr;
 	struct stab_entry *ste;
-	unsigned long offset = __get_cpu_var(stab_cache_ptr);
+	unsigned long offset;
 	unsigned long pc = KSTK_EIP(tsk);
 	unsigned long stack = KSTK_ESP(tsk);
 	unsigned long unmapped_base;
@@ -172,6 +172,15 @@ void switch_stab(struct task_struct *tsk, struct mm_struct *mm)
 	/* Force previous translations to complete. DRENG */
 	asm volatile("isync" : : : "memory");
 
+	/*
+	 * We need interrupts hard-disabled here, not just soft-disabled,
+	 * so that a PMU interrupt can't occur, which might try to access
+	 * user memory (to get a stack trace) and possible cause an STAB miss
+	 * which would update the stab_cache/stab_cache_ptr per-cpu variables.
+	 */
+	hard_irq_disable();
+
+	offset = __get_cpu_var(stab_cache_ptr);
 	if (offset <= NR_STAB_CACHE_ENTRIES) {
 		int i;
 
diff --git a/arch/x86/include/asm/perf_counter.h b/arch/x86/include/asm/perf_counter.h
index fa64e40..e7b7c93 100644
--- a/arch/x86/include/asm/perf_counter.h
+++ b/arch/x86/include/asm/perf_counter.h
@@ -84,6 +84,16 @@ union cpuid10_edx {
 #define MSR_ARCH_PERFMON_FIXED_CTR2			0x30b
 #define X86_PMC_IDX_FIXED_BUS_CYCLES			(X86_PMC_IDX_FIXED + 2)
 
+/*
+ * We model BTS tracing as another fixed-mode PMC.
+ *
+ * We choose a value in the middle of the fixed counter range, since lower
+ * values are used by actual fixed counters and higher values are used
+ * to indicate other overflow conditions in the PERF_GLOBAL_STATUS msr.
+ */
+#define X86_PMC_IDX_FIXED_BTS				(X86_PMC_IDX_FIXED + 16)
+
+
 #ifdef CONFIG_PERF_COUNTERS
 extern void init_hw_perf_counters(void);
 extern void perf_counters_lapic_init(void);
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 900332b..f9cd084 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -6,6 +6,7 @@
  *  Copyright (C) 2009 Jaswinder Singh Rajput
  *  Copyright (C) 2009 Advanced Micro Devices, Inc., Robert Richter
  *  Copyright (C) 2008-2009 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *  Copyright (C) 2009 Intel Corporation, <markus.t.metzger@intel.com>
  *
  *  For licencing details see kernel-base/COPYING
  */
@@ -20,6 +21,7 @@
 #include <linux/sched.h>
 #include <linux/uaccess.h>
 #include <linux/highmem.h>
+#include <linux/cpu.h>
 
 #include <asm/apic.h>
 #include <asm/stacktrace.h>
@@ -27,12 +29,52 @@
 
 static u64 perf_counter_mask __read_mostly;
 
+/* The maximal number of PEBS counters: */
+#define MAX_PEBS_COUNTERS	4
+
+/* The size of a BTS record in bytes: */
+#define BTS_RECORD_SIZE		24
+
+/* The size of a per-cpu BTS buffer in bytes: */
+#define BTS_BUFFER_SIZE		(BTS_RECORD_SIZE * 1024)
+
+/* The BTS overflow threshold in bytes from the end of the buffer: */
+#define BTS_OVFL_TH		(BTS_RECORD_SIZE * 64)
+
+
+/*
+ * Bits in the debugctlmsr controlling branch tracing.
+ */
+#define X86_DEBUGCTL_TR			(1 << 6)
+#define X86_DEBUGCTL_BTS		(1 << 7)
+#define X86_DEBUGCTL_BTINT		(1 << 8)
+#define X86_DEBUGCTL_BTS_OFF_OS		(1 << 9)
+#define X86_DEBUGCTL_BTS_OFF_USR	(1 << 10)
+
+/*
+ * A debug store configuration.
+ *
+ * We only support architectures that use 64bit fields.
+ */
+struct debug_store {
+	u64	bts_buffer_base;
+	u64	bts_index;
+	u64	bts_absolute_maximum;
+	u64	bts_interrupt_threshold;
+	u64	pebs_buffer_base;
+	u64	pebs_index;
+	u64	pebs_absolute_maximum;
+	u64	pebs_interrupt_threshold;
+	u64	pebs_counter_reset[MAX_PEBS_COUNTERS];
+};
+
 struct cpu_hw_counters {
 	struct perf_counter	*counters[X86_PMC_IDX_MAX];
 	unsigned long		used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	unsigned long		active_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	unsigned long		interrupts;
 	int			enabled;
+	struct debug_store	*ds;
 };
 
 /*
@@ -58,6 +100,8 @@ struct x86_pmu {
 	int		apic;
 	u64		max_period;
 	u64		intel_ctrl;
+	void		(*enable_bts)(u64 config);
+	void		(*disable_bts)(void);
 };
 
 static struct x86_pmu x86_pmu __read_mostly;
@@ -577,6 +621,9 @@ x86_perf_counter_update(struct perf_counter *counter,
 	u64 prev_raw_count, new_raw_count;
 	s64 delta;
 
+	if (idx == X86_PMC_IDX_FIXED_BTS)
+		return 0;
+
 	/*
 	 * Careful: an NMI might modify the previous counter value.
 	 *
@@ -666,10 +713,110 @@ static void release_pmc_hardware(void)
 #endif
 }
 
+static inline bool bts_available(void)
+{
+	return x86_pmu.enable_bts != NULL;
+}
+
+static inline void init_debug_store_on_cpu(int cpu)
+{
+	struct debug_store *ds = per_cpu(cpu_hw_counters, cpu).ds;
+
+	if (!ds)
+		return;
+
+	wrmsr_on_cpu(cpu, MSR_IA32_DS_AREA,
+		     (u32)((u64)(unsigned long)ds),
+		     (u32)((u64)(unsigned long)ds >> 32));
+}
+
+static inline void fini_debug_store_on_cpu(int cpu)
+{
+	if (!per_cpu(cpu_hw_counters, cpu).ds)
+		return;
+
+	wrmsr_on_cpu(cpu, MSR_IA32_DS_AREA, 0, 0);
+}
+
+static void release_bts_hardware(void)
+{
+	int cpu;
+
+	if (!bts_available())
+		return;
+
+	get_online_cpus();
+
+	for_each_online_cpu(cpu)
+		fini_debug_store_on_cpu(cpu);
+
+	for_each_possible_cpu(cpu) {
+		struct debug_store *ds = per_cpu(cpu_hw_counters, cpu).ds;
+
+		if (!ds)
+			continue;
+
+		per_cpu(cpu_hw_counters, cpu).ds = NULL;
+
+		kfree((void *)(unsigned long)ds->bts_buffer_base);
+		kfree(ds);
+	}
+
+	put_online_cpus();
+}
+
+static int reserve_bts_hardware(void)
+{
+	int cpu, err = 0;
+
+	if (!bts_available())
+		return 0;
+
+	get_online_cpus();
+
+	for_each_possible_cpu(cpu) {
+		struct debug_store *ds;
+		void *buffer;
+
+		err = -ENOMEM;
+		buffer = kzalloc(BTS_BUFFER_SIZE, GFP_KERNEL);
+		if (unlikely(!buffer))
+			break;
+
+		ds = kzalloc(sizeof(*ds), GFP_KERNEL);
+		if (unlikely(!ds)) {
+			kfree(buffer);
+			break;
+		}
+
+		ds->bts_buffer_base = (u64)(unsigned long)buffer;
+		ds->bts_index = ds->bts_buffer_base;
+		ds->bts_absolute_maximum =
+			ds->bts_buffer_base + BTS_BUFFER_SIZE;
+		ds->bts_interrupt_threshold =
+			ds->bts_absolute_maximum - BTS_OVFL_TH;
+
+		per_cpu(cpu_hw_counters, cpu).ds = ds;
+		err = 0;
+	}
+
+	if (err)
+		release_bts_hardware();
+	else {
+		for_each_online_cpu(cpu)
+			init_debug_store_on_cpu(cpu);
+	}
+
+	put_online_cpus();
+
+	return err;
+}
+
 static void hw_perf_counter_destroy(struct perf_counter *counter)
 {
 	if (atomic_dec_and_mutex_lock(&active_counters, &pmc_reserve_mutex)) {
 		release_pmc_hardware();
+		release_bts_hardware();
 		mutex_unlock(&pmc_reserve_mutex);
 	}
 }
@@ -712,6 +859,42 @@ set_ext_hw_attr(struct hw_perf_counter *hwc, struct perf_counter_attr *attr)
 	return 0;
 }
 
+static void intel_pmu_enable_bts(u64 config)
+{
+	unsigned long debugctlmsr;
+
+	debugctlmsr = get_debugctlmsr();
+
+	debugctlmsr |= X86_DEBUGCTL_TR;
+	debugctlmsr |= X86_DEBUGCTL_BTS;
+	debugctlmsr |= X86_DEBUGCTL_BTINT;
+
+	if (!(config & ARCH_PERFMON_EVENTSEL_OS))
+		debugctlmsr |= X86_DEBUGCTL_BTS_OFF_OS;
+
+	if (!(config & ARCH_PERFMON_EVENTSEL_USR))
+		debugctlmsr |= X86_DEBUGCTL_BTS_OFF_USR;
+
+	update_debugctlmsr(debugctlmsr);
+}
+
+static void intel_pmu_disable_bts(void)
+{
+	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
+	unsigned long debugctlmsr;
+
+	if (!cpuc->ds)
+		return;
+
+	debugctlmsr = get_debugctlmsr();
+
+	debugctlmsr &=
+		~(X86_DEBUGCTL_TR | X86_DEBUGCTL_BTS | X86_DEBUGCTL_BTINT |
+		  X86_DEBUGCTL_BTS_OFF_OS | X86_DEBUGCTL_BTS_OFF_USR);
+
+	update_debugctlmsr(debugctlmsr);
+}
+
 /*
  * Setup the hardware configuration for a given attr_type
  */
@@ -728,9 +911,13 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	err = 0;
 	if (!atomic_inc_not_zero(&active_counters)) {
 		mutex_lock(&pmc_reserve_mutex);
-		if (atomic_read(&active_counters) == 0 && !reserve_pmc_hardware())
-			err = -EBUSY;
-		else
+		if (atomic_read(&active_counters) == 0) {
+			if (!reserve_pmc_hardware())
+				err = -EBUSY;
+			else
+				err = reserve_bts_hardware();
+		}
+		if (!err)
 			atomic_inc(&active_counters);
 		mutex_unlock(&pmc_reserve_mutex);
 	}
@@ -793,6 +980,20 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	if (config == -1LL)
 		return -EINVAL;
 
+	/*
+	 * Branch tracing:
+	 */
+	if ((attr->config == PERF_COUNT_HW_BRANCH_INSTRUCTIONS) &&
+	    (hwc->sample_period == 1)) {
+		/* BTS is not supported by this architecture. */
+		if (!bts_available())
+			return -EOPNOTSUPP;
+
+		/* BTS is currently only allowed for user-mode. */
+		if (hwc->config & ARCH_PERFMON_EVENTSEL_OS)
+			return -EOPNOTSUPP;
+	}
+
 	hwc->config |= config;
 
 	return 0;
@@ -817,7 +1018,18 @@ static void p6_pmu_disable_all(void)
 
 static void intel_pmu_disable_all(void)
 {
+	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
+
+	if (!cpuc->enabled)
+		return;
+
+	cpuc->enabled = 0;
+	barrier();
+
 	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+
+	if (test_bit(X86_PMC_IDX_FIXED_BTS, cpuc->active_mask))
+		intel_pmu_disable_bts();
 }
 
 static void amd_pmu_disable_all(void)
@@ -875,7 +1087,25 @@ static void p6_pmu_enable_all(void)
 
 static void intel_pmu_enable_all(void)
 {
+	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
+
+	if (cpuc->enabled)
+		return;
+
+	cpuc->enabled = 1;
+	barrier();
+
 	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, x86_pmu.intel_ctrl);
+
+	if (test_bit(X86_PMC_IDX_FIXED_BTS, cpuc->active_mask)) {
+		struct perf_counter *counter =
+			cpuc->counters[X86_PMC_IDX_FIXED_BTS];
+
+		if (WARN_ON_ONCE(!counter))
+			return;
+
+		intel_pmu_enable_bts(counter->hw.config);
+	}
 }
 
 static void amd_pmu_enable_all(void)
@@ -962,6 +1192,11 @@ p6_pmu_disable_counter(struct hw_perf_counter *hwc, int idx)
 static inline void
 intel_pmu_disable_counter(struct hw_perf_counter *hwc, int idx)
 {
+	if (unlikely(idx == X86_PMC_IDX_FIXED_BTS)) {
+		intel_pmu_disable_bts();
+		return;
+	}
+
 	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL)) {
 		intel_pmu_disable_fixed(hwc, idx);
 		return;
@@ -990,6 +1225,9 @@ x86_perf_counter_set_period(struct perf_counter *counter,
 	s64 period = hwc->sample_period;
 	int err, ret = 0;
 
+	if (idx == X86_PMC_IDX_FIXED_BTS)
+		return 0;
+
 	/*
 	 * If we are way outside a reasoable range then just skip forward:
 	 */
@@ -1072,6 +1310,14 @@ static void p6_pmu_enable_counter(struct hw_perf_counter *hwc, int idx)
 
 static void intel_pmu_enable_counter(struct hw_perf_counter *hwc, int idx)
 {
+	if (unlikely(idx == X86_PMC_IDX_FIXED_BTS)) {
+		if (!__get_cpu_var(cpu_hw_counters).enabled)
+			return;
+
+		intel_pmu_enable_bts(hwc->config);
+		return;
+	}
+
 	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL)) {
 		intel_pmu_enable_fixed(hwc, idx);
 		return;
@@ -1093,11 +1339,16 @@ fixed_mode_idx(struct perf_counter *counter, struct hw_perf_counter *hwc)
 {
 	unsigned int event;
 
+	event = hwc->config & ARCH_PERFMON_EVENT_MASK;
+
+	if (unlikely((event ==
+		      x86_pmu.event_map(PERF_COUNT_HW_BRANCH_INSTRUCTIONS)) &&
+		     (hwc->sample_period == 1)))
+		return X86_PMC_IDX_FIXED_BTS;
+
 	if (!x86_pmu.num_counters_fixed)
 		return -1;
 
-	event = hwc->config & ARCH_PERFMON_EVENT_MASK;
-
 	if (unlikely(event == x86_pmu.event_map(PERF_COUNT_HW_INSTRUCTIONS)))
 		return X86_PMC_IDX_FIXED_INSTRUCTIONS;
 	if (unlikely(event == x86_pmu.event_map(PERF_COUNT_HW_CPU_CYCLES)))
@@ -1118,7 +1369,15 @@ static int x86_pmu_enable(struct perf_counter *counter)
 	int idx;
 
 	idx = fixed_mode_idx(counter, hwc);
-	if (idx >= 0) {
+	if (idx == X86_PMC_IDX_FIXED_BTS) {
+		/* BTS is already occupied. */
+		if (test_and_set_bit(idx, cpuc->used_mask))
+			return -EAGAIN;
+
+		hwc->config_base	= 0;
+		hwc->counter_base	= 0;
+		hwc->idx		= idx;
+	} else if (idx >= 0) {
 		/*
 		 * Try to get the fixed counter, if that is already taken
 		 * then try to get a generic counter:
@@ -1229,6 +1488,44 @@ void perf_counter_print_debug(void)
 	local_irq_restore(flags);
 }
 
+static void intel_pmu_drain_bts_buffer(struct cpu_hw_counters *cpuc,
+				       struct perf_sample_data *data)
+{
+	struct debug_store *ds = cpuc->ds;
+	struct bts_record {
+		u64	from;
+		u64	to;
+		u64	flags;
+	};
+	struct perf_counter *counter = cpuc->counters[X86_PMC_IDX_FIXED_BTS];
+	unsigned long orig_ip = data->regs->ip;
+	struct bts_record *at, *top;
+
+	if (!counter)
+		return;
+
+	if (!ds)
+		return;
+
+	at  = (struct bts_record *)(unsigned long)ds->bts_buffer_base;
+	top = (struct bts_record *)(unsigned long)ds->bts_index;
+
+	ds->bts_index = ds->bts_buffer_base;
+
+	for (; at < top; at++) {
+		data->regs->ip	= at->from;
+		data->addr	= at->to;
+
+		perf_counter_output(counter, 1, data);
+	}
+
+	data->regs->ip	= orig_ip;
+	data->addr	= 0;
+
+	/* There's new data available. */
+	counter->pending_kill = POLL_IN;
+}
+
 static void x86_pmu_disable(struct perf_counter *counter)
 {
 	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
@@ -1253,6 +1550,15 @@ static void x86_pmu_disable(struct perf_counter *counter)
 	 * that we are disabling:
 	 */
 	x86_perf_counter_update(counter, hwc, idx);
+
+	/* Drain the remaining BTS records. */
+	if (unlikely(idx == X86_PMC_IDX_FIXED_BTS)) {
+		struct perf_sample_data data;
+		struct pt_regs regs;
+
+		data.regs = &regs;
+		intel_pmu_drain_bts_buffer(cpuc, &data);
+	}
 	cpuc->counters[idx] = NULL;
 	clear_bit(idx, cpuc->used_mask);
 
@@ -1280,6 +1586,7 @@ static int intel_pmu_save_and_restart(struct perf_counter *counter)
 
 static void intel_pmu_reset(void)
 {
+	struct debug_store *ds = __get_cpu_var(cpu_hw_counters).ds;
 	unsigned long flags;
 	int idx;
 
@@ -1297,6 +1604,8 @@ static void intel_pmu_reset(void)
 	for (idx = 0; idx < x86_pmu.num_counters_fixed; idx++) {
 		checking_wrmsrl(MSR_ARCH_PERFMON_FIXED_CTR0 + idx, 0ull);
 	}
+	if (ds)
+		ds->bts_index = ds->bts_buffer_base;
 
 	local_irq_restore(flags);
 }
@@ -1362,6 +1671,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 	cpuc = &__get_cpu_var(cpu_hw_counters);
 
 	perf_disable();
+	intel_pmu_drain_bts_buffer(cpuc, &data);
 	status = intel_pmu_get_status();
 	if (!status) {
 		perf_enable();
@@ -1571,6 +1881,8 @@ static struct x86_pmu intel_pmu = {
 	 * the generic counter period:
 	 */
 	.max_period		= (1ULL << 31) - 1,
+	.enable_bts		= intel_pmu_enable_bts,
+	.disable_bts		= intel_pmu_disable_bts,
 };
 
 static struct x86_pmu amd_pmu = {
@@ -1962,3 +2274,8 @@ struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 
 	return entry;
 }
+
+void hw_perf_counter_setup_online(int cpu)
+{
+	init_debug_store_on_cpu(cpu);
+}
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index b53f700..e022b84 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -216,6 +216,7 @@ struct perf_counter_attr {
 #define PERF_COUNTER_IOC_REFRESH	_IO ('$', 2)
 #define PERF_COUNTER_IOC_RESET		_IO ('$', 3)
 #define PERF_COUNTER_IOC_PERIOD		_IOW('$', 4, u64)
+#define PERF_COUNTER_IOC_SET_OUTPUT	_IO ('$', 5)
 
 enum perf_counter_ioc_flags {
 	PERF_IOC_FLAG_GROUP		= 1U << 0,
@@ -415,6 +416,9 @@ enum perf_callchain_context {
 	PERF_CONTEXT_MAX		= (__u64)-4095,
 };
 
+#define PERF_FLAG_FD_NO_GROUP	(1U << 0)
+#define PERF_FLAG_FD_OUTPUT	(1U << 1)
+
 #ifdef __KERNEL__
 /*
  * Kernel-internal data types and definitions:
@@ -536,6 +540,7 @@ struct perf_counter {
 	struct list_head		sibling_list;
 	int				nr_siblings;
 	struct perf_counter		*group_leader;
+	struct perf_counter		*output;
 	const struct pmu		*pmu;
 
 	enum perf_counter_active_state	state;
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index d7cbc57..e0d91fd 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -46,12 +46,18 @@ static atomic_t nr_task_counters __read_mostly;
 
 /*
  * perf counter paranoia level:
- *  0 - not paranoid
- *  1 - disallow cpu counters to unpriv
- *  2 - disallow kernel profiling to unpriv
+ *  -1 - not paranoid at all
+ *   0 - disallow raw tracepoint access for unpriv
+ *   1 - disallow cpu counters for unpriv
+ *   2 - disallow kernel profiling for unpriv
  */
 int sysctl_perf_counter_paranoid __read_mostly = 1;
 
+static inline bool perf_paranoid_tracepoint_raw(void)
+{
+	return sysctl_perf_counter_paranoid > -1;
+}
+
 static inline bool perf_paranoid_cpu(void)
 {
 	return sysctl_perf_counter_paranoid > 0;
@@ -469,7 +475,8 @@ static void update_counter_times(struct perf_counter *counter)
 	struct perf_counter_context *ctx = counter->ctx;
 	u64 run_end;
 
-	if (counter->state < PERF_COUNTER_STATE_INACTIVE)
+	if (counter->state < PERF_COUNTER_STATE_INACTIVE ||
+	    counter->group_leader->state < PERF_COUNTER_STATE_INACTIVE)
 		return;
 
 	counter->total_time_enabled = ctx->time - counter->tstamp_enabled;
@@ -518,7 +525,7 @@ static void __perf_counter_disable(void *info)
 	 */
 	if (counter->state >= PERF_COUNTER_STATE_INACTIVE) {
 		update_context_time(ctx);
-		update_counter_times(counter);
+		update_group_times(counter);
 		if (counter == counter->group_leader)
 			group_sched_out(counter, cpuctx, ctx);
 		else
@@ -573,7 +580,7 @@ static void perf_counter_disable(struct perf_counter *counter)
 	 * in, so we can change the state safely.
 	 */
 	if (counter->state == PERF_COUNTER_STATE_INACTIVE) {
-		update_counter_times(counter);
+		update_group_times(counter);
 		counter->state = PERF_COUNTER_STATE_OFF;
 	}
 
@@ -851,6 +858,27 @@ retry:
 }
 
 /*
+ * Put a counter into inactive state and update time fields.
+ * Enabling the leader of a group effectively enables all
+ * the group members that aren't explicitly disabled, so we
+ * have to update their ->tstamp_enabled also.
+ * Note: this works for group members as well as group leaders
+ * since the non-leader members' sibling_lists will be empty.
+ */
+static void __perf_counter_mark_enabled(struct perf_counter *counter,
+					struct perf_counter_context *ctx)
+{
+	struct perf_counter *sub;
+
+	counter->state = PERF_COUNTER_STATE_INACTIVE;
+	counter->tstamp_enabled = ctx->time - counter->total_time_enabled;
+	list_for_each_entry(sub, &counter->sibling_list, list_entry)
+		if (sub->state >= PERF_COUNTER_STATE_INACTIVE)
+			sub->tstamp_enabled =
+				ctx->time - sub->total_time_enabled;
+}
+
+/*
  * Cross CPU call to enable a performance counter
  */
 static void __perf_counter_enable(void *info)
@@ -877,8 +905,7 @@ static void __perf_counter_enable(void *info)
 
 	if (counter->state >= PERF_COUNTER_STATE_INACTIVE)
 		goto unlock;
-	counter->state = PERF_COUNTER_STATE_INACTIVE;
-	counter->tstamp_enabled = ctx->time - counter->total_time_enabled;
+	__perf_counter_mark_enabled(counter, ctx);
 
 	/*
 	 * If the counter is in a group and isn't the group leader,
@@ -971,11 +998,9 @@ static void perf_counter_enable(struct perf_counter *counter)
 	 * Since we have the lock this context can't be scheduled
 	 * in, so we can change the state safely.
 	 */
-	if (counter->state == PERF_COUNTER_STATE_OFF) {
-		counter->state = PERF_COUNTER_STATE_INACTIVE;
-		counter->tstamp_enabled =
-			ctx->time - counter->total_time_enabled;
-	}
+	if (counter->state == PERF_COUNTER_STATE_OFF)
+		__perf_counter_mark_enabled(counter, ctx);
+
  out:
 	spin_unlock_irq(&ctx->lock);
 }
@@ -1479,9 +1504,7 @@ static void perf_counter_enable_on_exec(struct task_struct *task)
 		counter->attr.enable_on_exec = 0;
 		if (counter->state >= PERF_COUNTER_STATE_INACTIVE)
 			continue;
-		counter->state = PERF_COUNTER_STATE_INACTIVE;
-		counter->tstamp_enabled =
-			ctx->time - counter->total_time_enabled;
+		__perf_counter_mark_enabled(counter, ctx);
 		enabled = 1;
 	}
 
@@ -1675,6 +1698,11 @@ static void free_counter(struct perf_counter *counter)
 			atomic_dec(&nr_task_counters);
 	}
 
+	if (counter->output) {
+		fput(counter->output->filp);
+		counter->output = NULL;
+	}
+
 	if (counter->destroy)
 		counter->destroy(counter);
 
@@ -1960,6 +1988,8 @@ unlock:
 	return ret;
 }
 
+int perf_counter_set_output(struct perf_counter *counter, int output_fd);
+
 static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct perf_counter *counter = file->private_data;
@@ -1983,6 +2013,9 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case PERF_COUNTER_IOC_PERIOD:
 		return perf_counter_period(counter, (u64 __user *)arg);
 
+	case PERF_COUNTER_IOC_SET_OUTPUT:
+		return perf_counter_set_output(counter, arg);
+
 	default:
 		return -ENOTTY;
 	}
@@ -2253,6 +2286,11 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 
 	WARN_ON_ONCE(counter->ctx->parent_ctx);
 	mutex_lock(&counter->mmap_mutex);
+	if (counter->output) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
 	if (atomic_inc_not_zero(&counter->mmap_count)) {
 		if (nr_pages != counter->data->nr_pages)
 			ret = -EINVAL;
@@ -2638,6 +2676,7 @@ static int perf_output_begin(struct perf_output_handle *handle,
 			     struct perf_counter *counter, unsigned int size,
 			     int nmi, int sample)
 {
+	struct perf_counter *output_counter;
 	struct perf_mmap_data *data;
 	unsigned int offset, head;
 	int have_lost;
@@ -2647,13 +2686,17 @@ static int perf_output_begin(struct perf_output_handle *handle,
 		u64			 lost;
 	} lost_event;
 
+	rcu_read_lock();
 	/*
 	 * For inherited counters we send all the output towards the parent.
 	 */
 	if (counter->parent)
 		counter = counter->parent;
 
-	rcu_read_lock();
+	output_counter = rcu_dereference(counter->output);
+	if (output_counter)
+		counter = output_counter;
+
 	data = rcu_dereference(counter->data);
 	if (!data)
 		goto out;
@@ -3934,6 +3977,7 @@ static const struct pmu *tp_perf_counter_init(struct perf_counter *counter)
 	 * have these.
 	 */
 	if ((counter->attr.sample_type & PERF_SAMPLE_RAW) &&
+			perf_paranoid_tracepoint_raw() &&
 			!capable(CAP_SYS_ADMIN))
 		return ERR_PTR(-EPERM);
 
@@ -4202,6 +4246,57 @@ err_size:
 	goto out;
 }
 
+int perf_counter_set_output(struct perf_counter *counter, int output_fd)
+{
+	struct perf_counter *output_counter = NULL;
+	struct file *output_file = NULL;
+	struct perf_counter *old_output;
+	int fput_needed = 0;
+	int ret = -EINVAL;
+
+	if (!output_fd)
+		goto set;
+
+	output_file = fget_light(output_fd, &fput_needed);
+	if (!output_file)
+		return -EBADF;
+
+	if (output_file->f_op != &perf_fops)
+		goto out;
+
+	output_counter = output_file->private_data;
+
+	/* Don't chain output fds */
+	if (output_counter->output)
+		goto out;
+
+	/* Don't set an output fd when we already have an output channel */
+	if (counter->data)
+		goto out;
+
+	atomic_long_inc(&output_file->f_count);
+
+set:
+	mutex_lock(&counter->mmap_mutex);
+	old_output = counter->output;
+	rcu_assign_pointer(counter->output, output_counter);
+	mutex_unlock(&counter->mmap_mutex);
+
+	if (old_output) {
+		/*
+		 * we need to make sure no existing perf_output_*()
+		 * is still referencing this counter.
+		 */
+		synchronize_rcu();
+		fput(old_output->filp);
+	}
+
+	ret = 0;
+out:
+	fput_light(output_file, fput_needed);
+	return ret;
+}
+
 /**
  * sys_perf_counter_open - open a performance counter, associate it to a task/cpu
  *
@@ -4221,15 +4316,15 @@ SYSCALL_DEFINE5(perf_counter_open,
 	struct file *group_file = NULL;
 	int fput_needed = 0;
 	int fput_needed2 = 0;
-	int ret;
+	int err;
 
 	/* for future expandability... */
-	if (flags)
+	if (flags & ~(PERF_FLAG_FD_NO_GROUP | PERF_FLAG_FD_OUTPUT))
 		return -EINVAL;
 
-	ret = perf_copy_attr(attr_uptr, &attr);
-	if (ret)
-		return ret;
+	err = perf_copy_attr(attr_uptr, &attr);
+	if (err)
+		return err;
 
 	if (!attr.exclude_kernel) {
 		if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
@@ -4252,8 +4347,8 @@ SYSCALL_DEFINE5(perf_counter_open,
 	 * Look up the group leader (we will attach this counter to it):
 	 */
 	group_leader = NULL;
-	if (group_fd != -1) {
-		ret = -EINVAL;
+	if (group_fd != -1 && !(flags & PERF_FLAG_FD_NO_GROUP)) {
+		err = -EINVAL;
 		group_file = fget_light(group_fd, &fput_needed);
 		if (!group_file)
 			goto err_put_context;
@@ -4282,18 +4377,24 @@ SYSCALL_DEFINE5(perf_counter_open,
 
 	counter = perf_counter_alloc(&attr, cpu, ctx, group_leader,
 				     NULL, GFP_KERNEL);
-	ret = PTR_ERR(counter);
+	err = PTR_ERR(counter);
 	if (IS_ERR(counter))
 		goto err_put_context;
 
-	ret = anon_inode_getfd("[perf_counter]", &perf_fops, counter, 0);
-	if (ret < 0)
+	err = anon_inode_getfd("[perf_counter]", &perf_fops, counter, 0);
+	if (err < 0)
 		goto err_free_put_context;
 
-	counter_file = fget_light(ret, &fput_needed2);
+	counter_file = fget_light(err, &fput_needed2);
 	if (!counter_file)
 		goto err_free_put_context;
 
+	if (flags & PERF_FLAG_FD_OUTPUT) {
+		err = perf_counter_set_output(counter, group_fd);
+		if (err)
+			goto err_fput_free_put_context;
+	}
+
 	counter->filp = counter_file;
 	WARN_ON_ONCE(ctx->parent_ctx);
 	mutex_lock(&ctx->mutex);
@@ -4307,20 +4408,20 @@ SYSCALL_DEFINE5(perf_counter_open,
 	list_add_tail(&counter->owner_entry, &current->perf_counter_list);
 	mutex_unlock(&current->perf_counter_mutex);
 
+err_fput_free_put_context:
 	fput_light(counter_file, fput_needed2);
 
-out_fput:
-	fput_light(group_file, fput_needed);
-
-	return ret;
-
 err_free_put_context:
-	kfree(counter);
+	if (err < 0)
+		kfree(counter);
 
 err_put_context:
-	put_ctx(ctx);
+	if (err < 0)
+		put_ctx(ctx);
+
+	fput_light(group_file, fput_needed);
 
-	goto out_fput;
+	return err;
 }
 
 /*
diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 6be696b..0ff23de 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -91,6 +91,10 @@ OPTIONS
 --no-samples::
 	Don't sample.
 
+-R::
+--raw-samples::
+Collect raw sample records from all opened counters (typically for tracepoint counters).
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index e72e931..59f0b84 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -27,6 +27,9 @@ OPTIONS
 -n
 --show-nr-samples
 	Show the number of samples for each symbol
+-T
+--threads
+	Show per-thread event counters
 -C::
 --comms=::
 	Only consider symbols in these comms. CSV that understands
@@ -48,6 +51,16 @@ OPTIONS
 	all occurances of this separator in symbol names (and other output)
 	with a '.' character, that thus it's the only non valid separator.
 
+-g [type,min]::
+--call-graph::
+        Display callchains using type and min percent threshold.
+	type can be either:
+	- flat: single column, linear exposure of callchains.
+	- graph: use a graph tree, displaying absolute overhead rates.
+	- fractal: like graph, but displays relative rates. Each branch of
+		 the tree is considered as a new profiled object. +
+	Default: fractal,0.5.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1]
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index c045b42..9f8d207 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -166,7 +166,35 @@ endif
 
 # CFLAGS and LDFLAGS are for the users to override from the command line.
 
-CFLAGS = $(M64) -ggdb3 -Wall -Wextra -Wstrict-prototypes -Wmissing-declarations -Wmissing-prototypes -std=gnu99 -Wdeclaration-after-statement -Werror -O6
+#
+# Include saner warnings here, which can catch bugs:
+#
+
+EXTRA_WARNINGS := -Wcast-align
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat-security
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat-y2k
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wshadow
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Winit-self
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wpacked
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wredundant-decls
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstack-protector
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-aliasing=3
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wswitch-default
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wswitch-enum
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wno-system-headers
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wundef
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wvolatile-register-var
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wwrite-strings
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wbad-function-cast
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wmissing-declarations
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wmissing-prototypes
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wnested-externs
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wold-style-definition
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-prototypes
+EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wdeclaration-after-statement
+
+CFLAGS = $(M64) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -fstack-protector-all -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
 LDFLAGS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS)
 ALL_LDFLAGS = $(LDFLAGS)
@@ -310,6 +338,7 @@ LIB_H += util/sigchain.h
 LIB_H += util/symbol.h
 LIB_H += util/module.h
 LIB_H += util/color.h
+LIB_H += util/values.h
 
 LIB_OBJS += util/abspath.o
 LIB_OBJS += util/alias.o
@@ -337,6 +366,13 @@ LIB_OBJS += util/color.o
 LIB_OBJS += util/pager.o
 LIB_OBJS += util/header.o
 LIB_OBJS += util/callchain.o
+LIB_OBJS += util/values.o
+LIB_OBJS += util/debug.o
+LIB_OBJS += util/map.o
+LIB_OBJS += util/thread.o
+LIB_OBJS += util/trace-event-parse.o
+LIB_OBJS += util/trace-event-read.o
+LIB_OBJS += util/trace-event-info.o
 
 BUILTIN_OBJS += builtin-annotate.o
 BUILTIN_OBJS += builtin-help.o
@@ -345,6 +381,7 @@ BUILTIN_OBJS += builtin-record.o
 BUILTIN_OBJS += builtin-report.o
 BUILTIN_OBJS += builtin-stat.o
 BUILTIN_OBJS += builtin-top.o
+BUILTIN_OBJS += builtin-trace.o
 
 PERFLIBS = $(LIB_FILE)
 
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 5e17de9..043d85b 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -17,16 +17,13 @@
 #include "util/string.h"
 
 #include "perf.h"
+#include "util/debug.h"
 
 #include "util/parse-options.h"
 #include "util/parse-events.h"
-
-#define SHOW_KERNEL	1
-#define SHOW_USER	2
-#define SHOW_HV		4
+#include "util/thread.h"
 
 static char		const *input_name = "perf.data";
-static char		*vmlinux = "vmlinux";
 
 static char		default_sort_order[] = "comm,symbol";
 static char		*sort_order = default_sort_order;
@@ -35,13 +32,6 @@ static int		force;
 static int		input;
 static int		show_mask = SHOW_KERNEL | SHOW_USER | SHOW_HV;
 
-static int		dump_trace = 0;
-#define dprintf(x...)	do { if (dump_trace) printf(x); } while (0)
-
-static int		verbose;
-
-static int		modules;
-
 static int		full_paths;
 
 static int		print_line;
@@ -49,39 +39,8 @@ static int		print_line;
 static unsigned long	page_size;
 static unsigned long	mmap_window = 32;
 
-struct ip_event {
-	struct perf_event_header header;
-	u64 ip;
-	u32 pid, tid;
-};
-
-struct mmap_event {
-	struct perf_event_header header;
-	u32 pid, tid;
-	u64 start;
-	u64 len;
-	u64 pgoff;
-	char filename[PATH_MAX];
-};
-
-struct comm_event {
-	struct perf_event_header header;
-	u32 pid, tid;
-	char comm[16];
-};
-
-struct fork_event {
-	struct perf_event_header header;
-	u32 pid, ppid;
-};
-
-typedef union event_union {
-	struct perf_event_header	header;
-	struct ip_event			ip;
-	struct mmap_event		mmap;
-	struct comm_event		comm;
-	struct fork_event		fork;
-} event_t;
+static struct rb_root	threads;
+static struct thread	*last_match;
 
 
 struct sym_ext {
@@ -90,323 +49,6 @@ struct sym_ext {
 	char		*path;
 };
 
-static LIST_HEAD(dsos);
-static struct dso *kernel_dso;
-static struct dso *vdso;
-
-
-static void dsos__add(struct dso *dso)
-{
-	list_add_tail(&dso->node, &dsos);
-}
-
-static struct dso *dsos__find(const char *name)
-{
-	struct dso *pos;
-
-	list_for_each_entry(pos, &dsos, node)
-		if (strcmp(pos->name, name) == 0)
-			return pos;
-	return NULL;
-}
-
-static struct dso *dsos__findnew(const char *name)
-{
-	struct dso *dso = dsos__find(name);
-	int nr;
-
-	if (dso)
-		return dso;
-
-	dso = dso__new(name, 0);
-	if (!dso)
-		goto out_delete_dso;
-
-	nr = dso__load(dso, NULL, verbose);
-	if (nr < 0) {
-		if (verbose)
-			fprintf(stderr, "Failed to open: %s\n", name);
-		goto out_delete_dso;
-	}
-	if (!nr && verbose) {
-		fprintf(stderr,
-		"No symbols found in: %s, maybe install a debug package?\n",
-				name);
-	}
-
-	dsos__add(dso);
-
-	return dso;
-
-out_delete_dso:
-	dso__delete(dso);
-	return NULL;
-}
-
-static void dsos__fprintf(FILE *fp)
-{
-	struct dso *pos;
-
-	list_for_each_entry(pos, &dsos, node)
-		dso__fprintf(pos, fp);
-}
-
-static struct symbol *vdso__find_symbol(struct dso *dso, u64 ip)
-{
-	return dso__find_symbol(dso, ip);
-}
-
-static int load_kernel(void)
-{
-	int err;
-
-	kernel_dso = dso__new("[kernel]", 0);
-	if (!kernel_dso)
-		return -1;
-
-	err = dso__load_kernel(kernel_dso, vmlinux, NULL, verbose, modules);
-	if (err <= 0) {
-		dso__delete(kernel_dso);
-		kernel_dso = NULL;
-	} else
-		dsos__add(kernel_dso);
-
-	vdso = dso__new("[vdso]", 0);
-	if (!vdso)
-		return -1;
-
-	vdso->find_symbol = vdso__find_symbol;
-
-	dsos__add(vdso);
-
-	return err;
-}
-
-struct map {
-	struct list_head node;
-	u64	 start;
-	u64	 end;
-	u64	 pgoff;
-	u64	 (*map_ip)(struct map *, u64);
-	struct dso	 *dso;
-};
-
-static u64 map__map_ip(struct map *map, u64 ip)
-{
-	return ip - map->start + map->pgoff;
-}
-
-static u64 vdso__map_ip(struct map *map __used, u64 ip)
-{
-	return ip;
-}
-
-static struct map *map__new(struct mmap_event *event)
-{
-	struct map *self = malloc(sizeof(*self));
-
-	if (self != NULL) {
-		const char *filename = event->filename;
-
-		self->start = event->start;
-		self->end   = event->start + event->len;
-		self->pgoff = event->pgoff;
-
-		self->dso = dsos__findnew(filename);
-		if (self->dso == NULL)
-			goto out_delete;
-
-		if (self->dso == vdso)
-			self->map_ip = vdso__map_ip;
-		else
-			self->map_ip = map__map_ip;
-	}
-	return self;
-out_delete:
-	free(self);
-	return NULL;
-}
-
-static struct map *map__clone(struct map *self)
-{
-	struct map *map = malloc(sizeof(*self));
-
-	if (!map)
-		return NULL;
-
-	memcpy(map, self, sizeof(*self));
-
-	return map;
-}
-
-static int map__overlap(struct map *l, struct map *r)
-{
-	if (l->start > r->start) {
-		struct map *t = l;
-		l = r;
-		r = t;
-	}
-
-	if (l->end > r->start)
-		return 1;
-
-	return 0;
-}
-
-static size_t map__fprintf(struct map *self, FILE *fp)
-{
-	return fprintf(fp, " %Lx-%Lx %Lx %s\n",
-		       self->start, self->end, self->pgoff, self->dso->name);
-}
-
-
-struct thread {
-	struct rb_node	 rb_node;
-	struct list_head maps;
-	pid_t		 pid;
-	char		 *comm;
-};
-
-static struct thread *thread__new(pid_t pid)
-{
-	struct thread *self = malloc(sizeof(*self));
-
-	if (self != NULL) {
-		self->pid = pid;
-		self->comm = malloc(32);
-		if (self->comm)
-			snprintf(self->comm, 32, ":%d", self->pid);
-		INIT_LIST_HEAD(&self->maps);
-	}
-
-	return self;
-}
-
-static int thread__set_comm(struct thread *self, const char *comm)
-{
-	if (self->comm)
-		free(self->comm);
-	self->comm = strdup(comm);
-	return self->comm ? 0 : -ENOMEM;
-}
-
-static size_t thread__fprintf(struct thread *self, FILE *fp)
-{
-	struct map *pos;
-	size_t ret = fprintf(fp, "Thread %d %s\n", self->pid, self->comm);
-
-	list_for_each_entry(pos, &self->maps, node)
-		ret += map__fprintf(pos, fp);
-
-	return ret;
-}
-
-
-static struct rb_root threads;
-static struct thread *last_match;
-
-static struct thread *threads__findnew(pid_t pid)
-{
-	struct rb_node **p = &threads.rb_node;
-	struct rb_node *parent = NULL;
-	struct thread *th;
-
-	/*
-	 * Font-end cache - PID lookups come in blocks,
-	 * so most of the time we dont have to look up
-	 * the full rbtree:
-	 */
-	if (last_match && last_match->pid == pid)
-		return last_match;
-
-	while (*p != NULL) {
-		parent = *p;
-		th = rb_entry(parent, struct thread, rb_node);
-
-		if (th->pid == pid) {
-			last_match = th;
-			return th;
-		}
-
-		if (pid < th->pid)
-			p = &(*p)->rb_left;
-		else
-			p = &(*p)->rb_right;
-	}
-
-	th = thread__new(pid);
-	if (th != NULL) {
-		rb_link_node(&th->rb_node, parent, p);
-		rb_insert_color(&th->rb_node, &threads);
-		last_match = th;
-	}
-
-	return th;
-}
-
-static void thread__insert_map(struct thread *self, struct map *map)
-{
-	struct map *pos, *tmp;
-
-	list_for_each_entry_safe(pos, tmp, &self->maps, node) {
-		if (map__overlap(pos, map)) {
-			list_del_init(&pos->node);
-			/* XXX leaks dsos */
-			free(pos);
-		}
-	}
-
-	list_add_tail(&map->node, &self->maps);
-}
-
-static int thread__fork(struct thread *self, struct thread *parent)
-{
-	struct map *map;
-
-	if (self->comm)
-		free(self->comm);
-	self->comm = strdup(parent->comm);
-	if (!self->comm)
-		return -ENOMEM;
-
-	list_for_each_entry(map, &parent->maps, node) {
-		struct map *new = map__clone(map);
-		if (!new)
-			return -ENOMEM;
-		thread__insert_map(self, new);
-	}
-
-	return 0;
-}
-
-static struct map *thread__find_map(struct thread *self, u64 ip)
-{
-	struct map *pos;
-
-	if (self == NULL)
-		return NULL;
-
-	list_for_each_entry(pos, &self->maps, node)
-		if (ip >= pos->start && ip <= pos->end)
-			return pos;
-
-	return NULL;
-}
-
-static size_t threads__fprintf(FILE *fp)
-{
-	size_t ret = 0;
-	struct rb_node *nd;
-
-	for (nd = rb_first(&threads); nd; nd = rb_next(nd)) {
-		struct thread *pos = rb_entry(nd, struct thread, rb_node);
-
-		ret += thread__fprintf(pos, fp);
-	}
-
-	return ret;
-}
-
 /*
  * histogram, sorted on item, collects counts
  */
@@ -433,7 +75,7 @@ struct hist_entry {
 struct sort_entry {
 	struct list_head list;
 
-	char *header;
+	const char *header;
 
 	int64_t (*cmp)(struct hist_entry *, struct hist_entry *);
 	int64_t (*collapse)(struct hist_entry *, struct hist_entry *);
@@ -577,7 +219,7 @@ static struct sort_entry sort_sym = {
 static int sort__need_collapse = 0;
 
 struct sort_dimension {
-	char			*name;
+	const char		*name;
 	struct sort_entry	*entry;
 	int			taken;
 };
@@ -830,17 +472,6 @@ static void output__resort(void)
 	}
 }
 
-static void register_idle_thread(void)
-{
-	struct thread *thread = threads__findnew(0);
-
-	if (thread == NULL ||
-			thread__set_comm(thread, "[idle]")) {
-		fprintf(stderr, "problem inserting idle task.\n");
-		exit(-1);
-	}
-}
-
 static unsigned long total = 0,
 		     total_mmap = 0,
 		     total_comm = 0,
@@ -853,18 +484,20 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 	char level;
 	int show = 0;
 	struct dso *dso = NULL;
-	struct thread *thread = threads__findnew(event->ip.pid);
+	struct thread *thread;
 	u64 ip = event->ip.ip;
 	struct map *map = NULL;
 
-	dprintf("%p [%p]: PERF_EVENT (IP, %d): %d: %p\n",
+	thread = threads__findnew(event->ip.pid, &threads, &last_match);
+
+	dump_printf("%p [%p]: PERF_EVENT (IP, %d): %d: %p\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
 		event->header.misc,
 		event->ip.pid,
 		(void *)(long)ip);
 
-	dprintf(" ... thread: %s:%d\n", thread->comm, thread->pid);
+	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
 
 	if (thread == NULL) {
 		fprintf(stderr, "problem processing %d event, skipping it.\n",
@@ -878,7 +511,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 
 		dso = kernel_dso;
 
-		dprintf(" ...... dso: %s\n", dso->name);
+		dump_printf(" ...... dso: %s\n", dso->name);
 
 	} else if (event->header.misc & PERF_EVENT_MISC_USER) {
 
@@ -899,12 +532,12 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 			if ((long long)ip < 0)
 				dso = kernel_dso;
 		}
-		dprintf(" ...... dso: %s\n", dso ? dso->name : "<not found>");
+		dump_printf(" ...... dso: %s\n", dso ? dso->name : "<not found>");
 
 	} else {
 		show = SHOW_HV;
 		level = 'H';
-		dprintf(" ...... dso: [hypervisor]\n");
+		dump_printf(" ...... dso: [hypervisor]\n");
 	}
 
 	if (show & show_mask) {
@@ -927,10 +560,12 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 static int
 process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	struct thread *thread = threads__findnew(event->mmap.pid);
-	struct map *map = map__new(&event->mmap);
+	struct thread *thread;
+	struct map *map = map__new(&event->mmap, NULL, 0);
+
+	thread = threads__findnew(event->mmap.pid, &threads, &last_match);
 
-	dprintf("%p [%p]: PERF_EVENT_MMAP %d: [%p(%p) @ %p]: %s\n",
+	dump_printf("%p [%p]: PERF_EVENT_MMAP %d: [%p(%p) @ %p]: %s\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
 		event->mmap.pid,
@@ -940,7 +575,7 @@ process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 		event->mmap.filename);
 
 	if (thread == NULL || map == NULL) {
-		dprintf("problem processing PERF_EVENT_MMAP, skipping event.\n");
+		dump_printf("problem processing PERF_EVENT_MMAP, skipping event.\n");
 		return 0;
 	}
 
@@ -953,16 +588,17 @@ process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 static int
 process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	struct thread *thread = threads__findnew(event->comm.pid);
+	struct thread *thread;
 
-	dprintf("%p [%p]: PERF_EVENT_COMM: %s:%d\n",
+	thread = threads__findnew(event->comm.pid, &threads, &last_match);
+	dump_printf("%p [%p]: PERF_EVENT_COMM: %s:%d\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
 		event->comm.comm, event->comm.pid);
 
 	if (thread == NULL ||
 	    thread__set_comm(thread, event->comm.comm)) {
-		dprintf("problem processing PERF_EVENT_COMM, skipping event.\n");
+		dump_printf("problem processing PERF_EVENT_COMM, skipping event.\n");
 		return -1;
 	}
 	total_comm++;
@@ -973,10 +609,12 @@ process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 static int
 process_fork_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	struct thread *thread = threads__findnew(event->fork.pid);
-	struct thread *parent = threads__findnew(event->fork.ppid);
+	struct thread *thread;
+	struct thread *parent;
 
-	dprintf("%p [%p]: PERF_EVENT_FORK: %d:%d\n",
+	thread = threads__findnew(event->fork.pid, &threads, &last_match);
+	parent = threads__findnew(event->fork.ppid, &threads, &last_match);
+	dump_printf("%p [%p]: PERF_EVENT_FORK: %d:%d\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
 		event->fork.pid, event->fork.ppid);
@@ -989,7 +627,7 @@ process_fork_event(event_t *event, unsigned long offset, unsigned long head)
 		return 0;
 
 	if (!thread || !parent || thread__fork(thread, parent)) {
-		dprintf("problem processing PERF_EVENT_FORK, skipping event.\n");
+		dump_printf("problem processing PERF_EVENT_FORK, skipping event.\n");
 		return -1;
 	}
 	total_fork++;
@@ -1075,7 +713,7 @@ parse_line(FILE *file, struct symbol *sym, u64 start, u64 len)
 		const char *path = NULL;
 		unsigned int hits = 0;
 		double percent = 0.0;
-		char *color;
+		const char *color;
 		struct sym_ext *sym_ext = sym->priv;
 
 		offset = line_ip - start;
@@ -1157,7 +795,7 @@ static void free_source_line(struct symbol *sym, int len)
 
 /* Get the filename:line for the colored entries */
 static void
-get_source_line(struct symbol *sym, u64 start, int len, char *filename)
+get_source_line(struct symbol *sym, u64 start, int len, const char *filename)
 {
 	int i;
 	char cmd[PATH_MAX * 2];
@@ -1203,7 +841,7 @@ get_source_line(struct symbol *sym, u64 start, int len, char *filename)
 	}
 }
 
-static void print_summary(char *filename)
+static void print_summary(const char *filename)
 {
 	struct sym_ext *sym_ext;
 	struct rb_node *node;
@@ -1219,7 +857,7 @@ static void print_summary(char *filename)
 	node = rb_first(&root_sym_ext);
 	while (node) {
 		double percent;
-		char *color;
+		const char *color;
 		char *path;
 
 		sym_ext = rb_entry(node, struct sym_ext, node);
@@ -1234,7 +872,7 @@ static void print_summary(char *filename)
 
 static void annotate_sym(struct dso *dso, struct symbol *sym)
 {
-	char *filename = dso->name, *d_filename;
+	const char *filename = dso->name, *d_filename;
 	u64 start, end, len;
 	char command[PATH_MAX*2];
 	FILE *file;
@@ -1244,7 +882,7 @@ static void annotate_sym(struct dso *dso, struct symbol *sym)
 	if (sym->module)
 		filename = sym->module->path;
 	else if (dso == kernel_dso)
-		filename = vmlinux;
+		filename = vmlinux_name;
 
 	start = sym->obj_start;
 	if (!start)
@@ -1316,12 +954,12 @@ static int __cmd_annotate(void)
 	int ret, rc = EXIT_FAILURE;
 	unsigned long offset = 0;
 	unsigned long head = 0;
-	struct stat stat;
+	struct stat input_stat;
 	event_t *event;
 	uint32_t size;
 	char *buf;
 
-	register_idle_thread();
+	register_idle_thread(&threads, &last_match);
 
 	input = open(input_name, O_RDONLY);
 	if (input < 0) {
@@ -1329,18 +967,18 @@ static int __cmd_annotate(void)
 		exit(-1);
 	}
 
-	ret = fstat(input, &stat);
+	ret = fstat(input, &input_stat);
 	if (ret < 0) {
 		perror("failed to stat file");
 		exit(-1);
 	}
 
-	if (!force && (stat.st_uid != geteuid())) {
-		fprintf(stderr, "file: %s not owned by current user\n", input_name);
+	if (!force && input_stat.st_uid && (input_stat.st_uid != geteuid())) {
+		fprintf(stderr, "file: %s not owned by current user or root\n", input_name);
 		exit(-1);
 	}
 
-	if (!stat.st_size) {
+	if (!input_stat.st_size) {
 		fprintf(stderr, "zero-sized file, nothing to do!\n");
 		exit(0);
 	}
@@ -1367,10 +1005,10 @@ more:
 
 	if (head + event->header.size >= page_size * mmap_window) {
 		unsigned long shift = page_size * (head / page_size);
-		int ret;
+		int munmap_ret;
 
-		ret = munmap(buf, page_size * mmap_window);
-		assert(ret == 0);
+		munmap_ret = munmap(buf, page_size * mmap_window);
+		assert(munmap_ret == 0);
 
 		offset += shift;
 		head -= shift;
@@ -1379,14 +1017,14 @@ more:
 
 	size = event->header.size;
 
-	dprintf("%p [%p]: event: %d\n",
+	dump_printf("%p [%p]: event: %d\n",
 			(void *)(offset + head),
 			(void *)(long)event->header.size,
 			event->header.type);
 
 	if (!size || process_event(event, offset, head) < 0) {
 
-		dprintf("%p [%p]: skipping unknown header type: %d\n",
+		dump_printf("%p [%p]: skipping unknown header type: %d\n",
 			(void *)(offset + head),
 			(void *)(long)(event->header.size),
 			event->header.type);
@@ -1406,23 +1044,23 @@ more:
 
 	head += size;
 
-	if (offset + head < (unsigned long)stat.st_size)
+	if (offset + head < (unsigned long)input_stat.st_size)
 		goto more;
 
 	rc = EXIT_SUCCESS;
 	close(input);
 
-	dprintf("      IP events: %10ld\n", total);
-	dprintf("    mmap events: %10ld\n", total_mmap);
-	dprintf("    comm events: %10ld\n", total_comm);
-	dprintf("    fork events: %10ld\n", total_fork);
-	dprintf(" unknown events: %10ld\n", total_unknown);
+	dump_printf("      IP events: %10ld\n", total);
+	dump_printf("    mmap events: %10ld\n", total_mmap);
+	dump_printf("    comm events: %10ld\n", total_comm);
+	dump_printf("    fork events: %10ld\n", total_fork);
+	dump_printf(" unknown events: %10ld\n", total_unknown);
 
 	if (dump_trace)
 		return 0;
 
 	if (verbose >= 3)
-		threads__fprintf(stdout);
+		threads__fprintf(stdout, &threads);
 
 	if (verbose >= 2)
 		dsos__fprintf(stdout);
@@ -1450,7 +1088,7 @@ static const struct option options[] = {
 		    "be more verbose (show symbol address, etc)"),
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
-	OPT_STRING('k', "vmlinux", &vmlinux, "file", "vmlinux pathname"),
+	OPT_STRING('k', "vmlinux", &vmlinux_name, "file", "vmlinux pathname"),
 	OPT_BOOLEAN('m', "modules", &modules,
 		    "load module symbols - WARNING: use only with -k and LIVE kernel"),
 	OPT_BOOLEAN('l', "print-line", &print_line,
diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
index 2599d86..4fb8734 100644
--- a/tools/perf/builtin-help.c
+++ b/tools/perf/builtin-help.c
@@ -456,6 +456,7 @@ int cmd_help(int argc, const char **argv, const char *prefix __used)
 		break;
 	case HELP_FORMAT_WEB:
 		show_html_page(argv[0]);
+	default:
 		break;
 	}
 
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 89a5ddc..99a12fe 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -15,6 +15,9 @@
 #include "util/string.h"
 
 #include "util/header.h"
+#include "util/event.h"
+#include "util/debug.h"
+#include "util/trace-event.h"
 
 #include <unistd.h>
 #include <sched.h>
@@ -42,7 +45,6 @@ static int			inherit				= 1;
 static int			force				= 0;
 static int			append_file			= 0;
 static int			call_graph			= 0;
-static int			verbose				= 0;
 static int			inherit_stat			= 0;
 static int			no_samples			= 0;
 static int			sample_address			= 0;
@@ -62,24 +64,6 @@ static int			file_new = 1;
 
 struct perf_header		*header;
 
-struct mmap_event {
-	struct perf_event_header	header;
-	u32				pid;
-	u32				tid;
-	u64				start;
-	u64				len;
-	u64				pgoff;
-	char				filename[PATH_MAX];
-};
-
-struct comm_event {
-	struct perf_event_header	header;
-	u32				pid;
-	u32				tid;
-	char				comm[16];
-};
-
-
 struct mmap_data {
 	int			counter;
 	void			*base;
@@ -419,8 +403,11 @@ static void create_counter(int counter, int cpu, pid_t pid)
 	if (call_graph)
 		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
 
-	if (raw_samples)
+	if (raw_samples) {
+		attr->sample_type	|= PERF_SAMPLE_TIME;
 		attr->sample_type	|= PERF_SAMPLE_RAW;
+		attr->sample_type	|= PERF_SAMPLE_CPU;
+	}
 
 	attr->mmap		= track;
 	attr->comm		= track;
@@ -563,6 +550,17 @@ static int __cmd_record(int argc, const char **argv)
 	else
 		header = perf_header__new();
 
+
+	if (raw_samples) {
+		read_tracing_data(attrs, nr_counters);
+	} else {
+		for (i = 0; i < nr_counters; i++) {
+			if (attrs[i].sample_type & PERF_SAMPLE_RAW) {
+				read_tracing_data(attrs, nr_counters);
+				break;
+			}
+		}
+	}
 	atexit(atexit_header);
 
 	if (!system_wide) {
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 8b2ec88..cdf9a8d 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -17,19 +17,18 @@
 #include "util/string.h"
 #include "util/callchain.h"
 #include "util/strlist.h"
+#include "util/values.h"
 
 #include "perf.h"
+#include "util/debug.h"
 #include "util/header.h"
 
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 
-#define SHOW_KERNEL	1
-#define SHOW_USER	2
-#define SHOW_HV		4
+#include "util/thread.h"
 
 static char		const *input_name = "perf.data";
-static char		*vmlinux = NULL;
 
 static char		default_sort_order[] = "comm,dso,symbol";
 static char		*sort_order = default_sort_order;
@@ -42,18 +41,15 @@ static int		force;
 static int		input;
 static int		show_mask = SHOW_KERNEL | SHOW_USER | SHOW_HV;
 
-static int		dump_trace = 0;
-#define dprintf(x...)	do { if (dump_trace) printf(x); } while (0)
-#define cdprintf(x...)	do { if (dump_trace) color_fprintf(stdout, color, x); } while (0)
-
-static int		verbose;
-#define eprintf(x...)	do { if (verbose) fprintf(stderr, x); } while (0)
-
-static int		modules;
-
 static int		full_paths;
 static int		show_nr_samples;
 
+static int		show_threads;
+static struct perf_read_values	show_threads_values;
+
+static char		default_pretty_printing_style[] = "normal";
+static char		*pretty_printing_style = default_pretty_printing_style;
+
 static unsigned long	page_size;
 static unsigned long	mmap_window = 32;
 
@@ -67,6 +63,15 @@ static char		callchain_default_opt[] = "fractal,0.5";
 
 static int		callchain;
 
+static char		__cwd[PATH_MAX];
+static char		*cwd = __cwd;
+static int		cwdlen;
+
+static struct rb_root	threads;
+static struct thread	*last_match;
+
+static struct perf_header *header;
+
 static
 struct callchain_param	callchain_param = {
 	.mode	= CHAIN_GRAPH_REL,
@@ -75,59 +80,6 @@ struct callchain_param	callchain_param = {
 
 static u64		sample_type;
 
-struct ip_event {
-	struct perf_event_header header;
-	u64 ip;
-	u32 pid, tid;
-	unsigned char __more_data[];
-};
-
-struct mmap_event {
-	struct perf_event_header header;
-	u32 pid, tid;
-	u64 start;
-	u64 len;
-	u64 pgoff;
-	char filename[PATH_MAX];
-};
-
-struct comm_event {
-	struct perf_event_header header;
-	u32 pid, tid;
-	char comm[16];
-};
-
-struct fork_event {
-	struct perf_event_header header;
-	u32 pid, ppid;
-	u32 tid, ptid;
-};
-
-struct lost_event {
-	struct perf_event_header header;
-	u64 id;
-	u64 lost;
-};
-
-struct read_event {
-	struct perf_event_header header;
-	u32 pid,tid;
-	u64 value;
-	u64 time_enabled;
-	u64 time_running;
-	u64 id;
-};
-
-typedef union event_union {
-	struct perf_event_header	header;
-	struct ip_event			ip;
-	struct mmap_event		mmap;
-	struct comm_event		comm;
-	struct fork_event		fork;
-	struct lost_event		lost;
-	struct read_event		read;
-} event_t;
-
 static int repsep_fprintf(FILE *fp, const char *fmt, ...)
 {
 	int n;
@@ -141,6 +93,7 @@ static int repsep_fprintf(FILE *fp, const char *fmt, ...)
 		n = vasprintf(&bf, fmt, ap);
 		if (n > 0) {
 			char *sep = bf;
+
 			while (1) {
 				sep = strchr(sep, *field_sep);
 				if (sep == NULL)
@@ -155,396 +108,10 @@ static int repsep_fprintf(FILE *fp, const char *fmt, ...)
 	return n;
 }
 
-static LIST_HEAD(dsos);
-static struct dso *kernel_dso;
-static struct dso *vdso;
-static struct dso *hypervisor_dso;
-
-static void dsos__add(struct dso *dso)
-{
-	list_add_tail(&dso->node, &dsos);
-}
-
-static struct dso *dsos__find(const char *name)
-{
-	struct dso *pos;
-
-	list_for_each_entry(pos, &dsos, node)
-		if (strcmp(pos->name, name) == 0)
-			return pos;
-	return NULL;
-}
-
-static struct dso *dsos__findnew(const char *name)
-{
-	struct dso *dso = dsos__find(name);
-	int nr;
-
-	if (dso)
-		return dso;
-
-	dso = dso__new(name, 0);
-	if (!dso)
-		goto out_delete_dso;
-
-	nr = dso__load(dso, NULL, verbose);
-	if (nr < 0) {
-		eprintf("Failed to open: %s\n", name);
-		goto out_delete_dso;
-	}
-	if (!nr)
-		eprintf("No symbols found in: %s, maybe install a debug package?\n", name);
-
-	dsos__add(dso);
-
-	return dso;
-
-out_delete_dso:
-	dso__delete(dso);
-	return NULL;
-}
-
-static void dsos__fprintf(FILE *fp)
-{
-	struct dso *pos;
-
-	list_for_each_entry(pos, &dsos, node)
-		dso__fprintf(pos, fp);
-}
-
-static struct symbol *vdso__find_symbol(struct dso *dso, u64 ip)
-{
-	return dso__find_symbol(dso, ip);
-}
-
-static int load_kernel(void)
-{
-	int err;
-
-	kernel_dso = dso__new("[kernel]", 0);
-	if (!kernel_dso)
-		return -1;
-
-	err = dso__load_kernel(kernel_dso, vmlinux, NULL, verbose, modules);
-	if (err <= 0) {
-		dso__delete(kernel_dso);
-		kernel_dso = NULL;
-	} else
-		dsos__add(kernel_dso);
-
-	vdso = dso__new("[vdso]", 0);
-	if (!vdso)
-		return -1;
-
-	vdso->find_symbol = vdso__find_symbol;
-
-	dsos__add(vdso);
-
-	hypervisor_dso = dso__new("[hypervisor]", 0);
-	if (!hypervisor_dso)
-		return -1;
-	dsos__add(hypervisor_dso);
-
-	return err;
-}
-
-static char __cwd[PATH_MAX];
-static char *cwd = __cwd;
-static int cwdlen;
-
-static int strcommon(const char *pathname)
-{
-	int n = 0;
-
-	while (n < cwdlen && pathname[n] == cwd[n])
-		++n;
-
-	return n;
-}
-
-struct map {
-	struct list_head node;
-	u64	 start;
-	u64	 end;
-	u64	 pgoff;
-	u64	 (*map_ip)(struct map *, u64);
-	struct dso	 *dso;
-};
-
-static u64 map__map_ip(struct map *map, u64 ip)
-{
-	return ip - map->start + map->pgoff;
-}
-
-static u64 vdso__map_ip(struct map *map __used, u64 ip)
-{
-	return ip;
-}
-
-static inline int is_anon_memory(const char *filename)
-{
-	return strcmp(filename, "//anon") == 0;
-}
-
-static struct map *map__new(struct mmap_event *event)
-{
-	struct map *self = malloc(sizeof(*self));
-
-	if (self != NULL) {
-		const char *filename = event->filename;
-		char newfilename[PATH_MAX];
-		int anon;
-
-		if (cwd) {
-			int n = strcommon(filename);
-
-			if (n == cwdlen) {
-				snprintf(newfilename, sizeof(newfilename),
-					 ".%s", filename + n);
-				filename = newfilename;
-			}
-		}
-
-		anon = is_anon_memory(filename);
-
-		if (anon) {
-			snprintf(newfilename, sizeof(newfilename), "/tmp/perf-%d.map", event->pid);
-			filename = newfilename;
-		}
-
-		self->start = event->start;
-		self->end   = event->start + event->len;
-		self->pgoff = event->pgoff;
-
-		self->dso = dsos__findnew(filename);
-		if (self->dso == NULL)
-			goto out_delete;
-
-		if (self->dso == vdso || anon)
-			self->map_ip = vdso__map_ip;
-		else
-			self->map_ip = map__map_ip;
-	}
-	return self;
-out_delete:
-	free(self);
-	return NULL;
-}
-
-static struct map *map__clone(struct map *self)
-{
-	struct map *map = malloc(sizeof(*self));
-
-	if (!map)
-		return NULL;
-
-	memcpy(map, self, sizeof(*self));
-
-	return map;
-}
-
-static int map__overlap(struct map *l, struct map *r)
-{
-	if (l->start > r->start) {
-		struct map *t = l;
-		l = r;
-		r = t;
-	}
-
-	if (l->end > r->start)
-		return 1;
-
-	return 0;
-}
-
-static size_t map__fprintf(struct map *self, FILE *fp)
-{
-	return fprintf(fp, " %Lx-%Lx %Lx %s\n",
-		       self->start, self->end, self->pgoff, self->dso->name);
-}
-
-
-struct thread {
-	struct rb_node	 rb_node;
-	struct list_head maps;
-	pid_t		 pid;
-	char		 *comm;
-};
-
-static struct thread *thread__new(pid_t pid)
-{
-	struct thread *self = malloc(sizeof(*self));
-
-	if (self != NULL) {
-		self->pid = pid;
-		self->comm = malloc(32);
-		if (self->comm)
-			snprintf(self->comm, 32, ":%d", self->pid);
-		INIT_LIST_HEAD(&self->maps);
-	}
-
-	return self;
-}
-
 static unsigned int dsos__col_width,
 		    comms__col_width,
 		    threads__col_width;
 
-static int thread__set_comm(struct thread *self, const char *comm)
-{
-	if (self->comm)
-		free(self->comm);
-	self->comm = strdup(comm);
-	if (!self->comm)
-		return -ENOMEM;
-
-	if (!col_width_list_str && !field_sep &&
-	    (!comm_list || strlist__has_entry(comm_list, comm))) {
-		unsigned int slen = strlen(comm);
-		if (slen > comms__col_width) {
-			comms__col_width = slen;
-			threads__col_width = slen + 6;
-		}
-	}
-
-	return 0;
-}
-
-static size_t thread__fprintf(struct thread *self, FILE *fp)
-{
-	struct map *pos;
-	size_t ret = fprintf(fp, "Thread %d %s\n", self->pid, self->comm);
-
-	list_for_each_entry(pos, &self->maps, node)
-		ret += map__fprintf(pos, fp);
-
-	return ret;
-}
-
-
-static struct rb_root threads;
-static struct thread *last_match;
-
-static struct thread *threads__findnew(pid_t pid)
-{
-	struct rb_node **p = &threads.rb_node;
-	struct rb_node *parent = NULL;
-	struct thread *th;
-
-	/*
-	 * Font-end cache - PID lookups come in blocks,
-	 * so most of the time we dont have to look up
-	 * the full rbtree:
-	 */
-	if (last_match && last_match->pid == pid)
-		return last_match;
-
-	while (*p != NULL) {
-		parent = *p;
-		th = rb_entry(parent, struct thread, rb_node);
-
-		if (th->pid == pid) {
-			last_match = th;
-			return th;
-		}
-
-		if (pid < th->pid)
-			p = &(*p)->rb_left;
-		else
-			p = &(*p)->rb_right;
-	}
-
-	th = thread__new(pid);
-	if (th != NULL) {
-		rb_link_node(&th->rb_node, parent, p);
-		rb_insert_color(&th->rb_node, &threads);
-		last_match = th;
-	}
-
-	return th;
-}
-
-static void thread__insert_map(struct thread *self, struct map *map)
-{
-	struct map *pos, *tmp;
-
-	list_for_each_entry_safe(pos, tmp, &self->maps, node) {
-		if (map__overlap(pos, map)) {
-			if (verbose >= 2) {
-				printf("overlapping maps:\n");
-				map__fprintf(map, stdout);
-				map__fprintf(pos, stdout);
-			}
-
-			if (map->start <= pos->start && map->end > pos->start)
-				pos->start = map->end;
-
-			if (map->end >= pos->end && map->start < pos->end)
-				pos->end = map->start;
-
-			if (verbose >= 2) {
-				printf("after collision:\n");
-				map__fprintf(pos, stdout);
-			}
-
-			if (pos->start >= pos->end) {
-				list_del_init(&pos->node);
-				free(pos);
-			}
-		}
-	}
-
-	list_add_tail(&map->node, &self->maps);
-}
-
-static int thread__fork(struct thread *self, struct thread *parent)
-{
-	struct map *map;
-
-	if (self->comm)
-		free(self->comm);
-	self->comm = strdup(parent->comm);
-	if (!self->comm)
-		return -ENOMEM;
-
-	list_for_each_entry(map, &parent->maps, node) {
-		struct map *new = map__clone(map);
-		if (!new)
-			return -ENOMEM;
-		thread__insert_map(self, new);
-	}
-
-	return 0;
-}
-
-static struct map *thread__find_map(struct thread *self, u64 ip)
-{
-	struct map *pos;
-
-	if (self == NULL)
-		return NULL;
-
-	list_for_each_entry(pos, &self->maps, node)
-		if (ip >= pos->start && ip <= pos->end)
-			return pos;
-
-	return NULL;
-}
-
-static size_t threads__fprintf(FILE *fp)
-{
-	size_t ret = 0;
-	struct rb_node *nd;
-
-	for (nd = rb_first(&threads); nd; nd = rb_next(nd)) {
-		struct thread *pos = rb_entry(nd, struct thread, rb_node);
-
-		ret += thread__fprintf(pos, fp);
-	}
-
-	return ret;
-}
-
 /*
  * histogram, sorted on item, collects counts
  */
@@ -574,7 +141,7 @@ struct hist_entry {
 struct sort_entry {
 	struct list_head list;
 
-	char *header;
+	const char *header;
 
 	int64_t (*cmp)(struct hist_entry *, struct hist_entry *);
 	int64_t (*collapse)(struct hist_entry *, struct hist_entry *);
@@ -758,7 +325,7 @@ static int sort__need_collapse = 0;
 static int sort__has_parent = 0;
 
 struct sort_dimension {
-	char			*name;
+	const char		*name;
 	struct sort_entry	*entry;
 	int			taken;
 };
@@ -773,7 +340,7 @@ static struct sort_dimension sort_dimensions[] = {
 
 static LIST_HEAD(hist_entry__sort_list);
 
-static int sort_dimension__add(char *tok)
+static int sort_dimension__add(const char *tok)
 {
 	unsigned int i;
 
@@ -1032,6 +599,7 @@ hist_entry_callchain__fprintf(FILE *fp, struct hist_entry *self,
 		case CHAIN_GRAPH_REL:
 			ret += callchain__fprintf_graph(fp, chain,
 							total_samples, 1, 1);
+		case CHAIN_NONE:
 		default:
 			break;
 		}
@@ -1098,6 +666,34 @@ static void dso__calc_col_width(struct dso *self)
 	self->slen_calculated = 1;
 }
 
+static void thread__comm_adjust(struct thread *self)
+{
+	char *comm = self->comm;
+
+	if (!col_width_list_str && !field_sep &&
+	    (!comm_list || strlist__has_entry(comm_list, comm))) {
+		unsigned int slen = strlen(comm);
+
+		if (slen > comms__col_width) {
+			comms__col_width = slen;
+			threads__col_width = slen + 6;
+		}
+	}
+}
+
+static int thread__set_comm_adjust(struct thread *self, const char *comm)
+{
+	int ret = thread__set_comm(self, comm);
+
+	if (ret)
+		return ret;
+
+	thread__comm_adjust(self);
+
+	return 0;
+}
+
+
 static struct symbol *
 resolve_symbol(struct thread *thread, struct map **mapp,
 	       struct dso **dsop, u64 *ipp)
@@ -1141,8 +737,8 @@ got_map:
 		if ((long long)ip < 0)
 		dso = kernel_dso;
 	}
-	dprintf(" ...... dso: %s\n", dso ? dso->name : "<not found>");
-	dprintf(" ...... map: %Lx -> %Lx\n", *ipp, ip);
+	dump_printf(" ...... dso: %s\n", dso ? dso->name : "<not found>");
+	dump_printf(" ...... map: %Lx -> %Lx\n", *ipp, ip);
 	*ipp  = ip;
 
 	if (dsop)
@@ -1398,6 +994,9 @@ static size_t output__fprintf(FILE *fp, u64 total_samples)
 	size_t ret = 0;
 	unsigned int width;
 	char *col_width = col_width_list_str;
+	int raw_printing_style;
+
+	raw_printing_style = !strcmp(pretty_printing_style, "raw");
 
 	init_rem_hits();
 
@@ -1474,18 +1073,11 @@ print_entries:
 
 	free(rem_sq_bracket);
 
-	return ret;
-}
+	if (show_threads)
+		perf_read_values_display(fp, &show_threads_values,
+					 raw_printing_style);
 
-static void register_idle_thread(void)
-{
-	struct thread *thread = threads__findnew(0);
-
-	if (thread == NULL ||
-			thread__set_comm(thread, "[idle]")) {
-		fprintf(stderr, "problem inserting idle task.\n");
-		exit(-1);
-	}
+	return ret;
 }
 
 static unsigned long total = 0,
@@ -1514,7 +1106,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 	char level;
 	int show = 0;
 	struct dso *dso = NULL;
-	struct thread *thread = threads__findnew(event->ip.pid);
+	struct thread *thread;
 	u64 ip = event->ip.ip;
 	u64 period = 1;
 	struct map *map = NULL;
@@ -1522,12 +1114,14 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 	struct ip_callchain *chain = NULL;
 	int cpumode;
 
+	thread = threads__findnew(event->ip.pid, &threads, &last_match);
+
 	if (sample_type & PERF_SAMPLE_PERIOD) {
 		period = *(u64 *)more_data;
 		more_data += sizeof(u64);
 	}
 
-	dprintf("%p [%p]: PERF_EVENT_SAMPLE (IP, %d): %d/%d: %p period: %Ld\n",
+	dump_printf("%p [%p]: PERF_EVENT_SAMPLE (IP, %d): %d/%d: %p period: %Ld\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
 		event->header.misc,
@@ -1540,7 +1134,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 
 		chain = (void *)more_data;
 
-		dprintf("... chain: nr:%Lu\n", chain->nr);
+		dump_printf("... chain: nr:%Lu\n", chain->nr);
 
 		if (validate_chain(chain, event) < 0) {
 			eprintf("call-chain problem with event, skipping it.\n");
@@ -1549,11 +1143,11 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 
 		if (dump_trace) {
 			for (i = 0; i < chain->nr; i++)
-				dprintf("..... %2d: %016Lx\n", i, chain->ips[i]);
+				dump_printf("..... %2d: %016Lx\n", i, chain->ips[i]);
 		}
 	}
 
-	dprintf(" ... thread: %s:%d\n", thread->comm, thread->pid);
+	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
 
 	if (thread == NULL) {
 		eprintf("problem processing %d event, skipping it.\n",
@@ -1572,7 +1166,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 
 		dso = kernel_dso;
 
-		dprintf(" ...... dso: %s\n", dso->name);
+		dump_printf(" ...... dso: %s\n", dso->name);
 
 	} else if (cpumode == PERF_EVENT_MISC_USER) {
 
@@ -1585,7 +1179,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 
 		dso = hypervisor_dso;
 
-		dprintf(" ...... dso: [hypervisor]\n");
+		dump_printf(" ...... dso: [hypervisor]\n");
 	}
 
 	if (show & show_mask) {
@@ -1611,10 +1205,12 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 static int
 process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	struct thread *thread = threads__findnew(event->mmap.pid);
-	struct map *map = map__new(&event->mmap);
+	struct thread *thread;
+	struct map *map = map__new(&event->mmap, cwd, cwdlen);
 
-	dprintf("%p [%p]: PERF_EVENT_MMAP %d/%d: [%p(%p) @ %p]: %s\n",
+	thread = threads__findnew(event->mmap.pid, &threads, &last_match);
+
+	dump_printf("%p [%p]: PERF_EVENT_MMAP %d/%d: [%p(%p) @ %p]: %s\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
 		event->mmap.pid,
@@ -1625,7 +1221,7 @@ process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 		event->mmap.filename);
 
 	if (thread == NULL || map == NULL) {
-		dprintf("problem processing PERF_EVENT_MMAP, skipping event.\n");
+		dump_printf("problem processing PERF_EVENT_MMAP, skipping event.\n");
 		return 0;
 	}
 
@@ -1638,16 +1234,18 @@ process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 static int
 process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	struct thread *thread = threads__findnew(event->comm.pid);
+	struct thread *thread;
+
+	thread = threads__findnew(event->comm.pid, &threads, &last_match);
 
-	dprintf("%p [%p]: PERF_EVENT_COMM: %s:%d\n",
+	dump_printf("%p [%p]: PERF_EVENT_COMM: %s:%d\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
 		event->comm.comm, event->comm.pid);
 
 	if (thread == NULL ||
-	    thread__set_comm(thread, event->comm.comm)) {
-		dprintf("problem processing PERF_EVENT_COMM, skipping event.\n");
+	    thread__set_comm_adjust(thread, event->comm.comm)) {
+		dump_printf("problem processing PERF_EVENT_COMM, skipping event.\n");
 		return -1;
 	}
 	total_comm++;
@@ -1658,10 +1256,13 @@ process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 static int
 process_task_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	struct thread *thread = threads__findnew(event->fork.pid);
-	struct thread *parent = threads__findnew(event->fork.ppid);
+	struct thread *thread;
+	struct thread *parent;
 
-	dprintf("%p [%p]: PERF_EVENT_%s: (%d:%d):(%d:%d)\n",
+	thread = threads__findnew(event->fork.pid, &threads, &last_match);
+	parent = threads__findnew(event->fork.ppid, &threads, &last_match);
+
+	dump_printf("%p [%p]: PERF_EVENT_%s: (%d:%d):(%d:%d)\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
 		event->header.type == PERF_EVENT_FORK ? "FORK" : "EXIT",
@@ -1679,7 +1280,7 @@ process_task_event(event_t *event, unsigned long offset, unsigned long head)
 		return 0;
 
 	if (!thread || !parent || thread__fork(thread, parent)) {
-		dprintf("problem processing PERF_EVENT_FORK, skipping event.\n");
+		dump_printf("problem processing PERF_EVENT_FORK, skipping event.\n");
 		return -1;
 	}
 	total_fork++;
@@ -1690,7 +1291,7 @@ process_task_event(event_t *event, unsigned long offset, unsigned long head)
 static int
 process_lost_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	dprintf("%p [%p]: PERF_EVENT_LOST: id:%Ld: lost:%Ld\n",
+	dump_printf("%p [%p]: PERF_EVENT_LOST: id:%Ld: lost:%Ld\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
 		event->lost.id,
@@ -1701,67 +1302,24 @@ process_lost_event(event_t *event, unsigned long offset, unsigned long head)
 	return 0;
 }
 
-static void trace_event(event_t *event)
-{
-	unsigned char *raw_event = (void *)event;
-	char *color = PERF_COLOR_BLUE;
-	int i, j;
-
-	if (!dump_trace)
-		return;
-
-	dprintf(".");
-	cdprintf("\n. ... raw event: size %d bytes\n", event->header.size);
-
-	for (i = 0; i < event->header.size; i++) {
-		if ((i & 15) == 0) {
-			dprintf(".");
-			cdprintf("  %04x: ", i);
-		}
-
-		cdprintf(" %02x", raw_event[i]);
-
-		if (((i & 15) == 15) || i == event->header.size-1) {
-			cdprintf("  ");
-			for (j = 0; j < 15-(i & 15); j++)
-				cdprintf("   ");
-			for (j = 0; j < (i & 15); j++) {
-				if (isprint(raw_event[i-15+j]))
-					cdprintf("%c", raw_event[i-15+j]);
-				else
-					cdprintf(".");
-			}
-			cdprintf("\n");
-		}
-	}
-	dprintf(".\n");
-}
-
-static struct perf_header	*header;
-
-static struct perf_counter_attr *perf_header__find_attr(u64 id)
+static int
+process_read_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	int i;
+	struct perf_counter_attr *attr;
 
-	for (i = 0; i < header->attrs; i++) {
-		struct perf_header_attr *attr = header->attr[i];
-		int j;
+	attr = perf_header__find_attr(event->read.id, header);
 
-		for (j = 0; j < attr->ids; j++) {
-			if (attr->id[j] == id)
-				return &attr->attr;
-		}
+	if (show_threads) {
+		const char *name = attr ? __event_name(attr->type, attr->config)
+				   : "unknown";
+		perf_read_values_add_value(&show_threads_values,
+					   event->read.pid, event->read.tid,
+					   event->read.id,
+					   name,
+					   event->read.value);
 	}
 
-	return NULL;
-}
-
-static int
-process_read_event(event_t *event, unsigned long offset, unsigned long head)
-{
-	struct perf_counter_attr *attr = perf_header__find_attr(event->read.id);
-
-	dprintf("%p [%p]: PERF_EVENT_READ: %d %d %s %Lu\n",
+	dump_printf("%p [%p]: PERF_EVENT_READ: %d %d %s %Lu\n",
 			(void *)(offset + head),
 			(void *)(long)(event->header.size),
 			event->read.pid,
@@ -1813,34 +1371,22 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 	return 0;
 }
 
-static u64 perf_header__sample_type(void)
-{
-	u64 sample_type = 0;
-	int i;
-
-	for (i = 0; i < header->attrs; i++) {
-		struct perf_header_attr *attr = header->attr[i];
-
-		if (!sample_type)
-			sample_type = attr->attr.sample_type;
-		else if (sample_type != attr->attr.sample_type)
-			die("non matching sample_type");
-	}
-
-	return sample_type;
-}
-
 static int __cmd_report(void)
 {
 	int ret, rc = EXIT_FAILURE;
 	unsigned long offset = 0;
 	unsigned long head, shift;
-	struct stat stat;
+	struct stat input_stat;
+	struct thread *idle;
 	event_t *event;
 	uint32_t size;
 	char *buf;
 
-	register_idle_thread();
+	idle = register_idle_thread(&threads, &last_match);
+	thread__comm_adjust(idle);
+
+	if (show_threads)
+		perf_read_values_init(&show_threads_values);
 
 	input = open(input_name, O_RDONLY);
 	if (input < 0) {
@@ -1851,18 +1397,18 @@ static int __cmd_report(void)
 		exit(-1);
 	}
 
-	ret = fstat(input, &stat);
+	ret = fstat(input, &input_stat);
 	if (ret < 0) {
 		perror("failed to stat file");
 		exit(-1);
 	}
 
-	if (!force && (stat.st_uid != geteuid())) {
-		fprintf(stderr, "file: %s not owned by current user\n", input_name);
+	if (!force && input_stat.st_uid && (input_stat.st_uid != geteuid())) {
+		fprintf(stderr, "file: %s not owned by current user or root\n", input_name);
 		exit(-1);
 	}
 
-	if (!stat.st_size) {
+	if (!input_stat.st_size) {
 		fprintf(stderr, "zero-sized file, nothing to do!\n");
 		exit(0);
 	}
@@ -1870,7 +1416,7 @@ static int __cmd_report(void)
 	header = perf_header__read(input);
 	head = header->data_offset;
 
-	sample_type = perf_header__sample_type();
+	sample_type = perf_header__sample_type(header);
 
 	if (!(sample_type & PERF_SAMPLE_CALLCHAIN)) {
 		if (sort__has_parent) {
@@ -1880,7 +1426,7 @@ static int __cmd_report(void)
 			exit(-1);
 		}
 		if (callchain) {
-			fprintf(stderr, "selected -c but no callchain data."
+			fprintf(stderr, "selected -g but no callchain data."
 					" Did you call perf record without"
 					" -g?\n");
 			exit(-1);
@@ -1930,12 +1476,12 @@ more:
 		size = 8;
 
 	if (head + event->header.size >= page_size * mmap_window) {
-		int ret;
+		int munmap_ret;
 
 		shift = page_size * (head / page_size);
 
-		ret = munmap(buf, page_size * mmap_window);
-		assert(ret == 0);
+		munmap_ret = munmap(buf, page_size * mmap_window);
+		assert(munmap_ret == 0);
 
 		offset += shift;
 		head -= shift;
@@ -1944,14 +1490,14 @@ more:
 
 	size = event->header.size;
 
-	dprintf("\n%p [%p]: event: %d\n",
+	dump_printf("\n%p [%p]: event: %d\n",
 			(void *)(offset + head),
 			(void *)(long)event->header.size,
 			event->header.type);
 
 	if (!size || process_event(event, offset, head) < 0) {
 
-		dprintf("%p [%p]: skipping unknown header type: %d\n",
+		dump_printf("%p [%p]: skipping unknown header type: %d\n",
 			(void *)(offset + head),
 			(void *)(long)(event->header.size),
 			event->header.type);
@@ -1974,25 +1520,25 @@ more:
 	if (offset + head >= header->data_offset + header->data_size)
 		goto done;
 
-	if (offset + head < (unsigned long)stat.st_size)
+	if (offset + head < (unsigned long)input_stat.st_size)
 		goto more;
 
 done:
 	rc = EXIT_SUCCESS;
 	close(input);
 
-	dprintf("      IP events: %10ld\n", total);
-	dprintf("    mmap events: %10ld\n", total_mmap);
-	dprintf("    comm events: %10ld\n", total_comm);
-	dprintf("    fork events: %10ld\n", total_fork);
-	dprintf("    lost events: %10ld\n", total_lost);
-	dprintf(" unknown events: %10ld\n", total_unknown);
+	dump_printf("      IP events: %10ld\n", total);
+	dump_printf("    mmap events: %10ld\n", total_mmap);
+	dump_printf("    comm events: %10ld\n", total_comm);
+	dump_printf("    fork events: %10ld\n", total_fork);
+	dump_printf("    lost events: %10ld\n", total_lost);
+	dump_printf(" unknown events: %10ld\n", total_unknown);
 
 	if (dump_trace)
 		return 0;
 
 	if (verbose >= 3)
-		threads__fprintf(stdout);
+		threads__fprintf(stdout, &threads);
 
 	if (verbose >= 2)
 		dsos__fprintf(stdout);
@@ -2001,6 +1547,9 @@ done:
 	output__resort(total);
 	output__fprintf(stdout, total);
 
+	if (show_threads)
+		perf_read_values_destroy(&show_threads_values);
+
 	return rc;
 }
 
@@ -2069,12 +1618,16 @@ static const struct option options[] = {
 		    "be more verbose (show symbol address, etc)"),
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
-	OPT_STRING('k', "vmlinux", &vmlinux, "file", "vmlinux pathname"),
+	OPT_STRING('k', "vmlinux", &vmlinux_name, "file", "vmlinux pathname"),
 	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
 	OPT_BOOLEAN('m', "modules", &modules,
 		    "load module symbols - WARNING: use only with -k and LIVE kernel"),
 	OPT_BOOLEAN('n', "show-nr-samples", &show_nr_samples,
 		    "Show a column with the number of samples"),
+	OPT_BOOLEAN('T', "threads", &show_threads,
+		    "Show per-thread event counters"),
+	OPT_STRING(0, "pretty", &pretty_printing_style, "key",
+		   "pretty printing style key: normal raw"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent"),
 	OPT_BOOLEAN('P', "full-paths", &full_paths,
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index b4b06c7..61b8282 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -42,6 +42,8 @@
 #include "util/util.h"
 #include "util/parse-options.h"
 #include "util/parse-events.h"
+#include "util/event.h"
+#include "util/debug.h"
 
 #include <sys/prctl.h>
 #include <math.h>
@@ -60,10 +62,7 @@ static struct perf_counter_attr default_attrs[] = {
 
 };
 
-#define MAX_RUN			100
-
 static int			system_wide			=  0;
-static int			verbose				=  0;
 static unsigned int		nr_cpus				=  0;
 static int			run_idx				=  0;
 
@@ -75,26 +74,56 @@ static int			null_run			=  0;
 
 static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
 
-static u64			runtime_nsecs[MAX_RUN];
-static u64			walltime_nsecs[MAX_RUN];
-static u64			runtime_cycles[MAX_RUN];
+static int			event_scaled[MAX_COUNTERS];
 
-static u64			event_res[MAX_RUN][MAX_COUNTERS][3];
-static u64			event_scaled[MAX_RUN][MAX_COUNTERS];
+struct stats
+{
+	double n, mean, M2;
+};
 
-static u64			event_res_avg[MAX_COUNTERS][3];
-static u64			event_res_noise[MAX_COUNTERS][3];
+static void update_stats(struct stats *stats, u64 val)
+{
+	double delta;
 
-static u64			event_scaled_avg[MAX_COUNTERS];
+	stats->n++;
+	delta = val - stats->mean;
+	stats->mean += delta / stats->n;
+	stats->M2 += delta*(val - stats->mean);
+}
 
-static u64			runtime_nsecs_avg;
-static u64			runtime_nsecs_noise;
+static double avg_stats(struct stats *stats)
+{
+	return stats->mean;
+}
 
-static u64			walltime_nsecs_avg;
-static u64			walltime_nsecs_noise;
+/*
+ * http://en.wikipedia.org/wiki/Algorithms_for_calculating_variance
+ *
+ *       (\Sum n_i^2) - ((\Sum n_i)^2)/n
+ * s^2 = -------------------------------
+ *                  n - 1
+ *
+ * http://en.wikipedia.org/wiki/Stddev
+ *
+ * The std dev of the mean is related to the std dev by:
+ *
+ *             s
+ * s_mean = -------
+ *          sqrt(n)
+ *
+ */
+static double stddev_stats(struct stats *stats)
+{
+	double variance = stats->M2 / (stats->n - 1);
+	double variance_mean = variance / stats->n;
+
+	return sqrt(variance_mean);
+}
 
-static u64			runtime_cycles_avg;
-static u64			runtime_cycles_noise;
+struct stats			event_res_stats[MAX_COUNTERS][3];
+struct stats			runtime_nsecs_stats;
+struct stats			walltime_nsecs_stats;
+struct stats			runtime_cycles_stats;
 
 #define MATCH_EVENT(t, c, counter)			\
 	(attrs[counter].type == PERF_TYPE_##t &&	\
@@ -149,12 +178,11 @@ static inline int nsec_counter(int counter)
  */
 static void read_counter(int counter)
 {
-	u64 *count, single_count[3];
+	u64 count[3], single_count[3];
 	unsigned int cpu;
 	size_t res, nv;
 	int scaled;
-
-	count = event_res[run_idx][counter];
+	int i;
 
 	count[0] = count[1] = count[2] = 0;
 
@@ -179,24 +207,33 @@ static void read_counter(int counter)
 	scaled = 0;
 	if (scale) {
 		if (count[2] == 0) {
-			event_scaled[run_idx][counter] = -1;
+			event_scaled[counter] = -1;
 			count[0] = 0;
 			return;
 		}
 
 		if (count[2] < count[1]) {
-			event_scaled[run_idx][counter] = 1;
+			event_scaled[counter] = 1;
 			count[0] = (unsigned long long)
 				((double)count[0] * count[1] / count[2] + 0.5);
 		}
 	}
+
+	for (i = 0; i < 3; i++)
+		update_stats(&event_res_stats[counter][i], count[i]);
+
+	if (verbose) {
+		fprintf(stderr, "%s: %Ld %Ld %Ld\n", event_name(counter),
+				count[0], count[1], count[2]);
+	}
+
 	/*
 	 * Save the full runtime - to allow normalization during printout:
 	 */
 	if (MATCH_EVENT(SOFTWARE, SW_TASK_CLOCK, counter))
-		runtime_nsecs[run_idx] = count[0];
+		update_stats(&runtime_nsecs_stats, count[0]);
 	if (MATCH_EVENT(HARDWARE, HW_CPU_CYCLES, counter))
-		runtime_cycles[run_idx] = count[0];
+		update_stats(&runtime_cycles_stats, count[0]);
 }
 
 static int run_perf_stat(int argc __used, const char **argv)
@@ -270,7 +307,7 @@ static int run_perf_stat(int argc __used, const char **argv)
 
 	t1 = rdclock();
 
-	walltime_nsecs[run_idx] = t1 - t0;
+	update_stats(&walltime_nsecs_stats, t1 - t0);
 
 	for (counter = 0; counter < nr_counters; counter++)
 		read_counter(counter);
@@ -278,42 +315,38 @@ static int run_perf_stat(int argc __used, const char **argv)
 	return WEXITSTATUS(status);
 }
 
-static void print_noise(u64 *count, u64 *noise)
+static void print_noise(int counter, double avg)
 {
-	if (run_count > 1)
-		fprintf(stderr, "   ( +- %7.3f%% )",
-			(double)noise[0]/(count[0]+1)*100.0);
+	if (run_count == 1)
+		return;
+
+	fprintf(stderr, "   ( +- %7.3f%% )",
+			100 * stddev_stats(&event_res_stats[counter][0]) / avg);
 }
 
-static void nsec_printout(int counter, u64 *count, u64 *noise)
+static void nsec_printout(int counter, double avg)
 {
-	double msecs = (double)count[0] / 1000000;
+	double msecs = avg / 1e6;
 
 	fprintf(stderr, " %14.6f  %-24s", msecs, event_name(counter));
 
 	if (MATCH_EVENT(SOFTWARE, SW_TASK_CLOCK, counter)) {
-		if (walltime_nsecs_avg)
-			fprintf(stderr, " # %10.3f CPUs ",
-				(double)count[0] / (double)walltime_nsecs_avg);
+		fprintf(stderr, " # %10.3f CPUs ",
+				avg / avg_stats(&walltime_nsecs_stats));
 	}
-	print_noise(count, noise);
 }
 
-static void abs_printout(int counter, u64 *count, u64 *noise)
+static void abs_printout(int counter, double avg)
 {
-	fprintf(stderr, " %14Ld  %-24s", count[0], event_name(counter));
+	fprintf(stderr, " %14.0f  %-24s", avg, event_name(counter));
 
-	if (runtime_cycles_avg &&
-	    MATCH_EVENT(HARDWARE, HW_INSTRUCTIONS, counter)) {
+	if (MATCH_EVENT(HARDWARE, HW_INSTRUCTIONS, counter)) {
 		fprintf(stderr, " # %10.3f IPC  ",
-			(double)count[0] / (double)runtime_cycles_avg);
+				avg / avg_stats(&runtime_cycles_stats));
 	} else {
-		if (runtime_nsecs_avg) {
-			fprintf(stderr, " # %10.3f M/sec",
-				(double)count[0]/runtime_nsecs_avg*1000.0);
-		}
+		fprintf(stderr, " # %10.3f M/sec",
+				1000.0 * avg / avg_stats(&runtime_nsecs_stats));
 	}
-	print_noise(count, noise);
 }
 
 /*
@@ -321,12 +354,8 @@ static void abs_printout(int counter, u64 *count, u64 *noise)
  */
 static void print_counter(int counter)
 {
-	u64 *count, *noise;
-	int scaled;
-
-	count = event_res_avg[counter];
-	noise = event_res_noise[counter];
-	scaled = event_scaled_avg[counter];
+	double avg = avg_stats(&event_res_stats[counter][0]);
+	int scaled = event_scaled[counter];
 
 	if (scaled == -1) {
 		fprintf(stderr, " %14s  %-24s\n",
@@ -335,110 +364,29 @@ static void print_counter(int counter)
 	}
 
 	if (nsec_counter(counter))
-		nsec_printout(counter, count, noise);
+		nsec_printout(counter, avg);
 	else
-		abs_printout(counter, count, noise);
-
-	if (scaled)
-		fprintf(stderr, "  (scaled from %.2f%%)",
-			(double) count[2] / count[1] * 100);
-
-	fprintf(stderr, "\n");
-}
+		abs_printout(counter, avg);
 
-/*
- * normalize_noise noise values down to stddev:
- */
-static void normalize_noise(u64 *val)
-{
-	double res;
+	print_noise(counter, avg);
 
-	res = (double)*val / (run_count * sqrt((double)run_count));
+	if (scaled) {
+		double avg_enabled, avg_running;
 
-	*val = (u64)res;
-}
+		avg_enabled = avg_stats(&event_res_stats[counter][1]);
+		avg_running = avg_stats(&event_res_stats[counter][2]);
 
-static void update_avg(const char *name, int idx, u64 *avg, u64 *val)
-{
-	*avg += *val;
-
-	if (verbose > 1)
-		fprintf(stderr, "debug: %20s[%d]: %Ld\n", name, idx, *val);
-}
-/*
- * Calculate the averages and noises:
- */
-static void calc_avg(void)
-{
-	int i, j;
-
-	if (verbose > 1)
-		fprintf(stderr, "\n");
-
-	for (i = 0; i < run_count; i++) {
-		update_avg("runtime", 0, &runtime_nsecs_avg, runtime_nsecs + i);
-		update_avg("walltime", 0, &walltime_nsecs_avg, walltime_nsecs + i);
-		update_avg("runtime_cycles", 0, &runtime_cycles_avg, runtime_cycles + i);
-
-		for (j = 0; j < nr_counters; j++) {
-			update_avg("counter/0", j,
-				event_res_avg[j]+0, event_res[i][j]+0);
-			update_avg("counter/1", j,
-				event_res_avg[j]+1, event_res[i][j]+1);
-			update_avg("counter/2", j,
-				event_res_avg[j]+2, event_res[i][j]+2);
-			if (event_scaled[i][j] != (u64)-1)
-				update_avg("scaled", j,
-					event_scaled_avg + j, event_scaled[i]+j);
-			else
-				event_scaled_avg[j] = -1;
-		}
-	}
-	runtime_nsecs_avg /= run_count;
-	walltime_nsecs_avg /= run_count;
-	runtime_cycles_avg /= run_count;
-
-	for (j = 0; j < nr_counters; j++) {
-		event_res_avg[j][0] /= run_count;
-		event_res_avg[j][1] /= run_count;
-		event_res_avg[j][2] /= run_count;
-	}
-
-	for (i = 0; i < run_count; i++) {
-		runtime_nsecs_noise +=
-			abs((s64)(runtime_nsecs[i] - runtime_nsecs_avg));
-		walltime_nsecs_noise +=
-			abs((s64)(walltime_nsecs[i] - walltime_nsecs_avg));
-		runtime_cycles_noise +=
-			abs((s64)(runtime_cycles[i] - runtime_cycles_avg));
-
-		for (j = 0; j < nr_counters; j++) {
-			event_res_noise[j][0] +=
-				abs((s64)(event_res[i][j][0] - event_res_avg[j][0]));
-			event_res_noise[j][1] +=
-				abs((s64)(event_res[i][j][1] - event_res_avg[j][1]));
-			event_res_noise[j][2] +=
-				abs((s64)(event_res[i][j][2] - event_res_avg[j][2]));
-		}
+		fprintf(stderr, "  (scaled from %.2f%%)",
+				100 * avg_running / avg_enabled);
 	}
 
-	normalize_noise(&runtime_nsecs_noise);
-	normalize_noise(&walltime_nsecs_noise);
-	normalize_noise(&runtime_cycles_noise);
-
-	for (j = 0; j < nr_counters; j++) {
-		normalize_noise(&event_res_noise[j][0]);
-		normalize_noise(&event_res_noise[j][1]);
-		normalize_noise(&event_res_noise[j][2]);
-	}
+	fprintf(stderr, "\n");
 }
 
 static void print_stat(int argc, const char **argv)
 {
 	int i, counter;
 
-	calc_avg();
-
 	fflush(stdout);
 
 	fprintf(stderr, "\n");
@@ -457,10 +405,11 @@ static void print_stat(int argc, const char **argv)
 
 	fprintf(stderr, "\n");
 	fprintf(stderr, " %14.9f  seconds time elapsed",
-			(double)walltime_nsecs_avg/1e9);
+			avg_stats(&walltime_nsecs_stats)/1e9);
 	if (run_count > 1) {
 		fprintf(stderr, "   ( +- %7.3f%% )",
-			100.0*(double)walltime_nsecs_noise/(double)walltime_nsecs_avg);
+				100*stddev_stats(&walltime_nsecs_stats) /
+				avg_stats(&walltime_nsecs_stats));
 	}
 	fprintf(stderr, "\n\n");
 }
@@ -515,7 +464,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 		PARSE_OPT_STOP_AT_NON_OPTION);
 	if (!argc)
 		usage_with_options(stat_usage, options);
-	if (run_count <= 0 || run_count > MAX_RUN)
+	if (run_count <= 0)
 		usage_with_options(stat_usage, options);
 
 	/* Set attrs and nr_counters if no event is selected and !null_run */
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 7de28ce..4002ccb 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -27,6 +27,8 @@
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 
+#include "util/debug.h"
+
 #include <assert.h>
 #include <fcntl.h>
 
@@ -68,8 +70,6 @@ static int			group				=  0;
 static unsigned int		page_size;
 static unsigned int		mmap_pages			= 16;
 static int			freq				=  0;
-static int			verbose				=  0;
-static char			*vmlinux			=  NULL;
 
 static int			delay_secs			=  2;
 static int			zero;
@@ -122,7 +122,8 @@ static void parse_source(struct sym_entry *syme)
 	struct module *module;
 	struct section *section = NULL;
 	FILE *file;
-	char command[PATH_MAX*2], *path = vmlinux;
+	char command[PATH_MAX*2];
+	const char *path = vmlinux_name;
 	u64 start, end, len;
 
 	if (!syme)
@@ -338,8 +339,6 @@ static void show_details(struct sym_entry *syme)
 		printf("%d lines not displayed, maybe increase display entries [e]\n", more);
 }
 
-struct dso			*kernel_dso;
-
 /*
  * Symbols will be added here in record_ip and will get out
  * after decayed.
@@ -484,17 +483,24 @@ static void print_sym_table(void)
 	if (nr_counters == 1)
 		printf("             samples    pcnt");
 	else
-		printf("  weight     samples    pcnt");
+		printf("   weight    samples    pcnt");
 
-	printf("         RIP          kernel function\n"
-	       	       "  ______     _______   _____   ________________   _______________\n\n"
-	);
+	if (verbose)
+		printf("         RIP       ");
+	printf("   kernel function\n");
+	printf("   %s    _______   _____",
+	       nr_counters == 1 ? "      " : "______");
+	if (verbose)
+		printf("   ________________");
+	printf("   _______________\n\n");
 
 	for (nd = rb_first(&tmp); nd; nd = rb_next(nd)) {
-		struct sym_entry *syme = rb_entry(nd, struct sym_entry, rb_node);
-		struct symbol *sym = (struct symbol *)(syme + 1);
+		struct symbol *sym;
 		double pcnt;
 
+		syme = rb_entry(nd, struct sym_entry, rb_node);
+		sym = (struct symbol *)(syme + 1);
+
 		if (++printed > print_entries || (int)syme->snap_count < count_filter)
 			continue;
 
@@ -507,7 +513,9 @@ static void print_sym_table(void)
 			printf("%9.1f %10ld - ", syme->weight, syme->snap_count);
 
 		percent_color_fprintf(stdout, "%4.1f%%", pcnt);
-		printf(" - %016llx : %s", sym->start, sym->name);
+		if (verbose)
+			printf(" - %016llx", sym->start);
+		printf(" : %s", sym->name);
 		if (sym->module)
 			printf("\t[%s]", sym->module->name);
 		printf("\n");
@@ -613,7 +621,7 @@ static void print_mapped_keys(void)
 
 	fprintf(stdout, "\t[f]     profile display filter (count).    \t(%d)\n", count_filter);
 
-	if (vmlinux) {
+	if (vmlinux_name) {
 		fprintf(stdout, "\t[F]     annotate display filter (percent). \t(%d%%)\n", sym_pcnt_filter);
 		fprintf(stdout, "\t[s]     annotate symbol.                   \t(%s)\n", name?: "NULL");
 		fprintf(stdout, "\t[S]     stop annotation.\n");
@@ -642,7 +650,9 @@ static int key_mapped(int c)
 		case 'F':
 		case 's':
 		case 'S':
-			return vmlinux ? 1 : 0;
+			return vmlinux_name ? 1 : 0;
+		default:
+			break;
 	}
 
 	return 0;
@@ -728,6 +738,8 @@ static void handle_keypress(int c)
 		case 'z':
 			zero = ~zero;
 			break;
+		default:
+			break;
 	}
 }
 
@@ -816,13 +828,13 @@ static int parse_symbols(void)
 {
 	struct rb_node *node;
 	struct symbol  *sym;
-	int modules = vmlinux ? 1 : 0;
+	int use_modules = vmlinux_name ? 1 : 0;
 
 	kernel_dso = dso__new("[kernel]", sizeof(struct sym_entry));
 	if (kernel_dso == NULL)
 		return -1;
 
-	if (dso__load_kernel(kernel_dso, vmlinux, symbol_filter, verbose, modules) <= 0)
+	if (dso__load_kernel(kernel_dso, vmlinux_name, symbol_filter, verbose, use_modules) <= 0)
 		goto out_delete_dso;
 
 	node = rb_first(&kernel_dso->syms);
@@ -937,26 +949,6 @@ static void mmap_read_counter(struct mmap_data *md)
 	last_read = this_read;
 
 	for (; old != head;) {
-		struct ip_event {
-			struct perf_event_header header;
-			u64 ip;
-			u32 pid, target_pid;
-		};
-		struct mmap_event {
-			struct perf_event_header header;
-			u32 pid, target_pid;
-			u64 start;
-			u64 len;
-			u64 pgoff;
-			char filename[PATH_MAX];
-		};
-
-		typedef union event_union {
-			struct perf_event_header header;
-			struct ip_event ip;
-			struct mmap_event mmap;
-		} event_t;
-
 		event_t *event = (event_t *)&data[old & md->mask];
 
 		event_t event_copy;
@@ -1138,7 +1130,7 @@ static const struct option options[] = {
 			    "system-wide collection from all CPUs"),
 	OPT_INTEGER('C', "CPU", &profile_cpu,
 		    "CPU to profile on"),
-	OPT_STRING('k', "vmlinux", &vmlinux, "file", "vmlinux pathname"),
+	OPT_STRING('k', "vmlinux", &vmlinux_name, "file", "vmlinux pathname"),
 	OPT_INTEGER('m', "mmap-pages", &mmap_pages,
 		    "number of mmap data pages"),
 	OPT_INTEGER('r', "realtime", &realtime_prio,
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
new file mode 100644
index 0000000..914ab36
--- /dev/null
+++ b/tools/perf/builtin-trace.c
@@ -0,0 +1,297 @@
+#include "builtin.h"
+
+#include "util/util.h"
+#include "util/cache.h"
+#include "util/symbol.h"
+#include "util/thread.h"
+#include "util/header.h"
+
+#include "util/parse-options.h"
+
+#include "perf.h"
+#include "util/debug.h"
+
+#include "util/trace-event.h"
+
+static char		const *input_name = "perf.data";
+static int		input;
+static unsigned long	page_size;
+static unsigned long	mmap_window = 32;
+
+static unsigned long	total = 0;
+static unsigned long	total_comm = 0;
+
+static struct rb_root	threads;
+static struct thread	*last_match;
+
+static struct perf_header *header;
+static u64		sample_type;
+
+
+static int
+process_comm_event(event_t *event, unsigned long offset, unsigned long head)
+{
+	struct thread *thread;
+
+	thread = threads__findnew(event->comm.pid, &threads, &last_match);
+
+	dump_printf("%p [%p]: PERF_EVENT_COMM: %s:%d\n",
+		(void *)(offset + head),
+		(void *)(long)(event->header.size),
+		event->comm.comm, event->comm.pid);
+
+	if (thread == NULL ||
+	    thread__set_comm(thread, event->comm.comm)) {
+		dump_printf("problem processing PERF_EVENT_COMM, skipping event.\n");
+		return -1;
+	}
+	total_comm++;
+
+	return 0;
+}
+
+static int
+process_sample_event(event_t *event, unsigned long offset, unsigned long head)
+{
+	char level;
+	int show = 0;
+	struct dso *dso = NULL;
+	struct thread *thread;
+	u64 ip = event->ip.ip;
+	u64 timestamp = -1;
+	u32 cpu = -1;
+	u64 period = 1;
+	void *more_data = event->ip.__more_data;
+	int cpumode;
+
+	thread = threads__findnew(event->ip.pid, &threads, &last_match);
+
+	if (sample_type & PERF_SAMPLE_TIME) {
+		timestamp = *(u64 *)more_data;
+		more_data += sizeof(u64);
+	}
+
+	if (sample_type & PERF_SAMPLE_CPU) {
+		cpu = *(u32 *)more_data;
+		more_data += sizeof(u32);
+		more_data += sizeof(u32); /* reserved */
+	}
+
+	if (sample_type & PERF_SAMPLE_PERIOD) {
+		period = *(u64 *)more_data;
+		more_data += sizeof(u64);
+	}
+
+	dump_printf("%p [%p]: PERF_EVENT_SAMPLE (IP, %d): %d/%d: %p period: %Ld\n",
+		(void *)(offset + head),
+		(void *)(long)(event->header.size),
+		event->header.misc,
+		event->ip.pid, event->ip.tid,
+		(void *)(long)ip,
+		(long long)period);
+
+	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
+
+	if (thread == NULL) {
+		eprintf("problem processing %d event, skipping it.\n",
+			event->header.type);
+		return -1;
+	}
+
+	cpumode = event->header.misc & PERF_EVENT_MISC_CPUMODE_MASK;
+
+	if (cpumode == PERF_EVENT_MISC_KERNEL) {
+		show = SHOW_KERNEL;
+		level = 'k';
+
+		dso = kernel_dso;
+
+		dump_printf(" ...... dso: %s\n", dso->name);
+
+	} else if (cpumode == PERF_EVENT_MISC_USER) {
+
+		show = SHOW_USER;
+		level = '.';
+
+	} else {
+		show = SHOW_HV;
+		level = 'H';
+
+		dso = hypervisor_dso;
+
+		dump_printf(" ...... dso: [hypervisor]\n");
+	}
+
+	if (sample_type & PERF_SAMPLE_RAW) {
+		struct {
+			u32 size;
+			char data[0];
+		} *raw = more_data;
+
+		/*
+		 * FIXME: better resolve from pid from the struct trace_entry
+		 * field, although it should be the same than this perf
+		 * event pid
+		 */
+		print_event(cpu, raw->data, raw->size, timestamp, thread->comm);
+	}
+	total += period;
+
+	return 0;
+}
+
+static int
+process_event(event_t *event, unsigned long offset, unsigned long head)
+{
+	trace_event(event);
+
+	switch (event->header.type) {
+	case PERF_EVENT_MMAP ... PERF_EVENT_LOST:
+		return 0;
+
+	case PERF_EVENT_COMM:
+		return process_comm_event(event, offset, head);
+
+	case PERF_EVENT_EXIT ... PERF_EVENT_READ:
+		return 0;
+
+	case PERF_EVENT_SAMPLE:
+		return process_sample_event(event, offset, head);
+
+	case PERF_EVENT_MAX:
+	default:
+		return -1;
+	}
+
+	return 0;
+}
+
+static int __cmd_trace(void)
+{
+	int ret, rc = EXIT_FAILURE;
+	unsigned long offset = 0;
+	unsigned long head = 0;
+	struct stat perf_stat;
+	event_t *event;
+	uint32_t size;
+	char *buf;
+
+	trace_report();
+	register_idle_thread(&threads, &last_match);
+
+	input = open(input_name, O_RDONLY);
+	if (input < 0) {
+		perror("failed to open file");
+		exit(-1);
+	}
+
+	ret = fstat(input, &perf_stat);
+	if (ret < 0) {
+		perror("failed to stat file");
+		exit(-1);
+	}
+
+	if (!perf_stat.st_size) {
+		fprintf(stderr, "zero-sized file, nothing to do!\n");
+		exit(0);
+	}
+	header = perf_header__read(input);
+	head = header->data_offset;
+	sample_type = perf_header__sample_type(header);
+
+	if (!(sample_type & PERF_SAMPLE_RAW))
+		die("No trace sample to read. Did you call perf record "
+		    "without -R?");
+
+	if (load_kernel() < 0) {
+		perror("failed to load kernel symbols");
+		return EXIT_FAILURE;
+	}
+
+remap:
+	buf = (char *)mmap(NULL, page_size * mmap_window, PROT_READ,
+			   MAP_SHARED, input, offset);
+	if (buf == MAP_FAILED) {
+		perror("failed to mmap file");
+		exit(-1);
+	}
+
+more:
+	event = (event_t *)(buf + head);
+
+	size = event->header.size;
+	if (!size)
+		size = 8;
+
+	if (head + event->header.size >= page_size * mmap_window) {
+		unsigned long shift = page_size * (head / page_size);
+		int res;
+
+		res = munmap(buf, page_size * mmap_window);
+		assert(res == 0);
+
+		offset += shift;
+		head -= shift;
+		goto remap;
+	}
+
+	size = event->header.size;
+
+
+	if (!size || process_event(event, offset, head) < 0) {
+
+		/*
+		 * assume we lost track of the stream, check alignment, and
+		 * increment a single u64 in the hope to catch on again 'soon'.
+		 */
+
+		if (unlikely(head & 7))
+			head &= ~7ULL;
+
+		size = 8;
+	}
+
+	head += size;
+
+	if (offset + head < (unsigned long)perf_stat.st_size)
+		goto more;
+
+	rc = EXIT_SUCCESS;
+	close(input);
+
+	return rc;
+}
+
+static const char * const annotate_usage[] = {
+	"perf trace [<options>] <command>",
+	NULL
+};
+
+static const struct option options[] = {
+	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
+		    "dump raw trace in ASCII"),
+	OPT_BOOLEAN('v', "verbose", &verbose,
+		    "be more verbose (show symbol address, etc)"),
+	OPT_END()
+};
+
+int cmd_trace(int argc, const char **argv, const char *prefix __used)
+{
+	symbol__init();
+	page_size = getpagesize();
+
+	argc = parse_options(argc, argv, options, annotate_usage, 0);
+	if (argc) {
+		/*
+		 * Special case: if there's an argument left then assume tha
+		 * it's a symbol filter:
+		 */
+		if (argc > 1)
+			usage_with_options(annotate_usage, options);
+	}
+
+
+	setup_pager();
+
+	return __cmd_trace();
+}
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index 51d1682..3a63e41 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -22,5 +22,6 @@ extern int cmd_stat(int argc, const char **argv, const char *prefix);
 extern int cmd_top(int argc, const char **argv, const char *prefix);
 extern int cmd_version(int argc, const char **argv, const char *prefix);
 extern int cmd_list(int argc, const char **argv, const char *prefix);
+extern int cmd_trace(int argc, const char **argv, const char *prefix);
 
 #endif
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 31982ad..fe4589d 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -292,6 +292,7 @@ static void handle_internal_command(int argc, const char **argv)
 		{ "top", cmd_top, 0 },
 		{ "annotate", cmd_annotate, 0 },
 		{ "version", cmd_version, 0 },
+		{ "trace", cmd_trace, 0 },
 	};
 	unsigned int i;
 	static const char ext[] = STRIP_EXTENSION;
diff --git a/tools/perf/util/abspath.c b/tools/perf/util/abspath.c
index 61d33b8..a791dd4 100644
--- a/tools/perf/util/abspath.c
+++ b/tools/perf/util/abspath.c
@@ -50,7 +50,8 @@ const char *make_absolute_path(const char *path)
 			die ("Could not get current working directory");
 
 		if (last_elem) {
-			int len = strlen(buf);
+			len = strlen(buf);
+
 			if (len + strlen(last_elem) + 2 > PATH_MAX)
 				die ("Too long path name: '%s/%s'",
 						buf, last_elem);
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 4b50c41..6f8ea9d 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -52,7 +52,6 @@ extern const char *perf_mailmap_file;
 extern void maybe_flush_or_die(FILE *, const char *);
 extern int copy_fd(int ifd, int ofd);
 extern int copy_file(const char *dst, const char *src, int mode);
-extern ssize_t read_in_full(int fd, void *buf, size_t count);
 extern ssize_t write_in_full(int fd, const void *buf, size_t count);
 extern void write_or_die(int fd, const void *buf, size_t count);
 extern int write_or_whine(int fd, const void *buf, size_t count, const char *msg);
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 0114734..3b8380f 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -50,6 +50,7 @@ rb_insert_callchain(struct rb_root *root, struct callchain_node *chain,
 			else
 				p = &(*p)->rb_right;
 			break;
+		case CHAIN_NONE:
 		default:
 			break;
 		}
@@ -143,6 +144,7 @@ int register_callchain_param(struct callchain_param *param)
 	case CHAIN_FLAT:
 		param->sort = sort_chain_flat;
 		break;
+	case CHAIN_NONE:
 	default:
 		return -1;
 	}
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index a926ae4..43cf3ea 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -4,6 +4,7 @@
 #include "../perf.h"
 #include <linux/list.h>
 #include <linux/rbtree.h>
+#include "util.h"
 #include "symbol.h"
 
 enum chain_mode {
diff --git a/tools/perf/util/color.c b/tools/perf/util/color.c
index 90a044d..e88bca5 100644
--- a/tools/perf/util/color.c
+++ b/tools/perf/util/color.c
@@ -166,7 +166,7 @@ int perf_color_default_config(const char *var, const char *value, void *cb)
 	return perf_default_config(var, value, cb);
 }
 
-static int color_vfprintf(FILE *fp, const char *color, const char *fmt,
+static int __color_vfprintf(FILE *fp, const char *color, const char *fmt,
 		va_list args, const char *trail)
 {
 	int r = 0;
@@ -191,6 +191,10 @@ static int color_vfprintf(FILE *fp, const char *color, const char *fmt,
 	return r;
 }
 
+int color_vfprintf(FILE *fp, const char *color, const char *fmt, va_list args)
+{
+	return __color_vfprintf(fp, color, fmt, args, NULL);
+}
 
 
 int color_fprintf(FILE *fp, const char *color, const char *fmt, ...)
@@ -199,7 +203,7 @@ int color_fprintf(FILE *fp, const char *color, const char *fmt, ...)
 	int r;
 
 	va_start(args, fmt);
-	r = color_vfprintf(fp, color, fmt, args, NULL);
+	r = color_vfprintf(fp, color, fmt, args);
 	va_end(args);
 	return r;
 }
@@ -209,7 +213,7 @@ int color_fprintf_ln(FILE *fp, const char *color, const char *fmt, ...)
 	va_list args;
 	int r;
 	va_start(args, fmt);
-	r = color_vfprintf(fp, color, fmt, args, "\n");
+	r = __color_vfprintf(fp, color, fmt, args, "\n");
 	va_end(args);
 	return r;
 }
@@ -242,9 +246,9 @@ int color_fwrite_lines(FILE *fp, const char *color,
 	return 0;
 }
 
-char *get_percent_color(double percent)
+const char *get_percent_color(double percent)
 {
-	char *color = PERF_COLOR_NORMAL;
+	const char *color = PERF_COLOR_NORMAL;
 
 	/*
 	 * We color high-overhead entries in red, mid-overhead
@@ -263,7 +267,7 @@ char *get_percent_color(double percent)
 int percent_color_fprintf(FILE *fp, const char *fmt, double percent)
 {
 	int r;
-	char *color;
+	const char *color;
 
 	color = get_percent_color(percent);
 	r = color_fprintf(fp, color, fmt, percent);
diff --git a/tools/perf/util/color.h b/tools/perf/util/color.h
index 706cec5..58d5975 100644
--- a/tools/perf/util/color.h
+++ b/tools/perf/util/color.h
@@ -32,10 +32,11 @@ int perf_color_default_config(const char *var, const char *value, void *cb);
 int perf_config_colorbool(const char *var, const char *value, int stdout_is_tty);
 void color_parse(const char *value, const char *var, char *dst);
 void color_parse_mem(const char *value, int len, const char *var, char *dst);
+int color_vfprintf(FILE *fp, const char *color, const char *fmt, va_list args);
 int color_fprintf(FILE *fp, const char *color, const char *fmt, ...);
 int color_fprintf_ln(FILE *fp, const char *color, const char *fmt, ...);
 int color_fwrite_lines(FILE *fp, const char *color, size_t count, const char *buf);
 int percent_color_fprintf(FILE *fp, const char *fmt, double percent);
-char *get_percent_color(double percent);
+const char *get_percent_color(double percent);
 
 #endif /* COLOR_H */
diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index 780df54..8784649 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -160,17 +160,18 @@ static int get_extended_base_var(char *name, int baselen, int c)
 	name[baselen++] = '.';
 
 	for (;;) {
-		int c = get_next_char();
-		if (c == '\n')
+		int ch = get_next_char();
+
+		if (ch == '\n')
 			return -1;
-		if (c == '"')
+		if (ch == '"')
 			break;
-		if (c == '\\') {
-			c = get_next_char();
-			if (c == '\n')
+		if (ch == '\\') {
+			ch = get_next_char();
+			if (ch == '\n')
 				return -1;
 		}
-		name[baselen++] = c;
+		name[baselen++] = ch;
 		if (baselen > MAXNAME / 2)
 			return -1;
 	}
@@ -530,6 +531,8 @@ static int store_aux(const char* key, const char* value, void *cb __used)
 					store.offset[store.seen] = ftell(config_file);
 			}
 		}
+	default:
+		break;
 	}
 	return 0;
 }
@@ -619,6 +622,7 @@ contline:
 		switch (contents[offset]) {
 			case '=': equal_offset = offset; break;
 			case ']': bracket_offset = offset; break;
+			default: break;
 		}
 	if (offset > 0 && contents[offset-1] == '\\') {
 		offset_ = offset;
@@ -742,9 +746,9 @@ int perf_config_set_multivar(const char* key, const char* value,
 			goto write_err_out;
 	} else {
 		struct stat st;
-		char* contents;
+		char *contents;
 		ssize_t contents_sz, copy_begin, copy_end;
-		int i, new_line = 0;
+		int new_line = 0;
 
 		if (value_regex == NULL)
 			store.value_regex = NULL;
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
new file mode 100644
index 0000000..e8ca98f
--- /dev/null
+++ b/tools/perf/util/debug.c
@@ -0,0 +1,95 @@
+/* For general debugging purposes */
+
+#include "../perf.h"
+
+#include <string.h>
+#include <stdarg.h>
+#include <stdio.h>
+
+#include "color.h"
+#include "event.h"
+#include "debug.h"
+
+int verbose = 0;
+int dump_trace = 0;
+
+int eprintf(const char *fmt, ...)
+{
+	va_list args;
+	int ret = 0;
+
+	if (verbose) {
+		va_start(args, fmt);
+		ret = vfprintf(stderr, fmt, args);
+		va_end(args);
+	}
+
+	return ret;
+}
+
+int dump_printf(const char *fmt, ...)
+{
+	va_list args;
+	int ret = 0;
+
+	if (dump_trace) {
+		va_start(args, fmt);
+		ret = vprintf(fmt, args);
+		va_end(args);
+	}
+
+	return ret;
+}
+
+static int dump_printf_color(const char *fmt, const char *color, ...)
+{
+	va_list args;
+	int ret = 0;
+
+	if (dump_trace) {
+		va_start(args, color);
+		ret = color_vfprintf(stdout, color, fmt, args);
+		va_end(args);
+	}
+
+	return ret;
+}
+
+
+void trace_event(event_t *event)
+{
+	unsigned char *raw_event = (void *)event;
+	const char *color = PERF_COLOR_BLUE;
+	int i, j;
+
+	if (!dump_trace)
+		return;
+
+	dump_printf(".");
+	dump_printf_color("\n. ... raw event: size %d bytes\n", color,
+			  event->header.size);
+
+	for (i = 0; i < event->header.size; i++) {
+		if ((i & 15) == 0) {
+			dump_printf(".");
+			dump_printf_color("  %04x: ", color, i);
+		}
+
+		dump_printf_color(" %02x", color, raw_event[i]);
+
+		if (((i & 15) == 15) || i == event->header.size-1) {
+			dump_printf_color("  ", color);
+			for (j = 0; j < 15-(i & 15); j++)
+				dump_printf_color("   ", color);
+			for (j = 0; j < (i & 15); j++) {
+				if (isprint(raw_event[i-15+j]))
+					dump_printf_color("%c", color,
+							  raw_event[i-15+j]);
+				else
+					dump_printf_color(".", color);
+			}
+			dump_printf_color("\n", color);
+		}
+	}
+	dump_printf(".\n");
+}
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
new file mode 100644
index 0000000..437eea5
--- /dev/null
+++ b/tools/perf/util/debug.h
@@ -0,0 +1,8 @@
+/* For debugging general purposes */
+
+extern int verbose;
+extern int dump_trace;
+
+int eprintf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
+int dump_printf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
+void trace_event(event_t *event);
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
new file mode 100644
index 0000000..fa2d4e9
--- /dev/null
+++ b/tools/perf/util/event.h
@@ -0,0 +1,96 @@
+#ifndef __PERF_EVENT_H
+#define __PERF_EVENT_H
+#include "../perf.h"
+#include "util.h"
+#include <linux/list.h>
+
+enum {
+	SHOW_KERNEL	= 1,
+	SHOW_USER	= 2,
+	SHOW_HV		= 4,
+};
+
+/*
+ * PERF_SAMPLE_IP | PERF_SAMPLE_TID | *
+ */
+struct ip_event {
+	struct perf_event_header header;
+	u64 ip;
+	u32 pid, tid;
+	unsigned char __more_data[];
+};
+
+struct mmap_event {
+	struct perf_event_header header;
+	u32 pid, tid;
+	u64 start;
+	u64 len;
+	u64 pgoff;
+	char filename[PATH_MAX];
+};
+
+struct comm_event {
+	struct perf_event_header header;
+	u32 pid, tid;
+	char comm[16];
+};
+
+struct fork_event {
+	struct perf_event_header header;
+	u32 pid, ppid;
+	u32 tid, ptid;
+};
+
+struct lost_event {
+	struct perf_event_header header;
+	u64 id;
+	u64 lost;
+};
+
+/*
+ * PERF_FORMAT_ENABLED | PERF_FORMAT_RUNNING | PERF_FORMAT_ID
+ */
+struct read_event {
+	struct perf_event_header header;
+	u32 pid,tid;
+	u64 value;
+	u64 time_enabled;
+	u64 time_running;
+	u64 id;
+};
+
+typedef union event_union {
+	struct perf_event_header	header;
+	struct ip_event			ip;
+	struct mmap_event		mmap;
+	struct comm_event		comm;
+	struct fork_event		fork;
+	struct lost_event		lost;
+	struct read_event		read;
+} event_t;
+
+struct map {
+	struct list_head	node;
+	u64			start;
+	u64			end;
+	u64			pgoff;
+	u64			(*map_ip)(struct map *, u64);
+	struct dso		*dso;
+};
+
+static inline u64 map__map_ip(struct map *map, u64 ip)
+{
+	return ip - map->start + map->pgoff;
+}
+
+static inline u64 vdso__map_ip(struct map *map __used, u64 ip)
+{
+	return ip;
+}
+
+struct map *map__new(struct mmap_event *event, char *cwd, int cwdlen);
+struct map *map__clone(struct map *self);
+int map__overlap(struct map *l, struct map *r);
+size_t map__fprintf(struct map *self, FILE *fp);
+
+#endif
diff --git a/tools/perf/util/exec_cmd.c b/tools/perf/util/exec_cmd.c
index 34a3528..2745605 100644
--- a/tools/perf/util/exec_cmd.c
+++ b/tools/perf/util/exec_cmd.c
@@ -6,7 +6,6 @@
 
 #define MAX_ARGS	32
 
-extern char **environ;
 static const char *argv_exec_path;
 static const char *argv0_path;
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index b92a457..ec4d4c2 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -237,9 +237,44 @@ struct perf_header *perf_header__read(int fd)
 	self->data_offset = f_header.data.offset;
 	self->data_size   = f_header.data.size;
 
-	lseek(fd, self->data_offset + self->data_size, SEEK_SET);
+	lseek(fd, self->data_offset, SEEK_SET);
 
 	self->frozen = 1;
 
 	return self;
 }
+
+u64 perf_header__sample_type(struct perf_header *header)
+{
+	u64 type = 0;
+	int i;
+
+	for (i = 0; i < header->attrs; i++) {
+		struct perf_header_attr *attr = header->attr[i];
+
+		if (!type)
+			type = attr->attr.sample_type;
+		else if (type != attr->attr.sample_type)
+			die("non matching sample_type");
+	}
+
+	return type;
+}
+
+struct perf_counter_attr *
+perf_header__find_attr(u64 id, struct perf_header *header)
+{
+	int i;
+
+	for (i = 0; i < header->attrs; i++) {
+		struct perf_header_attr *attr = header->attr[i];
+		int j;
+
+		for (j = 0; j < attr->ids; j++) {
+			if (attr->id[j] == id)
+				return &attr->attr;
+		}
+	}
+
+	return NULL;
+}
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index bf28044..5d0a72e 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -31,6 +31,10 @@ struct perf_header_attr *
 perf_header_attr__new(struct perf_counter_attr *attr);
 void perf_header_attr__add_id(struct perf_header_attr *self, u64 id);
 
+u64 perf_header__sample_type(struct perf_header *header);
+struct perf_counter_attr *
+perf_header__find_attr(u64 id, struct perf_header *header);
+
 
 struct perf_header *perf_header__new(void);
 
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
new file mode 100644
index 0000000..804e023
--- /dev/null
+++ b/tools/perf/util/map.c
@@ -0,0 +1,97 @@
+#include "event.h"
+#include "symbol.h"
+#include <stdlib.h>
+#include <string.h>
+#include <stdio.h>
+
+static inline int is_anon_memory(const char *filename)
+{
+	return strcmp(filename, "//anon") == 0;
+}
+
+static int strcommon(const char *pathname, char *cwd, int cwdlen)
+{
+	int n = 0;
+
+	while (n < cwdlen && pathname[n] == cwd[n])
+		++n;
+
+	return n;
+}
+
+ struct map *map__new(struct mmap_event *event, char *cwd, int cwdlen)
+{
+	struct map *self = malloc(sizeof(*self));
+
+	if (self != NULL) {
+		const char *filename = event->filename;
+		char newfilename[PATH_MAX];
+		int anon;
+
+		if (cwd) {
+			int n = strcommon(filename, cwd, cwdlen);
+
+			if (n == cwdlen) {
+				snprintf(newfilename, sizeof(newfilename),
+					 ".%s", filename + n);
+				filename = newfilename;
+			}
+		}
+
+		anon = is_anon_memory(filename);
+
+		if (anon) {
+			snprintf(newfilename, sizeof(newfilename), "/tmp/perf-%d.map", event->pid);
+			filename = newfilename;
+		}
+
+		self->start = event->start;
+		self->end   = event->start + event->len;
+		self->pgoff = event->pgoff;
+
+		self->dso = dsos__findnew(filename);
+		if (self->dso == NULL)
+			goto out_delete;
+
+		if (self->dso == vdso || anon)
+			self->map_ip = vdso__map_ip;
+		else
+			self->map_ip = map__map_ip;
+	}
+	return self;
+out_delete:
+	free(self);
+	return NULL;
+}
+
+struct map *map__clone(struct map *self)
+{
+	struct map *map = malloc(sizeof(*self));
+
+	if (!map)
+		return NULL;
+
+	memcpy(map, self, sizeof(*self));
+
+	return map;
+}
+
+int map__overlap(struct map *l, struct map *r)
+{
+	if (l->start > r->start) {
+		struct map *t = l;
+		l = r;
+		r = t;
+	}
+
+	if (l->end > r->start)
+		return 1;
+
+	return 0;
+}
+
+size_t map__fprintf(struct map *self, FILE *fp)
+{
+	return fprintf(fp, " %Lx-%Lx %Lx %s\n",
+		       self->start, self->end, self->pgoff, self->dso->name);
+}
diff --git a/tools/perf/util/module.c b/tools/perf/util/module.c
index ddabe92..3d567fe 100644
--- a/tools/perf/util/module.c
+++ b/tools/perf/util/module.c
@@ -436,9 +436,9 @@ static int mod_dso__load_module_paths(struct mod_dso *self)
 		goto out_failure;
 
 	while (!feof(file)) {
-		char *path, *name, *tmp;
+		char *name, *tmp;
 		struct module *module;
-		int line_len, len;
+		int line_len;
 
 		line_len = getline(&line, &n, file);
 		if (line_len < 0)
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 0441784..52219d5 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1,23 +1,21 @@
 
-#include "../perf.h"
 #include "util.h"
+#include "../perf.h"
 #include "parse-options.h"
 #include "parse-events.h"
 #include "exec_cmd.h"
 #include "string.h"
 #include "cache.h"
 
-extern char *strcasestr(const char *haystack, const char *needle);
-
 int					nr_counters;
 
 struct perf_counter_attr		attrs[MAX_COUNTERS];
 
 struct event_symbol {
-	u8	type;
-	u64	config;
-	char	*symbol;
-	char	*alias;
+	u8		type;
+	u64		config;
+	const char	*symbol;
+	const char	*alias;
 };
 
 char debugfs_path[MAXPATHLEN];
@@ -51,7 +49,7 @@ static struct event_symbol event_symbols[] = {
 #define PERF_COUNTER_TYPE(config)	__PERF_COUNTER_FIELD(config, TYPE)
 #define PERF_COUNTER_ID(config)		__PERF_COUNTER_FIELD(config, EVENT)
 
-static char *hw_event_names[] = {
+static const char *hw_event_names[] = {
 	"cycles",
 	"instructions",
 	"cache-references",
@@ -61,7 +59,7 @@ static char *hw_event_names[] = {
 	"bus-cycles",
 };
 
-static char *sw_event_names[] = {
+static const char *sw_event_names[] = {
 	"cpu-clock-msecs",
 	"task-clock-msecs",
 	"page-faults",
@@ -73,7 +71,7 @@ static char *sw_event_names[] = {
 
 #define MAX_ALIASES 8
 
-static char *hw_cache[][MAX_ALIASES] = {
+static const char *hw_cache[][MAX_ALIASES] = {
  { "L1-dcache",	"l1-d",		"l1d",		"L1-data",		},
  { "L1-icache",	"l1-i",		"l1i",		"L1-instruction",	},
  { "LLC",	"L2"							},
@@ -82,13 +80,13 @@ static char *hw_cache[][MAX_ALIASES] = {
  { "branch",	"branches",	"bpu",		"btb",		"bpc",	},
 };
 
-static char *hw_cache_op[][MAX_ALIASES] = {
+static const char *hw_cache_op[][MAX_ALIASES] = {
  { "load",	"loads",	"read",					},
  { "store",	"stores",	"write",				},
  { "prefetch",	"prefetches",	"speculative-read", "speculative-load",	},
 };
 
-static char *hw_cache_result[][MAX_ALIASES] = {
+static const char *hw_cache_result[][MAX_ALIASES] = {
  { "refs",	"Reference",	"ops",		"access",		},
  { "misses",	"miss",							},
 };
@@ -113,11 +111,9 @@ static unsigned long hw_cache_stat[C(MAX)] = {
  [C(BPU)]	= (CACHE_READ),
 };
 
-#define for_each_subsystem(sys_dir, sys_dirent, sys_next, file, st)	       \
+#define for_each_subsystem(sys_dir, sys_dirent, sys_next)	       \
 	while (!readdir_r(sys_dir, &sys_dirent, &sys_next) && sys_next)	       \
-	if (snprintf(file, MAXPATHLEN, "%s/%s", debugfs_path,	       	       \
-			sys_dirent.d_name) &&		       		       \
-	   (!stat(file, &st)) && (S_ISDIR(st.st_mode)) &&		       \
+	if (sys_dirent.d_type == DT_DIR &&				       \
 	   (strcmp(sys_dirent.d_name, ".")) &&				       \
 	   (strcmp(sys_dirent.d_name, "..")))
 
@@ -136,11 +132,9 @@ static int tp_event_has_id(struct dirent *sys_dir, struct dirent *evt_dir)
 	return 0;
 }
 
-#define for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next, file, st)    \
+#define for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next)	       \
 	while (!readdir_r(evt_dir, &evt_dirent, &evt_next) && evt_next)        \
-	if (snprintf(file, MAXPATHLEN, "%s/%s/%s", debugfs_path,	       \
-		     sys_dirent.d_name, evt_dirent.d_name) &&		       \
-	   (!stat(file, &st)) && (S_ISDIR(st.st_mode)) &&		       \
+	if (evt_dirent.d_type == DT_DIR &&				       \
 	   (strcmp(evt_dirent.d_name, ".")) &&				       \
 	   (strcmp(evt_dirent.d_name, "..")) &&				       \
 	   (!tp_event_has_id(&sys_dirent, &evt_dirent)))
@@ -158,34 +152,39 @@ int valid_debugfs_mount(const char *debugfs)
 	return 0;
 }
 
-static char *tracepoint_id_to_name(u64 config)
+struct tracepoint_path *tracepoint_id_to_path(u64 config)
 {
-	static char tracepoint_name[2 * MAX_EVENT_LENGTH];
+	struct tracepoint_path *path = NULL;
 	DIR *sys_dir, *evt_dir;
 	struct dirent *sys_next, *evt_next, sys_dirent, evt_dirent;
-	struct stat st;
 	char id_buf[4];
-	int fd;
+	int sys_dir_fd, fd;
 	u64 id;
 	char evt_path[MAXPATHLEN];
 
 	if (valid_debugfs_mount(debugfs_path))
-		return "unkown";
+		return NULL;
 
 	sys_dir = opendir(debugfs_path);
 	if (!sys_dir)
 		goto cleanup;
-
-	for_each_subsystem(sys_dir, sys_dirent, sys_next, evt_path, st) {
-		evt_dir = opendir(evt_path);
-		if (!evt_dir)
-			goto cleanup;
-		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next,
-								evt_path, st) {
-			snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id",
-				 debugfs_path, sys_dirent.d_name,
+	sys_dir_fd = dirfd(sys_dir);
+
+	for_each_subsystem(sys_dir, sys_dirent, sys_next) {
+		int dfd = openat(sys_dir_fd, sys_dirent.d_name,
+				 O_RDONLY|O_DIRECTORY), evt_dir_fd;
+		if (dfd == -1)
+			continue;
+		evt_dir = fdopendir(dfd);
+		if (!evt_dir) {
+			close(dfd);
+			continue;
+		}
+		evt_dir_fd = dirfd(evt_dir);
+		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next) {
+			snprintf(evt_path, MAXPATHLEN, "%s/id",
 				 evt_dirent.d_name);
-			fd = open(evt_path, O_RDONLY);
+			fd = openat(evt_dir_fd, evt_path, O_RDONLY);
 			if (fd < 0)
 				continue;
 			if (read(fd, id_buf, sizeof(id_buf)) < 0) {
@@ -197,10 +196,23 @@ static char *tracepoint_id_to_name(u64 config)
 			if (id == config) {
 				closedir(evt_dir);
 				closedir(sys_dir);
-				snprintf(tracepoint_name, 2 * MAX_EVENT_LENGTH,
-					"%s:%s", sys_dirent.d_name,
-					evt_dirent.d_name);
-				return tracepoint_name;
+				path = calloc(1, sizeof(path));
+				path->system = malloc(MAX_EVENT_LENGTH);
+				if (!path->system) {
+					free(path);
+					return NULL;
+				}
+				path->name = malloc(MAX_EVENT_LENGTH);
+				if (!path->name) {
+					free(path->system);
+					free(path);
+					return NULL;
+				}
+				strncpy(path->system, sys_dirent.d_name,
+					MAX_EVENT_LENGTH);
+				strncpy(path->name, evt_dirent.d_name,
+					MAX_EVENT_LENGTH);
+				return path;
 			}
 		}
 		closedir(evt_dir);
@@ -208,7 +220,25 @@ static char *tracepoint_id_to_name(u64 config)
 
 cleanup:
 	closedir(sys_dir);
-	return "unkown";
+	return NULL;
+}
+
+#define TP_PATH_LEN (MAX_EVENT_LENGTH * 2 + 1)
+static const char *tracepoint_id_to_name(u64 config)
+{
+	static char buf[TP_PATH_LEN];
+	struct tracepoint_path *path;
+
+	path = tracepoint_id_to_path(config);
+	if (path) {
+		snprintf(buf, TP_PATH_LEN, "%s:%s", path->system, path->name);
+		free(path->name);
+		free(path->system);
+		free(path);
+	} else
+		snprintf(buf, TP_PATH_LEN, "%s:%s", "unknown", "unknown");
+
+	return buf;
 }
 
 static int is_cache_op_valid(u8 cache_type, u8 cache_op)
@@ -235,7 +265,7 @@ static char *event_cache_name(u8 cache_type, u8 cache_op, u8 cache_result)
 	return name;
 }
 
-char *event_name(int counter)
+const char *event_name(int counter)
 {
 	u64 config = attrs[counter].config;
 	int type = attrs[counter].type;
@@ -243,7 +273,7 @@ char *event_name(int counter)
 	return __event_name(type, config);
 }
 
-char *__event_name(int type, u64 config)
+const char *__event_name(int type, u64 config)
 {
 	static char buf[32];
 
@@ -294,7 +324,7 @@ char *__event_name(int type, u64 config)
 	return "unknown";
 }
 
-static int parse_aliases(const char **str, char *names[][MAX_ALIASES], int size)
+static int parse_aliases(const char **str, const char *names[][MAX_ALIASES], int size)
 {
 	int i, j;
 	int n, longest = -1;
@@ -598,7 +628,7 @@ static void print_tracepoint_events(void)
 {
 	DIR *sys_dir, *evt_dir;
 	struct dirent *sys_next, *evt_next, sys_dirent, evt_dirent;
-	struct stat st;
+	int sys_dir_fd;
 	char evt_path[MAXPATHLEN];
 
 	if (valid_debugfs_mount(debugfs_path))
@@ -607,13 +637,20 @@ static void print_tracepoint_events(void)
 	sys_dir = opendir(debugfs_path);
 	if (!sys_dir)
 		goto cleanup;
-
-	for_each_subsystem(sys_dir, sys_dirent, sys_next, evt_path, st) {
-		evt_dir = opendir(evt_path);
-		if (!evt_dir)
-			goto cleanup;
-		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next,
-								evt_path, st) {
+	sys_dir_fd = dirfd(sys_dir);
+
+	for_each_subsystem(sys_dir, sys_dirent, sys_next) {
+		int dfd = openat(sys_dir_fd, sys_dirent.d_name,
+				 O_RDONLY|O_DIRECTORY), evt_dir_fd;
+		if (dfd == -1)
+			continue;
+		evt_dir = fdopendir(dfd);
+		if (!evt_dir) {
+			close(dfd);
+			continue;
+		}
+		evt_dir_fd = dirfd(evt_dir);
+		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next) {
 			snprintf(evt_path, MAXPATHLEN, "%s:%s",
 				 sys_dirent.d_name, evt_dirent.d_name);
 			fprintf(stderr, "  %-40s [%s]\n", evt_path,
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 192a962..60704c1 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -1,16 +1,25 @@
-
+#ifndef _PARSE_EVENTS_H
+#define _PARSE_EVENTS_H
 /*
  * Parse symbolic events/counts passed in as options:
  */
 
 struct option;
 
+struct tracepoint_path {
+	char *system;
+	char *name;
+	struct tracepoint_path *next;
+};
+
+extern struct tracepoint_path *tracepoint_id_to_path(u64 config);
+
 extern int			nr_counters;
 
 extern struct perf_counter_attr attrs[MAX_COUNTERS];
 
-extern char *event_name(int ctr);
-extern char *__event_name(int type, u64 config);
+extern const char *event_name(int ctr);
+extern const char *__event_name(int type, u64 config);
 
 extern int parse_events(const struct option *opt, const char *str, int unset);
 
@@ -21,3 +30,5 @@ extern void print_events(void);
 extern char debugfs_path[];
 extern int valid_debugfs_mount(const char *debugfs);
 
+
+#endif /* _PARSE_EVENTS_H */
diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
index 1bf6719..6d8af48 100644
--- a/tools/perf/util/parse-options.c
+++ b/tools/perf/util/parse-options.c
@@ -53,6 +53,12 @@ static int get_value(struct parse_opt_ctx_t *p,
 		case OPTION_SET_INT:
 		case OPTION_SET_PTR:
 			return opterror(opt, "takes no value", flags);
+		case OPTION_END:
+		case OPTION_ARGUMENT:
+		case OPTION_GROUP:
+		case OPTION_STRING:
+		case OPTION_INTEGER:
+		case OPTION_LONG:
 		default:
 			break;
 		}
@@ -130,6 +136,9 @@ static int get_value(struct parse_opt_ctx_t *p,
 			return opterror(opt, "expects a numerical value", flags);
 		return 0;
 
+	case OPTION_END:
+	case OPTION_ARGUMENT:
+	case OPTION_GROUP:
 	default:
 		die("should not happen, someone must be hit on the forehead");
 	}
@@ -296,6 +305,8 @@ int parse_options_step(struct parse_opt_ctx_t *ctx,
 				return parse_options_usage(usagestr, options);
 			case -2:
 				goto unknown;
+			default:
+				break;
 			}
 			if (ctx->opt)
 				check_typos(arg + 1, options);
@@ -314,6 +325,8 @@ int parse_options_step(struct parse_opt_ctx_t *ctx,
 					ctx->argv[0] = strdup(ctx->opt - 1);
 					*(char *)ctx->argv[0] = '-';
 					goto unknown;
+				default:
+					break;
 				}
 			}
 			continue;
@@ -336,6 +349,8 @@ int parse_options_step(struct parse_opt_ctx_t *ctx,
 			return parse_options_usage(usagestr, options);
 		case -2:
 			goto unknown;
+		default:
+			break;
 		}
 		continue;
 unknown:
@@ -456,6 +471,13 @@ int usage_with_options_internal(const char * const *usagestr,
 			}
 			break;
 		default: /* OPTION_{BIT,BOOLEAN,SET_INT,SET_PTR} */
+		case OPTION_END:
+		case OPTION_GROUP:
+		case OPTION_BIT:
+		case OPTION_BOOLEAN:
+		case OPTION_SET_INT:
+		case OPTION_SET_PTR:
+		case OPTION_LONG:
 			break;
 		}
 
diff --git a/tools/perf/util/path.c b/tools/perf/util/path.c
index a501a40..fd1f2fa 100644
--- a/tools/perf/util/path.c
+++ b/tools/perf/util/path.c
@@ -17,7 +17,7 @@ static char bad_path[] = "/bad-path/";
  * Two hacks:
  */
 
-static char *get_perf_dir(void)
+static const char *get_perf_dir(void)
 {
 	return ".";
 }
@@ -38,8 +38,9 @@ size_t strlcpy(char *dest, const char *src, size_t size)
 static char *get_pathname(void)
 {
 	static char pathname_array[4][PATH_MAX];
-	static int index;
-	return pathname_array[3 & ++index];
+	static int idx;
+
+	return pathname_array[3 & ++idx];
 }
 
 static char *cleanup_path(char *path)
@@ -161,20 +162,24 @@ int perf_mkstemp(char *path, size_t len, const char *template)
 }
 
 
-const char *make_relative_path(const char *abs, const char *base)
+const char *make_relative_path(const char *abs_path, const char *base)
 {
 	static char buf[PATH_MAX + 1];
 	int baselen;
+
 	if (!base)
-		return abs;
+		return abs_path;
+
 	baselen = strlen(base);
-	if (prefixcmp(abs, base))
-		return abs;
-	if (abs[baselen] == '/')
+	if (prefixcmp(abs_path, base))
+		return abs_path;
+	if (abs_path[baselen] == '/')
 		baselen++;
 	else if (base[baselen - 1] != '/')
-		return abs;
-	strcpy(buf, abs + baselen);
+		return abs_path;
+
+	strcpy(buf, abs_path + baselen);
+
 	return buf;
 }
 
diff --git a/tools/perf/util/run-command.c b/tools/perf/util/run-command.c
index a393534..2b615ac 100644
--- a/tools/perf/util/run-command.c
+++ b/tools/perf/util/run-command.c
@@ -262,7 +262,7 @@ int run_hook(const char *index_file, const char *name, ...)
 {
 	struct child_process hook;
 	const char **argv = NULL, *env[2];
-	char index[PATH_MAX];
+	char idx[PATH_MAX];
 	va_list args;
 	int ret;
 	size_t i = 0, alloc = 0;
@@ -284,8 +284,8 @@ int run_hook(const char *index_file, const char *name, ...)
 	hook.no_stdin = 1;
 	hook.stdout_to_stderr = 1;
 	if (index_file) {
-		snprintf(index, sizeof(index), "PERF_INDEX_FILE=%s", index_file);
-		env[0] = index;
+		snprintf(idx, sizeof(idx), "PERF_INDEX_FILE=%s", index_file);
+		env[0] = idx;
 		env[1] = NULL;
 		hook.env = env;
 	}
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 5c0f42e..fd3d9c8 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -3,6 +3,8 @@
 #include "string.h"
 #include "symbol.h"
 
+#include "debug.h"
+
 #include <libelf.h>
 #include <gelf.h>
 #include <elf.h>
@@ -21,7 +23,7 @@ enum dso_origin {
 
 static struct symbol *symbol__new(u64 start, u64 len,
 				  const char *name, unsigned int priv_size,
-				  u64 obj_start, int verbose)
+				  u64 obj_start, int v)
 {
 	size_t namelen = strlen(name) + 1;
 	struct symbol *self = calloc(1, priv_size + sizeof(*self) + namelen);
@@ -29,7 +31,7 @@ static struct symbol *symbol__new(u64 start, u64 len,
 	if (!self)
 		return NULL;
 
-	if (verbose >= 2)
+	if (v >= 2)
 		printf("new symbol: %016Lx [%08lx]: %s, hist: %p, obj_start: %p\n",
 			(u64)start, (unsigned long)len, name, self->hist, (void *)(unsigned long)obj_start);
 
@@ -156,7 +158,7 @@ size_t dso__fprintf(struct dso *self, FILE *fp)
 	return ret;
 }
 
-static int dso__load_kallsyms(struct dso *self, symbol_filter_t filter, int verbose)
+static int dso__load_kallsyms(struct dso *self, symbol_filter_t filter, int v)
 {
 	struct rb_node *nd, *prevnd;
 	char *line = NULL;
@@ -198,7 +200,7 @@ static int dso__load_kallsyms(struct dso *self, symbol_filter_t filter, int verb
 		 * Well fix up the end later, when we have all sorted.
 		 */
 		sym = symbol__new(start, 0xdead, line + len + 2,
-				  self->sym_priv_size, 0, verbose);
+				  self->sym_priv_size, 0, v);
 
 		if (sym == NULL)
 			goto out_delete_line;
@@ -239,7 +241,7 @@ out_failure:
 	return -1;
 }
 
-static int dso__load_perf_map(struct dso *self, symbol_filter_t filter, int verbose)
+static int dso__load_perf_map(struct dso *self, symbol_filter_t filter, int v)
 {
 	char *line = NULL;
 	size_t n;
@@ -277,7 +279,7 @@ static int dso__load_perf_map(struct dso *self, symbol_filter_t filter, int verb
 			continue;
 
 		sym = symbol__new(start, size, line + len,
-				  self->sym_priv_size, start, verbose);
+				  self->sym_priv_size, start, v);
 
 		if (sym == NULL)
 			goto out_delete_line;
@@ -305,13 +307,13 @@ out_failure:
  * elf_symtab__for_each_symbol - iterate thru all the symbols
  *
  * @self: struct elf_symtab instance to iterate
- * @index: uint32_t index
+ * @idx: uint32_t idx
  * @sym: GElf_Sym iterator
  */
-#define elf_symtab__for_each_symbol(syms, nr_syms, index, sym) \
-	for (index = 0, gelf_getsym(syms, index, &sym);\
-	     index < nr_syms; \
-	     index++, gelf_getsym(syms, index, &sym))
+#define elf_symtab__for_each_symbol(syms, nr_syms, idx, sym) \
+	for (idx = 0, gelf_getsym(syms, idx, &sym);\
+	     idx < nr_syms; \
+	     idx++, gelf_getsym(syms, idx, &sym))
 
 static inline uint8_t elf_sym__type(const GElf_Sym *sym)
 {
@@ -354,7 +356,7 @@ static inline const char *elf_sym__name(const GElf_Sym *sym,
 
 static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
 				    GElf_Shdr *shp, const char *name,
-				    size_t *index)
+				    size_t *idx)
 {
 	Elf_Scn *sec = NULL;
 	size_t cnt = 1;
@@ -365,8 +367,8 @@ static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
 		gelf_getshdr(sec, shp);
 		str = elf_strptr(elf, ep->e_shstrndx, shp->sh_name);
 		if (!strcmp(name, str)) {
-			if (index)
-				*index = cnt;
+			if (idx)
+				*idx = cnt;
 			break;
 		}
 		++cnt;
@@ -392,7 +394,7 @@ static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
  * And always look at the original dso, not at debuginfo packages, that
  * have the PLT data stripped out (shdr_rel_plt.sh_type == SHT_NOBITS).
  */
-static int dso__synthesize_plt_symbols(struct  dso *self, int verbose)
+static int dso__synthesize_plt_symbols(struct  dso *self, int v)
 {
 	uint32_t nr_rel_entries, idx;
 	GElf_Sym sym;
@@ -442,7 +444,7 @@ static int dso__synthesize_plt_symbols(struct  dso *self, int verbose)
 		goto out_elf_end;
 
 	/*
-	 * Fetch the relocation section to find the indexes to the GOT
+	 * Fetch the relocation section to find the idxes to the GOT
 	 * and the symbols in the .dynsym they refer to.
 	 */
 	reldata = elf_getdata(scn_plt_rel, NULL);
@@ -476,7 +478,7 @@ static int dso__synthesize_plt_symbols(struct  dso *self, int verbose)
 				 "%s@plt", elf_sym__name(&sym, symstrs));
 
 			f = symbol__new(plt_offset, shdr_plt.sh_entsize,
-					sympltname, self->sym_priv_size, 0, verbose);
+					sympltname, self->sym_priv_size, 0, v);
 			if (!f)
 				goto out_elf_end;
 
@@ -494,7 +496,7 @@ static int dso__synthesize_plt_symbols(struct  dso *self, int verbose)
 				 "%s@plt", elf_sym__name(&sym, symstrs));
 
 			f = symbol__new(plt_offset, shdr_plt.sh_entsize,
-					sympltname, self->sym_priv_size, 0, verbose);
+					sympltname, self->sym_priv_size, 0, v);
 			if (!f)
 				goto out_elf_end;
 
@@ -518,12 +520,12 @@ out:
 }
 
 static int dso__load_sym(struct dso *self, int fd, const char *name,
-			 symbol_filter_t filter, int verbose, struct module *mod)
+			 symbol_filter_t filter, int v, struct module *mod)
 {
 	Elf_Data *symstrs, *secstrs;
 	uint32_t nr_syms;
 	int err = -1;
-	uint32_t index;
+	uint32_t idx;
 	GElf_Ehdr ehdr;
 	GElf_Shdr shdr;
 	Elf_Data *syms;
@@ -534,14 +536,14 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 
 	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
 	if (elf == NULL) {
-		if (verbose)
+		if (v)
 			fprintf(stderr, "%s: cannot read %s ELF file.\n",
 				__func__, name);
 		goto out_close;
 	}
 
 	if (gelf_getehdr(elf, &ehdr) == NULL) {
-		if (verbose)
+		if (v)
 			fprintf(stderr, "%s: cannot get elf header.\n", __func__);
 		goto out_elf_end;
 	}
@@ -583,9 +585,9 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 						     NULL) != NULL);
 	} else self->adjust_symbols = 0;
 
-	elf_symtab__for_each_symbol(syms, nr_syms, index, sym) {
+	elf_symtab__for_each_symbol(syms, nr_syms, idx, sym) {
 		struct symbol *f;
-		const char *name;
+		const char *elf_name;
 		char *demangled;
 		u64 obj_start;
 		struct section *section = NULL;
@@ -608,7 +610,7 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 		obj_start = sym.st_value;
 
 		if (self->adjust_symbols) {
-			if (verbose >= 2)
+			if (v >= 2)
 				printf("adjusting symbol: st_value: %Lx sh_addr: %Lx sh_offset: %Lx\n",
 					(u64)sym.st_value, (u64)shdr.sh_addr, (u64)shdr.sh_offset);
 
@@ -630,13 +632,13 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 		 * DWARF DW_compile_unit has this, but we don't always have access
 		 * to it...
 		 */
-		name = elf_sym__name(&sym, symstrs);
-		demangled = bfd_demangle(NULL, name, DMGL_PARAMS | DMGL_ANSI);
+		elf_name = elf_sym__name(&sym, symstrs);
+		demangled = bfd_demangle(NULL, elf_name, DMGL_PARAMS | DMGL_ANSI);
 		if (demangled != NULL)
-			name = demangled;
+			elf_name = demangled;
 
-		f = symbol__new(sym.st_value, sym.st_size, name,
-				self->sym_priv_size, obj_start, verbose);
+		f = symbol__new(sym.st_value, sym.st_size, elf_name,
+				self->sym_priv_size, obj_start, v);
 		free(demangled);
 		if (!f)
 			goto out_elf_end;
@@ -659,7 +661,7 @@ out_close:
 
 #define BUILD_ID_SIZE 128
 
-static char *dso__read_build_id(struct dso *self, int verbose)
+static char *dso__read_build_id(struct dso *self, int v)
 {
 	int i;
 	GElf_Ehdr ehdr;
@@ -676,14 +678,14 @@ static char *dso__read_build_id(struct dso *self, int verbose)
 
 	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
 	if (elf == NULL) {
-		if (verbose)
+		if (v)
 			fprintf(stderr, "%s: cannot read %s ELF file.\n",
 				__func__, self->name);
 		goto out_close;
 	}
 
 	if (gelf_getehdr(elf, &ehdr) == NULL) {
-		if (verbose)
+		if (v)
 			fprintf(stderr, "%s: cannot get elf header.\n", __func__);
 		goto out_elf_end;
 	}
@@ -706,7 +708,7 @@ static char *dso__read_build_id(struct dso *self, int verbose)
 		++raw;
 		bid += 2;
 	}
-	if (verbose >= 2)
+	if (v >= 2)
 		printf("%s(%s): %s\n", __func__, self->name, build_id);
 out_elf_end:
 	elf_end(elf);
@@ -732,7 +734,7 @@ char dso__symtab_origin(const struct dso *self)
 	return origin[self->origin];
 }
 
-int dso__load(struct dso *self, symbol_filter_t filter, int verbose)
+int dso__load(struct dso *self, symbol_filter_t filter, int v)
 {
 	int size = PATH_MAX;
 	char *name = malloc(size), *build_id = NULL;
@@ -745,7 +747,7 @@ int dso__load(struct dso *self, symbol_filter_t filter, int verbose)
 	self->adjust_symbols = 0;
 
 	if (strncmp(self->name, "/tmp/perf-", 10) == 0) {
-		ret = dso__load_perf_map(self, filter, verbose);
+		ret = dso__load_perf_map(self, filter, v);
 		self->origin = ret > 0 ? DSO__ORIG_JAVA_JIT :
 					 DSO__ORIG_NOT_FOUND;
 		return ret;
@@ -764,7 +766,7 @@ more:
 			snprintf(name, size, "/usr/lib/debug%s", self->name);
 			break;
 		case DSO__ORIG_BUILDID:
-			build_id = dso__read_build_id(self, verbose);
+			build_id = dso__read_build_id(self, v);
 			if (build_id != NULL) {
 				snprintf(name, size,
 					 "/usr/lib/debug/.build-id/%.2s/%s.debug",
@@ -785,7 +787,7 @@ more:
 		fd = open(name, O_RDONLY);
 	} while (fd < 0);
 
-	ret = dso__load_sym(self, fd, name, filter, verbose, NULL);
+	ret = dso__load_sym(self, fd, name, filter, v, NULL);
 	close(fd);
 
 	/*
@@ -795,7 +797,7 @@ more:
 		goto more;
 
 	if (ret > 0) {
-		int nr_plt = dso__synthesize_plt_symbols(self, verbose);
+		int nr_plt = dso__synthesize_plt_symbols(self, v);
 		if (nr_plt > 0)
 			ret += nr_plt;
 	}
@@ -807,7 +809,7 @@ out:
 }
 
 static int dso__load_module(struct dso *self, struct mod_dso *mods, const char *name,
-			     symbol_filter_t filter, int verbose)
+			     symbol_filter_t filter, int v)
 {
 	struct module *mod = mod_dso__find_module(mods, name);
 	int err = 0, fd;
@@ -820,13 +822,13 @@ static int dso__load_module(struct dso *self, struct mod_dso *mods, const char *
 	if (fd < 0)
 		return err;
 
-	err = dso__load_sym(self, fd, name, filter, verbose, mod);
+	err = dso__load_sym(self, fd, name, filter, v, mod);
 	close(fd);
 
 	return err;
 }
 
-int dso__load_modules(struct dso *self, symbol_filter_t filter, int verbose)
+int dso__load_modules(struct dso *self, symbol_filter_t filter, int v)
 {
 	struct mod_dso *mods = mod_dso__new_dso("modules");
 	struct module *pos;
@@ -844,7 +846,7 @@ int dso__load_modules(struct dso *self, symbol_filter_t filter, int verbose)
 	next = rb_first(&mods->mods);
 	while (next) {
 		pos = rb_entry(next, struct module, rb_node);
-		err = dso__load_module(self, mods, pos->name, filter, verbose);
+		err = dso__load_module(self, mods, pos->name, filter, v);
 
 		if (err < 0)
 			break;
@@ -887,14 +889,14 @@ static inline void dso__fill_symbol_holes(struct dso *self)
 }
 
 static int dso__load_vmlinux(struct dso *self, const char *vmlinux,
-			     symbol_filter_t filter, int verbose)
+			     symbol_filter_t filter, int v)
 {
 	int err, fd = open(vmlinux, O_RDONLY);
 
 	if (fd < 0)
 		return -1;
 
-	err = dso__load_sym(self, fd, vmlinux, filter, verbose, NULL);
+	err = dso__load_sym(self, fd, vmlinux, filter, v, NULL);
 
 	if (err > 0)
 		dso__fill_symbol_holes(self);
@@ -905,18 +907,18 @@ static int dso__load_vmlinux(struct dso *self, const char *vmlinux,
 }
 
 int dso__load_kernel(struct dso *self, const char *vmlinux,
-		     symbol_filter_t filter, int verbose, int modules)
+		     symbol_filter_t filter, int v, int use_modules)
 {
 	int err = -1;
 
 	if (vmlinux) {
-		err = dso__load_vmlinux(self, vmlinux, filter, verbose);
-		if (err > 0 && modules)
-			err = dso__load_modules(self, filter, verbose);
+		err = dso__load_vmlinux(self, vmlinux, filter, v);
+		if (err > 0 && use_modules)
+			err = dso__load_modules(self, filter, v);
 	}
 
 	if (err <= 0)
-		err = dso__load_kallsyms(self, filter, verbose);
+		err = dso__load_kallsyms(self, filter, v);
 
 	if (err > 0)
 		self->origin = DSO__ORIG_KERNEL;
@@ -924,6 +926,103 @@ int dso__load_kernel(struct dso *self, const char *vmlinux,
 	return err;
 }
 
+LIST_HEAD(dsos);
+struct dso	*kernel_dso;
+struct dso	*vdso;
+struct dso	*hypervisor_dso;
+
+const char	*vmlinux_name = "vmlinux";
+int		modules;
+
+static void dsos__add(struct dso *dso)
+{
+	list_add_tail(&dso->node, &dsos);
+}
+
+static struct dso *dsos__find(const char *name)
+{
+	struct dso *pos;
+
+	list_for_each_entry(pos, &dsos, node)
+		if (strcmp(pos->name, name) == 0)
+			return pos;
+	return NULL;
+}
+
+struct dso *dsos__findnew(const char *name)
+{
+	struct dso *dso = dsos__find(name);
+	int nr;
+
+	if (dso)
+		return dso;
+
+	dso = dso__new(name, 0);
+	if (!dso)
+		goto out_delete_dso;
+
+	nr = dso__load(dso, NULL, verbose);
+	if (nr < 0) {
+		eprintf("Failed to open: %s\n", name);
+		goto out_delete_dso;
+	}
+	if (!nr)
+		eprintf("No symbols found in: %s, maybe install a debug package?\n", name);
+
+	dsos__add(dso);
+
+	return dso;
+
+out_delete_dso:
+	dso__delete(dso);
+	return NULL;
+}
+
+void dsos__fprintf(FILE *fp)
+{
+	struct dso *pos;
+
+	list_for_each_entry(pos, &dsos, node)
+		dso__fprintf(pos, fp);
+}
+
+static struct symbol *vdso__find_symbol(struct dso *dso, u64 ip)
+{
+	return dso__find_symbol(dso, ip);
+}
+
+int load_kernel(void)
+{
+	int err;
+
+	kernel_dso = dso__new("[kernel]", 0);
+	if (!kernel_dso)
+		return -1;
+
+	err = dso__load_kernel(kernel_dso, vmlinux_name, NULL, verbose, modules);
+	if (err <= 0) {
+		dso__delete(kernel_dso);
+		kernel_dso = NULL;
+	} else
+		dsos__add(kernel_dso);
+
+	vdso = dso__new("[vdso]", 0);
+	if (!vdso)
+		return -1;
+
+	vdso->find_symbol = vdso__find_symbol;
+
+	dsos__add(vdso);
+
+	hypervisor_dso = dso__new("[hypervisor]", 0);
+	if (!hypervisor_dso)
+		return -1;
+	dsos__add(hypervisor_dso);
+
+	return err;
+}
+
+
 void symbol__init(void)
 {
 	elf_version(EV_CURRENT);
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index b53bf01..6e84907 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -6,6 +6,7 @@
 #include <linux/list.h>
 #include <linux/rbtree.h>
 #include "module.h"
+#include "event.h"
 
 #ifdef HAVE_CPLUS_DEMANGLE
 extern char *cplus_demangle(const char *, int);
@@ -54,7 +55,7 @@ struct dso {
 	char		 name[0];
 };
 
-const char *sym_hist_filter;
+extern const char *sym_hist_filter;
 
 typedef int (*symbol_filter_t)(struct dso *self, struct symbol *sym);
 
@@ -72,9 +73,20 @@ int dso__load_kernel(struct dso *self, const char *vmlinux,
 		     symbol_filter_t filter, int verbose, int modules);
 int dso__load_modules(struct dso *self, symbol_filter_t filter, int verbose);
 int dso__load(struct dso *self, symbol_filter_t filter, int verbose);
+struct dso *dsos__findnew(const char *name);
+void dsos__fprintf(FILE *fp);
 
 size_t dso__fprintf(struct dso *self, FILE *fp);
 char dso__symtab_origin(const struct dso *self);
 
+int load_kernel(void);
+
 void symbol__init(void);
+
+extern struct list_head dsos;
+extern struct dso *kernel_dso;
+extern struct dso *vdso;
+extern struct dso *hypervisor_dso;
+extern const char *vmlinux_name;
+extern int   modules;
 #endif /* _PERF_SYMBOL_ */
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
new file mode 100644
index 0000000..7635928
--- /dev/null
+++ b/tools/perf/util/thread.c
@@ -0,0 +1,175 @@
+#include "../perf.h"
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include "thread.h"
+#include "util.h"
+#include "debug.h"
+
+static struct thread *thread__new(pid_t pid)
+{
+	struct thread *self = malloc(sizeof(*self));
+
+	if (self != NULL) {
+		self->pid = pid;
+		self->comm = malloc(32);
+		if (self->comm)
+			snprintf(self->comm, 32, ":%d", self->pid);
+		INIT_LIST_HEAD(&self->maps);
+	}
+
+	return self;
+}
+
+int thread__set_comm(struct thread *self, const char *comm)
+{
+	if (self->comm)
+		free(self->comm);
+	self->comm = strdup(comm);
+	return self->comm ? 0 : -ENOMEM;
+}
+
+static size_t thread__fprintf(struct thread *self, FILE *fp)
+{
+	struct map *pos;
+	size_t ret = fprintf(fp, "Thread %d %s\n", self->pid, self->comm);
+
+	list_for_each_entry(pos, &self->maps, node)
+		ret += map__fprintf(pos, fp);
+
+	return ret;
+}
+
+struct thread *
+threads__findnew(pid_t pid, struct rb_root *threads, struct thread **last_match)
+{
+	struct rb_node **p = &threads->rb_node;
+	struct rb_node *parent = NULL;
+	struct thread *th;
+
+	/*
+	 * Font-end cache - PID lookups come in blocks,
+	 * so most of the time we dont have to look up
+	 * the full rbtree:
+	 */
+	if (*last_match && (*last_match)->pid == pid)
+		return *last_match;
+
+	while (*p != NULL) {
+		parent = *p;
+		th = rb_entry(parent, struct thread, rb_node);
+
+		if (th->pid == pid) {
+			*last_match = th;
+			return th;
+		}
+
+		if (pid < th->pid)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	th = thread__new(pid);
+	if (th != NULL) {
+		rb_link_node(&th->rb_node, parent, p);
+		rb_insert_color(&th->rb_node, threads);
+		*last_match = th;
+	}
+
+	return th;
+}
+
+struct thread *
+register_idle_thread(struct rb_root *threads, struct thread **last_match)
+{
+	struct thread *thread = threads__findnew(0, threads, last_match);
+
+	if (!thread || thread__set_comm(thread, "[init]")) {
+		fprintf(stderr, "problem inserting idle task.\n");
+		exit(-1);
+	}
+
+	return thread;
+}
+
+void thread__insert_map(struct thread *self, struct map *map)
+{
+	struct map *pos, *tmp;
+
+	list_for_each_entry_safe(pos, tmp, &self->maps, node) {
+		if (map__overlap(pos, map)) {
+			if (verbose >= 2) {
+				printf("overlapping maps:\n");
+				map__fprintf(map, stdout);
+				map__fprintf(pos, stdout);
+			}
+
+			if (map->start <= pos->start && map->end > pos->start)
+				pos->start = map->end;
+
+			if (map->end >= pos->end && map->start < pos->end)
+				pos->end = map->start;
+
+			if (verbose >= 2) {
+				printf("after collision:\n");
+				map__fprintf(pos, stdout);
+			}
+
+			if (pos->start >= pos->end) {
+				list_del_init(&pos->node);
+				free(pos);
+			}
+		}
+	}
+
+	list_add_tail(&map->node, &self->maps);
+}
+
+int thread__fork(struct thread *self, struct thread *parent)
+{
+	struct map *map;
+
+	if (self->comm)
+		free(self->comm);
+	self->comm = strdup(parent->comm);
+	if (!self->comm)
+		return -ENOMEM;
+
+	list_for_each_entry(map, &parent->maps, node) {
+		struct map *new = map__clone(map);
+		if (!new)
+			return -ENOMEM;
+		thread__insert_map(self, new);
+	}
+
+	return 0;
+}
+
+struct map *thread__find_map(struct thread *self, u64 ip)
+{
+	struct map *pos;
+
+	if (self == NULL)
+		return NULL;
+
+	list_for_each_entry(pos, &self->maps, node)
+		if (ip >= pos->start && ip <= pos->end)
+			return pos;
+
+	return NULL;
+}
+
+size_t threads__fprintf(FILE *fp, struct rb_root *threads)
+{
+	size_t ret = 0;
+	struct rb_node *nd;
+
+	for (nd = rb_first(threads); nd; nd = rb_next(nd)) {
+		struct thread *pos = rb_entry(nd, struct thread, rb_node);
+
+		ret += thread__fprintf(pos, fp);
+	}
+
+	return ret;
+}
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
new file mode 100644
index 0000000..634f280
--- /dev/null
+++ b/tools/perf/util/thread.h
@@ -0,0 +1,21 @@
+#include <linux/rbtree.h>
+#include <linux/list.h>
+#include <unistd.h>
+#include "symbol.h"
+
+struct thread {
+	struct rb_node	 rb_node;
+	struct list_head maps;
+	pid_t		 pid;
+	char		 *comm;
+};
+
+int thread__set_comm(struct thread *self, const char *comm);
+struct thread *
+threads__findnew(pid_t pid, struct rb_root *threads, struct thread **last_match);
+struct thread *
+register_idle_thread(struct rb_root *threads, struct thread **last_match);
+void thread__insert_map(struct thread *self, struct map *map);
+int thread__fork(struct thread *self, struct thread *parent);
+struct map *thread__find_map(struct thread *self, u64 ip);
+size_t threads__fprintf(FILE *fp, struct rb_root *threads);
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
new file mode 100644
index 0000000..6c9302a
--- /dev/null
+++ b/tools/perf/util/trace-event-info.c
@@ -0,0 +1,539 @@
+/*
+ * Copyright (C) 2008,2009, Steven Rostedt <srostedt@redhat.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License (not later!)
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+#define _GNU_SOURCE
+#include <dirent.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdarg.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/wait.h>
+#include <pthread.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <ctype.h>
+#include <errno.h>
+#include <stdbool.h>
+
+#include "../perf.h"
+#include "trace-event.h"
+
+
+#define VERSION "0.5"
+
+#define _STR(x) #x
+#define STR(x) _STR(x)
+#define MAX_PATH 256
+
+#define TRACE_CTRL	"tracing_on"
+#define TRACE		"trace"
+#define AVAILABLE	"available_tracers"
+#define CURRENT		"current_tracer"
+#define ITER_CTRL	"trace_options"
+#define MAX_LATENCY	"tracing_max_latency"
+
+unsigned int page_size;
+
+static const char *output_file = "trace.info";
+static int output_fd;
+
+struct event_list {
+	struct event_list *next;
+	const char *event;
+};
+
+struct events {
+	struct events *sibling;
+	struct events *children;
+	struct events *next;
+	char *name;
+};
+
+
+
+static void die(const char *fmt, ...)
+{
+	va_list ap;
+	int ret = errno;
+
+	if (errno)
+		perror("trace-cmd");
+	else
+		ret = -1;
+
+	va_start(ap, fmt);
+	fprintf(stderr, "  ");
+	vfprintf(stderr, fmt, ap);
+	va_end(ap);
+
+	fprintf(stderr, "\n");
+	exit(ret);
+}
+
+void *malloc_or_die(unsigned int size)
+{
+	void *data;
+
+	data = malloc(size);
+	if (!data)
+		die("malloc");
+	return data;
+}
+
+static const char *find_debugfs(void)
+{
+	static char debugfs[MAX_PATH+1];
+	static int debugfs_found;
+	char type[100];
+	FILE *fp;
+
+	if (debugfs_found)
+		return debugfs;
+
+	if ((fp = fopen("/proc/mounts","r")) == NULL)
+		die("Can't open /proc/mounts for read");
+
+	while (fscanf(fp, "%*s %"
+		      STR(MAX_PATH)
+		      "s %99s %*s %*d %*d\n",
+		      debugfs, type) == 2) {
+		if (strcmp(type, "debugfs") == 0)
+			break;
+	}
+	fclose(fp);
+
+	if (strcmp(type, "debugfs") != 0)
+		die("debugfs not mounted, please mount");
+
+	debugfs_found = 1;
+
+	return debugfs;
+}
+
+/*
+ * Finds the path to the debugfs/tracing
+ * Allocates the string and stores it.
+ */
+static const char *find_tracing_dir(void)
+{
+	static char *tracing;
+	static int tracing_found;
+	const char *debugfs;
+
+	if (tracing_found)
+		return tracing;
+
+	debugfs = find_debugfs();
+
+	tracing = malloc_or_die(strlen(debugfs) + 9);
+
+	sprintf(tracing, "%s/tracing", debugfs);
+
+	tracing_found = 1;
+	return tracing;
+}
+
+static char *get_tracing_file(const char *name)
+{
+	const char *tracing;
+	char *file;
+
+	tracing = find_tracing_dir();
+	if (!tracing)
+		return NULL;
+
+	file = malloc_or_die(strlen(tracing) + strlen(name) + 2);
+
+	sprintf(file, "%s/%s", tracing, name);
+	return file;
+}
+
+static void put_tracing_file(char *file)
+{
+	free(file);
+}
+
+static ssize_t write_or_die(const void *buf, size_t len)
+{
+	int ret;
+
+	ret = write(output_fd, buf, len);
+	if (ret < 0)
+		die("writing to '%s'", output_file);
+
+	return ret;
+}
+
+int bigendian(void)
+{
+	unsigned char str[] = { 0x1, 0x2, 0x3, 0x4, 0x0, 0x0, 0x0, 0x0};
+	unsigned int *ptr;
+
+	ptr = (unsigned int *)(void *)str;
+	return *ptr == 0x01020304;
+}
+
+static unsigned long long copy_file_fd(int fd)
+{
+	unsigned long long size = 0;
+	char buf[BUFSIZ];
+	int r;
+
+	do {
+		r = read(fd, buf, BUFSIZ);
+		if (r > 0) {
+			size += r;
+			write_or_die(buf, r);
+		}
+	} while (r > 0);
+
+	return size;
+}
+
+static unsigned long long copy_file(const char *file)
+{
+	unsigned long long size = 0;
+	int fd;
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0)
+		die("Can't read '%s'", file);
+	size = copy_file_fd(fd);
+	close(fd);
+
+	return size;
+}
+
+static unsigned long get_size_fd(int fd)
+{
+	unsigned long long size = 0;
+	char buf[BUFSIZ];
+	int r;
+
+	do {
+		r = read(fd, buf, BUFSIZ);
+		if (r > 0)
+			size += r;
+	} while (r > 0);
+
+	lseek(fd, 0, SEEK_SET);
+
+	return size;
+}
+
+static unsigned long get_size(const char *file)
+{
+	unsigned long long size = 0;
+	int fd;
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0)
+		die("Can't read '%s'", file);
+	size = get_size_fd(fd);
+	close(fd);
+
+	return size;
+}
+
+static void read_header_files(void)
+{
+	unsigned long long size, check_size;
+	char *path;
+	int fd;
+
+	path = get_tracing_file("events/header_page");
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		die("can't read '%s'", path);
+
+	/* unfortunately, you can not stat debugfs files for size */
+	size = get_size_fd(fd);
+
+	write_or_die("header_page", 12);
+	write_or_die(&size, 8);
+	check_size = copy_file_fd(fd);
+	if (size != check_size)
+		die("wrong size for '%s' size=%lld read=%lld",
+		    path, size, check_size);
+	put_tracing_file(path);
+
+	path = get_tracing_file("events/header_event");
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		die("can't read '%s'", path);
+
+	size = get_size_fd(fd);
+
+	write_or_die("header_event", 13);
+	write_or_die(&size, 8);
+	check_size = copy_file_fd(fd);
+	if (size != check_size)
+		die("wrong size for '%s'", path);
+	put_tracing_file(path);
+}
+
+static bool name_in_tp_list(char *sys, struct tracepoint_path *tps)
+{
+	while (tps) {
+		if (!strcmp(sys, tps->name))
+			return true;
+		tps = tps->next;
+	}
+
+	return false;
+}
+
+static void copy_event_system(const char *sys, struct tracepoint_path *tps)
+{
+	unsigned long long size, check_size;
+	struct dirent *dent;
+	struct stat st;
+	char *format;
+	DIR *dir;
+	int count = 0;
+	int ret;
+
+	dir = opendir(sys);
+	if (!dir)
+		die("can't read directory '%s'", sys);
+
+	while ((dent = readdir(dir))) {
+		if (strcmp(dent->d_name, ".") == 0 ||
+		    strcmp(dent->d_name, "..") == 0 ||
+		    !name_in_tp_list(dent->d_name, tps))
+			continue;
+		format = malloc_or_die(strlen(sys) + strlen(dent->d_name) + 10);
+		sprintf(format, "%s/%s/format", sys, dent->d_name);
+		ret = stat(format, &st);
+		free(format);
+		if (ret < 0)
+			continue;
+		count++;
+	}
+
+	write_or_die(&count, 4);
+
+	rewinddir(dir);
+	while ((dent = readdir(dir))) {
+		if (strcmp(dent->d_name, ".") == 0 ||
+		    strcmp(dent->d_name, "..") == 0 ||
+		    !name_in_tp_list(dent->d_name, tps))
+			continue;
+		format = malloc_or_die(strlen(sys) + strlen(dent->d_name) + 10);
+		sprintf(format, "%s/%s/format", sys, dent->d_name);
+		ret = stat(format, &st);
+
+		if (ret >= 0) {
+			/* unfortunately, you can not stat debugfs files for size */
+			size = get_size(format);
+			write_or_die(&size, 8);
+			check_size = copy_file(format);
+			if (size != check_size)
+				die("error in size of file '%s'", format);
+		}
+
+		free(format);
+	}
+}
+
+static void read_ftrace_files(struct tracepoint_path *tps)
+{
+	char *path;
+
+	path = get_tracing_file("events/ftrace");
+
+	copy_event_system(path, tps);
+
+	put_tracing_file(path);
+}
+
+static bool system_in_tp_list(char *sys, struct tracepoint_path *tps)
+{
+	while (tps) {
+		if (!strcmp(sys, tps->system))
+			return true;
+		tps = tps->next;
+	}
+
+	return false;
+}
+
+static void read_event_files(struct tracepoint_path *tps)
+{
+	struct dirent *dent;
+	struct stat st;
+	char *path;
+	char *sys;
+	DIR *dir;
+	int count = 0;
+	int ret;
+
+	path = get_tracing_file("events");
+
+	dir = opendir(path);
+	if (!dir)
+		die("can't read directory '%s'", path);
+
+	while ((dent = readdir(dir))) {
+		if (strcmp(dent->d_name, ".") == 0 ||
+		    strcmp(dent->d_name, "..") == 0 ||
+		    strcmp(dent->d_name, "ftrace") == 0 ||
+		    !system_in_tp_list(dent->d_name, tps))
+			continue;
+		sys = malloc_or_die(strlen(path) + strlen(dent->d_name) + 2);
+		sprintf(sys, "%s/%s", path, dent->d_name);
+		ret = stat(sys, &st);
+		free(sys);
+		if (ret < 0)
+			continue;
+		if (S_ISDIR(st.st_mode))
+			count++;
+	}
+
+	write_or_die(&count, 4);
+
+	rewinddir(dir);
+	while ((dent = readdir(dir))) {
+		if (strcmp(dent->d_name, ".") == 0 ||
+		    strcmp(dent->d_name, "..") == 0 ||
+		    strcmp(dent->d_name, "ftrace") == 0 ||
+		    !system_in_tp_list(dent->d_name, tps))
+			continue;
+		sys = malloc_or_die(strlen(path) + strlen(dent->d_name) + 2);
+		sprintf(sys, "%s/%s", path, dent->d_name);
+		ret = stat(sys, &st);
+		if (ret >= 0) {
+			if (S_ISDIR(st.st_mode)) {
+				write_or_die(dent->d_name, strlen(dent->d_name) + 1);
+				copy_event_system(sys, tps);
+			}
+		}
+		free(sys);
+	}
+
+	put_tracing_file(path);
+}
+
+static void read_proc_kallsyms(void)
+{
+	unsigned int size, check_size;
+	const char *path = "/proc/kallsyms";
+	struct stat st;
+	int ret;
+
+	ret = stat(path, &st);
+	if (ret < 0) {
+		/* not found */
+		size = 0;
+		write_or_die(&size, 4);
+		return;
+	}
+	size = get_size(path);
+	write_or_die(&size, 4);
+	check_size = copy_file(path);
+	if (size != check_size)
+		die("error in size of file '%s'", path);
+
+}
+
+static void read_ftrace_printk(void)
+{
+	unsigned int size, check_size;
+	const char *path;
+	struct stat st;
+	int ret;
+
+	path = get_tracing_file("printk_formats");
+	ret = stat(path, &st);
+	if (ret < 0) {
+		/* not found */
+		size = 0;
+		write_or_die(&size, 4);
+		return;
+	}
+	size = get_size(path);
+	write_or_die(&size, 4);
+	check_size = copy_file(path);
+	if (size != check_size)
+		die("error in size of file '%s'", path);
+
+}
+
+static struct tracepoint_path *
+get_tracepoints_path(struct perf_counter_attr *pattrs, int nb_counters)
+{
+	struct tracepoint_path path, *ppath = &path;
+	int i;
+
+	for (i = 0; i < nb_counters; i++) {
+		if (pattrs[i].type != PERF_TYPE_TRACEPOINT)
+			continue;
+		ppath->next = tracepoint_id_to_path(pattrs[i].config);
+		if (!ppath->next)
+			die("%s\n", "No memory to alloc tracepoints list");
+		ppath = ppath->next;
+	}
+
+	return path.next;
+}
+void read_tracing_data(struct perf_counter_attr *pattrs, int nb_counters)
+{
+	char buf[BUFSIZ];
+	struct tracepoint_path *tps;
+
+	output_fd = open(output_file, O_WRONLY | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
+	if (output_fd < 0)
+		die("creating file '%s'", output_file);
+
+	buf[0] = 23;
+	buf[1] = 8;
+	buf[2] = 68;
+	memcpy(buf + 3, "tracing", 7);
+
+	write_or_die(buf, 10);
+
+	write_or_die(VERSION, strlen(VERSION) + 1);
+
+	/* save endian */
+	if (bigendian())
+		buf[0] = 1;
+	else
+		buf[0] = 0;
+
+	write_or_die(buf, 1);
+
+	/* save size of long */
+	buf[0] = sizeof(long);
+	write_or_die(buf, 1);
+
+	/* save page_size */
+	page_size = getpagesize();
+	write_or_die(&page_size, 4);
+
+	tps = get_tracepoints_path(pattrs, nb_counters);
+
+	read_header_files();
+	read_ftrace_files(tps);
+	read_event_files(tps);
+	read_proc_kallsyms();
+	read_ftrace_printk();
+}
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
new file mode 100644
index 0000000..629e602
--- /dev/null
+++ b/tools/perf/util/trace-event-parse.c
@@ -0,0 +1,2942 @@
+/*
+ * Copyright (C) 2009, Steven Rostedt <srostedt@redhat.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License (not later!)
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  The parts for function graph printing was taken and modified from the
+ *  Linux Kernel that were written by Frederic Weisbecker.
+ */
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <ctype.h>
+#include <errno.h>
+
+#undef _GNU_SOURCE
+#include "../perf.h"
+#include "util.h"
+#include "trace-event.h"
+
+int header_page_ts_offset;
+int header_page_ts_size;
+int header_page_size_offset;
+int header_page_size_size;
+int header_page_data_offset;
+int header_page_data_size;
+
+static char *input_buf;
+static unsigned long long input_buf_ptr;
+static unsigned long long input_buf_siz;
+
+static int cpus;
+static int long_size;
+
+static void init_input_buf(char *buf, unsigned long long size)
+{
+	input_buf = buf;
+	input_buf_siz = size;
+	input_buf_ptr = 0;
+}
+
+struct cmdline {
+	char *comm;
+	int pid;
+};
+
+static struct cmdline *cmdlines;
+static int cmdline_count;
+
+static int cmdline_cmp(const void *a, const void *b)
+{
+	const struct cmdline *ca = a;
+	const struct cmdline *cb = b;
+
+	if (ca->pid < cb->pid)
+		return -1;
+	if (ca->pid > cb->pid)
+		return 1;
+
+	return 0;
+}
+
+void parse_cmdlines(char *file, int size __unused)
+{
+	struct cmdline_list {
+		struct cmdline_list	*next;
+		char			*comm;
+		int			pid;
+	} *list = NULL, *item;
+	char *line;
+	char *next = NULL;
+	int i;
+
+	line = strtok_r(file, "\n", &next);
+	while (line) {
+		item = malloc_or_die(sizeof(*item));
+		sscanf(line, "%d %as", &item->pid,
+		       (float *)(void *)&item->comm); /* workaround gcc warning */
+		item->next = list;
+		list = item;
+		line = strtok_r(NULL, "\n", &next);
+		cmdline_count++;
+	}
+
+	cmdlines = malloc_or_die(sizeof(*cmdlines) * cmdline_count);
+
+	i = 0;
+	while (list) {
+		cmdlines[i].pid = list->pid;
+		cmdlines[i].comm = list->comm;
+		i++;
+		item = list;
+		list = list->next;
+		free(item);
+	}
+
+	qsort(cmdlines, cmdline_count, sizeof(*cmdlines), cmdline_cmp);
+}
+
+static struct func_map {
+	unsigned long long		addr;
+	char				*func;
+	char				*mod;
+} *func_list;
+static unsigned int func_count;
+
+static int func_cmp(const void *a, const void *b)
+{
+	const struct func_map *fa = a;
+	const struct func_map *fb = b;
+
+	if (fa->addr < fb->addr)
+		return -1;
+	if (fa->addr > fb->addr)
+		return 1;
+
+	return 0;
+}
+
+void parse_proc_kallsyms(char *file, unsigned int size __unused)
+{
+	struct func_list {
+		struct func_list	*next;
+		unsigned long long	addr;
+		char			*func;
+		char			*mod;
+	} *list = NULL, *item;
+	char *line;
+	char *next = NULL;
+	char *addr_str;
+	char ch;
+	int ret;
+	int i;
+
+	line = strtok_r(file, "\n", &next);
+	while (line) {
+		item = malloc_or_die(sizeof(*item));
+		item->mod = NULL;
+		ret = sscanf(line, "%as %c %as\t[%as",
+			     (float *)(void *)&addr_str, /* workaround gcc warning */
+			     &ch,
+			     (float *)(void *)&item->func,
+			     (float *)(void *)&item->mod);
+		item->addr = strtoull(addr_str, NULL, 16);
+		free(addr_str);
+
+		/* truncate the extra ']' */
+		if (item->mod)
+			item->mod[strlen(item->mod) - 1] = 0;
+
+
+		item->next = list;
+		list = item;
+		line = strtok_r(NULL, "\n", &next);
+		func_count++;
+	}
+
+	func_list = malloc_or_die(sizeof(*func_list) * func_count + 1);
+
+	i = 0;
+	while (list) {
+		func_list[i].func = list->func;
+		func_list[i].addr = list->addr;
+		func_list[i].mod = list->mod;
+		i++;
+		item = list;
+		list = list->next;
+		free(item);
+	}
+
+	qsort(func_list, func_count, sizeof(*func_list), func_cmp);
+
+	/*
+	 * Add a special record at the end.
+	 */
+	func_list[func_count].func = NULL;
+	func_list[func_count].addr = 0;
+	func_list[func_count].mod = NULL;
+}
+
+/*
+ * We are searching for a record in between, not an exact
+ * match.
+ */
+static int func_bcmp(const void *a, const void *b)
+{
+	const struct func_map *fa = a;
+	const struct func_map *fb = b;
+
+	if ((fa->addr == fb->addr) ||
+
+	    (fa->addr > fb->addr &&
+	     fa->addr < (fb+1)->addr))
+		return 0;
+
+	if (fa->addr < fb->addr)
+		return -1;
+
+	return 1;
+}
+
+static struct func_map *find_func(unsigned long long addr)
+{
+	struct func_map *func;
+	struct func_map key;
+
+	key.addr = addr;
+
+	func = bsearch(&key, func_list, func_count, sizeof(*func_list),
+		       func_bcmp);
+
+	return func;
+}
+
+void print_funcs(void)
+{
+	int i;
+
+	for (i = 0; i < (int)func_count; i++) {
+		printf("%016llx %s",
+		       func_list[i].addr,
+		       func_list[i].func);
+		if (func_list[i].mod)
+			printf(" [%s]\n", func_list[i].mod);
+		else
+			printf("\n");
+	}
+}
+
+static struct printk_map {
+	unsigned long long		addr;
+	char				*printk;
+} *printk_list;
+static unsigned int printk_count;
+
+static int printk_cmp(const void *a, const void *b)
+{
+	const struct func_map *fa = a;
+	const struct func_map *fb = b;
+
+	if (fa->addr < fb->addr)
+		return -1;
+	if (fa->addr > fb->addr)
+		return 1;
+
+	return 0;
+}
+
+static struct printk_map *find_printk(unsigned long long addr)
+{
+	struct printk_map *printk;
+	struct printk_map key;
+
+	key.addr = addr;
+
+	printk = bsearch(&key, printk_list, printk_count, sizeof(*printk_list),
+			 printk_cmp);
+
+	return printk;
+}
+
+void parse_ftrace_printk(char *file, unsigned int size __unused)
+{
+	struct printk_list {
+		struct printk_list	*next;
+		unsigned long long	addr;
+		char			*printk;
+	} *list = NULL, *item;
+	char *line;
+	char *next = NULL;
+	char *addr_str;
+	int ret;
+	int i;
+
+	line = strtok_r(file, "\n", &next);
+	while (line) {
+		item = malloc_or_die(sizeof(*item));
+		ret = sscanf(line, "%as : %as",
+			     (float *)(void *)&addr_str, /* workaround gcc warning */
+			     (float *)(void *)&item->printk);
+		item->addr = strtoull(addr_str, NULL, 16);
+		free(addr_str);
+
+		item->next = list;
+		list = item;
+		line = strtok_r(NULL, "\n", &next);
+		printk_count++;
+	}
+
+	printk_list = malloc_or_die(sizeof(*printk_list) * printk_count + 1);
+
+	i = 0;
+	while (list) {
+		printk_list[i].printk = list->printk;
+		printk_list[i].addr = list->addr;
+		i++;
+		item = list;
+		list = list->next;
+		free(item);
+	}
+
+	qsort(printk_list, printk_count, sizeof(*printk_list), printk_cmp);
+}
+
+void print_printk(void)
+{
+	int i;
+
+	for (i = 0; i < (int)printk_count; i++) {
+		printf("%016llx %s\n",
+		       printk_list[i].addr,
+		       printk_list[i].printk);
+	}
+}
+
+static struct event *alloc_event(void)
+{
+	struct event *event;
+
+	event = malloc_or_die(sizeof(*event));
+	memset(event, 0, sizeof(*event));
+
+	return event;
+}
+
+enum event_type {
+	EVENT_ERROR,
+	EVENT_NONE,
+	EVENT_SPACE,
+	EVENT_NEWLINE,
+	EVENT_OP,
+	EVENT_DELIM,
+	EVENT_ITEM,
+	EVENT_DQUOTE,
+	EVENT_SQUOTE,
+};
+
+static struct event *event_list;
+
+static void add_event(struct event *event)
+{
+	event->next = event_list;
+	event_list = event;
+}
+
+static int event_item_type(enum event_type type)
+{
+	switch (type) {
+	case EVENT_ITEM ... EVENT_SQUOTE:
+		return 1;
+	case EVENT_ERROR ... EVENT_DELIM:
+	default:
+		return 0;
+	}
+}
+
+static void free_arg(struct print_arg *arg)
+{
+	if (!arg)
+		return;
+
+	switch (arg->type) {
+	case PRINT_ATOM:
+		if (arg->atom.atom)
+			free(arg->atom.atom);
+		break;
+	case PRINT_NULL:
+	case PRINT_FIELD ... PRINT_OP:
+	default:
+		/* todo */
+		break;
+	}
+
+	free(arg);
+}
+
+static enum event_type get_type(int ch)
+{
+	if (ch == '\n')
+		return EVENT_NEWLINE;
+	if (isspace(ch))
+		return EVENT_SPACE;
+	if (isalnum(ch) || ch == '_')
+		return EVENT_ITEM;
+	if (ch == '\'')
+		return EVENT_SQUOTE;
+	if (ch == '"')
+		return EVENT_DQUOTE;
+	if (!isprint(ch))
+		return EVENT_NONE;
+	if (ch == '(' || ch == ')' || ch == ',')
+		return EVENT_DELIM;
+
+	return EVENT_OP;
+}
+
+static int __read_char(void)
+{
+	if (input_buf_ptr >= input_buf_siz)
+		return -1;
+
+	return input_buf[input_buf_ptr++];
+}
+
+static int __peek_char(void)
+{
+	if (input_buf_ptr >= input_buf_siz)
+		return -1;
+
+	return input_buf[input_buf_ptr];
+}
+
+static enum event_type __read_token(char **tok)
+{
+	char buf[BUFSIZ];
+	int ch, last_ch, quote_ch, next_ch;
+	int i = 0;
+	int tok_size = 0;
+	enum event_type type;
+
+	*tok = NULL;
+
+
+	ch = __read_char();
+	if (ch < 0)
+		return EVENT_NONE;
+
+	type = get_type(ch);
+	if (type == EVENT_NONE)
+		return type;
+
+	buf[i++] = ch;
+
+	switch (type) {
+	case EVENT_NEWLINE:
+	case EVENT_DELIM:
+		*tok = malloc_or_die(2);
+		(*tok)[0] = ch;
+		(*tok)[1] = 0;
+		return type;
+
+	case EVENT_OP:
+		switch (ch) {
+		case '-':
+			next_ch = __peek_char();
+			if (next_ch == '>') {
+				buf[i++] = __read_char();
+				break;
+			}
+			/* fall through */
+		case '+':
+		case '|':
+		case '&':
+		case '>':
+		case '<':
+			last_ch = ch;
+			ch = __peek_char();
+			if (ch != last_ch)
+				goto test_equal;
+			buf[i++] = __read_char();
+			switch (last_ch) {
+			case '>':
+			case '<':
+				goto test_equal;
+			default:
+				break;
+			}
+			break;
+		case '!':
+		case '=':
+			goto test_equal;
+		default: /* what should we do instead? */
+			break;
+		}
+		buf[i] = 0;
+		*tok = strdup(buf);
+		return type;
+
+ test_equal:
+		ch = __peek_char();
+		if (ch == '=')
+			buf[i++] = __read_char();
+		break;
+
+	case EVENT_DQUOTE:
+	case EVENT_SQUOTE:
+		/* don't keep quotes */
+		i--;
+		quote_ch = ch;
+		last_ch = 0;
+		do {
+			if (i == (BUFSIZ - 1)) {
+				buf[i] = 0;
+				if (*tok) {
+					*tok = realloc(*tok, tok_size + BUFSIZ);
+					if (!*tok)
+						return EVENT_NONE;
+					strcat(*tok, buf);
+				} else
+					*tok = strdup(buf);
+
+				if (!*tok)
+					return EVENT_NONE;
+				tok_size += BUFSIZ;
+				i = 0;
+			}
+			last_ch = ch;
+			ch = __read_char();
+			buf[i++] = ch;
+		} while (ch != quote_ch && last_ch != '\\');
+		/* remove the last quote */
+		i--;
+		goto out;
+
+	case EVENT_ERROR ... EVENT_SPACE:
+	case EVENT_ITEM:
+	default:
+		break;
+	}
+
+	while (get_type(__peek_char()) == type) {
+		if (i == (BUFSIZ - 1)) {
+			buf[i] = 0;
+			if (*tok) {
+				*tok = realloc(*tok, tok_size + BUFSIZ);
+				if (!*tok)
+					return EVENT_NONE;
+				strcat(*tok, buf);
+			} else
+				*tok = strdup(buf);
+
+			if (!*tok)
+				return EVENT_NONE;
+			tok_size += BUFSIZ;
+			i = 0;
+		}
+		ch = __read_char();
+		buf[i++] = ch;
+	}
+
+ out:
+	buf[i] = 0;
+	if (*tok) {
+		*tok = realloc(*tok, tok_size + i);
+		if (!*tok)
+			return EVENT_NONE;
+		strcat(*tok, buf);
+	} else
+		*tok = strdup(buf);
+	if (!*tok)
+		return EVENT_NONE;
+
+	return type;
+}
+
+static void free_token(char *tok)
+{
+	if (tok)
+		free(tok);
+}
+
+static enum event_type read_token(char **tok)
+{
+	enum event_type type;
+
+	for (;;) {
+		type = __read_token(tok);
+		if (type != EVENT_SPACE)
+			return type;
+
+		free_token(*tok);
+	}
+
+	/* not reached */
+	return EVENT_NONE;
+}
+
+/* no newline */
+static enum event_type read_token_item(char **tok)
+{
+	enum event_type type;
+
+	for (;;) {
+		type = __read_token(tok);
+		if (type != EVENT_SPACE && type != EVENT_NEWLINE)
+			return type;
+
+		free_token(*tok);
+	}
+
+	/* not reached */
+	return EVENT_NONE;
+}
+
+static int test_type(enum event_type type, enum event_type expect)
+{
+	if (type != expect) {
+		die("Error: expected type %d but read %d",
+		    expect, type);
+		return -1;
+	}
+	return 0;
+}
+
+static int test_type_token(enum event_type type, char *token,
+		    enum event_type expect, char *expect_tok)
+{
+	if (type != expect) {
+		die("Error: expected type %d but read %d",
+		    expect, type);
+		return -1;
+	}
+
+	if (strcmp(token, expect_tok) != 0) {
+		die("Error: expected '%s' but read '%s'",
+		    expect_tok, token);
+		return -1;
+	}
+	return 0;
+}
+
+static int __read_expect_type(enum event_type expect, char **tok, int newline_ok)
+{
+	enum event_type type;
+
+	if (newline_ok)
+		type = read_token(tok);
+	else
+		type = read_token_item(tok);
+	return test_type(type, expect);
+}
+
+static int read_expect_type(enum event_type expect, char **tok)
+{
+	return __read_expect_type(expect, tok, 1);
+}
+
+static int __read_expected(enum event_type expect, char *str, int newline_ok)
+{
+	enum event_type type;
+	char *token;
+	int ret;
+
+	if (newline_ok)
+		type = read_token(&token);
+	else
+		type = read_token_item(&token);
+
+	ret = test_type_token(type, token, expect, str);
+
+	free_token(token);
+
+	return 0;
+}
+
+static int read_expected(enum event_type expect, char *str)
+{
+	return __read_expected(expect, str, 1);
+}
+
+static int read_expected_item(enum event_type expect, char *str)
+{
+	return __read_expected(expect, str, 0);
+}
+
+static char *event_read_name(void)
+{
+	char *token;
+
+	if (read_expected(EVENT_ITEM, (char *)"name") < 0)
+		return NULL;
+
+	if (read_expected(EVENT_OP, (char *)":") < 0)
+		return NULL;
+
+	if (read_expect_type(EVENT_ITEM, &token) < 0)
+		goto fail;
+
+	return token;
+
+ fail:
+	free_token(token);
+	return NULL;
+}
+
+static int event_read_id(void)
+{
+	char *token;
+	int id;
+
+	if (read_expected_item(EVENT_ITEM, (char *)"ID") < 0)
+		return -1;
+
+	if (read_expected(EVENT_OP, (char *)":") < 0)
+		return -1;
+
+	if (read_expect_type(EVENT_ITEM, &token) < 0)
+		goto fail;
+
+	id = strtoul(token, NULL, 0);
+	free_token(token);
+	return id;
+
+ fail:
+	free_token(token);
+	return -1;
+}
+
+static int event_read_fields(struct event *event, struct format_field **fields)
+{
+	struct format_field *field = NULL;
+	enum event_type type;
+	char *token;
+	char *last_token;
+	int count = 0;
+
+	do {
+		type = read_token(&token);
+		if (type == EVENT_NEWLINE) {
+			free_token(token);
+			return count;
+		}
+
+		count++;
+
+		if (test_type_token(type, token, EVENT_ITEM, (char *)"field"))
+			goto fail;
+		free_token(token);
+
+		type = read_token(&token);
+		/*
+		 * The ftrace fields may still use the "special" name.
+		 * Just ignore it.
+		 */
+		if (event->flags & EVENT_FL_ISFTRACE &&
+		    type == EVENT_ITEM && strcmp(token, "special") == 0) {
+			free_token(token);
+			type = read_token(&token);
+		}
+
+		if (test_type_token(type, token, EVENT_OP, (char *)":") < 0)
+			return -1;
+
+		if (read_expect_type(EVENT_ITEM, &token) < 0)
+			goto fail;
+
+		last_token = token;
+
+		field = malloc_or_die(sizeof(*field));
+		memset(field, 0, sizeof(*field));
+
+		/* read the rest of the type */
+		for (;;) {
+			type = read_token(&token);
+			if (type == EVENT_ITEM ||
+			    (type == EVENT_OP && strcmp(token, "*") == 0) ||
+			    /*
+			     * Some of the ftrace fields are broken and have
+			     * an illegal "." in them.
+			     */
+			    (event->flags & EVENT_FL_ISFTRACE &&
+			     type == EVENT_OP && strcmp(token, ".") == 0)) {
+
+				if (strcmp(token, "*") == 0)
+					field->flags |= FIELD_IS_POINTER;
+
+				if (field->type) {
+					field->type = realloc(field->type,
+							      strlen(field->type) +
+							      strlen(last_token) + 2);
+					strcat(field->type, " ");
+					strcat(field->type, last_token);
+				} else
+					field->type = last_token;
+				last_token = token;
+				continue;
+			}
+
+			break;
+		}
+
+		if (!field->type) {
+			die("no type found");
+			goto fail;
+		}
+		field->name = last_token;
+
+		if (test_type(type, EVENT_OP))
+			goto fail;
+
+		if (strcmp(token, "[") == 0) {
+			enum event_type last_type = type;
+			char *brackets = token;
+			int len;
+
+			field->flags |= FIELD_IS_ARRAY;
+
+			type = read_token(&token);
+		        while (strcmp(token, "]") != 0) {
+				if (last_type == EVENT_ITEM &&
+				    type == EVENT_ITEM)
+					len = 2;
+				else
+					len = 1;
+				last_type = type;
+
+				brackets = realloc(brackets,
+						   strlen(brackets) +
+						   strlen(token) + len);
+				if (len == 2)
+					strcat(brackets, " ");
+				strcat(brackets, token);
+				free_token(token);
+				type = read_token(&token);
+				if (type == EVENT_NONE) {
+					die("failed to find token");
+					goto fail;
+				}
+			}
+
+			free_token(token);
+
+			brackets = realloc(brackets, strlen(brackets) + 2);
+			strcat(brackets, "]");
+
+			/* add brackets to type */
+
+			type = read_token(&token);
+			/*
+			 * If the next token is not an OP, then it is of
+			 * the format: type [] item;
+			 */
+			if (type == EVENT_ITEM) {
+				field->type = realloc(field->type,
+						      strlen(field->type) +
+						      strlen(field->name) +
+						      strlen(brackets) + 2);
+				strcat(field->type, " ");
+				strcat(field->type, field->name);
+				free_token(field->name);
+				strcat(field->type, brackets);
+				field->name = token;
+				type = read_token(&token);
+			} else {
+				field->type = realloc(field->type,
+						      strlen(field->type) +
+						      strlen(brackets) + 1);
+				strcat(field->type, brackets);
+			}
+			free(brackets);
+		}
+
+		if (test_type_token(type, token,  EVENT_OP, (char *)";"))
+			goto fail;
+		free_token(token);
+
+		if (read_expected(EVENT_ITEM, (char *)"offset") < 0)
+			goto fail_expect;
+
+		if (read_expected(EVENT_OP, (char *)":") < 0)
+			goto fail_expect;
+
+		if (read_expect_type(EVENT_ITEM, &token))
+			goto fail;
+		field->offset = strtoul(token, NULL, 0);
+		free_token(token);
+
+		if (read_expected(EVENT_OP, (char *)";") < 0)
+			goto fail_expect;
+
+		if (read_expected(EVENT_ITEM, (char *)"size") < 0)
+			goto fail_expect;
+
+		if (read_expected(EVENT_OP, (char *)":") < 0)
+			goto fail_expect;
+
+		if (read_expect_type(EVENT_ITEM, &token))
+			goto fail;
+		field->size = strtoul(token, NULL, 0);
+		free_token(token);
+
+		if (read_expected(EVENT_OP, (char *)";") < 0)
+			goto fail_expect;
+
+		if (read_expect_type(EVENT_NEWLINE, &token) < 0)
+			goto fail;
+		free_token(token);
+
+		*fields = field;
+		fields = &field->next;
+
+	} while (1);
+
+	return 0;
+
+fail:
+	free_token(token);
+fail_expect:
+	if (field)
+		free(field);
+	return -1;
+}
+
+static int event_read_format(struct event *event)
+{
+	char *token;
+	int ret;
+
+	if (read_expected_item(EVENT_ITEM, (char *)"format") < 0)
+		return -1;
+
+	if (read_expected(EVENT_OP, (char *)":") < 0)
+		return -1;
+
+	if (read_expect_type(EVENT_NEWLINE, &token))
+		goto fail;
+	free_token(token);
+
+	ret = event_read_fields(event, &event->format.common_fields);
+	if (ret < 0)
+		return ret;
+	event->format.nr_common = ret;
+
+	ret = event_read_fields(event, &event->format.fields);
+	if (ret < 0)
+		return ret;
+	event->format.nr_fields = ret;
+
+	return 0;
+
+ fail:
+	free_token(token);
+	return -1;
+}
+
+enum event_type
+process_arg_token(struct event *event, struct print_arg *arg,
+		  char **tok, enum event_type type);
+
+static enum event_type
+process_arg(struct event *event, struct print_arg *arg, char **tok)
+{
+	enum event_type type;
+	char *token;
+
+	type = read_token(&token);
+	*tok = token;
+
+	return process_arg_token(event, arg, tok, type);
+}
+
+static enum event_type
+process_cond(struct event *event, struct print_arg *top, char **tok)
+{
+	struct print_arg *arg, *left, *right;
+	enum event_type type;
+	char *token = NULL;
+
+	arg = malloc_or_die(sizeof(*arg));
+	memset(arg, 0, sizeof(*arg));
+
+	left = malloc_or_die(sizeof(*left));
+
+	right = malloc_or_die(sizeof(*right));
+
+	arg->type = PRINT_OP;
+	arg->op.left = left;
+	arg->op.right = right;
+
+	*tok = NULL;
+	type = process_arg(event, left, &token);
+	if (test_type_token(type, token, EVENT_OP, (char *)":"))
+		goto out_free;
+
+	arg->op.op = token;
+
+	type = process_arg(event, right, &token);
+
+	top->op.right = arg;
+
+	*tok = token;
+	return type;
+
+out_free:
+	free_token(*tok);
+	free(right);
+	free(left);
+	free_arg(arg);
+	return EVENT_ERROR;
+}
+
+static int get_op_prio(char *op)
+{
+	if (!op[1]) {
+		switch (op[0]) {
+		case '*':
+		case '/':
+		case '%':
+			return 6;
+		case '+':
+		case '-':
+			return 7;
+			/* '>>' and '<<' are 8 */
+		case '<':
+		case '>':
+			return 9;
+			/* '==' and '!=' are 10 */
+		case '&':
+			return 11;
+		case '^':
+			return 12;
+		case '|':
+			return 13;
+		case '?':
+			return 16;
+		default:
+			die("unknown op '%c'", op[0]);
+			return -1;
+		}
+	} else {
+		if (strcmp(op, "++") == 0 ||
+		    strcmp(op, "--") == 0) {
+			return 3;
+		} else if (strcmp(op, ">>") == 0 ||
+			   strcmp(op, "<<") == 0) {
+			return 8;
+		} else if (strcmp(op, ">=") == 0 ||
+			   strcmp(op, "<=") == 0) {
+			return 9;
+		} else if (strcmp(op, "==") == 0 ||
+			   strcmp(op, "!=") == 0) {
+			return 10;
+		} else if (strcmp(op, "&&") == 0) {
+			return 14;
+		} else if (strcmp(op, "||") == 0) {
+			return 15;
+		} else {
+			die("unknown op '%s'", op);
+			return -1;
+		}
+	}
+}
+
+static void set_op_prio(struct print_arg *arg)
+{
+
+	/* single ops are the greatest */
+	if (!arg->op.left || arg->op.left->type == PRINT_NULL) {
+		arg->op.prio = 0;
+		return;
+	}
+
+	arg->op.prio = get_op_prio(arg->op.op);
+}
+
+static enum event_type
+process_op(struct event *event, struct print_arg *arg, char **tok)
+{
+	struct print_arg *left, *right = NULL;
+	enum event_type type;
+	char *token;
+
+	/* the op is passed in via tok */
+	token = *tok;
+
+	if (arg->type == PRINT_OP && !arg->op.left) {
+		/* handle single op */
+		if (token[1]) {
+			die("bad op token %s", token);
+			return EVENT_ERROR;
+		}
+		switch (token[0]) {
+		case '!':
+		case '+':
+		case '-':
+			break;
+		default:
+			die("bad op token %s", token);
+			return EVENT_ERROR;
+		}
+
+		/* make an empty left */
+		left = malloc_or_die(sizeof(*left));
+		left->type = PRINT_NULL;
+		arg->op.left = left;
+
+		right = malloc_or_die(sizeof(*right));
+		arg->op.right = right;
+
+		type = process_arg(event, right, tok);
+
+	} else if (strcmp(token, "?") == 0) {
+
+		left = malloc_or_die(sizeof(*left));
+		/* copy the top arg to the left */
+		*left = *arg;
+
+		arg->type = PRINT_OP;
+		arg->op.op = token;
+		arg->op.left = left;
+		arg->op.prio = 0;
+
+		type = process_cond(event, arg, tok);
+
+	} else if (strcmp(token, ">>") == 0 ||
+		   strcmp(token, "<<") == 0 ||
+		   strcmp(token, "&") == 0 ||
+		   strcmp(token, "|") == 0 ||
+		   strcmp(token, "&&") == 0 ||
+		   strcmp(token, "||") == 0 ||
+		   strcmp(token, "-") == 0 ||
+		   strcmp(token, "+") == 0 ||
+		   strcmp(token, "*") == 0 ||
+		   strcmp(token, "^") == 0 ||
+		   strcmp(token, "/") == 0 ||
+		   strcmp(token, "==") == 0 ||
+		   strcmp(token, "!=") == 0) {
+
+		left = malloc_or_die(sizeof(*left));
+
+		/* copy the top arg to the left */
+		*left = *arg;
+
+		arg->type = PRINT_OP;
+		arg->op.op = token;
+		arg->op.left = left;
+
+		set_op_prio(arg);
+
+		right = malloc_or_die(sizeof(*right));
+
+		type = process_arg(event, right, tok);
+
+		arg->op.right = right;
+
+	} else {
+		die("unknown op '%s'", token);
+		/* the arg is now the left side */
+		return EVENT_NONE;
+	}
+
+
+	if (type == EVENT_OP) {
+		int prio;
+
+		/* higher prios need to be closer to the root */
+		prio = get_op_prio(*tok);
+
+		if (prio > arg->op.prio)
+			return process_op(event, arg, tok);
+
+		return process_op(event, right, tok);
+	}
+
+	return type;
+}
+
+static enum event_type
+process_entry(struct event *event __unused, struct print_arg *arg,
+	      char **tok)
+{
+	enum event_type type;
+	char *field;
+	char *token;
+
+	if (read_expected(EVENT_OP, (char *)"->") < 0)
+		return EVENT_ERROR;
+
+	if (read_expect_type(EVENT_ITEM, &token) < 0)
+		goto fail;
+	field = token;
+
+	arg->type = PRINT_FIELD;
+	arg->field.name = field;
+
+	type = read_token(&token);
+	*tok = token;
+
+	return type;
+
+fail:
+	free_token(token);
+	return EVENT_ERROR;
+}
+
+static char *arg_eval (struct print_arg *arg);
+
+static long long arg_num_eval(struct print_arg *arg)
+{
+	long long left, right;
+	long long val = 0;
+
+	switch (arg->type) {
+	case PRINT_ATOM:
+		val = strtoll(arg->atom.atom, NULL, 0);
+		break;
+	case PRINT_TYPE:
+		val = arg_num_eval(arg->typecast.item);
+		break;
+	case PRINT_OP:
+		switch (arg->op.op[0]) {
+		case '|':
+			left = arg_num_eval(arg->op.left);
+			right = arg_num_eval(arg->op.right);
+			if (arg->op.op[1])
+				val = left || right;
+			else
+				val = left | right;
+			break;
+		case '&':
+			left = arg_num_eval(arg->op.left);
+			right = arg_num_eval(arg->op.right);
+			if (arg->op.op[1])
+				val = left && right;
+			else
+				val = left & right;
+			break;
+		case '<':
+			left = arg_num_eval(arg->op.left);
+			right = arg_num_eval(arg->op.right);
+			switch (arg->op.op[1]) {
+			case 0:
+				val = left < right;
+				break;
+			case '<':
+				val = left << right;
+				break;
+			case '=':
+				val = left <= right;
+				break;
+			default:
+				die("unknown op '%s'", arg->op.op);
+			}
+			break;
+		case '>':
+			left = arg_num_eval(arg->op.left);
+			right = arg_num_eval(arg->op.right);
+			switch (arg->op.op[1]) {
+			case 0:
+				val = left > right;
+				break;
+			case '>':
+				val = left >> right;
+				break;
+			case '=':
+				val = left >= right;
+				break;
+			default:
+				die("unknown op '%s'", arg->op.op);
+			}
+			break;
+		case '=':
+			left = arg_num_eval(arg->op.left);
+			right = arg_num_eval(arg->op.right);
+
+			if (arg->op.op[1] != '=')
+				die("unknown op '%s'", arg->op.op);
+
+			val = left == right;
+			break;
+		case '!':
+			left = arg_num_eval(arg->op.left);
+			right = arg_num_eval(arg->op.right);
+
+			switch (arg->op.op[1]) {
+			case '=':
+				val = left != right;
+				break;
+			default:
+				die("unknown op '%s'", arg->op.op);
+			}
+			break;
+		default:
+			die("unknown op '%s'", arg->op.op);
+		}
+		break;
+
+	case PRINT_NULL:
+	case PRINT_FIELD ... PRINT_SYMBOL:
+	case PRINT_STRING:
+	default:
+		die("invalid eval type %d", arg->type);
+
+	}
+	return val;
+}
+
+static char *arg_eval (struct print_arg *arg)
+{
+	long long val;
+	static char buf[20];
+
+	switch (arg->type) {
+	case PRINT_ATOM:
+		return arg->atom.atom;
+	case PRINT_TYPE:
+		return arg_eval(arg->typecast.item);
+	case PRINT_OP:
+		val = arg_num_eval(arg);
+		sprintf(buf, "%lld", val);
+		return buf;
+
+	case PRINT_NULL:
+	case PRINT_FIELD ... PRINT_SYMBOL:
+	case PRINT_STRING:
+	default:
+		die("invalid eval type %d", arg->type);
+		break;
+	}
+
+	return NULL;
+}
+
+static enum event_type
+process_fields(struct event *event, struct print_flag_sym **list, char **tok)
+{
+	enum event_type type;
+	struct print_arg *arg = NULL;
+	struct print_flag_sym *field;
+	char *token = NULL;
+	char *value;
+
+	do {
+		free_token(token);
+		type = read_token_item(&token);
+		if (test_type_token(type, token, EVENT_OP, (char *)"{"))
+			break;
+
+		arg = malloc_or_die(sizeof(*arg));
+
+		free_token(token);
+		type = process_arg(event, arg, &token);
+		if (test_type_token(type, token, EVENT_DELIM, (char *)","))
+			goto out_free;
+
+		field = malloc_or_die(sizeof(*field));
+		memset(field, 0, sizeof(field));
+
+		value = arg_eval(arg);
+		field->value = strdup(value);
+
+		free_token(token);
+		type = process_arg(event, arg, &token);
+		if (test_type_token(type, token, EVENT_OP, (char *)"}"))
+			goto out_free;
+
+		value = arg_eval(arg);
+		field->str = strdup(value);
+		free_arg(arg);
+		arg = NULL;
+
+		*list = field;
+		list = &field->next;
+
+		free_token(token);
+		type = read_token_item(&token);
+	} while (type == EVENT_DELIM && strcmp(token, ",") == 0);
+
+	*tok = token;
+	return type;
+
+out_free:
+	free_arg(arg);
+	free_token(token);
+
+	return EVENT_ERROR;
+}
+
+static enum event_type
+process_flags(struct event *event, struct print_arg *arg, char **tok)
+{
+	struct print_arg *field;
+	enum event_type type;
+	char *token;
+
+	memset(arg, 0, sizeof(*arg));
+	arg->type = PRINT_FLAGS;
+
+	if (read_expected_item(EVENT_DELIM, (char *)"(") < 0)
+		return EVENT_ERROR;
+
+	field = malloc_or_die(sizeof(*field));
+
+	type = process_arg(event, field, &token);
+	if (test_type_token(type, token, EVENT_DELIM, (char *)","))
+		goto out_free;
+
+	arg->flags.field = field;
+
+	type = read_token_item(&token);
+	if (event_item_type(type)) {
+		arg->flags.delim = token;
+		type = read_token_item(&token);
+	}
+
+	if (test_type_token(type, token, EVENT_DELIM, (char *)","))
+		goto out_free;
+
+	type = process_fields(event, &arg->flags.flags, &token);
+	if (test_type_token(type, token, EVENT_DELIM, (char *)")"))
+		goto out_free;
+
+	free_token(token);
+	type = read_token_item(tok);
+	return type;
+
+out_free:
+	free_token(token);
+	return EVENT_ERROR;
+}
+
+static enum event_type
+process_symbols(struct event *event, struct print_arg *arg, char **tok)
+{
+	struct print_arg *field;
+	enum event_type type;
+	char *token;
+
+	memset(arg, 0, sizeof(*arg));
+	arg->type = PRINT_SYMBOL;
+
+	if (read_expected_item(EVENT_DELIM, (char *)"(") < 0)
+		return EVENT_ERROR;
+
+	field = malloc_or_die(sizeof(*field));
+
+	type = process_arg(event, field, &token);
+	if (test_type_token(type, token, EVENT_DELIM, (char *)","))
+		goto out_free;
+
+	arg->symbol.field = field;
+
+	type = process_fields(event, &arg->symbol.symbols, &token);
+	if (test_type_token(type, token, EVENT_DELIM, (char *)")"))
+		goto out_free;
+
+	free_token(token);
+	type = read_token_item(tok);
+	return type;
+
+out_free:
+	free_token(token);
+	return EVENT_ERROR;
+}
+
+static enum event_type
+process_paren(struct event *event, struct print_arg *arg, char **tok)
+{
+	struct print_arg *item_arg;
+	enum event_type type;
+	int ptr_cast = 0;
+	char *token;
+
+	type = process_arg(event, arg, &token);
+
+	if (type == EVENT_ERROR)
+		return EVENT_ERROR;
+
+	if (type == EVENT_OP) {
+		/* handle the ptr casts */
+		if (!strcmp(token, "*")) {
+			/*
+			 * FIXME: should we zapp whitespaces before ')' ?
+			 * (may require a peek_token_item())
+			 */
+			if (__peek_char() == ')') {
+				ptr_cast = 1;
+				free_token(token);
+				type = read_token_item(&token);
+			}
+		}
+		if (!ptr_cast) {
+			type = process_op(event, arg, &token);
+
+			if (type == EVENT_ERROR)
+				return EVENT_ERROR;
+		}
+	}
+
+	if (test_type_token(type, token, EVENT_DELIM, (char *)")")) {
+		free_token(token);
+		return EVENT_ERROR;
+	}
+
+	free_token(token);
+	type = read_token_item(&token);
+
+	/*
+	 * If the next token is an item or another open paren, then
+	 * this was a typecast.
+	 */
+	if (event_item_type(type) ||
+	    (type == EVENT_DELIM && strcmp(token, "(") == 0)) {
+
+		/* make this a typecast and contine */
+
+		/* prevous must be an atom */
+		if (arg->type != PRINT_ATOM)
+			die("previous needed to be PRINT_ATOM");
+
+		item_arg = malloc_or_die(sizeof(*item_arg));
+
+		arg->type = PRINT_TYPE;
+		if (ptr_cast) {
+			char *old = arg->atom.atom;
+
+			arg->atom.atom = malloc_or_die(strlen(old + 3));
+			sprintf(arg->atom.atom, "%s *", old);
+			free(old);
+		}
+		arg->typecast.type = arg->atom.atom;
+		arg->typecast.item = item_arg;
+		type = process_arg_token(event, item_arg, &token, type);
+
+	}
+
+	*tok = token;
+	return type;
+}
+
+
+static enum event_type
+process_str(struct event *event __unused, struct print_arg *arg, char **tok)
+{
+	enum event_type type;
+	char *token;
+
+	if (read_expected(EVENT_DELIM, (char *)"(") < 0)
+		return EVENT_ERROR;
+
+	if (read_expect_type(EVENT_ITEM, &token) < 0)
+		goto fail;
+
+	arg->type = PRINT_STRING;
+	arg->string.string = token;
+	arg->string.offset = -1;
+
+	if (read_expected(EVENT_DELIM, (char *)")") < 0)
+		return EVENT_ERROR;
+
+	type = read_token(&token);
+	*tok = token;
+
+	return type;
+fail:
+	free_token(token);
+	return EVENT_ERROR;
+}
+
+enum event_type
+process_arg_token(struct event *event, struct print_arg *arg,
+		  char **tok, enum event_type type)
+{
+	char *token;
+	char *atom;
+
+	token = *tok;
+
+	switch (type) {
+	case EVENT_ITEM:
+		if (strcmp(token, "REC") == 0) {
+			free_token(token);
+			type = process_entry(event, arg, &token);
+		} else if (strcmp(token, "__print_flags") == 0) {
+			free_token(token);
+			type = process_flags(event, arg, &token);
+		} else if (strcmp(token, "__print_symbolic") == 0) {
+			free_token(token);
+			type = process_symbols(event, arg, &token);
+		} else if (strcmp(token, "__get_str") == 0) {
+			free_token(token);
+			type = process_str(event, arg, &token);
+		} else {
+			atom = token;
+			/* test the next token */
+			type = read_token_item(&token);
+
+			/* atoms can be more than one token long */
+			while (type == EVENT_ITEM) {
+				atom = realloc(atom, strlen(atom) + strlen(token) + 2);
+				strcat(atom, " ");
+				strcat(atom, token);
+				free_token(token);
+				type = read_token_item(&token);
+			}
+
+			/* todo, test for function */
+
+			arg->type = PRINT_ATOM;
+			arg->atom.atom = atom;
+		}
+		break;
+	case EVENT_DQUOTE:
+	case EVENT_SQUOTE:
+		arg->type = PRINT_ATOM;
+		arg->atom.atom = token;
+		type = read_token_item(&token);
+		break;
+	case EVENT_DELIM:
+		if (strcmp(token, "(") == 0) {
+			free_token(token);
+			type = process_paren(event, arg, &token);
+			break;
+		}
+	case EVENT_OP:
+		/* handle single ops */
+		arg->type = PRINT_OP;
+		arg->op.op = token;
+		arg->op.left = NULL;
+		type = process_op(event, arg, &token);
+
+		break;
+
+	case EVENT_ERROR ... EVENT_NEWLINE:
+	default:
+		die("unexpected type %d", type);
+	}
+	*tok = token;
+
+	return type;
+}
+
+static int event_read_print_args(struct event *event, struct print_arg **list)
+{
+	enum event_type type;
+	struct print_arg *arg;
+	char *token;
+	int args = 0;
+
+	do {
+		arg = malloc_or_die(sizeof(*arg));
+		memset(arg, 0, sizeof(*arg));
+
+		type = process_arg(event, arg, &token);
+
+		if (type == EVENT_ERROR) {
+			free_arg(arg);
+			return -1;
+		}
+
+		*list = arg;
+		args++;
+
+		if (type == EVENT_OP) {
+			type = process_op(event, arg, &token);
+			list = &arg->next;
+			continue;
+		}
+
+		if (type == EVENT_DELIM && strcmp(token, ",") == 0) {
+			free_token(token);
+			*list = arg;
+			list = &arg->next;
+			continue;
+		}
+		break;
+	} while (type != EVENT_NONE);
+
+	if (type != EVENT_NONE)
+		free_token(token);
+
+	return args;
+}
+
+static int event_read_print(struct event *event)
+{
+	enum event_type type;
+	char *token;
+	int ret;
+
+	if (read_expected_item(EVENT_ITEM, (char *)"print") < 0)
+		return -1;
+
+	if (read_expected(EVENT_ITEM, (char *)"fmt") < 0)
+		return -1;
+
+	if (read_expected(EVENT_OP, (char *)":") < 0)
+		return -1;
+
+	if (read_expect_type(EVENT_DQUOTE, &token) < 0)
+		goto fail;
+
+	event->print_fmt.format = token;
+	event->print_fmt.args = NULL;
+
+	/* ok to have no arg */
+	type = read_token_item(&token);
+
+	if (type == EVENT_NONE)
+		return 0;
+
+	if (test_type_token(type, token, EVENT_DELIM, (char *)","))
+		goto fail;
+
+	free_token(token);
+
+	ret = event_read_print_args(event, &event->print_fmt.args);
+	if (ret < 0)
+		return -1;
+
+	return 0;
+
+ fail:
+	free_token(token);
+	return -1;
+}
+
+static struct format_field *
+find_common_field(struct event *event, const char *name)
+{
+	struct format_field *format;
+
+	for (format = event->format.common_fields;
+	     format; format = format->next) {
+		if (strcmp(format->name, name) == 0)
+			break;
+	}
+
+	return format;
+}
+
+static struct format_field *
+find_field(struct event *event, const char *name)
+{
+	struct format_field *format;
+
+	for (format = event->format.fields;
+	     format; format = format->next) {
+		if (strcmp(format->name, name) == 0)
+			break;
+	}
+
+	return format;
+}
+
+static struct format_field *
+find_any_field(struct event *event, const char *name)
+{
+	struct format_field *format;
+
+	format = find_common_field(event, name);
+	if (format)
+		return format;
+	return find_field(event, name);
+}
+
+static unsigned long long read_size(void *ptr, int size)
+{
+	switch (size) {
+	case 1:
+		return *(unsigned char *)ptr;
+	case 2:
+		return data2host2(ptr);
+	case 4:
+		return data2host4(ptr);
+	case 8:
+		return data2host8(ptr);
+	default:
+		/* BUG! */
+		return 0;
+	}
+}
+
+static int get_common_info(const char *type, int *offset, int *size)
+{
+	struct event *event;
+	struct format_field *field;
+
+	/*
+	 * All events should have the same common elements.
+	 * Pick any event to find where the type is;
+	 */
+	if (!event_list)
+		die("no event_list!");
+
+	event = event_list;
+	field = find_common_field(event, type);
+	if (!field)
+		die("field '%s' not found", type);
+
+	*offset = field->offset;
+	*size = field->size;
+
+	return 0;
+}
+
+static int parse_common_type(void *data)
+{
+	static int type_offset;
+	static int type_size;
+	int ret;
+
+	if (!type_size) {
+		ret = get_common_info("common_type",
+				      &type_offset,
+				      &type_size);
+		if (ret < 0)
+			return ret;
+	}
+	return read_size(data + type_offset, type_size);
+}
+
+static int parse_common_pid(void *data)
+{
+	static int pid_offset;
+	static int pid_size;
+	int ret;
+
+	if (!pid_size) {
+		ret = get_common_info("common_pid",
+				      &pid_offset,
+				      &pid_size);
+		if (ret < 0)
+			return ret;
+	}
+
+	return read_size(data + pid_offset, pid_size);
+}
+
+static struct event *find_event(int id)
+{
+	struct event *event;
+
+	for (event = event_list; event; event = event->next) {
+		if (event->id == id)
+			break;
+	}
+	return event;
+}
+
+static unsigned long long eval_num_arg(void *data, int size,
+				   struct event *event, struct print_arg *arg)
+{
+	unsigned long long val = 0;
+	unsigned long long left, right;
+
+	switch (arg->type) {
+	case PRINT_NULL:
+		/* ?? */
+		return 0;
+	case PRINT_ATOM:
+		return strtoull(arg->atom.atom, NULL, 0);
+	case PRINT_FIELD:
+		if (!arg->field.field) {
+			arg->field.field = find_any_field(event, arg->field.name);
+			if (!arg->field.field)
+				die("field %s not found", arg->field.name);
+		}
+		/* must be a number */
+		val = read_size(data + arg->field.field->offset,
+				arg->field.field->size);
+		break;
+	case PRINT_FLAGS:
+	case PRINT_SYMBOL:
+		break;
+	case PRINT_TYPE:
+		return eval_num_arg(data, size, event, arg->typecast.item);
+	case PRINT_STRING:
+		return 0;
+		break;
+	case PRINT_OP:
+		left = eval_num_arg(data, size, event, arg->op.left);
+		right = eval_num_arg(data, size, event, arg->op.right);
+		switch (arg->op.op[0]) {
+		case '|':
+			if (arg->op.op[1])
+				val = left || right;
+			else
+				val = left | right;
+			break;
+		case '&':
+			if (arg->op.op[1])
+				val = left && right;
+			else
+				val = left & right;
+			break;
+		case '<':
+			switch (arg->op.op[1]) {
+			case 0:
+				val = left < right;
+				break;
+			case '<':
+				val = left << right;
+				break;
+			case '=':
+				val = left <= right;
+				break;
+			default:
+				die("unknown op '%s'", arg->op.op);
+			}
+			break;
+		case '>':
+			switch (arg->op.op[1]) {
+			case 0:
+				val = left > right;
+				break;
+			case '>':
+				val = left >> right;
+				break;
+			case '=':
+				val = left >= right;
+				break;
+			default:
+				die("unknown op '%s'", arg->op.op);
+			}
+			break;
+		case '=':
+			if (arg->op.op[1] != '=')
+				die("unknown op '%s'", arg->op.op);
+			val = left == right;
+			break;
+		default:
+			die("unknown op '%s'", arg->op.op);
+		}
+		break;
+	default: /* not sure what to do there */
+		return 0;
+	}
+	return val;
+}
+
+struct flag {
+	const char *name;
+	unsigned long long value;
+};
+
+static const struct flag flags[] = {
+	{ "HI_SOFTIRQ", 0 },
+	{ "TIMER_SOFTIRQ", 1 },
+	{ "NET_TX_SOFTIRQ", 2 },
+	{ "NET_RX_SOFTIRQ", 3 },
+	{ "BLOCK_SOFTIRQ", 4 },
+	{ "TASKLET_SOFTIRQ", 5 },
+	{ "SCHED_SOFTIRQ", 6 },
+	{ "HRTIMER_SOFTIRQ", 7 },
+	{ "RCU_SOFTIRQ", 8 },
+
+	{ "HRTIMER_NORESTART", 0 },
+	{ "HRTIMER_RESTART", 1 },
+};
+
+static unsigned long long eval_flag(const char *flag)
+{
+	int i;
+
+	/*
+	 * Some flags in the format files do not get converted.
+	 * If the flag is not numeric, see if it is something that
+	 * we already know about.
+	 */
+	if (isdigit(flag[0]))
+		return strtoull(flag, NULL, 0);
+
+	for (i = 0; i < (int)(sizeof(flags)/sizeof(flags[0])); i++)
+		if (strcmp(flags[i].name, flag) == 0)
+			return flags[i].value;
+
+	return 0;
+}
+
+static void print_str_arg(void *data, int size,
+			  struct event *event, struct print_arg *arg)
+{
+	struct print_flag_sym *flag;
+	unsigned long long val, fval;
+	char *str;
+	int print;
+
+	switch (arg->type) {
+	case PRINT_NULL:
+		/* ?? */
+		return;
+	case PRINT_ATOM:
+		printf("%s", arg->atom.atom);
+		return;
+	case PRINT_FIELD:
+		if (!arg->field.field) {
+			arg->field.field = find_any_field(event, arg->field.name);
+			if (!arg->field.field)
+				die("field %s not found", arg->field.name);
+		}
+		str = malloc_or_die(arg->field.field->size + 1);
+		memcpy(str, data + arg->field.field->offset,
+		       arg->field.field->size);
+		str[arg->field.field->size] = 0;
+		printf("%s", str);
+		free(str);
+		break;
+	case PRINT_FLAGS:
+		val = eval_num_arg(data, size, event, arg->flags.field);
+		print = 0;
+		for (flag = arg->flags.flags; flag; flag = flag->next) {
+			fval = eval_flag(flag->value);
+			if (!val && !fval) {
+				printf("%s", flag->str);
+				break;
+			}
+			if (fval && (val & fval) == fval) {
+				if (print && arg->flags.delim)
+					printf("%s", arg->flags.delim);
+				printf("%s", flag->str);
+				print = 1;
+				val &= ~fval;
+			}
+		}
+		break;
+	case PRINT_SYMBOL:
+		val = eval_num_arg(data, size, event, arg->symbol.field);
+		for (flag = arg->symbol.symbols; flag; flag = flag->next) {
+			fval = eval_flag(flag->value);
+			if (val == fval) {
+				printf("%s", flag->str);
+				break;
+			}
+		}
+		break;
+
+	case PRINT_TYPE:
+		break;
+	case PRINT_STRING: {
+		int str_offset;
+
+		if (arg->string.offset == -1) {
+			struct format_field *f;
+
+			f = find_any_field(event, arg->string.string);
+			arg->string.offset = f->offset;
+		}
+		str_offset = *(int *)(data + arg->string.offset);
+		str_offset &= 0xffff;
+		printf("%s", ((char *)data) + str_offset);
+		break;
+	}
+	case PRINT_OP:
+		/*
+		 * The only op for string should be ? :
+		 */
+		if (arg->op.op[0] != '?')
+			return;
+		val = eval_num_arg(data, size, event, arg->op.left);
+		if (val)
+			print_str_arg(data, size, event, arg->op.right->op.left);
+		else
+			print_str_arg(data, size, event, arg->op.right->op.right);
+		break;
+	default:
+		/* well... */
+		break;
+	}
+}
+
+static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struct event *event)
+{
+	static struct format_field *field, *ip_field;
+	struct print_arg *args, *arg, **next;
+	unsigned long long ip, val;
+	char *ptr;
+	void *bptr;
+
+	if (!field) {
+		field = find_field(event, "buf");
+		if (!field)
+			die("can't find buffer field for binary printk");
+		ip_field = find_field(event, "ip");
+		if (!ip_field)
+			die("can't find ip field for binary printk");
+	}
+
+	ip = read_size(data + ip_field->offset, ip_field->size);
+
+	/*
+	 * The first arg is the IP pointer.
+	 */
+	args = malloc_or_die(sizeof(*args));
+	arg = args;
+	arg->next = NULL;
+	next = &arg->next;
+
+	arg->type = PRINT_ATOM;
+	arg->atom.atom = malloc_or_die(32);
+	sprintf(arg->atom.atom, "%lld", ip);
+
+	/* skip the first "%pf : " */
+	for (ptr = fmt + 6, bptr = data + field->offset;
+	     bptr < data + size && *ptr; ptr++) {
+		int ls = 0;
+
+		if (*ptr == '%') {
+ process_again:
+			ptr++;
+			switch (*ptr) {
+			case '%':
+				break;
+			case 'l':
+				ls++;
+				goto process_again;
+			case 'L':
+				ls = 2;
+				goto process_again;
+			case '0' ... '9':
+				goto process_again;
+			case 'p':
+				ls = 1;
+				/* fall through */
+			case 'd':
+			case 'u':
+			case 'x':
+			case 'i':
+				bptr = (void *)(((unsigned long)bptr + (long_size - 1)) &
+						~(long_size - 1));
+				switch (ls) {
+				case 0:
+				case 1:
+					ls = long_size;
+					break;
+				case 2:
+					ls = 8;
+				default:
+					break;
+				}
+				val = read_size(bptr, ls);
+				bptr += ls;
+				arg = malloc_or_die(sizeof(*arg));
+				arg->next = NULL;
+				arg->type = PRINT_ATOM;
+				arg->atom.atom = malloc_or_die(32);
+				sprintf(arg->atom.atom, "%lld", val);
+				*next = arg;
+				next = &arg->next;
+				break;
+			case 's':
+				arg = malloc_or_die(sizeof(*arg));
+				arg->next = NULL;
+				arg->type = PRINT_STRING;
+				arg->string.string = strdup(bptr);
+				bptr += strlen(bptr) + 1;
+				*next = arg;
+				next = &arg->next;
+			default:
+				break;
+			}
+		}
+	}
+
+	return args;
+}
+
+static void free_args(struct print_arg *args)
+{
+	struct print_arg *next;
+
+	while (args) {
+		next = args->next;
+
+		if (args->type == PRINT_ATOM)
+			free(args->atom.atom);
+		else
+			free(args->string.string);
+		free(args);
+		args = next;
+	}
+}
+
+static char *get_bprint_format(void *data, int size __unused, struct event *event)
+{
+	unsigned long long addr;
+	static struct format_field *field;
+	struct printk_map *printk;
+	char *format;
+	char *p;
+
+	if (!field) {
+		field = find_field(event, "fmt");
+		if (!field)
+			die("can't find format field for binary printk");
+		printf("field->offset = %d size=%d\n", field->offset, field->size);
+	}
+
+	addr = read_size(data + field->offset, field->size);
+
+	printk = find_printk(addr);
+	if (!printk) {
+		format = malloc_or_die(45);
+		sprintf(format, "%%pf : (NO FORMAT FOUND at %llx)\n",
+			addr);
+		return format;
+	}
+
+	p = printk->printk;
+	/* Remove any quotes. */
+	if (*p == '"')
+		p++;
+	format = malloc_or_die(strlen(p) + 10);
+	sprintf(format, "%s : %s", "%pf", p);
+	/* remove ending quotes and new line since we will add one too */
+	p = format + strlen(format) - 1;
+	if (*p == '"')
+		*p = 0;
+
+	p -= 2;
+	if (strcmp(p, "\\n") == 0)
+		*p = 0;
+
+	return format;
+}
+
+static void pretty_print(void *data, int size, struct event *event)
+{
+	struct print_fmt *print_fmt = &event->print_fmt;
+	struct print_arg *arg = print_fmt->args;
+	struct print_arg *args = NULL;
+	const char *ptr = print_fmt->format;
+	unsigned long long val;
+	struct func_map *func;
+	const char *saveptr;
+	char *bprint_fmt = NULL;
+	char format[32];
+	int show_func;
+	int len;
+	int ls;
+
+	if (event->flags & EVENT_FL_ISFUNC)
+		ptr = " %pF <-- %pF";
+
+	if (event->flags & EVENT_FL_ISBPRINT) {
+		bprint_fmt = get_bprint_format(data, size, event);
+		args = make_bprint_args(bprint_fmt, data, size, event);
+		arg = args;
+		ptr = bprint_fmt;
+	}
+
+	for (; *ptr; ptr++) {
+		ls = 0;
+		if (*ptr == '%') {
+			saveptr = ptr;
+			show_func = 0;
+ cont_process:
+			ptr++;
+			switch (*ptr) {
+			case '%':
+				printf("%%");
+				break;
+			case 'l':
+				ls++;
+				goto cont_process;
+			case 'L':
+				ls = 2;
+				goto cont_process;
+			case 'z':
+			case 'Z':
+			case '0' ... '9':
+				goto cont_process;
+			case 'p':
+				if (long_size == 4)
+					ls = 1;
+				else
+					ls = 2;
+
+				if (*(ptr+1) == 'F' ||
+				    *(ptr+1) == 'f') {
+					ptr++;
+					show_func = *ptr;
+				}
+
+				/* fall through */
+			case 'd':
+			case 'i':
+			case 'x':
+			case 'X':
+			case 'u':
+				if (!arg)
+					die("no argument match");
+
+				len = ((unsigned long)ptr + 1) -
+					(unsigned long)saveptr;
+
+				/* should never happen */
+				if (len > 32)
+					die("bad format!");
+
+				memcpy(format, saveptr, len);
+				format[len] = 0;
+
+				val = eval_num_arg(data, size, event, arg);
+				arg = arg->next;
+
+				if (show_func) {
+					func = find_func(val);
+					if (func) {
+						printf("%s", func->func);
+						if (show_func == 'F')
+							printf("+0x%llx",
+							       val - func->addr);
+						break;
+					}
+				}
+				switch (ls) {
+				case 0:
+					printf(format, (int)val);
+					break;
+				case 1:
+					printf(format, (long)val);
+					break;
+				case 2:
+					printf(format, (long long)val);
+					break;
+				default:
+					die("bad count (%d)", ls);
+				}
+				break;
+			case 's':
+				if (!arg)
+					die("no matching argument");
+
+				print_str_arg(data, size, event, arg);
+				arg = arg->next;
+				break;
+			default:
+				printf(">%c<", *ptr);
+
+			}
+		} else
+			printf("%c", *ptr);
+	}
+
+	if (args) {
+		free_args(args);
+		free(bprint_fmt);
+	}
+}
+
+static inline int log10_cpu(int nb)
+{
+	if (nb / 100)
+		return 3;
+	if (nb / 10)
+		return 2;
+	return 1;
+}
+
+/* taken from Linux, written by Frederic Weisbecker */
+static void print_graph_cpu(int cpu)
+{
+	int i;
+	int log10_this = log10_cpu(cpu);
+	int log10_all = log10_cpu(cpus);
+
+
+	/*
+	 * Start with a space character - to make it stand out
+	 * to the right a bit when trace output is pasted into
+	 * email:
+	 */
+	printf(" ");
+
+	/*
+	 * Tricky - we space the CPU field according to the max
+	 * number of online CPUs. On a 2-cpu system it would take
+	 * a maximum of 1 digit - on a 128 cpu system it would
+	 * take up to 3 digits:
+	 */
+	for (i = 0; i < log10_all - log10_this; i++)
+		printf(" ");
+
+	printf("%d) ", cpu);
+}
+
+#define TRACE_GRAPH_PROCINFO_LENGTH	14
+#define TRACE_GRAPH_INDENT	2
+
+static void print_graph_proc(int pid, const char *comm)
+{
+	/* sign + log10(MAX_INT) + '\0' */
+	char pid_str[11];
+	int spaces = 0;
+	int len;
+	int i;
+
+	sprintf(pid_str, "%d", pid);
+
+	/* 1 stands for the "-" character */
+	len = strlen(comm) + strlen(pid_str) + 1;
+
+	if (len < TRACE_GRAPH_PROCINFO_LENGTH)
+		spaces = TRACE_GRAPH_PROCINFO_LENGTH - len;
+
+	/* First spaces to align center */
+	for (i = 0; i < spaces / 2; i++)
+		printf(" ");
+
+	printf("%s-%s", comm, pid_str);
+
+	/* Last spaces to align center */
+	for (i = 0; i < spaces - (spaces / 2); i++)
+		printf(" ");
+}
+
+static struct record *
+get_return_for_leaf(int cpu, int cur_pid, unsigned long long cur_func,
+		    struct record *next)
+{
+	struct format_field *field;
+	struct event *event;
+	unsigned long val;
+	int type;
+	int pid;
+
+	type = parse_common_type(next->data);
+	event = find_event(type);
+	if (!event)
+		return NULL;
+
+	if (!(event->flags & EVENT_FL_ISFUNCRET))
+		return NULL;
+
+	pid = parse_common_pid(next->data);
+	field = find_field(event, "func");
+	if (!field)
+		die("function return does not have field func");
+
+	val = read_size(next->data + field->offset, field->size);
+
+	if (cur_pid != pid || cur_func != val)
+		return NULL;
+
+	/* this is a leaf, now advance the iterator */
+	return trace_read_data(cpu);
+}
+
+/* Signal a overhead of time execution to the output */
+static void print_graph_overhead(unsigned long long duration)
+{
+	/* Non nested entry or return */
+	if (duration == ~0ULL)
+		return (void)printf("  ");
+
+	/* Duration exceeded 100 msecs */
+	if (duration > 100000ULL)
+		return (void)printf("! ");
+
+	/* Duration exceeded 10 msecs */
+	if (duration > 10000ULL)
+		return (void)printf("+ ");
+
+	printf("  ");
+}
+
+static void print_graph_duration(unsigned long long duration)
+{
+	unsigned long usecs = duration / 1000;
+	unsigned long nsecs_rem = duration % 1000;
+	/* log10(ULONG_MAX) + '\0' */
+	char msecs_str[21];
+	char nsecs_str[5];
+	int len;
+	int i;
+
+	sprintf(msecs_str, "%lu", usecs);
+
+	/* Print msecs */
+	len = printf("%lu", usecs);
+
+	/* Print nsecs (we don't want to exceed 7 numbers) */
+	if (len < 7) {
+		snprintf(nsecs_str, 8 - len, "%03lu", nsecs_rem);
+		len += printf(".%s", nsecs_str);
+	}
+
+	printf(" us ");
+
+	/* Print remaining spaces to fit the row's width */
+	for (i = len; i < 7; i++)
+		printf(" ");
+
+	printf("|  ");
+}
+
+static void
+print_graph_entry_leaf(struct event *event, void *data, struct record *ret_rec)
+{
+	unsigned long long rettime, calltime;
+	unsigned long long duration, depth;
+	unsigned long long val;
+	struct format_field *field;
+	struct func_map *func;
+	struct event *ret_event;
+	int type;
+	int i;
+
+	type = parse_common_type(ret_rec->data);
+	ret_event = find_event(type);
+
+	field = find_field(ret_event, "rettime");
+	if (!field)
+		die("can't find rettime in return graph");
+	rettime = read_size(ret_rec->data + field->offset, field->size);
+
+	field = find_field(ret_event, "calltime");
+	if (!field)
+		die("can't find rettime in return graph");
+	calltime = read_size(ret_rec->data + field->offset, field->size);
+
+	duration = rettime - calltime;
+
+	/* Overhead */
+	print_graph_overhead(duration);
+
+	/* Duration */
+	print_graph_duration(duration);
+
+	field = find_field(event, "depth");
+	if (!field)
+		die("can't find depth in entry graph");
+	depth = read_size(data + field->offset, field->size);
+
+	/* Function */
+	for (i = 0; i < (int)(depth * TRACE_GRAPH_INDENT); i++)
+		printf(" ");
+
+	field = find_field(event, "func");
+	if (!field)
+		die("can't find func in entry graph");
+	val = read_size(data + field->offset, field->size);
+	func = find_func(val);
+
+	if (func)
+		printf("%s();", func->func);
+	else
+		printf("%llx();", val);
+}
+
+static void print_graph_nested(struct event *event, void *data)
+{
+	struct format_field *field;
+	unsigned long long depth;
+	unsigned long long val;
+	struct func_map *func;
+	int i;
+
+	/* No overhead */
+	print_graph_overhead(-1);
+
+	/* No time */
+	printf("           |  ");
+
+	field = find_field(event, "depth");
+	if (!field)
+		die("can't find depth in entry graph");
+	depth = read_size(data + field->offset, field->size);
+
+	/* Function */
+	for (i = 0; i < (int)(depth * TRACE_GRAPH_INDENT); i++)
+		printf(" ");
+
+	field = find_field(event, "func");
+	if (!field)
+		die("can't find func in entry graph");
+	val = read_size(data + field->offset, field->size);
+	func = find_func(val);
+
+	if (func)
+		printf("%s() {", func->func);
+	else
+		printf("%llx() {", val);
+}
+
+static void
+pretty_print_func_ent(void *data, int size, struct event *event,
+		      int cpu, int pid, const char *comm,
+		      unsigned long secs, unsigned long usecs)
+{
+	struct format_field *field;
+	struct record *rec;
+	void *copy_data;
+	unsigned long val;
+
+	printf("%5lu.%06lu |  ", secs, usecs);
+
+	print_graph_cpu(cpu);
+	print_graph_proc(pid, comm);
+
+	printf(" | ");
+
+	field = find_field(event, "func");
+	if (!field)
+		die("function entry does not have func field");
+
+	val = read_size(data + field->offset, field->size);
+
+	/*
+	 * peek_data may unmap the data pointer. Copy it first.
+	 */
+	copy_data = malloc_or_die(size);
+	memcpy(copy_data, data, size);
+	data = copy_data;
+
+	rec = trace_peek_data(cpu);
+	if (rec) {
+		rec = get_return_for_leaf(cpu, pid, val, rec);
+		if (rec) {
+			print_graph_entry_leaf(event, data, rec);
+			goto out_free;
+		}
+	}
+	print_graph_nested(event, data);
+out_free:
+	free(data);
+}
+
+static void
+pretty_print_func_ret(void *data, int size __unused, struct event *event,
+		      int cpu, int pid, const char *comm,
+		      unsigned long secs, unsigned long usecs)
+{
+	unsigned long long rettime, calltime;
+	unsigned long long duration, depth;
+	struct format_field *field;
+	int i;
+
+	printf("%5lu.%06lu |  ", secs, usecs);
+
+	print_graph_cpu(cpu);
+	print_graph_proc(pid, comm);
+
+	printf(" | ");
+
+	field = find_field(event, "rettime");
+	if (!field)
+		die("can't find rettime in return graph");
+	rettime = read_size(data + field->offset, field->size);
+
+	field = find_field(event, "calltime");
+	if (!field)
+		die("can't find calltime in return graph");
+	calltime = read_size(data + field->offset, field->size);
+
+	duration = rettime - calltime;
+
+	/* Overhead */
+	print_graph_overhead(duration);
+
+	/* Duration */
+	print_graph_duration(duration);
+
+	field = find_field(event, "depth");
+	if (!field)
+		die("can't find depth in entry graph");
+	depth = read_size(data + field->offset, field->size);
+
+	/* Function */
+	for (i = 0; i < (int)(depth * TRACE_GRAPH_INDENT); i++)
+		printf(" ");
+
+	printf("}");
+}
+
+static void
+pretty_print_func_graph(void *data, int size, struct event *event,
+			int cpu, int pid, const char *comm,
+			unsigned long secs, unsigned long usecs)
+{
+	if (event->flags & EVENT_FL_ISFUNCENT)
+		pretty_print_func_ent(data, size, event,
+				      cpu, pid, comm, secs, usecs);
+	else if (event->flags & EVENT_FL_ISFUNCRET)
+		pretty_print_func_ret(data, size, event,
+				      cpu, pid, comm, secs, usecs);
+	printf("\n");
+}
+
+void print_event(int cpu, void *data, int size, unsigned long long nsecs,
+		  char *comm)
+{
+	struct event *event;
+	unsigned long secs;
+	unsigned long usecs;
+	int type;
+	int pid;
+
+	secs = nsecs / NSECS_PER_SEC;
+	nsecs -= secs * NSECS_PER_SEC;
+	usecs = nsecs / NSECS_PER_USEC;
+
+	type = parse_common_type(data);
+
+	event = find_event(type);
+	if (!event)
+		die("ug! no event found for type %d", type);
+
+	pid = parse_common_pid(data);
+
+	if (event->flags & (EVENT_FL_ISFUNCENT | EVENT_FL_ISFUNCRET))
+		return pretty_print_func_graph(data, size, event, cpu,
+					       pid, comm, secs, usecs);
+
+	printf("%16s-%-5d [%03d] %5lu.%09Lu: %s: ",
+	       comm, pid,  cpu,
+	       secs, nsecs, event->name);
+
+	pretty_print(data, size, event);
+	printf("\n");
+}
+
+static void print_fields(struct print_flag_sym *field)
+{
+	printf("{ %s, %s }", field->value, field->str);
+	if (field->next) {
+		printf(", ");
+		print_fields(field->next);
+	}
+}
+
+static void print_args(struct print_arg *args)
+{
+	int print_paren = 1;
+
+	switch (args->type) {
+	case PRINT_NULL:
+		printf("null");
+		break;
+	case PRINT_ATOM:
+		printf("%s", args->atom.atom);
+		break;
+	case PRINT_FIELD:
+		printf("REC->%s", args->field.name);
+		break;
+	case PRINT_FLAGS:
+		printf("__print_flags(");
+		print_args(args->flags.field);
+		printf(", %s, ", args->flags.delim);
+		print_fields(args->flags.flags);
+		printf(")");
+		break;
+	case PRINT_SYMBOL:
+		printf("__print_symbolic(");
+		print_args(args->symbol.field);
+		printf(", ");
+		print_fields(args->symbol.symbols);
+		printf(")");
+		break;
+	case PRINT_STRING:
+		printf("__get_str(%s)", args->string.string);
+		break;
+	case PRINT_TYPE:
+		printf("(%s)", args->typecast.type);
+		print_args(args->typecast.item);
+		break;
+	case PRINT_OP:
+		if (strcmp(args->op.op, ":") == 0)
+			print_paren = 0;
+		if (print_paren)
+			printf("(");
+		print_args(args->op.left);
+		printf(" %s ", args->op.op);
+		print_args(args->op.right);
+		if (print_paren)
+			printf(")");
+		break;
+	default:
+		/* we should warn... */
+		return;
+	}
+	if (args->next) {
+		printf("\n");
+		print_args(args->next);
+	}
+}
+
+static void parse_header_field(char *type,
+			       int *offset, int *size)
+{
+	char *token;
+
+	if (read_expected(EVENT_ITEM, (char *)"field") < 0)
+		return;
+	if (read_expected(EVENT_OP, (char *)":") < 0)
+		return;
+	/* type */
+	if (read_expect_type(EVENT_ITEM, &token) < 0)
+		return;
+	free_token(token);
+
+	if (read_expected(EVENT_ITEM, type) < 0)
+		return;
+	if (read_expected(EVENT_OP, (char *)";") < 0)
+		return;
+	if (read_expected(EVENT_ITEM, (char *)"offset") < 0)
+		return;
+	if (read_expected(EVENT_OP, (char *)":") < 0)
+		return;
+	if (read_expect_type(EVENT_ITEM, &token) < 0)
+		return;
+	*offset = atoi(token);
+	free_token(token);
+	if (read_expected(EVENT_OP, (char *)";") < 0)
+		return;
+	if (read_expected(EVENT_ITEM, (char *)"size") < 0)
+		return;
+	if (read_expected(EVENT_OP, (char *)":") < 0)
+		return;
+	if (read_expect_type(EVENT_ITEM, &token) < 0)
+		return;
+	*size = atoi(token);
+	free_token(token);
+	if (read_expected(EVENT_OP, (char *)";") < 0)
+		return;
+	if (read_expect_type(EVENT_NEWLINE, &token) < 0)
+		return;
+	free_token(token);
+}
+
+int parse_header_page(char *buf, unsigned long size)
+{
+	init_input_buf(buf, size);
+
+	parse_header_field((char *)"timestamp", &header_page_ts_offset,
+			   &header_page_ts_size);
+	parse_header_field((char *)"commit", &header_page_size_offset,
+			   &header_page_size_size);
+	parse_header_field((char *)"data", &header_page_data_offset,
+			   &header_page_data_size);
+
+	return 0;
+}
+
+int parse_ftrace_file(char *buf, unsigned long size)
+{
+	struct format_field *field;
+	struct print_arg *arg, **list;
+	struct event *event;
+	int ret;
+
+	init_input_buf(buf, size);
+
+	event = alloc_event();
+	if (!event)
+		return -ENOMEM;
+
+	event->flags |= EVENT_FL_ISFTRACE;
+
+	event->name = event_read_name();
+	if (!event->name)
+		die("failed to read ftrace event name");
+
+	if (strcmp(event->name, "function") == 0)
+		event->flags |= EVENT_FL_ISFUNC;
+
+	else if (strcmp(event->name, "funcgraph_entry") == 0)
+		event->flags |= EVENT_FL_ISFUNCENT;
+
+	else if (strcmp(event->name, "funcgraph_exit") == 0)
+		event->flags |= EVENT_FL_ISFUNCRET;
+
+	else if (strcmp(event->name, "bprint") == 0)
+		event->flags |= EVENT_FL_ISBPRINT;
+
+	event->id = event_read_id();
+	if (event->id < 0)
+		die("failed to read ftrace event id");
+
+	add_event(event);
+
+	ret = event_read_format(event);
+	if (ret < 0)
+		die("failed to read ftrace event format");
+
+	ret = event_read_print(event);
+	if (ret < 0)
+		die("failed to read ftrace event print fmt");
+
+	/*
+	 * The arguments for ftrace files are parsed by the fields.
+	 * Set up the fields as their arguments.
+	 */
+	list = &event->print_fmt.args;
+	for (field = event->format.fields; field; field = field->next) {
+		arg = malloc_or_die(sizeof(*arg));
+		memset(arg, 0, sizeof(*arg));
+		*list = arg;
+		list = &arg->next;
+		arg->type = PRINT_FIELD;
+		arg->field.name = field->name;
+		arg->field.field = field;
+	}
+	return 0;
+}
+
+int parse_event_file(char *buf, unsigned long size, char *system__unused __unused)
+{
+	struct event *event;
+	int ret;
+
+	init_input_buf(buf, size);
+
+	event = alloc_event();
+	if (!event)
+		return -ENOMEM;
+
+	event->name = event_read_name();
+	if (!event->name)
+		die("failed to read event name");
+
+	event->id = event_read_id();
+	if (event->id < 0)
+		die("failed to read event id");
+
+	ret = event_read_format(event);
+	if (ret < 0)
+		die("failed to read event format");
+
+	ret = event_read_print(event);
+	if (ret < 0)
+		die("failed to read event print fmt");
+
+#define PRINT_ARGS 0
+	if (PRINT_ARGS && event->print_fmt.args)
+		print_args(event->print_fmt.args);
+
+	add_event(event);
+	return 0;
+}
+
+void parse_set_info(int nr_cpus, int long_sz)
+{
+	cpus = nr_cpus;
+	long_size = long_sz;
+}
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
new file mode 100644
index 0000000..a1217a1
--- /dev/null
+++ b/tools/perf/util/trace-event-read.c
@@ -0,0 +1,512 @@
+/*
+ * Copyright (C) 2009, Steven Rostedt <srostedt@redhat.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License (not later!)
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+#define _LARGEFILE64_SOURCE
+
+#include <dirent.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <getopt.h>
+#include <stdarg.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/wait.h>
+#include <sys/mman.h>
+#include <pthread.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <ctype.h>
+#include <errno.h>
+
+#include "../perf.h"
+#include "util.h"
+#include "trace-event.h"
+
+static int input_fd;
+
+static int read_page;
+
+int file_bigendian;
+int host_bigendian;
+static int long_size;
+
+static unsigned long	page_size;
+
+static int read_or_die(void *data, int size)
+{
+	int r;
+
+	r = read(input_fd, data, size);
+	if (r != size)
+		die("reading input file (size expected=%d received=%d)",
+		    size, r);
+	return r;
+}
+
+static unsigned int read4(void)
+{
+	unsigned int data;
+
+	read_or_die(&data, 4);
+	return __data2host4(data);
+}
+
+static unsigned long long read8(void)
+{
+	unsigned long long data;
+
+	read_or_die(&data, 8);
+	return __data2host8(data);
+}
+
+static char *read_string(void)
+{
+	char buf[BUFSIZ];
+	char *str = NULL;
+	int size = 0;
+	int i;
+	int r;
+
+	for (;;) {
+		r = read(input_fd, buf, BUFSIZ);
+		if (r < 0)
+			die("reading input file");
+
+		if (!r)
+			die("no data");
+
+		for (i = 0; i < r; i++) {
+			if (!buf[i])
+				break;
+		}
+		if (i < r)
+			break;
+
+		if (str) {
+			size += BUFSIZ;
+			str = realloc(str, size);
+			if (!str)
+				die("malloc of size %d", size);
+			memcpy(str + (size - BUFSIZ), buf, BUFSIZ);
+		} else {
+			size = BUFSIZ;
+			str = malloc_or_die(size);
+			memcpy(str, buf, size);
+		}
+	}
+
+	/* trailing \0: */
+	i++;
+
+	/* move the file descriptor to the end of the string */
+	r = lseek(input_fd, -(r - i), SEEK_CUR);
+	if (r < 0)
+		die("lseek");
+
+	if (str) {
+		size += i;
+		str = realloc(str, size);
+		if (!str)
+			die("malloc of size %d", size);
+		memcpy(str + (size - i), buf, i);
+	} else {
+		size = i;
+		str = malloc_or_die(i);
+		memcpy(str, buf, i);
+	}
+
+	return str;
+}
+
+static void read_proc_kallsyms(void)
+{
+	unsigned int size;
+	char *buf;
+
+	size = read4();
+	if (!size)
+		return;
+
+	buf = malloc_or_die(size);
+	read_or_die(buf, size);
+
+	parse_proc_kallsyms(buf, size);
+
+	free(buf);
+}
+
+static void read_ftrace_printk(void)
+{
+	unsigned int size;
+	char *buf;
+
+	size = read4();
+	if (!size)
+		return;
+
+	buf = malloc_or_die(size);
+	read_or_die(buf, size);
+
+	parse_ftrace_printk(buf, size);
+
+	free(buf);
+}
+
+static void read_header_files(void)
+{
+	unsigned long long size;
+	char *header_page;
+	char *header_event;
+	char buf[BUFSIZ];
+
+	read_or_die(buf, 12);
+
+	if (memcmp(buf, "header_page", 12) != 0)
+		die("did not read header page");
+
+	size = read8();
+	header_page = malloc_or_die(size);
+	read_or_die(header_page, size);
+	parse_header_page(header_page, size);
+	free(header_page);
+
+	/*
+	 * The size field in the page is of type long,
+	 * use that instead, since it represents the kernel.
+	 */
+	long_size = header_page_size_size;
+
+	read_or_die(buf, 13);
+	if (memcmp(buf, "header_event", 13) != 0)
+		die("did not read header event");
+
+	size = read8();
+	header_event = malloc_or_die(size);
+	read_or_die(header_event, size);
+	free(header_event);
+}
+
+static void read_ftrace_file(unsigned long long size)
+{
+	char *buf;
+
+	buf = malloc_or_die(size);
+	read_or_die(buf, size);
+	parse_ftrace_file(buf, size);
+	free(buf);
+}
+
+static void read_event_file(char *sys, unsigned long long size)
+{
+	char *buf;
+
+	buf = malloc_or_die(size);
+	read_or_die(buf, size);
+	parse_event_file(buf, size, sys);
+	free(buf);
+}
+
+static void read_ftrace_files(void)
+{
+	unsigned long long size;
+	int count;
+	int i;
+
+	count = read4();
+
+	for (i = 0; i < count; i++) {
+		size = read8();
+		read_ftrace_file(size);
+	}
+}
+
+static void read_event_files(void)
+{
+	unsigned long long size;
+	char *sys;
+	int systems;
+	int count;
+	int i,x;
+
+	systems = read4();
+
+	for (i = 0; i < systems; i++) {
+		sys = read_string();
+
+		count = read4();
+		for (x=0; x < count; x++) {
+			size = read8();
+			read_event_file(sys, size);
+		}
+	}
+}
+
+struct cpu_data {
+	unsigned long long	offset;
+	unsigned long long	size;
+	unsigned long long	timestamp;
+	struct record		*next;
+	char			*page;
+	int			cpu;
+	int			index;
+	int			page_size;
+};
+
+static struct cpu_data *cpu_data;
+
+static void update_cpu_data_index(int cpu)
+{
+	cpu_data[cpu].offset += page_size;
+	cpu_data[cpu].size -= page_size;
+	cpu_data[cpu].index = 0;
+}
+
+static void get_next_page(int cpu)
+{
+	off64_t save_seek;
+	off64_t ret;
+
+	if (!cpu_data[cpu].page)
+		return;
+
+	if (read_page) {
+		if (cpu_data[cpu].size <= page_size) {
+			free(cpu_data[cpu].page);
+			cpu_data[cpu].page = NULL;
+			return;
+		}
+
+		update_cpu_data_index(cpu);
+
+		/* other parts of the code may expect the pointer to not move */
+		save_seek = lseek64(input_fd, 0, SEEK_CUR);
+
+		ret = lseek64(input_fd, cpu_data[cpu].offset, SEEK_SET);
+		if (ret < 0)
+			die("failed to lseek");
+		ret = read(input_fd, cpu_data[cpu].page, page_size);
+		if (ret < 0)
+			die("failed to read page");
+
+		/* reset the file pointer back */
+		lseek64(input_fd, save_seek, SEEK_SET);
+
+		return;
+	}
+
+	munmap(cpu_data[cpu].page, page_size);
+	cpu_data[cpu].page = NULL;
+
+	if (cpu_data[cpu].size <= page_size)
+		return;
+
+	update_cpu_data_index(cpu);
+
+	cpu_data[cpu].page = mmap(NULL, page_size, PROT_READ, MAP_PRIVATE,
+				  input_fd, cpu_data[cpu].offset);
+	if (cpu_data[cpu].page == MAP_FAILED)
+		die("failed to mmap cpu %d at offset 0x%llx",
+		    cpu, cpu_data[cpu].offset);
+}
+
+static unsigned int type_len4host(unsigned int type_len_ts)
+{
+	if (file_bigendian)
+		return (type_len_ts >> 27) & ((1 << 5) - 1);
+	else
+		return type_len_ts & ((1 << 5) - 1);
+}
+
+static unsigned int ts4host(unsigned int type_len_ts)
+{
+	if (file_bigendian)
+		return type_len_ts & ((1 << 27) - 1);
+	else
+		return type_len_ts >> 5;
+}
+
+static int calc_index(void *ptr, int cpu)
+{
+	return (unsigned long)ptr - (unsigned long)cpu_data[cpu].page;
+}
+
+struct record *trace_peek_data(int cpu)
+{
+	struct record *data;
+	void *page = cpu_data[cpu].page;
+	int idx = cpu_data[cpu].index;
+	void *ptr = page + idx;
+	unsigned long long extend;
+	unsigned int type_len_ts;
+	unsigned int type_len;
+	unsigned int delta;
+	unsigned int length = 0;
+
+	if (cpu_data[cpu].next)
+		return cpu_data[cpu].next;
+
+	if (!page)
+		return NULL;
+
+	if (!idx) {
+		/* FIXME: handle header page */
+		if (header_page_ts_size != 8)
+			die("expected a long long type for timestamp");
+		cpu_data[cpu].timestamp = data2host8(ptr);
+		ptr += 8;
+		switch (header_page_size_size) {
+		case 4:
+			cpu_data[cpu].page_size = data2host4(ptr);
+			ptr += 4;
+			break;
+		case 8:
+			cpu_data[cpu].page_size = data2host8(ptr);
+			ptr += 8;
+			break;
+		default:
+			die("bad long size");
+		}
+		ptr = cpu_data[cpu].page + header_page_data_offset;
+	}
+
+read_again:
+	idx = calc_index(ptr, cpu);
+
+	if (idx >= cpu_data[cpu].page_size) {
+		get_next_page(cpu);
+		return trace_peek_data(cpu);
+	}
+
+	type_len_ts = data2host4(ptr);
+	ptr += 4;
+
+	type_len = type_len4host(type_len_ts);
+	delta = ts4host(type_len_ts);
+
+	switch (type_len) {
+	case RINGBUF_TYPE_PADDING:
+		if (!delta)
+			die("error, hit unexpected end of page");
+		length = data2host4(ptr);
+		ptr += 4;
+		length *= 4;
+		ptr += length;
+		goto read_again;
+
+	case RINGBUF_TYPE_TIME_EXTEND:
+		extend = data2host4(ptr);
+		ptr += 4;
+		extend <<= TS_SHIFT;
+		extend += delta;
+		cpu_data[cpu].timestamp += extend;
+		goto read_again;
+
+	case RINGBUF_TYPE_TIME_STAMP:
+		ptr += 12;
+		break;
+	case 0:
+		length = data2host4(ptr);
+		ptr += 4;
+		die("here! length=%d", length);
+		break;
+	default:
+		length = type_len * 4;
+		break;
+	}
+
+	cpu_data[cpu].timestamp += delta;
+
+	data = malloc_or_die(sizeof(*data));
+	memset(data, 0, sizeof(*data));
+
+	data->ts = cpu_data[cpu].timestamp;
+	data->size = length;
+	data->data = ptr;
+	ptr += length;
+
+	cpu_data[cpu].index = calc_index(ptr, cpu);
+	cpu_data[cpu].next = data;
+
+	return data;
+}
+
+struct record *trace_read_data(int cpu)
+{
+	struct record *data;
+
+	data = trace_peek_data(cpu);
+	cpu_data[cpu].next = NULL;
+
+	return data;
+}
+
+void trace_report (void)
+{
+	const char *input_file = "trace.info";
+	char buf[BUFSIZ];
+	char test[] = { 23, 8, 68 };
+	char *version;
+	int show_funcs = 0;
+	int show_printk = 0;
+
+	input_fd = open(input_file, O_RDONLY);
+	if (input_fd < 0)
+		die("opening '%s'\n", input_file);
+
+	read_or_die(buf, 3);
+	if (memcmp(buf, test, 3) != 0)
+		die("not an trace data file");
+
+	read_or_die(buf, 7);
+	if (memcmp(buf, "tracing", 7) != 0)
+		die("not a trace file (missing tracing)");
+
+	version = read_string();
+	printf("version = %s\n", version);
+	free(version);
+
+	read_or_die(buf, 1);
+	file_bigendian = buf[0];
+	host_bigendian = bigendian();
+
+	read_or_die(buf, 1);
+	long_size = buf[0];
+
+	page_size = read4();
+
+	read_header_files();
+
+	read_ftrace_files();
+	read_event_files();
+	read_proc_kallsyms();
+	read_ftrace_printk();
+
+	if (show_funcs) {
+		print_funcs();
+		return;
+	}
+	if (show_printk) {
+		print_printk();
+		return;
+	}
+
+	return;
+}
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
new file mode 100644
index 0000000..420294a
--- /dev/null
+++ b/tools/perf/util/trace-event.h
@@ -0,0 +1,240 @@
+#ifndef _TRACE_EVENTS_H
+#define _TRACE_EVENTS_H
+
+#include "parse-events.h"
+
+#define __unused __attribute__((unused))
+
+
+#ifndef PAGE_MASK
+#define PAGE_MASK (page_size - 1)
+#endif
+
+enum {
+	RINGBUF_TYPE_PADDING		= 29,
+	RINGBUF_TYPE_TIME_EXTEND	= 30,
+	RINGBUF_TYPE_TIME_STAMP		= 31,
+};
+
+#ifndef TS_SHIFT
+#define TS_SHIFT		27
+#endif
+
+#define NSECS_PER_SEC		1000000000ULL
+#define NSECS_PER_USEC		1000ULL
+
+enum format_flags {
+	FIELD_IS_ARRAY		= 1,
+	FIELD_IS_POINTER	= 2,
+};
+
+struct format_field {
+	struct format_field	*next;
+	char			*type;
+	char			*name;
+	int			offset;
+	int			size;
+	unsigned long		flags;
+};
+
+struct format {
+	int			nr_common;
+	int			nr_fields;
+	struct format_field	*common_fields;
+	struct format_field	*fields;
+};
+
+struct print_arg_atom {
+	char			*atom;
+};
+
+struct print_arg_string {
+	char			*string;
+	int			offset;
+};
+
+struct print_arg_field {
+	char			*name;
+	struct format_field	*field;
+};
+
+struct print_flag_sym {
+	struct print_flag_sym	*next;
+	char			*value;
+	char			*str;
+};
+
+struct print_arg_typecast {
+	char 			*type;
+	struct print_arg	*item;
+};
+
+struct print_arg_flags {
+	struct print_arg	*field;
+	char			*delim;
+	struct print_flag_sym	*flags;
+};
+
+struct print_arg_symbol {
+	struct print_arg	*field;
+	struct print_flag_sym	*symbols;
+};
+
+struct print_arg;
+
+struct print_arg_op {
+	char			*op;
+	int			prio;
+	struct print_arg	*left;
+	struct print_arg	*right;
+};
+
+struct print_arg_func {
+	char			*name;
+	struct print_arg	*args;
+};
+
+enum print_arg_type {
+	PRINT_NULL,
+	PRINT_ATOM,
+	PRINT_FIELD,
+	PRINT_FLAGS,
+	PRINT_SYMBOL,
+	PRINT_TYPE,
+	PRINT_STRING,
+	PRINT_OP,
+};
+
+struct print_arg {
+	struct print_arg		*next;
+	enum print_arg_type		type;
+	union {
+		struct print_arg_atom		atom;
+		struct print_arg_field		field;
+		struct print_arg_typecast	typecast;
+		struct print_arg_flags		flags;
+		struct print_arg_symbol		symbol;
+		struct print_arg_func		func;
+		struct print_arg_string		string;
+		struct print_arg_op		op;
+	};
+};
+
+struct print_fmt {
+	char			*format;
+	struct print_arg	*args;
+};
+
+struct event {
+	struct event		*next;
+	char			*name;
+	int			id;
+	int			flags;
+	struct format		format;
+	struct print_fmt	print_fmt;
+};
+
+enum {
+	EVENT_FL_ISFTRACE	= 1,
+	EVENT_FL_ISPRINT	= 2,
+	EVENT_FL_ISBPRINT	= 4,
+	EVENT_FL_ISFUNC		= 8,
+	EVENT_FL_ISFUNCENT	= 16,
+	EVENT_FL_ISFUNCRET	= 32,
+};
+
+struct record {
+	unsigned long long ts;
+	int size;
+	void *data;
+};
+
+struct record *trace_peek_data(int cpu);
+struct record *trace_read_data(int cpu);
+
+void parse_set_info(int nr_cpus, int long_sz);
+
+void trace_report(void);
+
+void *malloc_or_die(unsigned int size);
+
+void parse_cmdlines(char *file, int size);
+void parse_proc_kallsyms(char *file, unsigned int size);
+void parse_ftrace_printk(char *file, unsigned int size);
+
+void print_funcs(void);
+void print_printk(void);
+
+int parse_ftrace_file(char *buf, unsigned long size);
+int parse_event_file(char *buf, unsigned long size, char *system);
+void print_event(int cpu, void *data, int size, unsigned long long nsecs,
+		  char *comm);
+
+extern int file_bigendian;
+extern int host_bigendian;
+
+int bigendian(void);
+
+static inline unsigned short __data2host2(unsigned short data)
+{
+	unsigned short swap;
+
+	if (host_bigendian == file_bigendian)
+		return data;
+
+	swap = ((data & 0xffULL) << 8) |
+		((data & (0xffULL << 8)) >> 8);
+
+	return swap;
+}
+
+static inline unsigned int __data2host4(unsigned int data)
+{
+	unsigned int swap;
+
+	if (host_bigendian == file_bigendian)
+		return data;
+
+	swap = ((data & 0xffULL) << 24) |
+		((data & (0xffULL << 8)) << 8) |
+		((data & (0xffULL << 16)) >> 8) |
+		((data & (0xffULL << 24)) >> 24);
+
+	return swap;
+}
+
+static inline unsigned long long __data2host8(unsigned long long data)
+{
+	unsigned long long swap;
+
+	if (host_bigendian == file_bigendian)
+		return data;
+
+	swap = ((data & 0xffULL) << 56) |
+		((data & (0xffULL << 8)) << 40) |
+		((data & (0xffULL << 16)) << 24) |
+		((data & (0xffULL << 24)) << 8) |
+		((data & (0xffULL << 32)) >> 8) |
+		((data & (0xffULL << 40)) >> 24) |
+		((data & (0xffULL << 48)) >> 40) |
+		((data & (0xffULL << 56)) >> 56);
+
+	return swap;
+}
+
+#define data2host2(ptr)		__data2host2(*(unsigned short *)ptr)
+#define data2host4(ptr)		__data2host4(*(unsigned int *)ptr)
+#define data2host8(ptr)		__data2host8(*(unsigned long long *)ptr)
+
+extern int header_page_ts_offset;
+extern int header_page_ts_size;
+extern int header_page_size_offset;
+extern int header_page_size_size;
+extern int header_page_data_offset;
+extern int header_page_data_size;
+
+int parse_header_page(char *buf, unsigned long size);
+
+void read_tracing_data(struct perf_counter_attr *pattrs, int nb_counters);
+
+#endif /* _TRACE_EVENTS_H */
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 68fe157..9de2329 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -39,10 +39,6 @@
 /* Approximation of the length of the decimal representation of this type. */
 #define decimal_length(x)	((int)(sizeof(x) * 2.56 + 0.5) + 1)
 
-#if !defined(__APPLE__) && !defined(__FreeBSD__)  && !defined(__USLC__) && !defined(_M_UNIX)
-#define _XOPEN_SOURCE 600 /* glibc2 and AIX 5.3L need 500, OpenBSD needs 600 for S_ISLNK() */
-#define _XOPEN_SOURCE_EXTENDED 1 /* AIX 5.3L needs this */
-#endif
 #define _ALL_SOURCE 1
 #define _GNU_SOURCE 1
 #define _BSD_SOURCE 1
@@ -83,6 +79,7 @@
 #include <inttypes.h>
 #include "../../../include/linux/magic.h"
 
+
 #ifndef NO_ICONV
 #include <iconv.h>
 #endif
@@ -310,6 +307,7 @@ static inline int has_extension(const char *filename, const char *ext)
 #undef isspace
 #undef isdigit
 #undef isalpha
+#undef isprint
 #undef isalnum
 #undef tolower
 #undef toupper
diff --git a/tools/perf/util/values.c b/tools/perf/util/values.c
new file mode 100644
index 0000000..1c15e39
--- /dev/null
+++ b/tools/perf/util/values.c
@@ -0,0 +1,230 @@
+#include <stdlib.h>
+
+#include "util.h"
+#include "values.h"
+
+void perf_read_values_init(struct perf_read_values *values)
+{
+	values->threads_max = 16;
+	values->pid = malloc(values->threads_max * sizeof(*values->pid));
+	values->tid = malloc(values->threads_max * sizeof(*values->tid));
+	values->value = malloc(values->threads_max * sizeof(*values->value));
+	if (!values->pid || !values->tid || !values->value)
+		die("failed to allocate read_values threads arrays");
+	values->threads = 0;
+
+	values->counters_max = 16;
+	values->counterrawid = malloc(values->counters_max
+				      * sizeof(*values->counterrawid));
+	values->countername = malloc(values->counters_max
+				     * sizeof(*values->countername));
+	if (!values->counterrawid || !values->countername)
+		die("failed to allocate read_values counters arrays");
+	values->counters = 0;
+}
+
+void perf_read_values_destroy(struct perf_read_values *values)
+{
+	int i;
+
+	if (!values->threads_max || !values->counters_max)
+		return;
+
+	for (i = 0; i < values->threads; i++)
+		free(values->value[i]);
+	free(values->pid);
+	free(values->tid);
+	free(values->counterrawid);
+	for (i = 0; i < values->counters; i++)
+		free(values->countername[i]);
+	free(values->countername);
+}
+
+static void perf_read_values__enlarge_threads(struct perf_read_values *values)
+{
+	values->threads_max *= 2;
+	values->pid = realloc(values->pid,
+			      values->threads_max * sizeof(*values->pid));
+	values->tid = realloc(values->tid,
+			      values->threads_max * sizeof(*values->tid));
+	values->value = realloc(values->value,
+				values->threads_max * sizeof(*values->value));
+	if (!values->pid || !values->tid || !values->value)
+		die("failed to enlarge read_values threads arrays");
+}
+
+static int perf_read_values__findnew_thread(struct perf_read_values *values,
+					    u32 pid, u32 tid)
+{
+	int i;
+
+	for (i = 0; i < values->threads; i++)
+		if (values->pid[i] == pid && values->tid[i] == tid)
+			return i;
+
+	if (values->threads == values->threads_max)
+		perf_read_values__enlarge_threads(values);
+
+	i = values->threads++;
+	values->pid[i] = pid;
+	values->tid[i] = tid;
+	values->value[i] = malloc(values->counters_max * sizeof(**values->value));
+	if (!values->value[i])
+		die("failed to allocate read_values counters array");
+
+	return i;
+}
+
+static void perf_read_values__enlarge_counters(struct perf_read_values *values)
+{
+	int i;
+
+	values->counters_max *= 2;
+	values->counterrawid = realloc(values->counterrawid,
+				       values->counters_max * sizeof(*values->counterrawid));
+	values->countername = realloc(values->countername,
+				      values->counters_max * sizeof(*values->countername));
+	if (!values->counterrawid || !values->countername)
+		die("failed to enlarge read_values counters arrays");
+
+	for (i = 0; i < values->threads; i++) {
+		values->value[i] = realloc(values->value[i],
+					   values->counters_max * sizeof(**values->value));
+		if (!values->value[i])
+			die("failed to enlarge read_values counters arrays");
+	}
+}
+
+static int perf_read_values__findnew_counter(struct perf_read_values *values,
+					     u64 rawid, const char *name)
+{
+	int i;
+
+	for (i = 0; i < values->counters; i++)
+		if (values->counterrawid[i] == rawid)
+			return i;
+
+	if (values->counters == values->counters_max)
+		perf_read_values__enlarge_counters(values);
+
+	i = values->counters++;
+	values->counterrawid[i] = rawid;
+	values->countername[i] = strdup(name);
+
+	return i;
+}
+
+void perf_read_values_add_value(struct perf_read_values *values,
+				u32 pid, u32 tid,
+				u64 rawid, const char *name, u64 value)
+{
+	int tindex, cindex;
+
+	tindex = perf_read_values__findnew_thread(values, pid, tid);
+	cindex = perf_read_values__findnew_counter(values, rawid, name);
+
+	values->value[tindex][cindex] = value;
+}
+
+static void perf_read_values__display_pretty(FILE *fp,
+					     struct perf_read_values *values)
+{
+	int i, j;
+	int pidwidth, tidwidth;
+	int *counterwidth;
+
+	counterwidth = malloc(values->counters * sizeof(*counterwidth));
+	if (!counterwidth)
+		die("failed to allocate counterwidth array");
+	tidwidth = 3;
+	pidwidth = 3;
+	for (j = 0; j < values->counters; j++)
+		counterwidth[j] = strlen(values->countername[j]);
+	for (i = 0; i < values->threads; i++) {
+		int width;
+
+		width = snprintf(NULL, 0, "%d", values->pid[i]);
+		if (width > pidwidth)
+			pidwidth = width;
+		width = snprintf(NULL, 0, "%d", values->tid[i]);
+		if (width > tidwidth)
+			tidwidth = width;
+		for (j = 0; j < values->counters; j++) {
+			width = snprintf(NULL, 0, "%Lu", values->value[i][j]);
+			if (width > counterwidth[j])
+				counterwidth[j] = width;
+		}
+	}
+
+	fprintf(fp, "# %*s  %*s", pidwidth, "PID", tidwidth, "TID");
+	for (j = 0; j < values->counters; j++)
+		fprintf(fp, "  %*s", counterwidth[j], values->countername[j]);
+	fprintf(fp, "\n");
+
+	for (i = 0; i < values->threads; i++) {
+		fprintf(fp, "  %*d  %*d", pidwidth, values->pid[i],
+			tidwidth, values->tid[i]);
+		for (j = 0; j < values->counters; j++)
+			fprintf(fp, "  %*Lu",
+				counterwidth[j], values->value[i][j]);
+		fprintf(fp, "\n");
+	}
+}
+
+static void perf_read_values__display_raw(FILE *fp,
+					  struct perf_read_values *values)
+{
+	int width, pidwidth, tidwidth, namewidth, rawwidth, countwidth;
+	int i, j;
+
+	tidwidth = 3; /* TID */
+	pidwidth = 3; /* PID */
+	namewidth = 4; /* "Name" */
+	rawwidth = 3; /* "Raw" */
+	countwidth = 5; /* "Count" */
+
+	for (i = 0; i < values->threads; i++) {
+		width = snprintf(NULL, 0, "%d", values->pid[i]);
+		if (width > pidwidth)
+			pidwidth = width;
+		width = snprintf(NULL, 0, "%d", values->tid[i]);
+		if (width > tidwidth)
+			tidwidth = width;
+	}
+	for (j = 0; j < values->counters; j++) {
+		width = strlen(values->countername[j]);
+		if (width > namewidth)
+			namewidth = width;
+		width = snprintf(NULL, 0, "%llx", values->counterrawid[j]);
+		if (width > rawwidth)
+			rawwidth = width;
+	}
+	for (i = 0; i < values->threads; i++) {
+		for (j = 0; j < values->counters; j++) {
+			width = snprintf(NULL, 0, "%Lu", values->value[i][j]);
+			if (width > countwidth)
+				countwidth = width;
+		}
+	}
+
+	fprintf(fp, "# %*s  %*s  %*s  %*s  %*s\n",
+		pidwidth, "PID", tidwidth, "TID",
+		namewidth, "Name", rawwidth, "Raw",
+		countwidth, "Count");
+	for (i = 0; i < values->threads; i++)
+		for (j = 0; j < values->counters; j++)
+			fprintf(fp, "  %*d  %*d  %*s  %*llx  %*Lu\n",
+				pidwidth, values->pid[i],
+				tidwidth, values->tid[i],
+				namewidth, values->countername[j],
+				rawwidth, values->counterrawid[j],
+				countwidth, values->value[i][j]);
+}
+
+void perf_read_values_display(FILE *fp, struct perf_read_values *values, int raw)
+{
+	if (raw)
+		perf_read_values__display_raw(fp, values);
+	else
+		perf_read_values__display_pretty(fp, values);
+}
diff --git a/tools/perf/util/values.h b/tools/perf/util/values.h
new file mode 100644
index 0000000..cadf8cf
--- /dev/null
+++ b/tools/perf/util/values.h
@@ -0,0 +1,27 @@
+#ifndef _PERF_VALUES_H
+#define _PERF_VALUES_H
+
+#include "types.h"
+
+struct perf_read_values {
+	int threads;
+	int threads_max;
+	u32 *pid, *tid;
+	int counters;
+	int counters_max;
+	u64 *counterrawid;
+	char **countername;
+	u64 **value;
+};
+
+void perf_read_values_init(struct perf_read_values *values);
+void perf_read_values_destroy(struct perf_read_values *values);
+
+void perf_read_values_add_value(struct perf_read_values *values,
+				u32 pid, u32 tid,
+				u64 rawid, const char *name, u64 value);
+
+void perf_read_values_display(FILE *fp, struct perf_read_values *values,
+			      int raw);
+
+#endif /* _PERF_VALUES_H */
