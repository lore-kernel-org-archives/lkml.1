Return-Path: <linux-kernel-owner+w=401wt.eu-S1758207AbYFZMc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207AbYFZMc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbYFZM2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:28:52 -0400
Received: from il.qumranet.com ([212.179.150.194]:32376 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194AbYFZM2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:41 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 31/50] KVM: MMU: Move nonpaging_prefetch_page()
Date: Thu, 26 Jun 2008 15:28:13 +0300
Message-Id: <1214483312-9265-32-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for next patch. No code change.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 53f1ed8..62741b7 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -776,6 +776,15 @@ static void mmu_page_remove_parent_pte(struct kvm_mmu_page *sp,
 	BUG();
 }
 
+static void nonpaging_prefetch_page(struct kvm_vcpu *vcpu,
+				    struct kvm_mmu_page *sp)
+{
+	int i;
+
+	for (i = 0; i < PT64_ENT_PER_PAGE; ++i)
+		sp->spt[i] = shadow_trap_nonpresent_pte;
+}
+
 static struct kvm_mmu_page *kvm_mmu_lookup_page(struct kvm *kvm, gfn_t gfn)
 {
 	unsigned index;
@@ -1213,15 +1222,6 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 }
 
 
-static void nonpaging_prefetch_page(struct kvm_vcpu *vcpu,
-				    struct kvm_mmu_page *sp)
-{
-	int i;
-
-	for (i = 0; i < PT64_ENT_PER_PAGE; ++i)
-		sp->spt[i] = shadow_trap_nonpresent_pte;
-}
-
 static void mmu_free_roots(struct kvm_vcpu *vcpu)
 {
 	int i;
-- 
1.5.6

