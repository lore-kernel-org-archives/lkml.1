Return-Path: <linux-kernel-owner+w=401wt.eu-S1761191AbXFQKAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761191AbXFQKAn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 06:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759735AbXFQJpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:42 -0400
Received: from il.qumranet.com ([82.166.9.18]:55152 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759425AbXFQJot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:49 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Nguyen Anh Quynh <aquynh@gmail.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 47/58] KVM: Remove unnecessary initialization and checks in mark_page_dirty()
Date: Sun, 17 Jun 2007 12:44:28 +0300
Message-Id: <11820734813473-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nguyen Anh Quynh <aquynh@gmail.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index bf35457..3c3231d 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -970,7 +970,7 @@ EXPORT_SYMBOL_GPL(gfn_to_page);
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
 {
 	int i;
-	struct kvm_memory_slot *memslot = NULL;
+	struct kvm_memory_slot *memslot;
 	unsigned long rel_gfn;
 
 	for (i = 0; i < kvm->nmemslots; ++i) {
@@ -979,7 +979,7 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
 		if (gfn >= memslot->base_gfn
 		    && gfn < memslot->base_gfn + memslot->npages) {
 
-			if (!memslot || !memslot->dirty_bitmap)
+			if (!memslot->dirty_bitmap)
 				return;
 
 			rel_gfn = gfn - memslot->base_gfn;
-- 
1.5.0.6

