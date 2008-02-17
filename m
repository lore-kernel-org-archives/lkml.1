Return-Path: <linux-kernel-owner+w=401wt.eu-S1759411AbYBQIZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759411AbYBQIZs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 03:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757706AbYBQIVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 03:21:24 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:37031 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759260AbYBQIVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 03:21:23 -0500
Date: Sun, 17 Feb 2008 10:20:57 +0200
From: Adrian Bunk <bunk@kernel.org>
To: npiggin@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] fs/ramfs/ extern cleanup
Message-ID: <20080217082057.GX3848@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following cleanups:
- internal.h shouldn't duplicate the extern declaration for
  ramfs_file_operations already in include/linux/ramfs.h
- file-mmu.c needs two #include's for seeing the extern declarations
  of it's global struct's

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/ramfs/file-mmu.c |    3 +++
 fs/ramfs/internal.h |    1 -
 2 files changed, 3 insertions(+), 1 deletion(-)

157e8cf4ac47a1f31fb68273f09425fcbf7dbb0d diff --git a/fs/ramfs/file-mmu.c b/fs/ramfs/file-mmu.c
index b41a514..9590b90 100644
--- a/fs/ramfs/file-mmu.c
+++ b/fs/ramfs/file-mmu.c
@@ -26,6 +26,9 @@
 
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/ramfs.h>
+
+#include "internal.h"
 
 const struct address_space_operations ramfs_aops = {
 	.readpage	= simple_readpage,
diff --git a/fs/ramfs/internal.h b/fs/ramfs/internal.h
index af7cc07..6b33063 100644
--- a/fs/ramfs/internal.h
+++ b/fs/ramfs/internal.h
@@ -11,5 +11,4 @@
 
 
 extern const struct address_space_operations ramfs_aops;
-extern const struct file_operations ramfs_file_operations;
 extern const struct inode_operations ramfs_file_inode_operations;

