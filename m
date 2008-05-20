Return-Path: <linux-kernel-owner+w=401wt.eu-S1765961AbYETKB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765961AbYETKB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 06:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763772AbYETKAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 06:00:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764917AbYETKAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 06:00:21 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Jean Delvare <khali@linux-fr.org>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3/3] [GFS2] Prefer strlcpy() over snprintf()
Date: Tue, 20 May 2008 10:12:44 +0100
Message-Id: <12112747762255-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12112747742961-git-send-email-swhiteho@redhat.com>
References: <1211274764371-git-send-email-swhiteho@redhat.com>
 <12112747723560-git-send-email-swhiteho@redhat.com>
 <12112747742961-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Delvare <khali@linux-fr.org>

strlcpy is faster than snprintf when you don't use the returned value.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index ef9c6c4..b2028c8 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -142,8 +142,8 @@ static int init_names(struct gfs2_sbd *sdp, int silent)
 	if (!table[0])
 		table = sdp->sd_vfs->s_id;
 
-	snprintf(sdp->sd_proto_name, GFS2_FSNAME_LEN, "%s", proto);
-	snprintf(sdp->sd_table_name, GFS2_FSNAME_LEN, "%s", table);
+	strlcpy(sdp->sd_proto_name, proto, GFS2_FSNAME_LEN);
+	strlcpy(sdp->sd_table_name, table, GFS2_FSNAME_LEN);
 
 	table = sdp->sd_table_name;
 	while ((table = strchr(table, '/')))
-- 
1.5.1.2

