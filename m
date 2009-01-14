Return-Path: <linux-kernel-owner+w=401wt.eu-S1761696AbZANPJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761696AbZANPJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 10:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755647AbZANPJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 10:09:04 -0500
Received: from ns2.suse.de ([195.135.220.15]:56150 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845AbZANPJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 10:09:03 -0500
Date: Wed, 14 Jan 2009 16:09:00 +0100
From: Nick Piggin <npiggin@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Lin Ming <ming.m.lin@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] SLQB slab allocator
Message-ID: <20090114150900.GC25401@wotan.suse.de>
References: <20090114090449.GE2942@wotan.suse.de> <84144f020901140253s72995188vb35a79501c38eaa3@mail.gmail.com> <20090114114707.GA24673@wotan.suse.de> <84144f020901140544v56b856a4w80756b90f5b59f26@mail.gmail.com> <20090114142200.GB25401@wotan.suse.de> <84144f020901140645o68328e01ne0e10ace47555e19@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020901140645o68328e01ne0e10ace47555e19@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 04:45:15PM +0200, Pekka Enberg wrote:
> Hi Nick,
> 
> On Wed, Jan 14, 2009 at 4:22 PM, Nick Piggin <npiggin@suse.de> wrote:
> > The problem is there was apparently no plan for resolving the SLAB vs SLUB
> > strategy. And then features and things were added to one or the other one.
> > But on the other hand, the SLUB experience was a success in a way because
> > there were a lot of performance regressions found and fixed after it was
> > merged, for example.
> 
> That's not completely true. I can't speak for Christoph, but the
> biggest problem I have is that I have _no way_ of reproducing or
> analyzing the regression. I've tried out various benchmarks I have
> access to but I haven't been able to find anything.
> 
> The hypothesis is that SLUB regresses because of kmalloc()/kfree()
> ping-pong between CPUs and as far as I understood, Christoph thinks we
> can improve SLUB with the per-cpu alloc patches and the freelist
> management rework.
> 
> Don't get me wrong, though. I am happy you are able to work with the
> Intel engineers to fix the long standing issue (I want it fixed too!)
> but I would be happier if the end-result was few simple patches
> against mm/slub.c :-).

Right, but that regression isn't my only problem with SLUB. I think
higher order allocations could be much more damaging for more a wider
class of users. It is less common to see higher order allocation failure
reports in places other than lkml, where people tend to have systems
stay up longer and/or do a wider range of things with them.

The idea of removing queues doesn't seem so good to me. Queues are good.
You amortize or avoid all sorts of things with queues. We have them
everywhere in the kernel ;)

 
> On Wed, Jan 14, 2009 at 4:22 PM, Nick Piggin <npiggin@suse.de> wrote:
> > I'd love to be able to justify replacing SLAB and SLUB today, but actually
> > it is simply never going to be trivial to discover performance regressions.
> > So I don't think outright replacement is great either (consider if SLUB
> > had replaced SLAB completely).
> 
> If you ask me, I wish we *had* removed SLAB so relevant people could
> have made a huge stink out of it and the regression would have been
> taken care quickly ;-).

Well, presumably the stink was made because we've been stuck with SLAB
for 2 years for some reason. But it is not only that one but there were
other regressions too. Point simply is that it would have been much
harder for users to detect if there even is a regression, what with all
the other changes happening.


