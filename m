Return-Path: <linux-kernel-owner+w=401wt.eu-S1161107AbXDJXsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161107AbXDJXsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 19:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161104AbXDJXsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 19:48:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:27917 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161107AbXDJXsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 19:48:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,392,1170662400"; 
   d="scan'208"; a="225249669:sNHT3355638083"
Date: Tue, 10 Apr 2007 16:47:06 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, nickpiggin@yahoo.com.au,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       Ravikiran G Thirumalai <kiran@scalex86.org>
Subject: Re: [patch] sched: align rq to cacheline boundary
Message-ID: <20070410234706.GA585@linux-os.sc.intel.com>
References: <20070409180853.GC3948@linux-os.sc.intel.com> <20070409134057.2d249f0c.akpm@linux-foundation.org> <20070410063656.GB23274@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070410063656.GB23274@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2007 at 08:36:56AM +0200, Ingo Molnar wrote:
> the runqueue is really supposed to be cacheline-isolated at _both_ ends 
> - at its beginning and at its end as well.

Then either we need to define the first element in the struct as
cacheline aligned or move into section where all the elements are
cacheline aligned. My current patch will not align it at the end.

> > Remember also that the linesize on VSMP is 4k.
> 
> that sucks ...
> 
> maybe, to mitigate some of the costs, do a special PER_CPU_CACHE_ALIGNED 
> area that collects per-cpu fields that also have significant cross-CPU 
> use and need cacheline isolation? Such cacheline-aligned variables, if 
> collected separately, would pack up more tightly and would cause only 
> half of the wasted space.

I will post a patch(once Jermey's page align percpu patch goes in to -mm)

thanks,
suresh
