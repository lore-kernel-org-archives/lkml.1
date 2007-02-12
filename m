Return-Path: <linux-kernel-owner+w=401wt.eu-S965008AbXBLQ7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965008AbXBLQ7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:59:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964984AbXBLQ5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:57:13 -0500
Received: from mx1.suse.de ([195.135.220.2]:47942 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964988AbXBLQvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:51:38 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212551.664370000@suse.de>
In-Reply-To: <20070212551.664370000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review III] [16/29] i386: Remove fastcall in paravirt.[ch]
Message-Id: <20070212165136.9F73213E1B@wotan.suse.de>
Date: Mon, 12 Feb 2007 17:51:36 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Not needed because fastcall is always default now

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/paravirt.c |  102 ++++++++++++++++-----------------
 include/asm-i386/paravirt.h |  136 ++++++++++++++++++++++----------------------
 2 files changed, 119 insertions(+), 119 deletions(-)

Index: linux/arch/i386/kernel/paravirt.c
===================================================================
--- linux.orig/arch/i386/kernel/paravirt.c
+++ linux/arch/i386/kernel/paravirt.c
@@ -92,7 +92,7 @@ static unsigned native_patch(u8 type, u1
 	return insn_len;
 }
 
-static fastcall unsigned long native_get_debugreg(int regno)
+static unsigned long native_get_debugreg(int regno)
 {
 	unsigned long val = 0; 	/* Damn you, gcc! */
 
@@ -115,7 +115,7 @@ static fastcall unsigned long native_get
 	return val;
 }
 
-static fastcall void native_set_debugreg(int regno, unsigned long value)
+static void native_set_debugreg(int regno, unsigned long value)
 {
 	switch (regno) {
 	case 0:
@@ -146,55 +146,55 @@ void init_IRQ(void)
 	paravirt_ops.init_IRQ();
 }
 
-static fastcall void native_clts(void)
+static void native_clts(void)
 {
 	asm volatile ("clts");
 }
 
-static fastcall unsigned long native_read_cr0(void)
+static unsigned long native_read_cr0(void)
 {
 	unsigned long val;
 	asm volatile("movl %%cr0,%0\n\t" :"=r" (val));
 	return val;
 }
 
-static fastcall void native_write_cr0(unsigned long val)
+static void native_write_cr0(unsigned long val)
 {
 	asm volatile("movl %0,%%cr0": :"r" (val));
 }
 
-static fastcall unsigned long native_read_cr2(void)
+static unsigned long native_read_cr2(void)
 {
 	unsigned long val;
 	asm volatile("movl %%cr2,%0\n\t" :"=r" (val));
 	return val;
 }
 
-static fastcall void native_write_cr2(unsigned long val)
+static void native_write_cr2(unsigned long val)
 {
 	asm volatile("movl %0,%%cr2": :"r" (val));
 }
 
-static fastcall unsigned long native_read_cr3(void)
+static unsigned long native_read_cr3(void)
 {
 	unsigned long val;
 	asm volatile("movl %%cr3,%0\n\t" :"=r" (val));
 	return val;
 }
 
-static fastcall void native_write_cr3(unsigned long val)
+static void native_write_cr3(unsigned long val)
 {
 	asm volatile("movl %0,%%cr3": :"r" (val));
 }
 
-static fastcall unsigned long native_read_cr4(void)
+static unsigned long native_read_cr4(void)
 {
 	unsigned long val;
 	asm volatile("movl %%cr4,%0\n\t" :"=r" (val));
 	return val;
 }
 
-static fastcall unsigned long native_read_cr4_safe(void)
+static unsigned long native_read_cr4_safe(void)
 {
 	unsigned long val;
 	/* This could fault if %cr4 does not exist */
@@ -207,51 +207,51 @@ static fastcall unsigned long native_rea
 	return val;
 }
 
-static fastcall void native_write_cr4(unsigned long val)
+static void native_write_cr4(unsigned long val)
 {
 	asm volatile("movl %0,%%cr4": :"r" (val));
 }
 
-static fastcall unsigned long native_save_fl(void)
+static unsigned long native_save_fl(void)
 {
 	unsigned long f;
 	asm volatile("pushfl ; popl %0":"=g" (f): /* no input */);
 	return f;
 }
 
-static fastcall void native_restore_fl(unsigned long f)
+static void native_restore_fl(unsigned long f)
 {
 	asm volatile("pushl %0 ; popfl": /* no output */
 			     :"g" (f)
 			     :"memory", "cc");
 }
 
-static fastcall void native_irq_disable(void)
+static void native_irq_disable(void)
 {
 	asm volatile("cli": : :"memory");
 }
 
-static fastcall void native_irq_enable(void)
+static void native_irq_enable(void)
 {
 	asm volatile("sti": : :"memory");
 }
 
-static fastcall void native_safe_halt(void)
+static void native_safe_halt(void)
 {
 	asm volatile("sti; hlt": : :"memory");
 }
 
-static fastcall void native_halt(void)
+static void native_halt(void)
 {
 	asm volatile("hlt": : :"memory");
 }
 
-static fastcall void native_wbinvd(void)
+static void native_wbinvd(void)
 {
 	asm volatile("wbinvd": : :"memory");
 }
 
-static fastcall unsigned long long native_read_msr(unsigned int msr, int *err)
+static unsigned long long native_read_msr(unsigned int msr, int *err)
 {
 	unsigned long long val;
 
@@ -270,7 +270,7 @@ static fastcall unsigned long long nativ
 	return val;
 }
 
-static fastcall int native_write_msr(unsigned int msr, unsigned long long val)
+static int native_write_msr(unsigned int msr, unsigned long long val)
 {
 	int err;
 	asm volatile("2: wrmsr ; xorl %0,%0\n"
@@ -288,53 +288,53 @@ static fastcall int native_write_msr(uns
 	return err;
 }
 
-static fastcall unsigned long long native_read_tsc(void)
+static unsigned long long native_read_tsc(void)
 {
 	unsigned long long val;
 	asm volatile("rdtsc" : "=A" (val));
 	return val;
 }
 
-static fastcall unsigned long long native_read_pmc(void)
+static unsigned long long native_read_pmc(void)
 {
 	unsigned long long val;
 	asm volatile("rdpmc" : "=A" (val));
 	return val;
 }
 
-static fastcall void native_load_tr_desc(void)
+static void native_load_tr_desc(void)
 {
 	asm volatile("ltr %w0"::"q" (GDT_ENTRY_TSS*8));
 }
 
-static fastcall void native_load_gdt(const struct Xgt_desc_struct *dtr)
+static void native_load_gdt(const struct Xgt_desc_struct *dtr)
 {
 	asm volatile("lgdt %0"::"m" (*dtr));
 }
 
-static fastcall void native_load_idt(const struct Xgt_desc_struct *dtr)
+static void native_load_idt(const struct Xgt_desc_struct *dtr)
 {
 	asm volatile("lidt %0"::"m" (*dtr));
 }
 
-static fastcall void native_store_gdt(struct Xgt_desc_struct *dtr)
+static void native_store_gdt(struct Xgt_desc_struct *dtr)
 {
 	asm ("sgdt %0":"=m" (*dtr));
 }
 
-static fastcall void native_store_idt(struct Xgt_desc_struct *dtr)
+static void native_store_idt(struct Xgt_desc_struct *dtr)
 {
 	asm ("sidt %0":"=m" (*dtr));
 }
 
-static fastcall unsigned long native_store_tr(void)
+static unsigned long native_store_tr(void)
 {
 	unsigned long tr;
 	asm ("str %0":"=r" (tr));
 	return tr;
 }
 
-static fastcall void native_load_tls(struct thread_struct *t, unsigned int cpu)
+static void native_load_tls(struct thread_struct *t, unsigned int cpu)
 {
 #define C(i) get_cpu_gdt_table(cpu)[GDT_ENTRY_TLS_MIN + i] = t->tls_array[i]
 	C(0); C(1); C(2);
@@ -348,22 +348,22 @@ static inline void native_write_dt_entry
 	lp[1] = entry_high;
 }
 
-static fastcall void native_write_ldt_entry(void *dt, int entrynum, u32 low, u32 high)
+static void native_write_ldt_entry(void *dt, int entrynum, u32 low, u32 high)
 {
 	native_write_dt_entry(dt, entrynum, low, high);
 }
 
-static fastcall void native_write_gdt_entry(void *dt, int entrynum, u32 low, u32 high)
+static void native_write_gdt_entry(void *dt, int entrynum, u32 low, u32 high)
 {
 	native_write_dt_entry(dt, entrynum, low, high);
 }
 
-static fastcall void native_write_idt_entry(void *dt, int entrynum, u32 low, u32 high)
+static void native_write_idt_entry(void *dt, int entrynum, u32 low, u32 high)
 {
 	native_write_dt_entry(dt, entrynum, low, high);
 }
 
-static fastcall void native_load_esp0(struct tss_struct *tss,
+static void native_load_esp0(struct tss_struct *tss,
 				      struct thread_struct *thread)
 {
 	tss->esp0 = thread->esp0;
@@ -375,12 +375,12 @@ static fastcall void native_load_esp0(st
 	}
 }
 
-static fastcall void native_io_delay(void)
+static void native_io_delay(void)
 {
 	asm volatile("outb %al,$0x80");
 }
 
-static fastcall void native_flush_tlb(void)
+static void native_flush_tlb(void)
 {
 	__native_flush_tlb();
 }
@@ -389,49 +389,49 @@ static fastcall void native_flush_tlb(vo
  * Global pages have to be flushed a bit differently. Not a real
  * performance problem because this does not happen often.
  */
-static fastcall void native_flush_tlb_global(void)
+static void native_flush_tlb_global(void)
 {
 	__native_flush_tlb_global();
 }
 
-static fastcall void native_flush_tlb_single(u32 addr)
+static void native_flush_tlb_single(u32 addr)
 {
 	__native_flush_tlb_single(addr);
 }
 
 #ifndef CONFIG_X86_PAE
-static fastcall void native_set_pte(pte_t *ptep, pte_t pteval)
+static void native_set_pte(pte_t *ptep, pte_t pteval)
 {
 	*ptep = pteval;
 }
 
-static fastcall void native_set_pte_at(struct mm_struct *mm, u32 addr, pte_t *ptep, pte_t pteval)
+static void native_set_pte_at(struct mm_struct *mm, u32 addr, pte_t *ptep, pte_t pteval)
 {
 	*ptep = pteval;
 }
 
-static fastcall void native_set_pmd(pmd_t *pmdp, pmd_t pmdval)
+static void native_set_pmd(pmd_t *pmdp, pmd_t pmdval)
 {
 	*pmdp = pmdval;
 }
 
 #else /* CONFIG_X86_PAE */
 
-static fastcall void native_set_pte(pte_t *ptep, pte_t pte)
+static void native_set_pte(pte_t *ptep, pte_t pte)
 {
 	ptep->pte_high = pte.pte_high;
 	smp_wmb();
 	ptep->pte_low = pte.pte_low;
 }
 
-static fastcall void native_set_pte_at(struct mm_struct *mm, u32 addr, pte_t *ptep, pte_t pte)
+static void native_set_pte_at(struct mm_struct *mm, u32 addr, pte_t *ptep, pte_t pte)
 {
 	ptep->pte_high = pte.pte_high;
 	smp_wmb();
 	ptep->pte_low = pte.pte_low;
 }
 
-static fastcall void native_set_pte_present(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte)
+static void native_set_pte_present(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte)
 {
 	ptep->pte_low = 0;
 	smp_wmb();
@@ -440,29 +440,29 @@ static fastcall void native_set_pte_pres
 	ptep->pte_low = pte.pte_low;
 }
 
-static fastcall void native_set_pte_atomic(pte_t *ptep, pte_t pteval)
+static void native_set_pte_atomic(pte_t *ptep, pte_t pteval)
 {
 	set_64bit((unsigned long long *)ptep,pte_val(pteval));
 }
 
-static fastcall void native_set_pmd(pmd_t *pmdp, pmd_t pmdval)
+static void native_set_pmd(pmd_t *pmdp, pmd_t pmdval)
 {
 	set_64bit((unsigned long long *)pmdp,pmd_val(pmdval));
 }
 
-static fastcall void native_set_pud(pud_t *pudp, pud_t pudval)
+static void native_set_pud(pud_t *pudp, pud_t pudval)
 {
 	*pudp = pudval;
 }
 
-static fastcall void native_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+static void native_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
 	ptep->pte_low = 0;
 	smp_wmb();
 	ptep->pte_high = 0;
 }
 
-static fastcall void native_pmd_clear(pmd_t *pmd)
+static void native_pmd_clear(pmd_t *pmd)
 {
 	u32 *tmp = (u32 *)pmd;
 	*tmp = 0;
@@ -472,8 +472,8 @@ static fastcall void native_pmd_clear(pm
 #endif /* CONFIG_X86_PAE */
 
 /* These are in entry.S */
-extern fastcall void native_iret(void);
-extern fastcall void native_irq_enable_sysexit(void);
+extern void native_iret(void);
+extern void native_irq_enable_sysexit(void);
 
 static int __init print_banner(void)
 {
Index: linux/include/asm-i386/paravirt.h
===================================================================
--- linux.orig/include/asm-i386/paravirt.h
+++ linux/include/asm-i386/paravirt.h
@@ -59,102 +59,102 @@ struct paravirt_ops
 	   convention.  This makes it easier to implement inline
 	   assembler replacements. */
 
-	void (fastcall *cpuid)(unsigned int *eax, unsigned int *ebx,
+	void (*cpuid)(unsigned int *eax, unsigned int *ebx,
 		      unsigned int *ecx, unsigned int *edx);
 
-	unsigned long (fastcall *get_debugreg)(int regno);
-	void (fastcall *set_debugreg)(int regno, unsigned long value);
+	unsigned long (*get_debugreg)(int regno);
+	void (*set_debugreg)(int regno, unsigned long value);
 
-	void (fastcall *clts)(void);
+	void (*clts)(void);
 
-	unsigned long (fastcall *read_cr0)(void);
-	void (fastcall *write_cr0)(unsigned long);
+	unsigned long (*read_cr0)(void);
+	void (*write_cr0)(unsigned long);
 
-	unsigned long (fastcall *read_cr2)(void);
-	void (fastcall *write_cr2)(unsigned long);
-
-	unsigned long (fastcall *read_cr3)(void);
-	void (fastcall *write_cr3)(unsigned long);
-
-	unsigned long (fastcall *read_cr4_safe)(void);
-	unsigned long (fastcall *read_cr4)(void);
-	void (fastcall *write_cr4)(unsigned long);
-
-	unsigned long (fastcall *save_fl)(void);
-	void (fastcall *restore_fl)(unsigned long);
-	void (fastcall *irq_disable)(void);
-	void (fastcall *irq_enable)(void);
-	void (fastcall *safe_halt)(void);
-	void (fastcall *halt)(void);
-	void (fastcall *wbinvd)(void);
+	unsigned long (*read_cr2)(void);
+	void (*write_cr2)(unsigned long);
+
+	unsigned long (*read_cr3)(void);
+	void (*write_cr3)(unsigned long);
+
+	unsigned long (*read_cr4_safe)(void);
+	unsigned long (*read_cr4)(void);
+	void (*write_cr4)(unsigned long);
+
+	unsigned long (*save_fl)(void);
+	void (*restore_fl)(unsigned long);
+	void (*irq_disable)(void);
+	void (*irq_enable)(void);
+	void (*safe_halt)(void);
+	void (*halt)(void);
+	void (*wbinvd)(void);
 
 	/* err = 0/-EFAULT.  wrmsr returns 0/-EFAULT. */
-	u64 (fastcall *read_msr)(unsigned int msr, int *err);
-	int (fastcall *write_msr)(unsigned int msr, u64 val);
+	u64 (*read_msr)(unsigned int msr, int *err);
+	int (*write_msr)(unsigned int msr, u64 val);
 
-	u64 (fastcall *read_tsc)(void);
-	u64 (fastcall *read_pmc)(void);
+	u64 (*read_tsc)(void);
+	u64 (*read_pmc)(void);
 
-	void (fastcall *load_tr_desc)(void);
-	void (fastcall *load_gdt)(const struct Xgt_desc_struct *);
-	void (fastcall *load_idt)(const struct Xgt_desc_struct *);
-	void (fastcall *store_gdt)(struct Xgt_desc_struct *);
-	void (fastcall *store_idt)(struct Xgt_desc_struct *);
-	void (fastcall *set_ldt)(const void *desc, unsigned entries);
-	unsigned long (fastcall *store_tr)(void);
-	void (fastcall *load_tls)(struct thread_struct *t, unsigned int cpu);
-	void (fastcall *write_ldt_entry)(void *dt, int entrynum,
+	void (*load_tr_desc)(void);
+	void (*load_gdt)(const struct Xgt_desc_struct *);
+	void (*load_idt)(const struct Xgt_desc_struct *);
+	void (*store_gdt)(struct Xgt_desc_struct *);
+	void (*store_idt)(struct Xgt_desc_struct *);
+	void (*set_ldt)(const void *desc, unsigned entries);
+	unsigned long (*store_tr)(void);
+	void (*load_tls)(struct thread_struct *t, unsigned int cpu);
+	void (*write_ldt_entry)(void *dt, int entrynum,
 					 u32 low, u32 high);
-	void (fastcall *write_gdt_entry)(void *dt, int entrynum,
+	void (*write_gdt_entry)(void *dt, int entrynum,
 					 u32 low, u32 high);
-	void (fastcall *write_idt_entry)(void *dt, int entrynum,
+	void (*write_idt_entry)(void *dt, int entrynum,
 					 u32 low, u32 high);
-	void (fastcall *load_esp0)(struct tss_struct *tss,
+	void (*load_esp0)(struct tss_struct *tss,
 				   struct thread_struct *thread);
 
-	void (fastcall *set_iopl_mask)(unsigned mask);
+	void (*set_iopl_mask)(unsigned mask);
 
-	void (fastcall *io_delay)(void);
+	void (*io_delay)(void);
 	void (*const_udelay)(unsigned long loops);
 
 #ifdef CONFIG_X86_LOCAL_APIC
-	void (fastcall *apic_write)(unsigned long reg, unsigned long v);
-	void (fastcall *apic_write_atomic)(unsigned long reg, unsigned long v);
-	unsigned long (fastcall *apic_read)(unsigned long reg);
+	void (*apic_write)(unsigned long reg, unsigned long v);
+	void (*apic_write_atomic)(unsigned long reg, unsigned long v);
+	unsigned long (*apic_read)(unsigned long reg);
 	void (*setup_boot_clock)(void);
 	void (*setup_secondary_clock)(void);
 #endif
 
-	void (fastcall *flush_tlb_user)(void);
-	void (fastcall *flush_tlb_kernel)(void);
-	void (fastcall *flush_tlb_single)(u32 addr);
-
-	void (fastcall *alloc_pt)(u32 pfn);
-	void (fastcall *alloc_pd)(u32 pfn);
-	void (fastcall *alloc_pd_clone)(u32 pfn, u32 clonepfn, u32 start, u32 count);
-	void (fastcall *release_pt)(u32 pfn);
-	void (fastcall *release_pd)(u32 pfn);
-
-	void (fastcall *set_pte)(pte_t *ptep, pte_t pteval);
-	void (fastcall *set_pte_at)(struct mm_struct *mm, u32 addr, pte_t *ptep, pte_t pteval);
-	void (fastcall *set_pmd)(pmd_t *pmdp, pmd_t pmdval);
-	void (fastcall *pte_update)(struct mm_struct *mm, u32 addr, pte_t *ptep);
-	void (fastcall *pte_update_defer)(struct mm_struct *mm, u32 addr, pte_t *ptep);
+	void (*flush_tlb_user)(void);
+	void (*flush_tlb_kernel)(void);
+	void (*flush_tlb_single)(u32 addr);
+
+	void (*alloc_pt)(u32 pfn);
+	void (*alloc_pd)(u32 pfn);
+	void (*alloc_pd_clone)(u32 pfn, u32 clonepfn, u32 start, u32 count);
+	void (*release_pt)(u32 pfn);
+	void (*release_pd)(u32 pfn);
+
+	void (*set_pte)(pte_t *ptep, pte_t pteval);
+	void (*set_pte_at)(struct mm_struct *mm, u32 addr, pte_t *ptep, pte_t pteval);
+	void (*set_pmd)(pmd_t *pmdp, pmd_t pmdval);
+	void (*pte_update)(struct mm_struct *mm, u32 addr, pte_t *ptep);
+	void (*pte_update_defer)(struct mm_struct *mm, u32 addr, pte_t *ptep);
 #ifdef CONFIG_X86_PAE
-	void (fastcall *set_pte_atomic)(pte_t *ptep, pte_t pteval);
-	void (fastcall *set_pte_present)(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte);
-	void (fastcall *set_pud)(pud_t *pudp, pud_t pudval);
-	void (fastcall *pte_clear)(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
-	void (fastcall *pmd_clear)(pmd_t *pmdp);
+	void (*set_pte_atomic)(pte_t *ptep, pte_t pteval);
+	void (*set_pte_present)(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte);
+	void (*set_pud)(pud_t *pudp, pud_t pudval);
+	void (*pte_clear)(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
+	void (*pmd_clear)(pmd_t *pmdp);
 #endif
 
-	void (fastcall *set_lazy_mode)(int mode);
+	void (*set_lazy_mode)(int mode);
 
 	/* These two are jmp to, not actually called. */
-	void (fastcall *irq_enable_sysexit)(void);
-	void (fastcall *iret)(void);
+	void (*irq_enable_sysexit)(void);
+	void (*iret)(void);
 
-	void (fastcall *startup_ipi_hook)(int phys_apicid, unsigned long start_eip, unsigned long start_esp);
+	void (*startup_ipi_hook)(int phys_apicid, unsigned long start_eip, unsigned long start_esp);
 };
 
 /* Mark a paravirt probe function. */
