Return-Path: <linux-kernel-owner+w=401wt.eu-S1759413AbXL3H1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413AbXL3H1h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:27:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756206AbXL3HLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:39 -0500
Received: from il.qumranet.com ([82.166.9.18]:59497 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753816AbXL3HKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:47 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Jerone Young <jyoung5@us.ibm.com>
Subject: [PATCH 28/52] KVM: Portability: Move structure lapic_state to <asm/kvm.h>
Date: Sun, 30 Dec 2007 09:10:14 +0200
Message-Id: <1198998638-22713-29-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jerone Young <jyoung5@us.ibm.com>

This patch moves structure lapic_state from include/linux/kvm.h
to include/asm-x86/kvm.h

Signed-off-by: Jerone Young <jyoung5@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/asm-x86/kvm.h |    6 ++++++
 include/linux/kvm.h   |    5 -----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/asm-x86/kvm.h b/include/asm-x86/kvm.h
index c83a2ff..a2c65b5 100644
--- a/include/asm-x86/kvm.h
+++ b/include/asm-x86/kvm.h
@@ -76,4 +76,10 @@ struct kvm_regs {
 	__u64 rip, rflags;
 };
 
+/* for KVM_GET_LAPIC and KVM_SET_LAPIC */
+#define KVM_APIC_REG_SIZE 0x400
+struct kvm_lapic_state {
+	char regs[KVM_APIC_REG_SIZE];
+};
+
 #endif
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 0d83efc..280ec0d 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -150,11 +150,6 @@ struct kvm_fpu {
 	__u32 pad2;
 };
 
-/* for KVM_GET_LAPIC and KVM_SET_LAPIC */
-#define KVM_APIC_REG_SIZE 0x400
-struct kvm_lapic_state {
-	char regs[KVM_APIC_REG_SIZE];
-};
 
 struct kvm_segment {
 	__u64 base;
-- 
1.5.3.7

