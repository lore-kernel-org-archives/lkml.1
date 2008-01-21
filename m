Return-Path: <linux-kernel-owner+w=401wt.eu-S1764750AbYAUKSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764750AbYAUKSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760114AbYAUKDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:03:07 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759331AbYAUKDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:03:03 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 43/58] [GFS2] Eliminate the no longer needed sd_statfs_mutex
Date: Mon, 21 Jan 2008 09:22:01 +0000
Message-Id: <12009074163163-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009074142128-git-send-email-swhiteho@redhat.com>
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
Message-Id: <74bfe16e314ed23a9633debae6a1db7c19202208.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch eliminates the unneeded sd_statfs_mutex mutex but preserves
the ordering as discussed.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 14862d1..9a83429 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -527,7 +527,6 @@ struct gfs2_sbd {
 	/* StatFS stuff */
 
 	spinlock_t sd_statfs_spin;
-	struct mutex sd_statfs_mutex;
 	struct gfs2_statfs_change_host sd_statfs_master;
 	struct gfs2_statfs_change_host sd_statfs_local;
 	unsigned long sd_statfs_sync_time;
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 35ec630..22e260e 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -60,7 +60,6 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 
 	mutex_init(&sdp->sd_inum_mutex);
 	spin_lock_init(&sdp->sd_statfs_spin);
-	mutex_init(&sdp->sd_statfs_mutex);
 
 	spin_lock_init(&sdp->sd_rindex_spin);
 	mutex_init(&sdp->sd_rindex_mutex);
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index dda7747..73e49df 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -686,9 +686,7 @@ void gfs2_statfs_change(struct gfs2_sbd *sdp, s64 total, s64 free,
 	if (error)
 		return;
 
-	mutex_lock(&sdp->sd_statfs_mutex);
 	gfs2_trans_add_bh(l_ip->i_gl, l_bh, 1);
-	mutex_unlock(&sdp->sd_statfs_mutex);
 
 	spin_lock(&sdp->sd_statfs_spin);
 	l_sc->sc_total += total;
@@ -736,9 +734,7 @@ int gfs2_statfs_sync(struct gfs2_sbd *sdp)
 	if (error)
 		goto out_bh2;
 
-	mutex_lock(&sdp->sd_statfs_mutex);
 	gfs2_trans_add_bh(l_ip->i_gl, l_bh, 1);
-	mutex_unlock(&sdp->sd_statfs_mutex);
 
 	spin_lock(&sdp->sd_statfs_spin);
 	m_sc->sc_total += l_sc->sc_total;
-- 
1.5.1.2

