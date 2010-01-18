Return-Path: <linux-kernel-owner+w=401wt.eu-S1751293Ab0ARF0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293Ab0ARF0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 00:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911Ab0ARF0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 00:26:48 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40825 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab0ARF0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 00:26:48 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: [cleanup][PATCH] Fix indentation of the comments of do_migrate_pages
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20100118142507.AE4D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 18 Jan 2010 14:26:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently, do_migrate_pages() have very long comment and this is
not indent properly. I often misunderstand it is function starting
commnents and confused it.

this patch fixes it.

note: this patch doesn't break 80 column rule. I guess original
      author intended this indentaion, but an accident corrupted it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/mempolicy.c |   60 ++++++++++++++++++++++++++++----------------------------
 1 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 9751f3f..e5bb7fb 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -887,36 +887,36 @@ int do_migrate_pages(struct mm_struct *mm,
 	if (err)
 		goto out;
 
-/*
- * Find a 'source' bit set in 'tmp' whose corresponding 'dest'
- * bit in 'to' is not also set in 'tmp'.  Clear the found 'source'
- * bit in 'tmp', and return that <source, dest> pair for migration.
- * The pair of nodemasks 'to' and 'from' define the map.
- *
- * If no pair of bits is found that way, fallback to picking some
- * pair of 'source' and 'dest' bits that are not the same.  If the
- * 'source' and 'dest' bits are the same, this represents a node
- * that will be migrating to itself, so no pages need move.
- *
- * If no bits are left in 'tmp', or if all remaining bits left
- * in 'tmp' correspond to the same bit in 'to', return false
- * (nothing left to migrate).
- *
- * This lets us pick a pair of nodes to migrate between, such that
- * if possible the dest node is not already occupied by some other
- * source node, minimizing the risk of overloading the memory on a
- * node that would happen if we migrated incoming memory to a node
- * before migrating outgoing memory source that same node.
- *
- * A single scan of tmp is sufficient.  As we go, we remember the
- * most recent <s, d> pair that moved (s != d).  If we find a pair
- * that not only moved, but what's better, moved to an empty slot
- * (d is not set in tmp), then we break out then, with that pair.
- * Otherwise when we finish scannng from_tmp, we at least have the
- * most recent <s, d> pair that moved.  If we get all the way through
- * the scan of tmp without finding any node that moved, much less
- * moved to an empty node, then there is nothing left worth migrating.
- */
+	/*
+	 * Find a 'source' bit set in 'tmp' whose corresponding 'dest'
+	 * bit in 'to' is not also set in 'tmp'.  Clear the found 'source'
+	 * bit in 'tmp', and return that <source, dest> pair for migration.
+	 * The pair of nodemasks 'to' and 'from' define the map.
+	 *
+	 * If no pair of bits is found that way, fallback to picking some
+	 * pair of 'source' and 'dest' bits that are not the same.  If the
+	 * 'source' and 'dest' bits are the same, this represents a node
+	 * that will be migrating to itself, so no pages need move.
+	 *
+	 * If no bits are left in 'tmp', or if all remaining bits left
+	 * in 'tmp' correspond to the same bit in 'to', return false
+	 * (nothing left to migrate).
+	 *
+	 * This lets us pick a pair of nodes to migrate between, such that
+	 * if possible the dest node is not already occupied by some other
+	 * source node, minimizing the risk of overloading the memory on a
+	 * node that would happen if we migrated incoming memory to a node
+	 * before migrating outgoing memory source that same node.
+	 *
+	 * A single scan of tmp is sufficient.  As we go, we remember the
+	 * most recent <s, d> pair that moved (s != d).  If we find a pair
+	 * that not only moved, but what's better, moved to an empty slot
+	 * (d is not set in tmp), then we break out then, with that pair.
+	 * Otherwise when we finish scannng from_tmp, we at least have the
+	 * most recent <s, d> pair that moved.  If we get all the way through
+	 * the scan of tmp without finding any node that moved, much less
+	 * moved to an empty node, then there is nothing left worth migrating.
+	 */
 
 	tmp = *from_nodes;
 	while (!nodes_empty(tmp)) {
-- 
1.6.5.2



