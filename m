Return-Path: <linux-kernel-owner+w=401wt.eu-S1757466AbXGHL6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbXGHL6l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 07:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbXGHLzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 07:55:19 -0400
Received: from il.qumranet.com ([82.166.9.18]:38404 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759AbXGHLyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 07:54:46 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Shaohua Li <shaohua.li@intel.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 09/20] KVM: MMU: Fix Wrong tlb flush order
Date: Sun,  8 Jul 2007 14:54:38 +0300
Message-Id: <1183895689306-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11838956891287-git-send-email-avi@qumranet.com>
References: <11838956891287-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaohua Li <shaohua.li@intel.com>

Need to flush the tlb after updating a pte, not before.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index ad50cfd..49ffbd3 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -441,8 +441,8 @@ static void rmap_write_protect(struct kvm_vcpu *vcpu, u64 gfn)
 		BUG_ON(!(*spte & PT_WRITABLE_MASK));
 		rmap_printk("rmap_write_protect: spte %p %llx\n", spte, *spte);
 		rmap_remove(vcpu, spte);
-		kvm_flush_remote_tlbs(vcpu->kvm);
 		set_shadow_pte(spte, *spte & ~PT_WRITABLE_MASK);
+		kvm_flush_remote_tlbs(vcpu->kvm);
 	}
 }
 
-- 
1.5.2.2

