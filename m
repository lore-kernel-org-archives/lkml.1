Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbYAAPkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbYAAPkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:40:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755276AbYAAPgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:33 -0500
Received: from il.qumranet.com ([82.166.9.18]:33794 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754161AbYAAPgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:24 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Izik Eidus <izike@qumranet.com>
Subject: [PATCH 12/54] KVM: MMU: mark pages that were inserted to the shadow pages table as accessed
Date: Tue,  1 Jan 2008 17:35:38 +0200
Message-Id: <1199201780-14001-13-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <izike@qumranet.com>

Mark guest pages as accessed when removed from the shadow page tables for
better lru processing.

Signed-off-by: Izik Eidus <izike@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 0cb6580..9b9d1b6 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -26,6 +26,7 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <linux/module.h>
+#include <linux/swap.h>
 
 #include <asm/page.h>
 #include <asm/cmpxchg.h>
@@ -438,6 +439,7 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 		return;
 	sp = page_header(__pa(spte));
 	page = pfn_to_page((*spte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT);
+	mark_page_accessed(page);
 	if (is_writeble_pte(*spte))
 		kvm_release_page_dirty(page);
 	else
-- 
1.5.3.7

