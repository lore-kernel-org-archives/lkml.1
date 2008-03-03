Return-Path: <linux-kernel-owner+w=401wt.eu-S1759690AbYCCThk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759690AbYCCThk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 14:37:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbYCCThc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 14:37:32 -0500
Received: from el-out-1112.google.com ([209.85.162.178]:10355 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbYCCTha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 14:37:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=n3/eBziWUJDRSNJpzeJSgXEDmJrblV2aKVxqIZJ+x8VqNzZB//bcv9wAcpmNujwT3H20EEH3V9iwbXvndiO4gFZ1i5+duZEqUiSoJJFbm9/+BFQON9HLspJUdNiRTsabf4kqGELyIyy/xp3NZweKyhl/tpnXJgPLqPfEshzesvM=
Subject: [PATCH] x86: replace remaining __FUNCTION__ occurances
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Avi Kivity <avi@qumranet.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 11:37:23 -0800
Message-Id: <1204573043.3266.50.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/alternative.c |    8 ++++----
 arch/x86/kernel/irq_32.c      |    2 +-
 arch/x86/kernel/srat_32.c     |   10 +++++-----
 arch/x86/kernel/summit_32.c   |   12 ++++++------
 arch/x86/kvm/lapic.c          |    8 ++++----
 arch/x86/kvm/mmu.c            |   34 +++++++++++++++++-----------------
 arch/x86/kvm/paging_tmpl.h    |   14 +++++++-------
 arch/x86/kvm/svm.c            |   12 ++++++------
 arch/x86/kvm/vmx.c            |    6 +++---
 arch/x86/kvm/x86.c            |   10 +++++-----
 arch/x86/lguest/boot.c        |    2 +-
 11 files changed, 59 insertions(+), 59 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 45d79ea..72f1fe2 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -201,7 +201,7 @@ void apply_alternatives(struct alt_instr *start, struct alt_instr *end)
 	struct alt_instr *a;
 	char insnbuf[MAX_PATCH_LEN];
 
-	DPRINTK("%s: alt table %p -> %p\n", __FUNCTION__, start, end);
+	DPRINTK("%s: alt table %p -> %p\n", __func__, start, end);
 	for (a = start; a < end; a++) {
 		u8 *instr = a->instr;
 		BUG_ON(a->replacementlen > a->instrlen);
@@ -213,7 +213,7 @@ void apply_alternatives(struct alt_instr *start, struct alt_instr *end)
 		if (instr >= (u8 *)VSYSCALL_START && instr < (u8*)VSYSCALL_END) {
 			instr = __va(instr - (u8*)VSYSCALL_START + (u8*)__pa_symbol(&__vsyscall_0));
 			DPRINTK("%s: vsyscall fixup: %p => %p\n",
-				__FUNCTION__, a->instr, instr);
+				__func__, a->instr, instr);
 		}
 #endif
 		memcpy(insnbuf, a->replacement, a->replacementlen);
@@ -303,7 +303,7 @@ void alternatives_smp_module_add(struct module *mod, char *name,
 	smp->text	= text;
 	smp->text_end	= text_end;
 	DPRINTK("%s: locks %p -> %p, text %p -> %p, name %s\n",
-		__FUNCTION__, smp->locks, smp->locks_end,
+		__func__, smp->locks, smp->locks_end,
 		smp->text, smp->text_end, smp->name);
 
 	spin_lock_irqsave(&smp_alt, flags);
@@ -328,7 +328,7 @@ void alternatives_smp_module_del(struct module *mod)
 			continue;
 		list_del(&item->next);
 		spin_unlock_irqrestore(&smp_alt, flags);
-		DPRINTK("%s: %s\n", __FUNCTION__, item->name);
+		DPRINTK("%s: %s\n", __func__, item->name);
 		kfree(item);
 		return;
 	}
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index cef054b..6ea67b7 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -79,7 +79,7 @@ unsigned int do_IRQ(struct pt_regs *regs)
 
 	if (unlikely((unsigned)irq >= NR_IRQS)) {
 		printk(KERN_EMERG "%s: cannot handle IRQ %d\n",
-					__FUNCTION__, irq);
+					__func__, irq);
 		BUG();
 	}
 
diff --git a/arch/x86/kernel/srat_32.c b/arch/x86/kernel/srat_32.c
index b72e613..70e4a37 100644
--- a/arch/x86/kernel/srat_32.c
+++ b/arch/x86/kernel/srat_32.c
@@ -277,14 +277,14 @@ int __init get_memcfg_from_srat(void)
 	rsdp_address = acpi_os_get_root_pointer();
 	if (!rsdp_address) {
 		printk("%s: System description tables not found\n",
-		       __FUNCTION__);
+		       __func__);
 		goto out_err;
 	}
 
-	printk("%s: assigning address to rsdp\n", __FUNCTION__);
+	printk("%s: assigning address to rsdp\n", __func__);
 	rsdp = (struct acpi_table_rsdp *)(u32)rsdp_address;
 	if (!rsdp) {
-		printk("%s: Didn't find ACPI root!\n", __FUNCTION__);
+		printk("%s: Didn't find ACPI root!\n", __func__);
 		goto out_err;
 	}
 
@@ -292,7 +292,7 @@ int __init get_memcfg_from_srat(void)
 		rsdp->oem_id);
 
 	if (strncmp(rsdp->signature, ACPI_SIG_RSDP,strlen(ACPI_SIG_RSDP))) {
-		printk(KERN_WARNING "%s: RSDP table signature incorrect\n", __FUNCTION__);
+		printk(KERN_WARNING "%s: RSDP table signature incorrect\n", __func__);
 		goto out_err;
 	}
 
@@ -302,7 +302,7 @@ int __init get_memcfg_from_srat(void)
 	if (!rsdt) {
 		printk(KERN_WARNING
 		       "%s: ACPI: Invalid root system description tables (RSDT)\n",
-		       __FUNCTION__);
+		       __func__);
 		goto out_err;
 	}
 
diff --git a/arch/x86/kernel/summit_32.c b/arch/x86/kernel/summit_32.c
index c7b579d..30f04c3 100644
--- a/arch/x86/kernel/summit_32.c
+++ b/arch/x86/kernel/summit_32.c
@@ -47,7 +47,7 @@ static int __init setup_pci_node_map_for_wpeg(int wpeg_num, int last_bus)
 		}
 	}
 	if (i == rio_table_hdr->num_rio_dev) {
-		printk(KERN_ERR "%s: Couldn't find owner Cyclone for Winnipeg!\n", __FUNCTION__);
+		printk(KERN_ERR "%s: Couldn't find owner Cyclone for Winnipeg!\n", __func__);
 		return last_bus;
 	}
 
@@ -58,7 +58,7 @@ static int __init setup_pci_node_map_for_wpeg(int wpeg_num, int last_bus)
 		}
 	}
 	if (i == rio_table_hdr->num_scal_dev) {
-		printk(KERN_ERR "%s: Couldn't find owner Twister for Cyclone!\n", __FUNCTION__);
+		printk(KERN_ERR "%s: Couldn't find owner Twister for Cyclone!\n", __func__);
 		return last_bus;
 	}
 
@@ -88,7 +88,7 @@ static int __init setup_pci_node_map_for_wpeg(int wpeg_num, int last_bus)
 		num_buses = 9;
 		break;
 	default:
-		printk(KERN_INFO "%s: Unsupported Winnipeg type!\n", __FUNCTION__);
+		printk(KERN_INFO "%s: Unsupported Winnipeg type!\n", __func__);
 		return last_bus;
 	}
 
@@ -103,13 +103,13 @@ static int __init build_detail_arrays(void)
 	int i, scal_detail_size, rio_detail_size;
 
 	if (rio_table_hdr->num_scal_dev > MAX_NUMNODES) {
-		printk(KERN_WARNING "%s: MAX_NUMNODES too low!  Defined as %d, but system has %d nodes.\n", __FUNCTION__, MAX_NUMNODES, rio_table_hdr->num_scal_dev);
+		printk(KERN_WARNING "%s: MAX_NUMNODES too low!  Defined as %d, but system has %d nodes.\n", __func__, MAX_NUMNODES, rio_table_hdr->num_scal_dev);
 		return 0;
 	}
 
 	switch (rio_table_hdr->version) {
 	default:
-		printk(KERN_WARNING "%s: Invalid Rio Grande Table Version: %d\n", __FUNCTION__, rio_table_hdr->version);
+		printk(KERN_WARNING "%s: Invalid Rio Grande Table Version: %d\n", __func__, rio_table_hdr->version);
 		return 0;
 	case 2:
 		scal_detail_size = 11;
@@ -154,7 +154,7 @@ void __init setup_summit(void)
 		offset = *((unsigned short *)(ptr + offset));
 	}
 	if (!rio_table_hdr) {
-		printk(KERN_ERR "%s: Unable to locate Rio Grande Table in EBDA - bailing!\n", __FUNCTION__);
+		printk(KERN_ERR "%s: Unable to locate Rio Grande Table in EBDA - bailing!\n", __func__);
 		return;
 	}
 
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 2cbee94..fb1b3b6 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -654,7 +654,7 @@ static void start_apic_timer(struct kvm_lapic *apic)
 	apic_debug("%s: bus cycle is %" PRId64 "ns, now 0x%016"
 			   PRIx64 ", "
 			   "timer initial count 0x%x, period %lldns, "
-			   "expire @ 0x%016" PRIx64 ".\n", __FUNCTION__,
+			   "expire @ 0x%016" PRIx64 ".\n", __func__,
 			   APIC_BUS_CYCLE_NS, ktime_to_ns(now),
 			   apic_get_reg(apic, APIC_TMICT),
 			   apic->timer.period,
@@ -687,7 +687,7 @@ static void apic_mmio_write(struct kvm_io_device *this,
 	/* too common printing */
 	if (offset != APIC_EOI)
 		apic_debug("%s: offset 0x%x with length 0x%x, and value is "
-			   "0x%x\n", __FUNCTION__, offset, len, val);
+			   "0x%x\n", __func__, offset, len, val);
 
 	offset &= 0xff0;
 
@@ -865,7 +865,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu)
 	struct kvm_lapic *apic;
 	int i;
 
-	apic_debug("%s\n", __FUNCTION__);
+	apic_debug("%s\n", __func__);
 
 	ASSERT(vcpu);
 	apic = vcpu->arch.apic;
@@ -903,7 +903,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu)
 	apic_update_ppr(apic);
 
 	apic_debug(KERN_INFO "%s: vcpu=%p, id=%d, base_msr="
-		   "0x%016" PRIx64 ", base_address=0x%0lx.\n", __FUNCTION__,
+		   "0x%016" PRIx64 ", base_address=0x%0lx.\n", __func__,
 		   vcpu, kvm_apic_id(apic),
 		   vcpu->arch.apic_base, apic->base_address);
 }
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 8efdcdb..5504bdf 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -540,7 +540,7 @@ static int is_empty_shadow_page(u64 *spt)
 
 	for (pos = spt, end = pos + PAGE_SIZE / sizeof(u64); pos != end; pos++)
 		if ((*pos & ~PT_SHADOW_IO_MARK) != shadow_trap_nonpresent_pte) {
-			printk(KERN_ERR "%s: %p %llx\n", __FUNCTION__,
+			printk(KERN_ERR "%s: %p %llx\n", __func__,
 			       pos, *pos);
 			return 0;
 		}
@@ -663,13 +663,13 @@ static struct kvm_mmu_page *kvm_mmu_lookup_page(struct kvm *kvm, gfn_t gfn)
 	struct kvm_mmu_page *sp;
 	struct hlist_node *node;
 
-	pgprintk("%s: looking for gfn %lx\n", __FUNCTION__, gfn);
+	pgprintk("%s: looking for gfn %lx\n", __func__, gfn);
 	index = kvm_page_table_hashfn(gfn) % KVM_NUM_MMU_PAGES;
 	bucket = &kvm->arch.mmu_page_hash[index];
 	hlist_for_each_entry(sp, node, bucket, hash_link)
 		if (sp->gfn == gfn && !sp->role.metaphysical) {
 			pgprintk("%s: found role %x\n",
-				 __FUNCTION__, sp->role.word);
+				 __func__, sp->role.word);
 			return sp;
 		}
 	return NULL;
@@ -701,21 +701,21 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
 		role.quadrant = quadrant;
 	}
-	pgprintk("%s: looking gfn %lx role %x\n", __FUNCTION__,
+	pgprintk("%s: looking gfn %lx role %x\n", __func__,
 		 gfn, role.word);
 	index = kvm_page_table_hashfn(gfn) % KVM_NUM_MMU_PAGES;
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
@@ -842,13 +842,13 @@ static int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 	struct hlist_node *node, *n;
 	int r;
 
-	pgprintk("%s: looking for gfn %lx\n", __FUNCTION__, gfn);
+	pgprintk("%s: looking for gfn %lx\n", __func__, gfn);
 	r = 0;
 	index = kvm_page_table_hashfn(gfn) % KVM_NUM_MMU_PAGES;
 	bucket = &kvm->arch.mmu_page_hash[index];
 	hlist_for_each_entry_safe(sp, node, n, bucket, hash_link)
 		if (sp->gfn == gfn && !sp->role.metaphysical) {
-			pgprintk("%s: gfn %lx role %x\n", __FUNCTION__, gfn,
+			pgprintk("%s: gfn %lx role %x\n", __func__, gfn,
 				 sp->role.word);
 			kvm_mmu_zap_page(kvm, sp);
 			r = 1;
@@ -861,7 +861,7 @@ static void mmu_unshadow(struct kvm *kvm, gfn_t gfn)
 	struct kvm_mmu_page *sp;
 
 	while ((sp = kvm_mmu_lookup_page(kvm, gfn)) != NULL) {
-		pgprintk("%s: zap %lx %x\n", __FUNCTION__, gfn, sp->role.word);
+		pgprintk("%s: zap %lx %x\n", __func__, gfn, sp->role.word);
 		kvm_mmu_zap_page(kvm, sp);
 	}
 }
@@ -894,7 +894,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 
 	pgprintk("%s: spte %llx access %x write_fault %d"
 		 " user_fault %d gfn %lx\n",
-		 __FUNCTION__, *shadow_pte, pt_access,
+		 __func__, *shadow_pte, pt_access,
 		 write_fault, user_fault, gfn);
 
 	/*
@@ -934,7 +934,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 		shadow = kvm_mmu_lookup_page(vcpu->kvm, gfn);
 		if (shadow) {
 			pgprintk("%s: found shadow page for %lx, marking ro\n",
-				 __FUNCTION__, gfn);
+				 __func__, gfn);
 			pte_access &= ~ACC_WRITE_MASK;
 			if (is_writeble_pte(spte)) {
 				spte &= ~PT_WRITABLE_MASK;
@@ -950,7 +950,7 @@ unshadowed:
 	if (pte_access & ACC_WRITE_MASK)
 		mark_page_dirty(vcpu->kvm, gfn);
 
-	pgprintk("%s: setting spte %llx\n", __FUNCTION__, spte);
+	pgprintk("%s: setting spte %llx\n", __func__, spte);
 	set_shadow_pte(shadow_pte, spte);
 	page_header_update_slot(vcpu->kvm, shadow_pte, gfn);
 	if (!was_rmapped) {
@@ -1130,7 +1130,7 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 	gfn_t gfn;
 	int r;
 
-	pgprintk("%s: gva %lx error %x\n", __FUNCTION__, gva, error_code);
+	pgprintk("%s: gva %lx error %x\n", __func__, gva, error_code);
 	r = mmu_topup_memory_caches(vcpu);
 	if (r)
 		return r;
@@ -1172,7 +1172,7 @@ void kvm_mmu_flush_tlb(struct kvm_vcpu *vcpu)
 
 static void paging_new_cr3(struct kvm_vcpu *vcpu)
 {
-	pgprintk("%s: cr3 %lx\n", __FUNCTION__, vcpu->cr3);
+	pgprintk("%s: cr3 %lx\n", __func__, vcpu->cr3);
 	mmu_free_roots(vcpu);
 }
 
@@ -1412,7 +1412,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	int flooded = 0;
 	int npte;
 
-	pgprintk("%s: gpa %llx bytes %d\n", __FUNCTION__, gpa, bytes);
+	pgprintk("%s: gpa %llx bytes %d\n", __func__, gpa, bytes);
 	mmu_guess_page_from_pte_write(vcpu, gpa, new, bytes);
 	spin_lock(&vcpu->kvm->mmu_lock);
 	kvm_mmu_free_some_pages(vcpu);
@@ -1845,7 +1845,7 @@ static void audit_rmap(struct kvm_vcpu *vcpu)
 
 	if (n_rmap != n_actual)
 		printk(KERN_ERR "%s: (%s) rmap %d actual %d\n",
-		       __FUNCTION__, audit_msg, n_rmap, n_actual);
+		       __func__, audit_msg, n_rmap, n_actual);
 }
 
 static void audit_write_protection(struct kvm_vcpu *vcpu)
@@ -1865,7 +1865,7 @@ static void audit_write_protection(struct kvm_vcpu *vcpu)
 		if (*rmapp)
 			printk(KERN_ERR "%s: (%s) shadow page has writable"
 			       " mappings: gfn %lx role %x\n",
-			       __FUNCTION__, audit_msg, sp->gfn,
+			       __func__, audit_msg, sp->gfn,
 			       sp->role.word);
 	}
 }
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 03ba860..84ef21b 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -127,7 +127,7 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 	unsigned index, pt_access, pte_access;
 	gpa_t pte_gpa;
 
-	pgprintk("%s: addr %lx\n", __FUNCTION__, addr);
+	pgprintk("%s: addr %lx\n", __func__, addr);
 walk:
 	walker->level = vcpu->arch.mmu.root_level;
 	pte = vcpu->arch.cr3;
@@ -152,7 +152,7 @@ walk:
 		pte_gpa += index * sizeof(pt_element_t);
 		walker->table_gfn[walker->level - 1] = table_gfn;
 		walker->pte_gpa[walker->level - 1] = pte_gpa;
-		pgprintk("%s: table_gfn[%d] %lx\n", __FUNCTION__,
+		pgprintk("%s: table_gfn[%d] %lx\n", __func__,
 			 walker->level - 1, table_gfn);
 
 		kvm_read_guest(vcpu->kvm, pte_gpa, &pte, sizeof(pte));
@@ -219,7 +219,7 @@ walk:
 	walker->pt_access = pt_access;
 	walker->pte_access = pte_access;
 	pgprintk("%s: pte %llx pte_access %x pt_access %x\n",
-		 __FUNCTION__, (u64)pte, pt_access, pte_access);
+		 __func__, (u64)pte, pt_access, pte_access);
 	return 1;
 
 not_present:
@@ -255,7 +255,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 	}
 	if (bytes < sizeof(pt_element_t))
 		return;
-	pgprintk("%s: gpte %llx spte %p\n", __FUNCTION__, (u64)gpte, spte);
+	pgprintk("%s: gpte %llx spte %p\n", __func__, (u64)gpte, spte);
 	pte_access = page->role.access & FNAME(gpte_access)(vcpu, gpte);
 	if (gpte_to_gfn(gpte) != vcpu->arch.update_pte.gfn)
 		return;
@@ -371,7 +371,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 	int r;
 	struct page *page;
 
-	pgprintk("%s: addr %lx err %x\n", __FUNCTION__, addr, error_code);
+	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
 	kvm_mmu_audit(vcpu, "pre page fault");
 
 	r = mmu_topup_memory_caches(vcpu);
@@ -389,7 +389,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 	 * The page is not mapped by the guest.  Let the guest handle it.
 	 */
 	if (!r) {
-		pgprintk("%s: guest page fault\n", __FUNCTION__);
+		pgprintk("%s: guest page fault\n", __func__);
 		inject_page_fault(vcpu, addr, walker.error_code);
 		vcpu->arch.last_pt_write_count = 0; /* reset fork detector */
 		up_read(&current->mm->mmap_sem);
@@ -402,7 +402,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 	kvm_mmu_free_some_pages(vcpu);
 	shadow_pte = FNAME(fetch)(vcpu, addr, &walker, user_fault, write_fault,
 				  &write_pt, page);
-	pgprintk("%s: shadow pte %p %llx ptwrite %d\n", __FUNCTION__,
+	pgprintk("%s: shadow pte %p %llx ptwrite %d\n", __func__,
 		 shadow_pte, *shadow_pte, write_pt);
 
 	if (!write_pt)
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index de755cb..a528800 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -219,12 +219,12 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
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
 
@@ -916,7 +916,7 @@ static void svm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long value,
 	}
 	default:
 		printk(KERN_DEBUG "%s: unexpected dr %u\n",
-		       __FUNCTION__, dr);
+		       __func__, dr);
 		*exception = UD_VECTOR;
 		return;
 	}
@@ -1029,7 +1029,7 @@ static int invalid_op_interception(struct vcpu_svm *svm,
 static int task_switch_interception(struct vcpu_svm *svm,
 				    struct kvm_run *kvm_run)
 {
-	pr_unimpl(&svm->vcpu, "%s: task switch is unsupported\n", __FUNCTION__);
+	pr_unimpl(&svm->vcpu, "%s: task switch is unsupported\n", __func__);
 	kvm_run->exit_reason = KVM_EXIT_UNKNOWN;
 	return 0;
 }
@@ -1045,7 +1045,7 @@ static int emulate_on_interception(struct vcpu_svm *svm,
 				   struct kvm_run *kvm_run)
 {
 	if (emulate_instruction(&svm->vcpu, NULL, 0, 0, 0) != EMULATE_DONE)
-		pr_unimpl(&svm->vcpu, "%s: failed\n", __FUNCTION__);
+		pr_unimpl(&svm->vcpu, "%s: failed\n", __func__);
 	return 1;
 }
 
@@ -1285,7 +1285,7 @@ static int handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 	    exit_code != SVM_EXIT_EXCP_BASE + PF_VECTOR)
 		printk(KERN_ERR "%s: unexpected exit_ini_info 0x%x "
 		       "exit_code 0x%x\n",
-		       __FUNCTION__, svm->vmcb->control.exit_int_info,
+		       __func__, svm->vmcb->control.exit_int_info,
 		       exit_code);
 
 	if (exit_code >= ARRAY_SIZE(svm_exit_handlers)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index ad36447..99a99a3 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1216,7 +1216,7 @@ static void enter_lmode(struct kvm_vcpu *vcpu)
 	guest_tr_ar = vmcs_read32(GUEST_TR_AR_BYTES);
 	if ((guest_tr_ar & AR_TYPE_MASK) != AR_TYPE_BUSY_64_TSS) {
 		printk(KERN_DEBUG "%s: tss fixup for long mode. \n",
-		       __FUNCTION__);
+		       __func__);
 		vmcs_write32(GUEST_TR_AR_BYTES,
 			     (guest_tr_ar & ~AR_TYPE_MASK)
 			     | AR_TYPE_BUSY_64_TSS);
@@ -1846,7 +1846,7 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	if ((vect_info & VECTORING_INFO_VALID_MASK) &&
 						!is_page_fault(intr_info))
 		printk(KERN_ERR "%s: unexpected, vectoring info 0x%x "
-		       "intr info 0x%x\n", __FUNCTION__, vect_info, intr_info);
+		       "intr info 0x%x\n", __func__, vect_info, intr_info);
 
 	if (!irqchip_in_kernel(vcpu->kvm) && is_external_interrupt(vect_info)) {
 		int irq = vect_info & VECTORING_INFO_VECTOR_MASK;
@@ -2212,7 +2212,7 @@ static int kvm_handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 	if ((vectoring_info & VECTORING_INFO_VALID_MASK) &&
 				exit_reason != EXIT_REASON_EXCEPTION_NMI)
 		printk(KERN_WARNING "%s: unexpected, valid vectoring info and "
-		       "exit reason is 0x%x\n", __FUNCTION__, exit_reason);
+		       "exit reason is 0x%x\n", __func__, exit_reason);
 	if (exit_reason < kvm_vmx_max_exit_handlers
 	    && kvm_vmx_exit_handlers[exit_reason])
 		return kvm_vmx_exit_handlers[exit_reason](vcpu, kvm_run);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cf53081..4a79fcb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -478,11 +478,11 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 #endif
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
 	case MSR_IA32_UCODE_REV:
 	case MSR_IA32_UCODE_WRITE:
@@ -1791,7 +1791,7 @@ int emulator_get_dr(struct x86_emulate_ctxt *ctxt, int dr, unsigned long *dest)
 		*dest = kvm_x86_ops->get_dr(vcpu, dr);
 		return X86EMUL_CONTINUE;
 	default:
-		pr_unimpl(vcpu, "%s: unexpected dr %u\n", __FUNCTION__, dr);
+		pr_unimpl(vcpu, "%s: unexpected dr %u\n", __func__, dr);
 		return X86EMUL_UNHANDLEABLE;
 	}
 }
@@ -2337,7 +2337,7 @@ unsigned long realmode_get_cr(struct kvm_vcpu *vcpu, int cr)
 	case 8:
 		return get_cr8(vcpu);
 	default:
-		vcpu_printf(vcpu, "%s: unexpected cr %u\n", __FUNCTION__, cr);
+		vcpu_printf(vcpu, "%s: unexpected cr %u\n", __func__, cr);
 		return 0;
 	}
 }
@@ -2363,7 +2363,7 @@ void realmode_set_cr(struct kvm_vcpu *vcpu, int cr, unsigned long val,
 		set_cr8(vcpu, val & 0xfUL);
 		break;
 	default:
-		vcpu_printf(vcpu, "%s: unexpected cr %u\n", __FUNCTION__, cr);
+		vcpu_printf(vcpu, "%s: unexpected cr %u\n", __func__, cr);
 	}
 }
 
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index cccb38a..3f7ae8e 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -652,7 +652,7 @@ static int lguest_clockevent_set_next_event(unsigned long delta,
 	if (delta < LG_CLOCK_MIN_DELTA) {
 		if (printk_ratelimit())
 			printk(KERN_DEBUG "%s: small delta %lu ns\n",
-			       __FUNCTION__, delta);
+			       __func__, delta);
 		return -ETIME;
 	}
 	hcall(LHCALL_SET_CLOCKEVENT, delta, 0, 0);
-- 
1.5.4.3.500.g83a2c



