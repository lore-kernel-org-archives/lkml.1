Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbZIVI4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbZIVI4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 04:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbZIVI4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 04:56:51 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:34469 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbZIVI4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 04:56:50 -0400
Date: Tue, 22 Sep 2009 14:26:44 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@lists.ozlabs.org, Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [v5 RFC PATCH 0/7]: cpuidle/x86/POWER (REDESIGN): Cleanup idle
	power management code in x86, cleanup drivers/cpuidle/cpuidle.c and
	introduce cpuidle to POWER.
Message-ID: <20090922085644.GA5511@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090922053314.GA6417@linux.vnet.ibm.com> <1253604359.8439.278.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1253604359.8439.278.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-09-22 09:25:59]:

> 
> 
> Much better :-)
> 
> 
> But I'm puzzled by all the per-cpu-ish-ness of the stuff. Why would you
> need to register things on a per-cpu basis?
> 
> Also:
> 
> 
> +       list_for_each(pos, &per_cpu(cpuidle_devices_list, cpu)) {
> +               temp_dev = container_of(pos, struct cpuidle_device,
> +                                       percpu_list[cpu]);
> +               if (dev == temp_dev) {
> +                       list_del(&temp_dev->percpu_list[cpu]);
> +                       cpuidle_remove_state_sysfs(temp_dev);
> +               }
> +       }
> 
> Looks buggy, either you want to break out of the loop on dev ==
> temp_dev, or you want to use list_for_each_safe().
> 
> 
> 

Hi Peter,

There were a couple of buggy issues, which i have cleaned up for the
next iteration.

        * As you pointed out above, the loop is buggy.
        * Also, the percpu_list[NR_CPUS] which i am defining inside
          struct cpuidle_device is wrong. It does not need to be an
          array.

Thanks for the quick turnaround
arun
