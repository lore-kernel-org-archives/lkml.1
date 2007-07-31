Return-Path: <linux-kernel-owner+w=401wt.eu-S940036AbXGaFqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940036AbXGaFqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 01:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbXGaFqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 01:46:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:28408 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbXGaFqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 01:46:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:x-mailer;
        b=nRLfjp67tJb7Dh23L7/ErrldY7w2k7uOSiJIgfcpE349hYHWLSPwym06TVxmRBnvea5E+uIsWummqIGkYpDJXJskEs8hYN4ur7QzD+XHYaivKAI+lrkE/WV4Th+YJ7HRBCYq2gp/aOv/3wOIXeiFGDCmY3jjuHMBF0zA8wYp/7U=
From: Denis Cheng <crquan@gmail.com>
To: Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, chdebra@gmail.com
Subject: [PATCH] fs/gfs2: mark struct *_operations const
Date: Tue, 31 Jul 2007 13:46:17 +0800
Message-Id: <11858607771757-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.2.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

these struct *_operations are all method tables, thus should be const.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 fs/gfs2/eaops.c        |    8 ++++----
 fs/gfs2/eaops.h        |    4 ++--
 fs/gfs2/glock.c        |    2 +-
 fs/gfs2/ops_dentry.c   |    3 +--
 fs/gfs2/ops_dentry.h   |    2 +-
 fs/gfs2/ops_vm.c       |    4 ++--
 fs/gfs2/ops_vm.h       |    4 ++--
 include/linux/dcache.h |    2 +-
 include/linux/mm.h     |    2 +-
 9 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/fs/gfs2/eaops.c b/fs/gfs2/eaops.c
index 1ab3e9d..aa8dbf3 100644
--- a/fs/gfs2/eaops.c
+++ b/fs/gfs2/eaops.c
@@ -200,28 +200,28 @@ static int security_eo_remove(struct gfs2_inode *ip, struct gfs2_ea_request *er)
 	return gfs2_ea_remove_i(ip, er);
 }
 
-static struct gfs2_eattr_operations gfs2_user_eaops = {
+static const struct gfs2_eattr_operations gfs2_user_eaops = {
 	.eo_get = user_eo_get,
 	.eo_set = user_eo_set,
 	.eo_remove = user_eo_remove,
 	.eo_name = "user",
 };
 
-struct gfs2_eattr_operations gfs2_system_eaops = {
+const struct gfs2_eattr_operations gfs2_system_eaops = {
 	.eo_get = system_eo_get,
 	.eo_set = system_eo_set,
 	.eo_remove = system_eo_remove,
 	.eo_name = "system",
 };
 
-static struct gfs2_eattr_operations gfs2_security_eaops = {
+static const struct gfs2_eattr_operations gfs2_security_eaops = {
 	.eo_get = security_eo_get,
 	.eo_set = security_eo_set,
 	.eo_remove = security_eo_remove,
 	.eo_name = "security",
 };
 
-struct gfs2_eattr_operations *gfs2_ea_ops[] = {
+const struct gfs2_eattr_operations *gfs2_ea_ops[] = {
 	NULL,
 	&gfs2_user_eaops,
 	&gfs2_system_eaops,
diff --git a/fs/gfs2/eaops.h b/fs/gfs2/eaops.h
index 508b4f7..da2f7fb 100644
--- a/fs/gfs2/eaops.h
+++ b/fs/gfs2/eaops.h
@@ -22,9 +22,9 @@ struct gfs2_eattr_operations {
 
 unsigned int gfs2_ea_name2type(const char *name, const char **truncated_name);
 
-extern struct gfs2_eattr_operations gfs2_system_eaops;
+extern const struct gfs2_eattr_operations gfs2_system_eaops;
 
-extern struct gfs2_eattr_operations *gfs2_ea_ops[];
+extern const struct gfs2_eattr_operations *gfs2_ea_ops[];
 
 #endif /* __EAOPS_DOT_H__ */
 
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 3f0974e..00fe234 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -2095,7 +2095,7 @@ static int gfs2_glock_seq_show(struct seq_file *file, void *iter_ptr)
 	return 0;
 }
 
-static struct seq_operations gfs2_glock_seq_ops = {
+static const struct seq_operations gfs2_glock_seq_ops = {
 	.start = gfs2_glock_seq_start,
 	.next  = gfs2_glock_seq_next,
 	.stop  = gfs2_glock_seq_stop,
diff --git a/fs/gfs2/ops_dentry.c b/fs/gfs2/ops_dentry.c
index 793e334..1bdf016 100644
--- a/fs/gfs2/ops_dentry.c
+++ b/fs/gfs2/ops_dentry.c
@@ -108,8 +108,7 @@ static int gfs2_dhash(struct dentry *dentry, struct qstr *str)
 	return 0;
 }
 
-struct dentry_operations gfs2_dops = {
+const struct dentry_operations gfs2_dops = {
 	.d_revalidate = gfs2_drevalidate,
 	.d_hash = gfs2_dhash,
 };
-
diff --git a/fs/gfs2/ops_dentry.h b/fs/gfs2/ops_dentry.h
index 5caa3db..668a6bc 100644
--- a/fs/gfs2/ops_dentry.h
+++ b/fs/gfs2/ops_dentry.h
@@ -12,6 +12,6 @@
 
 #include <linux/dcache.h>
 
-extern struct dentry_operations gfs2_dops;
+extern const struct dentry_operations gfs2_dops;
 
 #endif /* __OPS_DENTRY_DOT_H__ */
diff --git a/fs/gfs2/ops_vm.c b/fs/gfs2/ops_vm.c
index 927d739..baa3b20 100644
--- a/fs/gfs2/ops_vm.c
+++ b/fs/gfs2/ops_vm.c
@@ -159,11 +159,11 @@ out:
 	return ret;
 }
 
-struct vm_operations_struct gfs2_vm_ops_private = {
+const struct vm_operations_struct gfs2_vm_ops_private = {
 	.fault = gfs2_private_fault,
 };
 
-struct vm_operations_struct gfs2_vm_ops_sharewrite = {
+const struct vm_operations_struct gfs2_vm_ops_sharewrite = {
 	.fault = gfs2_sharewrite_fault,
 };
 
diff --git a/fs/gfs2/ops_vm.h b/fs/gfs2/ops_vm.h
index 4ae8f43..cfefd2d 100644
--- a/fs/gfs2/ops_vm.h
+++ b/fs/gfs2/ops_vm.h
@@ -12,7 +12,7 @@
 
 #include <linux/mm.h>
 
-extern struct vm_operations_struct gfs2_vm_ops_private;
-extern struct vm_operations_struct gfs2_vm_ops_sharewrite;
+extern const struct vm_operations_struct gfs2_vm_ops_private;
+extern const struct vm_operations_struct gfs2_vm_ops_sharewrite;
 
 #endif /* __OPS_VM_DOT_H__ */
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index aab53df..9cd948e 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -104,7 +104,7 @@ struct dentry {
 	struct list_head d_subdirs;	/* our children */
 	struct list_head d_alias;	/* inode alias list */
 	unsigned long d_time;		/* used by d_revalidate */
-	struct dentry_operations *d_op;
+	const struct dentry_operations *d_op;
 	struct super_block *d_sb;	/* The root of the dentry tree */
 	void *d_fsdata;			/* fs-specific data */
 #ifdef CONFIG_PROFILING
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 655094d..c91b684 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -96,7 +96,7 @@ struct vm_area_struct {
 	struct anon_vma *anon_vma;	/* Serialized by page_table_lock */
 
 	/* Function pointers to deal with this struct. */
-	struct vm_operations_struct * vm_ops;
+	const struct vm_operations_struct * vm_ops;
 
 	/* Information about our backing store: */
 	unsigned long vm_pgoff;		/* Offset (within vm_file) in PAGE_SIZE
-- 
1.5.2.2

