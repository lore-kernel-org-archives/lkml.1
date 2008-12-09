Return-Path: <linux-kernel-owner+w=401wt.eu-S1757270AbYLIUca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbYLIUca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:32:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755022AbYLIUYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:24:01 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34895 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754939AbYLIUXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:13 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 40/44] KVM: Export ioapic_get_delivery_bitmask
Date: Tue,  9 Dec 2008 22:22:55 +0200
Message-Id: <1228854179-23002-41-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

It would be used for MSI in device assignment, for MSI dispatch.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/ioapic.c |    7 ++++---
 virt/kvm/ioapic.h |    2 ++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index c8f939c..23b81cf 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -153,8 +153,8 @@ static void ioapic_inj_nmi(struct kvm_vcpu *vcpu)
 	kvm_vcpu_kick(vcpu);
 }
 
-static u32 ioapic_get_delivery_bitmask(struct kvm_ioapic *ioapic, u8 dest,
-				       u8 dest_mode)
+u32 kvm_ioapic_get_delivery_bitmask(struct kvm_ioapic *ioapic, u8 dest,
+				    u8 dest_mode)
 {
 	u32 mask = 0;
 	int i;
@@ -208,7 +208,8 @@ static int ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
 		     "vector=%x trig_mode=%x\n",
 		     dest, dest_mode, delivery_mode, vector, trig_mode);
 
-	deliver_bitmask = ioapic_get_delivery_bitmask(ioapic, dest, dest_mode);
+	deliver_bitmask = kvm_ioapic_get_delivery_bitmask(ioapic, dest,
+							  dest_mode);
 	if (!deliver_bitmask) {
 		ioapic_debug("no target on destination\n");
 		return 0;
diff --git a/virt/kvm/ioapic.h b/virt/kvm/ioapic.h
index cd7ae76..49c9581 100644
--- a/virt/kvm/ioapic.h
+++ b/virt/kvm/ioapic.h
@@ -85,5 +85,7 @@ void kvm_ioapic_update_eoi(struct kvm *kvm, int vector, int trigger_mode);
 int kvm_ioapic_init(struct kvm *kvm);
 void kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level);
 void kvm_ioapic_reset(struct kvm_ioapic *ioapic);
+u32 kvm_ioapic_get_delivery_bitmask(struct kvm_ioapic *ioapic, u8 dest,
+				u8 dest_mode);
 
 #endif
-- 
1.6.0.3

