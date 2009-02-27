Return-Path: <linux-kernel-owner+w=401wt.eu-S1759992AbZB0Kdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759992AbZB0Kdp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:33:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757919AbZB0K1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:27:43 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53593 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756252AbZB0K1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:11 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 31/37] KVM: MMU: Only enable cr4_pge role in shadow mode
Date: Fri, 27 Feb 2009 12:26:54 +0200
Message-Id: <1235730420-7929-32-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two dimensional paging is only confused by it.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6fbc346..19ccde6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -364,7 +364,7 @@ void kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	}
 	kvm_x86_ops->set_cr4(vcpu, cr4);
 	vcpu->arch.cr4 = cr4;
-	vcpu->arch.mmu.base_role.cr4_pge = !!(cr4 & X86_CR4_PGE);
+	vcpu->arch.mmu.base_role.cr4_pge = (cr4 & X86_CR4_PGE) && !tdp_enabled;
 	kvm_mmu_sync_global(vcpu);
 	kvm_mmu_reset_context(vcpu);
 }
-- 
1.6.0.6

