Return-Path: <linux-kernel-owner+w=401wt.eu-S1757313AbYE3B2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbYE3B2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 21:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbYE3B1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 21:27:54 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:27604 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbYE3B1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 21:27:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=uuMUwQ1f7ifgMq46gL5TCPNxK8DCDHNN6oBEvpAh+yfUa+ZizsWfpsi7smACL3aD7VE/vTXRwOdWwWIr8LGcFZQs3s6Xt2qmlENytay9B/gNbRi5c/rTsx2HqPhkJmu1eMAoA7epb0yWemoFBFX5wzeDmvzYxH3GGZz8+tYnrvE=
Subject: [PATCH] gfs2: trivial sparse lock annotations
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 29 May 2008 18:27:51 -0700
Message-Id: <1212110871.28403.167.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Annotate the &sdp->sd_log_lock.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/gfs2/log.c |    2 ++
 fs/gfs2/log.h |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

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
1.5.6.rc0.277.g804cf



