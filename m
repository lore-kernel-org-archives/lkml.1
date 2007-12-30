Return-Path: <linux-kernel-owner+w=401wt.eu-S1757602AbXL3HP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602AbXL3HP6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756323AbXL3HLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:04 -0500
Received: from il.qumranet.com ([82.166.9.18]:59489 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbXL3HKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:45 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 13/52] KVM: Portability: Move struct kvm_x86_ops definition to x86.h
Date: Sun, 30 Dec 2007 09:09:59 +0200
Message-Id: <1198998638-22713-14-git-send-email-avi@qumranet.com>
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
 drivers/kvm/kvm.h |   69 -----------------------------------------------------
 drivers/kvm/x86.h |   67 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+), 69 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index aceecf4..e4e1ff7 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -386,75 +386,6 @@ struct descriptor_table {
 	unsigned long base;
 } __attribute__((packed));
 
-struct kvm_x86_ops {
-	int (*cpu_has_kvm_support)(void);          /* __init */
-	int (*disabled_by_bios)(void);             /* __init */
-	void (*hardware_enable)(void *dummy);      /* __init */
-	void (*hardware_disable)(void *dummy);
-	void (*check_processor_compatibility)(void *rtn);
-	int (*hardware_setup)(void);               /* __init */
-	void (*hardware_unsetup)(void);            /* __exit */
-
-	/* Create, but do not attach this VCPU */
-	struct kvm_vcpu *(*vcpu_create)(struct kvm *kvm, unsigned id);
-	void (*vcpu_free)(struct kvm_vcpu *vcpu);
-	int (*vcpu_reset)(struct kvm_vcpu *vcpu);
-
-	void (*prepare_guest_switch)(struct kvm_vcpu *vcpu);
-	void (*vcpu_load)(struct kvm_vcpu *vcpu, int cpu);
-	void (*vcpu_put)(struct kvm_vcpu *vcpu);
-	void (*vcpu_decache)(struct kvm_vcpu *vcpu);
-
-	int (*set_guest_debug)(struct kvm_vcpu *vcpu,
-			       struct kvm_debug_guest *dbg);
-	void (*guest_debug_pre)(struct kvm_vcpu *vcpu);
-	int (*get_msr)(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata);
-	int (*set_msr)(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
-	u64 (*get_segment_base)(struct kvm_vcpu *vcpu, int seg);
-	void (*get_segment)(struct kvm_vcpu *vcpu,
-			    struct kvm_segment *var, int seg);
-	void (*set_segment)(struct kvm_vcpu *vcpu,
-			    struct kvm_segment *var, int seg);
-	void (*get_cs_db_l_bits)(struct kvm_vcpu *vcpu, int *db, int *l);
-	void (*decache_cr4_guest_bits)(struct kvm_vcpu *vcpu);
-	void (*set_cr0)(struct kvm_vcpu *vcpu, unsigned long cr0);
-	void (*set_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
-	void (*set_cr4)(struct kvm_vcpu *vcpu, unsigned long cr4);
-	void (*set_efer)(struct kvm_vcpu *vcpu, u64 efer);
-	void (*get_idt)(struct kvm_vcpu *vcpu, struct descriptor_table *dt);
-	void (*set_idt)(struct kvm_vcpu *vcpu, struct descriptor_table *dt);
-	void (*get_gdt)(struct kvm_vcpu *vcpu, struct descriptor_table *dt);
-	void (*set_gdt)(struct kvm_vcpu *vcpu, struct descriptor_table *dt);
-	unsigned long (*get_dr)(struct kvm_vcpu *vcpu, int dr);
-	void (*set_dr)(struct kvm_vcpu *vcpu, int dr, unsigned long value,
-		       int *exception);
-	void (*cache_regs)(struct kvm_vcpu *vcpu);
-	void (*decache_regs)(struct kvm_vcpu *vcpu);
-	unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
-	void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
-
-	void (*tlb_flush)(struct kvm_vcpu *vcpu);
-	void (*inject_page_fault)(struct kvm_vcpu *vcpu,
-				  unsigned long addr, u32 err_code);
-
-	void (*inject_gp)(struct kvm_vcpu *vcpu, unsigned err_code);
-
-	void (*run)(struct kvm_vcpu *vcpu, struct kvm_run *run);
-	int (*handle_exit)(struct kvm_run *run, struct kvm_vcpu *vcpu);
-	void (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
-	void (*patch_hypercall)(struct kvm_vcpu *vcpu,
-				unsigned char *hypercall_addr);
-	int (*get_irq)(struct kvm_vcpu *vcpu);
-	void (*set_irq)(struct kvm_vcpu *vcpu, int vec);
-	void (*inject_pending_irq)(struct kvm_vcpu *vcpu);
-	void (*inject_pending_vectors)(struct kvm_vcpu *vcpu,
-				       struct kvm_run *run);
-
-	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
-};
-
-extern struct kvm_x86_ops *kvm_x86_ops;
-
 /* The guest did something we don't support. */
 #define pr_unimpl(vcpu, fmt, ...)					\
  do {									\
diff --git a/drivers/kvm/x86.h b/drivers/kvm/x86.h
index ec1d669..77b4092 100644
--- a/drivers/kvm/x86.h
+++ b/drivers/kvm/x86.h
@@ -121,6 +121,73 @@ struct kvm_vcpu {
 	struct x86_emulate_ctxt emulate_ctxt;
 };
 
+struct kvm_x86_ops {
+	int (*cpu_has_kvm_support)(void);          /* __init */
+	int (*disabled_by_bios)(void);             /* __init */
+	void (*hardware_enable)(void *dummy);      /* __init */
+	void (*hardware_disable)(void *dummy);
+	void (*check_processor_compatibility)(void *rtn);
+	int (*hardware_setup)(void);               /* __init */
+	void (*hardware_unsetup)(void);            /* __exit */
+
+	/* Create, but do not attach this VCPU */
+	struct kvm_vcpu *(*vcpu_create)(struct kvm *kvm, unsigned id);
+	void (*vcpu_free)(struct kvm_vcpu *vcpu);
+	int (*vcpu_reset)(struct kvm_vcpu *vcpu);
+
+	void (*prepare_guest_switch)(struct kvm_vcpu *vcpu);
+	void (*vcpu_load)(struct kvm_vcpu *vcpu, int cpu);
+	void (*vcpu_put)(struct kvm_vcpu *vcpu);
+	void (*vcpu_decache)(struct kvm_vcpu *vcpu);
+
+	int (*set_guest_debug)(struct kvm_vcpu *vcpu,
+			       struct kvm_debug_guest *dbg);
+	void (*guest_debug_pre)(struct kvm_vcpu *vcpu);
+	int (*get_msr)(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata);
+	int (*set_msr)(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
+	u64 (*get_segment_base)(struct kvm_vcpu *vcpu, int seg);
+	void (*get_segment)(struct kvm_vcpu *vcpu,
+			    struct kvm_segment *var, int seg);
+	void (*set_segment)(struct kvm_vcpu *vcpu,
+			    struct kvm_segment *var, int seg);
+	void (*get_cs_db_l_bits)(struct kvm_vcpu *vcpu, int *db, int *l);
+	void (*decache_cr4_guest_bits)(struct kvm_vcpu *vcpu);
+	void (*set_cr0)(struct kvm_vcpu *vcpu, unsigned long cr0);
+	void (*set_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
+	void (*set_cr4)(struct kvm_vcpu *vcpu, unsigned long cr4);
+	void (*set_efer)(struct kvm_vcpu *vcpu, u64 efer);
+	void (*get_idt)(struct kvm_vcpu *vcpu, struct descriptor_table *dt);
+	void (*set_idt)(struct kvm_vcpu *vcpu, struct descriptor_table *dt);
+	void (*get_gdt)(struct kvm_vcpu *vcpu, struct descriptor_table *dt);
+	void (*set_gdt)(struct kvm_vcpu *vcpu, struct descriptor_table *dt);
+	unsigned long (*get_dr)(struct kvm_vcpu *vcpu, int dr);
+	void (*set_dr)(struct kvm_vcpu *vcpu, int dr, unsigned long value,
+		       int *exception);
+	void (*cache_regs)(struct kvm_vcpu *vcpu);
+	void (*decache_regs)(struct kvm_vcpu *vcpu);
+	unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
+	void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
+
+	void (*tlb_flush)(struct kvm_vcpu *vcpu);
+	void (*inject_page_fault)(struct kvm_vcpu *vcpu,
+				  unsigned long addr, u32 err_code);
+
+	void (*inject_gp)(struct kvm_vcpu *vcpu, unsigned err_code);
+
+	void (*run)(struct kvm_vcpu *vcpu, struct kvm_run *run);
+	int (*handle_exit)(struct kvm_run *run, struct kvm_vcpu *vcpu);
+	void (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
+	void (*patch_hypercall)(struct kvm_vcpu *vcpu,
+				unsigned char *hypercall_addr);
+	int (*get_irq)(struct kvm_vcpu *vcpu);
+	void (*set_irq)(struct kvm_vcpu *vcpu, int vec);
+	void (*inject_pending_irq)(struct kvm_vcpu *vcpu);
+	void (*inject_pending_vectors)(struct kvm_vcpu *vcpu,
+				       struct kvm_run *run);
+
+	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
+};
+
 extern struct kvm_x86_ops *kvm_x86_ops;
 
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t gva, u32 error_code);
-- 
1.5.3.7

