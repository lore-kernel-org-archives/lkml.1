Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbXLJJwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbXLJJwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 04:52:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbXLJJwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 04:52:47 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:36868 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbXLJJwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 04:52:46 -0500
Date: Mon, 10 Dec 2007 15:22:22 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: akpm@linux-foundation.org
Cc: lkml <linux-kernel@vger.kernel.org>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       davem@davemloft.net, mathieu.desnoyers@polymtl.ca,
       hskinnemoen@atmel.com
Subject: [PATCH 1/2] Kprobes: Indicate kretprobe support in arch/<arch>/Kconfig
Message-ID: <20071210095221.GA19425@in.ibm.com>
Reply-To: ananth@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

This patch adds CONFIG_HAVE_KRETPROBES to the arch/<arch>/Kconfig file
for relevant architectures with kprobes support. This facilitates easy
handling of in-kernel modules (like samples/kprobes/kretprobe_example.c)
that depend on kretprobes being present in the kernel.

This patch depends on Mathieu Desnoyers' "Instrumentation menu removal"
patchset (http://marc.info/?l=linux-kernel&m=119496432229633&w=2)

Updated to apply on 2.6.24-rc4-mm1.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 arch/avr32/Kconfig            |    5 +++++
 arch/ia64/Kconfig             |    5 +++++
 arch/powerpc/Kconfig          |    5 +++++
 arch/s390/Kconfig             |    5 +++++
 arch/sparc64/Kconfig          |    5 +++++
 arch/x86/Kconfig              |    5 +++++
 include/asm-ia64/kprobes.h    |    1 -
 include/asm-powerpc/kprobes.h |    1 -
 include/asm-s390/kprobes.h    |    1 -
 include/asm-x86/kprobes_32.h  |    1 -
 include/asm-x86/kprobes_64.h  |    1 -
 include/linux/kprobes.h       |    6 +++---
 kernel/kprobes.c              |    8 +++-----
 13 files changed, 36 insertions(+), 13 deletions(-)

Index: linux-2.6.24-rc4/arch/avr32/Kconfig
===================================================================
--- linux-2.6.24-rc4.orig/arch/avr32/Kconfig
+++ linux-2.6.24-rc4/arch/avr32/Kconfig
@@ -66,6 +66,11 @@ config GENERIC_BUG
 	def_bool y
 	depends on BUG
 
+config HAVE_KRETPROBES
+	bool
+	depends on HAVE_KPROBES
+	default n
+
 source "init/Kconfig"
 
 menu "System Type and features"
Index: linux-2.6.24-rc4/arch/ia64/Kconfig
===================================================================
--- linux-2.6.24-rc4.orig/arch/ia64/Kconfig
+++ linux-2.6.24-rc4/arch/ia64/Kconfig
@@ -101,6 +101,11 @@ config AUDIT_ARCH
 	bool
 	default y
 
+config HAVE_KRETPROBES
+	bool
+	depends on HAVE_KPROBES
+	default y
+
 choice
 	prompt "System type"
 	default IA64_GENERIC
Index: linux-2.6.24-rc4/arch/powerpc/Kconfig
===================================================================
--- linux-2.6.24-rc4.orig/arch/powerpc/Kconfig
+++ linux-2.6.24-rc4/arch/powerpc/Kconfig
@@ -165,6 +165,11 @@ config PPC_OF_PLATFORM_PCI
 	depends on PPC64 # not supported on 32 bits yet
 	default n
 
+config HAVE_KRETPROBES
+	bool
+	depends on HAVE_KPROBES
+	default y
+
 source "init/Kconfig"
 
 source "arch/powerpc/platforms/Kconfig"
Index: linux-2.6.24-rc4/arch/s390/Kconfig
===================================================================
--- linux-2.6.24-rc4.orig/arch/s390/Kconfig
+++ linux-2.6.24-rc4/arch/s390/Kconfig
@@ -54,6 +54,11 @@ config S390
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 
+config HAVE_KRETPROBES
+	bool
+	depends on HAVE_KPROBES
+	default y
+
 source "init/Kconfig"
 
 menu "Base setup"
Index: linux-2.6.24-rc4/arch/sparc64/Kconfig
===================================================================
--- linux-2.6.24-rc4.orig/arch/sparc64/Kconfig
+++ linux-2.6.24-rc4/arch/sparc64/Kconfig
@@ -81,6 +81,11 @@ config GENERIC_HARDIRQS_NO__DO_IRQ
 config ARCH_SUPPORTS_AOUT
 	def_bool y
 
+config HAVE_KRETPROBES
+	bool
+	depends on HAVE_KPROBES
+	default n
+
 choice
 	prompt "Kernel page size"
 	default SPARC64_PAGE_SIZE_8KB
Index: linux-2.6.24-rc4/arch/x86/Kconfig
===================================================================
--- linux-2.6.24-rc4.orig/arch/x86/Kconfig
+++ linux-2.6.24-rc4/arch/x86/Kconfig
@@ -145,6 +145,11 @@ config X86_TRAMPOLINE
 config KTIME_SCALAR
 	def_bool X86_32
 
+config HAVE_KRETPROBES
+	bool
+	depends on HAVE_KPROBES
+	default y
+
 source "init/Kconfig"
 
 menu "Processor type and features"
Index: linux-2.6.24-rc4/include/asm-ia64/kprobes.h
===================================================================
--- linux-2.6.24-rc4.orig/include/asm-ia64/kprobes.h
+++ linux-2.6.24-rc4/include/asm-ia64/kprobes.h
@@ -82,7 +82,6 @@ struct kprobe_ctlblk {
 	struct prev_kprobe prev_kprobe[ARCH_PREV_KPROBE_SZ];
 };
 
-#define ARCH_SUPPORTS_KRETPROBES
 #define kretprobe_blacklist_size 0
 
 #define SLOT0_OPCODE_SHIFT	(37)
Index: linux-2.6.24-rc4/include/asm-powerpc/kprobes.h
===================================================================
--- linux-2.6.24-rc4.orig/include/asm-powerpc/kprobes.h
+++ linux-2.6.24-rc4/include/asm-powerpc/kprobes.h
@@ -80,7 +80,6 @@ typedef unsigned int kprobe_opcode_t;
 #define is_trap(instr)	(IS_TW(instr) || IS_TWI(instr))
 #endif
 
-#define ARCH_SUPPORTS_KRETPROBES
 #define flush_insn_slot(p)	do { } while (0)
 #define kretprobe_blacklist_size 0
 
Index: linux-2.6.24-rc4/include/asm-s390/kprobes.h
===================================================================
--- linux-2.6.24-rc4.orig/include/asm-s390/kprobes.h
+++ linux-2.6.24-rc4/include/asm-s390/kprobes.h
@@ -46,7 +46,6 @@ typedef u16 kprobe_opcode_t;
 	? (MAX_STACK_SIZE) \
 	: (((unsigned long)current_thread_info()) + THREAD_SIZE - (ADDR)))
 
-#define ARCH_SUPPORTS_KRETPROBES
 #define kretprobe_blacklist_size 0
 
 #define KPROBE_SWAP_INST	0x10
Index: linux-2.6.24-rc4/include/asm-x86/kprobes_32.h
===================================================================
--- linux-2.6.24-rc4.orig/include/asm-x86/kprobes_32.h
+++ linux-2.6.24-rc4/include/asm-x86/kprobes_32.h
@@ -42,7 +42,6 @@ typedef u8 kprobe_opcode_t;
 	? (MAX_STACK_SIZE) \
 	: (((unsigned long)current_thread_info()) + THREAD_SIZE - (ADDR)))
 
-#define ARCH_SUPPORTS_KRETPROBES
 #define flush_insn_slot(p)	do { } while (0)
 
 extern const int kretprobe_blacklist_size;
Index: linux-2.6.24-rc4/include/asm-x86/kprobes_64.h
===================================================================
--- linux-2.6.24-rc4.orig/include/asm-x86/kprobes_64.h
+++ linux-2.6.24-rc4/include/asm-x86/kprobes_64.h
@@ -41,7 +41,6 @@ typedef u8 kprobe_opcode_t;
 	? (MAX_STACK_SIZE) \
 	: (((unsigned long)current_thread_info()) + THREAD_SIZE - (ADDR)))
 
-#define ARCH_SUPPORTS_KRETPROBES
 extern const int kretprobe_blacklist_size;
 
 void kretprobe_trampoline(void);
Index: linux-2.6.24-rc4/include/linux/kprobes.h
===================================================================
--- linux-2.6.24-rc4.orig/include/linux/kprobes.h
+++ linux-2.6.24-rc4/include/linux/kprobes.h
@@ -125,11 +125,11 @@ struct jprobe {
 DECLARE_PER_CPU(struct kprobe *, current_kprobe);
 DECLARE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
-#ifdef ARCH_SUPPORTS_KRETPROBES
+#ifdef CONFIG_HAVE_KRETPROBES
 extern void arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				   struct pt_regs *regs);
 extern int arch_trampoline_kprobe(struct kprobe *p);
-#else /* ARCH_SUPPORTS_KRETPROBES */
+#else /* CONFIG_HAVE_KRETPROBES */
 static inline void arch_prepare_kretprobe(struct kretprobe *rp,
 					struct pt_regs *regs)
 {
@@ -138,7 +138,7 @@ static inline int arch_trampoline_kprobe
 {
 	return 0;
 }
-#endif /* ARCH_SUPPORTS_KRETPROBES */
+#endif /* CONFIG_HAVE_KRETPROBES */
 /*
  * Function-return probe -
  * Note:
Index: linux-2.6.24-rc4/kernel/kprobes.c
===================================================================
--- linux-2.6.24-rc4.orig/kernel/kprobes.c
+++ linux-2.6.24-rc4/kernel/kprobes.c
@@ -678,8 +678,7 @@ void __kprobes unregister_jprobe(struct 
 	unregister_kprobe(&jp->kp);
 }
 
-#ifdef ARCH_SUPPORTS_KRETPROBES
-
+#ifdef CONFIG_HAVE_KRETPROBES
 /*
  * This kprobe pre_handler is registered with every kretprobe. When probe
  * hits it will set up the return probe.
@@ -762,7 +761,7 @@ int __kprobes register_kretprobe(struct 
 	return ret;
 }
 
-#else /* ARCH_SUPPORTS_KRETPROBES */
+#else /* CONFIG_HAVE_KRETPROBES */
 
 int __kprobes register_kretprobe(struct kretprobe *rp)
 {
@@ -774,8 +773,7 @@ static int __kprobes pre_handler_kretpro
 {
 	return 0;
 }
-
-#endif /* ARCH_SUPPORTS_KRETPROBES */
+#endif /* CONFIG_HAVE_KRETPROBES */
 
 void __kprobes unregister_kretprobe(struct kretprobe *rp)
 {
