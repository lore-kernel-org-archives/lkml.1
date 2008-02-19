Return-Path: <linux-kernel-owner+w=401wt.eu-S1760123AbYBSEMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760123AbYBSEMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 23:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbYBSELr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 23:11:47 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:53760 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbYBSELo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 23:11:44 -0500
Message-Id: <20080219040829.217204571@arndb.de>
References: <20080219040435.825494460@arndb.de>
User-Agent: quilt/0.46-1
Date: Tue, 19 Feb 2008 05:04:41 +0100
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@lst.de>, Greg KH <gregkh@suse.de>,
       David Howells <dhowells@redhat.com>
Subject: [RFC 06/11] split out linux/libfs.h from linux/fs.h
Content-Disposition: inline; filename=libfs-header.diff
X-Provags-ID: V01U2FsdGVkX1+NMIWL8JS6oW26aCxZJRhCzAB79VEPDmdG63W
 awUi1m7cCvsVjYTtb0BBKcccDuG/u+P0/i95vxD/QyUYRTmtM+
 G/9YYi56mocC+BcEFAc3A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With libfs turning into a larger subsystem, it makes
sense to have a separate header that is not included
by the low-level vfs code.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Index: linux-2.6/fs/debugfs/inode.c
===================================================================
--- linux-2.6.orig/fs/debugfs/inode.c
+++ linux-2.6/fs/debugfs/inode.c
@@ -18,6 +18,7 @@
 
 #include <linux/module.h>
 #include <linux/fs.h>
+#include <linux/libfs.h>
 #include <linux/mount.h>
 #include <linux/pagemap.h>
 #include <linux/init.h>
Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -947,6 +947,7 @@ struct dentry *d_alloc_name(struct dentr
 	q.hash = full_name_hash(q.name, q.len);
 	return d_alloc(parent, &q);
 }
+EXPORT_SYMBOL(d_alloc_name);
 
 /**
  * d_instantiate - fill in inode information for a dentry
Index: linux-2.6/drivers/usb/core/inode.c
===================================================================
--- linux-2.6.orig/drivers/usb/core/inode.c
+++ linux-2.6/drivers/usb/core/inode.c
@@ -27,6 +27,7 @@
 
 /*****************************************************************************/
 
+#include <linux/libfs.h>
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/mount.h>
Index: linux-2.6/fs/binfmt_misc.c
===================================================================
--- linux-2.6.orig/fs/binfmt_misc.c
+++ linux-2.6/fs/binfmt_misc.c
@@ -16,6 +16,7 @@
  *  2001-02-28 AV: rewritten into something that resembles C. Original didn't.
  */
 
+#include <linux/libfs.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/sched.h>
Index: linux-2.6/fs/configfs/mount.c
===================================================================
--- linux-2.6.orig/fs/configfs/mount.c
+++ linux-2.6/fs/configfs/mount.c
@@ -25,6 +25,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/libfs.h>
 #include <linux/module.h>
 #include <linux/mount.h>
 #include <linux/pagemap.h>
Index: linux-2.6/fs/debugfs/file.c
===================================================================
--- linux-2.6.orig/fs/debugfs/file.c
+++ linux-2.6/fs/debugfs/file.c
@@ -15,6 +15,7 @@
 
 #include <linux/module.h>
 #include <linux/fs.h>
+#include <linux/libfs.h>
 #include <linux/pagemap.h>
 #include <linux/namei.h>
 #include <linux/debugfs.h>
Index: linux-2.6/fs/fuse/control.c
===================================================================
--- linux-2.6.orig/fs/fuse/control.c
+++ linux-2.6/fs/fuse/control.c
@@ -9,6 +9,7 @@
 #include "fuse_i.h"
 
 #include <linux/init.h>
+#include <linux/libfs.h>
 #include <linux/module.h>
 
 #define FUSE_CTL_SUPER_MAGIC 0x65735543
Index: linux-2.6/fs/nfsd/nfsctl.c
===================================================================
--- linux-2.6.orig/fs/nfsd/nfsctl.c
+++ linux-2.6/fs/nfsd/nfsctl.c
@@ -8,6 +8,7 @@
 
 #include <linux/module.h>
 
+#include <linux/libfs.h>
 #include <linux/linkage.h>
 #include <linux/time.h>
 #include <linux/errno.h>
Index: linux-2.6/net/sunrpc/rpc_pipe.c
===================================================================
--- linux-2.6.orig/net/sunrpc/rpc_pipe.c
+++ linux-2.6/net/sunrpc/rpc_pipe.c
@@ -8,6 +8,7 @@
  * Copyright (c) 2002, Trond Myklebust <trond.myklebust@fys.uio.no>
  *
  */
+#include <linux/libfs.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/string.h>
Index: linux-2.6/security/inode.c
===================================================================
--- linux-2.6.orig/security/inode.c
+++ linux-2.6/security/inode.c
@@ -16,6 +16,7 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/libfs.h>
 #include <linux/security.h>
 
 #define SECURITYFS_MAGIC	0x73636673
Index: linux-2.6/security/selinux/selinuxfs.c
===================================================================
--- linux-2.6.orig/security/selinux/selinuxfs.c
+++ linux-2.6/security/selinux/selinuxfs.c
@@ -14,6 +14,7 @@
  *	the Free Software Foundation, version 2.
  */
 
+#include <linux/libfs.h>
 #include <linux/kernel.h>
 #include <linux/pagemap.h>
 #include <linux/slab.h>
Index: linux-2.6/virt/kvm/kvm_main.c
===================================================================
--- linux-2.6.orig/virt/kvm/kvm_main.c
+++ linux-2.6/virt/kvm/kvm_main.c
@@ -40,6 +40,7 @@
 #include <linux/kvm_para.h>
 #include <linux/pagemap.h>
 #include <linux/mman.h>
+#include <linux/libfs.h>
 
 #include <asm/processor.h>
 #include <asm/io.h>
Index: linux-2.6/arch/powerpc/platforms/cell/spufs/spufs.h
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/spufs/spufs.h
+++ linux-2.6/arch/powerpc/platforms/cell/spufs/spufs.h
@@ -27,6 +27,7 @@
 #include <linux/spinlock.h>
 #include <linux/fs.h>
 #include <linux/cpumask.h>
+#include <linux/libfs.h>
 
 #include <asm/spu.h>
 #include <asm/spu_csa.h>
Index: linux-2.6/fs/autofs4/autofs_i.h
===================================================================
--- linux-2.6.orig/fs/autofs4/autofs_i.h
+++ linux-2.6/fs/autofs4/autofs_i.h
@@ -22,6 +22,7 @@
 #define AUTOFS_IOC_COUNT     32
 
 #include <linux/kernel.h>
+#include <linux/libfs.h>
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <linux/string.h>
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -1957,12 +1957,7 @@ extern struct dentry *simple_lookup(stru
 extern ssize_t generic_read_dir(struct file *, char __user *, size_t, loff_t *);
 extern const struct file_operations simple_dir_operations;
 extern const struct inode_operations simple_dir_inode_operations;
-struct tree_descr { char *name; const struct file_operations *ops; int mode; };
 struct dentry *d_alloc_name(struct dentry *, const char *);
-extern int simple_fill_super(struct super_block *, int, const struct tree_descr *);
-extern int simple_pin_fs(struct file_system_type *, struct vfsmount **mount, int *count);
-extern void simple_release_fs(struct vfsmount **mount, int *count);
-
 extern ssize_t simple_read_from_buffer(void __user *, size_t, loff_t *, const void *, size_t);
 
 #ifdef CONFIG_MIGRATION
@@ -1993,92 +1988,6 @@ static inline ino_t parent_ino(struct de
 /* kernel/fork.c */
 extern int unshare_files(void);
 
-/* Transaction based IO helpers */
-
-/*
- * An argresp is stored in an allocated page and holds the
- * size of the argument or response, along with its content
- */
-struct simple_transaction_argresp {
-	ssize_t size;
-	char data[0];
-};
-
-#define SIMPLE_TRANSACTION_LIMIT (PAGE_SIZE - sizeof(struct simple_transaction_argresp))
-
-char *simple_transaction_get(struct file *file, const char __user *buf,
-				size_t size);
-ssize_t simple_transaction_read(struct file *file, char __user *buf,
-				size_t size, loff_t *pos);
-int simple_transaction_release(struct inode *inode, struct file *file);
-
-static inline void simple_transaction_set(struct file *file, size_t n)
-{
-	struct simple_transaction_argresp *ar = file->private_data;
-
-	BUG_ON(n > SIMPLE_TRANSACTION_LIMIT);
-
-	/*
-	 * The barrier ensures that ar->size will really remain zero until
-	 * ar->data is ready for reading.
-	 */
-	smp_mb();
-	ar->size = n;
-}
-
-/*
- * simple attribute files
- *
- * These attributes behave similar to those in sysfs:
- *
- * Writing to an attribute immediately sets a value, an open file can be
- * written to multiple times.
- *
- * Reading from an attribute creates a buffer from the value that might get
- * read with multiple read calls. When the attribute has been read
- * completely, no further read calls are possible until the file is opened
- * again.
- *
- * All attributes contain a text representation of a numeric value
- * that are accessed with the get() and set() functions.
- */
-#define __DEFINE_SIMPLE_ATTRIBUTE(__static, __fops, __get, __set, __fmt)\
-static int __fops ## _open(struct inode *inode, struct file *file)	\
-{									\
-	__simple_attr_check_format(__fmt, 0ull);			\
-	return simple_attr_open(inode, file, __get, __set, __fmt);	\
-}									\
-__static const struct file_operations __fops = {			\
-	.owner	 = THIS_MODULE,						\
-	.open	 = __fops ## _open,					\
-	.release = simple_attr_release,					\
-	.read	 = simple_attr_read,					\
-	.write	 = simple_attr_write,					\
-}
-
-#define DEFINE_SIMPLE_ATTRIBUTE(__fops, __get, __set, __fmt)		\
-	__DEFINE_SIMPLE_ATTRIBUTE(static, __fops, __get, __set, __fmt)
-
-#define DEFINE_SIMPLE_EXPORTED_ATTRIBUTE(__fops, __get, __set, __fmt)	\
-	__DEFINE_SIMPLE_ATTRIBUTE(/**/, __fops, __get, __set, __fmt);	\
-	EXPORT_SYMBOL_GPL(__fops)
-
-static inline void __attribute__((format(printf, 1, 2)))
-__simple_attr_check_format(const char *fmt, ...)
-{
-	/* don't do anything, just let the compiler check the arguments; */
-}
-
-int simple_attr_open(struct inode *inode, struct file *file,
-		     int (*get)(void *, u64 *), int (*set)(void *, u64),
-		     const char *fmt);
-int simple_attr_release(struct inode *inode, struct file *file);
-ssize_t simple_attr_read(struct file *file, char __user *buf,
-			 size_t len, loff_t *ppos);
-ssize_t simple_attr_write(struct file *file, const char __user *buf,
-			  size_t len, loff_t *ppos);
-
-
 #ifdef CONFIG_SECURITY
 static inline char *alloc_secdata(void)
 {
Index: linux-2.6/include/linux/libfs.h
===================================================================
--- linux-2.6.orig/include/linux/libfs.h
+++ linux-2.6/include/linux/libfs.h
@@ -3,6 +3,11 @@
 
 #include <linux/fs.h>
 
+struct tree_descr { char *name; const struct file_operations *ops; int mode; };
+extern int simple_fill_super(struct super_block *, int, const struct tree_descr *);
+extern int simple_pin_fs(struct file_system_type *, struct vfsmount **mount, int *count);
+extern void simple_release_fs(struct vfsmount **mount, int *count);
+
 /* simple_fs interface */
 struct simple_fs_type {
 	struct file_system_type fstype;
@@ -26,6 +31,91 @@ struct simple_fs_type _type = {		\
 extern struct dentry *simple_register_filesystem(struct simple_fs_type *type);
 extern void simple_unregister_filesystem(struct simple_fs_type *type);
 
+/* Transaction based IO helpers */
+
+/*
+ * An argresp is stored in an allocated page and holds the
+ * size of the argument or response, along with its content
+ */
+struct simple_transaction_argresp {
+	ssize_t size;
+	char data[0];
+};
+
+#define SIMPLE_TRANSACTION_LIMIT (PAGE_SIZE - sizeof(struct simple_transaction_argresp))
+
+char *simple_transaction_get(struct file *file, const char __user *buf,
+				size_t size);
+ssize_t simple_transaction_read(struct file *file, char __user *buf,
+				size_t size, loff_t *pos);
+int simple_transaction_release(struct inode *inode, struct file *file);
+
+static inline void simple_transaction_set(struct file *file, size_t n)
+{
+	struct simple_transaction_argresp *ar = file->private_data;
+
+	BUG_ON(n > SIMPLE_TRANSACTION_LIMIT);
+
+	/*
+	 * The barrier ensures that ar->size will really remain zero until
+	 * ar->data is ready for reading.
+	 */
+	smp_mb();
+	ar->size = n;
+}
+
+/*
+ * simple attribute files
+ *
+ * These attributes behave similar to those in sysfs:
+ *
+ * Writing to an attribute immediately sets a value, an open file can be
+ * written to multiple times.
+ *
+ * Reading from an attribute creates a buffer from the value that might get
+ * read with multiple read calls. When the attribute has been read
+ * completely, no further read calls are possible until the file is opened
+ * again.
+ *
+ * All attributes contain a text representation of a numeric value
+ * that are accessed with the get() and set() functions.
+ */
+#define __DEFINE_SIMPLE_ATTRIBUTE(__static, __fops, __get, __set, __fmt)\
+static int __fops ## _open(struct inode *inode, struct file *file)	\
+{									\
+	__simple_attr_check_format(__fmt, 0ull);			\
+	return simple_attr_open(inode, file, __get, __set, __fmt);	\
+}									\
+__static const struct file_operations __fops = {			\
+	.owner	 = THIS_MODULE,						\
+	.open	 = __fops ## _open,					\
+	.release = simple_attr_release,					\
+	.read	 = simple_attr_read,					\
+	.write	 = simple_attr_write,					\
+}
+
+#define DEFINE_SIMPLE_ATTRIBUTE(__fops, __get, __set, __fmt)		\
+	__DEFINE_SIMPLE_ATTRIBUTE(static, __fops, __get, __set, __fmt)
+
+#define DEFINE_SIMPLE_EXPORTED_ATTRIBUTE(__fops, __get, __set, __fmt)	\
+	__DEFINE_SIMPLE_ATTRIBUTE(/**/, __fops, __get, __set, __fmt);	\
+	EXPORT_SYMBOL_GPL(__fops)
+
+static inline void __attribute__((format(printf, 1, 2)))
+__simple_attr_check_format(const char *fmt, ...)
+{
+	/* don't do anything, just let the compiler check the arguments; */
+}
+
+int simple_attr_open(struct inode *inode, struct file *file,
+		     int (*get)(void *, u64 *), int (*set)(void *, u64),
+		     const char *fmt);
+int simple_attr_release(struct inode *inode, struct file *file);
+ssize_t simple_attr_read(struct file *file, char __user *buf,
+			 size_t len, loff_t *ppos);
+ssize_t simple_attr_write(struct file *file, const char __user *buf,
+			  size_t len, loff_t *ppos);
+
 extern const struct file_operations simple_fops_u8;
 extern const struct file_operations simple_fops_x8;
 extern const struct file_operations simple_fops_u16;

-- 

