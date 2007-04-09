Return-Path: <linux-kernel-owner+w=401wt.eu-S964793AbXDIO5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964793AbXDIO5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 10:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933766AbXDIO4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 10:56:36 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:44042 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933798AbXDIOzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 10:55:10 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 15/21] Unionfs: Decrement totalopens counter on error in unionfs_open
Date: Mon,  9 Apr 2007 10:54:06 -0400
Message-Id: <1176130455797-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.3.268.g3dda
In-Reply-To: <11761304521844-git-send-email-jsipek@cs.sunysb.edu>
References: <11761304521844-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 8453f2d..c9df99d 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -509,6 +509,7 @@ int unionfs_open(struct inode *inode, struct file *file)
 
 	/* freeing the allocated resources, and fput the opened files */
 	if (err) {
+		atomic_dec(&UNIONFS_I(dentry->d_inode)->totalopens);
 		for (bindex = bstart; bindex <= bend; bindex++) {
 			hidden_file = unionfs_lower_file_idx(file, bindex);
 			if (!hidden_file)
-- 
1.5.0.3.268.g3dda

