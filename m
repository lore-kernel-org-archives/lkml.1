Return-Path: <linux-kernel-owner+w=401wt.eu-S1751706AbZBSAF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706AbZBSAF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 19:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbZBSAFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 19:05:18 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47267 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbZBSAFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 19:05:16 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [patch] SLQB slab allocator (try 2)
Cc: kosaki.motohiro@jp.fujitsu.com,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <1234944569.24030.20.camel@penberg-laptop>
References: <20090218093858.8990.A69D9226@jp.fujitsu.com> <1234944569.24030.20.camel@penberg-laptop>
Message-Id: <20090219085229.954A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Thu, 19 Feb 2009 09:05:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

> Hi!
> 
> On Wed, 2009-02-18 at 09:48 +0900, KOSAKI Motohiro wrote:
> > I think 2 * PAGE_SIZE is best and the patch description is needed change.
> > it's because almost architecture use two pages for stack and current page
> > allocator don't have delayed consolidation mechanism for order-1 page.
> 
> Do you mean alloc_thread_info()? Not all architectures use kmalloc() to
> implement it so I'm not sure if that's relevant for this patch.
> 
> On Wed, 2009-02-18 at 09:48 +0900, KOSAKI Motohiro wrote:
> > In addition, if pekka patch (SLAB_LIMIT = 8K) run on ia64, 16K allocation 
> > always fallback to page allocator and using 64K (4 times memory consumption!).
> 
> Yes, correct, but SLUB does that already by passing all allocations over
> 4K to the page allocator.

hmhm
OK. my mail was pointless.

but why? In my understanding, slab framework mainly exist for efficient
sub-page allocation.
the fallbacking of 4K allocation in 64K page-sized architecture seems
inefficient.


> I'm not totally against 2 * PAGE_SIZE but I just worry that as SLUB
> performance will be bound to architecture page size, we will see skewed
> results in performance tests without realizing it. That's why I'm in
> favor of a fixed size that's unified across architectures.

fair point.



