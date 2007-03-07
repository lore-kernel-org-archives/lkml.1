Return-Path: <linux-kernel-owner+w=401wt.eu-S1030501AbXCGO3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030501AbXCGO3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 09:29:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030475AbXCGO3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 09:29:50 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030528AbXCGO3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 09:29:48 -0500
Subject: [GFS2] go_drop_bh is never used, so remove it [10/12]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1173277501.11001.752.camel@quoit.chygwyn.com>
References: <1173277501.11001.752.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Wed, 07 Mar 2007 14:32:54 +0000
Message-Id: <1173277974.11001.772.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 631c42e170564108423fa4073531db159f2523ea Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Thu, 1 Mar 2007 10:36:32 +0000
Subject: [PATCH] [GFS2] go_drop_bh is never used, so remove it

The ->go_drop_bh function is never used, so this removes it and the single
caller,

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 6618c11..8597fde 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -953,9 +953,6 @@ static void drop_bh(struct gfs2_glock *gl, unsigned int ret)
 		spin_unlock(&gl->gl_spin);
 	}
 
-	if (glops->go_drop_bh)
-		glops->go_drop_bh(gl);
-
 	spin_lock(&gl->gl_spin);
 	gl->gl_req_gh = NULL;
 	gl->gl_req_bh = NULL;
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 0b2b545..49f0dbf 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -104,7 +104,6 @@ struct gfs2_glock_operations {
 	void (*go_xmote_th) (struct gfs2_glock *gl);
 	void (*go_xmote_bh) (struct gfs2_glock *gl);
 	void (*go_drop_th) (struct gfs2_glock *gl);
-	void (*go_drop_bh) (struct gfs2_glock *gl);
 	void (*go_inval) (struct gfs2_glock *gl, int flags);
 	int (*go_demote_ok) (struct gfs2_glock *gl);
 	int (*go_lock) (struct gfs2_holder *gh);
-- 
1.4.4.2



