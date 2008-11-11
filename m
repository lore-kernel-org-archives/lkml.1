Return-Path: <linux-kernel-owner+w=401wt.eu-S1756610AbYKKPWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610AbYKKPWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 10:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755935AbYKKPWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 10:22:07 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:47609 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470AbYKKPWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 10:22:05 -0500
Date: Tue, 11 Nov 2008 20:51:26 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>
Subject: Re: [RFC PATCH v3 3/5] sched: nominate preferred wakeup cpu
Message-ID: <20081111152126.GF3593@linux.vnet.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20081110181526.562.69941.stgit@drishya.in.ibm.com> <20081110183326.562.37718.stgit@drishya.in.ibm.com> <1226411019.7685.1767.camel@twins> <491991BE.9080405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491991BE.9080405@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 09:07:58AM -0500, Gregory Haskins wrote:
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

If I understand correctly, we may want to have more than one preferred
cpu in a given sched domain, taking into account node topology i.e if a
given sched domain encompasses two nodes, then we may like to designate
2 preferred wakeup_cpu's, one per node. If that is the case, then
root_domain may not be of use here?

- vatsa
