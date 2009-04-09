Return-Path: <linux-kernel-owner+w=401wt.eu-S1760875AbZDIEpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760875AbZDIEpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 00:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759460AbZDIEoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 00:44:54 -0400
Received: from gate.crashing.org ([63.228.1.57]:53650 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758885AbZDIEox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 00:44:53 -0400
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, hch@infradead.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, ian.campbell@citrix.com,
       beckyb@kernel.crashing.org
Message-Id: <25E78C44-E366-40D1-AC1B-3022F1A95069@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <49DD3C9C.7060101@goop.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH 4/7] swiotlb: Allow arch override of address_needs_mapping
Date: Wed, 8 Apr 2009 23:43:27 -0500
References: <49DD270A.6060506@goop.org>	<20090409080143C.fujita.tomonori@lab.ntt.co.jp>	<49DD3041.8020808@goop.org> <20090409083752I.fujita.tomonori@lab.ntt.co.jp> <49DD3C9C.7060101@goop.org>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 8, 2009, at 7:09 PM, Jeremy Fitzhardinge wrote:

> FUJITA Tomonori wrote:
>> On Wed, 08 Apr 2009 16:16:17 -0700
>> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>
>>
>>> FUJITA Tomonori wrote:
>>>
>>>>> Becky's patches of last week also added __weak annotations to  
>>>>> swiotlb_bus_to_virt, virt_to_bus and bus_to_phys; added the  
>>>>> hwdev parameter to swiotlb_bus_to_phys; and added a weak  
>>>>> swiotlb_arch_address_needs_mapping.  I assume that was needed  
>>>>> because powerpc needs non-trivial implementations for those  
>>>>> functions.
>>>>>
>>>> Hmm, what she added are wrappers of virt_to_bus and bus_to_virt. We
>>>> can remove these and directly use virt_to_bus and bus_to_virt.
>>>>
>>> In general those interfaces are deprecated.  Are we un-deprecating  
>>> them?  Or do you mean adding virt<->bus to dma_ops?
>>>
>>
>> Hmm, these interfaces are wrong for drivers surely because they can't
>> handle dma mapping properly. However, they are exactly what swiotlb
>> needs (swiotlb doesn't need to care about dma mapping).
>
> It needs to care about the mapping from phys to bus.  On x86 they're  
> identical, but on powerpc there can be at least an offset between  
> them.
>
>> Until 2.6.28,
>> swiotlb has used them. They are with IA64, X86_64 and PPC_32, I  
>> think.
>>
>
> Well, Becky's patches also added the hwdev argument to them, so  
> presumably the powerpc implementation needs that (different devices/ 
> buses have differing views of physical memory, I guess).

On powerpc we need the hwdev because things vary based on bus.  For  
our SoC chips we don't need any mapping between phys & bus.  However  
something like PCI does have a mapping (a simple offset).

- k
