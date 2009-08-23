Return-Path: <linux-kernel-owner+w=401wt.eu-S933738AbZHWMCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933738AbZHWMCz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 08:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933542AbZHWL4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 07:56:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933525AbZHWL4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:48 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/46] KVM: Use temporary variable to shorten lines.
Date: Sun, 23 Aug 2009 14:56:06 +0300
Message-Id: <1251028605-31977-8-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Cosmetic only. No logic is changed by this patch.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/ioapic.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 8a9c6cc..92496ff 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -103,6 +103,7 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 {
 	unsigned index;
 	bool mask_before, mask_after;
+	union kvm_ioapic_redirect_entry *e;
 
 	switch (ioapic->ioregsel) {
 	case IOAPIC_REG_VERSION:
@@ -122,19 +123,20 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 		ioapic_debug("change redir index %x val %x\n", index, val);
 		if (index >= IOAPIC_NUM_PINS)
 			return;
-		mask_before = ioapic->redirtbl[index].fields.mask;
+		e = &ioapic->redirtbl[index];
+		mask_before = e->fields.mask;
 		if (ioapic->ioregsel & 1) {
-			ioapic->redirtbl[index].bits &= 0xffffffff;
-			ioapic->redirtbl[index].bits |= (u64) val << 32;
+			e->bits &= 0xffffffff;
+			e->bits |= (u64) val << 32;
 		} else {
-			ioapic->redirtbl[index].bits &= ~0xffffffffULL;
-			ioapic->redirtbl[index].bits |= (u32) val;
-			ioapic->redirtbl[index].fields.remote_irr = 0;
+			e->bits &= ~0xffffffffULL;
+			e->bits |= (u32) val;
+			e->fields.remote_irr = 0;
 		}
-		mask_after = ioapic->redirtbl[index].fields.mask;
+		mask_after = e->fields.mask;
 		if (mask_before != mask_after)
 			kvm_fire_mask_notifiers(ioapic->kvm, index, mask_after);
-		if (ioapic->redirtbl[index].fields.trig_mode == IOAPIC_LEVEL_TRIG
+		if (e->fields.trig_mode == IOAPIC_LEVEL_TRIG
 		    && ioapic->irr & (1 << index))
 			ioapic_service(ioapic, index);
 		break;
-- 
1.6.4.1

