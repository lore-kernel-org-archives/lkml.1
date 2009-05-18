Return-Path: <linux-kernel-owner+w=401wt.eu-S1751989AbZERJrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989AbZERJrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756805AbZERJZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:25:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38405 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbZERJXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:09 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 13/43] KVM: declare ioapic functions only on affected hardware
Date: Mon, 18 May 2009 12:22:35 +0300
Message-Id: <1242638585-18470-14-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

Since "KVM: Unify the delivery of IOAPIC and MSI interrupts"
I get the following warnings:

  CC [M]  arch/s390/kvm/kvm-s390.o
In file included from arch/s390/kvm/kvm-s390.c:22:
include/linux/kvm_host.h:357: warning: 'struct kvm_ioapic' declared inside parameter list
include/linux/kvm_host.h:357: warning: its scope is only this definition or declaration, which is probably not what you want

This patch limits IOAPIC functions for architectures that have one.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 include/linux/kvm_host.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3832243..3b91ec9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -363,9 +363,11 @@ void kvm_unregister_irq_mask_notifier(struct kvm *kvm, int irq,
 				      struct kvm_irq_mask_notifier *kimn);
 void kvm_fire_mask_notifiers(struct kvm *kvm, int irq, bool mask);
 
+#ifdef __KVM_HAVE_IOAPIC
 void kvm_get_intr_delivery_bitmask(struct kvm_ioapic *ioapic,
 				   union kvm_ioapic_redirect_entry *entry,
 				   unsigned long *deliver_bitmask);
+#endif
 int kvm_set_irq(struct kvm *kvm, int irq_source_id, int irq, int level);
 void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin);
 void kvm_register_irq_ack_notifier(struct kvm *kvm,
-- 
1.6.0.6

