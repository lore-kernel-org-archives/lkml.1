Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbYAAPzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbYAAPzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:55:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755579AbYAAPhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:37:18 -0500
Received: from il.qumranet.com ([82.166.9.18]:33801 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754297AbYAAPg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:27 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Carlo Marcelo Arenas Belon <carenas@sajinet.com.pe>
Subject: [PATCH 22/54] KVM: SVM: Remove KVM specific defines for MSR_EFER
Date: Tue,  1 Jan 2008 17:35:48 +0200
Message-Id: <1199201780-14001-23-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carlo Marcelo Arenas Belon <carenas@sajinet.com.pe>

This patch removes the KVM specific defines for MSR_EFER that were being used
in the svm support file and migrates all references to use instead the ones
from the kernel headers that are used everywhere else and that have the same
values.

Signed-off-by: Carlo Marcelo Arenas Belon <carenas@sajinet.com.pe>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/svm.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 928fb35..04e6b39 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -42,9 +42,6 @@ MODULE_LICENSE("GPL");
 #define SEG_TYPE_LDT 2
 #define SEG_TYPE_BUSY_TSS16 3
 
-#define KVM_EFER_LMA (1 << 10)
-#define KVM_EFER_LME (1 << 8)
-
 #define SVM_FEATURE_NPT  (1 << 0)
 #define SVM_FEATURE_LBRV (1 << 1)
 #define SVM_DEATURE_SVML (1 << 2)
@@ -184,8 +181,8 @@ static inline void flush_guest_tlb(struct kvm_vcpu *vcpu)
 
 static void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
-	if (!(efer & KVM_EFER_LMA))
-		efer &= ~KVM_EFER_LME;
+	if (!(efer & EFER_LMA))
+		efer &= ~EFER_LME;
 
 	to_svm(vcpu)->vmcb->save.efer = efer | MSR_EFER_SVME_MASK;
 	vcpu->shadow_efer = efer;
@@ -777,15 +774,15 @@ static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 #ifdef CONFIG_X86_64
-	if (vcpu->shadow_efer & KVM_EFER_LME) {
+	if (vcpu->shadow_efer & EFER_LME) {
 		if (!is_paging(vcpu) && (cr0 & X86_CR0_PG)) {
-			vcpu->shadow_efer |= KVM_EFER_LMA;
-			svm->vmcb->save.efer |= KVM_EFER_LMA | KVM_EFER_LME;
+			vcpu->shadow_efer |= EFER_LMA;
+			svm->vmcb->save.efer |= EFER_LMA | EFER_LME;
 		}
 
 		if (is_paging(vcpu) && !(cr0 & X86_CR0_PG)) {
-			vcpu->shadow_efer &= ~KVM_EFER_LMA;
-			svm->vmcb->save.efer &= ~(KVM_EFER_LMA | KVM_EFER_LME);
+			vcpu->shadow_efer &= ~EFER_LMA;
+			svm->vmcb->save.efer &= ~(EFER_LMA | EFER_LME);
 		}
 	}
 #endif
-- 
1.5.3.7

