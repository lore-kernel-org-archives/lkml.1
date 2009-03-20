Return-Path: <linux-kernel-owner+w=401wt.eu-S1757040AbZCTPD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040AbZCTPD3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 11:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbZCTPDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 11:03:21 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:49284 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbZCTPDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 11:03:20 -0400
Date: Fri, 20 Mar 2009 11:00:42 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/25] Cleanup and optimise the page allocator V5
In-Reply-To: <1237543392-11797-1-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0903201059240.3740@qirst.com>
References: <1237543392-11797-1-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Mar 2009, Mel Gorman wrote:

> The lock contention on some machines goes up for the the zone->lru_lock
> and zone->lock locks which can regress some workloads even though others on
> the same machine still go faster. For netperf, a lock called slock-AF_INET
> seemed very important although I didn't look too closely other than noting
> contention went up. The zone->lock gets hammered a lot by high order allocs
> and frees coming from SLUB which are not covered by the PCP allocator in
> this patchset. zone->lru_lock goes up is less clear but as it's page cache
> releases but overall contention may be up because CPUs are spending less
> time with interrupts disabled and more time trying to do real work but
> contending on the locks.

We can tune SLUB to buffer more pages if the lru lock becomes too hot.


