Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbYJ1TS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbYJ1TS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 15:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752791AbYJ1TSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 15:18:17 -0400
Received: from smtp-out.google.com ([216.239.45.13]:34418 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbYJ1TSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 15:18:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=QohoPRp1ygVatjpvztmxd13FDrs7RF37OKNnXoBuhSKy0t/8aLrKm5Y5pO52QQwiO
	2Ve7QnnALPw1b2IH67Jdg==
Date: Tue, 28 Oct 2008 12:18:05 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Paul Menage <menage@google.com>,
       Derek Fults <dfults@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/7] mm: make page writeback obey cpuset constraints
In-Reply-To: <1225215134.15763.27.camel@lappy.programming.kicks-ass.net>
Message-ID: <alpine.DEB.1.10.0810281216570.30390@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0810280259500.15270@chino.kir.corp.google.com>  <alpine.DEB.1.10.0810280301300.15270@chino.kir.corp.google.com> <1225215134.15763.27.camel@lappy.programming.kicks-ass.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2008, Peter Zijlstra wrote:

> > +	is_subset = cpuset_populate_dirty_limits(dl, &dirtyable_memory,
> > +						 &nr_mapped, nodes);
> > +	if (!is_subset) {
> > +		dl->nr_dirty = global_page_state(NR_FILE_DIRTY);
> > +		dl->nr_unstable = global_page_state(NR_UNSTABLE_NFS);
> > +		dl->nr_writeback = global_page_state(NR_WRITEBACK);
> > +		dirtyable_memory = determine_dirtyable_memory();
> > +		nr_mapped = global_page_state(NR_FILE_MAPPED) +
> > +			global_page_state(NR_ANON_PAGES);
> > +	} else
> > +		dirtyable_memory -= highmem_dirtyable_memory(nodes,
> > +							dirtyable_memory);
> 
> Why not fold that all into cpuset_populate_dirty_limits() ?
> 

cpuset_populate_dirty_limits() is a no-op on !CONFIG_CPUSETS kernels.
