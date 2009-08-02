Return-Path: <linux-kernel-owner+w=401wt.eu-S1752144AbZHBIsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbZHBIsG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 04:48:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbZHBIsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 04:48:05 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:53539 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbZHBIsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 04:48:04 -0400
Date: Sun, 2 Aug 2009 10:46:25 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: alex@shark-linux.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 6/15] arch/arm/mach-shark: Use DIV_ROUND_CLOSEST
Message-ID: <Pine.LNX.4.64.0908021046060.15557@ask.diku.dk>
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
 arch/arm/mach-shark/core.c          |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-shark/core.c b/arch/arm/mach-shark/core.c
index 358d875..a4eae65 100644
--- a/arch/arm/mach-shark/core.c
+++ b/arch/arm/mach-shark/core.c
@@ -119,7 +119,7 @@ static void __init shark_map_io(void)
 }
 
 #define IRQ_TIMER 0
-#define HZ_TIME ((1193180 + HZ/2) / HZ)
+#define HZ_TIME DIV_ROUND_CLOSEST(1193180, HZ)
 
 static irqreturn_t
 shark_timer_interrupt(int irq, void *dev_id)
