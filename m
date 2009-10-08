Return-Path: <linux-kernel-owner+w=401wt.eu-S1758837AbZJHQWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837AbZJHQWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 12:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758794AbZJHQWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 12:22:15 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:39554 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758812AbZJHQWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 12:22:15 -0400
Date: Thu, 8 Oct 2009 12:15:18 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V6 1/7] this_cpu_ops: page allocator conversion
In-Reply-To: <4ACDC11D.4030007@kernel.org>
Message-ID: <alpine.DEB.1.10.0910081212200.21951@gentwo.org>
References: <20091007211024.442168959@gentwo.org> <20091007211052.229772418@gentwo.org> <4ACDC11D.4030007@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Oct 2009, Tejun Heo wrote:

> > +static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch);
> > +static DEFINE_PER_CPU(struct per_cpu_pageset, boot_pageset);
>
> This looks much better but I'm not sure whether it's safe.  percpu
> offsets have not been set up before setup_per_cpu_areas() is complete
> on most archs but if all that's necessary is getting the page
> allocator up and running as soon as static per cpu areas and offsets
> are set up (which basically means as soon as cpu init is complete on
> ia64 and setup_per_cpu_areas() is complete on all other archs).  This
> should be correct.  Is this what you're expecting?

paging_init() is called after the per cpu areas have been initialized. So
I thought this would be safe. Tested it on x86.

zone_pcp_init() only sets up the per cpu pointers to the pagesets. That
works regardless of the boot stage. Then then build_all_zonelists()
initializes the actual contents of the per cpu variables.

Finally the per cpu pagesets are allocated from the percpu allocator when
all allocators are up and the pagesets are sized.


