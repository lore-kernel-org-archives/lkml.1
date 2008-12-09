Return-Path: <linux-kernel-owner+w=401wt.eu-S1757651AbYLIUe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651AbYLIUe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbYLIUYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:24:15 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34885 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754902AbYLIUXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:12 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 39/44] KVM: Add fields for MSI device assignment
Date: Tue,  9 Dec 2008 22:22:54 +0200
Message-Id: <1228854179-23002-40-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

Prepared for kvm_arch_assigned_device_msi_dispatch().

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 include/linux/kvm.h      |    7 +++++++
 include/linux/kvm_host.h |    4 ++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 44fd7fa..bb283c3 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -507,10 +507,17 @@ struct kvm_assigned_irq {
 	__u32 guest_irq;
 	__u32 flags;
 	union {
+		struct {
+			__u32 addr_lo;
+			__u32 addr_hi;
+			__u32 data;
+		} guest_msi;
 		__u32 reserved[12];
 	};
 };
 
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 
+#define KVM_DEV_IRQ_ASSIGN_ENABLE_MSI	(1 << 0)
+
 #endif
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c3d4b96..8091a4d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -16,6 +16,7 @@
 #include <linux/mm.h>
 #include <linux/preempt.h>
 #include <linux/marker.h>
+#include <linux/msi.h>
 #include <asm/signal.h>
 
 #include <linux/kvm.h>
@@ -307,8 +308,11 @@ struct kvm_assigned_dev_kernel {
 	int host_devfn;
 	int host_irq;
 	int guest_irq;
+	struct msi_msg guest_msi;
 #define KVM_ASSIGNED_DEV_GUEST_INTX	(1 << 0)
+#define KVM_ASSIGNED_DEV_GUEST_MSI	(1 << 1)
 #define KVM_ASSIGNED_DEV_HOST_INTX	(1 << 8)
+#define KVM_ASSIGNED_DEV_HOST_MSI	(1 << 9)
 	unsigned long irq_requested_type;
 	int irq_source_id;
 	struct pci_dev *dev;
-- 
1.6.0.3

