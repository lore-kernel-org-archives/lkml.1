Return-Path: <linux-kernel-owner+w=401wt.eu-S1756282AbXGHHvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbXGHHvv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 03:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbXGHHvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 03:51:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40912 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629AbXGHHvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 03:51:41 -0400
Date: Sun, 8 Jul 2007 09:51:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
Message-ID: <20070708075119.GA16631@elte.hu>
References: <20070708034952.022985379@sgi.com> <20070708035018.074510057@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070708035018.074510057@sgi.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(added Matt to the Cc: list)

* Christoph Lameter <clameter@sgi.com> wrote:

> Maintenance of slab allocators becomes a problem as new features for 
> allocators are developed. The SLOB allocator in particular has been 
> lagging behind in many ways in the past:
> 
> - Had no support for SLAB_DESTROY_BY_RCU for years (but no one 
>   noticed)
> 
> - Still has no support for slab reclaim counters. This may currently 
>   not be necessary if one would restrict the supported configurations 
>   for functionality relying on these. But even that has not been done.
> 
> The only current advantage over SLUB in terms of memory savings is 
> through SLOBs kmalloc layout that is not power of two based like SLAB 
> and SLUB which allows to eliminate some memory waste.
> 
> Through that SLOB has still a slight memory advantage over SLUB of 
> ~350k in for a standard server configuration. It is likely that the 
> savings are is smaller for real embedded configurations that have less 
> functionality.

actually, one real advantage of the SLOB is that it is a minimal, really 
simple allocator. Its text and data size is so small as well.

here's the size comparison:

   text    data     bss     dec     hex filename
  10788     837      16   11641    2d79 mm/slab.o
   6205    4207     124   10536    2928 mm/slub.o
   1640      44       4    1688     698 mm/slob.o

slab/slub have roughly the same footprint, but slob is 10% of that size. 
Would be a waste to throw this away.

A year ago the -rt kernel defaulted to the SLOB for a few releases, and 
barring some initial scalability issues (which were solved in -rt) it 
worked pretty well on generic PCs, so i dont buy the 'it doesnt work' 
argument either.

	Ingo
