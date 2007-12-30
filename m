Return-Path: <linux-kernel-owner+w=401wt.eu-S1756992AbXL3H1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992AbXL3H1P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754038AbXL3HLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:39 -0500
Received: from il.qumranet.com ([82.166.9.18]:59490 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699AbXL3HKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:47 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Jerone Young <jyoung5@us.ibm.com>
Subject: [PATCH 31/52] KVM: Portability: Move cpuid structures to <asm/kvm.h>
Date: Sun, 30 Dec 2007 09:10:17 +0200
Message-Id: <1198998638-22713-32-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jerone Young <jyoung5@us.ibm.com>

This patch moves structures:
	kvm_cpuid_entry
	kvm_cpuid

from include/linux/kvm.h to include/asm-x86/kvm.h

Signed-off-by: Jerone Young <jyoung5@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/asm-x86/kvm.h |   17 +++++++++++++++++
 include/linux/kvm.h   |   16 ----------------
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/include/asm-x86/kvm.h b/include/asm-x86/kvm.h
index 32c7dda..4837d75 100644
--- a/include/asm-x86/kvm.h
+++ b/include/asm-x86/kvm.h
@@ -135,4 +135,21 @@ struct kvm_msr_list {
 };
 
 
+struct kvm_cpuid_entry {
+	__u32 function;
+	__u32 eax;
+	__u32 ebx;
+	__u32 ecx;
+	__u32 edx;
+	__u32 padding;
+};
+
+/* for KVM_SET_CPUID */
+struct kvm_cpuid {
+	__u32 nent;
+	__u32 padding;
+	struct kvm_cpuid_entry entries[0];
+};
+
+
 #endif
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index e6867aa..fd4f900 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -192,22 +192,6 @@ struct kvm_dirty_log {
 	};
 };
 
-struct kvm_cpuid_entry {
-	__u32 function;
-	__u32 eax;
-	__u32 ebx;
-	__u32 ecx;
-	__u32 edx;
-	__u32 padding;
-};
-
-/* for KVM_SET_CPUID */
-struct kvm_cpuid {
-	__u32 nent;
-	__u32 padding;
-	struct kvm_cpuid_entry entries[0];
-};
-
 /* for KVM_SET_SIGNAL_MASK */
 struct kvm_signal_mask {
 	__u32 len;
-- 
1.5.3.7

