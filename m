Return-Path: <linux-kernel-owner+w=401wt.eu-S1760300AbXIZDg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760300AbXIZDg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 23:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759743AbXIZDdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 23:33:42 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:35480 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759672AbXIZDdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 23:33:40 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Olivier Blin <blino@mandriva.com>, Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 04/25] Unionfs: cache-coherency fixes
Date: Tue, 25 Sep 2007 23:09:43 -0400
Message-Id: <1190776206791-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11907762042481-git-send-email-ezk@cs.sunysb.edu>
References: <11907762042481-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olivier Blin <blino@mandriva.com>

Do not update mtime if there is no upper branch for the inode.  This
prevents from calling unionfs_lower_inode_idx() with a negative index, which
triggers a bug.

Signed-off-by: Olivier Blin <blino@mandriva.com>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/fanout.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/unionfs/fanout.h b/fs/unionfs/fanout.h
index afeb9f6..51aa0de 100644
--- a/fs/unionfs/fanout.h
+++ b/fs/unionfs/fanout.h
@@ -308,7 +308,7 @@ static inline void unionfs_copy_attr_times(struct inode *upper)
 	int bindex;
 	struct inode *lower;
 
-	if (!upper)
+	if (!upper || ibstart(upper) < 0)
 		return;
 	for (bindex=ibstart(upper); bindex <= ibend(upper); bindex++) {
 		lower = unionfs_lower_inode_idx(upper, bindex);
-- 
1.5.2.2

