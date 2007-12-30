Return-Path: <linux-kernel-owner+w=401wt.eu-S1759373AbXL3H0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373AbXL3H0v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:26:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756587AbXL3HLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:38 -0500
Received: from il.qumranet.com ([82.166.9.18]:59496 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431AbXL3HKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:47 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Jerone Young <jyoung5@us.ibm.com>
Subject: [PATCH 26/52] KVM: Portability: Move x86 pic strutctures
Date: Sun, 30 Dec 2007 09:10:12 +0200
Message-Id: <1198998638-22713-27-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jerone Young <jyoung5@us.ibm.com>

This patch moves structures:
	kvm_pic_state
	kvm_ioapic_state

to inclue/asm-x86/kvm.h.

Signed-off-by: Jerone Young <jyoung5@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/asm-x86/kvm.h |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/kvm.h   |   48 ------------------------------------------------
 2 files changed, 49 insertions(+), 48 deletions(-)

diff --git a/include/asm-x86/kvm.h b/include/asm-x86/kvm.h
index 37cf8e9..80752bc 100644
--- a/include/asm-x86/kvm.h
+++ b/include/asm-x86/kvm.h
@@ -17,4 +17,53 @@ struct kvm_memory_alias {
 	__u64 target_phys_addr;
 };
 
+/* for KVM_GET_IRQCHIP and KVM_SET_IRQCHIP */
+struct kvm_pic_state {
+	__u8 last_irr;	/* edge detection */
+	__u8 irr;		/* interrupt request register */
+	__u8 imr;		/* interrupt mask register */
+	__u8 isr;		/* interrupt service register */
+	__u8 priority_add;	/* highest irq priority */
+	__u8 irq_base;
+	__u8 read_reg_select;
+	__u8 poll;
+	__u8 special_mask;
+	__u8 init_state;
+	__u8 auto_eoi;
+	__u8 rotate_on_auto_eoi;
+	__u8 special_fully_nested_mode;
+	__u8 init4;		/* true if 4 byte init */
+	__u8 elcr;		/* PIIX edge/trigger selection */
+	__u8 elcr_mask;
+};
+
+#define KVM_IOAPIC_NUM_PINS  24
+struct kvm_ioapic_state {
+	__u64 base_address;
+	__u32 ioregsel;
+	__u32 id;
+	__u32 irr;
+	__u32 pad;
+	union {
+		__u64 bits;
+		struct {
+			__u8 vector;
+			__u8 delivery_mode:3;
+			__u8 dest_mode:1;
+			__u8 delivery_status:1;
+			__u8 polarity:1;
+			__u8 remote_irr:1;
+			__u8 trig_mode:1;
+			__u8 mask:1;
+			__u8 reserve:7;
+			__u8 reserved[4];
+			__u8 dest_id;
+		} fields;
+	} redirtbl[KVM_IOAPIC_NUM_PINS];
+};
+
+#define KVM_IRQCHIP_PIC_MASTER   0
+#define KVM_IRQCHIP_PIC_SLAVE    1
+#define KVM_IRQCHIP_IOAPIC       2
+
 #endif
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index d09dd5d..1779c3d 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -48,54 +48,6 @@ struct kvm_irq_level {
 	__u32 level;
 };
 
-/* for KVM_GET_IRQCHIP and KVM_SET_IRQCHIP */
-struct kvm_pic_state {
-	__u8 last_irr;	/* edge detection */
-	__u8 irr;		/* interrupt request register */
-	__u8 imr;		/* interrupt mask register */
-	__u8 isr;		/* interrupt service register */
-	__u8 priority_add;	/* highest irq priority */
-	__u8 irq_base;
-	__u8 read_reg_select;
-	__u8 poll;
-	__u8 special_mask;
-	__u8 init_state;
-	__u8 auto_eoi;
-	__u8 rotate_on_auto_eoi;
-	__u8 special_fully_nested_mode;
-	__u8 init4;		/* true if 4 byte init */
-	__u8 elcr;		/* PIIX edge/trigger selection */
-	__u8 elcr_mask;
-};
-
-#define KVM_IOAPIC_NUM_PINS  24
-struct kvm_ioapic_state {
-	__u64 base_address;
-	__u32 ioregsel;
-	__u32 id;
-	__u32 irr;
-	__u32 pad;
-	union {
-		__u64 bits;
-		struct {
-			__u8 vector;
-			__u8 delivery_mode:3;
-			__u8 dest_mode:1;
-			__u8 delivery_status:1;
-			__u8 polarity:1;
-			__u8 remote_irr:1;
-			__u8 trig_mode:1;
-			__u8 mask:1;
-			__u8 reserve:7;
-			__u8 reserved[4];
-			__u8 dest_id;
-		} fields;
-	} redirtbl[KVM_IOAPIC_NUM_PINS];
-};
-
-#define KVM_IRQCHIP_PIC_MASTER   0
-#define KVM_IRQCHIP_PIC_SLAVE    1
-#define KVM_IRQCHIP_IOAPIC       2
 
 struct kvm_irqchip {
 	__u32 chip_id;
-- 
1.5.3.7

