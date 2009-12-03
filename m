Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbZLCTIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbZLCTIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 14:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756694AbZLCTId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 14:08:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33374 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756693AbZLCTIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 14:08:30 -0500
Date: Thu, 3 Dec 2009 20:08:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] tracing updates for v2.6.33
Message-ID: <20091203190816.GA8785@elte.hu>
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

Please pull the latest tracing-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-core-for-linus

Highlights:

 - filter engine updates

 - bkl-locking events

 - various cleanups and other updates

there's also a generic change that adds __always_unused:

 include/linux/compiler-gcc.h          |    1 +
 include/linux/compiler.h              |    4 +

Thanks,

	Ingo

------------------>
Ananth N Mavinakayanahalli (1):
      kprobes: Sanitize struct kretprobe_instance allocations

Frederic Weisbecker (12):
      tracing/bkl: Add bkl ftrace events
      tracing/filters: Cleanup useless headers
      tracing/event: Cleanup the useless dentry variable
      tracing/filters: Provide basic regex support
      tracing/filters: Unify the regex parsing helpers
      tracing: Pushdown the bkl tracepoints calls
      tracing: Rename set_ftrace to set_bootup_ftrace
      tracing: Remove unused ftrace_trace_addr helper
      tracing: Move syscalls metadata handling from arch to core
      tracing: Document HAVE_SYSCALL_TRACEPOINTS needs
      ftrace: Copy ftrace_graph_filter boot param using strlcpy
      ftrace: Rename set_bootup_ftrace into set_cmdline_ftrace

Ingo Molnar (2):
      ring-buffer benchmark: Run producer/consumer threads at nice +19
      tracing, function tracer: Clean up strstrip() usage

Jiri Olsa (2):
      tracing: Enable records during the module load
      tracing: Enable "__cold" functions

Joe Perches (2):
      ftrace.c: Add #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
      testmmiotrace.c: Add and use pr_fmt(fmt)

Josh Stone (1):
      tracing: Remove the stale include/trace/power.h

Lai Jiangshan (2):
      tracing: Prevent build warning: 'ftrace_graph_buf' defined but not used
      tracing: Separate raw syscall from syscall tracer

Li Hong (8):
      tracing: Amend documentation in recordmcount.pl to reflect implementation
      tracing: Correct the check for number of arguments in recordmcount.pl
      tracing: Check absolute path of input file in recordmcount.pl
      tracing: Fix objcopy revision check in recordmcount.pl
      tracing: Move mcount section search to front of loop in recordmcount.pl
      tracing: Add regex for weak functions in recordmcount.pl
      tracing: Move conditional into update_funcs() in recordmcount.pl
      tracing: Exit with error if a weak function is used in recordmcount.pl

Li Zefan (2):
      compiler: Introduce __always_unused
      tracing: Fix to use __always_unused attribute

Stefan Assmann (1):
      ftrace: add kernel command line graph function filtering

Steven Rostedt (6):
      function-graph/x86: Replace unbalanced ret with jmp
      ring-buffer: Add multiple iterations between benchmark timestamps
      tracing: do not disable interrupts for trace_clock_local
      ring-buffer: Move access to commit_page up into function used
      tracing: Only print objcopy version warning once from recordmcount
      ring-buffer-benchmark: Add parameters to set produce/consumer priorities

jolsa@redhat.com (1):
      tracing: Support multiple pids in set_pid_ftrace file


 Documentation/kernel-parameters.txt   |    7 +
 Documentation/trace/ftrace-design.txt |   13 +-
 Makefile                              |    1 +
 arch/s390/kernel/ftrace.c             |   67 +------
 arch/x86/kernel/entry_32.S            |    7 +-
 arch/x86/kernel/entry_64.S            |    6 +-
 arch/x86/kernel/ftrace.c              |   84 +-------
 arch/x86/mm/testmmiotrace.c           |   29 ++--
 include/linux/compiler-gcc.h          |    1 +
 include/linux/compiler.h              |    4 +
 include/linux/smp_lock.h              |   21 ++-
 include/trace/events/bkl.h            |   61 ++++++
 include/trace/events/syscalls.h       |    3 +-
 include/trace/power.h                 |   32 ---
 include/trace/syscall.h               |    2 +-
 kernel/kprobes.c                      |    4 +-
 kernel/trace/ftrace.c                 |  375 +++++++++++++++++++++------------
 kernel/trace/ring_buffer.c            |    9 +-
 kernel/trace/ring_buffer_benchmark.c  |   85 +++++++-
 kernel/trace/trace.c                  |    4 +-
 kernel/trace/trace.h                  |   44 +++--
 kernel/trace/trace_clock.c            |    8 +-
 kernel/trace/trace_events.c           |   23 +-
 kernel/trace/trace_events_filter.c    |  155 ++++++++++++--
 kernel/trace/trace_export.c           |    4 +-
 kernel/trace/trace_syscalls.c         |   86 ++++++++
 lib/kernel_lock.c                     |   20 ++-
 scripts/recordmcount.pl               |  219 +++++++++++---------
 28 files changed, 856 insertions(+), 518 deletions(-)
 create mode 100644 include/trace/events/bkl.h
 delete mode 100644 include/trace/power.h

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9107b38..c8d1b2b 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -779,6 +779,13 @@ and is between 256 and 4096 characters. It is defined in the file
 			by the set_ftrace_notrace file in the debugfs
 			tracing directory.
 
+	ftrace_graph_filter=[function-list]
+			[FTRACE] Limit the top level callers functions traced
+			by the function graph tracer at boot up.
+			function-list is a comma separated list of functions
+			that can be changed at run time by the
+			set_graph_function file in the debugfs tracing directory.
+
 	gamecon.map[2|3]=
 			[HW,JOY] Multisystem joystick and NES/SNES/PSX pad
 			support via parallel port (up to 5 devices per port)
diff --git a/Documentation/trace/ftrace-design.txt b/Documentation/trace/ftrace-design.txt
index 7003e10..641a1ef 100644
--- a/Documentation/trace/ftrace-design.txt
+++ b/Documentation/trace/ftrace-design.txt
@@ -213,10 +213,19 @@ If you can't trace NMI functions, then skip this option.
 <details to be filled>
 
 
-HAVE_FTRACE_SYSCALLS
+HAVE_SYSCALL_TRACEPOINTS
 ---------------------
 
-<details to be filled>
+You need very few things to get the syscalls tracing in an arch.
+
+- Have a NR_syscalls variable in <asm/unistd.h> that provides the number
+  of syscalls supported by the arch.
+- Implement arch_syscall_addr() that resolves a syscall address from a
+  syscall number.
+- Support the TIF_SYSCALL_TRACEPOINT thread flags
+- Put the trace_sys_enter() and trace_sys_exit() tracepoints calls from ptrace
+  in the ptrace syscalls tracing path.
+- Tag this arch as HAVE_SYSCALL_TRACEPOINTS.
 
 
 HAVE_FTRACE_MCOUNT_RECORD
diff --git a/Makefile b/Makefile
index 9425d1d..1c949ac 100644
--- a/Makefile
+++ b/Makefile
@@ -379,6 +379,7 @@ export RCS_TAR_IGNORE := --exclude SCCS --exclude BitKeeper --exclude .svn --exc
 PHONY += scripts_basic
 scripts_basic:
 	$(Q)$(MAKE) $(build)=scripts/basic
+	$(Q)rm -f .tmp_quiet_recordmcount
 
 # To avoid any implicit rule to kick in, define an empty command.
 scripts/basic/%: scripts_basic ;
diff --git a/arch/s390/kernel/ftrace.c b/arch/s390/kernel/ftrace.c
index f5fe34d..5a82bc6 100644
--- a/arch/s390/kernel/ftrace.c
+++ b/arch/s390/kernel/ftrace.c
@@ -203,73 +203,10 @@ out:
 
 #ifdef CONFIG_FTRACE_SYSCALLS
 
-extern unsigned long __start_syscalls_metadata[];
-extern unsigned long __stop_syscalls_metadata[];
 extern unsigned int sys_call_table[];
 
-static struct syscall_metadata **syscalls_metadata;
-
-struct syscall_metadata *syscall_nr_to_meta(int nr)
-{
-	if (!syscalls_metadata || nr >= NR_syscalls || nr < 0)
-		return NULL;
-
-	return syscalls_metadata[nr];
-}
-
-int syscall_name_to_nr(char *name)
-{
-	int i;
-
-	if (!syscalls_metadata)
-		return -1;
-	for (i = 0; i < NR_syscalls; i++)
-		if (syscalls_metadata[i])
-			if (!strcmp(syscalls_metadata[i]->name, name))
-				return i;
-	return -1;
-}
-
-void set_syscall_enter_id(int num, int id)
-{
-	syscalls_metadata[num]->enter_id = id;
-}
-
-void set_syscall_exit_id(int num, int id)
+unsigned long __init arch_syscall_addr(int nr)
 {
-	syscalls_metadata[num]->exit_id = id;
-}
-
-static struct syscall_metadata *find_syscall_meta(unsigned long syscall)
-{
-	struct syscall_metadata *start;
-	struct syscall_metadata *stop;
-	char str[KSYM_SYMBOL_LEN];
-
-	start = (struct syscall_metadata *)__start_syscalls_metadata;
-	stop = (struct syscall_metadata *)__stop_syscalls_metadata;
-	kallsyms_lookup(syscall, NULL, NULL, NULL, str);
-
-	for ( ; start < stop; start++) {
-		if (start->name && !strcmp(start->name + 3, str + 3))
-			return start;
-	}
-	return NULL;
-}
-
-static int __init arch_init_ftrace_syscalls(void)
-{
-	struct syscall_metadata *meta;
-	int i;
-	syscalls_metadata = kzalloc(sizeof(*syscalls_metadata) * NR_syscalls,
-				    GFP_KERNEL);
-	if (!syscalls_metadata)
-		return -ENOMEM;
-	for (i = 0; i < NR_syscalls; i++) {
-		meta = find_syscall_meta((unsigned long)sys_call_table[i]);
-		syscalls_metadata[i] = meta;
-	}
-	return 0;
+	return (unsigned long)sys_call_table[nr];
 }
-arch_initcall(arch_init_ftrace_syscalls);
 #endif
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index c097e7d..7d52e9d 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1185,17 +1185,14 @@ END(ftrace_graph_caller)
 
 .globl return_to_handler
 return_to_handler:
-	pushl $0
 	pushl %eax
-	pushl %ecx
 	pushl %edx
 	movl %ebp, %eax
 	call ftrace_return_to_handler
-	movl %eax, 0xc(%esp)
+	movl %eax, %ecx
 	popl %edx
-	popl %ecx
 	popl %eax
-	ret
+	jmp *%ecx
 #endif
 
 .section .rodata,"a"
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index b5c061f..bd5bbdd 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -155,11 +155,11 @@ GLOBAL(return_to_handler)
 
 	call ftrace_return_to_handler
 
-	movq %rax, 16(%rsp)
+	movq %rax, %rdi
 	movq 8(%rsp), %rdx
 	movq (%rsp), %rax
-	addq $16, %rsp
-	retq
+	addq $24, %rsp
+	jmp *%rdi
 #endif
 
 
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 9dbb527..5a1b975 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -9,6 +9,8 @@
  * the dangers of modifying code on the run.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/spinlock.h>
 #include <linux/hardirq.h>
 #include <linux/uaccess.h>
@@ -336,15 +338,15 @@ int __init ftrace_dyn_arch_init(void *data)
 
 	switch (faulted) {
 	case 0:
-		pr_info("ftrace: converting mcount calls to 0f 1f 44 00 00\n");
+		pr_info("converting mcount calls to 0f 1f 44 00 00\n");
 		memcpy(ftrace_nop, ftrace_test_p6nop, MCOUNT_INSN_SIZE);
 		break;
 	case 1:
-		pr_info("ftrace: converting mcount calls to 66 66 66 66 90\n");
+		pr_info("converting mcount calls to 66 66 66 66 90\n");
 		memcpy(ftrace_nop, ftrace_test_nop5, MCOUNT_INSN_SIZE);
 		break;
 	case 2:
-		pr_info("ftrace: converting mcount calls to jmp . + 5\n");
+		pr_info("converting mcount calls to jmp . + 5\n");
 		memcpy(ftrace_nop, ftrace_test_jmp, MCOUNT_INSN_SIZE);
 		break;
 	}
@@ -468,82 +470,10 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
 
 #ifdef CONFIG_FTRACE_SYSCALLS
 
-extern unsigned long __start_syscalls_metadata[];
-extern unsigned long __stop_syscalls_metadata[];
 extern unsigned long *sys_call_table;
 
-static struct syscall_metadata **syscalls_metadata;
-
-static struct syscall_metadata *find_syscall_meta(unsigned long *syscall)
-{
-	struct syscall_metadata *start;
-	struct syscall_metadata *stop;
-	char str[KSYM_SYMBOL_LEN];
-
-
-	start = (struct syscall_metadata *)__start_syscalls_metadata;
-	stop = (struct syscall_metadata *)__stop_syscalls_metadata;
-	kallsyms_lookup((unsigned long) syscall, NULL, NULL, NULL, str);
-
-	for ( ; start < stop; start++) {
-		if (start->name && !strcmp(start->name, str))
-			return start;
-	}
-	return NULL;
-}
-
-struct syscall_metadata *syscall_nr_to_meta(int nr)
-{
-	if (!syscalls_metadata || nr >= NR_syscalls || nr < 0)
-		return NULL;
-
-	return syscalls_metadata[nr];
-}
-
-int syscall_name_to_nr(char *name)
+unsigned long __init arch_syscall_addr(int nr)
 {
-	int i;
-
-	if (!syscalls_metadata)
-		return -1;
-
-	for (i = 0; i < NR_syscalls; i++) {
-		if (syscalls_metadata[i]) {
-			if (!strcmp(syscalls_metadata[i]->name, name))
-				return i;
-		}
-	}
-	return -1;
-}
-
-void set_syscall_enter_id(int num, int id)
-{
-	syscalls_metadata[num]->enter_id = id;
-}
-
-void set_syscall_exit_id(int num, int id)
-{
-	syscalls_metadata[num]->exit_id = id;
-}
-
-static int __init arch_init_ftrace_syscalls(void)
-{
-	int i;
-	struct syscall_metadata *meta;
-	unsigned long **psys_syscall_table = &sys_call_table;
-
-	syscalls_metadata = kzalloc(sizeof(*syscalls_metadata) *
-					NR_syscalls, GFP_KERNEL);
-	if (!syscalls_metadata) {
-		WARN_ON(1);
-		return -ENOMEM;
-	}
-
-	for (i = 0; i < NR_syscalls; i++) {
-		meta = find_syscall_meta(psys_syscall_table[i]);
-		syscalls_metadata[i] = meta;
-	}
-	return 0;
+	return (unsigned long)(&sys_call_table)[nr];
 }
-arch_initcall(arch_init_ftrace_syscalls);
 #endif
diff --git a/arch/x86/mm/testmmiotrace.c b/arch/x86/mm/testmmiotrace.c
index 427fd1b..8565d94 100644
--- a/arch/x86/mm/testmmiotrace.c
+++ b/arch/x86/mm/testmmiotrace.c
@@ -1,12 +1,13 @@
 /*
  * Written by Pekka Paalanen, 2008-2009 <pq@iki.fi>
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/io.h>
 #include <linux/mmiotrace.h>
 
-#define MODULE_NAME "testmmiotrace"
-
 static unsigned long mmio_address;
 module_param(mmio_address, ulong, 0);
 MODULE_PARM_DESC(mmio_address, " Start address of the mapping of 16 kB "
@@ -30,7 +31,7 @@ static unsigned v32(unsigned i)
 static void do_write_test(void __iomem *p)
 {
 	unsigned int i;
-	pr_info(MODULE_NAME ": write test.\n");
+	pr_info("write test.\n");
 	mmiotrace_printk("Write test.\n");
 
 	for (i = 0; i < 256; i++)
@@ -47,7 +48,7 @@ static void do_read_test(void __iomem *p)
 {
 	unsigned int i;
 	unsigned errs[3] = { 0 };
-	pr_info(MODULE_NAME ": read test.\n");
+	pr_info("read test.\n");
 	mmiotrace_printk("Read test.\n");
 
 	for (i = 0; i < 256; i++)
@@ -68,7 +69,7 @@ static void do_read_test(void __iomem *p)
 
 static void do_read_far_test(void __iomem *p)
 {
-	pr_info(MODULE_NAME ": read far test.\n");
+	pr_info("read far test.\n");
 	mmiotrace_printk("Read far test.\n");
 
 	ioread32(p + read_far);
@@ -78,7 +79,7 @@ static void do_test(unsigned long size)
 {
 	void __iomem *p = ioremap_nocache(mmio_address, size);
 	if (!p) {
-		pr_err(MODULE_NAME ": could not ioremap, aborting.\n");
+		pr_err("could not ioremap, aborting.\n");
 		return;
 	}
 	mmiotrace_printk("ioremap returned %p.\n", p);
@@ -94,24 +95,22 @@ static int __init init(void)
 	unsigned long size = (read_far) ? (8 << 20) : (16 << 10);
 
 	if (mmio_address == 0) {
-		pr_err(MODULE_NAME ": you have to use the module argument "
-							"mmio_address.\n");
-		pr_err(MODULE_NAME ": DO NOT LOAD THIS MODULE UNLESS"
-				" YOU REALLY KNOW WHAT YOU ARE DOING!\n");
+		pr_err("you have to use the module argument mmio_address.\n");
+		pr_err("DO NOT LOAD THIS MODULE UNLESS YOU REALLY KNOW WHAT YOU ARE DOING!\n");
 		return -ENXIO;
 	}
 
-	pr_warning(MODULE_NAME ": WARNING: mapping %lu kB @ 0x%08lx in PCI "
-		"address space, and writing 16 kB of rubbish in there.\n",
-		 size >> 10, mmio_address);
+	pr_warning("WARNING: mapping %lu kB @ 0x%08lx in PCI address space, "
+		   "and writing 16 kB of rubbish in there.\n",
+		   size >> 10, mmio_address);
 	do_test(size);
-	pr_info(MODULE_NAME ": All done.\n");
+	pr_info("All done.\n");
 	return 0;
 }
 
 static void __exit cleanup(void)
 {
-	pr_debug(MODULE_NAME ": unloaded.\n");
+	pr_debug("unloaded.\n");
 }
 
 module_init(init);
diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index a3ed7cb..73dcf80 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -79,6 +79,7 @@
 #define  noinline			__attribute__((noinline))
 #define __attribute_const__		__attribute__((__const__))
 #define __maybe_unused			__attribute__((unused))
+#define __always_unused			__attribute__((unused))
 
 #define __gcc_header(x) #x
 #define _gcc_header(x) __gcc_header(linux/compiler-gcc##x.h)
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 04fb513..7947f4f 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -213,6 +213,10 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 # define __maybe_unused		/* unimplemented */
 #endif
 
+#ifndef __always_unused
+# define __always_unused	/* unimplemented */
+#endif
+
 #ifndef noinline
 #define noinline
 #endif
diff --git a/include/linux/smp_lock.h b/include/linux/smp_lock.h
index 813be59..2ea1dd1 100644
--- a/include/linux/smp_lock.h
+++ b/include/linux/smp_lock.h
@@ -24,8 +24,21 @@ static inline int reacquire_kernel_lock(struct task_struct *task)
 	return 0;
 }
 
-extern void __lockfunc lock_kernel(void)	__acquires(kernel_lock);
-extern void __lockfunc unlock_kernel(void)	__releases(kernel_lock);
+extern void __lockfunc
+_lock_kernel(const char *func, const char *file, int line)
+__acquires(kernel_lock);
+
+extern void __lockfunc
+_unlock_kernel(const char *func, const char *file, int line)
+__releases(kernel_lock);
+
+#define lock_kernel() do {					\
+	_lock_kernel(__func__, __FILE__, __LINE__);		\
+} while (0)
+
+#define unlock_kernel()	do {					\
+	_unlock_kernel(__func__, __FILE__, __LINE__);		\
+} while (0)
 
 /*
  * Various legacy drivers don't really need the BKL in a specific
@@ -41,8 +54,8 @@ static inline void cycle_kernel_lock(void)
 
 #else
 
-#define lock_kernel()				do { } while(0)
-#define unlock_kernel()				do { } while(0)
+#define lock_kernel()
+#define unlock_kernel()
 #define release_kernel_lock(task)		do { } while(0)
 #define cycle_kernel_lock()			do { } while(0)
 #define reacquire_kernel_lock(task)		0
diff --git a/include/trace/events/bkl.h b/include/trace/events/bkl.h
new file mode 100644
index 0000000..8abd620
--- /dev/null
+++ b/include/trace/events/bkl.h
@@ -0,0 +1,61 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM bkl
+
+#if !defined(_TRACE_BKL_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_BKL_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(lock_kernel,
+
+	TP_PROTO(const char *func, const char *file, int line),
+
+	TP_ARGS(func, file, line),
+
+	TP_STRUCT__entry(
+		__field(	int,		lock_depth		)
+		__field_ext(	const char *,	func, FILTER_PTR_STRING	)
+		__field_ext(	const char *,	file, FILTER_PTR_STRING	)
+		__field(	int,		line			)
+	),
+
+	TP_fast_assign(
+		/* We want to record the lock_depth after lock is acquired */
+		__entry->lock_depth = current->lock_depth + 1;
+		__entry->func = func;
+		__entry->file = file;
+		__entry->line = line;
+	),
+
+	TP_printk("depth: %d, %s:%d %s()", __entry->lock_depth,
+		  __entry->file, __entry->line, __entry->func)
+);
+
+TRACE_EVENT(unlock_kernel,
+
+	TP_PROTO(const char *func, const char *file, int line),
+
+	TP_ARGS(func, file, line),
+
+	TP_STRUCT__entry(
+		__field(int,		lock_depth)
+		__field(const char *,	func)
+		__field(const char *,	file)
+		__field(int,		line)
+	),
+
+	TP_fast_assign(
+		__entry->lock_depth = current->lock_depth;
+		__entry->func = func;
+		__entry->file = file;
+		__entry->line = line;
+	),
+
+	TP_printk("depth: %d, %s:%d %s()", __entry->lock_depth,
+		  __entry->file, __entry->line, __entry->func)
+);
+
+#endif /* _TRACE_BKL_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/include/trace/events/syscalls.h b/include/trace/events/syscalls.h
index 397dff2..fb726ac 100644
--- a/include/trace/events/syscalls.h
+++ b/include/trace/events/syscalls.h
@@ -1,5 +1,6 @@
 #undef TRACE_SYSTEM
-#define TRACE_SYSTEM syscalls
+#define TRACE_SYSTEM raw_syscalls
+#define TRACE_INCLUDE_FILE syscalls
 
 #if !defined(_TRACE_EVENTS_SYSCALLS_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_EVENTS_SYSCALLS_H
diff --git a/include/trace/power.h b/include/trace/power.h
deleted file mode 100644
index ef20466..0000000
--- a/include/trace/power.h
+++ /dev/null
@@ -1,32 +0,0 @@
-#ifndef _TRACE_POWER_H
-#define _TRACE_POWER_H
-
-#include <linux/ktime.h>
-#include <linux/tracepoint.h>
-
-enum {
-	POWER_NONE = 0,
-	POWER_CSTATE = 1,
-	POWER_PSTATE = 2,
-};
-
-struct power_trace {
-	ktime_t			stamp;
-	ktime_t			end;
-	int			type;
-	int			state;
-};
-
-DECLARE_TRACE(power_start,
-	TP_PROTO(struct power_trace *it, unsigned int type, unsigned int state),
-	      TP_ARGS(it, type, state));
-
-DECLARE_TRACE(power_mark,
-	TP_PROTO(struct power_trace *it, unsigned int type, unsigned int state),
-	      TP_ARGS(it, type, state));
-
-DECLARE_TRACE(power_end,
-	TP_PROTO(struct power_trace *it),
-	      TP_ARGS(it));
-
-#endif /* _TRACE_POWER_H */
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 5dc283b..e972f0a 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -33,7 +33,7 @@ struct syscall_metadata {
 };
 
 #ifdef CONFIG_FTRACE_SYSCALLS
-extern struct syscall_metadata *syscall_nr_to_meta(int nr);
+extern unsigned long arch_syscall_addr(int nr);
 extern int syscall_name_to_nr(char *name);
 void set_syscall_enter_id(int num, int id);
 void set_syscall_exit_id(int num, int id);
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 5240d75..1494e85 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1014,9 +1014,9 @@ int __kprobes register_kretprobe(struct kretprobe *rp)
 	/* Pre-allocate memory for max kretprobe instances */
 	if (rp->maxactive <= 0) {
 #ifdef CONFIG_PREEMPT
-		rp->maxactive = max(10, 2 * NR_CPUS);
+		rp->maxactive = max(10, 2 * num_possible_cpus());
 #else
-		rp->maxactive = NR_CPUS;
+		rp->maxactive = num_possible_cpus();
 #endif
 	}
 	spin_lock_init(&rp->lock);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 9c451a1..1dc101d 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -60,6 +60,13 @@ static int last_ftrace_enabled;
 /* Quick disabling of function tracer. */
 int function_trace_stop;
 
+/* List for set_ftrace_pid's pids. */
+LIST_HEAD(ftrace_pids);
+struct ftrace_pid {
+	struct list_head list;
+	struct pid *pid;
+};
+
 /*
  * ftrace_disabled is set when an anomaly is discovered.
  * ftrace_disabled is much stronger than ftrace_enabled.
@@ -78,6 +85,10 @@ ftrace_func_t ftrace_trace_function __read_mostly = ftrace_stub;
 ftrace_func_t __ftrace_trace_function __read_mostly = ftrace_stub;
 ftrace_func_t ftrace_pid_function __read_mostly = ftrace_stub;
 
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+static int ftrace_set_func(unsigned long *array, int *idx, char *buffer);
+#endif
+
 static void ftrace_list_func(unsigned long ip, unsigned long parent_ip)
 {
 	struct ftrace_ops *op = ftrace_list;
@@ -155,7 +166,7 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
 		else
 			func = ftrace_list_func;
 
-		if (ftrace_pid_trace) {
+		if (!list_empty(&ftrace_pids)) {
 			set_ftrace_pid_function(func);
 			func = ftrace_pid_func;
 		}
@@ -203,7 +214,7 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 		if (ftrace_list->next == &ftrace_list_end) {
 			ftrace_func_t func = ftrace_list->func;
 
-			if (ftrace_pid_trace) {
+			if (!list_empty(&ftrace_pids)) {
 				set_ftrace_pid_function(func);
 				func = ftrace_pid_func;
 			}
@@ -231,7 +242,7 @@ static void ftrace_update_pid_func(void)
 	func = __ftrace_trace_function;
 #endif
 
-	if (ftrace_pid_trace) {
+	if (!list_empty(&ftrace_pids)) {
 		set_ftrace_pid_function(func);
 		func = ftrace_pid_func;
 	} else {
@@ -821,8 +832,6 @@ static __init void ftrace_profile_debugfs(struct dentry *d_tracer)
 }
 #endif /* CONFIG_FUNCTION_PROFILER */
 
-/* set when tracing only a pid */
-struct pid *ftrace_pid_trace;
 static struct pid * const ftrace_swapper_pid = &init_struct_pid;
 
 #ifdef CONFIG_DYNAMIC_FTRACE
@@ -1261,12 +1270,34 @@ static int ftrace_update_code(struct module *mod)
 		ftrace_new_addrs = p->newlist;
 		p->flags = 0L;
 
-		/* convert record (i.e, patch mcount-call with NOP) */
-		if (ftrace_code_disable(mod, p)) {
-			p->flags |= FTRACE_FL_CONVERTED;
-			ftrace_update_cnt++;
-		} else
+		/*
+		 * Do the initial record convertion from mcount jump
+		 * to the NOP instructions.
+		 */
+		if (!ftrace_code_disable(mod, p)) {
 			ftrace_free_rec(p);
+			continue;
+		}
+
+		p->flags |= FTRACE_FL_CONVERTED;
+		ftrace_update_cnt++;
+
+		/*
+		 * If the tracing is enabled, go ahead and enable the record.
+		 *
+		 * The reason not to enable the record immediatelly is the
+		 * inherent check of ftrace_make_nop/ftrace_make_call for
+		 * correct previous instructions.  Making first the NOP
+		 * conversion puts the module to the correct state, thus
+		 * passing the ftrace_make_call check.
+		 */
+		if (ftrace_start_up) {
+			int failed = __ftrace_replace_code(p, 1);
+			if (failed) {
+				ftrace_bug(failed, p->ip);
+				ftrace_free_rec(p);
+			}
+		}
 	}
 
 	stop = ftrace_now(raw_smp_processor_id());
@@ -1656,60 +1687,6 @@ ftrace_regex_lseek(struct file *file, loff_t offset, int origin)
 	return ret;
 }
 
-enum {
-	MATCH_FULL,
-	MATCH_FRONT_ONLY,
-	MATCH_MIDDLE_ONLY,
-	MATCH_END_ONLY,
-};
-
-/*
- * (static function - no need for kernel doc)
- *
- * Pass in a buffer containing a glob and this function will
- * set search to point to the search part of the buffer and
- * return the type of search it is (see enum above).
- * This does modify buff.
- *
- * Returns enum type.
- *  search returns the pointer to use for comparison.
- *  not returns 1 if buff started with a '!'
- *     0 otherwise.
- */
-static int
-ftrace_setup_glob(char *buff, int len, char **search, int *not)
-{
-	int type = MATCH_FULL;
-	int i;
-
-	if (buff[0] == '!') {
-		*not = 1;
-		buff++;
-		len--;
-	} else
-		*not = 0;
-
-	*search = buff;
-
-	for (i = 0; i < len; i++) {
-		if (buff[i] == '*') {
-			if (!i) {
-				*search = buff + 1;
-				type = MATCH_END_ONLY;
-			} else {
-				if (type == MATCH_END_ONLY)
-					type = MATCH_MIDDLE_ONLY;
-				else
-					type = MATCH_FRONT_ONLY;
-				buff[i] = 0;
-				break;
-			}
-		}
-	}
-
-	return type;
-}
-
 static int ftrace_match(char *str, char *regex, int len, int type)
 {
 	int matched = 0;
@@ -1758,7 +1735,7 @@ static void ftrace_match_records(char *buff, int len, int enable)
 	int not;
 
 	flag = enable ? FTRACE_FL_FILTER : FTRACE_FL_NOTRACE;
-	type = ftrace_setup_glob(buff, len, &search, &not);
+	type = filter_parse_regex(buff, len, &search, &not);
 
 	search_len = strlen(search);
 
@@ -1826,7 +1803,7 @@ static void ftrace_match_module_records(char *buff, char *mod, int enable)
 	}
 
 	if (strlen(buff)) {
-		type = ftrace_setup_glob(buff, strlen(buff), &search, &not);
+		type = filter_parse_regex(buff, strlen(buff), &search, &not);
 		search_len = strlen(search);
 	}
 
@@ -1991,7 +1968,7 @@ register_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 	int count = 0;
 	char *search;
 
-	type = ftrace_setup_glob(glob, strlen(glob), &search, &not);
+	type = filter_parse_regex(glob, strlen(glob), &search, &not);
 	len = strlen(search);
 
 	/* we do not support '!' for function probes */
@@ -2068,7 +2045,7 @@ __unregister_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 	else if (glob) {
 		int not;
 
-		type = ftrace_setup_glob(glob, strlen(glob), &search, &not);
+		type = filter_parse_regex(glob, strlen(glob), &search, &not);
 		len = strlen(search);
 
 		/* we do not support '!' for function probes */
@@ -2312,6 +2289,32 @@ static int __init set_ftrace_filter(char *str)
 }
 __setup("ftrace_filter=", set_ftrace_filter);
 
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+static char ftrace_graph_buf[FTRACE_FILTER_SIZE] __initdata;
+static int __init set_graph_function(char *str)
+{
+	strlcpy(ftrace_graph_buf, str, FTRACE_FILTER_SIZE);
+	return 1;
+}
+__setup("ftrace_graph_filter=", set_graph_function);
+
+static void __init set_ftrace_early_graph(char *buf)
+{
+	int ret;
+	char *func;
+
+	while (buf) {
+		func = strsep(&buf, ",");
+		/* we allow only one expression at a time */
+		ret = ftrace_set_func(ftrace_graph_funcs, &ftrace_graph_count,
+				      func);
+		if (ret)
+			printk(KERN_DEBUG "ftrace: function %s not "
+					  "traceable\n", func);
+	}
+}
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
 static void __init set_ftrace_early_filter(char *buf, int enable)
 {
 	char *func;
@@ -2328,6 +2331,10 @@ static void __init set_ftrace_early_filters(void)
 		set_ftrace_early_filter(ftrace_filter_buf, 1);
 	if (ftrace_notrace_buf[0])
 		set_ftrace_early_filter(ftrace_notrace_buf, 0);
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	if (ftrace_graph_buf[0])
+		set_ftrace_early_graph(ftrace_graph_buf);
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 }
 
 static int
@@ -2513,7 +2520,7 @@ ftrace_set_func(unsigned long *array, int *idx, char *buffer)
 		return -ENODEV;
 
 	/* decode regex */
-	type = ftrace_setup_glob(buffer, strlen(buffer), &search, &not);
+	type = filter_parse_regex(buffer, strlen(buffer), &search, &not);
 	if (not)
 		return -EINVAL;
 
@@ -2624,7 +2631,7 @@ static __init int ftrace_init_dyn_debugfs(struct dentry *d_tracer)
 	return 0;
 }
 
-static int ftrace_convert_nops(struct module *mod,
+static int ftrace_process_locs(struct module *mod,
 			       unsigned long *start,
 			       unsigned long *end)
 {
@@ -2684,7 +2691,7 @@ static void ftrace_init_module(struct module *mod,
 {
 	if (ftrace_disabled || start == end)
 		return;
-	ftrace_convert_nops(mod, start, end);
+	ftrace_process_locs(mod, start, end);
 }
 
 static int ftrace_module_notify(struct notifier_block *self,
@@ -2745,7 +2752,7 @@ void __init ftrace_init(void)
 
 	last_ftrace_enabled = ftrace_enabled = 1;
 
-	ret = ftrace_convert_nops(NULL,
+	ret = ftrace_process_locs(NULL,
 				  __start_mcount_loc,
 				  __stop_mcount_loc);
 
@@ -2778,23 +2785,6 @@ static inline void ftrace_startup_enable(int command) { }
 # define ftrace_shutdown_sysctl()	do { } while (0)
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
-static ssize_t
-ftrace_pid_read(struct file *file, char __user *ubuf,
-		       size_t cnt, loff_t *ppos)
-{
-	char buf[64];
-	int r;
-
-	if (ftrace_pid_trace == ftrace_swapper_pid)
-		r = sprintf(buf, "swapper tasks\n");
-	else if (ftrace_pid_trace)
-		r = sprintf(buf, "%u\n", pid_vnr(ftrace_pid_trace));
-	else
-		r = sprintf(buf, "no pid\n");
-
-	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
-}
-
 static void clear_ftrace_swapper(void)
 {
 	struct task_struct *p;
@@ -2845,14 +2835,12 @@ static void set_ftrace_pid(struct pid *pid)
 	rcu_read_unlock();
 }
 
-static void clear_ftrace_pid_task(struct pid **pid)
+static void clear_ftrace_pid_task(struct pid *pid)
 {
-	if (*pid == ftrace_swapper_pid)
+	if (pid == ftrace_swapper_pid)
 		clear_ftrace_swapper();
 	else
-		clear_ftrace_pid(*pid);
-
-	*pid = NULL;
+		clear_ftrace_pid(pid);
 }
 
 static void set_ftrace_pid_task(struct pid *pid)
@@ -2863,74 +2851,184 @@ static void set_ftrace_pid_task(struct pid *pid)
 		set_ftrace_pid(pid);
 }
 
-static ssize_t
-ftrace_pid_write(struct file *filp, const char __user *ubuf,
-		   size_t cnt, loff_t *ppos)
+static int ftrace_pid_add(int p)
 {
 	struct pid *pid;
-	char buf[64];
-	long val;
-	int ret;
+	struct ftrace_pid *fpid;
+	int ret = -EINVAL;
 
-	if (cnt >= sizeof(buf))
-		return -EINVAL;
+	mutex_lock(&ftrace_lock);
 
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
+	if (!p)
+		pid = ftrace_swapper_pid;
+	else
+		pid = find_get_pid(p);
 
-	buf[cnt] = 0;
+	if (!pid)
+		goto out;
 
-	ret = strict_strtol(buf, 10, &val);
-	if (ret < 0)
-		return ret;
+	ret = 0;
 
-	mutex_lock(&ftrace_lock);
-	if (val < 0) {
-		/* disable pid tracing */
-		if (!ftrace_pid_trace)
-			goto out;
+	list_for_each_entry(fpid, &ftrace_pids, list)
+		if (fpid->pid == pid)
+			goto out_put;
 
-		clear_ftrace_pid_task(&ftrace_pid_trace);
+	ret = -ENOMEM;
 
-	} else {
-		/* swapper task is special */
-		if (!val) {
-			pid = ftrace_swapper_pid;
-			if (pid == ftrace_pid_trace)
-				goto out;
-		} else {
-			pid = find_get_pid(val);
+	fpid = kmalloc(sizeof(*fpid), GFP_KERNEL);
+	if (!fpid)
+		goto out_put;
 
-			if (pid == ftrace_pid_trace) {
-				put_pid(pid);
-				goto out;
-			}
-		}
+	list_add(&fpid->list, &ftrace_pids);
+	fpid->pid = pid;
 
-		if (ftrace_pid_trace)
-			clear_ftrace_pid_task(&ftrace_pid_trace);
+	set_ftrace_pid_task(pid);
 
-		if (!pid)
-			goto out;
+	ftrace_update_pid_func();
+	ftrace_startup_enable(0);
+
+	mutex_unlock(&ftrace_lock);
+	return 0;
+
+out_put:
+	if (pid != ftrace_swapper_pid)
+		put_pid(pid);
 
-		ftrace_pid_trace = pid;
+out:
+	mutex_unlock(&ftrace_lock);
+	return ret;
+}
+
+static void ftrace_pid_reset(void)
+{
+	struct ftrace_pid *fpid, *safe;
 
-		set_ftrace_pid_task(ftrace_pid_trace);
+	mutex_lock(&ftrace_lock);
+	list_for_each_entry_safe(fpid, safe, &ftrace_pids, list) {
+		struct pid *pid = fpid->pid;
+
+		clear_ftrace_pid_task(pid);
+
+		list_del(&fpid->list);
+		kfree(fpid);
 	}
 
-	/* update the function call */
 	ftrace_update_pid_func();
 	ftrace_startup_enable(0);
 
- out:
 	mutex_unlock(&ftrace_lock);
+}
 
-	return cnt;
+static void *fpid_start(struct seq_file *m, loff_t *pos)
+{
+	mutex_lock(&ftrace_lock);
+
+	if (list_empty(&ftrace_pids) && (!*pos))
+		return (void *) 1;
+
+	return seq_list_start(&ftrace_pids, *pos);
+}
+
+static void *fpid_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	if (v == (void *)1)
+		return NULL;
+
+	return seq_list_next(v, &ftrace_pids, pos);
+}
+
+static void fpid_stop(struct seq_file *m, void *p)
+{
+	mutex_unlock(&ftrace_lock);
+}
+
+static int fpid_show(struct seq_file *m, void *v)
+{
+	const struct ftrace_pid *fpid = list_entry(v, struct ftrace_pid, list);
+
+	if (v == (void *)1) {
+		seq_printf(m, "no pid\n");
+		return 0;
+	}
+
+	if (fpid->pid == ftrace_swapper_pid)
+		seq_printf(m, "swapper tasks\n");
+	else
+		seq_printf(m, "%u\n", pid_vnr(fpid->pid));
+
+	return 0;
+}
+
+static const struct seq_operations ftrace_pid_sops = {
+	.start = fpid_start,
+	.next = fpid_next,
+	.stop = fpid_stop,
+	.show = fpid_show,
+};
+
+static int
+ftrace_pid_open(struct inode *inode, struct file *file)
+{
+	int ret = 0;
+
+	if ((file->f_mode & FMODE_WRITE) &&
+	    (file->f_flags & O_TRUNC))
+		ftrace_pid_reset();
+
+	if (file->f_mode & FMODE_READ)
+		ret = seq_open(file, &ftrace_pid_sops);
+
+	return ret;
+}
+
+static ssize_t
+ftrace_pid_write(struct file *filp, const char __user *ubuf,
+		   size_t cnt, loff_t *ppos)
+{
+	char buf[64], *tmp;
+	long val;
+	int ret;
+
+	if (cnt >= sizeof(buf))
+		return -EINVAL;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+
+	buf[cnt] = 0;
+
+	/*
+	 * Allow "echo > set_ftrace_pid" or "echo -n '' > set_ftrace_pid"
+	 * to clean the filter quietly.
+	 */
+	tmp = strstrip(buf);
+	if (strlen(tmp) == 0)
+		return 1;
+
+	ret = strict_strtol(tmp, 10, &val);
+	if (ret < 0)
+		return ret;
+
+	ret = ftrace_pid_add(val);
+
+	return ret ? ret : cnt;
+}
+
+static int
+ftrace_pid_release(struct inode *inode, struct file *file)
+{
+	if (file->f_mode & FMODE_READ)
+		seq_release(inode, file);
+
+	return 0;
 }
 
 static const struct file_operations ftrace_pid_fops = {
-	.read = ftrace_pid_read,
-	.write = ftrace_pid_write,
+	.open		= ftrace_pid_open,
+	.write		= ftrace_pid_write,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= ftrace_pid_release,
 };
 
 static __init int ftrace_init_debugfs(void)
@@ -3293,4 +3391,3 @@ void ftrace_graph_stop(void)
 	ftrace_stop();
 }
 #endif
-
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 3ffa502..4b8293f 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1785,9 +1785,9 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
 static struct ring_buffer_event *
 rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
 	     unsigned long length, unsigned long tail,
-	     struct buffer_page *commit_page,
 	     struct buffer_page *tail_page, u64 *ts)
 {
+	struct buffer_page *commit_page = cpu_buffer->commit_page;
 	struct ring_buffer *buffer = cpu_buffer->buffer;
 	struct buffer_page *next_page;
 	int ret;
@@ -1890,13 +1890,10 @@ static struct ring_buffer_event *
 __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 		  unsigned type, unsigned long length, u64 *ts)
 {
-	struct buffer_page *tail_page, *commit_page;
+	struct buffer_page *tail_page;
 	struct ring_buffer_event *event;
 	unsigned long tail, write;
 
-	commit_page = cpu_buffer->commit_page;
-	/* we just need to protect against interrupts */
-	barrier();
 	tail_page = cpu_buffer->tail_page;
 	write = local_add_return(length, &tail_page->write);
 
@@ -1907,7 +1904,7 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 	/* See if we shot pass the end of this buffer page */
 	if (write > BUF_PAGE_SIZE)
 		return rb_move_tail(cpu_buffer, length, tail,
-				    commit_page, tail_page, ts);
+				    tail_page, ts);
 
 	/* We reserved something on the buffer */
 
diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index 573d3cc..b2477ca 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -35,6 +35,28 @@ static int disable_reader;
 module_param(disable_reader, uint, 0644);
 MODULE_PARM_DESC(disable_reader, "only run producer");
 
+static int write_iteration = 50;
+module_param(write_iteration, uint, 0644);
+MODULE_PARM_DESC(write_iteration, "# of writes between timestamp readings");
+
+static int producer_nice = 19;
+static int consumer_nice = 19;
+
+static int producer_fifo = -1;
+static int consumer_fifo = -1;
+
+module_param(producer_nice, uint, 0644);
+MODULE_PARM_DESC(producer_nice, "nice prio for producer");
+
+module_param(consumer_nice, uint, 0644);
+MODULE_PARM_DESC(consumer_nice, "nice prio for consumer");
+
+module_param(producer_fifo, uint, 0644);
+MODULE_PARM_DESC(producer_fifo, "fifo prio for producer");
+
+module_param(consumer_fifo, uint, 0644);
+MODULE_PARM_DESC(consumer_fifo, "fifo prio for consumer");
+
 static int read_events;
 
 static int kill_test;
@@ -208,15 +230,18 @@ static void ring_buffer_producer(void)
 	do {
 		struct ring_buffer_event *event;
 		int *entry;
-
-		event = ring_buffer_lock_reserve(buffer, 10);
-		if (!event) {
-			missed++;
-		} else {
-			hit++;
-			entry = ring_buffer_event_data(event);
-			*entry = smp_processor_id();
-			ring_buffer_unlock_commit(buffer, event);
+		int i;
+
+		for (i = 0; i < write_iteration; i++) {
+			event = ring_buffer_lock_reserve(buffer, 10);
+			if (!event) {
+				missed++;
+			} else {
+				hit++;
+				entry = ring_buffer_event_data(event);
+				*entry = smp_processor_id();
+				ring_buffer_unlock_commit(buffer, event);
+			}
 		}
 		do_gettimeofday(&end_tv);
 
@@ -263,6 +288,27 @@ static void ring_buffer_producer(void)
 
 	if (kill_test)
 		trace_printk("ERROR!\n");
+
+	if (!disable_reader) {
+		if (consumer_fifo < 0)
+			trace_printk("Running Consumer at nice: %d\n",
+				     consumer_nice);
+		else
+			trace_printk("Running Consumer at SCHED_FIFO %d\n",
+				     consumer_fifo);
+	}
+	if (producer_fifo < 0)
+		trace_printk("Running Producer at nice: %d\n",
+			     producer_nice);
+	else
+		trace_printk("Running Producer at SCHED_FIFO %d\n",
+			     producer_fifo);
+
+	/* Let the user know that the test is running at low priority */
+	if (producer_fifo < 0 && consumer_fifo < 0 &&
+	    producer_nice == 19 && consumer_nice == 19)
+		trace_printk("WARNING!!! This test is running at lowest priority.\n");
+
 	trace_printk("Time:     %lld (usecs)\n", time);
 	trace_printk("Overruns: %lld\n", overruns);
 	if (disable_reader)
@@ -392,6 +438,27 @@ static int __init ring_buffer_benchmark_init(void)
 	if (IS_ERR(producer))
 		goto out_kill;
 
+	/*
+	 * Run them as low-prio background tasks by default:
+	 */
+	if (!disable_reader) {
+		if (consumer_fifo >= 0) {
+			struct sched_param param = {
+				.sched_priority = consumer_fifo
+			};
+			sched_setscheduler(consumer, SCHED_FIFO, &param);
+		} else
+			set_user_nice(consumer, consumer_nice);
+	}
+
+	if (producer_fifo >= 0) {
+		struct sched_param param = {
+			.sched_priority = consumer_fifo
+		};
+		sched_setscheduler(producer, SCHED_FIFO, &param);
+	} else
+		set_user_nice(producer, producer_nice);
+
 	return 0;
 
  out_kill:
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b20d3ec..9d3067a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -129,7 +129,7 @@ static int tracing_set_tracer(const char *buf);
 static char bootup_tracer_buf[MAX_TRACER_SIZE] __initdata;
 static char *default_bootup_tracer;
 
-static int __init set_ftrace(char *str)
+static int __init set_cmdline_ftrace(char *str)
 {
 	strncpy(bootup_tracer_buf, str, MAX_TRACER_SIZE);
 	default_bootup_tracer = bootup_tracer_buf;
@@ -137,7 +137,7 @@ static int __init set_ftrace(char *str)
 	ring_buffer_expanded = 1;
 	return 1;
 }
-__setup("ftrace=", set_ftrace);
+__setup("ftrace=", set_cmdline_ftrace);
 
 static int __init set_ftrace_dump_on_oops(char *str)
 {
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 405cb85..acef8b4 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -483,10 +483,6 @@ static inline int ftrace_graph_addr(unsigned long addr)
 	return 0;
 }
 #else
-static inline int ftrace_trace_addr(unsigned long addr)
-{
-	return 1;
-}
 static inline int ftrace_graph_addr(unsigned long addr)
 {
 	return 1;
@@ -500,12 +496,12 @@ print_graph_function(struct trace_iterator *iter)
 }
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
-extern struct pid *ftrace_pid_trace;
+extern struct list_head ftrace_pids;
 
 #ifdef CONFIG_FUNCTION_TRACER
 static inline int ftrace_trace_task(struct task_struct *task)
 {
-	if (!ftrace_pid_trace)
+	if (list_empty(&ftrace_pids))
 		return 1;
 
 	return test_tsk_trace_trace(task);
@@ -699,22 +695,40 @@ struct event_subsystem {
 };
 
 struct filter_pred;
+struct regex;
 
 typedef int (*filter_pred_fn_t) (struct filter_pred *pred, void *event,
 				 int val1, int val2);
 
+typedef int (*regex_match_func)(char *str, struct regex *r, int len);
+
+enum regex_type {
+	MATCH_FULL,
+	MATCH_FRONT_ONLY,
+	MATCH_MIDDLE_ONLY,
+	MATCH_END_ONLY,
+};
+
+struct regex {
+	char			pattern[MAX_FILTER_STR_VAL];
+	int			len;
+	int			field_len;
+	regex_match_func	match;
+};
+
 struct filter_pred {
-	filter_pred_fn_t fn;
-	u64 val;
-	char str_val[MAX_FILTER_STR_VAL];
-	int str_len;
-	char *field_name;
-	int offset;
-	int not;
-	int op;
-	int pop_n;
+	filter_pred_fn_t 	fn;
+	u64 			val;
+	struct regex		regex;
+	char 			*field_name;
+	int 			offset;
+	int 			not;
+	int 			op;
+	int 			pop_n;
 };
 
+extern enum regex_type
+filter_parse_regex(char *buff, int len, char **search, int *not);
 extern void print_event_filter(struct ftrace_event_call *call,
 			       struct trace_seq *s);
 extern int apply_event_filter(struct ftrace_event_call *call,
diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 20c5f92..878c03f 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -20,6 +20,8 @@
 #include <linux/ktime.h>
 #include <linux/trace_clock.h>
 
+#include "trace.h"
+
 /*
  * trace_clock_local(): the simplest and least coherent tracing clock.
  *
@@ -28,17 +30,17 @@
  */
 u64 notrace trace_clock_local(void)
 {
-	unsigned long flags;
 	u64 clock;
+	int resched;
 
 	/*
 	 * sched_clock() is an architecture implemented, fast, scalable,
 	 * lockless clock. It is not guaranteed to be coherent across
 	 * CPUs, nor across CPU idle events.
 	 */
-	raw_local_irq_save(flags);
+	resched = ftrace_preempt_disable();
 	clock = sched_clock();
-	raw_local_irq_restore(flags);
+	ftrace_preempt_enable(resched);
 
 	return clock;
 }
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index d128f65..5e9ffc3 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -878,9 +878,9 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
 			   "'%s/filter' entry\n", name);
 	}
 
-	entry = trace_create_file("enable", 0644, system->entry,
-				  (void *)system->name,
-				  &ftrace_system_enable_fops);
+	trace_create_file("enable", 0644, system->entry,
+			  (void *)system->name,
+			  &ftrace_system_enable_fops);
 
 	return system->entry;
 }
@@ -892,7 +892,6 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 		 const struct file_operations *filter,
 		 const struct file_operations *format)
 {
-	struct dentry *entry;
 	int ret;
 
 	/*
@@ -910,12 +909,12 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 	}
 
 	if (call->regfunc)
-		entry = trace_create_file("enable", 0644, call->dir, call,
-					  enable);
+		trace_create_file("enable", 0644, call->dir, call,
+				  enable);
 
 	if (call->id && call->profile_enable)
-		entry = trace_create_file("id", 0444, call->dir, call,
-					  id);
+		trace_create_file("id", 0444, call->dir, call,
+		 		  id);
 
 	if (call->define_fields) {
 		ret = call->define_fields(call);
@@ -924,16 +923,16 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 				   " events/%s\n", call->name);
 			return ret;
 		}
-		entry = trace_create_file("filter", 0644, call->dir, call,
-					  filter);
+		trace_create_file("filter", 0644, call->dir, call,
+				  filter);
 	}
 
 	/* A trace may not want to export its format */
 	if (!call->show_format)
 		return 0;
 
-	entry = trace_create_file("format", 0444, call->dir, call,
-				  format);
+	trace_create_file("format", 0444, call->dir, call,
+			  format);
 
 	return 0;
 }
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 98a6cc5..9267201 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -18,8 +18,6 @@
  * Copyright (C) 2009 Tom Zanussi <tzanussi@gmail.com>
  */
 
-#include <linux/debugfs.h>
-#include <linux/uaccess.h>
 #include <linux/module.h>
 #include <linux/ctype.h>
 #include <linux/mutex.h>
@@ -197,9 +195,9 @@ static int filter_pred_string(struct filter_pred *pred, void *event,
 	char *addr = (char *)(event + pred->offset);
 	int cmp, match;
 
-	cmp = strncmp(addr, pred->str_val, pred->str_len);
+	cmp = pred->regex.match(addr, &pred->regex, pred->regex.field_len);
 
-	match = (!cmp) ^ pred->not;
+	match = cmp ^ pred->not;
 
 	return match;
 }
@@ -211,9 +209,9 @@ static int filter_pred_pchar(struct filter_pred *pred, void *event,
 	char **addr = (char **)(event + pred->offset);
 	int cmp, match;
 
-	cmp = strncmp(*addr, pred->str_val, pred->str_len);
+	cmp = pred->regex.match(*addr, &pred->regex, pred->regex.field_len);
 
-	match = (!cmp) ^ pred->not;
+	match = cmp ^ pred->not;
 
 	return match;
 }
@@ -237,9 +235,9 @@ static int filter_pred_strloc(struct filter_pred *pred, void *event,
 	char *addr = (char *)(event + str_loc);
 	int cmp, match;
 
-	cmp = strncmp(addr, pred->str_val, str_len);
+	cmp = pred->regex.match(addr, &pred->regex, str_len);
 
-	match = (!cmp) ^ pred->not;
+	match = cmp ^ pred->not;
 
 	return match;
 }
@@ -250,6 +248,124 @@ static int filter_pred_none(struct filter_pred *pred, void *event,
 	return 0;
 }
 
+/* Basic regex callbacks */
+static int regex_match_full(char *str, struct regex *r, int len)
+{
+	if (strncmp(str, r->pattern, len) == 0)
+		return 1;
+	return 0;
+}
+
+static int regex_match_front(char *str, struct regex *r, int len)
+{
+	if (strncmp(str, r->pattern, len) == 0)
+		return 1;
+	return 0;
+}
+
+static int regex_match_middle(char *str, struct regex *r, int len)
+{
+	if (strstr(str, r->pattern))
+		return 1;
+	return 0;
+}
+
+static int regex_match_end(char *str, struct regex *r, int len)
+{
+	char *ptr = strstr(str, r->pattern);
+
+	if (ptr && (ptr[r->len] == 0))
+		return 1;
+	return 0;
+}
+
+/**
+ * filter_parse_regex - parse a basic regex
+ * @buff:   the raw regex
+ * @len:    length of the regex
+ * @search: will point to the beginning of the string to compare
+ * @not:    tell whether the match will have to be inverted
+ *
+ * This passes in a buffer containing a regex and this function will
+ * set search to point to the search part of the buffer and
+ * return the type of search it is (see enum above).
+ * This does modify buff.
+ *
+ * Returns enum type.
+ *  search returns the pointer to use for comparison.
+ *  not returns 1 if buff started with a '!'
+ *     0 otherwise.
+ */
+enum regex_type filter_parse_regex(char *buff, int len, char **search, int *not)
+{
+	int type = MATCH_FULL;
+	int i;
+
+	if (buff[0] == '!') {
+		*not = 1;
+		buff++;
+		len--;
+	} else
+		*not = 0;
+
+	*search = buff;
+
+	for (i = 0; i < len; i++) {
+		if (buff[i] == '*') {
+			if (!i) {
+				*search = buff + 1;
+				type = MATCH_END_ONLY;
+			} else {
+				if (type == MATCH_END_ONLY)
+					type = MATCH_MIDDLE_ONLY;
+				else
+					type = MATCH_FRONT_ONLY;
+				buff[i] = 0;
+				break;
+			}
+		}
+	}
+
+	return type;
+}
+
+static int filter_build_regex(struct filter_pred *pred)
+{
+	struct regex *r = &pred->regex;
+	char *search, *dup;
+	enum regex_type type;
+	int not;
+
+	type = filter_parse_regex(r->pattern, r->len, &search, &not);
+	dup = kstrdup(search, GFP_KERNEL);
+	if (!dup)
+		return -ENOMEM;
+
+	strcpy(r->pattern, dup);
+	kfree(dup);
+
+	r->len = strlen(r->pattern);
+
+	switch (type) {
+	case MATCH_FULL:
+		r->match = regex_match_full;
+		break;
+	case MATCH_FRONT_ONLY:
+		r->match = regex_match_front;
+		break;
+	case MATCH_MIDDLE_ONLY:
+		r->match = regex_match_middle;
+		break;
+	case MATCH_END_ONLY:
+		r->match = regex_match_end;
+		break;
+	}
+
+	pred->not ^= not;
+
+	return 0;
+}
+
 /* return 1 if event matches, 0 otherwise (discard) */
 int filter_match_preds(struct ftrace_event_call *call, void *rec)
 {
@@ -396,7 +512,7 @@ static void filter_clear_pred(struct filter_pred *pred)
 {
 	kfree(pred->field_name);
 	pred->field_name = NULL;
-	pred->str_len = 0;
+	pred->regex.len = 0;
 }
 
 static int filter_set_pred(struct filter_pred *dest,
@@ -660,21 +776,24 @@ static int filter_add_pred(struct filter_parse_state *ps,
 	}
 
 	if (is_string_field(field)) {
-		pred->str_len = field->size;
+		ret = filter_build_regex(pred);
+		if (ret)
+			return ret;
 
-		if (field->filter_type == FILTER_STATIC_STRING)
+		if (field->filter_type == FILTER_STATIC_STRING) {
 			fn = filter_pred_string;
-		else if (field->filter_type == FILTER_DYN_STRING)
-			fn = filter_pred_strloc;
+			pred->regex.field_len = field->size;
+		} else if (field->filter_type == FILTER_DYN_STRING)
+				fn = filter_pred_strloc;
 		else {
 			fn = filter_pred_pchar;
-			pred->str_len = strlen(pred->str_val);
+			pred->regex.field_len = strlen(pred->regex.pattern);
 		}
 	} else {
 		if (field->is_signed)
-			ret = strict_strtoll(pred->str_val, 0, &val);
+			ret = strict_strtoll(pred->regex.pattern, 0, &val);
 		else
-			ret = strict_strtoull(pred->str_val, 0, &val);
+			ret = strict_strtoull(pred->regex.pattern, 0, &val);
 		if (ret) {
 			parse_error(ps, FILT_ERR_ILLEGAL_INTVAL, 0);
 			return -EINVAL;
@@ -1045,8 +1164,8 @@ static struct filter_pred *create_pred(int op, char *operand1, char *operand2)
 		return NULL;
 	}
 
-	strcpy(pred->str_val, operand2);
-	pred->str_len = strlen(operand2);
+	strcpy(pred->regex.pattern, operand2);
+	pred->regex.len = strlen(pred->regex.pattern);
 
 	pred->op = op;
 
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 9753fcc..c74848d 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -48,11 +48,11 @@
 struct ____ftrace_##name {					\
 	tstruct							\
 };								\
-static void __used ____ftrace_check_##name(void)		\
+static void __always_unused ____ftrace_check_##name(void)	\
 {								\
 	struct ____ftrace_##name *__entry = NULL;		\
 								\
-	/* force cmpile-time check on F_printk() */		\
+	/* force compile-time check on F_printk() */		\
 	printk(print);						\
 }
 
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 527e17e..ddee9c5 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -14,6 +14,69 @@ static int sys_refcount_exit;
 static DECLARE_BITMAP(enabled_enter_syscalls, NR_syscalls);
 static DECLARE_BITMAP(enabled_exit_syscalls, NR_syscalls);
 
+extern unsigned long __start_syscalls_metadata[];
+extern unsigned long __stop_syscalls_metadata[];
+
+static struct syscall_metadata **syscalls_metadata;
+
+static struct syscall_metadata *find_syscall_meta(unsigned long syscall)
+{
+	struct syscall_metadata *start;
+	struct syscall_metadata *stop;
+	char str[KSYM_SYMBOL_LEN];
+
+
+	start = (struct syscall_metadata *)__start_syscalls_metadata;
+	stop = (struct syscall_metadata *)__stop_syscalls_metadata;
+	kallsyms_lookup(syscall, NULL, NULL, NULL, str);
+
+	for ( ; start < stop; start++) {
+		/*
+		 * Only compare after the "sys" prefix. Archs that use
+		 * syscall wrappers may have syscalls symbols aliases prefixed
+		 * with "SyS" instead of "sys", leading to an unwanted
+		 * mismatch.
+		 */
+		if (start->name && !strcmp(start->name + 3, str + 3))
+			return start;
+	}
+	return NULL;
+}
+
+static struct syscall_metadata *syscall_nr_to_meta(int nr)
+{
+	if (!syscalls_metadata || nr >= NR_syscalls || nr < 0)
+		return NULL;
+
+	return syscalls_metadata[nr];
+}
+
+int syscall_name_to_nr(char *name)
+{
+	int i;
+
+	if (!syscalls_metadata)
+		return -1;
+
+	for (i = 0; i < NR_syscalls; i++) {
+		if (syscalls_metadata[i]) {
+			if (!strcmp(syscalls_metadata[i]->name, name))
+				return i;
+		}
+	}
+	return -1;
+}
+
+void set_syscall_enter_id(int num, int id)
+{
+	syscalls_metadata[num]->enter_id = id;
+}
+
+void set_syscall_exit_id(int num, int id)
+{
+	syscalls_metadata[num]->exit_id = id;
+}
+
 enum print_line_t
 print_syscall_enter(struct trace_iterator *iter, int flags)
 {
@@ -375,6 +438,29 @@ struct trace_event event_syscall_exit = {
 	.trace			= print_syscall_exit,
 };
 
+int __init init_ftrace_syscalls(void)
+{
+	struct syscall_metadata *meta;
+	unsigned long addr;
+	int i;
+
+	syscalls_metadata = kzalloc(sizeof(*syscalls_metadata) *
+					NR_syscalls, GFP_KERNEL);
+	if (!syscalls_metadata) {
+		WARN_ON(1);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < NR_syscalls; i++) {
+		addr = arch_syscall_addr(i);
+		meta = find_syscall_meta(addr);
+		syscalls_metadata[i] = meta;
+	}
+
+	return 0;
+}
+core_initcall(init_ftrace_syscalls);
+
 #ifdef CONFIG_EVENT_PROFILE
 
 static DECLARE_BITMAP(enabled_prof_enter_syscalls, NR_syscalls);
diff --git a/lib/kernel_lock.c b/lib/kernel_lock.c
index 39f1029..4ebfa5a 100644
--- a/lib/kernel_lock.c
+++ b/lib/kernel_lock.c
@@ -5,10 +5,13 @@
  * relegated to obsolescence, but used by various less
  * important (or lazy) subsystems.
  */
-#include <linux/smp_lock.h>
 #include <linux/module.h>
 #include <linux/kallsyms.h>
 #include <linux/semaphore.h>
+#include <linux/smp_lock.h>
+
+#define CREATE_TRACE_POINTS
+#include <trace/events/bkl.h>
 
 /*
  * The 'big kernel lock'
@@ -113,21 +116,26 @@ static inline void __unlock_kernel(void)
  * This cannot happen asynchronously, so we only need to
  * worry about other CPU's.
  */
-void __lockfunc lock_kernel(void)
+void __lockfunc _lock_kernel(const char *func, const char *file, int line)
 {
-	int depth = current->lock_depth+1;
+	int depth = current->lock_depth + 1;
+
+	trace_lock_kernel(func, file, line);
+
 	if (likely(!depth))
 		__lock_kernel();
 	current->lock_depth = depth;
 }
 
-void __lockfunc unlock_kernel(void)
+void __lockfunc _unlock_kernel(const char *func, const char *file, int line)
 {
 	BUG_ON(current->lock_depth < 0);
 	if (likely(--current->lock_depth < 0))
 		__unlock_kernel();
+
+	trace_unlock_kernel(func, file, line);
 }
 
-EXPORT_SYMBOL(lock_kernel);
-EXPORT_SYMBOL(unlock_kernel);
+EXPORT_SYMBOL(_lock_kernel);
+EXPORT_SYMBOL(_unlock_kernel);
 
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 090d300..f0d1445 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -6,77 +6,93 @@
 #                   all the offsets to the calls to mcount.
 #
 #
-# What we want to end up with is a section in vmlinux called
-# __mcount_loc that contains a list of pointers to all the
-# call sites in the kernel that call mcount. Later on boot up, the kernel
-# will read this list, save the locations and turn them into nops.
-# When tracing or profiling is later enabled, these locations will then
-# be converted back to pointers to some function.
+# What we want to end up with this is that each object file will have a
+# section called __mcount_loc that will hold the list of pointers to mcount
+# callers. After final linking, the vmlinux will have within .init.data the
+# list of all callers to mcount between __start_mcount_loc and __stop_mcount_loc.
+# Later on boot up, the kernel will read this list, save the locations and turn
+# them into nops. When tracing or profiling is later enabled, these locations
+# will then be converted back to pointers to some function.
 #
 # This is no easy feat. This script is called just after the original
 # object is compiled and before it is linked.
 #
-# The references to the call sites are offsets from the section of text
-# that the call site is in. Hence, all functions in a section that
-# has a call site to mcount, will have the offset from the beginning of
-# the section and not the beginning of the function.
+# When parse this object file using 'objdump', the references to the call
+# sites are offsets from the section that the call site is in. Hence, all
+# functions in a section that has a call site to mcount, will have the
+# offset from the beginning of the section and not the beginning of the
+# function.
+#
+# But where this section will reside finally in vmlinx is undetermined at
+# this point. So we can't use this kind of offsets to record the final
+# address of this call site.
+#
+# The trick is to change the call offset referring the start of a section to
+# referring a function symbol in this section. During the link step, 'ld' will
+# compute the final address according to the information we record.
 #
-# The trick is to find a way to record the beginning of the section.
-# The way we do this is to look at the first function in the section
-# which will also be the location of that section after final link.
 # e.g.
 #
 #  .section ".sched.text", "ax"
-#  .globl my_func
-#  my_func:
 #        [...]
-#        call mcount  (offset: 0x5)
+#  func1:
+#        [...]
+#        call mcount  (offset: 0x10)
 #        [...]
 #        ret
-#  other_func:
+#  .globl fun2
+#  func2:             (offset: 0x20)
 #        [...]
-#        call mcount (offset: 0x1b)
+#        [...]
+#        ret
+#  func3:
+#        [...]
+#        call mcount (offset: 0x30)
 #        [...]
 #
 # Both relocation offsets for the mcounts in the above example will be
-# offset from .sched.text. If we make another file called tmp.s with:
+# offset from .sched.text. If we choose global symbol func2 as a reference and
+# make another file called tmp.s with the new offsets:
 #
 #  .section __mcount_loc
-#  .quad  my_func + 0x5
-#  .quad  my_func + 0x1b
+#  .quad  func2 - 0x10
+#  .quad  func2 + 0x10
 #
-# We can then compile this tmp.s into tmp.o, and link it to the original
+# We can then compile this tmp.s into tmp.o, and link it back to the original
 # object.
 #
-# But this gets hard if my_func is not globl (a static function).
-# In such a case we have:
+# In our algorithm, we will choose the first global function we meet in this
+# section as the reference. But this gets hard if there is no global functions
+# in this section. In such a case we have to select a local one. E.g. func1:
 #
 #  .section ".sched.text", "ax"
-#  my_func:
+#  func1:
 #        [...]
-#        call mcount  (offset: 0x5)
+#        call mcount  (offset: 0x10)
 #        [...]
 #        ret
-#  other_func:
+#  func2:
 #        [...]
-#        call mcount (offset: 0x1b)
+#        call mcount (offset: 0x20)
 #        [...]
+#  .section "other.section"
 #
 # If we make the tmp.s the same as above, when we link together with
-# the original object, we will end up with two symbols for my_func:
+# the original object, we will end up with two symbols for func1:
 # one local, one global.  After final compile, we will end up with
-# an undefined reference to my_func.
+# an undefined reference to func1 or a wrong reference to another global
+# func1 in other files.
 #
 # Since local objects can reference local variables, we need to find
 # a way to make tmp.o reference the local objects of the original object
-# file after it is linked together. To do this, we convert the my_func
+# file after it is linked together. To do this, we convert func1
 # into a global symbol before linking tmp.o. Then after we link tmp.o
-# we will only have a single symbol for my_func that is global.
-# We can convert my_func back into a local symbol and we are done.
+# we will only have a single symbol for func1 that is global.
+# We can convert func1 back into a local symbol and we are done.
 #
 # Here are the steps we take:
 #
-# 1) Record all the local symbols by using 'nm'
+# 1) Record all the local and weak symbols by using 'nm'
 # 2) Use objdump to find all the call site offsets and sections for
 #    mcount.
 # 3) Compile the list into its own object.
@@ -86,10 +102,8 @@
 # 6) Link together this new object with the list object.
 # 7) Convert the local functions back to local symbols and rename
 #    the result as the original object.
-#    End.
 # 8) Link the object with the list object.
 # 9) Move the result back to the original object.
-#    End.
 #
 
 use strict;
@@ -99,7 +113,7 @@ $P =~ s@.*/@@g;
 
 my $V = '0.1';
 
-if ($#ARGV < 7) {
+if ($#ARGV != 10) {
 	print "usage: $P arch bits objdump objcopy cc ld nm rm mv is_module inputfile\n";
 	print "version: $V\n";
 	exit(1);
@@ -109,7 +123,7 @@ my ($arch, $bits, $objdump, $objcopy, $cc,
     $ld, $nm, $rm, $mv, $is_module, $inputfile) = @ARGV;
 
 # This file refers to mcount and shouldn't be ftraced, so lets' ignore it
-if ($inputfile eq "kernel/trace/ftrace.o") {
+if ($inputfile =~ m,kernel/trace/ftrace\.o$,) {
     exit(0);
 }
 
@@ -119,6 +133,7 @@ my %text_sections = (
      ".sched.text" => 1,
      ".spinlock.text" => 1,
      ".irqentry.text" => 1,
+     ".text.unlikely" => 1,
 );
 
 $objdump = "objdump" if ((length $objdump) == 0);
@@ -137,13 +152,47 @@ my %weak;		# List of weak functions
 my %convert;		# List of local functions used that needs conversion
 
 my $type;
-my $nm_regex;		# Find the local functions (return function)
+my $local_regex;	# Match a local function (return function)
+my $weak_regex; 	# Match a weak function (return function)
 my $section_regex;	# Find the start of a section
 my $function_regex;	# Find the name of a function
 			#    (return offset and func name)
 my $mcount_regex;	# Find the call site to mcount (return offset)
 my $alignment;		# The .align value to use for $mcount_section
 my $section_type;	# Section header plus possible alignment command
+my $can_use_local = 0; 	# If we can use local function references
+
+# Shut up recordmcount if user has older objcopy
+my $quiet_recordmcount = ".tmp_quiet_recordmcount";
+my $print_warning = 1;
+$print_warning = 0 if ( -f $quiet_recordmcount);
+
+##
+# check_objcopy - whether objcopy supports --globalize-symbols
+#
+#  --globalize-symbols came out in 2.17, we must test the version
+#  of objcopy, and if it is less than 2.17, then we can not
+#  record local functions.
+sub check_objcopy
+{
+    open (IN, "$objcopy --version |") or die "error running $objcopy";
+    while (<IN>) {
+	if (/objcopy.*\s(\d+)\.(\d+)/) {
+	    $can_use_local = 1 if ($1 > 2 || ($1 == 2 && $2 >= 17));
+	    last;
+	}
+    }
+    close (IN);
+
+    if (!$can_use_local && $print_warning) {
+	print STDERR "WARNING: could not find objcopy version or version " .
+	    "is less than 2.17.\n" .
+	    "\tLocal function references are disabled.\n";
+	open (QUIET, ">$quiet_recordmcount");
+	printf QUIET "Disables the warning from recordmcount.pl\n";
+	close QUIET;
+    }
+}
 
 if ($arch eq "x86") {
     if ($bits == 64) {
@@ -157,7 +206,8 @@ if ($arch eq "x86") {
 # We base the defaults off of i386, the other archs may
 # feel free to change them in the below if statements.
 #
-$nm_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\S+)";
+$local_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\S+)";
+$weak_regex = "^[0-9a-fA-F]+\\s+([wW])\\s+(\\S+)";
 $section_regex = "Disassembly of section\\s+(\\S+):";
 $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
 $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
@@ -206,7 +256,7 @@ if ($arch eq "x86_64") {
     $cc .= " -m32";
 
 } elsif ($arch eq "powerpc") {
-    $nm_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\.?\\S+)";
+    $local_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\.?\\S+)";
     $function_regex = "^([0-9a-fA-F]+)\\s+<(\\.?.*?)>:";
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s\\.?_mcount\$";
 
@@ -278,44 +328,17 @@ if ($filename =~ m,^(.*)(\.\S),) {
 my $mcount_s = $dirname . "/.tmp_mc_" . $prefix . ".s";
 my $mcount_o = $dirname . "/.tmp_mc_" . $prefix . ".o";
 
-#
-# --globalize-symbols came out in 2.17, we must test the version
-# of objcopy, and if it is less than 2.17, then we can not
-# record local functions.
-my $use_locals = 01;
-my $local_warn_once = 0;
-my $found_version = 0;
-
-open (IN, "$objcopy --version |") || die "error running $objcopy";
-while (<IN>) {
-    if (/objcopy.*\s(\d+)\.(\d+)/) {
-	my $major = $1;
-	my $minor = $2;
-
-	$found_version = 1;
-	if ($major < 2 ||
-	    ($major == 2 && $minor < 17)) {
-	    $use_locals = 0;
-	}
-	last;
-    }
-}
-close (IN);
-
-if (!$found_version) {
-    print STDERR "WARNING: could not find objcopy version.\n" .
-	"\tDisabling local function references.\n";
-}
+check_objcopy();
 
 #
 # Step 1: find all the local (static functions) and weak symbols.
-#        't' is local, 'w/W' is weak (we never use a weak function)
+#         't' is local, 'w/W' is weak
 #
 open (IN, "$nm $inputfile|") || die "error running $nm";
 while (<IN>) {
-    if (/$nm_regex/) {
+    if (/$local_regex/) {
 	$locals{$1} = 1;
-    } elsif (/^[0-9a-fA-F]+\s+([wW])\s+(\S+)/) {
+    } elsif (/$weak_regex/) {
 	$weak{$2} = $1;
     }
 }
@@ -333,26 +356,20 @@ my $offset = 0;		# offset of ref_func to section beginning
 #
 sub update_funcs
 {
-    return if ($#offsets < 0);
-
-    defined($ref_func) || die "No function to reference";
+    return unless ($ref_func and @offsets);
 
-    # A section only had a weak function, to represent it.
-    # Unfortunately, a weak function may be overwritten by another
-    # function of the same name, making all these offsets incorrect.
-    # To be safe, we simply print a warning and bail.
+    # Sanity check on weak function. A weak function may be overwritten by
+    # another function of the same name, making all these offsets incorrect.
     if (defined $weak{$ref_func}) {
-	print STDERR
-	    "$inputfile: WARNING: referencing weak function" .
+	die "$inputfile: ERROR: referencing weak function" .
 	    " $ref_func for mcount\n";
-	return;
     }
 
     # is this function static? If so, note this fact.
     if (defined $locals{$ref_func}) {
 
 	# only use locals if objcopy supports globalize-symbols
-	if (!$use_locals) {
+	if (!$can_use_local) {
 	    return;
 	}
 	$convert{$ref_func} = 1;
@@ -378,9 +395,27 @@ open(IN, "$objdump -hdr $inputfile|") || die "error running $objdump";
 
 my $text;
 
+
+# read headers first
 my $read_headers = 1;
 
 while (<IN>) {
+
+    if ($read_headers && /$mcount_section/) {
+	#
+	# Somehow the make process can execute this script on an
+	# object twice. If it does, we would duplicate the mcount
+	# section and it will cause the function tracer self test
+	# to fail. Check if the mcount section exists, and if it does,
+	# warn and exit.
+	#
+	print STDERR "ERROR: $mcount_section already in $inputfile\n" .
+	    "\tThis may be an indication that your build is corrupted.\n" .
+	    "\tDelete $inputfile and try again. If the same object file\n" .
+	    "\tstill causes an issue, then disable CONFIG_DYNAMIC_FTRACE.\n";
+	exit(-1);
+    }
+
     # is it a section?
     if (/$section_regex/) {
 	$read_headers = 0;
@@ -392,7 +427,7 @@ while (<IN>) {
 	    $read_function = 0;
 	}
 	# print out any recorded offsets
-	update_funcs() if (defined($ref_func));
+	update_funcs();
 
 	# reset all markers and arrays
 	$text_found = 0;
@@ -421,21 +456,7 @@ while (<IN>) {
 		$offset = hex $1;
 	    }
 	}
-    } elsif ($read_headers && /$mcount_section/) {
-	#
-	# Somehow the make process can execute this script on an
-	# object twice. If it does, we would duplicate the mcount
-	# section and it will cause the function tracer self test
-	# to fail. Check if the mcount section exists, and if it does,
-	# warn and exit.
-	#
-	print STDERR "ERROR: $mcount_section already in $inputfile\n" .
-	    "\tThis may be an indication that your build is corrupted.\n" .
-	    "\tDelete $inputfile and try again. If the same object file\n" .
-	    "\tstill causes an issue, then disable CONFIG_DYNAMIC_FTRACE.\n";
-	exit(-1);
     }
-
     # is this a call site to mcount? If so, record it to print later
     if ($text_found && /$mcount_regex/) {
 	$offsets[$#offsets + 1] = hex $1;
@@ -443,7 +464,7 @@ while (<IN>) {
 }
 
 # dump out anymore offsets that may have been found
-update_funcs() if (defined($ref_func));
+update_funcs();
 
 # If we did not find any mcount callers, we are done (do nothing).
 if (!$opened) {
