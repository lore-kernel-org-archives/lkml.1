Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbYAAPg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbYAAPg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbYAAPgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:24 -0500
Received: from il.qumranet.com ([82.166.9.18]:33764 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482AbYAAPgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:23 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 04/54] KVM: MMU: Rename 'release_page'
Date: Tue,  1 Jan 2008 17:35:30 +0200
Message-Id: <1199201780-14001-5-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the awkwardly named variable.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 86896da..0cb6580 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -430,18 +430,18 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	struct kvm_rmap_desc *desc;
 	struct kvm_rmap_desc *prev_desc;
 	struct kvm_mmu_page *sp;
-	struct page *release_page;
+	struct page *page;
 	unsigned long *rmapp;
 	int i;
 
 	if (!is_rmap_pte(*spte))
 		return;
 	sp = page_header(__pa(spte));
-	release_page = pfn_to_page((*spte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT);
+	page = pfn_to_page((*spte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT);
 	if (is_writeble_pte(*spte))
-		kvm_release_page_dirty(release_page);
+		kvm_release_page_dirty(page);
 	else
-		kvm_release_page_clean(release_page);
+		kvm_release_page_clean(page);
 	rmapp = gfn_to_rmap(kvm, sp->gfns[spte - sp->spt]);
 	if (!*rmapp) {
 		printk(KERN_ERR "rmap_remove: %p %llx 0->BUG\n", spte, *spte);
-- 
1.5.3.7

