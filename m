Return-Path: <linux-kernel-owner+w=401wt.eu-S1760884AbXFQJvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760884AbXFQJvw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759059AbXFQJo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:44:58 -0400
Received: from il.qumranet.com ([82.166.9.18]:55192 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758577AbXFQJop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:45 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 18/58] KVM: MMU: Simplify kvm_mmu_free_page() a tiny bit
Date: Sun, 17 Jun 2007 12:43:59 +0300
Message-Id: <1182073480191-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 9ec3df9..a96c9ae 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -455,12 +455,10 @@ static int is_empty_shadow_page(hpa_t page_hpa)
 }
 #endif
 
-static void kvm_mmu_free_page(struct kvm_vcpu *vcpu, hpa_t page_hpa)
+static void kvm_mmu_free_page(struct kvm_vcpu *vcpu,
+			      struct kvm_mmu_page *page_head)
 {
-	struct kvm_mmu_page *page_head = page_header(page_hpa);
-
-	ASSERT(is_empty_shadow_page(page_hpa));
-	page_head->page_hpa = page_hpa;
+	ASSERT(is_empty_shadow_page(page_head->page_hpa));
 	list_move(&page_head->link, &vcpu->free_pages);
 	++vcpu->kvm->n_free_mmu_pages;
 }
@@ -690,7 +688,7 @@ static void kvm_mmu_zap_page(struct kvm_vcpu *vcpu,
 	kvm_mmu_page_unlink_children(vcpu, page);
 	if (!page->root_count) {
 		hlist_del(&page->hash_link);
-		kvm_mmu_free_page(vcpu, page->page_hpa);
+		kvm_mmu_free_page(vcpu, page);
 	} else
 		list_move(&page->link, &vcpu->kvm->active_mmu_pages);
 }
-- 
1.5.0.6

