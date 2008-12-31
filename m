Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbYLaQu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbYLaQu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 11:50:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756138AbYLaQuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 11:50:20 -0500
Received: from kumera.dghda.com ([80.68.90.171]:34056 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756084AbYLaQuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 11:50:18 -0500
From: "Duane Griffin" <duaneg@dghda.com>
To: Evgeniy Dushistov <dushistov@mail.ru>
Cc: linux-kernel@vger.kernel.org, Duane Griffin <duaneg@dghda.com>
Subject: [PATCH 3/4] ufs: ensure fast symlinks are NUL-terminated
Date: Wed, 31 Dec 2008 16:50:07 +0000
Message-Id: <1230742208-23972-3-git-send-email-duaneg@dghda.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1230742208-23972-2-git-send-email-duaneg@dghda.com>
References: <1230742208-23972-1-git-send-email-duaneg@dghda.com>
 <1230742208-23972-2-git-send-email-duaneg@dghda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure fast symlink targets are NUL-terminated, even if corrupted
on-disk.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---
 fs/ufs/inode.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index c1ea916..c2edfb6 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -658,8 +658,9 @@ static int ufs1_read_inode(struct inode *inode, struct ufs_inode *ufs_inode)
 		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR); i++)
 			ufsi->i_u1.i_data[i] = ufs_inode->ui_u2.ui_addr.ui_db[i];
 	} else {
-		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR) * 4; i++)
+		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR) * 4 - 1; i++)
 			ufsi->i_u1.i_symlink[i] = ufs_inode->ui_u2.ui_symlink[i];
+		ufsi->i_u1.i_symlink[(UFS_NDADDR + UFS_NINDIR) * 4 - 1] = 0;
 	}
 	return 0;
 }
@@ -708,8 +709,9 @@ static int ufs2_read_inode(struct inode *inode, struct ufs2_inode *ufs2_inode)
 			ufsi->i_u1.u2_i_data[i] =
 				ufs2_inode->ui_u2.ui_addr.ui_db[i];
 	} else {
-		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR) * 4 * 2; i++)
+		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR) * 4 * 2 - 1; i++)
 			ufsi->i_u1.i_symlink[i] = ufs2_inode->ui_u2.ui_symlink[i];
+		ufsi->i_u1.i_symlink[(UFS_NDADDR + UFS_NINDIR) * 4 * 2 - 1] = 0;
 	}
 	return 0;
 }
-- 
1.6.0.6

