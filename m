Return-Path: <linux-kernel-owner+w=401wt.eu-S1761577AbYHAVNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761577AbYHAVNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760879AbYHAVKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:10:05 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57950 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760877AbYHAVKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:10:01 -0400
Date: Fri, 1 Aug 2008 14:09:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.26-rc9-git4: Reported regressions from 2.6.25
Message-ID: <20080801210953.GK14851@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4yrA-dRoNlD.A.jcB.ny-cIB@albercik> <200807101725.36175.nickpiggin@yahoo.com.au> <20080710110213.GA6688@martell.zuzino.mipt.ru> <alpine.LFD.1.10.0807101020270.11076@woody.linux-foundation.org> <20080710173459.GA11648@elte.hu> <20080710180620.GA30844@elte.hu> <20080710204157.GG6877@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080710204157.GG6877@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 01:41:57PM -0700, Paul E. McKenney wrote:
> On Thu, Jul 10, 2008 at 08:06:20PM +0200, Ingo Molnar wrote:
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > cool! :)
> > > 
> > > (hm, could anyone please resend Nick's original mail? The original one 
> > > is not in my lkml folder nor on lkml.org - only the quoted one.)
> > 
> > ok, got the mail now now:
> > 
> > | | Annoyed this wasn't a crazy obscure error in the algorithm I could 
> > | | fix :) [...]
> > 
> > Paul recently ran a formal proof against all sorts of RCU details (and 
> > found and fixed a few obscure races that way that no-one ever 
> > triggered), so i'd be quite surprised if we found anything in the core 
> > algorithm :-)

Yeah, it was instead the simple stuff that I messed up...  :-/

> > | | [...] I spent all day debugging it and had to make a special test 
> > | | case (rcutorture didn't seem to trigger it), and a big RCU state 
> > | | logging infrastructure to log millions of RCU state transitions and 
> > | | events. Oh well.
> > 
> > nice debugging!
> 
> Indeed!!!
> 
> > Acked-by: Ingo Molnar <mingo@elte.hu>
> > 
> > i'm wondering why rcutorture didnt trigger it. I do run !HOTPLUG + 
> > RCU_PREEMPT kernels and never saw this. Nor did Paul. That aspect is 
> > weird.
> 
> Turns out that my environment was silently re-enabling HOTPLUG_CPU, so I
> only -thought- I was testing !CPU_HOTPLUG.  Once I forced it to really
> disable HOTPLUG_CPU (by manually also specifying CONFIG_SUSPEND=n and
> CONFIG_HIBERNATION=n), then rcutorture complained within 10 seconds.
> 
> Sigh!!!

And Nick's patch gets rid of the rcutorture failures for me as well,
now that I can reproduce them.  ;-)

							Thanx, Paul
