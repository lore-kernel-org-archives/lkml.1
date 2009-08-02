Return-Path: <linux-kernel-owner+w=401wt.eu-S1752579AbZHBIud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbZHBIud (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 04:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbZHBIuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 04:50:32 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:54228 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbZHBIub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 04:50:31 -0400
Date: Sun, 2 Aug 2009 10:48:45 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: chas@cmf.nrl.navy.mil, linux-atm-general@lists.sourceforge.net,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 12/15] drivers/atm: Use DIV_ROUND_CLOSEST
Message-ID: <Pine.LNX.4.64.0908021048280.15557@ask.diku.dk>
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
 drivers/atm/horizon.c               |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/atm/horizon.c b/drivers/atm/horizon.c
index 6b969f8..01ce241 100644
--- a/drivers/atm/horizon.c
+++ b/drivers/atm/horizon.c
@@ -641,7 +641,7 @@ static int make_rate (const hrz_dev * dev, u32 c, rounding r,
 					pre = 1;
 				break;
 			case round_nearest:
-				pre = (br+(c<<div)/2)/(c<<div);
+				pre = DIV_ROUND_CLOSEST(br, c<<div);
 				// but p must be non-zero
 				if (!pre)
 					pre = 1;
@@ -671,7 +671,7 @@ static int make_rate (const hrz_dev * dev, u32 c, rounding r,
 					pre = DIV_ROUND_UP(br, c<<div);
 					break;
 				case round_nearest:
-					pre = (br+(c<<div)/2)/(c<<div);
+					pre = DIV_ROUND_CLOSEST(br, c<<div);
 					break;
 				default: /* round_up */
 					pre = br/(c<<div);
