Return-Path: <linux-kernel-owner+w=401wt.eu-S932874AbXBEOiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874AbXBEOiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932929AbXBEOiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:38:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932874AbXBEOiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:38:23 -0500
Subject: [GFS2] more CURRENT_TIME_SEC [49/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:46:26 +0000
Message-Id: <1170686786.11001.369.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9df7e962608d496427bb2259024dcff933e16c6d Mon Sep 17 00:00:00 2001
From: Eric Sandeen <sandeen@redhat.com>
Date: Mon, 29 Jan 2007 11:11:51 -0600
Subject: [PATCH] [GFS2] more CURRENT_TIME_SEC

Whoops, quilt user error, missed this one in the previous patch.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/eattr.c b/fs/gfs2/eattr.c
index ebebbdc..0c83c7f 100644
--- a/fs/gfs2/eattr.c
+++ b/fs/gfs2/eattr.c
@@ -301,7 +301,7 @@ static int ea_dealloc_unstuffed(struct gfs2_inode *ip, struct buffer_head *bh,
 
 	error = gfs2_meta_inode_buffer(ip, &dibh);
 	if (!error) {
-		ip->i_inode.i_ctime.tv_sec = get_seconds();
+		ip->i_inode.i_ctime = CURRENT_TIME_SEC;
 		gfs2_trans_add_bh(ip->i_gl, dibh, 1);
 		gfs2_dinode_out(ip, dibh->b_data);
 		brelse(dibh);
@@ -718,7 +718,7 @@ static int ea_alloc_skeleton(struct gfs2_inode *ip, struct gfs2_ea_request *er,
 					    (er->er_mode & S_IFMT));
 			ip->i_inode.i_mode = er->er_mode;
 		}
-		ip->i_inode.i_ctime.tv_sec = get_seconds();
+		ip->i_inode.i_ctime = CURRENT_TIME_SEC;
 		gfs2_trans_add_bh(ip->i_gl, dibh, 1);
 		gfs2_dinode_out(ip, dibh->b_data);
 		brelse(dibh);
@@ -853,7 +853,7 @@ static int ea_set_simple_noalloc(struct gfs2_inode *ip, struct buffer_head *bh,
 			(ip->i_inode.i_mode & S_IFMT) == (er->er_mode & S_IFMT));
 		ip->i_inode.i_mode = er->er_mode;
 	}
-	ip->i_inode.i_ctime.tv_sec = get_seconds();
+	ip->i_inode.i_ctime = CURRENT_TIME_SEC;
 	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
 	gfs2_dinode_out(ip, dibh->b_data);
 	brelse(dibh);
@@ -1134,7 +1134,7 @@ static int ea_remove_stuffed(struct gfs2_inode *ip, struct gfs2_ea_location *el)
 
 	error = gfs2_meta_inode_buffer(ip, &dibh);
 	if (!error) {
-		ip->i_inode.i_ctime.tv_sec = get_seconds();
+		ip->i_inode.i_ctime = CURRENT_TIME_SEC;
 		gfs2_trans_add_bh(ip->i_gl, dibh, 1);
 		gfs2_dinode_out(ip, dibh->b_data);
 		brelse(dibh);
-- 
1.4.4.2



