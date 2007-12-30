Return-Path: <linux-kernel-owner+w=401wt.eu-S1758085AbXL3HSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbXL3HSg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:18:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbXL3HLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:14 -0500
Received: from il.qumranet.com ([82.166.9.18]:59486 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315AbXL3HKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:46 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Jerone Young <jyoung5@us.ibm.com>
Subject: [PATCH 25/52] KVM: Portability: Move kvm_memory_alias to asm/kvm.h
Date: Sun, 30 Dec 2007 09:10:11 +0200
Message-Id: <1198998638-22713-26-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jerone Young <jyoung5@us.ibm.com>

This patch moves sturct kvm_memory_alias from include/linux/kvm.h
to include/asm-x86/kvm.h. Also have include/linux/kvm.h include
include/asm/kvm.h.

Signed-off-by: Jerone Young <jyoung5@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/asm-x86/kvm.h |   20 ++++++++++++++++++++
 include/linux/kvm.h   |    8 +-------
 2 files changed, 21 insertions(+), 7 deletions(-)
 create mode 100644 include/asm-x86/kvm.h

diff --git a/include/asm-x86/kvm.h b/include/asm-x86/kvm.h
new file mode 100644
index 0000000..37cf8e9
--- /dev/null
+++ b/include/asm-x86/kvm.h
@@ -0,0 +1,20 @@
+#ifndef __LINUX_KVM_X86_H
+#define __LINUX_KVM_X86_H
+
+/*
+ * KVM x86 specific structures and definitions
+ *
+ */
+
+#include <asm/types.h>
+#include <linux/ioctl.h>
+
+struct kvm_memory_alias {
+	__u32 slot;  /* this has a different namespace than memory slots */
+	__u32 flags;
+	__u64 guest_phys_addr;
+	__u64 memory_size;
+	__u64 target_phys_addr;
+};
+
+#endif
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 71d33d6..d09dd5d 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -9,6 +9,7 @@
 
 #include <asm/types.h>
 #include <linux/ioctl.h>
+#include <asm/kvm.h>
 
 #define KVM_API_VERSION 12
 
@@ -35,13 +36,6 @@ struct kvm_userspace_memory_region {
 /* for kvm_memory_region::flags */
 #define KVM_MEM_LOG_DIRTY_PAGES  1UL
 
-struct kvm_memory_alias {
-	__u32 slot;  /* this has a different namespace than memory slots */
-	__u32 flags;
-	__u64 guest_phys_addr;
-	__u64 memory_size;
-	__u64 target_phys_addr;
-};
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
-- 
1.5.3.7

