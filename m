Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbZEYNUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbZEYNUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 09:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbZEYNUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 09:20:35 -0400
Received: from mail2.shareable.org ([80.68.89.115]:59200 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbZEYNUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 09:20:34 -0400
Date: Mon, 25 May 2009 14:20:27 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Catalin Marinas <catalin.marinas@arm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Broken ARM atomic ops wrt memory barriers (was : [PATCH] Add cmpxchg support for ARMv6+ systems)
Message-ID: <20090525132027.GA946@shareable.org>
References: <20090422171703.19555.83629.stgit@pc1117.cambridge.arm.com> <20090423141248.22193.10543.stgit@pc1117.cambridge.arm.com> <20090524131636.GB3159@n2100.arm.linux.org.uk> <20090524145633.GA14754@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090524145633.GA14754@Krystal>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> I use a local cmpxchg in the LTTng tree as key instruction to manage the
> ring buffer in a irq, softirq and NMI-safe way (due to the atomic nature
> of this instruction), but without the overhead of synchronizing across
> CPUs.
> 
> On ARM, the semantic looks a bit like PowerPC with linked load/linked
> store, and you don't seem to need memory barriers. I guess that's either
> because
> 
> a) they are implicit in the ll/ls or
> b) ARM does not perform out-of-order memory read/writes or
> c) they've simply been forgotten, and it's a bug.
> 
> the cmpxchg local instruction maps currently to cmpxchg, as a fallback,
> since there is no difference between the SMP-aware and UP-only
> instructions.
> 
> But if I look at arch/arm/include/asm/spinlock.h, the answer I get seems
> to be c) : ARM needs memory barriers.

Memory barriers only affect the observed access order with respect to
other processors (and perhaps other devices).

So a CPU-local operation would not need barriers.  CPU-local code,
including local IRQs, see all memory accesses in the same order as
executed instructions.

Of course you need barriers at some point, when using the local data
to update global data seen by other CPUs at a later time.  But that is
hopefully done elsewhere.

After considering this, do you think it's still missing barriers?

-- Jamie
