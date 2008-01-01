Return-Path: <linux-kernel-owner+w=401wt.eu-S1755356AbYAAPgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbYAAPgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbYAAPgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:23 -0500
Received: from il.qumranet.com ([82.166.9.18]:33760 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbYAAPgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:23 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 01/54] KVM: MMU: Remove gva_to_hpa()
Date: Tue,  1 Jan 2008 17:35:27 +0200
Message-Id: <1199201780-14001-2-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No longer used.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h |    1 -
 drivers/kvm/mmu.c |    9 ---------
 2 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index eda82cd..31315bc 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -379,7 +379,6 @@ hpa_t gpa_to_hpa(struct kvm *kvm, gpa_t gpa);
 #define HPA_MSB ((sizeof(hpa_t) * 8) - 1)
 #define HPA_ERR_MASK ((hpa_t)1 << HPA_MSB)
 static inline int is_error_hpa(hpa_t hpa) { return hpa >> HPA_MSB; }
-hpa_t gva_to_hpa(struct kvm_vcpu *vcpu, gva_t gva);
 struct page *gva_to_page(struct kvm_vcpu *vcpu, gva_t gva);
 
 extern struct page *bad_page;
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 1965185..6aa0319 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -881,15 +881,6 @@ hpa_t gpa_to_hpa(struct kvm *kvm, gpa_t gpa)
 	return hpa;
 }
 
-hpa_t gva_to_hpa(struct kvm_vcpu *vcpu, gva_t gva)
-{
-	gpa_t gpa = vcpu->mmu.gva_to_gpa(vcpu, gva);
-
-	if (gpa == UNMAPPED_GVA)
-		return UNMAPPED_GVA;
-	return gpa_to_hpa(vcpu->kvm, gpa);
-}
-
 struct page *gva_to_page(struct kvm_vcpu *vcpu, gva_t gva)
 {
 	gpa_t gpa = vcpu->mmu.gva_to_gpa(vcpu, gva);
-- 
1.5.3.7

