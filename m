Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbXCOXM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbXCOXM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 19:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753435AbXCOXM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 19:12:59 -0400
Received: from holomorphy.com ([66.93.40.71]:54914 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753434AbXCOXM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 19:12:58 -0400
Date: Thu, 15 Mar 2007 16:12:54 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, clameter@sgi.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 0/4] Arch independent quicklists V2
Message-ID: <20070315231254.GY2986@holomorphy.com>
References: <20070313071325.4920.82870.sendpatchset@schroedinger.engr.sgi.com> <20070313005334.853559ca.akpm@linux-foundation.org> <45F65ADA.9010501@yahoo.com.au> <20070313035250.f908a50e.akpm@linux-foundation.org> <45F685C6.8070806@yahoo.com.au> <20070313041551.565891b5.akpm@linux-foundation.org> <45F68B4B.9020200@yahoo.com.au> <20070313044756.b45649ac.akpm@linux-foundation.org> <20070314011244.GM2986@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070314011244.GM2986@holomorphy.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 06:12:44PM -0700, William Lee Irwin III wrote:
> There are furthermore distinctions to make between fork() and execve().
> fork() stomps over the entire process address space copying pagetables
> en masse. After execve() a process incrementally faults in PTE's one at
> a time. It should be clear that if case analyses are of interest at
> all, fork() will want cache-hot pages (cache-preloaded pages?) where
> such are largely wasted on incremental faults after execve(). The copy
> operations in fork() should probably also be examined in the context of
> shared pagetables at some point.

To make this perfectly clear, we can deal with the varying usage cases
with hot/cold flags to the pagetable allocator functions. Where bulk
copies such as fork() are happening, it makes perfect sense to
precharge the cache by eager zeroing. Where sparse single pte affairs
such as incrementally faulting things in after execve() are involved,
cache cold preconstructed pagetable pages are ideal. Address hints
could furthermore be used to precharge single cachelines (e.g. via
prefetch) in the sparse usage case.


-- wli
