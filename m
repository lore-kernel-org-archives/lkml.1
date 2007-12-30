Return-Path: <linux-kernel-owner+w=401wt.eu-S1758221AbXL3HTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221AbXL3HTi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755943AbXL3HLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:17 -0500
Received: from il.qumranet.com ([82.166.9.18]:59487 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753468AbXL3HKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:47 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Jerone Young <jyoung5@us.ibm.com>
Subject: [PATCH 29/52] KVM: Portability: Move kvm_segment & kvm_dtable structure to  <asm/kvm.h>
Date: Sun, 30 Dec 2007 09:10:15 +0200
Message-Id: <1198998638-22713-30-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jerone Young <jyoung5@us.ibm.com>

This patch moves structures:
	kvm_segment
	kvm_dtable
from include/linux/kvm.h to include/asm-x86/kvm.h

Signed-off-by: Jerone Young <jyoung5@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/asm-x86/kvm.h |   17 +++++++++++++++++
 include/linux/kvm.h   |   15 ---------------
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/include/asm-x86/kvm.h b/include/asm-x86/kvm.h
index a2c65b5..644a325 100644
--- a/include/asm-x86/kvm.h
+++ b/include/asm-x86/kvm.h
@@ -82,4 +82,21 @@ struct kvm_lapic_state {
 	char regs[KVM_APIC_REG_SIZE];
 };
 
+struct kvm_segment {
+	__u64 base;
+	__u32 limit;
+	__u16 selector;
+	__u8  type;
+	__u8  present, dpl, db, s, l, g, avl;
+	__u8  unusable;
+	__u8  padding;
+};
+
+struct kvm_dtable {
+	__u64 base;
+	__u16 limit;
+	__u16 padding[3];
+};
+
+
 #endif
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 280ec0d..442cb58 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -151,21 +151,6 @@ struct kvm_fpu {
 };
 
 
-struct kvm_segment {
-	__u64 base;
-	__u32 limit;
-	__u16 selector;
-	__u8  type;
-	__u8  present, dpl, db, s, l, g, avl;
-	__u8  unusable;
-	__u8  padding;
-};
-
-struct kvm_dtable {
-	__u64 base;
-	__u16 limit;
-	__u16 padding[3];
-};
 
 /* for KVM_GET_SREGS and KVM_SET_SREGS */
 struct kvm_sregs {
-- 
1.5.3.7

