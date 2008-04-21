Return-Path: <linux-kernel-owner+w=401wt.eu-S1761464AbYDUKid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761464AbYDUKid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756703AbYDUKac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:30:32 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:37886
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979AbYDUKaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:30:08 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 19/31] KVM: Rename debugfs_dir to kvm_debugfs_dir
Date: Mon, 21 Apr 2008 13:29:45 +0300
Message-Id: <1208773797-7829-20-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208773797-7829-1-git-send-email-avi@qumranet.com>
References: <1208773797-7829-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

It's a globally exported symbol now.

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/linux/kvm_host.h |    2 +-
 virt/kvm/kvm_main.c      |    8 ++++----
 virt/kvm/kvm_trace.c     |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 81d4c33..4e16682 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -315,7 +315,7 @@ struct kvm_stats_debugfs_item {
 	struct dentry *dentry;
 };
 extern struct kvm_stats_debugfs_item debugfs_entries[];
-extern struct dentry *debugfs_dir;
+extern struct dentry *kvm_debugfs_dir;
 
 #ifdef CONFIG_KVM_TRACE
 int kvm_trace_ioctl(unsigned int ioctl, unsigned long arg);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0998455..d3cb4cc 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -60,7 +60,7 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_cache);
 
 static __read_mostly struct preempt_ops kvm_preempt_ops;
 
-struct dentry *debugfs_dir;
+struct dentry *kvm_debugfs_dir;
 
 static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
 			   unsigned long arg);
@@ -1392,9 +1392,9 @@ static void kvm_init_debug(void)
 {
 	struct kvm_stats_debugfs_item *p;
 
-	debugfs_dir = debugfs_create_dir("kvm", NULL);
+	kvm_debugfs_dir = debugfs_create_dir("kvm", NULL);
 	for (p = debugfs_entries; p->name; ++p)
-		p->dentry = debugfs_create_file(p->name, 0444, debugfs_dir,
+		p->dentry = debugfs_create_file(p->name, 0444, kvm_debugfs_dir,
 						(void *)(long)p->offset,
 						stat_fops[p->kind]);
 }
@@ -1405,7 +1405,7 @@ static void kvm_exit_debug(void)
 
 	for (p = debugfs_entries; p->name; ++p)
 		debugfs_remove(p->dentry);
-	debugfs_remove(debugfs_dir);
+	debugfs_remove(kvm_debugfs_dir);
 }
 
 static int kvm_suspend(struct sys_device *dev, pm_message_t state)
diff --git a/virt/kvm/kvm_trace.c b/virt/kvm/kvm_trace.c
index 5425440..0e49547 100644
--- a/virt/kvm/kvm_trace.c
+++ b/virt/kvm/kvm_trace.c
@@ -159,12 +159,12 @@ static int do_kvm_trace_enable(struct kvm_user_trace_setup *kuts)
 
 	r = -EIO;
 	atomic_set(&kt->lost_records, 0);
-	kt->lost_file = debugfs_create_file("lost_records", 0444, debugfs_dir,
+	kt->lost_file = debugfs_create_file("lost_records", 0444, kvm_debugfs_dir,
 					    kt, &kvm_trace_lost_ops);
 	if (!kt->lost_file)
 		goto err;
 
-	kt->rchan = relay_open("trace", debugfs_dir, kuts->buf_size,
+	kt->rchan = relay_open("trace", kvm_debugfs_dir, kuts->buf_size,
 				kuts->buf_nr, &kvm_relay_callbacks, kt);
 	if (!kt->rchan)
 		goto err;
-- 
1.5.5

