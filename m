Return-Path: <linux-kernel-owner+w=401wt.eu-S1765767AbYAUKWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765767AbYAUKWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760245AbYAUKD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:03:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759724AbYAUKDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:03:20 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 53/58] [GFS2] gfs2_alloc_required performance
Date: Mon, 21 Jan 2008 09:22:11 +0000
Message-Id: <12009074321081-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009074312371-git-send-email-swhiteho@redhat.com>
References: <1200907336293-git-send-email-swhiteho@redhat.com>
 <12009073443813-git-send-email-swhiteho@redhat.com>
 <12009073453549-git-send-email-swhiteho@redhat.com>
 <1200907348435-git-send-email-swhiteho@redhat.com>
 <12009073492811-git-send-email-swhiteho@redhat.com>
 <12009073512300-git-send-email-swhiteho@redhat.com>
 <12009073531216-git-send-email-swhiteho@redhat.com>
 <12009073542596-git-send-email-swhiteho@redhat.com>
 <1200907356883-git-send-email-swhiteho@redhat.com>
 <12009073571991-git-send-email-swhiteho@redhat.com>
 <12009073591688-git-send-email-swhiteho@redhat.com>
 <12009073611695-git-send-email-swhiteho@redhat.com>
 <1200907362266-git-send-email-swhiteho@redhat.com>
 <12009073642512-git-send-email-swhiteho@redhat.com>
 <12009073662309-git-send-email-swhiteho@redhat.com>
 <12009073671755-git-send-email-swhiteho@redhat.com>
 <12009073698-git-send-email-swhiteho@redhat.com>
 <12009073701982-git-send-email-swhiteho@redhat.com>
 <12009073722253-git-send-email-swhiteho@redhat.com>
 <1200907374616-git-send-email-swhiteho@redhat.com>
 <12009073753723-git-send-email-swhiteho@redhat.com>
 <12009073771883-git-send-email-swhiteho@redhat.com>
 <1200907378664-git-send-email-swhiteho@redhat.com>
 <12009073803732-git-send-email-swhiteho@redhat.com>
 <12009073823161-git-send-email-swhiteho@redhat.com>
 <12009073841692-git-send-email-swhiteho@redhat.com>
 <12009073862261-git-send-email-swhiteho@redhat.com>
 <12009073883125-git-send-email-swhiteho@redhat.com>
 <12009073891848-git-send-email-swhiteho@redhat.com>
 <12009073913676-git-send-email-swhiteho@redhat.com>
 <12009073933630-git-send-email-swhiteho@redhat.com>
 <12009073953412-git-send-email-swhiteho@redhat.com>
 <1200907397123-git-send-email-swhiteho@redhat.com>
 <12009073981159-git-send-email-swhiteho@redhat.com>
 <12009074002775-git-send-email-swhiteho@redhat.com>
 <12009074021586-git-send-email-swhiteho@redhat.com>
 <12009074032614-git-send-email-swhiteho@redhat.com>
 <1200907405414-git-send-email-swhiteho@redhat.com>
 <12009074074196-git-send-email-swhiteho@redhat.com>
 <12009074082286-git-send-email-swhiteho@redhat.com>
 <12009074103982-git-send-email-swhiteho@redhat.com>
 <12009074121930-git-send-email-swhiteho@redhat.com>
 <12009074142128-git-send-email-swhiteho@redhat.com>
 <12009074163163-git-send-email-swhiteho@redhat.com>
 <1200907417194-git-send-email-swhiteho@redhat.com>
 <12009074192015-git-send-email-swhiteho@redhat.com>
 <12009074213460-git-send-email-swhiteho@redhat.com>
 <12009074221447-git-send-email-swhiteho@redhat.com>
 <12009074243427-git-send-email-swhiteho@redhat.com>
 <12009074263736-git-send-email-swhiteho@redhat.com>
 <12009074271575-git-send-email-swhiteho@redhat.com>
 <12009074291130-git-send-email-swhiteho@redhat.com>
 <12009074312371-git-send-email-swhiteho@redhat.com>
Message-Id: <51b22fb453b7c234ecfee616047d2ccc6ec77f11.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This is a small I/O performance enhancement to gfs2.  (Actually, it is a rework of
an earlier version I got wrong).  The idea here is to check if the write extends
past the last block in the file.  If so, the function can save itself a lot of
time and trouble because it knows an allocate will be required.  Benchmarks like
iozone should see better performance.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 73dfad7..4356cc2 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1224,6 +1224,11 @@ int gfs2_write_alloc_required(struct gfs2_inode *ip, u64 offset,
 		unsigned int shift = sdp->sd_sb.sb_bsize_shift;
 		lblock = offset >> shift;
 		lblock_stop = (offset + len + sdp->sd_sb.sb_bsize - 1) >> shift;
+		if (lblock_stop > ip->i_di.di_blocks) { /* writing past the
+							   last block */
+			*alloc_required = 1;
+			return 0;
+		}
 	}
 
 	for (; lblock < lblock_stop; lblock += extlen) {
-- 
1.5.1.2

