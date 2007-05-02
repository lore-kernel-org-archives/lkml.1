Return-Path: <linux-kernel-owner+w=401wt.eu-S2993493AbXEBQec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993493AbXEBQec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 12:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993497AbXEBQec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 12:34:32 -0400
Received: from sceptre.pobox.com ([207.106.133.20]:38610 "EHLO
	sceptre.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993493AbXEBQea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 12:34:30 -0400
Date: Wed, 2 May 2007 11:37:57 -0500
From: Nathan Lynch <ntl@pobox.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, ashok.raj@intel.com,
       heiko.carstens@de.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: /sys/devices/system/cpu/*: Present cpus or Possible cpus
Message-ID: <20070502163757.GF30688@localdomain>
References: <20070502110022.GA13040@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502110022.GA13040@in.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gautham-

Gautham R Shenoy wrote:
> 
> Looking at the topology_init() code, I observe that the meaning of
> the cpuX/ directory entries in /sys/devices/system/cpu/ might be
> different for different architectures. 
> 
> Looks like, in case of i386, ia64, m32, mips etc, the cpuX directory entries
> represent the "present cpus".
> 
> However, in case of powerpc, s390 etc, the cpuX entries represent the
> "possible cpus".
> 
> Wondering if there is any particular reason for this discrepancy.

I believe that the powerpc behavior was established before
cpu_present_map was introduced.


> I am not entirely surely if it's due cpu hotplug because 
> both i386 and powerpc support it!

powerpc also supports processor add and remove (as opposed to
online/offline); i386 does not AFAIK.  I think this may be a reason
for the difference.


> When I do a 
> "echo 1 > /sys/devices/system/cpu/cpuX/online" on a power box as root, 
> I might get "-bash: echo: write error: Invalid argument" 
> because cpuX might not be present!
>
> In case of lpar, cpu_present_map need not necessarily be equal to
> cpu_possible_map, so the above error is observable.

Working as intended.  You have to add a cpu to the partition before
you can online it.


> Is this discrepency intentional ?
> Or is it due to the fact that in most cases,
> cpu_present_map == cpu_possible_map, so lets not bother about it :-?

I think it's the inevitable result when architectures are free to
invent their own versions of the same sysfs interface.  But is it
really causing a problem in this case?

