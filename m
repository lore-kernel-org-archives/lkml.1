Return-Path: <linux-kernel-owner+w=401wt.eu-S1757027AbZF3Wxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027AbZF3Wxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 18:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbZF3Wxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 18:53:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:44697 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753447AbZF3Wxk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 18:53:40 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX1+e3As642ye6JQyncKxD+Di2wR3YqqeOpDKxtC9EF
	2oRg5Vr14wdTM6
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: gregkh@suse.de
Subject: Re: patch kvm-add-vt-x-machine-check-support.patch added to 2.6.30-stable tree
Date: Wed, 1 Jul 2009 00:53:37 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30-0.slh.5-sidux-amd64; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com, avi@redhat.com,
       ying.huang@intel.com, stable@kernel.org
References: <20090629184144.76C9948FD3@coco.kroah.org>
In-Reply-To: <20090629184144.76C9948FD3@coco.kroah.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907010053.40900.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wednesday 01 July 2009, gregkh@suse.de wrote:
> This is a note to let you know that we have just queued up the patch titled
> 
>     Subject: KVM: Add VT-x machine check support
> 
> to the 2.6.30-stable tree.  Its filename is
> 
>     kvm-add-vt-x-machine-check-support.patch
> 
> A git repo of this tree can be found at 
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> 
> From a0861c02a981c943573478ea13b29b1fb958ee5b Mon Sep 17 00:00:00 2001
> From: Andi Kleen <ak@linux.intel.com>
> Date: Mon, 8 Jun 2009 17:37:09 +0800
> Subject: KVM: Add VT-x machine check support

This patch fails to compile if applied to 2.6.30 + current stable queue.

arch/x86/kvm/vmx.c: In function 'vmx_vcpu_run':
arch/x86/kvm/vmx.c:3573: error: 'exit_intr_info' undeclared (first use in this function)
arch/x86/kvm/vmx.c:3573: error: (Each undeclared identifier is reported only once
arch/x86/kvm/vmx.c:3573: error: for each function it appears in.)
make[4]: *** [arch/x86/kvm/vmx.o] Error 1
make[3]: *** [arch/x86/kvm] Error 2
make[3]: *** Waiting for unfinished jobs....

It seems to depend on the code refactoring introduced by 

>From 7b4a25cb296e2a73d2e87a4af65361d45d450a27 Mon Sep 17 00:00:00 2001
From: Gleb Natapov <gleb@redhat.com>
Date: Mon, 30 Mar 2009 16:03:08 +0300
Subject: KVM: VMX: Fix handling of a fault during NMI unblocked due to IRET

Bit 12 is undefined in any of the following cases:
 If the VM exit sets the valid bit in the IDT-vectoring information field.
 If the VM exit is due to a double fault.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>

and followed up by the code movement in

>From 20f65983e30f222e5383f77206e3f571d1d64610 Mon Sep 17 00:00:00 2001
From: Gleb Natapov <gleb@redhat.com>
Date: Mon, 11 May 2009 13:35:55 +0300
Subject: KVM: Move "exit due to NMI" handling into vmx_complete_interrupts()

To save us one reading of VM_EXIT_INTR_INFO.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>

Regards
	Stefan Lippers-Hollmann

> From: Andi Kleen <ak@linux.intel.com>
> 
> commit a0861c02a981c943573478ea13b29b1fb958ee5b upstream.
> 
> VT-x needs an explicit MC vector intercept to handle machine checks in the
> hyper visor.
> 
> It also has a special option to catch machine checks that happen
> during VT entry.
> 
> Do these interceptions and forward them to the Linux machine check
> handler. Make it always look like user space is interrupted because
> the machine check handler treats kernel/user space differently.
> 
> Thanks to Jiang Yunhong for help and testing.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> Signed-off-by: Avi Kivity <avi@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  arch/x86/include/asm/vmx.h          |    1 
>  arch/x86/kernel/cpu/mcheck/mce_64.c |    1 
>  arch/x86/kvm/vmx.c                  |   50 ++++++++++++++++++++++++++++++++++--
>  3 files changed, 50 insertions(+), 2 deletions(-)

-- 

> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -247,6 +247,7 @@ enum vmcs_field {
>  #define EXIT_REASON_MSR_READ            31
>  #define EXIT_REASON_MSR_WRITE           32
>  #define EXIT_REASON_MWAIT_INSTRUCTION   36
> +#define EXIT_REASON_MCE_DURING_VMENTRY	 41
>  #define EXIT_REASON_TPR_BELOW_THRESHOLD 43
>  #define EXIT_REASON_APIC_ACCESS         44
>  #define EXIT_REASON_EPT_VIOLATION       48
> --- a/arch/x86/kernel/cpu/mcheck/mce_64.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
> @@ -420,6 +420,7 @@ void do_machine_check(struct pt_regs * r
>   out2:
>  	atomic_dec(&mce_entry);
>  }
> +EXPORT_SYMBOL_GPL(do_machine_check);
>  
>  #ifdef CONFIG_X86_MCE_INTEL
>  /***
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -32,6 +32,7 @@
>  #include <asm/desc.h>
>  #include <asm/vmx.h>
>  #include <asm/virtext.h>
> +#include <asm/mce.h>
>  
>  #define __ex(x) __kvm_handle_fault_on_reboot(x)
>  
> @@ -97,6 +98,7 @@ struct vcpu_vmx {
>  	int soft_vnmi_blocked;
>  	ktime_t entry_time;
>  	s64 vnmi_blocked_time;
> +	u32 exit_reason;
>  };
>  
>  static inline struct vcpu_vmx *to_vmx(struct kvm_vcpu *vcpu)
> @@ -213,6 +215,13 @@ static inline int is_external_interrupt(
>  		== (INTR_TYPE_EXT_INTR | INTR_INFO_VALID_MASK);
>  }
>  
> +static inline int is_machine_check(u32 intr_info)
> +{
> +	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VECTOR_MASK |
> +			     INTR_INFO_VALID_MASK)) ==
> +		(INTR_TYPE_HARD_EXCEPTION | MC_VECTOR | INTR_INFO_VALID_MASK);
> +}
> +
>  static inline int cpu_has_vmx_msr_bitmap(void)
>  {
>  	return (vmcs_config.cpu_based_exec_ctrl & CPU_BASED_USE_MSR_BITMAPS);
> @@ -478,7 +487,7 @@ static void update_exception_bitmap(stru
>  {
>  	u32 eb;
>  
> -	eb = (1u << PF_VECTOR) | (1u << UD_VECTOR);
> +	eb = (1u << PF_VECTOR) | (1u << UD_VECTOR) | (1u << MC_VECTOR);
>  	if (!vcpu->fpu_active)
>  		eb |= 1u << NM_VECTOR;
>  	if (vcpu->guest_debug & KVM_GUESTDBG_ENABLE) {
> @@ -2585,6 +2594,31 @@ static int handle_rmode_exception(struct
>  	return 0;
>  }
>  
> +/*
> + * Trigger machine check on the host. We assume all the MSRs are already set up
> + * by the CPU and that we still run on the same CPU as the MCE occurred on.
> + * We pass a fake environment to the machine check handler because we want
> + * the guest to be always treated like user space, no matter what context
> + * it used internally.
> + */
> +static void kvm_machine_check(void)
> +{
> +#if defined(CONFIG_X86_MCE) && defined(CONFIG_X86_64)
> +	struct pt_regs regs = {
> +		.cs = 3, /* Fake ring 3 no matter what the guest ran on */
> +		.flags = X86_EFLAGS_IF,
> +	};
> +
> +	do_machine_check(&regs, 0);
> +#endif
> +}
> +
> +static int handle_machine_check(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
> +{
> +	/* already handled by vcpu_run */
> +	return 1;
> +}
> +
>  static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -2596,6 +2630,9 @@ static int handle_exception(struct kvm_v
>  	vect_info = vmx->idt_vectoring_info;
>  	intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
>  
> +	if (is_machine_check(intr_info))
> +		return handle_machine_check(vcpu, kvm_run);
> +
>  	if ((vect_info & VECTORING_INFO_VALID_MASK) &&
>  						!is_page_fault(intr_info))
>  		printk(KERN_ERR "%s: unexpected, vectoring info 0x%x "
> @@ -3150,6 +3187,7 @@ static int (*kvm_vmx_exit_handlers[])(st
>  	[EXIT_REASON_WBINVD]                  = handle_wbinvd,
>  	[EXIT_REASON_TASK_SWITCH]             = handle_task_switch,
>  	[EXIT_REASON_EPT_VIOLATION]	      = handle_ept_violation,
> +	[EXIT_REASON_MCE_DURING_VMENTRY]      = handle_machine_check,
>  };
>  
>  static const int kvm_vmx_max_exit_handlers =
> @@ -3161,8 +3199,8 @@ static const int kvm_vmx_max_exit_handle
>   */
>  static int kvm_handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
>  {
> -	u32 exit_reason = vmcs_read32(VM_EXIT_REASON);
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	u32 exit_reason = vmx->exit_reason;
>  	u32 vectoring_info = vmx->idt_vectoring_info;
>  
>  	KVMTRACE_3D(VMEXIT, vcpu, exit_reason, (u32)kvm_rip_read(vcpu),
> @@ -3512,6 +3550,14 @@ static void vmx_vcpu_run(struct kvm_vcpu
>  
>  	intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
>  
> +	vmx->exit_reason = vmcs_read32(VM_EXIT_REASON);
> +
> +	/* Handle machine checks before interrupts are enabled */
> +	if ((vmx->exit_reason == EXIT_REASON_MCE_DURING_VMENTRY)
> +	    || (vmx->exit_reason == EXIT_REASON_EXCEPTION_NMI
> +		&& is_machine_check(exit_intr_info)))
> +		kvm_machine_check();
> +
>  	/* We need to handle NMIs before interrupts are enabled */
>  	if ((intr_info & INTR_INFO_INTR_TYPE_MASK) == INTR_TYPE_NMI_INTR &&
>  	    (intr_info & INTR_INFO_VALID_MASK)) {
> 
> 
> Patches currently in stable-queue which might be from ak@linux.intel.com are
> 
> queue-2.6.30/kvm-add-vt-x-machine-check-support.patch
