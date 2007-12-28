Return-Path: <linux-kernel-owner+w=401wt.eu-S1753350AbXL1TIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbXL1TIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 14:08:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbXL1THf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 14:07:35 -0500
Received: from verein.lst.de ([213.95.11.210]:39048 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbXL1THe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 14:07:34 -0500
Date: Fri, 28 Dec 2007 20:07:22 +0100
From: Christoph Hellwig <hch@lst.de>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Cc: arndb@de.ibm.com, stefano.brivio@polimi.it
Subject: [PATCH 3/3] libfs: rename simple_attr_close to simple_attr_release
Message-ID: <20071228190722.GC4855@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.127 () BAYES_20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

simple_attr_close implementes ->release so it should be named
accordingly.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6.24-rc6/arch/powerpc/platforms/cell/spufs/file.c
===================================================================
--- linux-2.6.24-rc6.orig/arch/powerpc/platforms/cell/spufs/file.c	2007-12-28 19:53:28.000000000 +0100
+++ linux-2.6.24-rc6/arch/powerpc/platforms/cell/spufs/file.c	2007-12-28 19:53:38.000000000 +0100
@@ -350,7 +350,7 @@ spufs_cntl_release(struct inode *inode, 
 	struct spufs_inode_info *i = SPUFS_I(inode);
 	struct spu_context *ctx = i->i_ctx;
 
-	simple_attr_close(inode, file);
+	simple_attr_release(inode, file);
 
 	mutex_lock(&ctx->mapping_lock);
 	if (!--i->i_openers)
Index: linux-2.6.24-rc6/fs/libfs.c
===================================================================
--- linux-2.6.24-rc6.orig/fs/libfs.c	2007-12-28 19:53:28.000000000 +0100
+++ linux-2.6.24-rc6/fs/libfs.c	2007-12-28 19:53:50.000000000 +0100
@@ -615,7 +615,7 @@ int simple_attr_open(struct inode *inode
 	return nonseekable_open(inode, file);
 }
 
-int simple_attr_close(struct inode *inode, struct file *file)
+int simple_attr_release(struct inode *inode, struct file *file)
 {
 	kfree(file->private_data);
 	return 0;
@@ -804,6 +804,6 @@ EXPORT_SYMBOL(simple_transaction_get);
 EXPORT_SYMBOL(simple_transaction_read);
 EXPORT_SYMBOL(simple_transaction_release);
 EXPORT_SYMBOL_GPL(simple_attr_open);
-EXPORT_SYMBOL_GPL(simple_attr_close);
+EXPORT_SYMBOL_GPL(simple_attr_release);
 EXPORT_SYMBOL_GPL(simple_attr_read);
 EXPORT_SYMBOL_GPL(simple_attr_write);
Index: linux-2.6.24-rc6/include/linux/fs.h
===================================================================
--- linux-2.6.24-rc6.orig/include/linux/fs.h	2007-12-28 19:53:28.000000000 +0100
+++ linux-2.6.24-rc6/include/linux/fs.h	2007-12-28 19:54:03.000000000 +0100
@@ -2061,7 +2061,7 @@ static int __fops ## _open(struct inode 
 static struct file_operations __fops = {				\
 	.owner	 = THIS_MODULE,						\
 	.open	 = __fops ## _open,					\
-	.release = simple_attr_close,					\
+	.release = simple_attr_release,					\
 	.read	 = simple_attr_read,					\
 	.write	 = simple_attr_write,					\
 };
@@ -2075,7 +2075,7 @@ __simple_attr_check_format(const char *f
 int simple_attr_open(struct inode *inode, struct file *file,
 		     int (*get)(void *, u64 *), int (*set)(void *, u64),
 		     const char *fmt);
-int simple_attr_close(struct inode *inode, struct file *file);
+int simple_attr_release(struct inode *inode, struct file *file);
 ssize_t simple_attr_read(struct file *file, char __user *buf,
 			 size_t len, loff_t *ppos);
 ssize_t simple_attr_write(struct file *file, const char __user *buf,
