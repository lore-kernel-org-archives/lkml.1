Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbYKMRr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbYKMRr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 12:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbYKMRpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 12:45:30 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37301 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982AbYKMRpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 12:45:19 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Zachary Amsden <zach@vmware.com>,
       kexec@lists.infradead.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 02/11] kvm: vmx: move ASM_VMX_* definitions to asm/virtext.h
Date: Thu, 13 Nov 2008 15:43:42 -0200
Message-Id: <1226598231-18311-3-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1226598231-18311-1-git-send-email-ehabkost@redhat.com>
References: <1226598231-18311-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the definitions so they can be used by non-kvm code.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |   14 ++------------
 arch/x86/include/asm/virtext.h  |   17 +++++++++++++++++
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8346be8..5920e9a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -22,6 +22,8 @@
 #include <asm/pvclock-abi.h>
 #include <asm/desc.h>
 
+#include <asm/virtext.h>
+
 #define KVM_MAX_VCPUS 16
 #define KVM_MEMORY_SLOTS 32
 /* memory slots that does not exposed to userspace */
@@ -702,18 +704,6 @@ static inline void kvm_inject_gp(struct kvm_vcpu *vcpu, u32 error_code)
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
diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index 298b6a0..351fa23 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -19,6 +19,23 @@
 #include <asm/system.h>
 
 /*
+ * VMX asm instructions:
+ */
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
+/*
  * VMX functions:
  */
 
-- 
1.5.5.GIT

