Return-Path: <linux-kernel-owner+w=401wt.eu-S1760703AbXK1LzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760703AbXK1LzH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 06:55:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756379AbXK1Lyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 06:54:53 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40529 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751467AbXK1Lyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 06:54:51 -0500
Date: Wed, 28 Nov 2007 03:49:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [BUG] 2.6.24-rc3-git3 oom-killer invoked
Message-Id: <20071128034906.6093448d.akpm@linux-foundation.org>
In-Reply-To: <474D4DB8.4000104@linux.vnet.ibm.com>
References: <474D4DB8.4000104@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007 16:45:04 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Hi,
> 
> oom-killer gets invoked while running ltprunall on AMD Opteron box
> 
> sleep invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0
> Pid: 23477, comm: sleep Not tainted 2.6.24-rc3-git3-autokern1 #1
> 
> Call Trace:
>  [<ffffffff8026ac6b>] oom_kill_process+0x4f/0xf5
>  [<ffffffff8026b147>] out_of_memory+0x1bc/0x22d
>  [<ffffffff8026db44>] __alloc_pages+0x282/0x313
>  [<ffffffff804e4a5c>] __wait_on_bit_lock+0x5b/0x66
>  [<ffffffff8026f684>] __do_page_cache_readahead+0x7c/0x18f
>  [<ffffffff8026a353>] filemap_fault+0x15d/0x317
>  [<ffffffff80274d06>] __do_fault+0x68/0x3bb
>  [<ffffffff804e5cb1>] _spin_unlock_irq+0x9/0xc
>  [<ffffffff8027690a>] handle_mm_fault+0x325/0x694
>  [<ffffffff804e78c1>] do_page_fault+0x3c5/0x764
>  [<ffffffff8024c5b9>] hrtimer_try_to_cancel+0x5f/0x68
>  [<ffffffff8024c5ce>] hrtimer_cancel+0xc/0x16
>  [<ffffffff804e4e43>] do_nanosleep+0x4e/0x77
>  [<ffffffff8024c73f>] hrtimer_nanosleep+0x58/0xf8
>  [<ffffffff8024c301>] hrtimer_wakeup+0x0/0x21
>  [<ffffffff804e5e59>] error_exit+0x0/0x51
> 
> Mem-info:
> Node 0 DMA per-cpu:
> CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
> CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
> CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
> CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
> Node 0 DMA32 per-cpu:
> CPU    0: Hot: hi:  186, btch:  31 usd:  40   Cold: hi:   62, btch:  15 usd:  50
> CPU    1: Hot: hi:  186, btch:  31 usd:  24   Cold: hi:   62, btch:  15 usd:  24
> CPU    2: Hot: hi:  186, btch:  31 usd:   3   Cold: hi:   62, btch:  15 usd:  21
> CPU    3: Hot: hi:  186, btch:  31 usd: 163   Cold: hi:   62, btch:  15 usd:  45
> Active:122323 inactive:122411 dirty:0 writeback:1 unstable:0
>  free:1979 slab:2772 mapped:10 pagetables:2062 bounce:0
> Node 0 DMA free:3988kB min:28kB low:32kB high:40kB active:2056kB inactive:2108kB present:7656kB pages_scanned:7201 all_unreclaimable? yes
> lowmem_reserve[]: 0 992 992 992
> Node 0 DMA32 free:4228kB min:4012kB low:5012kB high:6016kB active:489852kB inactive:485192kB present:1015864kB pages_scanned:70920 all_unreclaimable? no
> lowmem_reserve[]: 0 0 0 0
> Node 0 DMA: 3*4kB 5*8kB 2*16kB 0*32kB 1*64kB 2*128kB 2*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3988kB
> Node 0 DMA32: 117*4kB 16*8kB 5*16kB 1*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 4228kB
> Swap cache: add 815346, delete 815330, find 474/677, race 0+0
> Free swap  = 0kB
> Total swap = 2031640kB
> Free swap:            0kB
> 262093 pages of RAM
> 6955 reserved pages
> 288 pages shared
> 40 pages swap cached
> Out of memory: kill process 23475 (mem01) score 46734 or a child
> Killed process 23475 (mem01)
> 

It ran out of swapspace and killed the piggy process.  There's no bug here.

Unless there's a memory leak.  Check to see how much memory is free after
everything has been killed off.

