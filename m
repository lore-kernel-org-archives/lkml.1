Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbYKKQ4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbYKKQ4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 11:56:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbYKKQ4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 11:56:42 -0500
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:50643 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbYKKQ4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 11:56:41 -0500
Message-ID: <4919B7AA.8060801@linux.vnet.ibm.com>
Date: Tue, 11 Nov 2008 22:19:46 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       "gregory.haskins" <gregory.haskins@gmail.com>
Subject: Re: [RFC PATCH v3 3/5] sched: nominate preferred wakeup cpu
References: <20081110181526.562.69941.stgit@drishya.in.ibm.com> <20081110183326.562.37718.stgit@drishya.in.ibm.com> <1226411019.7685.1767.camel@twins> <20081111164825.GS4646@dirshya.in.ibm.com>
In-Reply-To: <20081111164825.GS4646@dirshya.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vaidyanathan Srinivasan wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> [2008-11-11 14:43:39]:
> 
>> On Tue, 2008-11-11 at 00:03 +0530, Vaidyanathan Srinivasan wrote:
>>> When the system utilisation is low and more cpus are idle,
>>> then the process waking up from sleep should prefer to
>>> wakeup an idle cpu from semi-idle cpu package (multi core
>>> package) rather than a completely idle cpu package which
>>> would waste power.
>>>
>>> Use the sched_mc balance logic in find_busiest_group() to
>>> nominate a preferred wakeup cpu.
>>>
>>> This info can be sored in appropriate sched_domain, but
>>> updating this info in all copies of sched_domain is not
>>> practical.  For now lets try with a per-cpu variable
>>> pointing to a common storage in partition sched domain
>>> attribute.  Global variable may not work in partitioned
>>> sched domain case.
>> Would it make sense to place the preferred_wakeup_cpu stuff in the
>> root_domain structure we already have?
> 
> Yep, that will be a good idea.  We can get to root_domain from each
> CPU's rq and we can get rid of the per-cpu pointers for
> preferred_wakeup_cpu as well. I will change the implementation and
> re-post.

Did you see Vatsa's comments? root_domain will no work if you have more than one
preferred_wakeup_cpu per domain.

-- 
	Balbir
