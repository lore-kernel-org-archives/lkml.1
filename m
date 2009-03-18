Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbZCRNb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbZCRNb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 09:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756278AbZCRN2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 09:28:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757773AbZCRN2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 09:28:21 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Hannes Eder <hannes@hanneseder.net>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 15/18] GFS2: fix sparse warning: Should it be static?
Date: Wed, 18 Mar 2009 12:23:50 +0000
Message-Id: <1237379033-28095-16-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1237379033-28095-15-git-send-email-swhiteho@redhat.com>
References: <1237379033-28095-1-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-2-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-3-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-4-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-5-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-6-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-7-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-8-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-9-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-10-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-11-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-12-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-13-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-14-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-15-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>

Impact: Make symbol static.

Fix this sparse warning:
  fs/gfs2/rgrp.c:188:5: warning: symbol 'gfs2_bitfit' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 34691d7..f03d024 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -185,7 +185,8 @@ static inline u64 gfs2_bit_search(const __le64 *ptr, u64 mask, u8 state)
  * Return: the block number (bitmap buffer scope) that was found
  */
 
-u32 gfs2_bitfit(const u8 *buf, const unsigned int len, u32 goal, u8 state)
+static u32 gfs2_bitfit(const u8 *buf, const unsigned int len,
+		       u32 goal, u8 state)
 {
 	u32 spoint = (goal << 1) & ((8*sizeof(u64)) - 1);
 	const __le64 *ptr = ((__le64 *)buf) + (goal >> 5);
-- 
1.6.0.3

