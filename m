Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbZIJKcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbZIJKcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 06:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbZIJKcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 06:32:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755461AbZIJK3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 06:29:45 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 04/15] GFS2: Replace assertion with proper error handling
Date: Thu, 10 Sep 2009 12:27:56 +0100
Message-Id: <1252582087-10007-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1252582087-10007-4-git-send-email-swhiteho@redhat.com>
References: <1252582087-10007-1-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-2-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-3-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-4-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One fewer assert, one more place we can recover gracefully
if there is an error.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/rgrp.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 3d0193a..c681c54 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1561,7 +1561,9 @@ int gfs2_alloc_di(struct gfs2_inode *dip, u64 *bn, u64 *generation)
 
 	rgd->rd_last_alloc = blk;
 	block = rgd->rd_data0 + blk;
-	gfs2_assert_withdraw(sdp, rgd->rd_free);
+	if (rgd->rd_free == 0)
+		goto rgrp_error;
+
 	rgd->rd_free--;
 	rgd->rd_dinodes++;
 	*generation = rgd->rd_igeneration++;
-- 
1.6.2.5

