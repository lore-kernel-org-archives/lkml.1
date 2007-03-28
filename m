Return-Path: <linux-kernel-owner+w=401wt.eu-S933274AbXC1Uux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274AbXC1Uux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 16:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933297AbXC1Uux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 16:50:53 -0400
Received: from holomorphy.com ([66.93.40.71]:41139 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933274AbXC1Uuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 16:50:52 -0400
Date: Wed, 28 Mar 2007 13:50:55 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [RFC] i386: Remove page sized slabs for pgds and pmds
Message-ID: <20070328205055.GX8915@holomorphy.com>
References: <Pine.LNX.4.64.0703281309210.12985@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703281309210.12985@schroedinger.engr.sgi.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2007 at 01:12:56PM -0700, Christoph Lameter wrote:
> The benefit of preconstructed pgds and pmds in the i386 arch code seem to
> be debatable. The performance measurements indicate that there may be a slight
> benefit but it seems to almost vanish in the noise ratio.
> Method used (i386 1G memory):
> 1. Boot kernel
> 2. make clean
> 3. time make all

Getting the relevant results without tremendous amounts of noise from
other kernel activity needs something like lmbench's fault and fork()
microbenchmarks. Also, /proc/profile and/or oprofile results would be
useful here to get useful notions of what's happening performancewise,
in particular oprofile with L2 cache miss performance counters.

The magnitude of the degradation in the specific operations can't
really be established without these sorts of affairs. We need to know
how large a fraction of the workload is attributable to the operations
in question. Profiling would already give something of a breakdown but
it's difficult to get the numbers to add up properly or to separate
fork() from faults, so the microbenchmarks focused on the particular
operations are needed. The profiles are still needed to understand how
the time shuffled around and to either confirm or invalidate notions
regarding cache behavior.

In any event, I already know the answers because I already did all this
a number of years ago: it's all dominated by PTE caching, which was
never merged, but I carried out-of-tree for several years, so of course
it's in the noise. PMD and PTE caching are only pertinent to fork()
anyway, so the vast majority of your workload is unaffected, and it's
even more "in the noise" due to that. I can't be arsed to care about it
anymore since i386 became a target-system-only architecture for me and
am sick of the flak coming at me for my pagetable caching code anyway.
Hence this patch.


-- wli
