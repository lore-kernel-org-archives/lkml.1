Return-Path: <linux-kernel-owner+w=401wt.eu-S1759119AbYDQJhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759119AbYDQJhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933483AbYDQJZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:25:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759578AbYDQJZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:25:25 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 06/48] [GFS2] Misc fixups
Date: Thu, 17 Apr 2008 09:38:42 +0100
Message-Id: <12084215802470-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084215781246-git-send-email-swhiteho@redhat.com>
References: 12084214272083-git-send-email-swhiteho@redhat.com
 <12084215642582-git-send-email-swhiteho@redhat.com>
 <1208421571478-git-send-email-swhiteho@redhat.com>
 <12084215742081-git-send-email-swhiteho@redhat.com>
 <12084215763647-git-send-email-swhiteho@redhat.com>
 <12084215781246-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch contains two small fixups that didn't fit elsewhere.
They are: (1) get rid of temp variable in find_metapath.
(2) Remove vestigial "ret" variable from gfs2_writepage_common.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index e8e48b6..e84e384 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -305,11 +305,10 @@ static void find_metapath(struct gfs2_inode *ip, u64 block,
 			  struct metapath *mp)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-	u64 b = block;
 	unsigned int i;
 
 	for (i = ip->i_height; i--;)
-		mp->mp_list[i] = do_div(b, sdp->sd_inptrs);
+		mp->mp_list[i] = do_div(block, sdp->sd_inptrs);
 
 }
 
diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index ac772b6..7523999 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2007 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2004-2008 Red Hat, Inc.  All rights reserved.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
@@ -104,11 +104,9 @@ static int gfs2_writepage_common(struct page *page,
 	loff_t i_size = i_size_read(inode);
 	pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
 	unsigned offset;
-	int ret = -EIO;
 
 	if (gfs2_assert_withdraw(sdp, gfs2_glock_is_held_excl(ip->i_gl)))
 		goto out;
-	ret = 0;
 	if (current->journal_info)
 		goto redirty;
 	/* Is the page fully outside i_size? (truncate in progress) */
-- 
1.5.1.2

