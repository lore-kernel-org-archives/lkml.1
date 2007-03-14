Return-Path: <linux-kernel-owner+w=401wt.eu-S932501AbXCNUAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501AbXCNUAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 16:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933055AbXCNUAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 16:00:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43246 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932501AbXCNUAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 16:00:22 -0400
Date: Wed, 14 Mar 2007 20:59:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 - Take 2
Message-ID: <20070314195916.GA5674@elte.hu>
References: <20070314050819.536207642@goodmis.org> <p73slc8863r.fsf@bingen.suse.de> <20070314125330.GA13168@elte.hu> <Pine.LNX.4.64.0703140850250.9690@woody.linux-foundation.org> <20070314180933.GA12994@elte.hu> <Pine.LNX.4.64.0703141120530.9690@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703141120530.9690@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > of code. i386 is 87847 lines of code, x86_64 is 40978 lines of code, 
> > a total of 128825. That means we move about 10% of the code. Not 
> > insignificant but not earth-shattering either. With alot more effort 
> > (and testing) we could realistically go up to maybe 20% - but that's 
> > still a bit low to spread out all the files, isnt it?
> 
> Well, I'd like it to be 100% _eventually_, and just unify the 
> architectures.

ok, having a single bi-arch final tree is indeed intriquing and i didnt 
realize that you were suggesting that. (I had the impression that 
arch/x86/ was more of a 'common library' thing, not a target 
architecture. What felt weird to me was having 3 separate hierarchies - 
but as long as it's just a temporary state it's OK.)

> We've now done that both for S/390 and POWER, and I think in both 
> cases it's been a clear win. So it's not like this is even a radical 
> idea.

the x86_64 and i386 trees have diverged quite a bit though, so this will 
be a major logistical undertaking. And with Andi opposed to 
fundamentally it it also lacks a bit of manpower i guess :-/

> There really is almost nothing in i386 that shouldn't be supported on 
> x86-64 too, unless it literally is the actual low-level asm files and 
> vm86 mode support (which in turn is best left as just a config option 
> that would just *depend* on 32-bit, so even that could sanely be 
> represented in a shared tree without any real downside at all).

yeah. But this really scares the sh*t out of me. I already tried to 
unify some of the most fragile lowlevel bits recently: for example the 
SMP bootup, TSC sync and APIC initialization sequences were totally 
different on x86 and x86_64. And those kind of random deviations have 
spread all around the tree. But ... my experience has been pretty 
positive: touching both codebases at once tends to dust off old code and 
tends to fix more bugs. And in the process of doing that we broke 
Andrew's laptop only half a dozen times! ;) But .. in the long run, it's 
alot easier to think about unified code. 32-bit x86 will certainly stay 
with us for at least 10-20 years, and the best model for maintainance is 
having one codebase.

Another practical complication is that even for modular stuff, sometimes 
x86_64 has the better code, sometimes i386. But ... the more i think 
about it the more i like it. -m32 certainly works fine and does the 
right thing.

	Ingo
