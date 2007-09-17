Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbXIQIiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbXIQIiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686AbXIQIcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:39 -0400
Received: from il.qumranet.com ([82.166.9.18]:45249 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581AbXIQIc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:28 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 041/104] KVM: Don't assign vcpu->cr3 if it's invalid: check first, set last
Date: Mon, 17 Sep 2007 10:31:23 +0200
Message-Id: <11900179471923-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

sSigned-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 2be6b1c..5dc6017 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -579,7 +579,6 @@ void set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 		}
 	}
 
-	vcpu->cr3 = cr3;
 	mutex_lock(&vcpu->kvm->lock);
 	/*
 	 * Does the new cr3 value map to physical memory? (Note, we
@@ -592,8 +591,10 @@ void set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	 */
 	if (unlikely(!gfn_to_memslot(vcpu->kvm, cr3 >> PAGE_SHIFT)))
 		inject_gp(vcpu);
-	else
+	else {
+		vcpu->cr3 = cr3;
 		vcpu->mmu.new_cr3(vcpu);
+	}
 	mutex_unlock(&vcpu->kvm->lock);
 }
 EXPORT_SYMBOL_GPL(set_cr3);
-- 
1.5.3

