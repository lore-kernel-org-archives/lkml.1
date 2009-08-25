Return-Path: <linux-kernel-owner+w=401wt.eu-S1755653AbZHYSLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbZHYSLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 14:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755626AbZHYSLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 14:11:39 -0400
Received: from mail-px0-f182.google.com ([209.85.216.182]:56094 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755641AbZHYSLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 14:11:38 -0400
Message-ID: <4A94293A.2090103@vflare.org>
Date: Tue, 25 Aug 2009 23:41:06 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Balbir Singh <balbir@linux.vnet.ibm.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-mm-cc@laptop.org
Subject: Re: [PATCH 4/4] compcache: documentation
References: <200908241008.02184.ngupta@vflare.org> <661de9470908251003y3db1fb3awb648f9340cd0beb4@mail.gmail.com>
In-Reply-To: <661de9470908251003y3db1fb3awb648f9340cd0beb4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2009 10:33 PM, Balbir Singh wrote:


>> +It consists of three modules:
>> + - xvmalloc.ko: memory allocator
>
> I've seen your case for a custom allocator, but why can't we
>
> 1) Refactor slob and use it

SLOB is fundamentally a different allocator. It looked at it in detail
but could not image how can I make it suitable for the project. SLOB
really does not fit it.

> 2) Do we care about the optimizations in SLUB w.r.t. scalability in
> your module? If so.. will xvmalloc meet those requirements?
>

Scalability is desired which xvmalloc lacks in its current state. My
plan is to have a wrapper around xvmalloc that creates per-cpu pools
and leave xvmalloc core simple. Along with this, detailed profiling
needs to be done to see where the bottlenecks are in the core itself.


>
> What level of compression have you observed? Any speed trade-offs?
>

All the performance numbers can be found at:
http://code.google.com/p/compcache/wiki/Performance

I also summarized these in patch [0/4]:
http://lkml.org/lkml/2009/8/24/8

The compression ratio is highly workload dependent. On "generic" desktop
workload, stats show:
  - ~80% of pages compressing to PAGE_SIZE/2 or less.
  - ~1% incompressible pages.


For the speed part, please refer to performance numbers at link above.
It show cases where it help or hurts the performance.

Thanks,
Nitin


