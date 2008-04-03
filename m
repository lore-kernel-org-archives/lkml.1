Return-Path: <linux-kernel-owner+w=401wt.eu-S1761785AbYDCTeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761785AbYDCTeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759643AbYDCTc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:32:59 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:53021
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756705AbYDCTc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:32:56 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Alexander Graf <alex@csgraf.de>
Subject: [PATCH 06/35] KVM: Implement dummy values for MSR_PERF_STATUS
Date: Thu,  3 Apr 2008 22:32:21 +0300
Message-Id: <1207251170-5013-7-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207251170-5013-1-git-send-email-avi@qumranet.com>
References: <1207251170-5013-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <alex@csgraf.de>

Darwin relies on this and ceases to work without.

Signed-off-by: Alexander Graf <alex@csgraf.de>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cf6261e..0dd038e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -426,6 +426,7 @@ static u32 msrs_to_save[] = {
 	MSR_CSTAR, MSR_KERNEL_GS_BASE, MSR_SYSCALL_MASK, MSR_LSTAR,
 #endif
 	MSR_IA32_TIME_STAMP_COUNTER, MSR_KVM_SYSTEM_TIME, MSR_KVM_WALL_CLOCK,
+	MSR_IA32_PERF_STATUS,
 };
 
 static unsigned num_msrs_to_save;
@@ -653,7 +654,6 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case MSR_IA32_MC0_MISC+12:
 	case MSR_IA32_MC0_MISC+16:
 	case MSR_IA32_UCODE_REV:
-	case MSR_IA32_PERF_STATUS:
 	case MSR_IA32_EBL_CR_POWERON:
 		/* MTRR registers */
 	case 0xfe:
@@ -669,6 +669,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case MSR_IA32_MISC_ENABLE:
 		data = vcpu->arch.ia32_misc_enable_msr;
 		break;
+	case MSR_IA32_PERF_STATUS:
+		/* TSC increment by tick */
+		data = 1000ULL;
+		/* CPU multiplier */
+		data |= (((uint64_t)4ULL) << 40);
+		break;
 	case MSR_EFER:
 		data = vcpu->arch.shadow_efer;
 		break;
-- 
1.5.4.5

