Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340AbZGMKKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbZGMKKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 06:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755301AbZGMKKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 06:10:10 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:41802 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279AbZGMKKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 06:10:09 -0400
Date: Mon, 13 Jul 2009 12:10:05 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: felixb@sgi.com, xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2] fs/xfs: Drop unnecessary NULL test
Message-ID: <Pine.LNX.4.64.0907131209250.6808@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The result of container_of should not be NULL.  In particular, in this case
the argument to the enclosing function has passed though INIT_DELAYED_WORK,
which dereferences it, implying that its container cannot be NULL.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression x,e;
@@
x = container_of(...)
... when != x = e
* x == NULL
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/xfs/xfs_mru_cache.c              |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
index 4b0613d..0651ce7 100644
--- a/fs/xfs/xfs_mru_cache.c
+++ b/fs/xfs/xfs_mru_cache.c
@@ -280,8 +280,8 @@ _xfs_mru_cache_reap(
 	xfs_mru_cache_t		*mru = container_of(work, xfs_mru_cache_t, work.work);
 	unsigned long		now, next;
 
-	ASSERT(mru && mru->lists);
-	if (!mru || !mru->lists)
+	ASSERT(mru->lists);
+	if (!mru->lists)
 		return;
 
 	spin_lock(&mru->lock);
