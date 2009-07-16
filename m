Return-Path: <linux-kernel-owner+w=401wt.eu-S932708AbZGPQVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932708AbZGPQVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 12:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932686AbZGPQVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 12:21:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:5559 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932684AbZGPQVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 12:21:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,412,1243839600"; 
   d="scan'208";a="708418044"
Date: Thu, 16 Jul 2009 09:21:29 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: "Wu, Fengguang" <fengguang.wu@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       David Howells <dhowells@redhat.com>,
       "riel@redhat.com" <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>
Subject: Re: [PATCH] mm: count only reclaimable lru pages
Message-ID: <20090716092129.1dbb0138@jbarnes-g45>
In-Reply-To: <20090716133454.GA20550@localhost>
References: <20090716133454.GA20550@localhost>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jul 2009 06:34:55 -0700
"Wu, Fengguang" <fengguang.wu@intel.com> wrote:

> global_lru_pages() / zone_lru_pages() can be used in two ways:
> - to estimate max reclaimable pages in determine_dirtyable_memory()  
> - to calculate the slab scan ratio
> 
> When swap is full or not present, the anon lru lists are not
> reclaimable and thus won't be scanned. So the anon pages shall not be
> counted. Also rename the function names to reflect the new meaning.
> 
> It can greatly (and correctly) increase the slab scan rate under high
> memory pressure (when most file pages have been reclaimed and swap is
> full/absent), thus avoid possible false OOM kills.
> 
> Cc: Minchan Kim <minchan.kim@gmail.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  include/linux/vmstat.h |   11 +--------
>  mm/page-writeback.c    |    5 ++--
>  mm/vmscan.c            |   44 +++++++++++++++++++++++++++++----------
>  3 files changed, 38 insertions(+), 22 deletions(-)
> 

Looks nice to me, including the naming.  FWIW (given that it's been
years since I did any serious VM work):

Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
