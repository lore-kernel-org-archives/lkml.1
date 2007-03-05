Return-Path: <linux-kernel-owner+w=401wt.eu-S1750726AbXCEB7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750726AbXCEB7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbXCEB61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:58:27 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:38365 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbXCEBzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:55:15 -0500
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 07/13] fs/unionfs/: Use SEEK_{SET,CUR} instead of hardcoded values
Date: Sun,  4 Mar 2007 20:54:57 -0500
Message-Id: <1173059705953-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.2.260.g2eb065
In-Reply-To: <11730597033857-git-send-email-jsipek@cs.sunysb.edu>
References: <11730597033857-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/dirfops.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/unionfs/dirfops.c b/fs/unionfs/dirfops.c
index 2b77fa9..8f568c7 100644
--- a/fs/unionfs/dirfops.c
+++ b/fs/unionfs/dirfops.c
@@ -135,15 +135,15 @@ static int unionfs_readdir(struct file *file, void *dirent, filldir_t filldir)
 		buf.sb = inode->i_sb;
 
 		/* Read starting from where we last left off. */
-		offset = vfs_llseek(hidden_file, uds->dirpos, 0);
+		offset = vfs_llseek(hidden_file, uds->dirpos, SEEK_SET);
 		if (offset < 0) {
 			err = offset;
 			goto out;
 		}
 		err = vfs_readdir(hidden_file, unionfs_filldir, &buf);
-		/* Save the position for when we continue. */
 
-		offset = vfs_llseek(hidden_file, 0, 1);
+		/* Save the position for when we continue. */
+		offset = vfs_llseek(hidden_file, 0, SEEK_CUR);
 		if (offset < 0) {
 			err = offset;
 			goto out;
-- 
1.5.0.2.260.g2eb065

