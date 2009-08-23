Return-Path: <linux-kernel-owner+w=401wt.eu-S933802AbZHWMFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933802AbZHWMFX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 08:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933777AbZHWMDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 08:03:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933533AbZHWL4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:49 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 23/46] KVM: MMU: Fix MMU_DEBUG compile breakage
Date: Sun, 23 Aug 2009 14:56:22 +0300
Message-Id: <1251028605-31977-24-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index ac121b3..f1f0815 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1808,8 +1808,8 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	pgprintk("%s: setting spte %llx\n", __func__, *sptep);
 	pgprintk("instantiating %s PTE (%s) at %ld (%llx) addr %p\n",
 		 is_large_pte(*sptep)? "2MB" : "4kB",
-		 is_present_pte(*sptep)?"RW":"R", gfn,
-		 *shadow_pte, sptep);
+		 *sptep & PT_PRESENT_MASK ?"RW":"R", gfn,
+		 *sptep, sptep);
 	if (!was_rmapped && is_large_pte(*sptep))
 		++vcpu->kvm->stat.lpages;
 
-- 
1.6.4.1

