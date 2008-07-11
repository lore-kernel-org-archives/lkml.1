Return-Path: <linux-kernel-owner+w=401wt.eu-S1758621AbYGKLEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621AbYGKLEb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753680AbYGKLBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:01:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755868AbYGKLBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:01:41 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 04/18] [GFS2] trivial sparse lock annotations
Date: Fri, 11 Jul 2008 11:11:05 +0100
Message-Id: <12157710931623-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1215771091790-git-send-email-swhiteho@redhat.com>
References: <121577107950-git-send-email-swhiteho@redhat.com>
 <12157710872782-git-send-email-swhiteho@redhat.com>
 <1215771089769-git-send-email-swhiteho@redhat.com>
 <1215771091790-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>

Annotate the &sdp->sd_log_lock.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 548264b..6c6af9f 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -87,6 +87,8 @@ void gfs2_remove_from_ail(struct gfs2_bufdata *bd)
  */
 
 static void gfs2_ail1_start_one(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
+__releases(&sdp->sd_log_lock)
+__acquires(&sdp->sd_log_lock)
 {
 	struct gfs2_bufdata *bd, *s;
 	struct buffer_head *bh;
diff --git a/fs/gfs2/log.h b/fs/gfs2/log.h
index 7711528..7c64510 100644
--- a/fs/gfs2/log.h
+++ b/fs/gfs2/log.h
@@ -21,6 +21,7 @@
  */
 
 static inline void gfs2_log_lock(struct gfs2_sbd *sdp)
+__acquires(&sdp->sd_log_lock)
 {
 	spin_lock(&sdp->sd_log_lock);
 }
@@ -32,6 +33,7 @@ static inline void gfs2_log_lock(struct gfs2_sbd *sdp)
  */
 
 static inline void gfs2_log_unlock(struct gfs2_sbd *sdp)
+__releases(&sdp->sd_log_lock)
 {
 	spin_unlock(&sdp->sd_log_lock);
 }
-- 
1.5.1.2

