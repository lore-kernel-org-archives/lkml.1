Return-Path: <linux-kernel-owner+w=401wt.eu-S1753738AbXLZLKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738AbXLZLKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbXLZLG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:28 -0500
Received: from il.qumranet.com ([82.166.9.18]:50482 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761AbXLZLGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:06 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Carsten Otte <cotte@de.ibm.com>
Subject: [PATCH 20/55] KVM: Portability: move get/set_apic_base to x86.c
Date: Wed, 26 Dec 2007 13:05:25 +0200
Message-Id: <1198667160-22953-21-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carsten Otte <cotte@de.ibm.com>

This patch moves the implementation of get_apic_base and set_apic_base
from kvm_main.c to x86.c

Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |   19 -------------------
 drivers/kvm/x86.c      |   19 +++++++++++++++++++
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 00f9c9e..d6545a7 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -556,25 +556,6 @@ unsigned long get_cr8(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(get_cr8);
 
-u64 kvm_get_apic_base(struct kvm_vcpu *vcpu)
-{
-	if (irqchip_in_kernel(vcpu->kvm))
-		return vcpu->apic_base;
-	else
-		return vcpu->apic_base;
-}
-EXPORT_SYMBOL_GPL(kvm_get_apic_base);
-
-void kvm_set_apic_base(struct kvm_vcpu *vcpu, u64 data)
-{
-	/* TODO: reserve bits check */
-	if (irqchip_in_kernel(vcpu->kvm))
-		kvm_lapic_set_base(vcpu, data);
-	else
-		vcpu->apic_base = data;
-}
-EXPORT_SYMBOL_GPL(kvm_set_apic_base);
-
 void fx_init(struct kvm_vcpu *vcpu)
 {
 	unsigned after_mxcsr_mask;
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index 5a95922..c26e371 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -59,6 +59,25 @@ unsigned long segment_base(u16 selector)
 }
 EXPORT_SYMBOL_GPL(segment_base);
 
+u64 kvm_get_apic_base(struct kvm_vcpu *vcpu)
+{
+	if (irqchip_in_kernel(vcpu->kvm))
+		return vcpu->apic_base;
+	else
+		return vcpu->apic_base;
+}
+EXPORT_SYMBOL_GPL(kvm_get_apic_base);
+
+void kvm_set_apic_base(struct kvm_vcpu *vcpu, u64 data)
+{
+	/* TODO: reserve bits check */
+	if (irqchip_in_kernel(vcpu->kvm))
+		kvm_lapic_set_base(vcpu, data);
+	else
+		vcpu->apic_base = data;
+}
+EXPORT_SYMBOL_GPL(kvm_set_apic_base);
+
 /*
  * List of msr numbers which we expose to userspace through KVM_GET_MSRS
  * and KVM_SET_MSRS, and KVM_GET_MSR_INDEX_LIST.
-- 
1.5.3.7

