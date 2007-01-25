Return-Path: <linux-kernel-owner+w=401wt.eu-S1030605AbXAYVr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030605AbXAYVr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 16:47:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030606AbXAYVr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 16:47:57 -0500
Received: from mx3.cs.washington.edu ([128.208.3.132]:49759 "EHLO
	mx3.cs.washington.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030605AbXAYVr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 16:47:56 -0500
X-Greylist: delayed 624 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Jan 2007 16:47:56 EST
Date: Thu, 25 Jan 2007 13:37:25 -0800 (PST)
From: David Rientjes <rientjes@cs.washington.edu>
To: Andrew Morton <akpm@osdl.org>
cc: Andi Kleen <ak@suse.de>, Rohit Seth <rohitseth@google.com>,
       linux-kernel@vger.kernel.org
Subject: [patch -mm 4/5] x86_64: fake numa function annotations
In-Reply-To: <Pine.LNX.4.64N.0701251334280.13206@attu4.cs.washington.edu>
Message-ID: <Pine.LNX.4.64N.0701251335270.13206@attu4.cs.washington.edu>
References: <Pine.LNX.4.64N.0701251332280.13206@attu4.cs.washington.edu>
 <Pine.LNX.4.64N.0701251333470.13206@attu4.cs.washington.edu>
 <Pine.LNX.4.64N.0701251334280.13206@attu4.cs.washington.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark the new numa=fake x86_64 helper functions, setup_node_range(),
split_nodes_equally(), and split_nodes_by_size() as __init.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@cs.washington.edu>
---
 arch/x86_64/mm/numa.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86_64/mm/numa.c b/arch/x86_64/mm/numa.c
index 2ee228b..5d8fee6 100644
--- a/arch/x86_64/mm/numa.c
+++ b/arch/x86_64/mm/numa.c
@@ -287,8 +287,8 @@ char *cmdline __initdata;
  * if there is additional memory left for allocation past addr and -1 otherwise.
  * addr is adjusted to be at the end of the node.
  */
-static int setup_node_range(int nid, struct bootnode *nodes, u64 *addr,
-			    u64 size, u64 max_addr)
+static int __init setup_node_range(int nid, struct bootnode *nodes, u64 *addr,
+				   u64 size, u64 max_addr)
 {
 	int ret = 0;
 	nodes[nid].start = *addr;
@@ -310,8 +310,9 @@ static int setup_node_range(int nid, struct bootnode *nodes, u64 *addr,
  * is the number of nodes split up and addr is adjusted to be at the end of the
  * last node allocated.
  */
-static int split_nodes_equally(struct bootnode *nodes, u64 *addr, u64 max_addr,
-			       int node_start, int num_nodes)
+static int __init split_nodes_equally(struct bootnode *nodes, u64 *addr,
+				      u64 max_addr, int node_start,
+				      int num_nodes)
 {
 	unsigned int big;
 	u64 size;
@@ -363,8 +364,8 @@ static int split_nodes_equally(struct bootnode *nodes, u64 *addr, u64 max_addr,
  * always assigned to a final node and can be asymmetric.  Returns the number of
  * nodes split.
  */
-static int split_nodes_by_size(struct bootnode *nodes, u64 *addr, u64 max_addr,
-			       int node_start, u64 size)
+static int __init split_nodes_by_size(struct bootnode *nodes, u64 *addr,
+			       u64 max_addr, int node_start, u64 size)
 {
 	int i = node_start;
 	size = (size << 20) & FAKE_NODE_MIN_HASH_MASK;
