Return-Path: <linux-kernel-owner+w=401wt.eu-S1752017AbZHBIrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbZHBIrh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 04:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbZHBIrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 04:47:36 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:53412 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbZHBIrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 04:47:36 -0400
Date: Sun, 2 Aug 2009 10:46:05 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: kernel@wantstofly.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 5/15] arch/arm/mach-ixp2000: Use DIV_ROUND_CLOSEST
Message-ID: <Pine.LNX.4.64.0908021045400.15557@ask.diku.dk>
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
 arch/arm/mach-ixp2000/core.c        |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-ixp2000/core.c b/arch/arm/mach-ixp2000/core.c
index babb225..037342b 100644
--- a/arch/arm/mach-ixp2000/core.c
+++ b/arch/arm/mach-ixp2000/core.c
@@ -219,7 +219,7 @@ static struct irqaction ixp2000_timer_irq = {
 
 void __init ixp2000_init_time(unsigned long tick_rate)
 {
-	ticks_per_jiffy = (tick_rate + HZ/2) / HZ;
+	ticks_per_jiffy = DIV_ROUND_CLOSEST(tick_rate, HZ);
 	ticks_per_usec = tick_rate / 1000000;
 
 	/*
