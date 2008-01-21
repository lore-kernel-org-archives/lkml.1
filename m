Return-Path: <linux-kernel-owner+w=401wt.eu-S1764327AbYAUKPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764327AbYAUKPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760015AbYAUKC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:02:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759957AbYAUKCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:02:53 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 37/58] [GFS2] Get rid of useless "found" variable in quota.c
Date: Mon, 21 Jan 2008 09:21:55 +0000
Message-Id: <1200907405414-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009074032614-git-send-email-swhiteho@redhat.com>
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
Message-Id: <0c49902611713aaaa068bd588b88299e19c8ce71.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This just eliminates an unused variable from the quota code.
Not likely to be a time saver.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 8b4c20c..60cc50f 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2004-2007 Red Hat, Inc.  All rights reserved.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
@@ -273,7 +273,7 @@ static int bh_get(struct gfs2_quota_data *qd)
 	}
 
 	block = qd->qd_slot / sdp->sd_qc_per_block;
-	offset = qd->qd_slot % sdp->sd_qc_per_block;;
+	offset = qd->qd_slot % sdp->sd_qc_per_block;
 
 	bh_map.b_size = 1 << ip->i_inode.i_blkbits;
 	error = gfs2_block_map(&ip->i_inode, block, &bh_map, 0);
@@ -1016,7 +1016,6 @@ void gfs2_quota_change(struct gfs2_inode *ip, s64 change,
 	struct gfs2_alloc *al = &ip->i_alloc;
 	struct gfs2_quota_data *qd;
 	unsigned int x;
-	unsigned int found = 0;
 
 	if (gfs2_assert_warn(GFS2_SB(&ip->i_inode), change))
 		return;
@@ -1029,7 +1028,6 @@ void gfs2_quota_change(struct gfs2_inode *ip, s64 change,
 		if ((qd->qd_id == uid && test_bit(QDF_USER, &qd->qd_flags)) ||
 		    (qd->qd_id == gid && !test_bit(QDF_USER, &qd->qd_flags))) {
 			do_qc(qd, change);
-			found++;
 		}
 	}
 }
-- 
1.5.1.2

