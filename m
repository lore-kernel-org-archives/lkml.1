Return-Path: <linux-kernel-owner+w=401wt.eu-S1755455AbYBYFzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbYBYFzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 00:55:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbYBYFz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 00:55:27 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:43020 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbYBYFzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 00:55:15 -0500
Date: Mon, 25 Feb 2008 11:25:41 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, hskinnemoen@atmel.com,
       Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>,
       sam@ravnborg.org, sagar.abhishek@gmail.com
Subject: [PATCH 1/2] Kprobes: Indicate kretprobe support in Kconfig
Message-ID: <20080225055541.GE7148@in.ibm.com>
Reply-To: ananth@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

This patch adds CONFIG_HAVE_KRETPROBES to the arch/<arch>/Kconfig file
for relevant architectures with kprobes support. This facilitates easy
handling of in-kernel modules (like samples/kprobes/kretprobe_example.c)
that depend on kretprobes being present in the kernel.

Updated to apply on 2.6.25-rc3. Thanks to Sam Ravnborg for helping
make the patch more lean.

Per Mathieu's suggestion, added CONFIG_KRETPROBES and fixed up
dependencies.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/Kconfig                  |    7 +++++++
 arch/arm/Kconfig              |    1 +
 arch/ia64/Kconfig             |    1 +
 arch/powerpc/Kconfig          |    1 +
 arch/s390/Kconfig             |    1 +
 arch/sparc64/Kconfig          |    1 +
 arch/x86/Kconfig              |    1 +
 include/asm-arm/kprobes.h     |    1 -
 include/asm-ia64/kprobes.h    |    1 -
 include/asm-powerpc/kprobes.h |    1 -
 include/asm-s390/kprobes.h    |    1 -
 include/asm-sparc64/kprobes.h |    2 --
 include/asm-x86/kprobes.h     |    1 -
 include/linux/kprobes.h       |    6 +++---
 kernel/kprobes.c              |    9 +++------
 15 files changed, 19 insertions(+), 16 deletions(-)

Index: linux-2.6.25-rc2/arch/Kconfig
===================================================================
--- linux-2.6.25-rc2.orig/arch/Kconfig
+++ linux-2.6.25-rc2/arch/Kconfig
@@ -27,5 +27,12 @@ config KPROBES
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
 
+config KRETPROBES
+	def_bool y
+	depends on KPROBES && HAVE_KRETPROBES
+
 config HAVE_KPROBES
 	def_bool n
+
+config HAVE_KRETPROBES
+	def_bool n
Index: linux-2.6.25-rc2/arch/ia64/Kconfig
===================================================================
--- linux-2.6.25-rc2.orig/arch/ia64/Kconfig
+++ linux-2.6.25-rc2/arch/ia64/Kconfig
@@ -18,6 +18,7 @@ config IA64
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select HAVE_KRETPROBES
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
Index: linux-2.6.25-rc2/arch/powerpc/Kconfig
===================================================================
--- linux-2.6.25-rc2.orig/arch/powerpc/Kconfig
+++ linux-2.6.25-rc2/arch/powerpc/Kconfig
@@ -90,6 +90,7 @@ config PPC
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select HAVE_KRETPROBES
 
 config EARLY_PRINTK
 	bool
Index: linux-2.6.25-rc2/arch/x86/Kconfig
===================================================================
--- linux-2.6.25-rc2.orig/arch/x86/Kconfig
+++ linux-2.6.25-rc2/arch/x86/Kconfig
@@ -21,6 +21,7 @@ config X86
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select HAVE_KRETPROBES
 	select HAVE_KVM
 
 
Index: linux-2.6.25-rc2/include/asm-ia64/kprobes.h
===================================================================
--- linux-2.6.25-rc2.orig/include/asm-ia64/kprobes.h
+++ linux-2.6.25-rc2/include/asm-ia64/kprobes.h
@@ -82,7 +82,6 @@ struct kprobe_ctlblk {
 	struct prev_kprobe prev_kprobe[ARCH_PREV_KPROBE_SZ];
 };
 
-#define ARCH_SUPPORTS_KRETPROBES
 #define kretprobe_blacklist_size 0
 
 #define SLOT0_OPCODE_SHIFT	(37)
Index: linux-2.6.25-rc2/include/asm-powerpc/kprobes.h
===================================================================
--- linux-2.6.25-rc2.orig/include/asm-powerpc/kprobes.h
+++ linux-2.6.25-rc2/include/asm-powerpc/kprobes.h
@@ -80,7 +80,6 @@ typedef unsigned int kprobe_opcode_t;
 #define is_trap(instr)	(IS_TW(instr) || IS_TWI(instr))
 #endif
 
-#define ARCH_SUPPORTS_KRETPROBES
 #define flush_insn_slot(p)	do { } while (0)
 #define kretprobe_blacklist_size 0
 
Index: linux-2.6.25-rc2/include/asm-x86/kprobes.h
===================================================================
--- linux-2.6.25-rc2.orig/include/asm-x86/kprobes.h
+++ linux-2.6.25-rc2/include/asm-x86/kprobes.h
@@ -42,7 +42,6 @@ typedef u8 kprobe_opcode_t;
 	: (((unsigned long)current_thread_info()) + THREAD_SIZE \
 	   - (unsigned long)(ADDR)))
 
-#define ARCH_SUPPORTS_KRETPROBES
 #define flush_insn_slot(p)	do { } while (0)
 
 extern const int kretprobe_blacklist_size;
Index: linux-2.6.25-rc2/include/linux/kprobes.h
===================================================================
--- linux-2.6.25-rc2.orig/include/linux/kprobes.h
+++ linux-2.6.25-rc2/include/linux/kprobes.h
@@ -125,11 +125,11 @@ struct jprobe {
 DECLARE_PER_CPU(struct kprobe *, current_kprobe);
 DECLARE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
-#ifdef ARCH_SUPPORTS_KRETPROBES
+#ifdef CONFIG_KRETPROBES
 extern void arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				   struct pt_regs *regs);
 extern int arch_trampoline_kprobe(struct kprobe *p);
-#else /* ARCH_SUPPORTS_KRETPROBES */
+#else /* CONFIG_KRETPROBES */
 static inline void arch_prepare_kretprobe(struct kretprobe *rp,
 					struct pt_regs *regs)
 {
@@ -138,7 +138,7 @@ static inline int arch_trampoline_kprobe
 {
 	return 0;
 }
-#endif /* ARCH_SUPPORTS_KRETPROBES */
+#endif /* CONFIG_KRETPROBES */
 /*
  * Function-return probe -
  * Note:
Index: linux-2.6.25-rc2/kernel/kprobes.c
===================================================================
--- linux-2.6.25-rc2.orig/kernel/kprobes.c
+++ linux-2.6.25-rc2/kernel/kprobes.c
@@ -678,8 +678,7 @@ void __kprobes unregister_jprobe(struct 
 	unregister_kprobe(&jp->kp);
 }
 
-#ifdef ARCH_SUPPORTS_KRETPROBES
-
+#ifdef CONFIG_KRETPROBES
 /*
  * This kprobe pre_handler is registered with every kretprobe. When probe
  * hits it will set up the return probe.
@@ -769,8 +768,7 @@ int __kprobes register_kretprobe(struct 
 	return ret;
 }
 
-#else /* ARCH_SUPPORTS_KRETPROBES */
-
+#else /* CONFIG_KRETPROBES */
 int __kprobes register_kretprobe(struct kretprobe *rp)
 {
 	return -ENOSYS;
@@ -781,8 +779,7 @@ static int __kprobes pre_handler_kretpro
 {
 	return 0;
 }
-
-#endif /* ARCH_SUPPORTS_KRETPROBES */
+#endif /* CONFIG_KRETPROBES */
 
 void __kprobes unregister_kretprobe(struct kretprobe *rp)
 {
Index: linux-2.6.25-rc2/arch/s390/Kconfig
===================================================================
--- linux-2.6.25-rc2.orig/arch/s390/Kconfig
+++ linux-2.6.25-rc2/arch/s390/Kconfig
@@ -61,6 +61,7 @@ config S390
 	def_bool y
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select HAVE_KRETPROBES
 
 source "init/Kconfig"
 
Index: linux-2.6.25-rc2/arch/arm/Kconfig
===================================================================
--- linux-2.6.25-rc2.orig/arch/arm/Kconfig
+++ linux-2.6.25-rc2/arch/arm/Kconfig
@@ -12,6 +12,7 @@ config ARM
 	select SYS_SUPPORTS_APM_EMULATION
 	select HAVE_OPROFILE
 	select HAVE_KPROBES if (!XIP_KERNEL)
+	select HAVE_KRETPROBES if (HAVE_KPROBES)
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
Index: linux-2.6.25-rc2/include/asm-arm/kprobes.h
===================================================================
--- linux-2.6.25-rc2.orig/include/asm-arm/kprobes.h
+++ linux-2.6.25-rc2/include/asm-arm/kprobes.h
@@ -20,7 +20,6 @@
 #include <linux/ptrace.h>
 #include <linux/percpu.h>
 
-#define ARCH_SUPPORTS_KRETPROBES
 #define __ARCH_WANT_KPROBES_INSN_SLOT
 #define MAX_INSN_SIZE			2
 #define MAX_STACK_SIZE			64	/* 32 would probably be OK */
Index: linux-2.6.25-rc2/include/asm-s390/kprobes.h
===================================================================
--- linux-2.6.25-rc2.orig/include/asm-s390/kprobes.h
+++ linux-2.6.25-rc2/include/asm-s390/kprobes.h
@@ -46,7 +46,6 @@ typedef u16 kprobe_opcode_t;
 	? (MAX_STACK_SIZE) \
 	: (((unsigned long)current_thread_info()) + THREAD_SIZE - (ADDR)))
 
-#define ARCH_SUPPORTS_KRETPROBES
 #define kretprobe_blacklist_size 0
 
 #define KPROBE_SWAP_INST	0x10
Index: linux-2.6.25-rc2/arch/sparc64/Kconfig
===================================================================
--- linux-2.6.25-rc2.orig/arch/sparc64/Kconfig
+++ linux-2.6.25-rc2/arch/sparc64/Kconfig
@@ -10,6 +10,7 @@ config SPARC
 	default y
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select HAVE_KRETPROBES
 
 config SPARC64
 	bool
Index: linux-2.6.25-rc2/include/asm-sparc64/kprobes.h
===================================================================
--- linux-2.6.25-rc2.orig/include/asm-sparc64/kprobes.h
+++ linux-2.6.25-rc2/include/asm-sparc64/kprobes.h
@@ -14,8 +14,6 @@ typedef u32 kprobe_opcode_t;
 
 #define arch_remove_kprobe(p)	do {} while (0)
 
-#define ARCH_SUPPORTS_KRETPROBES
-
 #define flush_insn_slot(p)		\
 do { 	flushi(&(p)->ainsn.insn[0]);	\
 	flushi(&(p)->ainsn.insn[1]);	\
