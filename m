Return-Path: <linux-kernel-owner+w=401wt.eu-S1761991AbZDCHE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761991AbZDCHE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 03:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755119AbZDCHEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 03:04:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43554 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbZDCHEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 03:04:46 -0400
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       "Balbir Singh" <balbir@in.ibm.com>
Subject: Re: [PATCH v2 1/2] sched: Nominate idle load balancer from a semi-idle package.
From: Andi Kleen <andi@firstfloor.org>
References: <20090402123607.14569.33649.stgit@sofia.in.ibm.com>
	<20090402123829.14569.67639.stgit@sofia.in.ibm.com>
Date: Fri, 03 Apr 2009 09:04:42 +0200
In-Reply-To: <20090402123829.14569.67639.stgit@sofia.in.ibm.com> (Gautham R. Shenoy's message of "Thu, 02 Apr 2009 18:08:29 +0530")
Message-ID: <87hc16kyk5.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gautham R Shenoy <ego@in.ibm.com> writes:
>
> Improve the algorithm to nominate the idle load balancer from a semi idle
> cores/packages thereby increasing the probability of the cores/packages being
> in deeper sleep states for longer duration.

The basic patch looks good.

In theory you could also look for a nearby nohz balancer in the end
to optimize traffic on the interconnect of a larger NUMA system, 
but it's probably not worth it.

>
> The algorithm is activated only when sched_mc/smt_power_savings != 0.

But it seems to me that this check could be dropped and doing it
unconditionally, because idle balancing doesn't need much memory
bandwith or cpu power, so always putting it nearby is good.

-Ani

-- 
ak@linux.intel.com -- Speaking for myself only.
