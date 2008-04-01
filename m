Return-Path: <linux-kernel-owner+w=401wt.eu-S1761533AbYDAVLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761533AbYDAVLJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761918AbYDAVID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:08:03 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:45620 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761554AbYDAVH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:07:59 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 07/14] Unionfs: don't copy parent inode times in setattr
Date: Tue,  1 Apr 2008 17:06:49 -0400
Message-Id: <12070840192374-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12070840162442-git-send-email-ezk@cs.sunysb.edu>
References: <12070840162442-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/inode.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 640969d..0dc07ec 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -1064,8 +1064,7 @@ static int unionfs_setattr(struct dentry *dentry, struct iattr *ia)
 	if (ia->ia_valid & ATTR_ATIME_SET)
 		inode->i_atime = lower_inode->i_atime;
 	fsstack_copy_inode_size(inode, lower_inode);
-	/* if setattr succeeded, then parent dir may have changed */
-	unionfs_copy_attr_times(dentry->d_parent->d_inode);
+
 out:
 	if (!err)
 		unionfs_check_dentry(dentry);
-- 
1.5.2.2

