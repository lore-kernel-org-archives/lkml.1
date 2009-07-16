Return-Path: <linux-kernel-owner+w=401wt.eu-S1757504AbZGPOZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504AbZGPOZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 10:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757232AbZGPOZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 10:25:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:28648 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757154AbZGPOZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 10:25:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,411,1243839600"; 
   d="scan'208";a="165725163"
Date: Thu, 16 Jul 2009 22:25:33 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       David Howells <dhowells@redhat.com>,
       "riel@redhat.com" <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
Subject: Re: [PATCH] mm: count only reclaimable lru pages
Message-ID: <20090716142533.GA27165@localhost>
References: <20090716133454.GA20550@localhost> <alpine.DEB.1.10.0907160959260.32382@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0907160959260.32382@gentwo.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 10:00:51PM +0800, Christoph Lameter wrote:
> On Thu, 16 Jul 2009, Wu Fengguang wrote:
> 
> > When swap is full or not present, the anon lru lists are not reclaimable
> > and thus won't be scanned. So the anon pages shall not be counted. Also
> > rename the function names to reflect the new meaning.
> >
> > It can greatly (and correctly) increase the slab scan rate under high memory
> > pressure (when most file pages have been reclaimed and swap is full/absent),
> > thus avoid possible false OOM kills.
> 
> Reclaimable? Are all pages on the LRUs truly reclaimable?

No, only possibly reclaimable :)

What would you suggest?  In fact I'm not totally comfortable with it.
Maybe it would be safer to simply stick with the old _lru_pages naming?

Thanks,
Fengguang

> Aside from that nit.
> 
> Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
