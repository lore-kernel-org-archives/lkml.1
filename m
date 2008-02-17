Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724AbYBQR4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbYBQR4g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 12:56:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYBQR4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 12:56:24 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:58977 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbYBQR4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 12:56:22 -0500
Date: Sun, 17 Feb 2008 18:56:18 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: bfennema@falcon.csc.calpoly.edu, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 4/7] fs/udf/truncate.c: Use BUG_ON
Message-ID: <Pine.LNX.4.64.0802171855510.28055@ask.diku.dk>
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

diff -u -p a/fs/udf/truncate.c b/fs/udf/truncate.c
--- a/fs/udf/truncate.c 2008-02-10 22:34:15.000000000 +0100
+++ b/fs/udf/truncate.c 2008-02-17 16:41:19.000000000 +0100
@@ -224,8 +224,7 @@ void udf_truncate_extents(struct inode *
 				if (indirect_ext_len) {
 					/* We managed to free all extents in the
 					 * indirect extent - free it too */
-					if (!epos.bh)
-						BUG();
+					BUG_ON(!epos.bh);
 					udf_free_blocks(sb, inode, epos.block,
 							0, indirect_ext_len);
 				} else {
@@ -272,8 +271,7 @@ void udf_truncate_extents(struct inode *
 		}
 
 		if (indirect_ext_len) {
-			if (!epos.bh)
-				BUG();
+			BUG_ON(!epos.bh);
 			udf_free_blocks(sb, inode, epos.block, 0,
 					indirect_ext_len);
 		} else {
