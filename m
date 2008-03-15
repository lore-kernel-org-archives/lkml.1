Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbYCOQEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbYCOQEx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 12:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753823AbYCOQEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 12:04:42 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:51763 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360AbYCOQEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 12:04:41 -0400
Date: Sat, 15 Mar 2008 17:04:39 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: jesse@icplus.com.tw, jgarzik@pobox.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 6/7] drivers/net/ipg.c: remove unused variable
Message-ID: <Pine.LNX.4.64.0803151704150.24178@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The variable gig is initialized but never used otherwise.

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
 drivers/net/ipg.c |    3 ---
 1 file changed, 3 deletions(-)

diff -u -p a/drivers/net/ipg.c b/drivers/net/ipg.c
--- a/drivers/net/ipg.c 2008-03-12 14:13:13.000000000 +0100
+++ b/drivers/net/ipg.c 2008-03-15 11:17:14.000000000 +0100
@@ -472,7 +472,6 @@ static int ipg_config_autoneg(struct net
 	unsigned int txflowcontrol;
 	unsigned int rxflowcontrol;
 	unsigned int fullduplex;
-	unsigned int gig;
 	u32 mac_ctrl_val;
 	u32 asicctrl;
 	u8 phyctrl;
@@ -489,7 +488,6 @@ static int ipg_config_autoneg(struct net
 	fullduplex = 0;
 	txflowcontrol = 0;
 	rxflowcontrol = 0;
-	gig = 0;
 
 	/* To accomodate a problem in 10Mbps operation,
 	 * set a global flag if PHY running in 10Mbps mode.
@@ -511,7 +509,6 @@ static int ipg_config_autoneg(struct net
 		break;
 	case IPG_PC_LINK_SPEED_1000MBPS:
 		printk("1000Mbps.\n");
-		gig = 1;
 		break;
 	default:
 		printk("undefined!\n");
