Return-Path: <linux-kernel-owner+w=401wt.eu-S1759656AbYFDPaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656AbYFDPaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 11:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754095AbYFDPa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 11:30:27 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60880 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750959AbYFDPa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 11:30:26 -0400
Message-ID: <4846B50F.5060808@sgi.com>
Date: Wed, 04 Jun 2008 08:30:23 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Christoph Lameter <clameter@sgi.com>, Eric Dumazet <dada1@cosmosbay.com>,
       akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 02/41] cpu alloc: The allocator
References: <20080530035620.587204923@sgi.com> <483F8AF7.9000309@cosmosbay.com> <Pine.LNX.4.64.0805292219220.12107@schroedinger.engr.sgi.com> <200805301552.25423.rusty@rustcorp.com.au>
In-Reply-To: <200805301552.25423.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Friday 30 May 2008 15:20:45 Christoph Lameter wrote:
>> On Fri, 30 May 2008, Eric Dumazet wrote:
>>>> +static DEFINE_PER_CPU(UNIT_TYPE, area[UNITS]);
>>> area[] is not guaranteed to be aligned on anything but 4 bytes.
>>>
>>> If someone then needs to call cpu_alloc(8, GFP_KERNEL, 8), it might get
>>> an non aligned result.
>>>
>>> Either you should add an __attribute__((__aligned__(PAGE_SIZE))),
>>> or take into account the real address of area[] in cpu_alloc() to avoid
>>> waste of up to PAGE_SIZE bytes
>>> per cpu.
>> I think cacheline aligning should be sufficient. People should not
>> allocate large page aligned objects here.
> 
> I vaguely recall there were issues with this in the module code.  They might 
> be gone now, but failing to meet alignment contraints without a big warning 
> would suck.
> 
> But modifying your code to consider the actual alignment is actually pretty 
> trivial, AFAICT.
> 
> Cheers,
> Rusty.

So paraphrasing my earlier email, we should add:

	bitmap_find_free_area(bitmap, nbits, size, align, alignbase)

so that > cacheline alignment is possible?

My thinking is that if we do go to true dynamically sized cpu_alloc area then
allocating PAGE_SIZE units may be both practical and worthwhile...?

Thanks,
Mike
