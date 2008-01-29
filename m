Return-Path: <linux-kernel-owner+w=401wt.eu-S1758654AbYA2MTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654AbYA2MTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 07:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbYA2MSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 07:18:52 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:52160 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbYA2MSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 07:18:51 -0500
Date: Tue, 29 Jan 2008 18:02:23 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Paul Jackson <pj@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steve Grubb <sgrubb@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       "Li, Tong N" <tong.n.li@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Menage <menage@google.com>,
       David Rientjes <rientjes@google.com>
Subject: Re: scheduler scalability - cgroups, cpusets and load-balancing
Message-ID: <20080129123223.GM1044@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <1201600428.28547.87.camel@lappy> <1201604243.28547.101.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201604243.28547.101.camel@lappy>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 11:57:22AM +0100, Peter Zijlstra wrote:
> On Tue, 2008-01-29 at 10:53 +0100, Peter Zijlstra wrote:
> 
> > My thoughts were to make stronger use of disjoint cpu-sets. cgroups and
> > cpusets are related, in that cpusets provide a property to a cgroup.
> > However, load_balance_monitor()'s interaction with sched domains
> > confuses me - it might DTRT, but I can't tell.
> > 
> > [ It looks to me it balances a group over the largest SD the current cpu
> >   has access to, even though that might be larger than the SD associated
> >   with the cpuset of that particular cgroup. ]
> 
> Hmm, with a bit more thought I think that does indeed DTRT. Because, if
> the cpu belongs to a disjoint cpuset, the highest sd (with
> load-balancing enabled) would be that. Right?

Hi Peter,
	Yes, I was having this in mind when I wrote the load_balance_monitor() 
function - to only balance across cpus that form a disjoint cpuset in the 
system.

> [ Just a bit of a shame we have all cgroups represented on each cpu. ]

After reading your explanation in the other mail abt what you mean here,
I agree. Your suggestion to remove/add cfs_rq from/to the leaf_cfs_rq_list
upon dequeue_of_last_task/enqueue_of_first_task  AND

> Also, might be a nice idea to split the daemon up if there are indeed
> disjoint sets - currently there is only a single daemon which touches
> the whole system.

the above suggestions seems like good ideas. I can also look at reducing
the frequency at which the thread runs ..

-- 
Regards,
vatsa
