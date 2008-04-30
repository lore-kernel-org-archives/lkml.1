Return-Path: <linux-kernel-owner+w=401wt.eu-S1758711AbYEAMVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711AbYEAMVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 08:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbYEAMVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 08:21:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39237 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbYEAMVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 08:21:05 -0400
Date: Wed, 30 Apr 2008 07:20:13 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: RFC: starting a kernel-testers group for newbies
Message-ID: <20080430072013.7c3b30b1@infradead.org>
In-Reply-To: <20080501113038.GW29330@cs181133002.pp.htv.fi>
References: <20080429.190352.137408408.davem@davemloft.net>
	<200804302136.58005.rjw@sisk.pl>
	<20080430131537.1f7a0914.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>
	<20080501003125.GM29330@cs181133002.pp.htv.fi>
	<20080430000338.50548884@infradead.org>
	<20080501113038.GW29330@cs181133002.pp.htv.fi>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008 14:30:38 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> On Wed, Apr 30, 2008 at 12:03:38AM -0700, Arjan van de Ven wrote:
> > On Thu, 1 May 2008 03:31:25 +0300
> > Adrian Bunk <bunk@kernel.org> wrote:
> > 
> > > On Wed, Apr 30, 2008 at 01:31:08PM -0700, Linus Torvalds wrote:
> > > > 
> > > > 
> > > > On Wed, 30 Apr 2008, Andrew Morton wrote:
> > > > > 
> > > > > <jumps up and down>
> > > > > 
> > > > > There should be nothing in 2.6.x-rc1 which wasn't in
> > > > > 2.6.x-mm1!
> > > > 
> > > > The problem I see with both -mm and linux-next is that they
> > > > tend to be better at finding the "physical conflict" kind of
> > > > issues (ie the merge itself fails) than the "code looks ok but
> > > > doesn't actually work" kind of issue.
> > > > 
> > > > Why?
> > > > 
> > > > The tester base is simply too small.
> > > > 
> > > > Now, if *that* could be improved, that would be wonderful, but
> > > > I'm not seeing it as very likely.
> > > > 
> > > > I think we have fairly good penetration these days with the
> > > > regular -git tree, but I think that one is quite frankly a
> > > > *lot* less scary than -mm or -next are, and there it has been
> > > > an absolutely huge boon to get the kernel into the Fedora
> > > > test-builds etc (and I _think_ Ubuntu and SuSE also started
> > > > something like that).
> > > > 
> > > > So I'm very pessimistic about getting a lot of test coverage
> > > > before -rc1.
> > > > 
> > > > Maybe too pessimistic, who knows?
> > > 
> > > First of all:
> > > I 100% agree with Andrew that our biggest problems are in
> > > reviewing code and resolving bugs, not in finding bugs (we
> > > already have far too many unresolved bugs).
> > 
> > I would argue instead that we don't know which bugs to fix first.
> > We're never going to fix all bugs, and to be honest, that's ok.
> >...
> 
> That might be OK.
> 
> But our current status quo is not OK:
> 
> Check Rafael's regressions lists asking yourself
> "How many regressions are older than two weeks?" 

"ext4 doesn't compile on m68k".
YAWN.

Wrong question...
"How many bugs that a sizable portion of users will hit in reality are there?"
is the right question to ask...


> 
> We have unmaintained and de facto unmaintained parts of the kernel
> where even issues that might be easy to fix don't get fixed.

And how many people are hitting those issues? If a part of the kernel is really
important to enough people, there tends to be someone who stands up to either fix
the issue or start de-facto maintaining that part.
And yes I know there's parts where that doesn't hold. But to be honest, there's
not that many of them that have active development (and thus get the biggest
share of regressions)

> 
> >...
> > So there's a few things we (and you / janitors) can do over time to
> > get better data on what issues people hit: 
> > 1) Get automated collection of issues more wide spread. The wider
> > our net the better we know which issues get hit a lot, and plain
> > the more data we have on when things start, when they stop, etc
> > etc. Especially if you get a lot of testers in your project, I'd
> > like them to install the client for easy reporting of issues. 2) We
> > should add more WARN_ON()s on "known bad" conditions. If it
> > WARN_ON()'s, we can learn about it via the automated collection.
> > And we can then do the statistics to figure out which ones happen a
> > lot. 3) We need to get persistent-across-reboot oops saving going;
> > there's some venues for this
> 
> No disagreement on this, its just a different issue than our bug
> fixing problem.

No it's not! Knowing earlier and better which bugs get hit is NOT different
to our bug fixing "problem", it's in fact an essential part to the solution of it!

> 
