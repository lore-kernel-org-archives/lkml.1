Return-Path: <linux-kernel-owner+w=401wt.eu-S964884AbZKYN3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964884AbZKYN3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:29:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964867AbZKYN23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:28:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964864AbZKYN22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:28:28 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 15/30] GFS2: Remove constant argument from qdsb_get()
Date: Wed, 25 Nov 2009 14:22:40 +0000
Message-Id: <1259158975-28499-16-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1259158975-28499-15-git-send-email-swhiteho@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "create" argument to qdsb_get() was only ever set to true,
so this patch removes that argument.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/quota.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index e7114be..f790f5a 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -462,12 +462,12 @@ static void qd_unlock(struct gfs2_quota_data *qd)
 	qd_put(qd);
 }
 
-static int qdsb_get(struct gfs2_sbd *sdp, int user, u32 id, int create,
+static int qdsb_get(struct gfs2_sbd *sdp, int user, u32 id,
 		    struct gfs2_quota_data **qdp)
 {
 	int error;
 
-	error = qd_get(sdp, user, id, create, qdp);
+	error = qd_get(sdp, user, id, CREATE, qdp);
 	if (error)
 		return error;
 
@@ -509,20 +509,20 @@ int gfs2_quota_hold(struct gfs2_inode *ip, u32 uid, u32 gid)
 	if (sdp->sd_args.ar_quota == GFS2_QUOTA_OFF)
 		return 0;
 
-	error = qdsb_get(sdp, QUOTA_USER, ip->i_inode.i_uid, CREATE, qd);
+	error = qdsb_get(sdp, QUOTA_USER, ip->i_inode.i_uid, qd);
 	if (error)
 		goto out;
 	al->al_qd_num++;
 	qd++;
 
-	error = qdsb_get(sdp, QUOTA_GROUP, ip->i_inode.i_gid, CREATE, qd);
+	error = qdsb_get(sdp, QUOTA_GROUP, ip->i_inode.i_gid, qd);
 	if (error)
 		goto out;
 	al->al_qd_num++;
 	qd++;
 
 	if (uid != NO_QUOTA_CHANGE && uid != ip->i_inode.i_uid) {
-		error = qdsb_get(sdp, QUOTA_USER, uid, CREATE, qd);
+		error = qdsb_get(sdp, QUOTA_USER, uid, qd);
 		if (error)
 			goto out;
 		al->al_qd_num++;
@@ -530,7 +530,7 @@ int gfs2_quota_hold(struct gfs2_inode *ip, u32 uid, u32 gid)
 	}
 
 	if (gid != NO_QUOTA_CHANGE && gid != ip->i_inode.i_gid) {
-		error = qdsb_get(sdp, QUOTA_GROUP, gid, CREATE, qd);
+		error = qdsb_get(sdp, QUOTA_GROUP, gid, qd);
 		if (error)
 			goto out;
 		al->al_qd_num++;
-- 
1.6.2.5

