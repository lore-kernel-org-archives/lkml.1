Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbZGPNlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbZGPNlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 09:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756648AbZGPNlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 09:41:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38279 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756609AbZGPNlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 09:41:15 -0400
Subject: Re: [PATCH] mm: count only reclaimable lru pages
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       David Howells <dhowells@redhat.com>,
       "riel@redhat.com" <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
In-Reply-To: <20090716133454.GA20550@localhost>
References: <20090716133454.GA20550@localhost>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 15:40:51 +0200
Message-Id: <1247751651.6586.17.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-16 at 21:34 +0800, Wu Fengguang wrote:
> global_lru_pages() / zone_lru_pages() can be used in two ways:
> - to estimate max reclaimable pages in determine_dirtyable_memory()  
> - to calculate the slab scan ratio
> 
> When swap is full or not present, the anon lru lists are not reclaimable
> and thus won't be scanned. So the anon pages shall not be counted. Also
> rename the function names to reflect the new meaning.
> 
> It can greatly (and correctly) increase the slab scan rate under high memory
> pressure (when most file pages have been reclaimed and swap is full/absent),
> thus avoid possible false OOM kills.
> 
> Cc: Minchan Kim <minchan.kim@gmail.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Makes sense.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>


