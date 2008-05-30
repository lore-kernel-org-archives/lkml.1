Return-Path: <linux-kernel-owner+w=401wt.eu-S1759330AbYE3FzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330AbYE3FzH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 01:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbYE3Fyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 01:54:55 -0400
Received: from smtp27.orange.fr ([80.12.242.94]:50222 "EHLO smtp27.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701AbYE3Fyz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 01:54:55 -0400
X-ME-UUID: 20080530055453794.C1DE91C00088@mwinf2728.orange.fr
Message-ID: <483F96A8.7060309@cosmosbay.com>
Date: Fri, 30 May 2008 07:54:48 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: Re: [patch 02/41] cpu alloc: The allocator
References: <20080530035620.587204923@sgi.com> <20080530040011.084909898@sgi.com> <483F8AF7.9000309@cosmosbay.com> <Pine.LNX.4.64.0805292219220.12107@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0805292219220.12107@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter a écrit :
> On Fri, 30 May 2008, Eric Dumazet wrote:
>
>   
>>> +static DEFINE_PER_CPU(UNIT_TYPE, area[UNITS]);
>>>   
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
>>     
>
> I think cacheline aligning should be sufficient. People should not 
> allocate large page aligned objects here.
>
>
>   
Hum, maybe, but then we broke modules that might request up to PAGE_SIZE 
alignement for their percpu section,
if I read your 3rd patch correctly.

Taking into account the ((unsigned long)area & (PAGE_SIZE-1)) offset in 
cpu_alloc()
should give up to PAGE_SIZE alignment for free.





