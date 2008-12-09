Return-Path: <linux-kernel-owner+w=401wt.eu-S1756046AbYLIU0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbYLIU0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbYLIUXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:23:22 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34851 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708AbYLIUXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:08 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 12/44] KVM: Fix kernel allocated memory slot
Date: Tue,  9 Dec 2008 22:22:27 +0200
Message-Id: <1228854179-23002-13-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

Commit 7fd49de9773fdcb7b75e823b21c1c5dc1e218c14 "KVM: ensure that memslot
userspace addresses are page-aligned" broke kernel space allocated memory
slot, for the userspace_addr is invalid.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/kvm_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0a0a959..4727c08 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -715,7 +715,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		goto out;
 	if (mem->guest_phys_addr & (PAGE_SIZE - 1))
 		goto out;
-	if (mem->userspace_addr & (PAGE_SIZE - 1))
+	if (user_alloc && (mem->userspace_addr & (PAGE_SIZE - 1)))
 		goto out;
 	if (mem->slot >= KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS)
 		goto out;
-- 
1.6.0.3

