Return-Path: <linux-kernel-owner+w=401wt.eu-S1752439AbYJYEFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbYJYEFT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 00:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750748AbYJYEFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 00:05:06 -0400
Received: from mail.gmx.net ([213.165.64.20]:53529 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750737AbYJYEFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 00:05:05 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19WfqFS2jZWVj7JMD2bmZ2eoep1ZnGa0JrgRhkn/Y
	rdKUxAD2x7l/ls
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
From: Mike Galbraith <efault@gmx.de>
To: David Miller <davem@davemloft.net>
Cc: rjw@sisk.pl, mingo@elte.hu, s0mbre@tservice.net.ru, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20081024.163111.244324800.davem@davemloft.net>
References: <20081010115518.GA3159@tservice.net.ru>
	 <20081010115725.GD19487@elte.hu> <200810250025.35734.rjw@sisk.pl>
	 <20081024.163111.244324800.davem@davemloft.net>
Content-Type: text/plain
Date: Sat, 25 Oct 2008 06:05:01 +0200
Message-Id: <1224907501.5161.36.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-24 at 16:31 -0700, David Miller wrote:
> From: "Rafael J. Wysocki" <rjw@sisk.pl>
> Date: Sat, 25 Oct 2008 00:25:34 +0200
> 
> > On Friday, 10 of October 2008, Ingo Molnar wrote:
> > > 
> > > * Evgeniy Polyakov <s0mbre@tservice.net.ru> wrote:
> > > 
> > > > On Fri, Oct 10, 2008 at 01:42:45PM +0200, Ingo Molnar (mingo@elte.hu) wrote:
> > > > > > vanilla 27: 347.222
> > > > > > no TSO/GSO: 357.331
> > > > > > no hrticks: 382.983
> > > > > > no balance: 389.802
> > > > > 
> > > > > okay. The target is 470 MB/sec, right? (Assuming the workload is sane 
> > > > > and 'fixing' it does not mean we have to schedule worse.)
> > > > 
> > > > Well, that's where I started/stopped, so maybe we will even move
> > > > further? :)
> > > 
> > > that's the right attitude ;)
> > 
> > Can anyone please tell me if there was any conclusion of this thread?
> 
> I made some more analysis in private with Ingo and Peter Z. and found
> that the tbench decreases correlate pretty much directly with the
> ongoing increasing cpu cost of wake_up() and friends in the fair
> scheduler.
> 
> The largest increase in computational cost of wakeups came in 2.6.27
> when the hrtimer bits got added, it more than tripled the cost of a wakeup.
> In 2.6.28-rc1 the hrtimer feature has been disabled, but I think that
> should be backports into the 2.6.27-stable branch.
> 
> So I think that should be backported, and meanwhile I'm spending some
> time in the background trying to replace the fair schedulers RB tree
> crud with something faster so maybe at some point we can recover all
> of the regressions in this area caused by the CFS code.

My test data indicates (to me anyway) that there is another source of
localhost throughput loss in .27.  In that data, there is no hrtick
overhead since I didn't have highres timers enabled, and computational
costs added in .27 were removed.  Dunno where it lives, but it does
appear to exist.

	-Mike

