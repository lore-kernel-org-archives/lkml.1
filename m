Return-Path: <linux-kernel-owner+w=401wt.eu-S1755005AbZDHM14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbZDHM14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755868AbZDHM1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:27:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43817 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759367AbZDHM1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:27:23 -0400
Date: Wed, 8 Apr 2009 14:26:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ming Lei <tom.leiming@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: pm-hibernate : possible circular locking dependency detected
Message-ID: <20090408122613.GD18581@elte.hu>
References: <d82e647a0904050253n31bd2654s9b216465eec4d038@mail.gmail.com> <200904071356.29914.rusty@rustcorp.com.au> <1239087953.798.5513.camel@twins> <200904081247.08712.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904081247.08712.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Tuesday 07 April 2009 16:35:53 Peter Zijlstra wrote:
> > On Tue, 2009-04-07 at 13:56 +0930, Rusty Russell wrote:
> > > Looks like this will be fixed by Andrew's work-on-cpu-in-own-thread
> > > patch which I just put out the pull request for.
> > 
> > Would it make sense to teach it about a short-circuit like:
> > 
> > work_on_cpu() {
> > 
> >   if (cpumask_weight(current->cpus_allowed) == 1 && 
> >       smp_processor_id() == cpu)
> >     return do_work_right_here();
> 
> Does that happen much?  I guess put a counter in and see?

a temporary tracepoint or trace_printk() for the workqueue tracer 
would also tell this, without any long-term overhead (it will be 
easy to remove it).

	Ingo
