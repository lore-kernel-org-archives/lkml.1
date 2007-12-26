Return-Path: <linux-kernel-owner+w=401wt.eu-S1754107AbXLZLPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbXLZLPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752213AbXLZLGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:45 -0500
Received: from il.qumranet.com ([82.166.9.18]:50489 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbXLZLGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:07 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Uri Lublin <uril@qumranet.com>
Subject: [PATCH 30/55] KVM: Make mark_page_dirty() work for aliased pages too.
Date: Wed, 26 Dec 2007 13:05:35 +0200
Message-Id: <1198667160-22953-31-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uri Lublin <uril@qumranet.com>

Recommended by Izik Eidus.

Signed-off-by: Uri Lublin <uril@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 27f3a6e..ad4c84c 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -796,11 +796,11 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
 }
 EXPORT_SYMBOL_GPL(kvm_clear_guest);
 
-/* WARNING: Does not work on aliased pages. */
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
 {
 	struct kvm_memory_slot *memslot;
 
+	gfn = unalias_gfn(kvm, gfn);
 	memslot = __gfn_to_memslot(kvm, gfn);
 	if (memslot && memslot->dirty_bitmap) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
-- 
1.5.3.7

