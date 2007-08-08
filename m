Return-Path: <linux-kernel-owner+w=401wt.eu-S1764130AbXHHRUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764130AbXHHRUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 13:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935897AbXHHRTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 13:19:06 -0400
Received: from ns2.suse.de ([195.135.220.15]:37160 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934450AbXHHRTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 13:19:02 -0400
Message-Id: <20070808171643.922193525@suse.de>
References: <20070808171622.632749741@suse.de>
User-Agent: quilt/0.46-1
Date: Wed, 08 Aug 2007 19:16:26 +0200
From: Andreas Gruenbacher <agruen@suse.de>
To: linux-kernel@vger.kernel.org
Cc: John Johansen <jjohansen@suse.de>, Jan Blunck <jblunck@suse.de>,
       Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [RFC 04/10] Temporary struct vfs_lookup in file_permission
Content-Disposition: inline; filename=file_permission.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Create a temporary struct vfs_lookup in file_permission() instead of
passing a NULL value.

Signed-off-by: Andreas Gruenbacher <ag@bestbits.at>

---
 fs/namei.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -292,14 +292,15 @@ int vfs_permission(struct vfs_lookup *lo
  *
  * Used to check for read/write/execute permissions on an already opened
  * file.
- *
- * Note:
- *	Do not use this function in new code.  All access checks should
- *	be done using vfs_permission().
  */
 int file_permission(struct file *file, int mask)
 {
-	return permission(file->f_path.dentry->d_inode, mask, NULL);
+	struct vfs_lookup lookup;
+
+	lookup.path = file->f_path;
+	lookup.flags = 0;
+
+	return permission(file->f_path.dentry->d_inode, mask, &lookup);
 }
 
 /*

