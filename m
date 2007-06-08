Return-Path: <linux-kernel-owner+w=401wt.eu-S970594AbXFHUBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970594AbXFHUBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 16:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbXFHUBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 16:01:03 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:53460 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbXFHUBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 16:01:01 -0400
Date: Fri, 8 Jun 2007 13:00:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>,
       LKML <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       RT <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH RT] convert RCU Preempt tasklet into softirq.
Message-ID: <20070608200058.GC18399@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1181180051.18444.31.camel@localhost.localdomain> <20070607041411.GB1783@linux.vnet.ibm.com> <1181226138.18444.54.camel@localhost.localdomain> <20070607161754.GA11941@linux.vnet.ibm.com> <1181240819.10408.14.camel@localhost.localdomain> <20070607210247.GA9390@linux.vnet.ibm.com> <1181316428.10408.30.camel@localhost.localdomain> <20070608193655.GA18399@linux.vnet.ibm.com> <1181331828.10408.34.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181331828.10408.34.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 03:43:48PM -0400, Steven Rostedt wrote:
> On Fri, 2007-06-08 at 12:36 -0700, Paul E. McKenney wrote:
> > On Fri, Jun 08, 2007 at 11:27:08AM -0400, Steven Rostedt wrote:
> 
> > > The first time I compiled it, I forgot the ';' and got a warning there.
> > > But the warning also included "declaring structure softirq_action in
> > > prototype", so I fixed both the ';' and added the struct. I can try
> > > compile without it. But I also know that adding #include <interrupt.h>
> > > in rcupreempt.h caused issues too.
> > 
> > If I leave out both the "struct softirq_action" and the
> > rcu_process_callbacks() declaration,, it compiles for me.
> > 
> > So I guess the rcu_process_callbacks() should be declared static...
> 
> OK, I can update the patch to reflect that. Remember, I didn't learn
> anything from doing this patch, so I have no idea why
> rcu_procell_callbacks was global. I was just keeping to the norm. :-)

Hey, -I- learned something from your doing the patch -- namely that
rcu_process_callbacks() was needlessly non-static.  ;-)

> Actually, I'll make a separate patch for this change. This is a
> different issue.

Sounds good!

						Thanx, Paul
