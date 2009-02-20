Return-Path: <linux-kernel-owner+w=401wt.eu-S1758535AbZBTRZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535AbZBTRZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754853AbZBTRZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:25:29 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35212 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562AbZBTRZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:25:28 -0500
Date: Fri, 20 Feb 2009 09:25:26 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
Message-ID: <20090220172526.GM6960@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090220134121.GA19575@damson.getinternet.no> <20090220135000.GA9616@elte.hu> <20090220140157.GA12799@elte.hu> <19f34abd0902200651k7e86aebay5398ef5ac0578561@mail.gmail.com> <20090220154619.GC6960@linux.vnet.ibm.com> <20090220160409.GB11294@elte.hu> <20090220164441.GG6960@linux.vnet.ibm.com> <20090220171427.GE24538@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220171427.GE24538@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 06:14:27PM +0100, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > > > So, what flavor of RCU were you using?
> > > 
> > > well, even in preemptible RCU the grace period should be 
> > > extended as long as we are non-preempt (which we are here), 
> > > correct?
> > 
> > Given Classic RCU, you are quite correct.  With preemptable 
> > RCU, if there are no readers, and if irqs are enabled, the 
> > grace period could end within the spinlock's critical section.  
> > Of course, the spinlock would need to be held for an 
> > improbably long time -- many milliseconds.
> 
> ah. But we _can_ get unlucky there and get into 
> multiple-milliseconds of blockage: for example if some heavy 
> interrupt source or softirq processes stuff for many 
> milliseconds.
> 
> So it's a real fix needed both for mainline and for 2.6.28. 
> And kudos to kmemcheck ;-)

Kudos from me as well!!!  Sure beats the heck out of tracking down memory
corruption by hand!!!  ;-)

							Thanx, Paul
