Return-Path: <linux-kernel-owner+w=401wt.eu-S932076AbZBLWAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076AbZBLWAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 17:00:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758792AbZBLWAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 17:00:04 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:40763 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758789AbZBLWAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 17:00:00 -0500
Date: Thu, 12 Feb 2009 13:59:59 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       Bryan Wu <cooloney@kernel.org>, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
	(repost)
Message-ID: <20090212215959.GN6759@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090212023308.GA21157@linux.vnet.ibm.com> <20090212040824.GA12346@Krystal> <20090212050120.GA8317@linux.vnet.ibm.com> <20090212070539.GA15896@Krystal> <20090212164621.GC6759@linux.vnet.ibm.com> <20090212192941.GC2047@Krystal> <20090212200249.GG6759@linux.vnet.ibm.com> <alpine.LFD.2.00.0902121210120.3099@localhost.localdomain> <20090212203924.GK6759@linux.vnet.ibm.com> <alpine.LFD.2.00.0902121247040.3099@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902121247040.3099@localhost.localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 01:15:08PM -0800, Linus Torvalds wrote:
> 
> 
> On Thu, 12 Feb 2009, Paul E. McKenney wrote:
> > 
> > In other words, you are arguing for using ACCESS_ONCE() in the loops,
> > but keeping the old ACCESS_ONCE() definition, and declaring BF hardware
> > broken?
> 
> Well, I _also_ argue that if you have a busy loop, you'd better have a 
> cpu_relax() in there somewhere anyway. If you don't, you have a bug.
> 
> So I think the BF approach is "borderline broken", but I think it should 
> work, if BF just has whatever appropriate cache flush in its cpu_relax.

OK, got it.  Keep ACCESS_ONCE() as is, make sure any busy-wait
loops contain a cpu_relax().  A given busy loop might or might not
need ACCESS_ONCE(), but that decision is independent of hardware
considerations.

Ah, and blackfin's cpu_relax() does seem to have migrated from barrier()
to smp_mb() recently, so sounds good to me!!!

							Thanx, Paul
