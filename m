Return-Path: <linux-kernel-owner+w=401wt.eu-S1752385AbZHBIrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbZHBIrN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 04:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbZHBIrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 04:47:12 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:53295 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbZHBIrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 04:47:11 -0400
Date: Sun, 2 Aug 2009 10:45:39 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: hsweeten@visionengravers.com, ryan@bluewatersys.com,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 4/15] arch/arm/mach-ep93xx: Use DIV_ROUND_CLOSEST
Message-ID: <Pine.LNX.4.64.0908021045190.15557@ask.diku.dk>
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
 arch/arm/mach-ep93xx/core.c         |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-ep93xx/core.c b/arch/arm/mach-ep93xx/core.c
index 4075529..16b92c3 100644
--- a/arch/arm/mach-ep93xx/core.c
+++ b/arch/arm/mach-ep93xx/core.c
@@ -82,7 +82,7 @@ void __init ep93xx_map_io(void)
  */
 static unsigned int last_jiffy_time;
 
-#define TIMER4_TICKS_PER_JIFFY		((CLOCK_TICK_RATE + (HZ/2)) / HZ)
+#define TIMER4_TICKS_PER_JIFFY		DIV_ROUND_CLOSEST(CLOCK_TICK_RATE, HZ)
 
 static irqreturn_t ep93xx_timer_interrupt(int irq, void *dev_id)
 {
