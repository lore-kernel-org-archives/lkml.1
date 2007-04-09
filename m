Return-Path: <linux-kernel-owner+w=401wt.eu-S933691AbXDIO7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933691AbXDIO7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 10:59:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933681AbXDIOyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 10:54:38 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:44001 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933691AbXDIOyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 10:54:35 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 18/21] Unionfs: Pass lowernd to lower ->revalidate function
Date: Mon,  9 Apr 2007 10:54:09 -0400
Message-Id: <11761304562231-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.3.268.g3dda
In-Reply-To: <11761304521844-git-send-email-jsipek@cs.sunysb.edu>
References: <11761304521844-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/dentry.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index b08842f..9eb143d 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -150,8 +150,7 @@ static int __unionfs_d_revalidate_one(struct dentry *dentry, struct nameidata *n
 		if (!hidden_dentry || !hidden_dentry->d_op
 		    || !hidden_dentry->d_op->d_revalidate)
 			continue;
-
-		if (!hidden_dentry->d_op->d_revalidate(hidden_dentry, nd))
+		if (!hidden_dentry->d_op->d_revalidate(hidden_dentry, &lowernd))
 			valid = 0;
 	}
 
-- 
1.5.0.3.268.g3dda

