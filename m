Return-Path: <linux-kernel-owner+w=401wt.eu-S1757730AbXL3HTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730AbXL3HTR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755983AbXL3HLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:16 -0500
Received: from il.qumranet.com ([82.166.9.18]:59488 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463AbXL3HKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:47 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Jerone Young <jyoung5@us.ibm.com>
Subject: [PATCH 27/52] KVM: Portability: Move kvm_regs to <asm/kvm.h>
Date: Sun, 30 Dec 2007 09:10:13 +0200
Message-Id: <1198998638-22713-28-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jerone Young <jyoung5@us.ibm.com>

This patch moves structure kvm_regs to include/asm-x86/kvm.h.
Each architecture will need to create there own version of this
structure.

Signed-off-by: Jerone Young <jyoung5@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/asm-x86/kvm.h |   10 ++++++++++
 include/linux/kvm.h   |    9 ---------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/include/asm-x86/kvm.h b/include/asm-x86/kvm.h
index 80752bc..c83a2ff 100644
--- a/include/asm-x86/kvm.h
+++ b/include/asm-x86/kvm.h
@@ -66,4 +66,14 @@ struct kvm_ioapic_state {
 #define KVM_IRQCHIP_PIC_SLAVE    1
 #define KVM_IRQCHIP_IOAPIC       2
 
+/* for KVM_GET_REGS and KVM_SET_REGS */
+struct kvm_regs {
+	/* out (KVM_GET_REGS) / in (KVM_SET_REGS) */
+	__u64 rax, rbx, rcx, rdx;
+	__u64 rsi, rdi, rsp, rbp;
+	__u64 r8,  r9,  r10, r11;
+	__u64 r12, r13, r14, r15;
+	__u64 rip, rflags;
+};
+
 #endif
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 1779c3d..0d83efc 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -134,15 +134,6 @@ struct kvm_run {
 	};
 };
 
-/* for KVM_GET_REGS and KVM_SET_REGS */
-struct kvm_regs {
-	/* out (KVM_GET_REGS) / in (KVM_SET_REGS) */
-	__u64 rax, rbx, rcx, rdx;
-	__u64 rsi, rdi, rsp, rbp;
-	__u64 r8,  r9,  r10, r11;
-	__u64 r12, r13, r14, r15;
-	__u64 rip, rflags;
-};
 
 /* for KVM_GET_FPU and KVM_SET_FPU */
 struct kvm_fpu {
-- 
1.5.3.7

