Return-Path: <linux-kernel-owner+w=401wt.eu-S1752863AbXC1VY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbXC1VY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 17:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbXC1VY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 17:24:56 -0400
Received: from holomorphy.com ([66.93.40.71]:49390 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863AbXC1VYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 17:24:55 -0400
Date: Wed, 28 Mar 2007 14:24:59 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [RFC] i386: Remove page sized slabs for pgds and pmds
Message-ID: <20070328212459.GY8915@holomorphy.com>
References: <Pine.LNX.4.64.0703281309210.12985@schroedinger.engr.sgi.com> <20070328205055.GX8915@holomorphy.com> <Pine.LNX.4.64.0703281356080.13258@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703281356080.13258@schroedinger.engr.sgi.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007, William Lee Irwin III wrote:
>> Getting the relevant results without tremendous amounts of noise from
>> other kernel activity needs something like lmbench's fault and fork()
>> microbenchmarks. Also, /proc/profile and/or oprofile results would be
>> useful here to get useful notions of what's happening performancewise,
>> in particular oprofile with L2 cache miss performance counters.

On Wed, Mar 28, 2007 at 02:00:44PM -0700, Christoph Lameter wrote:
> The machine had a minimal debian root and it was run on a serial console.

The other activity I referred to was the massive amount of crap like
mremap(), gettimeofday(), open()/close()/etc., spinning in userspace,
etc. that kernel compiles do. An otherwise quiescent system is a
distinct prerequisite for validity. Most of what you've "proven" with
the kernel compile is that pagetable construction is probably not a
significant portion of kernel compiles and not anything about relative
speed apart from eager construction being unquantifiably slower.


On Wed, 28 Mar 2007, William Lee Irwin III wrote:
>> it's in the noise. PMD and PTE caching are only pertinent to fork()
>> anyway, so the vast majority of your workload is unaffected, and it's

On Wed, Mar 28, 2007 at 02:00:44PM -0700, Christoph Lameter wrote:
> I'd be interested to see some numbers here. I still believe the situation 
> to be better on IA64 and other platforms due to the larger page sizes 
> containing many more cachelines which should make the effect bigger.

Bad quoting; this is reminiscent of PR hackery where subsequences of
words from the middle of sentences are cut out with audio editors in
order to form an embarrassing quote. The full paragraph:


On Wed, Mar 28, 2007 at 01:50:55PM -0700, William Lee Irwin III wrote:
> In any event, I already know the answers because I already did all this
> a number of years ago: it's all dominated by PTE caching, which was
> never merged, but I carried out-of-tree for several years, so of course
> it's in the noise. PMD and PTE caching are only pertinent to fork()
> anyway, so the vast majority of your workload is unaffected, and it's
> even more "in the noise" due to that. I can't be arsed to care about it
> anymore since i386 became a target-system-only architecture for me and
> am sick of the flak coming at me for my pagetable caching code anyway.
> Hence this patch.

I'd also appreciate if it were mentioned who actually wrote this, given
that the patch posted was what I sent you verbatim (and actually
requested you not post for good reasons, some centering around pageattr.c).

The salient point from the above, which was conveniently omitted, was
"it's all dominated by PTE caching." However, even this needs some
qualification having to do with the VSZ of the parent process in fork().
For very small processes, such as cannot be constructed with glibc due
to its massive bloat and cannot be constructed with the standard process
address space layouts due to stacks being too distant from text and
heap, PTE's actually don't substantially outnumber PMD's et al, so
there is more to this story.


-- wli
