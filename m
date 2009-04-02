Return-Path: <linux-kernel-owner+w=401wt.eu-S932407AbZDBRdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407AbZDBRdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 13:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760410AbZDBRdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 13:33:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49732 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759494AbZDBRdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 13:33:40 -0400
Date: Thu, 2 Apr 2009 19:32:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, henrix@sapo.pt,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/genirq] genirq: do not execute DEBUG_SHIRQ when irq
	setup failed
Message-ID: <20090402173257.GA3755@elte.hu>
References: <20090401170635.GA4392@hades.domain.com> <tip-ba71604fad348656071a2a76eef9a67dab85a773@git.kernel.org> <1238682747.3099.16.camel@ht.satnam> <alpine.LFD.2.00.0904021718230.12916@localhost.localdomain> <1238686904.3099.22.camel@ht.satnam> <alpine.LFD.2.00.0904021753020.12916@localhost.localdomain> <1238689216.3099.34.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238689216.3099.34.camel@ht.satnam>
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


Jaswinder,

Let me transcribe what happened:

* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Thu, 2009-04-02 at 18:08 +0200, Thomas Gleixner wrote:
> > On Thu, 2 Apr 2009, Jaswinder Singh Rajput wrote:
> > > > > >  #ifdef CONFIG_DEBUG_SHIRQ
> > > > > > -	if (irqflags & IRQF_SHARED) {
> > > > > > +	if (!retval & (irqflags & IRQF_SHARED)) {
> > > > > >  		/*
> > > > > >  		 * It's a shared IRQ -- the driver ought to be prepared for it
> > > > > >  		 * to happen immediately, so let's make sure....
> > > > > 
> > > > > What is this ?

[ Jaswinder misunderstands a patch and asks a rather stupid question 
  in a demanding tone and does not go into any level of detail why 
  he thinks the patch is wrong. Just a single look into the source 
  code file in question would have shown him his mistake. ]

> > > > 
> > > > You looking at the wrong place.

[ Thomas, the genirq maintainer, points out Jaswinder's error 
  calmly. ]

> > > >  
> > > > > There is no retval:
> > > > > 
> > > > > http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=blob;f=kernel/irq/manage.c;h=a3eb7baf1e46f2c735edb4cc44e0386cfbc4989e;hb=HEAD
> > > > 
> > > > Care to read patches you want to comment on carefully _BEFORE_ you
> > > > start yelling at people and sending useless copies of the wrong
> > > > function around the world.
> > > > 
> > > > The patch is perfectly fine and already applied.

[ Thomas also asks Jaswinder to think things through before wasting 
  other people's time. ]

> > > > 
> > > 
> > > Yes, I know somehow you applied it. When you will merge this branch with
> > > -tip/master then you will understand what I am saying.

[ Jaswinder is being difficult: he writes that Thomas "somehow"
  applied the patch - ignoring the fact that Thomas is the 
  maintainer of this code.

  Jaswinder is also suggesting in a condescending tone that Thomas
  does not understand the issue - while the code is perfectly fine 
  and it is Jaswinder who is trivially wrong.

  Wasting more of Thomas's time. ]

> > Jaswinder. I really start to get annoyed. 
> > 

[ Thomas, understandably, being into the 4th mail of a thread that 
  should not have happened at all, is getting annoyed. ]

> > That patch applies fine on master as well.

[ Thomas points out another mistake in Jaswinder's argument. ]

> > > Even function name is changed from:
> > >
> > > 713 int request_irq(unsigned int irq, irq_handler_t handler,
> > > 
> > > 857 int request_threaded_irq(unsigned int irq, irq_handler_t handler,

[ Jaswinder shows evidence of even more stupidity: he points out to 
  Thomas that a function changed its name, forgetting two things: 
  that 1) it is irrelevant and 2) Thomas did the rename in question. ]

> > 
> > And why is this fcking relevant ? 

[ Thomas is really annoyed at Jaswinder writing wrong, 
  irrelevant, time wasting mails without showing any sign of 
  understanding the issues and without admitting fault. ]

> > 
> 
> I am dead sure, you really need some good manners and need to 
> learn many things.

[ Jaswinder, still not admitting his fault, compounds his mistakes
  by being even more condescending. ]

Jaswinder, this is really not an acceptable pattern of behavior on 
lkml.

	Ingo
