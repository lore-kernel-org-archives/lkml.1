Return-Path: <linux-kernel-owner+w=401wt.eu-S1759921AbZFQTRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759921AbZFQTRI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 15:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757893AbZFQTQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 15:16:56 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:45372 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667AbZFQTQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 15:16:56 -0400
Date: Thu, 18 Jun 2009 00:46:19 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: venkatesh.pallipadi@intel.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Gautham R Shenoy <ego@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch 0/2] RFC sched: Change nohz ilb logic from poll to push
	model
Message-ID: <20090617191619.GH7961@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090617182649.604970000@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090617182649.604970000@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com> [2009-06-17 11:26:49]:

> Existing nohz idle load balance (ilb) logic uses the pull model, with one
> idle load balancer CPU nominated on any partially idle system and that
> balancer CPU not going into nohz mode. With the periodic tick, the
> balancer does the idle balancing on behalf of all the CPUs in nohz mode.
> 
> This is not very optimal and has few issues:
> * the balancer will continue to have periodic ticks and wakeup
>   frequently (HZ rate), even though it may not have any rebalancing to do on
>   behalf of any of the idle CPUs.
> * On x86 and CPUs that have APIC timer stoppage on idle CPUs, this periodic
>   wakeup can result in an additional interrupt on a CPU doing the timer
>   broadcast.
> * The balancer may end up spending a lot of time doing the balancing on
>   behalf of nohz CPUs, especially with increasing number of sockets and
>   cores in the platform.
> 
> The alternative is to have a push model, where all idle CPUs can enter nohz
> mode and busy CPU kicks one of the idle CPUs to take care of idle balancing
> on behalf of a group of idle CPUs.

Hi Venki,

The idea is very useful and further extends the power savings in idle
system.  However the kick method from busy CPU should not add to
scheduling latency during a sudden burst of work.

Does adding nohz_balancer_kick() in trigger_load_balance() path in
a busy CPU add to its overhead?

 
> Following patches tries that approach. There are still some rough edges
> in the patches related to use of #defines around the code. But, wanted
> to get opinion on this approach as an RFC (not for inclusion into the
> tree yet).

I like the idea but my only concern is the performance impact on busy
cpus with this push model. 

--Vaidy
