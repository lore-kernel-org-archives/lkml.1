Return-Path: <linux-kernel-owner+w=401wt.eu-S1755318AbYBQR6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbYBQR6U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 12:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbYBQR6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 12:58:06 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:59043 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbYBQR6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 12:58:04 -0500
Date: Sun, 17 Feb 2008 18:57:58 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net,
       v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 7/7] net/9p/trans_virtio.c: Use BUG_ON
Message-ID: <Pine.LNX.4.64.0802171857310.28055@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

if (...) BUG(); should be replaced with BUG_ON(...) when the test has no
side-effects to allow a definition of BUG_ON that drops the code completely.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@ disable unlikely @ expression E,f; @@

(
  if (<... f(...) ...>) { BUG(); }
|
- if (unlikely(E)) { BUG(); }
+ BUG_ON(E);
)

@@ expression E,f; @@

(
  if (<... f(...) ...>) { BUG(); }
|
- if (E) { BUG(); }
+ BUG_ON(E);
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

diff -u -p a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
--- a/net/9p/trans_virtio.c 2008-02-10 22:34:18.000000000 +0100
+++ b/net/9p/trans_virtio.c 2008-02-17 16:43:18.000000000 +0100
@@ -183,8 +183,7 @@ pack_sg_list(struct scatterlist *sg, int
 		sg_set_buf(&sg[index++], data, s);
 		count -= s;
 		data += s;
-		if (index > limit)
-			BUG();
+		BUG_ON(index > limit);
 	}
 
 	return index-start;
