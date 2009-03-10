Return-Path: <linux-kernel-owner+w=401wt.eu-S1756703AbZCJPd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbZCJPd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 11:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756510AbZCJPdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 11:33:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43317 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691AbZCJPds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 11:33:48 -0400
Date: Tue, 10 Mar 2009 16:33:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       lethal@linux-sh.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Free setup_irq() interrupt V2
Message-ID: <20090310153332.GB23463@elte.hu>
References: <20090310102459.23422.80761.sendpatchset@rx1.opensource.se> <alpine.LFD.2.00.0903101510040.29264@localhost.localdomain> <20090310150415.GL3850@elte.hu> <alpine.LFD.2.00.0903101615540.29264@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903101615540.29264@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Tue, 10 Mar 2009, Ingo Molnar wrote:
> > * Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> > > Magnus,
> > > 
> > > On Tue, 10 Mar 2009, Magnus Damm wrote:
> > > > From: Magnus Damm <damm@igel.co.jp>
> > > > This patch adds a __free_irq() function for releasing 
> > > > interrupts requested with setup_irq().
> > > 
> > > I think there is a simpler solution than adding yet another 
> > > function for the confusion of driver writers. See below.
> > 
> > Uhm, i asked for that solution ;-) 
> 
> Uhm, I missed that :) 
> 
> > To reduce the confusion in generic code with yet another IRQF flag.
> 
> Hmm. I still prefer a solution which confuses the few people hacking
> on kernel/irq/* instead of having another function which confuses the
> already confused driver writers.
> 
> I can live with the two functions as well, but then please let us use
> a function name which is more intuitive than __free_irq().
> 
> setup_irq()   -> remove_irq()
> request_irq() -> free_irq()

Sure, that's fine with me.

I almost suggested shutdown_irq() to Magnus originally, then 
went for __free_irq().

	Ingo
