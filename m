Return-Path: <linux-kernel-owner+w=401wt.eu-S1758003AbYE2QbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003AbYE2QbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 12:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbYE2Qa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 12:30:59 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63547 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbYE2Qa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 12:30:58 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5306"; a="3495998"
Message-ID: <483EDA40.4040100@qualcomm.com>
Date: Thu, 29 May 2008 09:30:56 -0700
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, rdunlap@xenotime.net
Subject: Re: [PATCH] [genirq] Expose default irq affinity mask (take 2)
References: <1211925713-11253-1-git-send-email-maxk@qualcomm.com> <20080528233712.5a95b63e.pj@sgi.com>
In-Reply-To: <20080528233712.5a95b63e.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Review comments ... just nits ... patch looks good overall.
> 
> 1.  Trailing whitespace on Doc lines:
> 	+irq subdir is one subdir for each IRQ, and two files; default_smp_affinity and 
> 	+smp_affinity is a bitmask, in which you can specify which CPUs can handle the 
> 	+default_smp_affinity mask applies to all non-active IRQs. In other words IRQs 
> 
>     (Granted, there are already about 300 hundred trailing whitespaces in that file,
>     so this is like trying not to spit into the Pacific ocean ;).
> 
> 2.  I think that the following line should be removed from kernel/irq/proc.c:
> 
> 	+extern cpumask_t irq_default_affinity;
> 
> 	(You already pick up that extern from <linux/irq.h>, as it should be.)
> 
> 3.  The trailing period was missing after the line:
> 
> 	irq subdir is one subdir for each IRQ, and one file; prof_cpu_mask
> 
>     Might as well add it, after "prof_cpu_mask", while you're there anyway.
> 
> 4.  In the doc:
> 
>     +  > echo 1 > /proc/irq/5/smp_affinity
>     +
>     +This means that only the first CPU will handle the IRQ, but you can also echo
>     +5 which means that only the first and fourth CPU can handle the IRQ.
> 
>     it might be a good idea to not use "5" for both the example CPU
>     and for the example mask.  It increases the chance of a reader
>     getting confused as to which 5 is which.  Perhaps try a different
>     example CPU, such as:
> 
> 	     echo 1 > /proc/irq/2/smp_affinity
> 
> 5. The original Doc text, before your patch, stated that the
>    "The contents of the prof_cpu_mask file ... by default." 
> 
>    After your patch, this statement that the default contents
>    of the prof_cpu_mask file was ffffffff got lost.
>    
> 6. The grammar of the following got mangled a little:
> 
>     +default_smp_affinity mask applies to all non-active IRQs. In other words IRQs
>     +that have not been allocated/activated yet (for which /proc/irq/[0-9]* directory
>     +does not exist).
> 
>     Perhaps the following is better:
> 
>     +The default_smp_affinity mask applies to all non-active IRQs, which are the
>     +IRQs which have not yet been allocated/activated, and hence which lack a
>     +/proc/irq/[0-9]* directory.
>     
> 7.  The lines of code (with their definition of cpumask_t tmp):
>       +	cpus_and(tmp, new_value, cpu_online_map);
>       +	if (cpus_empty(tmp))
>       +		return -EINVAL;
> 
>     can be better written, I'm pretty sure, as:
>       +	if (!cpus_intersects(new_value, cpu_online_map))
>       +		return -EINVAL;
> 
>     Minimizing cpumask_t's as local stack variables is a good thing,
>     especially on some of the high (thousands) count CPU systems that
>     SGI is developing.

Nice (thorough) review. Thanx. I'll update the patch based on your comments.
#7 was definitely "monkey see, monkey do". I cut and pasted it from existing 
mask update without much thought. Will update both places.

Thanx
Max


