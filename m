Return-Path: <linux-kernel-owner+w=401wt.eu-S1757640AbYBUFLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640AbYBUFLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 00:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbYBUFLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 00:11:07 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:53085 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751059AbYBUFLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 00:11:05 -0500
Message-ID: <47BD06C2.5030602@linux.vnet.ibm.com>
Date: Thu, 21 Feb 2008 10:36:10 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andi Kleen <andi@firstfloor.org>, akpm@osdl.org, torvalds@osdl.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] Document huge memory/cache overhead of memory controller
 in Kconfig
References: <20080220122338.GA4352@basil.nowhere.org> <47BC2275.4060900@linux.vnet.ibm.com> <200802211535.38932.nickpiggin@yahoo.com.au>
In-Reply-To: <200802211535.38932.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Wednesday 20 February 2008 23:52, Balbir Singh wrote:
>> Andi Kleen wrote:
>>> Document huge memory/cache overhead of memory controller in Kconfig
>>>
>>> I was a little surprised that 2.6.25-rc* increased struct page for the
>>> memory controller.  At least on many x86-64 machines it will not fit into
>>> a single cache line now anymore and also costs considerable amounts of
>>> RAM.
>> The size of struct page earlier was 56 bytes on x86_64 and with 64 bytes it
>> won't fit into the cacheline anymore? Please also look at
>> http://lwn.net/Articles/234974/
> 
> BTW. We'll probably want to increase the width of some counters
> in struct page at some point for 64-bit, so then it really will
> go over with the memory controller!
> 

Hmm...

> Actually, an external data structure is a pretty good idea. We
> could probably do it easily with a radix tree (pfn->memory
> controller). And that might be a better option for distros.
> 

I'll put in my long list of TODOs. I started looking at it yesterday again and
here are my early thoughts

1. We could create something similar to mem_map, we would need to handle 4
different ways of creating mem_map.
2. On x86 with 64 GB ram, if we decided to use vmalloc space, we would need 64
MB of vmalloc'ed memory

I have not explored your latest suggestion of pfn <-> memory controller mapping
yet. I'll explore it and see how that goes.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
