Return-Path: <linux-kernel-owner+w=401wt.eu-S1763468AbZAHWot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763468AbZAHWot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 17:44:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760914AbZAHWoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 17:44:04 -0500
Received: from kumera.dghda.com ([80.68.90.171]:55950 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759733AbZAHWoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 17:44:03 -0500
From: "Duane Griffin" <duaneg@dghda.com>
To: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       Duane Griffin <duaneg@dghda.com>
Subject: [PATCH, v2 3/4] ufs: ensure fast symlinks are NUL-terminated
Date: Thu,  8 Jan 2009 22:43:50 +0000
Message-Id: <1231454631-14329-3-git-send-email-duaneg@dghda.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1231454631-14329-2-git-send-email-duaneg@dghda.com>
References: <1231454631-14329-1-git-send-email-duaneg@dghda.com>
 <1231454631-14329-2-git-send-email-duaneg@dghda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure fast symlink targets are NUL-terminated, even if corrupted
on-disk.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---

checkpatch complains about the lines being over 80 characters, but IMO it is
more readable this way. Let me know if you'd prefer it split it over two
lines, though.

Version 1 -> 2:
  * No change

 fs/ufs/inode.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index ac8b324..3d2512c 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -658,7 +658,8 @@ static int ufs1_read_inode(struct inode *inode, struct ufs_inode *ufs_inode)
 		       sizeof(ufs_inode->ui_u2.ui_addr));
 	} else {
 		memcpy(ufsi->i_u1.i_symlink, ufs_inode->ui_u2.ui_symlink,
-		       sizeof(ufs_inode->ui_u2.ui_symlink));
+		       sizeof(ufs_inode->ui_u2.ui_symlink) - 1);
+		ufsi->i_u1.i_symlink[sizeof(ufs_inode->ui_u2.ui_symlink) - 1] = 0;
 	}
 	return 0;
 }
@@ -706,7 +707,8 @@ static int ufs2_read_inode(struct inode *inode, struct ufs2_inode *ufs2_inode)
 		       sizeof(ufs2_inode->ui_u2.ui_addr));
 	} else {
 		memcpy(ufsi->i_u1.i_symlink, ufs2_inode->ui_u2.ui_symlink,
-		       sizeof(ufs2_inode->ui_u2.ui_symlink));
+		       sizeof(ufs2_inode->ui_u2.ui_symlink) - 1);
+		ufsi->i_u1.i_symlink[sizeof(ufs2_inode->ui_u2.ui_symlink) - 1] = 0;
 	}
 	return 0;
 }
-- 
1.6.0.6

