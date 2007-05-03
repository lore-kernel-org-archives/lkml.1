Return-Path: <linux-kernel-owner+w=401wt.eu-S1751580AbXECI0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbXECI0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 04:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbXECI0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 04:26:46 -0400
Received: from holomorphy.com ([66.93.40.71]:55553 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbXECI0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 04:26:45 -0400
Date: Thu, 3 May 2007 01:27:16 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>, Hugh Dickins <hugh@veritas.com>,
       haveblue@ibm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: 2.6.22 -mm merge plans: slub
Message-ID: <20070503082716.GE19966@holomorphy.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <Pine.LNX.4.64.0705011846590.10660@blonde.wat.veritas.com> <20070501125559.9ab42896.akpm@linux-foundation.org> <Pine.LNX.4.64.0705012101410.26170@blonde.wat.veritas.com> <Pine.LNX.4.64.0705011403470.26819@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0705021330001.16517@blonde.wat.veritas.com> <Pine.LNX.4.64.0705021017270.32635@schroedinger.engr.sgi.com> <20070503011515.0d89082b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503011515.0d89082b.akpm@linux-foundation.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 01:15:15AM -0700, Andrew Morton wrote:
> That all seems to work as intended.
> However with NR_CPUS=8 SPLIT_PTLOCK_CPUS=4, enabling SLUB=y crashes the
> machine early in boot.  
> Too early for netconsole, no serial console.  Wedges up uselessly with
> CONFIG_XMON=n, does mysterious repeated uncontrollable exceptions with
> CONFIG_XMON=y.  This is all fairly typical for a powerpc/G5 crash :(
> However I was able to glimpse some stuff as it flew past.  Crash started in
> flush_old_exec and ended in pgtable_free_tlb -> kmem_cache_free.  I don't know
> how to do better than that I'm afraid, unless I'm to hunt down a PCIE serial
> card, perhaps.

I've seen this crash in flush_old_exec() before. ISTR it being due to
slub vs. pagetable alignment or something on that order.


-- wli
