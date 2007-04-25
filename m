Return-Path: <linux-kernel-owner+w=401wt.eu-S1161618AbXDYGmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161618AbXDYGmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 02:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161619AbXDYGmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 02:42:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50334 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161618AbXDYGmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 02:42:15 -0400
Date: Wed, 25 Apr 2007 08:41:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, Nigel Cunningham <nigel@nigel.suspend2.net>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070425064137.GA25247@elte.hu>
References: <200704182245.24156.mail@earthworm.de> <20070418211632.GA7610@elte.hu> <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu> <1176947576.5906.21.camel@nigel.suspend2.net> <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424212408.GD16457@elf.ucw.cz> <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
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

> I absolutely detest all suspend-to-disk crap. Quite frankly, I hate 
> the whole thing. I think they've _all_ caused problems for the "true" 
> suspend (suspend-to-ram), and the last thing I want to see is three or 
> four different suspend-to-disk implementations.  So unlike Ingo, I 
> don't think "let's just integrate them all side-by-side and maintain 
> them and look who wins" is really a good idea.
>
> How many different magic ioctl's does the thing introduce? Is it 
> really just *two* entry-points (and how simple are they, 
> interface-wise), and nothing else?

userspace-driven-suspend is already in the kernel, today. So it's not 
really "two versions side by side doing the same thing", but more of:

           A B C + D E F G H

where "ABC" is used by the uswsusp code today, and "ABCDEFGH" is used by 
suspend2. So any "suspend2 merge" would largely be about adding "DEFGH". 
(uswsusp of course redoes 'DEFGH' in user-space its own way, and there 
is the inevitable "+" glue code as well, but it's at least not two 
parallel versions of the same thing in the kernel, which would be 
gross.)

My original mail was about the following thing: i tried the suspend2 
patch (which just makes "echo disk > /sys/power/state" work as expected, 
as long as you give the booting up kernel image an idea about where the 
swap partition we suspended to is, via a single boot option) and that it 
was pretty straightforward and worked well, and that i think its way of 
reusing the existing suspend infrastructure and doing the add-ons 
cleanly while keeping the existing user-hibernate code intact looked 
viable to me.

I.e. to me it looked like while there are apparent conflicts of 
personalities suspend2 did not really seem to be a hostile 
reimplementation of 'A B C', but that it tries to build upon 'A B C' and 
just has a different technical opinion about whether 'DEFGH' should be 
in the kernel or outside of it.

	Ingo
