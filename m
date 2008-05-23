Return-Path: <linux-kernel-owner+w=401wt.eu-S1754875AbYEWEbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbYEWEbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 00:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbYEWEbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 00:31:13 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:50714 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbYEWEbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 00:31:12 -0400
X-Greylist: delayed 1807 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 May 2008 00:31:12 EDT
Message-Id: <200805230430.m4N4UsWC016579@www262.sakura.ne.jp>
Subject: Re: [git patch] vfs: permission API cleanup (v2)
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, trond.myklebust@fys.uio.no,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Fri, 23 May 2008 13:30:54 +0900
References: <E1JzDzC-0008MT-Hb@pomaz-ex.szeredi.hu>
In-Reply-To: <E1JzDzC-0008MT-Hb@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: Reuse local variable in vfs_link().

Why not reuse "inode" which is assigned as

  struct inode *inode = old_dentry->d_inode;

in the beginning of vfs_link() ?

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/namei.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- vfs.orig/fs/namei.c
+++ vfs/fs/namei.c
@@ -2554,19 +2554,19 @@ static int vfs_link(struct dentry *old_d
 		return -EPERM;
 	if (!dir->i_op || !dir->i_op->link)
 		return -EPERM;
-	if (S_ISDIR(old_dentry->d_inode->i_mode))
+	if (S_ISDIR(inode->i_mode))
 		return -EPERM;
 
 	error = security_inode_link(old_dentry, dir, new_dentry);
 	if (error)
 		return error;
 
-	mutex_lock(&old_dentry->d_inode->i_mutex);
+	mutex_lock(&inode->i_mutex);
 	DQUOT_INIT(dir);
 	error = dir->i_op->link(old_dentry, dir, new_dentry);
-	mutex_unlock(&old_dentry->d_inode->i_mutex);
+	mutex_unlock(&inode->i_mutex);
 	if (!error)
-		fsnotify_link(dir, old_dentry->d_inode, new_dentry);
+		fsnotify_link(dir, inode, new_dentry);
 	return error;
 }
 
