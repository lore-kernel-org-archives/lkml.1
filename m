Return-Path: <linux-kernel-owner+w=401wt.eu-S1757048AbZDUKka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048AbZDUKka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 06:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbZDUKkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 06:40:19 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35503 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbZDUKkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 06:40:17 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 10/25] Calculate the alloc_flags for allocation only once
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090421103709.GR12713@csn.ul.ie>
References: <20090421190921.F15F.A69D9226@jp.fujitsu.com> <20090421103709.GR12713@csn.ul.ie>
Message-Id: <20090421193942.F171.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 21 Apr 2009 19:40:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The changelog now reads
> =====
> 
> Factor out the mapping between GFP and alloc_flags only once. Once factored
> out, it only needs to be calculated once but some care must be taken.
> 
> [neilb@suse.de says]
> As the test:
> 
> -       if (((p->flags & PF_MEMALLOC) ||
>         unlikely(test_thread_flag(TIF_MEMDIE)))
> -                       && !in_interrupt()) {
> -               if (!(gfp_mask & __GFP_NOMEMALLOC)) {
> 
> has been replaced with a slightly weaker one:
> 
> +       if (alloc_flags & ALLOC_NO_WATERMARKS) {
> 
> Without care, this would allow recursion into the allocator via direct
> reclaim. This patch ensures we do not recurse when PF_MEMALLOC is set
> but TF_MEMDIE callers are now allowed to directly reclaim where they
> would have been prevented in the past.

Excellent. :)



