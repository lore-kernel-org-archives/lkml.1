Return-Path: <linux-kernel-owner+w=401wt.eu-S1752064AbXDJHhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbXDJHhL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 03:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbXDJHhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 03:37:10 -0400
Received: from ns2.suse.de ([195.135.220.15]:36005 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbXDJHhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 03:37:09 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] sched: align rq to cacheline boundary
Date: Tue, 10 Apr 2007 09:37:00 +0200
User-Agent: KMail/1.9.6
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, mingo@elte.hu,
       nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>
References: <20070409180853.GC3948@linux-os.sc.intel.com> <20070409134057.2d249f0c.akpm@linux-foundation.org>
In-Reply-To: <20070409134057.2d249f0c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704100937.01399.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> >  
> > -static DEFINE_PER_CPU(struct rq, runqueues);
> > +static DEFINE_PER_CPU(struct rq, runqueues) ____cacheline_aligned_in_smp;
> 
> Remember that this can consume up to (linesize-4 * NR_CPUS) bytes, 

On x86 just the real possible map now -- that tends to be much smaller.

There might be some other architectures who still allocate per cpu
for all of NR_CPUs (or always set possible map to that), but those
should be just fixed.

> which is 
> rather a lot.

We should have solved the problem of limited per cpu space in .22 at least
with some patches by Jeremy. I also plan a few other changes the will
use more per CPU memory again.

> Remember also that the linesize on VSMP is 4k.
> 
> And that putting a gap in the per-cpu memory like this will reduce its
> overall cache-friendliness.

When he avoids false sharing on remote wakeup it should be more cache friendly.

> Need more convincing, please.

Was this based on some benchmark where it showed?

-Andi
