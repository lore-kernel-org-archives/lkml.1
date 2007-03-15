Return-Path: <linux-kernel-owner+w=401wt.eu-S1753377AbXCOVMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbXCOVMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 17:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbXCOVMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 17:12:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:30236 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378AbXCOVMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 17:12:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,289,1170662400"; 
   d="scan'208"; a="210361867:sNHT17682910"
Date: Thu, 15 Mar 2007 14:12:41 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: ray-gmail@madrabbit.org
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Con Kolivas <kernel@kolivas.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>
Subject: Re: RSDL v0.30 cpu scheduler for mainline kernels
Message-ID: <20070315211240.GC12447@linux-os.sc.intel.com>
References: <200703121058.11966.kernel@kolivas.org> <20070315023102.GL30596@linux-os.sc.intel.com> <200703151705.13761.kernel@kolivas.org> <20070315174654.GB12447@linux-os.sc.intel.com> <2c0942db0703151158l59cbede2x845fc134d9f1cf9d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0703151158l59cbede2x845fc134d9f1cf9d@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 11:58:39AM -0700, Ray Lee wrote:
> With more CPUs, the context switch period can be multiplied by that
> number of CPUs while still allowing all tasks the same frequency of
> access to the CPU.

Are you assuming the other cpus might be idle?

It depends on the load of the system also, right. If all the cpus are
loaded, then increasing the period will decrease the frequency.
If some of the cpus are idle, then it doesn't matter what context
switch rate we use(as we don't get context switched out by other task).

> With 4 processors, the context switch would be
> 24ms, by which point we're probably reaching the point of diminishing
> returns for minimizing overhead and maximizing throughput.

BTW, the overhead is not just the context switch cost, but also the cache
evictions that the incoming process will bring.

> >We need to minimize these context switches.
> 
> That's a judgement call. If a synthetic benchmark degrades but other

I was showing the degradation with SPECjbb2000 workload. Synthetic workload
was for showing/reproducing the issue quickly.

> things improve, then this, as most everything in computer science, is
> yet another trade-off that needs to be evaluated. (You recognize there
> is a tradeoff here, right?

I am with you. But lets say, if these tasks are not interactive, then
what is the need for paying this penality?

thanks,
suresh
