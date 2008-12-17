Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760482AbYLQMdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760482AbYLQMdl (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbYLQM3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:29:24 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53742 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbYLQM3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:29:20 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 13/24] GFS2: Add more detail to debugfs glock dumps
Date: Wed, 17 Dec 2008 11:30:12 +0000
Message-Id: <1229513423-19105-14-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1229513423-19105-13-git-send-email-swhiteho@redhat.com>
References: <1229513423-19105-1-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-2-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-3-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-4-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-5-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-6-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-7-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-8-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-9-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-10-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-11-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-12-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-13-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

Although the glock dumps print quite a lot of information about
the glocks themselves, there are more things which can be
usefully added to the dump realting to the objects themselves.

This patch adds a few more fields to the inode and resource
group lines, which should be useful for debugging.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 848d64c..68ee665 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -260,10 +260,13 @@ static int inode_go_dump(struct seq_file *seq, const struct gfs2_glock *gl)
 	const struct gfs2_inode *ip = gl->gl_object;
 	if (ip == NULL)
 		return 0;
-	gfs2_print_dbg(seq, " I: n:%llu/%llu t:%u f:0x%08lx\n",
+	gfs2_print_dbg(seq, " I: n:%llu/%llu t:%u f:0x%02lx d:0x%08x s:%llu/%llu\n",
 		  (unsigned long long)ip->i_no_formal_ino,
 		  (unsigned long long)ip->i_no_addr,
-		  IF2DT(ip->i_inode.i_mode), ip->i_flags);
+		  IF2DT(ip->i_inode.i_mode), ip->i_flags,
+		  (unsigned int)ip->i_diskflags,
+		  (unsigned long long)ip->i_inode.i_size,
+		  (unsigned long long)ip->i_disksize);
 	return 0;
 }
 
@@ -318,7 +321,9 @@ static int rgrp_go_dump(struct seq_file *seq, const struct gfs2_glock *gl)
 	const struct gfs2_rgrpd *rgd = gl->gl_object;
 	if (rgd == NULL)
 		return 0;
-	gfs2_print_dbg(seq, " R: n:%llu\n", (unsigned long long)rgd->rd_addr);
+	gfs2_print_dbg(seq, " R: n:%llu f:%02x b:%u/%u i:%u\n",
+		       (unsigned long long)rgd->rd_addr, rgd->rd_flags,
+		       rgd->rd_free, rgd->rd_free_clone, rgd->rd_dinodes);
 	return 0;
 }
 
-- 
1.6.0.3

