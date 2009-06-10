Return-Path: <linux-kernel-owner+w=401wt.eu-S1759537AbZFJJko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537AbZFJJko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758041AbZFJJiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:38:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40293 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757517AbZFJJiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:38:07 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 10/24] GFS2: Don't warn when delete inode fails on ro filesystem
Date: Wed, 10 Jun 2009 09:30:51 +0100
Message-Id: <1244622665-7470-11-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1244622665-7470-10-git-send-email-swhiteho@redhat.com>
References: <1244622665-7470-1-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-2-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-3-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-4-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-5-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-6-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-7-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-8-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-9-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-10-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the filesystem is read-only, then we expect that delete inode
will fail, so there is no need to warn about it.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_super.c b/fs/gfs2/ops_super.c
index a3c2272..2fd1dcb 100644
--- a/fs/gfs2/ops_super.c
+++ b/fs/gfs2/ops_super.c
@@ -714,7 +714,7 @@ out_unlock:
 		gfs2_glock_dq(&ip->i_iopen_gh);
 	gfs2_holder_uninit(&ip->i_iopen_gh);
 	gfs2_glock_dq_uninit(&gh);
-	if (error && error != GLR_TRYFAILED)
+	if (error && error != GLR_TRYFAILED && error != -EROFS)
 		fs_warn(sdp, "gfs2_delete_inode: %d\n", error);
 out:
 	truncate_inode_pages(&inode->i_data, 0);
-- 
1.6.0.6

