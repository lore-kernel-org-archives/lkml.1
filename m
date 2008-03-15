Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbYCOQF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbYCOQF0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 12:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbYCOQFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 12:05:07 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:42733 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823AbYCOQFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 12:05:04 -0400
Date: Sat, 15 Mar 2008 17:05:02 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: jcliburn@gmail.com, csnook@redhat.com, atl1-devel@lists.sourceforge.net,
       jgarzik@pobox.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 7/7] drivers/net/atl1/atl1_main.c: remove unused variable
Message-ID: <Pine.LNX.4.64.0803151704400.24178@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The variable update_rx is initialized but never used otherwise.

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
 drivers/net/atl1/atl1_main.c |    3 ---
 1 file changed, 3 deletions(-)

diff -u -p a/drivers/net/atl1/atl1_main.c b/drivers/net/atl1/atl1_main.c
--- a/drivers/net/atl1/atl1_main.c	2008-03-12 14:13:13.000000000 +0100
+++ b/drivers/net/atl1/atl1_main.c	2008-03-15 16:18:08.000000000 +0100
@@ -1765,15 +1765,12 @@ static irqreturn_t atl1_intr(int irq, vo
 {
 	struct atl1_adapter *adapter = netdev_priv(data);
 	u32 status;
-	u8 update_rx;
 	int max_ints = 10;
 
 	status = adapter->cmb.cmb->int_stats;
 	if (!status)
 		return IRQ_NONE;
 
-	update_rx = 0;
-
 	do {
 		/* clear CMB interrupt status at once */
 		adapter->cmb.cmb->int_stats = 0;
