Return-Path: <linux-kernel-owner+w=401wt.eu-S934892AbXGUGGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934892AbXGUGGx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 02:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932501AbXGUGGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 02:06:40 -0400
Received: from il.qumranet.com ([82.166.9.18]:32881 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761166AbXGUGGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 02:06:38 -0400
From: Avi Kivity <avi@qumranet.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: caglar@pardus.org.tr, linux-kernel@vger.kernel.org,
       kvm-devel@lists.sourceforge.net, Avi Kivity <avi@qumranet.com>
Subject: [PATCH] KVM: MMU: Fix cleaning up the shadow page allocation cache
Date: Sat, 21 Jul 2007 09:06:46 +0300
Message-Id: <11849980062842-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

__free_page() wants a struct page, not a virtual address.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index d99d2fe..1a87ba9 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -244,7 +244,7 @@ static int mmu_topup_memory_cache_page(struct kvm_mmu_memory_cache *cache,
 static void mmu_free_memory_cache_page(struct kvm_mmu_memory_cache *mc)
 {
 	while (mc->nobjs)
-		__free_page(mc->objects[--mc->nobjs]);
+		free_page((unsigned long)mc->objects[--mc->nobjs]);
 }
 
 static int __mmu_topup_memory_caches(struct kvm_vcpu *vcpu, gfp_t gfp_flags)
-- 
1.5.2.4

