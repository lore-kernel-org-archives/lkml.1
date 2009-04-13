Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059AbZDMKO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbZDMKO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 06:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbZDMKOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 06:14:47 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:62076 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbZDMKOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 06:14:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=tq+VyL8oSMYfl6zodnRllnHnGnK2Vnwa7iqbcb48sk9T1mC1T/9eT1FZP4BQX3q2m1
         6JmwjwlMBhf6tZ0g7LXmqVp2S6bu5CQxRAGsL/ETPA7V2crqiVvhyevywdEEJppn8Mw/
         NTWeeUAP6aGg4buTsX3RDTqF0vYoqp2K0px64=
MIME-Version: 1.0
Date: Mon, 13 Apr 2009 12:14:42 +0200
Message-ID: <667b0cb60904130314v53edce6fi39b25490742dbd0d@mail.gmail.com>
Subject: [PATCH]procfs: Fix checkpatch.pl errors in generic.c
From: Mateusz Mandera <ormi.linux@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It fixes checkpatch.pl errors in fs/proc/generic.c:

Signed-off-by: Mateusz Mandera <ormi.linux@gmail.com>
---
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index fa678ab..0add7e4 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -3,7 +3,7 @@
  *
  * This file contains generic proc-fs routines for handling
  * directories and files.
- *
+ *
  * Copyright (C) 1991, 1992 Linus Torvalds.
  * Copyright (C) 1997 Theodore Ts'o
  */
@@ -20,7 +20,7 @@
 #include <linux/bitops.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>

 #include "internal.h"

@@ -33,20 +33,23 @@ static int proc_match(int len, const char *name,
struct proc_dir_entry *de)
 	return !memcmp(name, de->name, len);
 }

-/* buffer size is one page but our output routines use some slack for
overruns */
+/*
+ * buffer size is one page but our output
+ * routines use some slack for overruns
+ */
 #define PROC_BLOCK_SIZE	(PAGE_SIZE - 1024)

 static ssize_t
 __proc_file_read(struct file *file, char __user *buf, size_t nbytes,
 	       loff_t *ppos)
 {
-	struct inode * inode = file->f_path.dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	char 	*page;
-	ssize_t	retval=0;
-	int	eof=0;
+	ssize_t	retval = 0;
+	int	eof = 0;
 	ssize_t	n, count;
 	char	*start;
-	struct proc_dir_entry * dp;
+	struct proc_dir_entry *dp;
 	unsigned long long pos;

 	/*
@@ -61,7 +64,8 @@ __proc_file_read(struct file *file, char __user
*buf, size_t nbytes,
 		nbytes = MAX_NON_LFS - pos;

 	dp = PDE(inode);
-	if (!(page = (char*) __get_free_page(GFP_TEMPORARY)))
+	page = (char *) __get_free_page(GFP_TEMPORARY);
+	if (!page)
 		return -ENOMEM;

 	while ((nbytes > 0) && !eof) {
@@ -87,11 +91,11 @@ __proc_file_read(struct file *file, char __user
*buf, size_t nbytes,
 			 *    offset within the buffer.  Return the number (n)
 			 *    of bytes there are from the beginning of the
 			 *    buffer up to the last byte of data.  If the
-			 *    number of supplied bytes (= n - offset) is
+			 *    number of supplied bytes (= n - offset) is
 			 *    greater than zero and you didn't signal eof
 			 *    and the reader is prepared to take more data
 			 *    you will be called again with the requested
-			 *    offset advanced by the number of bytes
+			 *    offset advanced by the number of bytes
 			 *    absorbed.  This interface is useful for files
 			 *    no larger than the buffer.
 			 * 1) Set *start = an unsigned long value less than
@@ -165,15 +169,15 @@ __proc_file_read(struct file *file, char __user
*buf, size_t nbytes,
 			if (n > count)
 				n = count;
 		}
-		
- 		n -= copy_to_user(buf, start < page ? page : start, n);
+
+		n -= copy_to_user(buf, start < page ? page : start, n);
 		if (n == 0) {
 			if (retval == 0)
 				retval = -EFAULT;
 			break;
 		}

-		*ppos += start < page ? (unsigned long)start : n;
+		*ppos += start < page ? (unsigned long)start:n;
 		nbytes -= n;
 		buf += n;
 		retval += n;
@@ -262,7 +266,7 @@ static int proc_notify_change(struct dentry
*dentry, struct iattr *iattr)
 	error = inode_setattr(inode, iattr);
 	if (error)
 		goto out;
-	
+
 	de->uid = inode->i_uid;
 	de->gid = inode->i_gid;
 	de->mode = inode->i_mode;
@@ -396,18 +400,17 @@ static const struct inode_operations
proc_link_inode_operations = {
 };

 /*
- * As some entries in /proc are volatile, we want to
- * get rid of unused dentries.  This could be made
- * smarter: we could keep a "volatile" flag in the
+ * As some entries in /proc are volatile, we want to
+ * get rid of unused dentries.  This could be made
+ * smarter: we could keep a "volatile" flag in the
  * inode to indicate which ones to keep.
  */
-static int proc_delete_dentry(struct dentry * dentry)
+static int proc_delete_dentry(struct dentry *dentry)
 {
 	return 1;
 }

-static const struct dentry_operations proc_dentry_operations =
-{
+static const struct dentry_operations proc_dentry_operations = {
 	.d_delete	= proc_delete_dentry,
 };

@@ -475,58 +478,58 @@ int proc_readdir_de(struct proc_dir_entry *de,
struct file *filp, void *dirent,
 	ino = inode->i_ino;
 	i = filp->f_pos;
 	switch (i) {
-		case 0:
-			if (filldir(dirent, ".", 1, i, ino, DT_DIR) < 0)
-				goto out;
-			i++;
-			filp->f_pos++;
-			/* fall through */
-		case 1:
-			if (filldir(dirent, "..", 2, i,
-				    parent_ino(filp->f_path.dentry),
-				    DT_DIR) < 0)
+	case 0:
+		if (filldir(dirent, ".", 1, i, ino, DT_DIR) < 0)
+			goto out;
+		i++;
+		filp->f_pos++;
+		/* fall through */
+	case 1:
+		if (filldir(dirent, "..", 2, i,
+			    parent_ino(filp->f_path.dentry),
+			    DT_DIR) < 0)
+			goto out;
+		i++;
+		filp->f_pos++;
+		/* fall through */
+	default:
+		spin_lock(&proc_subdir_lock);
+		de = de->subdir;
+		i -= 2;
+		for (;;) {
+			if (!de) {
+				ret = 1;
+				spin_unlock(&proc_subdir_lock);
 				goto out;
-			i++;
-			filp->f_pos++;
-			/* fall through */
-		default:
-			spin_lock(&proc_subdir_lock);
-			de = de->subdir;
-			i -= 2;
-			for (;;) {
-				if (!de) {
-					ret = 1;
-					spin_unlock(&proc_subdir_lock);
-					goto out;
-				}
-				if (!i)
-					break;
-				de = de->next;
-				i--;
 			}
+			if (!i)
+				break;
+			de = de->next;
+			i--;
+		}

-			do {
-				struct proc_dir_entry *next;
+		do {
+			struct proc_dir_entry *next;

-				/* filldir passes info to user space */
-				de_get(de);
-				spin_unlock(&proc_subdir_lock);
-				if (filldir(dirent, de->name, de->namelen, filp->f_pos,
-					    de->low_ino, de->mode >> 12) < 0) {
-					de_put(de);
-					goto out;
-				}
-				spin_lock(&proc_subdir_lock);
-				filp->f_pos++;
-				next = de->next;
-				de_put(de);
-				de = next;
-			} while (de);
+			/* filldir passes info to user space */
+			de_get(de);
 			spin_unlock(&proc_subdir_lock);
+			if (filldir(dirent, de->name, de->namelen, filp->f_pos,
+				    de->low_ino, de->mode >> 12) < 0) {
+				de_put(de);
+				goto out;
+			}
+			spin_lock(&proc_subdir_lock);
+			filp->f_pos++;
+			next = de->next;
+			de_put(de);
+			de = next;
+		} while (de);
+		spin_unlock(&proc_subdir_lock);
 	}
 	ret = 1;
 out:
-	return ret;	
+	return ret;
 }

 int proc_readdir(struct file *filp, void *dirent, filldir_t filldir)
@@ -556,11 +559,12 @@ static const struct inode_operations
proc_dir_inode_operations = {
 	.setattr	= proc_notify_change,
 };

-static int proc_register(struct proc_dir_entry * dir, struct
proc_dir_entry * dp)
+static int proc_register(struct proc_dir_entry *dir,
+			struct proc_dir_entry *dp)
 {
 	unsigned int i;
 	struct proc_dir_entry *tmp;
-	
+
 	i = get_inode_number();
 	if (i == 0)
 		return -EAGAIN;
@@ -586,7 +590,8 @@ static int proc_register(struct proc_dir_entry *
dir, struct proc_dir_entry * dp

 	for (tmp = dir->subdir; tmp; tmp = tmp->next)
 		if (strcmp(tmp->name, dp->name) == 0) {
-			WARN(1, KERN_WARNING "proc_dir_entry '%s/%s' already registered\n",
+			WARN(1, KERN_WARNING
+				"proc_dir_entry '%s/%s' already registered\n",
 				dir->name, dp->name);
 			break;
 		}
@@ -609,7 +614,8 @@ static struct proc_dir_entry *__proc_create(struct
proc_dir_entry **parent,
 	int len;

 	/* make sure name is valid */
-	if (!name || !strlen(name)) goto out;
+	if (!name || !strlen(name))
+		goto out;

 	if (xlate_proc_name(name, parent, &fn) != 0)
 		goto out;
@@ -621,7 +627,8 @@ static struct proc_dir_entry *__proc_create(struct
proc_dir_entry **parent,
 	len = strlen(fn);

 	ent = kmalloc(sizeof(struct proc_dir_entry) + len + 1, GFP_KERNEL);
-	if (!ent) goto out;
+	if (!ent)
+		goto out;

 	memset(ent, 0, sizeof(struct proc_dir_entry));
 	memcpy(((char *) ent) + sizeof(struct proc_dir_entry), fn, len + 1);
@@ -644,12 +651,12 @@ struct proc_dir_entry *proc_symlink(const char *name,
 	struct proc_dir_entry *ent;

 	ent = __proc_create(&parent, name,
-			  (S_IFLNK | S_IRUGO | S_IWUGO | S_IXUGO),1);
+			  (S_IFLNK | S_IRUGO | S_IWUGO | S_IXUGO), 1);

 	if (ent) {
-		ent->data = kmalloc((ent->size=strlen(dest))+1, GFP_KERNEL);
+		ent->data = kmalloc((ent->size = strlen(dest))+1, GFP_KERNEL);
 		if (ent->data) {
-			strcpy((char*)ent->data,dest);
+			strcpy((char *)ent->data, dest);
 			if (proc_register(parent, ent) < 0) {
 				kfree(ent->data);
 				kfree(ent);
@@ -792,7 +799,7 @@ void remove_proc_entry(const char *name, struct
proc_dir_entry *parent)
 	len = strlen(fn);

 	spin_lock(&proc_subdir_lock);
-	for (p = &parent->subdir; *p; p=&(*p)->next ) {
+	for (p = &parent->subdir; *p; p = &(*p)->next) {
 		if (proc_match(len, fn, *p)) {
 			de = *p;
 			*p = de->next;
@@ -830,7 +837,8 @@ continue_removing:
 	while (!list_empty(&de->pde_openers)) {
 		struct pde_opener *pdeo;

-		pdeo = list_first_entry(&de->pde_openers, struct pde_opener, lh);
+		pdeo = list_first_entry(&de->pde_openers,
+					struct pde_opener, lh);
 		list_del(&pdeo->lh);
 		spin_unlock(&de->pde_unload_lock);
 		pdeo->release(pdeo->inode, pdeo->file);
