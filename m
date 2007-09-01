Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbXIAQo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbXIAQo2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 12:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbXIAQoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 12:44:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60759 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbXIAQoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 12:44:16 -0400
Date: Sat, 1 Sep 2007 18:44:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: chris@zankel.net, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc: sched.c vs. xtensa: RSR redefined
Message-ID: <20070901164412.GA7273@elte.hu>
References: <20070901152743.GI9260@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070901152743.GI9260@stusta.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Adrian Bunk <bunk@kernel.org> wrote:

> Although it seems to pick the right version the following namespace 
> conflict should be resolved:

agreed - i've queued up the fix below.

	Ingo

------------------>
Subject: sched: fix xtensa build warning
From: Ingo Molnar <mingo@elte.hu>

rename RSR to SRR - 'RSR' is already defined on xtensa.

found by Adrian Bunk.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -668,7 +668,7 @@ static u64 div64_likely32(u64 divident, 
 /*
  * Shift right and round:
  */
-#define RSR(x, y) (((x) + (1UL << ((y) - 1))) >> (y))
+#define SRR(x, y) (((x) + (1UL << ((y) - 1))) >> (y))
 
 static unsigned long
 calc_delta_mine(unsigned long delta_exec, unsigned long weight,
@@ -684,10 +684,10 @@ calc_delta_mine(unsigned long delta_exec
 	 * Check whether we'd overflow the 64-bit multiplication:
 	 */
 	if (unlikely(tmp > WMULT_CONST))
-		tmp = RSR(RSR(tmp, WMULT_SHIFT/2) * lw->inv_weight,
+		tmp = SRR(SRR(tmp, WMULT_SHIFT/2) * lw->inv_weight,
 			WMULT_SHIFT/2);
 	else
-		tmp = RSR(tmp * lw->inv_weight, WMULT_SHIFT);
+		tmp = SRR(tmp * lw->inv_weight, WMULT_SHIFT);
 
 	return (unsigned long)min(tmp, (u64)(unsigned long)LONG_MAX);
 }
