Return-Path: <linux-kernel-owner+w=401wt.eu-S1761712AbYBYX6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761712AbYBYX6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 18:58:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761500AbYBYX55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 18:57:57 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:42878 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759130AbYBYX5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 18:57:55 -0500
Subject: Re: [PATCH [RT] 08/14] add a loop counter based timeout mechanism
From: Sven-Thorsten Dietrich <sdietrich@novell.com>
To: Andi Kleen <ak@suse.de>
Cc: gregory.haskins@gmail.com, paulmck@linux.vnet.ibm.com,
       "Bill Huey (hui)" <bill.huey@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>, mingo@elte.hu,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, rostedt@goodmis.org,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       kevin@hilman.org, cminyard@mvista.com, dsingleton@mvista.com,
       dwalker@mvista.com, npiggin@suse.de, dsaxena@plexity.net,
       gregkh@suse.de, pmorreale@novell.com, mkohari@novell.com
In-Reply-To: 20080223123100.GB9021@bingen.suse.de
References: <20080221152504.4804.8724.stgit@novell1.haskins.net>
	 <20080221152707.4804.59177.stgit@novell1.haskins.net>
	 <200802211741.10299.ak@suse.de> <20080222190814.GD11213@linux.vnet.ibm.com>
	 <9810cff90802221119j23818e74g2721512a693a0a01@mail.gmail.com>
	 <9810cff90802221121s216f69f4k4a5f39eaaf11dd7f@mail.gmail.com>
	 <20080222194341.GE11213@linux.vnet.ibm.com>
	 <1203710145.4772.107.camel@sven.thebigcorporation.com>
	 <20080222202316.GF11213@linux.vnet.ibm.com> <47BF46AF.7010200@gmail.com>
	 20080223123100.GB9021@bingen.suse.de
Content-Type: text/plain
Date: Mon, 25 Feb 2008 15:52:06 -0800
Message-Id: <1203983526.16711.171.camel@sven.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-02-23 at 13:31 +0100, Andi Kleen wrote:
> > *) compute the context-switch pair time average for the system.  This is 
> > your time threshold (CSt).
> 

Hi Andi,

> This is not a uniform time. Consider the difference between
> context switch on the same hyperthread, context switch between cores
> on a die, context switch between sockets, context switch between
> distant numa nodes. You could have several orders of magnitude
> between all those.
> 
> >
> > *) For each lock, maintain an average hold-time (AHt) statistic (I am 
> > assuming this can be done cheaply...perhaps not).
> 
> That would assume that the hold times are very uniform. But what happens
> when you e.g. have a workload where 50% of the lock aquisitions are short 
> and 30% are long? 
> 
> I'm a little sceptical of such "too clever" algorithms.
> 

I agree, this does not make any sense until you get to very large SMP
systems - and only iff it can be demonstrated, that the overhead
associated with lock statistics and including some notion of the context
switch overhead still comes out with a net gain.

There is some notion of task-routing in the RT scheduler already, and
this is quite a clever little algorithm. 

I see no reason, why the scheduler should not eventually take directly
into account (when balancing), the quantifiable context-switch and CPU
overhead of moving a task to a distant processor.

In fact, for a deadline-based scheduler working on high-frequency tasks,
given that the times can switch so radically, this is would be
requiredOnve context-switch-overhead data is available to the scheduler,
there is no particular reason why adaptive locking could not also
utilize that data.

Sven

> -Andi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

