Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab0BJR0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:26:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755751Ab0BJRXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:14 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 38/40] KVM: Fill out ftrace exit reason strings
Date: Wed, 10 Feb 2010 19:23:07 +0200
Message-Id: <1265822589-11155-39-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some exit reasons missed their strings; fill out the table.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/vmx.c |   58 +++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index f04e2ff..f4486f4 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3993,29 +3993,49 @@ static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	return ret;
 }
 
+#define _ER(x) { EXIT_REASON_##x, #x }
+
 static const struct trace_print_flags vmx_exit_reasons_str[] = {
-	{ EXIT_REASON_EXCEPTION_NMI,           "exception" },
-	{ EXIT_REASON_EXTERNAL_INTERRUPT,      "ext_irq" },
-	{ EXIT_REASON_TRIPLE_FAULT,            "triple_fault" },
-	{ EXIT_REASON_NMI_WINDOW,              "nmi_window" },
-	{ EXIT_REASON_IO_INSTRUCTION,          "io_instruction" },
-	{ EXIT_REASON_CR_ACCESS,               "cr_access" },
-	{ EXIT_REASON_DR_ACCESS,               "dr_access" },
-	{ EXIT_REASON_CPUID,                   "cpuid" },
-	{ EXIT_REASON_MSR_READ,                "rdmsr" },
-	{ EXIT_REASON_MSR_WRITE,               "wrmsr" },
-	{ EXIT_REASON_PENDING_INTERRUPT,       "interrupt_window" },
-	{ EXIT_REASON_HLT,                     "halt" },
-	{ EXIT_REASON_INVLPG,                  "invlpg" },
-	{ EXIT_REASON_VMCALL,                  "hypercall" },
-	{ EXIT_REASON_TPR_BELOW_THRESHOLD,     "tpr_below_thres" },
-	{ EXIT_REASON_APIC_ACCESS,             "apic_access" },
-	{ EXIT_REASON_WBINVD,                  "wbinvd" },
-	{ EXIT_REASON_TASK_SWITCH,             "task_switch" },
-	{ EXIT_REASON_EPT_VIOLATION,           "ept_violation" },
+	_ER(EXCEPTION_NMI),
+	_ER(EXTERNAL_INTERRUPT),
+	_ER(TRIPLE_FAULT),
+	_ER(PENDING_INTERRUPT),
+	_ER(NMI_WINDOW),
+	_ER(TASK_SWITCH),
+	_ER(CPUID),
+	_ER(HLT),
+	_ER(INVLPG),
+	_ER(RDPMC),
+	_ER(RDTSC),
+	_ER(VMCALL),
+	_ER(VMCLEAR),
+	_ER(VMLAUNCH),
+	_ER(VMPTRLD),
+	_ER(VMPTRST),
+	_ER(VMREAD),
+	_ER(VMRESUME),
+	_ER(VMWRITE),
+	_ER(VMOFF),
+	_ER(VMON),
+	_ER(CR_ACCESS),
+	_ER(DR_ACCESS),
+	_ER(IO_INSTRUCTION),
+	_ER(MSR_READ),
+	_ER(MSR_WRITE),
+	_ER(MWAIT_INSTRUCTION),
+	_ER(MONITOR_INSTRUCTION),
+	_ER(PAUSE_INSTRUCTION),
+	_ER(MCE_DURING_VMENTRY),
+	_ER(TPR_BELOW_THRESHOLD),
+	_ER(APIC_ACCESS),
+	_ER(EPT_VIOLATION),
+	_ER(EPT_MISCONFIG),
+	_ER(WBINVD),
 	{ -1, NULL }
 };
 
+#undef _ER
+
 static bool vmx_gb_page_enable(void)
 {
 	return false;
-- 
1.6.5.3

