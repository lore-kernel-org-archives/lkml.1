Return-Path: <linux-kernel-owner+w=401wt.eu-S1763477AbYD0TOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763477AbYD0TOU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 15:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbYD0TOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 15:14:08 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:53167 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbYD0TOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 15:14:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GUo2RIf2VOMrND2R6NOuRoBUN+JUuH/BTCCOFSgvA78c4dtcmV2HAMQzT9jK6WK5KJiMW7TuHN4vgpN4yIwf8nyNGx6Hks9ZSCvENSYP9A8mR8coHdvX0pP+RwM5+hN0Q61AfjrMWFJZVd2UVETzTnAK2cWleqht10yAGOD05lw=
Subject: [PATCH] kvm: add statics were possible, function definition in
	lapic.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Avi Kivity <avi@qumranet.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Sun, 27 Apr 2008 12:14:13 -0700
Message-Id: <1209323653.14173.68.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 arch/x86/kvm/i8254.c |    6 +++---
 arch/x86/kvm/lapic.h |    1 +
 arch/x86/kvm/mmu.c   |    4 ++--
 arch/x86/kvm/vmx.c   |    2 +-
 arch/x86/kvm/x86.c   |    4 ++--
 5 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 361e316..908520c 100644
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
@@ -558,7 +558,7 @@ void kvm_free_pit(struct kvm *kvm)
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
index 2ad6f54..8315d99 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1965,7 +1965,7 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 	kvm_flush_remote_tlbs(kvm);
 }
 
-void kvm_mmu_remove_one_alloc_mmu_page(struct kvm *kvm)
+static void kvm_mmu_remove_one_alloc_mmu_page(struct kvm *kvm)
 {
 	struct kvm_mmu_page *page;
 
@@ -2011,7 +2011,7 @@ static struct shrinker mmu_shrinker = {
 	.seeks = DEFAULT_SEEKS * 10,
 };
 
-void mmu_destroy_caches(void)
+static void mmu_destroy_caches(void)
 {
 	if (pte_chain_cache)
 		kmem_cache_destroy(pte_chain_cache);
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 8e5d664..c50a33c 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1580,7 +1580,7 @@ static void allocate_vpid(struct vcpu_vmx *vmx)
 	spin_unlock(&vmx_vpid_lock);
 }
 
-void vmx_disable_intercept_for_msr(struct page *msr_bitmap, u32 msr)
+static void vmx_disable_intercept_for_msr(struct page *msr_bitmap, u32 msr)
 {
 	void *va;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0ce5563..458c186 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3403,7 +3403,7 @@ static int load_state_from_tss16(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-int kvm_task_switch_16(struct kvm_vcpu *vcpu, u16 tss_selector,
+static int kvm_task_switch_16(struct kvm_vcpu *vcpu, u16 tss_selector,
 		       struct desc_struct *cseg_desc,
 		       struct desc_struct *nseg_desc)
 {
@@ -3426,7 +3426,7 @@ out:
 	return ret;
 }
 
-int kvm_task_switch_32(struct kvm_vcpu *vcpu, u16 tss_selector,
+static int kvm_task_switch_32(struct kvm_vcpu *vcpu, u16 tss_selector,
 		       struct desc_struct *cseg_desc,
 		       struct desc_struct *nseg_desc)
 {
-- 
1.5.5.1.270.g89765



