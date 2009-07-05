Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbZGEIGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbZGEIGO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 04:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbZGEIFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 04:05:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55472 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534AbZGEIFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 04:05:50 -0400
Date: Sun, 5 Jul 2009 10:04:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 4/6 -tip] perf_counter: Add Generalized Hardware
	interrupt support for AMD
Message-ID: <20090705080459.GA11636@elte.hu>
References: <1246440909.3403.5.camel@hpdv5.satnam> <1246440977.3403.7.camel@hpdv5.satnam> <1246441043.3403.9.camel@hpdv5.satnam> <1246441094.3403.10.camel@hpdv5.satnam> <20090701112406.GE15958@elte.hu> <1246622515.2322.30.camel@jaswinder.satnam> <20090704102230.GE2139@elte.hu> <1246717039.2329.26.camel@jaswinder.satnam> <20090705011123.GA31673@elte.hu> <1246768166.2325.8.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246768166.2325.8.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Sun, 2009-07-05 at 03:11 +0200, Ingo Molnar wrote:
> > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > 
> > > On Sat, 2009-07-04 at 12:22 +0200, Ingo Molnar wrote:
> > > > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > > > 
> > > > > On Wed, 2009-07-01 at 13:24 +0200, Ingo Molnar wrote:
> > > > > > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > > > > > 
> > > > > > > 
> > > > > > > $ ./perf stat -e interrupts -e masked -e int-pending-mask-cycles -- ls -lR /usr/include/ > /dev/null
> > > > > > > 
> > > > > > >  Performance counter stats for 'ls -lR /usr/include/':
> > > > > > > 
> > > > > > >             377  interrupts
> > > > > > >        53429936  int-mask-cycles
> > > > > > >            1119  int-pending-mask-cycles
> > > > > > > 
> > > > > > >     0.371457539  seconds time elapsed
> > > > > > 
> > > > > > Agreed, this is another useful generalization - and the 'cycles 
> > > > > > pending' metrics are not retrievable via any software means.
> > > > > > 
> > > > > > We could and should probably add a software counter for hardirqs 
> > > > > > as wel. That would allow the vector/irqnr information to be 
> > > > > > passed in, and it would allow architectures without irq metrics 
> > > > > > in the PMU to have this counter too.
> > > > > > 
> > > > > 
> > > > > Please let me know that addition of software counter will be 
> > > > > in this patch or we can do it incrementally after this patch.
> > > > 
> > > > It should be in this series. That way we can cross-check whether 
> > > > the soft counts and the hard counts match up and find potential 
> > > > bugs that way, etc.
> > > > 
> > > 
> > > You want to cross check performance counter events ?
> > 
> > Yes. The events are also more complete if we add per IRQ source 
> > counts as well, not just summary counts.
> 
> If you ask me about 'complete', I will say : "No-one is 'complete' 
> except God".
> 
> Let me know what you mean by 'complete' and 'more complete'.
> 
> This is a hardware performance interrupt event patch. If you want 
> to add IRQ source, of course you can add it in another patch, it 
> is a never ending task.
> 
> I do not understand why you behave like this :
> 
> 1. Is today the last day of the creation.
> 2. Or you will not collect any further patches.
> 
> Of course answer is "no" then what is the problem with you.
> 
> Stop this complete-ness madness. You will never complete atleast 
> in this life no matter what you will do.

I'm simply not going to apply patches from you for what i consider a 
half-done feature.

	Ingo
