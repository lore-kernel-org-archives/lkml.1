Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbYKKEtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbYKKEtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 23:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbYKKEtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 23:49:07 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:48094 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbYKKEtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 23:49:05 -0500
Date: Tue, 11 Nov 2008 10:22:40 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>
Subject: Re: [RFC PATCH v3 0/5] Tunable sched_mc_power_savings=n
Message-ID: <20081111045240.GO4646@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
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
References: <20081110181526.562.69941.stgit@drishya.in.ibm.com> <1226343016.7685.444.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1226343016.7685.444.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2008-11-10 19:50:16]:

> 
> a quick response, I'll read them more carefully tomorrow:

Hi Peter,

Thanks for the quick review.

> 
>  - why are the preferred cpu things pointers? afaict using just the cpu
> number is both smaller and clearer to the reader.

I would need each cpu within a partitioned sched domain to point to
the _same_ preferred wakeup cpu.  The preferred CPU will be updated in
one place in find_busiest_group() and used by wake_idle.

If I have a per cpu value, then updating it for each cpu in the
partitioned sched domain will be slow.

The actual number of preferred_wakeup_cpu will be equal to the number
of partitions.  If there are no partitions in the sched domains, then
then all per-cpu pointers will point to the same variable.

>  - in patch 5/5 you do:
> 
> +               spin_unlock(&this_rq->lock);
> +               double_rq_lock(this_rq, busiest);
> 
> we call that double_lock_balance()

Will fix this. Did not look for such a routine :)

>  - comments go like:
> 
>  /*
>   * this is a multi-
>   * line comment
>   */

Will fix this too.

Thanks,
Vaidy

