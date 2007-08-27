Return-Path: <linux-kernel-owner+w=401wt.eu-S1758299AbXH0SqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299AbXH0SqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 14:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbXH0SqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 14:46:16 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:32984 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750902AbXH0SqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 14:46:16 -0400
Date: Mon, 27 Aug 2007 18:46:12 +0000
From: Mike Travis <travis@cthulhu.engr.sgi.com>
To: Andi Kleen <ak@suse.de>
cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, travis@sgi.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 0/6] x86: Reduce Memory Usage and Inter-Node message
 traffic (v2)
In-Reply-To: <20070825092434.GE16227@bingen.suse.de>
Message-ID: <Pine.SGI.4.56.0708271838210.4349416@kluge.engr.sgi.com>
References: <20070824222654.687510000@sgi.com> <20070825005017.GC1894@linux-os.sc.intel.com>
 <20070825092434.GE16227@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 25 Aug 2007, Andi Kleen wrote:

> On Fri, Aug 24, 2007 at 05:50:18PM -0700, Siddha, Suresh B wrote:
> > On Fri, Aug 24, 2007 at 03:26:54PM -0700, travis@sgi.com wrote:
> > > Previous Intro:
> >
> > Thanks for doing this.
> >
> > > In x86_64 and i386 architectures most arrays that are sized
> > > using NR_CPUS lay in local memory on node 0.  Not only will most
> > > (99%?) of the systems not use all the slots in these arrays,
> > > particularly when NR_CPUS is increased to accommodate future
> > > very high cpu count systems, but a number of cache lines are
> > > passed unnecessarily on the system bus when these arrays are
> > > referenced by cpus on other nodes.
> >
> > Can we move cpuinfo_x86 also to per cpu area? Though critical run
>
> I worry how much impact that would be? boot_cpu_data is quite
> widely used.
>

I looked at this and it would be a big memory savings.  But I haven't
yet analyzed the various accesses to verify that we can cleanly move
the structure, and that we don't suffer a bunch of tlb misses because
accesses are primarily from node 0.

More info soon.

Thanks,
Mike
