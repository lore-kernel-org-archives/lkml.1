Return-Path: <linux-kernel-owner+w=401wt.eu-S1759111AbYCCXgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759111AbYCCXgd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 18:36:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762805AbYCCXgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 18:36:19 -0500
Received: from gv-out-0910.google.com ([216.239.58.184]:22363 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762672AbYCCXgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 18:36:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fTefumhm511TVCeNgOHR/mvfSVYlMnUzSmRnCsou7mcxKGO5Flsk8G/QaisLTPbrtCxX36RfxA5kj/nIUwyWfT5ZCdyf0mShBIlILkRvvaMGm7KW4b9F8uRx++kJR3lUPrt7buidgUcoW/FgOsIyvuQlE68e/J3Jo35FxXvLUSQ=
Subject: [PATCH] security: replace remaining __FUNCTION__ occurences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 15:36:04 -0800
Message-Id: <1204587364.22933.26.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 security/commoncap.c           |    4 ++--
 security/keys/internal.h       |    8 ++++----
 security/root_plug.c           |    2 +-
 security/security.c            |    8 ++++----
 security/selinux/hooks.c       |   16 ++++++++--------
 security/selinux/netlink.c     |    2 +-
 security/selinux/selinuxfs.c   |    8 ++++----
 security/selinux/ss/services.c |    4 ++--
 8 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index bb0c095..4796a0a 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -267,7 +267,7 @@ static int get_file_caps(struct linux_binprm *bprm)
 	rc = cap_from_disk(&vcaps, bprm, rc);
 	if (rc)
 		printk(KERN_NOTICE "%s: cap_from_disk returned %d for %s\n",
-			__FUNCTION__, rc, bprm->filename);
+			__func__, rc, bprm->filename);
 
 out:
 	dput(dentry);
@@ -302,7 +302,7 @@ int cap_bprm_set_security (struct linux_binprm *bprm)
 	ret = get_file_caps(bprm);
 	if (ret)
 		printk(KERN_NOTICE "%s: get_file_caps returned %d for %s\n",
-			__FUNCTION__, ret, bprm->filename);
+			__func__, ret, bprm->filename);
 
 	/*  To support inheritance of root-permissions and suid-root
 	 *  executables under compatibility mode, we raise all three
diff --git a/security/keys/internal.h b/security/keys/internal.h
index d36d693..7d894ef 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -22,16 +22,16 @@ void no_printk(const char *fmt, ...)
 
 #ifdef __KDEBUG
 #define kenter(FMT, ...) \
-	printk(KERN_DEBUG "==> %s("FMT")\n", __FUNCTION__, ##__VA_ARGS__)
+	printk(KERN_DEBUG "==> %s("FMT")\n", __func__, ##__VA_ARGS__)
 #define kleave(FMT, ...) \
-	printk(KERN_DEBUG "<== %s()"FMT"\n", __FUNCTION__, ##__VA_ARGS__)
+	printk(KERN_DEBUG "<== %s()"FMT"\n", __func__, ##__VA_ARGS__)
 #define kdebug(FMT, ...) \
 	printk(KERN_DEBUG "xxx" FMT"yyy\n", ##__VA_ARGS__)
 #else
 #define kenter(FMT, ...) \
-	no_printk(KERN_DEBUG "==> %s("FMT")\n", __FUNCTION__, ##__VA_ARGS__)
+	no_printk(KERN_DEBUG "==> %s("FMT")\n", __func__, ##__VA_ARGS__)
 #define kleave(FMT, ...) \
-	no_printk(KERN_DEBUG "<== %s()"FMT"\n", __FUNCTION__, ##__VA_ARGS__)
+	no_printk(KERN_DEBUG "<== %s()"FMT"\n", __func__, ##__VA_ARGS__)
 #define kdebug(FMT, ...) \
 	no_printk(KERN_DEBUG FMT"\n", ##__VA_ARGS__)
 #endif
diff --git a/security/root_plug.c b/security/root_plug.c
index 870f130..6112d14 100644
--- a/security/root_plug.c
+++ b/security/root_plug.c
@@ -49,7 +49,7 @@ module_param(debug, bool, 0600);
 	do {							\
 		if (debug)					\
 			printk(KERN_DEBUG "%s: %s: " fmt ,	\
-				MY_NAME , __FUNCTION__ , 	\
+				MY_NAME , __func__ , 	\
 				## arg);			\
 	} while (0)
 
diff --git a/security/security.c b/security/security.c
index d15e56c..aeeacee 100644
--- a/security/security.c
+++ b/security/security.c
@@ -57,7 +57,7 @@ int __init security_init(void)
 
 	if (verify(&dummy_security_ops)) {
 		printk(KERN_ERR "%s could not verify "
-		       "dummy_security_ops structure.\n", __FUNCTION__);
+		       "dummy_security_ops structure.\n", __func__);
 		return -EIO;
 	}
 
@@ -82,7 +82,7 @@ int register_security(struct security_operations *ops)
 {
 	if (verify(ops)) {
 		printk(KERN_DEBUG "%s could not verify "
-		       "security_operations structure.\n", __FUNCTION__);
+		       "security_operations structure.\n", __func__);
 		return -EINVAL;
 	}
 
@@ -110,13 +110,13 @@ int mod_reg_security(const char *name, struct security_operations *ops)
 {
 	if (verify(ops)) {
 		printk(KERN_INFO "%s could not verify "
-		       "security operations.\n", __FUNCTION__);
+		       "security operations.\n", __func__);
 		return -EINVAL;
 	}
 
 	if (ops == security_ops) {
 		printk(KERN_INFO "%s security operations "
-		       "already registered.\n", __FUNCTION__);
+		       "already registered.\n", __func__);
 		return -EINVAL;
 	}
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 75c2e99..5137ac2 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -663,7 +663,7 @@ static int selinux_set_mnt_opts(struct super_block *sb, char **mount_options,
 	rc = security_fs_use(sb->s_type->name, &sbsec->behavior, &sbsec->sid);
 	if (rc) {
 		printk(KERN_WARNING "%s: security_fs_use(%s) returned %d\n",
-		       __FUNCTION__, sb->s_type->name, rc);
+		       __func__, sb->s_type->name, rc);
 		goto out;
 	}
 
@@ -1119,7 +1119,7 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 		}
 		if (!dentry) {
 			printk(KERN_WARNING "%s:  no dentry for dev=%s "
-			       "ino=%ld\n", __FUNCTION__, inode->i_sb->s_id,
+			       "ino=%ld\n", __func__, inode->i_sb->s_id,
 			       inode->i_ino);
 			goto out_unlock;
 		}
@@ -1157,7 +1157,7 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 		if (rc < 0) {
 			if (rc != -ENODATA) {
 				printk(KERN_WARNING "%s:  getxattr returned "
-				       "%d for dev=%s ino=%ld\n", __FUNCTION__,
+				       "%d for dev=%s ino=%ld\n", __func__,
 				       -rc, inode->i_sb->s_id, inode->i_ino);
 				kfree(context);
 				goto out_unlock;
@@ -1171,7 +1171,7 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 			if (rc) {
 				printk(KERN_WARNING "%s:  context_to_sid(%s) "
 				       "returned %d for dev=%s ino=%ld\n",
-				       __FUNCTION__, context, -rc,
+				       __func__, context, -rc,
 				       inode->i_sb->s_id, inode->i_ino);
 				kfree(context);
 				/* Leave with the unlabeled SID */
@@ -2393,7 +2393,7 @@ static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
 			printk(KERN_WARNING "%s:  "
 			       "security_transition_sid failed, rc=%d (dev=%s "
 			       "ino=%ld)\n",
-			       __FUNCTION__,
+			       __func__,
 			       -rc, inode->i_sb->s_id, inode->i_ino);
 			return rc;
 		}
@@ -2627,7 +2627,7 @@ static void selinux_inode_post_setxattr(struct dentry *dentry, char *name,
 	rc = security_context_to_sid(value, size, &newsid);
 	if (rc) {
 		printk(KERN_WARNING "%s:  unable to obtain SID for context "
-		       "%s, rc=%d\n", __FUNCTION__, (char*)value, -rc);
+		       "%s, rc=%d\n", __func__, (char*)value, -rc);
 		return;
 	}
 
@@ -4975,14 +4975,14 @@ static int selinux_register_security (const char *name, struct security_operatio
 {
 	if (secondary_ops != original_ops) {
 		printk(KERN_ERR "%s:  There is already a secondary security "
-		       "module registered.\n", __FUNCTION__);
+		       "module registered.\n", __func__);
 		return -EINVAL;
  	}
 
 	secondary_ops = ops;
 
 	printk(KERN_INFO "%s:  Registering secondary module %s\n",
-	       __FUNCTION__,
+	       __func__,
 	       name);
 
 	return 0;
diff --git a/security/selinux/netlink.c b/security/selinux/netlink.c
index b59871d..6214a7a 100644
--- a/security/selinux/netlink.c
+++ b/security/selinux/netlink.c
@@ -89,7 +89,7 @@ out:
 nlmsg_failure:
 	kfree_skb(skb);
 oom:
-	printk(KERN_ERR "SELinux:  OOM in %s\n", __FUNCTION__);
+	printk(KERN_ERR "SELinux:  OOM in %s\n", __func__);
 	goto out;
 }
 
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 0341567..0c89077 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -391,7 +391,7 @@ static ssize_t sel_write_context(struct file * file, char *buf, size_t size)
 
 	if (len > SIMPLE_TRANSACTION_LIMIT) {
 		printk(KERN_ERR "%s:  context size (%u) exceeds payload "
-		       "max\n", __FUNCTION__, len);
+		       "max\n", __func__, len);
 		length = -ERANGE;
 		goto out;
 	}
@@ -644,7 +644,7 @@ static ssize_t sel_write_create(struct file * file, char *buf, size_t size)
 
 	if (len > SIMPLE_TRANSACTION_LIMIT) {
 		printk(KERN_ERR "%s:  context size (%u) exceeds payload "
-		       "max\n", __FUNCTION__, len);
+		       "max\n", __func__, len);
 		length = -ERANGE;
 		goto out3;
 	}
@@ -821,7 +821,7 @@ static ssize_t sel_write_member(struct file * file, char *buf, size_t size)
 
 	if (len > SIMPLE_TRANSACTION_LIMIT) {
 		printk(KERN_ERR "%s:  context size (%u) exceeds payload "
-		       "max\n", __FUNCTION__, len);
+		       "max\n", __func__, len);
 		length = -ERANGE;
 		goto out3;
 	}
@@ -1760,7 +1760,7 @@ static int sel_fill_super(struct super_block * sb, void * data, int silent)
 out:
 	return ret;
 err:
-	printk(KERN_ERR "%s:  failed while creating inodes\n", __FUNCTION__);
+	printk(KERN_ERR "%s:  failed while creating inodes\n", __func__);
 	goto out;
 }
 
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index f374186..9bca7ad 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -412,7 +412,7 @@ static int context_struct_compute_av(struct context *scontext,
 	return 0;
 
 inval_class:
-	printk(KERN_ERR "%s:  unrecognized class %d\n", __FUNCTION__, tclass);
+	printk(KERN_ERR "%s:  unrecognized class %d\n", __func__, tclass);
 	return -EINVAL;
 }
 
@@ -2201,7 +2201,7 @@ int security_get_permissions(char *class, char ***perms, int *nperms)
 	match = hashtab_search(policydb.p_classes.table, class);
 	if (!match) {
 		printk(KERN_ERR "%s:  unrecognized class %s\n",
-			__FUNCTION__, class);
+			__func__, class);
 		rc = -EINVAL;
 		goto out;
 	}
-- 
1.5.4.3.500.g83a2c



