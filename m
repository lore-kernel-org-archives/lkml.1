Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbXL1Ups@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbXL1Ups (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 15:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbXL1Unq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 15:43:46 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37102 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbXL1Unj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 15:43:39 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 06/30] Unionfs: initialize inode times for reused inodes
Date: Fri, 28 Dec 2007 15:42:40 -0500
Message-Id: <11988745882719-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
References: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/super.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index ed3eb04..c474c86 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -55,6 +55,14 @@ static void unionfs_read_inode(struct inode *inode)
 
 	inode->i_mapping->a_ops = &unionfs_aops;
 
+	/*
+	 * reset times so unionfs_copy_attr_all can keep out time invariants
+	 * right (upper inode time being the max of all lower ones).
+	 */
+	inode->i_atime.tv_sec = inode->i_atime.tv_nsec = 0;
+	inode->i_mtime.tv_sec = inode->i_mtime.tv_nsec = 0;
+	inode->i_ctime.tv_sec = inode->i_ctime.tv_nsec = 0;
+
 	unionfs_read_unlock(inode->i_sb);
 }
 
-- 
1.5.2.2

