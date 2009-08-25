Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbZHYLdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbZHYLdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 07:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbZHYLdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 07:33:08 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:43259 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbZHYLdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 07:33:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19091.52205.222449.441072@cargo.ozlabs.ibm.com>
Date: Tue, 25 Aug 2009 21:33:01 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, dwalker@fifo99.com,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/core] timekeeping: Increase granularity of
	read_persistent_clock()
In-Reply-To: <20090825101742.GA26801@elte.hu>
References: <20090822103252.GA32369@elte.hu>
	<20090822171540.1220f50d@skybase>
	<20090822153346.GA3313@elte.hu>
	<19088.47213.327897.703458@cargo.ozlabs.ibm.com>
	<20090823084740.GA7651@elte.hu>
	<19090.1800.521794.839576@cargo.ozlabs.ibm.com>
	<20090824082318.GD2424@elte.hu>
	<19091.24374.210127.155521@drongo.ozlabs.ibm.com>
	<20090825082612.GA17692@elte.hu>
	<19091.46451.893720.573893@cargo.ozlabs.ibm.com>
	<20090825101742.GA26801@elte.hu>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> * Paul Mackerras <paulus@samba.org> wrote:
> 
> > Ingo Molnar writes:
> > 
> > > If you suggest that each and every subsystem maintainer who 
> > > touches code that can be built on non-x86 architectures has to 
> > > cross-build to 20+ architectures to be able to push out a tree, 
> > > all the time, and has to rebase if this ever gets omitted, you 
> > > are really defying reality and are hurting Linux.
> > 
> > Nice straw man, but I never said or even suggested anything like 
> > that. :)
> 
> ... but what you say in essence amounts to that. Every change to a 
> file that is built on an architecture 'affects' that architecture so 
> your arguments can be repeated for that one. It's a slippery slope 
> built on a wrong premise.

Not at all.  I'm saying that committing code, some of which has never
ever been compiled on any architecture, is just sloppy.  It's basic
good engineering practice to have at least compiled the code you're
committing - at least once on at least one architecture.  It's like
making changes inside #ifdef CONFIG_FOO but never testing with
CONFIG_FOO turned on.  You'd complain, and rightly, if someone did
that.

> I can only repeat what i said because i did not see you really 
> counter the core of my argument (you snipped out much of my mail 
> that details this and only replied to the last paragraph):

Well, though much of what you said is true, in the end it seems to
boil down to saying that non-x86 architectures don't have any right to
expect any degree of care or attention from you, because only x86 is
important.  And of course you have a perfect right to pay attention to
whatever you find interesting and ignore anything else, including
difficulties that you cause along the way for other kernel developers.

There doesn't seem to be any useful response to that.

> Say that patch also touches arch/xtensa/. Can you cross-build to 
> xtensa?

Sure, I just ask Michael Ellerman to point kisskb at a tree with my
proposed patch in it.

> > Patches which touch multiple architecture's arch-specific code 
> > should also get sent to the maintainers of the affected 
> > architectures and the linux-arch mailing list.  I don't recall 
> > seeing this patch on linux-arch, though I may have missed it (and 
> > anyway that would be Martin's responsibility not yours, but it 
> > does contribute to the sense of being blindsided).
> > 
> > More generally - if you don't have the resources to do regular 
> > build testing for powerpc or other architectures, then publish a 
> > testing branch and we'll get kisskb 
> > (http://kisskb.ellerman.id.au/) to build a selection of configs 
> > and architectures automatically.
> 
> Slowing down patches via buerocracy like that is not acceptable at 
> all. Make developers care more about your architecture via natural 
> means, not via buerocratic measures.

The "should" in what I said is just good manners, not bureaucracy.

The stuff about kisskb was an offer to help, not bureaucracy.
No-one's forcing you to do anything.

Paul.
