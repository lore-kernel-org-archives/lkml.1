Return-Path: <linux-kernel-owner+w=401wt.eu-S1758595AbYAJCR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595AbYAJCR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 21:17:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757289AbYAJCRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 21:17:07 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37451 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757547AbYAJCRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 21:17:02 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 4/4] Unionfs: ensure we have lower dentries in d_iput
Date: Wed,  9 Jan 2008 21:16:32 -0500
Message-Id: <11999313941523-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <1199931392670-git-send-email-ezk@cs.sunysb.edu>
References: <1199931392670-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/dentry.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index d969640..cd15243 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -507,9 +507,10 @@ static void unionfs_d_iput(struct dentry *dentry, struct inode *inode)
 {
 	int bindex, rc;
 
+	BUG_ON(!dentry);
 	unionfs_read_lock(dentry->d_sb, UNIONFS_SMUTEX_CHILD);
 
-	if (dbstart(dentry) < 0)
+	if (!UNIONFS_D(dentry) || dbstart(dentry) < 0)
 		goto drop_lower_inodes;
 	for (bindex = dbstart(dentry); bindex <= dbend(dentry); bindex++) {
 		if (unionfs_lower_mnt_idx(dentry, bindex)) {
-- 
1.5.2.2

