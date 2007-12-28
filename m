Return-Path: <linux-kernel-owner+w=401wt.eu-S1756876AbXL1Uv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbXL1Uv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 15:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbXL1Uod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 15:44:33 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37175 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbXL1Un6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 15:43:58 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 28/30] Unionfs: don't check dentry on error
Date: Fri, 28 Dec 2007 15:43:02 -0500
Message-Id: <11988745981409-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
References: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index df6138a..740d364 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -158,9 +158,9 @@ out:
 	unionfs_check_inode(parent);
 	if (!err) {
 		unionfs_check_dentry(dentry->d_parent);
+		unionfs_check_dentry(dentry);
 		unionfs_check_nd(nd);
 	}
-	unionfs_check_dentry(dentry);
 	unionfs_unlock_dentry(dentry);
 	unionfs_read_unlock(dentry->d_sb);
 	return err;
-- 
1.5.2.2

