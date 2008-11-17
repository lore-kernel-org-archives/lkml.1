Return-Path: <linux-kernel-owner+w=401wt.eu-S1755824AbYKQVI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbYKQVI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 16:08:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbYKQVE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 16:04:56 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48392 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579AbYKQVEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 16:04:46 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Zachary Amsden <zach@vmware.com>,
       kexec@lists.infradead.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 03/12] kvm: vmx: move ASM_VMX_* definitions from asm/kvm_host.h to asm/vmx.h
Date: Mon, 17 Nov 2008 19:03:15 -0200
Message-Id: <1226955804-16802-4-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1226955804-16802-1-git-send-email-ehabkost@redhat.com>
References: <1226955804-16802-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those definitions will be used by code outside KVM, so move it outside
of a KVM-specific source file.

Those definitions are used only on kvm/vmx.c, that already includes
asm/vmx.h, so they can be moved safely.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |   12 ------------
 arch/x86/include/asm/vmx.h      |   15 +++++++++++++++
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8346be8..caad194 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -702,18 +702,6 @@ static inline void kvm_inject_gp(struct kvm_vcpu *vcpu, u32 error_code)
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
index ec5edc3..e8aa699 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -356,4 +356,19 @@ enum vmcs_field {
 
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
1.5.5.GIT

