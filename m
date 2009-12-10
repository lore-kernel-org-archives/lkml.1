Return-Path: <linux-kernel-owner+w=401wt.eu-S1761613AbZLJT0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761613AbZLJT0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 14:26:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761554AbZLJT0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 14:26:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53839 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761454AbZLJT0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 14:26:18 -0500
Date: Thu, 10 Dec 2009 20:25:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf events updates
Message-ID: <20091210192549.GA18553@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf events git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

Fixes mostly, plus some late changes/cleanups.

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (3):
      perf buildid-list: Fix copy'n'paste help message
      perf symbols: dsos__read_build_ids() should read both user and kernel buildids
      perf symbols: perf_header__read_build_ids() offset'n'size should be u64

Arnd Bergmann (1):
      perf events: hw_breakpoints: Don't include asm/hw_breakpoint.h in user space

Cyrill Gorcunov (1):
      x86, perf events: Check if we have APIC enabled

Frederic Weisbecker (14):
      hw-breakpoints: Add two reserved fields for future extensions
      perf: Remove pointless union that wraps the hw breakpoint fields
      perf: Remove unused struct perf_event::event_callback
      hw-breakpoints: Drop callback and task parameters from modify helper
      hw-breakpoints: Use overflow handler instead of the event callback
      perf: Remove the "event" callback from perf events
      x86/perf: Exclude the debug stack from the callchains
      x86: Fixup wrong debug exception frame link in stacktraces
      x86: Fixup wrong irq frame link in stacktraces
      hw-breakpoints: Zeroe the breakpoint attrs on initialization
      hw-breakpoints: Fix task-bound breakpoint slot allocation
      hw-breakpoints: Modify breakpoints without unregistering them
      tracing/kprobes: Fix field creation's bad error handling
      perf sched: Add max delay time snapshot

Ingo Molnar (1):
      perf kmem: Fix unused argument build warning

Jean Delvare (1):
      x86, perf probe: Fix warning in test_get_len()

Juha Leppanen (1):
      perf probe: Fix strtailcmp() to compare s1and s2[0]

Julia Lawall (2):
      perf tools: Correct size computation in tracepoint_id_to_path()
      perf tools: Correct size given to memset

Li Zefan (2):
      perf kmem: Show usage if no option is specified
      perf tools: Align long options which have no short forms

Masami Hiramatsu (12):
      x86 insn: Delete empty or incomplete inat-tables.c
      perf probe: Fix event namelist to duplicate string
      perf probe: Check e_snprintf() format string
      perf probe: Use pr_debug for debug message
      perf probe: Change event list format
      perf probe: Change probe-added message more user-friendly
      perf probe: Fix add-probe command syntax without --add option
      perf probe: Remove event suffix number _0
      perf probe: Support vmlinux on cwd by default
      trace-kprobe: Support delete probe syntax
      perf probe: Support --del option
      perf probe: Update perf-probe document

Mike Frysinger (1):
      sched: Mark sched_clock() as notrace

OGAWA Hirofumi (4):
      perf timechart: Fix header handling
      perf: Make common SAMPLE_EVENT parser
      perf tools: Misc small fixes
      x86: Compile insn.c and inat.c only for KPROBES

Stephen Rothwell (1):
      perf: hw_breakpoints: Fix percpu namespace clash

Tom Zanussi (2):
      perf trace/scripting: Fix compile error when libperl not installed
      perf trace/scripting: Don't display 'scripting unsupported' msg unnecessarily

Ulrich Drepper (1):
      perf tools: Optimize parse_subsystem_tracepoint_event()

Xiao Guangrong (10):
      perf/sched: Fix 'perf sched trace'
      perf_event: Fix raw event processing
      perf_event: Fix __dsos__write_buildid_table()
      perf_event: Eliminate raw->size
      perf_event: Clean up __perf_event_init_context()
      perf_event: Allocate children's perf_event_ctxp at the right time
      perf_event: Cleanup for cpu_clock_perf_event_update()
      perf sched: Fix for getting task's execution time
      perf_event: Fix perf_swevent_hrtimer() variable initialization
      perf_event: Fix variable initialization in other codepaths


 arch/x86/Kconfig.debug                  |    4 +-
 arch/x86/kernel/cpu/perf_event.c        |   31 +++--
 arch/x86/kernel/dumpstack_64.c          |   33 +++++-
 arch/x86/kernel/entry_64.S              |    6 +-
 arch/x86/kernel/hw_breakpoint.c         |    5 +-
 arch/x86/kernel/ptrace.c                |   68 +++++-----
 arch/x86/lib/Makefile                   |    4 +-
 arch/x86/tools/test_get_len.c           |    2 +-
 include/linux/hw_breakpoint.h           |   40 +++----
 include/linux/perf_event.h              |   41 +++---
 include/linux/sched.h                   |    3 +-
 kernel/hw_breakpoint.c                  |  146 +++++++++++++---------
 kernel/perf_event.c                     |   75 ++++++------
 kernel/trace/trace_kprobe.c             |   41 +++++--
 kernel/trace/trace_ksym.c               |    5 +-
 samples/hw_breakpoint/data_breakpoint.c |    7 +-
 tools/perf/Documentation/perf-kmem.txt  |   13 +-
 tools/perf/Documentation/perf-probe.txt |   21 +++-
 tools/perf/builtin-buildid-list.c       |    2 +-
 tools/perf/builtin-kmem.c               |  123 ++++++++----------
 tools/perf/builtin-probe.c              |   80 +++++++++---
 tools/perf/builtin-report.c             |   39 +++---
 tools/perf/builtin-sched.c              |  212 ++++++++++++++-----------------
 tools/perf/builtin-timechart.c          |   56 +++------
 tools/perf/builtin-trace.c              |   48 ++-----
 tools/perf/util/data_map.c              |    4 +-
 tools/perf/util/data_map.h              |    2 +-
 tools/perf/util/event.c                 |   67 ++++++++++
 tools/perf/util/event.h                 |   17 +++-
 tools/perf/util/header.c                |    9 +-
 tools/perf/util/parse-events.c          |   17 +--
 tools/perf/util/parse-options.c         |    3 +
 tools/perf/util/probe-event.c           |  133 +++++++++++++++++--
 tools/perf/util/probe-event.h           |    1 +
 tools/perf/util/probe-finder.c          |    2 +-
 tools/perf/util/symbol.c                |    5 +-
 tools/perf/util/trace-event-parse.c     |    4 +-
 tools/perf/util/trace-event-perl.c      |   67 ++++++++--
 tools/perf/util/trace-event-perl.h      |    4 +
 tools/perf/util/trace-event-read.c      |    3 +-
 40 files changed, 878 insertions(+), 565 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 7d0b681..0e90929 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -187,8 +187,8 @@ config HAVE_MMIOTRACE_SUPPORT
 	def_bool y
 
 config X86_DECODER_SELFTEST
-     bool "x86 instruction decoder selftest"
-     depends on DEBUG_KERNEL
+	bool "x86 instruction decoder selftest"
+	depends on DEBUG_KERNEL && KPROBES
 	---help---
 	 Perform x86 instruction decoder selftests at build time.
 	 This option is useful for checking the sanity of x86 instruction
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index c1bbed1..18f05ec 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1632,6 +1632,7 @@ static void intel_pmu_drain_bts_buffer(struct cpu_hw_events *cpuc)
 
 	data.period	= event->hw.last_period;
 	data.addr	= 0;
+	data.raw	= NULL;
 	regs.ip		= 0;
 
 	/*
@@ -1749,6 +1750,7 @@ static int p6_pmu_handle_irq(struct pt_regs *regs)
 	u64 val;
 
 	data.addr = 0;
+	data.raw = NULL;
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -1794,6 +1796,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 	u64 ack, status;
 
 	data.addr = 0;
+	data.raw = NULL;
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -1857,6 +1860,7 @@ static int amd_pmu_handle_irq(struct pt_regs *regs)
 	u64 val;
 
 	data.addr = 0;
+	data.raw = NULL;
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -2062,12 +2066,6 @@ static __init int p6_pmu_init(void)
 
 	x86_pmu = p6_pmu;
 
-	if (!cpu_has_apic) {
-		pr_info("no APIC, boot with the \"lapic\" boot parameter to force-enable it.\n");
-		pr_info("no hardware sampling interrupt available.\n");
-		x86_pmu.apic = 0;
-	}
-
 	return 0;
 }
 
@@ -2159,6 +2157,16 @@ static __init int amd_pmu_init(void)
 	return 0;
 }
 
+static void __init pmu_check_apic(void)
+{
+	if (cpu_has_apic)
+		return;
+
+	x86_pmu.apic = 0;
+	pr_info("no APIC, boot with the \"lapic\" boot parameter to force-enable it.\n");
+	pr_info("no hardware sampling interrupt available.\n");
+}
+
 void __init init_hw_perf_events(void)
 {
 	int err;
@@ -2180,6 +2188,8 @@ void __init init_hw_perf_events(void)
 		return;
 	}
 
+	pmu_check_apic();
+
 	pr_cont("%s PMU driver.\n", x86_pmu.name);
 
 	if (x86_pmu.num_events > X86_PMC_MAX_GENERIC) {
@@ -2287,7 +2297,7 @@ void callchain_store(struct perf_callchain_entry *entry, u64 ip)
 
 static DEFINE_PER_CPU(struct perf_callchain_entry, pmc_irq_entry);
 static DEFINE_PER_CPU(struct perf_callchain_entry, pmc_nmi_entry);
-static DEFINE_PER_CPU(int, in_nmi_frame);
+static DEFINE_PER_CPU(int, in_ignored_frame);
 
 
 static void
@@ -2303,8 +2313,9 @@ static void backtrace_warning(void *data, char *msg)
 
 static int backtrace_stack(void *data, char *name)
 {
-	per_cpu(in_nmi_frame, smp_processor_id()) =
-			x86_is_stack_id(NMI_STACK, name);
+	per_cpu(in_ignored_frame, smp_processor_id()) =
+			x86_is_stack_id(NMI_STACK, name) ||
+			x86_is_stack_id(DEBUG_STACK, name);
 
 	return 0;
 }
@@ -2313,7 +2324,7 @@ static void backtrace_address(void *data, unsigned long addr, int reliable)
 {
 	struct perf_callchain_entry *entry = data;
 
-	if (per_cpu(in_nmi_frame, smp_processor_id()))
+	if (per_cpu(in_ignored_frame, smp_processor_id()))
 		return;
 
 	if (reliable)
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index a071e6b..004b8aa 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -101,6 +101,35 @@ static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
 	return NULL;
 }
 
+static inline int
+in_irq_stack(unsigned long *stack, unsigned long *irq_stack,
+	     unsigned long *irq_stack_end)
+{
+	return (stack >= irq_stack && stack < irq_stack_end);
+}
+
+/*
+ * We are returning from the irq stack and go to the previous one.
+ * If the previous stack is also in the irq stack, then bp in the first
+ * frame of the irq stack points to the previous, interrupted one.
+ * Otherwise we have another level of indirection: We first save
+ * the bp of the previous stack, then we switch the stack to the irq one
+ * and save a new bp that links to the previous one.
+ * (See save_args())
+ */
+static inline unsigned long
+fixup_bp_irq_link(unsigned long bp, unsigned long *stack,
+		  unsigned long *irq_stack, unsigned long *irq_stack_end)
+{
+#ifdef CONFIG_FRAME_POINTER
+	struct stack_frame *frame = (struct stack_frame *)bp;
+
+	if (!in_irq_stack(stack, irq_stack, irq_stack_end))
+		return (unsigned long)frame->next_frame;
+#endif
+	return bp;
+}
+
 /*
  * x86-64 can have up to three kernel stacks:
  * process stack
@@ -173,7 +202,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 			irq_stack = irq_stack_end -
 				(IRQ_STACK_SIZE - 64) / sizeof(*irq_stack);
 
-			if (stack >= irq_stack && stack < irq_stack_end) {
+			if (in_irq_stack(stack, irq_stack, irq_stack_end)) {
 				if (ops->stack(data, "IRQ") < 0)
 					break;
 				bp = print_context_stack(tinfo, stack, bp,
@@ -184,6 +213,8 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 				 * pointer (index -1 to end) in the IRQ stack:
 				 */
 				stack = (unsigned long *) (irq_stack_end[-1]);
+				bp = fixup_bp_irq_link(bp, stack, irq_stack,
+						       irq_stack_end);
 				irq_stack_end = NULL;
 				ops->stack(data, "EOI");
 				continue;
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 722df1b..0f08a0c 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1076,10 +1076,10 @@ ENTRY(\sym)
 	TRACE_IRQS_OFF
 	movq %rsp,%rdi		/* pt_regs pointer */
 	xorl %esi,%esi		/* no error code */
-	PER_CPU(init_tss, %rbp)
-	subq $EXCEPTION_STKSZ, TSS_ist + (\ist - 1) * 8(%rbp)
+	PER_CPU(init_tss, %r12)
+	subq $EXCEPTION_STKSZ, TSS_ist + (\ist - 1) * 8(%r12)
 	call \do_sym
-	addq $EXCEPTION_STKSZ, TSS_ist + (\ist - 1) * 8(%rbp)
+	addq $EXCEPTION_STKSZ, TSS_ist + (\ist - 1) * 8(%r12)
 	jmp paranoid_exit	/* %ebx: no swapgs flag */
 	CFI_ENDPROC
 END(\sym)
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index d42f65a..05d5fec 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -362,8 +362,7 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp,
 		return ret;
 	}
 
-	if (bp->callback)
-		ret = arch_store_info(bp);
+	ret = arch_store_info(bp);
 
 	if (ret < 0)
 		return ret;
@@ -519,7 +518,7 @@ static int __kprobes hw_breakpoint_handler(struct die_args *args)
 			break;
 		}
 
-		(bp->callback)(bp, args->regs);
+		perf_bp_event(bp, args->regs);
 
 		rcu_read_unlock();
 	}
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 04d182a..7079dda 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -555,7 +555,9 @@ static int genregs_set(struct task_struct *target,
 	return ret;
 }
 
-static void ptrace_triggered(struct perf_event *bp, void *data)
+static void ptrace_triggered(struct perf_event *bp, int nmi,
+			     struct perf_sample_data *data,
+			     struct pt_regs *regs)
 {
 	int i;
 	struct thread_struct *thread = &(current->thread);
@@ -593,13 +595,13 @@ static unsigned long ptrace_get_dr7(struct perf_event *bp[])
 	return dr7;
 }
 
-static struct perf_event *
+static int
 ptrace_modify_breakpoint(struct perf_event *bp, int len, int type,
 			 struct task_struct *tsk, int disabled)
 {
 	int err;
 	int gen_len, gen_type;
-	DEFINE_BREAKPOINT_ATTR(attr);
+	struct perf_event_attr attr;
 
 	/*
 	 * We shoud have at least an inactive breakpoint at this
@@ -607,18 +609,18 @@ ptrace_modify_breakpoint(struct perf_event *bp, int len, int type,
 	 * written the address register first
 	 */
 	if (!bp)
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 
 	err = arch_bp_generic_fields(len, type, &gen_len, &gen_type);
 	if (err)
-		return ERR_PTR(err);
+		return err;
 
 	attr = bp->attr;
 	attr.bp_len = gen_len;
 	attr.bp_type = gen_type;
 	attr.disabled = disabled;
 
-	return modify_user_hw_breakpoint(bp, &attr, bp->callback, tsk);
+	return modify_user_hw_breakpoint(bp, &attr);
 }
 
 /*
@@ -656,28 +658,17 @@ restore:
 				if (!second_pass)
 					continue;
 
-				thread->ptrace_bps[i] = NULL;
-				bp = ptrace_modify_breakpoint(bp, len, type,
+				rc = ptrace_modify_breakpoint(bp, len, type,
 							      tsk, 1);
-				if (IS_ERR(bp)) {
-					rc = PTR_ERR(bp);
-					thread->ptrace_bps[i] = NULL;
+				if (rc)
 					break;
-				}
-				thread->ptrace_bps[i] = bp;
 			}
 			continue;
 		}
 
-		bp = ptrace_modify_breakpoint(bp, len, type, tsk, 0);
-
-		/* Incorrect bp, or we have a bug in bp API */
-		if (IS_ERR(bp)) {
-			rc = PTR_ERR(bp);
-			thread->ptrace_bps[i] = NULL;
+		rc = ptrace_modify_breakpoint(bp, len, type, tsk, 0);
+		if (rc)
 			break;
-		}
-		thread->ptrace_bps[i] = bp;
 	}
 	/*
 	 * Make a second pass to free the remaining unused breakpoints
@@ -721,9 +712,10 @@ static int ptrace_set_breakpoint_addr(struct task_struct *tsk, int nr,
 {
 	struct perf_event *bp;
 	struct thread_struct *t = &tsk->thread;
-	DEFINE_BREAKPOINT_ATTR(attr);
+	struct perf_event_attr attr;
 
 	if (!t->ptrace_bps[nr]) {
+		hw_breakpoint_init(&attr);
 		/*
 		 * Put stub len and type to register (reserve) an inactive but
 		 * correct bp
@@ -734,26 +726,32 @@ static int ptrace_set_breakpoint_addr(struct task_struct *tsk, int nr,
 		attr.disabled = 1;
 
 		bp = register_user_hw_breakpoint(&attr, ptrace_triggered, tsk);
+
+		/*
+		 * CHECKME: the previous code returned -EIO if the addr wasn't
+		 * a valid task virtual addr. The new one will return -EINVAL in
+		 *  this case.
+		 * -EINVAL may be what we want for in-kernel breakpoints users,
+		 * but -EIO looks better for ptrace, since we refuse a register
+		 * writing for the user. And anyway this is the previous
+		 * behaviour.
+		 */
+		if (IS_ERR(bp))
+			return PTR_ERR(bp);
+
+		t->ptrace_bps[nr] = bp;
 	} else {
+		int err;
+
 		bp = t->ptrace_bps[nr];
-		t->ptrace_bps[nr] = NULL;
 
 		attr = bp->attr;
 		attr.bp_addr = addr;
-		bp = modify_user_hw_breakpoint(bp, &attr, bp->callback, tsk);
+		err = modify_user_hw_breakpoint(bp, &attr);
+		if (err)
+			return err;
 	}
-	/*
-	 * CHECKME: the previous code returned -EIO if the addr wasn't a
-	 * valid task virtual addr. The new one will return -EINVAL in this
-	 * case.
-	 * -EINVAL may be what we want for in-kernel breakpoints users, but
-	 * -EIO looks better for ptrace, since we refuse a register writing
-	 * for the user. And anyway this is the previous behaviour.
-	 */
-	if (IS_ERR(bp))
-		return PTR_ERR(bp);
 
-	t->ptrace_bps[nr] = bp;
 
 	return 0;
 }
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index a2d6472..45b20e4 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -5,7 +5,7 @@
 inat_tables_script = $(srctree)/arch/x86/tools/gen-insn-attr-x86.awk
 inat_tables_maps = $(srctree)/arch/x86/lib/x86-opcode-map.txt
 quiet_cmd_inat_tables = GEN     $@
-      cmd_inat_tables = $(AWK) -f $(inat_tables_script) $(inat_tables_maps) > $@
+      cmd_inat_tables = $(AWK) -f $(inat_tables_script) $(inat_tables_maps) > $@ || rm -f $@
 
 $(obj)/inat-tables.c: $(inat_tables_script) $(inat_tables_maps)
 	$(call cmd,inat_tables)
@@ -20,7 +20,7 @@ lib-y := delay.o
 lib-y += thunk_$(BITS).o
 lib-y += usercopy_$(BITS).o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
-lib-y += insn.o inat.o
+lib-$(CONFIG_KPROBES) += insn.o inat.o
 
 obj-y += msr-reg.o msr-reg-export.o
 
diff --git a/arch/x86/tools/test_get_len.c b/arch/x86/tools/test_get_len.c
index d8214dc..bee8d6a 100644
--- a/arch/x86/tools/test_get_len.c
+++ b/arch/x86/tools/test_get_len.c
@@ -113,7 +113,7 @@ int main(int argc, char **argv)
 	char line[BUFSIZE], sym[BUFSIZE] = "<unknown>";
 	unsigned char insn_buf[16];
 	struct insn insn;
-	int insns = 0, c;
+	int insns = 0;
 	int warnings = 0;
 
 	parse_args(argc, argv);
diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index a03daed..69f07a9 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -20,19 +20,18 @@ enum {
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 
-/* As it's for in-kernel or ptrace use, we want it to be pinned */
-#define DEFINE_BREAKPOINT_ATTR(name)	\
-struct perf_event_attr name = {		\
-	.type = PERF_TYPE_BREAKPOINT,	\
-	.size = sizeof(name),		\
-	.pinned = 1,			\
-};
-
 static inline void hw_breakpoint_init(struct perf_event_attr *attr)
 {
+	memset(attr, 0, sizeof(*attr));
+
 	attr->type = PERF_TYPE_BREAKPOINT;
 	attr->size = sizeof(*attr);
+	/*
+	 * As it's for in-kernel or ptrace use, we want it to be pinned
+	 * and to call its callback every hits.
+	 */
 	attr->pinned = 1;
+	attr->sample_period = 1;
 }
 
 static inline unsigned long hw_breakpoint_addr(struct perf_event *bp)
@@ -52,27 +51,24 @@ static inline int hw_breakpoint_len(struct perf_event *bp)
 
 extern struct perf_event *
 register_user_hw_breakpoint(struct perf_event_attr *attr,
-			    perf_callback_t triggered,
+			    perf_overflow_handler_t triggered,
 			    struct task_struct *tsk);
 
 /* FIXME: only change from the attr, and don't unregister */
-extern struct perf_event *
-modify_user_hw_breakpoint(struct perf_event *bp,
-			  struct perf_event_attr *attr,
-			  perf_callback_t triggered,
-			  struct task_struct *tsk);
+extern int
+modify_user_hw_breakpoint(struct perf_event *bp, struct perf_event_attr *attr);
 
 /*
  * Kernel breakpoints are not associated with any particular thread.
  */
 extern struct perf_event *
 register_wide_hw_breakpoint_cpu(struct perf_event_attr *attr,
-				perf_callback_t triggered,
+				perf_overflow_handler_t	triggered,
 				int cpu);
 
 extern struct perf_event **
 register_wide_hw_breakpoint(struct perf_event_attr *attr,
-			    perf_callback_t triggered);
+			    perf_overflow_handler_t triggered);
 
 extern int register_perf_hw_breakpoint(struct perf_event *bp);
 extern int __register_perf_hw_breakpoint(struct perf_event *bp);
@@ -93,20 +89,18 @@ static inline struct arch_hw_breakpoint *counter_arch_bp(struct perf_event *bp)
 
 static inline struct perf_event *
 register_user_hw_breakpoint(struct perf_event_attr *attr,
-			    perf_callback_t triggered,
+			    perf_overflow_handler_t triggered,
 			    struct task_struct *tsk)	{ return NULL; }
-static inline struct perf_event *
+static inline int
 modify_user_hw_breakpoint(struct perf_event *bp,
-			  struct perf_event_attr *attr,
-			  perf_callback_t triggered,
-			  struct task_struct *tsk)	{ return NULL; }
+			  struct perf_event_attr *attr)	{ return NULL; }
 static inline struct perf_event *
 register_wide_hw_breakpoint_cpu(struct perf_event_attr *attr,
-				perf_callback_t triggered,
+				perf_overflow_handler_t	 triggered,
 				int cpu)		{ return NULL; }
 static inline struct perf_event **
 register_wide_hw_breakpoint(struct perf_event_attr *attr,
-			    perf_callback_t triggered)	{ return NULL; }
+			    perf_overflow_handler_t triggered)	{ return NULL; }
 static inline int
 register_perf_hw_breakpoint(struct perf_event *bp)	{ return -ENOSYS; }
 static inline int
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 43adbd7..64a53f7 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -18,10 +18,6 @@
 #include <linux/ioctl.h>
 #include <asm/byteorder.h>
 
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
-#include <asm/hw_breakpoint.h>
-#endif
-
 /*
  * User-space ABI bits:
  */
@@ -215,12 +211,12 @@ struct perf_event_attr {
 		__u32		wakeup_watermark; /* bytes before wakeup   */
 	};
 
-	union {
-		struct { /* Hardware breakpoint info */
-			__u64		bp_addr;
-			__u32		bp_type;
-			__u32		bp_len;
-		};
+	struct { /* Hardware breakpoint info */
+		__u64		bp_addr;
+		__u32		bp_type;
+		__u32		bp_len;
+		__u64		__bp_reserved_1;
+		__u64		__bp_reserved_2;
 	};
 
 	__u32			__reserved_2;
@@ -451,6 +447,10 @@ enum perf_callchain_context {
 # include <asm/perf_event.h>
 #endif
 
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+#include <asm/hw_breakpoint.h>
+#endif
+
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/rculist.h>
@@ -565,10 +565,12 @@ struct perf_pending_entry {
 	void (*func)(struct perf_pending_entry *);
 };
 
-typedef void (*perf_callback_t)(struct perf_event *, void *);
-
 struct perf_sample_data;
 
+typedef void (*perf_overflow_handler_t)(struct perf_event *, int,
+					struct perf_sample_data *,
+					struct pt_regs *regs);
+
 /**
  * struct perf_event - performance event kernel representation:
  */
@@ -660,18 +662,12 @@ struct perf_event {
 	struct pid_namespace		*ns;
 	u64				id;
 
-	void (*overflow_handler)(struct perf_event *event,
-			int nmi, struct perf_sample_data *data,
-			struct pt_regs *regs);
+	perf_overflow_handler_t		overflow_handler;
 
 #ifdef CONFIG_EVENT_PROFILE
 	struct event_filter		*filter;
 #endif
 
-	perf_callback_t			callback;
-
-	perf_callback_t			event_callback;
-
 #endif /* CONFIG_PERF_EVENTS */
 };
 
@@ -781,7 +777,7 @@ extern struct perf_event *
 perf_event_create_kernel_counter(struct perf_event_attr *attr,
 				int cpu,
 				pid_t pid,
-				perf_callback_t callback);
+				perf_overflow_handler_t callback);
 extern u64 perf_event_read_value(struct perf_event *event,
 				 u64 *enabled, u64 *running);
 
@@ -876,6 +872,8 @@ extern void perf_output_copy(struct perf_output_handle *handle,
 			     const void *buf, unsigned int len);
 extern int perf_swevent_get_recursion_context(void);
 extern void perf_swevent_put_recursion_context(int rctx);
+extern void perf_event_enable(struct perf_event *event);
+extern void perf_event_disable(struct perf_event *event);
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *task, int cpu)		{ }
@@ -906,7 +904,8 @@ static inline void perf_event_fork(struct task_struct *tsk)		{ }
 static inline void perf_event_init(void)				{ }
 static inline int  perf_swevent_get_recursion_context(void)  { return -1; }
 static inline void perf_swevent_put_recursion_context(int rctx)		{ }
-
+static inline void perf_event_enable(struct perf_event *event)		{ }
+static inline void perf_event_disable(struct perf_event *event)		{ }
 #endif
 
 #define perf_output_put(handle, x) \
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 75e6e60..576d838 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1836,7 +1836,8 @@ static inline int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
 extern int sched_clock_stable;
 #endif
 
-extern unsigned long long sched_clock(void);
+/* ftrace calls sched_clock() directly */
+extern unsigned long long notrace sched_clock(void);
 
 extern void sched_clock_init(void);
 extern u64 sched_clock_cpu(int cpu);
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index cf5ee16..366eedf 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -52,7 +52,7 @@
 static DEFINE_PER_CPU(unsigned int, nr_cpu_bp_pinned);
 
 /* Number of pinned task breakpoints in a cpu */
-static DEFINE_PER_CPU(unsigned int, task_bp_pinned[HBP_NUM]);
+static DEFINE_PER_CPU(unsigned int, nr_task_bp_pinned[HBP_NUM]);
 
 /* Number of non-pinned cpu/task breakpoints in a cpu */
 static DEFINE_PER_CPU(unsigned int, nr_bp_flexible);
@@ -73,7 +73,7 @@ static DEFINE_MUTEX(nr_bp_mutex);
 static unsigned int max_task_bp_pinned(int cpu)
 {
 	int i;
-	unsigned int *tsk_pinned = per_cpu(task_bp_pinned, cpu);
+	unsigned int *tsk_pinned = per_cpu(nr_task_bp_pinned, cpu);
 
 	for (i = HBP_NUM -1; i >= 0; i--) {
 		if (tsk_pinned[i] > 0)
@@ -83,15 +83,51 @@ static unsigned int max_task_bp_pinned(int cpu)
 	return 0;
 }
 
+static int task_bp_pinned(struct task_struct *tsk)
+{
+	struct perf_event_context *ctx = tsk->perf_event_ctxp;
+	struct list_head *list;
+	struct perf_event *bp;
+	unsigned long flags;
+	int count = 0;
+
+	if (WARN_ONCE(!ctx, "No perf context for this task"))
+		return 0;
+
+	list = &ctx->event_list;
+
+	spin_lock_irqsave(&ctx->lock, flags);
+
+	/*
+	 * The current breakpoint counter is not included in the list
+	 * at the open() callback time
+	 */
+	list_for_each_entry(bp, list, event_entry) {
+		if (bp->attr.type == PERF_TYPE_BREAKPOINT)
+			count++;
+	}
+
+	spin_unlock_irqrestore(&ctx->lock, flags);
+
+	return count;
+}
+
 /*
  * Report the number of pinned/un-pinned breakpoints we have in
  * a given cpu (cpu > -1) or in all of them (cpu = -1).
  */
-static void fetch_bp_busy_slots(struct bp_busy_slots *slots, int cpu)
+static void
+fetch_bp_busy_slots(struct bp_busy_slots *slots, struct perf_event *bp)
 {
+	int cpu = bp->cpu;
+	struct task_struct *tsk = bp->ctx->task;
+
 	if (cpu >= 0) {
 		slots->pinned = per_cpu(nr_cpu_bp_pinned, cpu);
-		slots->pinned += max_task_bp_pinned(cpu);
+		if (!tsk)
+			slots->pinned += max_task_bp_pinned(cpu);
+		else
+			slots->pinned += task_bp_pinned(tsk);
 		slots->flexible = per_cpu(nr_bp_flexible, cpu);
 
 		return;
@@ -101,7 +137,10 @@ static void fetch_bp_busy_slots(struct bp_busy_slots *slots, int cpu)
 		unsigned int nr;
 
 		nr = per_cpu(nr_cpu_bp_pinned, cpu);
-		nr += max_task_bp_pinned(cpu);
+		if (!tsk)
+			nr += max_task_bp_pinned(cpu);
+		else
+			nr += task_bp_pinned(tsk);
 
 		if (nr > slots->pinned)
 			slots->pinned = nr;
@@ -118,35 +157,12 @@ static void fetch_bp_busy_slots(struct bp_busy_slots *slots, int cpu)
  */
 static void toggle_bp_task_slot(struct task_struct *tsk, int cpu, bool enable)
 {
-	int count = 0;
-	struct perf_event *bp;
-	struct perf_event_context *ctx = tsk->perf_event_ctxp;
 	unsigned int *tsk_pinned;
-	struct list_head *list;
-	unsigned long flags;
-
-	if (WARN_ONCE(!ctx, "No perf context for this task"))
-		return;
-
-	list = &ctx->event_list;
-
-	spin_lock_irqsave(&ctx->lock, flags);
-
-	/*
-	 * The current breakpoint counter is not included in the list
-	 * at the open() callback time
-	 */
-	list_for_each_entry(bp, list, event_entry) {
-		if (bp->attr.type == PERF_TYPE_BREAKPOINT)
-			count++;
-	}
+	int count = 0;
 
-	spin_unlock_irqrestore(&ctx->lock, flags);
+	count = task_bp_pinned(tsk);
 
-	if (WARN_ONCE(count < 0, "No breakpoint counter found in the counter list"))
-		return;
-
-	tsk_pinned = per_cpu(task_bp_pinned, cpu);
+	tsk_pinned = per_cpu(nr_task_bp_pinned, cpu);
 	if (enable) {
 		tsk_pinned[count]++;
 		if (count > 0)
@@ -193,7 +209,7 @@ static void toggle_bp_slot(struct perf_event *bp, bool enable)
  *   - If attached to a single cpu, check:
  *
  *       (per_cpu(nr_bp_flexible, cpu) || (per_cpu(nr_cpu_bp_pinned, cpu)
- *           + max(per_cpu(task_bp_pinned, cpu)))) < HBP_NUM
+ *           + max(per_cpu(nr_task_bp_pinned, cpu)))) < HBP_NUM
  *
  *       -> If there are already non-pinned counters in this cpu, it means
  *          there is already a free slot for them.
@@ -204,7 +220,7 @@ static void toggle_bp_slot(struct perf_event *bp, bool enable)
  *   - If attached to every cpus, check:
  *
  *       (per_cpu(nr_bp_flexible, *) || (max(per_cpu(nr_cpu_bp_pinned, *))
- *           + max(per_cpu(task_bp_pinned, *)))) < HBP_NUM
+ *           + max(per_cpu(nr_task_bp_pinned, *)))) < HBP_NUM
  *
  *       -> This is roughly the same, except we check the number of per cpu
  *          bp for every cpu and we keep the max one. Same for the per tasks
@@ -216,7 +232,7 @@ static void toggle_bp_slot(struct perf_event *bp, bool enable)
  *   - If attached to a single cpu, check:
  *
  *       ((per_cpu(nr_bp_flexible, cpu) > 1) + per_cpu(nr_cpu_bp_pinned, cpu)
- *            + max(per_cpu(task_bp_pinned, cpu))) < HBP_NUM
+ *            + max(per_cpu(nr_task_bp_pinned, cpu))) < HBP_NUM
  *
  *       -> Same checks as before. But now the nr_bp_flexible, if any, must keep
  *          one register at least (or they will never be fed).
@@ -224,7 +240,7 @@ static void toggle_bp_slot(struct perf_event *bp, bool enable)
  *   - If attached to every cpus, check:
  *
  *       ((per_cpu(nr_bp_flexible, *) > 1) + max(per_cpu(nr_cpu_bp_pinned, *))
- *            + max(per_cpu(task_bp_pinned, *))) < HBP_NUM
+ *            + max(per_cpu(nr_task_bp_pinned, *))) < HBP_NUM
  */
 int reserve_bp_slot(struct perf_event *bp)
 {
@@ -233,7 +249,7 @@ int reserve_bp_slot(struct perf_event *bp)
 
 	mutex_lock(&nr_bp_mutex);
 
-	fetch_bp_busy_slots(&slots, bp->cpu);
+	fetch_bp_busy_slots(&slots, bp);
 
 	/* Flexible counters need to keep at least one slot */
 	if (slots.pinned + (!!slots.flexible) == HBP_NUM) {
@@ -259,7 +275,7 @@ void release_bp_slot(struct perf_event *bp)
 }
 
 
-int __register_perf_hw_breakpoint(struct perf_event *bp)
+int register_perf_hw_breakpoint(struct perf_event *bp)
 {
 	int ret;
 
@@ -276,19 +292,12 @@ int __register_perf_hw_breakpoint(struct perf_event *bp)
 	 * This is a quick hack that will be removed soon, once we remove
 	 * the tmp breakpoints from ptrace
 	 */
-	if (!bp->attr.disabled || bp->callback == perf_bp_event)
+	if (!bp->attr.disabled || !bp->overflow_handler)
 		ret = arch_validate_hwbkpt_settings(bp, bp->ctx->task);
 
 	return ret;
 }
 
-int register_perf_hw_breakpoint(struct perf_event *bp)
-{
-	bp->callback = perf_bp_event;
-
-	return __register_perf_hw_breakpoint(bp);
-}
-
 /**
  * register_user_hw_breakpoint - register a hardware breakpoint for user space
  * @attr: breakpoint attributes
@@ -297,7 +306,7 @@ int register_perf_hw_breakpoint(struct perf_event *bp)
  */
 struct perf_event *
 register_user_hw_breakpoint(struct perf_event_attr *attr,
-			    perf_callback_t triggered,
+			    perf_overflow_handler_t triggered,
 			    struct task_struct *tsk)
 {
 	return perf_event_create_kernel_counter(attr, -1, tsk->pid, triggered);
@@ -311,19 +320,40 @@ EXPORT_SYMBOL_GPL(register_user_hw_breakpoint);
  * @triggered: callback to trigger when we hit the breakpoint
  * @tsk: pointer to 'task_struct' of the process to which the address belongs
  */
-struct perf_event *
-modify_user_hw_breakpoint(struct perf_event *bp, struct perf_event_attr *attr,
-			  perf_callback_t triggered,
-			  struct task_struct *tsk)
+int modify_user_hw_breakpoint(struct perf_event *bp, struct perf_event_attr *attr)
 {
-	/*
-	 * FIXME: do it without unregistering
-	 * - We don't want to lose our slot
-	 * - If the new bp is incorrect, don't lose the older one
-	 */
-	unregister_hw_breakpoint(bp);
+	u64 old_addr = bp->attr.bp_addr;
+	int old_type = bp->attr.bp_type;
+	int old_len = bp->attr.bp_len;
+	int err = 0;
 
-	return perf_event_create_kernel_counter(attr, -1, tsk->pid, triggered);
+	perf_event_disable(bp);
+
+	bp->attr.bp_addr = attr->bp_addr;
+	bp->attr.bp_type = attr->bp_type;
+	bp->attr.bp_len = attr->bp_len;
+
+	if (attr->disabled)
+		goto end;
+
+	err = arch_validate_hwbkpt_settings(bp, bp->ctx->task);
+	if (!err)
+		perf_event_enable(bp);
+
+	if (err) {
+		bp->attr.bp_addr = old_addr;
+		bp->attr.bp_type = old_type;
+		bp->attr.bp_len = old_len;
+		if (!bp->attr.disabled)
+			perf_event_enable(bp);
+
+		return err;
+	}
+
+end:
+	bp->attr.disabled = attr->disabled;
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(modify_user_hw_breakpoint);
 
@@ -348,7 +378,7 @@ EXPORT_SYMBOL_GPL(unregister_hw_breakpoint);
  */
 struct perf_event **
 register_wide_hw_breakpoint(struct perf_event_attr *attr,
-			    perf_callback_t triggered)
+			    perf_overflow_handler_t triggered)
 {
 	struct perf_event **cpu_events, **pevent, *bp;
 	long err;
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 6b7ddba..d891ec4 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -36,7 +36,7 @@
 /*
  * Each CPU has a list of per CPU events:
  */
-DEFINE_PER_CPU(struct perf_cpu_context, perf_cpu_context);
+static DEFINE_PER_CPU(struct perf_cpu_context, perf_cpu_context);
 
 int perf_max_events __read_mostly = 1;
 static int perf_reserved_percpu __read_mostly;
@@ -567,7 +567,7 @@ static void __perf_event_disable(void *info)
  * is the current context on this CPU and preemption is disabled,
  * hence we can't get into perf_event_task_sched_out for this context.
  */
-static void perf_event_disable(struct perf_event *event)
+void perf_event_disable(struct perf_event *event)
 {
 	struct perf_event_context *ctx = event->ctx;
 	struct task_struct *task = ctx->task;
@@ -971,7 +971,7 @@ static void __perf_event_enable(void *info)
  * perf_event_for_each_child or perf_event_for_each as described
  * for perf_event_disable.
  */
-static void perf_event_enable(struct perf_event *event)
+void perf_event_enable(struct perf_event *event)
 {
 	struct perf_event_context *ctx = event->ctx;
 	struct task_struct *task = ctx->task;
@@ -1579,7 +1579,6 @@ static void
 __perf_event_init_context(struct perf_event_context *ctx,
 			    struct task_struct *task)
 {
-	memset(ctx, 0, sizeof(*ctx));
 	spin_lock_init(&ctx->lock);
 	mutex_init(&ctx->mutex);
 	INIT_LIST_HEAD(&ctx->group_list);
@@ -1654,7 +1653,7 @@ static struct perf_event_context *find_get_context(pid_t pid, int cpu)
 	}
 
 	if (!ctx) {
-		ctx = kmalloc(sizeof(struct perf_event_context), GFP_KERNEL);
+		ctx = kzalloc(sizeof(struct perf_event_context), GFP_KERNEL);
 		err = -ENOMEM;
 		if (!ctx)
 			goto errout;
@@ -4011,6 +4010,7 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
 	event->pmu->read(event);
 
 	data.addr = 0;
+	data.raw = NULL;
 	data.period = event->hw.last_period;
 	regs = get_irq_regs();
 	/*
@@ -4080,8 +4080,7 @@ static void cpu_clock_perf_event_update(struct perf_event *event)
 	u64 now;
 
 	now = cpu_clock(cpu);
-	prev = atomic64_read(&event->hw.prev_count);
-	atomic64_set(&event->hw.prev_count, now);
+	prev = atomic64_xchg(&event->hw.prev_count, now);
 	atomic64_add(now - prev, &event->count);
 }
 
@@ -4286,15 +4285,8 @@ static void bp_perf_event_destroy(struct perf_event *event)
 static const struct pmu *bp_perf_event_init(struct perf_event *bp)
 {
 	int err;
-	/*
-	 * The breakpoint is already filled if we haven't created the counter
-	 * through perf syscall
-	 * FIXME: manage to get trigerred to NULL if it comes from syscalls
-	 */
-	if (!bp->callback)
-		err = register_perf_hw_breakpoint(bp);
-	else
-		err = __register_perf_hw_breakpoint(bp);
+
+	err = register_perf_hw_breakpoint(bp);
 	if (err)
 		return ERR_PTR(err);
 
@@ -4308,6 +4300,7 @@ void perf_bp_event(struct perf_event *bp, void *data)
 	struct perf_sample_data sample;
 	struct pt_regs *regs = data;
 
+	sample.raw = NULL;
 	sample.addr = bp->attr.bp_addr;
 
 	if (!perf_exclude_event(bp, regs))
@@ -4390,7 +4383,7 @@ perf_event_alloc(struct perf_event_attr *attr,
 		   struct perf_event_context *ctx,
 		   struct perf_event *group_leader,
 		   struct perf_event *parent_event,
-		   perf_callback_t callback,
+		   perf_overflow_handler_t overflow_handler,
 		   gfp_t gfpflags)
 {
 	const struct pmu *pmu;
@@ -4433,10 +4426,10 @@ perf_event_alloc(struct perf_event_attr *attr,
 
 	event->state		= PERF_EVENT_STATE_INACTIVE;
 
-	if (!callback && parent_event)
-		callback = parent_event->callback;
+	if (!overflow_handler && parent_event)
+		overflow_handler = parent_event->overflow_handler;
 	
-	event->callback	= callback;
+	event->overflow_handler	= overflow_handler;
 
 	if (attr->disabled)
 		event->state = PERF_EVENT_STATE_OFF;
@@ -4776,7 +4769,8 @@ err_put_context:
  */
 struct perf_event *
 perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
-				 pid_t pid, perf_callback_t callback)
+				 pid_t pid,
+				 perf_overflow_handler_t overflow_handler)
 {
 	struct perf_event *event;
 	struct perf_event_context *ctx;
@@ -4793,7 +4787,7 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 	}
 
 	event = perf_event_alloc(attr, cpu, ctx, NULL,
-				     NULL, callback, GFP_KERNEL);
+				 NULL, overflow_handler, GFP_KERNEL);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
 		goto err_put_context;
@@ -5090,7 +5084,7 @@ again:
  */
 int perf_event_init_task(struct task_struct *child)
 {
-	struct perf_event_context *child_ctx, *parent_ctx;
+	struct perf_event_context *child_ctx = NULL, *parent_ctx;
 	struct perf_event_context *cloned_ctx;
 	struct perf_event *event;
 	struct task_struct *parent = current;
@@ -5106,20 +5100,6 @@ int perf_event_init_task(struct task_struct *child)
 		return 0;
 
 	/*
-	 * This is executed from the parent task context, so inherit
-	 * events that have been marked for cloning.
-	 * First allocate and initialize a context for the child.
-	 */
-
-	child_ctx = kmalloc(sizeof(struct perf_event_context), GFP_KERNEL);
-	if (!child_ctx)
-		return -ENOMEM;
-
-	__perf_event_init_context(child_ctx, child);
-	child->perf_event_ctxp = child_ctx;
-	get_task_struct(child);
-
-	/*
 	 * If the parent's context is a clone, pin it so it won't get
 	 * swapped under us.
 	 */
@@ -5149,6 +5129,26 @@ int perf_event_init_task(struct task_struct *child)
 			continue;
 		}
 
+		if (!child->perf_event_ctxp) {
+			/*
+			 * This is executed from the parent task context, so
+			 * inherit events that have been marked for cloning.
+			 * First allocate and initialize a context for the
+			 * child.
+			 */
+
+			child_ctx = kzalloc(sizeof(struct perf_event_context),
+					    GFP_KERNEL);
+			if (!child_ctx) {
+				ret = -ENOMEM;
+				goto exit;
+			}
+
+			__perf_event_init_context(child_ctx, child);
+			child->perf_event_ctxp = child_ctx;
+			get_task_struct(child);
+		}
+
 		ret = inherit_group(event, parent, parent_ctx,
 					     child, child_ctx);
 		if (ret) {
@@ -5177,6 +5177,7 @@ int perf_event_init_task(struct task_struct *child)
 		get_ctx(child_ctx->parent_ctx);
 	}
 
+exit:
 	mutex_unlock(&parent_ctx->mutex);
 
 	perf_unpin_context(parent_ctx);
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index aff5f80..b52d397 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -606,23 +606,22 @@ static int create_trace_probe(int argc, char **argv)
 	 */
 	struct trace_probe *tp;
 	int i, ret = 0;
-	int is_return = 0;
+	int is_return = 0, is_delete = 0;
 	char *symbol = NULL, *event = NULL, *arg = NULL, *group = NULL;
 	unsigned long offset = 0;
 	void *addr = NULL;
 	char buf[MAX_EVENT_NAME_LEN];
 
-	if (argc < 2) {
-		pr_info("Probe point is not specified.\n");
-		return -EINVAL;
-	}
-
+	/* argc must be >= 1 */
 	if (argv[0][0] == 'p')
 		is_return = 0;
 	else if (argv[0][0] == 'r')
 		is_return = 1;
+	else if (argv[0][0] == '-')
+		is_delete = 1;
 	else {
-		pr_info("Probe definition must be started with 'p' or 'r'.\n");
+		pr_info("Probe definition must be started with 'p', 'r' or"
+			" '-'.\n");
 		return -EINVAL;
 	}
 
@@ -642,7 +641,29 @@ static int create_trace_probe(int argc, char **argv)
 			return -EINVAL;
 		}
 	}
+	if (!group)
+		group = KPROBE_EVENT_SYSTEM;
 
+	if (is_delete) {
+		if (!event) {
+			pr_info("Delete command needs an event name.\n");
+			return -EINVAL;
+		}
+		tp = find_probe_event(event, group);
+		if (!tp) {
+			pr_info("Event %s/%s doesn't exist.\n", group, event);
+			return -ENOENT;
+		}
+		/* delete an event */
+		unregister_trace_probe(tp);
+		free_trace_probe(tp);
+		return 0;
+	}
+
+	if (argc < 2) {
+		pr_info("Probe point is not specified.\n");
+		return -EINVAL;
+	}
 	if (isdigit(argv[1][0])) {
 		if (is_return) {
 			pr_info("Return probe point must be a symbol.\n");
@@ -671,8 +692,6 @@ static int create_trace_probe(int argc, char **argv)
 	argc -= 2; argv += 2;
 
 	/* setup a probe */
-	if (!group)
-		group = KPROBE_EVENT_SYSTEM;
 	if (!event) {
 		/* Make a new event name */
 		if (symbol)
@@ -1114,7 +1133,7 @@ static int kprobe_event_define_fields(struct ftrace_event_call *event_call)
 	struct trace_probe *tp = (struct trace_probe *)event_call->data;
 
 	ret = trace_define_common_fields(event_call);
-	if (!ret)
+	if (ret)
 		return ret;
 
 	DEFINE_FIELD(unsigned long, ip, FIELD_STRING_IP, 0);
@@ -1132,7 +1151,7 @@ static int kretprobe_event_define_fields(struct ftrace_event_call *event_call)
 	struct trace_probe *tp = (struct trace_probe *)event_call->data;
 
 	ret = trace_define_common_fields(event_call);
-	if (!ret)
+	if (ret)
 		return ret;
 
 	DEFINE_FIELD(unsigned long, func, FIELD_STRING_FUNC, 0);
diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index ddfa0fd..acb87d4 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -79,11 +79,12 @@ void ksym_collect_stats(unsigned long hbp_hit_addr)
 }
 #endif /* CONFIG_PROFILE_KSYM_TRACER */
 
-void ksym_hbp_handler(struct perf_event *hbp, void *data)
+void ksym_hbp_handler(struct perf_event *hbp, int nmi,
+		      struct perf_sample_data *data,
+		      struct pt_regs *regs)
 {
 	struct ring_buffer_event *event;
 	struct ksym_trace_entry *entry;
-	struct pt_regs *regs = data;
 	struct ring_buffer *buffer;
 	int pc;
 
diff --git a/samples/hw_breakpoint/data_breakpoint.c b/samples/hw_breakpoint/data_breakpoint.c
index 2952550..c69cbe9 100644
--- a/samples/hw_breakpoint/data_breakpoint.c
+++ b/samples/hw_breakpoint/data_breakpoint.c
@@ -41,7 +41,9 @@ module_param_string(ksym, ksym_name, KSYM_NAME_LEN, S_IRUGO);
 MODULE_PARM_DESC(ksym, "Kernel symbol to monitor; this module will report any"
 			" write operations on the kernel symbol");
 
-static void sample_hbp_handler(struct perf_event *temp, void *data)
+static void sample_hbp_handler(struct perf_event *bp, int nmi,
+			       struct perf_sample_data *data,
+			       struct pt_regs *regs)
 {
 	printk(KERN_INFO "%s value is changed\n", ksym_name);
 	dump_stack();
@@ -51,8 +53,9 @@ static void sample_hbp_handler(struct perf_event *temp, void *data)
 static int __init hw_break_module_init(void)
 {
 	int ret;
-	DEFINE_BREAKPOINT_ATTR(attr);
+	struct perf_event_attr attr;
 
+	hw_breakpoint_init(&attr);
 	attr.bp_addr = kallsyms_lookup_name(ksym_name);
 	attr.bp_len = HW_BREAKPOINT_LEN_4;
 	attr.bp_type = HW_BREAKPOINT_W | HW_BREAKPOINT_R;
diff --git a/tools/perf/Documentation/perf-kmem.txt b/tools/perf/Documentation/perf-kmem.txt
index 44b0ce3..eac4d85 100644
--- a/tools/perf/Documentation/perf-kmem.txt
+++ b/tools/perf/Documentation/perf-kmem.txt
@@ -8,16 +8,16 @@ perf-kmem - Tool to trace/measure kernel memory(slab) properties
 SYNOPSIS
 --------
 [verse]
-'perf kmem' {record} [<options>]
+'perf kmem' {record|stat} [<options>]
 
 DESCRIPTION
 -----------
-There's two variants of perf kmem:
+There are two variants of perf kmem:
 
   'perf kmem record <command>' to record the kmem events
   of an arbitrary workload.
 
-  'perf kmem' to report kernel memory statistics.
+  'perf kmem stat' to report kernel memory statistics.
 
 OPTIONS
 -------
@@ -25,8 +25,11 @@ OPTIONS
 --input=<file>::
 	Select the input file (default: perf.data)
 
---stat=<caller|alloc>::
-	Select per callsite or per allocation statistics
+--caller::
+	Show per-callsite statistics
+
+--alloc::
+	Show per-allocation statistics
 
 -s <key[,key2...]>::
 --sort=<key[,key2...]>::
diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 9270594..8fa6bf9 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -8,10 +8,13 @@ perf-probe - Define new dynamic tracepoints
 SYNOPSIS
 --------
 [verse]
-'perf probe' [options] --add 'PROBE' [--add 'PROBE' ...]
+'perf probe' [options] --add='PROBE' [...]
 or
-'perf probe' [options] 'PROBE' ['PROBE' ...]
-
+'perf probe' [options] PROBE
+or
+'perf probe' [options] --del='[GROUP:]EVENT' [...]
+or
+'perf probe' --list
 
 DESCRIPTION
 -----------
@@ -31,8 +34,16 @@ OPTIONS
         Be more verbose (show parsed arguments, etc).
 
 -a::
---add::
-	Define a probe point (see PROBE SYNTAX for detail)
+--add=::
+	Define a probe event (see PROBE SYNTAX for detail).
+
+-d::
+--del=::
+	Delete a probe event.
+
+-l::
+--list::
+	List up current probe events.
 
 PROBE SYNTAX
 ------------
diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index 7dee9d1..dcb6143 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -19,7 +19,7 @@ static char const *input_name = "perf.data";
 static int force;
 
 static const char *const buildid_list_usage[] = {
-	"perf report [<options>]",
+	"perf buildid-list [<options>]",
 	NULL
 };
 
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 047fef7..5f20951 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -57,11 +57,6 @@ static struct rb_root root_caller_sorted;
 static unsigned long total_requested, total_allocated;
 static unsigned long nr_allocs, nr_cross_allocs;
 
-struct raw_event_sample {
-	u32 size;
-	char data[0];
-};
-
 #define PATH_SYS_NODE	"/sys/devices/system/node"
 
 static void init_cpunode_map(void)
@@ -201,7 +196,7 @@ static void insert_caller_stat(unsigned long call_site,
 	}
 }
 
-static void process_alloc_event(struct raw_event_sample *raw,
+static void process_alloc_event(void *data,
 				struct event *event,
 				int cpu,
 				u64 timestamp __used,
@@ -214,10 +209,10 @@ static void process_alloc_event(struct raw_event_sample *raw,
 	int bytes_alloc;
 	int node1, node2;
 
-	ptr = raw_field_value(event, "ptr", raw->data);
-	call_site = raw_field_value(event, "call_site", raw->data);
-	bytes_req = raw_field_value(event, "bytes_req", raw->data);
-	bytes_alloc = raw_field_value(event, "bytes_alloc", raw->data);
+	ptr = raw_field_value(event, "ptr", data);
+	call_site = raw_field_value(event, "call_site", data);
+	bytes_req = raw_field_value(event, "bytes_req", data);
+	bytes_alloc = raw_field_value(event, "bytes_alloc", data);
 
 	insert_alloc_stat(call_site, ptr, bytes_req, bytes_alloc, cpu);
 	insert_caller_stat(call_site, bytes_req, bytes_alloc);
@@ -227,7 +222,7 @@ static void process_alloc_event(struct raw_event_sample *raw,
 
 	if (node) {
 		node1 = cpunode_map[cpu];
-		node2 = raw_field_value(event, "node", raw->data);
+		node2 = raw_field_value(event, "node", data);
 		if (node1 != node2)
 			nr_cross_allocs++;
 	}
@@ -262,7 +257,7 @@ static struct alloc_stat *search_alloc_stat(unsigned long ptr,
 	return NULL;
 }
 
-static void process_free_event(struct raw_event_sample *raw,
+static void process_free_event(void *data,
 			       struct event *event,
 			       int cpu,
 			       u64 timestamp __used,
@@ -271,7 +266,7 @@ static void process_free_event(struct raw_event_sample *raw,
 	unsigned long ptr;
 	struct alloc_stat *s_alloc, *s_caller;
 
-	ptr = raw_field_value(event, "ptr", raw->data);
+	ptr = raw_field_value(event, "ptr", data);
 
 	s_alloc = search_alloc_stat(ptr, 0, &root_alloc_stat, ptr_cmp);
 	if (!s_alloc)
@@ -289,66 +284,53 @@ static void process_free_event(struct raw_event_sample *raw,
 }
 
 static void
-process_raw_event(event_t *raw_event __used, void *more_data,
+process_raw_event(event_t *raw_event __used, void *data,
 		  int cpu, u64 timestamp, struct thread *thread)
 {
-	struct raw_event_sample *raw = more_data;
 	struct event *event;
 	int type;
 
-	type = trace_parse_common_type(raw->data);
+	type = trace_parse_common_type(data);
 	event = trace_find_event(type);
 
 	if (!strcmp(event->name, "kmalloc") ||
 	    !strcmp(event->name, "kmem_cache_alloc")) {
-		process_alloc_event(raw, event, cpu, timestamp, thread, 0);
+		process_alloc_event(data, event, cpu, timestamp, thread, 0);
 		return;
 	}
 
 	if (!strcmp(event->name, "kmalloc_node") ||
 	    !strcmp(event->name, "kmem_cache_alloc_node")) {
-		process_alloc_event(raw, event, cpu, timestamp, thread, 1);
+		process_alloc_event(data, event, cpu, timestamp, thread, 1);
 		return;
 	}
 
 	if (!strcmp(event->name, "kfree") ||
 	    !strcmp(event->name, "kmem_cache_free")) {
-		process_free_event(raw, event, cpu, timestamp, thread);
+		process_free_event(data, event, cpu, timestamp, thread);
 		return;
 	}
 }
 
 static int process_sample_event(event_t *event)
 {
-	u64 ip = event->ip.ip;
-	u64 timestamp = -1;
-	u32 cpu = -1;
-	u64 period = 1;
-	void *more_data = event->ip.__more_data;
-	struct thread *thread = threads__findnew(event->ip.pid);
+	struct sample_data data;
+	struct thread *thread;
 
-	if (sample_type & PERF_SAMPLE_TIME) {
-		timestamp = *(u64 *)more_data;
-		more_data += sizeof(u64);
-	}
-
-	if (sample_type & PERF_SAMPLE_CPU) {
-		cpu = *(u32 *)more_data;
-		more_data += sizeof(u32);
-		more_data += sizeof(u32); /* reserved */
-	}
+	memset(&data, 0, sizeof(data));
+	data.time = -1;
+	data.cpu = -1;
+	data.period = 1;
 
-	if (sample_type & PERF_SAMPLE_PERIOD) {
-		period = *(u64 *)more_data;
-		more_data += sizeof(u64);
-	}
+	event__parse_sample(event, sample_type, &data);
 
 	dump_printf("(IP, %d): %d/%d: %p period: %Ld\n",
 		event->header.misc,
-		event->ip.pid, event->ip.tid,
-		(void *)(long)ip,
-		(long long)period);
+		data.pid, data.tid,
+		(void *)(long)data.ip,
+		(long long)data.period);
 
+	thread = threads__findnew(event->ip.pid);
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
 			 event->header.type);
@@ -357,7 +339,8 @@ static int process_sample_event(event_t *event)
 
 	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
 
-	process_raw_event(event, more_data, cpu, timestamp, thread);
+	process_raw_event(event, data.raw_data, data.cpu,
+			  data.time, thread);
 
 	return 0;
 }
@@ -543,7 +526,7 @@ static int __cmd_kmem(void)
 }
 
 static const char * const kmem_usage[] = {
-	"perf kmem [<options>] {record}",
+	"perf kmem [<options>] {record|stat}",
 	NULL
 };
 
@@ -703,18 +686,17 @@ static int parse_sort_opt(const struct option *opt __used,
 	return 0;
 }
 
-static int parse_stat_opt(const struct option *opt __used,
-			  const char *arg, int unset __used)
+static int parse_caller_opt(const struct option *opt __used,
+			  const char *arg __used, int unset __used)
 {
-	if (!arg)
-		return -1;
+	caller_flag = (alloc_flag + 1);
+	return 0;
+}
 
-	if (strcmp(arg, "alloc") == 0)
-		alloc_flag = (caller_flag + 1);
-	else if (strcmp(arg, "caller") == 0)
-		caller_flag = (alloc_flag + 1);
-	else
-		return -1;
+static int parse_alloc_opt(const struct option *opt __used,
+			  const char *arg __used, int unset __used)
+{
+	alloc_flag = (caller_flag + 1);
 	return 0;
 }
 
@@ -739,14 +721,17 @@ static int parse_line_opt(const struct option *opt __used,
 static const struct option kmem_options[] = {
 	OPT_STRING('i', "input", &input_name, "file",
 		   "input file name"),
-	OPT_CALLBACK(0, "stat", NULL, "<alloc>|<caller>",
-		     "stat selector, Pass 'alloc' or 'caller'.",
-		     parse_stat_opt),
+	OPT_CALLBACK_NOOPT(0, "caller", NULL, NULL,
+			   "show per-callsite statistics",
+			   parse_caller_opt),
+	OPT_CALLBACK_NOOPT(0, "alloc", NULL, NULL,
+			   "show per-allocation statistics",
+			   parse_alloc_opt),
 	OPT_CALLBACK('s', "sort", NULL, "key[,key2...]",
 		     "sort by keys: ptr, call_site, bytes, hit, pingpong, frag",
 		     parse_sort_opt),
 	OPT_CALLBACK('l', "line", NULL, "num",
-		     "show n lins",
+		     "show n lines",
 		     parse_line_opt),
 	OPT_BOOLEAN(0, "raw-ip", &raw_ip, "show raw ip instead of symbol"),
 	OPT_END()
@@ -790,18 +775,22 @@ int cmd_kmem(int argc, const char **argv, const char *prefix __used)
 
 	argc = parse_options(argc, argv, kmem_options, kmem_usage, 0);
 
-	if (argc && !strncmp(argv[0], "rec", 3))
-		return __cmd_record(argc, argv);
-	else if (argc)
+	if (!argc)
 		usage_with_options(kmem_usage, kmem_options);
 
-	if (list_empty(&caller_sort))
-		setup_sorting(&caller_sort, default_sort_order);
-	if (list_empty(&alloc_sort))
-		setup_sorting(&alloc_sort, default_sort_order);
+	if (!strncmp(argv[0], "rec", 3)) {
+		return __cmd_record(argc, argv);
+	} else if (!strcmp(argv[0], "stat")) {
+		setup_cpunode_map();
+
+		if (list_empty(&caller_sort))
+			setup_sorting(&caller_sort, default_sort_order);
+		if (list_empty(&alloc_sort))
+			setup_sorting(&alloc_sort, default_sort_order);
 
-	setup_cpunode_map();
+		return __cmd_kmem();
+	}
 
-	return __cmd_kmem();
+	return 0;
 }
 
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index a58e11b..5a47c1e 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -35,6 +35,7 @@
 #include "perf.h"
 #include "builtin.h"
 #include "util/util.h"
+#include "util/strlist.h"
 #include "util/event.h"
 #include "util/debug.h"
 #include "util/parse-options.h"
@@ -43,11 +44,12 @@
 #include "util/probe-event.h"
 
 /* Default vmlinux search paths */
-#define NR_SEARCH_PATH 3
+#define NR_SEARCH_PATH 4
 const char *default_search_path[NR_SEARCH_PATH] = {
 "/lib/modules/%s/build/vmlinux",		/* Custom build kernel */
 "/usr/lib/debug/lib/modules/%s/vmlinux",	/* Red Hat debuginfo */
 "/boot/vmlinux-debug-%s",			/* Ubuntu */
+"./vmlinux",					/* CWD */
 };
 
 #define MAX_PATH_LEN 256
@@ -60,6 +62,7 @@ static struct {
 	int need_dwarf;
 	int nr_probe;
 	struct probe_point probes[MAX_PROBES];
+	struct strlist *dellist;
 } session;
 
 static bool listing;
@@ -79,6 +82,25 @@ static void parse_probe_event(const char *str)
 	pr_debug("%d arguments\n", pp->nr_args);
 }
 
+static void parse_probe_event_argv(int argc, const char **argv)
+{
+	int i, len;
+	char *buf;
+
+	/* Bind up rest arguments */
+	len = 0;
+	for (i = 0; i < argc; i++)
+		len += strlen(argv[i]) + 1;
+	buf = zalloc(len + 1);
+	if (!buf)
+		die("Failed to allocate memory for binding arguments.");
+	len = 0;
+	for (i = 0; i < argc; i++)
+		len += sprintf(&buf[len], "%s ", argv[i]);
+	parse_probe_event(buf);
+	free(buf);
+}
+
 static int opt_add_probe_event(const struct option *opt __used,
 			      const char *str, int unset __used)
 {
@@ -87,6 +109,17 @@ static int opt_add_probe_event(const struct option *opt __used,
 	return 0;
 }
 
+static int opt_del_probe_event(const struct option *opt __used,
+			       const char *str, int unset __used)
+{
+	if (str) {
+		if (!session.dellist)
+			session.dellist = strlist__new(true, NULL);
+		strlist__add(session.dellist, str);
+	}
+	return 0;
+}
+
 #ifndef NO_LIBDWARF
 static int open_default_vmlinux(void)
 {
@@ -121,6 +154,7 @@ static int open_default_vmlinux(void)
 static const char * const probe_usage[] = {
 	"perf probe [<options>] 'PROBEDEF' ['PROBEDEF' ...]",
 	"perf probe [<options>] --add 'PROBEDEF' [--add 'PROBEDEF' ...]",
+	"perf probe [<options>] --del '[GROUP:]EVENT' ...",
 	"perf probe --list",
 	NULL
 };
@@ -132,7 +166,9 @@ static const struct option options[] = {
 	OPT_STRING('k', "vmlinux", &session.vmlinux, "file",
 		"vmlinux/module pathname"),
 #endif
-	OPT_BOOLEAN('l', "list", &listing, "list up current probes"),
+	OPT_BOOLEAN('l', "list", &listing, "list up current probe events"),
+	OPT_CALLBACK('d', "del", NULL, "[GROUP:]EVENT", "delete a probe event.",
+		opt_del_probe_event),
 	OPT_CALLBACK('a', "add", NULL,
 #ifdef NO_LIBDWARF
 		"FUNC[+OFFS|%return] [ARG ...]",
@@ -160,7 +196,7 @@ static const struct option options[] = {
 
 int cmd_probe(int argc, const char **argv, const char *prefix __used)
 {
-	int i, j, ret;
+	int i, ret;
 #ifndef NO_LIBDWARF
 	int fd;
 #endif
@@ -168,40 +204,52 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 
 	argc = parse_options(argc, argv, options, probe_usage,
 			     PARSE_OPT_STOP_AT_NON_OPTION);
-	for (i = 0; i < argc; i++)
-		parse_probe_event(argv[i]);
+	if (argc > 0)
+		parse_probe_event_argv(argc, argv);
 
-	if ((session.nr_probe == 0 && !listing) ||
-	    (session.nr_probe != 0 && listing))
+	if ((session.nr_probe == 0 && !session.dellist && !listing))
 		usage_with_options(probe_usage, options);
 
 	if (listing) {
+		if (session.nr_probe != 0 || session.dellist) {
+			pr_warning("  Error: Don't use --list with"
+				   " --add/--del.\n");
+			usage_with_options(probe_usage, options);
+		}
 		show_perf_probe_events();
 		return 0;
 	}
 
+	if (session.dellist) {
+		del_trace_kprobe_events(session.dellist);
+		strlist__delete(session.dellist);
+		if (session.nr_probe == 0)
+			return 0;
+	}
+
 	if (session.need_dwarf)
 #ifdef NO_LIBDWARF
 		die("Debuginfo-analysis is not supported");
 #else	/* !NO_LIBDWARF */
 		pr_debug("Some probes require debuginfo.\n");
 
-	if (session.vmlinux)
+	if (session.vmlinux) {
+		pr_debug("Try to open %s.", session.vmlinux);
 		fd = open(session.vmlinux, O_RDONLY);
-	else
+	} else
 		fd = open_default_vmlinux();
 	if (fd < 0) {
 		if (session.need_dwarf)
-			die("Could not open vmlinux/module file.");
+			die("Could not open debuginfo file.");
 
-		pr_warning("Could not open vmlinux/module file."
-			   " Try to use symbols.\n");
+		pr_debug("Could not open vmlinux/module file."
+			 " Try to use symbols.\n");
 		goto end_dwarf;
 	}
 
 	/* Searching probe points */
-	for (j = 0; j < session.nr_probe; j++) {
-		pp = &session.probes[j];
+	for (i = 0; i < session.nr_probe; i++) {
+		pp = &session.probes[i];
 		if (pp->found)
 			continue;
 
@@ -223,8 +271,8 @@ end_dwarf:
 #endif /* !NO_LIBDWARF */
 
 	/* Synthesize probes without dwarf */
-	for (j = 0; j < session.nr_probe; j++) {
-		pp = &session.probes[j];
+	for (i = 0; i < session.nr_probe; i++) {
+		pp = &session.probes[i];
 		if (pp->found)	/* This probe is already found. */
 			continue;
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 383c4ab..2b9eb3a 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -605,44 +605,41 @@ static int validate_chain(struct ip_callchain *chain, event_t *event)
 
 static int process_sample_event(event_t *event)
 {
-	u64 ip = event->ip.ip;
-	u64 period = 1;
-	void *more_data = event->ip.__more_data;
-	struct ip_callchain *chain = NULL;
+	struct sample_data data;
 	int cpumode;
 	struct addr_location al;
-	struct thread *thread = threads__findnew(event->ip.pid);
+	struct thread *thread;
 
-	if (sample_type & PERF_SAMPLE_PERIOD) {
-		period = *(u64 *)more_data;
-		more_data += sizeof(u64);
-	}
+	memset(&data, 0, sizeof(data));
+	data.period = 1;
+
+	event__parse_sample(event, sample_type, &data);
 
 	dump_printf("(IP, %d): %d/%d: %p period: %Ld\n",
 		event->header.misc,
-		event->ip.pid, event->ip.tid,
-		(void *)(long)ip,
-		(long long)period);
+		data.pid, data.tid,
+		(void *)(long)data.ip,
+		(long long)data.period);
 
 	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
 		unsigned int i;
 
-		chain = (void *)more_data;
-
-		dump_printf("... chain: nr:%Lu\n", chain->nr);
+		dump_printf("... chain: nr:%Lu\n", data.callchain->nr);
 
-		if (validate_chain(chain, event) < 0) {
+		if (validate_chain(data.callchain, event) < 0) {
 			pr_debug("call-chain problem with event, "
 				 "skipping it.\n");
 			return 0;
 		}
 
 		if (dump_trace) {
-			for (i = 0; i < chain->nr; i++)
-				dump_printf("..... %2d: %016Lx\n", i, chain->ips[i]);
+			for (i = 0; i < data.callchain->nr; i++)
+				dump_printf("..... %2d: %016Lx\n",
+					    i, data.callchain->ips[i]);
 		}
 	}
 
+	thread = threads__findnew(data.pid);
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
 			event->header.type);
@@ -657,7 +654,7 @@ static int process_sample_event(event_t *event)
 	cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
 	thread__find_addr_location(thread, cpumode,
-				   MAP__FUNCTION, ip, &al, NULL);
+				   MAP__FUNCTION, data.ip, &al, NULL);
 	/*
 	 * We have to do this here as we may have a dso with no symbol hit that
 	 * has a name longer than the ones with symbols sampled.
@@ -675,12 +672,12 @@ static int process_sample_event(event_t *event)
 	if (sym_list && al.sym && !strlist__has_entry(sym_list, al.sym->name))
 		return 0;
 
-	if (hist_entry__add(&al, chain, period)) {
+	if (hist_entry__add(&al, data.callchain, data.period)) {
 		pr_debug("problem incrementing symbol count, skipping event\n");
 		return -1;
 	}
 
-	event__stats.total += period;
+	event__stats.total += data.period;
 
 	return 0;
 }
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 26b782f..7cca7c1 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -13,7 +13,6 @@
 #include "util/debug.h"
 #include "util/data_map.h"
 
-#include <sys/types.h>
 #include <sys/prctl.h>
 
 #include <semaphore.h>
@@ -141,6 +140,7 @@ struct work_atoms {
 	struct thread		*thread;
 	struct rb_node		node;
 	u64			max_lat;
+	u64			max_lat_at;
 	u64			total_lat;
 	u64			nb_atoms;
 	u64			total_runtime;
@@ -414,34 +414,33 @@ static u64 get_cpu_usage_nsec_parent(void)
 	return sum;
 }
 
-static u64 get_cpu_usage_nsec_self(void)
+static int self_open_counters(void)
 {
-	char filename [] = "/proc/1234567890/sched";
-	unsigned long msecs, nsecs;
-	char *line = NULL;
-	u64 total = 0;
-	size_t len = 0;
-	ssize_t chars;
-	FILE *file;
-	int ret;
+	struct perf_event_attr attr;
+	int fd;
 
-	sprintf(filename, "/proc/%d/sched", getpid());
-	file = fopen(filename, "r");
-	BUG_ON(!file);
+	memset(&attr, 0, sizeof(attr));
 
-	while ((chars = getline(&line, &len, file)) != -1) {
-		ret = sscanf(line, "se.sum_exec_runtime : %ld.%06ld\n",
-			&msecs, &nsecs);
-		if (ret == 2) {
-			total = msecs*1e6 + nsecs;
-			break;
-		}
-	}
-	if (line)
-		free(line);
-	fclose(file);
+	attr.type = PERF_TYPE_SOFTWARE;
+	attr.config = PERF_COUNT_SW_TASK_CLOCK;
+
+	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
 
-	return total;
+	if (fd < 0)
+		die("Error: sys_perf_event_open() syscall returned"
+		    "with %d (%s)\n", fd, strerror(errno));
+	return fd;
+}
+
+static u64 get_cpu_usage_nsec_self(int fd)
+{
+	u64 runtime;
+	int ret;
+
+	ret = read(fd, &runtime, sizeof(runtime));
+	BUG_ON(ret != sizeof(runtime));
+
+	return runtime;
 }
 
 static void *thread_func(void *ctx)
@@ -450,9 +449,11 @@ static void *thread_func(void *ctx)
 	u64 cpu_usage_0, cpu_usage_1;
 	unsigned long i, ret;
 	char comm2[22];
+	int fd;
 
 	sprintf(comm2, ":%s", this_task->comm);
 	prctl(PR_SET_NAME, comm2);
+	fd = self_open_counters();
 
 again:
 	ret = sem_post(&this_task->ready_for_work);
@@ -462,16 +463,15 @@ again:
 	ret = pthread_mutex_unlock(&start_work_mutex);
 	BUG_ON(ret);
 
-	cpu_usage_0 = get_cpu_usage_nsec_self();
+	cpu_usage_0 = get_cpu_usage_nsec_self(fd);
 
 	for (i = 0; i < this_task->nr_events; i++) {
 		this_task->curr_event = i;
 		process_sched_event(this_task, this_task->atoms[i]);
 	}
 
-	cpu_usage_1 = get_cpu_usage_nsec_self();
+	cpu_usage_1 = get_cpu_usage_nsec_self(fd);
 	this_task->cpu_usage = cpu_usage_1 - cpu_usage_0;
-
 	ret = sem_post(&this_task->work_done_sem);
 	BUG_ON(ret);
 
@@ -628,11 +628,6 @@ static void test_calibrations(void)
 	printf("the sleep test took %Ld nsecs\n", T1-T0);
 }
 
-struct raw_event_sample {
-	u32 size;
-	char data[0];
-};
-
 #define FILL_FIELD(ptr, field, event, data)	\
 	ptr.field = (typeof(ptr.field)) raw_field_value(event, #field, data)
 
@@ -1019,8 +1014,10 @@ add_sched_in_event(struct work_atoms *atoms, u64 timestamp)
 
 	delta = atom->sched_in_time - atom->wake_up_time;
 	atoms->total_lat += delta;
-	if (delta > atoms->max_lat)
+	if (delta > atoms->max_lat) {
 		atoms->max_lat = delta;
+		atoms->max_lat_at = timestamp;
+	}
 	atoms->nb_atoms++;
 }
 
@@ -1216,10 +1213,11 @@ static void output_lat_thread(struct work_atoms *work_list)
 
 	avg = work_list->total_lat / work_list->nb_atoms;
 
-	printf("|%11.3f ms |%9llu | avg:%9.3f ms | max:%9.3f ms |\n",
+	printf("|%11.3f ms |%9llu | avg:%9.3f ms | max:%9.3f ms | max at: %9.6f s\n",
 	      (double)work_list->total_runtime / 1e6,
 		 work_list->nb_atoms, (double)avg / 1e6,
-		 (double)work_list->max_lat / 1e6);
+		 (double)work_list->max_lat / 1e6,
+		 (double)work_list->max_lat_at / 1e9);
 }
 
 static int pid_cmp(struct work_atoms *l, struct work_atoms *r)
@@ -1356,7 +1354,7 @@ static void sort_lat(void)
 static struct trace_sched_handler *trace_handler;
 
 static void
-process_sched_wakeup_event(struct raw_event_sample *raw,
+process_sched_wakeup_event(void *data,
 			   struct event *event,
 			   int cpu __used,
 			   u64 timestamp __used,
@@ -1364,13 +1362,13 @@ process_sched_wakeup_event(struct raw_event_sample *raw,
 {
 	struct trace_wakeup_event wakeup_event;
 
-	FILL_COMMON_FIELDS(wakeup_event, event, raw->data);
+	FILL_COMMON_FIELDS(wakeup_event, event, data);
 
-	FILL_ARRAY(wakeup_event, comm, event, raw->data);
-	FILL_FIELD(wakeup_event, pid, event, raw->data);
-	FILL_FIELD(wakeup_event, prio, event, raw->data);
-	FILL_FIELD(wakeup_event, success, event, raw->data);
-	FILL_FIELD(wakeup_event, cpu, event, raw->data);
+	FILL_ARRAY(wakeup_event, comm, event, data);
+	FILL_FIELD(wakeup_event, pid, event, data);
+	FILL_FIELD(wakeup_event, prio, event, data);
+	FILL_FIELD(wakeup_event, success, event, data);
+	FILL_FIELD(wakeup_event, cpu, event, data);
 
 	if (trace_handler->wakeup_event)
 		trace_handler->wakeup_event(&wakeup_event, event, cpu, timestamp, thread);
@@ -1469,7 +1467,7 @@ map_switch_event(struct trace_switch_event *switch_event,
 
 
 static void
-process_sched_switch_event(struct raw_event_sample *raw,
+process_sched_switch_event(void *data,
 			   struct event *event,
 			   int this_cpu,
 			   u64 timestamp __used,
@@ -1477,15 +1475,15 @@ process_sched_switch_event(struct raw_event_sample *raw,
 {
 	struct trace_switch_event switch_event;
 
-	FILL_COMMON_FIELDS(switch_event, event, raw->data);
+	FILL_COMMON_FIELDS(switch_event, event, data);
 
-	FILL_ARRAY(switch_event, prev_comm, event, raw->data);
-	FILL_FIELD(switch_event, prev_pid, event, raw->data);
-	FILL_FIELD(switch_event, prev_prio, event, raw->data);
-	FILL_FIELD(switch_event, prev_state, event, raw->data);
-	FILL_ARRAY(switch_event, next_comm, event, raw->data);
-	FILL_FIELD(switch_event, next_pid, event, raw->data);
-	FILL_FIELD(switch_event, next_prio, event, raw->data);
+	FILL_ARRAY(switch_event, prev_comm, event, data);
+	FILL_FIELD(switch_event, prev_pid, event, data);
+	FILL_FIELD(switch_event, prev_prio, event, data);
+	FILL_FIELD(switch_event, prev_state, event, data);
+	FILL_ARRAY(switch_event, next_comm, event, data);
+	FILL_FIELD(switch_event, next_pid, event, data);
+	FILL_FIELD(switch_event, next_prio, event, data);
 
 	if (curr_pid[this_cpu] != (u32)-1) {
 		/*
@@ -1502,7 +1500,7 @@ process_sched_switch_event(struct raw_event_sample *raw,
 }
 
 static void
-process_sched_runtime_event(struct raw_event_sample *raw,
+process_sched_runtime_event(void *data,
 			   struct event *event,
 			   int cpu __used,
 			   u64 timestamp __used,
@@ -1510,17 +1508,17 @@ process_sched_runtime_event(struct raw_event_sample *raw,
 {
 	struct trace_runtime_event runtime_event;
 
-	FILL_ARRAY(runtime_event, comm, event, raw->data);
-	FILL_FIELD(runtime_event, pid, event, raw->data);
-	FILL_FIELD(runtime_event, runtime, event, raw->data);
-	FILL_FIELD(runtime_event, vruntime, event, raw->data);
+	FILL_ARRAY(runtime_event, comm, event, data);
+	FILL_FIELD(runtime_event, pid, event, data);
+	FILL_FIELD(runtime_event, runtime, event, data);
+	FILL_FIELD(runtime_event, vruntime, event, data);
 
 	if (trace_handler->runtime_event)
 		trace_handler->runtime_event(&runtime_event, event, cpu, timestamp, thread);
 }
 
 static void
-process_sched_fork_event(struct raw_event_sample *raw,
+process_sched_fork_event(void *data,
 			 struct event *event,
 			 int cpu __used,
 			 u64 timestamp __used,
@@ -1528,12 +1526,12 @@ process_sched_fork_event(struct raw_event_sample *raw,
 {
 	struct trace_fork_event fork_event;
 
-	FILL_COMMON_FIELDS(fork_event, event, raw->data);
+	FILL_COMMON_FIELDS(fork_event, event, data);
 
-	FILL_ARRAY(fork_event, parent_comm, event, raw->data);
-	FILL_FIELD(fork_event, parent_pid, event, raw->data);
-	FILL_ARRAY(fork_event, child_comm, event, raw->data);
-	FILL_FIELD(fork_event, child_pid, event, raw->data);
+	FILL_ARRAY(fork_event, parent_comm, event, data);
+	FILL_FIELD(fork_event, parent_pid, event, data);
+	FILL_ARRAY(fork_event, child_comm, event, data);
+	FILL_FIELD(fork_event, child_pid, event, data);
 
 	if (trace_handler->fork_event)
 		trace_handler->fork_event(&fork_event, event, cpu, timestamp, thread);
@@ -1550,7 +1548,7 @@ process_sched_exit_event(struct event *event,
 }
 
 static void
-process_sched_migrate_task_event(struct raw_event_sample *raw,
+process_sched_migrate_task_event(void *data,
 			   struct event *event,
 			   int cpu __used,
 			   u64 timestamp __used,
@@ -1558,80 +1556,66 @@ process_sched_migrate_task_event(struct raw_event_sample *raw,
 {
 	struct trace_migrate_task_event migrate_task_event;
 
-	FILL_COMMON_FIELDS(migrate_task_event, event, raw->data);
+	FILL_COMMON_FIELDS(migrate_task_event, event, data);
 
-	FILL_ARRAY(migrate_task_event, comm, event, raw->data);
-	FILL_FIELD(migrate_task_event, pid, event, raw->data);
-	FILL_FIELD(migrate_task_event, prio, event, raw->data);
-	FILL_FIELD(migrate_task_event, cpu, event, raw->data);
+	FILL_ARRAY(migrate_task_event, comm, event, data);
+	FILL_FIELD(migrate_task_event, pid, event, data);
+	FILL_FIELD(migrate_task_event, prio, event, data);
+	FILL_FIELD(migrate_task_event, cpu, event, data);
 
 	if (trace_handler->migrate_task_event)
 		trace_handler->migrate_task_event(&migrate_task_event, event, cpu, timestamp, thread);
 }
 
 static void
-process_raw_event(event_t *raw_event __used, void *more_data,
+process_raw_event(event_t *raw_event __used, void *data,
 		  int cpu, u64 timestamp, struct thread *thread)
 {
-	struct raw_event_sample *raw = more_data;
 	struct event *event;
 	int type;
 
-	type = trace_parse_common_type(raw->data);
+
+	type = trace_parse_common_type(data);
 	event = trace_find_event(type);
 
 	if (!strcmp(event->name, "sched_switch"))
-		process_sched_switch_event(raw, event, cpu, timestamp, thread);
+		process_sched_switch_event(data, event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_stat_runtime"))
-		process_sched_runtime_event(raw, event, cpu, timestamp, thread);
+		process_sched_runtime_event(data, event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_wakeup"))
-		process_sched_wakeup_event(raw, event, cpu, timestamp, thread);
+		process_sched_wakeup_event(data, event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_wakeup_new"))
-		process_sched_wakeup_event(raw, event, cpu, timestamp, thread);
+		process_sched_wakeup_event(data, event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_process_fork"))
-		process_sched_fork_event(raw, event, cpu, timestamp, thread);
+		process_sched_fork_event(data, event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_process_exit"))
 		process_sched_exit_event(event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_migrate_task"))
-		process_sched_migrate_task_event(raw, event, cpu, timestamp, thread);
+		process_sched_migrate_task_event(data, event, cpu, timestamp, thread);
 }
 
 static int process_sample_event(event_t *event)
 {
+	struct sample_data data;
 	struct thread *thread;
-	u64 ip = event->ip.ip;
-	u64 timestamp = -1;
-	u32 cpu = -1;
-	u64 period = 1;
-	void *more_data = event->ip.__more_data;
 
 	if (!(sample_type & PERF_SAMPLE_RAW))
 		return 0;
 
-	thread = threads__findnew(event->ip.pid);
+	memset(&data, 0, sizeof(data));
+	data.time = -1;
+	data.cpu = -1;
+	data.period = -1;
 
-	if (sample_type & PERF_SAMPLE_TIME) {
-		timestamp = *(u64 *)more_data;
-		more_data += sizeof(u64);
-	}
-
-	if (sample_type & PERF_SAMPLE_CPU) {
-		cpu = *(u32 *)more_data;
-		more_data += sizeof(u32);
-		more_data += sizeof(u32); /* reserved */
-	}
-
-	if (sample_type & PERF_SAMPLE_PERIOD) {
-		period = *(u64 *)more_data;
-		more_data += sizeof(u64);
-	}
+	event__parse_sample(event, sample_type, &data);
 
 	dump_printf("(IP, %d): %d/%d: %p period: %Ld\n",
 		event->header.misc,
-		event->ip.pid, event->ip.tid,
-		(void *)(long)ip,
-		(long long)period);
+		data.pid, data.tid,
+		(void *)(long)data.ip,
+		(long long)data.period);
 
+	thread = threads__findnew(data.pid);
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
 			 event->header.type);
@@ -1640,10 +1624,10 @@ static int process_sample_event(event_t *event)
 
 	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
 
-	if (profile_cpu != -1 && profile_cpu != (int) cpu)
+	if (profile_cpu != -1 && profile_cpu != (int)data.cpu)
 		return 0;
 
-	process_raw_event(event, more_data, cpu, timestamp, thread);
+	process_raw_event(event, data.raw_data, data.cpu, data.time, thread);
 
 	return 0;
 }
@@ -1724,9 +1708,9 @@ static void __cmd_lat(void)
 	read_events();
 	sort_lat();
 
-	printf("\n -----------------------------------------------------------------------------------------\n");
-	printf("  Task                  |   Runtime ms  | Switches | Average delay ms | Maximum delay ms |\n");
-	printf(" -----------------------------------------------------------------------------------------\n");
+	printf("\n ---------------------------------------------------------------------------------------------------------------\n");
+	printf("  Task                  |   Runtime ms  | Switches | Average delay ms | Maximum delay ms | Maximum delay at     |\n");
+	printf(" ---------------------------------------------------------------------------------------------------------------\n");
 
 	next = rb_first(&sorted_atom_root);
 
@@ -1902,13 +1886,18 @@ static int __cmd_record(int argc, const char **argv)
 
 int cmd_sched(int argc, const char **argv, const char *prefix __used)
 {
-	symbol__init(0);
-
 	argc = parse_options(argc, argv, sched_options, sched_usage,
 			     PARSE_OPT_STOP_AT_NON_OPTION);
 	if (!argc)
 		usage_with_options(sched_usage, sched_options);
 
+	/*
+	 * Aliased to 'perf trace' for now:
+	 */
+	if (!strcmp(argv[0], "trace"))
+		return cmd_trace(argc, argv, prefix);
+
+	symbol__init(0);
 	if (!strncmp(argv[0], "rec", 3)) {
 		return __cmd_record(argc, argv);
 	} else if (!strncmp(argv[0], "lat", 3)) {
@@ -1932,11 +1921,6 @@ int cmd_sched(int argc, const char **argv, const char *prefix __used)
 				usage_with_options(replay_usage, replay_options);
 		}
 		__cmd_replay();
-	} else if (!strcmp(argv[0], "trace")) {
-		/*
-		 * Aliased to 'perf trace' for now:
-		 */
-		return cmd_trace(argc, argv, prefix);
 	} else {
 		usage_with_options(sched_usage, sched_options);
 	}
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index cb58b66..f472df9 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -302,12 +302,11 @@ process_exit_event(event_t *event)
 }
 
 struct trace_entry {
-	u32			size;
 	unsigned short		type;
 	unsigned char		flags;
 	unsigned char		preempt_count;
 	int			pid;
-	int			tgid;
+	int			lock_depth;
 };
 
 struct power_entry {
@@ -484,43 +483,22 @@ static void sched_switch(int cpu, u64 timestamp, struct trace_entry *te)
 static int
 process_sample_event(event_t *event)
 {
-	int cursor = 0;
-	u64 addr = 0;
-	u64 stamp = 0;
-	u32 cpu = 0;
-	u32 pid = 0;
+	struct sample_data data;
 	struct trace_entry *te;
 
-	if (sample_type & PERF_SAMPLE_IP)
-		cursor++;
-
-	if (sample_type & PERF_SAMPLE_TID) {
-		pid = event->sample.array[cursor]>>32;
-		cursor++;
-	}
-	if (sample_type & PERF_SAMPLE_TIME) {
-		stamp = event->sample.array[cursor++];
+	memset(&data, 0, sizeof(data));
 
-		if (!first_time || first_time > stamp)
-			first_time = stamp;
-		if (last_time < stamp)
-			last_time = stamp;
+	event__parse_sample(event, sample_type, &data);
 
+	if (sample_type & PERF_SAMPLE_TIME) {
+		if (!first_time || first_time > data.time)
+			first_time = data.time;
+		if (last_time < data.time)
+			last_time = data.time;
 	}
-	if (sample_type & PERF_SAMPLE_ADDR)
-		addr = event->sample.array[cursor++];
-	if (sample_type & PERF_SAMPLE_ID)
-		cursor++;
-	if (sample_type & PERF_SAMPLE_STREAM_ID)
-		cursor++;
-	if (sample_type & PERF_SAMPLE_CPU)
-		cpu = event->sample.array[cursor++] & 0xFFFFFFFF;
-	if (sample_type & PERF_SAMPLE_PERIOD)
-		cursor++;
-
-	te = (void *)&event->sample.array[cursor];
 
-	if (sample_type & PERF_SAMPLE_RAW && te->size > 0) {
+	te = (void *)data.raw_data;
+	if (sample_type & PERF_SAMPLE_RAW && data.raw_size > 0) {
 		char *event_str;
 		struct power_entry *pe;
 
@@ -532,19 +510,19 @@ process_sample_event(event_t *event)
 			return 0;
 
 		if (strcmp(event_str, "power:power_start") == 0)
-			c_state_start(cpu, stamp, pe->value);
+			c_state_start(data.cpu, data.time, pe->value);
 
 		if (strcmp(event_str, "power:power_end") == 0)
-			c_state_end(cpu, stamp);
+			c_state_end(data.cpu, data.time);
 
 		if (strcmp(event_str, "power:power_frequency") == 0)
-			p_state_change(cpu, stamp, pe->value);
+			p_state_change(data.cpu, data.time, pe->value);
 
 		if (strcmp(event_str, "sched:sched_wakeup") == 0)
-			sched_wakeup(cpu, stamp, pid, te);
+			sched_wakeup(data.cpu, data.time, data.pid, te);
 
 		if (strcmp(event_str, "sched:sched_switch") == 0)
-			sched_switch(cpu, stamp, te);
+			sched_switch(data.cpu, data.time, te);
 	}
 	return 0;
 }
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index abb914a..c2fcc34 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -66,58 +66,40 @@ static u64			sample_type;
 
 static int process_sample_event(event_t *event)
 {
-	u64 ip = event->ip.ip;
-	u64 timestamp = -1;
-	u32 cpu = -1;
-	u64 period = 1;
-	void *more_data = event->ip.__more_data;
-	struct thread *thread = threads__findnew(event->ip.pid);
-
-	if (sample_type & PERF_SAMPLE_TIME) {
-		timestamp = *(u64 *)more_data;
-		more_data += sizeof(u64);
-	}
+	struct sample_data data;
+	struct thread *thread;
 
-	if (sample_type & PERF_SAMPLE_CPU) {
-		cpu = *(u32 *)more_data;
-		more_data += sizeof(u32);
-		more_data += sizeof(u32); /* reserved */
-	}
+	memset(&data, 0, sizeof(data));
+	data.time = -1;
+	data.cpu = -1;
+	data.period = 1;
 
-	if (sample_type & PERF_SAMPLE_PERIOD) {
-		period = *(u64 *)more_data;
-		more_data += sizeof(u64);
-	}
+	event__parse_sample(event, sample_type, &data);
 
 	dump_printf("(IP, %d): %d/%d: %p period: %Ld\n",
 		event->header.misc,
-		event->ip.pid, event->ip.tid,
-		(void *)(long)ip,
-		(long long)period);
+		data.pid, data.tid,
+		(void *)(long)data.ip,
+		(long long)data.period);
 
+	thread = threads__findnew(event->ip.pid);
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
 			 event->header.type);
 		return -1;
 	}
 
-	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
-
 	if (sample_type & PERF_SAMPLE_RAW) {
-		struct {
-			u32 size;
-			char data[0];
-		} *raw = more_data;
-
 		/*
 		 * FIXME: better resolve from pid from the struct trace_entry
 		 * field, although it should be the same than this perf
 		 * event pid
 		 */
-		scripting_ops->process_event(cpu, raw->data, raw->size,
-					     timestamp, thread->comm);
+		scripting_ops->process_event(data.cpu, data.raw_data,
+					     data.raw_size,
+					     data.time, thread->comm);
 	}
-	event__stats.total += period;
+	event__stats.total += data.period;
 
 	return 0;
 }
diff --git a/tools/perf/util/data_map.c b/tools/perf/util/data_map.c
index ca0bedf..59b65d0 100644
--- a/tools/perf/util/data_map.c
+++ b/tools/perf/util/data_map.c
@@ -100,11 +100,11 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 	}
 }
 
-int perf_header__read_build_ids(int input, off_t offset, off_t size)
+int perf_header__read_build_ids(int input, u64 offset, u64 size)
 {
 	struct build_id_event bev;
 	char filename[PATH_MAX];
-	off_t limit = offset + size;
+	u64 limit = offset + size;
 	int err = -1;
 
 	while (offset < limit) {
diff --git a/tools/perf/util/data_map.h b/tools/perf/util/data_map.h
index 3180ff7..258a87b 100644
--- a/tools/perf/util/data_map.h
+++ b/tools/perf/util/data_map.h
@@ -27,6 +27,6 @@ int mmap_dispatch_perf_file(struct perf_header **pheader,
 			    int full_paths,
 			    int *cwdlen,
 			    char **cwd);
-int perf_header__read_build_ids(int input, off_t offset, off_t file_size);
+int perf_header__read_build_ids(int input, u64 offset, u64 file_size);
 
 #endif
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 414b89d..4dcecaf 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -310,3 +310,70 @@ int event__preprocess_sample(const event_t *self, struct addr_location *al,
 			al->level == 'H' ? "[hypervisor]" : "<not found>");
 	return 0;
 }
+
+int event__parse_sample(event_t *event, u64 type, struct sample_data *data)
+{
+	u64 *array = event->sample.array;
+
+	if (type & PERF_SAMPLE_IP) {
+		data->ip = event->ip.ip;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_TID) {
+		u32 *p = (u32 *)array;
+		data->pid = p[0];
+		data->tid = p[1];
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_TIME) {
+		data->time = *array;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_ADDR) {
+		data->addr = *array;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_ID) {
+		data->id = *array;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_STREAM_ID) {
+		data->stream_id = *array;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_CPU) {
+		u32 *p = (u32 *)array;
+		data->cpu = *p;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_PERIOD) {
+		data->period = *array;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_READ) {
+		pr_debug("PERF_SAMPLE_READ is unsuported for now\n");
+		return -1;
+	}
+
+	if (type & PERF_SAMPLE_CALLCHAIN) {
+		data->callchain = (struct ip_callchain *)array;
+		array += 1 + data->callchain->nr;
+	}
+
+	if (type & PERF_SAMPLE_RAW) {
+		u32 *p = (u32 *)array;
+		data->raw_size = *p;
+		p++;
+		data->raw_data = p;
+	}
+
+	return 0;
+}
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index a4cc810..c7a78ee 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -56,11 +56,25 @@ struct read_event {
 	u64 id;
 };
 
-struct sample_event{
+struct sample_event {
 	struct perf_event_header        header;
 	u64 array[];
 };
 
+struct sample_data {
+	u64 ip;
+	u32 pid, tid;
+	u64 time;
+	u64 addr;
+	u64 id;
+	u64 stream_id;
+	u32 cpu;
+	u64 period;
+	struct ip_callchain *callchain;
+	u32 raw_size;
+	void *raw_data;
+};
+
 #define BUILD_ID_SIZE 20
 
 struct build_id_event {
@@ -155,5 +169,6 @@ int event__process_task(event_t *self);
 struct addr_location;
 int event__preprocess_sample(const event_t *self, struct addr_location *al,
 			     symbol_filter_t filter);
+int event__parse_sample(event_t *event, u64 type, struct sample_data *data);
 
 #endif /* __PERF_RECORD_H */
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 4805e6d..59a9c0b 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -187,7 +187,9 @@ static int do_write(int fd, const void *buf, size_t size)
 
 static int __dsos__write_buildid_table(struct list_head *head, int fd)
 {
+#define NAME_ALIGN	64
 	struct dso *pos;
+	static const char zero_buf[NAME_ALIGN];
 
 	list_for_each_entry(pos, head, node) {
 		int err;
@@ -197,14 +199,17 @@ static int __dsos__write_buildid_table(struct list_head *head, int fd)
 		if (!pos->has_build_id)
 			continue;
 		len = pos->long_name_len + 1;
-		len = ALIGN(len, 64);
+		len = ALIGN(len, NAME_ALIGN);
 		memset(&b, 0, sizeof(b));
 		memcpy(&b.build_id, pos->build_id, sizeof(pos->build_id));
 		b.header.size = sizeof(b) + len;
 		err = do_write(fd, &b, sizeof(b));
 		if (err < 0)
 			return err;
-		err = do_write(fd, pos->long_name, len);
+		err = do_write(fd, pos->long_name, pos->long_name_len + 1);
+		if (err < 0)
+			return err;
+		err = do_write(fd, zero_buf, len - pos->long_name_len - 1);
 		if (err < 0)
 			return err;
 	}
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 9e5dbd6..e5bc0fb 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -197,7 +197,7 @@ struct tracepoint_path *tracepoint_id_to_path(u64 config)
 			if (id == config) {
 				closedir(evt_dir);
 				closedir(sys_dir);
-				path = zalloc(sizeof(path));
+				path = zalloc(sizeof(*path));
 				path->system = malloc(MAX_EVENT_LENGTH);
 				if (!path->system) {
 					free(path);
@@ -467,7 +467,6 @@ parse_subsystem_tracepoint_event(char *sys_name, char *flags)
 	while ((evt_ent = readdir(evt_dir))) {
 		char event_opt[MAX_EVOPT_LEN + 1];
 		int len;
-		unsigned int rem = MAX_EVOPT_LEN;
 
 		if (!strcmp(evt_ent->d_name, ".")
 		    || !strcmp(evt_ent->d_name, "..")
@@ -475,20 +474,12 @@ parse_subsystem_tracepoint_event(char *sys_name, char *flags)
 		    || !strcmp(evt_ent->d_name, "filter"))
 			continue;
 
-		len = snprintf(event_opt, MAX_EVOPT_LEN, "%s:%s", sys_name,
-			       evt_ent->d_name);
+		len = snprintf(event_opt, MAX_EVOPT_LEN, "%s:%s%s%s", sys_name,
+			       evt_ent->d_name, flags ? ":" : "",
+			       flags ?: "");
 		if (len < 0)
 			return EVT_FAILED;
 
-		rem -= len;
-		if (flags) {
-			if (rem < strlen(flags) + 1)
-				return EVT_FAILED;
-
-			strcat(event_opt, ":");
-			strcat(event_opt, flags);
-		}
-
 		if (parse_events(NULL, event_opt, 0))
 			return EVT_FAILED;
 	}
diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
index 6d8af48..efebd5b 100644
--- a/tools/perf/util/parse-options.c
+++ b/tools/perf/util/parse-options.c
@@ -430,6 +430,9 @@ int usage_with_options_internal(const char * const *usagestr,
 		pos = fprintf(stderr, "    ");
 		if (opts->short_name)
 			pos += fprintf(stderr, "-%c", opts->short_name);
+		else
+			pos += fprintf(stderr, "    ");
+
 		if (opts->long_name && opts->short_name)
 			pos += fprintf(stderr, ", ");
 		if (opts->long_name)
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index cd7fbda..d14a458 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -48,6 +48,9 @@
 
 /* If there is no space to write, returns -E2BIG. */
 static int e_snprintf(char *str, size_t size, const char *format, ...)
+	__attribute__((format(printf, 3, 4)));
+
+static int e_snprintf(char *str, size_t size, const char *format, ...)
 {
 	int ret;
 	va_list ap;
@@ -258,7 +261,7 @@ int synthesize_perf_probe_event(struct probe_point *pp)
 		ret = e_snprintf(buf, MAX_CMDLEN, "%s%s%s%s", pp->function,
 				 offs, pp->retprobe ? "%return" : "", line);
 	else
-		ret = e_snprintf(buf, MAX_CMDLEN, "%s%s%s%s", pp->file, line);
+		ret = e_snprintf(buf, MAX_CMDLEN, "%s%s", pp->file, line);
 	if (ret <= 0)
 		goto error;
 	len = ret;
@@ -373,14 +376,32 @@ static void clear_probe_point(struct probe_point *pp)
 		free(pp->args);
 	for (i = 0; i < pp->found; i++)
 		free(pp->probes[i]);
-	memset(pp, 0, sizeof(pp));
+	memset(pp, 0, sizeof(*pp));
+}
+
+/* Show an event */
+static void show_perf_probe_event(const char *group, const char *event,
+				  const char *place, struct probe_point *pp)
+{
+	int i;
+	char buf[128];
+
+	e_snprintf(buf, 128, "%s:%s", group, event);
+	printf("  %-40s (on %s", buf, place);
+
+	if (pp->nr_args > 0) {
+		printf(" with");
+		for (i = 0; i < pp->nr_args; i++)
+			printf(" %s", pp->args[i]);
+	}
+	printf(")\n");
 }
 
 /* List up current perf-probe events */
 void show_perf_probe_events(void)
 {
 	unsigned int i;
-	int fd;
+	int fd, nr;
 	char *group, *event;
 	struct probe_point pp;
 	struct strlist *rawlist;
@@ -393,8 +414,13 @@ void show_perf_probe_events(void)
 	for (i = 0; i < strlist__nr_entries(rawlist); i++) {
 		ent = strlist__entry(rawlist, i);
 		parse_trace_kprobe_event(ent->s, &group, &event, &pp);
+		/* Synthesize only event probe point */
+		nr = pp.nr_args;
+		pp.nr_args = 0;
 		synthesize_perf_probe_event(&pp);
-		printf("[%s:%s]\t%s\n", group, event, pp.probes[0]);
+		pp.nr_args = nr;
+		/* Show an event */
+		show_perf_probe_event(group, event, pp.probes[0], &pp);
 		free(group);
 		free(event);
 		clear_probe_point(&pp);
@@ -404,21 +430,28 @@ void show_perf_probe_events(void)
 }
 
 /* Get current perf-probe event names */
-static struct strlist *get_perf_event_names(int fd)
+static struct strlist *get_perf_event_names(int fd, bool include_group)
 {
 	unsigned int i;
 	char *group, *event;
+	char buf[128];
 	struct strlist *sl, *rawlist;
 	struct str_node *ent;
 
 	rawlist = get_trace_kprobe_event_rawlist(fd);
 
-	sl = strlist__new(false, NULL);
+	sl = strlist__new(true, NULL);
 	for (i = 0; i < strlist__nr_entries(rawlist); i++) {
 		ent = strlist__entry(rawlist, i);
 		parse_trace_kprobe_event(ent->s, &group, &event, NULL);
-		strlist__add(sl, event);
+		if (include_group) {
+			if (e_snprintf(buf, 128, "%s:%s", group, event) < 0)
+				die("Failed to copy group:event name.");
+			strlist__add(sl, buf);
+		} else
+			strlist__add(sl, event);
 		free(group);
+		free(event);
 	}
 
 	strlist__delete(rawlist);
@@ -426,24 +459,30 @@ static struct strlist *get_perf_event_names(int fd)
 	return sl;
 }
 
-static int write_trace_kprobe_event(int fd, const char *buf)
+static void write_trace_kprobe_event(int fd, const char *buf)
 {
 	int ret;
 
+	pr_debug("Writing event: %s\n", buf);
 	ret = write(fd, buf, strlen(buf));
 	if (ret <= 0)
-		die("Failed to create event.");
-	else
-		printf("Added new event: %s\n", buf);
-
-	return ret;
+		die("Failed to write event: %s", strerror(errno));
 }
 
 static void get_new_event_name(char *buf, size_t len, const char *base,
 			       struct strlist *namelist)
 {
 	int i, ret;
-	for (i = 0; i < MAX_EVENT_INDEX; i++) {
+
+	/* Try no suffix */
+	ret = e_snprintf(buf, len, "%s", base);
+	if (ret < 0)
+		die("snprintf() failed: %s", strerror(-ret));
+	if (!strlist__has_entry(namelist, buf))
+		return;
+
+	/* Try to add suffix */
+	for (i = 1; i < MAX_EVENT_INDEX; i++) {
 		ret = e_snprintf(buf, len, "%s_%d", base, i);
 		if (ret < 0)
 			die("snprintf() failed: %s", strerror(-ret));
@@ -464,7 +503,7 @@ void add_trace_kprobe_events(struct probe_point *probes, int nr_probes)
 
 	fd = open_kprobe_events(O_RDWR, O_APPEND);
 	/* Get current event names */
-	namelist = get_perf_event_names(fd);
+	namelist = get_perf_event_names(fd, false);
 
 	for (j = 0; j < nr_probes; j++) {
 		pp = probes + j;
@@ -476,9 +515,73 @@ void add_trace_kprobe_events(struct probe_point *probes, int nr_probes)
 				 PERFPROBE_GROUP, event,
 				 pp->probes[i]);
 			write_trace_kprobe_event(fd, buf);
+			printf("Added new event:\n");
+			/* Get the first parameter (probe-point) */
+			sscanf(pp->probes[i], "%s", buf);
+			show_perf_probe_event(PERFPROBE_GROUP, event,
+					      buf, pp);
 			/* Add added event name to namelist */
 			strlist__add(namelist, event);
 		}
 	}
+	/* Show how to use the event. */
+	printf("\nYou can now use it on all perf tools, such as:\n\n");
+	printf("\tperf record -e %s:%s -a sleep 1\n\n", PERFPROBE_GROUP, event);
+
+	strlist__delete(namelist);
+	close(fd);
+}
+
+static void del_trace_kprobe_event(int fd, const char *group,
+				   const char *event, struct strlist *namelist)
+{
+	char buf[128];
+
+	if (e_snprintf(buf, 128, "%s:%s", group, event) < 0)
+		die("Failed to copy event.");
+	if (!strlist__has_entry(namelist, buf)) {
+		pr_warning("Warning: event \"%s\" is not found.\n", buf);
+		return;
+	}
+	/* Convert from perf-probe event to trace-kprobe event */
+	if (e_snprintf(buf, 128, "-:%s/%s", group, event) < 0)
+		die("Failed to copy event.");
+
+	write_trace_kprobe_event(fd, buf);
+	printf("Remove event: %s:%s\n", group, event);
+}
+
+void del_trace_kprobe_events(struct strlist *dellist)
+{
+	int fd;
+	unsigned int i;
+	const char *group, *event;
+	char *p, *str;
+	struct str_node *ent;
+	struct strlist *namelist;
+
+	fd = open_kprobe_events(O_RDWR, O_APPEND);
+	/* Get current event names */
+	namelist = get_perf_event_names(fd, true);
+
+	for (i = 0; i < strlist__nr_entries(dellist); i++) {
+		ent = strlist__entry(dellist, i);
+		str = strdup(ent->s);
+		if (!str)
+			die("Failed to copy event.");
+		p = strchr(str, ':');
+		if (p) {
+			group = str;
+			*p = '\0';
+			event = p + 1;
+		} else {
+			group = PERFPROBE_GROUP;
+			event = str;
+		}
+		del_trace_kprobe_event(fd, group, event, namelist);
+		free(str);
+	}
+	strlist__delete(namelist);
 	close(fd);
 }
+
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 0c6fe56..f752159 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -10,6 +10,7 @@ extern void parse_trace_kprobe_event(const char *str, char **group,
 				     char **event, struct probe_point *pp);
 extern int synthesize_trace_kprobe_event(struct probe_point *pp);
 extern void add_trace_kprobe_events(struct probe_point *probes, int nr_probes);
+extern void del_trace_kprobe_events(struct strlist *dellist);
 extern void show_perf_probe_events(void);
 
 /* Maximum index number of event-name postfix */
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 293cdfc..4585f1d 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -106,7 +106,7 @@ static int strtailcmp(const char *s1, const char *s2)
 {
 	int i1 = strlen(s1);
 	int i2 = strlen(s2);
-	while (--i1 > 0 && --i2 > 0) {
+	while (--i1 >= 0 && --i2 >= 0) {
 		if (s1[i1] != s2[i2])
 			return s1[i1] - s2[i2];
 	}
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index fffcb93..e7508ad 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -938,8 +938,9 @@ static bool __dsos__read_build_ids(struct list_head *head)
 
 bool dsos__read_build_ids(void)
 {
-	return __dsos__read_build_ids(&dsos__kernel) ||
-	       __dsos__read_build_ids(&dsos__user);
+	bool kbuildids = __dsos__read_build_ids(&dsos__kernel),
+	     ubuildids = __dsos__read_build_ids(&dsos__user);
+	return kbuildids || ubuildids;
 }
 
 /*
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 0302405..c5c32be 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -177,7 +177,7 @@ void parse_proc_kallsyms(char *file, unsigned int size __unused)
 		func_count++;
 	}
 
-	func_list = malloc_or_die(sizeof(*func_list) * func_count + 1);
+	func_list = malloc_or_die(sizeof(*func_list) * (func_count + 1));
 
 	i = 0;
 	while (list) {
@@ -1477,7 +1477,7 @@ process_fields(struct event *event, struct print_flag_sym **list, char **tok)
 			goto out_free;
 
 		field = malloc_or_die(sizeof(*field));
-		memset(field, 0, sizeof(field));
+		memset(field, 0, sizeof(*field));
 
 		value = arg_eval(arg);
 		field->value = strdup(value);
diff --git a/tools/perf/util/trace-event-perl.c b/tools/perf/util/trace-event-perl.c
index 51e833f..a5ffe60 100644
--- a/tools/perf/util/trace-event-perl.c
+++ b/tools/perf/util/trace-event-perl.c
@@ -32,9 +32,6 @@
 
 void xs_init(pTHX);
 
-void boot_Perf__Trace__Context(pTHX_ CV *cv);
-void boot_DynaLoader(pTHX_ CV *cv);
-
 void xs_init(pTHX)
 {
 	const char *file = __FILE__;
@@ -573,26 +570,72 @@ struct scripting_ops perl_scripting_ops = {
 	.generate_script = perl_generate_script,
 };
 
-#ifdef NO_LIBPERL
-void setup_perl_scripting(void)
+static void print_unsupported_msg(void)
 {
 	fprintf(stderr, "Perl scripting not supported."
-		"  Install libperl and rebuild perf to enable it.  e.g. "
-		"apt-get install libperl-dev (ubuntu), yum install "
-		"perl-ExtUtils-Embed (Fedora), etc.\n");
+		"  Install libperl and rebuild perf to enable it.\n"
+		"For example:\n  # apt-get install libperl-dev (ubuntu)"
+		"\n  # yum install perl-ExtUtils-Embed (Fedora)"
+		"\n  etc.\n");
 }
-#else
-void setup_perl_scripting(void)
+
+static int perl_start_script_unsupported(const char *script __unused)
+{
+	print_unsupported_msg();
+
+	return -1;
+}
+
+static int perl_stop_script_unsupported(void)
+{
+	return 0;
+}
+
+static void perl_process_event_unsupported(int cpu __unused,
+					   void *data __unused,
+					   int size __unused,
+					   unsigned long long nsecs __unused,
+					   char *comm __unused)
+{
+}
+
+static int perl_generate_script_unsupported(const char *outfile __unused)
+{
+	print_unsupported_msg();
+
+	return -1;
+}
+
+struct scripting_ops perl_scripting_unsupported_ops = {
+	.name = "Perl",
+	.start_script = perl_start_script_unsupported,
+	.stop_script = perl_stop_script_unsupported,
+	.process_event = perl_process_event_unsupported,
+	.generate_script = perl_generate_script_unsupported,
+};
+
+static void register_perl_scripting(struct scripting_ops *scripting_ops)
 {
 	int err;
-	err = script_spec_register("Perl", &perl_scripting_ops);
+	err = script_spec_register("Perl", scripting_ops);
 	if (err)
 		die("error registering Perl script extension");
 
-	err = script_spec_register("pl", &perl_scripting_ops);
+	err = script_spec_register("pl", scripting_ops);
 	if (err)
 		die("error registering pl script extension");
 
 	scripting_context = malloc(sizeof(struct scripting_context));
 }
+
+#ifdef NO_LIBPERL
+void setup_perl_scripting(void)
+{
+	register_perl_scripting(&perl_scripting_unsupported_ops);
+}
+#else
+void setup_perl_scripting(void)
+{
+	register_perl_scripting(&perl_scripting_ops);
+}
 #endif
diff --git a/tools/perf/util/trace-event-perl.h b/tools/perf/util/trace-event-perl.h
index 8fe0d86..e88fb26 100644
--- a/tools/perf/util/trace-event-perl.h
+++ b/tools/perf/util/trace-event-perl.h
@@ -34,9 +34,13 @@ typedef int INTERP;
 #define dXSUB_SYS
 #define pTHX_
 static inline void newXS(const char *a, void *b, const char *c) {}
+static void boot_Perf__Trace__Context(pTHX_ CV *cv) {}
+static void boot_DynaLoader(pTHX_ CV *cv) {}
 #else
 #include <EXTERN.h>
 #include <perl.h>
+void boot_Perf__Trace__Context(pTHX_ CV *cv);
+void boot_DynaLoader(pTHX_ CV *cv);
 typedef PerlInterpreter * INTERP;
 #endif
 
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index 342dfdd..1744422 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -145,8 +145,9 @@ static void read_proc_kallsyms(void)
 	if (!size)
 		return;
 
-	buf = malloc_or_die(size);
+	buf = malloc_or_die(size + 1);
 	read_or_die(buf, size);
+	buf[size] = '\0';
 
 	parse_proc_kallsyms(buf, size);
 
