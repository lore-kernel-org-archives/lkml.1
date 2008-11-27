Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbYK0SKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbYK0SKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 13:10:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbYK0SKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 13:10:14 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:26833 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbYK0SKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 13:10:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eWC9iy6zGGqhbZqcYc3+L4rpcfM7+Y4/hX4IuXFuo2BeJL2fU9bqUS/zhnPnToE8DE
         S0AKYCyd390x/4FxUajxl78z/fAhogP+tPno+mBSvZPUktf0WqelG/65hRqgIQp7EVUV
         genwp6miecESwiMyZgY9e/A9rC6mjM3LbfOYc=
Date: Thu, 27 Nov 2008 21:10:08 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] x86: entry_64.S - trivial: space, comments fixup
Message-ID: <20081127181008.GB23593@localhost>
References: <1227727024-2281-1-git-send-email-gorcunov@gmail.com> <82259867e200855889261370c29bbd15a111d7fb.1227725632.git.gorcunov@gmail.com> <cc7949234e3ac0ddb402764be5ed620035f964a6.1227725632.git.gorcunov@gmail.com> <6bc2fd402754cfa5b69a63a529bc065584c5f375.1227725632.git.gorcunov@gmail.com> <39e35cbc79237b162a0720dceaa52a72c7eb1690.1227725632.git.gorcunov@gmail.com> <fbfac26820d86fa887adfbfa8ac80b369de00075.1227725632.git.gorcunov@gmail.com> <1227782341.31610.1287042073@webmail.messagingengine.com> <20081127120230.GB4259@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081127120230.GB4259@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Thu, Nov 27, 2008 at 01:02:34PM +0100]
| > > From: Cyrill Gorcunov <gorcunov@gmail.com>
| > > 
| > > Impact: cleanup
| > > 
| > > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| > 
| > Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>
| 
| Cyrill, could you please rework the still relevant bits against latest 
| tip/master? Alexander's wider patch got in the way.
| 
| Thanks,
| 
| 	Ingo
| 

Here is an updated version
---
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: x86: entry_64.S - trivial: space, comments fixup

Impact: cleanup

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/entry_64.S |   94 ++++++++++++++++++++++-----------------------
 1 file changed, 48 insertions(+), 46 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/entry_64.S
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/entry_64.S
+++ linux-2.6.git/arch/x86/kernel/entry_64.S
@@ -1027,7 +1027,7 @@ END(\sym)
 
 .macro paranoidzeroentry_ist sym do_sym ist
 ENTRY(\sym)
- 	INTR_FRAME
+	INTR_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
 	pushq $-1		/* ORIG_RAX: no syscall to restart */
 	CFI_ADJUST_CFA_OFFSET 8
@@ -1095,36 +1095,36 @@ zeroentry coprocessor_error do_coprocess
 errorentry alignment_check do_alignment_check
 zeroentry simd_coprocessor_error do_simd_coprocessor_error
 
-       /* Reload gs selector with exception handling */
-       /* edi:  new selector */
+	/* Reload gs selector with exception handling */
+	/* edi:  new selector */
 ENTRY(native_load_gs_index)
 	CFI_STARTPROC
 	pushf
 	CFI_ADJUST_CFA_OFFSET 8
 	DISABLE_INTERRUPTS(CLBR_ANY | ~(CLBR_RDI))
-        SWAPGS
+	SWAPGS
 gs_change:
-        movl %edi,%gs
+	movl %edi,%gs
 2:	mfence		/* workaround */
 	SWAPGS
-        popf
+	popf
 	CFI_ADJUST_CFA_OFFSET -8
-        ret
+	ret
 	CFI_ENDPROC
 END(native_load_gs_index)
 
-        .section __ex_table,"a"
-        .align 8
-        .quad gs_change,bad_gs
-        .previous
-        .section .fixup,"ax"
+	.section __ex_table,"a"
+	.align 8
+	.quad gs_change,bad_gs
+	.previous
+	.section .fixup,"ax"
 	/* running with kernelgs */
 bad_gs:
 	SWAPGS			/* switch back to user gs */
 	xorl %eax,%eax
-        movl %eax,%gs
-        jmp  2b
-        .previous
+	movl %eax,%gs
+	jmp  2b
+	.previous
 
 /*
  * Create a kernel thread.
@@ -1159,7 +1159,7 @@ ENTRY(kernel_thread)
 	 * so internally to the x86_64 port you can rely on kernel_thread()
 	 * not to reschedule the child before returning, this avoids the need
 	 * of hacks for example to fork off the per-CPU idle tasks.
-         * [Hopefully no generic code relies on the reschedule -AK]
+	 * [Hopefully no generic code relies on the reschedule -AK]
 	 */
 	RESTORE_ALL
 	UNFAKE_STACK_FRAME
@@ -1239,22 +1239,24 @@ END(call_softirq)
 zeroentry xen_hypervisor_callback xen_do_hypervisor_callback
 
 /*
-# A note on the "critical region" in our callback handler.
-# We want to avoid stacking callback handlers due to events occurring
-# during handling of the last event. To do this, we keep events disabled
-# until we've done all processing. HOWEVER, we must enable events before
-# popping the stack frame (can't be done atomically) and so it would still
-# be possible to get enough handler activations to overflow the stack.
-# Although unlikely, bugs of that kind are hard to track down, so we'd
-# like to avoid the possibility.
-# So, on entry to the handler we detect whether we interrupted an
-# existing activation in its critical region -- if so, we pop the current
-# activation and restart the handler using the previous one.
-*/
+ * A note on the "critical region" in our callback handler.
+ * We want to avoid stacking callback handlers due to events occurring
+ * during handling of the last event. To do this, we keep events disabled
+ * until we've done all processing. HOWEVER, we must enable events before
+ * popping the stack frame (can't be done atomically) and so it would still
+ * be possible to get enough handler activations to overflow the stack.
+ * Although unlikely, bugs of that kind are hard to track down, so we'd
+ * like to avoid the possibility.
+ * So, on entry to the handler we detect whether we interrupted an
+ * existing activation in its critical region -- if so, we pop the current
+ * activation and restart the handler using the previous one.
+ */
 ENTRY(xen_do_hypervisor_callback)   # do_hypervisor_callback(struct *pt_regs)
 	CFI_STARTPROC
-/* Since we don't modify %rdi, evtchn_do_upall(struct *pt_regs) will
-   see the correct pointer to the pt_regs */
+/*
+ * Since we don't modify %rdi, evtchn_do_upall(struct *pt_regs) will
+ * see the correct pointer to the pt_regs
+ */
 	movq %rdi, %rsp            # we don't return, adjust the stack frame
 	CFI_ENDPROC
 	DEFAULT_FRAME
@@ -1272,18 +1274,18 @@ ENTRY(xen_do_hypervisor_callback)   # do
 END(do_hypervisor_callback)
 
 /*
-# Hypervisor uses this for application faults while it executes.
-# We get here for two reasons:
-#  1. Fault while reloading DS, ES, FS or GS
-#  2. Fault while executing IRET
-# Category 1 we do not need to fix up as Xen has already reloaded all segment
-# registers that could be reloaded and zeroed the others.
-# Category 2 we fix up by killing the current process. We cannot use the
-# normal Linux return path in this case because if we use the IRET hypercall
-# to pop the stack frame we end up in an infinite loop of failsafe callbacks.
-# We distinguish between categories by comparing each saved segment register
-# with its current contents: any discrepancy means we in category 1.
-*/
+ * Hypervisor uses this for application faults while it executes.
+ * We get here for two reasons:
+ *  1. Fault while reloading DS, ES, FS or GS
+ *  2. Fault while executing IRET
+ * Category 1 we do not need to fix up as Xen has already reloaded all segment
+ * registers that could be reloaded and zeroed the others.
+ * Category 2 we fix up by killing the current process. We cannot use the
+ * normal Linux return path in this case because if we use the IRET hypercall
+ * to pop the stack frame we end up in an infinite loop of failsafe callbacks.
+ * We distinguish between categories by comparing each saved segment register
+ * with its current contents: any discrepancy means we in category 1.
+ */
 ENTRY(xen_failsafe_callback)
 	INTR_FRAME 1 (6*8)
 	/*CFI_REL_OFFSET gs,GS*/
@@ -1347,8 +1349,8 @@ paranoidzeroentry machine_check do_machi
 #endif
 
 	/*
- 	 * "Paranoid" exit path from exception stack.
-  	 * Paranoid because this is used by NMIs and cannot take
+	 * "Paranoid" exit path from exception stack.
+	 * Paranoid because this is used by NMIs and cannot take
 	 * any kernel state for granted.
 	 * We don't do kernel preemption checks here, because only
 	 * NMI should be common and it does not enable IRQs and
@@ -1453,7 +1455,7 @@ error_kernelspace:
 	cmpq %rcx,RIP+8(%rsp)
 	je error_swapgs
 	cmpq $gs_change,RIP+8(%rsp)
-        je error_swapgs
+	je error_swapgs
 	jmp error_sti
 END(error_entry)
 
@@ -1529,7 +1531,7 @@ nmi_schedule:
 	CFI_ENDPROC
 #else
 	jmp paranoid_exit
- 	CFI_ENDPROC
+	CFI_ENDPROC
 #endif
 END(nmi)
 
