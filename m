Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbXKSWEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbXKSWEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbXKSWEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:04:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755889AbXKSWEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:04:21 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 05/18] x86 vDSO: harmonize asm-offsets
In-Reply-To: Roland McGrath's message of  Monday, 19 November 2007 13:59:43 -0800 <20071119215944.01B7C26F8BE@magilla.localdomain>
References: <20071119215944.01B7C26F8BE@magilla.localdomain>
X-Windows: the first fully modular software disaster.
Message-Id: <20071119220346.10C8D26F8C1@magilla.localdomain>
Date: Mon, 19 Nov 2007 14:03:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This change harmonizes the asm-offsets macros used in the 32-bit vDSO
across 32-bit and 64-bit builds.  It's a purely cosmetic change for now,
but it paves the way for consolidating the 32-bit vDSO builds.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/asm-offsets_32.c        |   20 ++++++------
 arch/x86/kernel/vsyscall-sigreturn_32.S |   54 +++++++++++++++---------------
 2 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kernel/asm-offsets_32.c b/arch/x86/kernel/asm-offsets_32.c
index 0e45981..c578a2b 100644
--- a/arch/x86/kernel/asm-offsets_32.c
+++ b/arch/x86/kernel/asm-offsets_32.c
@@ -38,15 +38,15 @@ void foo(void);
 
 void foo(void)
 {
-	OFFSET(SIGCONTEXT_eax, sigcontext, eax);
-	OFFSET(SIGCONTEXT_ebx, sigcontext, ebx);
-	OFFSET(SIGCONTEXT_ecx, sigcontext, ecx);
-	OFFSET(SIGCONTEXT_edx, sigcontext, edx);
-	OFFSET(SIGCONTEXT_esi, sigcontext, esi);
-	OFFSET(SIGCONTEXT_edi, sigcontext, edi);
-	OFFSET(SIGCONTEXT_ebp, sigcontext, ebp);
-	OFFSET(SIGCONTEXT_esp, sigcontext, esp);
-	OFFSET(SIGCONTEXT_eip, sigcontext, eip);
+	OFFSET(IA32_SIGCONTEXT_eax, sigcontext, eax);
+	OFFSET(IA32_SIGCONTEXT_ebx, sigcontext, ebx);
+	OFFSET(IA32_SIGCONTEXT_ecx, sigcontext, ecx);
+	OFFSET(IA32_SIGCONTEXT_edx, sigcontext, edx);
+	OFFSET(IA32_SIGCONTEXT_esi, sigcontext, esi);
+	OFFSET(IA32_SIGCONTEXT_edi, sigcontext, edi);
+	OFFSET(IA32_SIGCONTEXT_ebp, sigcontext, ebp);
+	OFFSET(IA32_SIGCONTEXT_esp, sigcontext, esp);
+	OFFSET(IA32_SIGCONTEXT_eip, sigcontext, eip);
 	BLANK();
 
 	OFFSET(CPUINFO_x86, cpuinfo_x86, x86);
@@ -94,7 +94,7 @@ void foo(void)
 	BLANK();
 
 	OFFSET(EXEC_DOMAIN_handler, exec_domain, handler);
-	OFFSET(RT_SIGFRAME_sigcontext, rt_sigframe, uc.uc_mcontext);
+	OFFSET(IA32_RT_SIGFRAME_sigcontext, rt_sigframe, uc.uc_mcontext);
 	BLANK();
 
 	OFFSET(pbe_address, pbe, address);
diff --git a/arch/x86/kernel/vsyscall-sigreturn_32.S b/arch/x86/kernel/vsyscall-sigreturn_32.S
index a92262f..e939253 100644
--- a/arch/x86/kernel/vsyscall-sigreturn_32.S
+++ b/arch/x86/kernel/vsyscall-sigreturn_32.S
@@ -91,27 +91,27 @@ __kernel_rt_sigreturn:
 	.sleb128 offset;		/*       offset */		\
 1:
 
-	do_cfa_expr(SIGCONTEXT_esp+4)
-	do_expr(0, SIGCONTEXT_eax+4)
-	do_expr(1, SIGCONTEXT_ecx+4)
-	do_expr(2, SIGCONTEXT_edx+4)
-	do_expr(3, SIGCONTEXT_ebx+4)
-	do_expr(5, SIGCONTEXT_ebp+4)
-	do_expr(6, SIGCONTEXT_esi+4)
-	do_expr(7, SIGCONTEXT_edi+4)
-	do_expr(8, SIGCONTEXT_eip+4)
+	do_cfa_expr(IA32_SIGCONTEXT_esp+4)
+	do_expr(0, IA32_SIGCONTEXT_eax+4)
+	do_expr(1, IA32_SIGCONTEXT_ecx+4)
+	do_expr(2, IA32_SIGCONTEXT_edx+4)
+	do_expr(3, IA32_SIGCONTEXT_ebx+4)
+	do_expr(5, IA32_SIGCONTEXT_ebp+4)
+	do_expr(6, IA32_SIGCONTEXT_esi+4)
+	do_expr(7, IA32_SIGCONTEXT_edi+4)
+	do_expr(8, IA32_SIGCONTEXT_eip+4)
 
 	.byte 0x42	/* DW_CFA_advance_loc 2 -- nop; popl eax. */
 
-	do_cfa_expr(SIGCONTEXT_esp)
-	do_expr(0, SIGCONTEXT_eax)
-	do_expr(1, SIGCONTEXT_ecx)
-	do_expr(2, SIGCONTEXT_edx)
-	do_expr(3, SIGCONTEXT_ebx)
-	do_expr(5, SIGCONTEXT_ebp)
-	do_expr(6, SIGCONTEXT_esi)
-	do_expr(7, SIGCONTEXT_edi)
-	do_expr(8, SIGCONTEXT_eip)
+	do_cfa_expr(IA32_SIGCONTEXT_esp)
+	do_expr(0, IA32_SIGCONTEXT_eax)
+	do_expr(1, IA32_SIGCONTEXT_ecx)
+	do_expr(2, IA32_SIGCONTEXT_edx)
+	do_expr(3, IA32_SIGCONTEXT_ebx)
+	do_expr(5, IA32_SIGCONTEXT_ebp)
+	do_expr(6, IA32_SIGCONTEXT_esi)
+	do_expr(7, IA32_SIGCONTEXT_edi)
+	do_expr(8, IA32_SIGCONTEXT_eip)
 
 	.align 4
 .LENDFDEDLSI1:
@@ -128,15 +128,15 @@ __kernel_rt_sigreturn:
 	   slightly less complicated than the above, since we don't
 	   modify the stack pointer in the process.  */
 
-	do_cfa_expr(RT_SIGFRAME_sigcontext-4 + SIGCONTEXT_esp)
-	do_expr(0, RT_SIGFRAME_sigcontext-4 + SIGCONTEXT_eax)
-	do_expr(1, RT_SIGFRAME_sigcontext-4 + SIGCONTEXT_ecx)
-	do_expr(2, RT_SIGFRAME_sigcontext-4 + SIGCONTEXT_edx)
-	do_expr(3, RT_SIGFRAME_sigcontext-4 + SIGCONTEXT_ebx)
-	do_expr(5, RT_SIGFRAME_sigcontext-4 + SIGCONTEXT_ebp)
-	do_expr(6, RT_SIGFRAME_sigcontext-4 + SIGCONTEXT_esi)
-	do_expr(7, RT_SIGFRAME_sigcontext-4 + SIGCONTEXT_edi)
-	do_expr(8, RT_SIGFRAME_sigcontext-4 + SIGCONTEXT_eip)
+	do_cfa_expr(IA32_RT_SIGFRAME_sigcontext-4 + IA32_SIGCONTEXT_esp)
+	do_expr(0, IA32_RT_SIGFRAME_sigcontext-4 + IA32_SIGCONTEXT_eax)
+	do_expr(1, IA32_RT_SIGFRAME_sigcontext-4 + IA32_SIGCONTEXT_ecx)
+	do_expr(2, IA32_RT_SIGFRAME_sigcontext-4 + IA32_SIGCONTEXT_edx)
+	do_expr(3, IA32_RT_SIGFRAME_sigcontext-4 + IA32_SIGCONTEXT_ebx)
+	do_expr(5, IA32_RT_SIGFRAME_sigcontext-4 + IA32_SIGCONTEXT_ebp)
+	do_expr(6, IA32_RT_SIGFRAME_sigcontext-4 + IA32_SIGCONTEXT_esi)
+	do_expr(7, IA32_RT_SIGFRAME_sigcontext-4 + IA32_SIGCONTEXT_edi)
+	do_expr(8, IA32_RT_SIGFRAME_sigcontext-4 + IA32_SIGCONTEXT_eip)
 
 	.align 4
 .LENDFDEDLSI2:
