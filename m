Return-Path: <linux-kernel-owner+w=401wt.eu-S1755328Ab0AUXer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab0AUXer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 18:34:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755312Ab0AUXeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 18:34:46 -0500
Received: from smtp-out.google.com ([216.239.44.51]:36945 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310Ab0AUXeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 18:34:46 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=dQL/w36IOOukqJXulPFtoBersBgXOes6FoyO8BT0dcKzxmCckMCojwOf5yvRrokSt
	TMkgysDjQfRwFirAL6u4A==
Date: Thu, 21 Jan 2010 15:34:39 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/7] Add /proc trigger for memory compaction
In-Reply-To: <20100121140948.GJ5154@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1001211514230.31073@chino.kir.corp.google.com>
References: <1262795169-9095-1-git-send-email-mel@csn.ul.ie> <1262795169-9095-6-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.1001071352100.23894@chino.kir.corp.google.com> <20100120094813.GC5154@csn.ul.ie> <alpine.DEB.2.00.1001201241540.6440@chino.kir.corp.google.com>
 <20100121140948.GJ5154@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jan 2010, Mel Gorman wrote:

> > It would be helpful to be able to determine what is "compactable" at the 
> > same time by adding both global and per-node "compact_order" tunables that 
> > would default to HUGETLB_PAGE_ORDER. 
> 
> Well, rather than having a separate tunable, writing a number to
> /proc/sys/vm/compact could indicate the order if that trigger is now
> working system-wide. Would that be suitable?
> 

Do you think you'll eventually find a need to call try_to_compact_pages() 
with a higher order than the one passed to the page allocator to limit 
"compaction thrashing" from fragmented frees to a zone where we're 
constantly compacting order-1 pages, for instance?  I agree that memory 
compaction should always be used before direct reclaim for higher order 
allocations, but it may be more efficient to define a compact_min_order, 
tunable from userspace, that would avoid the need for constant order-1 
compactions from subsequent page allocations.

If that's a possibility, we may find a need for "compact_order", now 
renamed "compact_min_order", outside of the explicit trigger.
