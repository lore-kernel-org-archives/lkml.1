Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbZKSNj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbZKSNj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253AbZKSNgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:36:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780AbZKSNfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:35:09 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 32/35] KVM: Reorder IOCTLs in main kvm.h
Date: Thu, 19 Nov 2009 15:35:08 +0200
Message-Id: <1258637711-11674-33-git-send-email-avi@redhat.com>
In-Reply-To: <1258637711-11674-1-git-send-email-avi@redhat.com>
References: <1258637711-11674-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Obviously, people tend to extend this header at the bottom - more or
less blindly. Ensure that deprecated stuff gets its own corner again by
moving things to the top. Also add some comments and reindent IOCTLs to
make them more readable and reduce the risk of number collisions.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 include/linux/kvm.h |  235 +++++++++++++++++++++++++--------------------------
 1 files changed, 117 insertions(+), 118 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 6ed1a12..ca62b8e 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -14,12 +14,76 @@
 
 #define KVM_API_VERSION 12
 
-/* for KVM_TRACE_ENABLE, deprecated */
+/* *** Deprecated interfaces *** */
+
+#define KVM_TRC_SHIFT           16
+
+#define KVM_TRC_ENTRYEXIT       (1 << KVM_TRC_SHIFT)
+#define KVM_TRC_HANDLER         (1 << (KVM_TRC_SHIFT + 1))
+
+#define KVM_TRC_VMENTRY         (KVM_TRC_ENTRYEXIT + 0x01)
+#define KVM_TRC_VMEXIT          (KVM_TRC_ENTRYEXIT + 0x02)
+#define KVM_TRC_PAGE_FAULT      (KVM_TRC_HANDLER + 0x01)
+
+#define KVM_TRC_HEAD_SIZE       12
+#define KVM_TRC_CYCLE_SIZE      8
+#define KVM_TRC_EXTRA_MAX       7
+
+#define KVM_TRC_INJ_VIRQ         (KVM_TRC_HANDLER + 0x02)
+#define KVM_TRC_REDELIVER_EVT    (KVM_TRC_HANDLER + 0x03)
+#define KVM_TRC_PEND_INTR        (KVM_TRC_HANDLER + 0x04)
+#define KVM_TRC_IO_READ          (KVM_TRC_HANDLER + 0x05)
+#define KVM_TRC_IO_WRITE         (KVM_TRC_HANDLER + 0x06)
+#define KVM_TRC_CR_READ          (KVM_TRC_HANDLER + 0x07)
+#define KVM_TRC_CR_WRITE         (KVM_TRC_HANDLER + 0x08)
+#define KVM_TRC_DR_READ          (KVM_TRC_HANDLER + 0x09)
+#define KVM_TRC_DR_WRITE         (KVM_TRC_HANDLER + 0x0A)
+#define KVM_TRC_MSR_READ         (KVM_TRC_HANDLER + 0x0B)
+#define KVM_TRC_MSR_WRITE        (KVM_TRC_HANDLER + 0x0C)
+#define KVM_TRC_CPUID            (KVM_TRC_HANDLER + 0x0D)
+#define KVM_TRC_INTR             (KVM_TRC_HANDLER + 0x0E)
+#define KVM_TRC_NMI              (KVM_TRC_HANDLER + 0x0F)
+#define KVM_TRC_VMMCALL          (KVM_TRC_HANDLER + 0x10)
+#define KVM_TRC_HLT              (KVM_TRC_HANDLER + 0x11)
+#define KVM_TRC_CLTS             (KVM_TRC_HANDLER + 0x12)
+#define KVM_TRC_LMSW             (KVM_TRC_HANDLER + 0x13)
+#define KVM_TRC_APIC_ACCESS      (KVM_TRC_HANDLER + 0x14)
+#define KVM_TRC_TDP_FAULT        (KVM_TRC_HANDLER + 0x15)
+#define KVM_TRC_GTLB_WRITE       (KVM_TRC_HANDLER + 0x16)
+#define KVM_TRC_STLB_WRITE       (KVM_TRC_HANDLER + 0x17)
+#define KVM_TRC_STLB_INVAL       (KVM_TRC_HANDLER + 0x18)
+#define KVM_TRC_PPC_INSTR        (KVM_TRC_HANDLER + 0x19)
+
 struct kvm_user_trace_setup {
-	__u32 buf_size; /* sub_buffer size of each per-cpu */
-	__u32 buf_nr; /* the number of sub_buffers of each per-cpu */
+	__u32 buf_size;
+	__u32 buf_nr;
+};
+
+#define __KVM_DEPRECATED_MAIN_W_0x06 \
+	_IOW(KVMIO, 0x06, struct kvm_user_trace_setup)
+#define __KVM_DEPRECATED_MAIN_0x07 _IO(KVMIO, 0x07)
+#define __KVM_DEPRECATED_MAIN_0x08 _IO(KVMIO, 0x08)
+
+#define __KVM_DEPRECATED_VM_R_0x70 _IOR(KVMIO, 0x70, struct kvm_assigned_irq)
+
+struct kvm_breakpoint {
+	__u32 enabled;
+	__u32 padding;
+	__u64 address;
+};
+
+struct kvm_debug_guest {
+	__u32 enabled;
+	__u32 pad;
+	struct kvm_breakpoint breakpoints[4];
+	__u32 singlestep;
 };
 
+#define __KVM_DEPRECATED_VCPU_W_0x87 _IOW(KVMIO, 0x87, struct kvm_debug_guest)
+
+/* *** End of deprecated interfaces *** */
+
+
 /* for KVM_CREATE_MEMORY_REGION */
 struct kvm_memory_region {
 	__u32 slot;
@@ -329,24 +393,6 @@ struct kvm_ioeventfd {
 	__u8  pad[36];
 };
 
-#define KVM_TRC_SHIFT           16
-/*
- * kvm trace categories
- */
-#define KVM_TRC_ENTRYEXIT       (1 << KVM_TRC_SHIFT)
-#define KVM_TRC_HANDLER         (1 << (KVM_TRC_SHIFT + 1)) /* only 12 bits */
-
-/*
- * kvm trace action
- */
-#define KVM_TRC_VMENTRY         (KVM_TRC_ENTRYEXIT + 0x01)
-#define KVM_TRC_VMEXIT          (KVM_TRC_ENTRYEXIT + 0x02)
-#define KVM_TRC_PAGE_FAULT      (KVM_TRC_HANDLER + 0x01)
-
-#define KVM_TRC_HEAD_SIZE       12
-#define KVM_TRC_CYCLE_SIZE      8
-#define KVM_TRC_EXTRA_MAX       7
-
 #define KVMIO 0xAE
 
 /*
@@ -367,12 +413,10 @@ struct kvm_ioeventfd {
  */
 #define KVM_GET_VCPU_MMAP_SIZE    _IO(KVMIO,   0x04) /* in bytes */
 #define KVM_GET_SUPPORTED_CPUID   _IOWR(KVMIO, 0x05, struct kvm_cpuid2)
-/*
- * ioctls for kvm trace
- */
-#define KVM_TRACE_ENABLE          _IOW(KVMIO, 0x06, struct kvm_user_trace_setup)
-#define KVM_TRACE_PAUSE           _IO(KVMIO,  0x07)
-#define KVM_TRACE_DISABLE         _IO(KVMIO,  0x08)
+#define KVM_TRACE_ENABLE          __KVM_DEPRECATED_MAIN_W_0x06
+#define KVM_TRACE_PAUSE           __KVM_DEPRECATED_MAIN_0x07
+#define KVM_TRACE_DISABLE         __KVM_DEPRECATED_MAIN_0x08
+
 /*
  * Extension capability list.
  */
@@ -522,56 +566,57 @@ struct kvm_clock_data {
 /*
  * ioctls for VM fds
  */
-#define KVM_SET_MEMORY_REGION     _IOW(KVMIO, 0x40, struct kvm_memory_region)
+#define KVM_SET_MEMORY_REGION     _IOW(KVMIO,  0x40, struct kvm_memory_region)
 /*
  * KVM_CREATE_VCPU receives as a parameter the vcpu slot, and returns
  * a vcpu fd.
  */
-#define KVM_CREATE_VCPU           _IO(KVMIO,  0x41)
-#define KVM_GET_DIRTY_LOG         _IOW(KVMIO, 0x42, struct kvm_dirty_log)
-#define KVM_SET_MEMORY_ALIAS      _IOW(KVMIO, 0x43, struct kvm_memory_alias)
-#define KVM_SET_NR_MMU_PAGES      _IO(KVMIO, 0x44)
-#define KVM_GET_NR_MMU_PAGES      _IO(KVMIO, 0x45)
-#define KVM_SET_USER_MEMORY_REGION _IOW(KVMIO, 0x46,\
+#define KVM_CREATE_VCPU           _IO(KVMIO,   0x41)
+#define KVM_GET_DIRTY_LOG         _IOW(KVMIO,  0x42, struct kvm_dirty_log)
+#define KVM_SET_MEMORY_ALIAS      _IOW(KVMIO,  0x43, struct kvm_memory_alias)
+#define KVM_SET_NR_MMU_PAGES      _IO(KVMIO,   0x44)
+#define KVM_GET_NR_MMU_PAGES      _IO(KVMIO,   0x45)
+#define KVM_SET_USER_MEMORY_REGION _IOW(KVMIO, 0x46, \
 					struct kvm_userspace_memory_region)
-#define KVM_SET_TSS_ADDR          _IO(KVMIO, 0x47)
-#define KVM_SET_IDENTITY_MAP_ADDR _IOW(KVMIO, 0x48, __u64)
+#define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
+#define KVM_SET_IDENTITY_MAP_ADDR _IOW(KVMIO,  0x48, __u64)
 /* Device model IOC */
-#define KVM_CREATE_IRQCHIP	  _IO(KVMIO,  0x60)
-#define KVM_IRQ_LINE		  _IOW(KVMIO, 0x61, struct kvm_irq_level)
-#define KVM_GET_IRQCHIP		  _IOWR(KVMIO, 0x62, struct kvm_irqchip)
-#define KVM_SET_IRQCHIP		  _IOR(KVMIO,  0x63, struct kvm_irqchip)
-#define KVM_CREATE_PIT		  _IO(KVMIO,  0x64)
-#define KVM_GET_PIT		  _IOWR(KVMIO, 0x65, struct kvm_pit_state)
-#define KVM_SET_PIT		  _IOR(KVMIO,  0x66, struct kvm_pit_state)
-#define KVM_IRQ_LINE_STATUS	  _IOWR(KVMIO, 0x67, struct kvm_irq_level)
+#define KVM_CREATE_IRQCHIP        _IO(KVMIO,   0x60)
+#define KVM_IRQ_LINE              _IOW(KVMIO,  0x61, struct kvm_irq_level)
+#define KVM_GET_IRQCHIP           _IOWR(KVMIO, 0x62, struct kvm_irqchip)
+#define KVM_SET_IRQCHIP           _IOR(KVMIO,  0x63, struct kvm_irqchip)
+#define KVM_CREATE_PIT            _IO(KVMIO,   0x64)
+#define KVM_GET_PIT               _IOWR(KVMIO, 0x65, struct kvm_pit_state)
+#define KVM_SET_PIT               _IOR(KVMIO,  0x66, struct kvm_pit_state)
+#define KVM_IRQ_LINE_STATUS       _IOWR(KVMIO, 0x67, struct kvm_irq_level)
 #define KVM_REGISTER_COALESCED_MMIO \
 			_IOW(KVMIO,  0x67, struct kvm_coalesced_mmio_zone)
 #define KVM_UNREGISTER_COALESCED_MMIO \
 			_IOW(KVMIO,  0x68, struct kvm_coalesced_mmio_zone)
-#define KVM_ASSIGN_PCI_DEVICE _IOR(KVMIO, 0x69, \
-				   struct kvm_assigned_pci_dev)
-#define KVM_SET_GSI_ROUTING       _IOW(KVMIO, 0x6a, struct kvm_irq_routing)
+#define KVM_ASSIGN_PCI_DEVICE     _IOR(KVMIO,  0x69, \
+				       struct kvm_assigned_pci_dev)
+#define KVM_SET_GSI_ROUTING       _IOW(KVMIO,  0x6a, struct kvm_irq_routing)
 /* deprecated, replaced by KVM_ASSIGN_DEV_IRQ */
-#define KVM_ASSIGN_IRQ _IOR(KVMIO, 0x70, \
-			    struct kvm_assigned_irq)
-#define KVM_ASSIGN_DEV_IRQ        _IOW(KVMIO, 0x70, struct kvm_assigned_irq)
-#define KVM_REINJECT_CONTROL      _IO(KVMIO, 0x71)
-#define KVM_DEASSIGN_PCI_DEVICE _IOW(KVMIO, 0x72, \
-				     struct kvm_assigned_pci_dev)
-#define KVM_ASSIGN_SET_MSIX_NR \
-			_IOW(KVMIO, 0x73, struct kvm_assigned_msix_nr)
-#define KVM_ASSIGN_SET_MSIX_ENTRY \
-			_IOW(KVMIO, 0x74, struct kvm_assigned_msix_entry)
-#define KVM_DEASSIGN_DEV_IRQ       _IOW(KVMIO, 0x75, struct kvm_assigned_irq)
-#define KVM_IRQFD                  _IOW(KVMIO, 0x76, struct kvm_irqfd)
-#define KVM_CREATE_PIT2		   _IOW(KVMIO, 0x77, struct kvm_pit_config)
-#define KVM_SET_BOOT_CPU_ID        _IO(KVMIO, 0x78)
-#define KVM_IOEVENTFD             _IOW(KVMIO, 0x79, struct kvm_ioeventfd)
-#define KVM_XEN_HVM_CONFIG        _IOW(KVMIO, 0x7a, struct kvm_xen_hvm_config)
-#define KVM_SET_CLOCK             _IOW(KVMIO, 0x7b, struct kvm_clock_data)
-#define KVM_GET_CLOCK             _IOR(KVMIO, 0x7c, struct kvm_clock_data)
-
+#define KVM_ASSIGN_IRQ            __KVM_DEPRECATED_VM_R_0x70
+#define KVM_ASSIGN_DEV_IRQ        _IOW(KVMIO,  0x70, struct kvm_assigned_irq)
+#define KVM_REINJECT_CONTROL      _IO(KVMIO,   0x71)
+#define KVM_DEASSIGN_PCI_DEVICE   _IOW(KVMIO,  0x72, \
+				       struct kvm_assigned_pci_dev)
+#define KVM_ASSIGN_SET_MSIX_NR    _IOW(KVMIO,  0x73, \
+				       struct kvm_assigned_msix_nr)
+#define KVM_ASSIGN_SET_MSIX_ENTRY _IOW(KVMIO,  0x74, \
+				       struct kvm_assigned_msix_entry)
+#define KVM_DEASSIGN_DEV_IRQ      _IOW(KVMIO,  0x75, struct kvm_assigned_irq)
+#define KVM_IRQFD                 _IOW(KVMIO,  0x76, struct kvm_irqfd)
+#define KVM_CREATE_PIT2		  _IOW(KVMIO,  0x77, struct kvm_pit_config)
+#define KVM_SET_BOOT_CPU_ID       _IO(KVMIO,   0x78)
+#define KVM_IOEVENTFD             _IOW(KVMIO,  0x79, struct kvm_ioeventfd)
+#define KVM_XEN_HVM_CONFIG        _IOW(KVMIO,  0x7a, struct kvm_xen_hvm_config)
+#define KVM_SET_CLOCK             _IOW(KVMIO,  0x7b, struct kvm_clock_data)
+#define KVM_GET_CLOCK             _IOR(KVMIO,  0x7c, struct kvm_clock_data)
+/* Available with KVM_CAP_PIT_STATE2 */
+#define KVM_GET_PIT2              _IOR(KVMIO,  0x9f, struct kvm_pit_state2)
+#define KVM_SET_PIT2              _IOW(KVMIO,  0xa0, struct kvm_pit_state2)
 
 /*
  * ioctls for vcpu fds
@@ -584,7 +629,7 @@ struct kvm_clock_data {
 #define KVM_TRANSLATE             _IOWR(KVMIO, 0x85, struct kvm_translation)
 #define KVM_INTERRUPT             _IOW(KVMIO,  0x86, struct kvm_interrupt)
 /* KVM_DEBUG_GUEST is no longer supported, use KVM_SET_GUEST_DEBUG instead */
-#define KVM_DEBUG_GUEST           __KVM_DEPRECATED_DEBUG_GUEST
+#define KVM_DEBUG_GUEST           __KVM_DEPRECATED_VCPU_W_0x87
 #define KVM_GET_MSRS              _IOWR(KVMIO, 0x88, struct kvm_msrs)
 #define KVM_SET_MSRS              _IOW(KVMIO,  0x89, struct kvm_msrs)
 #define KVM_SET_CPUID             _IOW(KVMIO,  0x8a, struct kvm_cpuid)
@@ -596,7 +641,7 @@ struct kvm_clock_data {
 #define KVM_SET_CPUID2            _IOW(KVMIO,  0x90, struct kvm_cpuid2)
 #define KVM_GET_CPUID2            _IOWR(KVMIO, 0x91, struct kvm_cpuid2)
 /* Available with KVM_CAP_VAPIC */
-#define KVM_TPR_ACCESS_REPORTING  _IOWR(KVMIO,  0x92, struct kvm_tpr_access_ctl)
+#define KVM_TPR_ACCESS_REPORTING  _IOWR(KVMIO, 0x92, struct kvm_tpr_access_ctl)
 /* Available with KVM_CAP_VAPIC */
 #define KVM_SET_VAPIC_ADDR        _IOW(KVMIO,  0x93, struct kvm_vapic_addr)
 /* valid for virtual machine (for floating interrupt)_and_ vcpu */
@@ -608,67 +653,21 @@ struct kvm_clock_data {
 /* initial ipl psw for s390 */
 #define KVM_S390_SET_INITIAL_PSW  _IOW(KVMIO,  0x96, struct kvm_s390_psw)
 /* initial reset for s390 */
-#define KVM_S390_INITIAL_RESET    _IO(KVMIO,  0x97)
+#define KVM_S390_INITIAL_RESET    _IO(KVMIO,   0x97)
 #define KVM_GET_MP_STATE          _IOR(KVMIO,  0x98, struct kvm_mp_state)
 #define KVM_SET_MP_STATE          _IOW(KVMIO,  0x99, struct kvm_mp_state)
 /* Available with KVM_CAP_NMI */
-#define KVM_NMI                   _IO(KVMIO,  0x9a)
+#define KVM_NMI                   _IO(KVMIO,   0x9a)
 /* Available with KVM_CAP_SET_GUEST_DEBUG */
 #define KVM_SET_GUEST_DEBUG       _IOW(KVMIO,  0x9b, struct kvm_guest_debug)
 /* MCE for x86 */
 #define KVM_X86_SETUP_MCE         _IOW(KVMIO,  0x9c, __u64)
 #define KVM_X86_GET_MCE_CAP_SUPPORTED _IOR(KVMIO,  0x9d, __u64)
 #define KVM_X86_SET_MCE           _IOW(KVMIO,  0x9e, struct kvm_x86_mce)
-
-/*
- * Deprecated interfaces
- */
-struct kvm_breakpoint {
-	__u32 enabled;
-	__u32 padding;
-	__u64 address;
-};
-
-struct kvm_debug_guest {
-	__u32 enabled;
-	__u32 pad;
-	struct kvm_breakpoint breakpoints[4];
-	__u32 singlestep;
-};
-
-#define __KVM_DEPRECATED_DEBUG_GUEST _IOW(KVMIO,  0x87, struct kvm_debug_guest)
-
+/* IA64 stack access */
 #define KVM_IA64_VCPU_GET_STACK   _IOR(KVMIO,  0x9a, void *)
 #define KVM_IA64_VCPU_SET_STACK   _IOW(KVMIO,  0x9b, void *)
 
-#define KVM_GET_PIT2   _IOR(KVMIO,   0x9f, struct kvm_pit_state2)
-#define KVM_SET_PIT2   _IOW(KVMIO,   0xa0, struct kvm_pit_state2)
-
-#define KVM_TRC_INJ_VIRQ         (KVM_TRC_HANDLER + 0x02)
-#define KVM_TRC_REDELIVER_EVT    (KVM_TRC_HANDLER + 0x03)
-#define KVM_TRC_PEND_INTR        (KVM_TRC_HANDLER + 0x04)
-#define KVM_TRC_IO_READ          (KVM_TRC_HANDLER + 0x05)
-#define KVM_TRC_IO_WRITE         (KVM_TRC_HANDLER + 0x06)
-#define KVM_TRC_CR_READ          (KVM_TRC_HANDLER + 0x07)
-#define KVM_TRC_CR_WRITE         (KVM_TRC_HANDLER + 0x08)
-#define KVM_TRC_DR_READ          (KVM_TRC_HANDLER + 0x09)
-#define KVM_TRC_DR_WRITE         (KVM_TRC_HANDLER + 0x0A)
-#define KVM_TRC_MSR_READ         (KVM_TRC_HANDLER + 0x0B)
-#define KVM_TRC_MSR_WRITE        (KVM_TRC_HANDLER + 0x0C)
-#define KVM_TRC_CPUID            (KVM_TRC_HANDLER + 0x0D)
-#define KVM_TRC_INTR             (KVM_TRC_HANDLER + 0x0E)
-#define KVM_TRC_NMI              (KVM_TRC_HANDLER + 0x0F)
-#define KVM_TRC_VMMCALL          (KVM_TRC_HANDLER + 0x10)
-#define KVM_TRC_HLT              (KVM_TRC_HANDLER + 0x11)
-#define KVM_TRC_CLTS             (KVM_TRC_HANDLER + 0x12)
-#define KVM_TRC_LMSW             (KVM_TRC_HANDLER + 0x13)
-#define KVM_TRC_APIC_ACCESS      (KVM_TRC_HANDLER + 0x14)
-#define KVM_TRC_TDP_FAULT        (KVM_TRC_HANDLER + 0x15)
-#define KVM_TRC_GTLB_WRITE       (KVM_TRC_HANDLER + 0x16)
-#define KVM_TRC_STLB_WRITE       (KVM_TRC_HANDLER + 0x17)
-#define KVM_TRC_STLB_INVAL       (KVM_TRC_HANDLER + 0x18)
-#define KVM_TRC_PPC_INSTR        (KVM_TRC_HANDLER + 0x19)
-
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 
 struct kvm_assigned_pci_dev {
@@ -722,4 +721,4 @@ struct kvm_assigned_msix_entry {
 	__u16 padding[3];
 };
 
-#endif
+#endif /* __LINUX_KVM_H */
-- 
1.6.5.2

