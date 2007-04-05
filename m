Return-Path: <linux-kernel-owner+w=401wt.eu-S965111AbXDEJGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965111AbXDEJGH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 05:06:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965148AbXDEJGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 05:06:06 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:38196 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965111AbXDEJGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 05:06:05 -0400
Date: Thu, 5 Apr 2007 11:06:01 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Rik van Riel <riel@redhat.com>
Cc: Jakub Jelinek <jakub@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: missing madvise functionality
Message-Id: <20070405110601.8ef4b601.dada1@cosmosbay.com>
In-Reply-To: <4614B3FB.2090405@redhat.com>
References: <46128051.9000609@redhat.com>
	<p73648dz5oa.fsf@bingen.suse.de>
	<46128CC2.9090809@redhat.com>
	<20070403172841.GB23689@one.firstfloor.org>
	<20070403125903.3e8577f4.akpm@linux-foundation.org>
	<4612B645.7030902@redhat.com>
	<20070403202937.GE355@devserv.devel.redhat.com>
	<4614A5CC.5080508@redhat.com>
	<20070405100848.db97d835.dada1@cosmosbay.com>
	<4614B3FB.2090405@redhat.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Apr 2007 04:31:55 -0400
Rik van Riel <riel@redhat.com> wrote:

> Eric Dumazet wrote:
> 
> > Could you please add this patch and see if it helps on your machine ?
> > 
> > [PATCH] VM : mm_struct's mmap_cache should be close to mmap_sem
> > 
> > Avoids cache line dirtying
> 
> I could, but I already know it's not going to help much.
> 
> How do I know this?  I already have 66% idle time when running
> with my patch (and without Nick Piggin's patch to take the
> mmap_sem for reading only).  Interestingly, despite the idle
> time increasing from 10% to 66%, throughput triples...
> 
> Saving some CPU time will probably only increase the idle time,
> I see no reason your patch would reduce contention and increase
> throughput.
> 
> I'm not saying your patch doesn't make sense - it probably does.
> I just suspect it would have zero impact on this particular
> scenario, because of the already huge idle time.

I know your cpus have idle time, that not the question.

But *when* your cpus are not idle, they might be slowed down because of cache line transferts between them. This patch doesnt reduce contention, just latencies (and overall performance)

I dont currently have SMP test machine, so I couldnt test it myself.

On x86_64, I am pretty sure the patch would help, because offsetof(mmap_sem) = 0x60
On i386, offsetof(mmap_sem)=0x34, so this patch wont help.

As you said, throughput can raise and idle time raise too.

