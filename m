Return-Path: <linux-kernel-owner+w=401wt.eu-S1760350AbYHHVAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760350AbYHHVAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 17:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbYHHVAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:00:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42560 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771AbYHHVAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:00:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Langsdorf, Mark" <mark.langsdorf@amd.com>
Subject: Re: Regression in 2.6.27-rc1 for set_cpus_allowed_ptr
Date: Fri, 8 Aug 2008 23:03:39 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "lkml" <linux-kernel@vger.kernel.org>, Gautham R Shenoy <ego@in.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
References: <6453C3CB8E2B3646B0D020C112613273C5AC5A@sausexmb4.amd.com>
In-Reply-To: <6453C3CB8E2B3646B0D020C112613273C5AC5A@sausexmb4.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808082303.41068.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding CCs]

On Friday, 8 of August 2008, Langsdorf, Mark wrote:
> One of my co-workers noticed that the powernow-k8
> driver no longer restarts when a CPU core is 
> hot-disabled and then hot-enabled on AMD quad-core
> systems.  
> 
> The following comands work fine on 2.6.26 and fail 
> on 2.6.27-rc1:
> 
> echo 0 > /sys/devices/system/cpu/cpu3/online
> echo 1 > /sys/devices/system/cpu/cpu3/online
> find /sys -name cpufreq
> 
> For 2.6.26, the find will return a cpufreq
> directory for each processor.  In 2.6.27-rc1,
> the cpu3 directory is missing.
> 
> After digging through the code, the following
> logic is failing when the core is hot-enabled
> at runtime.  The code works during the boot
> sequence.
> 
> 	cpumask_t = current->cpus_allowed;
> 	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
> 	if (smp_processor_id() != cpu)
> 		return -ENODEV;
> 
> The objective is to move to the specific CPU and
> test it's MSRs to see if it is supported.  For
> some reason, it isn't working.  Any suggestions
> on how to fix this are appreciated.
> 
> -Mark Langdsorf
> Operating System Research Center
> AMD
