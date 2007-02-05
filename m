Return-Path: <linux-kernel-owner+w=401wt.eu-S932858AbXBEO0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858AbXBEO0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:26:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932860AbXBEO0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:26:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932868AbXBEO0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:26:07 -0500
Subject: [GFS2] Remove unused go_callback operation [31/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:34:09 +0000
Message-Id: <1170686049.11001.333.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From bb11b4f7b47bf5f2e293895926bd889cc188bf2e Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Fri, 19 Jan 2007 13:57:36 -0500
Subject: [PATCH] [GFS2] Remove unused go_callback operation

This is never used, so we might as well remove it.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 90847e0..8e4b55a 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1568,8 +1568,6 @@ static void blocking_cb(struct gfs2_sbd *sdp, struct lm_lockname *name,
 	if (!gl)
 		return;
 
-	if (gl->gl_ops->go_callback)
-		gl->gl_ops->go_callback(gl, state);
 	handle_callback(gl, state);
 
 	spin_lock(&gl->gl_spin);
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index dc024b1..1acbcc2 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -110,7 +110,6 @@ struct gfs2_glock_operations {
 	int (*go_demote_ok) (struct gfs2_glock *gl);
 	int (*go_lock) (struct gfs2_holder *gh);
 	void (*go_unlock) (struct gfs2_holder *gh);
-	void (*go_callback) (struct gfs2_glock *gl, unsigned int state);
 	const int go_type;
 };
 
-- 
1.4.4.2



