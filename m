Return-Path: <linux-kernel-owner+w=401wt.eu-S1753675AbZBRCkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675AbZBRCkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 21:40:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbZBRCka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 21:40:30 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:34505 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbZBRCk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 21:40:29 -0500
Date: Tue, 17 Feb 2009 18:40:25 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: smp.c && barriers (Was: [PATCH 1/4] generic-smp: remove single
	ipi fallback for smp_call_function_many())
Message-ID: <20090218024025.GB7459@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1234820704.30178.396.camel@laptop> <20090216220214.GA10093@redhat.com> <1234823097.30178.406.camel@laptop> <20090216231946.GA12009@redhat.com> <1234862974.4744.31.camel@laptop> <20090217101130.GA8660@wotan.suse.de> <1234866453.4744.58.camel@laptop> <20090217112657.GE26402@wotan.suse.de> <20090217155147.GE6761@linux.vnet.ibm.com> <1234923331.29823.2.camel@vayu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234923331.29823.2.camel@vayu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 06:15:31PM -0800, Suresh Siddha wrote:
> On Tue, 2009-02-17 at 07:51 -0800, Paul E. McKenney wrote:
> > On Tue, Feb 17, 2009 at 12:26:57PM +0100, Nick Piggin wrote:
> > > +	spin_lock(&q->lock);
> > > +	list_replace_init(&q->list, &list);
> > > +	spin_unlock(&q->lock);
> > 
> > OK, I'll bite...
> > 
> > How do we avoid deadlock in the case where a pair of CPUs send to each
> > other concurrently?
> 
> Sender takes the lock with interrupts-disabled. That should prevent any
> deadlock, right?

You are of course correct!  Apologies for my confusion!!!

							Thanx, Paul
