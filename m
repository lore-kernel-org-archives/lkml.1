Return-Path: <linux-kernel-owner+w=401wt.eu-S933773AbYDQPZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933773AbYDQPZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 11:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760706AbYDQPZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 11:25:42 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:36431 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933506AbYDQPZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 11:25:39 -0400
Message-ID: <48076BF1.9080204@tiscali.nl>
Date: Thu, 17 Apr 2008 17:25:37 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: swhiteho@redhat.com
CC: cluster-devel@redhat.com, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] gfs2: fix assertion in log_refund()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

since unsigned, unused >= 0 is always true.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 161ab6f..211dc2d 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -769,8 +769,8 @@ static void log_refund(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 	sdp->sd_log_commited_revoke += tr->tr_num_revoke - tr->tr_num_revoke_rm;
 	gfs2_assert_withdraw(sdp, ((int)sdp->sd_log_commited_revoke) >= 0);
 	reserved = calc_reserved(sdp);
+	gfs2_assert_withdraw(sdp, sdp->sd_log_blks_reserved + tr->tr_reserved >= reserved);
 	unused = sdp->sd_log_blks_reserved - reserved + tr->tr_reserved;
-	gfs2_assert_withdraw(sdp, unused >= 0);
 	atomic_add(unused, &sdp->sd_log_blks_free);
 	gfs2_assert_withdraw(sdp, atomic_read(&sdp->sd_log_blks_free) <=
 			     sdp->sd_jdesc->jd_blocks);
