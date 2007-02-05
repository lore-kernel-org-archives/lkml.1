Return-Path: <linux-kernel-owner+w=401wt.eu-S932940AbXBEO3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940AbXBEO3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:29:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932939AbXBEO3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:29:45 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932941AbXBEO3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:29:43 -0500
Subject: [GFS2] Compile fix for glock.c [37/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:37:48 +0000
Message-Id: <1170686268.11001.345.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1887e3bb2050c8ad515ff1ce2b4fec8f9b1c601b Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Tue, 23 Jan 2007 13:20:41 -0500
Subject: [PATCH] [GFS2] Compile fix for glock.c

This one liner got missed from the previous patch.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 1509481..f68582d 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1786,7 +1786,7 @@ static void clear_glock(struct gfs2_glock *gl)
 	}
 
 	if (gfs2_glmutex_trylock(gl)) {
-		if (list_empty(gl, &gl->gl_holders) &&
+		if (list_empty(&gl->gl_holders) &&
 		    gl->gl_state != LM_ST_UNLOCKED)
 			handle_callback(gl, LM_ST_UNLOCKED);
 		gfs2_glmutex_unlock(gl);
-- 
1.4.4.2



