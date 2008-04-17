Return-Path: <linux-kernel-owner+w=401wt.eu-S934211AbYDQJft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934211AbYDQJft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933426AbYDQJZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:25:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765709AbYDQJZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:25:19 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 03/48] [GFS2] Get rid of unneeded parameter in gfs2_rlist_alloc
Date: Thu, 17 Apr 2008 09:38:39 +0100
Message-Id: <12084215742081-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1208421571478-git-send-email-swhiteho@redhat.com>
References: 12084214272083-git-send-email-swhiteho@redhat.com
 <12084215642582-git-send-email-swhiteho@redhat.com>
 <1208421571478-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch removed the unnecessary parameter from function
gfs2_rlist_alloc.  The parameter was always passed in as 0.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 5a31870..e8e48b6 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -680,7 +680,7 @@ static int do_strip(struct gfs2_inode *ip, struct buffer_head *dibh,
 	else
 		goto out; /* Nothing to do */
 
-	gfs2_rlist_alloc(&rlist, LM_ST_EXCLUSIVE, 0);
+	gfs2_rlist_alloc(&rlist, LM_ST_EXCLUSIVE);
 
 	for (x = 0; x < rlist.rl_rgrps; x++) {
 		struct gfs2_rgrpd *rgd;
diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index c347095..78c236f 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -1894,7 +1894,7 @@ static int leaf_dealloc(struct gfs2_inode *dip, u32 index, u32 len,
 		l_blocks++;
 	}
 
-	gfs2_rlist_alloc(&rlist, LM_ST_EXCLUSIVE, 0);
+	gfs2_rlist_alloc(&rlist, LM_ST_EXCLUSIVE);
 
 	for (x = 0; x < rlist.rl_rgrps; x++) {
 		struct gfs2_rgrpd *rgd;
diff --git a/fs/gfs2/eattr.c b/fs/gfs2/eattr.c
index bee9970..04febbc 100644
--- a/fs/gfs2/eattr.c
+++ b/fs/gfs2/eattr.c
@@ -1347,7 +1347,7 @@ static int ea_dealloc_indirect(struct gfs2_inode *ip)
 	else
 		goto out;
 
-	gfs2_rlist_alloc(&rlist, LM_ST_EXCLUSIVE, 0);
+	gfs2_rlist_alloc(&rlist, LM_ST_EXCLUSIVE);
 
 	for (x = 0; x < rlist.rl_rgrps; x++) {
 		struct gfs2_rgrpd *rgd;
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 3552110..7b9d6f1 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2007 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2004-2008 Red Hat, Inc.  All rights reserved.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
@@ -1699,8 +1699,7 @@ void gfs2_rlist_add(struct gfs2_sbd *sdp, struct gfs2_rgrp_list *rlist,
  *
  */
 
-void gfs2_rlist_alloc(struct gfs2_rgrp_list *rlist, unsigned int state,
-		      int flags)
+void gfs2_rlist_alloc(struct gfs2_rgrp_list *rlist, unsigned int state)
 {
 	unsigned int x;
 
@@ -1708,7 +1707,7 @@ void gfs2_rlist_alloc(struct gfs2_rgrp_list *rlist, unsigned int state,
 				GFP_NOFS | __GFP_NOFAIL);
 	for (x = 0; x < rlist->rl_rgrps; x++)
 		gfs2_holder_init(rlist->rl_rgd[x]->rd_gl,
-				state, flags,
+				state, 0,
 				&rlist->rl_ghs[x]);
 }
 
diff --git a/fs/gfs2/rgrp.h b/fs/gfs2/rgrp.h
index 149bb16..5683605 100644
--- a/fs/gfs2/rgrp.h
+++ b/fs/gfs2/rgrp.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2004-2008 Red Hat, Inc.  All rights reserved.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
@@ -64,8 +64,7 @@ struct gfs2_rgrp_list {
 
 void gfs2_rlist_add(struct gfs2_sbd *sdp, struct gfs2_rgrp_list *rlist,
 		    u64 block);
-void gfs2_rlist_alloc(struct gfs2_rgrp_list *rlist, unsigned int state,
-		      int flags);
+void gfs2_rlist_alloc(struct gfs2_rgrp_list *rlist, unsigned int state);
 void gfs2_rlist_free(struct gfs2_rgrp_list *rlist);
 u64 gfs2_ri_total(struct gfs2_sbd *sdp);
 
-- 
1.5.1.2

