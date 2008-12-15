Return-Path: <linux-kernel-owner+w=401wt.eu-S1756070AbYLOQ5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbYLOQ5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 11:57:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbYLOQ5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 11:57:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:55191 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912AbYLOQ5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 11:57:15 -0500
Subject: [PATCH] x86: traps.c declare functions before they get used
From: Jaswinder Singh <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain
Date: Mon, 15 Dec 2008 22:25:45 +0530
Message-Id: <1229360145.15326.5.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>

In asm/traps.h :-
do_double_fault : added under X86_64
sync_regs : added under X86_64
math_error : moved out from X86_32 as it is common for both 32 and 64 bit
smp_thermal_interrupt : added under X86_64
mce_threshold_interrupt : added under X86_64
math_emulate : moved from X86_32 to MATH_EMULATION
---
 arch/x86/include/asm/traps.h |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 45dee28..d8a201b 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -46,6 +46,10 @@ dotraplinkage void do_coprocessor_segment_overrun(struct pt_regs *, long);
 dotraplinkage void do_invalid_TSS(struct pt_regs *, long);
 dotraplinkage void do_segment_not_present(struct pt_regs *, long);
 dotraplinkage void do_stack_segment(struct pt_regs *, long);
+#ifdef CONFIG_X86_64
+dotraplinkage void do_double_fault(struct pt_regs *, long);
+asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *);
+#endif
 dotraplinkage void do_general_protection(struct pt_regs *, long);
 dotraplinkage void do_page_fault(struct pt_regs *, unsigned long);
 dotraplinkage void do_spurious_interrupt_bug(struct pt_regs *, long);
@@ -72,9 +76,14 @@ static inline int get_si_code(unsigned long condition)
 extern int panic_on_unrecovered_nmi;
 extern int kstack_depth_to_print;
 
-#ifdef CONFIG_X86_32
 void math_error(void __user *);
+#ifdef CONFIG_X86_32
 unsigned long patch_espfix_desc(unsigned long, unsigned long);
+#else
+asmlinkage void smp_thermal_interrupt(void);
+asmlinkage void mce_threshold_interrupt(void);
+#endif
+#ifndef CONFIG_MATH_EMULATION
 asmlinkage void math_emulate(long);
 #endif
 
-- 
1.5.5.1



