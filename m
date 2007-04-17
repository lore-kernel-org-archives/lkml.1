Return-Path: <linux-kernel-owner+w=401wt.eu-S1752318AbXDQHkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbXDQHkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 03:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbXDQHkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 03:40:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:52801 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318AbXDQHkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 03:40:22 -0400
Date: Tue, 17 Apr 2007 09:40:21 +0200
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: William Lee Irwin III <wli@holomorphy.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070417074021.GB20026@wotan.suse.de>
References: <46240F98.3020800@bigpond.net.au> <1176776941.6222.21.camel@Homer.simpson.net> <20070417034050.GD25513@wotan.suse.de> <46244A52.4000403@bigpond.net.au> <20070417042954.GG25513@wotan.suse.de> <20070417060955.GO8915@holomorphy.com> <20070417061503.GC1057@wotan.suse.de> <Pine.LNX.4.64.0704162317330.30516@alien.or.mcafeemobile.com> <20070417070949.GR8915@holomorphy.com> <20070417073308.GB30559@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417073308.GB30559@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 09:33:08AM +0200, Ingo Molnar wrote:
> 
> * William Lee Irwin III <wli@holomorphy.com> wrote:
> 
> > On Mon, Apr 16, 2007 at 11:50:03PM -0700, Davide Libenzi wrote:
> > > I had a quick look at Ingo's code yesterday. Ingo is always smart to 
> > > prepare a main dish (feature) with a nice sider (code cleanup) to 
> > > Linus ;) And even this code does that pretty nicely. The deadline 
> > > designs looks good, although I think the final "key" calculation 
> > > code will end up quite different from what it looks now.
> > 
> > The additive nice_offset breaks nice levels. A multiplicative priority 
> > weighting of a different, nonnegative metric of cpu utilization from 
> > what's now used is required for nice levels to work. I've been trying 
> > to point this out politely by strongly suggesting testing whether nice 
> > levels work.
> 
> granted, CFS's nice code is still incomplete, but you err quite 
> significantly with this extreme statement that they are "broken".
> 
> nice levels certainly work to a fair degree even in the current code and 
> much of the focus is elsewhere - just try it. (In fact i claim that 
> CFS's nice levels often work _better_ than the mainline scheduler's nice 
> level support, for the testcases that matter to users.)
> 
> The precise behavior of nice levels, as i pointed it out in previous 
> mails, is largely 'uninteresting' and it has changed multiple times in 
> the past 10 years.
> 
> What matters to users is mainly: whether X reniced to -10 does get 
> enough CPU time and whether stuff reniced to +19 doesnt take away too 
> much CPU time from the rest of the system.

I agree there.


> _How_ a Linux scheduler 
> achieves this is an internal matter and certainly CFS does it in a hacky 
> way at the moment.
> 
> All the rest, 'CPU bandwidth utilization' or whatever abstract metric we 
> could come up with is just a fancy academic technicality that has no 
> real significance to any of the testers who are trying CFS right now.
> 
> Sure we prefer final solutions that are clean and make sense (because 
> such things are the easiest to maintain long-term), and often such final 
> solutions are quite close to academic concepts, and i think Davide 
> correctly observed this by saying that "the final key calculation code 
> will end up quite different from what it looks now", but your 
> extreme-end claim of 'breakage' for something that is just plain 
> incomplete is not really a fair characterisation at this point.
> 
> Anyone who thinks that there exists only two kinds of code: 100% correct 
> and 100% incorrect with no shades of grey inbetween is in reality a sort 
> of an extremist: whom, depending on mood and affection, we could call 
> either a 'coding purist' or a 'coding taliban' ;-)

Only if you are an extremist-naming extremist with no shades of grey.
Others, like myself, also include 'coding al-qaeda' and 'coding john
howard' in that scale.

