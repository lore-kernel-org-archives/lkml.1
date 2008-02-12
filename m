Return-Path: <linux-kernel-owner+w=401wt.eu-S1764089AbYBLQbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764089AbYBLQbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 11:31:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759384AbYBLQbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 11:31:42 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44273 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762204AbYBLQbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 11:31:41 -0500
Date: Tue, 12 Feb 2008 18:07:11 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] kgdb-light -v10
Message-ID: <20080212170711.GB4191@one.firstfloor.org>
References: <20080211171039.GA20446@one.firstfloor.org> <20080211230335.GA16102@elte.hu> <20080212100327.GA30873@one.firstfloor.org> <20080212112747.GA1569@elte.hu> <20080212121903.GA419@one.firstfloor.org> <20080212123839.GA15360@elte.hu> <20080212135027.GA1343@one.firstfloor.org> <20080212152846.GC3078@elte.hu> <20080212161152.GA3281@one.firstfloor.org> <alpine.LFD.1.00.0802120811010.2920@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802120811010.2920@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This includes things like having "breakpoint reservations" (discussed 
> earlier) and just generally trying to add lots of infrastructure to make 
> kgdb "fit in" to the kernel.

I think that part is actually mostly ok now (old kgdb stubs were
much worse in this regard) 

I still think the ultimative proof for this would be working
"modprobe kgdb" though.

> 
> The fact is, not having kgdb enabled should have _zero_ impact on the 
> kernel, but the implication is also that when you *do* enable kgdb, that 
> shouldn't change anything visible either: the rest of the kernel should 

While agreed in theory there are some exceptions: any time an oops
happens or a crash dump would happen automatically kgdb should definitely
do something very visible. Unfortunately that's not always the case
currently (see earlier comments on the notifier priority) 

> So kgdb in my opinion will *have* to step on some other kernel 
> infrastructure. I also think that things like timeouts are not something 
> the client should do - if a kgdb lock never gets through, then it should 
> be the debugging end that should just react to ^C and tough titties: it's 
> not like there's a whole lot to be done.

The problem here is that the timeout we were talking about 
is not integrated into the kgdb event loop, it is rather the loop
that protects the event loop. If you hang there all input
from the outside will be ignored.

> So keep the damn thing really simple, and don't try to handle every 
> possible thing. We expect the debugger side to have a person with some 
> flexibility on it.

If you want areally simple kgdb the best option would be re-porting
the really simple (tm) 2.4 era x86-64 kgdb stub I did long ago.
It had a small fraction of the code size of the current code, but
was also missing a lot of features of course.

-Andi
