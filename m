Return-Path: <linux-kernel-owner+w=401wt.eu-S934609AbYDQJiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934609AbYDQJiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932940AbYDQJZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:25:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933382AbYDQJZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:25:33 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 09/48] [GFS2] Plug an unlikely leak
Date: Thu, 17 Apr 2008 09:38:45 +0100
Message-Id: <120842158797-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084215851158-git-send-email-swhiteho@redhat.com>
References: 12084214272083-git-send-email-swhiteho@redhat.com
 <12084215642582-git-send-email-swhiteho@redhat.com>
 <1208421571478-git-send-email-swhiteho@redhat.com>
 <12084215742081-git-send-email-swhiteho@redhat.com>
 <12084215763647-git-send-email-swhiteho@redhat.com>
 <12084215781246-git-send-email-swhiteho@redhat.com>
 <12084215802470-git-send-email-swhiteho@redhat.com>
 <12084215833555-git-send-email-swhiteho@redhat.com>
 <12084215851158-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 7138737..4390f6f 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -404,8 +404,10 @@ static int revoke_lo_scan_elements(struct gfs2_jdesc *jd, unsigned int start,
 			blkno = be64_to_cpu(*(__be64 *)(bh->b_data + offset));
 
 			error = gfs2_revoke_add(sdp, blkno, start);
-			if (error < 0)
+			if (error < 0) {
+				brelse(bh);
 				return error;
+			}
 			else if (error)
 				sdp->sd_found_revokes++;
 
-- 
1.5.1.2

