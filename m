Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbYJ1Rce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbYJ1Rce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 13:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbYJ1RcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 13:32:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:37584 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbYJ1RcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 13:32:22 -0400
Subject: Re: [patch 3/7] mm: make page writeback obey cpuset constraints
From: Peter Zijlstra <peterz@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Paul Menage <menage@google.com>,
       Derek Fults <dfults@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0810280301300.15270@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0810280259500.15270@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0810280301300.15270@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 18:32:14 +0100
Message-Id: <1225215134.15763.27.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-28 at 09:08 -0700, David Rientjes wrote:

> +	is_subset = cpuset_populate_dirty_limits(dl, &dirtyable_memory,
> +						 &nr_mapped, nodes);
> +	if (!is_subset) {
> +		dl->nr_dirty = global_page_state(NR_FILE_DIRTY);
> +		dl->nr_unstable = global_page_state(NR_UNSTABLE_NFS);
> +		dl->nr_writeback = global_page_state(NR_WRITEBACK);
> +		dirtyable_memory = determine_dirtyable_memory();
> +		nr_mapped = global_page_state(NR_FILE_MAPPED) +
> +			global_page_state(NR_ANON_PAGES);
> +	} else
> +		dirtyable_memory -= highmem_dirtyable_memory(nodes,
> +							dirtyable_memory);

Why not fold that all into cpuset_populate_dirty_limits() ?

