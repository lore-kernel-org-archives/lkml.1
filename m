Return-Path: <linux-kernel-owner+w=401wt.eu-S1761686AbZBZO1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761686AbZBZO1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757834AbZBZORL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:17:11 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43093 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755003AbZBZOPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:43 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Xiantao Zhang <xiantao.zhang@intel.com>
Subject: [PATCH 19/40] KVM: ia64: Code cleanup
Date: Thu, 26 Feb 2009 16:15:09 +0200
Message-Id: <1235657730-27683-20-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiantao Zhang <xiantao.zhang@intel.com>

Remove some unnecessary blank lines to accord with Kernel's coding style.
Also remove vcpu_get_itir_on_fault due to no reference to it.

Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/process.c |   15 ---------------
 arch/ia64/kvm/vcpu.c    |   39 ++-------------------------------------
 arch/ia64/kvm/vtlb.c    |    5 -----
 3 files changed, 2 insertions(+), 57 deletions(-)

diff --git a/arch/ia64/kvm/process.c b/arch/ia64/kvm/process.c
index 230eae4..f9c9504 100644
--- a/arch/ia64/kvm/process.c
+++ b/arch/ia64/kvm/process.c
@@ -167,7 +167,6 @@ static u64 vcpu_get_itir_on_fault(struct kvm_vcpu *vcpu, u64 ifa)
 	return (rr1.val);
 }
 
-
 /*
  * Set vIFA & vITIR & vIHA, when vPSR.ic =1
  * Parameter:
@@ -222,8 +221,6 @@ void itlb_fault(struct kvm_vcpu *vcpu, u64 vadr)
 	inject_guest_interruption(vcpu, IA64_INST_TLB_VECTOR);
 }
 
-
-
 /*
  * Data Nested TLB Fault
  *  @ Data Nested TLB Vector
@@ -245,7 +242,6 @@ void alt_dtlb(struct kvm_vcpu *vcpu, u64 vadr)
 	inject_guest_interruption(vcpu, IA64_ALT_DATA_TLB_VECTOR);
 }
 
-
 /*
  * Data TLB Fault
  *  @ Data TLB vector
@@ -265,8 +261,6 @@ static void _vhpt_fault(struct kvm_vcpu *vcpu, u64 vadr)
 	/* If vPSR.ic, IFA, ITIR, IHA*/
 	set_ifa_itir_iha(vcpu, vadr, 1, 1, 1);
 	inject_guest_interruption(vcpu, IA64_VHPT_TRANS_VECTOR);
-
-
 }
 
 /*
@@ -279,7 +273,6 @@ void ivhpt_fault(struct kvm_vcpu *vcpu, u64 vadr)
 	_vhpt_fault(vcpu, vadr);
 }
 
-
 /*
  * VHPT Data Fault
  *  @ VHPT Translation vector
@@ -290,8 +283,6 @@ void dvhpt_fault(struct kvm_vcpu *vcpu, u64 vadr)
 	_vhpt_fault(vcpu, vadr);
 }
 
-
-
 /*
  * Deal with:
  *  General Exception vector
@@ -301,7 +292,6 @@ void _general_exception(struct kvm_vcpu *vcpu)
 	inject_guest_interruption(vcpu, IA64_GENEX_VECTOR);
 }
 
-
 /*
  * Illegal Operation Fault
  *  @ General Exception Vector
@@ -419,19 +409,16 @@ static void __page_not_present(struct kvm_vcpu *vcpu, u64 vadr)
 	inject_guest_interruption(vcpu, IA64_PAGE_NOT_PRESENT_VECTOR);
 }
 
-
 void data_page_not_present(struct kvm_vcpu *vcpu, u64 vadr)
 {
 	__page_not_present(vcpu, vadr);
 }
 
-
 void inst_page_not_present(struct kvm_vcpu *vcpu, u64 vadr)
 {
 	__page_not_present(vcpu, vadr);
 }
 
-
 /* Deal with
  *  Data access rights vector
  */
@@ -703,7 +690,6 @@ void vhpi_detection(struct kvm_vcpu *vcpu)
 	}
 }
 
-
 void leave_hypervisor_tail(void)
 {
 	struct kvm_vcpu *v = current_vcpu;
@@ -737,7 +723,6 @@ void leave_hypervisor_tail(void)
 	}
 }
 
-
 static inline void handle_lds(struct kvm_pt_regs *regs)
 {
 	regs->cr_ipsr |= IA64_PSR_ED;
diff --git a/arch/ia64/kvm/vcpu.c b/arch/ia64/kvm/vcpu.c
index ecd526b..4d8be4c 100644
--- a/arch/ia64/kvm/vcpu.c
+++ b/arch/ia64/kvm/vcpu.c
@@ -112,7 +112,6 @@ void switch_to_physical_rid(struct kvm_vcpu *vcpu)
 	return;
 }
 
-
 void switch_to_virtual_rid(struct kvm_vcpu *vcpu)
 {
 	unsigned long psr;
@@ -166,8 +165,6 @@ void switch_mm_mode(struct kvm_vcpu *vcpu, struct ia64_psr old_psr,
 	return;
 }
 
-
-
 /*
  * In physical mode, insert tc/tr for region 0 and 4 uses
  * RID[0] and RID[4] which is for physical mode emulation.
@@ -269,7 +266,6 @@ static inline unsigned long fph_index(struct kvm_pt_regs *regs,
 	return rotate_reg(96, rrb_fr, (regnum - IA64_FIRST_ROTATING_FR));
 }
 
-
 /*
  * The inverse of the above: given bspstore and the number of
  * registers, calculate ar.bsp.
@@ -1039,8 +1035,6 @@ u64 vcpu_tak(struct kvm_vcpu *vcpu, u64 vadr)
 	return key;
 }
 
-
-
 void kvm_thash(struct kvm_vcpu *vcpu, INST64 inst)
 {
 	unsigned long thash, vadr;
@@ -1050,7 +1044,6 @@ void kvm_thash(struct kvm_vcpu *vcpu, INST64 inst)
 	vcpu_set_gr(vcpu, inst.M46.r1, thash, 0);
 }
 
-
 void kvm_ttag(struct kvm_vcpu *vcpu, INST64 inst)
 {
 	unsigned long tag, vadr;
@@ -1131,7 +1124,6 @@ int vcpu_tpa(struct kvm_vcpu *vcpu, u64 vadr, u64 *padr)
 	return IA64_NO_FAULT;
 }
 
-
 int kvm_tpa(struct kvm_vcpu *vcpu, INST64 inst)
 {
 	unsigned long r1, r3;
@@ -1154,7 +1146,6 @@ void kvm_tak(struct kvm_vcpu *vcpu, INST64 inst)
 	vcpu_set_gr(vcpu, inst.M46.r1, r1, 0);
 }
 
-
 /************************************
  * Insert/Purge translation register/cache
  ************************************/
@@ -1385,7 +1376,6 @@ void kvm_mov_to_ar_reg(struct kvm_vcpu *vcpu, INST64 inst)
 	vcpu_set_itc(vcpu, r2);
 }
 
-
 void kvm_mov_from_ar_reg(struct kvm_vcpu *vcpu, INST64 inst)
 {
 	unsigned long r1;
@@ -1393,8 +1383,9 @@ void kvm_mov_from_ar_reg(struct kvm_vcpu *vcpu, INST64 inst)
 	r1 = vcpu_get_itc(vcpu);
 	vcpu_set_gr(vcpu, inst.M31.r1, r1, 0);
 }
+
 /**************************************************************************
-  struct kvm_vcpu*protection key register access routines
+  struct kvm_vcpu protection key register access routines
  **************************************************************************/
 
 unsigned long vcpu_get_pkr(struct kvm_vcpu *vcpu, unsigned long reg)
@@ -1407,20 +1398,6 @@ void vcpu_set_pkr(struct kvm_vcpu *vcpu, unsigned long reg, unsigned long val)
 	ia64_set_pkr(reg, val);
 }
 
-
-unsigned long vcpu_get_itir_on_fault(struct kvm_vcpu *vcpu, unsigned long ifa)
-{
-	union ia64_rr rr, rr1;
-
-	rr.val = vcpu_get_rr(vcpu, ifa);
-	rr1.val = 0;
-	rr1.ps = rr.ps;
-	rr1.rid = rr.rid;
-	return (rr1.val);
-}
-
-
-
 /********************************
  * Moves to privileged registers
  ********************************/
@@ -1464,8 +1441,6 @@ unsigned long vcpu_set_rr(struct kvm_vcpu *vcpu, unsigned long reg,
 	return (IA64_NO_FAULT);
 }
 
-
-
 void kvm_mov_to_rr(struct kvm_vcpu *vcpu, INST64 inst)
 {
 	unsigned long r3, r2;
@@ -1510,8 +1485,6 @@ void kvm_mov_to_pkr(struct kvm_vcpu *vcpu, INST64 inst)
 	vcpu_set_pkr(vcpu, r3, r2);
 }
 
-
-
 void kvm_mov_from_rr(struct kvm_vcpu *vcpu, INST64 inst)
 {
 	unsigned long r3, r1;
@@ -1557,7 +1530,6 @@ void kvm_mov_from_pmc(struct kvm_vcpu *vcpu, INST64 inst)
 	vcpu_set_gr(vcpu, inst.M43.r1, r1, 0);
 }
 
-
 unsigned long vcpu_get_cpuid(struct kvm_vcpu *vcpu, unsigned long reg)
 {
 	/* FIXME: This could get called as a result of a rsvd-reg fault */
@@ -1609,7 +1581,6 @@ unsigned long kvm_mov_to_cr(struct kvm_vcpu *vcpu, INST64 inst)
 	return 0;
 }
 
-
 unsigned long kvm_mov_from_cr(struct kvm_vcpu *vcpu, INST64 inst)
 {
 	unsigned long tgt = inst.M33.r1;
@@ -1633,8 +1604,6 @@ unsigned long kvm_mov_from_cr(struct kvm_vcpu *vcpu, INST64 inst)
 	return 0;
 }
 
-
-
 void vcpu_set_psr(struct kvm_vcpu *vcpu, unsigned long val)
 {
 
@@ -1776,9 +1745,6 @@ void vcpu_bsw1(struct kvm_vcpu *vcpu)
 	}
 }
 
-
-
-
 void vcpu_rfi(struct kvm_vcpu *vcpu)
 {
 	unsigned long ifs, psr;
@@ -1796,7 +1762,6 @@ void vcpu_rfi(struct kvm_vcpu *vcpu)
 	regs->cr_iip = VCPU(vcpu, iip);
 }
 
-
 /*
    VPSR can't keep track of below bits of guest PSR
    This function gets guest PSR
diff --git a/arch/ia64/kvm/vtlb.c b/arch/ia64/kvm/vtlb.c
index 6b6307a..ac94867 100644
--- a/arch/ia64/kvm/vtlb.c
+++ b/arch/ia64/kvm/vtlb.c
@@ -509,7 +509,6 @@ void thash_purge_all(struct kvm_vcpu *v)
 	local_flush_tlb_all();
 }
 
-
 /*
  * Lookup the hash table and its collision chain to find an entry
  * covering this address rid:va or the entry.
@@ -517,7 +516,6 @@ void thash_purge_all(struct kvm_vcpu *v)
  * INPUT:
  *  in: TLB format for both VHPT & TLB.
  */
-
 struct thash_data *vtlb_lookup(struct kvm_vcpu *v, u64 va, int is_data)
 {
 	struct thash_data  *cch;
@@ -547,7 +545,6 @@ struct thash_data *vtlb_lookup(struct kvm_vcpu *v, u64 va, int is_data)
 	return NULL;
 }
 
-
 /*
  * Initialize internal control data before service.
  */
@@ -589,7 +586,6 @@ u64 kvm_gpa_to_mpa(u64 gpa)
 	return (pte >> PAGE_SHIFT << PAGE_SHIFT) | (gpa & ~PAGE_MASK);
 }
 
-
 /*
  * Fetch guest bundle code.
  * INPUT:
@@ -631,7 +627,6 @@ int fetch_code(struct kvm_vcpu *vcpu, u64 gip, IA64_BUNDLE *pbundle)
 	return IA64_NO_FAULT;
 }
 
-
 void kvm_init_vhpt(struct kvm_vcpu *v)
 {
 	v->arch.vhpt.num = VHPT_NUM_ENTRIES;
-- 
1.6.0.6

