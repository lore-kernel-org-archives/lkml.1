Return-Path: <linux-kernel-owner+w=401wt.eu-S1764540AbYDQJkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764540AbYDQJkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933548AbYDQJZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:25:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933480AbYDQJZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:25:42 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Adrian Bunk <bunk@kernel.org>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 08/48] [GFS2] make gfs2_glock_hold() static
Date: Thu, 17 Apr 2008 09:38:44 +0100
Message-Id: <12084215851158-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084215833555-git-send-email-swhiteho@redhat.com>
References: 12084214272083-git-send-email-swhiteho@redhat.com
 <12084215642582-git-send-email-swhiteho@redhat.com>
 <1208421571478-git-send-email-swhiteho@redhat.com>
 <12084215742081-git-send-email-swhiteho@redhat.com>
 <12084215763647-git-send-email-swhiteho@redhat.com>
 <12084215781246-git-send-email-swhiteho@redhat.com>
 <12084215802470-git-send-email-swhiteho@redhat.com>
 <12084215833555-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>

gfs2_glock_hold() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 5752dec..befcda0 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -197,7 +197,7 @@ static void glock_free(struct gfs2_glock *gl)
  *
  */
 
-void gfs2_glock_hold(struct gfs2_glock *gl)
+static void gfs2_glock_hold(struct gfs2_glock *gl)
 {
 	atomic_inc(&gl->gl_ref);
 }
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index 2f9c6d1..ace5770 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -79,7 +79,6 @@ static inline int gfs2_glock_is_blocking(struct gfs2_glock *gl)
 int gfs2_glock_get(struct gfs2_sbd *sdp,
 		   u64 number, const struct gfs2_glock_operations *glops,
 		   int create, struct gfs2_glock **glp);
-void gfs2_glock_hold(struct gfs2_glock *gl);
 int gfs2_glock_put(struct gfs2_glock *gl);
 void gfs2_holder_init(struct gfs2_glock *gl, unsigned int state, unsigned flags,
 		      struct gfs2_holder *gh);
-- 
1.5.1.2

