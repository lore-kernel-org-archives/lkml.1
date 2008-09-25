Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171AbYIYMBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbYIYMBB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754894AbYIYLzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:55:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48563 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754869AbYIYLzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:55:47 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Xiantao Zhang <xiantao.zhang@intel.com>
Subject: [PATCH 16/39] KVM: ia64: add a dummy irq ack notification
Date: Thu, 25 Sep 2008 14:54:48 +0300
Message-Id: <1222343711-12508-17-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiantao Zhang <xiantao.zhang@intel.com>

Before enabling notify_acked_irq for ia64, leave the related APIs as
nop-op first.

Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/ia64/kvm/irq.h |   32 ++++++++++++++++++++++++++++++++
 virt/kvm/ioapic.c   |    2 +-
 2 files changed, 33 insertions(+), 1 deletions(-)
 create mode 100644 arch/ia64/kvm/irq.h

diff --git a/arch/ia64/kvm/irq.h b/arch/ia64/kvm/irq.h
new file mode 100644
index 0000000..f2e6545
--- /dev/null
+++ b/arch/ia64/kvm/irq.h
@@ -0,0 +1,32 @@
+/*
+ * irq.h: In-kernel interrupt controller related definitions
+ * Copyright (c) 2008, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * Authors:
+ *   Xiantao Zhang <xiantao.zhang@intel.com>
+ *
+ */
+
+#ifndef __IRQ_H
+#define __IRQ_H
+
+struct kvm;
+
+static inline void kvm_notify_acked_irq(struct kvm *kvm, unsigned gsi)
+{
+}
+
+#endif
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 515cd7c..53772bb 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -386,7 +386,7 @@ static void ioapic_mmio_write(struct kvm_io_device *this, gpa_t addr, int len,
 		break;
 #ifdef	CONFIG_IA64
 	case IOAPIC_REG_EOI:
-		kvm_ioapic_update_eoi(ioapic->kvm, data);
+		kvm_ioapic_update_eoi(ioapic->kvm, data, IOAPIC_LEVEL_TRIG);
 		break;
 #endif
 
-- 
1.6.0.1

