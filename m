Return-Path: <linux-kernel-owner+w=401wt.eu-S1763368AbYFFRgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763368AbYFFRgz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 13:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbYFFRgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 13:36:44 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61869 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754656AbYFFRgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 13:36:44 -0400
Date: Fri, 6 Jun 2008 18:04:12 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, minyard@acm.org,
       dvhltc@us.ibm.com, niv@us.ibm.com
Subject: Re: Recoverable MCA interrupts from NMI handlers?  IPMI and RCU?
In-Reply-To: <20080606164122.GD8507@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.55.0806061800130.4127@cliff.in.clinika.pl>
References: <20080606152134.GA13641@linux.vnet.ibm.com> <484961FC.5030800@zytor.com>
 <20080606164122.GD8507@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008, Paul E. McKenney wrote:

> > >2.	Does the IPMI subsystem make use of RCU read-side primitives
> > >	from within SMI handlers?  If so, we need the SMI handlers to
> > >	invoke rcu_irq_enter() upon entry and rcu_irq_exit() upon exit
> > >	when they are invoked from dynticks idle state.  Or something
> > >	similar, depending on restrictions on code within SMI handlers.
> > 
> > Not sure about that one.  I clearly need to look carefully into this... 
> > SMI is quite "special" in that it sets up an entirely new environment; 
> > the concept of executing kernel code at SMI level makes me want to run 
> > away and hide.
> 
> Well, as long as the SMI handlers don't include calls to rcu_read_lock()
> and rcu_read_unlock(), then they don't need to include any calls to
> rcu_irq_enter() and rcu_irq_exit().  ;-)

 You can't really call any non-trivial protected mode code from the system
management mode as they run from different virtual address spaces each.  
What is run in the SMM is meant to be like firmware, run transparently to
the rest of the system.  In real life limitations of hardware and bugs in
software make it less transparent than one could wish, but there you go.

  Maciej
