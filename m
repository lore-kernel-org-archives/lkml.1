Return-Path: <linux-kernel-owner+w=401wt.eu-S1752893AbXDQIob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbXDQIob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 04:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbXDQIob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 04:44:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43206 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817AbXDQIoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 04:44:30 -0400
Date: Tue, 17 Apr 2007 10:44:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070417084405.GA13661@elte.hu>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <1176619384.6222.70.camel@Homer.simpson.net> <46240F98.3020800@bigpond.net.au> <1176776941.6222.21.camel@Homer.simpson.net> <20070417034050.GD25513@wotan.suse.de> <46244A52.4000403@bigpond.net.au> <20070417042954.GG25513@wotan.suse.de> <462467E9.4030509@bigpond.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462467E9.4030509@bigpond.net.au>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Williams <pwil3058@bigpond.net.au> wrote:

> > And my scheduler for example cuts down the amount of policy code and 
> > code size significantly.
> 
> Yours is one of the smaller patches mainly because you perpetuate (or 
> you did in the last one I looked at) the (horrible to my eyes) dual 
> array (active/expired) mechanism.  That this idea was bad should have 
> been apparent to all as soon as the decision was made to excuse some 
> tasks from being moved from the active array to the expired array.  
> This essentially meant that there would be circumstances where extreme 
> unfairness (to the extent of starvation in some cases) -- the very 
> things that the mechanism was originally designed to ensure (as far as 
> I can gather).  Right about then in the development of the O(1) 
> scheduler alternative solutions should have been sought.

in hindsight i'd agree. But back then we were clearly not ready for 
fine-grained accurate statistics + trees (cpus are alot faster at more 
complex arithmetics today, plus people still believed that low-res can 
be done well enough), and taking out any of these two concepts from CFS 
would result in a similarly complex runqueue implementation. Also, the 
array switch was just thought to be of another piece of 'if the 
heuristics go wrong, we fall back to an array switch' logic, right in 
line with the other heuristics. And you have to accept it, mainline's 
ability to auto-renice make -j jobs (and other CPU hogs) was quite a 
plus for developers, so it had (and probably still has) quite some 
inertia.

	Ingo
