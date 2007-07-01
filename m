Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbXGAU1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbXGAU1a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 16:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759303AbXGAUXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 16:23:08 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:46887 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758740AbXGAUXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 16:23:06 -0400
Date: Sun, 1 Jul 2007 22:23:30 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, ezk@cs.sunysb.edu,
       jsipek@cs.sunysb.edu
Cc: linux-kernel@vger.kernel.org, unionfs@filesystems.org
Subject: [-mm patch] unionfs: make functions static
Message-ID: <20070701202330.GU10869@stusta.de>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070628034321.38c9f12b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes some needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 fs/unionfs/lookup.c |    4 +++-
 fs/unionfs/mmap.c   |   14 +++++++-------
 fs/unionfs/union.h  |    1 -
 3 files changed, 10 insertions(+), 9 deletions(-)

--- linux-2.6.22-rc6-mm1/fs/unionfs/union.h.old	2007-07-01 00:01:19.000000000 +0200
+++ linux-2.6.22-rc6-mm1/fs/unionfs/union.h	2007-07-01 00:01:26.000000000 +0200
@@ -242,7 +242,6 @@
 	unionfs_lock_dentry(d2);
 }
 
-extern int realloc_dentry_private_data(struct dentry *dentry);
 extern int new_dentry_private_data(struct dentry *dentry);
 extern void free_dentry_private_data(struct dentry *dentry);
 extern void update_bstart(struct dentry *dentry);
--- linux-2.6.22-rc6-mm1/fs/unionfs/lookup.c.old	2007-07-01 00:05:02.000000000 +0200
+++ linux-2.6.22-rc6-mm1/fs/unionfs/lookup.c	2007-07-01 00:06:05.000000000 +0200
@@ -18,6 +18,8 @@
 
 #include "union.h"
 
+static int realloc_dentry_private_data(struct dentry *dentry);
+
 /* is the filename valid == !(whiteout for a file or opaque dir marker) */
 static int is_validname(const char *name)
 {
@@ -488,7 +490,7 @@
 }
 
 /* UNIONFS_D(dentry)->lock must be locked */
-int realloc_dentry_private_data(struct dentry *dentry)
+static int realloc_dentry_private_data(struct dentry *dentry)
 {
 	if (!__realloc_dentry_private_data(dentry))
 		return 0;
--- linux-2.6.22-rc6-mm1/fs/unionfs/mmap.c.old	2007-07-01 00:08:07.000000000 +0200
+++ linux-2.6.22-rc6-mm1/fs/unionfs/mmap.c	2007-07-01 00:12:05.000000000 +0200
@@ -52,7 +52,7 @@
  * such day as Linux can better support address_space_ops in a stackable
  * fashion.
  */
-int unionfs_writepage(struct page *page, struct writeback_control *wbc)
+static int unionfs_writepage(struct page *page, struct writeback_control *wbc)
 {
 	int err = -EIO;
 	struct inode *inode;
@@ -198,7 +198,7 @@
 	return err;
 }
 
-int unionfs_readpage(struct file *file, struct page *page)
+static int unionfs_readpage(struct file *file, struct page *page)
 {
 	int err;
 
@@ -225,8 +225,8 @@
 	return err;
 }
 
-int unionfs_prepare_write(struct file *file, struct page *page, unsigned from,
-			  unsigned to)
+static int unionfs_prepare_write(struct file *file, struct page *page,
+				 unsigned from, unsigned to)
 {
 	int err;
 
@@ -239,8 +239,8 @@
 	return err;
 }
 
-int unionfs_commit_write(struct file *file, struct page *page, unsigned from,
-			 unsigned to)
+static int unionfs_commit_write(struct file *file, struct page *page,
+				unsigned from, unsigned to)
 {
 	int err = -ENOMEM;
 	struct inode *inode, *lower_inode;
@@ -308,7 +308,7 @@
 	return err;		/* assume all is ok */
 }
 
-void unionfs_sync_page(struct page *page)
+static void unionfs_sync_page(struct page *page)
 {
 	struct inode *inode;
 	struct inode *lower_inode;

