Return-Path: <linux-kernel-owner+w=401wt.eu-S1758926AbZIQS2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926AbZIQS2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 14:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbZIQS2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 14:28:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56745 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbZIQS2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 14:28:43 -0400
Date: Thu, 17 Sep 2009 20:28:42 +0200
From: Nick Piggin <npiggin@suse.de>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       heiko.carstens@de.ibm.com, mingo@elte.hu, sachinp@in.ibm.com
Subject: Re: [RFC/PATCH] SLQB: Mark the allocator as broken PowerPC and S390
Message-ID: <20090917182842.GS18404@wotan.suse.de>
References: <1253083059.5478.1.camel@penberg-laptop> <20090917100841.GF13002@csn.ul.ie> <1253183365.4975.20.camel@penberg-laptop> <20090917105707.GA7205@csn.ul.ie> <1253186019.4975.32.camel@penberg-laptop> <20090917111828.GB7205@csn.ul.ie> <20090917114116.GL18404@wotan.suse.de> <20090917181831.GA714@csn.ul.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090917181831.GA714@csn.ul.ie>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 07:18:32PM +0100, Mel Gorman wrote:
> > Ahh... it's pretty lame of me. Sachin has been a willing tester :(
> > I have spent quite a few hours looking at it but I never found
> > many good leads. Much appreciated if you can make more progress on
> > it.
> 
> Nothing much so far. I've reproduced the problem based on 2.6.31 and slqb-core
> from Pekka's tree but not a whole pile else. I don't know SLQB at all so the
> investigation is fuzzy. It appears to initialise SLQB ok but crashes later when
> setting up SCSI. Not 100% sure what the triggering event is but it might be
> userspace starting up and other CPUs get involved, possibly corrupting lists.
> 
> This machine has two CPUs (0, 1) and two nodes with actual memory (2,3).
> After applying a patch to kmem_cache_create, I see in the console
> 
> MEL::Creating cache pgd_cache CPU 0 Node 0
> MEL::Creating cache pmd_cache CPU 0 Node 0
> MEL::Creating cache pid_namespace CPU 0 Node 0
> MEL::Creating cache shmem_inode_cache CPU 0 Node 0
> MEL::Creating cache scsi_data_buffer CPU 1 Node 0
> 
> It crashes at this point during creation before the struct kmem_cache has
> been allocated from kmem_cache_cache. Note it's kmem_cache_cache we are
> failing to allocate from, not scsi_data_buffer.

Yes, it's crashing in kmem_cache_create, when trying to allocate from
kmem_cache_cache.

I didn't get much further. I had thought something must be NULL or
not set up correctly in kmem_cache_cache, but I didn't work out what.

If you can identify the precondition which cases the crash (or even
just have a static counter of the number of caches created, to trigger
at the crashing cache create), then perhaps you can dump some more
details of the kmem_cache_cache.

Thanks,
Nick
