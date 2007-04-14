Return-Path: <linux-kernel-owner+w=401wt.eu-S965522AbXDNMC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965522AbXDNMC4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 08:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965525AbXDNMC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 08:02:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38989 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965522AbXDNMCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 08:02:55 -0400
Date: Sat, 14 Apr 2007 14:02:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: surya.prabhakar@wipro.com
Cc: kernel@kolivas.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       npiggin@suse.de, efault@gmx.de, arjan@infradead.org, tglx@linutronix.de,
       wli@holomorphy.com
Subject: Re: [TEST RESULT]massive_intr.c -- cfs/vanilla/sd-0.40
Message-ID: <20070414120220.GA2346@elte.hu>
References: <1176540546.2702.15.camel@bluegenie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1176540546.2702.15.camel@bluegenie>
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


* surya.prabhakar@wipro.com <surya.prabhakar@wipro.com> wrote:

> Hi Ingo,
>   Did a test with massive_intr.c on a standard linux desktop.
> for vanilla, con's Sd-0.40 and cfs.

thanks!

> [surya@bluegenie tests]$ ./massive_intr 10 10
> 002435  00000120
> 002439  00000120
> 002441  00000120
> 002434  00000120
> 002436  00000120
> 002440  00000120
> 002432  00000120
> 002437  00000120
> 002433  00000120
> 002438  00000120
> 
> Felt it is too much fair, will try another pass ;)

hehe :)

> [surya@bluegenie tests]$ ./massive_intr 10 10
> 002961  00000121
> 002965  00000120
> 002964  00000121
> 002959  00000120
> 002956  00000121
> 002963  00000121
> 002960  00000121
> 002962  00000121
> 002958  00000122
> 002957  00000122

btw., other schedulers might work better with some more test-time: i'd 
suggest to use 60 seconds (./massive_intr 10 60) [or maybe more, using 
more threads] to see long-term fairness effects.

> [...] Will be trying out ringtest in the next round.

cool. ringtest.c is intended to be used the following way: start it, it 
will generate a 99% busy system (but it is using a ring of 100 tasks, 
where each tasks runs for 100 msecs then sleeps for 1 msec, so every 
task gets a turn every 10 seconds). If you add a pure CPU hog to the 
system, for example an infinite shell loop:

	while :; do :; done &

then a 'fair' scheduler would give roughly 50% of CPU time to the CPU 
hog (and the ringtest.c tasks take up the other 50%).

	Ingo
