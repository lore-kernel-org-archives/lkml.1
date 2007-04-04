Return-Path: <linux-kernel-owner+w=401wt.eu-S2992737AbXDDIZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992737AbXDDIZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 04:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992741AbXDDIZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 04:25:52 -0400
Received: from amsfep17-int.chello.nl ([213.46.243.15]:21400 "EHLO
	amsfep13-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S2992737AbXDDIZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 04:25:51 -0400
Subject: Re: missing madvise functionality
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jakub Jelinek <jakub@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
In-Reply-To: <46130BC8.9050905@yahoo.com.au>
References: <46128051.9000609@redhat.com>	<p73648dz5oa.fsf@bingen.suse.de>
	 <46128CC2.9090809@redhat.com>	<20070403172841.GB23689@one.firstfloor.org>
	 <20070403125903.3e8577f4.akpm@linux-foundation.org>
	 <4612B645.7030902@redhat.com>
	 <20070403202937.GE355@devserv.devel.redhat.com>
	 <20070403144948.fe8eede6.akpm@linux-foundation.org>
	 <4612DCC6.7000504@cosmosbay.com>  <46130BC8.9050905@yahoo.com.au>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 10:25:46 +0200
Message-Id: <1175675146.6483.26.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 12:22 +1000, Nick Piggin wrote:
> Eric Dumazet wrote:

> > I do think such workloads might benefit from a vma_cache not shared by 
> > all threads but private to each thread. A sequence could invalidate the 
> > cache(s).
> > 
> > ie instead of a mm->mmap_cache, having a mm->sequence, and each thread 
> > having a current->mmap_cache and current->mm_sequence
> 
> I have a patchset to do exactly this, btw.

/me too

However, I decided against pushing it because when it does happen that a
task is not involved with a vma lookup for longer than it takes the seq
count to wrap we have a stale pointer...

We could go and walk the tasks once in a while to reset the pointer, but
it all got a tad involved.

