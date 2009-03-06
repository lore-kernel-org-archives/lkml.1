Return-Path: <linux-kernel-owner+w=401wt.eu-S1755105AbZCFDVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbZCFDVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 22:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbZCFDVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 22:21:45 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:48872 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbZCFDVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 22:21:45 -0500
Date: Fri, 6 Mar 2009 08:51:22 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Arun R Bharadwaj <arun@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu, andi@firstfloor.org,
       venkatesh.pallipadi@intel.com, vatsa@linux.vnet.ibm.com,
       arjan@infradead.org, svaidy@linux.vnet.ibm.com
Subject: Re: [v2 PATCH 4/4] timers: logic to enable timer migration.
Message-ID: <20090306032122.GA32316@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20090304121249.GA9855@linux.vnet.ibm.com> <20090304121937.GE9855@linux.vnet.ibm.com> <20090305162329.GA5294@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305162329.GA5294@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 05:23:29PM +0100, Oleg Nesterov wrote:
> On 03/04, Arun R Bharadwaj wrote:
> >
> > +++ linux.trees.git/kernel/sched.c
> > @@ -4009,6 +4009,11 @@ static struct {
> >  	.load_balancer = ATOMIC_INIT(-1),
> >  };
> >
> > +inline int get_nohz_load_balancer(void)
> 
> inline?
> 
> > +{
> > +	return atomic_read(&nohz.load_balancer);
> > +}
> 
> Shouldn't we reset .load_balancer when this CPU is CPU_DOWN'ed ?
> Otherwise the timer can migrate to the dead CPU.

In the select_nohz_load_balancer() code, we check if this CPU is in the
cpu_active_map. If no, then this CPU relinquishes being the idle
load balancer. Also, the timer migration code in the CPU down path would
migrate any timers queued onto this CPU, right ?

> 
> Oleg.

-- 
Thanks and Regards
gautham
