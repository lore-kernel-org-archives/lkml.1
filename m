Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbYKLUVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbYKLUVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 15:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753158AbYKLUVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 15:21:10 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:32986 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbYKLUVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 15:21:08 -0500
Date: Wed, 12 Nov 2008 11:43:46 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@redhat.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>, manfred@colorfullife.com
Subject: Re: [Bug #11989] Suspend failure on NForce4-based boards due to
	chanes in stop_machine
Message-ID: <20081112194346.GF6667@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081111113134.GA5653@osiris.boeblingen.de.ibm.com> <20081111124201.GA9459@osiris.boeblingen.de.ibm.com> <20081111143505.GA6923@linux.vnet.ibm.com> <20081111150225.GA10743@linux.vnet.ibm.com> <20081111161401.GC9459@osiris.boeblingen.de.ibm.com> <20081111164523.GB6736@linux.vnet.ibm.com> <20081111173451.GA24720@linux.vnet.ibm.com> <20081112090508.GA14329@osiris.boeblingen.de.ibm.com> <20081112160349.GA6667@linux.vnet.ibm.com> <20081112165118.GA30743@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112165118.GA30743@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 05:51:18PM +0100, Heiko Carstens wrote:
> On Wed, Nov 12, 2008 at 08:03:49AM -0800, Paul E. McKenney wrote:
> > On Wed, Nov 12, 2008 at 10:05:08AM +0100, Heiko Carstens wrote:
> > > On Tue, Nov 11, 2008 at 09:34:51AM -0800, Paul E. McKenney wrote:
> > > > > Were you using preemptible RCU earlier as well?  Raphael was using
> > > > > classic RCU.  Don't get me wrong, all problems need fixing, just trying
> > > > > to make sure I understand where the problems are occurring.
> > > 
> > > Indeed, my fault. I just try to reproduce a cpu hotplug bug with classic RCU
> > > and cpu hotplug stress test, but no luck so far.
> > 
> > OK, then my next step will be to send Rafael an updated version of
> > my hierarchical RCU, which is more robust than classic RCU against
> > online/offline stress tests.  On the machines I have access to, anyway.  ;-)
> > 
> > Then I will look at preemptable RCU, which undoubtably needs some of the
> > same help that I have been giving to hierarchical RCU.  Manfred thus
> > wins the clairvoyance award!
> 
> Well, I tried all day long to reproduce a cpu hotplug/stop_machine hang
> with classic RCU and a kernel configuration that is as close as possible
> to Raphael's configuration, but it just continues to work without a bug.
> 
> One of the machines is a virtual machine with 8 virtual cpus mapped on
> two real cpus. The real cpus are again shared with other guests. So I end
> up with cpu steal times of 50-90%. That should have revealed races in the
> stop_machine code, considering that thousands of cpu hotplug operations
> happened.
> 
> I let these test machines running over night. Maybe something happens...
> but at a first glance it looks more like the reworked stop_machine code
> triggers a different bug that already is present. Hmmm...

I can make Classic RCU break in 2.6.28-rc3, but I need a 128-CPU machine to
break it.  ;-)

							Thanx, Paul
