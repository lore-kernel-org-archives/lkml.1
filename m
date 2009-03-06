Return-Path: <linux-kernel-owner+w=401wt.eu-S1756412AbZCFR1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412AbZCFR1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 12:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbZCFR1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 12:27:39 -0500
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:47818 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbZCFR1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 12:27:38 -0500
Date: Fri, 6 Mar 2009 22:56:54 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Arun R Bharadwaj <arun@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu, andi@firstfloor.org,
       venkatesh.pallipadi@intel.com, vatsa@linux.vnet.ibm.com,
       arjan@infradead.org, svaidy@linux.vnet.ibm.com
Subject: Re: [v2 PATCH 4/4] timers: logic to enable timer migration.
Message-ID: <20090306172654.GA18600@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20090304121249.GA9855@linux.vnet.ibm.com> <20090304121937.GE9855@linux.vnet.ibm.com> <20090305162329.GA5294@redhat.com> <20090306032122.GA32316@in.ibm.com> <20090306145002.GA5828@redhat.com> <20090306154933.GA12494@in.ibm.com> <20090306170834.GA11271@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090306170834.GA11271@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 06:08:34PM +0100, Oleg Nesterov wrote:
> On 03/06, Gautham R Shenoy wrote:
> >
> > .load_balancer is the idle load balancer CPU which performs
> > load balancing on behalf of all the idle cpus in the system.
> > It's the only idle CPU which doesn't turn off it's ticks.
> >
> > This CPU relinquishes it's role as the idle load balancer when
> > a) it finds a runnable task in it's runqueue, i.e before exiting idle
> >    state.
> > OR
> > b) all the CPUs in the system go idle.
> >
> > Since it doesn't turn off it's ticks, it calls
> > select_nohz_load_balancer() every scheduler tick, and thus can observe
> > that it's no longer set in cpu_active_map within a tick or two.
> >
> > Also, the cpu_down() path calls migrate_timers() in CPU_DEAD:,i.e after
> > the CPU has gone down. But to take the CPU down, we would have invoked
> > the stop_machine_run() code on that CPU, which by itself would make the
> > CPU relinquish it's role as the idle load balancer owing to condition (a).
> >
> > Thus I believe, mod_timer() can never migrate a timer on to a DEAD CPU,
> > during/_after_ we invoke migrate_timers() from the CPU_DEAD callpath.
> 
> OK, thanks a lot for your explanation!

Glad it helped :-)
> 
> Oleg.

-- 
Thanks and Regards
gautham
