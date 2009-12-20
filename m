Return-Path: <linux-kernel-owner+w=401wt.eu-S1755652AbZLTRug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbZLTRug (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 12:50:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755480AbZLTRuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 12:50:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52243 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755472AbZLTRue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 12:50:34 -0500
Date: Sun, 20 Dec 2009 18:50:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Joe Perches <joe@perches.com>, San Mehat <san@google.com>,
       Arjan van de Ven <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: sched: restore sanity
Message-ID: <20091220175019.GA19472@elte.hu>
References: <1261315437.4314.6.camel@laptop>
 <20091220144925.GA19608@elte.hu>
 <1261320715.4314.9.camel@laptop>
 <236ccac0912200703g464912b1r421497ebf3b6ebc6@mail.gmail.com>
 <236ccac0912200705i369d00d1v42603a00e92039b6@mail.gmail.com>
 <1261322387.4314.22.camel@laptop>
 <1261329743.30458.179.camel@Joe-Laptop.home>
 <1261330592.4314.36.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261330592.4314.36.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Sun, 2009-12-20 at 09:22 -0800, Joe Perches wrote:
> > On Sun, 2009-12-20 at 16:19 +0100, Peter Zijlstra wrote:
> > > On Sun, 2009-12-20 at 07:05 -0800, San Mehat wrote:
> > > > >> Probably, but the rest is just as annoying, pr_* is crap.
> > > > Oh? Out of curiosity whats wrong with it?
> > > That's what should be asked of printk().
> > 
> > pr_<level> offers some things printk cannot:
> > 
> > o standardization, eliminates frequent missing KERN_ levels
> >   and missing/typo/misspelled module prefixes  
> 
> There's other ways of fixing that, one way is to make it a proper
> function argument, like:
> 
> printk(char level, char *fmt, ...);
> 
> Which is something we have precedent for too in fprintf() and syslog().
> 
> > o visually shorter, fewer chars used, less 80 char wrapping
> 
> Fuck me senseless, visually less obvious too.
> 
> > o finer grained ability to eliminate unnecessary messages
> >   for embedded systems
> 
> How is that not possible with another solution.
> 
> > o standardized mechanism to prefix messages with module/function
> 
> Who fucking gives a shit, that is the very thing that made me send the
> revert.
> 
> > o eventual code reduction via use of a singleton instead of
> >   duplicated module/function names
> 
> text reduction?
> 
> > o eventual dynamic_debug styled control of prefix by
> >   module/function
> 
> Feh, who cares, printk output simply shouldn't be frequent enough to
> need filtering, there's much better solutions for that.
> 
> > There are quite of number of arbitrarily named module wrapper
> > macros and functions that build on printk.
> 
> Then remove them all..
> 
> Are you really arguing to fully deprecate printk()? If not this is all
> going to be useless since I'll simply keep using printk().

I dont mind that strongly but you (and Mike) objecting to it so forcefully 
clearly tips the balance against the pr_*() lines in sched.c so i've queued up 
your revert in the scheduler tree.

( I've Cc:-ed Linus and Andrew, in case they care one way or another. )

Thanks,

	Ingo
