Return-Path: <linux-kernel-owner+w=401wt.eu-S1757322AbZHZKig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbZHZKig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757056AbZHZKaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:30:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756660AbZHZKaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:09 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/47] KVM: MMU: make __kvm_mmu_free_some_pages handle empty list
Date: Wed, 26 Aug 2009 13:29:24 +0300
Message-Id: <1251282609-12835-3-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <ieidus@redhat.com>

First check if the list is empty before attempting to look at list
entries.

Signed-off-by: Izik Eidus <ieidus@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 1249c12..28be35c 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2705,7 +2705,8 @@ EXPORT_SYMBOL_GPL(kvm_mmu_unprotect_page_virt);
 
 void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 {
-	while (vcpu->kvm->arch.n_free_mmu_pages < KVM_REFILL_PAGES) {
+	while (vcpu->kvm->arch.n_free_mmu_pages < KVM_REFILL_PAGES &&
+	       !list_empty(&vcpu->kvm->arch.active_mmu_pages)) {
 		struct kvm_mmu_page *sp;
 
 		sp = container_of(vcpu->kvm->arch.active_mmu_pages.prev,
-- 
1.6.4.1

