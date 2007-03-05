Return-Path: <linux-kernel-owner+w=401wt.eu-S1752580AbXCEB5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbXCEB5k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbXCEBzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:55:35 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:38380 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbXCEBzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:55:24 -0500
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 08/13] fs/unionfs/: Check return value of d_path
Date: Sun,  4 Mar 2007 20:54:58 -0500
Message-Id: <11730597051029-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.2.260.g2eb065
In-Reply-To: <11730597033857-git-send-email-jsipek@cs.sunysb.edu>
References: <11730597033857-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/super.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index 38443c7..176cfb6 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -311,6 +311,11 @@ static int unionfs_show_options(struct seq_file *m, struct vfsmount *mnt)
 		path = d_path(unionfs_lower_dentry_idx(sb->s_root, bindex),
 			   unionfs_lower_mnt_idx(sb->s_root, bindex), tmp_page,
 			   PAGE_SIZE);
+		if (IS_ERR(path)) {
+			ret = PTR_ERR(path);
+			goto out;
+		}
+
 		perms = branchperms(sb, bindex);
 
 		seq_printf(m, "%s=%s", path,
-- 
1.5.0.2.260.g2eb065

