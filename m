Return-Path: <linux-kernel-owner+w=401wt.eu-S1754923AbZCFRMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbZCFRMM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 12:12:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313AbZCFRL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 12:11:57 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49749 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941AbZCFRL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 12:11:56 -0500
Date: Fri, 6 Mar 2009 18:08:34 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Arun R Bharadwaj <arun@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu, andi@firstfloor.org,
       venkatesh.pallipadi@intel.com, vatsa@linux.vnet.ibm.com,
       arjan@infradead.org, svaidy@linux.vnet.ibm.com
Subject: Re: [v2 PATCH 4/4] timers: logic to enable timer migration.
Message-ID: <20090306170834.GA11271@redhat.com>
References: <20090304121249.GA9855@linux.vnet.ibm.com> <20090304121937.GE9855@linux.vnet.ibm.com> <20090305162329.GA5294@redhat.com> <20090306032122.GA32316@in.ibm.com> <20090306145002.GA5828@redhat.com> <20090306154933.GA12494@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090306154933.GA12494@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06, Gautham R Shenoy wrote:
>
> .load_balancer is the idle load balancer CPU which performs
> load balancing on behalf of all the idle cpus in the system.
> It's the only idle CPU which doesn't turn off it's ticks.
>
> This CPU relinquishes it's role as the idle load balancer when
> a) it finds a runnable task in it's runqueue, i.e before exiting idle
>    state.
> OR
> b) all the CPUs in the system go idle.
>
> Since it doesn't turn off it's ticks, it calls
> select_nohz_load_balancer() every scheduler tick, and thus can observe
> that it's no longer set in cpu_active_map within a tick or two.
>
> Also, the cpu_down() path calls migrate_timers() in CPU_DEAD:,i.e after
> the CPU has gone down. But to take the CPU down, we would have invoked
> the stop_machine_run() code on that CPU, which by itself would make the
> CPU relinquish it's role as the idle load balancer owing to condition (a).
>
> Thus I believe, mod_timer() can never migrate a timer on to a DEAD CPU,
> during/_after_ we invoke migrate_timers() from the CPU_DEAD callpath.

OK, thanks a lot for your explanation!

Oleg.

