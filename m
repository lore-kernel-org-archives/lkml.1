Return-Path: <linux-kernel-owner+w=401wt.eu-S1760629AbXK0Xs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760629AbXK0Xs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 18:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760666AbXK0XsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 18:48:25 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48518 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760659AbXK0XsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 18:48:24 -0500
Date: Wed, 28 Nov 2007 00:48:21 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>, andi@firstfloor.org, travis@sgi.com,
       ak@suse.de, pageexec@freemail.hu, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm: Prevent dereferencing non-allocated per_cpu variables
Message-ID: <20071127234821.GC31491@one.firstfloor.org>
References: <20071127215052.090968000@sgi.com> <20071127215054.660250000@sgi.com> <20071127221628.GG24223@one.firstfloor.org> <20071127151241.038c146d.akpm@linux-foundation.org> <20071127152122.1d5fbce3.akpm@linux-foundation.org> <Pine.LNX.4.64.0711271522050.6713@schroedinger.engr.sgi.com> <20071127154213.11970e63.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071127154213.11970e63.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 03:42:13PM -0800, Andrew Morton wrote:
> On Tue, 27 Nov 2007 15:22:56 -0800 (PST)
> Christoph Lameter <clameter@sgi.com> wrote:
> 
> > On Tue, 27 Nov 2007, Andrew Morton wrote:
> > 
> > > The prefetch however might still need some work - we can indeed do
> > > prefetch() against a not-possible CPU's memory here.  And I do recall that
> > > 4-5 years ago we did have a CPU (one of mine, iirc) which would oops when
> > > prefetching from a bad address.  I forget what the conclusion was on that
> > > matter.
> > > 
> > > If we do want to fix the prefetch-from-outer-space then we should be using
> > > cpu_isset(cpu, *cpumask) here rather than cpu_possible().
> > 
> > Generally the prefetch things have turned out to be not that useful. How 
> > about dropping the prefetch? I kept it because it was there.
> 
> I don't recall anyone ever demonstrating that prefetch is useful in-kernel.

It was demonstrated useful for some specific cases, like context switch early
fetch on IA64. But I agree the prefetch on each list_for_each() is probably
a bad idea and should be removed. Will also help code size.

The best strategy is probably to figure out which oprofile counters
to use and then do some profiling and only insert prefetches where
the profiler actually finds significant cache misses.

-Andi
