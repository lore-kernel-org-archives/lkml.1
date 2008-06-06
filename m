Return-Path: <linux-kernel-owner+w=401wt.eu-S933298AbYFFVeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298AbYFFVeA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 17:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759356AbYFFVdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 17:33:51 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:55587 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756850AbYFFVdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 17:33:51 -0400
Date: Fri, 6 Jun 2008 14:33:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Corey Minyard <minyard@acm.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, dvhltc@us.ibm.com, niv@us.ibm.com
Subject: Re: Recoverable MCA interrupts from NMI handlers?  IPMI and RCU?
Message-ID: <20080606213345.GD25053@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080606152134.GA13641@linux.vnet.ibm.com> <4849A3AC.5090107@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4849A3AC.5090107@acm.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2008 at 03:53:00PM -0500, Corey Minyard wrote:
> Paul E. McKenney wrote:
> >Hello!
> >
> >A couple of questions about the x86 architecture...
> >
> >1.	Can recoverable machine-check exceptions occur from within
> >	NMI handlers?  If so, there is a bug in preemptable RCU's
> >	CONFIG_NO_HZ handling that could be fixed by a patch something
> >	like the one shown below (untested, probably does not even
> >	compile).
> >
> >2.	Does the IPMI subsystem make use of RCU read-side primitives
> >	from within SMI handlers?  If so, we need the SMI handlers to
> >	invoke rcu_irq_enter() upon entry and rcu_irq_exit() upon exit
> >	when they are invoked from dynticks idle state.  Or something
> >	similar, depending on restrictions on code within SMI handlers.
> >  
> If you mean the IPMI driver, it does not tie into any SMI.  It 
> theoretically could since there's a bit for that in the watchdog timer, 
> but there's been no demand and I haven't looked at it.  I guess it would 
> be better than an NMI.
> 
> If it did tie in, it would most likely just panic to get useful 
> information out before the watchdog reset the system.

Thanks for the info!  I will stop worrying about SMIs and RCU, then.

						Thanx, Paul
