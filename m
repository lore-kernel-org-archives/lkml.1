Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbYKKRYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbYKKRYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 12:24:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbYKKRYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 12:24:13 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:50425 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbYKKRYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 12:24:11 -0500
Date: Tue, 11 Nov 2008 22:57:50 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       "gregory.haskins" <gregory.haskins@gmail.com>
Subject: Re: [RFC PATCH v3 3/5] sched: nominate preferred wakeup cpu
Message-ID: <20081111172750.GA788@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Balbir Singh <balbir@linux.vnet.ibm.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Suresh B Siddha <suresh.b.siddha@intel.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
	Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
	Andi Kleen <andi@firstfloor.org>,
	David Collier-Brown <davecb@sun.com>,
	Tim Connors <tconnors@astro.swin.edu.au>,
	Max Krasnyansky <maxk@qualcomm.com>,
	"gregory.haskins" <gregory.haskins@gmail.com>
References: <20081110181526.562.69941.stgit@drishya.in.ibm.com> <20081110183326.562.37718.stgit@drishya.in.ibm.com> <1226411019.7685.1767.camel@twins> <20081111164825.GS4646@dirshya.in.ibm.com> <4919B7AA.8060801@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4919B7AA.8060801@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Balbir Singh <balbir@linux.vnet.ibm.com> [2008-11-11 22:19:46]:

> Vaidyanathan Srinivasan wrote:
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> [2008-11-11 14:43:39]:
> > 
> >> On Tue, 2008-11-11 at 00:03 +0530, Vaidyanathan Srinivasan wrote:
> >>> When the system utilisation is low and more cpus are idle,
> >>> then the process waking up from sleep should prefer to
> >>> wakeup an idle cpu from semi-idle cpu package (multi core
> >>> package) rather than a completely idle cpu package which
> >>> would waste power.
> >>>
> >>> Use the sched_mc balance logic in find_busiest_group() to
> >>> nominate a preferred wakeup cpu.
> >>>
> >>> This info can be sored in appropriate sched_domain, but
> >>> updating this info in all copies of sched_domain is not
> >>> practical.  For now lets try with a per-cpu variable
> >>> pointing to a common storage in partition sched domain
> >>> attribute.  Global variable may not work in partitioned
> >>> sched domain case.
> >> Would it make sense to place the preferred_wakeup_cpu stuff in the
> >> root_domain structure we already have?
> > 
> > Yep, that will be a good idea.  We can get to root_domain from each
> > CPU's rq and we can get rid of the per-cpu pointers for
> > preferred_wakeup_cpu as well. I will change the implementation and
> > re-post.
> 
> Did you see Vatsa's comments? root_domain will no work if you have more than one
> preferred_wakeup_cpu per domain.

Hi Balbir,

I just saw Vatsa's comments.  We have similar limitation with the
current implementation also.  sched_domain_attr dattr is also per
partitioned domain and not per numa node.  

In the current implementation we can get rid of the per-cpu variables
and use root_domain.  Later we can have an array in root_domain and
index it based on the cpu's node.

Thanks,
Vaidy
