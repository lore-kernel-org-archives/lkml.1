Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577AbZBUBL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbZBUBL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 20:11:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313AbZBUBLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 20:11:48 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:53257 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589AbZBUBLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 20:11:47 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 1/2] GFS2: fix sparse warnings: constant is so big it is ...
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 21 Feb 2009 02:11:42 +0100
Message-ID: <20090221011125.5075.23703.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090221011033.5075.95929.stgit@vmbox.hanneseder.net>
References: <20090221011033.5075.95929.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warnings:
  fs/gfs2/rgrp.c:156:23: warning: constant 0xffffffffffffffff is so big it is unsigned long long
  fs/gfs2/rgrp.c:157:23: warning: constant 0xaaaaaaaaaaaaaaaa is so big it is unsigned long long
  fs/gfs2/rgrp.c:158:23: warning: constant 0x5555555555555555 is so big it is long long
  fs/gfs2/rgrp.c:194:20: warning: constant 0x5555555555555555 is so big it is long long
  fs/gfs2/rgrp.c:204:44: warning: constant 0x5555555555555555 is so big it is long long

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 fs/gfs2/rgrp.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

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

