Return-Path: <linux-kernel-owner+w=401wt.eu-S1762830AbXGPLVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762830AbXGPLVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 07:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756658AbXGPLVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 07:21:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52047 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756287AbXGPLVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 07:21:05 -0400
Date: Mon, 16 Jul 2007 13:20:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: James Bruce <bruce@andrew.cmu.edu>, Thomas Gleixner <tglx@linutronix.de>,
       Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrea Arcangeli <andrea@suse.de>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] CFS: Fix missing digit off in wmult table
Message-ID: <20070716112037.GA6895@elte.hu>
References: <20070711211638.GE18767@one.firstfloor.org> <20070711214649.GK14435@v2.random> <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org> <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net> <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184355835.12353.321.camel@chaos> <469B0D9E.3030402@andrew.cmu.edu> <20070716070610.GA10907@elte.hu> <Pine.LNX.4.64.0707161213500.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707161213500.1817@scrub.home>
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


* Roman Zippel <zippel@linux-m68k.org> wrote:

> > yes, the weight multiplier 1.25, but the actual difference in CPU 
> > utilization, when running two CPU intense tasks, is ~10%:
> > 
> >   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> >  8246 mingo     20   0  1576  244  196 R   55  0.0   0:11.96 loop
> >  8247 mingo     21   1  1576  244  196 R   45  0.0   0:10.52 loop
> > 
> > so the first task 'wins' +10% CPU utilization (relative to the 50% 
> > it had before), the second task 'loses' -10% CPU utilization 
> > (relative to the 50% it had before).
> 
> As soon as you add another loop the difference changes again, while 
> it's always correct to say it gets 25% more cpu time [...]

yep, and i'll add the relative effect to the comment too.

	Ingo
