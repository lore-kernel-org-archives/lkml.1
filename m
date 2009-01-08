Return-Path: <linux-kernel-owner+w=401wt.eu-S1763546AbZAHWpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763546AbZAHWpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 17:45:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761301AbZAHWoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 17:44:06 -0500
Received: from kumera.dghda.com ([80.68.90.171]:55954 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760692AbZAHWoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 17:44:05 -0500
From: "Duane Griffin" <duaneg@dghda.com>
To: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       Duane Griffin <duaneg@dghda.com>
Subject: [PATCH, v2 4/4] ufs: copy symlink data into the correct union member
Date: Thu,  8 Jan 2009 22:43:51 +0000
Message-Id: <1231454631-14329-4-git-send-email-duaneg@dghda.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1231454631-14329-3-git-send-email-duaneg@dghda.com>
References: <1231454631-14329-1-git-send-email-duaneg@dghda.com>
 <1231454631-14329-2-git-send-email-duaneg@dghda.com>
 <1231454631-14329-3-git-send-email-duaneg@dghda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copy symlink data into the union member it is accessed through. Although
this shouldn't make a difference to behaviour it makes the code easier
to follow and grep through. It may also prevent problems if the
struct/union definitions change in the future.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---

Version 1 -> 2:
  * Remove now obsolete cast; don't take address of the array

 fs/ufs/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ufs/namei.c b/fs/ufs/namei.c
index e3a9b1f..23119fe 100644
--- a/fs/ufs/namei.c
+++ b/fs/ufs/namei.c
@@ -147,7 +147,7 @@ static int ufs_symlink (struct inode * dir, struct dentry * dentry,
 	} else {
 		/* fast symlink */
 		inode->i_op = &ufs_fast_symlink_inode_operations;
-		memcpy((char*)&UFS_I(inode)->i_u1.i_data,symname,l);
+		memcpy(UFS_I(inode)->i_u1.i_symlink, symname, l);
 		inode->i_size = l-1;
 	}
 	mark_inode_dirty(inode);
-- 
1.6.0.6

