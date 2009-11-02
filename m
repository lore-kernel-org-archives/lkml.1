Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696AbZKBKIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbZKBKIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:08:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754449AbZKBKH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:07:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58569 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430AbZKBKHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:07:06 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>, Alex Elder <aelder@sgi.com>,
       xfs-masters@oss.sgi.com, Christoph Hellwig <hch@lst.de>,
       Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@sandeen.net>,
       Niv Sardi <xaiki@sgi.com>, Felix Blyakher <felixb@sgi.com>,
       xfs@oss.sgi.com
Subject: [PATCH 27/27] BKL: Remove BKL from xfs
Date: Mon,  2 Nov 2009 11:05:07 +0100
Message-Id: <1257156307-24175-28-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1257156307-24175-1-git-send-email-jblunck@suse.de>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BKL is only used in fill_super. It is safe to remove it.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/xfs/linux-2.6/xfs_super.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 7426166..18a4b8e 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1412,8 +1412,6 @@ xfs_fs_fill_super(
 	int			flags = 0, error = ENOMEM;
 	char			*mtpt = NULL;
 
-	lock_kernel();
-
 	mp = kzalloc(sizeof(struct xfs_mount), GFP_KERNEL);
 	if (!mp)
 		goto out;
@@ -1508,7 +1506,6 @@ xfs_fs_fill_super(
 	kfree(mtpt);
 
 	xfs_itrace_exit(XFS_I(sb->s_root->d_inode));
-	unlock_kernel();
 	return 0;
 
  out_filestream_unmount:
@@ -1525,7 +1522,6 @@ xfs_fs_fill_super(
 	kfree(mtpt);
 	kfree(mp);
  out:
-	unlock_kernel();
 	return -error;
 
  fail_vnrele:
-- 
1.6.4.2

