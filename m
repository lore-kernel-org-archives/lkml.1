Return-Path: <linux-kernel-owner+w=401wt.eu-S1752323AbYGUPsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbYGUPsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 11:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751014AbYGUPsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 11:48:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbYGUPsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 11:48:12 -0400
Message-ID: <4884AFA3.9070804@redhat.com>
Date: Mon, 21 Jul 2008 11:47:47 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH]: iommu fix potential overflow in alloc_iommu()
References: <20080721141501.3720.4565.sendpatchset@prarit.bos.redhat.com>	<20080722001317N.fujita.tomonori@lab.ntt.co.jp>	<4884A983.7010709@redhat.com> <20080722004638M.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080722004638M.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



FUJITA Tomonori wrote:
> On Mon, 21 Jul 2008 11:21:39 -0400
> Prarit Bhargava <prarit@redhat.com> wrote:
>
>   
>> FUJITA Tomonori wrote:
>>     
>>> On Mon, 21 Jul 2008 10:15:22 -0400
>>> Prarit Bhargava <prarit@redhat.com> wrote:
>>>
>>>   
>>>       
>>>> (This didn't appear on LKML or any of the mirrors ... trying again)
>>>>
>>>> It is possible that alloc_iommu()'s boundary_size overflows as
>>>> dma_get_seg_boundary can return 0xffffffff.  In that case, further usage of
>>>> boundary_size triggers a BUG_ON() in the iommu code.
>>>>     
>>>>         
>>> Did you actually hit this? pci-gart_64.c is used only by X86_64.
>>>   
>>>       
>> I hit this by declaring a device struct and not declaring a value for 
>> dev->dma_parms->segment_boundary_mask.
>>     
>
> What do you mean? You set dev->dma_params but does't set
> dev->dma_parms->segment_boundary_mask? If so, you need to fix your
> code. If you set dev->dma_parms, dma_parms needs to be initialized
> properly.
>   

No, I didn't set dev->dma_params.

P.

