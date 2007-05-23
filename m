Return-Path: <linux-kernel-owner+w=401wt.eu-S1764690AbXEWLGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764690AbXEWLGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 07:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758892AbXEWLGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 07:06:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56080 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758730AbXEWLGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 07:06:33 -0400
Date: Wed, 23 May 2007 13:05:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Patrick McHardy <kaber@trash.net>
Cc: Anant Nitya <kernel@prachanda.info>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: bad networking related lag in v2.6.22-rc2
Message-ID: <20070523110556.GA8653@elte.hu>
References: <20070517174533.GA538@elte.hu> <200705221147.56571.kernel@prachanda.hub> <20070522062233.GA20002@elte.hu> <200705231110.44526.kernel@prachanda.hub> <20070523063052.GB26814@elte.hu> <46541DC4.4090501@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46541DC4.4090501@trash.net>
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


* Patrick McHardy <kaber@trash.net> wrote:

> How is this trace to be understood? Is it simply a call trace in 
> execution-order? [...]

yeah. There's a help section at the top of the trace which explains the 
other fields too:

                 _------=> CPU#
                / _-----=> irqs-off
               | / _----=> need-resched
               || / _---=> hardirq/softirq
               ||| / _--=> preempt-depth
               |||| /
               |||||     delay
   cmd     pid ||||| time  |   caller
      \   /    |||||   \   |   /
 privoxy-12926 1.Ns1    0us : ktime_get_ts (ktime_get)

the function name in braces is the parent function. So in this case the 
trace entry means we called ktime_get_ts() from ktime_get().

	Ingo
