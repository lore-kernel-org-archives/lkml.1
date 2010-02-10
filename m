Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297Ab0BJRcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:32:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755353Ab0BJRXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:12 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/40] KVM: VMX: Move some cr[04] related constants to vmx.c
Date: Wed, 10 Feb 2010 19:22:34 +0200
Message-Id: <1265822589-11155-6-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They have no place in common code.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |   13 -------------
 arch/x86/kvm/vmx.c              |   13 +++++++++++++
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4f865e8..da6dee8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -38,19 +38,6 @@
 #define CR3_L_MODE_RESERVED_BITS (CR3_NONPAE_RESERVED_BITS |	\
 				  0xFFFFFF0000000000ULL)
 
-#define KVM_GUEST_CR0_MASK_UNRESTRICTED_GUEST				\
-	(X86_CR0_WP | X86_CR0_NE | X86_CR0_NW | X86_CR0_CD)
-#define KVM_GUEST_CR0_MASK						\
-	(KVM_GUEST_CR0_MASK_UNRESTRICTED_GUEST | X86_CR0_PG | X86_CR0_PE)
-#define KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST				\
-	(X86_CR0_WP | X86_CR0_NE | X86_CR0_TS | X86_CR0_MP)
-#define KVM_VM_CR0_ALWAYS_ON						\
-	(KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST | X86_CR0_PG | X86_CR0_PE)
-#define KVM_GUEST_CR4_MASK						\
-	(X86_CR4_VME | X86_CR4_PSE | X86_CR4_PAE | X86_CR4_PGE | X86_CR4_VMXE)
-#define KVM_PMODE_VM_CR4_ALWAYS_ON (X86_CR4_PAE | X86_CR4_VMXE)
-#define KVM_RMODE_VM_CR4_ALWAYS_ON (X86_CR4_VME | X86_CR4_PAE | X86_CR4_VMXE)
-
 #define INVALID_PAGE (~(hpa_t)0)
 #define UNMAPPED_GVA (~(gpa_t)0)
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 8a8e139..efbb614 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -61,6 +61,19 @@ module_param_named(unrestricted_guest,
 static int __read_mostly emulate_invalid_guest_state = 0;
 module_param(emulate_invalid_guest_state, bool, S_IRUGO);
 
+#define KVM_GUEST_CR0_MASK_UNRESTRICTED_GUEST				\
+	(X86_CR0_WP | X86_CR0_NE | X86_CR0_NW | X86_CR0_CD)
+#define KVM_GUEST_CR0_MASK						\
+	(KVM_GUEST_CR0_MASK_UNRESTRICTED_GUEST | X86_CR0_PG | X86_CR0_PE)
+#define KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST				\
+	(X86_CR0_WP | X86_CR0_NE | X86_CR0_TS | X86_CR0_MP)
+#define KVM_VM_CR0_ALWAYS_ON						\
+	(KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST | X86_CR0_PG | X86_CR0_PE)
+#define KVM_GUEST_CR4_MASK						\
+	(X86_CR4_VME | X86_CR4_PSE | X86_CR4_PAE | X86_CR4_PGE | X86_CR4_VMXE)
+#define KVM_PMODE_VM_CR4_ALWAYS_ON (X86_CR4_PAE | X86_CR4_VMXE)
+#define KVM_RMODE_VM_CR4_ALWAYS_ON (X86_CR4_VME | X86_CR4_PAE | X86_CR4_VMXE)
+
 /*
  * These 2 parameters are used to config the controls for Pause-Loop Exiting:
  * ple_gap:    upper bound on the amount of time between two successive
-- 
1.6.5.3

