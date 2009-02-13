Return-Path: <linux-kernel-owner+w=401wt.eu-S1761206AbZBMO5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761206AbZBMO5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 09:57:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758811AbZBMO46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 09:56:58 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44826 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758772AbZBMO46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 09:56:58 -0500
Date: Fri, 13 Feb 2009 06:56:54 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       Bryan Wu <cooloney@kernel.org>, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
	(repost)
Message-ID: <20090213145653.GA6854@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090212023308.GA21157@linux.vnet.ibm.com> <alpine.LFD.2.00.0902121247040.3099@localhost.localdomain> <20090212215959.GN6759@linux.vnet.ibm.com> <200902140050.44550.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902140050.44550.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 14, 2009 at 12:50:43AM +1100, Nick Piggin wrote:
> On Friday 13 February 2009 08:59:59 Paul E. McKenney wrote:
> > On Thu, Feb 12, 2009 at 01:15:08PM -0800, Linus Torvalds wrote:
> > > On Thu, 12 Feb 2009, Paul E. McKenney wrote:
> > > > In other words, you are arguing for using ACCESS_ONCE() in the loops,
> > > > but keeping the old ACCESS_ONCE() definition, and declaring BF hardware
> > > > broken?
> > >
> > > Well, I _also_ argue that if you have a busy loop, you'd better have a
> > > cpu_relax() in there somewhere anyway. If you don't, you have a bug.
> > >
> > > So I think the BF approach is "borderline broken", but I think it should
> > > work, if BF just has whatever appropriate cache flush in its cpu_relax.
> >
> > OK, got it.  Keep ACCESS_ONCE() as is, make sure any busy-wait
> > loops contain a cpu_relax().  A given busy loop might or might not
> > need ACCESS_ONCE(), but that decision is independent of hardware
> > considerations.
> >
> > Ah, and blackfin's cpu_relax() does seem to have migrated from barrier()
> > to smp_mb() recently, so sounds good to me!!!
> 
> 
> Interesting. I don't know if you would say it is not cache coherent.
> Does anything in cache coherency definition require timeliness? Only
> causality I think.
> 
> However I think "infinite write buffering delay", or requiring "cache
> barriers" is insane to teach any generic code about. BF would be free
> to optimise arch functions, but for correctness surely it must also
> have a periodic interrupt that will expose stores to other CPUs.

I have great sympathy for this point of view!!!  So why not have the
blackfin folks get the appropriate instructions added in the gcc port
to their architecture?  (Yeah, I know, gcc has no way of knowing which
variables are shared and not...)

But perhaps we could decorate the affected variable declarations with
a macro that expands to some sort of gcc attribute in the blackfin case?

							Thanx, Paul
