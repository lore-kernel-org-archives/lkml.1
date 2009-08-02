Return-Path: <linux-kernel-owner+w=401wt.eu-S1752643AbZHBIv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbZHBIv5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 04:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbZHBIvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 04:51:53 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:53372 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492AbZHBIvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 04:51:51 -0400
Date: Sun, 2 Aug 2009 10:44:32 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: rth@twiddle.net, ink@jurassic.park.msu.ru, linux-alpha@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/15] arch/alpha: Use DIV_ROUND_CLOSEST
Message-ID: <Pine.LNX.4.64.0908021044000.15557@ask.diku.dk>
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
 arch/alpha/kernel/sys_ruffian.c     |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/alpha/kernel/sys_ruffian.c b/arch/alpha/kernel/sys_ruffian.c
index d9f9cfe..8de1046 100644
--- a/arch/alpha/kernel/sys_ruffian.c
+++ b/arch/alpha/kernel/sys_ruffian.c
@@ -66,7 +66,7 @@ ruffian_init_irq(void)
 	common_init_isa_dma();
 }
 
-#define RUFFIAN_LATCH	((PIT_TICK_RATE + HZ / 2) / HZ)
+#define RUFFIAN_LATCH	DIV_ROUND_CLOSEST(PIT_TICK_RATE, HZ)
 
 static void __init
 ruffian_init_rtc(void)
