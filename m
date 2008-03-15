Return-Path: <linux-kernel-owner+w=401wt.eu-S1755089AbYCOQEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbYCOQEc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 12:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754810AbYCOQER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 12:04:17 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:42313 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754784AbYCOQEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 12:04:15 -0400
Date: Sat, 15 Mar 2008 17:04:13 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: jeffrey.t.kirsher@intel.com, ayyappan.veeraiyan@intel.com,
       john.ronciak@intel.com, jesse.brandeburg@intel.com,
       auke-jan.h.kok@intel.com, e1000-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 5/7] drivers/net/ixgb/ixgb_main.c: remove unused variable
Message-ID: <Pine.LNX.4.64.0803151703520.24178@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The variable num_group_tail_writes is initialized but never used otherwise.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
identifier i;
constant C;
@@

(
extern T i;
|
- T i;
  <+... when != i
- i = C;
  ...+>
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---
 drivers/net/ixgb/ixgb_main.c |    2 --
 1 file changed, 2 deletions(-)

diff -u -p a/drivers/net/ixgb/ixgb_main.c b/drivers/net/ixgb/ixgb_main.c
--- a/drivers/net/ixgb/ixgb_main.c 2008-03-12 14:13:13.000000000 +0100
+++ b/drivers/net/ixgb/ixgb_main.c 2008-03-15 11:16:23.000000000 +0100
@@ -2088,14 +2088,12 @@ ixgb_alloc_rx_buffers(struct ixgb_adapte
 	struct ixgb_buffer *buffer_info;
 	struct sk_buff *skb;
 	unsigned int i;
-	int num_group_tail_writes;
 	long cleancount;
 
 	i = rx_ring->next_to_use;
 	buffer_info = &rx_ring->buffer_info[i];
 	cleancount = IXGB_DESC_UNUSED(rx_ring);
 
-	num_group_tail_writes = IXGB_RX_BUFFER_WRITE;
 
 	/* leave three descriptors unused */
 	while(--cleancount > 2) {
