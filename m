Return-Path: <linux-kernel-owner+w=401wt.eu-S1752891AbZH1TxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbZH1TxH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 15:53:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbZH1TxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 15:53:06 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:38739 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbZH1TxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 15:53:05 -0400
Date: Sat, 29 Aug 2009 01:23:03 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-mm-cc@laptop.org
Subject: Re: [PATCH 4/4] compcache: documentation
Message-ID: <20090828195303.GA4889@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <200908241008.02184.ngupta@vflare.org> <661de9470908251003y3db1fb3awb648f9340cd0beb4@mail.gmail.com> <4A94293A.2090103@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4A94293A.2090103@vflare.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nitin Gupta <ngupta@vflare.org> [2009-08-25 23:41:06]:

> On 08/25/2009 10:33 PM, Balbir Singh wrote:
>
>
>>> +It consists of three modules:
>>> + - xvmalloc.ko: memory allocator
>>
>> I've seen your case for a custom allocator, but why can't we
>>
>> 1) Refactor slob and use it
>
> SLOB is fundamentally a different allocator. It looked at it in detail
> but could not image how can I make it suitable for the project. SLOB
> really does not fit it.
>
>> 2) Do we care about the optimizations in SLUB w.r.t. scalability in
>> your module? If so.. will xvmalloc meet those requirements?
>>
>
> Scalability is desired which xvmalloc lacks in its current state. My
> plan is to have a wrapper around xvmalloc that creates per-cpu pools
> and leave xvmalloc core simple. Along with this, detailed profiling
> needs to be done to see where the bottlenecks are in the core itself.
>

I've not yet tested the patches, but adding another allocator does
worry me a bit. Do you intend to allow other users to consume the
allocator routines?

>
>>
>> What level of compression have you observed? Any speed trade-offs?
>>
>
> All the performance numbers can be found at:
> http://code.google.com/p/compcache/wiki/Performance
>
> I also summarized these in patch [0/4]:
> http://lkml.org/lkml/2009/8/24/8
>
> The compression ratio is highly workload dependent. On "generic" desktop
> workload, stats show:
>  - ~80% of pages compressing to PAGE_SIZE/2 or less.
>  - ~1% incompressible pages.
>
>
> For the speed part, please refer to performance numbers at link above.
> It show cases where it help or hurts the performance.
>

Thanks, I'll take a look at the links

-- 
	Balbir
