Return-Path: <linux-kernel-owner+w=401wt.eu-S1761904AbXKCBYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761904AbXKCBYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 21:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757032AbXKCBXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 21:23:20 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:35203 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbXKCBXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 21:23:15 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 6/8] Unionfs: don't bother validating inode if it has no lower branches
Date: Fri,  2 Nov 2007 21:22:47 -0400
Message-Id: <11940529722460-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11940529692937-git-send-email-ezk@cs.sunysb.edu>
References: <11940529692937-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/debug.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/unionfs/debug.c b/fs/unionfs/debug.c
index 894bf7c..0066ccd 100644
--- a/fs/unionfs/debug.c
+++ b/fs/unionfs/debug.c
@@ -49,6 +49,9 @@ void __unionfs_check_inode(const struct inode *inode,
 	sb = inode->i_sb;
 	istart = ibstart(inode);
 	iend = ibend(inode);
+	/* don't check inode if no lower branches */
+	if (istart < 0 && iend < 0)
+		return;
 	if (unlikely(istart > iend)) {
 		PRINT_CALLER(fname, fxn, line);
 		pr_debug(" Ci0: inode=%p istart/end=%d:%d\n",
@@ -221,6 +224,9 @@ check_inode:
 		return;
 	istart = ibstart(inode);
 	iend = ibend(inode);
+	/* don't check inode if no lower branches */
+	if (istart < 0 && iend < 0)
+		return;
 	BUG_ON(istart > iend);
 	if (unlikely((istart == -1 && iend != -1) ||
 		     (istart != -1 && iend == -1))) {
-- 
1.5.2.2

