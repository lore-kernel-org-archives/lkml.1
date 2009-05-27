Return-Path: <linux-kernel-owner+w=401wt.eu-S932369AbZE0TLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369AbZE0TLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 15:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761302AbZE0TLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 15:11:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:47671 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761245AbZE0TLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 15:11:16 -0400
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-Id: <2A2CCBB9-12B1-43CD-9183-B851FF321B30@kernel.crashing.org>
From: Becky Bruce <beckyb@kernel.crashing.org>
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
In-Reply-To: <1243342307.9295.86.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH V2 2/3] powerpc: Add support for swiotlb on 32-bit
Date: Wed, 27 May 2009 14:11:05 -0500
References: <1242340949-16369-1-git-send-email-beckyb@kernel.crashing.org> <1242340949-16369-2-git-send-email-beckyb@kernel.crashing.org> <20090519142656T.fujita.tomonori@lab.ntt.co.jp> <19E48A70-3332-423C-ACAD-390F940EE81C@kernel.crashing.org> <4A1592CF.8000208@goop.org> <E6DAA792-9923-4B76-9759-6955AABE3EAB@kernel.crashing.org> <1242990702.22654.253.camel@zakaz.uk.xensource.com> <4A173B72.5000201@goop.org> <1243342307.9295.86.camel@zakaz.uk.xensource.com>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 26, 2009, at 7:51 AM, Ian Campbell wrote:

> On Fri, 2009-05-22 at 19:55 -0400, Jeremy Fitzhardinge wrote:
>> Ian Campbell wrote:
>>> On Thu, 2009-05-21 at 14:27 -0400, Becky Bruce wrote:
>>>
>>>> I can work with that, but it's going to be a bit inefficient, as I
>>>> actually need the dma_addr_t, not the phys_addr_t, so I'll have to
>>>> convert.  In every case, this is a conversion I've already done and
>>>> that I need in the calling code as well.
>>>>
>>>
>>> Does
>>>
>>>    dma_addr_t dma_map_range(struct device *hwdev, phys_addr_t addr,
>>>    size_t size);
>>>
>>> work for you?
>>>
>>> If the range does not need mapping then it returns the dma  
>>> address, if
>>> you needed to calculate the dma address anyway to figure out if  
>>> mapping
>>> is required then this is fine. If the range does need mapping then  
>>> it
>>> returns NULL.
>>>
>>
>> My only concern is whether dma_addr_t == 0 is actually equivalent to
>> NULL.  That is, can we be sure that address 0 will never be used?
>
> It seems not, ~0UL might have been an option, but...
>
>> Taking dma_alloc_coherent as a model, we could have something like:
>>
>>    int dma_map_range(struct device *hwdev, phys_addr_t addr, size_t  
>> size, dma_addr_t *dma_addrp);
>>
>>
>> where *dma_addrp is set if the function returns success (bool return
>> type might be clearer).
>
> ... this sounds like a good idea to me.

I agree.  This will work for me as well.

-becky

