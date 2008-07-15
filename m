Return-Path: <linux-kernel-owner+w=401wt.eu-S1757263AbYGOPkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263AbYGOPkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbYGOPkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:40:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:51472 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbYGOPkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:40:03 -0400
Subject: [PATCH] x86: Introducing asm-x86/traps.h
From: Jaswinder Singh <jaswinder@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 21:09:13 +0530
Message-Id: <1216136353.2747.3.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Declaring x86 traps under one hood.
Declaring x86 do_traps before defining them.

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 arch/x86/kernel/traps_32.c |   21 +-------------
 arch/x86/kernel/traps_64.c |   22 +--------------
 include/asm-x86/traps.h    |   66 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+), 41 deletions(-)
 create mode 100644 include/asm-x86/traps.h

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 8a76897..a4e9ba5 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -58,6 +58,7 @@
 #include <asm/nmi.h>
 #include <asm/smp.h>
 #include <asm/io.h>
+#include <asm/traps.h>
 
 #include "mach_traps.h"
 
@@ -77,26 +78,6 @@ char ignore_fpu_irq;
 gate_desc idt_table[256]
 	__attribute__((__section__(".data.idt"))) = { { { { 0, 0 } } }, };
 
-asmlinkage void divide_error(void);
-asmlinkage void debug(void);
-asmlinkage void nmi(void);
-asmlinkage void int3(void);
-asmlinkage void overflow(void);
-asmlinkage void bounds(void);
-asmlinkage void invalid_op(void);
-asmlinkage void device_not_available(void);
-asmlinkage void coprocessor_segment_overrun(void);
-asmlinkage void invalid_TSS(void);
-asmlinkage void segment_not_present(void);
-asmlinkage void stack_segment(void);
-asmlinkage void general_protection(void);
-asmlinkage void page_fault(void);
-asmlinkage void coprocessor_error(void);
-asmlinkage void simd_coprocessor_error(void);
-asmlinkage void alignment_check(void);
-asmlinkage void spurious_interrupt_bug(void);
-asmlinkage void machine_check(void);
-
 int panic_on_unrecovered_nmi;
 int kstack_depth_to_print = 24;
 static unsigned int code_bytes = 64;
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 2696a68..3d74429 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -51,30 +51,10 @@
 #include <asm/pgalloc.h>
 #include <asm/proto.h>
 #include <asm/pda.h>
+#include <asm/traps.h>
 
 #include <mach_traps.h>
 
-asmlinkage void divide_error(void);
-asmlinkage void debug(void);
-asmlinkage void nmi(void);
-asmlinkage void int3(void);
-asmlinkage void overflow(void);
-asmlinkage void bounds(void);
-asmlinkage void invalid_op(void);
-asmlinkage void device_not_available(void);
-asmlinkage void double_fault(void);
-asmlinkage void coprocessor_segment_overrun(void);
-asmlinkage void invalid_TSS(void);
-asmlinkage void segment_not_present(void);
-asmlinkage void stack_segment(void);
-asmlinkage void general_protection(void);
-asmlinkage void page_fault(void);
-asmlinkage void coprocessor_error(void);
-asmlinkage void simd_coprocessor_error(void);
-asmlinkage void alignment_check(void);
-asmlinkage void spurious_interrupt_bug(void);
-asmlinkage void machine_check(void);
-
 int panic_on_unrecovered_nmi;
 int kstack_depth_to_print = 12;
 static unsigned int code_bytes = 64;
diff --git a/include/asm-x86/traps.h b/include/asm-x86/traps.h
new file mode 100644
index 0000000..a4b65a7
--- /dev/null
+++ b/include/asm-x86/traps.h
@@ -0,0 +1,66 @@
+#ifndef _ASM_X86_TRAPS_H
+#define _ASM_X86_TRAPS_H
+
+/* Common in X86_32 and X86_64 */
+asmlinkage void divide_error(void);
+asmlinkage void debug(void);
+asmlinkage void nmi(void);
+asmlinkage void int3(void);
+asmlinkage void overflow(void);
+asmlinkage void bounds(void);
+asmlinkage void invalid_op(void);
+asmlinkage void device_not_available(void);
+asmlinkage void coprocessor_segment_overrun(void);
+asmlinkage void invalid_TSS(void);
+asmlinkage void segment_not_present(void);
+asmlinkage void stack_segment(void);
+asmlinkage void general_protection(void);
+asmlinkage void page_fault(void);
+asmlinkage void coprocessor_error(void);
+asmlinkage void simd_coprocessor_error(void);
+asmlinkage void alignment_check(void);
+asmlinkage void spurious_interrupt_bug(void);
+#ifdef CONFIG_X86_MCE
+asmlinkage void machine_check(void);
+#endif /* CONFIG_X86_MCE */
+
+void do_divide_error(struct pt_regs *, long);
+void do_overflow(struct pt_regs *, long);
+void do_bounds(struct pt_regs *, long);
+void do_coprocessor_segment_overrun(struct pt_regs *, long);
+void do_invalid_TSS(struct pt_regs *, long);
+void do_segment_not_present(struct pt_regs *, long);
+void do_stack_segment(struct pt_regs *, long);
+void do_alignment_check(struct pt_regs *, long);
+void do_invalid_op(struct pt_regs *, long);
+void do_general_protection(struct pt_regs *, long);
+void do_nmi(struct pt_regs *, long);
+
+extern int panic_on_unrecovered_nmi;
+extern int kstack_depth_to_print;
+
+#ifdef CONFIG_X86_32
+
+void do_iret_error(struct pt_regs *, long);
+void do_int3(struct pt_regs *, long);
+void do_debug(struct pt_regs *, long);
+void math_error(void __user *);
+void do_coprocessor_error(struct pt_regs *, long);
+void do_simd_coprocessor_error(struct pt_regs *, long);
+void do_spurious_interrupt_bug(struct pt_regs *, long);
+unsigned long patch_espfix_desc(unsigned long, unsigned long);
+asmlinkage void math_emulate(long);
+
+#else /* CONFIG_X86_32 */
+
+asmlinkage void double_fault(void);
+
+asmlinkage void do_int3(struct pt_regs *, long);
+asmlinkage void do_stack_segment(struct pt_regs *, long);
+asmlinkage void do_debug(struct pt_regs *, unsigned long);
+asmlinkage void do_coprocessor_error(struct pt_regs *);
+asmlinkage void do_simd_coprocessor_error(struct pt_regs *);
+asmlinkage void do_spurious_interrupt_bug(struct pt_regs *);
+
+#endif /* CONFIG_X86_32 */
+#endif /* _ASM_X86_TRAPS_H */
-- 
1.5.5.1



