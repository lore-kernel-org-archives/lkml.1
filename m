Return-Path: <linux-kernel-owner+w=401wt.eu-S1754274AbXEYIIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbXEYIIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 04:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbXEYIIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 04:08:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57743 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbXEYIIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 04:08:32 -0400
Date: Fri, 25 May 2007 10:08:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [patch] i386, numaq: enable TSCs again
Message-ID: <20070525080827.GA22399@elte.hu>
References: <20070525071005.GA6431@elte.hu> <a781481a0705250022t3dec8f13u7c75d0ade40b0010@mail.gmail.com> <20070525073158.GB8094@one.firstfloor.org> <20070525073957.GA15207@elte.hu> <20070525074316.GA16821@elte.hu> <20070525074915.GA18400@elte.hu> <20070525075446.GA20140@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525075446.GA20140@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Andi, Andrew, do you remember why we disabled TSCs on NUMAQ? It was 
slightly async between CPUs, right? In that case we should try the patch 
below.

	Ingo

--------------------->
Subject: [patch] i386, numaq: enable TSCs again
From: Ingo Molnar <mingo@elte.hu>

enable TSCs on NUMAQ again. sched_clock() got improved and
the scheduler treats it as a per-CPU clock, so there should
be no issues from the slightly async TSCs on NUMAQ. Please
holler if this is wrong ...

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/i386/kernel/numaq.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-cfs-2.6.22-rc2-mm1.q/arch/i386/kernel/numaq.c
===================================================================
--- linux-cfs-2.6.22-rc2-mm1.q.orig/arch/i386/kernel/numaq.c
+++ linux-cfs-2.6.22-rc2-mm1.q/arch/i386/kernel/numaq.c
@@ -81,8 +81,7 @@ int __init get_memcfg_numaq(void)
 static int __init numaq_tsc_disable(void)
 {
 	if (num_online_nodes() > 1) {
-		printk(KERN_DEBUG "NUMAQ: disabling TSC\n");
-		tsc_disable = 1;
+		printk(KERN_DEBUG "NUMAQ: NOT disabling TSC. System still ok?\n");
 	}
 	return 0;
 }

