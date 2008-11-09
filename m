Return-Path: <linux-kernel-owner+w=401wt.eu-S1756436AbYKIQ50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436AbYKIQ50 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 11:57:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755748AbYKIQ5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 11:57:01 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:37678 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755681AbYKIQ47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 11:56:59 -0500
Date: Sun, 9 Nov 2008 17:56:57 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: per.liden@ericsson.com, jon.maloy@ericsson.com,
       allan.stephens@windriver.com, tipc-discussion@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 8/8] net/tipc/bcast.h: use ARRAY_SIZE
Message-ID: <Pine.LNX.4.64.0811091756350.32509@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

ARRAY_SIZE is more concise to use when the size of an array is divided by
the size of its type or the size of its first element.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@i@
@@

#include <linux/kernel.h>

@depends on i using "paren.iso"@
type T;
T[] E;
@@

- (sizeof(E)/sizeof(T))
+ ARRAY_SIZE(E)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 net/tipc/bcast.h              |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/tipc/bcast.h b/net/tipc/bcast.h
index 5aa024b..2f2d731 100644
--- a/net/tipc/bcast.h
+++ b/net/tipc/bcast.h
@@ -124,7 +124,7 @@ static inline int tipc_nmap_equal(struct tipc_node_map *nm_a, struct tipc_node_m
 static inline void tipc_nmap_diff(struct tipc_node_map *nm_a, struct tipc_node_map *nm_b,
 				  struct tipc_node_map *nm_diff)
 {
-	int stop = sizeof(nm_a->map) / sizeof(u32);
+	int stop = ARRAY_SIZE(nm_a->map);
 	int w;
 	int b;
 	u32 map;
