Return-Path: <linux-kernel-owner+w=401wt.eu-S932412AbZKXJLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412AbZKXJLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 04:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932388AbZKXJLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 04:11:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44543 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932300AbZKXJLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 04:11:23 -0500
Date: Tue, 24 Nov 2009 10:11:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@suse.de>, Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: newidle balancing in NUMA domain?
Message-ID: <20091124091124.GG21991@elte.hu>
References: <20091123112228.GA2287@wotan.suse.de>
 <1258987059.6193.73.camel@marge.simson.net>
 <20091123151152.GA19175@wotan.suse.de>
 <1258989704.4531.574.camel@laptop>
 <20091123152931.GD19175@wotan.suse.de>
 <1258991617.6182.21.camel@marge.simson.net>
 <20091124065322.GC20981@wotan.suse.de>
 <1259052035.8843.106.camel@marge.simson.net>
 <1259053080.6081.2.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259053080.6081.2.camel@marge.simson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

> On Tue, 2009-11-24 at 09:40 +0100, Mike Galbraith wrote:
> > On Tue, 2009-11-24 at 07:53 +0100, Nick Piggin wrote:
> > > On Mon, Nov 23, 2009 at 04:53:37PM +0100, Mike Galbraith wrote:
> > > > On Mon, 2009-11-23 at 16:29 +0100, Nick Piggin wrote:
> > > > 
> > > > > So basically about the least well performing or scalable possible
> > > > > software architecture. This is exactly the wrong thing to optimise
> > > > > for, guys.
> > > > 
> > > > Hm.  Isn't fork/exec our daily bread?
> > > 
> > > No. Not for handing out tiny chunks of work and attempting to do
> > > them in parallel. There is this thing called Amdahl's law, and if
> > > you write a parallel program that wantonly uses the heaviest
> > > possible primitives in its serial sections, then it doesn't deserve
> > > to go fast.
> > 
> > OK by me.  A bit if idle time for kbuild is easily cured with telling
> > make to emit more jobs, so there's enough little jobs to go around.
> > 
> > If x264 is declared dainbramaged, that's fine with me too.
> 
> (P.S. I don't want to have to explain to users of any such thread 
> happy applications why they suck rocks under Linux though)

The 68% of speedup is pretty valid for your change and the workload isnt 
particularly odd beyond the fast creation rate of threads - but i'd not 
blame the app for that, Linux creates/destroys threads very fast. Your 
followup load-balancing fix got queued up in the scheduler tree for 
v2.6.33 ~two weeks ago:

  1b9508f: sched: Rate-limit newidle

certainly handles some of the NUMA pain. If not, numbers telling us the 
other story (and patches to extend 'perf bench sched' with matching 
testcases) would be helpful, i'm not seeing problems on my NUMA testbox.

1b9508f was certainly too late for 2.6.32, but since it appears to be 
fine it can be forwarded to stable@kernel.org so it makes it into 
2.6.32.1.

Thanks,

	Ingo
