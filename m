Return-Path: <linux-kernel-owner+w=401wt.eu-S1754303AbYKKROY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbYKKROY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 12:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbYKKRON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 12:14:13 -0500
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:49239 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbYKKROL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 12:14:11 -0500
Date: Tue, 11 Nov 2008 22:47:51 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>
Subject: Re: [RFC PATCH v3 3/5] sched: nominate preferred wakeup cpu
Message-ID: <20081111171751.GV4646@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Gregory Haskins <gregory.haskins@gmail.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Suresh B Siddha <suresh.b.siddha@intel.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
	Andi Kleen <andi@firstfloor.org>,
	David Collier-Brown <davecb@sun.com>,
	Tim Connors <tconnors@astro.swin.edu.au>,
	Max Krasnyansky <maxk@qualcomm.com>
References: <20081110181526.562.69941.stgit@drishya.in.ibm.com> <20081110183326.562.37718.stgit@drishya.in.ibm.com> <1226411019.7685.1767.camel@twins> <491991BE.9080405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <491991BE.9080405@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gregory Haskins <gregory.haskins@gmail.com> [2008-11-11 09:07:58]:

> Peter Zijlstra wrote:
> > On Tue, 2008-11-11 at 00:03 +0530, Vaidyanathan Srinivasan wrote:
> >   
> >> When the system utilisation is low and more cpus are idle,
> >> then the process waking up from sleep should prefer to
> >> wakeup an idle cpu from semi-idle cpu package (multi core
> >> package) rather than a completely idle cpu package which
> >> would waste power.
> >>
> >> Use the sched_mc balance logic in find_busiest_group() to
> >> nominate a preferred wakeup cpu.
> >>
> >> This info can be sored in appropriate sched_domain, but
> >> updating this info in all copies of sched_domain is not
> >> practical.  For now lets try with a per-cpu variable
> >> pointing to a common storage in partition sched domain
> >> attribute.  Global variable may not work in partitioned
> >> sched domain case.
> >>     
> >
> > Would it make sense to place the preferred_wakeup_cpu stuff in the
> > root_domain structure we already have?
> >   
> 
> From the description, this is exactly what the root-domains were created
> to solve.
> 
> Vaidyanathan,  just declare your object in "struct root_domain" and
> initialize it in init_rootdomain() in kernel/sched.c, and then access it
> via rq->rd to take advantage of this infrastructure.  It will
> automatically follow any partitioning that happens to be configured.

Yep, I agree.  I will use root_domain for this purpose in the next
revision.

Thanks,
Vaidy
