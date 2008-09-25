Return-Path: <linux-kernel-owner+w=401wt.eu-S1756953AbYIYMEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953AbYIYMEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591AbYIYL4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:56:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48603 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754723AbYIYL4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:56:14 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 30/39] KVM: Don't call get_user_pages(.force = 1)
Date: Thu, 25 Sep 2008 14:55:02 +0300
Message-Id: <1222343711-12508-31-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

This is esoteric and only needed to break COW on MAP_SHARED mappings.  Since
KVM no longer does these sorts of mappings, breaking COW on them is no longer
necessary.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 virt/kvm/kvm_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0309571..de3b029 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -734,7 +734,7 @@ pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
 		return page_to_pfn(bad_page);
 	}
 
-	npages = get_user_pages(current, current->mm, addr, 1, 1, 1, page,
+	npages = get_user_pages(current, current->mm, addr, 1, 1, 0, page,
 				NULL);
 
 	if (unlikely(npages != 1)) {
-- 
1.6.0.1

