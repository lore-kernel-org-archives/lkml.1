Return-Path: <linux-kernel-owner+w=401wt.eu-S1758332AbXL3HVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332AbXL3HVm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756490AbXL3HLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:24 -0500
Received: from il.qumranet.com ([82.166.9.18]:59498 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753863AbXL3HKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:48 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Jerone Young <jyoung5@us.ibm.com>
Subject: [PATCH 30/52] KVM: Portability: Move kvm_sregs and msr structures to <asm/kvm.h>
Date: Sun, 30 Dec 2007 09:10:16 +0200
Message-Id: <1198998638-22713-31-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jerone Young <jyoung5@us.ibm.com>

Move structures:
	kvm_sregs
	kvm_msr_entry
	kvm_msrs
	kvm_msr_list

from include/linux/kvm.h to include/asm-x86/kvm.h

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/asm-x86/kvm.h |   36 ++++++++++++++++++++++++++++++++++++
 include/linux/kvm.h   |   36 ------------------------------------
 2 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/include/asm-x86/kvm.h b/include/asm-x86/kvm.h
index 644a325..32c7dda 100644
--- a/include/asm-x86/kvm.h
+++ b/include/asm-x86/kvm.h
@@ -9,6 +9,9 @@
 #include <asm/types.h>
 #include <linux/ioctl.h>
 
+/* Architectural interrupt line count. */
+#define KVM_NR_INTERRUPTS 256
+
 struct kvm_memory_alias {
 	__u32 slot;  /* this has a different namespace than memory slots */
 	__u32 flags;
@@ -99,4 +102,37 @@ struct kvm_dtable {
 };
 
 
+/* for KVM_GET_SREGS and KVM_SET_SREGS */
+struct kvm_sregs {
+	/* out (KVM_GET_SREGS) / in (KVM_SET_SREGS) */
+	struct kvm_segment cs, ds, es, fs, gs, ss;
+	struct kvm_segment tr, ldt;
+	struct kvm_dtable gdt, idt;
+	__u64 cr0, cr2, cr3, cr4, cr8;
+	__u64 efer;
+	__u64 apic_base;
+	__u64 interrupt_bitmap[(KVM_NR_INTERRUPTS + 63) / 64];
+};
+
+struct kvm_msr_entry {
+	__u32 index;
+	__u32 reserved;
+	__u64 data;
+};
+
+/* for KVM_GET_MSRS and KVM_SET_MSRS */
+struct kvm_msrs {
+	__u32 nmsrs; /* number of msrs in entries */
+	__u32 pad;
+
+	struct kvm_msr_entry entries[0];
+};
+
+/* for KVM_GET_MSR_INDEX_LIST */
+struct kvm_msr_list {
+	__u32 nmsrs; /* number of msrs in entries */
+	__u32 indices[0];
+};
+
+
 #endif
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 442cb58..e6867aa 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -13,9 +13,6 @@
 
 #define KVM_API_VERSION 12
 
-/* Architectural interrupt line count. */
-#define KVM_NR_INTERRUPTS 256
-
 /* for KVM_CREATE_MEMORY_REGION */
 struct kvm_memory_region {
 	__u32 slot;
@@ -151,39 +148,6 @@ struct kvm_fpu {
 };
 
 
-
-/* for KVM_GET_SREGS and KVM_SET_SREGS */
-struct kvm_sregs {
-	/* out (KVM_GET_SREGS) / in (KVM_SET_SREGS) */
-	struct kvm_segment cs, ds, es, fs, gs, ss;
-	struct kvm_segment tr, ldt;
-	struct kvm_dtable gdt, idt;
-	__u64 cr0, cr2, cr3, cr4, cr8;
-	__u64 efer;
-	__u64 apic_base;
-	__u64 interrupt_bitmap[(KVM_NR_INTERRUPTS + 63) / 64];
-};
-
-struct kvm_msr_entry {
-	__u32 index;
-	__u32 reserved;
-	__u64 data;
-};
-
-/* for KVM_GET_MSRS and KVM_SET_MSRS */
-struct kvm_msrs {
-	__u32 nmsrs; /* number of msrs in entries */
-	__u32 pad;
-
-	struct kvm_msr_entry entries[0];
-};
-
-/* for KVM_GET_MSR_INDEX_LIST */
-struct kvm_msr_list {
-	__u32 nmsrs; /* number of msrs in entries */
-	__u32 indices[0];
-};
-
 /* for KVM_TRANSLATE */
 struct kvm_translation {
 	/* in */
-- 
1.5.3.7

