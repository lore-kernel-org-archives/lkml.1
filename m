Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbZAGNCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbZAGNCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 08:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbZAGNCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 08:02:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41196 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbZAGNCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 08:02:34 -0500
Date: Wed, 7 Jan 2009 14:02:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: sam@ravnborg.org, kosaki.motohiro@jp.fujitsu.com, yinghai@kernel.org,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: irqnr fallout in gpiolib on sparc32
Message-ID: <20090107130213.GB3529@elte.hu>
References: <20090105135508.GB4190@elte.hu> <20090105.123734.137888898.davem@davemloft.net> <20090106125704.GC20407@elte.hu> <20090106.082913.97432854.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106.082913.97432854.davem@davemloft.net>
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

> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 6 Jan 2009 13:57:04 +0100
> 
> > Sparc32 on the other hand had a clean IRQ layer long before x86 found its 
> > desire for a clean genirq layer - so genirq is a nuisance for Sparc32 at 
> > best and it deserves none of the not nice actions. What i am hoping for is 
> > that perhaps the Sparc unification changed that equation.
> 
> Not really, the unificiation didn't change much in this area. [...]

Yeah, i mean - "changed the equation" psychologically, the same way it did 
it on x86.

There's now two files close to each other in the namespace:

 earth4:~/tip> ls -l arch/sparc/kernel/irq*.c
 -rw-rw-r-- 1 mingo mingo 16122 2009-01-07 13:50 arch/sparc/kernel/irq_32.c
 -rw-rw-r-- 1 mingo mingo 26556 2009-01-07 12:34 arch/sparc/kernel/irq_64.c

Each of them crying out loud to be unified. Every time you open irq_64.c 
you'll think "why that ugly _64.c postfix, shouldnt this be irq.c 
instead?" ;-)

That kind of gentle pressure to unify comes straight from the fact that 
there's _32.c and _64.c postfixes around and the postfixes mess up command 
completion when those files are opened, so we notice the non-unified-ness 
again and again.

At least this was what drove many of the x86 unifications. (Mind you, 
irq_32/irq_64.c is still not fully unified on x86 ;)

> [...] That doesn't change the fact that I do intend to genirq'ify 
> sparc32 some time soon. :-)

Cool! :-)

	Ingo
