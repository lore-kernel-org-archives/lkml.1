Return-Path: <linux-kernel-owner+w=401wt.eu-S1761613AbYAQWrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761613AbYAQWrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760161AbYAQWhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:37:12 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:11019 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759915AbYAQWgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:36:55 -0500
From: Mark Fasheh <mark.fasheh@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Jan Kara <jack@suse.cz>
Subject: [PATCH 23/30] ocfs2: printf fixes
Date: Thu, 17 Jan 2008 14:35:49 -0800
Message-Id: <1200609356-17788-24-git-send-email-mark.fasheh@oracle.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

Explicitely convert loff_t to long long in printf. Just for sure...

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/file.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 6ebc9f9..ed5d523 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -626,7 +626,7 @@ int ocfs2_lock_allocators(struct inode *inode, struct ocfs2_dinode *di,
 
 	mlog(0, "extend inode %llu, i_size = %lld, di->i_clusters = %u, "
 	     "clusters_to_add = %u, extents_to_split = %u\n",
-	     (unsigned long long)OCFS2_I(inode)->ip_blkno, i_size_read(inode),
+	     (unsigned long long)OCFS2_I(inode)->ip_blkno, (long long)i_size_read(inode),
 	     le32_to_cpu(di->i_clusters), clusters_to_add, extents_to_split);
 
 	num_free_extents = ocfs2_num_free_extents(osb, inode, di);
@@ -807,7 +807,7 @@ restarted_transaction:
 	     le32_to_cpu(fe->i_clusters),
 	     (unsigned long long)le64_to_cpu(fe->i_size));
 	mlog(0, "inode: ip_clusters=%u, i_size=%lld\n",
-	     OCFS2_I(inode)->ip_clusters, i_size_read(inode));
+	     OCFS2_I(inode)->ip_clusters, (long long)i_size_read(inode));
 
 leave:
 	if (handle) {
-- 
1.5.3.6

