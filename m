Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938AbZHPD5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbZHPD5P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 23:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbZHPD5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 23:57:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54579 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730AbZHPD5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 23:57:14 -0400
Message-ID: <4A878377.70502@redhat.com>
Date: Sat, 15 Aug 2009 23:56:39 -0400
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
References: <20090805024058.GA8886@localhost> <20090805155805.GC23385@random.random> <20090806100824.GO23385@random.random> <4A7AAE07.1010202@redhat.com> <20090806102057.GQ23385@random.random> <20090806105932.GA1569@localhost> <4A7AC201.4010202@redhat.com> <20090806130631.GB6162@localhost> <4A7AD79E.4020604@redhat.com> <20090816032822.GB6888@localhost>
In-Reply-To: <20090816032822.GB6888@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:

> Right, but I meant busty page allocations and accesses on them, which
> can make a large continuous segment of referenced pages in LRU list,
> say 50MB.  They may or may not be valuable as a whole, however a local
> algorithm may keep the first 4MB and drop the remaining 46MB.

I wonder if the problem is that we simply do not keep a large
enough inactive list in Jeff's test.  If we do not, pages do
not have a chance to be referenced again before the reclaim
code comes in.

The cgroup stats should show how many active anon and inactive
anon pages there are in the cgroup.

-- 
All rights reversed.
