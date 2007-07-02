Return-Path: <linux-kernel-owner+w=401wt.eu-S1757465AbXGBPup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465AbXGBPup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 11:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbXGBPui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 11:50:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35740 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512AbXGBPuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 11:50:37 -0400
Date: Mon, 2 Jul 2007 17:50:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v18
Message-ID: <20070702155029.GA13241@elte.hu>
References: <20070622220202.GA16872@elte.hu> <19f34abd0707020444r47221944tf7f33b2a0d17c367@mail.gmail.com> <b647ffbd0707020601r774a38d4gb62b6c07f1b5db32@mail.gmail.com> <19f34abd0707020643g6a274db5q1d25cabd85b9a25f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0707020643g6a274db5q1d25cabd85b9a25f@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.9
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.9 required=5.9 tests=BAYES_00,WEIRD_PORT autolearn=no SpamAssassin version=3.0.3
	0.1 WEIRD_PORT             URI: Uses non-standard port number for HTTP
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> Resulting files at
> http://vegard.afraid.org:1104/pub/cfs/
> 
> cfs-debug-info-2007.07.02-15:18:13    Before running program
> cfs-debug-info-2007.07.02-15:19:51    ~10 secs after start
> cfs-debug-info-2007.07.02-15:20:54    ~1 minute after start
> cfs-debug-info-2007.07.02-15:25:52    ~5 minutes after start
> cfs-debug-info-2007.07.02-15:30:54    ~10 minutes after start
> 
> a.out is my program, FahCore_78 is the f@h client.

thx. As an initial matter, could you double-check whether your v18 
kernel source has the patch below applied already?

	Ingo

Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -342,8 +342,9 @@ update_stats_enqueue(struct cfs_rq *cfs_
 		s64 tmp;
 
 		if (se->wait_runtime < 0) {
-			tmp = (0 - se->wait_runtime) << NICE_0_SHIFT;
-			key += (tmp * se->load.inv_weight) >> WMULT_SHIFT;
+			tmp = -se->wait_runtime;
+			key += (tmp * se->load.inv_weight) >>
+					(WMULT_SHIFT - NICE_0_SHIFT);
 		} else {
 			tmp = se->wait_runtime * se->load.weight;
 			key -= tmp >> NICE_0_SHIFT;

