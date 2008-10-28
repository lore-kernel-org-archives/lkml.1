Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbYJ1TRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbYJ1TRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 15:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbYJ1TRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 15:17:07 -0400
Received: from smtp-out.google.com ([216.239.45.13]:34173 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbYJ1TRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 15:17:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=u9z2GaziTnjK2DiuChtEtmASL1/tPx8RjUq/8AvwPRFAReMBMVv/V/b2M5fZjeRdZ
	lOQQv9zIV90mgIC02p2eQ==
Date: Tue, 28 Oct 2008 12:16:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Paul Menage <menage@google.com>,
       Derek Fults <dfults@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/7] mm: make page writeback obey cpuset constraints
In-Reply-To: <1225215093.15763.25.camel@lappy.programming.kicks-ass.net>
Message-ID: <alpine.DEB.1.10.0810281216280.30390@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0810280259500.15270@chino.kir.corp.google.com>  <alpine.DEB.1.10.0810280301300.15270@chino.kir.corp.google.com> <1225215093.15763.25.camel@lappy.programming.kicks-ass.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2008, Peter Zijlstra wrote:

> > +int cpuset_populate_dirty_limits(struct dirty_limits *dl,
> > +				 unsigned long *dirtyable_memory,
> > +				 unsigned long *nr_mapped,
> > +				 const nodemask_t *nodes)
> > +{
> > +	int node;
> > +
> > +	if (likely(!nodes || nodes_subset(node_online_map, *nodes)))
> > +		return 0;
> > +	for_each_node_mask(node, *nodes) {
> > +		if (!node_online(node))
> > +			continue;
> > +		dl->nr_dirty += node_page_state(node, NR_FILE_DIRTY);
> > +		dl->nr_unstable += node_page_state(node, NR_UNSTABLE_NFS);
> > +		dl->nr_writeback += node_page_state(node, NR_WRITEBACK);
> > +		dirtyable_memory +=
> 
> *dirtyable_memory perhaps?
> 

Indeed, fixed.

> > +			node_page_state(node, NR_ACTIVE_ANON) +
> > +			node_page_state(node, NR_ACTIVE_FILE) +
> > +			node_page_state(node, NR_INACTIVE_ANON) +
> > +			node_page_state(node, NR_INACTIVE_FILE) +
> > +			node_page_state(node, NR_FREE_PAGES);
> > +		nr_mapped +=
> 
> idem?
> 

Likewise.
