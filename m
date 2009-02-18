Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbZBRIJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbZBRIJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 03:09:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZBRIJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 03:09:32 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40451 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbZBRIJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 03:09:31 -0500
Subject: Re: [patch] SLQB slab allocator (try 2)
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <20090218093858.8990.A69D9226@jp.fujitsu.com>
References: <84144f020902171143i5844ef83h20cb4bee4f65c904@mail.gmail.com>
	 <alpine.DEB.1.10.0902171504090.24395@qirst.com>
	 <20090218093858.8990.A69D9226@jp.fujitsu.com>
Date: Wed, 18 Feb 2009 10:09:29 +0200
Message-Id: <1234944569.24030.20.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Wed, 2009-02-18 at 09:48 +0900, KOSAKI Motohiro wrote:
> I think 2 * PAGE_SIZE is best and the patch description is needed change.
> it's because almost architecture use two pages for stack and current page
> allocator don't have delayed consolidation mechanism for order-1 page.

Do you mean alloc_thread_info()? Not all architectures use kmalloc() to
implement it so I'm not sure if that's relevant for this patch.

On Wed, 2009-02-18 at 09:48 +0900, KOSAKI Motohiro wrote:
> In addition, if pekka patch (SLAB_LIMIT = 8K) run on ia64, 16K allocation 
> always fallback to page allocator and using 64K (4 times memory consumption!).

Yes, correct, but SLUB does that already by passing all allocations over
4K to the page allocator.

I'm not totally against 2 * PAGE_SIZE but I just worry that as SLUB
performance will be bound to architecture page size, we will see skewed
results in performance tests without realizing it. That's why I'm in
favor of a fixed size that's unified across architectures.

			Pekka

