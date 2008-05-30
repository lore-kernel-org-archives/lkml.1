Return-Path: <linux-kernel-owner+w=401wt.eu-S1756092AbYE3K2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbYE3K2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 06:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbYE3K1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 06:27:53 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:45207
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbYE3K1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 06:27:52 -0400
From: Amit Shah <amit.shah@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, muli@il.ibm.com, benami@il.ibm.com,
       allen.m.kay@intel.com, chrisw@redhat.com,
       Amit Shah <amit.shah@qumranet.com>
Subject: [PATCH 1/3] KVM: Expose get_eoi_gsi for IRQ acking for assigned devices.
Date: Fri, 30 May 2008 13:27:48 +0300
Message-Id: <1212143270-18333-1-git-send-email-amit.shah@qumranet.com>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also add kvm_ prefix.

Signed-off-by: Amit Shah <amit.shah@qumranet.com>
---
 virt/kvm/ioapic.c |    4 ++--
 virt/kvm/ioapic.h |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 99a1736..4c41a00 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -284,7 +284,7 @@ void kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level)
 	}
 }
 
-static int get_eoi_gsi(struct kvm_ioapic *ioapic, int vector)
+int kvm_get_eoi_gsi(struct kvm_ioapic *ioapic, int vector)
 {
 	int i;
 
@@ -300,7 +300,7 @@ void kvm_ioapic_update_eoi(struct kvm *kvm, int vector)
 	union ioapic_redir_entry *ent;
 	int gsi;
 
-	gsi = get_eoi_gsi(ioapic, vector);
+	gsi = kvm_get_eoi_gsi(ioapic, vector);
 	if (gsi == -1) {
 		printk(KERN_WARNING "Can't find redir item for %d EOI\n",
 		       vector);
diff --git a/virt/kvm/ioapic.h b/virt/kvm/ioapic.h
index 7f16675..a744572 100644
--- a/virt/kvm/ioapic.h
+++ b/virt/kvm/ioapic.h
@@ -91,5 +91,6 @@ void kvm_ioapic_update_eoi(struct kvm *kvm, int vector);
 int kvm_ioapic_init(struct kvm *kvm);
 void kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level);
 void kvm_ioapic_reset(struct kvm_ioapic *ioapic);
+int kvm_get_eoi_gsi(struct kvm_ioapic *ioapic, int vector);
 
 #endif
-- 
1.5.5.1

