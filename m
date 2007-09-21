Return-Path: <linux-kernel-owner+w=401wt.eu-S932816AbXIUWnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816AbXIUWnq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764007AbXIUWcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:39 -0400
Received: from mx1.suse.de ([195.135.220.2]:57071 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762338AbXIUWca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:30 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: jbeulich@novell.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [30/50] x86_64: remove some dead code
Message-Id: <20070921223229.C0DE013DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:29 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Jan Beulich" <jbeulich@novell.com>
Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@suse.de>

 arch/x86_64/kernel/entry.S |    4 ----
 arch/x86_64/kernel/traps.c |    3 ---
 2 files changed, 7 deletions(-)

Index: linux/arch/x86_64/kernel/entry.S
===================================================================
--- linux.orig/arch/x86_64/kernel/entry.S
+++ linux/arch/x86_64/kernel/entry.S
@@ -1088,10 +1088,6 @@ ENTRY(coprocessor_segment_overrun)
 	zeroentry do_coprocessor_segment_overrun
 END(coprocessor_segment_overrun)
 
-ENTRY(reserved)
-	zeroentry do_reserved
-END(reserved)
-
 	/* runs on exception stack */
 ENTRY(double_fault)
 	XCPT_FRAME
Index: linux/arch/x86_64/kernel/traps.c
===================================================================
--- linux.orig/arch/x86_64/kernel/traps.c
+++ linux/arch/x86_64/kernel/traps.c
@@ -70,7 +70,6 @@ asmlinkage void general_protection(void)
 asmlinkage void page_fault(void);
 asmlinkage void coprocessor_error(void);
 asmlinkage void simd_coprocessor_error(void);
-asmlinkage void reserved(void);
 asmlinkage void alignment_check(void);
 asmlinkage void machine_check(void);
 asmlinkage void spurious_interrupt_bug(void);
@@ -710,12 +709,10 @@ DO_ERROR_INFO( 0, SIGFPE,  "divide error
 DO_ERROR( 4, SIGSEGV, "overflow", overflow)
 DO_ERROR( 5, SIGSEGV, "bounds", bounds)
 DO_ERROR_INFO( 6, SIGILL,  "invalid opcode", invalid_op, ILL_ILLOPN, regs->rip)
-DO_ERROR( 7, SIGSEGV, "device not available", device_not_available)
 DO_ERROR( 9, SIGFPE,  "coprocessor segment overrun", coprocessor_segment_overrun)
 DO_ERROR(10, SIGSEGV, "invalid TSS", invalid_TSS)
 DO_ERROR(11, SIGBUS,  "segment not present", segment_not_present)
 DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0)
-DO_ERROR(18, SIGSEGV, "reserved", reserved)
 
 /* Runs on IST stack */
 asmlinkage void do_stack_segment(struct pt_regs *regs, long error_code)
