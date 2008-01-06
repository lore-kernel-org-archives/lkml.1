Return-Path: <linux-kernel-owner+w=401wt.eu-S1758964AbYAFOlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964AbYAFOlx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:41:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758094AbYAFOjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:39:51 -0500
Received: from il.qumranet.com ([82.166.9.18]:46607 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755029AbYAFOjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:39:43 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 07/33] KVM: Portability: Expand the KVM_VCPU_COMM in kvm_vcpu structure.
Date: Sun,  6 Jan 2008 16:39:13 +0200
Message-Id: <1199630379-28638-8-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199630379-28638-1-git-send-email-avi@qumranet.com>
References: <1199630379-28638-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

This patches removes KVM_COMM macro, original it is hold
kvm_vcpu common fields.

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Acked-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h |   53 ++++++++++++++++++++++-------------------------------
 1 files changed, 22 insertions(+), 31 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 53717be..039faa7 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -87,41 +87,32 @@ struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus, gpa_t addr);
 void kvm_io_bus_register_dev(struct kvm_io_bus *bus,
 			     struct kvm_io_device *dev);
 
+struct kvm_vcpu {
+	struct kvm *kvm;
+	struct preempt_notifier preempt_notifier;
+	int vcpu_id;
+	struct mutex mutex;
+	int   cpu;
+	struct kvm_run *run;
+	int guest_mode;
+	unsigned long requests;
+	struct kvm_guest_debug guest_debug;
+	int fpu_active;
+	int guest_fpu_loaded;
+	wait_queue_head_t wq;
+	int sigset_active;
+	sigset_t sigset;
+	struct kvm_vcpu_stat stat;
+
 #ifdef CONFIG_HAS_IOMEM
-#define KVM_VCPU_MMIO 			\
-	int mmio_needed;		\
-	int mmio_read_completed;	\
-	int mmio_is_write;		\
-	int mmio_size;			\
-	unsigned char mmio_data[8];	\
+	int mmio_needed;
+	int mmio_read_completed;
+	int mmio_is_write;
+	int mmio_size;
+	unsigned char mmio_data[8];
 	gpa_t mmio_phys_addr;
-
-#else
-#define KVM_VCPU_MMIO
-
 #endif
 
-#define KVM_VCPU_COMM 					\
-	struct kvm *kvm; 				\
-	struct preempt_notifier preempt_notifier;	\
-	int vcpu_id;					\
-	struct mutex mutex;				\
-	int   cpu;					\
-	struct kvm_run *run;				\
-	int guest_mode;					\
-	unsigned long requests;				\
-	struct kvm_guest_debug guest_debug;		\
-	int fpu_active; 				\
-	int guest_fpu_loaded;				\
-	wait_queue_head_t wq;				\
-	int sigset_active;				\
-	sigset_t sigset;				\
-	struct kvm_vcpu_stat stat;			\
-	KVM_VCPU_MMIO
-
-struct kvm_vcpu {
-	KVM_VCPU_COMM;
-
 	struct kvm_vcpu_arch arch;
 };
 
-- 
1.5.3.7

