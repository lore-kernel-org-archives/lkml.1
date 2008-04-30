Return-Path: <linux-kernel-owner+w=401wt.eu-S1759629AbYEAMQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759629AbYEAMQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 08:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbYEAMPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 08:15:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53771 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbYEAMPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 08:15:52 -0400
Date: Wed, 30 Apr 2008 07:15:26 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: RFC: starting a kernel-testers group for newbies
Message-ID: <20080430071526.1bce202c@infradead.org>
In-Reply-To: <20080501011346.522f9846.akpm@linux-foundation.org>
References: <20080429.190352.137408408.davem@davemloft.net>
	<200804302136.58005.rjw@sisk.pl>
	<20080430131537.1f7a0914.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>
	<20080501003125.GM29330@cs181133002.pp.htv.fi>
	<20080430000338.50548884@infradead.org>
	<20080501011346.522f9846.akpm@linux-foundation.org>
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

On Thu, 1 May 2008 01:13:46 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 30 Apr 2008 00:03:38 -0700 Arjan van de Ven
> <arjan@infradead.org> wrote:
> 
> > > First of all:
> > > I 100% agree with Andrew that our biggest problems are in
> > > reviewing code and resolving bugs, not in finding bugs (we
> > > already have far too many unresolved bugs).
> > 
> > I would argue instead that we don't know which bugs to fix first.
> 
> <boggle>
> 
> How about "a bug which we just added"?  One which is repeatable. 
> Repeatable by a tester who is prepared to work with us on resolving
> it. Those bugs.
> 
> Rafael has a list of them.  We release kernels when that list still
> has tens of unfixed regressions dating back up to a couple of months.
> 


I know he does. But I will still argue that if that is all we work from, and treat
all of those equally, we're doing the wrong thing.
I'm sorry, but I really do not consider "ext4 doesn't compile on m68k" which is 
on that list to be as relevant as a "i915 drm driver crashes" bug which is among
us for a while and not on that list, just based on the total user base for either of those. 

Does that mean nobody should fix the m68k bug?
Someone who cares about m68k for sure should work on it, or if it's easy for an ext4 developer,
sure. But if the ext4 person has to spend 8 hours on it figuring cross compilers, I say 
we're doing something very wrong here. (no offense to the m68k people, but there's just
a few of you; maybe I should have picked voyager instead)

Maybe that's a "boggle" for you; but for me that's symptomatic of where we are today:
We don't make (effective) prioritization decisions. Such decisions are hard, because it 
effectively means telling people "I'm sorry but your bug is not yet important". That's
unpopular, especially if the reporter is very motivated on lkml. And it will involve a 
certain amount of non-quantifiable judgement calls, which also means we won't always be
right. Another hard thing is that lkml is a very self-selective audience. A bug may be 
reported three times there, but never hit otherwise, while another bug might not be reported
at all (or only once) while thousands and thousands of people are hitting it.

Not that we're doing all that bad, we ARE fixing the bugs (at least the oopses/warnings) that
are frequently hit. So I wouldn't blindly say we're doing a bad job at prioritizing. I would
rather say that if we focus only on what is left afterwards without doing a reality check,
we'll *always* have a negative view of quality, since there will *always* be bugs we don't 
fix. Linux well over ten million users (much more if you count embedded devices). 
A lot of them will have "standard" hardware, and a bunch of them will have "weird" stuff.
Cosmic rays happen. As do overclocking and bad DIMMs. And some BIOSes are just weird etc etc.
If we do not prioritize effectively we'll be stuck forever chasing ghosts, or we'll be stuck
saying "our quality sucks" forever without making progress.

Another trap is to only look at what goes wrong, not on what goes right... we tend to only
see what goes wrong on lkml and it's an easy trap to fall into doomthinking that way.
Are we doing worse on quality? My (subjective) opinion is that we are doing better than last year.
We are focused more on quality. We are fixing the bugs that people hit most. We are fixing most
of the regressions (yes, not all). Subsystems are seeing flat or lower bugcounts/bugrates. Take ACPI, 
the number of outstanding bugs *halved* over the last year. Of course you can pick a single 
bug and say "but this one did not get fixed", but that just loses the big picture (and 
proves the point :). All of this with a growing userbase and a rate of development that's a bit
faster than last year as well.

Can we do better? Always. More testing will help. Both to detect things early, and by 
letting us figure out which bugs are important. Just saying "more testing is not relevant
because we're not even fixing the bugs we have now" is just incorrect. Sorry.
More testers helps. Wider range of hardware/usages allows us to find better patterns
in the hard to track down bugs. More testers means more people willing to see if they
can diagnose the bugs at least somewhat themselves, via bisection or otherwise. That's important,
because that's the part of the problem that scales well with a growing userbase.
