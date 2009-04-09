Return-Path: <linux-kernel-owner+w=401wt.eu-S936518AbZDIUMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936518AbZDIUMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 16:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935959AbZDIUL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 16:11:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:51857 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936081AbZDIUL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 16:11:58 -0400
Cc: jeremy@goop.org, hch@infradead.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, ian.campbell@citrix.com, beckyb@kernel.crashing.org
Message-Id: <F46E8277-0165-4C4F-9DFE-7697881536C0@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090410035037U.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH 4/7] swiotlb: Allow arch override of address_needs_mapping
Date: Thu, 9 Apr 2009 15:10:05 -0500
References: <49DD270A.6060506@goop.org> <20090409080143C.fujita.tomonori@lab.ntt.co.jp> <4D1571C8-53B8-4A4E-BCE8-7267ED262189@kernel.crashing.org> <20090410035037U.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 9, 2009, at 1:50 PM, FUJITA Tomonori wrote:

> On Wed, 8 Apr 2009 23:59:18 -0500
> Kumar Gala <galak@kernel.crashing.org> wrote:
>
>>
>> On Apr 8, 2009, at 6:01 PM, FUJITA Tomonori wrote:
>>
>>>> Becky's patches of last week also added __weak annotations to
>>>> swiotlb_bus_to_virt, virt_to_bus and bus_to_phys; added the hwdev
>>>> parameter to swiotlb_bus_to_phys; and added a weak
>>>> swiotlb_arch_address_needs_mapping.  I assume that was needed  
>>>> because
>>>> powerpc needs non-trivial implementations for those functions.
>>>
>>> Hmm, what she added are wrappers of virt_to_bus and bus_to_virt. We
>>> can remove these and directly use virt_to_bus and bus_to_virt.
>>>
>>> About __weak address_needs_mapping function, as I said, removing it
>>> and using dma_map_ops is a proper solution.
>>
>> Is this something you are looking at doing in the .31 timeframe?
>>
>> I'm looking at the fact that we need to switch over to using struct
>> dma_map_ops on ppc.  (I'm guessing this might be the patches you
>> mentioned the other day).  If so did you add set_dma_mask() to the
>> generic dma_map_ops?
>
> Yeah, I'll send patches to convert ppc to use dma_map_ops. In .31
> timeframe, I plan to:
>
> - add a generic dma-mapping.h and convert ia64, x86, and ppc to use it
>
> - clean up swiotlb.
>
> - try to convert archs supporting multiple dma ops to use dma_map_ops
>
> - rewrite ia64 and x86 dma ops initialization
>
>
> BTW, the ppc specific swiotlb patchset is available?

Still cleaning it up, but I'll post a WIP patch so people have a sense  
of what the changes look like.

- k

