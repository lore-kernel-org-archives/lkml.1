Return-Path: <linux-kernel-owner+w=401wt.eu-S1945974AbXDEGyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945974AbXDEGyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 02:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946000AbXDEGyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 02:54:40 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:34604 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945974AbXDEGyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 02:54:40 -0400
Message-ID: <46149D13.4000108@cosmosbay.com>
Date: Thu, 05 Apr 2007 08:54:11 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jakub Jelinek <jakub@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Rik van Riel <riel@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: missing madvise functionality
References: <46128051.9000609@redhat.com>	<p73648dz5oa.fsf@bingen.suse.de>	<46128CC2.9090809@redhat.com>	<20070403172841.GB23689@one.firstfloor.org>	<20070403125903.3e8577f4.akpm@linux-foundation.org>	<4612B645.7030902@redhat.com>	<20070403202937.GE355@devserv.devel.redhat.com>	<20070403144948.fe8eede6.akpm@linux-foundation.org>	<4612DCC6.7000504@cosmosbay.com>	<46130BC8.9050905@yahoo.com.au>	<1175675146.6483.26.camel@twins>	<461367F6.10705@yahoo.com.au>	<20070404113447.17ccbefa.dada1@cosmosbay.com>	<46137882.6050708@yahoo.com.au> <20070404135458.4f1a7059.dada1@cosmosbay.com> <4614585F.1050200@yahoo.com.au> <461492A5.1030905@cosmosbay.com> <461494FE.1040403@redhat.com>
In-Reply-To: <461494FE.1040403@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Thu, 05 Apr 2007 08:54:22 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper a écrit :
> Eric Dumazet wrote:
>> Database workload, where the user multi threaded app is constantly
>> accessing GBytes of data, so L2 cache hit is very small. If you want to
>> oprofile it, with say a CPU_CLK_UNHALTED:5000 event, then find_vma() is
>> in the top 5.
> 
> We did have a workload with lots of Java and databases at some point
> when many VMAs were the issue.  I brought this up here one, maybe two
> years ago and I think Blaisorblade went on and looked into avoiding VMA
> splits by having mprotect() not split VMAs and instead store the flags
> in the page table somewhere.  I don't remember the details.
> 
> Nothing came out of this but if this is possible it would be yet another
> way to avoid mmap_sem locking, right?
> 

I was speaking about oprofile needs, that may interfere with target process 
needs, since oprofile calls find_vma() on the target process mm and thus zap 
its mmap_cache.

oprofile is yet another mmap_sem user, but also a mmap_cache destroyer.

We could at least have a separate cache, only for oprofile.

If done correctly we might avoid taking mmap_sem when the same vm_area_struct 
contains EIP/RIP snapshots.


