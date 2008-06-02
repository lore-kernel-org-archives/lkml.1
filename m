Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbYFBKiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbYFBKiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbYFBKiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 06:38:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60069 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736AbYFBKiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 06:38:00 -0400
Date: Mon, 2 Jun 2008 12:36:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       tpiepho@freescale.com
Subject: Re: MMIO and gcc re-ordering issue
Message-ID: <20080602103643.GA21285@elte.hu>
References: <1211852026.3286.36.camel@pasglop> <20080526.184047.88207142.davem@davemloft.net> <1211854540.3286.42.camel@pasglop> <20080526.192812.184590464.davem@davemloft.net> <1211859542.3286.46.camel@pasglop> <alpine.LFD.1.10.0805270833060.2958@woody.linux-foundation.org> <alpine.LFD.1.10.0805270943100.2958@woody.linux-foundation.org> <alpine.LFD.1.10.0805271028520.2958@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805271028520.2958@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > Here's a UNTESTED patch for x86 that may or may not compile and 
> > work, and which serializes (on a compiler level) the IO accesses 
> > against regular memory accesses.
> 
> Ok, so it at least boots on x86-32. Thus probably on x86-64 too (since 
> the code is now shared). I didn't look at whether it generates much 
> bigger code due to the potential extra serialization, but some of the 
> code generation I looked at looked fine.
> 
> IOW, it doesn't at least create any _obviously_ worse code, and it 
> should be arguably safer than assuming the compiler does volatile 
> accesses the way we want it to.

ok, to pursue this topic of making readl*/writel*() more robust i picked 
up your patch into -tip and created a new topic branch for it: 
tip/x86/mmio.

The patch passed initial light testing in -tip (~30 successful random 
self-builds and bootups on various mixed 32-bit/64-bit boxes) but it's 
still v2.6.27 material IMO.

Failures in this area are subtle so there's no good way to tell whether 
it works as intended - we need wider testing. I've also added the 
tip/x86/mmio topic to tip/auto-x86-next rules as well so these changes 
will be picked up by tomorrow's linux-next tree as well, and by the next 
-mm iteration.

	Ingo
