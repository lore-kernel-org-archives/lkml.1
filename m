Return-Path: <linux-kernel-owner+w=401wt.eu-S1760643AbYFDPEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760643AbYFDPEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 11:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbYFDPEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 11:04:25 -0400
Received: from relay2.sgi.com ([192.48.171.30]:56911 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754856AbYFDPEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 11:04:25 -0400
Message-ID: <4846AEF6.2020107@sgi.com>
Date: Wed, 04 Jun 2008 08:04:22 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 02/41] cpu alloc: The allocator
References: <20080530035620.587204923@sgi.com> <20080530040011.084909898@sgi.com> <200805301546.49627.rusty@rustcorp.com.au>
In-Reply-To: <200805301546.49627.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Friday 30 May 2008 13:56:22 Christoph Lameter wrote:
>> The per cpu allocator allows dynamic allocation of memory on all
>> processors simultaneously. A bitmap is used to track used areas.
>> The allocator implements tight packing to reduce the cache footprint
>> and increase speed since cacheline contention is typically not a concern
>> for memory mainly used by a single cpu. Small objects will fill up gaps
>> left by larger allocations that required alignments.
> 
> Allocator seems nice and simple, similar to existing one in module.c (which 
> predates cool bitmap operators).
> 
> Being able to do per-cpu allocations in an interrupt handler seems like 
> encouraging a Bad Idea though: I'd be tempted to avoid the flags word, always 
> zero, and use a mutex instead of a spinlock.
> 
> Cheers,
> Rusty.

I haven't seen any further discussion on these aspects... is there a consensus
to remove the flags from CPU_ALLOC() and use a mutex?

Thanks,
Mike
