Return-Path: <linux-kernel-owner+w=401wt.eu-S1757430AbXEUIEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbXEUIEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 04:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657AbXEUIEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 04:04:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48504 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753012AbXEUIEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 04:04:33 -0400
Date: Mon, 21 May 2007 10:03:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Anant Nitya <kernel@prachanda.info>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: bad networking related lag in v2.6.22-rc2
Message-ID: <20070521080351.GA13375@elte.hu>
References: <20070517174533.GA538@elte.hu> <200705180317.06014.kernel@prachanda.hub> <20070518102607.GA23151@elte.hu> <200705200246.22444.kernel@prachanda.hub> <20070521075824.GA11198@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521075824.GA11198@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> ok, i got your -rc2 debug numbers (off-list), and it doesnt look pretty:
> 
> before-lag:
> 
>  sleep_max                :           259502076
>  block_max                :            27690921
>  wait_max                 :            16381558
> 
> after-lag:
> 
>  sleep_max                :           584186160
>  block_max                :           261780071
>  wait_max                 :           881255577
> 
> ouch! a nearly 1 second delay got observed by the scheduler - something 
> is really killing your system!
> 
> what does 'top' show during an upload? Is any system related task out 
> of whack? Could you try to get a readprofile or an oprofile output 
> from the kernel, so that we can see what is slowing it down so much? 
> It could be something networking related in v2.6.22-rc2.

ah, you got the latency tracer from Thomas, as part of the -hrt patchset 
- that makes it quite a bit easier to debug. Could you run the attached 
trace-it-10sec utility:

	trace-it-10sec > trace-to-ingo.txt

and send me the (compressed) trace output (off-list, or post an URL to 
the trace)? Try to reproduce the 'lag' event in the 10 seconds while the 
tracer is running.

	Ingo
