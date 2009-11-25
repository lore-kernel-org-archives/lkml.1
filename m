Return-Path: <linux-kernel-owner+w=401wt.eu-S964874AbZKYN2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964874AbZKYN2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964863AbZKYN22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:28:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934670AbZKYN20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:28:26 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 14/30] GFS2: Add proper error reporting to quota sync via sysfs
Date: Wed, 25 Nov 2009 14:22:39 +0000
Message-Id: <1259158975-28499-15-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1259158975-28499-14-git-send-email-swhiteho@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some reason, the errors were not making it to userspace.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/sys.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index be1b8ac..c5dad1e 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -178,6 +178,7 @@ static ssize_t quota_sync_store(struct gfs2_sbd *sdp, const char *buf,
 static ssize_t quota_refresh_user_store(struct gfs2_sbd *sdp, const char *buf,
 					size_t len)
 {
+	int error;
 	u32 id;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -185,13 +186,14 @@ static ssize_t quota_refresh_user_store(struct gfs2_sbd *sdp, const char *buf,
 
 	id = simple_strtoul(buf, NULL, 0);
 
-	gfs2_quota_refresh(sdp, 1, id);
-	return len;
+	error = gfs2_quota_refresh(sdp, 1, id);
+	return error ? error : len;
 }
 
 static ssize_t quota_refresh_group_store(struct gfs2_sbd *sdp, const char *buf,
 					 size_t len)
 {
+	int error;
 	u32 id;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -199,8 +201,8 @@ static ssize_t quota_refresh_group_store(struct gfs2_sbd *sdp, const char *buf,
 
 	id = simple_strtoul(buf, NULL, 0);
 
-	gfs2_quota_refresh(sdp, 0, id);
-	return len;
+	error = gfs2_quota_refresh(sdp, 0, id);
+	return error ? error : len;
 }
 
 static ssize_t demote_rq_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
-- 
1.6.2.5

