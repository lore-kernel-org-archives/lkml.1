Return-Path: <linux-kernel-owner+w=401wt.eu-S1758023AbXFZP1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023AbXFZP1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 11:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756254AbXFZP1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 11:27:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36036 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755870AbXFZP1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 11:27:07 -0400
Date: Tue, 26 Jun 2007 17:26:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch, v2.6.22-rc6] sys_time() speedup
Message-ID: <20070626152629.GA3342@elte.hu>
References: <20070625200601.GA18980@elte.hu> <200706252309.47467.zippel@linux-m68k.org> <20070625151508.86fa3778.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625151508.86fa3778.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > > the patch improves the sysbench OLTP macrobenchmark significantly:
> > 
> > Has that any real practical relevance?
> 
> Interesting question. [...]

i'm missing the <sarcastic> tag i guess ;-)

<sarcastic> Oh my, does database macro-performance have any relevance to 
Linux bread and butter markets in general. Boggle, it is a really 
difficult question i suspect. </sarcastic>

If we ignore those few million database and web server Linux boxes on
the market and concentrate purely on the few m68k boxes that are still
in existance, _then_ we might be doubtful about this question ;-)

> [...] The patch adds a new test-n-branch to gettimeofday() so if 
> gettimeofday() is used much more frequently than time(), we lose.

given that the cost to sys_gettimeofday() is less than a cycle (we test
a value already in a register, with an unlikely hint), and the benefit
to sys_time() is around 6000 cycles (or more), sys_gettimeofday() would
have to be used thousands of times more frequently than sys_time() -
which it clearly isnt. As a test i just triggered a really X-intense
workload and for that gettimeofday-dominated landscape there was still 1
sys_time() call for every 50 gettimeofday calls - so it's a small win
even for this X workload.

	Ingo
