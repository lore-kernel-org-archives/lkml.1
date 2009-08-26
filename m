Return-Path: <linux-kernel-owner+w=401wt.eu-S1757093AbZHZKaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093AbZHZKaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:30:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756784AbZHZKaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:30:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756333AbZHZKaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:09 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/47] KVM: MMU: fix bogus alloc_mmu_pages assignment
Date: Wed, 26 Aug 2009 13:29:25 +0300
Message-Id: <1251282609-12835-4-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Remove the bogus n_free_mmu_pages assignment from alloc_mmu_pages.

It breaks accounting of mmu pages, since n_free_mmu_pages is modified
but the real number of pages remains the same.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 28be35c..6f38178 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2786,14 +2786,6 @@ static int alloc_mmu_pages(struct kvm_vcpu *vcpu)
 
 	ASSERT(vcpu);
 
-	spin_lock(&vcpu->kvm->mmu_lock);
-	if (vcpu->kvm->arch.n_requested_mmu_pages)
-		vcpu->kvm->arch.n_free_mmu_pages =
-					vcpu->kvm->arch.n_requested_mmu_pages;
-	else
-		vcpu->kvm->arch.n_free_mmu_pages =
-					vcpu->kvm->arch.n_alloc_mmu_pages;
-	spin_unlock(&vcpu->kvm->mmu_lock);
 	/*
 	 * When emulating 32-bit mode, cr3 is only 32 bits even on x86_64.
 	 * Therefore we need to allocate shadow page tables in the first
-- 
1.6.4.1

