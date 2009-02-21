Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbZBUBM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbZBUBM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 20:12:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756258AbZBUBML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 20:12:11 -0500
Received: from mu-out-0910.google.com ([209.85.134.185]:6473 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256AbZBUBMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 20:12:10 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 2/2] GFS2: fix sparse warning: Should it be static?
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 21 Feb 2009 02:12:05 +0100
Message-ID: <20090221011157.5075.6318.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090221011033.5075.95929.stgit@vmbox.hanneseder.net>
References: <20090221011033.5075.95929.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Make symbol static.

Fix this sparse warning:
  fs/gfs2/rgrp.c:188:5: warning: symbol 'gfs2_bitfit' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 fs/gfs2/rgrp.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

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

