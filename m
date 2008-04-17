Return-Path: <linux-kernel-owner+w=401wt.eu-S1765669AbYDQJho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765669AbYDQJho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932618AbYDQJZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:25:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933480AbYDQJZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:25:27 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 07/48] [GFS2] Only wake the reclaim daemon if we need to
Date: Thu, 17 Apr 2008 09:38:43 +0100
Message-Id: <12084215833555-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084215802470-git-send-email-swhiteho@redhat.com>
References: 12084214272083-git-send-email-swhiteho@redhat.com
 <12084215642582-git-send-email-swhiteho@redhat.com>
 <1208421571478-git-send-email-swhiteho@redhat.com>
 <12084215742081-git-send-email-swhiteho@redhat.com>
 <12084215763647-git-send-email-swhiteho@redhat.com>
 <12084215781246-git-send-email-swhiteho@redhat.com>
 <12084215802470-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch only wakes up the glock reclaim daemon if there is
actually something to be reclaimed.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 7175a4d..5752dec 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1594,10 +1594,10 @@ void gfs2_glock_schedule_for_reclaim(struct gfs2_glock *gl)
 		gfs2_glock_hold(gl);
 		list_add(&gl->gl_reclaim, &sdp->sd_reclaim_list);
 		atomic_inc(&sdp->sd_reclaim_count);
-	}
-	spin_unlock(&sdp->sd_reclaim_lock);
-
-	wake_up(&sdp->sd_reclaim_wq);
+		spin_unlock(&sdp->sd_reclaim_lock);
+		wake_up(&sdp->sd_reclaim_wq);
+	} else
+		spin_unlock(&sdp->sd_reclaim_lock);
 }
 
 /**
-- 
1.5.1.2

