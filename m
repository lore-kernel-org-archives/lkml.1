Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbZDWKXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbZDWKXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 06:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756206AbZDWKWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 06:22:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44434 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513AbZDWKWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 06:22:08 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/3] GFS2: Fix bug in block allocation
Date: Thu, 23 Apr 2009 10:16:55 +0100
Message-Id: <1240478216-2594-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1240478216-2594-2-git-send-email-swhiteho@redhat.com>
References: <1240478216-2594-1-git-send-email-swhiteho@redhat.com>
 <1240478216-2594-2-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new bitfit algorithm was counting from the wrong end of
64 bit words in the bitfield. This fixes it by using __ffs64
instead of fls64

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index f03d024..c9786a4 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -212,8 +212,7 @@ static u32 gfs2_bitfit(const u8 *buf, const unsigned int len,
 	if (tmp == 0)
 		return BFITNOENT;
 	ptr--;
-	bit = fls64(tmp);
-	bit--;		/* fls64 always adds one to the bit count */
+	bit = __ffs64(tmp);
 	bit /= 2;	/* two bits per entry in the bitmap */
 	return (((const unsigned char *)ptr - buf) * GFS2_NBBY) + bit;
 }
-- 
1.6.0.6

