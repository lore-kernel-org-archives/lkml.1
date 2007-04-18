Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296AbXDRE34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbXDRE34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 00:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbXDRE3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 00:29:55 -0400
Received: from mail.gmx.net ([213.165.64.20]:48976 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753251AbXDRE3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 00:29:54 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/yJzFOn2XyY3bbsLieALwfJbapMQrjG3o7gBytkQ
	QAbncWYK+0IKSG
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
	Scheduler [CFS]
From: Mike Galbraith <efault@gmx.de>
To: Nick Piggin <npiggin@suse.de>
Cc: Matt Mackall <mpm@selenic.com>, William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070418035642.GB18452@wotan.suse.de>
References: <20070417034050.GD25513@wotan.suse.de>
	 <46244A52.4000403@bigpond.net.au> <20070417042954.GG25513@wotan.suse.de>
	 <20070417060955.GO8915@holomorphy.com>
	 <20070417061503.GC1057@wotan.suse.de>
	 <20070417062621.GL2986@holomorphy.com>
	 <20070417070155.GF1057@wotan.suse.de> <20070417213954.GE11166@waste.org>
	 <20070418031511.GA18452@wotan.suse.de>
	 <1176867920.6478.14.camel@Homer.simpson.net>
	 <20070418035642.GB18452@wotan.suse.de>
Content-Type: text/plain
Date: Wed, 18 Apr 2007 06:29:47 +0200
Message-Id: <1176870587.6478.38.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-18 at 05:56 +0200, Nick Piggin wrote:
> On Wed, Apr 18, 2007 at 05:45:20AM +0200, Mike Galbraith wrote:
> > On Wed, 2007-04-18 at 05:15 +0200, Nick Piggin wrote:
> > >
> > > 
> > > So on what basis would you allow unfairness? On the basis that it doesn't
> > > seem to harm anyone? It doesn't seem to harm testers?
> > 
> > Well, there's short term fair and long term fair.  Seems to me a burst
> > load having to always merge with a steady stream load using a short term
> > fairness yardstick absolutely must 'starve' relative to the steady load,
> > so to be long term fair, you have to add some short term unfairness.
> > The mainline scheduler is more long term fair (discounting the rather
> > obnoxious corner cases).
> 
> Oh yes definitely I mean long term fair. I guess it is impossible to be
> completely fair so long as we have to timeshare the CPU :)
> 
> So a constant delta is fine and unavoidable. But I don't think I agree
> with a constant factor: that means you can pick a time where process 1
> is allowed an arbitrary T more CPU time than process 2.

Definitely.  Using constants with no consideration of what else is
running is what causes the fairness mechanism in mainline to break down
under load.

(aside: What I was experimenting with before this new scheduler came
along was to turn the sleep_avg thing into an off-cpu period thing. Once
a time slice begins execution [runqueue wait doesn't count], that task
has the right to use it's slice in one go, and _anything_ that knocked
it off the cpu added to it's credit.  Knocking someone else off detracts
from credit, and to get to the point where you can knock others off
costs you stored credit proportional to the dynamic priority you attain
by using it.  All tasks that have credit stay active, no favorites.)

	-Mike

