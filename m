Return-Path: <linux-kernel-owner+w=401wt.eu-S1767210AbXEBSw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767210AbXEBSw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 14:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767211AbXEBSwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 14:52:55 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35413 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767210AbXEBSwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 14:52:54 -0400
Date: Thu, 3 May 2007 00:22:35 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Nathan Lynch <ntl@pobox.com>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, ashok.raj@intel.com,
       heiko.carstens@de.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: /sys/devices/system/cpu/*: Present cpus or Possible cpus
Message-ID: <20070502185235.GA6859@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070502110022.GA13040@in.ibm.com> <20070502163757.GF30688@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502163757.GF30688@localdomain>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 11:37:57AM -0500, Nathan Lynch wrote:
> Hi Gautham-
> 
> I believe that the powerpc behavior was established before
> cpu_present_map was introduced.

Ok. I guess the same is the reason with a few other architectures like 
s390.

> 
> 
> > I am not entirely surely if it's due cpu hotplug because 
> > both i386 and powerpc support it!
> 
> powerpc also supports processor add and remove (as opposed to
> online/offline); i386 does not AFAIK.  I think this may be a reason
> for the difference.
> 

Well, ACPI seems to be supporting it.
acpi_processor_hotadd_init() in drivers/acpi/processor_core.c appears 
to be equivalent to pSeries_add_processor(), except that the former
creates the sysfs entries on a hot add, while the later just updates
the cpu_present map.

> 
> > When I do a 
> > "echo 1 > /sys/devices/system/cpu/cpuX/online" on a power box as root, 
> > I might get "-bash: echo: write error: Invalid argument" 
> > because cpuX might not be present!
> >
> > In case of lpar, cpu_present_map need not necessarily be equal to
> > cpu_possible_map, so the above error is observable.
> 
> Working as intended.  You have to add a cpu to the partition before
> you can online it.
> 
> 
> > Is this discrepency intentional ?
> > Or is it due to the fact that in most cases,
> > cpu_present_map == cpu_possible_map, so lets not bother about it :-?
> 
> I think it's the inevitable result when architectures are free to
> invent their own versions of the same sysfs interface.  But is it
> really causing a problem in this case?
> 

No, it is not causing any problems :-)
I was just overwhelmed to see cpu0 to cpu77 in the sysfs entries on the
lpar which I was using. Looking at the kernel code, I figured out that
the MAX_CPUS for that lpar was 39 and each virtual cpu was probably
running 2 threads. That explained the 78 sysfs entries.

Thanks for the explaination anyway.
Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
