Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbYFZMav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbYFZMav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbYFZM2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:28:39 -0400
Received: from il.qumranet.com ([212.179.150.194]:32345 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbYFZM2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:35 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 08/50] KVM: SVM: add tracing support for TDP page faults
Date: Thu, 26 Jun 2008 15:27:50 +0300
Message-Id: <1214483312-9265-9-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

To distinguish between real page faults and nested page faults they should be
traced as different events. This is implemented by this patch.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c    |    4 ++++
 include/asm-x86/kvm.h |    1 +
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 8953292..218949c 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1011,6 +1011,10 @@ static int pf_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 		KVMTRACE_3D(PAGE_FAULT, &svm->vcpu, error_code,
 			    (u32)fault_address, (u32)(fault_address >> 32),
 			    handler);
+	else
+		KVMTRACE_3D(TDP_FAULT, &svm->vcpu, error_code,
+			    (u32)fault_address, (u32)(fault_address >> 32),
+			    handler);
 
 	return kvm_mmu_page_fault(&svm->vcpu, fault_address, error_code);
 }
diff --git a/include/asm-x86/kvm.h b/include/asm-x86/kvm.h
index 80eefef..6f18408 100644
--- a/include/asm-x86/kvm.h
+++ b/include/asm-x86/kvm.h
@@ -228,5 +228,6 @@ struct kvm_pit_state {
 #define KVM_TRC_CLTS             (KVM_TRC_HANDLER + 0x12)
 #define KVM_TRC_LMSW             (KVM_TRC_HANDLER + 0x13)
 #define KVM_TRC_APIC_ACCESS      (KVM_TRC_HANDLER + 0x14)
+#define KVM_TRC_TDP_FAULT        (KVM_TRC_HANDLER + 0x15)
 
 #endif
-- 
1.5.6

