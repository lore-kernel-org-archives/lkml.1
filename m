Return-Path: <linux-kernel-owner+w=401wt.eu-S1751639AbZHIFdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639AbZHIFdM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 01:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbZHIFdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 01:33:12 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37140 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbZHIFdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 01:33:11 -0400
Date: Sat, 8 Aug 2009 22:33:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Ingo Molnar <mingo@elte.hu>, Ben Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_PREEMPT_RCU in next/mmotm
Message-ID: <20090809053308.GD6866@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <Pine.LNX.4.64.0908081956580.12300@sister.anvils> <20090808235634.GB6866@linux.vnet.ibm.com> <Pine.LNX.4.64.0908090414320.18096@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0908090414320.18096@sister.anvils>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 09, 2009 at 04:32:28AM +0100, Hugh Dickins wrote:
> On Sat, 8 Aug 2009, Paul E. McKenney wrote:
> > On Sat, Aug 08, 2009 at 08:34:03PM +0100, Hugh Dickins wrote:
> > 
> > > CONFIG_PREEMPT_TREE=y seems okay on PowerPC; and when I briefly tried
> > 
> > CONFIG_TREE_RCU=y, you mean, right?
> 
> Whoops, yes indeed.
> 
> > > My guess is that there's some other issue which is triggering
> > > the RCU disgrace, but that is just a guess.
> > 
> > The one other issue I know of is one that apparently happens only on
> > one of Ingo's machines, which suddenly decides that it need not inform
> > RCU when onlining a CPU (at boot time).
> > 
> > But you seem to be making it past boot, and I would guess that you are
> > not doing any hotplug CPU operations, right?
> 
> That's right, I'm well past boot, and don't explicitly get into CPU
> hotplug, nor using suspend/hibernate on that machine; and looking at
> the config, see I don't even have CONFIG_HOTPLUG_CPU set.
> 
> In the morning I'll check that /proc/cpuinfo really shows all four
> cpus before I start, and is still showing four cpus when it goes bad,
> in case there's nevertheless an issue with that.
> 
> Is there some particular attribute of a cpu, most relevant to its RCU
> grace status, that I can check on with a printk?

The debugfs files enabled by CONFIG_RCU_TRACE, except rcu/rcugp, which,
since it will attempt to wait for a grace period, will probably wait
forever.

> > > Config attached.  Any suggestions?
> 
> [ Of course I forgot the config, but sent it just to Paul later. ]
> 
> > 
> > /me scratches head...  Will try some more CONFIG_PREEMPT_RCU testing
> > locally.
> 
> Thanks: I'm kind of glad that it's interesting,
> though it may sink some of our time.

Well, it certainly does have me a bit confused at the moment!

							Thanx, Paul
