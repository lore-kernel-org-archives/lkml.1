Return-Path: <linux-kernel-owner+w=401wt.eu-S1757035AbXL3HPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035AbXL3HPG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:15:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756305AbXL3HLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:00 -0500
Received: from il.qumranet.com ([82.166.9.18]:59490 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782AbXL3HKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:44 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 14/52] KVM: Portability: Move vcpu regs enumeration definition to x86.h
Date: Sun, 30 Dec 2007 09:10:00 +0200
Message-Id: <1198998638-22713-15-git-send-email-avi@qumranet.com>
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
 drivers/kvm/kvm.h |   35 -----------------------------------
 drivers/kvm/x86.h |   35 +++++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index e4e1ff7..1c4de50 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -150,41 +150,6 @@ struct kvm_guest_debug {
 	int singlestep;
 };
 
-enum {
-	VCPU_REGS_RAX = 0,
-	VCPU_REGS_RCX = 1,
-	VCPU_REGS_RDX = 2,
-	VCPU_REGS_RBX = 3,
-	VCPU_REGS_RSP = 4,
-	VCPU_REGS_RBP = 5,
-	VCPU_REGS_RSI = 6,
-	VCPU_REGS_RDI = 7,
-#ifdef CONFIG_X86_64
-	VCPU_REGS_R8 = 8,
-	VCPU_REGS_R9 = 9,
-	VCPU_REGS_R10 = 10,
-	VCPU_REGS_R11 = 11,
-	VCPU_REGS_R12 = 12,
-	VCPU_REGS_R13 = 13,
-	VCPU_REGS_R14 = 14,
-	VCPU_REGS_R15 = 15,
-#endif
-	NR_VCPU_REGS
-};
-
-enum {
-	VCPU_SREG_CS,
-	VCPU_SREG_DS,
-	VCPU_SREG_ES,
-	VCPU_SREG_FS,
-	VCPU_SREG_GS,
-	VCPU_SREG_SS,
-	VCPU_SREG_TR,
-	VCPU_SREG_LDTR,
-};
-
-#include "x86_emulate.h"
-
 struct kvm_pio_request {
 	unsigned long count;
 	int cur_count;
diff --git a/drivers/kvm/x86.h b/drivers/kvm/x86.h
index 77b4092..77a4a4a 100644
--- a/drivers/kvm/x86.h
+++ b/drivers/kvm/x86.h
@@ -55,6 +55,41 @@
 extern spinlock_t kvm_lock;
 extern struct list_head vm_list;
 
+enum {
+	VCPU_REGS_RAX = 0,
+	VCPU_REGS_RCX = 1,
+	VCPU_REGS_RDX = 2,
+	VCPU_REGS_RBX = 3,
+	VCPU_REGS_RSP = 4,
+	VCPU_REGS_RBP = 5,
+	VCPU_REGS_RSI = 6,
+	VCPU_REGS_RDI = 7,
+#ifdef CONFIG_X86_64
+	VCPU_REGS_R8 = 8,
+	VCPU_REGS_R9 = 9,
+	VCPU_REGS_R10 = 10,
+	VCPU_REGS_R11 = 11,
+	VCPU_REGS_R12 = 12,
+	VCPU_REGS_R13 = 13,
+	VCPU_REGS_R14 = 14,
+	VCPU_REGS_R15 = 15,
+#endif
+	NR_VCPU_REGS
+};
+
+enum {
+	VCPU_SREG_CS,
+	VCPU_SREG_DS,
+	VCPU_SREG_ES,
+	VCPU_SREG_FS,
+	VCPU_SREG_GS,
+	VCPU_SREG_SS,
+	VCPU_SREG_TR,
+	VCPU_SREG_LDTR,
+};
+
+#include "x86_emulate.h"
+
 struct kvm_vcpu {
 	KVM_VCPU_COMM;
 	u64 host_tsc;
-- 
1.5.3.7

