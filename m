Return-Path: <linux-kernel-owner+w=401wt.eu-S1757884AbZCRN23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884AbZCRN23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 09:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756145AbZCRN0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 09:26:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756094AbZCRN0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 09:26:44 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 06/18] GFS2: Remove unused field from glock
Date: Wed, 18 Mar 2009 12:23:41 +0000
Message-Id: <1237379033-28095-7-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1237379033-28095-6-git-send-email-swhiteho@redhat.com>
References: <1237379033-28095-1-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-2-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-3-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-4-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-5-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-6-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

The time stamp field is unused in the glock now that we are
using a shrinker, so that we can remove it and save sizeof(unsigned long)
bytes in each glock.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index cd200a5..173e59c 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -700,7 +700,6 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 	snprintf(gl->gl_strname, GDLM_STRNAME_BYTES, "%8x%16llx", name.ln_type, (unsigned long long)number);
 	memset(&gl->gl_lksb, 0, sizeof(struct dlm_lksb));
 	gl->gl_lksb.sb_lvbptr = gl->gl_lvb;
-	gl->gl_stamp = jiffies;
 	gl->gl_tchange = jiffies;
 	gl->gl_object = NULL;
 	gl->gl_sbd = sdp;
@@ -1008,7 +1007,6 @@ void gfs2_glock_dq(struct gfs2_holder *gh)
 			spin_lock(&gl->gl_spin);
 			clear_bit(GLF_LOCK, &gl->gl_flags);
 		}
-		gl->gl_stamp = jiffies;
 		if (list_empty(&gl->gl_holders) &&
 		    !test_bit(GLF_PENDING_DEMOTE, &gl->gl_flags) &&
 		    !test_bit(GLF_DEMOTE, &gl->gl_flags))
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 0af7c24..8fe0675 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -211,7 +211,6 @@ struct gfs2_glock {
 	char gl_strname[GDLM_STRNAME_BYTES];
 	struct dlm_lksb gl_lksb;
 	char gl_lvb[32];
-	unsigned long gl_stamp;
 	unsigned long gl_tchange;
 	void *gl_object;
 
-- 
1.6.0.3

