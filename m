Return-Path: <linux-kernel-owner+w=401wt.eu-S1756735AbXLWPIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbXLWPIr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 10:08:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985AbXLWOwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:52:35 -0500
Received: from il.qumranet.com ([82.166.9.18]:35898 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754431AbXLWOvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:46 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH 39/50] KVM: Add some \n in ioapic_debug()
Date: Sun, 23 Dec 2007 16:51:24 +0200
Message-Id: <1198421495-31481-40-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Vivier <Laurent.Vivier@bull.net>

Add new-line at end of debug strings.

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/ioapic.c |   25 ++++++++++++++-----------
 1 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/kvm/ioapic.c b/drivers/kvm/ioapic.c
index c7992e6..8503d99 100644
--- a/drivers/kvm/ioapic.c
+++ b/drivers/kvm/ioapic.c
@@ -40,8 +40,11 @@
 #include <asm/apicdef.h>
 #include <asm/io_apic.h>
 #include "irq.h"
-/* #define ioapic_debug(fmt,arg...) printk(KERN_WARNING fmt,##arg) */
+#if 0
+#define ioapic_debug(fmt,arg...) printk(KERN_WARNING fmt,##arg)
+#else
 #define ioapic_debug(fmt, arg...)
+#endif
 static void ioapic_deliver(struct kvm_ioapic *vioapic, int irq);
 
 static unsigned long ioapic_read_indirect(struct kvm_ioapic *ioapic,
@@ -113,7 +116,7 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 	default:
 		index = (ioapic->ioregsel - 0x10) >> 1;
 
-		ioapic_debug("change redir index %x val %x", index, val);
+		ioapic_debug("change redir index %x val %x\n", index, val);
 		if (index >= IOAPIC_NUM_PINS)
 			return;
 		if (ioapic->ioregsel & 1) {
@@ -134,7 +137,7 @@ static void ioapic_inj_irq(struct kvm_ioapic *ioapic,
 			   struct kvm_lapic *target,
 			   u8 vector, u8 trig_mode, u8 delivery_mode)
 {
-	ioapic_debug("irq %d trig %d deliv %d", vector, trig_mode,
+	ioapic_debug("irq %d trig %d deliv %d\n", vector, trig_mode,
 		     delivery_mode);
 
 	ASSERT((delivery_mode == dest_Fixed) ||
@@ -151,7 +154,7 @@ static u32 ioapic_get_delivery_bitmask(struct kvm_ioapic *ioapic, u8 dest,
 	struct kvm *kvm = ioapic->kvm;
 	struct kvm_vcpu *vcpu;
 
-	ioapic_debug("dest %d dest_mode %d", dest, dest_mode);
+	ioapic_debug("dest %d dest_mode %d\n", dest, dest_mode);
 
 	if (dest_mode == 0) {	/* Physical mode. */
 		if (dest == 0xFF) {	/* Broadcast. */
@@ -179,7 +182,7 @@ static u32 ioapic_get_delivery_bitmask(struct kvm_ioapic *ioapic, u8 dest,
 			    kvm_apic_match_logical_addr(vcpu->apic, dest))
 				mask |= 1 << vcpu->vcpu_id;
 		}
-	ioapic_debug("mask %x", mask);
+	ioapic_debug("mask %x\n", mask);
 	return mask;
 }
 
@@ -196,12 +199,12 @@ static void ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
 	int vcpu_id;
 
 	ioapic_debug("dest=%x dest_mode=%x delivery_mode=%x "
-		     "vector=%x trig_mode=%x",
+		     "vector=%x trig_mode=%x\n",
 		     dest, dest_mode, delivery_mode, vector, trig_mode);
 
 	deliver_bitmask = ioapic_get_delivery_bitmask(ioapic, dest, dest_mode);
 	if (!deliver_bitmask) {
-		ioapic_debug("no target on destination");
+		ioapic_debug("no target on destination\n");
 		return;
 	}
 
@@ -214,7 +217,7 @@ static void ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
 				       trig_mode, delivery_mode);
 		else
 			ioapic_debug("null round robin: "
-				     "mask=%x vector=%x delivery_mode=%x",
+				     "mask=%x vector=%x delivery_mode=%x\n",
 				     deliver_bitmask, vector, dest_LowestPrio);
 		break;
 	case dest_Fixed:
@@ -304,7 +307,7 @@ static void ioapic_mmio_read(struct kvm_io_device *this, gpa_t addr, int len,
 	struct kvm_ioapic *ioapic = (struct kvm_ioapic *)this->private;
 	u32 result;
 
-	ioapic_debug("addr %lx", (unsigned long)addr);
+	ioapic_debug("addr %lx\n", (unsigned long)addr);
 	ASSERT(!(addr & 0xf));	/* check alignment */
 
 	addr &= 0xff;
@@ -341,8 +344,8 @@ static void ioapic_mmio_write(struct kvm_io_device *this, gpa_t addr, int len,
 	struct kvm_ioapic *ioapic = (struct kvm_ioapic *)this->private;
 	u32 data;
 
-	ioapic_debug("ioapic_mmio_write addr=%lx len=%d val=%p\n",
-		     addr, len, val);
+	ioapic_debug("ioapic_mmio_write addr=%p len=%d val=%p\n",
+		     (void*)addr, len, val);
 	ASSERT(!(addr & 0xf));	/* check alignment */
 	if (len == 4 || len == 8)
 		data = *(u32 *) val;
-- 
1.5.3.7

