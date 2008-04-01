Return-Path: <linux-kernel-owner+w=401wt.eu-S1761886AbYDAVMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761886AbYDAVMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762137AbYDAVIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:08:20 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:45636 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761223AbYDAVIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:08:13 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 14/14] Unionfs: update lower mnts on rmdir with copyup
Date: Tue,  1 Apr 2008 17:06:56 -0400
Message-Id: <1207084023206-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12070840162442-git-send-email-ezk@cs.sunysb.edu>
References: <12070840162442-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/unlink.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/unionfs/unlink.c b/fs/unionfs/unlink.c
index c66bb3e..cad0386 100644
--- a/fs/unionfs/unlink.c
+++ b/fs/unionfs/unlink.c
@@ -280,6 +280,8 @@ out:
 		    !unionfs_lower_inode_idx(inode, dend))
 			ibstart(inode) = ibend(inode) = -1;
 		d_drop(dentry);
+		/* update our lower vfsmnts, in case a copyup took place */
+		unionfs_postcopyup_setmnt(dentry);
 	}
 
 	if (namelist)
-- 
1.5.2.2

