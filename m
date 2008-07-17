Return-Path: <linux-kernel-owner+w=401wt.eu-S1761003AbYGQQCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761003AbYGQQCA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 12:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760678AbYGQQAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 12:00:51 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:58903 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760644AbYGQQAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 12:00:49 -0400
Message-Id: <20080717160002.677803354@polymtl.ca>
References: <20080717155724.897537670@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 17 Jul 2008 11:57:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Avi Kivity <avi@qumranet.com>, kvm@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Feng(Eric) Liu" <eric.e.liu@intel.com>
Subject: [patch 1/4] kvm move VMCS Encodings to system headers
Content-Disposition: inline; filename=kvm-move-vmcs-encodings-to-system-headers.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 17 Jul 2008 16:00:13 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VMCS Encodings will be needed by the kvm-trace probes. Put them in
system-side headers instead of local header.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: 'Peter Zijlstra' <peterz@infradead.org>
CC: 'Feng(Eric) Liu' <eric.e.liu@intel.com>
CC: Avi Kivity <avi@qumranet.com>
CC: kvm@vger.kernel.org
---
 arch/x86/kvm/vmx.h         |  142 ---------------------------------------------
 include/asm-x86/kvm_host.h |  142 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 142 insertions(+), 142 deletions(-)

Index: linux-2.6-lttng/include/asm-x86/kvm_host.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86/kvm_host.h	2008-07-17 11:15:31.000000000 -0400
+++ linux-2.6-lttng/include/asm-x86/kvm_host.h	2008-07-17 11:16:30.000000000 -0400
@@ -719,4 +719,146 @@ asmlinkage void kvm_handle_fault_on_rebo
 	KVM_EX_ENTRY " 666b, 667b \n\t" \
 	".popsection"
 
+/* VMCS Encodings */
+enum vmcs_field {
+	VIRTUAL_PROCESSOR_ID            = 0x00000000,
+	GUEST_ES_SELECTOR               = 0x00000800,
+	GUEST_CS_SELECTOR               = 0x00000802,
+	GUEST_SS_SELECTOR               = 0x00000804,
+	GUEST_DS_SELECTOR               = 0x00000806,
+	GUEST_FS_SELECTOR               = 0x00000808,
+	GUEST_GS_SELECTOR               = 0x0000080a,
+	GUEST_LDTR_SELECTOR             = 0x0000080c,
+	GUEST_TR_SELECTOR               = 0x0000080e,
+	HOST_ES_SELECTOR                = 0x00000c00,
+	HOST_CS_SELECTOR                = 0x00000c02,
+	HOST_SS_SELECTOR                = 0x00000c04,
+	HOST_DS_SELECTOR                = 0x00000c06,
+	HOST_FS_SELECTOR                = 0x00000c08,
+	HOST_GS_SELECTOR                = 0x00000c0a,
+	HOST_TR_SELECTOR                = 0x00000c0c,
+	IO_BITMAP_A                     = 0x00002000,
+	IO_BITMAP_A_HIGH                = 0x00002001,
+	IO_BITMAP_B                     = 0x00002002,
+	IO_BITMAP_B_HIGH                = 0x00002003,
+	MSR_BITMAP                      = 0x00002004,
+	MSR_BITMAP_HIGH                 = 0x00002005,
+	VM_EXIT_MSR_STORE_ADDR          = 0x00002006,
+	VM_EXIT_MSR_STORE_ADDR_HIGH     = 0x00002007,
+	VM_EXIT_MSR_LOAD_ADDR           = 0x00002008,
+	VM_EXIT_MSR_LOAD_ADDR_HIGH      = 0x00002009,
+	VM_ENTRY_MSR_LOAD_ADDR          = 0x0000200a,
+	VM_ENTRY_MSR_LOAD_ADDR_HIGH     = 0x0000200b,
+	TSC_OFFSET                      = 0x00002010,
+	TSC_OFFSET_HIGH                 = 0x00002011,
+	VIRTUAL_APIC_PAGE_ADDR          = 0x00002012,
+	VIRTUAL_APIC_PAGE_ADDR_HIGH     = 0x00002013,
+	APIC_ACCESS_ADDR		= 0x00002014,
+	APIC_ACCESS_ADDR_HIGH		= 0x00002015,
+	EPT_POINTER                     = 0x0000201a,
+	EPT_POINTER_HIGH                = 0x0000201b,
+	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
+	GUEST_PHYSICAL_ADDRESS_HIGH     = 0x00002401,
+	VMCS_LINK_POINTER               = 0x00002800,
+	VMCS_LINK_POINTER_HIGH          = 0x00002801,
+	GUEST_IA32_DEBUGCTL             = 0x00002802,
+	GUEST_IA32_DEBUGCTL_HIGH        = 0x00002803,
+	GUEST_PDPTR0                    = 0x0000280a,
+	GUEST_PDPTR0_HIGH               = 0x0000280b,
+	GUEST_PDPTR1                    = 0x0000280c,
+	GUEST_PDPTR1_HIGH               = 0x0000280d,
+	GUEST_PDPTR2                    = 0x0000280e,
+	GUEST_PDPTR2_HIGH               = 0x0000280f,
+	GUEST_PDPTR3                    = 0x00002810,
+	GUEST_PDPTR3_HIGH               = 0x00002811,
+	PIN_BASED_VM_EXEC_CONTROL       = 0x00004000,
+	CPU_BASED_VM_EXEC_CONTROL       = 0x00004002,
+	EXCEPTION_BITMAP                = 0x00004004,
+	PAGE_FAULT_ERROR_CODE_MASK      = 0x00004006,
+	PAGE_FAULT_ERROR_CODE_MATCH     = 0x00004008,
+	CR3_TARGET_COUNT                = 0x0000400a,
+	VM_EXIT_CONTROLS                = 0x0000400c,
+	VM_EXIT_MSR_STORE_COUNT         = 0x0000400e,
+	VM_EXIT_MSR_LOAD_COUNT          = 0x00004010,
+	VM_ENTRY_CONTROLS               = 0x00004012,
+	VM_ENTRY_MSR_LOAD_COUNT         = 0x00004014,
+	VM_ENTRY_INTR_INFO_FIELD        = 0x00004016,
+	VM_ENTRY_EXCEPTION_ERROR_CODE   = 0x00004018,
+	VM_ENTRY_INSTRUCTION_LEN        = 0x0000401a,
+	TPR_THRESHOLD                   = 0x0000401c,
+	SECONDARY_VM_EXEC_CONTROL       = 0x0000401e,
+	VM_INSTRUCTION_ERROR            = 0x00004400,
+	VM_EXIT_REASON                  = 0x00004402,
+	VM_EXIT_INTR_INFO               = 0x00004404,
+	VM_EXIT_INTR_ERROR_CODE         = 0x00004406,
+	IDT_VECTORING_INFO_FIELD        = 0x00004408,
+	IDT_VECTORING_ERROR_CODE        = 0x0000440a,
+	VM_EXIT_INSTRUCTION_LEN         = 0x0000440c,
+	VMX_INSTRUCTION_INFO            = 0x0000440e,
+	GUEST_ES_LIMIT                  = 0x00004800,
+	GUEST_CS_LIMIT                  = 0x00004802,
+	GUEST_SS_LIMIT                  = 0x00004804,
+	GUEST_DS_LIMIT                  = 0x00004806,
+	GUEST_FS_LIMIT                  = 0x00004808,
+	GUEST_GS_LIMIT                  = 0x0000480a,
+	GUEST_LDTR_LIMIT                = 0x0000480c,
+	GUEST_TR_LIMIT                  = 0x0000480e,
+	GUEST_GDTR_LIMIT                = 0x00004810,
+	GUEST_IDTR_LIMIT                = 0x00004812,
+	GUEST_ES_AR_BYTES               = 0x00004814,
+	GUEST_CS_AR_BYTES               = 0x00004816,
+	GUEST_SS_AR_BYTES               = 0x00004818,
+	GUEST_DS_AR_BYTES               = 0x0000481a,
+	GUEST_FS_AR_BYTES               = 0x0000481c,
+	GUEST_GS_AR_BYTES               = 0x0000481e,
+	GUEST_LDTR_AR_BYTES             = 0x00004820,
+	GUEST_TR_AR_BYTES               = 0x00004822,
+	GUEST_INTERRUPTIBILITY_INFO     = 0x00004824,
+	GUEST_ACTIVITY_STATE            = 0X00004826,
+	GUEST_SYSENTER_CS               = 0x0000482A,
+	HOST_IA32_SYSENTER_CS           = 0x00004c00,
+	CR0_GUEST_HOST_MASK             = 0x00006000,
+	CR4_GUEST_HOST_MASK             = 0x00006002,
+	CR0_READ_SHADOW                 = 0x00006004,
+	CR4_READ_SHADOW                 = 0x00006006,
+	CR3_TARGET_VALUE0               = 0x00006008,
+	CR3_TARGET_VALUE1               = 0x0000600a,
+	CR3_TARGET_VALUE2               = 0x0000600c,
+	CR3_TARGET_VALUE3               = 0x0000600e,
+	EXIT_QUALIFICATION              = 0x00006400,
+	GUEST_LINEAR_ADDRESS            = 0x0000640a,
+	GUEST_CR0                       = 0x00006800,
+	GUEST_CR3                       = 0x00006802,
+	GUEST_CR4                       = 0x00006804,
+	GUEST_ES_BASE                   = 0x00006806,
+	GUEST_CS_BASE                   = 0x00006808,
+	GUEST_SS_BASE                   = 0x0000680a,
+	GUEST_DS_BASE                   = 0x0000680c,
+	GUEST_FS_BASE                   = 0x0000680e,
+	GUEST_GS_BASE                   = 0x00006810,
+	GUEST_LDTR_BASE                 = 0x00006812,
+	GUEST_TR_BASE                   = 0x00006814,
+	GUEST_GDTR_BASE                 = 0x00006816,
+	GUEST_IDTR_BASE                 = 0x00006818,
+	GUEST_DR7                       = 0x0000681a,
+	GUEST_RSP                       = 0x0000681c,
+	GUEST_RIP                       = 0x0000681e,
+	GUEST_RFLAGS                    = 0x00006820,
+	GUEST_PENDING_DBG_EXCEPTIONS    = 0x00006822,
+	GUEST_SYSENTER_ESP              = 0x00006824,
+	GUEST_SYSENTER_EIP              = 0x00006826,
+	HOST_CR0                        = 0x00006c00,
+	HOST_CR3                        = 0x00006c02,
+	HOST_CR4                        = 0x00006c04,
+	HOST_FS_BASE                    = 0x00006c06,
+	HOST_GS_BASE                    = 0x00006c08,
+	HOST_TR_BASE                    = 0x00006c0a,
+	HOST_GDTR_BASE                  = 0x00006c0c,
+	HOST_IDTR_BASE                  = 0x00006c0e,
+	HOST_IA32_SYSENTER_ESP          = 0x00006c10,
+	HOST_IA32_SYSENTER_EIP          = 0x00006c12,
+	HOST_RSP                        = 0x00006c14,
+	HOST_RIP                        = 0x00006c16,
+};
+
 #endif
Index: linux-2.6-lttng/arch/x86/kvm/vmx.h
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kvm/vmx.h	2008-07-17 11:15:17.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kvm/vmx.h	2008-07-17 11:16:30.000000000 -0400
@@ -68,148 +68,6 @@
 #define VM_ENTRY_SMM                            0x00000400
 #define VM_ENTRY_DEACT_DUAL_MONITOR             0x00000800
 
-/* VMCS Encodings */
-enum vmcs_field {
-	VIRTUAL_PROCESSOR_ID            = 0x00000000,
-	GUEST_ES_SELECTOR               = 0x00000800,
-	GUEST_CS_SELECTOR               = 0x00000802,
-	GUEST_SS_SELECTOR               = 0x00000804,
-	GUEST_DS_SELECTOR               = 0x00000806,
-	GUEST_FS_SELECTOR               = 0x00000808,
-	GUEST_GS_SELECTOR               = 0x0000080a,
-	GUEST_LDTR_SELECTOR             = 0x0000080c,
-	GUEST_TR_SELECTOR               = 0x0000080e,
-	HOST_ES_SELECTOR                = 0x00000c00,
-	HOST_CS_SELECTOR                = 0x00000c02,
-	HOST_SS_SELECTOR                = 0x00000c04,
-	HOST_DS_SELECTOR                = 0x00000c06,
-	HOST_FS_SELECTOR                = 0x00000c08,
-	HOST_GS_SELECTOR                = 0x00000c0a,
-	HOST_TR_SELECTOR                = 0x00000c0c,
-	IO_BITMAP_A                     = 0x00002000,
-	IO_BITMAP_A_HIGH                = 0x00002001,
-	IO_BITMAP_B                     = 0x00002002,
-	IO_BITMAP_B_HIGH                = 0x00002003,
-	MSR_BITMAP                      = 0x00002004,
-	MSR_BITMAP_HIGH                 = 0x00002005,
-	VM_EXIT_MSR_STORE_ADDR          = 0x00002006,
-	VM_EXIT_MSR_STORE_ADDR_HIGH     = 0x00002007,
-	VM_EXIT_MSR_LOAD_ADDR           = 0x00002008,
-	VM_EXIT_MSR_LOAD_ADDR_HIGH      = 0x00002009,
-	VM_ENTRY_MSR_LOAD_ADDR          = 0x0000200a,
-	VM_ENTRY_MSR_LOAD_ADDR_HIGH     = 0x0000200b,
-	TSC_OFFSET                      = 0x00002010,
-	TSC_OFFSET_HIGH                 = 0x00002011,
-	VIRTUAL_APIC_PAGE_ADDR          = 0x00002012,
-	VIRTUAL_APIC_PAGE_ADDR_HIGH     = 0x00002013,
-	APIC_ACCESS_ADDR		= 0x00002014,
-	APIC_ACCESS_ADDR_HIGH		= 0x00002015,
-	EPT_POINTER                     = 0x0000201a,
-	EPT_POINTER_HIGH                = 0x0000201b,
-	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
-	GUEST_PHYSICAL_ADDRESS_HIGH     = 0x00002401,
-	VMCS_LINK_POINTER               = 0x00002800,
-	VMCS_LINK_POINTER_HIGH          = 0x00002801,
-	GUEST_IA32_DEBUGCTL             = 0x00002802,
-	GUEST_IA32_DEBUGCTL_HIGH        = 0x00002803,
-	GUEST_PDPTR0                    = 0x0000280a,
-	GUEST_PDPTR0_HIGH               = 0x0000280b,
-	GUEST_PDPTR1                    = 0x0000280c,
-	GUEST_PDPTR1_HIGH               = 0x0000280d,
-	GUEST_PDPTR2                    = 0x0000280e,
-	GUEST_PDPTR2_HIGH               = 0x0000280f,
-	GUEST_PDPTR3                    = 0x00002810,
-	GUEST_PDPTR3_HIGH               = 0x00002811,
-	PIN_BASED_VM_EXEC_CONTROL       = 0x00004000,
-	CPU_BASED_VM_EXEC_CONTROL       = 0x00004002,
-	EXCEPTION_BITMAP                = 0x00004004,
-	PAGE_FAULT_ERROR_CODE_MASK      = 0x00004006,
-	PAGE_FAULT_ERROR_CODE_MATCH     = 0x00004008,
-	CR3_TARGET_COUNT                = 0x0000400a,
-	VM_EXIT_CONTROLS                = 0x0000400c,
-	VM_EXIT_MSR_STORE_COUNT         = 0x0000400e,
-	VM_EXIT_MSR_LOAD_COUNT          = 0x00004010,
-	VM_ENTRY_CONTROLS               = 0x00004012,
-	VM_ENTRY_MSR_LOAD_COUNT         = 0x00004014,
-	VM_ENTRY_INTR_INFO_FIELD        = 0x00004016,
-	VM_ENTRY_EXCEPTION_ERROR_CODE   = 0x00004018,
-	VM_ENTRY_INSTRUCTION_LEN        = 0x0000401a,
-	TPR_THRESHOLD                   = 0x0000401c,
-	SECONDARY_VM_EXEC_CONTROL       = 0x0000401e,
-	VM_INSTRUCTION_ERROR            = 0x00004400,
-	VM_EXIT_REASON                  = 0x00004402,
-	VM_EXIT_INTR_INFO               = 0x00004404,
-	VM_EXIT_INTR_ERROR_CODE         = 0x00004406,
-	IDT_VECTORING_INFO_FIELD        = 0x00004408,
-	IDT_VECTORING_ERROR_CODE        = 0x0000440a,
-	VM_EXIT_INSTRUCTION_LEN         = 0x0000440c,
-	VMX_INSTRUCTION_INFO            = 0x0000440e,
-	GUEST_ES_LIMIT                  = 0x00004800,
-	GUEST_CS_LIMIT                  = 0x00004802,
-	GUEST_SS_LIMIT                  = 0x00004804,
-	GUEST_DS_LIMIT                  = 0x00004806,
-	GUEST_FS_LIMIT                  = 0x00004808,
-	GUEST_GS_LIMIT                  = 0x0000480a,
-	GUEST_LDTR_LIMIT                = 0x0000480c,
-	GUEST_TR_LIMIT                  = 0x0000480e,
-	GUEST_GDTR_LIMIT                = 0x00004810,
-	GUEST_IDTR_LIMIT                = 0x00004812,
-	GUEST_ES_AR_BYTES               = 0x00004814,
-	GUEST_CS_AR_BYTES               = 0x00004816,
-	GUEST_SS_AR_BYTES               = 0x00004818,
-	GUEST_DS_AR_BYTES               = 0x0000481a,
-	GUEST_FS_AR_BYTES               = 0x0000481c,
-	GUEST_GS_AR_BYTES               = 0x0000481e,
-	GUEST_LDTR_AR_BYTES             = 0x00004820,
-	GUEST_TR_AR_BYTES               = 0x00004822,
-	GUEST_INTERRUPTIBILITY_INFO     = 0x00004824,
-	GUEST_ACTIVITY_STATE            = 0X00004826,
-	GUEST_SYSENTER_CS               = 0x0000482A,
-	HOST_IA32_SYSENTER_CS           = 0x00004c00,
-	CR0_GUEST_HOST_MASK             = 0x00006000,
-	CR4_GUEST_HOST_MASK             = 0x00006002,
-	CR0_READ_SHADOW                 = 0x00006004,
-	CR4_READ_SHADOW                 = 0x00006006,
-	CR3_TARGET_VALUE0               = 0x00006008,
-	CR3_TARGET_VALUE1               = 0x0000600a,
-	CR3_TARGET_VALUE2               = 0x0000600c,
-	CR3_TARGET_VALUE3               = 0x0000600e,
-	EXIT_QUALIFICATION              = 0x00006400,
-	GUEST_LINEAR_ADDRESS            = 0x0000640a,
-	GUEST_CR0                       = 0x00006800,
-	GUEST_CR3                       = 0x00006802,
-	GUEST_CR4                       = 0x00006804,
-	GUEST_ES_BASE                   = 0x00006806,
-	GUEST_CS_BASE                   = 0x00006808,
-	GUEST_SS_BASE                   = 0x0000680a,
-	GUEST_DS_BASE                   = 0x0000680c,
-	GUEST_FS_BASE                   = 0x0000680e,
-	GUEST_GS_BASE                   = 0x00006810,
-	GUEST_LDTR_BASE                 = 0x00006812,
-	GUEST_TR_BASE                   = 0x00006814,
-	GUEST_GDTR_BASE                 = 0x00006816,
-	GUEST_IDTR_BASE                 = 0x00006818,
-	GUEST_DR7                       = 0x0000681a,
-	GUEST_RSP                       = 0x0000681c,
-	GUEST_RIP                       = 0x0000681e,
-	GUEST_RFLAGS                    = 0x00006820,
-	GUEST_PENDING_DBG_EXCEPTIONS    = 0x00006822,
-	GUEST_SYSENTER_ESP              = 0x00006824,
-	GUEST_SYSENTER_EIP              = 0x00006826,
-	HOST_CR0                        = 0x00006c00,
-	HOST_CR3                        = 0x00006c02,
-	HOST_CR4                        = 0x00006c04,
-	HOST_FS_BASE                    = 0x00006c06,
-	HOST_GS_BASE                    = 0x00006c08,
-	HOST_TR_BASE                    = 0x00006c0a,
-	HOST_GDTR_BASE                  = 0x00006c0c,
-	HOST_IDTR_BASE                  = 0x00006c0e,
-	HOST_IA32_SYSENTER_ESP          = 0x00006c10,
-	HOST_IA32_SYSENTER_EIP          = 0x00006c12,
-	HOST_RSP                        = 0x00006c14,
-	HOST_RIP                        = 0x00006c16,
-};
-
 #define VMX_EXIT_REASONS_FAILED_VMENTRY         0x80000000
 
 #define EXIT_REASON_EXCEPTION_NMI       0

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
