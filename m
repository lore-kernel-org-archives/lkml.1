Return-Path: <linux-kernel-owner+w=401wt.eu-S1760254AbXEUIMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760254AbXEUIMv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 04:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbXEUIMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 04:12:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49243 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512AbXEUIMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 04:12:43 -0400
Date: Mon, 21 May 2007 10:12:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Anant Nitya <kernel@prachanda.info>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: bad networking related lag in v2.6.22-rc2
Message-ID: <20070521081201.GB13858@elte.hu>
References: <20070517174533.GA538@elte.hu> <200705180317.06014.kernel@prachanda.hub> <20070518102607.GA23151@elte.hu> <200705200246.22444.kernel@prachanda.hub> <20070521075824.GA11198@elte.hu> <20070521080351.GA13375@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521080351.GA13375@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.7
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.7 required=5.9 tests=BAYES_00,INFO_TLD autolearn=no SpamAssassin version=3.1.7
	1.3 INFO_TLD               URI: Contains an URL in the INFO top-level domain
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > ouch! a nearly 1 second delay got observed by the scheduler - something 
> > is really killing your system!
>
> ah, you got the latency tracer from Thomas, as part of the -hrt patchset 
> - that makes it quite a bit easier to debug. [...]

and ... you already did a trace for Thomas, for the softirq problem:

   http://cybertek.info/taitai/trace.txt.bz2

this trace shows really bad networking related kernel activities!

gkrellm-5977 does this at timestamp 0:

 gkrellm-5977  0..s.    0us : cond_resched_softirq (established_get_next)

2 milliseconds later it's still in established_get_next() (!):

 gkrellm-5977  0..s. 2001us : cond_resched_softirq (established_get_next)

and the whole thing takes ... 455 msecs:

 gkrellm-5977  0..s. 455443us+: cond_resched_softirq (established_get_next)

i think this suggests that you have tons of open sockets. What does 
"netstat -ts" say on your box?

	Ingo
