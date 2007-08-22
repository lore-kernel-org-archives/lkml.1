Return-Path: <linux-kernel-owner+w=401wt.eu-S934394AbXHVWYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934394AbXHVWYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 18:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932662AbXHVWYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 18:24:39 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:37723 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489AbXHVWYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 18:24:37 -0400
Message-ID: <46CCB79E.7070109@linux.vnet.ibm.com>
Date: Thu, 23 Aug 2007 03:54:30 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux-ia64@vger.kernel.org
Subject: Re: [BUG] 2.6.23-rc3-mm1 Kernel panic - not syncing: DMA: Memory
 would be corrupted
References: <46CC48FD.4000607@linux.vnet.ibm.com> <20070822091959.aa38fd3e.akpm@linux-foundation.org> <20070822172541.GA8058@bingen.suse.de> <46CC811C.9010600@linux.vnet.ibm.com> <617E1C2C70743745A92448908E030B2A023B2D39@scsmsx411.amr.corp.intel.com>
In-Reply-To: <617E1C2C70743745A92448908E030B2A023B2D39@scsmsx411.amr.corp.intel.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Luck, Tony wrote:
>> Attached the boot log and config file.
>>     
>
> Kamelesh,
>
> I don't see anything obvious in the boot_log.
>
> I used your "dotconfig" file to build a 2.6.23-rc3-mm1 kernel
> and booted it on my test system ... it worked just fine
> (except that for some reason the network did not come up :-( )
>
> I tried to compare my boot log with yours ... you have some
> different devices (E.g. your ethernet links are Tigon3 while
> mine are e1000) ... so the memory leak in a driver theory
> is a possibility.
>
> Try adding a dump_stack() call to lib/swiotlb.c where the
> "DMA: Out of SW-IOMMU space ..." message is printed.  That
> would tell us who is making the call that fails (they
> might be an innocent bystander after someone else has
> used all the space ... but this is unlikely).
>
> -Ton
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   
stack dump after the message "DMA: Out of SW-IOMMU space ...."


[ 20.865382] DMA: Out of SW-IOMMU space for 263200 bytes at device ?
[ 20.871946]
[ 20.871947] Call Trace:
[ 20.876287] [<a0000001000144e0>] show_stack+0x80/0xa0
[ 20.876289] sp=e00000014322f8f0 bsp=e000000143229170
[ 20.889731] [<a000000100014530>] dump_stack+0x30/0x60
[ 20.889733] sp=e00000014322fac0 bsp=e000000143229158
[ 20.903201] [<a0000001003aaa50>] swiotlb_full+0x50/0x120
[ 20.903202] sp=e00000014322fac0 bsp=e000000143229120
[ 20.916902] [<a0000001003aac40>] swiotlb_map_single+0x120/0x1c0
[ 20.916904] sp=e00000014322fac0 bsp=e0000001432290d8
[ 20.931215] [<a0000001003ab630>] swiotlb_alloc_coherent+0x150/0x240
[ 20.931217] sp=e00000014322fac0 bsp=e000000143229090
[ 20.945923] [<a000000100550860>] PrimeIocFifos+0x4c0/0xb20
[ 20.945925] sp=e00000014322fac0 bsp=e000000143229010
[ 20.959812] [<a000000100556a80>] mpt_do_ioc_recovery+0xd60/0x28e0
[ 20.959814] sp=e00000014322faf0 bsp=e000000143228f30
[ 20.974310] [<a00000010055c8f0>] mpt_attach+0x830/0x20e0
[ 20.974311] sp=e00000014322fdc0 bsp=e000000143228eb0
[ 20.988021] [<a0000001005667b0>] mptspi_probe+0x30/0x720
[ 20.988023] sp=e00000014322fdd0 bsp=e000000143228e60
[ 21.001743] [<a0000001003bb4b0>] pci_device_probe+0x1f0/0x2c0
[ 21.001745] sp=e00000014322fdd0 bsp=e000000143228e18
[ 21.015911] [<a00000010048f9e0>] driver_probe_device+0x180/0x400
[ 21.015913] sp=e00000014322fdd0 bsp=e000000143228dc8
[ 21.030305] [<a00000010048ff20>] __driver_attach+0xc0/0x160
[ 21.030307] sp=e00000014322fdd0 bsp=e000000143228d90
[ 21.044268] [<a00000010048dd90>] bus_for_each_dev+0xb0/0x120
[ 21.044269] sp=e00000014322fdd0 bsp=e000000143228d58
[ 21.058316] [<a00000010048f640>] driver_attach+0x40/0x60
[ 21.058318] sp=e00000014322fdf0 bsp=e000000143228d38
[ 21.072024] [<a00000010048e600>] bus_add_driver+0x120/0x400
[ 21.072026] sp=e00000014322fdf0 bsp=e000000143228cf8
[ 21.085989] [<a0000001004903c0>] driver_register+0xc0/0x180
[ 21.085990] sp=e00000014322fdf0 bsp=e000000143228cd8
[ 21.099952] [<a0000001003bb980>] __pci_register_driver+0xc0/0x140
[ 21.099953] sp=e00000014322fdf0 bsp=e000000143228ca0
[ 21.114467] [<a000000100943920>] mptspi_init+0x180/0x1c0
[ 21.114469] sp=e00000014322fe00 bsp=e000000143228c70
[ 21.130036] [<a0000001008fc5d0>] kernel_init+0x350/0x840
[ 21.130038] sp=e00000014322fe00 bsp=e000000143228c10
[ 21.143737] [<a000000100012150>] kernel_thread_helper+0xd0/0x100
[ 21.143739] sp=e00000014322fe30 bsp=e000000143228be0
[ 21.158141] [<a000000100008dc0>] start_kernel_thread+0x20/0x40
[ 21.158143] sp=e00000014322fe30 bsp=e000000143228be0
[ 21.172360] Kernel panic - not syncing: DMA: Memory would be corrupted

Thanks & Regards,
Kamalesh Babulal
