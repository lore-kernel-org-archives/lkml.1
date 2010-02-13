Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab0BMIHq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:07:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461Ab0BMICE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:04 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 27/39] KVM: SVM: Lazy fpu with npt
Date: Sat, 13 Feb 2010 10:01:47 +0200
Message-Id: <1266048119-14325-28-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we can allow the guest to play with cr0 when the fpu is loaded,
we can enable lazy fpu when npt is in use.

Acked-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 83c7ab1..8d7cb62 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2588,8 +2588,6 @@ static void svm_flush_tlb(struct kvm_vcpu *vcpu)
 
 static void svm_prepare_guest_switch(struct kvm_vcpu *vcpu)
 {
-	if (npt_enabled)
-		vcpu->fpu_active = 1;
 }
 
 static inline void sync_cr8_to_lapic(struct kvm_vcpu *vcpu)
@@ -2928,12 +2926,6 @@ static void svm_fpu_deactivate(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (npt_enabled) {
-		/* hack: npt requires active fpu at this time */
-		vcpu->fpu_active = 1;
-		return;
-	}
-
 	update_cr0_intercept(svm);
 	svm->vmcb->control.intercept_exceptions |= 1 << NM_VECTOR;
 }
-- 
1.6.5.3

