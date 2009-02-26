Return-Path: <linux-kernel-owner+w=401wt.eu-S1760980AbZBZOY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760980AbZBZOY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:24:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757279AbZBZOQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:16:15 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43062 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396AbZBZOPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:41 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 29/40] KVM: MMU: Drop walk_shadow()
Date: Thu, 26 Feb 2009 16:15:19 +0200
Message-Id: <1235657730-27683-30-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No longer used.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c |   20 --------------------
 1 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a25e1ad..1585080 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -145,11 +145,6 @@ struct kvm_rmap_desc {
 	struct kvm_rmap_desc *more;
 };
 
-struct kvm_shadow_walk {
-	int (*entry)(struct kvm_shadow_walk *walk, struct kvm_vcpu *vcpu,
-		     u64 addr, u64 *spte, int level);
-};
-
 struct kvm_shadow_walk_iterator {
 	u64 addr;
 	hpa_t shadow_addr;
@@ -1299,21 +1294,6 @@ static void shadow_walk_next(struct kvm_shadow_walk_iterator *iterator)
 	--iterator->level;
 }
 
-static int walk_shadow(struct kvm_shadow_walk *walker,
-		       struct kvm_vcpu *vcpu, u64 addr)
-{
-	struct kvm_shadow_walk_iterator iterator;
-	int r;
-
-	for_each_shadow_entry(vcpu, addr, iterator) {
-		r = walker->entry(walker, vcpu, addr,
-				  iterator.sptep, iterator.level);
-		if (r)
-			return r;
-	}
-	return 0;
-}
-
 static void kvm_mmu_page_unlink_children(struct kvm *kvm,
 					 struct kvm_mmu_page *sp)
 {
-- 
1.6.0.6

