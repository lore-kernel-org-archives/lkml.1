Return-Path: <linux-kernel-owner+w=401wt.eu-S1762717AbXHVORW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762717AbXHVORW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 10:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758698AbXHVORM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 10:17:12 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:35431 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757744AbXHVORM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 10:17:12 -0400
Message-ID: <46CC4563.3030306@linux.vnet.ibm.com>
Date: Wed, 22 Aug 2007 19:47:07 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [BUG] 2.6.23-rc3-mm1 Kernel panic - not syncing: Can't create
 pid_1 cachep
References: <46CC3F94.4050609@linux.vnet.ibm.com>
In-Reply-To: <46CC3F94.4050609@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal wrote:
> Hi Andrew,
>
> Following Kernel panic is raised while booting up with 2.6.23-rc3-mm1 
> kernel.
>
> ============================================================
> Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> Initializing HighMem for node 0 (00038000:001fbe00)
> Initializing HighMem for node 1 (00200000:003fbe00)
> Initializing HighMem for node 2 (00400000:005fbe00)
> Initializing HighMem for node 3 (00600000:007fbe00)
> Memory: 32480436k/33554432k available (2146k kernel code, 278984k 
> reserved, 1203k data, 216k init, 31842304k highmem)
> virtual kernel memory layout:
>    fixmap  : 0xffe1a000 - 0xfffff000   (1940 kB)
>    pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
>    vmalloc : 0xf8800000 - 0xffbfe000   ( 115 MB)
>    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
>      .init : 0xc134c000 - 0xc1382000   ( 216 kB)
>      .data : 0xc12189e1 - 0xc1345758   (1203 kB)
>      .text : 0xc1000000 - 0xc12189e1   (2146 kB)
> Checking if this processor honours the WP bit even in supervisor 
> mode... Ok.
> SLUB: Genslabs=12, HWalign=32, Order=0-3, MinObjects=16, CPUs=16, 
> Nodes=16
> Calibrating delay using timer specific routine.. 1401.55 BogoMIPS 
> (lpj=2803105)
> Kernel panic - not syncing: Can't create pid_1 cachep
>
>
> Thanks & Regards,
> Kamalesh Babulal.
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
To add to the panic, it begin called by the __init pidmap_init
of kernel/pid.c:641
        init_pid_ns.pid_cachep = create_pid_cachep(1);
        if (init_pid_ns.pid_cachep == NULL)
                panic("Can't create pid_1 cachep\n");

Thanks & Regards
Kamalesh Babulal

