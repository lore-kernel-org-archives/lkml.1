Return-Path: <linux-kernel-owner+w=401wt.eu-S1764006AbYFFQlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764006AbYFFQlj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 12:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbYFFQlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 12:41:31 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:59705 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbYFFQla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 12:41:30 -0400
Date: Fri, 6 Jun 2008 09:41:22 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       minyard@acm.org, dvhltc@us.ibm.com, niv@us.ibm.com
Subject: Re: Recoverable MCA interrupts from NMI handlers?  IPMI and RCU?
Message-ID: <20080606164122.GD8507@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080606152134.GA13641@linux.vnet.ibm.com> <484961FC.5030800@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484961FC.5030800@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2008 at 09:12:44AM -0700, H. Peter Anvin wrote:
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
> 
> In theory, recoverable #MC's can occur anywhere.  It's an exception.

Thank you for the info!  I guess I had better get busy testing the
patch, then.

> >2.	Does the IPMI subsystem make use of RCU read-side primitives
> >	from within SMI handlers?  If so, we need the SMI handlers to
> >	invoke rcu_irq_enter() upon entry and rcu_irq_exit() upon exit
> >	when they are invoked from dynticks idle state.  Or something
> >	similar, depending on restrictions on code within SMI handlers.
> 
> Not sure about that one.  I clearly need to look carefully into this... 
> SMI is quite "special" in that it sets up an entirely new environment; 
> the concept of executing kernel code at SMI level makes me want to run 
> away and hide.

Well, as long as the SMI handlers don't include calls to rcu_read_lock()
and rcu_read_unlock(), then they don't need to include any calls to
rcu_irq_enter() and rcu_irq_exit().  ;-)

							Thanx, Paul
