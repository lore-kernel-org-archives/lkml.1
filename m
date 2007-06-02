Return-Path: <linux-kernel-owner+w=401wt.eu-S1761925AbXFBB7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761925AbXFBB7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 21:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758877AbXFBB73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 21:59:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:14011 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758847AbXFBB72 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 21:59:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,374,1175497200"; 
   d="scan'208";a="250002580"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Dependent CPU core speed reporting not updated with CPUFREQ_SHARED_TYPE_HW?
Date: Fri, 1 Jun 2007 18:59:25 -0700
Message-ID: <653FFBB4508B9042B5D43DC9E18836F5F5B11F@scsmsx415.amr.corp.intel.com>
In-Reply-To: <20070601184342.GA13751@tree.beaverton.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Dependent CPU core speed reporting not updated with CPUFREQ_SHARED_TYPE_HW?
Thread-Index: AcekfJ4FO3U2nwAOQWCS4t/DVWXoKAAO/eOg
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: <linux-kernel@vger.kernel.org>, "Dave Jones" <davej@redhat.com>
X-OriginalArrivalTime: 02 Jun 2007 01:59:26.0732 (UTC) FILETIME=[A62E84C0:01C7A4B9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Darrick J. Wong [mailto:djwong@us.ibm.com] 
>Sent: Friday, June 01, 2007 11:44 AM
>To: Pallipadi, Venkatesh
>Cc: linux-kernel@vger.kernel.org
>Subject: Re: Dependent CPU core speed reporting not updated 
>with CPUFREQ_SHARED_TYPE_HW?
>
>On Thu, Mar 29, 2007 at 06:06:22PM -0700, Pallipadi, Venkatesh wrote:
>> thought of
>> making affected CPUs show the dependency in case of hw coord, but
>> retaining the percpu
>> control. But, it seemed complicated change for something that is
>> cosmetic.
>
>Actually, it's not so cosmetic any more.  Our newest servers have a
>power meter that measures power consumption, and I'm writing a program
>to measure the power cost of various cpufreq transitions in order to
>enforce a power cap.  Due to the under-reporting in affected_cpus, the
>app thinks that (taking your example above) CPUs 0 and 2 can be
>controlled independently.  Thus, a p-state transition of (x, x) ->
>(x, x-1) yields no energy saving at all, while (x, x-1) -> (x-1, x-1)
>does.  My program considers the effects of a single CPU's transition
>independently of which CPU it is and without considering what
>frequencies the other CPUs are operating at, which means that it will
>conclude that the cost of increasing speed (or the reward for 
>decreasing
>it) is half of what it is ... sort of.  It's mildly broken as a result,
>though amusingly enough it still seems to work ok.  I suspect that it
>might flail around trying to hit a cap a bit more than it would if
>affected_cpus were more accurate.

Hmmm. How about having a new cpufreq_sysfs entry to say
these CPUs are frequency dependent in hardware.

affected_cpus today has a single cpufreq directory for all affected_cpus
and we coordinate all CPUs in software. To change freq, we will have to
move among all affected_cpus and write an MSR.

Hardware coordination basically tells us that kernel can control
frequency
percpu, but underneath hardware will pick highest requested freq among a
group of CPUs. Instaed of handling this case as the existing software
coordination case above, we can add a new entry in cpufreq /sysfs
denoting
hardware coordinated CPU group.

Though it will be confusing with too many interfaces, I feel this is the
right way to go about here.

Comments? Thoughts?

Thanks,
Venki  
