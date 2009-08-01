Return-Path: <linux-kernel-owner+w=401wt.eu-S1752316AbZHATvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbZHATvL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 15:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbZHATvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 15:51:10 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:48410 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbZHATvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 15:51:08 -0400
Date: Sat, 1 Aug 2009 21:51:06 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 5/5] drivers/net: Use DIV_ROUND_CLOSEST
Message-ID: <Pine.LNX.4.64.0908012150340.25693@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The kernel.h macro DIV_ROUND_CLOSEST performs the computation (x + d/2)/d
but is perhaps more readable.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
expression x,__divisor;
@@

- (((x) + ((__divisor) / 2)) / (__divisor))
+ DIV_ROUND_CLOSEST(x,__divisor)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/b44.c                   |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/b44.c b/drivers/net/b44.c
index 1f7f015..07c92f3 100644
--- a/drivers/net/b44.c
+++ b/drivers/net/b44.c
@@ -1297,7 +1297,8 @@ static void b44_chip_reset(struct b44 *bp, int reset_kind)
 	switch (sdev->bus->bustype) {
 	case SSB_BUSTYPE_SSB:
 		bw32(bp, B44_MDIO_CTRL, (MDIO_CTRL_PREAMBLE |
-		     (((ssb_clockspeed(sdev->bus) + (B44_MDC_RATIO / 2)) / B44_MDC_RATIO)
+		     (DIV_ROUND_CLOSEST(ssb_clockspeed(sdev->bus),
+					B44_MDC_RATIO)
 		     & MDIO_CTRL_MAXF_MASK)));
 		break;
 	case SSB_BUSTYPE_PCI:
