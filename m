Return-Path: <linux-kernel-owner+w=401wt.eu-S1763921AbXGJVKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763921AbXGJVKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 17:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760020AbXGJVJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 17:09:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52070 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759769AbXGJVJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 17:09:52 -0400
Date: Tue, 10 Jul 2007 23:09:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Bligh <mbligh@mbligh.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>
Subject: Re: Performance regression in 2.6.22-git1 (new sched code?)
Message-ID: <20070710210945.GA4231@elte.hu>
References: <4693C3D2.9020005@mbligh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4693C3D2.9020005@mbligh.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Bligh <mbligh@mbligh.org> wrote:

> ~ 1% on 4-way x86_64
> 
> http://test.kernel.org/perf/kernbench.elm3b6.png
> 
> ~ 4% on 16-way NUMA-Q (i386)
> 
> http://test.kernel.org/perf/kernbench.moe.png
> 
> ~ 1.5% on 4-way i386
> 
> http://test.kernel.org/perf/kernbench.elm3b132.png

thx! I'll check this tomorrow, meanwhile here are a few quick ideas.

1) does reverting this patch improve performance:

   commit 9c4801cebc2add1fe514bc8eb201b16372eee11a
   Author: Ingo Molnar <mingo@elte.hu>
   Date:   Mon Jul 9 18:52:01 2007 +0200

       sched: more agressive idle balancing

2) does changing CONFIG_HZ=250 to CONFIG_HZ=100 improve the numbers? 
   CFS has some internal tuning that depends on HZ - a higher HZ is a 
   sign that the user wants more finegrained scheduling. So for maximum 
   server throughput, use CONFIG_HZ=100.

3) could you turn off CONFIG_SCHED_DEBUG? The cost is small but perhaps 
   measurable.

(these 3 suggestions could be tested together - they should have 
cumulative effects.)

	Ingo
