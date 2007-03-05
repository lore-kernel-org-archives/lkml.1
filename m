Return-Path: <linux-kernel-owner+w=401wt.eu-S1752060AbXCEB5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbXCEB5k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbXCEBzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:55:33 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:38381 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbXCEBzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:55:24 -0500
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 11/13] fs/unionfs/: mntput in __cleanup_dentry
Date: Sun,  4 Mar 2007 20:55:01 -0500
Message-Id: <11730597052814-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.2.260.g2eb065
In-Reply-To: <11730597033857-git-send-email-jsipek@cs.sunysb.edu>
References: <11730597033857-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

This fixes a mnt refleak which occured during copyup when directory
hierarchy was recreated on a writable branch.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/copyup.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/unionfs/copyup.c b/fs/unionfs/copyup.c
index 998cc69..e0075ca 100644
--- a/fs/unionfs/copyup.c
+++ b/fs/unionfs/copyup.c
@@ -548,6 +548,9 @@ static void __cleanup_dentry(struct dentry * dentry, int bindex,
 		if (!unionfs_lower_dentry_idx(dentry, i)->d_inode) {
 			dput(unionfs_lower_dentry_idx(dentry, i));
 			unionfs_set_lower_dentry_idx(dentry, i, NULL);
+
+			mntput(unionfs_lower_mnt_idx(dentry, i));
+			unionfs_set_lower_mnt_idx(dentry, i, NULL);
 		} else {
 			if (new_bstart < 0)
 				new_bstart = i;
-- 
1.5.0.2.260.g2eb065

