Return-Path: <linux-kernel-owner+w=401wt.eu-S1757206AbYIYMG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206AbYIYMG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbYIYL40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:56:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48612 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855AbYIYL4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:56:19 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 34/39] KVM: MMU: Flush tlbs after clearing write permission when accessing dirty log
Date: Thu, 25 Sep 2008 14:55:06 +0300
Message-Id: <1222343711-12508-35-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

Otherwise, the cpu may allow writes to the tracked pages, and we lose
some display bits or fail to migrate correctly.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5052acd..853a288 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2111,6 +2111,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 			if (pt[i] & PT_WRITABLE_MASK)
 				pt[i] &= ~PT_WRITABLE_MASK;
 	}
+	kvm_flush_remote_tlbs(kvm);
 	spin_unlock(&kvm->mmu_lock);
 }
 
-- 
1.6.0.1

