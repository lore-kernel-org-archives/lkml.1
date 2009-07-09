Return-Path: <linux-kernel-owner+w=401wt.eu-S1761341AbZGIO2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761341AbZGIO2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 10:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761122AbZGIO2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 10:28:24 -0400
Received: from www.tglx.de ([62.245.132.106]:54446 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761013AbZGIO2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 10:28:23 -0400
Date: Thu, 9 Jul 2009 16:28:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jarek Poplawski <jarkao2@gmail.com>
cc: Andres Freund <andres@anarazel.de>,
       Joao Correia <joaomiguelcorreia@gmail.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Patrick McHardy <kaber@trash.net>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 ( possibly?caused
 by netem)
In-Reply-To: <20090709142414.GC3651@ami.dom.local>
Message-ID: <alpine.LFD.2.00.0907091625540.24704@localhost.localdomain>
References: <200907031326.21822.andres@anarazel.de> <200907071811.27570.andres@anarazel.de> <20090708080852.GC3148@ami.dom.local> <200907090023.18040.andres@anarazel.de> <20090708224828.GD3666@ami.dom.local> <alpine.LFD.2.00.0907090956490.24704@localhost.localdomain>
 <20090709104412.GA3651@ami.dom.local> <alpine.LFD.2.00.0907091401040.24704@localhost.localdomain> <20090709132256.GB3651@ami.dom.local> <alpine.LFD.2.00.0907091601120.24704@localhost.localdomain> <20090709142414.GC3651@ami.dom.local>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jul 2009, Jarek Poplawski wrote:
> On Thu, Jul 09, 2009 at 04:15:28PM +0200, Thomas Gleixner wrote:
> > On Thu, 9 Jul 2009, Jarek Poplawski wrote:
> > > On Thu, Jul 09, 2009 at 02:03:50PM +0200, Thomas Gleixner wrote:
> > > > On Thu, 9 Jul 2009, Jarek Poplawski wrote:
> > > > > > 
> > > > > > I have the feeling that the code relies on some implicit cpu
> > > > > > boundness, which is not longer guaranteed with the timer migration
> > > > > > changes, but that's a question for the network experts.
> > > > > 
> > > > > As a matter of fact, I've just looked at this __netif_schedule(),
> > > > > which really is cpu bound, so you might be 100% right.
> > > > 
> > > > So the watchdog is the one which causes the trouble. The patch below
> > > > should fix this.
> > > 
> > > I hope so. On the other hand it seems it should work with this
> > > migration yet, so it probably needs additional debugging.
> > 
> > Right. I just provided the patch to narrow down the problem, but
> > please test the fix of the hrtimer migration code which I sent out a
> > bit earlier: http://lkml.org/lkml/2009/7/9/150
> > 
> > It fixes a possible endless loop in the timer code which is related to
> > the migration changes. Looking at the backtraces of the spinlock
> > lockup I think that is what you hit.
> 
> Actually, Andres and Joao hit this, and I hope they'll try these two
> patches.

Please test them separate from each other. The one I sent in this
thread was just for narrowing down the issue, but I'm now quite sure
that they really hit the issue which is addressed by the hrtimer
patch.

Thanks,

	tglx
