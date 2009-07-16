Return-Path: <linux-kernel-owner+w=401wt.eu-S932537AbZGPQBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537AbZGPQBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 12:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757600AbZGPQBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 12:01:24 -0400
Received: from cmpxchg.org ([85.214.51.133]:45040 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756536AbZGPQBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 12:01:23 -0400
Date: Thu, 16 Jul 2009 17:59:54 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
Subject: Re: [PATCH] mm: count only reclaimable lru pages v2
Message-ID: <20090716155954.GA1883@cmpxchg.org>
References: <20090716133454.GA20550@localhost> <alpine.DEB.1.10.0907160959260.32382@gentwo.org> <20090716142533.GA27165@localhost> <1247754491.6586.23.camel@laptop> <alpine.DEB.1.10.0907161037590.7930@gentwo.org> <4A5F3C70.7010001@redhat.com> <20090716150901.GA31204@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090716150901.GA31204@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 11:09:01PM +0800, Wu Fengguang wrote:

> mm: count only reclaimable lru pages 
> 
> global_lru_pages() / zone_lru_pages() can be used in two ways:
> - to estimate max reclaimable pages in determine_dirtyable_memory()  
> - to calculate the slab scan ratio
> 
> When swap is full or not present, the anon lru lists are not reclaimable
> and also won't be scanned. So the anon pages shall not be counted in both
> usage scenarios. Also rename to _reclaimable_pages: now they are counting
> the possibly reclaimable lru pages.
> 
> It can greatly (and correctly) increase the slab scan rate under high memory
> pressure (when most file pages have been reclaimed and swap is full/absent),
> thus reduce false OOM kills.
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Reviewed-by: Rik van Riel <riel@redhat.com>
> Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
