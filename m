Return-Path: <linux-kernel-owner+w=401wt.eu-S1756678AbYGWXZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbYGWXZB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 19:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755395AbYGWXYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 19:24:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755152AbYGWXYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 19:24:50 -0400
Message-ID: <4887BDB0.3000806@redhat.com>
Date: Wed, 23 Jul 2008 19:24:32 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
References: <20080723111928.15828.42561.sendpatchset@prarit.bos.redhat.com> <20080724082347U.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080724082347U.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



FUJITA Tomonori wrote:
> On Wed, 23 Jul 2008 07:19:43 -0400
> Prarit Bhargava <prarit@redhat.com> wrote:
>
>   
>> pci_alloc_consistent/dma_alloc_coherent does not return size aligned
>> addresses.
>>
>> From Documentation/DMA-mapping.txt:
>>
>> "pci_alloc_consistent returns two values: the virtual address which you
>> can use to access it from the CPU and dma_handle which you pass to the
>> card.
>>
>> The cpu return address and the DMA bus master address are both
>> guaranteed to be aligned to the smallest PAGE_SIZE order which
>> is greater than or equal to the requested size.  This invariant
>> exists (for example) to guarantee that if you allocate a chunk
>> which is smaller than or equal to 64 kilobytes, the extent of the
>> buffer you receive will not cross a 64K boundary."
>>
>> 1.  Modify alloc_iommu to allow for an alignment mask
>> 2.  Modify pci_gart_simple to return size-aligned values.
>> 3.  Fixup the alignment calculation in the iommu-helper code.
>>     
>
> Hmm, you don't fix anything in the helper code. You just use
> __ALIGN_MASK.
>
>   
Yeah -- I meant "fixup" as opposed to fix.

> And please don't use __ALIGN_MASK. You will notice that no one in
> mainline use __ALIGN_MASK. Andrew said that we should not.
>
> Ideally, we should use ALIGN here but the current code was accepted
> because it is pretty simple and we have an comment what we do here. So
> please let it alone.
>   

I'll resubmit shortly ...

P.
