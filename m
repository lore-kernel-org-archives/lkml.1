Return-Path: <linux-kernel-owner+w=401wt.eu-S1752703AbYFZMac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbYFZMac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbYFZM2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:28:38 -0400
Received: from il.qumranet.com ([212.179.150.194]:32311 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbYFZM2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:33 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH 02/50] KVM: add statics were possible, function definition in lapic.h
Date: Thu, 26 Jun 2008 15:27:44 +0300
Message-Id: <1214483312-9265-3-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>

Noticed by sparse:
arch/x86/kvm/vmx.c:1583:6: warning: symbol 'vmx_disable_intercept_for_msr' was not declared. Should it be static?
arch/x86/kvm/x86.c:3406:5: warning: symbol 'kvm_task_switch_16' was not declared. Should it be static?
arch/x86/kvm/x86.c:3429:5: warning: symbol 'kvm_task_switch_32' was not declared. Should it be static?
arch/x86/kvm/mmu.c:1968:6: warning: symbol 'kvm_mmu_remove_one_alloc_mmu_page' was not declared. Should it be static?
arch/x86/kvm/mmu.c:2014:6: warning: symbol 'mmu_destroy_caches' was not declared. Should it be static?
arch/x86/kvm/lapic.c:862:5: warning: symbol 'kvm_lapic_get_base' was not declared. Should it be static?
arch/x86/kvm/i8254.c:94:5: warning: symbol 'pit_get_gate' was not declared. Should it be static?
arch/x86/kvm/i8254.c:196:5: warning: symbol '__pit_timer_fn' was not declared. Should it be static?
arch/x86/kvm/i8254.c:561:6: warning: symbol '__inject_pit_timer_intr' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/i8254.c |    6 +++---
 arch/x86/kvm/lapic.h |    1 +
 arch/x86/kvm/mmu.c   |    2 +-
 arch/x86/kvm/vmx.c   |    2 +-
 arch/x86/kvm/x86.c   |    4 ++--
 5 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 3829aa7..735ec9a 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -91,7 +91,7 @@ static void pit_set_gate(struct kvm *kvm, int channel, u32 val)
 	c->gate = val;
 }
 
-int pit_get_gate(struct kvm *kvm, int channel)
+static int pit_get_gate(struct kvm *kvm, int channel)
 {
 	WARN_ON(!mutex_is_locked(&kvm->arch.vpit->pit_state.lock));
 
@@ -193,7 +193,7 @@ static void pit_latch_status(struct kvm *kvm, int channel)
 	}
 }
 
-int __pit_timer_fn(struct kvm_kpit_state *ps)
+static int __pit_timer_fn(struct kvm_kpit_state *ps)
 {
 	struct kvm_vcpu *vcpu0 = ps->pit->kvm->vcpus[0];
 	struct kvm_kpit_timer *pt = &ps->pit_timer;
@@ -575,7 +575,7 @@ void kvm_free_pit(struct kvm *kvm)
 	}
 }
 
-void __inject_pit_timer_intr(struct kvm *kvm)
+static void __inject_pit_timer_intr(struct kvm *kvm)
 {
 	mutex_lock(&kvm->lock);
 	kvm_ioapic_set_irq(kvm->arch.vioapic, 0, 1);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 676c396..8185888 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -31,6 +31,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu);
 u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu);
 void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8);
 void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value);
+u64 kvm_lapic_get_base(struct kvm_vcpu *vcpu);
 
 int kvm_apic_match_physical_addr(struct kvm_lapic *apic, u16 dest);
 int kvm_apic_match_logical_addr(struct kvm_lapic *apic, u8 mda);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 7e7c396..8e449db 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1948,7 +1948,7 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 	kvm_flush_remote_tlbs(kvm);
 }
 
-void kvm_mmu_remove_one_alloc_mmu_page(struct kvm *kvm)
+static void kvm_mmu_remove_one_alloc_mmu_page(struct kvm *kvm)
 {
 	struct kvm_mmu_page *page;
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 540e951..bc3452a 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1821,7 +1821,7 @@ static void allocate_vpid(struct vcpu_vmx *vmx)
 	spin_unlock(&vmx_vpid_lock);
 }
 
-void vmx_disable_intercept_for_msr(struct page *msr_bitmap, u32 msr)
+static void vmx_disable_intercept_for_msr(struct page *msr_bitmap, u32 msr)
 {
 	void *va;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 63a77ca..9a85a29 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3449,7 +3449,7 @@ static int load_state_from_tss16(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-int kvm_task_switch_16(struct kvm_vcpu *vcpu, u16 tss_selector,
+static int kvm_task_switch_16(struct kvm_vcpu *vcpu, u16 tss_selector,
 		       struct desc_struct *cseg_desc,
 		       struct desc_struct *nseg_desc)
 {
@@ -3472,7 +3472,7 @@ out:
 	return ret;
 }
 
-int kvm_task_switch_32(struct kvm_vcpu *vcpu, u16 tss_selector,
+static int kvm_task_switch_32(struct kvm_vcpu *vcpu, u16 tss_selector,
 		       struct desc_struct *cseg_desc,
 		       struct desc_struct *nseg_desc)
 {
-- 
1.5.6

