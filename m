Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbYCCVAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbYCCVAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:00:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbYCCVAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:00:06 -0500
Received: from el-out-1112.google.com ([209.85.162.180]:62625 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757397AbYCCVAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:00:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PJw51WipK+/soKlPAkYR6WuZQbxIZKtqvEnrWJeG1qPcYP0mGSfmfbdoD1D2MA6+eZ6DRyUa8zAJSs3SXFZB1SMLWqbNJfDwiGoQVNm9BWPccmAwC/TJSD60P/SiI6WnQ9bElfSY1KffndAgH/MipCZ2Ikt393Fzklh0FJnrYX0=
Subject: [PATCH] kvm: replace remaining __FUNCTION__ occurances
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Avi Kivity <avi@qumranet.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 12:59:56 -0800
Message-Id: <1204577996.22933.8.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Against kvm.git:master

 arch/x86/kvm/lapic.c       |    8 ++++----
 arch/x86/kvm/mmu.c         |   34 +++++++++++++++++-----------------
 arch/x86/kvm/paging_tmpl.h |   14 +++++++-------
 arch/x86/kvm/svm.c         |   14 +++++++-------
 arch/x86/kvm/vmx.c         |    6 +++---
 arch/x86/kvm/x86.c         |   12 ++++++------
 6 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 68a6b15..31280df 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -658,7 +658,7 @@ static void start_apic_timer(struct kvm_lapic *apic)
 	apic_debug("%s: bus cycle is %" PRId64 "ns, now 0x%016"
 			   PRIx64 ", "
 			   "timer initial count 0x%x, period %lldns, "
-			   "expire @ 0x%016" PRIx64 ".\n", __FUNCTION__,
+			   "expire @ 0x%016" PRIx64 ".\n", __func__,
 			   APIC_BUS_CYCLE_NS, ktime_to_ns(now),
 			   apic_get_reg(apic, APIC_TMICT),
 			   apic->timer.period,
@@ -691,7 +691,7 @@ static void apic_mmio_write(struct kvm_io_device *this,
 	/* too common printing */
 	if (offset != APIC_EOI)
 		apic_debug("%s: offset 0x%x with length 0x%x, and value is "
-			   "0x%x\n", __FUNCTION__, offset, len, val);
+			   "0x%x\n", __func__, offset, len, val);
 
 	offset &= 0xff0;
 
@@ -869,7 +869,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu)
 	struct kvm_lapic *apic;
 	int i;
 
-	apic_debug("%s\n", __FUNCTION__);
+	apic_debug("%s\n", __func__);
 
 	ASSERT(vcpu);
 	apic = vcpu->arch.apic;
@@ -907,7 +907,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu)
 	apic_update_ppr(apic);
 
 	apic_debug(KERN_INFO "%s: vcpu=%p, id=%d, base_msr="
-		   "0x%016" PRIx64 ", base_address=0x%0lx.\n", __FUNCTION__,
+		   "0x%016" PRIx64 ", base_address=0x%0lx.\n", __func__,
 		   vcpu, kvm_apic_id(apic),
 		   vcpu->arch.apic_base, apic->base_address);
 }
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 4583329..f0cdfba 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -650,7 +650,7 @@ static int is_empty_shadow_page(u64 *spt)
 
 	for (pos = spt, end = pos + PAGE_SIZE / sizeof(u64); pos != end; pos++)
 		if (*pos != shadow_trap_nonpresent_pte) {
-			printk(KERN_ERR "%s: %p %llx\n", __FUNCTION__,
+			printk(KERN_ERR "%s: %p %llx\n", __func__,
 			       pos, *pos);
 			return 0;
 		}
@@ -773,14 +773,14 @@ static struct kvm_mmu_page *kvm_mmu_lookup_page(struct kvm *kvm, gfn_t gfn)
 	struct kvm_mmu_page *sp;
 	struct hlist_node *node;
 
-	pgprintk("%s: looking for gfn %lx\n", __FUNCTION__, gfn);
+	pgprintk("%s: looking for gfn %lx\n", __func__, gfn);
 	index = kvm_page_table_hashfn(gfn);
 	bucket = &kvm->arch.mmu_page_hash[index];
 	hlist_for_each_entry(sp, node, bucket, hash_link)
 		if (sp->gfn == gfn && !sp->role.metaphysical
 		    && !sp->role.invalid) {
 			pgprintk("%s: found role %x\n",
-				 __FUNCTION__, sp->role.word);
+				 __func__, sp->role.word);
 			return sp;
 		}
 	return NULL;
@@ -811,21 +811,21 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
 		role.quadrant = quadrant;
 	}
-	pgprintk("%s: looking gfn %lx role %x\n", __FUNCTION__,
+	pgprintk("%s: looking gfn %lx role %x\n", __func__,
 		 gfn, role.word);
 	index = kvm_page_table_hashfn(gfn);
 	bucket = &vcpu->kvm->arch.mmu_page_hash[index];
 	hlist_for_each_entry(sp, node, bucket, hash_link)
 		if (sp->gfn == gfn && sp->role.word == role.word) {
 			mmu_page_add_parent_pte(vcpu, sp, parent_pte);
-			pgprintk("%s: found\n", __FUNCTION__);
+			pgprintk("%s: found\n", __func__);
 			return sp;
 		}
 	++vcpu->kvm->stat.mmu_cache_miss;
 	sp = kvm_mmu_alloc_page(vcpu, parent_pte);
 	if (!sp)
 		return sp;
-	pgprintk("%s: adding gfn %lx role %x\n", __FUNCTION__, gfn, role.word);
+	pgprintk("%s: adding gfn %lx role %x\n", __func__, gfn, role.word);
 	sp->gfn = gfn;
 	sp->role = role;
 	hlist_add_head(&sp->hash_link, bucket);
@@ -961,13 +961,13 @@ static int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 	struct hlist_node *node, *n;
 	int r;
 
-	pgprintk("%s: looking for gfn %lx\n", __FUNCTION__, gfn);
+	pgprintk("%s: looking for gfn %lx\n", __func__, gfn);
 	r = 0;
 	index = kvm_page_table_hashfn(gfn);
 	bucket = &kvm->arch.mmu_page_hash[index];
 	hlist_for_each_entry_safe(sp, node, n, bucket, hash_link)
 		if (sp->gfn == gfn && !sp->role.metaphysical) {
-			pgprintk("%s: gfn %lx role %x\n", __FUNCTION__, gfn,
+			pgprintk("%s: gfn %lx role %x\n", __func__, gfn,
 				 sp->role.word);
 			kvm_mmu_zap_page(kvm, sp);
 			r = 1;
@@ -980,7 +980,7 @@ static void mmu_unshadow(struct kvm *kvm, gfn_t gfn)
 	struct kvm_mmu_page *sp;
 
 	while ((sp = kvm_mmu_lookup_page(kvm, gfn)) != NULL) {
-		pgprintk("%s: zap %lx %x\n", __FUNCTION__, gfn, sp->role.word);
+		pgprintk("%s: zap %lx %x\n", __func__, gfn, sp->role.word);
 		kvm_mmu_zap_page(kvm, sp);
 	}
 }
@@ -1036,7 +1036,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 
 	pgprintk("%s: spte %llx access %x write_fault %d"
 		 " user_fault %d gfn %lx\n",
-		 __FUNCTION__, *shadow_pte, pt_access,
+		 __func__, *shadow_pte, pt_access,
 		 write_fault, user_fault, gfn);
 
 	/*
@@ -1072,7 +1072,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 		if (shadow ||
 		   (largepage && has_wrprotected_page(vcpu->kvm, gfn))) {
 			pgprintk("%s: found shadow page for %lx, marking ro\n",
-				 __FUNCTION__, gfn);
+				 __func__, gfn);
 			pte_access &= ~ACC_WRITE_MASK;
 			if (is_writeble_pte(spte)) {
 				spte &= ~PT_WRITABLE_MASK;
@@ -1088,7 +1088,7 @@ unshadowed:
 	if (pte_access & ACC_WRITE_MASK)
 		mark_page_dirty(vcpu->kvm, gfn);
 
-	pgprintk("%s: setting spte %llx\n", __FUNCTION__, spte);
+	pgprintk("%s: setting spte %llx\n", __func__, spte);
 	pgprintk("instantiating %s PTE (%s) at %d (%llx) addr %llx\n",
 		 (spte&PT_PAGE_SIZE_MASK)? "2MB" : "4kB",
 		 (spte&PT_WRITABLE_MASK)?"RW":"R", gfn, spte, shadow_pte);
@@ -1308,7 +1308,7 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 	gfn_t gfn;
 	int r;
 
-	pgprintk("%s: gva %lx error %x\n", __FUNCTION__, gva, error_code);
+	pgprintk("%s: gva %lx error %x\n", __func__, gva, error_code);
 	r = mmu_topup_memory_caches(vcpu);
 	if (r)
 		return r;
@@ -1386,7 +1386,7 @@ void kvm_mmu_flush_tlb(struct kvm_vcpu *vcpu)
 
 static void paging_new_cr3(struct kvm_vcpu *vcpu)
 {
-	pgprintk("%s: cr3 %lx\n", __FUNCTION__, vcpu->arch.cr3);
+	pgprintk("%s: cr3 %lx\n", __func__, vcpu->arch.cr3);
 	mmu_free_roots(vcpu);
 }
 
@@ -1682,7 +1682,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	int npte;
 	int r;
 
-	pgprintk("%s: gpa %llx bytes %d\n", __FUNCTION__, gpa, bytes);
+	pgprintk("%s: gpa %llx bytes %d\n", __func__, gpa, bytes);
 	mmu_guess_page_from_pte_write(vcpu, gpa, new, bytes);
 	spin_lock(&vcpu->kvm->mmu_lock);
 	kvm_mmu_free_some_pages(vcpu);
@@ -2130,7 +2130,7 @@ static void audit_rmap(struct kvm_vcpu *vcpu)
 
 	if (n_rmap != n_actual)
 		printk(KERN_ERR "%s: (%s) rmap %d actual %d\n",
-		       __FUNCTION__, audit_msg, n_rmap, n_actual);
+		       __func__, audit_msg, n_rmap, n_actual);
 }
 
 static void audit_write_protection(struct kvm_vcpu *vcpu)
@@ -2150,7 +2150,7 @@ static void audit_write_protection(struct kvm_vcpu *vcpu)
 		if (*rmapp)
 			printk(KERN_ERR "%s: (%s) shadow page has writable"
 			       " mappings: gfn %lx role %x\n",
-			       __FUNCTION__, audit_msg, sp->gfn,
+			       __func__, audit_msg, sp->gfn,
 			       sp->role.word);
 	}
 }
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 17f9d16..57abbd0 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -130,7 +130,7 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 	unsigned index, pt_access, pte_access;
 	gpa_t pte_gpa;
 
-	pgprintk("%s: addr %lx\n", __FUNCTION__, addr);
+	pgprintk("%s: addr %lx\n", __func__, addr);
 walk:
 	walker->level = vcpu->arch.mmu.root_level;
 	pte = vcpu->arch.cr3;
@@ -155,7 +155,7 @@ walk:
 		pte_gpa += index * sizeof(pt_element_t);
 		walker->table_gfn[walker->level - 1] = table_gfn;
 		walker->pte_gpa[walker->level - 1] = pte_gpa;
-		pgprintk("%s: table_gfn[%d] %lx\n", __FUNCTION__,
+		pgprintk("%s: table_gfn[%d] %lx\n", __func__,
 			 walker->level - 1, table_gfn);
 
 		kvm_read_guest(vcpu->kvm, pte_gpa, &pte, sizeof(pte));
@@ -222,7 +222,7 @@ walk:
 	walker->pt_access = pt_access;
 	walker->pte_access = pte_access;
 	pgprintk("%s: pte %llx pte_access %x pt_access %x\n",
-		 __FUNCTION__, (u64)pte, pt_access, pte_access);
+		 __func__, (u64)pte, pt_access, pte_access);
 	return 1;
 
 not_present:
@@ -256,7 +256,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 			set_shadow_pte(spte, shadow_notrap_nonpresent_pte);
 		return;
 	}
-	pgprintk("%s: gpte %llx spte %p\n", __FUNCTION__, (u64)gpte, spte);
+	pgprintk("%s: gpte %llx spte %p\n", __func__, (u64)gpte, spte);
 	pte_access = page->role.access & FNAME(gpte_access)(vcpu, gpte);
 	if (gpte_to_gfn(gpte) != vcpu->arch.update_pte.gfn)
 		return;
@@ -381,7 +381,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 	struct page *page;
 	int largepage = 0;
 
-	pgprintk("%s: addr %lx err %x\n", __FUNCTION__, addr, error_code);
+	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
 	kvm_mmu_audit(vcpu, "pre page fault");
 
 	r = mmu_topup_memory_caches(vcpu);
@@ -399,7 +399,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 	 * The page is not mapped by the guest.  Let the guest handle it.
 	 */
 	if (!r) {
-		pgprintk("%s: guest page fault\n", __FUNCTION__);
+		pgprintk("%s: guest page fault\n", __func__);
 		inject_page_fault(vcpu, addr, walker.error_code);
 		vcpu->arch.last_pt_write_count = 0; /* reset fork detector */
 		up_read(&vcpu->kvm->slots_lock);
@@ -431,7 +431,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 	shadow_pte = FNAME(fetch)(vcpu, addr, &walker, user_fault, write_fault,
 				  largepage, &write_pt, page);
 
-	pgprintk("%s: shadow pte %p %llx ptwrite %d\n", __FUNCTION__,
+	pgprintk("%s: shadow pte %p %llx ptwrite %d\n", __func__,
 		 shadow_pte, *shadow_pte, write_pt);
 
 	if (!write_pt)
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 28ad3c4..1ed3ead 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -230,12 +230,12 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	if (!svm->next_rip) {
-		printk(KERN_DEBUG "%s: NOP\n", __FUNCTION__);
+		printk(KERN_DEBUG "%s: NOP\n", __func__);
 		return;
 	}
 	if (svm->next_rip - svm->vmcb->save.rip > MAX_INST_SIZE)
 		printk(KERN_ERR "%s: ip 0x%llx next 0x%llx\n",
-		       __FUNCTION__,
+		       __func__,
 		       svm->vmcb->save.rip,
 		       svm->next_rip);
 
@@ -996,7 +996,7 @@ static void svm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long value,
 	}
 	default:
 		printk(KERN_DEBUG "%s: unexpected dr %u\n",
-		       __FUNCTION__, dr);
+		       __func__, dr);
 		*exception = UD_VECTOR;
 		return;
 	}
@@ -1109,7 +1109,7 @@ static int invalid_op_interception(struct vcpu_svm *svm,
 static int task_switch_interception(struct vcpu_svm *svm,
 				    struct kvm_run *kvm_run)
 {
-	pr_unimpl(&svm->vcpu, "%s: task switch is unsupported\n", __FUNCTION__);
+	pr_unimpl(&svm->vcpu, "%s: task switch is unsupported\n", __func__);
 	kvm_run->exit_reason = KVM_EXIT_UNKNOWN;
 	return 0;
 }
@@ -1125,7 +1125,7 @@ static int emulate_on_interception(struct vcpu_svm *svm,
 				   struct kvm_run *kvm_run)
 {
 	if (emulate_instruction(&svm->vcpu, NULL, 0, 0, 0) != EMULATE_DONE)
-		pr_unimpl(&svm->vcpu, "%s: failed\n", __FUNCTION__);
+		pr_unimpl(&svm->vcpu, "%s: failed\n", __func__);
 	return 1;
 }
 
@@ -1257,7 +1257,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
 	case MSR_IA32_DEBUGCTLMSR:
 		if (!svm_has(SVM_FEATURE_LBRV)) {
 			pr_unimpl(vcpu, "%s: MSR_IA32_DEBUGCTL 0x%llx, nop\n",
-					__FUNCTION__, data);
+					__func__, data);
 			break;
 		}
 		if (data & DEBUGCTL_RESERVED_BITS)
@@ -1419,7 +1419,7 @@ static int handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 	    exit_code != SVM_EXIT_NPF)
 		printk(KERN_ERR "%s: unexpected exit_ini_info 0x%x "
 		       "exit_code 0x%x\n",
-		       __FUNCTION__, svm->vmcb->control.exit_int_info,
+		       __func__, svm->vmcb->control.exit_int_info,
 		       exit_code);
 
 	if (exit_code >= ARRAY_SIZE(svm_exit_handlers)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 46e0e58..712fd73 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1256,7 +1256,7 @@ static void enter_lmode(struct kvm_vcpu *vcpu)
 	guest_tr_ar = vmcs_read32(GUEST_TR_AR_BYTES);
 	if ((guest_tr_ar & AR_TYPE_MASK) != AR_TYPE_BUSY_64_TSS) {
 		printk(KERN_DEBUG "%s: tss fixup for long mode. \n",
-		       __FUNCTION__);
+		       __func__);
 		vmcs_write32(GUEST_TR_AR_BYTES,
 			     (guest_tr_ar & ~AR_TYPE_MASK)
 			     | AR_TYPE_BUSY_64_TSS);
@@ -1911,7 +1911,7 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	if ((vect_info & VECTORING_INFO_VALID_MASK) &&
 						!is_page_fault(intr_info))
 		printk(KERN_ERR "%s: unexpected, vectoring info 0x%x "
-		       "intr info 0x%x\n", __FUNCTION__, vect_info, intr_info);
+		       "intr info 0x%x\n", __func__, vect_info, intr_info);
 
 	if (!irqchip_in_kernel(vcpu->kvm) && is_external_interrupt(vect_info)) {
 		int irq = vect_info & VECTORING_INFO_VECTOR_MASK;
@@ -2277,7 +2277,7 @@ static int kvm_handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 	if ((vectoring_info & VECTORING_INFO_VALID_MASK) &&
 				exit_reason != EXIT_REASON_EXCEPTION_NMI)
 		printk(KERN_WARNING "%s: unexpected, valid vectoring info and "
-		       "exit reason is 0x%x\n", __FUNCTION__, exit_reason);
+		       "exit reason is 0x%x\n", __func__, exit_reason);
 	if (exit_reason < kvm_vmx_max_exit_handlers
 	    && kvm_vmx_exit_handlers[exit_reason])
 		return kvm_vmx_exit_handlers[exit_reason](vcpu, kvm_run);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6f09840..e65a9d6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -563,15 +563,15 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		break;
 	case MSR_IA32_MC0_STATUS:
 		pr_unimpl(vcpu, "%s: MSR_IA32_MC0_STATUS 0x%llx, nop\n",
-		       __FUNCTION__, data);
+		       __func__, data);
 		break;
 	case MSR_IA32_MCG_STATUS:
 		pr_unimpl(vcpu, "%s: MSR_IA32_MCG_STATUS 0x%llx, nop\n",
-			__FUNCTION__, data);
+			__func__, data);
 		break;
 	case MSR_IA32_MCG_CTL:
 		pr_unimpl(vcpu, "%s: MSR_IA32_MCG_CTL 0x%llx, nop\n",
-			__FUNCTION__, data);
+			__func__, data);
 		break;
 	case MSR_IA32_UCODE_REV:
 	case MSR_IA32_UCODE_WRITE:
@@ -1926,7 +1926,7 @@ int emulator_get_dr(struct x86_emulate_ctxt *ctxt, int dr, unsigned long *dest)
 		*dest = kvm_x86_ops->get_dr(vcpu, dr);
 		return X86EMUL_CONTINUE;
 	default:
-		pr_unimpl(vcpu, "%s: unexpected dr %u\n", __FUNCTION__, dr);
+		pr_unimpl(vcpu, "%s: unexpected dr %u\n", __func__, dr);
 		return X86EMUL_UNHANDLEABLE;
 	}
 }
@@ -2473,7 +2473,7 @@ unsigned long realmode_get_cr(struct kvm_vcpu *vcpu, int cr)
 	case 8:
 		return kvm_get_cr8(vcpu);
 	default:
-		vcpu_printf(vcpu, "%s: unexpected cr %u\n", __FUNCTION__, cr);
+		vcpu_printf(vcpu, "%s: unexpected cr %u\n", __func__, cr);
 		return 0;
 	}
 }
@@ -2499,7 +2499,7 @@ void realmode_set_cr(struct kvm_vcpu *vcpu, int cr, unsigned long val,
 		kvm_set_cr8(vcpu, val & 0xfUL);
 		break;
 	default:
-		vcpu_printf(vcpu, "%s: unexpected cr %u\n", __FUNCTION__, cr);
+		vcpu_printf(vcpu, "%s: unexpected cr %u\n", __func__, cr);
 	}
 }
 
-- 
1.5.4.3.500.g83a2c



