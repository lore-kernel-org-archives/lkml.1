Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbXL3HOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbXL3HOa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:14:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756211AbXL3HK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:10:58 -0500
Received: from il.qumranet.com ([82.166.9.18]:59488 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbXL3HKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:44 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 12/52] KVM: Portability: Move some macro definitions from kvm.h to x86.h
Date: Sun, 30 Dec 2007 09:09:58 +0200
Message-Id: <1198998638-22713-13-git-send-email-avi@qumranet.com>
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
 drivers/kvm/kvm.h |   33 ---------------------------------
 drivers/kvm/x86.h |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index c1aa84f..aceecf4 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -20,24 +20,6 @@
 #include <linux/kvm.h>
 #include <linux/kvm_para.h>
 
-#define CR3_PAE_RESERVED_BITS ((X86_CR3_PWT | X86_CR3_PCD) - 1)
-#define CR3_NONPAE_RESERVED_BITS ((PAGE_SIZE-1) & ~(X86_CR3_PWT | X86_CR3_PCD))
-#define CR3_L_MODE_RESERVED_BITS (CR3_NONPAE_RESERVED_BITS|0xFFFFFF0000000000ULL)
-
-#define KVM_GUEST_CR0_MASK \
-	(X86_CR0_PG | X86_CR0_PE | X86_CR0_WP | X86_CR0_NE \
-	 | X86_CR0_NW | X86_CR0_CD)
-#define KVM_VM_CR0_ALWAYS_ON \
-	(X86_CR0_PG | X86_CR0_PE | X86_CR0_WP | X86_CR0_NE | X86_CR0_TS \
-	 | X86_CR0_MP)
-#define KVM_GUEST_CR4_MASK \
-	(X86_CR4_VME | X86_CR4_PSE | X86_CR4_PAE | X86_CR4_PGE | X86_CR4_VMXE)
-#define KVM_PMODE_VM_CR4_ALWAYS_ON (X86_CR4_PAE | X86_CR4_VMXE)
-#define KVM_RMODE_VM_CR4_ALWAYS_ON (X86_CR4_VME | X86_CR4_PAE | X86_CR4_VMXE)
-
-#define INVALID_PAGE (~(hpa_t)0)
-#define UNMAPPED_GVA (~(gpa_t)0)
-
 #define KVM_MAX_VCPUS 4
 #define KVM_ALIAS_SLOTS 4
 #define KVM_MEMORY_SLOTS 8
@@ -50,21 +32,6 @@
 #define KVM_REFILL_PAGES 25
 #define KVM_MAX_CPUID_ENTRIES 40
 
-#define DE_VECTOR 0
-#define UD_VECTOR 6
-#define NM_VECTOR 7
-#define DF_VECTOR 8
-#define TS_VECTOR 10
-#define NP_VECTOR 11
-#define SS_VECTOR 12
-#define GP_VECTOR 13
-#define PF_VECTOR 14
-
-#define SELECTOR_TI_MASK (1 << 2)
-#define SELECTOR_RPL_MASK 0x03
-
-#define IOPL_SHIFT 12
-
 #define KVM_PIO_PAGE_OFFSET 1
 
 /*
diff --git a/drivers/kvm/x86.h b/drivers/kvm/x86.h
index 4df0641..ec1d669 100644
--- a/drivers/kvm/x86.h
+++ b/drivers/kvm/x86.h
@@ -19,6 +19,39 @@
 #include <linux/kvm.h>
 #include <linux/kvm_para.h>
 
+#define CR3_PAE_RESERVED_BITS ((X86_CR3_PWT | X86_CR3_PCD) - 1)
+#define CR3_NONPAE_RESERVED_BITS ((PAGE_SIZE-1) & ~(X86_CR3_PWT | X86_CR3_PCD))
+#define CR3_L_MODE_RESERVED_BITS (CR3_NONPAE_RESERVED_BITS|0xFFFFFF0000000000ULL)
+
+#define KVM_GUEST_CR0_MASK \
+	(X86_CR0_PG | X86_CR0_PE | X86_CR0_WP | X86_CR0_NE \
+	 | X86_CR0_NW | X86_CR0_CD)
+#define KVM_VM_CR0_ALWAYS_ON \
+	(X86_CR0_PG | X86_CR0_PE | X86_CR0_WP | X86_CR0_NE | X86_CR0_TS \
+	 | X86_CR0_MP)
+#define KVM_GUEST_CR4_MASK \
+	(X86_CR4_VME | X86_CR4_PSE | X86_CR4_PAE | X86_CR4_PGE | X86_CR4_VMXE)
+#define KVM_PMODE_VM_CR4_ALWAYS_ON (X86_CR4_PAE | X86_CR4_VMXE)
+#define KVM_RMODE_VM_CR4_ALWAYS_ON (X86_CR4_VME | X86_CR4_PAE | X86_CR4_VMXE)
+
+#define INVALID_PAGE (~(hpa_t)0)
+#define UNMAPPED_GVA (~(gpa_t)0)
+
+#define DE_VECTOR 0
+#define UD_VECTOR 6
+#define NM_VECTOR 7
+#define DF_VECTOR 8
+#define TS_VECTOR 10
+#define NP_VECTOR 11
+#define SS_VECTOR 12
+#define GP_VECTOR 13
+#define PF_VECTOR 14
+
+#define SELECTOR_TI_MASK (1 << 2)
+#define SELECTOR_RPL_MASK 0x03
+
+#define IOPL_SHIFT 12
+
 extern spinlock_t kvm_lock;
 extern struct list_head vm_list;
 
-- 
1.5.3.7

