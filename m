Return-Path: <linux-kernel-owner+w=401wt.eu-S1761538AbXGIQmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761538AbXGIQmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758219AbXGIQZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:25:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758596AbXGIQY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:24:57 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>,
       Bob Peterson <rpeterso@redhat.com>
Subject: [PATCH] [GFS2] Small fixes to logging code
Date: Mon,  9 Jul 2007 17:03:02 +0100
Message-Id: <11839971003188-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11839970981366-git-send-email-swhiteho@redhat.com>
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
 <11839970914023-git-send-email-swhiteho@redhat.com>
 <11839970921764-git-send-email-swhiteho@redhat.com>
 <11839970941232-git-send-email-swhiteho@redhat.com>
 <11839970963525-git-send-email-swhiteho@redhat.com>
 <11839970981366-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This reverts part of an earlier patch which tried to reclaim
gfs2_bufdata structures too early and resulted in a "use after free"
case (this bit from me). Also a change to not write out log headers
unless we really need to (in the case of flushing nothing we don't need
a header) from Bob.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Bob Peterson <rpeterso@redhat.com>

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 8fcfb78..f49a12e 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -237,10 +237,7 @@ static void gfs2_ail2_empty_one(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
 		list_del(&bd->bd_ail_st_list);
 		list_del(&bd->bd_ail_gl_list);
 		atomic_dec(&bd->bd_gl->gl_ail_count);
-		if (bd->bd_bh)
-			brelse(bd->bd_bh);
-		else
-			kmem_cache_free(gfs2_bufdata_cachep, bd);
+		brelse(bd->bd_bh);
 	}
 }
 
@@ -583,6 +580,7 @@ static void log_flush_commit(struct gfs2_sbd *sdp)
 	struct list_head *head = &sdp->sd_log_flush_list;
 	struct gfs2_log_buf *lb;
 	struct buffer_head *bh;
+	int flushcount = 0;
 
 	while (!list_empty(head)) {
 		lb = list_entry(head->next, struct gfs2_log_buf, lb_list);
@@ -599,9 +597,20 @@ static void log_flush_commit(struct gfs2_sbd *sdp)
 		} else
 			brelse(bh);
 		kfree(lb);
+		flushcount++;
 	}
 
-	log_write_header(sdp, 0, 0);
+	/* If nothing was journaled, the header is unplanned and unwanted. */
+	if (flushcount) {
+		log_write_header(sdp, 0, 0);
+	} else {
+		unsigned int tail;
+		tail = current_tail(sdp);
+
+		gfs2_ail1_empty(sdp, 0);
+		if (sdp->sd_log_tail != tail)
+			log_pull_tail(sdp, tail);
+	}
 }
 
 /**
-- 
1.5.1.2

