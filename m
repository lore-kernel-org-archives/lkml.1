Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbZLTR5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbZLTR5U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 12:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755687AbZLTR5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 12:57:19 -0500
Received: from mail.perches.com ([173.55.12.10]:1325 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755422AbZLTR5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 12:57:18 -0500
Subject: Re: sched: restore sanity
From: Joe Perches <joe@perches.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: San Mehat <san@google.com>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1261330592.4314.36.camel@laptop>
References: <1261315437.4314.6.camel@laptop>
	 <20091220144925.GA19608@elte.hu> <1261320715.4314.9.camel@laptop>
	 <236ccac0912200703g464912b1r421497ebf3b6ebc6@mail.gmail.com>
	 <236ccac0912200705i369d00d1v42603a00e92039b6@mail.gmail.com>
	 <1261322387.4314.22.camel@laptop>
	 <1261329743.30458.179.camel@Joe-Laptop.home>
	 <1261330592.4314.36.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Dec 2009 09:57:17 -0800
Message-ID: <1261331837.30458.200.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-20 at 18:36 +0100, Peter Zijlstra wrote:
> On Sun, 2009-12-20 at 09:22 -0800, Joe Perches wrote:
> > On Sun, 2009-12-20 at 16:19 +0100, Peter Zijlstra wrote:
> > > On Sun, 2009-12-20 at 07:05 -0800, San Mehat wrote:
> > > > >> Probably, but the rest is just as annoying, pr_* is crap.
> > > > Oh? Out of curiosity whats wrong with it?
> > > That's what should be asked of printk().
> > pr_<level> offers some things printk cannot:
> > o standardization, eliminates frequent missing KERN_ levels
> >   and missing/typo/misspelled module prefixes  
> printk(char level, char *fmt, ...);

A change that's not possible without breaking the build of
one rather large body of code.

> Which is something we have precedent for too in fprintf() and syslog().

Huh?  Did that break builds?

> > o finer grained ability to eliminate unnecessary messages
> >   for embedded systems
> How is that not possible with another solution.

printk is not selective.  printk always compiles all
messages, pr_debug eliminates to nothing without DEBUG.
Similar mechanisms are possible for arbitrary pr_<level>.

> > o standardized mechanism to prefix messages with module/function
> Who fucking gives a shit

Apparently the people that prefix.

There are an awful lot of printks with __func__ or
embedded typed function names that I think are senseless.

I think it'd be much more sensible to have some
per module_printk_flags field that controlled whether
or not module/function/line was emitted.

I'm trying to get rid of them slowly and generically.

> > o eventual code reduction via use of a singleton instead of
> >   duplicated module/function names
> text reduction?

Yes.

> > o eventual dynamic_debug styled control of prefix by
> >   module/function
> Feh, who cares, printk output simply shouldn't be frequent enough to
> need filtering, there's much better solutions for that.

You could name those solutions.

> > There are quite of number of arbitrarily named module wrapper
> > macros and functions that build on printk.
> Then remove them all..
> Are you really arguing to fully deprecate printk()?

I think pr_<level> is a better use.
It's too early to deprecate printk though.

> If not this is all
> going to be useless since I'll simply keep using printk().

I didn't suggest you shouldn't.  Use what works for you.

