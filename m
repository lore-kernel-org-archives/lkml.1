Return-Path: <linux-kernel-owner+w=401wt.eu-S1753348AbYJ1Qq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbYJ1Qq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 12:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbYJ1Qqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 12:46:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49577 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216AbYJ1Qqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 12:46:47 -0400
Date: Tue, 28 Oct 2008 17:46:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC git pull] tracing fixes
Message-ID: <20081028164615.GA13425@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The latest tracing-fixes-for-linus git tree can be found at:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

While writing up this pull request i noticed that the diffstat of this 
tree grew unusually large :-(

Hence i changed it to an RFC pull request - and if it's not acceptable 
we will rebase it to be smaller.

Its size is due to three factors which gradually increased the size of 
the changes:

 - the dftraced daemon code removal (in favor of only allowing the 
   safer, build-time instrumentation variant)

 - further robustness improvements/fixes

 - the rename from CONFIG_FTRACE to CONFIG_FUNCTION_TRACER

   [ to fix a long-standing confusion factor that kernel developers 
     keep bumping into - between 'ftrace the framework' and 'ftrace 
     the function tracer'. This patch was ready in the merge window 
     but to complicate matters we had promised the SH tree to only do
     this rename after the SH tree's in-flight ftrace implementation 
     went upstream. But the SH tree went upstream near the end of the
     merge window via ed402af so we missed the window there. ]

we thought it prudent to include the robustness improvements as well 
(in v27 we got burned by being too conservative with such changes), 
and this is really a one-off event - but can restructure it all if 
it's too much at this stage, sift out and delay all the "wide" items 
to v2.6.29.

 Thanks,

	Ingo

------------------>
Alan Jenkins (2):
      tracing/fastboot: fix bootgraph.pl to run with "use strict"
      tracing/fastboot: fix row order in bootgraph.pl

Frederic Weisbecker (3):
      tracepoint: check if the probe has been registered
      tracing/ftrace: make boot tracer select the sched_switch tracer
      tracing: fix a build error on alpha

Ingo Molnar (2):
      ftrace: fix build failure
      ftrace: warning in kernel/trace/ftrace.c

Jonas Bonn (1):
      asm-generic: define DIE_OOPS in asm-generic

Peter Zijlstra (1):
      tracing: create tracers menu

Stephen Rothwell (1):
      trace: fix printk warning for u64

Steven Rostedt (21):
      ftrace: do not enclose logic in WARN_ON
      ftrace: release functions from hash
      ftrace: fix depends
      ftrace: rename FTRACE to FUNCTION_TRACER
      ftrace: rename the ftrace tracer to function
      ftrace: stack tracer only record when on stack
      ring-buffer: fix free page
      ftrace: handle generic arch calls
      ftrace: dynamic ftrace process only text section
      ftrace: return error on failed modified text.
      ftrace: comment arch ftrace code
      ftrace: use probe_kernel
      ftrace: only have ftrace_kill atomic
      ftrace: add ftrace warn on to disable ftrace
      ftrace: disable dynamic ftrace for all archs that use daemon
      ftrace: remove daemon
      ftrace: remove mcount set
      ftrace: remove ftrace hash
      ftrace, powerpc, sparc64, x86: remove notrace from arch ftrace file
      ftrace: use a real variable for ftrace_nop in x86
      ftrace: fix current_tracer error return


 Makefile                                 |    2 +-
 arch/arm/Kconfig                         |    3 +-
 arch/arm/boot/compressed/Makefile        |    2 +-
 arch/arm/include/asm/ftrace.h            |    2 +-
 arch/arm/kernel/armksyms.c               |    2 +-
 arch/arm/kernel/entry-common.S           |    4 +-
 arch/arm/kernel/ftrace.c                 |   13 -
 arch/powerpc/Kconfig                     |    3 +-
 arch/powerpc/Makefile                    |    2 +-
 arch/powerpc/include/asm/ftrace.h        |    2 +-
 arch/powerpc/kernel/Makefile             |    2 +-
 arch/powerpc/kernel/entry_32.S           |    2 +-
 arch/powerpc/kernel/entry_64.S           |    2 +-
 arch/powerpc/kernel/ftrace.c             |   27 +--
 arch/powerpc/kernel/ppc_ksyms.c          |    2 +-
 arch/powerpc/platforms/powermac/Makefile |    2 +-
 arch/sparc64/Kconfig                     |    3 +-
 arch/sparc64/Kconfig.debug               |    2 +-
 arch/sparc64/kernel/Makefile             |    2 +
 arch/sparc64/kernel/ftrace.c             |   26 +--
 arch/sparc64/lib/mcount.S                |    4 +-
 arch/x86/Kconfig                         |    2 +-
 arch/x86/include/asm/ftrace.h            |    4 +-
 arch/x86/kernel/Makefile                 |    3 +-
 arch/x86/kernel/entry_32.S               |    4 +-
 arch/x86/kernel/entry_64.S               |    4 +-
 arch/x86/kernel/ftrace.c                 |   50 +--
 arch/x86/kernel/i386_ksyms_32.c          |    2 +-
 arch/x86/kernel/x8664_ksyms_64.c         |    2 +-
 arch/x86/xen/Makefile                    |    2 +-
 include/asm-generic/kdebug.h             |    1 +
 include/linux/ftrace.h                   |   48 ++-
 kernel/Makefile                          |    4 +-
 kernel/sysctl.c                          |    2 +-
 kernel/trace/Kconfig                     |   27 +-
 kernel/trace/Makefile                    |    6 +-
 kernel/trace/ftrace.c                    |  608 +++++-------------------------
 kernel/trace/ring_buffer.c               |    6 +-
 kernel/trace/trace.c                     |   15 +-
 kernel/trace/trace.h                     |    2 +-
 kernel/trace/trace_functions.c           |    2 +-
 kernel/trace/trace_irqsoff.c             |    4 +-
 kernel/trace/trace_sched_wakeup.c        |    4 +-
 kernel/trace/trace_selftest.c            |   18 +-
 kernel/trace/trace_stack.c               |    4 +
 kernel/tracepoint.c                      |    8 +
 lib/Makefile                             |    2 +-
 scripts/Makefile.build                   |   10 +-
 scripts/bootgraph.pl                     |   19 +-
 scripts/recordmcount.pl                  |   28 ++-
 50 files changed, 284 insertions(+), 716 deletions(-)

diff --git a/Makefile b/Makefile
index e9c5d47..a7f2068 100644
--- a/Makefile
+++ b/Makefile
@@ -536,7 +536,7 @@ KBUILD_CFLAGS	+= -g
 KBUILD_AFLAGS	+= -gdwarf-2
 endif
 
-ifdef CONFIG_FTRACE
+ifdef CONFIG_FUNCTION_TRACER
 KBUILD_CFLAGS	+= -pg
 endif
 
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 5021db2..9722f8b 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -16,8 +16,7 @@ config ARM
 	select HAVE_ARCH_KGDB
 	select HAVE_KPROBES if (!XIP_KERNEL)
 	select HAVE_KRETPROBES if (HAVE_KPROBES)
-	select HAVE_FTRACE if (!XIP_KERNEL)
-	select HAVE_DYNAMIC_FTRACE if (HAVE_FTRACE)
+	select HAVE_FUNCTION_TRACER if (!XIP_KERNEL)
 	select HAVE_GENERIC_DMA_COHERENT
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index 7a03f20..c47f2a3 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -70,7 +70,7 @@ SEDFLAGS	= s/TEXT_START/$(ZTEXTADDR)/;s/BSS_START/$(ZBSSADDR)/
 targets       := vmlinux vmlinux.lds piggy.gz piggy.o font.o font.c \
 		 head.o misc.o $(OBJS)
 
-ifeq ($(CONFIG_FTRACE),y)
+ifeq ($(CONFIG_FUNCTION_TRACER),y)
 ORIG_CFLAGS := $(KBUILD_CFLAGS)
 KBUILD_CFLAGS = $(subst -pg, , $(ORIG_CFLAGS))
 endif
diff --git a/arch/arm/include/asm/ftrace.h b/arch/arm/include/asm/ftrace.h
index 584ef9a..39c8bc1 100644
--- a/arch/arm/include/asm/ftrace.h
+++ b/arch/arm/include/asm/ftrace.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_ARM_FTRACE
 #define _ASM_ARM_FTRACE
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 #define MCOUNT_ADDR		((long)(mcount))
 #define MCOUNT_INSN_SIZE	4 /* sizeof mcount call */
 
diff --git a/arch/arm/kernel/armksyms.c b/arch/arm/kernel/armksyms.c
index 2357b1c..c74f766 100644
--- a/arch/arm/kernel/armksyms.c
+++ b/arch/arm/kernel/armksyms.c
@@ -183,6 +183,6 @@ EXPORT_SYMBOL(_find_next_bit_be);
 
 EXPORT_SYMBOL(copy_page);
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 EXPORT_SYMBOL(mcount);
 #endif
diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 3aa14dc..06269ea 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -101,7 +101,7 @@ ENDPROC(ret_from_fork)
 #undef CALL
 #define CALL(x) .long x
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 #ifdef CONFIG_DYNAMIC_FTRACE
 ENTRY(mcount)
 	stmdb sp!, {r0-r3, lr}
@@ -149,7 +149,7 @@ trace:
 ftrace_stub:
 	mov pc, lr
 
-#endif /* CONFIG_FTRACE */
+#endif /* CONFIG_FUNCTION_TRACER */
 
 /*=============================================================================
  * SWI handler
diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
index 76d50e6..6c90479 100644
--- a/arch/arm/kernel/ftrace.c
+++ b/arch/arm/kernel/ftrace.c
@@ -95,19 +95,6 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 	return ret;
 }
 
-int ftrace_mcount_set(unsigned long *data)
-{
-	unsigned long pc, old;
-	unsigned long *addr = data;
-	unsigned char *new;
-
-	pc = (unsigned long)&mcount_call;
-	memcpy(&old, &mcount_call, MCOUNT_INSN_SIZE);
-	new = ftrace_call_replace(pc, *addr);
-	*addr = ftrace_modify_code(pc, (unsigned char *)&old, new);
-	return 0;
-}
-
 /* run from kstop_machine */
 int __init ftrace_dyn_arch_init(void *data)
 {
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 5b15278..525c13a 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -108,8 +108,7 @@ config ARCH_NO_VIRT_TO_BUS
 config PPC
 	bool
 	default y
-	select HAVE_DYNAMIC_FTRACE
-	select HAVE_FTRACE
+	select HAVE_FUNCTION_TRACER
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_IDE
 	select HAVE_IOREMAP_PROT
diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 24dd1a3..1f06670 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -122,7 +122,7 @@ KBUILD_CFLAGS		+= -mcpu=powerpc
 endif
 
 # Work around a gcc code-gen bug with -fno-omit-frame-pointer.
-ifeq ($(CONFIG_FTRACE),y)
+ifeq ($(CONFIG_FUNCTION_TRACER),y)
 KBUILD_CFLAGS		+= -mno-sched-epilog
 endif
 
diff --git a/arch/powerpc/include/asm/ftrace.h b/arch/powerpc/include/asm/ftrace.h
index de92132..b298f7a 100644
--- a/arch/powerpc/include/asm/ftrace.h
+++ b/arch/powerpc/include/asm/ftrace.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_POWERPC_FTRACE
 #define _ASM_POWERPC_FTRACE
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 #define MCOUNT_ADDR		((long)(_mcount))
 #define MCOUNT_INSN_SIZE	4 /* sizeof mcount call */
 
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index fdb5825..92673b4 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -12,7 +12,7 @@ CFLAGS_prom_init.o      += -fPIC
 CFLAGS_btext.o		+= -fPIC
 endif
 
-ifdef CONFIG_FTRACE
+ifdef CONFIG_FUNCTION_TRACER
 # Do not trace early boot code
 CFLAGS_REMOVE_cputable.o = -pg -mno-sched-epilog
 CFLAGS_REMOVE_prom_init.o = -pg -mno-sched-epilog
diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
index 1cbbf70..7ecc0d1 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -1158,7 +1158,7 @@ machine_check_in_rtas:
 
 #endif /* CONFIG_PPC_RTAS */
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 #ifdef CONFIG_DYNAMIC_FTRACE
 _GLOBAL(mcount)
 _GLOBAL(_mcount)
diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index fd8b4ba..e6d5284 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -884,7 +884,7 @@ _GLOBAL(enter_prom)
 	mtlr    r0
         blr
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 #ifdef CONFIG_DYNAMIC_FTRACE
 _GLOBAL(mcount)
 _GLOBAL(_mcount)
diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index 3855ceb..f4b006e 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -28,17 +28,17 @@ static unsigned int ftrace_nop = 0x60000000;
 #endif
 
 
-static unsigned int notrace ftrace_calc_offset(long ip, long addr)
+static unsigned int ftrace_calc_offset(long ip, long addr)
 {
 	return (int)(addr - ip);
 }
 
-notrace unsigned char *ftrace_nop_replace(void)
+unsigned char *ftrace_nop_replace(void)
 {
 	return (char *)&ftrace_nop;
 }
 
-notrace unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
+unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
 {
 	static unsigned int op;
 
@@ -68,7 +68,7 @@ notrace unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
 # define _ASM_PTR	" .long "
 #endif
 
-notrace int
+int
 ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 		   unsigned char *new_code)
 {
@@ -113,7 +113,7 @@ ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 	return faulted;
 }
 
-notrace int ftrace_update_ftrace_func(ftrace_func_t func)
+int ftrace_update_ftrace_func(ftrace_func_t func)
 {
 	unsigned long ip = (unsigned long)(&ftrace_call);
 	unsigned char old[MCOUNT_INSN_SIZE], *new;
@@ -126,23 +126,6 @@ notrace int ftrace_update_ftrace_func(ftrace_func_t func)
 	return ret;
 }
 
-notrace int ftrace_mcount_set(unsigned long *data)
-{
-	unsigned long ip = (long)(&mcount_call);
-	unsigned long *addr = data;
-	unsigned char old[MCOUNT_INSN_SIZE], *new;
-
-	/*
-	 * Replace the mcount stub with a pointer to the
-	 * ip recorder function.
-	 */
-	memcpy(old, &mcount_call, MCOUNT_INSN_SIZE);
-	new = ftrace_call_replace(ip, *addr);
-	*addr = ftrace_modify_code(ip, old, new);
-
-	return 0;
-}
-
 int __init ftrace_dyn_arch_init(void *data)
 {
 	/* This is running in kstop_machine */
diff --git a/arch/powerpc/kernel/ppc_ksyms.c b/arch/powerpc/kernel/ppc_ksyms.c
index 8edc235..260089d 100644
--- a/arch/powerpc/kernel/ppc_ksyms.c
+++ b/arch/powerpc/kernel/ppc_ksyms.c
@@ -68,7 +68,7 @@ EXPORT_SYMBOL(single_step_exception);
 EXPORT_SYMBOL(sys_sigreturn);
 #endif
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 EXPORT_SYMBOL(_mcount);
 #endif
 
diff --git a/arch/powerpc/platforms/powermac/Makefile b/arch/powerpc/platforms/powermac/Makefile
index be60d64..50f1693 100644
--- a/arch/powerpc/platforms/powermac/Makefile
+++ b/arch/powerpc/platforms/powermac/Makefile
@@ -1,6 +1,6 @@
 CFLAGS_bootx_init.o  		+= -fPIC
 
-ifdef CONFIG_FTRACE
+ifdef CONFIG_FUNCTION_TRACER
 # Do not trace early boot code
 CFLAGS_REMOVE_bootx_init.o = -pg -mno-sched-epilog
 endif
diff --git a/arch/sparc64/Kconfig b/arch/sparc64/Kconfig
index 035b15a..3b96e70 100644
--- a/arch/sparc64/Kconfig
+++ b/arch/sparc64/Kconfig
@@ -11,8 +11,7 @@ config SPARC
 config SPARC64
 	bool
 	default y
-	select HAVE_DYNAMIC_FTRACE
-	select HAVE_FTRACE
+	select HAVE_FUNCTION_TRACER
 	select HAVE_IDE
 	select HAVE_LMB
 	select HAVE_ARCH_KGDB
diff --git a/arch/sparc64/Kconfig.debug b/arch/sparc64/Kconfig.debug
index d6d32d1..c40515c 100644
--- a/arch/sparc64/Kconfig.debug
+++ b/arch/sparc64/Kconfig.debug
@@ -33,7 +33,7 @@ config DEBUG_PAGEALLOC
 
 config MCOUNT
 	bool
-	depends on STACK_DEBUG || FTRACE
+	depends on STACK_DEBUG || FUNCTION_TRACER
 	default y
 
 config FRAME_POINTER
diff --git a/arch/sparc64/kernel/Makefile b/arch/sparc64/kernel/Makefile
index c0b8009..b3e0b98 100644
--- a/arch/sparc64/kernel/Makefile
+++ b/arch/sparc64/kernel/Makefile
@@ -5,6 +5,8 @@
 EXTRA_AFLAGS := -ansi
 EXTRA_CFLAGS := -Werror
 
+CFLAGS_REMOVE_ftrace.o = -pg
+
 extra-y		:= head.o init_task.o vmlinux.lds
 
 obj-y		:= process.o setup.o cpu.o idprom.o reboot.o \
diff --git a/arch/sparc64/kernel/ftrace.c b/arch/sparc64/kernel/ftrace.c
index 4298d0a..d0218e7 100644
--- a/arch/sparc64/kernel/ftrace.c
+++ b/arch/sparc64/kernel/ftrace.c
@@ -9,12 +9,12 @@
 
 static const u32 ftrace_nop = 0x01000000;
 
-notrace unsigned char *ftrace_nop_replace(void)
+unsigned char *ftrace_nop_replace(void)
 {
 	return (char *)&ftrace_nop;
 }
 
-notrace unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
+unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
 {
 	static u32 call;
 	s32 off;
@@ -25,7 +25,7 @@ notrace unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
 	return (unsigned char *) &call;
 }
 
-notrace int
+int
 ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 		   unsigned char *new_code)
 {
@@ -59,7 +59,7 @@ ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 	return faulted;
 }
 
-notrace int ftrace_update_ftrace_func(ftrace_func_t func)
+int ftrace_update_ftrace_func(ftrace_func_t func)
 {
 	unsigned long ip = (unsigned long)(&ftrace_call);
 	unsigned char old[MCOUNT_INSN_SIZE], *new;
@@ -69,24 +69,6 @@ notrace int ftrace_update_ftrace_func(ftrace_func_t func)
 	return ftrace_modify_code(ip, old, new);
 }
 
-notrace int ftrace_mcount_set(unsigned long *data)
-{
-	unsigned long ip = (long)(&mcount_call);
-	unsigned long *addr = data;
-	unsigned char old[MCOUNT_INSN_SIZE], *new;
-
-	/*
-	 * Replace the mcount stub with a pointer to the
-	 * ip recorder function.
-	 */
-	memcpy(old, &mcount_call, MCOUNT_INSN_SIZE);
-	new = ftrace_call_replace(ip, *addr);
-	*addr = ftrace_modify_code(ip, old, new);
-
-	return 0;
-}
-
-
 int __init ftrace_dyn_arch_init(void *data)
 {
 	ftrace_mcount_set(data);
diff --git a/arch/sparc64/lib/mcount.S b/arch/sparc64/lib/mcount.S
index fad90dd..7ce9c65 100644
--- a/arch/sparc64/lib/mcount.S
+++ b/arch/sparc64/lib/mcount.S
@@ -93,7 +93,7 @@ mcount:
 	 nop
 1:
 #endif
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 #ifdef CONFIG_DYNAMIC_FTRACE
 	mov		%o7, %o0
 	.globl		mcount_call
@@ -119,7 +119,7 @@ mcount_call:
 	.size		_mcount,.-_mcount
 	.size		mcount,.-mcount
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 	.globl		ftrace_stub
 	.type		ftrace_stub,#function
 ftrace_stub:
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 350bee1..d11d7b5 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -28,7 +28,7 @@ config X86
 	select HAVE_KRETPROBES
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_DYNAMIC_FTRACE
-	select HAVE_FTRACE
+	select HAVE_FUNCTION_TRACER
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
 	select HAVE_ARCH_KGDB if !X86_VOYAGER
 	select HAVE_ARCH_TRACEHOOK
diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index 47f7e65..9e8bc29 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_X86_FTRACE_H
 #define _ASM_X86_FTRACE_H
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 #define MCOUNT_ADDR		((long)(mcount))
 #define MCOUNT_INSN_SIZE	5 /* sizeof mcount call */
 
@@ -19,6 +19,6 @@ static inline unsigned long ftrace_call_adjust(unsigned long addr)
 }
 #endif
 
-#endif /* CONFIG_FTRACE */
+#endif /* CONFIG_FUNCTION_TRACER */
 
 #endif /* _ASM_X86_FTRACE_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index d7e5a58..e489ff9 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -6,11 +6,12 @@ extra-y                := head_$(BITS).o head$(BITS).o head.o init_task.o vmlinu
 
 CPPFLAGS_vmlinux.lds += -U$(UTS_MACHINE)
 
-ifdef CONFIG_FTRACE
+ifdef CONFIG_FUNCTION_TRACER
 # Do not profile debug and lowlevel utilities
 CFLAGS_REMOVE_tsc.o = -pg
 CFLAGS_REMOVE_rtc.o = -pg
 CFLAGS_REMOVE_paravirt-spinlocks.o = -pg
+CFLAGS_REMOVE_ftrace.o = -pg
 endif
 
 #
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index dd65143..28b597e 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1149,7 +1149,7 @@ ENDPROC(xen_failsafe_callback)
 
 #endif	/* CONFIG_XEN */
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 #ifdef CONFIG_DYNAMIC_FTRACE
 
 ENTRY(mcount)
@@ -1204,7 +1204,7 @@ trace:
 	jmp ftrace_stub
 END(mcount)
 #endif /* CONFIG_DYNAMIC_FTRACE */
-#endif /* CONFIG_FTRACE */
+#endif /* CONFIG_FUNCTION_TRACER */
 
 .section .rodata,"a"
 #include "syscall_table_32.S"
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 09e7145..b86f332 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -61,7 +61,7 @@
 
 	.code64
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 #ifdef CONFIG_DYNAMIC_FTRACE
 ENTRY(mcount)
 	retq
@@ -138,7 +138,7 @@ trace:
 	jmp ftrace_stub
 END(mcount)
 #endif /* CONFIG_DYNAMIC_FTRACE */
-#endif /* CONFIG_FTRACE */
+#endif /* CONFIG_FUNCTION_TRACER */
 
 #ifndef CONFIG_PREEMPT
 #define retint_kernel retint_restore_args
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index d073d98..50ea0ac 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -21,8 +21,7 @@
 #include <asm/nops.h>
 
 
-/* Long is fine, even if it is only 4 bytes ;-) */
-static unsigned long *ftrace_nop;
+static unsigned char ftrace_nop[MCOUNT_INSN_SIZE];
 
 union ftrace_code_union {
 	char code[MCOUNT_INSN_SIZE];
@@ -33,17 +32,17 @@ union ftrace_code_union {
 };
 
 
-static int notrace ftrace_calc_offset(long ip, long addr)
+static int ftrace_calc_offset(long ip, long addr)
 {
 	return (int)(addr - ip);
 }
 
-notrace unsigned char *ftrace_nop_replace(void)
+unsigned char *ftrace_nop_replace(void)
 {
-	return (char *)ftrace_nop;
+	return ftrace_nop;
 }
 
-notrace unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
+unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
 {
 	static union ftrace_code_union calc;
 
@@ -57,7 +56,7 @@ notrace unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
 	return calc.code;
 }
 
-notrace int
+int
 ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 		   unsigned char *new_code)
 {
@@ -66,26 +65,31 @@ ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 	/*
 	 * Note: Due to modules and __init, code can
 	 *  disappear and change, we need to protect against faulting
-	 *  as well as code changing.
+	 *  as well as code changing. We do this by using the
+	 *  probe_kernel_* functions.
 	 *
 	 * No real locking needed, this code is run through
 	 * kstop_machine, or before SMP starts.
 	 */
-	if (__copy_from_user_inatomic(replaced, (char __user *)ip, MCOUNT_INSN_SIZE))
-		return 1;
 
+	/* read the text we want to modify */
+	if (probe_kernel_read(replaced, (void *)ip, MCOUNT_INSN_SIZE))
+		return -EFAULT;
+
+	/* Make sure it is what we expect it to be */
 	if (memcmp(replaced, old_code, MCOUNT_INSN_SIZE) != 0)
-		return 2;
+		return -EINVAL;
 
-	WARN_ON_ONCE(__copy_to_user_inatomic((char __user *)ip, new_code,
-				    MCOUNT_INSN_SIZE));
+	/* replace the text with the new text */
+	if (probe_kernel_write((void *)ip, new_code, MCOUNT_INSN_SIZE))
+		return -EPERM;
 
 	sync_core();
 
 	return 0;
 }
 
-notrace int ftrace_update_ftrace_func(ftrace_func_t func)
+int ftrace_update_ftrace_func(ftrace_func_t func)
 {
 	unsigned long ip = (unsigned long)(&ftrace_call);
 	unsigned char old[MCOUNT_INSN_SIZE], *new;
@@ -98,13 +102,6 @@ notrace int ftrace_update_ftrace_func(ftrace_func_t func)
 	return ret;
 }
 
-notrace int ftrace_mcount_set(unsigned long *data)
-{
-	/* mcount is initialized as a nop */
-	*data = 0;
-	return 0;
-}
-
 int __init ftrace_dyn_arch_init(void *data)
 {
 	extern const unsigned char ftrace_test_p6nop[];
@@ -127,9 +124,6 @@ int __init ftrace_dyn_arch_init(void *data)
 	 * TODO: check the cpuid to determine the best nop.
 	 */
 	asm volatile (
-		"jmp ftrace_test_jmp\n"
-		/* This code needs to stay around */
-		".section .text, \"ax\"\n"
 		"ftrace_test_jmp:"
 		"jmp ftrace_test_p6nop\n"
 		"nop\n"
@@ -140,8 +134,6 @@ int __init ftrace_dyn_arch_init(void *data)
 		"jmp 1f\n"
 		"ftrace_test_nop5:"
 		".byte 0x66,0x66,0x66,0x66,0x90\n"
-		"jmp 1f\n"
-		".previous\n"
 		"1:"
 		".section .fixup, \"ax\"\n"
 		"2:	movl $1, %0\n"
@@ -156,15 +148,15 @@ int __init ftrace_dyn_arch_init(void *data)
 	switch (faulted) {
 	case 0:
 		pr_info("ftrace: converting mcount calls to 0f 1f 44 00 00\n");
-		ftrace_nop = (unsigned long *)ftrace_test_p6nop;
+		memcpy(ftrace_nop, ftrace_test_p6nop, MCOUNT_INSN_SIZE);
 		break;
 	case 1:
 		pr_info("ftrace: converting mcount calls to 66 66 66 66 90\n");
-		ftrace_nop = (unsigned long *)ftrace_test_nop5;
+		memcpy(ftrace_nop, ftrace_test_nop5, MCOUNT_INSN_SIZE);
 		break;
 	case 2:
 		pr_info("ftrace: converting mcount calls to jmp . + 5\n");
-		ftrace_nop = (unsigned long *)ftrace_test_jmp;
+		memcpy(ftrace_nop, ftrace_test_jmp, MCOUNT_INSN_SIZE);
 		break;
 	}
 
diff --git a/arch/x86/kernel/i386_ksyms_32.c b/arch/x86/kernel/i386_ksyms_32.c
index dd7ebee..43cec6b 100644
--- a/arch/x86/kernel/i386_ksyms_32.c
+++ b/arch/x86/kernel/i386_ksyms_32.c
@@ -5,7 +5,7 @@
 #include <asm/desc.h>
 #include <asm/ftrace.h>
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 /* mcount is defined in assembly */
 EXPORT_SYMBOL(mcount);
 #endif
diff --git a/arch/x86/kernel/x8664_ksyms_64.c b/arch/x86/kernel/x8664_ksyms_64.c
index b545f37..695e426 100644
--- a/arch/x86/kernel/x8664_ksyms_64.c
+++ b/arch/x86/kernel/x8664_ksyms_64.c
@@ -12,7 +12,7 @@
 #include <asm/desc.h>
 #include <asm/ftrace.h>
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 /* mcount is defined in assembly */
 EXPORT_SYMBOL(mcount);
 #endif
diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index 3139479..6dcefba 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -1,4 +1,4 @@
-ifdef CONFIG_FTRACE
+ifdef CONFIG_FUNCTION_TRACER
 # Do not profile debug and lowlevel utilities
 CFLAGS_REMOVE_spinlock.o = -pg
 CFLAGS_REMOVE_time.o = -pg
diff --git a/include/asm-generic/kdebug.h b/include/asm-generic/kdebug.h
index 2b799c9..11e57b6 100644
--- a/include/asm-generic/kdebug.h
+++ b/include/asm-generic/kdebug.h
@@ -3,6 +3,7 @@
 
 enum die_val {
 	DIE_UNUSED,
+	DIE_OOPS=1
 };
 
 #endif /* _ASM_GENERIC_KDEBUG_H */
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index a3d4615..703eb53 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -8,7 +8,7 @@
 #include <linux/types.h>
 #include <linux/kallsyms.h>
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 
 extern int ftrace_enabled;
 extern int
@@ -36,16 +36,14 @@ void clear_ftrace_function(void);
 
 extern void ftrace_stub(unsigned long a0, unsigned long a1);
 
-#else /* !CONFIG_FTRACE */
+#else /* !CONFIG_FUNCTION_TRACER */
 # define register_ftrace_function(ops) do { } while (0)
 # define unregister_ftrace_function(ops) do { } while (0)
 # define clear_ftrace_function(ops) do { } while (0)
-static inline void ftrace_kill_atomic(void) { }
-#endif /* CONFIG_FTRACE */
+static inline void ftrace_kill(void) { }
+#endif /* CONFIG_FUNCTION_TRACER */
 
 #ifdef CONFIG_DYNAMIC_FTRACE
-# define FTRACE_HASHBITS	10
-# define FTRACE_HASHSIZE	(1<<FTRACE_HASHBITS)
 
 enum {
 	FTRACE_FL_FREE		= (1 << 0),
@@ -58,9 +56,9 @@ enum {
 };
 
 struct dyn_ftrace {
-	struct hlist_node node;
-	unsigned long	  ip; /* address of mcount call-site */
-	unsigned long	  flags;
+	struct list_head	list;
+	unsigned long		ip; /* address of mcount call-site */
+	unsigned long		flags;
 };
 
 int ftrace_force_update(void);
@@ -71,14 +69,33 @@ extern int ftrace_ip_converted(unsigned long ip);
 extern unsigned char *ftrace_nop_replace(void);
 extern unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr);
 extern int ftrace_dyn_arch_init(void *data);
-extern int ftrace_mcount_set(unsigned long *data);
-extern int ftrace_modify_code(unsigned long ip, unsigned char *old_code,
-			      unsigned char *new_code);
 extern int ftrace_update_ftrace_func(ftrace_func_t func);
 extern void ftrace_caller(void);
 extern void ftrace_call(void);
 extern void mcount_call(void);
 
+/**
+ * ftrace_modify_code - modify code segment
+ * @ip: the address of the code segment
+ * @old_code: the contents of what is expected to be there
+ * @new_code: the code to patch in
+ *
+ * This is a very sensitive operation and great care needs
+ * to be taken by the arch.  The operation should carefully
+ * read the location, check to see if what is read is indeed
+ * what we expect it to be, and then on success of the compare,
+ * it should write to the location.
+ *
+ * Return must be:
+ *  0 on success
+ *  -EFAULT on error reading the location
+ *  -EINVAL on a failed compare of the contents
+ *  -EPERM  on error writing to the location
+ * Any other value will be considered a failure.
+ */
+extern int ftrace_modify_code(unsigned long ip, unsigned char *old_code,
+			      unsigned char *new_code);
+
 extern int skip_trace(unsigned long ip);
 
 extern void ftrace_release(void *start, unsigned long size);
@@ -97,11 +114,10 @@ static inline void ftrace_release(void *start, unsigned long size) { }
 
 /* totally disable ftrace - can not re-enable after this */
 void ftrace_kill(void);
-void ftrace_kill_atomic(void);
 
 static inline void tracer_disable(void)
 {
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 	ftrace_enabled = 0;
 #endif
 }
@@ -113,7 +129,7 @@ static inline void tracer_disable(void)
  */
 static inline int __ftrace_enabled_save(void)
 {
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 	int saved_ftrace_enabled = ftrace_enabled;
 	ftrace_enabled = 0;
 	return saved_ftrace_enabled;
@@ -124,7 +140,7 @@ static inline int __ftrace_enabled_save(void)
 
 static inline void __ftrace_enabled_restore(int enabled)
 {
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 	ftrace_enabled = enabled;
 #endif
 }
diff --git a/kernel/Makefile b/kernel/Makefile
index 305f11d..9a3ec66 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -13,7 +13,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
 
 CFLAGS_REMOVE_sched.o = -mno-spe
 
-ifdef CONFIG_FTRACE
+ifdef CONFIG_FUNCTION_TRACER
 # Do not trace debug files and internal ftrace files
 CFLAGS_REMOVE_lockdep.o = -pg
 CFLAGS_REMOVE_lockdep_proc.o = -pg
@@ -88,7 +88,7 @@ obj-$(CONFIG_MARKERS) += marker.o
 obj-$(CONFIG_TRACEPOINTS) += tracepoint.o
 obj-$(CONFIG_LATENCYTOP) += latencytop.o
 obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
-obj-$(CONFIG_FTRACE) += trace/
+obj-$(CONFIG_FUNCTION_TRACER) += trace/
 obj-$(CONFIG_TRACING) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index a13bd4d..9d048fa 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -474,7 +474,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 	{
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "ftrace_enabled",
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 1cb3e1f..e0cea28 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -1,11 +1,12 @@
 #
-# Architectures that offer an FTRACE implementation should select HAVE_FTRACE:
+# Architectures that offer an FUNCTION_TRACER implementation should
+#  select HAVE_FUNCTION_TRACER:
 #
 
 config NOP_TRACER
 	bool
 
-config HAVE_FTRACE
+config HAVE_FUNCTION_TRACER
 	bool
 	select NOP_TRACER
 
@@ -28,9 +29,11 @@ config TRACING
 	select STACKTRACE
 	select TRACEPOINTS
 
-config FTRACE
+menu "Tracers"
+
+config FUNCTION_TRACER
 	bool "Kernel Function Tracer"
-	depends on HAVE_FTRACE
+	depends on HAVE_FUNCTION_TRACER
 	depends on DEBUG_KERNEL
 	select FRAME_POINTER
 	select TRACING
@@ -49,7 +52,6 @@ config IRQSOFF_TRACER
 	default n
 	depends on TRACE_IRQFLAGS_SUPPORT
 	depends on GENERIC_TIME
-	depends on HAVE_FTRACE
 	depends on DEBUG_KERNEL
 	select TRACE_IRQFLAGS
 	select TRACING
@@ -73,7 +75,6 @@ config PREEMPT_TRACER
 	default n
 	depends on GENERIC_TIME
 	depends on PREEMPT
-	depends on HAVE_FTRACE
 	depends on DEBUG_KERNEL
 	select TRACING
 	select TRACER_MAX_TRACE
@@ -101,7 +102,6 @@ config SYSPROF_TRACER
 
 config SCHED_TRACER
 	bool "Scheduling Latency Tracer"
-	depends on HAVE_FTRACE
 	depends on DEBUG_KERNEL
 	select TRACING
 	select CONTEXT_SWITCH_TRACER
@@ -112,7 +112,6 @@ config SCHED_TRACER
 
 config CONTEXT_SWITCH_TRACER
 	bool "Trace process context switches"
-	depends on HAVE_FTRACE
 	depends on DEBUG_KERNEL
 	select TRACING
 	select MARKERS
@@ -122,9 +121,9 @@ config CONTEXT_SWITCH_TRACER
 
 config BOOT_TRACER
 	bool "Trace boot initcalls"
-	depends on HAVE_FTRACE
 	depends on DEBUG_KERNEL
 	select TRACING
+	select CONTEXT_SWITCH_TRACER
 	help
 	  This tracer helps developers to optimize boot times: it records
 	  the timings of the initcalls and traces key events and the identity
@@ -141,9 +140,9 @@ config BOOT_TRACER
 
 config STACK_TRACER
 	bool "Trace max stack"
-	depends on HAVE_FTRACE
+	depends on HAVE_FUNCTION_TRACER
 	depends on DEBUG_KERNEL
-	select FTRACE
+	select FUNCTION_TRACER
 	select STACKTRACE
 	help
 	  This special tracer records the maximum stack footprint of the
@@ -160,7 +159,7 @@ config STACK_TRACER
 
 config DYNAMIC_FTRACE
 	bool "enable/disable ftrace tracepoints dynamically"
-	depends on FTRACE
+	depends on FUNCTION_TRACER
 	depends on HAVE_DYNAMIC_FTRACE
 	depends on DEBUG_KERNEL
 	default y
@@ -170,7 +169,7 @@ config DYNAMIC_FTRACE
 	 with a No-Op instruction) as they are called. A table is
 	 created to dynamically enable them again.
 
-	 This way a CONFIG_FTRACE kernel is slightly larger, but otherwise
+	 This way a CONFIG_FUNCTION_TRACER kernel is slightly larger, but otherwise
 	 has native performance as long as no tracing is active.
 
 	 The changes to the code are done by a kernel thread that
@@ -195,3 +194,5 @@ config FTRACE_STARTUP_TEST
 	  a series of tests are made to verify that the tracer is
 	  functioning properly. It will do tests on all the configured
 	  tracers of ftrace.
+
+endmenu
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index a85dfba..c8228b1 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -1,7 +1,7 @@
 
 # Do not instrument the tracer itself:
 
-ifdef CONFIG_FTRACE
+ifdef CONFIG_FUNCTION_TRACER
 ORIG_CFLAGS := $(KBUILD_CFLAGS)
 KBUILD_CFLAGS = $(subst -pg,,$(ORIG_CFLAGS))
 
@@ -10,13 +10,13 @@ CFLAGS_trace_selftest_dynamic.o = -pg
 obj-y += trace_selftest_dynamic.o
 endif
 
-obj-$(CONFIG_FTRACE) += libftrace.o
+obj-$(CONFIG_FUNCTION_TRACER) += libftrace.o
 obj-$(CONFIG_RING_BUFFER) += ring_buffer.o
 
 obj-$(CONFIG_TRACING) += trace.o
 obj-$(CONFIG_CONTEXT_SWITCH_TRACER) += trace_sched_switch.o
 obj-$(CONFIG_SYSPROF_TRACER) += trace_sysprof.o
-obj-$(CONFIG_FTRACE) += trace_functions.o
+obj-$(CONFIG_FUNCTION_TRACER) += trace_functions.o
 obj-$(CONFIG_IRQSOFF_TRACER) += trace_irqsoff.o
 obj-$(CONFIG_PREEMPT_TRACER) += trace_irqsoff.o
 obj-$(CONFIG_SCHED_TRACER) += trace_sched_wakeup.o
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4dda4f6..7618c52 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -25,13 +25,24 @@
 #include <linux/ftrace.h>
 #include <linux/sysctl.h>
 #include <linux/ctype.h>
-#include <linux/hash.h>
 #include <linux/list.h>
 
 #include <asm/ftrace.h>
 
 #include "trace.h"
 
+#define FTRACE_WARN_ON(cond)			\
+	do {					\
+		if (WARN_ON(cond))		\
+			ftrace_kill();		\
+	} while (0)
+
+#define FTRACE_WARN_ON_ONCE(cond)		\
+	do {					\
+		if (WARN_ON_ONCE(cond))		\
+			ftrace_kill();		\
+	} while (0)
+
 /* ftrace_enabled is a method to turn ftrace on or off */
 int ftrace_enabled __read_mostly;
 static int last_ftrace_enabled;
@@ -153,21 +164,8 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 }
 
 #ifdef CONFIG_DYNAMIC_FTRACE
-
 #ifndef CONFIG_FTRACE_MCOUNT_RECORD
-/*
- * The hash lock is only needed when the recording of the mcount
- * callers are dynamic. That is, by the caller themselves and
- * not recorded via the compilation.
- */
-static DEFINE_SPINLOCK(ftrace_hash_lock);
-#define ftrace_hash_lock(flags)	  spin_lock_irqsave(&ftrace_hash_lock, flags)
-#define ftrace_hash_unlock(flags) \
-			spin_unlock_irqrestore(&ftrace_hash_lock, flags)
-#else
-/* This is protected via the ftrace_lock with MCOUNT_RECORD. */
-#define ftrace_hash_lock(flags)   do { (void)(flags); } while (0)
-#define ftrace_hash_unlock(flags) do { } while(0)
+# error Dynamic ftrace depends on MCOUNT_RECORD
 #endif
 
 /*
@@ -178,8 +176,6 @@ static DEFINE_SPINLOCK(ftrace_hash_lock);
  */
 static unsigned long mcount_addr = MCOUNT_ADDR;
 
-static struct task_struct *ftraced_task;
-
 enum {
 	FTRACE_ENABLE_CALLS		= (1 << 0),
 	FTRACE_DISABLE_CALLS		= (1 << 1),
@@ -190,13 +186,9 @@ enum {
 
 static int ftrace_filtered;
 static int tracing_on;
-static int frozen_record_count;
 
-static struct hlist_head ftrace_hash[FTRACE_HASHSIZE];
+static LIST_HEAD(ftrace_new_addrs);
 
-static DEFINE_PER_CPU(int, ftrace_shutdown_disable_cpu);
-
-static DEFINE_MUTEX(ftraced_lock);
 static DEFINE_MUTEX(ftrace_regex_lock);
 
 struct ftrace_page {
@@ -214,16 +206,13 @@ struct ftrace_page {
 static struct ftrace_page	*ftrace_pages_start;
 static struct ftrace_page	*ftrace_pages;
 
-static int ftraced_trigger;
-static int ftraced_suspend;
-static int ftraced_stop;
-
-static int ftrace_record_suspend;
-
 static struct dyn_ftrace *ftrace_free_records;
 
 
 #ifdef CONFIG_KPROBES
+
+static int frozen_record_count;
+
 static inline void freeze_record(struct dyn_ftrace *rec)
 {
 	if (!(rec->flags & FTRACE_FL_FROZEN)) {
@@ -250,72 +239,6 @@ static inline int record_frozen(struct dyn_ftrace *rec)
 # define record_frozen(rec)			({ 0; })
 #endif /* CONFIG_KPROBES */
 
-int skip_trace(unsigned long ip)
-{
-	unsigned long fl;
-	struct dyn_ftrace *rec;
-	struct hlist_node *t;
-	struct hlist_head *head;
-
-	if (frozen_record_count == 0)
-		return 0;
-
-	head = &ftrace_hash[hash_long(ip, FTRACE_HASHBITS)];
-	hlist_for_each_entry_rcu(rec, t, head, node) {
-		if (rec->ip == ip) {
-			if (record_frozen(rec)) {
-				if (rec->flags & FTRACE_FL_FAILED)
-					return 1;
-
-				if (!(rec->flags & FTRACE_FL_CONVERTED))
-					return 1;
-
-				if (!tracing_on || !ftrace_enabled)
-					return 1;
-
-				if (ftrace_filtered) {
-					fl = rec->flags & (FTRACE_FL_FILTER |
-							   FTRACE_FL_NOTRACE);
-					if (!fl || (fl & FTRACE_FL_NOTRACE))
-						return 1;
-				}
-			}
-			break;
-		}
-	}
-
-	return 0;
-}
-
-static inline int
-ftrace_ip_in_hash(unsigned long ip, unsigned long key)
-{
-	struct dyn_ftrace *p;
-	struct hlist_node *t;
-	int found = 0;
-
-	hlist_for_each_entry_rcu(p, t, &ftrace_hash[key], node) {
-		if (p->ip == ip) {
-			found = 1;
-			break;
-		}
-	}
-
-	return found;
-}
-
-static inline void
-ftrace_add_hash(struct dyn_ftrace *node, unsigned long key)
-{
-	hlist_add_head_rcu(&node->node, &ftrace_hash[key]);
-}
-
-/* called from kstop_machine */
-static inline void ftrace_del_hash(struct dyn_ftrace *node)
-{
-	hlist_del(&node->node);
-}
-
 static void ftrace_free_rec(struct dyn_ftrace *rec)
 {
 	rec->ip = (unsigned long)ftrace_free_records;
@@ -346,7 +269,6 @@ void ftrace_release(void *start, unsigned long size)
 		}
 	}
 	spin_unlock(&ftrace_lock);
-
 }
 
 static struct dyn_ftrace *ftrace_alloc_dyn_node(unsigned long ip)
@@ -358,10 +280,8 @@ static struct dyn_ftrace *ftrace_alloc_dyn_node(unsigned long ip)
 		rec = ftrace_free_records;
 
 		if (unlikely(!(rec->flags & FTRACE_FL_FREE))) {
-			WARN_ON_ONCE(1);
+			FTRACE_WARN_ON_ONCE(1);
 			ftrace_free_records = NULL;
-			ftrace_disabled = 1;
-			ftrace_enabled = 0;
 			return NULL;
 		}
 
@@ -371,76 +291,36 @@ static struct dyn_ftrace *ftrace_alloc_dyn_node(unsigned long ip)
 	}
 
 	if (ftrace_pages->index == ENTRIES_PER_PAGE) {
-		if (!ftrace_pages->next)
-			return NULL;
+		if (!ftrace_pages->next) {
+			/* allocate another page */
+			ftrace_pages->next =
+				(void *)get_zeroed_page(GFP_KERNEL);
+			if (!ftrace_pages->next)
+				return NULL;
+		}
 		ftrace_pages = ftrace_pages->next;
 	}
 
 	return &ftrace_pages->records[ftrace_pages->index++];
 }
 
-static void
+static struct dyn_ftrace *
 ftrace_record_ip(unsigned long ip)
 {
-	struct dyn_ftrace *node;
-	unsigned long flags;
-	unsigned long key;
-	int resched;
-	int cpu;
+	struct dyn_ftrace *rec;
 
 	if (!ftrace_enabled || ftrace_disabled)
-		return;
-
-	resched = need_resched();
-	preempt_disable_notrace();
-
-	/*
-	 * We simply need to protect against recursion.
-	 * Use the the raw version of smp_processor_id and not
-	 * __get_cpu_var which can call debug hooks that can
-	 * cause a recursive crash here.
-	 */
-	cpu = raw_smp_processor_id();
-	per_cpu(ftrace_shutdown_disable_cpu, cpu)++;
-	if (per_cpu(ftrace_shutdown_disable_cpu, cpu) != 1)
-		goto out;
+		return NULL;
 
-	if (unlikely(ftrace_record_suspend))
-		goto out;
-
-	key = hash_long(ip, FTRACE_HASHBITS);
-
-	WARN_ON_ONCE(key >= FTRACE_HASHSIZE);
-
-	if (ftrace_ip_in_hash(ip, key))
-		goto out;
-
-	ftrace_hash_lock(flags);
-
-	/* This ip may have hit the hash before the lock */
-	if (ftrace_ip_in_hash(ip, key))
-		goto out_unlock;
-
-	node = ftrace_alloc_dyn_node(ip);
-	if (!node)
-		goto out_unlock;
-
-	node->ip = ip;
+	rec = ftrace_alloc_dyn_node(ip);
+	if (!rec)
+		return NULL;
 
-	ftrace_add_hash(node, key);
+	rec->ip = ip;
 
-	ftraced_trigger = 1;
+	list_add(&rec->list, &ftrace_new_addrs);
 
- out_unlock:
-	ftrace_hash_unlock(flags);
- out:
-	per_cpu(ftrace_shutdown_disable_cpu, cpu)--;
-
-	/* prevent recursion with scheduler */
-	if (resched)
-		preempt_enable_no_resched_notrace();
-	else
-		preempt_enable_notrace();
+	return rec;
 }
 
 #define FTRACE_ADDR ((long)(ftrace_caller))
@@ -559,7 +439,6 @@ static void ftrace_replace_code(int enable)
 				rec->flags |= FTRACE_FL_FAILED;
 				if ((system_state == SYSTEM_BOOTING) ||
 				    !core_kernel_text(rec->ip)) {
-					ftrace_del_hash(rec);
 					ftrace_free_rec(rec);
 				}
 			}
@@ -567,15 +446,6 @@ static void ftrace_replace_code(int enable)
 	}
 }
 
-static void ftrace_shutdown_replenish(void)
-{
-	if (ftrace_pages->next)
-		return;
-
-	/* allocate another page */
-	ftrace_pages->next = (void *)get_zeroed_page(GFP_KERNEL);
-}
-
 static void print_ip_ins(const char *fmt, unsigned char *p)
 {
 	int i;
@@ -591,23 +461,23 @@ ftrace_code_disable(struct dyn_ftrace *rec)
 {
 	unsigned long ip;
 	unsigned char *nop, *call;
-	int failed;
+	int ret;
 
 	ip = rec->ip;
 
 	nop = ftrace_nop_replace();
 	call = ftrace_call_replace(ip, mcount_addr);
 
-	failed = ftrace_modify_code(ip, call, nop);
-	if (failed) {
-		switch (failed) {
-		case 1:
-			WARN_ON_ONCE(1);
+	ret = ftrace_modify_code(ip, call, nop);
+	if (ret) {
+		switch (ret) {
+		case -EFAULT:
+			FTRACE_WARN_ON_ONCE(1);
 			pr_info("ftrace faulted on modifying ");
 			print_ip_sym(ip);
 			break;
-		case 2:
-			WARN_ON_ONCE(1);
+		case -EINVAL:
+			FTRACE_WARN_ON_ONCE(1);
 			pr_info("ftrace failed to modify ");
 			print_ip_sym(ip);
 			print_ip_ins(" expected: ", call);
@@ -615,6 +485,15 @@ ftrace_code_disable(struct dyn_ftrace *rec)
 			print_ip_ins(" replace: ", nop);
 			printk(KERN_CONT "\n");
 			break;
+		case -EPERM:
+			FTRACE_WARN_ON_ONCE(1);
+			pr_info("ftrace faulted on writing ");
+			print_ip_sym(ip);
+			break;
+		default:
+			FTRACE_WARN_ON_ONCE(1);
+			pr_info("ftrace faulted on unknown error ");
+			print_ip_sym(ip);
 		}
 
 		rec->flags |= FTRACE_FL_FAILED;
@@ -623,19 +502,11 @@ ftrace_code_disable(struct dyn_ftrace *rec)
 	return 1;
 }
 
-static int __ftrace_update_code(void *ignore);
-
 static int __ftrace_modify_code(void *data)
 {
-	unsigned long addr;
 	int *command = data;
 
 	if (*command & FTRACE_ENABLE_CALLS) {
-		/*
-		 * Update any recorded ips now that we have the
-		 * machine stopped
-		 */
-		__ftrace_update_code(NULL);
 		ftrace_replace_code(1);
 		tracing_on = 1;
 	} else if (*command & FTRACE_DISABLE_CALLS) {
@@ -646,14 +517,6 @@ static int __ftrace_modify_code(void *data)
 	if (*command & FTRACE_UPDATE_TRACE_FUNC)
 		ftrace_update_ftrace_func(ftrace_trace_function);
 
-	if (*command & FTRACE_ENABLE_MCOUNT) {
-		addr = (unsigned long)ftrace_record_ip;
-		ftrace_mcount_set(&addr);
-	} else if (*command & FTRACE_DISABLE_MCOUNT) {
-		addr = (unsigned long)ftrace_stub;
-		ftrace_mcount_set(&addr);
-	}
-
 	return 0;
 }
 
@@ -662,26 +525,9 @@ static void ftrace_run_update_code(int command)
 	stop_machine(__ftrace_modify_code, &command, NULL);
 }
 
-void ftrace_disable_daemon(void)
-{
-	/* Stop the daemon from calling kstop_machine */
-	mutex_lock(&ftraced_lock);
-	ftraced_stop = 1;
-	mutex_unlock(&ftraced_lock);
-
-	ftrace_force_update();
-}
-
-void ftrace_enable_daemon(void)
-{
-	mutex_lock(&ftraced_lock);
-	ftraced_stop = 0;
-	mutex_unlock(&ftraced_lock);
-
-	ftrace_force_update();
-}
-
 static ftrace_func_t saved_ftrace_func;
+static int ftrace_start;
+static DEFINE_MUTEX(ftrace_start_lock);
 
 static void ftrace_startup(void)
 {
@@ -690,9 +536,9 @@ static void ftrace_startup(void)
 	if (unlikely(ftrace_disabled))
 		return;
 
-	mutex_lock(&ftraced_lock);
-	ftraced_suspend++;
-	if (ftraced_suspend == 1)
+	mutex_lock(&ftrace_start_lock);
+	ftrace_start++;
+	if (ftrace_start == 1)
 		command |= FTRACE_ENABLE_CALLS;
 
 	if (saved_ftrace_func != ftrace_trace_function) {
@@ -705,7 +551,7 @@ static void ftrace_startup(void)
 
 	ftrace_run_update_code(command);
  out:
-	mutex_unlock(&ftraced_lock);
+	mutex_unlock(&ftrace_start_lock);
 }
 
 static void ftrace_shutdown(void)
@@ -715,9 +561,9 @@ static void ftrace_shutdown(void)
 	if (unlikely(ftrace_disabled))
 		return;
 
-	mutex_lock(&ftraced_lock);
-	ftraced_suspend--;
-	if (!ftraced_suspend)
+	mutex_lock(&ftrace_start_lock);
+	ftrace_start--;
+	if (!ftrace_start)
 		command |= FTRACE_DISABLE_CALLS;
 
 	if (saved_ftrace_func != ftrace_trace_function) {
@@ -730,7 +576,7 @@ static void ftrace_shutdown(void)
 
 	ftrace_run_update_code(command);
  out:
-	mutex_unlock(&ftraced_lock);
+	mutex_unlock(&ftrace_start_lock);
 }
 
 static void ftrace_startup_sysctl(void)
@@ -740,15 +586,15 @@ static void ftrace_startup_sysctl(void)
 	if (unlikely(ftrace_disabled))
 		return;
 
-	mutex_lock(&ftraced_lock);
+	mutex_lock(&ftrace_start_lock);
 	/* Force update next time */
 	saved_ftrace_func = NULL;
-	/* ftraced_suspend is true if we want ftrace running */
-	if (ftraced_suspend)
+	/* ftrace_start is true if we want ftrace running */
+	if (ftrace_start)
 		command |= FTRACE_ENABLE_CALLS;
 
 	ftrace_run_update_code(command);
-	mutex_unlock(&ftraced_lock);
+	mutex_unlock(&ftrace_start_lock);
 }
 
 static void ftrace_shutdown_sysctl(void)
@@ -758,112 +604,50 @@ static void ftrace_shutdown_sysctl(void)
 	if (unlikely(ftrace_disabled))
 		return;
 
-	mutex_lock(&ftraced_lock);
-	/* ftraced_suspend is true if ftrace is running */
-	if (ftraced_suspend)
+	mutex_lock(&ftrace_start_lock);
+	/* ftrace_start is true if ftrace is running */
+	if (ftrace_start)
 		command |= FTRACE_DISABLE_CALLS;
 
 	ftrace_run_update_code(command);
-	mutex_unlock(&ftraced_lock);
+	mutex_unlock(&ftrace_start_lock);
 }
 
 static cycle_t		ftrace_update_time;
 static unsigned long	ftrace_update_cnt;
 unsigned long		ftrace_update_tot_cnt;
 
-static int __ftrace_update_code(void *ignore)
+static int ftrace_update_code(void)
 {
-	int i, save_ftrace_enabled;
+	struct dyn_ftrace *p, *t;
 	cycle_t start, stop;
-	struct dyn_ftrace *p;
-	struct hlist_node *t, *n;
-	struct hlist_head *head, temp_list;
-
-	/* Don't be recording funcs now */
-	ftrace_record_suspend++;
-	save_ftrace_enabled = ftrace_enabled;
-	ftrace_enabled = 0;
 
 	start = ftrace_now(raw_smp_processor_id());
 	ftrace_update_cnt = 0;
 
-	/* No locks needed, the machine is stopped! */
-	for (i = 0; i < FTRACE_HASHSIZE; i++) {
-		INIT_HLIST_HEAD(&temp_list);
-		head = &ftrace_hash[i];
-
-		/* all CPUS are stopped, we are safe to modify code */
-		hlist_for_each_entry_safe(p, t, n, head, node) {
-			/* Skip over failed records which have not been
-			 * freed. */
-			if (p->flags & FTRACE_FL_FAILED)
-				continue;
-
-			/* Unconverted records are always at the head of the
-			 * hash bucket. Once we encounter a converted record,
-			 * simply skip over to the next bucket. Saves ftraced
-			 * some processor cycles (ftrace does its bid for
-			 * global warming :-p ). */
-			if (p->flags & (FTRACE_FL_CONVERTED))
-				break;
+	list_for_each_entry_safe(p, t, &ftrace_new_addrs, list) {
 
-			/* Ignore updates to this record's mcount site.
-			 * Reintroduce this record at the head of this
-			 * bucket to attempt to "convert" it again if
-			 * the kprobe on it is unregistered before the
-			 * next run. */
-			if (get_kprobe((void *)p->ip)) {
-				ftrace_del_hash(p);
-				INIT_HLIST_NODE(&p->node);
-				hlist_add_head(&p->node, &temp_list);
-				freeze_record(p);
-				continue;
-			} else {
-				unfreeze_record(p);
-			}
+		/* If something went wrong, bail without enabling anything */
+		if (unlikely(ftrace_disabled))
+			return -1;
 
-			/* convert record (i.e, patch mcount-call with NOP) */
-			if (ftrace_code_disable(p)) {
-				p->flags |= FTRACE_FL_CONVERTED;
-				ftrace_update_cnt++;
-			} else {
-				if ((system_state == SYSTEM_BOOTING) ||
-				    !core_kernel_text(p->ip)) {
-					ftrace_del_hash(p);
-					ftrace_free_rec(p);
-				}
-			}
-		}
+		list_del_init(&p->list);
 
-		hlist_for_each_entry_safe(p, t, n, &temp_list, node) {
-			hlist_del(&p->node);
-			INIT_HLIST_NODE(&p->node);
-			hlist_add_head(&p->node, head);
-		}
+		/* convert record (i.e, patch mcount-call with NOP) */
+		if (ftrace_code_disable(p)) {
+			p->flags |= FTRACE_FL_CONVERTED;
+			ftrace_update_cnt++;
+		} else
+			ftrace_free_rec(p);
 	}
 
 	stop = ftrace_now(raw_smp_processor_id());
 	ftrace_update_time = stop - start;
 	ftrace_update_tot_cnt += ftrace_update_cnt;
-	ftraced_trigger = 0;
-
-	ftrace_enabled = save_ftrace_enabled;
-	ftrace_record_suspend--;
 
 	return 0;
 }
 
-static int ftrace_update_code(void)
-{
-	if (unlikely(ftrace_disabled) ||
-	    !ftrace_enabled || !ftraced_trigger)
-		return 0;
-
-	stop_machine(__ftrace_update_code, NULL, NULL);
-
-	return 1;
-}
-
 static int __init ftrace_dyn_table_alloc(unsigned long num_to_init)
 {
 	struct ftrace_page *pg;
@@ -892,7 +676,7 @@ static int __init ftrace_dyn_table_alloc(unsigned long num_to_init)
 	pg = ftrace_pages = ftrace_pages_start;
 
 	cnt = num_to_init / ENTRIES_PER_PAGE;
-	pr_info("ftrace: allocating %ld hash entries in %d pages\n",
+	pr_info("ftrace: allocating %ld entries in %d pages\n",
 		num_to_init, cnt);
 
 	for (i = 0; i < cnt; i++) {
@@ -1401,10 +1185,10 @@ ftrace_regex_release(struct inode *inode, struct file *file, int enable)
 	}
 
 	mutex_lock(&ftrace_sysctl_lock);
-	mutex_lock(&ftraced_lock);
-	if (iter->filtered && ftraced_suspend && ftrace_enabled)
+	mutex_lock(&ftrace_start_lock);
+	if (iter->filtered && ftrace_start && ftrace_enabled)
 		ftrace_run_update_code(FTRACE_ENABLE_CALLS);
-	mutex_unlock(&ftraced_lock);
+	mutex_unlock(&ftrace_start_lock);
 	mutex_unlock(&ftrace_sysctl_lock);
 
 	kfree(iter);
@@ -1424,55 +1208,6 @@ ftrace_notrace_release(struct inode *inode, struct file *file)
 	return ftrace_regex_release(inode, file, 0);
 }
 
-static ssize_t
-ftraced_read(struct file *filp, char __user *ubuf,
-		     size_t cnt, loff_t *ppos)
-{
-	/* don't worry about races */
-	char *buf = ftraced_stop ? "disabled\n" : "enabled\n";
-	int r = strlen(buf);
-
-	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
-}
-
-static ssize_t
-ftraced_write(struct file *filp, const char __user *ubuf,
-		      size_t cnt, loff_t *ppos)
-{
-	char buf[64];
-	long val;
-	int ret;
-
-	if (cnt >= sizeof(buf))
-		return -EINVAL;
-
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-
-	if (strncmp(buf, "enable", 6) == 0)
-		val = 1;
-	else if (strncmp(buf, "disable", 7) == 0)
-		val = 0;
-	else {
-		buf[cnt] = 0;
-
-		ret = strict_strtoul(buf, 10, &val);
-		if (ret < 0)
-			return ret;
-
-		val = !!val;
-	}
-
-	if (val)
-		ftrace_enable_daemon();
-	else
-		ftrace_disable_daemon();
-
-	filp->f_pos += cnt;
-
-	return cnt;
-}
-
 static struct file_operations ftrace_avail_fops = {
 	.open = ftrace_avail_open,
 	.read = seq_read,
@@ -1503,54 +1238,6 @@ static struct file_operations ftrace_notrace_fops = {
 	.release = ftrace_notrace_release,
 };
 
-static struct file_operations ftraced_fops = {
-	.open = tracing_open_generic,
-	.read = ftraced_read,
-	.write = ftraced_write,
-};
-
-/**
- * ftrace_force_update - force an update to all recording ftrace functions
- */
-int ftrace_force_update(void)
-{
-	int ret = 0;
-
-	if (unlikely(ftrace_disabled))
-		return -ENODEV;
-
-	mutex_lock(&ftrace_sysctl_lock);
-	mutex_lock(&ftraced_lock);
-
-	/*
-	 * If ftraced_trigger is not set, then there is nothing
-	 * to update.
-	 */
-	if (ftraced_trigger && !ftrace_update_code())
-		ret = -EBUSY;
-
-	mutex_unlock(&ftraced_lock);
-	mutex_unlock(&ftrace_sysctl_lock);
-
-	return ret;
-}
-
-static void ftrace_force_shutdown(void)
-{
-	struct task_struct *task;
-	int command = FTRACE_DISABLE_CALLS | FTRACE_UPDATE_TRACE_FUNC;
-
-	mutex_lock(&ftraced_lock);
-	task = ftraced_task;
-	ftraced_task = NULL;
-	ftraced_suspend = -1;
-	ftrace_run_update_code(command);
-	mutex_unlock(&ftraced_lock);
-
-	if (task)
-		kthread_stop(task);
-}
-
 static __init int ftrace_init_debugfs(void)
 {
 	struct dentry *d_tracer;
@@ -1581,17 +1268,11 @@ static __init int ftrace_init_debugfs(void)
 		pr_warning("Could not create debugfs "
 			   "'set_ftrace_notrace' entry\n");
 
-	entry = debugfs_create_file("ftraced_enabled", 0644, d_tracer,
-				    NULL, &ftraced_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'ftraced_enabled' entry\n");
 	return 0;
 }
 
 fs_initcall(ftrace_init_debugfs);
 
-#ifdef CONFIG_FTRACE_MCOUNT_RECORD
 static int ftrace_convert_nops(unsigned long *start,
 			       unsigned long *end)
 {
@@ -1599,20 +1280,18 @@ static int ftrace_convert_nops(unsigned long *start,
 	unsigned long addr;
 	unsigned long flags;
 
+	mutex_lock(&ftrace_start_lock);
 	p = start;
 	while (p < end) {
 		addr = ftrace_call_adjust(*p++);
-		/* should not be called from interrupt context */
-		spin_lock(&ftrace_lock);
 		ftrace_record_ip(addr);
-		spin_unlock(&ftrace_lock);
-		ftrace_shutdown_replenish();
 	}
 
-	/* p is ignored */
+	/* disable interrupts to prevent kstop machine */
 	local_irq_save(flags);
-	__ftrace_update_code(p);
+	ftrace_update_code();
 	local_irq_restore(flags);
+	mutex_unlock(&ftrace_start_lock);
 
 	return 0;
 }
@@ -1658,130 +1337,26 @@ void __init ftrace_init(void)
  failed:
 	ftrace_disabled = 1;
 }
-#else /* CONFIG_FTRACE_MCOUNT_RECORD */
-static int ftraced(void *ignore)
-{
-	unsigned long usecs;
-
-	while (!kthread_should_stop()) {
-
-		set_current_state(TASK_INTERRUPTIBLE);
-
-		/* check once a second */
-		schedule_timeout(HZ);
-
-		if (unlikely(ftrace_disabled))
-			continue;
-
-		mutex_lock(&ftrace_sysctl_lock);
-		mutex_lock(&ftraced_lock);
-		if (!ftraced_suspend && !ftraced_stop &&
-		    ftrace_update_code()) {
-			usecs = nsecs_to_usecs(ftrace_update_time);
-			if (ftrace_update_tot_cnt > 100000) {
-				ftrace_update_tot_cnt = 0;
-				pr_info("hm, dftrace overflow: %lu change%s"
-					" (%lu total) in %lu usec%s\n",
-					ftrace_update_cnt,
-					ftrace_update_cnt != 1 ? "s" : "",
-					ftrace_update_tot_cnt,
-					usecs, usecs != 1 ? "s" : "");
-				ftrace_disabled = 1;
-				WARN_ON_ONCE(1);
-			}
-		}
-		mutex_unlock(&ftraced_lock);
-		mutex_unlock(&ftrace_sysctl_lock);
-
-		ftrace_shutdown_replenish();
-	}
-	__set_current_state(TASK_RUNNING);
-	return 0;
-}
-
-static int __init ftrace_dynamic_init(void)
-{
-	struct task_struct *p;
-	unsigned long addr;
-	int ret;
-
-	addr = (unsigned long)ftrace_record_ip;
-
-	stop_machine(ftrace_dyn_arch_init, &addr, NULL);
-
-	/* ftrace_dyn_arch_init places the return code in addr */
-	if (addr) {
-		ret = (int)addr;
-		goto failed;
-	}
-
-	ret = ftrace_dyn_table_alloc(NR_TO_INIT);
-	if (ret)
-		goto failed;
-
-	p = kthread_run(ftraced, NULL, "ftraced");
-	if (IS_ERR(p)) {
-		ret = -1;
-		goto failed;
-	}
-
-	last_ftrace_enabled = ftrace_enabled = 1;
-	ftraced_task = p;
-
-	return 0;
-
- failed:
-	ftrace_disabled = 1;
-	return ret;
-}
-
-core_initcall(ftrace_dynamic_init);
-#endif /* CONFIG_FTRACE_MCOUNT_RECORD */
 
 #else
 # define ftrace_startup()		do { } while (0)
 # define ftrace_shutdown()		do { } while (0)
 # define ftrace_startup_sysctl()	do { } while (0)
 # define ftrace_shutdown_sysctl()	do { } while (0)
-# define ftrace_force_shutdown()	do { } while (0)
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 /**
- * ftrace_kill_atomic - kill ftrace from critical sections
+ * ftrace_kill - kill ftrace
  *
  * This function should be used by panic code. It stops ftrace
  * but in a not so nice way. If you need to simply kill ftrace
  * from a non-atomic section, use ftrace_kill.
  */
-void ftrace_kill_atomic(void)
-{
-	ftrace_disabled = 1;
-	ftrace_enabled = 0;
-#ifdef CONFIG_DYNAMIC_FTRACE
-	ftraced_suspend = -1;
-#endif
-	clear_ftrace_function();
-}
-
-/**
- * ftrace_kill - totally shutdown ftrace
- *
- * This is a safety measure. If something was detected that seems
- * wrong, calling this function will keep ftrace from doing
- * any more modifications, and updates.
- * used when something went wrong.
- */
 void ftrace_kill(void)
 {
-	mutex_lock(&ftrace_sysctl_lock);
 	ftrace_disabled = 1;
 	ftrace_enabled = 0;
-
 	clear_ftrace_function();
-	mutex_unlock(&ftrace_sysctl_lock);
-
-	/* Try to totally disable ftrace */
-	ftrace_force_shutdown();
 }
 
 /**
@@ -1870,3 +1445,4 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 	mutex_unlock(&ftrace_sysctl_lock);
 	return ret;
 }
+
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 94af1fe..cedf4e2 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -130,7 +130,7 @@ struct buffer_page {
 static inline void free_buffer_page(struct buffer_page *bpage)
 {
 	if (bpage->page)
-		__free_page(bpage->page);
+		free_page((unsigned long)bpage->page);
 	kfree(bpage);
 }
 
@@ -966,7 +966,9 @@ rb_add_time_stamp(struct ring_buffer_per_cpu *cpu_buffer,
 	if (unlikely(*delta > (1ULL << 59) && !once++)) {
 		printk(KERN_WARNING "Delta way too big! %llu"
 		       " ts=%llu write stamp = %llu\n",
-		       *delta, *ts, cpu_buffer->write_stamp);
+		       (unsigned long long)*delta,
+		       (unsigned long long)*ts,
+		       (unsigned long long)cpu_buffer->write_stamp);
 		WARN_ON(1);
 	}
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d345d64..a610ca7 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -34,6 +34,7 @@
 
 #include <linux/stacktrace.h>
 #include <linux/ring_buffer.h>
+#include <linux/irqflags.h>
 
 #include "trace.h"
 
@@ -851,7 +852,7 @@ ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3)
 	preempt_enable_notrace();
 }
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 static void
 function_trace_call(unsigned long ip, unsigned long parent_ip)
 {
@@ -865,9 +866,6 @@ function_trace_call(unsigned long ip, unsigned long parent_ip)
 	if (unlikely(!ftrace_function_enabled))
 		return;
 
-	if (skip_trace(ip))
-		return;
-
 	pc = preempt_count();
 	resched = need_resched();
 	preempt_disable_notrace();
@@ -2379,9 +2377,10 @@ tracing_set_trace_write(struct file *filp, const char __user *ubuf,
 	int i;
 	size_t ret;
 
+	ret = cnt;
+
 	if (cnt > max_tracer_type_len)
 		cnt = max_tracer_type_len;
-	ret = cnt;
 
 	if (copy_from_user(&buf, ubuf, cnt))
 		return -EFAULT;
@@ -2414,8 +2413,8 @@ tracing_set_trace_write(struct file *filp, const char __user *ubuf,
  out:
 	mutex_unlock(&trace_types_lock);
 
-	if (ret == cnt)
-		filp->f_pos += cnt;
+	if (ret > 0)
+		filp->f_pos += ret;
 
 	return ret;
 }
@@ -3097,7 +3096,7 @@ void ftrace_dump(void)
 	dump_ran = 1;
 
 	/* No turning back! */
-	ftrace_kill_atomic();
+	ftrace_kill();
 
 	for_each_tracing_cpu(cpu) {
 		atomic_inc(&global_trace.data[cpu]->disabled);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index f1f9957..6889ca4 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -335,7 +335,7 @@ void update_max_tr_single(struct trace_array *tr,
 
 extern cycle_t ftrace_now(int cpu);
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 void tracing_start_function_trace(void);
 void tracing_stop_function_trace(void);
 #else
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index e90eb0c..0f85a64 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -64,7 +64,7 @@ static void function_trace_ctrl_update(struct trace_array *tr)
 
 static struct tracer function_trace __read_mostly =
 {
-	.name	     = "ftrace",
+	.name	     = "function",
 	.init	     = function_trace_init,
 	.reset	     = function_trace_reset,
 	.ctrl_update = function_trace_ctrl_update,
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index a7db7f0..9c74071 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -63,7 +63,7 @@ irq_trace(void)
  */
 static __cacheline_aligned_in_smp	unsigned long max_sequence;
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 /*
  * irqsoff uses its own tracer function to keep the overhead down:
  */
@@ -104,7 +104,7 @@ static struct ftrace_ops trace_ops __read_mostly =
 {
 	.func = irqsoff_tracer_call,
 };
-#endif /* CONFIG_FTRACE */
+#endif /* CONFIG_FUNCTION_TRACER */
 
 /*
  * Should this new latency be reported/recorded?
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index fe4a252..3ae93f1 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -31,7 +31,7 @@ static raw_spinlock_t wakeup_lock =
 
 static void __wakeup_reset(struct trace_array *tr);
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 /*
  * irqsoff uses its own tracer function to keep the overhead down:
  */
@@ -96,7 +96,7 @@ static struct ftrace_ops trace_ops __read_mostly =
 {
 	.func = wakeup_tracer_call,
 };
-#endif /* CONFIG_FTRACE */
+#endif /* CONFIG_FUNCTION_TRACER */
 
 /*
  * Should this new latency be reported/recorded?
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 09cf230..90bc752 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -70,7 +70,7 @@ static int trace_test_buffer(struct trace_array *tr, unsigned long *count)
 	return ret;
 }
 
-#ifdef CONFIG_FTRACE
+#ifdef CONFIG_FUNCTION_TRACER
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 
@@ -99,13 +99,6 @@ int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 	/* passed in by parameter to fool gcc from optimizing */
 	func();
 
-	/* update the records */
-	ret = ftrace_force_update();
-	if (ret) {
-		printk(KERN_CONT ".. ftraced failed .. ");
-		return ret;
-	}
-
 	/*
 	 * Some archs *cough*PowerPC*cough* add charachters to the
 	 * start of the function names. We simply put a '*' to
@@ -183,13 +176,6 @@ trace_selftest_startup_function(struct tracer *trace, struct trace_array *tr)
 	/* make sure msleep has been recorded */
 	msleep(1);
 
-	/* force the recorded functions to be traced */
-	ret = ftrace_force_update();
-	if (ret) {
-		printk(KERN_CONT ".. ftraced failed .. ");
-		return ret;
-	}
-
 	/* start the tracing */
 	ftrace_enabled = 1;
 	tracer_enabled = 1;
@@ -226,7 +212,7 @@ trace_selftest_startup_function(struct tracer *trace, struct trace_array *tr)
 
 	return ret;
 }
-#endif /* CONFIG_FTRACE */
+#endif /* CONFIG_FUNCTION_TRACER */
 
 #ifdef CONFIG_IRQSOFF_TRACER
 int
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 74c5d9a..be682b6 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -44,6 +44,10 @@ static inline void check_stack(void)
 	if (this_size <= max_stack_size)
 		return;
 
+	/* we do not handle interrupt stacks yet */
+	if (!object_is_on_stack(&this_size))
+		return;
+
 	raw_local_irq_save(flags);
 	__raw_spin_lock(&max_stack_lock);
 
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index f2b7c28..af8c856 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -131,6 +131,9 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *entry, void *probe)
 
 	old = entry->funcs;
 
+	if (!old)
+		return NULL;
+
 	debug_print_probes(entry);
 	/* (N -> M), (N > 1, M >= 0) probes */
 	for (nr_probes = 0; old[nr_probes]; nr_probes++) {
@@ -388,6 +391,11 @@ int tracepoint_probe_unregister(const char *name, void *probe)
 	if (entry->rcu_pending)
 		rcu_barrier_sched();
 	old = tracepoint_entry_remove_probe(entry, probe);
+	if (!old) {
+		printk(KERN_WARNING "Warning: Trying to unregister a probe"
+				    "that doesn't exist\n");
+		goto end;
+	}
 	mutex_unlock(&tracepoints_mutex);
 	tracepoint_update_probes();		/* may update entry */
 	mutex_lock(&tracepoints_mutex);
diff --git a/lib/Makefile b/lib/Makefile
index 16feaab..7cb65d8 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -2,7 +2,7 @@
 # Makefile for some libs needed in the kernel.
 #
 
-ifdef CONFIG_FTRACE
+ifdef CONFIG_FUNCTION_TRACER
 ORIG_CFLAGS := $(KBUILD_CFLAGS)
 KBUILD_CFLAGS = $(subst -pg,,$(ORIG_CFLAGS))
 endif
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 5ed4cbf..468fbc9 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -198,10 +198,16 @@ cmd_modversions =							\
 	fi;
 endif
 
+ifdef CONFIG_64BIT
+arch_bits = 64
+else
+arch_bits = 32
+endif
+
 ifdef CONFIG_FTRACE_MCOUNT_RECORD
 cmd_record_mcount = perl $(srctree)/scripts/recordmcount.pl \
-	"$(ARCH)" "$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" \
-	"$(MV)" "$(@)";
+	"$(ARCH)" "$(arch_bits)" "$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" \
+	"$(NM)" "$(RM)" "$(MV)" "$(@)";
 endif
 
 define rule_cc_o_c
diff --git a/scripts/bootgraph.pl b/scripts/bootgraph.pl
index 5e7316e..d2c61ef 100644
--- a/scripts/bootgraph.pl
+++ b/scripts/bootgraph.pl
@@ -37,7 +37,10 @@
 # 	dmesg | perl scripts/bootgraph.pl > output.svg
 #
 
-my %start, %end;
+use strict;
+
+my %start;
+my %end;
 my $done = 0;
 my $maxtime = 0;
 my $firsttime = 100;
@@ -105,18 +108,20 @@ my $threshold = ($maxtime - $firsttime) / 60.0;
 my $stylecounter = 0;
 my %rows;
 my $rowscount = 1;
-while (($key,$value) = each %start) {
+my @initcalls = sort { $start{$a} <=> $start{$b} } keys(%start);
+my $key;
+foreach $key (@initcalls) {
 	my $duration = $end{$key} - $start{$key};
 
 	if ($duration >= $threshold) {
-		my $s, $s2, $e, $y;
-		$pid = $pids{$key};
+		my ($s, $s2, $e, $w, $y, $y2, $style);
+		my $pid = $pids{$key};
 
 		if (!defined($rows{$pid})) {
 			$rows{$pid} = $rowscount;
 			$rowscount = $rowscount + 1;
 		}
-		$s = ($value - $firsttime) * $mult;
+		$s = ($start{$key} - $firsttime) * $mult;
 		$s2 = $s + 6;
 		$e = ($end{$key} - $firsttime) * $mult;
 		$w = $e - $s;
@@ -140,9 +145,9 @@ while (($key,$value) = each %start) {
 my $time = $firsttime;
 my $step = ($maxtime - $firsttime) / 15;
 while ($time < $maxtime) {
-	my $s2 = ($time - $firsttime) * $mult;
+	my $s3 = ($time - $firsttime) * $mult;
 	my $tm = int($time * 100) / 100.0;
-	print "<text transform=\"translate($s2,89) rotate(90)\">$tm</text>\n";
+	print "<text transform=\"translate($s3,89) rotate(90)\">$tm</text>\n";
 	$time = $time + $step;
 }
 
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index f56d760..6b9fe3e 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -106,7 +106,13 @@ if ($#ARGV < 6) {
 	exit(1);
 }
 
-my ($arch, $objdump, $objcopy, $cc, $ld, $nm, $rm, $mv, $inputfile) = @ARGV;
+my ($arch, $bits, $objdump, $objcopy, $cc,
+    $ld, $nm, $rm, $mv, $inputfile) = @ARGV;
+
+# Acceptable sections to record.
+my %text_sections = (
+     ".text" => 1,
+);
 
 $objdump = "objdump" if ((length $objdump) == 0);
 $objcopy = "objcopy" if ((length $objcopy) == 0);
@@ -129,8 +135,16 @@ my $function_regex;	# Find the name of a function
 			#    (return offset and func name)
 my $mcount_regex;	# Find the call site to mcount (return offset)
 
+if ($arch eq "x86") {
+    if ($bits == 64) {
+	$arch = "x86_64";
+    } else {
+	$arch = "i386";
+    }
+}
+
 if ($arch eq "x86_64") {
-    $section_regex = "Disassembly of section";
+    $section_regex = "Disassembly of section\\s+(\\S+):";
     $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount([+-]0x[0-9a-zA-Z]+)?\$";
     $type = ".quad";
@@ -142,7 +156,7 @@ if ($arch eq "x86_64") {
     $cc .= " -m64";
 
 } elsif ($arch eq "i386") {
-    $section_regex = "Disassembly of section";
+    $section_regex = "Disassembly of section\\s+(\\S+):";
     $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
     $type = ".long";
@@ -289,7 +303,13 @@ my $text;
 while (<IN>) {
     # is it a section?
     if (/$section_regex/) {
-	$read_function = 1;
+
+	# Only record text sections that we know are safe
+	if (defined($text_sections{$1})) {
+	    $read_function = 1;
+	} else {
+	    $read_function = 0;
+	}
 	# print out any recorded offsets
 	update_funcs() if ($text_found);
 
