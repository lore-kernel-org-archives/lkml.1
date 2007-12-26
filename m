Return-Path: <linux-kernel-owner+w=401wt.eu-S1752633AbXLZLHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbXLZLHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:07:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbXLZLGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:06 -0500
Received: from il.qumranet.com ([82.166.9.18]:50435 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbXLZLGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:03 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 03/55] KVM: Add a might_sleep() annotation to gfn_to_page()
Date: Wed, 26 Dec 2007 13:05:08 +0200
Message-Id: <1198667160-22953-4-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will help trap accesses to guest memory in atomic context.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index ff77175..005f2d5 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -993,6 +993,8 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 	struct page *page[1];
 	int npages;
 
+	might_sleep();
+
 	gfn = unalias_gfn(kvm, gfn);
 	slot = __gfn_to_memslot(kvm, gfn);
 	if (!slot) {
-- 
1.5.3.7

