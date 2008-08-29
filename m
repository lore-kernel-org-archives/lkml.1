Return-Path: <linux-kernel-owner+w=401wt.eu-S1753113AbYH2HCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbYH2HCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 03:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbYH2HCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 03:02:07 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:33449 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbYH2HCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 03:02:05 -0400
Date: Fri, 29 Aug 2008 10:01:03 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, geert@linux-m68k.org
Subject: Re: [RFC: 2.6 patch] m68knommu: remove the broken COMEMPCI code
Message-ID: <20080829070103.GD16462@cs181140183.pp.htv.fi>
References: <20080819134718.GH8852@cs181140183.pp.htv.fi> <48B24E2C.9060703@snapgear.com> <20080825204333.GA13027@cs181140183.pp.htv.fi> <48B77764.6060607@snapgear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <48B77764.6060607@snapgear.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 02:13:24PM +1000, Greg Ungerer wrote:
> Hi Adrian,
>
> Adrian Bunk wrote:
>> On Mon, Aug 25, 2008 at 04:16:12PM +1000, Greg Ungerer wrote:
>>> Hi Adrian,
>>>
>>> Adrian Bunk wrote:
>>>> There exists blackfin hardware with PCI support, but the support
>>>> currently in the kernel fails to build starting with:
>>>>
>>>> <--  snip  -->
>>>>
>>>> ...
>>>>   CC      init/main.o
>>>> In file included from dma-mapping.h:5,
>>>>                  from dma-mapping.h:52,
>>>>                  from dmaengine.h:29,
>>>>                  from skbuff.h:29,
>>>>                  from netlink.h:155,
>>>>                  from genetlink.h:4,
>>>>                  from genetlink.h:4,
>>>>                  from taskstats_kern.h:12,
>>>>                  from main.c:46:
>>>> dma-mapping.h: In function 'dma_supported': ma-mapping.h:24: error: 
>>>> implicit declaration of function 'pci_dma_supported'
>>>> ...
>>>> make[2]: *** [init/main.o] Error 1
>>> I think we should just remove the underlying comempci access
>>> code which is the only user of this (arch/m68knommu/kernel/comempci.c).
>>> Nobody has used it in a very long time. And the hardware itself is
>>> old, and completely brain-damaged by design.
>>
>> A patch for removing the comempci code is below.
>>
>> It's a bit suspicious that asm/elia.h is now removed since comempci.c  
>> was the only user. What's the sttus of the eLIA platform?
>
> Only ever a handful where made, and that was in 1999.
> I doubt anyone could ever use the PCI interface on it
> in any useful way.

So I can send a patch to remove the platform?

>> But COMEMPCI fails with a different error - this init/main.o build 
>> error is present for CONFIG_PCI=y, CONFIG_COMEMPCI=n, so the dependency 
>> of PCI on BROKEN is still required (unless it gets fixed).
>
> Unless I am mistaken there is now no need for the CONFIG_PCI option
> if selecting m68knommu. The only m68knommu platforms that had PCI
> as far as I know where those that use the comempci part.

That implies I can also kill the m68k PCI code since m68knommu will 
never use it?

> The patch looks ok to me too (acked below).

Thanks.

> Regards
> Greg
>...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

