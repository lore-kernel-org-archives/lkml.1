Return-Path: <linux-kernel-owner+w=401wt.eu-S1751600AbXECTse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbXECTse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 15:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbXECTse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 15:48:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46603 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbXECTsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 15:48:33 -0400
Date: Thu, 3 May 2007 21:48:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ting Yang <tingy@cs.umass.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v7
Message-ID: <20070503194827.GA10423@elte.hu>
References: <200704300820.49078.a1426z@gawab.com> <20070503074552.GA14960@elte.hu> <4639F970.5080701@cs.umass.edu> <20070503151741.GC1812@elte.hu> <463A0734.6090408@cs.umass.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463A0734.6090408@cs.umass.edu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ting Yang <tingy@cs.umass.edu> wrote:

> then how much time is needed for "curr" to build a 2 * 32 difference 
> on fair_key, with every 1 ms it updates fair_key by 1/32 ?  2 * 32 * 
> 32 !

yes - but the "*32" impacts the rescheduling granularity, the "/32" 
impacts the speed of how the key moves. So the total execution speed of 
the nice -10 task is still "*32" of a nice 0 task - it's just that not 
only it gets 32 times more CPU time, it also gets it at 32 times larger 
chunks at once. But the rescheduling granularity does _not_ impact the 
CPU share the task gets, so there's no quadratic effect.

but this is really simple to test: boot up CFS, start two infinite 
loops, one at nice 0 and one at nice +10 and look at it via "top" and 
type 's 60' in top to get a really long update interval for precise 
results. You wont see quadratically less CPU time used up by the nice 
+10 task, you'll see it getting the intended 1/32 share of CPU time.

	Ingo
