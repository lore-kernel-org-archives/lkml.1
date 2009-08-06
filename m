Return-Path: <linux-kernel-owner+w=401wt.eu-S1755814AbZHFNQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbZHFNQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 09:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755665AbZHFNQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 09:16:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49181 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755657AbZHFNQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 09:16:48 -0400
Message-ID: <4A7AD79E.4020604@redhat.com>
Date: Thu, 06 Aug 2009 09:16:14 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Avi Kivity <avi@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
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
References: <20090805024058.GA8886@localhost> <20090805155805.GC23385@random.random> <20090806100824.GO23385@random.random> <4A7AAE07.1010202@redhat.com> <20090806102057.GQ23385@random.random> <20090806105932.GA1569@localhost> <4A7AC201.4010202@redhat.com> <20090806130631.GB6162@localhost>
In-Reply-To: <20090806130631.GB6162@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:

> I guess both schemes have unacceptable flaws.
> 
> For JVM/BIGMEM workload, most pages would be found referenced _all the time_.
> So the KEEP_MOST scheme could increase reclaim overheads by N=250 times;
> while the DROP_CONTINUOUS scheme is effectively zero cost.

The higher overhead may not be an issue on smaller systems,
or inside smaller cgroups inside large systems, when doing
cgroup reclaim.

> However, the DROP_CONTINUOUS scheme does bring more _indeterminacy_.
> It can behave vastly different on single active task and multi ones.
> It is short sighted and can be cheated by bursty activities.

The split LRU VM tries to avoid the bursty page aging as
much as possible, by doing background deactivating of
anonymous pages whenever we reclaim page cache pages and
the number of anonymous pages in the zone (or cgroup) is
low.

-- 
All rights reversed.
