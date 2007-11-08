Return-Path: <linux-kernel-owner+w=401wt.eu-S1761329AbXKHPLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761329AbXKHPLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 10:11:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759471AbXKHPLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 10:11:39 -0500
Received: from waste.org ([66.93.16.53]:39073 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759031AbXKHPLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 10:11:38 -0500
Date: Thu, 8 Nov 2007 09:10:03 -0600
From: Matt Mackall <mpm@selenic.com>
To: Avi Kivity <avi@qumranet.com>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Marin Mitov <mitov@issp.bas.bg>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: is minimum udelay() not respected in preemptible SMP kernel-2.6.23?
Message-ID: <20071108151003.GS19691@waste.org>
References: <200711071921.52330.mitov@issp.bas.bg> <20071107123045.c6d4b855.akpm@linux-foundation.org> <20071108002027.GV17536@waste.org> <200711080131.01243.ak@suse.de> <4732F728.8020707@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4732F728.8020707@qumranet.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2007 at 01:46:48PM +0200, Avi Kivity wrote:
> Andi Kleen wrote:
> >On Thursday 08 November 2007 01:20, Matt Mackall wrote:
> >  
> >>On Wed, Nov 07, 2007 at 12:30:45PM -0800, Andrew Morton wrote:
> >>    
> >>>Ow.  Yes, from my reading delay_tsc() can return early (or after
> >>>heat-death-of-the-universe) if the TSCs are offset and if preemption
> >>>migrates the calling task between CPUs.
> >>>
> >>>I suppose a lameo fix would be to disable preemption in delay_tsc().
> >>>      
> >>preempt_disable is lousy documentation here. This and other cases
> >>(lots of per_cpu users, IIRC) actually want a migrate_disable() which
> >>is a proper subset. We can simply implement migrate_disable() as
> >>preempt_disable() for now and come back later and implement a proper
> >>migrate_disable() that still allows preemption (and thus avoids the
> >>latency).
> >>    
> >
> >We could actually do this right now. migrate_disable() can be just changing
> >the cpu affinity of the current thread to current cpu and then restoring 
> >it afterwards. That should even work from interrupt context.
> >
> >get_cpu() etc. could be changed to use this then too.
> >
> >  
> 
> What if some other thread calls sched_setaffinity() on the 
> migrate_disable()d cpu?  we'd need to detect this to avoid 
> migrate_enable() stomping on sched_setaffinity()'s work.

Yep, there are a bunch of problems with actually touching the affinity
mask.

-- 
Mathematics is the supreme nostalgia of our time.
