Return-Path: <linux-kernel-owner+w=401wt.eu-S1760263AbXICCi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760263AbXICCi1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932592AbXICC0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:26:24 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57764 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757743AbXICC0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:26:06 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 10/32] Unionfs: cache-coherency - file flush
Date: Sun,  2 Sep 2007 22:20:33 -0400
Message-Id: <1188786056480-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Update our inode's time after flush.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 0dc7492..edb52c0 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -742,6 +742,11 @@ int unionfs_flush(struct file *file, fl_owner_t id)
 
 	}
 
+	/* on success, update our times */
+	unionfs_copy_attr_times(dentry->d_inode);
+	/* parent time could have changed too (async) */
+	unionfs_copy_attr_times(dentry->d_parent->d_inode);
+
 out_lock:
 	unionfs_unlock_dentry(dentry);
 out:
-- 
1.5.2.2.238.g7cbf2f2

