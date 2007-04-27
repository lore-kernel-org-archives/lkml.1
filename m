Return-Path: <linux-kernel-owner+w=401wt.eu-S1755656AbXD0Lyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbXD0Lyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 07:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755653AbXD0Lyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 07:54:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47729 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755654AbXD0Lyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 07:54:52 -0400
Date: Fri, 27 Apr 2007 13:53:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Mark Lord <lkml@rtr.ca>,
       Zach Carter <linux@zachcarter.com>, buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070427115344.GA30706@elte.hu>
References: <20070425214704.GA32572@elte.hu> <1177596399.14496.1.camel@localhost> <200704261041.04838.gene.heskett@gmail.com> <1177618164.14496.5.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177618164.14496.5.camel@localhost>
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


* Kasper Sandberg <lkml@metanurb.dk> wrote:

> > Compared to mainline?  I still think this is a 100% keeper for 
> > desktop users like me.
> 
> Here its alot worse, just playing an ogg with ogg123 even without 
> anything reniced (X is 0), just pressing a link in konqueror can make 
> audio skip (ogg123 fails to fill the alsa buffer, and thus it skips).

update for lkml readers: this is some really 'catastrophic' condition 
triggering on your box. Here ogg123 just never skips on an older 750 MHz 
box, which is 4-5 times slower than your 2GHz box - while i have _fourty 
nice-0 infinite loops_ running. I.e. at this clearly ridiculous load, at 
just 2.5% of CPU time ogg123 is just chugging along nicely and never 
leaves out a beat.

i'll try to figure out what is happening on your box. I asked for your 
.config off-list (which you already sent me) and i'll try to reproduce 
your problems. One thing i noticed: when ogg123 plays with 'esd' also 
running on the system, it starts skipping really badly - but it does so 
under all schedulers i tried (cfs, sd, vanilla).

	Ingo
