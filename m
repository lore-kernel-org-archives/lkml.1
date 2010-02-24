Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453Ab0BXR7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 12:59:36 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:2438 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757025Ab0BXR7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 12:59:34 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i87h6bh43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYCXYY-02-PJR-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 01/11] KVM: SVM: Coding style cleanup
Date: Wed, 24 Feb 2010 18:59:10 +0100
Message-ID: <1267034360-5907-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267034360-5907-1-git-send-email-joerg.roedel@amd.com>
References: <1267034360-5907-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 24 Feb 2010 17:59:23.0465 (UTC) FILETIME=[18C50390:01CAB57B]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes whitespace errors, fixes comment formats
and most of checkpatch warnings. Now vim does not show
c-space-errors anymore.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |  148 ++++++++++++++++++++++++++++-----------------------
 1 files changed, 81 insertions(+), 67 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index d11ff46..217b8b0 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -119,7 +119,7 @@ struct vcpu_svm {
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
 static bool npt_enabled = true;
 #else
-static bool npt_enabled = false;
+static bool npt_enabled;
 #endif
 static int npt = 1;
 
@@ -167,8 +167,8 @@ static unsigned long iopm_base;
 struct kvm_ldttss_desc {
 	u16 limit0;
 	u16 base0;
-	unsigned base1 : 8, type : 5, dpl : 2, p : 1;
-	unsigned limit1 : 4, zero0 : 3, g : 1, base2 : 8;
+	unsigned base1:8, type:5, dpl:2, p:1;
+	unsigned limit1:4, zero0:3, g:1, base2:8;
 	u32 base3;
 	u32 zero1;
 } __attribute__((packed));
@@ -217,7 +217,7 @@ static inline void stgi(void)
 
 static inline void invlpga(unsigned long addr, u32 asid)
 {
-	asm volatile (__ex(SVM_INVLPGA) :: "a"(addr), "c"(asid));
+	asm volatile (__ex(SVM_INVLPGA) : : "a"(addr), "c"(asid));
 }
 
 static inline void force_new_asid(struct kvm_vcpu *vcpu)
@@ -289,8 +289,10 @@ static void svm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr,
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	/* If we are within a nested VM we'd better #VMEXIT and let the
-	   guest handle the exception */
+	/*
+	 * If we are within a nested VM we'd better #VMEXIT and let the guest
+	 * handle the exception
+	 */
 	if (nested_svm_check_exception(svm, nr, has_error_code, error_code))
 		return;
 
@@ -543,7 +545,7 @@ static void init_seg(struct vmcb_seg *seg)
 {
 	seg->selector = 0;
 	seg->attrib = SVM_SELECTOR_P_MASK | SVM_SELECTOR_S_MASK |
-		SVM_SELECTOR_WRITE_MASK; /* Read/Write Data Segment */
+		      SVM_SELECTOR_WRITE_MASK; /* Read/Write Data Segment */
 	seg->limit = 0xffff;
 	seg->base = 0;
 }
@@ -563,16 +565,16 @@ static void init_vmcb(struct vcpu_svm *svm)
 
 	svm->vcpu.fpu_active = 1;
 
-	control->intercept_cr_read = 	INTERCEPT_CR0_MASK |
+	control->intercept_cr_read =	INTERCEPT_CR0_MASK |
 					INTERCEPT_CR3_MASK |
 					INTERCEPT_CR4_MASK;
 
-	control->intercept_cr_write = 	INTERCEPT_CR0_MASK |
+	control->intercept_cr_write =	INTERCEPT_CR0_MASK |
 					INTERCEPT_CR3_MASK |
 					INTERCEPT_CR4_MASK |
 					INTERCEPT_CR8_MASK;
 
-	control->intercept_dr_read = 	INTERCEPT_DR0_MASK |
+	control->intercept_dr_read =	INTERCEPT_DR0_MASK |
 					INTERCEPT_DR1_MASK |
 					INTERCEPT_DR2_MASK |
 					INTERCEPT_DR3_MASK |
@@ -581,7 +583,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 					INTERCEPT_DR6_MASK |
 					INTERCEPT_DR7_MASK;
 
-	control->intercept_dr_write = 	INTERCEPT_DR0_MASK |
+	control->intercept_dr_write =	INTERCEPT_DR0_MASK |
 					INTERCEPT_DR1_MASK |
 					INTERCEPT_DR2_MASK |
 					INTERCEPT_DR3_MASK |
@@ -595,7 +597,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 					(1 << MC_VECTOR);
 
 
-	control->intercept = 	(1ULL << INTERCEPT_INTR) |
+	control->intercept =	(1ULL << INTERCEPT_INTR) |
 				(1ULL << INTERCEPT_NMI) |
 				(1ULL << INTERCEPT_SMI) |
 				(1ULL << INTERCEPT_SELECTIVE_CR0) |
@@ -656,7 +658,8 @@ static void init_vmcb(struct vcpu_svm *svm)
 	save->rip = 0x0000fff0;
 	svm->vcpu.arch.regs[VCPU_REGS_RIP] = save->rip;
 
-	/* This is the guest-visible cr0 value.
+	/*
+	 * This is the guest-visible cr0 value.
 	 * svm_set_cr0() sets PG and WP and clears NW and CD on save->cr0.
 	 */
 	svm->vcpu.arch.cr0 = X86_CR0_NW | X86_CR0_CD | X86_CR0_ET;
@@ -897,7 +900,8 @@ static void svm_get_segment(struct kvm_vcpu *vcpu,
 	var->db = (s->attrib >> SVM_SELECTOR_DB_SHIFT) & 1;
 	var->g = (s->attrib >> SVM_SELECTOR_G_SHIFT) & 1;
 
-	/* AMD's VMCB does not have an explicit unusable field, so emulate it
+	/*
+	 * AMD's VMCB does not have an explicit unusable field, so emulate it
 	 * for cross vendor migration purposes by "not present"
 	 */
 	var->unusable = !var->present || (var->type == 0);
@@ -933,7 +937,8 @@ static void svm_get_segment(struct kvm_vcpu *vcpu,
 			var->type |= 0x1;
 		break;
 	case VCPU_SREG_SS:
-		/* On AMD CPUs sometimes the DB bit in the segment
+		/*
+		 * On AMD CPUs sometimes the DB bit in the segment
 		 * descriptor is left as 1, although the whole segment has
 		 * been made unusable. Clear it here to pass an Intel VMX
 		 * entry check when cross vendor migrating.
@@ -1264,7 +1269,7 @@ static int db_interception(struct vcpu_svm *svm)
 	}
 
 	if (svm->vcpu.guest_debug &
-	    (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP)){
+	    (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP)) {
 		kvm_run->exit_reason = KVM_EXIT_DEBUG;
 		kvm_run->debug.arch.pc =
 			svm->vmcb->save.cs.base + svm->vmcb->save.rip;
@@ -1309,7 +1314,7 @@ static void svm_fpu_activate(struct kvm_vcpu *vcpu)
 		excp    = h_excp | n_excp;
 	} else {
 		excp  = svm->vmcb->control.intercept_exceptions;
-	        excp &= ~(1 << NM_VECTOR);
+		excp &= ~(1 << NM_VECTOR);
 	}
 
 	svm->vmcb->control.intercept_exceptions = excp;
@@ -1548,13 +1553,13 @@ static int nested_svm_exit_special(struct vcpu_svm *svm)
 	case SVM_EXIT_INTR:
 	case SVM_EXIT_NMI:
 		return NESTED_EXIT_HOST;
-		/* For now we are always handling NPFs when using them */
 	case SVM_EXIT_NPF:
+		/* For now we are always handling NPFs when using them */
 		if (npt_enabled)
 			return NESTED_EXIT_HOST;
 		break;
-	/* When we're shadowing, trap PFs */
 	case SVM_EXIT_EXCP_BASE + PF_VECTOR:
+		/* When we're shadowing, trap PFs */
 		if (!npt_enabled)
 			return NESTED_EXIT_HOST;
 		break;
@@ -1789,7 +1794,7 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 	if (!nested_msrpm)
 		return false;
 
-	for (i=0; i< PAGE_SIZE * (1 << MSRPM_ALLOC_ORDER) / 4; i++)
+	for (i = 0; i < PAGE_SIZE * (1 << MSRPM_ALLOC_ORDER) / 4; i++)
 		svm->nested.msrpm[i] = svm->msrpm[i] | nested_msrpm[i];
 
 	svm->vmcb->control.msrpm_base_pa = __pa(svm->nested.msrpm);
@@ -1823,8 +1828,10 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	kvm_clear_exception_queue(&svm->vcpu);
 	kvm_clear_interrupt_queue(&svm->vcpu);
 
-	/* Save the old vmcb, so we don't need to pick what we save, but
-	   can restore everything when a VMEXIT occurs */
+	/*
+	 * Save the old vmcb, so we don't need to pick what we save, but can
+	 * restore everything when a VMEXIT occurs
+	 */
 	hsave->save.es     = vmcb->save.es;
 	hsave->save.cs     = vmcb->save.cs;
 	hsave->save.ss     = vmcb->save.ss;
@@ -1872,6 +1879,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	kvm_register_write(&svm->vcpu, VCPU_REGS_RAX, nested_vmcb->save.rax);
 	kvm_register_write(&svm->vcpu, VCPU_REGS_RSP, nested_vmcb->save.rsp);
 	kvm_register_write(&svm->vcpu, VCPU_REGS_RIP, nested_vmcb->save.rip);
+
 	/* In case we don't even reach vcpu_run, the fields are not updated */
 	svm->vmcb->save.rax = nested_vmcb->save.rax;
 	svm->vmcb->save.rsp = nested_vmcb->save.rsp;
@@ -1903,8 +1911,10 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 		svm->vmcb->control.intercept_cr_write &= ~INTERCEPT_CR8_MASK;
 	}
 
-	/* We don't want a nested guest to be more powerful than the guest,
-	   so all intercepts are ORed */
+	/*
+	 * We don't want a nested guest to be more powerful than the guest, so
+	 * all intercepts are ORed
+	 */
 	svm->vmcb->control.intercept_cr_read |=
 		nested_vmcb->control.intercept_cr_read;
 	svm->vmcb->control.intercept_cr_write |=
@@ -2218,9 +2228,11 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 *data)
 	case MSR_IA32_SYSENTER_ESP:
 		*data = svm->sysenter_esp;
 		break;
-	/* Nobody will change the following 5 values in the VMCB so
-	   we can safely return them on rdmsr. They will always be 0
-	   until LBRV is implemented. */
+	/*
+	 * Nobody will change the following 5 values in the VMCB so we can
+	 * safely return them on rdmsr. They will always be 0 until LBRV is
+	 * implemented.
+	 */
 	case MSR_IA32_DEBUGCTLMSR:
 		*data = svm->vmcb->save.dbgctl;
 		break;
@@ -2399,16 +2411,16 @@ static int pause_interception(struct vcpu_svm *svm)
 }
 
 static int (*svm_exit_handlers[])(struct vcpu_svm *svm) = {
-	[SVM_EXIT_READ_CR0]           		= emulate_on_interception,
-	[SVM_EXIT_READ_CR3]           		= emulate_on_interception,
-	[SVM_EXIT_READ_CR4]           		= emulate_on_interception,
-	[SVM_EXIT_READ_CR8]           		= emulate_on_interception,
+	[SVM_EXIT_READ_CR0]			= emulate_on_interception,
+	[SVM_EXIT_READ_CR3]			= emulate_on_interception,
+	[SVM_EXIT_READ_CR4]			= emulate_on_interception,
+	[SVM_EXIT_READ_CR8]			= emulate_on_interception,
 	[SVM_EXIT_CR0_SEL_WRITE]		= emulate_on_interception,
-	[SVM_EXIT_WRITE_CR0]          		= emulate_on_interception,
-	[SVM_EXIT_WRITE_CR3]          		= emulate_on_interception,
-	[SVM_EXIT_WRITE_CR4]          		= emulate_on_interception,
-	[SVM_EXIT_WRITE_CR8]          		= cr8_write_interception,
-	[SVM_EXIT_READ_DR0] 			= emulate_on_interception,
+	[SVM_EXIT_WRITE_CR0]			= emulate_on_interception,
+	[SVM_EXIT_WRITE_CR3]			= emulate_on_interception,
+	[SVM_EXIT_WRITE_CR4]			= emulate_on_interception,
+	[SVM_EXIT_WRITE_CR8]			= cr8_write_interception,
+	[SVM_EXIT_READ_DR0]			= emulate_on_interception,
 	[SVM_EXIT_READ_DR1]			= emulate_on_interception,
 	[SVM_EXIT_READ_DR2]			= emulate_on_interception,
 	[SVM_EXIT_READ_DR3]			= emulate_on_interception,
@@ -2427,15 +2439,14 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_EXCP_BASE + DB_VECTOR]	= db_interception,
 	[SVM_EXIT_EXCP_BASE + BP_VECTOR]	= bp_interception,
 	[SVM_EXIT_EXCP_BASE + UD_VECTOR]	= ud_interception,
-	[SVM_EXIT_EXCP_BASE + PF_VECTOR] 	= pf_interception,
-	[SVM_EXIT_EXCP_BASE + NM_VECTOR] 	= nm_interception,
-	[SVM_EXIT_EXCP_BASE + MC_VECTOR] 	= mc_interception,
-	[SVM_EXIT_INTR] 			= intr_interception,
+	[SVM_EXIT_EXCP_BASE + PF_VECTOR]	= pf_interception,
+	[SVM_EXIT_EXCP_BASE + NM_VECTOR]	= nm_interception,
+	[SVM_EXIT_EXCP_BASE + MC_VECTOR]	= mc_interception,
+	[SVM_EXIT_INTR]				= intr_interception,
 	[SVM_EXIT_NMI]				= nmi_interception,
 	[SVM_EXIT_SMI]				= nop_on_interception,
 	[SVM_EXIT_INIT]				= nop_on_interception,
 	[SVM_EXIT_VINTR]			= interrupt_window_interception,
-	/* [SVM_EXIT_CR0_SEL_WRITE]		= emulate_on_interception, */
 	[SVM_EXIT_CPUID]			= cpuid_interception,
 	[SVM_EXIT_IRET]                         = iret_interception,
 	[SVM_EXIT_INVD]                         = emulate_on_interception,
@@ -2443,7 +2454,7 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_HLT]				= halt_interception,
 	[SVM_EXIT_INVLPG]			= invlpg_interception,
 	[SVM_EXIT_INVLPGA]			= invlpga_interception,
-	[SVM_EXIT_IOIO] 		  	= io_interception,
+	[SVM_EXIT_IOIO]				= io_interception,
 	[SVM_EXIT_MSR]				= msr_interception,
 	[SVM_EXIT_TASK_SWITCH]			= task_switch_interception,
 	[SVM_EXIT_SHUTDOWN]			= shutdown_interception,
@@ -2644,10 +2655,12 @@ static void enable_irq_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	/* In case GIF=0 we can't rely on the CPU to tell us when
-	 * GIF becomes 1, because that's a separate STGI/VMRUN intercept.
-	 * The next time we get that intercept, this function will be
-	 * called again though and we'll get the vintr intercept. */
+	/*
+	 * In case GIF=0 we can't rely on the CPU to tell us when GIF becomes
+	 * 1, because that's a separate STGI/VMRUN intercept.  The next time we
+	 * get that intercept, this function will be called again though and
+	 * we'll get the vintr intercept.
+	 */
 	if (gif_set(svm) && nested_svm_intr(svm)) {
 		svm_set_vintr(svm);
 		svm_inject_irq(svm, 0x0);
@@ -2662,9 +2675,10 @@ static void enable_nmi_window(struct kvm_vcpu *vcpu)
 	    == HF_NMI_MASK)
 		return; /* IRET will cause a vm exit */
 
-	/* Something prevents NMI from been injected. Single step over
-	   possible problem (IRET or exception injection or interrupt
-	   shadow) */
+	/*
+	 * Something prevents NMI from been injected. Single step over possible
+	 * problem (IRET or exception injection or interrupt shadow)
+	 */
 	svm->nmi_singlestep = true;
 	svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
 	update_db_intercept(vcpu);
@@ -2972,24 +2986,24 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
 }
 
 static const struct trace_print_flags svm_exit_reasons_str[] = {
-	{ SVM_EXIT_READ_CR0,           		"read_cr0" },
-	{ SVM_EXIT_READ_CR3,	      		"read_cr3" },
-	{ SVM_EXIT_READ_CR4,	      		"read_cr4" },
-	{ SVM_EXIT_READ_CR8,  	      		"read_cr8" },
-	{ SVM_EXIT_WRITE_CR0,          		"write_cr0" },
-	{ SVM_EXIT_WRITE_CR3,	      		"write_cr3" },
-	{ SVM_EXIT_WRITE_CR4,          		"write_cr4" },
-	{ SVM_EXIT_WRITE_CR8, 	      		"write_cr8" },
-	{ SVM_EXIT_READ_DR0, 	      		"read_dr0" },
-	{ SVM_EXIT_READ_DR1,	      		"read_dr1" },
-	{ SVM_EXIT_READ_DR2,	      		"read_dr2" },
-	{ SVM_EXIT_READ_DR3,	      		"read_dr3" },
-	{ SVM_EXIT_WRITE_DR0,	      		"write_dr0" },
-	{ SVM_EXIT_WRITE_DR1,	      		"write_dr1" },
-	{ SVM_EXIT_WRITE_DR2,	      		"write_dr2" },
-	{ SVM_EXIT_WRITE_DR3,	      		"write_dr3" },
-	{ SVM_EXIT_WRITE_DR5,	      		"write_dr5" },
-	{ SVM_EXIT_WRITE_DR7,	      		"write_dr7" },
+	{ SVM_EXIT_READ_CR0,			"read_cr0" },
+	{ SVM_EXIT_READ_CR3,			"read_cr3" },
+	{ SVM_EXIT_READ_CR4,			"read_cr4" },
+	{ SVM_EXIT_READ_CR8,			"read_cr8" },
+	{ SVM_EXIT_WRITE_CR0,			"write_cr0" },
+	{ SVM_EXIT_WRITE_CR3,			"write_cr3" },
+	{ SVM_EXIT_WRITE_CR4,			"write_cr4" },
+	{ SVM_EXIT_WRITE_CR8,			"write_cr8" },
+	{ SVM_EXIT_READ_DR0,			"read_dr0" },
+	{ SVM_EXIT_READ_DR1,			"read_dr1" },
+	{ SVM_EXIT_READ_DR2,			"read_dr2" },
+	{ SVM_EXIT_READ_DR3,			"read_dr3" },
+	{ SVM_EXIT_WRITE_DR0,			"write_dr0" },
+	{ SVM_EXIT_WRITE_DR1,			"write_dr1" },
+	{ SVM_EXIT_WRITE_DR2,			"write_dr2" },
+	{ SVM_EXIT_WRITE_DR3,			"write_dr3" },
+	{ SVM_EXIT_WRITE_DR5,			"write_dr5" },
+	{ SVM_EXIT_WRITE_DR7,			"write_dr7" },
 	{ SVM_EXIT_EXCP_BASE + DB_VECTOR,	"DB excp" },
 	{ SVM_EXIT_EXCP_BASE + BP_VECTOR,	"BP excp" },
 	{ SVM_EXIT_EXCP_BASE + UD_VECTOR,	"UD excp" },
-- 
1.7.0


