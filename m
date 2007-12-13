Return-Path: <linux-kernel-owner+w=401wt.eu-S1760000AbXLMJG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000AbXLMJG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 04:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbXLMJGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 04:06:45 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:30758
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751787AbXLMJGo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 04:06:44 -0500
Message-Id: <47610462.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 13 Dec 2007 09:07:30 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: eliminate dead code
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 arch/x86/kernel/entry_64.S |    4 ----
 arch/x86/kernel/traps_64.c |    3 ---
 2 files changed, 7 deletions(-)

--- linux-2.6.24-rc5/arch/x86/kernel/entry_64.S	2007-12-12 16:48:17.000000000 +0100
+++ 2.6.24-rc5-x86_64-dead-code/arch/x86/kernel/entry_64.S	2007-12-04 16:09:33.000000000 +0100
@@ -1087,10 +1087,6 @@ ENTRY(coprocessor_segment_overrun)
 	zeroentry do_coprocessor_segment_overrun
 END(coprocessor_segment_overrun)
 
-ENTRY(reserved)
-	zeroentry do_reserved
-END(reserved)
-
 	/* runs on exception stack */
 ENTRY(double_fault)
 	XCPT_FRAME
--- linux-2.6.24-rc5/arch/x86/kernel/traps_64.c	2007-12-12 16:48:17.000000000 +0100
+++ 2.6.24-rc5-x86_64-dead-code/arch/x86/kernel/traps_64.c	2007-12-04 16:09:33.000000000 +0100
@@ -69,7 +69,6 @@ asmlinkage void general_protection(void)
 asmlinkage void page_fault(void);
 asmlinkage void coprocessor_error(void);
 asmlinkage void simd_coprocessor_error(void);
-asmlinkage void reserved(void);
 asmlinkage void alignment_check(void);
 asmlinkage void machine_check(void);
 asmlinkage void spurious_interrupt_bug(void);
@@ -646,12 +645,10 @@ DO_ERROR_INFO( 0, SIGFPE,  "divide error
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



