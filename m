Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbZAENzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbZAENzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 08:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbZAENz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 08:55:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46151 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349AbZAENzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 08:55:25 -0500
Date: Mon, 5 Jan 2009 14:55:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       sparclinux <sparclinux@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: irqnr fallout in gpiolib on sparc32
Message-ID: <20090105135508.GB4190@elte.hu>
References: <20090105132916.GA10545@uranus.ravnborg.org> <20090105133819.GE6014@elte.hu> <20090105134832.GA14460@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105134832.GA14460@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> > > I did a simple:
> > > #include <linux/irqnr.h> but that did not help.
> > 
> > yeah. Does the patch below do the trick?
> 
> Needed a small fix - see below.
> 
> > btw., i'm curious, does the unification of the sparc architectures 
> > mean that sparc32 will be using genirq too some time in the future?
> 
> Dave has mentioned this but we are not working actively on it yet.

would be cool to do it - i think sparc32 is one of the last major physical 
architectures to not be on genirq - if we did this conversion we could do 
a good number of nice cleanups by eliminating all the genirq/non-genirq 
differences.

> > +#define nr_irqs			NR_IRQS
> > +#define irq_to_desc(irq)	irq_desc[irq]
> 
> irq_to_desc(irq) return a pointer to a struct irq_desc
> so we need to take the address.
> 
> > +#define irq_to_desc(irq)	&irq_desc[irq]
>                                 ^
> With this small fix the build continues.

oops, indeed. I fixed it, added your Tested-by and pushed it into 
tip/irq/urgent. Thanks Sam!

	Ingo
