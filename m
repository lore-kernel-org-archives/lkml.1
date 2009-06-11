Return-Path: <linux-kernel-owner+w=401wt.eu-S1760172AbZFKVOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760172AbZFKVOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 17:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbZFKVO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 17:14:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48549 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319AbZFKVO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 17:14:27 -0400
Date: Thu, 11 Jun 2009 23:14:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Bligh <mbligh@google.com>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Al Viro <viro@zeniv.linux.org.uk>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
Message-ID: <20090611211408.GA6415@elte.hu>
References: <20090611161714.GA5008@infradead.org> <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain> <20090611165226.GV8633@ZenIV.linux.org.uk> <1244739378.6691.540.camel@laptop> <20090611170015.GA3651@infradead.org> <alpine.LFD.2.01.0906111005020.3573@localhost.localdomain> <33307c790906111124m17e57332oc38c89fa70e39231@mail.gmail.com> <alpine.LFD.2.01.0906111127520.3573@localhost.localdomain> <20090611202341.GA23590@elte.hu> <1244753357.27363.82.camel@violet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244753357.27363.82.camel@violet>
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


* Marcel Holtmann <marcel@holtmann.org> wrote:

> Hi Ingo,
> 
> > > What the "keep it in the kernel sources" approach hopefully allows is
> > > 
> > >  - taking advantage of new features in a timely manner.
> > > 
> > >    NOT with some ABI breakage, but simply things like supporting a 
> > >    new CPU architecture or new counters. The thing that oprofile 
> > >    failed at so badly in my experience.
> > >
> > >  - Make it easier for developers, and _avoiding_ the horrible 
> > >    situation where you have two different groups that don't talk 
> > >    well to each other because one is a group of user-space 
> > >    weenies, and the other is a group of manly kernel people, and 
> > >    there is no common ground.
> > 
> > Yes, very much agreed.
> > 
> > Btw., here are a couple of other arguments why i find it useful to 
> > have the tools/perf/ in the kernel repo:
> > 
> > 1) Super-fast and synchronized release cycles
> > 
> > The kernel is one of the fastest moving packages in Linux - most 
> > user-space packages have (much!) longer release cycles than 3 
> > months.
> 
> that might be true for some projects, but for others this is 
> wrong. You are just making an assumption out of thin air.
> 
> > A tight release schedule forces a certain amount of release 
> > discipline on tooling as well - so i'm glad that the two will be 
> > coupled. It's so easy for a promising tool to degrade into 
> > tinkerware with odd release cycles with time - if it's part of 
> > the kernel then at least the release cycles wont be odd but at 
> > precise 3 months.
> 
> And you can't do that within a perf.git tree on kernel.org 
> because?

We actually tried the tools as separate code, and for the first 
three months of the project we only got three contributions - while 
the kernel code was essentially finished. (Pekka reported a similar 
experience in this thread, with another tool that has close kernel 
ties.)

Once we moved it into the same repo as the kernel code (three months 
ago), the patches started flowing in - at an amazing rate. We now 
have a dozen contributors, most of them kernel developers, and we 
have over a hundred good changes to the tools - in just another 3 
months.

The key difference was the location of the tools. It is very 
convenient and productive to have a shared repository for a project 
that frequently involves both kernel and tool changes.

So my point is: this model clearly works in practice and all the 
current tools/perf/ contributors like this kind of coding 
environment.

Most of your arguments seem to center around the notion that it 
could all be done in a separate repo too and that such a repo could 
be run as well as the Linux kernel. If you think you could do it 
even better in a separate repo you are certainly free to try it.

	Ingo
