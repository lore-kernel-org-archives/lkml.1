Return-Path: <linux-kernel-owner+w=401wt.eu-S965502AbXAWWjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965502AbXAWWjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 17:39:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965505AbXAWWjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 17:39:10 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:55138 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965502AbXAWWjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 17:39:09 -0500
Date: Wed, 24 Jan 2007 09:39:00 +1100
From: David Chinner <dgc@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: xfs@oss.sgi.com, akpm@osdl.org
Subject: [PATCH 2/2]: Fix BUG in cancel_dirty_pages on XFS
Message-ID: <20070123223900.GG33919298@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make XFS use the new truncate_unmap_inode_pages_range()
function.

Signed-off-by: Dave Chinner <dgc@sgi.com>

---
 fs/xfs/linux-2.6/xfs_fs_subr.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_fs_subr.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_fs_subr.c	2007-01-23 18:42:46.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_fs_subr.c	2007-01-23 18:44:53.955160806 +1100
@@ -32,7 +32,8 @@ fs_tosspages(
 	struct inode	*ip = vn_to_inode(vp);
 
 	if (VN_CACHED(vp))
-		truncate_inode_pages(ip->i_mapping, first);
+		truncate_unmap_inode_pages_range(ip->i_mapping,
+						first, last, 1);
 }
 
 void
@@ -49,7 +50,8 @@ fs_flushinval_pages(
 		if (VN_TRUNC(vp))
 			VUNTRUNCATE(vp);
 		filemap_write_and_wait(ip->i_mapping);
-		truncate_inode_pages(ip->i_mapping, first);
+		truncate_unmap_inode_pages_range(ip->i_mapping,
+						first, last, 1);
 	}
 }
 
