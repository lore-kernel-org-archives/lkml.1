Return-Path: <linux-kernel-owner+w=401wt.eu-S1752731Ab0AYUfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab0AYUfO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 15:35:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822Ab0AYUfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 15:35:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44444 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941Ab0AYUfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 15:35:11 -0500
Date: Mon, 25 Jan 2010 21:34:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Kyle Moffett <kyle@moffetthome.net>, tytso@mit.edu,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com
Subject: Re: linux-next: add utrace tree
Message-ID: <20100125203430.GA31937@elte.hu>
References: <20100123114729.GA7828@redhat.com>
 <20100123194820.GM21263@thunk.org>
 <f73f7ab81001241742t1f827ddetd958e1949787020f@mail.gmail.com>
 <alpine.LFD.2.00.1001250845180.3574@localhost.localdomain>
 <20100125170254.GB22862@redhat.com>
 <alpine.LFD.2.00.1001250930320.3574@localhost.localdomain>
 <1264442070.31321.422.camel@gandalf.stny.rr.com>
 <alpine.LFD.2.00.1001251002430.3574@localhost.localdomain>
 <1264444237.31321.431.camel@gandalf.stny.rr.com>
 <alpine.LFD.2.00.1001251939000.5926@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001251939000.5926@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Mon, 25 Jan 2010, Steven Rostedt wrote:
> 
> > On Mon, 2010-01-25 at 10:12 -0800, Linus Torvalds wrote:
> > 
> > > But on the whole, I think it's actually worked out pretty well for them. 
> > > I think the mainline kernel has improved in the process, but I also 
> > > suspect that _their_ RT patches have also improved thanks to having to 
> > > make the work more palatable to people like me who don't care all that 
> > > deeply about their particular flavor of crazy.
> > 
> > Actually this is an understatement. Every feature (and I do mean _every_) 
> > that went from -rt into mainline, undertook 3 or more rewrites before it 
> > was acceptable for mainline. And every time, the end result made the -rt 
> > patch set better as a whole.
> > 
> > Not to mention, that a lot of the early stuff also cleaned up mainline. 
> > You can't have Real-Time without having a clean kernel. And as you stated, 
> > a lot of those patches to clean up the kernel, no one even knew that the 
> > real reason was to help the -rt patch set. They were well disguised Trojan 
> > horses.
> 
> Tsss. Never admit such things.

Here's four examples of recent kernel features:

 - lockdep                                      [1]
 - ftrace                                       [2]
 - new-style generic mutexes and spin-mutexes   [3]
 - the new arch/x86 tree                        [4]

I suspect few would guess that all of these features were motivated by the -rt 
kernel originally:

    [1] lockdep started out as the 'track irqs-off sections' patches in -rt
    [2] ftrace started out as -rt's latency tracer and logdev
    [3] mutex.c was motivated by rtmutex.c
    [4] arch-x86 was motivated by annoyance with needless porting of -rt 
        features from 32-bit to 64-bit x86 and back.

[ Nor would you normally guess that Linux itself was motivated by a guy 
  wanting to toy around with 32-bit x86 assembly ;-) ]

Various forms of craziness that motivate us dont really hurt, as long as the 
process is rooted in reality. We can 'wish' for the crazier future stuff and 
can help it indirectly, and sometimes it might even happen down the road - but 
reality and common-sense utility is what controls.

And note that there's nothing dishonest about doing multi-purpose patches, as 
long as the mainstream purpose isnt really just a decoy. When we decouple a 
feature from -rt we usually forget its -rt purpose and the intermediate 
for-mainstream forms arent even useful for -rt - back-integration into -rt 
comes at a later stage. This makes it doubly sure that it's all formed by 
mainstream's need, not -rt's needs.

In the few cases where the -rt role is prominent for some weird reason we 
declare it as such. It's the exception to the rule really - few useful kernel 
features are single purpose. ( When they are then we are likely doing 
something wrong. -rt _is_ a special case. )

	Ingo
