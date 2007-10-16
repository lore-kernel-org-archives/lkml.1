Return-Path: <linux-kernel-owner+w=401wt.eu-S1765382AbXJPAav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765382AbXJPAav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 20:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757071AbXJPAae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 20:30:34 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:32373 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763724AbXJPAac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 20:30:32 -0400
Date: Mon, 15 Oct 2007 17:30:19 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Cc: torvalds <torvalds@linux-foundation.org>, akpm <akpm@linux-foundation.org>,
       gregkh <greg@kroah.com>
Subject: [PATCH 4/4] docbook: fix filesystems content
Message-Id: <20071015173019.f2bb1285.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix filesystems docbook warnings.

Warning(linux-2.6.23-git8//fs/debugfs/file.c:241): No description found for parameter 'name'
Warning(linux-2.6.23-git8//fs/debugfs/file.c:241): No description found for parameter 'mode'
Warning(linux-2.6.23-git8//fs/debugfs/file.c:241): No description found for parameter 'parent'
Warning(linux-2.6.23-git8//fs/debugfs/file.c:241): No description found for parameter 'value'
Warning(linux-2.6.23-git8//include/linux/jbd.h:404): No description found for parameter 'h_lockdep_map'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/debugfs/file.c   |   41 +++++++++++++++++++++++++++++++++++------
 include/linux/jbd.h |    1 +
 2 files changed, 36 insertions(+), 6 deletions(-)

--- linux-2.6.23-git8.orig/fs/debugfs/file.c
+++ linux-2.6.23-git8/fs/debugfs/file.c
@@ -227,15 +227,24 @@ DEFINE_SIMPLE_ATTRIBUTE(fops_x16, debugf
 
 DEFINE_SIMPLE_ATTRIBUTE(fops_x32, debugfs_u32_get, debugfs_u32_set, "0x%08llx\n");
 
-/**
- * debugfs_create_x8 - create a debugfs file that is used to read and write an unsigned 8-bit value
- * debugfs_create_x16 - create a debugfs file that is used to read and write an unsigned 16-bit value
- * debugfs_create_x32 - create a debugfs file that is used to read and write an unsigned 32-bit value
+/*
+ * debugfs_create_x{8,16,32} - create a debugfs file that is used to read and write an unsigned {8,16,32}-bit value
  *
- * These functions are exactly the same as the above functions, (but use a hex
- * output for the decimal challenged) for details look at the above unsigned
+ * These functions are exactly the same as the above functions (but use a hex
+ * output for the decimal challenged). For details look at the above unsigned
  * decimal functions.
  */
+
+/**
+ * debugfs_create_x8 - create a debugfs file that is used to read and write an unsigned 8-bit value
+ * @name: a pointer to a string containing the name of the file to create.
+ * @mode: the permission that the file should have
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this parameter is %NULL, then the
+ *          file will be created in the root of the debugfs filesystem.
+ * @value: a pointer to the variable that the file should read to and write
+ *         from.
+ */
 struct dentry *debugfs_create_x8(const char *name, mode_t mode,
 				 struct dentry *parent, u8 *value)
 {
@@ -243,6 +252,16 @@ struct dentry *debugfs_create_x8(const c
 }
 EXPORT_SYMBOL_GPL(debugfs_create_x8);
 
+/**
+ * debugfs_create_x16 - create a debugfs file that is used to read and write an unsigned 16-bit value
+ * @name: a pointer to a string containing the name of the file to create.
+ * @mode: the permission that the file should have
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this parameter is %NULL, then the
+ *          file will be created in the root of the debugfs filesystem.
+ * @value: a pointer to the variable that the file should read to and write
+ *         from.
+ */
 struct dentry *debugfs_create_x16(const char *name, mode_t mode,
 				 struct dentry *parent, u16 *value)
 {
@@ -250,6 +269,16 @@ struct dentry *debugfs_create_x16(const 
 }
 EXPORT_SYMBOL_GPL(debugfs_create_x16);
 
+/**
+ * debugfs_create_x32 - create a debugfs file that is used to read and write an unsigned 32-bit value
+ * @name: a pointer to a string containing the name of the file to create.
+ * @mode: the permission that the file should have
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this parameter is %NULL, then the
+ *          file will be created in the root of the debugfs filesystem.
+ * @value: a pointer to the variable that the file should read to and write
+ *         from.
+ */
 struct dentry *debugfs_create_x32(const char *name, mode_t mode,
 				 struct dentry *parent, u32 *value)
 {
--- linux-2.6.23-git8.orig/include/linux/jbd.h
+++ linux-2.6.23-git8/include/linux/jbd.h
@@ -372,6 +372,7 @@ struct jbd_revoke_table_s;
  * @h_sync: flag for sync-on-close
  * @h_jdata: flag to force data journaling
  * @h_aborted: flag indicating fatal error on handle
+ * @h_lockdep_map: lockdep info for debugging lock problems
  **/
 
 /* Docbook can't yet cope with the bit fields, but will leave the documentation
