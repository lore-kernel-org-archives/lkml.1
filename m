Return-Path: <linux-kernel-owner+w=401wt.eu-S1759697AbXLWPIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759697AbXLWPIb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 10:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756187AbXLWOwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:52:35 -0500
Received: from il.qumranet.com ([82.166.9.18]:35919 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798AbXLWOvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:46 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 41/50] KVM: Rename KVM_TLB_FLUSH to KVM_REQ_TLB_FLUSH
Date: Sun, 23 Dec 2007 16:51:26 +0200
Message-Id: <1198421495-31481-42-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We now have a new namespace, KVM_REQ_*, for bits in vcpu->requests.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    2 +-
 drivers/kvm/kvm_main.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 1edf8a5..6ae7b63 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -67,7 +67,7 @@
 /*
  * vcpu->requests bit members
  */
-#define KVM_TLB_FLUSH 0
+#define KVM_REQ_TLB_FLUSH          0
 
 /*
  * Address types:
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index c94d4df..a1a3be9 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -212,7 +212,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 		vcpu = kvm->vcpus[i];
 		if (!vcpu)
 			continue;
-		if (test_and_set_bit(KVM_TLB_FLUSH, &vcpu->requests))
+		if (test_and_set_bit(KVM_REQ_TLB_FLUSH, &vcpu->requests))
 			continue;
 		cpu = vcpu->cpu;
 		if (cpu != -1 && cpu != raw_smp_processor_id())
@@ -2171,7 +2171,7 @@ again:
 	kvm_guest_enter();
 
 	if (vcpu->requests)
-		if (test_and_clear_bit(KVM_TLB_FLUSH, &vcpu->requests))
+		if (test_and_clear_bit(KVM_REQ_TLB_FLUSH, &vcpu->requests))
 			kvm_x86_ops->tlb_flush(vcpu);
 
 	kvm_x86_ops->run(vcpu, kvm_run);
-- 
1.5.3.7

