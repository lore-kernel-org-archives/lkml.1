Return-Path: <linux-kernel-owner+w=401wt.eu-S1758508AbZCRNbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508AbZCRNbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 09:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756733AbZCRN1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 09:27:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756115AbZCRN1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 09:27:11 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Hannes Eder <hannes@hanneseder.net>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 14/18] GFS2: fix sparse warnings: constant is so big it is ...
Date: Wed, 18 Mar 2009 12:23:49 +0000
Message-Id: <1237379033-28095-15-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1237379033-28095-14-git-send-email-swhiteho@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>

Fix this sparse warnings:
  fs/gfs2/rgrp.c:156:23: warning: constant 0xffffffffffffffff is so big it is unsigned long long
  fs/gfs2/rgrp.c:157:23: warning: constant 0xaaaaaaaaaaaaaaaa is so big it is unsigned long long
  fs/gfs2/rgrp.c:158:23: warning: constant 0x5555555555555555 is so big it is long long
  fs/gfs2/rgrp.c:194:20: warning: constant 0x5555555555555555 is so big it is long long
  fs/gfs2/rgrp.c:204:44: warning: constant 0x5555555555555555 is so big it is long long

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index c0abe69..34691d7 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -153,10 +153,10 @@ static inline u64 gfs2_bit_search(const __le64 *ptr, u64 mask, u8 state)
 {
 	u64 tmp;
 	static const u64 search[] = {
-		[0] = 0xffffffffffffffff,
-		[1] = 0xaaaaaaaaaaaaaaaa,
-		[2] = 0x5555555555555555,
-		[3] = 0x0000000000000000,
+		[0] = 0xffffffffffffffffULL,
+		[1] = 0xaaaaaaaaaaaaaaaaULL,
+		[2] = 0x5555555555555555ULL,
+		[3] = 0x0000000000000000ULL,
 	};
 	tmp = le64_to_cpu(*ptr) ^ search[state];
 	tmp &= (tmp >> 1);
@@ -191,7 +191,7 @@ u32 gfs2_bitfit(const u8 *buf, const unsigned int len, u32 goal, u8 state)
 	const __le64 *ptr = ((__le64 *)buf) + (goal >> 5);
 	const __le64 *end = (__le64 *)(buf + ALIGN(len, sizeof(u64)));
 	u64 tmp;
-	u64 mask = 0x5555555555555555;
+	u64 mask = 0x5555555555555555ULL;
 	u32 bit;
 
 	BUG_ON(state > 3);
@@ -201,7 +201,7 @@ u32 gfs2_bitfit(const u8 *buf, const unsigned int len, u32 goal, u8 state)
 	tmp = gfs2_bit_search(ptr, mask, state);
 	ptr++;
 	while(tmp == 0 && ptr < end) {
-		tmp = gfs2_bit_search(ptr, 0x5555555555555555, state);
+		tmp = gfs2_bit_search(ptr, 0x5555555555555555ULL, state);
 		ptr++;
 	}
 	/* Mask off any bits which are more than len bytes from the start */
-- 
1.6.0.3

