Return-Path: <linux-kernel-owner+w=401wt.eu-S1752663AbZHBIyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbZHBIyK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 04:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbZHBIyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 04:54:09 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:53982 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbZHBIyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 04:54:08 -0400
Date: Sun, 2 Aug 2009 10:46:45 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: kernel@wantstofly.org, dan.j.williams@intel.com,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 7/15] arch/arm/plat-iop: Use DIV_ROUND_CLOSEST
Message-ID: <Pine.LNX.4.64.0908021046260.15557@ask.diku.dk>
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
 arch/arm/plat-iop/time.c            |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-iop/time.c b/arch/arm/plat-iop/time.c
index 3695bbe..8da95d5 100644
--- a/arch/arm/plat-iop/time.c
+++ b/arch/arm/plat-iop/time.c
@@ -85,7 +85,7 @@ void __init iop_init_time(unsigned long tick_rate)
 {
 	u32 timer_ctl;
 
-	ticks_per_jiffy = (tick_rate + HZ/2) / HZ;
+	ticks_per_jiffy = DIV_ROUND_CLOSEST(tick_rate, HZ);
 	ticks_per_usec = tick_rate / 1000000;
 	next_jiffy_time = 0xffffffff;
 	iop_tick_rate = tick_rate;
