Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbXJUXwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbXJUXwk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 19:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751561AbXJUXvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 19:51:50 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49190 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbXJUXvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 19:51:45 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 5/9] Unionfs: don't bother validating dentry if it has no lower branches
Date: Sun, 21 Oct 2007 19:51:18 -0400
Message-Id: <11930106852087-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11930106823372-git-send-email-ezk@cs.sunysb.edu>
References: <11930106823372-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/debug.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/unionfs/debug.c b/fs/unionfs/debug.c
index 68692d7..894bf7c 100644
--- a/fs/unionfs/debug.c
+++ b/fs/unionfs/debug.c
@@ -132,6 +132,9 @@ void __unionfs_check_dentry(const struct dentry *dentry,
 	inode = dentry->d_inode;
 	dstart = dbstart(dentry);
 	dend = dbend(dentry);
+	/* don't check dentry/mnt if no lower branches */
+	if (dstart < 0 && dend < 0)
+		goto check_inode;
 	BUG_ON(dstart > dend);
 
 	if (unlikely((dstart == -1 && dend != -1) ||
@@ -212,6 +215,7 @@ void __unionfs_check_dentry(const struct dentry *dentry,
 		}
 	}
 
+check_inode:
 	/* for inodes now */
 	if (!inode)
 		return;
-- 
1.5.2.2

