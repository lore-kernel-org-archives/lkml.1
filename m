Return-Path: <linux-kernel-owner+w=401wt.eu-S1757429AbXKMPrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429AbXKMPrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 10:47:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686AbXKMPrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 10:47:25 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46571 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064AbXKMPrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 10:47:24 -0500
Date: Tue, 13 Nov 2007 21:17:10 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, hch@infradead.org,
       randy.dunlap@oracle.com,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       mathieu.desnoyers@polymtl.ca, davem@davemloft.net,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>
Subject: [patch 1/2] Kprobes: Indicate kretprobe support in arch/<arch>/Kconfig
Message-ID: <20071113154710.GB25095@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20071021123919.GA7648@in.ibm.com> <20071113040045.0440e575.akpm@linux-foundation.org> <20071113153924.GA25095@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113153924.GA25095@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

This patch adds CONFIG_ARCH_SUPPORTS_KRETPROBES to the
arch/<arch>/Kconfig file for relevant architectures with kprobes
support. This facilitates easy handling of in-kernel modules (like
samples/kprobes/kretprobe_example.c) that depend on kretprobes being
present in the kernel.

This patch depends on Mathieu Desnoyers' "Instrumentation menu removal"
patchset (http://marc.info/?l=linux-kernel&m=119496432229633&w=2)


Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 arch/avr32/Kconfig            |    5 +++++
 arch/ia64/Kconfig             |    5 +++++
 arch/powerpc/Kconfig          |    5 +++++
 arch/s390/Kconfig             |    5 +++++
 arch/sparc64/Kconfig          |    5 +++++
 arch/x86/Kconfig.i386         |    5 +++++
 arch/x86/Kconfig.x86_64       |    5 +++++
 include/asm-ia64/kprobes.h    |    1 -
 include/asm-powerpc/kprobes.h |    1 -
 include/asm-s390/kprobes.h    |    1 -
 include/asm-x86/kprobes_32.h  |    1 -
 include/asm-x86/kprobes_64.h  |    1 -
 include/linux/kprobes.h       |    6 +++---
 kernel/kprobes.c              |    6 +++---
 14 files changed, 41 insertions(+), 11 deletions(-)

Index: kernel-13nov/arch/avr32/Kconfig
===================================================================
--- kernel-13nov.orig/arch/avr32/Kconfig
+++ kernel-13nov/arch/avr32/Kconfig
@@ -73,6 +73,11 @@ config GENERIC_BUG
 config ARCH_SUPPORTS_KPROBES
 	def_bool y
 
+config ARCH_SUPPORTS_KRETPROBES
+	bool
+	depends on ARCH_SUPPORTS_KPROBES
+	default n
+
 source "init/Kconfig"
 
 menu "System Type and features"
Index: kernel-13nov/arch/ia64/Kconfig
===================================================================
--- kernel-13nov.orig/arch/ia64/Kconfig
+++ kernel-13nov/arch/ia64/Kconfig
@@ -105,6 +105,11 @@ config ARCH_SUPPORTS_OPROFILE
 config ARCH_SUPPORTS_KPROBES
 	def_bool y
 
+config ARCH_SUPPORTS_KRETPROBES
+	bool
+	depends on ARCH_SUPPORTS_KPROBES
+	default y
+
 choice
 	prompt "System type"
 	default IA64_GENERIC
Index: kernel-13nov/arch/powerpc/Kconfig
===================================================================
--- kernel-13nov.orig/arch/powerpc/Kconfig
+++ kernel-13nov/arch/powerpc/Kconfig
@@ -169,6 +169,11 @@ config ARCH_SUPPORTS_OPROFILE
 config ARCH_SUPPORTS_KPROBES
 	def_bool y
 
+config ARCH_SUPPORTS_KRETPROBES
+	bool
+	depends on ARCH_SUPPORTS_KPROBES
+	default y
+
 source "init/Kconfig"
 
 source "arch/powerpc/platforms/Kconfig"
Index: kernel-13nov/arch/s390/Kconfig
===================================================================
--- kernel-13nov.orig/arch/s390/Kconfig
+++ kernel-13nov/arch/s390/Kconfig
@@ -58,6 +58,11 @@ config ARCH_SUPPORTS_OPROFILE
 config ARCH_SUPPORTS_KPROBES
 	def_bool y
 
+config ARCH_SUPPORTS_KRETPROBES
+	bool
+	depends on ARCH_SUPPORTS_KPROBES
+	default y
+
 source "init/Kconfig"
 
 menu "Base setup"
Index: kernel-13nov/arch/sparc64/Kconfig
===================================================================
--- kernel-13nov.orig/arch/sparc64/Kconfig
+++ kernel-13nov/arch/sparc64/Kconfig
@@ -82,6 +82,11 @@ config ARCH_SUPPORTS_OPROFILE
 config ARCH_SUPPORTS_KPROBES
 	def_bool y
 
+config ARCH_SUPPORTS_KRETPROBES
+	bool
+	depends on ARCH_SUPPORTS_KPROBES
+	default n
+
 choice
 	prompt "Kernel page size"
 	default SPARC64_PAGE_SIZE_8KB
Index: kernel-13nov/arch/x86/Kconfig.i386
===================================================================
--- kernel-13nov.orig/arch/x86/Kconfig.i386
+++ kernel-13nov/arch/x86/Kconfig.i386
@@ -97,6 +97,11 @@ config ARCH_SUPPORTS_OPROFILE
 config ARCH_SUPPORTS_KPROBES
 	def_bool y
 
+config ARCH_SUPPORTS_KRETPROBES
+	bool
+	depends on ARCH_SUPPORTS_KPROBES
+	default y
+
 source "init/Kconfig"
 
 menu "Processor type and features"
Index: kernel-13nov/arch/x86/Kconfig.x86_64
===================================================================
--- kernel-13nov.orig/arch/x86/Kconfig.x86_64
+++ kernel-13nov/arch/x86/Kconfig.x86_64
@@ -139,6 +139,11 @@ config ARCH_SUPPORTS_OPROFILE
 config ARCH_SUPPORTS_KPROBES
 	def_bool y
 
+config ARCH_SUPPORTS_KRETPROBES
+	bool
+	depends on ARCH_SUPPORTS_KPROBES
+	default y
+
 source "init/Kconfig"
 
 
Index: kernel-13nov/include/asm-ia64/kprobes.h
===================================================================
--- kernel-13nov.orig/include/asm-ia64/kprobes.h
+++ kernel-13nov/include/asm-ia64/kprobes.h
@@ -82,7 +82,6 @@ struct kprobe_ctlblk {
 	struct prev_kprobe prev_kprobe[ARCH_PREV_KPROBE_SZ];
 };
 
-#define ARCH_SUPPORTS_KRETPROBES
 #define kretprobe_blacklist_size 0
 
 #define SLOT0_OPCODE_SHIFT	(37)
Index: kernel-13nov/include/asm-powerpc/kprobes.h
===================================================================
--- kernel-13nov.orig/include/asm-powerpc/kprobes.h
+++ kernel-13nov/include/asm-powerpc/kprobes.h
@@ -80,7 +80,6 @@ typedef unsigned int kprobe_opcode_t;
 #define is_trap(instr)	(IS_TW(instr) || IS_TWI(instr))
 #endif
 
-#define ARCH_SUPPORTS_KRETPROBES
 #define flush_insn_slot(p)	do { } while (0)
 #define kretprobe_blacklist_size 0
 
Index: kernel-13nov/include/asm-s390/kprobes.h
===================================================================
--- kernel-13nov.orig/include/asm-s390/kprobes.h
+++ kernel-13nov/include/asm-s390/kprobes.h
@@ -46,7 +46,6 @@ typedef u16 kprobe_opcode_t;
 	? (MAX_STACK_SIZE) \
 	: (((unsigned long)current_thread_info()) + THREAD_SIZE - (ADDR)))
 
-#define ARCH_SUPPORTS_KRETPROBES
 #define kretprobe_blacklist_size 0
 
 #define KPROBE_SWAP_INST	0x10
Index: kernel-13nov/include/asm-x86/kprobes_32.h
===================================================================
--- kernel-13nov.orig/include/asm-x86/kprobes_32.h
+++ kernel-13nov/include/asm-x86/kprobes_32.h
@@ -42,7 +42,6 @@ typedef u8 kprobe_opcode_t;
 	? (MAX_STACK_SIZE) \
 	: (((unsigned long)current_thread_info()) + THREAD_SIZE - (ADDR)))
 
-#define ARCH_SUPPORTS_KRETPROBES
 #define flush_insn_slot(p)	do { } while (0)
 
 extern const int kretprobe_blacklist_size;
Index: kernel-13nov/include/asm-x86/kprobes_64.h
===================================================================
--- kernel-13nov.orig/include/asm-x86/kprobes_64.h
+++ kernel-13nov/include/asm-x86/kprobes_64.h
@@ -41,7 +41,6 @@ typedef u8 kprobe_opcode_t;
 	? (MAX_STACK_SIZE) \
 	: (((unsigned long)current_thread_info()) + THREAD_SIZE - (ADDR)))
 
-#define ARCH_SUPPORTS_KRETPROBES
 extern const int kretprobe_blacklist_size;
 
 void kretprobe_trampoline(void);
Index: kernel-13nov/include/linux/kprobes.h
===================================================================
--- kernel-13nov.orig/include/linux/kprobes.h
+++ kernel-13nov/include/linux/kprobes.h
@@ -125,11 +125,11 @@ struct jprobe {
 DECLARE_PER_CPU(struct kprobe *, current_kprobe);
 DECLARE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
-#ifdef ARCH_SUPPORTS_KRETPROBES
+#ifdef CONFIG_ARCH_SUPPORTS_KRETPROBES
 extern void arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				   struct pt_regs *regs);
 extern int arch_trampoline_kprobe(struct kprobe *p);
-#else /* ARCH_SUPPORTS_KRETPROBES */
+#else /* CONFIG_ARCH_SUPPORTS_KRETPROBES */
 static inline void arch_prepare_kretprobe(struct kretprobe *rp,
 					struct pt_regs *regs)
 {
@@ -138,7 +138,7 @@ static inline int arch_trampoline_kprobe
 {
 	return 0;
 }
-#endif /* ARCH_SUPPORTS_KRETPROBES */
+#endif /* CONFIG_ARCH_SUPPORTS_KRETPROBES */
 /*
  * Function-return probe -
  * Note:
Index: kernel-13nov/kernel/kprobes.c
===================================================================
--- kernel-13nov.orig/kernel/kprobes.c
+++ kernel-13nov/kernel/kprobes.c
@@ -678,7 +678,7 @@ void __kprobes unregister_jprobe(struct 
 	unregister_kprobe(&jp->kp);
 }
 
-#ifdef ARCH_SUPPORTS_KRETPROBES
+#ifdef CONFIG_ARCH_SUPPORTS_KRETPROBES
 
 /*
  * This kprobe pre_handler is registered with every kretprobe. When probe
@@ -762,7 +762,7 @@ int __kprobes register_kretprobe(struct 
 	return ret;
 }
 
-#else /* ARCH_SUPPORTS_KRETPROBES */
+#else /* CONFIG_ARCH_SUPPORTS_KRETPROBES */
 
 int __kprobes register_kretprobe(struct kretprobe *rp)
 {
@@ -775,7 +775,7 @@ static int __kprobes pre_handler_kretpro
 	return 0;
 }
 
-#endif /* ARCH_SUPPORTS_KRETPROBES */
+#endif /* CONFIG_ARCH_SUPPORTS_KRETPROBES */
 
 void __kprobes unregister_kretprobe(struct kretprobe *rp)
 {
