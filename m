Return-Path: <linux-kernel-owner+w=401wt.eu-S1753315AbZBQMva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbZBQMva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 07:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbZBQMvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 07:51:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47616 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbZBQMvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 07:51:21 -0500
Subject: Re: next-20090216: slqb
From: Peter Zijlstra <peterz@infradead.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Nick Piggin <npiggin@suse.de>, Alexey Dobriyan <adobriyan@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <84144f020902170331m765c50d6xd792de14ac220b9d@mail.gmail.com>
References: <20090216172016.f1d159a7.sfr@canb.auug.org.au>
	 <20090217005539.GA6292@x200.localdomain>
	 <20090217102733.GB26402@wotan.suse.de>
	 <84144f020902170331m765c50d6xd792de14ac220b9d@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 17 Feb 2009 13:48:15 +0100
Message-Id: <1234874895.4744.98.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-17 at 13:31 +0200, Pekka Enberg wrote:
> On Tue, Feb 17, 2009 at 03:55:40AM +0300, Alexey Dobriyan wrote:
> >> FYI, on powerpc-64-smp-n-debug-n:
> >>
> >> mm/slqb.c: In function '__slab_free':
> >> mm/slqb.c:1648: error: implicit declaration of function 'slab_free_to_remote'
> >> mm/slqb.c: In function 'kmem_cache_open':
> >> mm/slqb.c:2174: error: implicit declaration of function 'kmem_cache_dyn_array_free'
> >> mm/slqb.c:2175: warning: label 'error_cpu_array' defined but not used
> >> mm/slqb.c: In function 'kmem_cache_destroy':
> >> mm/slqb.c:2294: error: implicit declaration of function 'claim_remote_free_list'
> >> mm/slqb.c: In function 'kmem_cache_reap_percpu':
> >> mm/slqb.c:2547: error: implicit declaration of function 'flush_remote_free_cache'
> >> mm/slqb.c: In function 'kmem_cache_init':
> >> mm/slqb.c:2783: error: 'per_cpu__kmem_cpu_nodes' undeclared (first use in this function)
> >> mm/slqb.c:2783: error: (Each undeclared identifier is reported only once
> >> mm/slqb.c:2783: error: for each function it appears in.)
> >> mm/slqb.c:2784: error: 'kmem_cpu_cache' undeclared (first use in this function)
> 
> On Tue, Feb 17, 2009 at 12:27 PM, Nick Piggin <npiggin@suse.de> wrote:
> > Hmm, I guess this (SMP=n && NUMA=y) must be a valid config on ppc if
> > SLQB is the only one tripping on it, so I'll look at code to fix tihs
> > up.
> 
> It would be nice if one of the ppc devs confirmed this, though. Other
> architectures don't seem to support the combination.

I get a strong sense of deja-vu

                           Subject: 
next Feb 10: mm/slqb build break

FWIW, I don't think NUMA without SMP makes any kind of sense and the
arch Kconfig should be fixed.

