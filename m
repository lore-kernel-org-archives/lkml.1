Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbYJ3Ilt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbYJ3Ilt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 04:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbYJ3Ilk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 04:41:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58811 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbYJ3Ilk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 04:41:40 -0400
Subject: Re: [patch 3/7] mm: make page writeback obey cpuset constraints
From: Peter Zijlstra <peterz@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Paul Menage <menage@google.com>,
       Derek Fults <dfults@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0810281216570.30390@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0810280259500.15270@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0810280301300.15270@chino.kir.corp.google.com>
	 <1225215134.15763.27.camel@lappy.programming.kicks-ass.net>
	 <alpine.DEB.1.10.0810281216570.30390@chino.kir.corp.google.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 30 Oct 2008 09:42:00 +0100
Message-Id: <1225356120.7803.5.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-28 at 12:18 -0700, David Rientjes wrote:
> On Tue, 28 Oct 2008, Peter Zijlstra wrote:
> 
> > > +	is_subset = cpuset_populate_dirty_limits(dl, &dirtyable_memory,
> > > +						 &nr_mapped, nodes);
> > > +	if (!is_subset) {
> > > +		dl->nr_dirty = global_page_state(NR_FILE_DIRTY);
> > > +		dl->nr_unstable = global_page_state(NR_UNSTABLE_NFS);
> > > +		dl->nr_writeback = global_page_state(NR_WRITEBACK);
> > > +		dirtyable_memory = determine_dirtyable_memory();
> > > +		nr_mapped = global_page_state(NR_FILE_MAPPED) +
> > > +			global_page_state(NR_ANON_PAGES);
> > > +	} else
> > > +		dirtyable_memory -= highmem_dirtyable_memory(nodes,
> > > +							dirtyable_memory);
> > 
> > Why not fold that all into cpuset_populate_dirty_limits() ?
> > 
> 
> cpuset_populate_dirty_limits() is a no-op on !CONFIG_CPUSETS kernels.

Right, humm. Maybe introduce a populate_dirty_limits() and differentiate
that between CONFIG_CPUSETS and not, and make it do everything.

That would get rid of this fudge I think, no?
