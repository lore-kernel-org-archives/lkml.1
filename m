Return-Path: <linux-kernel-owner+w=401wt.eu-S2992899AbXEBIPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992899AbXEBIPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 04:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992908AbXEBIPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 04:15:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40822 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992899AbXEBIPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 04:15:52 -0400
Date: Wed, 2 May 2007 10:13:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Mark Lord <lkml@rtr.ca>,
       Zach Carter <linux@zachcarter.com>, buddabrod <buddabrod@gmail.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [patch] CFS scheduler, -v8
Message-ID: <20070502081356.GA21827@elte.hu>
References: <20070501212223.GA29867@elte.hu> <1178087834.8640.7.camel@Homer.simpson.net> <200705020403.35385.gene.heskett@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705020403.35385.gene.heskett@gmail.com>
User-Agent: Mutt/1.4.2.2i
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


* Gene Heskett <gene.heskett@gmail.com> wrote:

> > I noticed a (harmless) bounds warning triggered by the reduction in 
> > size of array->bitmap.  Patchlet below.
> 
> I just checked my logs, and it appears my workload didn't trigger this 
> one Mike. [...]

yeah: this is a build-time warning and it needs a newer/smarter gcc to 
notice that provably redundant piece of code. It's a harmless thing - 
but nevertheless Mike's fix is a nice little micro-optimization as well: 
it always bothered me a bit that at 140 priority levels we were _just_ 
past the 128 bits boundary by 12 bits. Now on 64-bit boxes it's just two 
64-bit words to cover all 100 priority levels of RT tasks.

> [...]  And so far, v8 is working great here.  And that great is in my 
> best "Tony the Tiger" voice, stolen shamelessly from the breakfast 
> cereal tv commercial of 30+ years ago. :)

heh :-)

> Ingo asked for a 0-100 rating, where 0 is mainline as I recall it, and 
> 100 is the best of the breed.  I'll give this one a 100 till something 
> better shows up.

nice - and you arent even using any OpenGL games ;)

The 0-100 rating is really useful to me so that i can see the impact of 
regressions (if any) and it's also one single number representing the 
subjective impression - that way it's easier to keep tab of things.

btw., do you still renice kmail slightly, or does it now work out of box 
with default nice 0?

	Ingo
