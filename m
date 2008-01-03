Return-Path: <linux-kernel-owner+w=401wt.eu-S1758283AbYACF7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283AbYACF7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 00:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756118AbYACF6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 00:58:15 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:50710 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078AbYACF6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 00:58:12 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 3/3] Unionfs: use VFS helpers to manipulate i_nlink
Date: Thu,  3 Jan 2008 00:57:40 -0500
Message-Id: <11993398631394-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11993398601-git-send-email-ezk@cs.sunysb.edu>
References: <11993398601-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/unlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/unionfs/unlink.c b/fs/unionfs/unlink.c
index a1c82b6..1e370a1 100644
--- a/fs/unionfs/unlink.c
+++ b/fs/unionfs/unlink.c
@@ -79,7 +79,7 @@ static int unionfs_unlink_whiteout(struct inode *dir, struct dentry *dentry)
 
 out:
 	if (!err)
-		dentry->d_inode->i_nlink--;
+		inode_dec_link_count(dentry->d_inode);
 
 	/* We don't want to leave negative leftover dentries for revalidate. */
 	if (!err && (dbopaque(dentry) != -1))
-- 
1.5.2.2

