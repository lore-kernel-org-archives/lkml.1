Return-Path: <linux-kernel-owner+w=401wt.eu-S1752357AbXDJE6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbXDJE6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 00:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbXDJE6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 00:58:38 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:59595 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbXDJE6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 00:58:37 -0400
Date: Mon, 9 Apr 2007 22:00:47 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: [patch] sched: align rq to cacheline boundary
Message-ID: <20070410050047.GA6150@localhost.localdomain>
References: <20070409180853.GC3948@linux-os.sc.intel.com> <20070409134057.2d249f0c.akpm@linux-foundation.org> <20070409215309.GC5275@localhost.localdomain> <20070409221705.GD3948@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070409221705.GD3948@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.2.1i
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 03:17:05PM -0700, Siddha, Suresh B wrote:
> On Mon, Apr 09, 2007 at 02:53:09PM -0700, Ravikiran G Thirumalai wrote:
> > On Mon, Apr 09, 2007 at 01:40:57PM -0700, Andrew Morton wrote:
> > > On Mon, 9 Apr 2007 11:08:53 -0700
> > > "Siddha, Suresh B" <suresh.b.siddha@intel.com> wrote:
> 
> Kiran, can you educate me when I am supposed to use
> ____cacheline_aligned_in_smp
> Vs
> __cacheline_aligned_in_smp ?

As far as my understanding goes, the four underscore version is for 
aligning members/elements within a data structure, and the two underscore 
version is for aligning statically defined variables.
The dual underscore version places the variable in a separate section meant
for cacheline aligned variables, so that there is no false sharing on the
cacheline with a consecutive datum.  For regular statically defined data
structures, the latter has to be used, but since your patch uses per-cpu data, 
which is already in a separate section, you had to use the former I guess.


> 
> > As for the (linesize-4 * NR_CPUS) wastage, maybe we can place the cacheline 
> > aligned per-cpu data in another section, just like we do with 
> > .data.cacheline_aligned section, but keep this new section between
> > __percpu_start and __percpu_end?
> 
> Yes. But that will still waste some memory in the new section, if the data
> elements are not multiples of 4k.

Yes.  But the wastage depends on the data structure now being aligned rather
than the structure that happened to be there before.  You cannot not lose
memory while padding I guess :).  But padding for per-cpu data seems a bit 
odd and I am not sure if it is worth it for 0.5% gain.

Thanks,
Kiran
