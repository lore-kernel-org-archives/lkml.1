Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751128Ab0BBJ4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 04:56:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754750Ab0BBJ4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 04:56:17 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3/4] GFS2: Fix previous patch
Date: Tue,  2 Feb 2010 09:47:24 +0000
Message-Id: <1265104045-15957-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1265104045-15957-3-git-send-email-swhiteho@redhat.com>
References: <1265104045-15957-1-git-send-email-swhiteho@redhat.com>
 <1265104045-15957-2-git-send-email-swhiteho@redhat.com>
 <1265104045-15957-3-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The do_div() call needs to remain.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/rgrp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 6702b82..46534a5 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -591,6 +591,7 @@ static int gfs2_ri_update(struct gfs2_inode *ip)
 	u64 rgrp_count = ip->i_disksize;
 	int error;
 
+	do_div(rgrp_count, sizeof(struct gfs2_rindex));
 	clear_rgrpdi(sdp);
 
 	file_ra_state_init(&ra_state, inode->i_mapping);
-- 
1.6.2.5

