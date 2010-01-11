Return-Path: <linux-kernel-owner+w=401wt.eu-S1753022Ab0AKJQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab0AKJQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 04:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949Ab0AKJPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 04:15:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613Ab0AKJPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 04:15:41 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 4/4] GFS2: Use MAX_LFS_FILESIZE for meta inode size
Date: Mon, 11 Jan 2010 09:11:40 +0000
Message-Id: <1263201100-6904-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1263201100-6904-4-git-send-email-swhiteho@redhat.com>
References: <1263201100-6904-1-git-send-email-swhiteho@redhat.com>
 <1263201100-6904-2-git-send-email-swhiteho@redhat.com>
 <1263201100-6904-3-git-send-email-swhiteho@redhat.com>
 <1263201100-6904-4-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using ~0ULL was cauing sign issues in filemap_fdatawrite_range, so
use MAX_LFS_FILESIZE instead.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/meta_io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index cb8d7a9..6f68a5f 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -121,7 +121,7 @@ struct inode *gfs2_aspace_get(struct gfs2_sbd *sdp)
 	if (aspace) {
 		mapping_set_gfp_mask(aspace->i_mapping, GFP_NOFS);
 		aspace->i_mapping->a_ops = &aspace_aops;
-		aspace->i_size = ~0ULL;
+		aspace->i_size = MAX_LFS_FILESIZE;
 		ip = GFS2_I(aspace);
 		clear_bit(GIF_USER, &ip->i_flags);
 		insert_inode_hash(aspace);
-- 
1.6.2.5

