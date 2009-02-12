Return-Path: <linux-kernel-owner+w=401wt.eu-S1760810AbZBLUjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760810AbZBLUjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 15:39:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750742AbZBLUj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 15:39:26 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33266 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758755AbZBLUjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 15:39:25 -0500
Date: Thu, 12 Feb 2009 12:39:24 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       Bryan Wu <cooloney@kernel.org>, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
	(repost)
Message-ID: <20090212203924.GK6759@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090211214258.GA32407@Krystal> <20090212003549.GU6694@linux.vnet.ibm.com> <20090212023308.GA21157@linux.vnet.ibm.com> <20090212040824.GA12346@Krystal> <20090212050120.GA8317@linux.vnet.ibm.com> <20090212070539.GA15896@Krystal> <20090212164621.GC6759@linux.vnet.ibm.com> <20090212192941.GC2047@Krystal> <20090212200249.GG6759@linux.vnet.ibm.com> <alpine.LFD.2.00.0902121210120.3099@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902121210120.3099@localhost.localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 12:13:29PM -0800, Linus Torvalds wrote:
> 
> 
> On Thu, 12 Feb 2009, Paul E. McKenney wrote:
> > 
> > Actually the best way to do this would be:
> > 
> > 	while (ACCESS_ONCE(sig_done) < 1)
> > 		continue;
> > 
> > If ACCESS_ONCE() needs to be made architecture-specific to make this
> > really work on Blackfin, we should make that change.
> 
> I really wouldn't want to mix up compiler barriers and cache barriers this 
> way. 
> 
> I think "cpu_relax()" is likely the right thing to piggy-back on for 
> broken cache-coherency.
> 
> > And, now that you mention it, I have heard rumors that other CPU 
> > families can violate cache coherence in some circumstances.
> 
> I personally suspect that the BF pseudo-SMP code is just broken, and that 
> it likely has tons of subtle bugs and races - because we _do_ depend on 
> cache coherency at least for accessing objects next to each other. I just 
> never personally felt like I had the energy to care deeply enough.
> 
> But I draw the line at making ACCESS_ONCE() imply anything but a compiler 
> optimization issue.

In other words, you are arguing for using ACCESS_ONCE() in the loops,
but keeping the old ACCESS_ONCE() definition, and declaring BF hardware
broken?

I am OK with that, just wanting to make sure I understand what you are
asking us to do.

							Thanx, Paul
