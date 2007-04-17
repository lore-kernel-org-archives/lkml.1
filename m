Return-Path: <linux-kernel-owner+w=401wt.eu-S1753043AbXDQJJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbXDQJJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 05:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbXDQJJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 05:09:15 -0400
Received: from holomorphy.com ([66.93.40.71]:34147 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbXDQJJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 05:09:12 -0400
Date: Tue, 17 Apr 2007 02:05:38 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Davide Libenzi <davidel@xmailserver.org>, Nick Piggin <npiggin@suse.de>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070417090538.GU8915@holomorphy.com>
References: <46240F98.3020800@bigpond.net.au> <1176776941.6222.21.camel@Homer.simpson.net> <20070417034050.GD25513@wotan.suse.de> <46244A52.4000403@bigpond.net.au> <20070417042954.GG25513@wotan.suse.de> <20070417060955.GO8915@holomorphy.com> <20070417061503.GC1057@wotan.suse.de> <Pine.LNX.4.64.0704162317330.30516@alien.or.mcafeemobile.com> <20070417070949.GR8915@holomorphy.com> <20070417073308.GB30559@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417073308.GB30559@elte.hu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* William Lee Irwin III <wli@holomorphy.com> wrote:
>> The additive nice_offset breaks nice levels. A multiplicative priority 
>> weighting of a different, nonnegative metric of cpu utilization from 
>> what's now used is required for nice levels to work. I've been trying 
>> to point this out politely by strongly suggesting testing whether nice 
>> levels work.

On Tue, Apr 17, 2007 at 09:33:08AM +0200, Ingo Molnar wrote:
> granted, CFS's nice code is still incomplete, but you err quite 
> significantly with this extreme statement that they are "broken".

I used the word relatively loosely. Nothing extreme is going on.
Maybe the phrasing exaggerated the force of the opinion. I'm sorry
about having misspoke so.


On Tue, Apr 17, 2007 at 09:33:08AM +0200, Ingo Molnar wrote:
> nice levels certainly work to a fair degree even in the current code and 
> much of the focus is elsewhere - just try it. (In fact i claim that 
> CFS's nice levels often work _better_ than the mainline scheduler's nice 
> level support, for the testcases that matter to users.)

Al Boldi's testcase appears to reveal some issues. I'm plotting a
testcase of my own if I can ever get past responding to email.


On Tue, Apr 17, 2007 at 09:33:08AM +0200, Ingo Molnar wrote:
> The precise behavior of nice levels, as i pointed it out in previous 
> mails, is largely 'uninteresting' and it has changed multiple times in 
> the past 10 years.

I expect that whether a scheduler can handle such prioritization has a
rather strong predictive quality regarding whether it can handle, say,
CKRM controls. I remain convinced that there should be some target
behavior and that some attempt should be made to achieve it. I don't
think any particular behavior is best, just that the behavior should
be well-defined.


On Tue, Apr 17, 2007 at 09:33:08AM +0200, Ingo Molnar wrote:
> What matters to users is mainly: whether X reniced to -10 does get 
> enough CPU time and whether stuff reniced to +19 doesnt take away too 
> much CPU time from the rest of the system. _How_ a Linux scheduler 
> achieves this is an internal matter and certainly CFS does it in a hacky 
> way at the moment.

It's not so far out. Basically just changing the key calculation in a
relatively simple manner should get things into relatively good shape.
It can, of course, be done other ways (I did it a rather different way
in vdls, though that method is not likely to be considered desirable).

I can't really write a testcase for such loose semantics, so the above
description is useless to me. These squishy sorts of definitions of
semantics are also uninformative to users, who, I would argue, do have
some interest in what nice levels mean. There have been at least a small
number of concerns about the strength of nice levels, and it would
reveal issues surrounding that area earlier if there were an objective
one could test to see if it were achieved.

It's furthermore a user-visible change in system call semantics we
should be more careful about changing out from beneath users.

So I see a lot of good reasons to pin down nice numbers. Incompleteness
is not a particularly mortal sin, but the proliferation of competing
schedulers is creating a need for standards, and that's what I'm really
on about.


On Tue, Apr 17, 2007 at 09:33:08AM +0200, Ingo Molnar wrote:
> All the rest, 'CPU bandwidth utilization' or whatever abstract metric we 
> could come up with is just a fancy academic technicality that has no 
> real significance to any of the testers who are trying CFS right now.

I could say "percent cpu" if it sounds less like formal jargon, which
"CPU bandwidth utilization" isn't really.


On Tue, Apr 17, 2007 at 09:33:08AM +0200, Ingo Molnar wrote:
> Sure we prefer final solutions that are clean and make sense (because 
> such things are the easiest to maintain long-term), and often such final 
> solutions are quite close to academic concepts, and i think Davide 
> correctly observed this by saying that "the final key calculation code 
> will end up quite different from what it looks now", but your 
> extreme-end claim of 'breakage' for something that is just plain 
> incomplete is not really a fair characterisation at this point.

It wasn't meant to be quite as strong a statement as it came out.
Sorry about that.


On Tue, Apr 17, 2007 at 09:33:08AM +0200, Ingo Molnar wrote:
> Anyone who thinks that there exists only two kinds of code: 100% correct 
> and 100% incorrect with no shades of grey inbetween is in reality a sort 
> of an extremist: whom, depending on mood and affection, we could call 
> either a 'coding purist' or a 'coding taliban' ;-)

I've made no such claims. Also rest assured that the tone of the
critique is not hostile, and wasn't meant to sound that way.

Also, given the general comments it appears clear that some statistical
metric of deviation from the intended behavior furthermore qualified by
timescale is necessary, so this appears to be headed toward a sort of
performance metric as opposed to a pass/fail test anyway. However, to
even measure this at all, some statement of intention is required. I'd
prefer that there be a Linux-standard semantics for nice so results are
more directly comparable and so that users also get similar nice
behavior from the scheduler as it varies over time and possibly
implementations if users should care to switch them out with some
scheduler patch or other.


-- wli
