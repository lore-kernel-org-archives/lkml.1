Return-Path: <linux-kernel-owner+w=401wt.eu-S1759309AbXL3H0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759309AbXL3H0f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:26:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756577AbXL3HLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:37 -0500
Received: from il.qumranet.com ([82.166.9.18]:59487 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755777AbXL3HKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:51 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 48/52] KVM: MMU: Remove set_pde()
Date: Sun, 30 Dec 2007 09:10:34 +0200
Message-Id: <1198998638-22713-49-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is now identical to set_pte().

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/paging_tmpl.h |   25 ++++---------------------
 1 files changed, 4 insertions(+), 21 deletions(-)

diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index cc373ed..062f4f5 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -305,17 +305,6 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 		       0, NULL, NULL, gpte_to_gfn(gpte));
 }
 
-static void FNAME(set_pde)(struct kvm_vcpu *vcpu, pt_element_t gpde,
-			   u64 *shadow_pte, u64 access_bits,
-			   int user_fault, int write_fault, int *ptwrite,
-			   struct guest_walker *walker, gfn_t gfn)
-{
-	access_bits &= gpde;
-	FNAME(set_pte_common)(vcpu, shadow_pte,
-			      gpde, access_bits, user_fault, write_fault,
-			      ptwrite, walker, gfn);
-}
-
 /*
  * Fetch a shadow pte for a specific level in the paging hierarchy.
  */
@@ -384,16 +373,10 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		prev_shadow_ent = shadow_ent;
 	}
 
-	if (walker->level == PT_DIRECTORY_LEVEL) {
-		FNAME(set_pde)(vcpu, walker->pte, shadow_ent,
-			       walker->inherited_ar, user_fault, write_fault,
-			       ptwrite, walker, walker->gfn);
-	} else {
-		ASSERT(walker->level == PT_PAGE_TABLE_LEVEL);
-		FNAME(set_pte)(vcpu, walker->pte, shadow_ent,
-			       walker->inherited_ar, user_fault, write_fault,
-			       ptwrite, walker, walker->gfn);
-	}
+	FNAME(set_pte)(vcpu, walker->pte, shadow_ent,
+		       walker->inherited_ar, user_fault, write_fault,
+		       ptwrite, walker, walker->gfn);
+
 	return shadow_ent;
 }
 
-- 
1.5.3.7

