Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbXL1Uv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbXL1Uv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 15:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbXL1Uo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 15:44:26 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37189 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbXL1UoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 15:44:04 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 15/30] Unionfs: remove unnecessary lock when deleting whiteouts
Date: Fri, 28 Dec 2007 15:42:49 -0500
Message-Id: <11988745922017-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
References: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lockdep complained, because we eventually call vfs_unlink which'd grab the
necessary locks.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/dirhelper.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/unionfs/dirhelper.c b/fs/unionfs/dirhelper.c
index 2e52fc3..b40090a 100644
--- a/fs/unionfs/dirhelper.c
+++ b/fs/unionfs/dirhelper.c
@@ -110,7 +110,6 @@ int delete_whiteouts(struct dentry *dentry, int bindex,
 	lower_dir = lower_dir_dentry->d_inode;
 	BUG_ON(!S_ISDIR(lower_dir->i_mode));
 
-	mutex_lock(&lower_dir->i_mutex);
 	if (!permission(lower_dir, MAY_WRITE | MAY_EXEC, NULL)) {
 		err = do_delete_whiteouts(dentry, bindex, namelist);
 	} else {
@@ -120,7 +119,6 @@ int delete_whiteouts(struct dentry *dentry, int bindex,
 		run_sioq(__delete_whiteouts, &args);
 		err = args.err;
 	}
-	mutex_unlock(&lower_dir->i_mutex);
 
 out:
 	return err;
-- 
1.5.2.2

