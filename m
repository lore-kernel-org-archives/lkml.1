Return-Path: <linux-kernel-owner+w=401wt.eu-S1030283AbXDJCbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030283AbXDJCbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 22:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030320AbXDJCbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 22:31:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030283AbXDJCbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 22:31:47 -0400
Date: Mon, 9 Apr 2007 22:31:08 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Jeff V. Merkey" <jmerkey@wolfmountaingroup.com>,
       Linux kernel <linux-kernel@vger.kernel.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: Preemption Broken:  centrino_target busted under SMP on 2.6.20.4
Message-ID: <20070410023108.GA14081@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Jeff V. Merkey" <jmerkey@wolfmountaingroup.com>,
	Linux kernel <linux-kernel@vger.kernel.org>,
	Venki Pallipadi <venkatesh.pallipadi@intel.com>
References: <46155CFF.70701@wolfmountaingroup.com> <20070405205034.GB3605@redhat.com> <20070409172651.9bc619d6.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070409172651.9bc619d6.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 05:26:51PM -0700, Andrew Morton wrote:
 > On Thu, 5 Apr 2007 16:50:34 -0400
 > Dave Jones <davej@redhat.com> wrote:
 > 
 > > diff --git a/arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c b/arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c
 > > index f43b987..824d0a2 100644
 > > --- a/arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c
 > > +++ b/arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c
 > > @@ -708,6 +708,7 @@ static int centrino_target (struct cpufreq_policy *policy,
 > >  	saved_mask = current->cpus_allowed;
 > >  	first_cpu = 1;
 > >  	cpus_clear(covered_cpus);
 > > +	preempt_disable();
 > >  	for_each_cpu_mask(j, online_policy_cpus) {
 > >  		/*
 > >  		 * Support for SMP systems.
 > > @@ -798,6 +799,7 @@ static int centrino_target (struct cpufreq_policy *policy,
 > >  	}
 > >  
 > >  migrate_end:
 > > +	preempt_enable();
 > >  	set_cpus_allowed(current, saved_mask);
 > >  	return 0;
 > >  }
 > 
 > This means we'll call set_cpus_allowed() while in atomic state, but
 > set_cpus_allowed() does sleepy stuff.

Puzzled. This diff shouldn't change anything about the context we're in
when we call set_cpus_allowed, and as we're not seeing warnings now,
I'm not sure what I'm missing?

[which may be 'the obvious', you wouldn't believe the evening I've had
 involving gas leaks and noxious fumes. Wheee, floaty head.]

	Dave

-- 
http://www.codemonkey.org.uk
