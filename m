Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbYJJHqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbYJJHqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 03:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbYJJHqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 03:46:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49072 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbYJJHqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 03:46:09 -0400
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Dave Jones <davej@redhat.com>, x86@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Update cacheline size on X86_GENERIC
From: Andi Kleen <andi@firstfloor.org>
References: <20081009171453.GA15321@redhat.com>
	<200810101428.23662.nickpiggin@yahoo.com.au>
Date: Fri, 10 Oct 2008 09:46:01 +0200
In-Reply-To: <200810101428.23662.nickpiggin@yahoo.com.au> (Nick Piggin's message of "Fri, 10 Oct 2008 14:28:23 +1100")
Message-ID: <87tzbksxja.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> writes:

> On Friday 10 October 2008 04:14, Dave Jones wrote:
>> I just noticed that configuring a kernel to use CONFIG_X86_GENERIC
>> (as is typical for a distro kernel) configures it to use a 128 byte
>> cacheline size. This made sense when that was commonplace (P4 era) but
>> current
>> Intel, AMD and VIA cpus use 64 byte cachelines.
>
> I think P4 technically did have 64 byte cachelines, but had some adjacent
> line prefetching.

The "coherency unit" on P4, which is what matters for SMP alignment
purposes to avoid false sharing, is 128 bytes.

> And AFAIK core2 CPUs can do similar prefetching (but
> maybe it's smarter and doesn't cause so much bouncing?).

On Core2 the coherency unit is 64bytes.

> Anyway, GENERIC kernel should run well on all architectures, and while
> going too big causes slightly increased structures sometimes, going too
> small could result in horrible bouncing.

Exactly.

That is it costs one percent or so on TPC, but I think the fix
for that is just to analyze where the problem is and size those
data structures based on the runtime cache size. Some subsystems
like slab do this already.

TPC is a bit of a extreme case because it is so extremly cache bound.

Overall the memory impact of the cache padding is getting less over
time because more and more data is moving into the per CPU data areas.

-Andi

-- 
ak@linux.intel.com
