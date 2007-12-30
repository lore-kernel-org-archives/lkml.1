Return-Path: <linux-kernel-owner+w=401wt.eu-S1757544AbXL3HQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbXL3HQZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756315AbXL3HLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:03 -0500
Received: from il.qumranet.com ([82.166.9.18]:59477 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843AbXL3HKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:45 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 15/52] KVM: Move some static inline functions out from kvm.h into x86.h
Date: Sun, 30 Dec 2007 09:10:01 +0200
Message-Id: <1198998638-22713-16-git-send-email-avi@qumranet.com>
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
 drivers/kvm/kvm.h |  109 ----------------------------------------------------
 drivers/kvm/x86.h |  110 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 110 insertions(+), 109 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 1c4de50..41f6ee2 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -577,115 +577,6 @@ static inline int memslot_id(struct kvm *kvm, struct kvm_memory_slot *slot)
 	return slot - kvm->memslots;
 }
 
-static inline struct kvm_mmu_page *page_header(hpa_t shadow_page)
-{
-	struct page *page = pfn_to_page(shadow_page >> PAGE_SHIFT);
-
-	return (struct kvm_mmu_page *)page_private(page);
-}
-
-static inline u16 read_fs(void)
-{
-	u16 seg;
-	asm("mov %%fs, %0" : "=g"(seg));
-	return seg;
-}
-
-static inline u16 read_gs(void)
-{
-	u16 seg;
-	asm("mov %%gs, %0" : "=g"(seg));
-	return seg;
-}
-
-static inline u16 read_ldt(void)
-{
-	u16 ldt;
-	asm("sldt %0" : "=g"(ldt));
-	return ldt;
-}
-
-static inline void load_fs(u16 sel)
-{
-	asm("mov %0, %%fs" : : "rm"(sel));
-}
-
-static inline void load_gs(u16 sel)
-{
-	asm("mov %0, %%gs" : : "rm"(sel));
-}
-
-#ifndef load_ldt
-static inline void load_ldt(u16 sel)
-{
-	asm("lldt %0" : : "rm"(sel));
-}
-#endif
-
-static inline void get_idt(struct descriptor_table *table)
-{
-	asm("sidt %0" : "=m"(*table));
-}
-
-static inline void get_gdt(struct descriptor_table *table)
-{
-	asm("sgdt %0" : "=m"(*table));
-}
-
-static inline unsigned long read_tr_base(void)
-{
-	u16 tr;
-	asm("str %0" : "=g"(tr));
-	return segment_base(tr);
-}
-
-#ifdef CONFIG_X86_64
-static inline unsigned long read_msr(unsigned long msr)
-{
-	u64 value;
-
-	rdmsrl(msr, value);
-	return value;
-}
-#endif
-
-static inline void fx_save(struct i387_fxsave_struct *image)
-{
-	asm("fxsave (%0)":: "r" (image));
-}
-
-static inline void fx_restore(struct i387_fxsave_struct *image)
-{
-	asm("fxrstor (%0)":: "r" (image));
-}
-
-static inline void fpu_init(void)
-{
-	asm("finit");
-}
-
-static inline u32 get_rdx_init_val(void)
-{
-	return 0x600; /* P6 family */
-}
-
-#define ASM_VMX_VMCLEAR_RAX       ".byte 0x66, 0x0f, 0xc7, 0x30"
-#define ASM_VMX_VMLAUNCH          ".byte 0x0f, 0x01, 0xc2"
-#define ASM_VMX_VMRESUME          ".byte 0x0f, 0x01, 0xc3"
-#define ASM_VMX_VMPTRLD_RAX       ".byte 0x0f, 0xc7, 0x30"
-#define ASM_VMX_VMREAD_RDX_RAX    ".byte 0x0f, 0x78, 0xd0"
-#define ASM_VMX_VMWRITE_RAX_RDX   ".byte 0x0f, 0x79, 0xd0"
-#define ASM_VMX_VMWRITE_RSP_RDX   ".byte 0x0f, 0x79, 0xd4"
-#define ASM_VMX_VMXOFF            ".byte 0x0f, 0x01, 0xc4"
-#define ASM_VMX_VMXON_RAX         ".byte 0xf3, 0x0f, 0xc7, 0x30"
-
-#define MSR_IA32_TIME_STAMP_COUNTER		0x010
-
-#define TSS_IOPB_BASE_OFFSET 0x66
-#define TSS_BASE_SIZE 0x68
-#define TSS_IOPB_SIZE (65536 / 8)
-#define TSS_REDIRECTION_SIZE (256 / 8)
-#define RMODE_TSS_SIZE (TSS_BASE_SIZE + TSS_REDIRECTION_SIZE + TSS_IOPB_SIZE + 1)
 
 enum kvm_stat_kind {
 	KVM_STAT_VM,
diff --git a/drivers/kvm/x86.h b/drivers/kvm/x86.h
index 77a4a4a..f1c43ca 100644
--- a/drivers/kvm/x86.h
+++ b/drivers/kvm/x86.h
@@ -267,4 +267,114 @@ static inline int is_paging(struct kvm_vcpu *vcpu)
 
 int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
 int complete_pio(struct kvm_vcpu *vcpu);
+
+static inline struct kvm_mmu_page *page_header(hpa_t shadow_page)
+{
+	struct page *page = pfn_to_page(shadow_page >> PAGE_SHIFT);
+
+	return (struct kvm_mmu_page *)page_private(page);
+}
+
+static inline u16 read_fs(void)
+{
+	u16 seg;
+	asm("mov %%fs, %0" : "=g"(seg));
+	return seg;
+}
+
+static inline u16 read_gs(void)
+{
+	u16 seg;
+	asm("mov %%gs, %0" : "=g"(seg));
+	return seg;
+}
+
+static inline u16 read_ldt(void)
+{
+	u16 ldt;
+	asm("sldt %0" : "=g"(ldt));
+	return ldt;
+}
+
+static inline void load_fs(u16 sel)
+{
+	asm("mov %0, %%fs" : : "rm"(sel));
+}
+
+static inline void load_gs(u16 sel)
+{
+	asm("mov %0, %%gs" : : "rm"(sel));
+}
+
+#ifndef load_ldt
+static inline void load_ldt(u16 sel)
+{
+	asm("lldt %0" : : "rm"(sel));
+}
+#endif
+
+static inline void get_idt(struct descriptor_table *table)
+{
+	asm("sidt %0" : "=m"(*table));
+}
+
+static inline void get_gdt(struct descriptor_table *table)
+{
+	asm("sgdt %0" : "=m"(*table));
+}
+
+static inline unsigned long read_tr_base(void)
+{
+	u16 tr;
+	asm("str %0" : "=g"(tr));
+	return segment_base(tr);
+}
+
+#ifdef CONFIG_X86_64
+static inline unsigned long read_msr(unsigned long msr)
+{
+	u64 value;
+
+	rdmsrl(msr, value);
+	return value;
+}
+#endif
+
+static inline void fx_save(struct i387_fxsave_struct *image)
+{
+	asm("fxsave (%0)":: "r" (image));
+}
+
+static inline void fx_restore(struct i387_fxsave_struct *image)
+{
+	asm("fxrstor (%0)":: "r" (image));
+}
+
+static inline void fpu_init(void)
+{
+	asm("finit");
+}
+
+static inline u32 get_rdx_init_val(void)
+{
+	return 0x600; /* P6 family */
+}
+
+#define ASM_VMX_VMCLEAR_RAX       ".byte 0x66, 0x0f, 0xc7, 0x30"
+#define ASM_VMX_VMLAUNCH          ".byte 0x0f, 0x01, 0xc2"
+#define ASM_VMX_VMRESUME          ".byte 0x0f, 0x01, 0xc3"
+#define ASM_VMX_VMPTRLD_RAX       ".byte 0x0f, 0xc7, 0x30"
+#define ASM_VMX_VMREAD_RDX_RAX    ".byte 0x0f, 0x78, 0xd0"
+#define ASM_VMX_VMWRITE_RAX_RDX   ".byte 0x0f, 0x79, 0xd0"
+#define ASM_VMX_VMWRITE_RSP_RDX   ".byte 0x0f, 0x79, 0xd4"
+#define ASM_VMX_VMXOFF            ".byte 0x0f, 0x01, 0xc4"
+#define ASM_VMX_VMXON_RAX         ".byte 0xf3, 0x0f, 0xc7, 0x30"
+
+#define MSR_IA32_TIME_STAMP_COUNTER		0x010
+
+#define TSS_IOPB_BASE_OFFSET 0x66
+#define TSS_BASE_SIZE 0x68
+#define TSS_IOPB_SIZE (65536 / 8)
+#define TSS_REDIRECTION_SIZE (256 / 8)
+#define RMODE_TSS_SIZE (TSS_BASE_SIZE + TSS_REDIRECTION_SIZE + TSS_IOPB_SIZE + 1)
 #endif
-- 
1.5.3.7

