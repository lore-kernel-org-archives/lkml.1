Return-Path: <linux-kernel-owner+w=401wt.eu-S1752524AbZHBIt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbZHBIt2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 04:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbZHBIt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 04:49:27 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:53922 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbZHBIt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 04:49:26 -0400
Date: Sun, 2 Aug 2009 10:47:47 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: geert@linux-m68k.org, zippel@linux-m68k.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 9/15] arch/m68k: Use DIV_ROUND_CLOSEST
Message-ID: <Pine.LNX.4.64.0908021047280.15557@ask.diku.dk>
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
 arch/m68k/amiga/config.c            |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/amiga/config.c b/arch/m68k/amiga/config.c
index 6e56275..002b9b0 100644
--- a/arch/m68k/amiga/config.c
+++ b/arch/m68k/amiga/config.c
@@ -480,7 +480,7 @@ static void __init amiga_sched_init(irq_handler_t timer_routine)
 	static struct resource sched_res = {
 		.name = "timer", .start = 0x00bfd400, .end = 0x00bfd5ff,
 	};
-	jiffy_ticks = (amiga_eclock+HZ/2)/HZ;
+	jiffy_ticks = DIV_ROUND_CLOSEST(amiga_eclock, HZ);
 
 	if (request_resource(&mb_resources._ciab, &sched_res))
 		printk("Cannot allocate ciab.ta{lo,hi}\n");
