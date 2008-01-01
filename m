Return-Path: <linux-kernel-owner+w=401wt.eu-S1758739AbYAAPtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739AbYAAPtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:49:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbYAAPg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:57 -0500
Received: from il.qumranet.com ([82.166.9.18]:33804 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755239AbYAAPgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:31 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 48/54] KVM: MMU: Remove walker argument to set_pte()
Date: Tue,  1 Jan 2008 17:36:14 +0200
Message-Id: <1199201780-14001-49-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unused.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/paging_tmpl.h |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index ca8d515..2e5a80a 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -238,8 +238,7 @@ err:
 static void FNAME(set_pte)(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 			   unsigned pt_access, unsigned pte_access,
 			   int user_fault, int write_fault, int dirty,
-			   int *ptwrite, struct guest_walker *walker,
-			   gfn_t gfn)
+			   int *ptwrite, gfn_t gfn)
 {
 	u64 spte;
 	int was_rmapped = is_rmap_pte(*shadow_pte);
@@ -337,7 +336,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 	pgprintk("%s: gpte %llx spte %p\n", __FUNCTION__, (u64)gpte, spte);
 	pte_access = page->role.access & FNAME(gpte_access)(vcpu, gpte);
 	FNAME(set_pte)(vcpu, spte, page->role.access, pte_access, 0, 0,
-		       gpte & PT_DIRTY_MASK, NULL, NULL, gpte_to_gfn(gpte));
+		       gpte & PT_DIRTY_MASK, NULL, gpte_to_gfn(gpte));
 }
 
 /*
@@ -402,7 +401,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 
 	FNAME(set_pte)(vcpu, shadow_ent, access, walker->pte_access & access,
 		       user_fault, write_fault, walker->pte & PT_DIRTY_MASK,
-		       ptwrite, walker, walker->gfn);
+		       ptwrite, walker->gfn);
 
 	return shadow_ent;
 }
-- 
1.5.3.7

