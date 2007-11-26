Return-Path: <linux-kernel-owner+w=401wt.eu-S1758222AbXKZQry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222AbXKZQry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756425AbXKZQpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:45:50 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:52805 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919AbXKZQpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:45:42 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 05/16] Unionfs: set lower mnt after mkdir which resulted in copyup
Date: Mon, 26 Nov 2007 11:44:02 -0500
Message-Id: <11960954552542-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11960954531503-git-send-email-ezk@cs.sunysb.edu>
References: <11960954531503-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/inode.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 1708f40..9c144be 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -674,8 +674,10 @@ out:
 
 	kfree(name);
 
-	if (!err)
+	if (!err) {
 		unionfs_copy_attr_times(dentry->d_inode);
+		unionfs_postcopyup_setmnt(dentry);
+	}
 	unionfs_check_inode(parent);
 	unionfs_check_dentry(dentry);
 	unionfs_unlock_dentry(dentry);
-- 
1.5.2.2

