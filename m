Return-Path: <linux-kernel-owner+w=401wt.eu-S1759265AbXLWPDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265AbXLWPDO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 10:03:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbXLWOwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:52:20 -0500
Received: from il.qumranet.com ([82.166.9.18]:35923 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753466AbXLWOvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:45 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Mike Day <ncmike@ncultra.org>
Subject: [PATCH 26/50] KVM: CodingStyle cleanup
Date: Sun, 23 Dec 2007 16:51:11 +0200
Message-Id: <1198421495-31481-27-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Day <ncmike@ncultra.org>

Signed-off-by: Mike D. Day <ncmike@ncultra.org>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h         |   32 +++++++++---------
 drivers/kvm/kvm_main.c    |   58 ++++++++++++++++++----------------
 drivers/kvm/lapic.c       |    3 +-
 drivers/kvm/mmu.c         |   10 +++--
 drivers/kvm/paging_tmpl.h |    2 +-
 drivers/kvm/svm.c         |   48 +++++++++++++---------------
 drivers/kvm/svm.h         |    2 +-
 drivers/kvm/vmx.c         |   60 +++++++++++++++++++----------------
 drivers/kvm/vmx.h         |    8 ++--
 drivers/kvm/x86_emulate.c |   76 ++++++++++++++++++++++-----------------------
 10 files changed, 151 insertions(+), 148 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 9f10c37..ec5b498 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -528,7 +528,7 @@ extern struct kvm_x86_ops *kvm_x86_ops;
 	if (printk_ratelimit())						\
 		printk(KERN_ERR "kvm: %i: cpu%i " fmt,			\
 		       current->tgid, (vcpu)->vcpu_id , ## __VA_ARGS__); \
- } while(0)
+ } while (0)
 
 #define kvm_printf(kvm, fmt ...) printk(KERN_DEBUG fmt)
 #define vcpu_printf(vcpu, fmt...) kvm_printf(vcpu->kvm, fmt)
@@ -598,7 +598,7 @@ int kvm_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
 
 struct x86_emulate_ctxt;
 
-int kvm_emulate_pio (struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
+int kvm_emulate_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 		     int size, unsigned port);
 int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 			   int size, unsigned long count, int down,
@@ -607,7 +607,7 @@ void kvm_emulate_cpuid(struct kvm_vcpu *vcpu);
 int kvm_emulate_halt(struct kvm_vcpu *vcpu);
 int emulate_invlpg(struct kvm_vcpu *vcpu, gva_t address);
 int emulate_clts(struct kvm_vcpu *vcpu);
-int emulator_get_dr(struct x86_emulate_ctxt* ctxt, int dr,
+int emulator_get_dr(struct x86_emulate_ctxt *ctxt, int dr,
 		    unsigned long *dest);
 int emulator_set_dr(struct x86_emulate_ctxt *ctxt, int dr,
 		    unsigned long value);
@@ -631,7 +631,7 @@ void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
 void kvm_flush_remote_tlbs(struct kvm *kvm);
 
 int emulator_read_std(unsigned long addr,
-                      void *val,
+		      void *val,
 		      unsigned int bytes,
 		      struct kvm_vcpu *vcpu);
 int emulator_write_emulated(unsigned long addr,
@@ -721,55 +721,55 @@ static inline struct kvm_mmu_page *page_header(hpa_t shadow_page)
 static inline u16 read_fs(void)
 {
 	u16 seg;
-	asm ("mov %%fs, %0" : "=g"(seg));
+	asm("mov %%fs, %0" : "=g"(seg));
 	return seg;
 }
 
 static inline u16 read_gs(void)
 {
 	u16 seg;
-	asm ("mov %%gs, %0" : "=g"(seg));
+	asm("mov %%gs, %0" : "=g"(seg));
 	return seg;
 }
 
 static inline u16 read_ldt(void)
 {
 	u16 ldt;
-	asm ("sldt %0" : "=g"(ldt));
+	asm("sldt %0" : "=g"(ldt));
 	return ldt;
 }
 
 static inline void load_fs(u16 sel)
 {
-	asm ("mov %0, %%fs" : : "rm"(sel));
+	asm("mov %0, %%fs" : : "rm"(sel));
 }
 
 static inline void load_gs(u16 sel)
 {
-	asm ("mov %0, %%gs" : : "rm"(sel));
+	asm("mov %0, %%gs" : : "rm"(sel));
 }
 
 #ifndef load_ldt
 static inline void load_ldt(u16 sel)
 {
-	asm ("lldt %0" : : "rm"(sel));
+	asm("lldt %0" : : "rm"(sel));
 }
 #endif
 
 static inline void get_idt(struct descriptor_table *table)
 {
-	asm ("sidt %0" : "=m"(*table));
+	asm("sidt %0" : "=m"(*table));
 }
 
 static inline void get_gdt(struct descriptor_table *table)
 {
-	asm ("sgdt %0" : "=m"(*table));
+	asm("sgdt %0" : "=m"(*table));
 }
 
 static inline unsigned long read_tr_base(void)
 {
 	u16 tr;
-	asm ("str %0" : "=g"(tr));
+	asm("str %0" : "=g"(tr));
 	return segment_base(tr);
 }
 
@@ -785,17 +785,17 @@ static inline unsigned long read_msr(unsigned long msr)
 
 static inline void fx_save(struct i387_fxsave_struct *image)
 {
-	asm ("fxsave (%0)":: "r" (image));
+	asm("fxsave (%0)":: "r" (image));
 }
 
 static inline void fx_restore(struct i387_fxsave_struct *image)
 {
-	asm ("fxrstor (%0)":: "r" (image));
+	asm("fxrstor (%0)":: "r" (image));
 }
 
 static inline void fpu_init(void)
 {
-	asm ("finit");
+	asm("finit");
 }
 
 static inline u32 get_rdx_init_val(void)
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 0a04b75..47ffefb 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -104,7 +104,7 @@ static struct dentry *debugfs_dir;
 #define EFER_RESERVED_BITS 0xfffffffffffff2fe
 
 #ifdef CONFIG_X86_64
-// LDT or TSS descriptor in the GDT. 16 bytes.
+/* LDT or TSS descriptor in the GDT. 16 bytes. */
 struct segment_descriptor_64 {
 	struct segment_descriptor s;
 	u32 base_higher;
@@ -121,27 +121,27 @@ unsigned long segment_base(u16 selector)
 	struct descriptor_table gdt;
 	struct segment_descriptor *d;
 	unsigned long table_base;
-	typedef unsigned long ul;
 	unsigned long v;
 
 	if (selector == 0)
 		return 0;
 
-	asm ("sgdt %0" : "=m"(gdt));
+	asm("sgdt %0" : "=m"(gdt));
 	table_base = gdt.base;
 
 	if (selector & 4) {           /* from ldt */
 		u16 ldt_selector;
 
-		asm ("sldt %0" : "=g"(ldt_selector));
+		asm("sldt %0" : "=g"(ldt_selector));
 		table_base = segment_base(ldt_selector);
 	}
 	d = (struct segment_descriptor *)(table_base + (selector & ~7));
-	v = d->base_low | ((ul)d->base_mid << 16) | ((ul)d->base_high << 24);
+	v = d->base_low | ((unsigned long)d->base_mid << 16) |
+		((unsigned long)d->base_high << 24);
 #ifdef CONFIG_X86_64
-	if (d->system == 0
-	    && (d->type == 2 || d->type == 9 || d->type == 11))
-		v |= ((ul)((struct segment_descriptor_64 *)d)->base_higher) << 32;
+	if (d->system == 0 && (d->type == 2 || d->type == 9 || d->type == 11))
+		v |= ((unsigned long) \
+		      ((struct segment_descriptor_64 *)d)->base_higher) << 32;
 #endif
 	return v;
 }
@@ -721,7 +721,7 @@ static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 		if (!new.phys_mem)
 			goto out_unlock;
 
-		new.rmap = vmalloc(npages * sizeof(struct page*));
+		new.rmap = vmalloc(npages * sizeof(struct page *));
 
 		if (!new.rmap)
 			goto out_unlock;
@@ -904,17 +904,17 @@ static int kvm_vm_ioctl_get_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
 	r = 0;
 	switch (chip->chip_id) {
 	case KVM_IRQCHIP_PIC_MASTER:
-		memcpy (&chip->chip.pic,
+		memcpy(&chip->chip.pic,
 			&pic_irqchip(kvm)->pics[0],
 			sizeof(struct kvm_pic_state));
 		break;
 	case KVM_IRQCHIP_PIC_SLAVE:
-		memcpy (&chip->chip.pic,
+		memcpy(&chip->chip.pic,
 			&pic_irqchip(kvm)->pics[1],
 			sizeof(struct kvm_pic_state));
 		break;
 	case KVM_IRQCHIP_IOAPIC:
-		memcpy (&chip->chip.ioapic,
+		memcpy(&chip->chip.ioapic,
 			ioapic_irqchip(kvm),
 			sizeof(struct kvm_ioapic_state));
 		break;
@@ -932,17 +932,17 @@ static int kvm_vm_ioctl_set_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
 	r = 0;
 	switch (chip->chip_id) {
 	case KVM_IRQCHIP_PIC_MASTER:
-		memcpy (&pic_irqchip(kvm)->pics[0],
+		memcpy(&pic_irqchip(kvm)->pics[0],
 			&chip->chip.pic,
 			sizeof(struct kvm_pic_state));
 		break;
 	case KVM_IRQCHIP_PIC_SLAVE:
-		memcpy (&pic_irqchip(kvm)->pics[1],
+		memcpy(&pic_irqchip(kvm)->pics[1],
 			&chip->chip.pic,
 			sizeof(struct kvm_pic_state));
 		break;
 	case KVM_IRQCHIP_IOAPIC:
-		memcpy (ioapic_irqchip(kvm),
+		memcpy(ioapic_irqchip(kvm),
 			&chip->chip.ioapic,
 			sizeof(struct kvm_ioapic_state));
 		break;
@@ -1341,7 +1341,7 @@ int emulate_clts(struct kvm_vcpu *vcpu)
 	return X86EMUL_CONTINUE;
 }
 
-int emulator_get_dr(struct x86_emulate_ctxt* ctxt, int dr, unsigned long *dest)
+int emulator_get_dr(struct x86_emulate_ctxt *ctxt, int dr, unsigned long *dest)
 {
 	struct kvm_vcpu *vcpu = ctxt->vcpu;
 
@@ -1934,7 +1934,7 @@ static void pio_string_write(struct kvm_io_device *pio_dev,
 	mutex_unlock(&vcpu->kvm->lock);
 }
 
-int kvm_emulate_pio (struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
+int kvm_emulate_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 		  int size, unsigned port)
 {
 	struct kvm_io_device *pio_dev;
@@ -2089,7 +2089,7 @@ static int __vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	int r;
 
 	if (unlikely(vcpu->mp_state == VCPU_MP_STATE_SIPI_RECEIVED)) {
-		printk("vcpu %d received sipi with vector # %x\n",
+		pr_debug("vcpu %d received sipi with vector # %x\n",
 		       vcpu->vcpu_id, vcpu->sipi_vector);
 		kvm_lapic_reset(vcpu);
 		kvm_x86_ops->vcpu_reset(vcpu);
@@ -2363,7 +2363,8 @@ static int kvm_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 		       sizeof sregs->interrupt_bitmap);
 		pending_vec = kvm_x86_ops->get_irq(vcpu);
 		if (pending_vec >= 0)
-			set_bit(pending_vec, (unsigned long *)sregs->interrupt_bitmap);
+			set_bit(pending_vec,
+				(unsigned long *)sregs->interrupt_bitmap);
 	} else
 		memcpy(sregs->interrupt_bitmap, vcpu->irq_pending,
 		       sizeof sregs->interrupt_bitmap);
@@ -2436,7 +2437,8 @@ static int kvm_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 		/* Only pending external irq is handled here */
 		if (pending_vec < max_bits) {
 			kvm_x86_ops->set_irq(vcpu, pending_vec);
-			printk("Set back pending irq %d\n", pending_vec);
+			pr_debug("Set back pending irq %d\n",
+				 pending_vec);
 		}
 	}
 
@@ -3155,8 +3157,7 @@ static long kvm_vm_ioctl(struct file *filp,
 				kvm->vpic = NULL;
 				goto out;
 			}
-		}
-		else
+		} else
 			goto out;
 		break;
 	case KVM_IRQ_LINE: {
@@ -3448,7 +3449,7 @@ static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
 }
 
 static int kvm_reboot(struct notifier_block *notifier, unsigned long val,
-                       void *v)
+		      void *v)
 {
 	if (val == SYS_RESTART) {
 		/*
@@ -3655,7 +3656,7 @@ int kvm_init_x86(struct kvm_x86_ops *ops, unsigned int vcpu_size,
 
 	r = misc_register(&kvm_dev);
 	if (r) {
-		printk (KERN_ERR "kvm: misc device register failed\n");
+		printk(KERN_ERR "kvm: misc device register failed\n");
 		goto out_free;
 	}
 
@@ -3683,6 +3684,7 @@ out:
 	kvm_x86_ops = NULL;
 	return r;
 }
+EXPORT_SYMBOL_GPL(kvm_init_x86);
 
 void kvm_exit_x86(void)
 {
@@ -3696,6 +3698,7 @@ void kvm_exit_x86(void)
 	kvm_x86_ops->hardware_unsetup();
 	kvm_x86_ops = NULL;
 }
+EXPORT_SYMBOL_GPL(kvm_exit_x86);
 
 static __init int kvm_init(void)
 {
@@ -3710,7 +3713,9 @@ static __init int kvm_init(void)
 
 	kvm_init_msr_list();
 
-	if ((bad_page = alloc_page(GFP_KERNEL)) == NULL) {
+	bad_page = alloc_page(GFP_KERNEL);
+
+	if (bad_page == NULL) {
 		r = -ENOMEM;
 		goto out;
 	}
@@ -3736,6 +3741,3 @@ static __exit void kvm_exit(void)
 
 module_init(kvm_init)
 module_exit(kvm_exit)
-
-EXPORT_SYMBOL_GPL(kvm_init_x86);
-EXPORT_SYMBOL_GPL(kvm_exit_x86);
diff --git a/drivers/kvm/lapic.c b/drivers/kvm/lapic.c
index 554e73a..e15b42e 100644
--- a/drivers/kvm/lapic.c
+++ b/drivers/kvm/lapic.c
@@ -906,8 +906,7 @@ static int __apic_timer_fn(struct kvm_lapic *apic)
 	wait_queue_head_t *q = &apic->vcpu->wq;
 
 	atomic_inc(&apic->timer.pending);
-	if (waitqueue_active(q))
-	{
+	if (waitqueue_active(q)) {
 		apic->vcpu->mp_state = VCPU_MP_STATE_RUNNABLE;
 		wake_up_interruptible(q);
 	}
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 6cda1fe..ece0aa4 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -90,7 +90,8 @@ static int dbg = 1;
 
 #define PT32_DIR_PSE36_SIZE 4
 #define PT32_DIR_PSE36_SHIFT 13
-#define PT32_DIR_PSE36_MASK (((1ULL << PT32_DIR_PSE36_SIZE) - 1) << PT32_DIR_PSE36_SHIFT)
+#define PT32_DIR_PSE36_MASK \
+	(((1ULL << PT32_DIR_PSE36_SIZE) - 1) << PT32_DIR_PSE36_SHIFT)
 
 
 #define PT_FIRST_AVAIL_BITS_SHIFT 9
@@ -103,7 +104,7 @@ static int dbg = 1;
 #define PT64_LEVEL_BITS 9
 
 #define PT64_LEVEL_SHIFT(level) \
-		( PAGE_SHIFT + (level - 1) * PT64_LEVEL_BITS )
+		(PAGE_SHIFT + (level - 1) * PT64_LEVEL_BITS)
 
 #define PT64_LEVEL_MASK(level) \
 		(((1ULL << PT64_LEVEL_BITS) - 1) << PT64_LEVEL_SHIFT(level))
@@ -115,7 +116,7 @@ static int dbg = 1;
 #define PT32_LEVEL_BITS 10
 
 #define PT32_LEVEL_SHIFT(level) \
-		( PAGE_SHIFT + (level - 1) * PT32_LEVEL_BITS )
+		(PAGE_SHIFT + (level - 1) * PT32_LEVEL_BITS)
 
 #define PT32_LEVEL_MASK(level) \
 		(((1ULL << PT32_LEVEL_BITS) - 1) << PT32_LEVEL_SHIFT(level))
@@ -1489,7 +1490,8 @@ static void audit_mappings_page(struct kvm_vcpu *vcpu, u64 page_pte,
 				printk(KERN_ERR "xx audit error: (%s) levels %d"
 				       " gva %lx gpa %llx hpa %llx ent %llx %d\n",
 				       audit_msg, vcpu->mmu.root_level,
-				       va, gpa, hpa, ent, is_shadow_present_pte(ent));
+				       va, gpa, hpa, ent,
+				       is_shadow_present_pte(ent));
 			else if (ent == shadow_notrap_nonpresent_pte
 				 && !is_error_hpa(hpa))
 				printk(KERN_ERR "audit: (%s) notrap shadow,"
diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index fbe595f..447d2c3 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -163,7 +163,7 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 		walker->page = pfn_to_page(paddr >> PAGE_SHIFT);
 		walker->table = kmap_atomic(walker->page, KM_USER0);
 		--walker->level;
-		walker->table_gfn[walker->level - 1 ] = table_gfn;
+		walker->table_gfn[walker->level - 1] = table_gfn;
 		pgprintk("%s: table_gfn[%d] %lx\n", __FUNCTION__,
 			 walker->level - 1, table_gfn);
 	}
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index f2278d0..746a377 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -229,12 +229,11 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 		printk(KERN_DEBUG "%s: NOP\n", __FUNCTION__);
 		return;
 	}
-	if (svm->next_rip - svm->vmcb->save.rip > MAX_INST_SIZE) {
+	if (svm->next_rip - svm->vmcb->save.rip > MAX_INST_SIZE)
 		printk(KERN_ERR "%s: ip 0x%llx next 0x%llx\n",
 		       __FUNCTION__,
 		       svm->vmcb->save.rip,
 		       svm->next_rip);
-	}
 
 	vcpu->rip = svm->vmcb->save.rip = svm->next_rip;
 	svm->vmcb->control.int_state &= ~SVM_INTERRUPT_SHADOW_MASK;
@@ -312,7 +311,7 @@ static void svm_hardware_enable(void *garbage)
 	svm_data->next_asid = svm_data->max_asid + 1;
 	svm_features = cpuid_edx(SVM_CPUID_FUNC);
 
-	asm volatile ( "sgdt %0" : "=m"(gdt_descr) );
+	asm volatile ("sgdt %0" : "=m"(gdt_descr));
 	gdt = (struct desc_struct *)gdt_descr.address;
 	svm_data->tss_desc = (struct kvm_ldttss_desc *)(gdt + GDT_ENTRY_TSS);
 
@@ -544,8 +543,7 @@ static void init_vmcb(struct vmcb *vmcb)
 	init_sys_seg(&save->tr, SEG_TYPE_BUSY_TSS16);
 
 	save->efer = MSR_EFER_SVME_MASK;
-
-        save->dr6 = 0xffff0ff0;
+	save->dr6 = 0xffff0ff0;
 	save->dr7 = 0x400;
 	save->rflags = 2;
 	save->rip = 0x0000fff0;
@@ -783,7 +781,7 @@ static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 			svm->vmcb->save.efer |= KVM_EFER_LMA | KVM_EFER_LME;
 		}
 
-		if (is_paging(vcpu) && !(cr0 & X86_CR0_PG) ) {
+		if (is_paging(vcpu) && !(cr0 & X86_CR0_PG)) {
 			vcpu->shadow_efer &= ~KVM_EFER_LMA;
 			svm->vmcb->save.efer &= ~(KVM_EFER_LMA | KVM_EFER_LME);
 		}
@@ -1010,7 +1008,7 @@ static int shutdown_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 
 static int io_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
-	u32 io_info = svm->vmcb->control.exit_info_1; //address size bug?
+	u32 io_info = svm->vmcb->control.exit_info_1; /* address size bug? */
 	int size, down, in, string, rep;
 	unsigned port;
 
@@ -1316,7 +1314,7 @@ static void reload_tss(struct kvm_vcpu *vcpu)
 	int cpu = raw_smp_processor_id();
 
 	struct svm_cpu_data *svm_data = per_cpu(svm_data, cpu);
-	svm_data->tss_desc->type = 9; //available 32/64-bit TSS
+	svm_data->tss_desc->type = 9; /* available 32/64-bit TSS */
 	load_TR_desc();
 }
 
@@ -1434,9 +1432,9 @@ static void do_interrupt_requests(struct kvm_vcpu *vcpu,
 	 * Interrupts blocked.  Wait for unblock.
 	 */
 	if (!svm->vcpu.interrupt_window_open &&
-	    (svm->vcpu.irq_summary || kvm_run->request_interrupt_window)) {
+	    (svm->vcpu.irq_summary || kvm_run->request_interrupt_window))
 		control->intercept |= 1ULL << INTERCEPT_VINTR;
-	} else
+	 else
 		control->intercept &= ~(1ULL << INTERCEPT_VINTR);
 }
 
@@ -1581,23 +1579,23 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		:
 		: [svm]"a"(svm),
 		  [vmcb]"i"(offsetof(struct vcpu_svm, vmcb_pa)),
-		  [rbx]"i"(offsetof(struct vcpu_svm,vcpu.regs[VCPU_REGS_RBX])),
-		  [rcx]"i"(offsetof(struct vcpu_svm,vcpu.regs[VCPU_REGS_RCX])),
-		  [rdx]"i"(offsetof(struct vcpu_svm,vcpu.regs[VCPU_REGS_RDX])),
-		  [rsi]"i"(offsetof(struct vcpu_svm,vcpu.regs[VCPU_REGS_RSI])),
-		  [rdi]"i"(offsetof(struct vcpu_svm,vcpu.regs[VCPU_REGS_RDI])),
-		  [rbp]"i"(offsetof(struct vcpu_svm,vcpu.regs[VCPU_REGS_RBP]))
+		  [rbx]"i"(offsetof(struct vcpu_svm, vcpu.regs[VCPU_REGS_RBX])),
+		  [rcx]"i"(offsetof(struct vcpu_svm, vcpu.regs[VCPU_REGS_RCX])),
+		  [rdx]"i"(offsetof(struct vcpu_svm, vcpu.regs[VCPU_REGS_RDX])),
+		  [rsi]"i"(offsetof(struct vcpu_svm, vcpu.regs[VCPU_REGS_RSI])),
+		  [rdi]"i"(offsetof(struct vcpu_svm, vcpu.regs[VCPU_REGS_RDI])),
+		  [rbp]"i"(offsetof(struct vcpu_svm, vcpu.regs[VCPU_REGS_RBP]))
 #ifdef CONFIG_X86_64
-		  ,[r8 ]"i"(offsetof(struct vcpu_svm,vcpu.regs[VCPU_REGS_R8])),
-		  [r9 ]"i"(offsetof(struct vcpu_svm,vcpu.regs[VCPU_REGS_R9 ])),
-		  [r10]"i"(offsetof(struct vcpu_svm,vcpu.regs[VCPU_REGS_R10])),
-		  [r11]"i"(offsetof(struct vcpu_svm,vcpu.regs[VCPU_REGS_R11])),
-		  [r12]"i"(offsetof(struct vcpu_svm,vcpu.regs[VCPU_REGS_R12])),
-		  [r13]"i"(offsetof(struct vcpu_svm,vcpu.regs[VCPU_REGS_R13])),
-		  [r14]"i"(offsetof(struct vcpu_svm,vcpu.regs[VCPU_REGS_R14])),
-		  [r15]"i"(offsetof(struct vcpu_svm,vcpu.regs[VCPU_REGS_R15]))
+		  , [r8]"i"(offsetof(struct vcpu_svm, vcpu.regs[VCPU_REGS_R8])),
+		  [r9]"i"(offsetof(struct vcpu_svm, vcpu.regs[VCPU_REGS_R9])),
+		  [r10]"i"(offsetof(struct vcpu_svm, vcpu.regs[VCPU_REGS_R10])),
+		  [r11]"i"(offsetof(struct vcpu_svm, vcpu.regs[VCPU_REGS_R11])),
+		  [r12]"i"(offsetof(struct vcpu_svm, vcpu.regs[VCPU_REGS_R12])),
+		  [r13]"i"(offsetof(struct vcpu_svm, vcpu.regs[VCPU_REGS_R13])),
+		  [r14]"i"(offsetof(struct vcpu_svm, vcpu.regs[VCPU_REGS_R14])),
+		  [r15]"i"(offsetof(struct vcpu_svm, vcpu.regs[VCPU_REGS_R15]))
 #endif
-		: "cc", "memory" );
+		: "cc", "memory");
 
 	if ((svm->vmcb->save.dr7 & 0xff))
 		load_db_regs(svm->host_db_regs);
diff --git a/drivers/kvm/svm.h b/drivers/kvm/svm.h
index 3b1b0f3..5fa277c 100644
--- a/drivers/kvm/svm.h
+++ b/drivers/kvm/svm.h
@@ -311,7 +311,7 @@ struct __attribute__ ((__packed__)) vmcb {
 
 #define SVM_EXIT_ERR		-1
 
-#define SVM_CR0_SELECTIVE_MASK (1 << 3 | 1) // TS and MP
+#define SVM_CR0_SELECTIVE_MASK (1 << 3 | 1) /* TS and MP */
 
 #define SVM_VMLOAD ".byte 0x0f, 0x01, 0xda"
 #define SVM_VMRUN  ".byte 0x0f, 0x01, 0xd8"
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 718d1f4..1336174 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -62,7 +62,7 @@ struct vcpu_vmx {
 		int           gs_ldt_reload_needed;
 		int           fs_reload_needed;
 		int           guest_efer_loaded;
-	}host_state;
+	} host_state;
 
 };
 
@@ -271,7 +271,7 @@ static void vmcs_writel(unsigned long field, unsigned long value)
 	u8 error;
 
 	asm volatile (ASM_VMX_VMWRITE_RAX_RDX "; setna %0"
-		       : "=q"(error) : "a"(value), "d"(field) : "cc" );
+		       : "=q"(error) : "a"(value), "d"(field) : "cc");
 	if (unlikely(error))
 		vmwrite_error(field, value);
 }
@@ -415,10 +415,10 @@ static void vmx_save_host_state(struct kvm_vcpu *vcpu)
 #endif
 
 #ifdef CONFIG_X86_64
-	if (is_long_mode(&vmx->vcpu)) {
+	if (is_long_mode(&vmx->vcpu))
 		save_msrs(vmx->host_msrs +
 			  vmx->msr_offset_kernel_gs_base, 1);
-	}
+
 #endif
 	load_msrs(vmx->guest_msrs, vmx->save_nmsrs);
 	load_transition_efer(vmx);
@@ -845,7 +845,7 @@ static int vmx_get_irq(struct kvm_vcpu *vcpu)
 		if (is_external_interrupt(idtv_info_field))
 			return idtv_info_field & VECTORING_INFO_VECTOR_MASK;
 		else
-			printk("pending exception: not handled yet\n");
+			printk(KERN_DEBUG "pending exception: not handled yet\n");
 	}
 	return -1;
 }
@@ -893,7 +893,7 @@ static void hardware_disable(void *garbage)
 }
 
 static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
-				      u32 msr, u32* result)
+				      u32 msr, u32 *result)
 {
 	u32 vmx_msr_low, vmx_msr_high;
 	u32 ctl = ctl_min | ctl_opt;
@@ -1102,7 +1102,7 @@ static void enter_pmode(struct kvm_vcpu *vcpu)
 	vmcs_write32(GUEST_CS_AR_BYTES, 0x9b);
 }
 
-static gva_t rmode_tss_base(struct kvm* kvm)
+static gva_t rmode_tss_base(struct kvm *kvm)
 {
 	gfn_t base_gfn = kvm->memslots[0].base_gfn + kvm->memslots[0].npages - 3;
 	return base_gfn << PAGE_SHIFT;
@@ -1385,7 +1385,7 @@ static void vmx_set_gdt(struct kvm_vcpu *vcpu, struct descriptor_table *dt)
 	vmcs_writel(GUEST_GDTR_BASE, dt->base);
 }
 
-static int init_rmode_tss(struct kvm* kvm)
+static int init_rmode_tss(struct kvm *kvm)
 {
 	gfn_t fn = rmode_tss_base(kvm) >> PAGE_SHIFT;
 	u16 data = 0;
@@ -1494,7 +1494,7 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 		vmcs_writel(GUEST_RIP, 0);
 	vmcs_writel(GUEST_RSP, 0);
 
-	//todo: dr0 = dr1 = dr2 = dr3 = 0; dr6 = 0xffff0ff0
+	/* todo: dr0 = dr1 = dr2 = dr3 = 0; dr6 = 0xffff0ff0 */
 	vmcs_writel(GUEST_DR7, 0x400);
 
 	vmcs_writel(GUEST_GDTR_BASE, 0);
@@ -1561,7 +1561,7 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	get_idt(&dt);
 	vmcs_writel(HOST_IDTR_BASE, dt.base);   /* 22.2.4 */
 
-	asm ("mov $.Lkvm_vmx_return, %0" : "=r"(kvm_vmx_return));
+	asm("mov $.Lkvm_vmx_return, %0" : "=r"(kvm_vmx_return));
 	vmcs_writel(HOST_RIP, kvm_vmx_return); /* 22.2.5 */
 	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, 0);
 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, 0);
@@ -1613,7 +1613,7 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	vmcs_writel(CR4_GUEST_HOST_MASK, KVM_GUEST_CR4_MASK);
 
 	vmx->vcpu.cr0 = 0x60000010;
-	vmx_set_cr0(&vmx->vcpu, vmx->vcpu.cr0); // enter rmode
+	vmx_set_cr0(&vmx->vcpu, vmx->vcpu.cr0); /* enter rmode */
 	vmx_set_cr4(&vmx->vcpu, 0);
 #ifdef CONFIG_X86_64
 	vmx_set_efer(&vmx->vcpu, 0);
@@ -1644,7 +1644,7 @@ static void inject_rmode_irq(struct kvm_vcpu *vcpu, int irq)
 	u16 sp =  vmcs_readl(GUEST_RSP);
 	u32 ss_limit = vmcs_read32(GUEST_SS_LIMIT);
 
-	if (sp > ss_limit || sp < 6 ) {
+	if (sp > ss_limit || sp < 6) {
 		vcpu_printf(vcpu, "%s: #SS, rsp 0x%lx ss 0x%lx limit 0x%x\n",
 			    __FUNCTION__,
 			    vmcs_readl(GUEST_RSP),
@@ -1664,15 +1664,18 @@ static void inject_rmode_irq(struct kvm_vcpu *vcpu, int irq)
 	ip =  vmcs_readl(GUEST_RIP);
 
 
-	if (emulator_write_emulated(ss_base + sp - 2, &flags, 2, vcpu) != X86EMUL_CONTINUE ||
-	    emulator_write_emulated(ss_base + sp - 4, &cs, 2, vcpu) != X86EMUL_CONTINUE ||
-	    emulator_write_emulated(ss_base + sp - 6, &ip, 2, vcpu) != X86EMUL_CONTINUE) {
+	if (emulator_write_emulated(
+		    ss_base + sp - 2, &flags, 2, vcpu) != X86EMUL_CONTINUE ||
+	    emulator_write_emulated(
+		    ss_base + sp - 4, &cs, 2, vcpu) != X86EMUL_CONTINUE ||
+	    emulator_write_emulated(
+		    ss_base + sp - 6, &ip, 2, vcpu) != X86EMUL_CONTINUE) {
 		vcpu_printf(vcpu, "%s: write guest err\n", __FUNCTION__);
 		return;
 	}
 
 	vmcs_writel(GUEST_RFLAGS, flags &
-		    ~( X86_EFLAGS_IF | X86_EFLAGS_AC | X86_EFLAGS_TF));
+		    ~(X86_EFLAGS_IF | X86_EFLAGS_AC | X86_EFLAGS_TF));
 	vmcs_write16(GUEST_CS_SELECTOR, ent[1]) ;
 	vmcs_writel(GUEST_CS_BASE, ent[1] << 4);
 	vmcs_writel(GUEST_RIP, ent[0]);
@@ -1777,10 +1780,9 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
 
 	if ((vect_info & VECTORING_INFO_VALID_MASK) &&
-						!is_page_fault(intr_info)) {
+						!is_page_fault(intr_info))
 		printk(KERN_ERR "%s: unexpected, vectoring info 0x%x "
 		       "intr info 0x%x\n", __FUNCTION__, vect_info, intr_info);
-	}
 
 	if (!irqchip_in_kernel(vcpu->kvm) && is_external_interrupt(vect_info)) {
 		int irq = vect_info & VECTORING_INFO_VECTOR_MASK;
@@ -1831,7 +1833,7 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		case EMULATE_DO_MMIO:
 			++vcpu->stat.mmio_exits;
 			return 0;
-		 case EMULATE_FAIL:
+		case EMULATE_FAIL:
 			kvm_report_emulation_failure(vcpu, "pagetable");
 			break;
 		default:
@@ -1849,7 +1851,8 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		return 1;
 	}
 
-	if ((intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VECTOR_MASK)) == (INTR_TYPE_EXCEPTION | 1)) {
+	if ((intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VECTOR_MASK)) ==
+	    (INTR_TYPE_EXCEPTION | 1)) {
 		kvm_run->exit_reason = KVM_EXIT_DEBUG;
 		return 0;
 	}
@@ -2138,8 +2141,8 @@ static int kvm_handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
-	if ( (vectoring_info & VECTORING_INFO_VALID_MASK) &&
-				exit_reason != EXIT_REASON_EXCEPTION_NMI )
+	if ((vectoring_info & VECTORING_INFO_VALID_MASK) &&
+				exit_reason != EXIT_REASON_EXCEPTION_NMI)
 		printk(KERN_WARNING "%s: unexpected, valid vectoring info and "
 		       "exit reason is 0x%x\n", __FUNCTION__, exit_reason);
 	if (exit_reason < kvm_vmx_max_exit_handlers
@@ -2238,7 +2241,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	 */
 	vmcs_writel(HOST_CR0, read_cr0());
 
-	asm (
+	asm(
 		/* Store host registers */
 #ifdef CONFIG_X86_64
 		"push %%rax; push %%rbx; push %%rdx;"
@@ -2342,8 +2345,8 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		[rdi]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RDI])),
 		[rbp]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RBP])),
 #ifdef CONFIG_X86_64
-		[r8 ]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R8 ])),
-		[r9 ]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R9 ])),
+		[r8]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R8])),
+		[r9]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R9])),
 		[r10]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R10])),
 		[r11]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R11])),
 		[r12]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R12])),
@@ -2352,11 +2355,12 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		[r15]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R15])),
 #endif
 		[cr2]"i"(offsetof(struct kvm_vcpu, cr2))
-	      : "cc", "memory" );
+	      : "cc", "memory");
 
-	vcpu->interrupt_window_open = (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) & 3) == 0;
+	vcpu->interrupt_window_open =
+		(vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) & 3) == 0;
 
-	asm ("mov %0, %%ds; mov %0, %%es" : : "r"(__USER_DS));
+	asm("mov %0, %%ds; mov %0, %%es" : : "r"(__USER_DS));
 	vmx->launched = 1;
 
 	intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
diff --git a/drivers/kvm/vmx.h b/drivers/kvm/vmx.h
index fd4e146..270d477 100644
--- a/drivers/kvm/vmx.h
+++ b/drivers/kvm/vmx.h
@@ -234,9 +234,9 @@ enum vmcs_field {
 /*
  * Exit Qualifications for MOV for Control Register Access
  */
-#define CONTROL_REG_ACCESS_NUM          0x7     /* 2:0, number of control register */
+#define CONTROL_REG_ACCESS_NUM          0x7     /* 2:0, number of control reg.*/
 #define CONTROL_REG_ACCESS_TYPE         0x30    /* 5:4, access type */
-#define CONTROL_REG_ACCESS_REG          0xf00   /* 10:8, general purpose register */
+#define CONTROL_REG_ACCESS_REG          0xf00   /* 10:8, general purpose reg. */
 #define LMSW_SOURCE_DATA_SHIFT 16
 #define LMSW_SOURCE_DATA  (0xFFFF << LMSW_SOURCE_DATA_SHIFT) /* 16:31 lmsw source */
 #define REG_EAX                         (0 << 8)
@@ -259,11 +259,11 @@ enum vmcs_field {
 /*
  * Exit Qualifications for MOV for Debug Register Access
  */
-#define DEBUG_REG_ACCESS_NUM            0x7     /* 2:0, number of debug register */
+#define DEBUG_REG_ACCESS_NUM            0x7     /* 2:0, number of debug reg. */
 #define DEBUG_REG_ACCESS_TYPE           0x10    /* 4, direction of access */
 #define TYPE_MOV_TO_DR                  (0 << 4)
 #define TYPE_MOV_FROM_DR                (1 << 4)
-#define DEBUG_REG_ACCESS_REG            0xf00   /* 11:8, general purpose register */
+#define DEBUG_REG_ACCESS_REG            0xf00   /* 11:8, general purpose reg. */
 
 
 /* segment AR */
diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index e6b213b..b03029e 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -23,7 +23,7 @@
 #include <stdio.h>
 #include <stdint.h>
 #include <public/xen.h>
-#define DPRINTF(_f, _a ...) printf( _f , ## _a )
+#define DPRINTF(_f, _a ...) printf(_f , ## _a)
 #else
 #include "kvm.h"
 #define DPRINTF(x...) do {} while (0)
@@ -285,21 +285,21 @@ static u16 twobyte_table[256] = {
 		switch ((_dst).bytes) {					    \
 		case 2:							    \
 			__asm__ __volatile__ (				    \
-				_PRE_EFLAGS("0","4","2")		    \
+				_PRE_EFLAGS("0", "4", "2")		    \
 				_op"w %"_wx"3,%1; "			    \
-				_POST_EFLAGS("0","4","2")		    \
+				_POST_EFLAGS("0", "4", "2")		    \
 				: "=m" (_eflags), "=m" ((_dst).val),        \
 				  "=&r" (_tmp)				    \
-				: _wy ((_src).val), "i" (EFLAGS_MASK) );    \
+				: _wy ((_src).val), "i" (EFLAGS_MASK));     \
 			break;						    \
 		case 4:							    \
 			__asm__ __volatile__ (				    \
-				_PRE_EFLAGS("0","4","2")		    \
+				_PRE_EFLAGS("0", "4", "2")		    \
 				_op"l %"_lx"3,%1; "			    \
-				_POST_EFLAGS("0","4","2")		    \
+				_POST_EFLAGS("0", "4", "2")		    \
 				: "=m" (_eflags), "=m" ((_dst).val),	    \
 				  "=&r" (_tmp)				    \
-				: _ly ((_src).val), "i" (EFLAGS_MASK) );    \
+				: _ly ((_src).val), "i" (EFLAGS_MASK));     \
 			break;						    \
 		case 8:							    \
 			__emulate_2op_8byte(_op, _src, _dst,		    \
@@ -311,16 +311,15 @@ static u16 twobyte_table[256] = {
 #define __emulate_2op(_op,_src,_dst,_eflags,_bx,_by,_wx,_wy,_lx,_ly,_qx,_qy) \
 	do {								     \
 		unsigned long _tmp;					     \
-		switch ( (_dst).bytes )					     \
-		{							     \
+		switch ((_dst).bytes) {				             \
 		case 1:							     \
 			__asm__ __volatile__ (				     \
-				_PRE_EFLAGS("0","4","2")		     \
+				_PRE_EFLAGS("0", "4", "2")		     \
 				_op"b %"_bx"3,%1; "			     \
-				_POST_EFLAGS("0","4","2")		     \
+				_POST_EFLAGS("0", "4", "2")		     \
 				: "=m" (_eflags), "=m" ((_dst).val),	     \
 				  "=&r" (_tmp)				     \
-				: _by ((_src).val), "i" (EFLAGS_MASK) );     \
+				: _by ((_src).val), "i" (EFLAGS_MASK));      \
 			break;						     \
 		default:						     \
 			__emulate_2op_nobyte(_op, _src, _dst, _eflags,	     \
@@ -349,34 +348,33 @@ static u16 twobyte_table[256] = {
 	do {								\
 		unsigned long _tmp;					\
 									\
-		switch ( (_dst).bytes )					\
-		{							\
+		switch ((_dst).bytes) {				        \
 		case 1:							\
 			__asm__ __volatile__ (				\
-				_PRE_EFLAGS("0","3","2")		\
+				_PRE_EFLAGS("0", "3", "2")		\
 				_op"b %1; "				\
-				_POST_EFLAGS("0","3","2")		\
+				_POST_EFLAGS("0", "3", "2")		\
 				: "=m" (_eflags), "=m" ((_dst).val),	\
 				  "=&r" (_tmp)				\
-				: "i" (EFLAGS_MASK) );			\
+				: "i" (EFLAGS_MASK));			\
 			break;						\
 		case 2:							\
 			__asm__ __volatile__ (				\
-				_PRE_EFLAGS("0","3","2")		\
+				_PRE_EFLAGS("0", "3", "2")		\
 				_op"w %1; "				\
-				_POST_EFLAGS("0","3","2")		\
+				_POST_EFLAGS("0", "3", "2")		\
 				: "=m" (_eflags), "=m" ((_dst).val),	\
 				  "=&r" (_tmp)				\
-				: "i" (EFLAGS_MASK) );			\
+				: "i" (EFLAGS_MASK));			\
 			break;						\
 		case 4:							\
 			__asm__ __volatile__ (				\
-				_PRE_EFLAGS("0","3","2")		\
+				_PRE_EFLAGS("0", "3", "2")		\
 				_op"l %1; "				\
-				_POST_EFLAGS("0","3","2")		\
+				_POST_EFLAGS("0", "3", "2")		\
 				: "=m" (_eflags), "=m" ((_dst).val),	\
 				  "=&r" (_tmp)				\
-				: "i" (EFLAGS_MASK) );			\
+				: "i" (EFLAGS_MASK));			\
 			break;						\
 		case 8:							\
 			__emulate_1op_8byte(_op, _dst, _eflags);	\
@@ -389,21 +387,21 @@ static u16 twobyte_table[256] = {
 #define __emulate_2op_8byte(_op, _src, _dst, _eflags, _qx, _qy)           \
 	do {								  \
 		__asm__ __volatile__ (					  \
-			_PRE_EFLAGS("0","4","2")			  \
+			_PRE_EFLAGS("0", "4", "2")			  \
 			_op"q %"_qx"3,%1; "				  \
-			_POST_EFLAGS("0","4","2")			  \
+			_POST_EFLAGS("0", "4", "2")			  \
 			: "=m" (_eflags), "=m" ((_dst).val), "=&r" (_tmp) \
-			: _qy ((_src).val), "i" (EFLAGS_MASK) );	  \
+			: _qy ((_src).val), "i" (EFLAGS_MASK));		\
 	} while (0)
 
 #define __emulate_1op_8byte(_op, _dst, _eflags)                           \
 	do {								  \
 		__asm__ __volatile__ (					  \
-			_PRE_EFLAGS("0","3","2")			  \
+			_PRE_EFLAGS("0", "3", "2")			  \
 			_op"q %1; "					  \
-			_POST_EFLAGS("0","3","2")			  \
+			_POST_EFLAGS("0", "3", "2")			  \
 			: "=m" (_eflags), "=m" ((_dst).val), "=&r" (_tmp) \
-			: "i" (EFLAGS_MASK) );				  \
+			: "i" (EFLAGS_MASK));				  \
 	} while (0)
 
 #elif defined(__i386__)
@@ -415,8 +413,8 @@ static u16 twobyte_table[256] = {
 #define insn_fetch(_type, _size, _eip)                                  \
 ({	unsigned long _x;						\
 	rc = ops->read_std((unsigned long)(_eip) + ctxt->cs_base, &_x,	\
-                                                  (_size), ctxt->vcpu); \
-	if ( rc != 0 )							\
+			   (_size), ctxt->vcpu);			\
+	if (rc != 0)							\
 		goto done;						\
 	(_eip) += (_size);						\
 	(_type)_x;							\
@@ -780,7 +778,7 @@ done_prefixes:
 		}
 		if (c->ad_bytes != 8)
 			c->modrm_ea = (u32)c->modrm_ea;
-	modrm_done:
+modrm_done:
 		;
 	}
 
@@ -828,10 +826,9 @@ done_prefixes:
 		c->src.bytes = (c->d & ByteOp) ? 1 :
 							   c->op_bytes;
 		/* Don't fetch the address for invlpg: it could be unmapped. */
-		if (c->twobyte && c->b == 0x01
-				    && c->modrm_reg == 7)
+		if (c->twobyte && c->b == 0x01 && c->modrm_reg == 7)
 			break;
-	      srcmem_common:
+	srcmem_common:
 		/*
 		 * For instructions with a ModR/M byte, switch to register
 		 * access if Mod = 3.
@@ -1175,10 +1172,11 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 	if (c->src.type == OP_MEM) {
 		c->src.ptr = (unsigned long *)cr2;
 		c->src.val = 0;
-		if ((rc = ops->read_emulated((unsigned long)c->src.ptr,
-					     &c->src.val,
-					     c->src.bytes,
-					     ctxt->vcpu)) != 0)
+		rc = ops->read_emulated((unsigned long)c->src.ptr,
+					&c->src.val,
+					c->src.bytes,
+					ctxt->vcpu);
+		if (rc != 0)
 			goto done;
 		c->src.orig_val = c->src.val;
 	}
-- 
1.5.3.7

