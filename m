Return-Path: <linux-kernel-owner+w=401wt.eu-S1030581AbXDPNqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030581AbXDPNqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 09:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbXDPNqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 09:46:15 -0400
Received: from holomorphy.com ([66.93.40.71]:43997 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795AbXDPNqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 09:46:14 -0400
Date: Mon, 16 Apr 2007 06:46:02 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Willy Tarreau <w@1wt.eu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jiri Slaby <jirislaby@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070416134602.GJ8915@holomorphy.com>
References: <m1647yn956.fsf@ebiederm.dsl.xmission.com> <20070414175433.GA17527@elte.hu> <20070414181854.GA5826@1wt.eu> <20070415175555.GA28524@elte.hu> <20070415180604.GA550@1wt.eu> <20070415192046.GA7504@elte.hu> <20070415193531.GD2986@holomorphy.com> <20070415195748.GA16004@elte.hu> <20070415235421.GF2986@holomorphy.com> <20070416112440.GA20014@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070416112440.GA20014@elte.hu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* William Lee Irwin III <wli@holomorphy.com> wrote:
>> Worse comes to worse I might actually get around to doing it myself. 
>> Any more detailed descriptions of the test for a rainy day?

On Mon, Apr 16, 2007 at 01:24:40PM +0200, Ingo Molnar wrote:
> the main complication here is that the handling of nice levels is still 
> typically a 2nd or 3rd degree design factor when writing schedulers. The 
> reason isnt carelessness, the reason is simply that users typically only 
> care about a single nice level: the one that all tasks run under by 
> default.

I'm a bit unconvinced here. Support for prioritization is a major
scheduler feature IMHO.


On Mon, Apr 16, 2007 at 01:24:40PM +0200, Ingo Molnar wrote:
> Also, often there's just one or two good ways to attack the problem 
> within a given scheduler approach and the quality of nice levels often 
> suffers under other, more important design factors like performance.
> This means that for example for the vanilla scheduler the distribution 
> of CPU power depends on HZ, on the number of tasks and on the scheduling 
> pattern. The distribution of CPU power amongst nice levels is basically 
> a function of _everything_. That makes any automated test pretty 
> challenging. Both with SD and with CFS there's a good chance to actually 
> formalize the meaning of nice levels, but i'd not go as far as to 
> mandate any particular behavior by rigidly saying "pass this automated 
> tool, else ...", other than "make nice levels resonable". All the other 
> more formal CPU resource limitation techniques are then a matter of 
> CKRM-alike patches, which offer much more finegrained mechanisms than 
> pure nice levels anyway.

Some of the issues with respect to the number of tasks and scheduling
patterns can be made part of the test; one can furthermore insist that
the system be quiescent in a variety of ways. I'm not convinced that
formalization of nice levels is a bad idea. They're the standard UNIX
prioritization facility, and it should work with some definite value
of "work."

Even supposing one doesn't care to bolt down the semantics of nice
levels, there should at least be some awareness of what those semantics
are and when and how they're changing. So in that respect a test for
CPU bandwidth distribution according to nice level remains valuable
even supposing that the semantics aren't required to be rigidly fixed.

As far as CKRM goes, I'm wild about it. I wish things would get in
shape to be merged (if they're not already) and merged ASAP on that
front. I think with so much agreement in concept we can work with
changing out implementations as-needed with it sitting in mainline once
the the user API/ABI is decided upon, and I think it already is.

I'm not entirely convinced CKRM answers this, though. If the scheduler
can't support nice levels, how is it supposed to support prioritization
or CPU bandwidth allocation according to CKRM configurations? I'm
relatively certain schedulers must be able to support prioritization
with deterministic CPU bandwidth as essential functionality. This is,
of course, not to say my certainty about things sets the standards for
what testcases are considered meaningful and valid.


On Mon, Apr 16, 2007 at 01:24:40PM +0200, Ingo Molnar wrote:
> so to answer your question: it's pretty much freely defined. Make up 
> your mind about it and figure out the ways how people use nice levels 
> and think about which aspects of that experience are worth testing for 
> intelligently.

Looking for usage cases is a good idea; I'll do that before coding any
testcase for nice semantics.


-- wli
