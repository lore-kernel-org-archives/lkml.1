Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbXLJCu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbXLJCu1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 21:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754929AbXLJCnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 21:43:41 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49792 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745AbXLJCnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 21:43:15 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 38/42] VFS: simplified fsstack_copy_attr_all
Date: Sun,  9 Dec 2007 21:42:11 -0500
Message-Id: <11972545601752-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11972545353262-git-send-email-ezk@cs.sunysb.edu>
References: <11972545353262-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/stack.c |   30 +++++++++++++++++-------------
 1 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/fs/stack.c b/fs/stack.c
index 67716f6..a548aac 100644
--- a/fs/stack.c
+++ b/fs/stack.c
@@ -1,8 +1,20 @@
+/*
+ * Copyright (c) 2006-2007 Erez Zadok
+ * Copyright (c) 2006-2007 Josef 'Jeff' Sipek
+ * Copyright (c) 2006-2007 Stony Brook University
+ * Copyright (c) 2006-2007 The Research Foundation of SUNY
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/fs_stack.h>
 
-/* does _NOT_ require i_mutex to be held.
+/*
+ * does _NOT_ require i_mutex to be held.
  *
  * This function cannot be inlined since i_size_{read,write} is rather
  * heavy-weight on 32-bit systems
@@ -14,11 +26,11 @@ void fsstack_copy_inode_size(struct inode *dst, const struct inode *src)
 }
 EXPORT_SYMBOL_GPL(fsstack_copy_inode_size);
 
-/* copy all attributes; get_nlinks is optional way to override the i_nlink
+/*
+ * copy all attributes; get_nlinks is optional way to override the i_nlink
  * copying
  */
-void fsstack_copy_attr_all(struct inode *dest, const struct inode *src,
-				int (*get_nlinks)(struct inode *))
+void fsstack_copy_attr_all(struct inode *dest, const struct inode *src)
 {
 	dest->i_mode = src->i_mode;
 	dest->i_uid = src->i_uid;
@@ -29,14 +41,6 @@ void fsstack_copy_attr_all(struct inode *dest, const struct inode *src,
 	dest->i_ctime = src->i_ctime;
 	dest->i_blkbits = src->i_blkbits;
 	dest->i_flags = src->i_flags;
-
-	/*
-	 * Update the nlinks AFTER updating the above fields, because the
-	 * get_links callback may depend on them.
-	 */
-	if (!get_nlinks)
-		dest->i_nlink = src->i_nlink;
-	else
-		dest->i_nlink = (*get_nlinks)(dest);
+	dest->i_nlink = src->i_nlink;
 }
 EXPORT_SYMBOL_GPL(fsstack_copy_attr_all);
-- 
1.5.2.2

