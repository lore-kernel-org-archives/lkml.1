Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbYF3E6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbYF3E6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 00:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbYF3E6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 00:58:15 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:53199 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbYF3E6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 00:58:14 -0400
Date: Mon, 30 Jun 2008 10:27:37 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: David Collier-Brown <davecb@sun.com>
Cc: Tim Connors <tconnors@astro.swin.edu.au>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <peterz@infradead.org>, dipankar@in.ibm.com,
       balbir@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC v1] Tunable sched_mc_power_savings=n
Message-ID: <20080630043327.GA6276@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: David Collier-Brown <davecb@sun.com>,
	Tim Connors <tconnors@astro.swin.edu.au>,
	Andi Kleen <andi@firstfloor.org>,
	Peter Zijlstra <peterz@infradead.org>, dipankar@in.ibm.com,
	balbir@linux.vnet.ibm.com,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Suresh B Siddha <suresh.b.siddha@intel.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
References: <4863AF57.3040005@linux.vnet.ibm.com> <4863DB29.1020304@firstfloor.org> <20080626185254.GA12416@dirshya.in.ibm.com> <4863F93C.9040102@firstfloor.org> <20080626210025.GB26167@in.ibm.com> <48640C04.9020600@firstfloor.org> <1214516584.12265.10.camel@twins.programming.kicks-ass.net> <48641A7D.6080204@firstfloor.org> <12146282628495-twc@hexane.ssi.swin.edu.au> <4867CE52.8040204@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4867CE52.8040204@sun.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Collier-Brown <davecb@sun.com> [2008-06-29 14:02:58]:

> Andi Kleen <andi@firstfloor.org> said on Fri, 27 Jun 2008 00:38:53 +0200:
>>> Peter Zijlstra wrote:
>>>>> And your workload manager could just nice processes. It should probably
>>>>> do that anyways to tell ondemand you don't need full frequency.
>>>>
>>>> Except that I want my nice 19 distcc processes to utilize as much cpu as
>>>> possible, but just not bother any other stuff I might be doing...
>>>
>>> They already won't do that if you run ondemand and cpufreq. It won't
>>> crank up the frequency for niced processes.
>
>
> Tim Connors then wrote:
>> Shouldn't there be a powernice, just as there is an ionice and a nice?
> Hmmn, how about:
>
> User Commands                                             nice(1)
>
> NAME
>     nice - invoke a command with an altered  priority
>
> SYNOPSIS
>     /usr/bin/nice [-increment | -n increment]  [-s|-i|-e|-p] command  [argu-
>     ment...]
>
> DESCRIPTION
>     The nice utility invokes command, requesting that it be  run
>     with a different  priority.  If -i is specified, the priority
>     of (disk) I/O is modified. If -e is specified, ethernet (or
>     other networking) priority is changed. If -p is specified, power
>     usage priority is changed and if  -s is specified, or none     of -1, 
> -e or -p  is specified, then system scheduling priority
>     is modified...

This is good.  We are exploring powernice.  'Generally' cpu, io and
power nice values should be similar: high or low.  Can we comeup with
use cases where we want to have conflicting nice values for cpu, io
and power?

                CPU     IO      POWER
distcc:         low     low     low
firefox:        low     high    high
ssh/shell:      high    high    high       
X:              high    high    low


I am trying to find answer to the question: Should we have the power
saving tunable as 'nice' value per process or system wide?

How should we interpret the POWER parameter in a datacenter with power
constraint as mentioned in this thread?  Or in a simple case of AC vs
battery in a laptop.

Thanks,
Vaidy

