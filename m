Return-Path: <linux-kernel-owner+w=401wt.eu-S1757182AbXKNOmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182AbXKNOmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 09:42:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755095AbXKNOlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 09:41:53 -0500
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:52478 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754772AbXKNOlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 09:41:53 -0500
Message-ID: <473B092F.40206@lwfinger.net>
Date: Wed, 14 Nov 2007 08:41:51 -0600
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: DMA descriptor alignment
References: <4737EF9C.4010207@lwfinger.net> <p731wauyta1.fsf@bingen.suse.de>
In-Reply-To: <p731wauyta1.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
> 
>> For those variants of BCM43xx cards that use 64-bit DMA, there is a requirement that all descriptor
>> rings must be aligned on an 8K boundary and must fit within an 8K page. On the x86_64 architecture
>> where the page size is 4K, I was getting addresses like 0x67AF000 when using dma_alloc_coherent
>> calls.
> 
> Normally x86-64 dma_alloc_coherent calls the buddy allocator which gives
> you always naturally aligned blocks. But there is a fallback calling
> into swiotlb and swiotlb uses best fit allocation which only guarantees
> single page alignment. That is probably what you're seeing.
> 
> My dma zone rework would remove that fallback case and should make it work.
> 
>> From the description of the dma_pool_create and dma_pool_allocate routines, I thought they
>> would fix my problems; however, even with a dma_pool_create(name, dev, 8192, 8192, 8192) call, I'm
>> still getting 4K rather than 8K alignment, which results in DMA errors.
> 
> They cannot give you more alignment than the underlying allocator.
> 
>> Is there a bug in these routines, am I using them incorrectly, or do I have a misunderstanding of
>> what it takes to get this kind of alignment?
> 
> My suggestion as a short term workaround would be to first allocate 
> 8K using dma_alloc_coherent and if that has the wrong alignment get 16K 
> and align yourself. When the driver is loaded later that might be unreliable,
> but near boot or with enough free memory using order 2 should usually work.
>  
> With the dma zone rework that could be removed later.

I will be most interested in the dma zone rework; however, I now have the descriptors properly
allocated merely by asking for 8K, just as I had thought it should work. I'm not quite sure what was
wrong before, but I added a test to make certain that the alignment is OK just in case the problem
comes back.

Thanks for your response,

Larry
