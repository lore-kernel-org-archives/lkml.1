Return-Path: <linux-kernel-owner+w=401wt.eu-S1765261AbYAUKVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765261AbYAUKVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:21:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759647AbYAUKDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:03:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759720AbYAUKDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:03:15 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 50/58] [GFS2] Fix assert in log code
Date: Mon, 21 Jan 2008 09:22:08 +0000
Message-Id: <12009074271575-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009074263736-git-send-email-swhiteho@redhat.com>
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
Message-Id: <db2dea335b81b73a856d2dc5bcb13201be4d56e6.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

Although the values were all being calculated correctly, there was a
race in the assert due to the way it was using atomic variables. This
changes the value we assert on so that we get the same effect by testing
a different variable. This prevents the assert triggering when it shouldn't.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 40c51bf..6e6a104 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -749,7 +749,7 @@ void __gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
 static void log_refund(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 {
 	unsigned int reserved;
-	unsigned int old;
+	unsigned int unused;
 
 	gfs2_log_lock(sdp);
 
@@ -761,14 +761,11 @@ static void log_refund(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 	sdp->sd_log_commited_revoke += tr->tr_num_revoke - tr->tr_num_revoke_rm;
 	gfs2_assert_withdraw(sdp, ((int)sdp->sd_log_commited_revoke) >= 0);
 	reserved = calc_reserved(sdp);
-	old = atomic_read(&sdp->sd_log_blks_free);
-	atomic_add(tr->tr_reserved - (reserved - sdp->sd_log_blks_reserved),
-		   &sdp->sd_log_blks_free);
-
-	gfs2_assert_withdraw(sdp, atomic_read(&sdp->sd_log_blks_free) >= old);
+	unused = sdp->sd_log_blks_reserved - reserved + tr->tr_reserved;
+	gfs2_assert_withdraw(sdp, unused >= 0);
+	atomic_add(unused, &sdp->sd_log_blks_free);
 	gfs2_assert_withdraw(sdp, atomic_read(&sdp->sd_log_blks_free) <=
 			     sdp->sd_jdesc->jd_blocks);
-
 	sdp->sd_log_blks_reserved = reserved;
 
 	gfs2_log_unlock(sdp);
-- 
1.5.1.2

