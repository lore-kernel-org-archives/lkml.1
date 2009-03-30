Return-Path: <linux-kernel-owner+w=401wt.eu-S1760693AbZC3Uub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760693AbZC3Uub (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 16:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755872AbZC3UuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 16:50:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47802 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754884AbZC3UuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 16:50:21 -0400
Message-ID: <49D13076.3020208@suse.com>
Date: Mon, 30 Mar 2009 16:49:58 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
Subject: [PATCH] reiserfs: xattr_create is unused with xattrs disabled
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This patch ifdefs xattr_create when xattrs aren't enabled.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/reiserfs/xattr.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -57,12 +57,14 @@
 /* Helpers for inode ops. We do this so that we don't have all the VFS
  * overhead and also for proper i_mutex annotation.
  * dir->i_mutex must be held for all of them. */
+#ifdef CONFIG_REISERFS_FS_XATTR
 static int xattr_create(struct inode *dir, struct dentry *dentry, int mode)
 {
 	BUG_ON(!mutex_is_locked(&dir->i_mutex));
 	vfs_dq_init(dir);
 	return dir->i_op->create(dir, dentry, mode, NULL);
 }
+#endif
 
 static int xattr_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 {
-- 
Jeff Mahoney
SUSE Labs
