Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbZHPDl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbZHPDl2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 23:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbZHPDl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 23:41:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:1778 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242AbZHPDl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 23:41:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,388,1246863600"; 
   d="scan'208";a="176232554"
Date: Sun, 16 Aug 2009 11:28:22 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Rik van Riel <riel@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
Message-ID: <20090816032822.GB6888@localhost>
References: <20090805024058.GA8886@localhost> <20090805155805.GC23385@random.random> <20090806100824.GO23385@random.random> <4A7AAE07.1010202@redhat.com> <20090806102057.GQ23385@random.random> <20090806105932.GA1569@localhost> <4A7AC201.4010202@redhat.com> <20090806130631.GB6162@localhost> <4A7AD79E.4020604@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7AD79E.4020604@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 09:16:14PM +0800, Rik van Riel wrote:
> Wu Fengguang wrote:
> 
> > I guess both schemes have unacceptable flaws.
> > 
> > For JVM/BIGMEM workload, most pages would be found referenced _all the time_.
> > So the KEEP_MOST scheme could increase reclaim overheads by N=250 times;
> > while the DROP_CONTINUOUS scheme is effectively zero cost.
> 
> The higher overhead may not be an issue on smaller systems,
> or inside smaller cgroups inside large systems, when doing
> cgroup reclaim.

Right.

> > However, the DROP_CONTINUOUS scheme does bring more _indeterminacy_.
> > It can behave vastly different on single active task and multi ones.
> > It is short sighted and can be cheated by bursty activities.
> 
> The split LRU VM tries to avoid the bursty page aging as
> much as possible, by doing background deactivating of
> anonymous pages whenever we reclaim page cache pages and
> the number of anonymous pages in the zone (or cgroup) is
> low.

Right, but I meant busty page allocations and accesses on them, which
can make a large continuous segment of referenced pages in LRU list,
say 50MB.  They may or may not be valuable as a whole, however a local
algorithm may keep the first 4MB and drop the remaining 46MB.

Thanks,
Fengguang
