Return-Path: <linux-kernel-owner+w=401wt.eu-S932083AbYBLQnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083AbYBLQnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 11:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759036AbYBLQnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 11:43:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60045 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758314AbYBLQnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 11:43:40 -0500
Date: Tue, 12 Feb 2008 17:42:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] kgdb-light -v10
Message-ID: <20080212164244.GA24207@elte.hu>
References: <20080211171039.GA20446@one.firstfloor.org> <20080211230335.GA16102@elte.hu> <20080212100327.GA30873@one.firstfloor.org> <20080212112747.GA1569@elte.hu> <20080212121903.GA419@one.firstfloor.org> <20080212123839.GA15360@elte.hu> <20080212135027.GA1343@one.firstfloor.org> <20080212152846.GC3078@elte.hu> <20080212161152.GA3281@one.firstfloor.org> <alpine.LFD.1.00.0802120811010.2920@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802120811010.2920@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > Yes and the session has no fixed time limit.
> 
> Quite frankly, if kgdb starts doing somethign "fancy", there is no way 
> I'll merge it.
> 
> This includes things like having "breakpoint reservations" (discussed 
> earlier) and just generally trying to add lots of infrastructure to 
> make kgdb "fit in" to the kernel.

yes - i zapped hw breakpoint support in -v10 already.

> In other words: I think the kgdb patches have become a lot more 
> palatable over the last week, but I think so exactly because they have 
> gotten smaller and less invasive. Anything that evokes any discussion 
> AT ALL should just be removed. It really should be that simple.

yes, that's what i've been doing. When anything became questionable even 
just a little bit, it was the axe or i changed it to something really 
obvious and correct.

by 2.6.26 kgdb-light will become so neutral to the rest of the kernel 
that we wont even notice that we've merged it ;-)

> [ The exception being that I think hw breakpoint support should be
>   added back in - never mind that it won't work if the "native kernel" 
>   also uses them. Tough.

yeah. I believe we need to achieve a "known zero impact, 100% trustable" 
state for KGDB to start with, and add stuff carefully to it.

> So keep the damn thing really simple, and don't try to handle every 
> possible thing. We expect the debugger side to have a person with some 
> flexibility on it.

yes - if something locks up, it will be the NMI watchdog starting the 
debugger eventually - not the other way around. The NMI watchdog is 
already system policy which can be turned on/off and is well known and 
expresses the user's wishes with what should happen to the system.

The debugger should really be a fundamentally very passive "console" 
type of thing, with as little direct policy as possible. That minimizes 
the chance that it accidentally messes up something and also makes it 
more likely that it will actually work reliably and dependably.

	Ingo
