Return-Path: <linux-kernel-owner+w=401wt.eu-S1755096AbZHPJhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbZHPJhE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbZHPJaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:30:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45330 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753767AbZHPJaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:10 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/48] KVM: Replace MSR_IA32_TIME_STAMP_COUNTER with MSR_IA32_TSC of msr-index.h
Date: Sun, 16 Aug 2009 12:29:22 +0300
Message-Id: <1250415008-17175-3-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jaswinder Singh Rajput <jaswinder@kernel.org>

Use standard msr-index.h's MSR declaration.

MSR_IA32_TSC is better than MSR_IA32_TIME_STAMP_COUNTER as it also solves
80 column issue.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    2 --
 arch/x86/kvm/svm.c              |    4 ++--
 arch/x86/kvm/vmx.c              |    4 ++--
 arch/x86/kvm/x86.c              |    5 ++---
 4 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index eabdc1c..7956175 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -752,8 +752,6 @@ static inline void kvm_inject_gp(struct kvm_vcpu *vcpu, u32 error_code)
 	kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
 }
 
-#define MSR_IA32_TIME_STAMP_COUNTER		0x010
-
 #define TSS_IOPB_BASE_OFFSET 0x66
 #define TSS_BASE_SIZE 0x68
 #define TSS_IOPB_SIZE (65536 / 8)
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b1f658a..48b22c9 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1953,7 +1953,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 *data)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	switch (ecx) {
-	case MSR_IA32_TIME_STAMP_COUNTER: {
+	case MSR_IA32_TSC: {
 		u64 tsc;
 
 		rdtscll(tsc);
@@ -2043,7 +2043,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	switch (ecx) {
-	case MSR_IA32_TIME_STAMP_COUNTER: {
+	case MSR_IA32_TSC: {
 		u64 tsc;
 
 		rdtscll(tsc);
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index db0b8b6..c87c93f 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -941,7 +941,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
 	case MSR_EFER:
 		return kvm_get_msr_common(vcpu, msr_index, pdata);
 #endif
-	case MSR_IA32_TIME_STAMP_COUNTER:
+	case MSR_IA32_TSC:
 		data = guest_read_tsc();
 		break;
 	case MSR_IA32_SYSENTER_CS:
@@ -1001,7 +1001,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 	case MSR_IA32_SYSENTER_ESP:
 		vmcs_writel(GUEST_SYSENTER_ESP, data);
 		break;
-	case MSR_IA32_TIME_STAMP_COUNTER:
+	case MSR_IA32_TSC:
 		rdtscll(host_tsc);
 		guest_write_tsc(data, host_tsc);
 		break;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3d45290..6d46079 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -466,7 +466,7 @@ static u32 msrs_to_save[] = {
 #ifdef CONFIG_X86_64
 	MSR_CSTAR, MSR_KERNEL_GS_BASE, MSR_SYSCALL_MASK, MSR_LSTAR,
 #endif
-	MSR_IA32_TIME_STAMP_COUNTER, MSR_KVM_SYSTEM_TIME, MSR_KVM_WALL_CLOCK,
+	MSR_IA32_TSC, MSR_KVM_SYSTEM_TIME, MSR_KVM_WALL_CLOCK,
 	MSR_IA32_PERF_STATUS, MSR_IA32_CR_PAT, MSR_VM_HSAVE_PA
 };
 
@@ -644,8 +644,7 @@ static void kvm_write_guest_time(struct kvm_vcpu *v)
 
 	/* Keep irq disabled to prevent changes to the clock */
 	local_irq_save(flags);
-	kvm_get_msr(v, MSR_IA32_TIME_STAMP_COUNTER,
-			  &vcpu->hv_clock.tsc_timestamp);
+	kvm_get_msr(v, MSR_IA32_TSC, &vcpu->hv_clock.tsc_timestamp);
 	ktime_get_ts(&ts);
 	local_irq_restore(flags);
 
-- 
1.6.3.3

