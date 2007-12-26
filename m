Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbXLZLPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbXLZLPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:15:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbXLZLGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:44 -0500
Received: from il.qumranet.com ([82.166.9.18]:50490 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbXLZLGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:07 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 32/55] KVM: Portability: Make exported debugfs data architecture-specific
Date: Wed, 26 Dec 2007 13:05:37 +0200
Message-Id: <1198667160-22953-33-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    7 +++++++
 drivers/kvm/kvm_main.c |   25 -------------------------
 drivers/kvm/x86.c      |   22 ++++++++++++++++++++++
 3 files changed, 29 insertions(+), 25 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 22317d6..d030a82 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -761,4 +761,11 @@ static inline u32 get_rdx_init_val(void)
 #define TSS_REDIRECTION_SIZE (256 / 8)
 #define RMODE_TSS_SIZE (TSS_BASE_SIZE + TSS_REDIRECTION_SIZE + TSS_IOPB_SIZE + 1)
 
+struct kvm_stats_debugfs_item {
+	const char *name;
+	int offset;
+	struct dentry *dentry;
+};
+extern struct kvm_stats_debugfs_item debugfs_entries[];
+
 #endif
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index ad4c84c..11580be 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -63,31 +63,6 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_cache);
 
 static __read_mostly struct preempt_ops kvm_preempt_ops;
 
-#define STAT_OFFSET(x) offsetof(struct kvm_vcpu, stat.x)
-
-static struct kvm_stats_debugfs_item {
-	const char *name;
-	int offset;
-	struct dentry *dentry;
-} debugfs_entries[] = {
-	{ "pf_fixed", STAT_OFFSET(pf_fixed) },
-	{ "pf_guest", STAT_OFFSET(pf_guest) },
-	{ "tlb_flush", STAT_OFFSET(tlb_flush) },
-	{ "invlpg", STAT_OFFSET(invlpg) },
-	{ "exits", STAT_OFFSET(exits) },
-	{ "io_exits", STAT_OFFSET(io_exits) },
-	{ "mmio_exits", STAT_OFFSET(mmio_exits) },
-	{ "signal_exits", STAT_OFFSET(signal_exits) },
-	{ "irq_window", STAT_OFFSET(irq_window_exits) },
-	{ "halt_exits", STAT_OFFSET(halt_exits) },
-	{ "halt_wakeup", STAT_OFFSET(halt_wakeup) },
-	{ "request_irq", STAT_OFFSET(request_irq_exits) },
-	{ "irq_exits", STAT_OFFSET(irq_exits) },
-	{ "light_exits", STAT_OFFSET(light_exits) },
-	{ "efer_reload", STAT_OFFSET(efer_reload) },
-	{ NULL }
-};
-
 static struct dentry *debugfs_dir;
 
 static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index f75e7d7..c1f10e5 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -40,6 +40,28 @@
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 #define EFER_RESERVED_BITS 0xfffffffffffff2fe
 
+#define STAT_OFFSET(x) offsetof(struct kvm_vcpu, stat.x)
+
+struct kvm_stats_debugfs_item debugfs_entries[] = {
+	{ "pf_fixed", STAT_OFFSET(pf_fixed) },
+	{ "pf_guest", STAT_OFFSET(pf_guest) },
+	{ "tlb_flush", STAT_OFFSET(tlb_flush) },
+	{ "invlpg", STAT_OFFSET(invlpg) },
+	{ "exits", STAT_OFFSET(exits) },
+	{ "io_exits", STAT_OFFSET(io_exits) },
+	{ "mmio_exits", STAT_OFFSET(mmio_exits) },
+	{ "signal_exits", STAT_OFFSET(signal_exits) },
+	{ "irq_window", STAT_OFFSET(irq_window_exits) },
+	{ "halt_exits", STAT_OFFSET(halt_exits) },
+	{ "halt_wakeup", STAT_OFFSET(halt_wakeup) },
+	{ "request_irq", STAT_OFFSET(request_irq_exits) },
+	{ "irq_exits", STAT_OFFSET(irq_exits) },
+	{ "light_exits", STAT_OFFSET(light_exits) },
+	{ "efer_reload", STAT_OFFSET(efer_reload) },
+	{ NULL }
+};
+
+
 unsigned long segment_base(u16 selector)
 {
 	struct descriptor_table gdt;
-- 
1.5.3.7

