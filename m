Return-Path: <linux-kernel-owner+w=401wt.eu-S1758631AbYDXLoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631AbYDXLoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 07:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbYDXLlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 07:41:22 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57208 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604AbYDXLki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 07:40:38 -0400
Message-Id: <20080424114008.353519557@szeredi.hu>
References: <20080424113950.818688067@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 24 Apr 2008 13:39:51 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu, mhalcrow@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 01/13] ecryptfs: add missing lock around notify_change
Content-Disposition: inline; filename=ecryptfs_locking_fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Caller of notify_change() need to hold i_mutex.

Compile tested only.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/ecryptfs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

Index: vfs-2.6/fs/ecryptfs/inode.c
===================================================================
--- vfs-2.6.orig/fs/ecryptfs/inode.c	2008-04-02 18:47:17.000000000 +0200
+++ vfs-2.6/fs/ecryptfs/inode.c	2008-04-02 18:49:18.000000000 +0200
@@ -908,7 +908,9 @@ static int ecryptfs_setattr(struct dentr
 	if (ia->ia_valid & (ATTR_KILL_SUID | ATTR_KILL_SGID))
 		ia->ia_valid &= ~ATTR_MODE;
 
+	mutex_lock(&lower_dentry->d_inode->i_mutex);
 	rc = notify_change(lower_dentry, ia);
+	mutex_unlock(&lower_dentry->d_inode->i_mutex);
 out:
 	fsstack_copy_attr_all(inode, lower_inode, NULL);
 	return rc;

--
