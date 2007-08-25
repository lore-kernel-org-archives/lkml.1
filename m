Return-Path: <linux-kernel-owner+w=401wt.eu-S932464AbXHYAu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464AbXHYAu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 20:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759937AbXHYAuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 20:50:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:62626 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756910AbXHYAuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 20:50:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,305,1183359600"; 
   d="scan'208";a="267764773"
Date: Fri, 24 Aug 2007 17:50:18 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: travis@sgi.com
Cc: Andi Kleen <ak@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 0/6] x86: Reduce Memory Usage and Inter-Node message traffic (v2)
Message-ID: <20070825005017.GC1894@linux-os.sc.intel.com>
References: <20070824222654.687510000@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070824222654.687510000@sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 03:26:54PM -0700, travis@sgi.com wrote:
> Previous Intro:

Thanks for doing this.

> In x86_64 and i386 architectures most arrays that are sized
> using NR_CPUS lay in local memory on node 0.  Not only will most
> (99%?) of the systems not use all the slots in these arrays,
> particularly when NR_CPUS is increased to accommodate future
> very high cpu count systems, but a number of cache lines are
> passed unnecessarily on the system bus when these arrays are
> referenced by cpus on other nodes.

Can we move cpuinfo_x86 also to per cpu area? Though critical run
time code doesn't access this area, it will be nice to move the cpuinfo_x86
also into per cpu area.

Perhaps the current cpuinfo_x86 layout might cause confusion and make people
add arch specific per cpu elements into cpuinfo_x86(thinking that it uses per
cpu area).

Wonder if this confusion is the reason for git commit f3fa8ebc

thanks,
suresh
