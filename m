Return-Path: <linux-kernel-owner+w=401wt.eu-S1752918AbYG1Xv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbYG1Xv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 19:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYG1Xvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 19:51:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57763 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbYG1Xvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 19:51:49 -0400
Date: Tue, 29 Jul 2008 01:51:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: combinatorial explosion in lockdep
Message-ID: <20080728235133.GA7956@elte.hu>
References: <20080728.153702.103032029.davem@davemloft.net> <20080728.161318.38361710.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728.161318.38361710.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: David Miller <davem@davemloft.net>
> Date: Mon, 28 Jul 2008 15:37:02 -0700 (PDT)
> 
> > I'm still digging on what exactly makes this happen, but I wanted to 
> > get the information out as soon as I had something useful like this.
> 
> As a simple hack, I tried mitigating these effects using a 
> generation-count based "visited" scheme to bypass traversing 
> lock_class chains we've already walked down.
> 
> It seems to work.

nice!

Any chance to get the "cat /proc/lockdep*" output, so that we could see 
and check the expected behavior of the full graph?

But with 128 cpus and double locking taking in the scheduler, there's 
around 127*128/2 possible combinations of cpu rq lock ordering, that's 
thousands of chains, and that takes a quadratic number of steps to 
iterate via the current algorithm - which would be in the neighborhood 
of 127^4 / 4, or about 65 million steps for each new change to the 
graph. (but it's late and i'm not sure at all about the numbers so i 
could be off by a few orders of magnitude, in either direction)

Plus the irqsafe/softirqsafe layers multiply things too.

Could you please also send the non-stack-iterator changes you did as 
well - that's cool stuff too!

	Ingo
