Return-Path: <linux-kernel-owner+w=401wt.eu-S1755129AbYLIU1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbYLIU1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:27:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755298AbYLIUX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:23:28 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34855 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754747AbYLIUXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:09 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 19/44] KVM: VMX: move ASM_VMX_* definitions from asm/kvm_host.h to asm/vmx.h
Date: Tue,  9 Dec 2008 22:22:34 +0200
Message-Id: <1228854179-23002-20-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Habkost <ehabkost@redhat.com>

Those definitions will be used by code outside KVM, so move it outside
of a KVM-specific source file.

Those definitions are used only on kvm/vmx.c, that already includes
asm/vmx.h, so they can be moved safely.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |   12 ------------
 arch/x86/include/asm/vmx.h      |   15 +++++++++++++++
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 99e3cc1..f58f7eb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -714,18 +714,6 @@ static inline void kvm_inject_gp(struct kvm_vcpu *vcpu, u32 error_code)
 	kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
 }
 
-#define ASM_VMX_VMCLEAR_RAX       ".byte 0x66, 0x0f, 0xc7, 0x30"
-#define ASM_VMX_VMLAUNCH          ".byte 0x0f, 0x01, 0xc2"
-#define ASM_VMX_VMRESUME          ".byte 0x0f, 0x01, 0xc3"
-#define ASM_VMX_VMPTRLD_RAX       ".byte 0x0f, 0xc7, 0x30"
-#define ASM_VMX_VMREAD_RDX_RAX    ".byte 0x0f, 0x78, 0xd0"
-#define ASM_VMX_VMWRITE_RAX_RDX   ".byte 0x0f, 0x79, 0xd0"
-#define ASM_VMX_VMWRITE_RSP_RDX   ".byte 0x0f, 0x79, 0xd4"
-#define ASM_VMX_VMXOFF            ".byte 0x0f, 0x01, 0xc4"
-#define ASM_VMX_VMXON_RAX         ".byte 0xf3, 0x0f, 0xc7, 0x30"
-#define ASM_VMX_INVEPT		  ".byte 0x66, 0x0f, 0x38, 0x80, 0x08"
-#define ASM_VMX_INVVPID		  ".byte 0x66, 0x0f, 0x38, 0x81, 0x08"
-
 #define MSR_IA32_TIME_STAMP_COUNTER		0x010
 
 #define TSS_IOPB_BASE_OFFSET 0x66
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 3db236c..d0238e6 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -364,4 +364,19 @@ enum vmcs_field {
 
 #define VMX_EPT_IDENTITY_PAGETABLE_ADDR		0xfffbc000ul
 
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
+#define ASM_VMX_INVEPT		  ".byte 0x66, 0x0f, 0x38, 0x80, 0x08"
+#define ASM_VMX_INVVPID		  ".byte 0x66, 0x0f, 0x38, 0x81, 0x08"
+
+
+
 #endif
-- 
1.6.0.3

