Return-Path: <linux-kernel-owner+w=401wt.eu-S1752756AbZHSNMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbZHSNMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZHSNMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:12:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50551 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751902AbZHSNCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:46 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/47] KVM: MMU audit: nontrapping ptes in nonleaf level
Date: Wed, 19 Aug 2009 16:02:01 +0300
Message-Id: <1250686963-8357-6-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

It is valid to set non leaf sptes as notrap.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 4c2585c..8643351 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3109,12 +3109,7 @@ static void audit_mappings_page(struct kvm_vcpu *vcpu, u64 page_pte,
 
 		va = canonicalize(va);
 		if (level > 1) {
-			if (ent == shadow_notrap_nonpresent_pte)
-				printk(KERN_ERR "audit: (%s) nontrapping pte"
-				       " in nonleaf level: levels %d gva %lx"
-				       " level %d pte %llx\n", audit_msg,
-				       vcpu->arch.mmu.root_level, va, level, ent);
-			else
+			if (is_shadow_present_pte(ent))
 				audit_mappings_page(vcpu, ent, va, level - 1);
 		} else {
 			gpa_t gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, va);
-- 
1.6.3.3

