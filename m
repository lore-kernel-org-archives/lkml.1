Return-Path: <linux-kernel-owner+w=401wt.eu-S1751817AbXFDCRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817AbXFDCRy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 22:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751032AbXFDCRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 22:17:45 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:50958 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbXFDCRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 22:17:45 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH -mm] Unionfs: Fix lock leak in unionfs_ioctl
Date: Sun,  3 Jun 2007 22:17:35 -0400
Message-Id: <11809234553416-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(This patch is already in the Unionfs git tree. This is just a heads up.)

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 83001aa..1045e51 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -635,7 +635,6 @@ static long do_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	}
 
 out:
-	unionfs_read_unlock(file->f_dentry->d_sb);
 	return err;
 }
 
@@ -709,6 +708,7 @@ long unionfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	}
 
 out:
+	unionfs_read_unlock(file->f_dentry->d_sb);
 	return err;
 }
 
-- 
1.5.2.rc1.165.gaf9b

