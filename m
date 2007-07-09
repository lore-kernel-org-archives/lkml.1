Return-Path: <linux-kernel-owner+w=401wt.eu-S1761280AbXGIQlD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761280AbXGIQlD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:41:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758572AbXGIQYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:24:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758120AbXGIQYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:24:47 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Abhijith Das <adas@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [GFS2] System won't suspend with GFS2 file system mounted
Date: Mon,  9 Jul 2007 17:02:57 +0100
Message-Id: <11839970914023-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1183997089710-git-send-email-swhiteho@redhat.com>
References: <11839969822277-git-send-email-swhiteho@redhat.com>
 <1183996989263-git-send-email-swhiteho@redhat.com>
 <11839969911617-git-send-email-swhiteho@redhat.com>
 <1183996996300-git-send-email-swhiteho@redhat.com>
 <11839969982134-git-send-email-swhiteho@redhat.com>
 <11839970003764-git-send-email-swhiteho@redhat.com>
 <11839970032102-git-send-email-swhiteho@redhat.com>
 <11839970052865-git-send-email-swhiteho@redhat.com>
 <11839970061096-git-send-email-swhiteho@redhat.com>
 <1183997008395-git-send-email-swhiteho@redhat.com>
 <11839970101065-git-send-email-swhiteho@redhat.com>
 <11839970122624-git-send-email-swhiteho@redhat.com>
 <11839970143164-git-send-email-swhiteho@redhat.com>
 <11839970162125-git-send-email-swhiteho@redhat.com>
 <11839970182635-git-send-email-swhiteho@redhat.com>
 <11839970204036-git-send-email-swhiteho@redhat.com>
 <11839970222606-git-send-email-swhiteho@redhat.com>
 <11839970241526-git-send-email-swhiteho@redhat.com>
 <1183997026104-git-send-email-swhiteho@redhat.com>
 <11839970282009-git-send-email-swhiteho@redhat.com>
 <11839970302426-git-send-email-swhiteho@redhat.com>
 <11839970324005-git-send-email-swhiteho@redhat.com>
 <1183997034982-git-send-email-swhiteho@redhat.com>
 <1183997036270-git-send-email-swhiteho@redhat.com>
 <11839970383020-git-send-email-swhiteho@redhat.com>
 <11839970403929-git-send-email-swhiteho@redhat.com>
 <11839970421091-git-send-email-swhiteho@redhat.com>
 <11839970442448-git-send-email-swhiteho@redhat.com>
 <11839970463325-git-send-email-swhiteho@redhat.com>
 <11839970481383-git-send-email-swhiteho@redhat.com>
 <1183997050365-git-send-email-swhiteho@redhat.com>
 <11839970521835-git-send-email-swhiteho@redhat.com>
 <11839970542719-git-send-email-swhiteho@redhat.com>
 <1183997056121-git-send-email-swhiteho@redhat.com>
 <11839970573954-git-send-email-swhiteho@redhat.com>
 <11839970591207-git-send-email-swhiteho@redhat.com>
 <11839970611456-git-send-email-swhiteho@redhat.com>
 <11839970633982-git-send-email-swhiteho@redhat.com>
 <11839970653759-git-send-email-swhiteho@redhat.com>
 <1183997067333-git-send-email-swhiteho@redhat.com>
 <11839970691406-git-send-email-swhiteho@redhat.com>
 <11839970711372-git-send-email-swhiteho@redhat.com>
 <1183997073435-git-send-email-swhiteho@redhat.com>
 <11839970752058-git-send-email-swhiteho@redhat.com>
 <11839970773694-git-send-email-swhiteho@redhat.com>
 <11839970793713-git-send-email-swhiteho@redhat.com>
 <11839970813260-git-send-email-swhiteho@redhat.com>
 <11839970832750-git-send-email-swhiteho@redhat.com>
 <11839970852076-git-send-email-swhiteho@redhat.com>
 <11839970871671-git-send-email-swhiteho@redhat.com>
 <1183997089710-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijith Das <adas@redhat.com>

The kernel threads in gfs2, namely gfs2_scand, gfs2_logd, gfs2_quotad,
gfs2_glockd, gfs2_recoverd weren't doing anything when the suspend
mechanism was trying to freeze them.

I put in calls to refrigerator() in the loops for all the daemons and
suspend works as expected.

Signed-off-by: Abhijith Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/daemon.c b/fs/gfs2/daemon.c
index 683cb5b..3548d9f 100644
--- a/fs/gfs2/daemon.c
+++ b/fs/gfs2/daemon.c
@@ -16,6 +16,7 @@
 #include <linux/delay.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/lm_interface.h>
+#include <linux/freezer.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -49,6 +50,8 @@ int gfs2_scand(void *data)
 	while (!kthread_should_stop()) {
 		gfs2_scand_internal(sdp);
 		t = gfs2_tune_get(sdp, gt_scand_secs) * HZ;
+		if (freezing(current))
+			refrigerator();
 		schedule_timeout_interruptible(t);
 	}
 
@@ -74,6 +77,8 @@ int gfs2_glockd(void *data)
 		wait_event_interruptible(sdp->sd_reclaim_wq,
 					 (atomic_read(&sdp->sd_reclaim_count) ||
 					 kthread_should_stop()));
+		if (freezing(current))
+			refrigerator();
 	}
 
 	return 0;
@@ -93,6 +98,8 @@ int gfs2_recoverd(void *data)
 	while (!kthread_should_stop()) {
 		gfs2_check_journals(sdp);
 		t = gfs2_tune_get(sdp,  gt_recoverd_secs) * HZ;
+		if (freezing(current))
+			refrigerator();
 		schedule_timeout_interruptible(t);
 	}
 
@@ -141,6 +148,8 @@ int gfs2_logd(void *data)
 		}
 
 		t = gfs2_tune_get(sdp, gt_logd_secs) * HZ;
+		if (freezing(current))
+			refrigerator();
 		schedule_timeout_interruptible(t);
 	}
 
@@ -191,6 +200,8 @@ int gfs2_quotad(void *data)
 		gfs2_quota_scan(sdp);
 
 		t = gfs2_tune_get(sdp, gt_quotad_secs) * HZ;
+		if (freezing(current))
+			refrigerator();
 		schedule_timeout_interruptible(t);
 	}
 
-- 
1.5.1.2

