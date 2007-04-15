Return-Path: <linux-kernel-owner+w=401wt.eu-S1752914AbXDOMq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbXDOMq0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 08:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752930AbXDOMq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 08:46:26 -0400
Received: from 1wt.eu ([62.212.114.60]:1930 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbXDOMqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 08:46:25 -0400
Date: Sun, 15 Apr 2007 14:45:27 +0200
From: Willy Tarreau <w@1wt.eu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: hui Bill Huey <billh@gnuppy.monkey.org>, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Peter Williams <pwil3058@bigpond.net.au>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070415124527.GP943@1wt.eu>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <20070415051645.GA28438@gnuppy.monkey.org> <20070415084447.GC24886@elte.hu> <20070415095146.GA30327@gnuppy.monkey.org> <84144f020704150339i4a0d437fja6868ab671558ba1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020704150339i4a0d437fja6868ab671558ba1@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2007 at 01:39:27PM +0300, Pekka Enberg wrote:
> On 4/15/07, hui Bill Huey <billh@gnuppy.monkey.org> wrote:
> >The perception here is that there is that there is this expectation that
> >sections of the Linux kernel are intentionally "churn squated" to prevent
> >any other ideas from creeping in other than of the owner of that subsytem
> 
> Strangely enough, my perception is that Ingo is simply trying to
> address the issues Mike's testing discovered in RDSL and SD. It's not
> surprising Ingo made it a separate patch set as Con has repeatedly
> stated that the "problems" are in fact by design and won't be fixed.

That's not exactly the problem. There are people who work very hard to
try to improve some areas of the kernel. They progress slowly, and
acquire more and more skills. Sometimes they feel like they need to
change some concepts and propose those changes which are required for
them to go further, or to develop faster. Those are rejected. So they
are constrained to work in a delimited perimeter from which it is
difficult for them to escape.

Then, the same person who rejected their changes comes with something
shiny new, better and which took him far less time. But he sort of
broke the rules because what was forbidden to the first persons is
suddenly permitted. Maybe for very good reasons, I'm not discussing
that. The good reason should have been valid the first time too.

The fact is that when changes are rejected, we should not simply say
"no", but explain why and define what would be acceptable. Some people
here have excellent teaching skills for this, but most others do not.
Anyway, the rules should be the same for everybody.

Also, there is what can be perceived as marketting here. Con worked
on his idea with convictions, he took time to write some generous
documentation, but he hit a wall where his concept was suboptimal on
a given workload. But at least, all the work was oriented on a technical
basis : design + code + doc.

Then, Ingo comes in with something looking amazingly better, with
virtually no documentation, an appealing announcement, and a shiny
advertising at boot. All this implemented without the constraints
other people had to respect. It already looks like definitive work
which will be merge as-is without many changes except a few bugfixes.

If those were two companies, the first one would simply have accused
the second one of not having respected contracts and having employed
heaving marketting to take the first place.

People here do not code for a living, they do it at least because they
believe in what they are doing, and some of them want a bit of gratitude
for their work. I've met people who were proud to say they implement
this or that feature in the kernel, so it is something important for
them. And being cited in an email is nothing compared to advertising
at boot time.

When the discussion was blocked between Con and Mike concerning the
design problems, it is where a new discussion should have taken place.
Ingo could have publicly spoken with them about his ideas of killing
the O(1) scheduler and replacing it with an rbtree-based one, and using
part of Bill's work to speed up development.

It is far easier to resign when people explain what concepts are wrong
and how they think they will do than when they suddenly present something
out of nowhere which is already better.

And it's not specific to Ingo (though I think his ability to work that
fast alone makes him tend to practise this more often than others).

Imagine if Con had worked another full week on his scheduler with better
results on Mike's workload, but still not as good as Ingo's, and they both
published at the same time. You certainly can imagine he would have preferred
to be informed first that it was pointless to continue in that direction.

Now I hope he and Bill will get over this and accept to work on improving
this scheduler, because I really find it smarter than a dumb O(1). I even
agree with Mike that we now have a solid basis for future work. But for
this, maybe a good starting point would be to remove the selfish printk
at boot, revert useless changes (SCHED_NORMAL->SCHED_FAIR come to mind)
and improve the documentation a bit so that people can work together on
the new design, without feeling like their work will only server to
promote X or Y.

Regards,
Willy

