Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbYB2EyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbYB2EyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 23:54:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754565AbYB2Exv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 23:53:51 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:58105 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438AbYB2Exu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 23:53:50 -0500
Date: Thu, 28 Feb 2008 20:53:28 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: ego@in.ibm.com, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ted Tso <tytso@us.ibm.com>,
       dvhltc@us.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
       Josh Triplett <josh@freedesktop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH 4/6] Preempt-RCU: Implementation
Message-ID: <20080229045328.GA18687@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20071213170348.GA25981@in.ibm.com> <20071213171658.GE25981@in.ibm.com> <200802290534.57040.zippel@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802290534.57040.zippel@linux-m68k.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 05:34:54AM +0100, Roman Zippel wrote:
> Hi,
> 
> On Thursday 13. December 2007, Gautham R Shenoy wrote:
> 
> > diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
> > index c64ce9c..06cafcc 100644
> > --- a/kernel/Kconfig.preempt
> > +++ b/kernel/Kconfig.preempt
> > @@ -63,3 +63,41 @@ config PREEMPT_BKL
> >  	  Say Y here if you are building a kernel for a desktop system.
> >  	  Say N if you are unsure.
> >
> > +choice
> > +	prompt "RCU implementation type:"
> > +	default CLASSIC_RCU
> > +
> > +config CLASSIC_RCU
> > +	bool "Classic RCU"
> > +	help
> > +	  This option selects the classic RCU implementation that is
> > +	  designed for best read-side performance on non-realtime
> > +	  systems.
> > +
> > +	  Say Y if you are unsure.
> > +
> > +config PREEMPT_RCU
> > +	bool "Preemptible RCU"
> > +	depends on PREEMPT
> > +	help
> > +	  This option reduces the latency of the kernel by making certain
> > +	  RCU sections preemptible. Normally RCU code is non-preemptible, if
> > +	  this option is selected then read-only RCU sections become
> > +	  preemptible. This helps latency, but may expose bugs due to
> > +	  now-naive assumptions about each RCU read-side critical section
> > +	  remaining on a given CPU through its execution.
> > +
> > +	  Say N if you are unsure.
> > +
> > +endchoice
> 
> Why got this moved into init/Kconfig?

Because there are some arches that don't have kernel/Kconfig.preempt,
its earlier home.  Therefore, putting it into kernel/Kconfig.preempt
broke those arches' builds by supplying neither PREEMPT_RCU nor
CLASSIC_RCU.

> Now it's somewhere in the root menu, not really belonging to anything.

Do you have a suggested location?

> Also why is this a choice? Are more RCU types planned?

I don't expect additional drop-in replacements for RCU, though people
are certainly free to experiment if they wish.  It is a choice because
this gives people a very clear idea of the two options and because
it makes the implementation a bit cleaner.

							Thanx, Paul
