Return-Path: <linux-kernel-owner+w=401wt.eu-S1763307AbYA1WQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763307AbYA1WQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761291AbYA1WLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:11:09 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:48006 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760246AbYA1WLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:11:08 -0500
Date: Tue, 29 Jan 2008 00:11:34 +0200
From: Adrian Bunk <bunk@kernel.org>
To: swhiteho@redhat.com
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make gfs2_glock_hold() static
Message-ID: <20080128221134.GZ8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gfs2_glock_hold() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/gfs2/glock.c |    2 +-
 fs/gfs2/glock.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

f04fbd054a051a564a3138e0e02b7423acf45a06 
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 80e09c5..e18f251 100644
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
index b16f604..0724076 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -77,7 +77,6 @@ static inline int gfs2_glock_is_blocking(struct gfs2_glock *gl)
 int gfs2_glock_get(struct gfs2_sbd *sdp,
 		   u64 number, const struct gfs2_glock_operations *glops,
 		   int create, struct gfs2_glock **glp);
-void gfs2_glock_hold(struct gfs2_glock *gl);
 int gfs2_glock_put(struct gfs2_glock *gl);
 void gfs2_holder_init(struct gfs2_glock *gl, unsigned int state, unsigned flags,
 		      struct gfs2_holder *gh);

