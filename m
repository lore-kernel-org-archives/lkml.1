Return-Path: <linux-kernel-owner+w=401wt.eu-S1752306AbXCEBys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbXCEBys (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:54:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbXCEByo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:54:44 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:49953 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751964AbXCEBtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:49:47 -0500
Date: Mon, 5 Mar 2007 02:49:48 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Eric Van Hensbergen <ericvh@gmail.com>, rminnich@lanl.gov,
       lucho@ionkov.net
Cc: v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [-mm patch] make struct v9fs_cached_file_operations static
Message-ID: <20070305014948.GC3441@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes te needlessly global struct v9fs_cached_file_operations 
static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 fs/9p/v9fs_vfs.h |    1 -
 fs/9p/vfs_file.c |    4 +++-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- linux-2.6.21-rc2-mm1/fs/9p/v9fs_vfs.h.old	2007-03-04 22:02:54.000000000 +0100
+++ linux-2.6.21-rc2-mm1/fs/9p/v9fs_vfs.h	2007-03-04 22:03:00.000000000 +0100
@@ -40,7 +40,6 @@
 extern struct file_system_type v9fs_fs_type;
 extern const struct address_space_operations v9fs_addr_operations;
 extern const struct file_operations v9fs_file_operations;
-extern const struct file_operations v9fs_cached_file_operations;
 extern const struct file_operations v9fs_dir_operations;
 extern struct dentry_operations v9fs_dentry_operations;
 extern struct dentry_operations v9fs_cached_dentry_operations;
--- linux-2.6.21-rc2-mm1/fs/9p/vfs_file.c.old	2007-03-04 22:03:07.000000000 +0100
+++ linux-2.6.21-rc2-mm1/fs/9p/vfs_file.c	2007-03-04 22:03:57.000000000 +0100
@@ -42,6 +42,8 @@
 #include "v9fs_vfs.h"
 #include "fid.h"
 
+static const struct file_operations v9fs_cached_file_operations;
+
 /**
  * v9fs_file_open - open a file (or directory)
  * @inode: inode to be opened
@@ -245,7 +247,7 @@
 	return total;
 }
 
-const struct file_operations v9fs_cached_file_operations = {
+static const struct file_operations v9fs_cached_file_operations = {
 	.llseek = generic_file_llseek,
 	.read = do_sync_read,
 	.aio_read = generic_file_aio_read,

