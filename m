Return-Path: <linux-kernel-owner+w=401wt.eu-S1752516AbZHBItw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbZHBItw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 04:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbZHBItw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 04:49:52 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:54038 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbZHBItv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 04:49:51 -0400
Date: Sun, 2 Aug 2009 10:48:08 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 10/15] arch/mips: Use DIV_ROUND_CLOSEST
Message-ID: <Pine.LNX.4.64.0908021047480.15557@ask.diku.dk>
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
 arch/mips/nxp/pnx8550/common/time.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/nxp/pnx8550/common/time.c b/arch/mips/nxp/pnx8550/common/time.c
index 8df43e9..18b1927 100644
--- a/arch/mips/nxp/pnx8550/common/time.c
+++ b/arch/mips/nxp/pnx8550/common/time.c
@@ -138,7 +138,7 @@ __init void plat_time_init(void)
 	 * HZ timer interrupts per second.
 	 */
 	mips_hpt_frequency = 27UL * ((1000000UL * n)/(m * pow2p));
-	cpj = (mips_hpt_frequency + HZ / 2) / HZ;
+	cpj = DIV_ROUND_CLOSEST(mips_hpt_frequency, HZ);
 	write_c0_count(0);
 	timer_ack();
 
