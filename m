Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126AbYIYMHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbYIYMHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755098AbYIYL4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:56:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48617 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755032AbYIYL4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:56:23 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 36/39] KVM: SVM: No need to unprotect memory during event injection when using npt
Date: Thu, 25 Sep 2008 14:55:08 +0300
Message-Id: <1222343711-12508-37-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

No memory is protected anyway.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index be86c09..6022888 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1021,7 +1021,7 @@ static int pf_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 	if (npt_enabled)
 		svm_flush_tlb(&svm->vcpu);
 
-	if (event_injection)
+	if (!npt_enabled && event_injection)
 		kvm_mmu_unprotect_page_virt(&svm->vcpu, fault_address);
 	return kvm_mmu_page_fault(&svm->vcpu, fault_address, error_code);
 }
-- 
1.6.0.1

