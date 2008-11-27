Return-Path: <linux-kernel-owner+w=401wt.eu-S1758560AbYK0K5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560AbYK0K5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:57:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755864AbYK0KjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:39:06 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:49357 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755109AbYK0KjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:39:02 -0500
Message-Id: <1227782341.31610.1287042073@webmail.messagingengine.com>
X-Sasl-Enc: q9FVkOD88Ob9Afa8JEgFSeT+L7S2hEOThnXiGHlPJcWj 1227782341
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, "Cyrill Gorcunov" <gorcunov@gmail.com>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1227727024-2281-1-git-send-email-gorcunov@gmail.com>
 <82259867e200855889261370c29bbd15a111d7fb.1227725632.git.gorcunov@gmail.com>
 <cc7949234e3ac0ddb402764be5ed620035f964a6.1227725632.git.gorcunov@gmail.com>
 <6bc2fd402754cfa5b69a63a529bc065584c5f375.1227725632.git.gorcunov@gmail.com>
 <39e35cbc79237b162a0720dceaa52a72c7eb1690.1227725632.git.gorcunov@gmail.com>
 <fbfac26820d86fa887adfbfa8ac80b369de00075.1227725632.git.gorcunov@gmail.com>
Subject: Re: [PATCH 5/5] x86: entry_64.S - trivial: space, comments fixup
In-Reply-To: <fbfac26820d86fa887adfbfa8ac80b369de00075.1227725632.git.gorcunov@gmail.com>
Date: Thu, 27 Nov 2008 11:39:01 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 26 Nov 2008 22:17:04 +0300, gorcunov@gmail.com said:
> From: Cyrill Gorcunov <gorcunov@gmail.com>
> 
> Impact: cleanup
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>


>  arch/x86/kernel/entry_64.S |   92
>  ++++++++++++++++++++++---------------------
>  1 files changed, 47 insertions(+), 45 deletions(-)
> 
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index a21be86..5ccf410 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -1119,8 +1119,8 @@ paranoidzeroentry machine_check do_machine_check
>  zeroentry simd_coprocessor_error do_simd_coprocessor_error
>  
>  	/*
> - 	 * "Paranoid" exit path from exception stack.
> -  	 * Paranoid because this is used by NMIs and cannot take
> +	 * "Paranoid" exit path from exception stack.
> +	 * Paranoid because this is used by NMIs and cannot take
>  	 * any kernel state for granted.
>  	 * We don't do kernel preemption checks here, because only
>  	 * NMI should be common and it does not enable IRQs and
> @@ -1225,7 +1225,7 @@ error_kernelspace:
>  	cmpq %rcx,RIP+8(%rsp)
>  	je error_swapgs
>  	cmpq $gs_change,RIP+8(%rsp)
> -        je error_swapgs
> +	je error_swapgs
>  	jmp error_sti
>  KPROBE_END(error_entry)
>  
> @@ -1249,36 +1249,36 @@ KPROBE_ENTRY(error_exit)
>  	CFI_ENDPROC
>  KPROBE_END(error_exit)
>  
> -       /* Reload gs selector with exception handling */
> -       /* edi:  new selector */
> +	/* Reload gs selector with exception handling */
> +	/* edi:  new selector */
>  ENTRY(native_load_gs_index)
>  	CFI_STARTPROC
>  	pushf
>  	CFI_ADJUST_CFA_OFFSET 8
>  	DISABLE_INTERRUPTS(CLBR_ANY | ~(CLBR_RDI))
> -        SWAPGS
> +	SWAPGS
>  gs_change:
> -        movl %edi,%gs
> +	movl %edi,%gs
>  2:	mfence		/* workaround */
>  	SWAPGS
> -        popf
> +	popf
>  	CFI_ADJUST_CFA_OFFSET -8
> -        ret
> +	ret
>  	CFI_ENDPROC
>  END(native_load_gs_index)
>  
> -        .section __ex_table,"a"
> -        .align 8
> -        .quad gs_change,bad_gs
> -        .previous
> -        .section .fixup,"ax"
> +	.section __ex_table,"a"
> +	.align 8
> +	.quad gs_change,bad_gs
> +	.previous
> +	.section .fixup,"ax"
>  	/* running with kernelgs */
>  bad_gs:
>  	SWAPGS			/* switch back to user gs */
>  	xorl %eax,%eax
> -        movl %eax,%gs
> -        jmp  2b
> -        .previous
> +	movl %eax,%gs
> +	jmp  2b
> +	.previous
>  
>  /*
>   * Create a kernel thread.
> @@ -1313,7 +1313,7 @@ ENTRY(kernel_thread)
>  	 * so internally to the x86_64 port you can rely on kernel_thread()
>  	 * not to reschedule the child before returning, this avoids the need
>  	 * of hacks for example to fork off the per-CPU idle tasks.
> -         * [Hopefully no generic code relies on the reschedule -AK]
> +	 * [Hopefully no generic code relies on the reschedule -AK]
>  	 */
>  	RESTORE_ALL
>  	UNFAKE_STACK_FRAME
> @@ -1420,7 +1420,7 @@ nmi_schedule:
>  	CFI_ENDPROC
>  #else
>  	jmp paranoid_exit
> - 	CFI_ENDPROC
> +	CFI_ENDPROC
>  #endif
>  KPROBE_END(nmi)
>  
> @@ -1455,22 +1455,24 @@ KPROBE_END(ignore_sysret)
>  zeroentry xen_hypervisor_callback xen_do_hypervisor_callback
>  
>  /*
> -# A note on the "critical region" in our callback handler.
> -# We want to avoid stacking callback handlers due to events occurring
> -# during handling of the last event. To do this, we keep events disabled
> -# until we've done all processing. HOWEVER, we must enable events before
> -# popping the stack frame (can't be done atomically) and so it would
> still
> -# be possible to get enough handler activations to overflow the stack.
> -# Although unlikely, bugs of that kind are hard to track down, so we'd
> -# like to avoid the possibility.
> -# So, on entry to the handler we detect whether we interrupted an
> -# existing activation in its critical region -- if so, we pop the
> current
> -# activation and restart the handler using the previous one.
> -*/
> + * A note on the "critical region" in our callback handler.
> + * We want to avoid stacking callback handlers due to events occurring
> + * during handling of the last event. To do this, we keep events
> disabled
> + * until we've done all processing. HOWEVER, we must enable events
> before
> + * popping the stack frame (can't be done atomically) and so it would
> still
> + * be possible to get enough handler activations to overflow the stack.
> + * Although unlikely, bugs of that kind are hard to track down, so we'd
> + * like to avoid the possibility.
> + * So, on entry to the handler we detect whether we interrupted an
> + * existing activation in its critical region -- if so, we pop the
> current
> + * activation and restart the handler using the previous one.
> + */
>  ENTRY(xen_do_hypervisor_callback)   # do_hypervisor_callback(struct
>  *pt_regs)
>  	CFI_STARTPROC
> -/* Since we don't modify %rdi, evtchn_do_upall(struct *pt_regs) will
> -   see the correct pointer to the pt_regs */
> +/*
> + * Since we don't modify %rdi, evtchn_do_upall(struct *pt_regs) will
> + * see the correct pointer to the pt_regs
> + */
>  	movq %rdi, %rsp            # we don't return, adjust the stack frame
>  	CFI_ENDPROC
>  	DEFAULT_FRAME
> @@ -1488,18 +1490,18 @@ ENTRY(xen_do_hypervisor_callback)   #
> do_hypervisor_callback(struct *pt_regs)
>  END(do_hypervisor_callback)
>  
>  /*
> -# Hypervisor uses this for application faults while it executes.
> -# We get here for two reasons:
> -#  1. Fault while reloading DS, ES, FS or GS
> -#  2. Fault while executing IRET
> -# Category 1 we do not need to fix up as Xen has already reloaded all
> segment
> -# registers that could be reloaded and zeroed the others.
> -# Category 2 we fix up by killing the current process. We cannot use the
> -# normal Linux return path in this case because if we use the IRET
> hypercall
> -# to pop the stack frame we end up in an infinite loop of failsafe
> callbacks.
> -# We distinguish between categories by comparing each saved segment
> register
> -# with its current contents: any discrepancy means we in category 1.
> -*/
> + * Hypervisor uses this for application faults while it executes.
> + * We get here for two reasons:
> + *  1. Fault while reloading DS, ES, FS or GS
> + *  2. Fault while executing IRET
> + * Category 1 we do not need to fix up as Xen has already reloaded all
> segment
> + * registers that could be reloaded and zeroed the others.
> + * Category 2 we fix up by killing the current process. We cannot use
> the
> + * normal Linux return path in this case because if we use the IRET
> hypercall
> + * to pop the stack frame we end up in an infinite loop of failsafe
> callbacks.
> + * We distinguish between categories by comparing each saved segment
> register
> + * with its current contents: any discrepancy means we in category 1.
> + */
>  ENTRY(xen_failsafe_callback)
>  	INTR_FRAME 1 (6*8)
>  	/*CFI_REL_OFFSET gs,GS*/
> -- 
> 1.6.0.4.603.gbc9c0
> 
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - The way an email service should be

