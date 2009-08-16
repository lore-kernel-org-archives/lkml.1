Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbZHPJc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbZHPJc0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754452AbZHPJcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:32:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45368 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075AbZHPJaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:13 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 34/48] KVM: Cleanup LAPIC interface
Date: Sun, 16 Aug 2009 12:29:54 +0300
Message-Id: <1250415008-17175-35-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

None of the interface services the LAPIC emulation provides need to be
exported to modules, and kvm_lapic_get_base is even totally unused
today.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/lapic.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 4bfd458..a23f42e 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -194,7 +194,6 @@ int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu)
 
 	return highest_irr;
 }
-EXPORT_SYMBOL_GPL(kvm_lapic_find_highest_irr);
 
 static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 			     int vector, int level, int trig_mode);
@@ -768,7 +767,6 @@ void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8)
 	apic_set_tpr(apic, ((cr8 & 0x0f) << 4)
 		     | (apic_get_reg(apic, APIC_TASKPRI) & 4));
 }
-EXPORT_SYMBOL_GPL(kvm_lapic_set_tpr);
 
 u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu)
 {
@@ -781,7 +779,6 @@ u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu)
 
 	return (tpr & 0xf0) >> 4;
 }
-EXPORT_SYMBOL_GPL(kvm_lapic_get_cr8);
 
 void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 {
@@ -805,12 +802,6 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 
 }
 
-u64 kvm_lapic_get_base(struct kvm_vcpu *vcpu)
-{
-	return vcpu->arch.apic_base;
-}
-EXPORT_SYMBOL_GPL(kvm_lapic_get_base);
-
 void kvm_lapic_reset(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic;
@@ -860,7 +851,6 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu)
 		   vcpu, kvm_apic_id(apic),
 		   vcpu->arch.apic_base, apic->base_address);
 }
-EXPORT_SYMBOL_GPL(kvm_lapic_reset);
 
 bool kvm_apic_present(struct kvm_vcpu *vcpu)
 {
@@ -871,7 +861,6 @@ int kvm_lapic_enabled(struct kvm_vcpu *vcpu)
 {
 	return kvm_apic_present(vcpu) && apic_sw_enabled(vcpu->arch.apic);
 }
-EXPORT_SYMBOL_GPL(kvm_lapic_enabled);
 
 /*
  *----------------------------------------------------------------------
@@ -970,7 +959,6 @@ nomem_free_apic:
 nomem:
 	return -ENOMEM;
 }
-EXPORT_SYMBOL_GPL(kvm_create_lapic);
 
 int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu)
 {
-- 
1.6.3.3

