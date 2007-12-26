Return-Path: <linux-kernel-owner+w=401wt.eu-S1752255AbXLZLGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbXLZLGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:06:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbXLZLGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:05 -0500
Received: from il.qumranet.com ([82.166.9.18]:50436 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbXLZLGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:03 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Eddie Dong <eddie.dong@intel.com>
Subject: [PATCH 04/55] KVM: Export PIC reset for kernel device reset
Date: Wed, 26 Dec 2007 13:05:09 +0200
Message-Id: <1198667160-22953-5-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eddie Dong <eddie.dong@intel.com>

Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/i8259.c |    6 ++----
 drivers/kvm/irq.h   |    1 +
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/kvm/i8259.c b/drivers/kvm/i8259.c
index a679157..f0dc2ee 100644
--- a/drivers/kvm/i8259.c
+++ b/drivers/kvm/i8259.c
@@ -181,10 +181,8 @@ int kvm_pic_read_irq(struct kvm_pic *s)
 	return intno;
 }
 
-static void pic_reset(void *opaque)
+void kvm_pic_reset(struct kvm_kpic_state *s)
 {
-	struct kvm_kpic_state *s = opaque;
-
 	s->last_irr = 0;
 	s->irr = 0;
 	s->imr = 0;
@@ -209,7 +207,7 @@ static void pic_ioport_write(void *opaque, u32 addr, u32 val)
 	addr &= 1;
 	if (addr == 0) {
 		if (val & 0x10) {
-			pic_reset(s);	/* init */
+			kvm_pic_reset(s);	/* init */
 			/*
 			 * deassert a pending interrupt
 			 */
diff --git a/drivers/kvm/irq.h b/drivers/kvm/irq.h
index 508280e..e08ae10 100644
--- a/drivers/kvm/irq.h
+++ b/drivers/kvm/irq.h
@@ -139,6 +139,7 @@ int kvm_apic_accept_pic_intr(struct kvm_vcpu *vcpu);
 int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu);
 int kvm_create_lapic(struct kvm_vcpu *vcpu);
 void kvm_lapic_reset(struct kvm_vcpu *vcpu);
+void kvm_pic_reset(struct kvm_kpic_state *s);
 void kvm_free_lapic(struct kvm_vcpu *vcpu);
 u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu);
 void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8);
-- 
1.5.3.7

