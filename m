Return-Path: <linux-kernel-owner+w=401wt.eu-S1757059AbYLaQvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059AbYLaQvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 11:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756166AbYLaQuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 11:50:22 -0500
Received: from kumera.dghda.com ([80.68.90.171]:34059 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756127AbYLaQuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 11:50:20 -0500
From: "Duane Griffin" <duaneg@dghda.com>
To: Evgeniy Dushistov <dushistov@mail.ru>
Cc: linux-kernel@vger.kernel.org, Duane Griffin <duaneg@dghda.com>
Subject: [PATCH 4/4] ufs: copy symlink data into the correct union member
Date: Wed, 31 Dec 2008 16:50:08 +0000
Message-Id: <1230742208-23972-4-git-send-email-duaneg@dghda.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1230742208-23972-3-git-send-email-duaneg@dghda.com>
References: <1230742208-23972-1-git-send-email-duaneg@dghda.com>
 <1230742208-23972-2-git-send-email-duaneg@dghda.com>
 <1230742208-23972-3-git-send-email-duaneg@dghda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copy symlink data into the union member it is accessed through. Although
this shouldn't make a difference to behaviour it makes the code easier
to follow and grep through. It may also prevent problems if the
struct/union definitions change in the future.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---
 fs/ufs/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ufs/namei.c b/fs/ufs/namei.c
index e3a9b1f..3884730 100644
--- a/fs/ufs/namei.c
+++ b/fs/ufs/namei.c
@@ -147,7 +147,7 @@ static int ufs_symlink (struct inode * dir, struct dentry * dentry,
 	} else {
 		/* fast symlink */
 		inode->i_op = &ufs_fast_symlink_inode_operations;
-		memcpy((char*)&UFS_I(inode)->i_u1.i_data,symname,l);
+		memcpy((char *) &UFS_I(inode)->i_u1.i_symlink, symname, l);
 		inode->i_size = l-1;
 	}
 	mark_inode_dirty(inode);
-- 
1.6.0.6

