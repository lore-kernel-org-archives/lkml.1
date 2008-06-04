Return-Path: <linux-kernel-owner+w=401wt.eu-S1760016AbYFDO60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016AbYFDO60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 10:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754172AbYFDO6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 10:58:17 -0400
Received: from relay1.sgi.com ([192.48.171.29]:38996 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754079AbYFDO6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 10:58:14 -0400
Message-ID: <4846AD84.2090800@sgi.com>
Date: Wed, 04 Jun 2008 07:58:12 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Eric Dumazet <dada1@cosmosbay.com>, akpm@linux-foundation.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 02/41] cpu alloc: The allocator
References: <20080530035620.587204923@sgi.com> <20080530040011.084909898@sgi.com> <483F8AF7.9000309@cosmosbay.com> <Pine.LNX.4.64.0805292219220.12107@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0805292219220.12107@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Fri, 30 May 2008, Eric Dumazet wrote:
> 
>>> +static DEFINE_PER_CPU(UNIT_TYPE, area[UNITS]);
>>>   
>> area[] is not guaranteed to be aligned on anything but 4 bytes.
>>
>> If someone then needs to call cpu_alloc(8, GFP_KERNEL, 8), it might get an non
>> aligned result.
>>
>> Either you should add an __attribute__((__aligned__(PAGE_SIZE))),
>> or take into account the real address of area[] in cpu_alloc() to avoid waste
>> of up to PAGE_SIZE bytes
>> per cpu.
> 
> I think cacheline aligning should be sufficient. People should not 
> allocate large page aligned objects here.

I'm a bit confused.  Why is DEFINE_PER_CPU_SHARED_ALIGNED() conditioned on
ifdef MODULE?

        #ifdef MODULE
        #define SHARED_ALIGNED_SECTION ".data.percpu"
        #else
        #define SHARED_ALIGNED_SECTION ".data.percpu.shared_aligned"
        #endif

        #define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)                       \
                __attribute__((__section__(SHARED_ALIGNED_SECTION)))            \
                PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name             \
                ____cacheline_aligned_in_smp

Thanks,
Mike
