Return-Path: <linux-kernel-owner+w=401wt.eu-S1757040AbZCTQID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040AbZCTQID (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 12:08:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbZCTQHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 12:07:53 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:47888 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbZCTQHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 12:07:52 -0400
Date: Fri, 20 Mar 2009 12:04:42 -0400 (EDT)
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
In-Reply-To: <20090320153723.GO24586@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0903201203340.28571@qirst.com>
References: <1237543392-11797-1-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0903201059240.3740@qirst.com> <20090320153723.GO24586@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Mar 2009, Mel Gorman wrote:

> hmm, I'm missing something in your reasoning. The contention I saw for
> zone->lru_lock
>
> &zone->lru_lock          37350 [<ffffffff8029d6fe>] ____pagevec_lru_add+0x9c/0x172
> &zone->lru_lock          55423 [<ffffffff8029d377>] release_pages+0x10a/0x21b
> &zone->lru_lock            402 [<ffffffff8029d9d9>] activate_page+0x4f/0x147
> &zone->lru_lock              6 [<ffffffff8029dbbd>] put_page+0x94/0x122
>
> So I just assumed it was LRU pages being taken off and freed that was
> causing the contention. Can SLUB affect that?

No. But it can affect the taking of the zone lock.

> Maybe you meant zone->lock and SLUB could tune buffers more to avoid
> that if that lock was hot. That is one alternative but the later patches
> proposed an alternative whereby high-order and compound pages could be
> stored on the PCP lists. Compound only really helps SLUB but high-order
> also helped stacks, signal handlers and the like so it seemed like a
> good idea one way or the other. Course, this meant a search of the PCP
> lists or increasing the size of the PCP structure - swings and
> roundabouts :/

Maybe include those as well? Its good stuff.
