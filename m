Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbZIFGj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbZIFGj0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 02:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbZIFGjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 02:39:25 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39994 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158AbZIFGjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 02:39:24 -0400
Date: Sat, 5 Sep 2009 23:39:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: RCU Kconfig help text
Message-ID: <20090906063927.GG7181@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <12924.1252157230@turing-police.cc.vt.edu> <20090905200145.GB7181@linux.vnet.ibm.com> <20090906062441.GD1431@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090906062441.GD1431@ucw.cz>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 06, 2009 at 08:24:41AM +0200, Pavel Machek wrote:
> On Sat 2009-09-05 13:01:46, Paul E. McKenney wrote:
> > On Sat, Sep 05, 2009 at 09:27:10AM -0400, Valdis.Kletnieks@vt.edu wrote:
> > > init/Kconfig says:
> > > 
> > > "choice
> > >         prompt "RCU Implementation"
> > >         default TREE_RCU
> > > 
> > > config TREE_RCU
> > >         bool "Tree-based hierarchical RCU"
> > >         help
> > >           This option selects the RCU implementation that is
> > >           designed for very large SMP system with hundreds or
> > >           thousands of CPUs.  It also scales down nicely to
> > >           smaller systems.
> > > 
> > > config TREE_PREEMPT_RCU
> > >         bool "Preemptable tree-based hierarchical RCU"
> > >         depends on PREEMPT
> > >         help
> > >           This option selects the RCU implementation that is
> > >           designed for very large SMP systems with hundreds or
> > >           thousands of CPUs, but for which real-time response
> > >           is also required.
> > > 
> > > endchoice"
> > > 
> > > This leaves somebody who has a laptop wondering which choice is best for
> > > a system with only one or two cores that has CONFIG_PREEMPT defined. One
> > > choice says it scales down nicely, the other explicitly has a 'depends on
> > > PREEMPT' attached to it...
> > > 
> > > (Yes, I realize in practice, the RCU sections on a laptop are probably usually
> > > so short they don't matter in practice.  I finally concluded TREE_PREEMPT was
> > > apparently a rename of CONFIG_PREEMPT_RCU and went with that since that was
> > > working for me before...)
> > 
> > Good point -- I will add the "It also scales down nicely to smaller
> > systems" to TREE_PREEMPT_RCU.
> > 
> > For -really- small systems, TINY_RCU will hopefully be there at some
> > point, but it can only handle single-CPU systems.
> 
> If so, call it 'UP_RCU' or 'UNIPROCESSOR_RCU'?

"UP_RCU".  Cute!!!  ;-)

My hope is to drive the RCU selection directly from CONFIG_SMP and
CONFIG_PREEMPT, so that the choice of RCU would be implicit (aside from
things like tracing and fanout).

Seem reasonable, or would you expect anyone to want to hand-select
the RCU implementation?

							Thanx, Paul
