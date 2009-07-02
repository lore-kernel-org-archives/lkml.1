Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbZGBFdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbZGBFdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 01:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbZGBFcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 01:32:11 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:58731 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbZGBFcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 01:32:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jutW/yOcGZkSDfVa31Vy+haJo7D9NQXacBX2Q0fVW1kSCtWzyYAAwnlDu25z474MNZ
         hNbAL4eqlWWybUDBGpNiOns22RKJKf4pavto43V8QrTWirq/3OVUck3nbMu9ObORV4pF
         DdfhYnlwtr76sQfEEEvobwmvQ8e6phcIFBHA0=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: selinux@tycho.nsa.gov, "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 7/8] SELinux selinuxfs.c non trivial fixes.
Date: Wed,  1 Jul 2009 22:32:46 -0700
Message-Id: <1246512767-2999-8-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1246512767-2999-1-git-send-email-justinmattock@gmail.com>
References: <1246512767-2999-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

Fix some comments.
Fix some debug messages.
---
 security/selinux/selinuxfs.c |   61 +++++++++++++++++++++--------------------
 1 files changed, 31 insertions(+), 30 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index b4fc506..97d728b 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -58,17 +58,17 @@ __setup("checkreqprot=", checkreqprot_setup);
 
 static DEFINE_MUTEX(sel_mutex);
 
-/* global data for booleans */
+/* Global data for booleans. */
 static struct dentry *bool_dir;
 static int bool_num;
 static char **bool_pending_names;
 static int *bool_pending_values;
 
-/* global data for classes */
+/* Global data for classes. */
 static struct dentry *class_dir;
 static unsigned long last_class_ino;
 
-/* global data for policy capabilities */
+/* Global data for policy capabilities. */
 static struct dentry *policycap_dir;
 
 extern void selnl_notify_setenforce(int val);
@@ -94,23 +94,23 @@ static int task_has_security(struct task_struct *tsk,
 
 enum sel_inos {
 	SEL_ROOT_INO = 2,
-	SEL_LOAD,	/* load policy */
-	SEL_ENFORCE,	/* get or set enforcing status */
+	SEL_LOAD,	/* Load policy. */
+	SEL_ENFORCE,	/* Get or set enforcing status. */
 	SEL_CONTEXT,	/* validate context */
-	SEL_ACCESS,	/* compute access decision */
-	SEL_CREATE,	/* compute create labeling decision */
-	SEL_RELABEL,	/* compute relabeling decision */
-	SEL_USER,	/* compute reachable user contexts */
-	SEL_POLICYVERS,	/* return policy version for this kernel */
-	SEL_COMMIT_BOOLS, /* commit new boolean values */
-	SEL_MLS,	/* return if MLS policy is enabled */
-	SEL_DISABLE,	/* disable SELinux until next reboot */
-	SEL_MEMBER,	/* compute polyinstantiation membership decision */
-	SEL_CHECKREQPROT, /* check requested protection, not kernel-applied one */
-	SEL_COMPAT_NET,	/* whether to use old compat network packet controls */
-	SEL_REJECT_UNKNOWN, /* export unknown reject handling to userspace */
-	SEL_DENY_UNKNOWN, /* export unknown deny handling to userspace */
-	SEL_INO_NEXT,	/* The next inode number to use */
+	SEL_ACCESS,	/* Compute access decision. */
+	SEL_CREATE,	/* Compute create labeling decision. */
+	SEL_RELABEL,	/* Compute relabeling decision. */
+	SEL_USER,	/* Compute reachable user contexts. */
+	SEL_POLICYVERS,	/* Return policy version for this kernel. */
+	SEL_COMMIT_BOOLS, /* Commit new boolean values. */
+	SEL_MLS,	/* Return if MLS policy is enabled. */
+	SEL_DISABLE,	/* Disable SELinux until next reboot. */
+	SEL_MEMBER,	/* Compute polyinstantiation membership decision. */
+	SEL_CHECKREQPROT, /* Check requested protection, not kernel-applied one. */
+	SEL_COMPAT_NET,	/* Whether to use old compat network packet controls. */
+	SEL_REJECT_UNKNOWN, /* Export unknown reject handling to userspace. */
+	SEL_DENY_UNKNOWN, /* Export unknown deny handling to userspace. */
+	SEL_INO_NEXT,	/* The next inode number to use. */
 };
 
 static unsigned long sel_last_ino = SEL_INO_NEXT - 1;
@@ -267,7 +267,7 @@ static const struct file_operations sel_policyvers_ops = {
 	.read		= sel_read_policyvers,
 };
 
-/* declaration for sel_write_load */
+/* Declaration for sel_write_load. */
 static int sel_make_bools(void);
 static int sel_make_classes(void);
 static int sel_make_policycap(void);
@@ -377,7 +377,7 @@ static ssize_t sel_write_context(struct file *file, char *buf, size_t size)
 
 	if (len > SIMPLE_TRANSACTION_LIMIT) {
 		printk(KERN_ERR "SELinux: %s:  context size (%u) exceeds "
-			"payload max\n", __func__, len);
+			"payload max.\n", __func__, len);
 		length = -ERANGE;
 		goto out;
 	}
@@ -581,7 +581,7 @@ static ssize_t sel_write_create(struct file *file, char *buf, size_t size)
 
 	if (len > SIMPLE_TRANSACTION_LIMIT) {
 		printk(KERN_ERR "SELinux: %s:  context size (%u) exceeds "
-			"payload max\n", __func__, len);
+			"payload max.\n", __func__, len);
 		length = -ERANGE;
 		goto out3;
 	}
@@ -978,7 +978,7 @@ static int sel_make_bools(void)
 	int *values = NULL;
 	u32 sid;
 
-	/* remove any existing files */
+	/* Remove any existing files. */
 	kfree(bool_pending_names);
 	kfree(bool_pending_values);
 	bool_pending_names = NULL;
@@ -1400,7 +1400,8 @@ static int sel_make_perm_files(char *objclass, int classvalue,
 			goto out1;
 		}
 		inode->i_fop = &sel_perm_ops;
-		/* i+1 since perm values are 1-indexed */
+		/* i+1 Since perm values are 1-indexed. */
+
 		inode->i_ino = sel_perm_to_ino(classvalue, i+1);
 		d_add(dentry, inode);
 	}
@@ -1481,14 +1482,14 @@ static int sel_make_classes(void)
 	int rc = 0, nclasses, i;
 	char **classes;
 
-	/* delete any existing entries */
+	/* Delete any existing entries. */
 	sel_remove_classes();
 
 	rc = security_get_classes(&classes, &nclasses);
 	if (rc < 0)
 		goto out;
 
-	/* +2 since classes are 1-indexed */
+	/* +2 Since classes are 1-indexed. */
 	last_class_ino = sel_class_to_ino(nclasses+2);
 
 	for (i = 0; i < nclasses; i++) {
@@ -1564,10 +1565,10 @@ static int sel_make_dir(struct inode *dir, struct dentry *dentry,
 	inode->i_op = &simple_dir_inode_operations;
 	inode->i_fop = &simple_dir_operations;
 	inode->i_ino = ++(*ino);
-	/* directory inodes start off with i_nlink == 2 (for "." entry) */
+	/* Directory inodes start off with i_nlink == 2 (for "." entry). */
 	inc_nlink(inode);
 	d_add(dentry, inode);
-	/* bump link count on parent directory, too */
+	/* Bump link count on parent directory, too. */
 	inc_nlink(dir);
 out:
 	return ret;
@@ -1692,7 +1693,7 @@ static int sel_fill_super(struct super_block *sb, void *data, int silent)
 out:
 	return ret;
 err:
-	printk(KERN_ERR "SELinux: %s:  failed while creating inodes\n",
+	printk(KERN_ERR "SELinux: %s:  Failed while creating inodes.\n",
 		__func__);
 	goto out;
 }
@@ -1722,7 +1723,7 @@ static int __init init_sel_fs(void)
 	if (!err) {
 		selinuxfs_mount = kern_mount(&sel_fs_type);
 		if (IS_ERR(selinuxfs_mount)) {
-			printk(KERN_ERR "selinuxfs:  could not mount!\n");
+			printk(KERN_ERR "selinuxfs:  Could not mount!\n");
 			err = PTR_ERR(selinuxfs_mount);
 			selinuxfs_mount = NULL;
 		}
-- 
1.6.3.2

