Return-Path: <linux-kernel-owner+w=401wt.eu-S964904AbZKYN2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964904AbZKYN2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:28:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964876AbZKYN2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:28:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964865AbZKYN22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:28:28 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 16/30] GFS2: Remove constant argument from qd_get()
Date: Wed, 25 Nov 2009 14:22:41 +0000
Message-Id: <1259158975-28499-17-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1259158975-28499-16-git-send-email-swhiteho@redhat.com>
References: <1259158975-28499-1-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-2-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-3-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-4-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-5-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-6-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-7-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-8-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-9-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-10-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-11-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-12-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-13-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-14-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-15-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-16-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function was only ever called with the "create"
argument set to true, so we can remove it.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/quota.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index f790f5a..db124af 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -165,7 +165,7 @@ fail:
 	return error;
 }
 
-static int qd_get(struct gfs2_sbd *sdp, int user, u32 id, int create,
+static int qd_get(struct gfs2_sbd *sdp, int user, u32 id,
 		  struct gfs2_quota_data **qdp)
 {
 	struct gfs2_quota_data *qd = NULL, *new_qd = NULL;
@@ -203,7 +203,7 @@ static int qd_get(struct gfs2_sbd *sdp, int user, u32 id, int create,
 
 		spin_unlock(&qd_lru_lock);
 
-		if (qd || !create) {
+		if (qd) {
 			if (new_qd) {
 				gfs2_glock_put(new_qd->qd_gl);
 				kmem_cache_free(gfs2_quotad_cachep, new_qd);
@@ -467,7 +467,7 @@ static int qdsb_get(struct gfs2_sbd *sdp, int user, u32 id,
 {
 	int error;
 
-	error = qd_get(sdp, user, id, CREATE, qdp);
+	error = qd_get(sdp, user, id, qdp);
 	if (error)
 		return error;
 
@@ -1117,7 +1117,7 @@ int gfs2_quota_refresh(struct gfs2_sbd *sdp, int user, u32 id)
 	struct gfs2_holder q_gh;
 	int error;
 
-	error = qd_get(sdp, user, id, CREATE, &qd);
+	error = qd_get(sdp, user, id, &qd);
 	if (error)
 		return error;
 
-- 
1.6.2.5

