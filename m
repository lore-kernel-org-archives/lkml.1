Return-Path: <linux-kernel-owner+w=401wt.eu-S1756121AbYGUPWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbYGUPWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 11:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbYGUPWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 11:22:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033AbYGUPWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 11:22:14 -0400
Message-ID: <4884A983.7010709@redhat.com>
Date: Mon, 21 Jul 2008 11:21:39 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH]: iommu fix potential overflow in alloc_iommu()
References: <20080721141501.3720.4565.sendpatchset@prarit.bos.redhat.com> <20080722001317N.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080722001317N.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



FUJITA Tomonori wrote:
> On Mon, 21 Jul 2008 10:15:22 -0400
> Prarit Bhargava <prarit@redhat.com> wrote:
>
>   
>> (This didn't appear on LKML or any of the mirrors ... trying again)
>>
>> It is possible that alloc_iommu()'s boundary_size overflows as
>> dma_get_seg_boundary can return 0xffffffff.  In that case, further usage of
>> boundary_size triggers a BUG_ON() in the iommu code.
>>     
>
> Did you actually hit this? pci-gart_64.c is used only by X86_64.
>   

I hit this by declaring a device struct and not declaring a value for 
dev->dma_parms->segment_boundary_mask.

I was attempting to alloc out of the IOMMU and the code then dies on the 
bugcheck in iommu_is_span_boundary() because boundary_size = 0.

P.
