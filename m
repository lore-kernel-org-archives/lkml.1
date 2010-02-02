Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab0BBJ40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 04:56:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754829Ab0BBJ4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 04:56:18 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 4/4] GFS2: Use GFP_NOFS for alloc structure
Date: Tue,  2 Feb 2010 09:47:25 +0000
Message-Id: <1265104045-15957-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1265104045-15957-4-git-send-email-swhiteho@redhat.com>
References: <1265104045-15957-1-git-send-email-swhiteho@redhat.com>
 <1265104045-15957-2-git-send-email-swhiteho@redhat.com>
 <1265104045-15957-3-git-send-email-swhiteho@redhat.com>
 <1265104045-15957-4-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is called under a glock, so its a good plan to use GFP_NOFS

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/rgrp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 46534a5..503b842 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -911,7 +911,7 @@ void gfs2_rgrp_repolish_clones(struct gfs2_rgrpd *rgd)
 struct gfs2_alloc *gfs2_alloc_get(struct gfs2_inode *ip)
 {
 	BUG_ON(ip->i_alloc != NULL);
-	ip->i_alloc = kzalloc(sizeof(struct gfs2_alloc), GFP_KERNEL);
+	ip->i_alloc = kzalloc(sizeof(struct gfs2_alloc), GFP_NOFS);
 	return ip->i_alloc;
 }
 
-- 
1.6.2.5

