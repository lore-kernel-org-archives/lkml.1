Return-Path: <linux-kernel-owner+w=401wt.eu-S1757570AbXL3HQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbXL3HQl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756330AbXL3HLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:05 -0500
Received: from il.qumranet.com ([82.166.9.18]:59491 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042AbXL3HKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:45 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 16/52] KVM: Portability: Move some function declarations to x86.h
Date: Sun, 30 Dec 2007 09:10:02 +0200
Message-Id: <1198998638-22713-17-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h |   84 -----------------------------------------------------
 drivers/kvm/x86.h |   84 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+), 84 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 41f6ee2..1901456 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -375,19 +375,6 @@ int kvm_init(void *opaque, unsigned int vcpu_size,
 		  struct module *module);
 void kvm_exit(void);
 
-int kvm_mmu_module_init(void);
-void kvm_mmu_module_exit(void);
-
-void kvm_mmu_destroy(struct kvm_vcpu *vcpu);
-int kvm_mmu_create(struct kvm_vcpu *vcpu);
-int kvm_mmu_setup(struct kvm_vcpu *vcpu);
-void kvm_mmu_set_nonpresent_ptes(u64 trap_pte, u64 notrap_pte);
-
-int kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
-void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot);
-void kvm_mmu_zap_all(struct kvm *kvm);
-void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages);
-
 hpa_t gpa_to_hpa(struct kvm *kvm, gpa_t gpa);
 #define HPA_MSB ((sizeof(hpa_t) * 8) - 1)
 #define HPA_ERR_MASK ((hpa_t)1 << HPA_MSB)
@@ -421,83 +408,12 @@ struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
 int kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
 
-enum emulation_result {
-	EMULATE_DONE,       /* no further processing */
-	EMULATE_DO_MMIO,      /* kvm_run filled with mmio request */
-	EMULATE_FAIL,         /* can't emulate this instruction */
-};
-
-int emulate_instruction(struct kvm_vcpu *vcpu, struct kvm_run *run,
-			unsigned long cr2, u16 error_code, int no_decode);
-void kvm_report_emulation_failure(struct kvm_vcpu *cvpu, const char *context);
-void realmode_lgdt(struct kvm_vcpu *vcpu, u16 size, unsigned long address);
-void realmode_lidt(struct kvm_vcpu *vcpu, u16 size, unsigned long address);
-void realmode_lmsw(struct kvm_vcpu *vcpu, unsigned long msw,
-		   unsigned long *rflags);
-
-unsigned long realmode_get_cr(struct kvm_vcpu *vcpu, int cr);
-void realmode_set_cr(struct kvm_vcpu *vcpu, int cr, unsigned long value,
-		     unsigned long *rflags);
-int kvm_get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *data);
-int kvm_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
-
-struct x86_emulate_ctxt;
-
-int kvm_emulate_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
-		     int size, unsigned port);
-int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
-			   int size, unsigned long count, int down,
-			    gva_t address, int rep, unsigned port);
-void kvm_emulate_cpuid(struct kvm_vcpu *vcpu);
-int kvm_emulate_halt(struct kvm_vcpu *vcpu);
-int emulate_invlpg(struct kvm_vcpu *vcpu, gva_t address);
-int emulate_clts(struct kvm_vcpu *vcpu);
-int emulator_get_dr(struct x86_emulate_ctxt *ctxt, int dr,
-		    unsigned long *dest);
-int emulator_set_dr(struct x86_emulate_ctxt *ctxt, int dr,
-		    unsigned long value);
-
-void set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
-void set_cr3(struct kvm_vcpu *vcpu, unsigned long cr0);
-void set_cr4(struct kvm_vcpu *vcpu, unsigned long cr0);
-void set_cr8(struct kvm_vcpu *vcpu, unsigned long cr0);
-unsigned long get_cr8(struct kvm_vcpu *vcpu);
-void lmsw(struct kvm_vcpu *vcpu, unsigned long msw);
-void kvm_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l);
-
-int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata);
-int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data);
-
-void fx_init(struct kvm_vcpu *vcpu);
-
 void kvm_vcpu_block(struct kvm_vcpu *vcpu);
 void kvm_resched(struct kvm_vcpu *vcpu);
 void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
 void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
 void kvm_flush_remote_tlbs(struct kvm *kvm);
 
-int emulator_read_std(unsigned long addr,
-		      void *val,
-		      unsigned int bytes,
-		      struct kvm_vcpu *vcpu);
-int emulator_write_emulated(unsigned long addr,
-			    const void *val,
-			    unsigned int bytes,
-			    struct kvm_vcpu *vcpu);
-
-unsigned long segment_base(u16 selector);
-
-void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
-		       const u8 *new, int bytes);
-int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva);
-void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu);
-int kvm_mmu_load(struct kvm_vcpu *vcpu);
-void kvm_mmu_unload(struct kvm_vcpu *vcpu);
-
-int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
-
-int kvm_fix_hypercall(struct kvm_vcpu *vcpu);
-
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg);
 long kvm_arch_vcpu_ioctl(struct file *filp,
diff --git a/drivers/kvm/x86.h b/drivers/kvm/x86.h
index f1c43ca..90b791b 100644
--- a/drivers/kvm/x86.h
+++ b/drivers/kvm/x86.h
@@ -225,6 +225,90 @@ struct kvm_x86_ops {
 
 extern struct kvm_x86_ops *kvm_x86_ops;
 
+int kvm_mmu_module_init(void);
+void kvm_mmu_module_exit(void);
+
+void kvm_mmu_destroy(struct kvm_vcpu *vcpu);
+int kvm_mmu_create(struct kvm_vcpu *vcpu);
+int kvm_mmu_setup(struct kvm_vcpu *vcpu);
+void kvm_mmu_set_nonpresent_ptes(u64 trap_pte, u64 notrap_pte);
+
+int kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
+void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot);
+void kvm_mmu_zap_all(struct kvm *kvm);
+void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages);
+
+enum emulation_result {
+	EMULATE_DONE,       /* no further processing */
+	EMULATE_DO_MMIO,      /* kvm_run filled with mmio request */
+	EMULATE_FAIL,         /* can't emulate this instruction */
+};
+
+int emulate_instruction(struct kvm_vcpu *vcpu, struct kvm_run *run,
+			unsigned long cr2, u16 error_code, int no_decode);
+void kvm_report_emulation_failure(struct kvm_vcpu *cvpu, const char *context);
+void realmode_lgdt(struct kvm_vcpu *vcpu, u16 size, unsigned long address);
+void realmode_lidt(struct kvm_vcpu *vcpu, u16 size, unsigned long address);
+void realmode_lmsw(struct kvm_vcpu *vcpu, unsigned long msw,
+		   unsigned long *rflags);
+
+unsigned long realmode_get_cr(struct kvm_vcpu *vcpu, int cr);
+void realmode_set_cr(struct kvm_vcpu *vcpu, int cr, unsigned long value,
+		     unsigned long *rflags);
+int kvm_get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *data);
+int kvm_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
+
+struct x86_emulate_ctxt;
+
+int kvm_emulate_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
+		     int size, unsigned port);
+int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
+			   int size, unsigned long count, int down,
+			    gva_t address, int rep, unsigned port);
+void kvm_emulate_cpuid(struct kvm_vcpu *vcpu);
+int kvm_emulate_halt(struct kvm_vcpu *vcpu);
+int emulate_invlpg(struct kvm_vcpu *vcpu, gva_t address);
+int emulate_clts(struct kvm_vcpu *vcpu);
+int emulator_get_dr(struct x86_emulate_ctxt *ctxt, int dr,
+		    unsigned long *dest);
+int emulator_set_dr(struct x86_emulate_ctxt *ctxt, int dr,
+		    unsigned long value);
+
+void set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
+void set_cr3(struct kvm_vcpu *vcpu, unsigned long cr0);
+void set_cr4(struct kvm_vcpu *vcpu, unsigned long cr0);
+void set_cr8(struct kvm_vcpu *vcpu, unsigned long cr0);
+unsigned long get_cr8(struct kvm_vcpu *vcpu);
+void lmsw(struct kvm_vcpu *vcpu, unsigned long msw);
+void kvm_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l);
+
+int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata);
+int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data);
+
+void fx_init(struct kvm_vcpu *vcpu);
+
+int emulator_read_std(unsigned long addr,
+		      void *val,
+		      unsigned int bytes,
+		      struct kvm_vcpu *vcpu);
+int emulator_write_emulated(unsigned long addr,
+			    const void *val,
+			    unsigned int bytes,
+			    struct kvm_vcpu *vcpu);
+
+unsigned long segment_base(u16 selector);
+
+void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
+		       const u8 *new, int bytes);
+int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva);
+void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu);
+int kvm_mmu_load(struct kvm_vcpu *vcpu);
+void kvm_mmu_unload(struct kvm_vcpu *vcpu);
+
+int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
+
+int kvm_fix_hypercall(struct kvm_vcpu *vcpu);
+
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t gva, u32 error_code);
 
 static inline void kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
-- 
1.5.3.7

