Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbXEQMwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbXEQMwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 08:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755490AbXEQMw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 08:52:29 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:29533 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbXEQMw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 08:52:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=L7aXME5W0ujlcfAFEiWKMpl8TLREcJBGBHDnXvd4JePmHFFaM2GmOBI+LS++PswMrOMuL7FQIy+YhOD50dE6mb/AFU94aCwvpFwymiIUfMVcCAQBVN6LKbwKy3pGESz8x/xVrUs66X9qwIbcQa+zXIscjw3zi8skftXiZtVqP5M=
Message-ID: <a781481a0705170552m19e2b560q13a3f40ec2e91c87@mail.gmail.com>
Date: Thu, 17 May 2007 18:22:24 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Reuben Farrelly" <reuben-linuxkernel@reub.net>
Subject: Re: 2.6.22-rc1-mm1 - Call trace in slub_def.h
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       clameter@sgi.com
In-Reply-To: <464C4CB8.8060906@reub.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070515201914.16944e04.akpm@linux-foundation.org>
	 <464C4CB8.8060906@reub.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/17/07, Reuben Farrelly <reuben-linuxkernel@reub.net> wrote:
> [...]
> I have just seen this on boot, with 2.6.22-rc2-mm1 on x86_64:
> [...]
> BUG: at include/linux/slub_def.h:88 kmalloc_index()
>
> Call Trace:
>   [<ffffffff8034f3f9>] pci_dev_put+0x12/0x14
>   [<ffffffff80283f30>] get_slab+0xb5/0x265
>   [<ffffffff802841bc>] __kmalloc+0x13/0xa3
>   [<ffffffff8021a4aa>] cache_k8_northbridges+0x80/0x116
>   [<ffffffff8063fed2>] gart_iommu_init+0x16/0x594
>   [<ffffffff804562ac>] genl_rcv+0x0/0x68
>   [<ffffffff804548ed>] netlink_kernel_create+0x15e/0x16b
>   [<ffffffff804acc52>] mutex_unlock+0x9/0xb
>   [<ffffffff80639fad>] pci_iommu_init+0x9/0x12
>   [<ffffffff806306af>] kernel_init+0x152/0x322
>   [<ffffffff80249c7c>] trace_hardirqs_on+0xc0/0x14e
>   [<ffffffff804ae03d>] trace_hardirqs_on_thunk+0x35/0x37
>   [<ffffffff80249c7c>] trace_hardirqs_on+0xc0/0x14e
>   [<ffffffff8020a848>] child_rip+0xa/0x12
>   [<ffffffff80209f5c>] restore_args+0x0/0x30
>   [<ffffffff8063055d>] kernel_init+0x0/0x322
>   [<ffffffff8020a83e>] child_rip+0x0/0x12
>
> PCI-GART: No AMD northbridge found.
> hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> hpet0: 3 64-bit timers, 14318180 Hz
> ACPI: RTC can wake from S4
> pnp: 00:01: iomem range 0xf0000000-0xf3ffffff has been reserved
> pnp: 00:01: iomem range 0xfed13000-0xfed13fff has been reserved

This ( http://lkml.org/lkml/2007/5/16/350 ) patch by Ben Collins
submitted yesterday should take care of this.

Thanks,
Satyam
