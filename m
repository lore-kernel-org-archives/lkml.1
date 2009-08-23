Return-Path: <linux-kernel-owner+w=401wt.eu-S933694AbZHWMAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933694AbZHWMAX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 08:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933561AbZHWMAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 08:00:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933551AbZHWL4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:50 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 28/46] KVM: Discard unnecessary kvm_mmu_flush_tlb() in kvm_mmu_load()
Date: Sun, 23 Aug 2009 14:56:27 +0300
Message-Id: <1251028605-31977-29-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

set_cr3() should already cover the TLB flushing.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index f1f0815..87c67f4 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2373,8 +2373,8 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	spin_unlock(&vcpu->kvm->mmu_lock);
 	if (r)
 		goto out;
+	/* set_cr3() should ensure TLB has been flushed */
 	kvm_x86_ops->set_cr3(vcpu, vcpu->arch.mmu.root_hpa);
-	kvm_mmu_flush_tlb(vcpu);
 out:
 	return r;
 }
-- 
1.6.4.1

