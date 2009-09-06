Return-Path: <linux-kernel-owner+w=401wt.eu-S1754845AbZIFIOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbZIFIOQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 04:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754787AbZIFIOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 04:14:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:42032 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741AbZIFIOH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 04:14:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=XL14YaL4og88Y6903duG+haD/9RqGZpXIQ9SuFcZh4B4//LeTjoDIq5pyiRh+2vkb7
         w11SokYH1WBhHd6uZ49tmdm48/G/safMMEbPVYa8VbAcxv4pH942e4bES70KRXZQ8rZQ
         CY0C6Pb8F3uN9b0T7ZphiQsNNFVd9z4p8X1Fw=
MIME-Version: 1.0
In-Reply-To: <200909060941.01810.elendil@planet.nl>
References: <200909060941.01810.elendil@planet.nl>
Date: Sun, 6 Sep 2009 11:14:07 +0300
X-Google-Sender-Auth: 57deef31dbee78a2
Message-ID: <84144f020909060114s74de2d2y850745dd82ece753@mail.gmail.com>
Subject: Re: iwlagn: order 2 page allocation failures
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net, Mel Gorman <mel@csn.ul.ie>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 6, 2009 at 10:40 AM, Frans Pop<elendil@planet.nl> wrote:
> Got a couple of page allocation failures today while viewing fairly
> large images. System was struggling for a bit to reorganize memory
> and swap, but nothing really serious. Everything recovered fairly
> quickly.
>
> Anything to look into?
>
> System: HP 2510p; 2.6.31-rc7-56-g7c0a57d; Debian stable, KDE desktop
>
> 10:00.0 Network controller [0280]: Intel Corporation PRO/Wireless 4965 AG or AGN
>           [Kedron] Network Connection [8086:4229] (rev 61)

Can you post your .config, please?

> kernel: swapper: page allocation failure. order:2, mode:0x4020
> kernel: Pid: 0, comm: swapper Not tainted 2.6.31-rc7 #15
> kernel: Call Trace:
> kernel:  <IRQ>  [<ffffffff8107909a>] __alloc_pages_nodemask+0x542/0x58a
> kernel:  [<ffffffff811d8a29>] ? skb_queue_tail+0x41/0x4a
> kernel:  [<ffffffff812568c2>] ? _spin_unlock+0x9/0xb
> kernel:  [<ffffffff811da2e1>] ? __alloc_skb+0x3c/0x15b
> kernel:  [<ffffffffa0356644>] ? iwl_rx_allocate+0xac/0x208 [iwlcore]
> kernel:  [<ffffffff8107913d>] __get_free_pages+0x12/0x41
> kernel:  [<ffffffff810982b1>] __kmalloc_track_caller+0x3b/0xec
> kernel:  [<ffffffff811da30b>] __alloc_skb+0x66/0x15b
> kernel:  [<ffffffffa0356644>] iwl_rx_allocate+0xac/0x208 [iwlcore]
> kernel:  [<ffffffffa03567b6>] iwl_rx_replenish_now+0x16/0x23 [iwlcore]
> kernel:  [<ffffffffa037d8e3>] iwl_rx_handle+0x356/0x39a [iwlagn]
> kernel:  [<ffffffffa00212a2>] ? scsi_io_completion+0x3a8/0x3d1 [scsi_mod]
> kernel:  [<ffffffffa037de27>] iwl_irq_tasklet_legacy+0x500/0x74f [iwlagn]
> kernel:  [<ffffffff8103dff0>] tasklet_action+0x71/0xbc
> kernel:  [<ffffffff8103e877>] __do_softirq+0x9b/0x12c
> kernel:  [<ffffffff8100cb7c>] call_softirq+0x1c/0x28
> kernel:  [<ffffffff8100e694>] do_softirq+0x34/0x72
> kernel:  [<ffffffff8103e601>] irq_exit+0x3f/0x79
> kernel:  [<ffffffff8100dd95>] do_IRQ+0xa3/0xba
> kernel:  [<ffffffff8100c413>] ret_from_intr+0x0/0xa
> kernel:  <EOI>  [<ffffffffa0262720>] ? acpi_idle_enter_simple+0x101/0x12f [processor]
> kernel:  [<ffffffffa0262716>] ? acpi_idle_enter_simple+0xf7/0x12f [processor]
> kernel:  [<ffffffff811cd6d8>] ? cpuidle_idle_call+0x8c/0xc4
> kernel:  [<ffffffff8100ae0f>] ? cpu_idle+0x52/0x93
> kernel:  [<ffffffff81245f4d>] ? rest_init+0x61/0x63
> kernel:  [<ffffffff81411c3f>] ? start_kernel+0x348/0x353
> kernel:  [<ffffffff8141129a>] ? x86_64_start_reservations+0xaa/0xae
> kernel:  [<ffffffff8141137f>] ? x86_64_start_kernel+0xe1/0xe8
> kernel: Mem-Info:
> kernel: DMA per-cpu:
> kernel: CPU    0: hi:    0, btch:   1 usd:   0
> kernel: CPU    1: hi:    0, btch:   1 usd:   0
> kernel: DMA32 per-cpu:
> kernel: CPU    0: hi:  186, btch:  31 usd: 172
> kernel: CPU    1: hi:  186, btch:  31 usd:  86
> kernel: Active_anon:314043 active_file:2401 inactive_anon:105396
> kernel:  inactive_file:2026 unevictable:407 dirty:0 writeback:3949 unstable:0
> kernel:  free:10313 slab:10486 mapped:2860 pagetables:4100 bounce:0
> kernel: DMA free:7924kB min:40kB low:48kB high:60kB active_anon:2828kB inactive_anon:3296kB
>        active_file:736kB inactive_file:664kB unevictable:0kB present:15336kB pages_scanned:0
>        all_unreclaimable? no
> kernel: lowmem_reserve[]: 0 1976 1976 1976
> kernel: DMA32 free:33328kB min:5664kB low:7080kB high:8496kB active_anon:1253344kB inactive_anon:418288kB
>        active_file:8868kB inactive_file:7440kB unevictable:1628kB present:2023748kB pages_scanned:0
>        all_unreclaimable? no
> kernel: lowmem_reserve[]: 0 0 0 0
> kernel: DMA: 913*4kB 36*8kB 1*16kB 0*32kB 0*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 7924kB
> kernel: DMA32: 7198*4kB 501*8kB 1*16kB 0*32kB 0*64kB 0*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 33328kB
> kernel: 63958 total pagecache pages
> kernel: 59163 pages in swap cache
> kernel: Swap cache stats: add 310806, delete 251643, find 16810381/16825997
> kernel: Free swap  = 1534944kB
> kernel: Total swap = 2097144kB
> kernel: 518064 pages RAM
> kernel: 10324 pages reserved
> kernel: 78783 pages shared
> kernel: 442988 pages non-shared
> kernel: iwlagn 0000:10:00.0: Can not allocate SKB buffers
>
> kernel: swapper: page allocation failure. order:2, mode:0x4020
> kernel: Pid: 0, comm: swapper Not tainted 2.6.31-rc7 #15
> kernel: Call Trace:
> kernel:  <IRQ>  [<ffffffff8107909a>] __alloc_pages_nodemask+0x542/0x58a
> kernel:  [<ffffffff812545d1>] ? printk+0x67/0x6e
> kernel:  [<ffffffffa0356644>] ? iwl_rx_allocate+0xac/0x208 [iwlcore]
> kernel:  [<ffffffff8107913d>] __get_free_pages+0x12/0x41
> kernel:  [<ffffffff810982b1>] __kmalloc_track_caller+0x3b/0xec
> kernel:  [<ffffffff811da30b>] __alloc_skb+0x66/0x15b
> kernel:  [<ffffffffa0356644>] iwl_rx_allocate+0xac/0x208 [iwlcore]
> kernel:  [<ffffffffa03567b6>] iwl_rx_replenish_now+0x16/0x23 [iwlcore]
> kernel:  [<ffffffffa037d90e>] iwl_rx_handle+0x381/0x39a [iwlagn]
> kernel:  [<ffffffffa00212a2>] ? scsi_io_completion+0x3a8/0x3d1 [scsi_mod]
> kernel:  [<ffffffffa037de27>] iwl_irq_tasklet_legacy+0x500/0x74f [iwlagn]
> kernel:  [<ffffffff8103dff0>] tasklet_action+0x71/0xbc
> kernel:  [<ffffffff8103e877>] __do_softirq+0x9b/0x12c
> kernel:  [<ffffffff8100cb7c>] call_softirq+0x1c/0x28
> kernel:  [<ffffffff8100e694>] do_softirq+0x34/0x72
> kernel:  [<ffffffff8103e601>] irq_exit+0x3f/0x79
> kernel:  [<ffffffff8100dd95>] do_IRQ+0xa3/0xba
> kernel:  [<ffffffff8100c413>] ret_from_intr+0x0/0xa
> kernel:  <EOI>  [<ffffffffa0262720>] ? acpi_idle_enter_simple+0x101/0x12f [processor]
> kernel:  [<ffffffffa0262716>] ? acpi_idle_enter_simple+0xf7/0x12f [processor]
> kernel:  [<ffffffff811cd6d8>] ? cpuidle_idle_call+0x8c/0xc4
> kernel:  [<ffffffff8100ae0f>] ? cpu_idle+0x52/0x93
> kernel:  [<ffffffff81245f4d>] ? rest_init+0x61/0x63
> kernel:  [<ffffffff81411c3f>] ? start_kernel+0x348/0x353
> kernel:  [<ffffffff8141129a>] ? x86_64_start_reservations+0xaa/0xae
> kernel:  [<ffffffff8141137f>] ? x86_64_start_kernel+0xe1/0xe8
> kernel: Mem-Info:
> kernel: DMA per-cpu:
> kernel: CPU    0: hi:    0, btch:   1 usd:   0
> kernel: CPU    1: hi:    0, btch:   1 usd:   0
> kernel: DMA32 per-cpu:
> kernel: CPU    0: hi:  186, btch:  31 usd: 172
> kernel: CPU    1: hi:  186, btch:  31 usd:  86
> kernel: Active_anon:314043 active_file:2401 inactive_anon:105396
> kernel:  inactive_file:2026 unevictable:407 dirty:0 writeback:3949 unstable:0
> kernel:  free:10313 slab:10486 mapped:2860 pagetables:4100 bounce:0
> kernel: DMA free:7924kB min:40kB low:48kB high:60kB active_anon:2828kB inactive_anon:3296kB
>        active_file:736kB inactive_file:664kB unevictable:0kB present:15336kB pages_scanned:0
>        all_unreclaimable? no
> kernel: lowmem_reserve[]: 0 1976 1976 1976
> kernel: DMA32 free:33328kB min:5664kB low:7080kB high:8496kB active_anon:1253344kB inactive_anon:418288kB
>        active_file:8868kB inactive_file:7440kB unevictable:1628kB present:2023748kB pages_scanned:0
>        all_unreclaimable? no
> kernel: lowmem_reserve[]: 0 0 0 0
> kernel: DMA: 913*4kB 36*8kB 1*16kB 0*32kB 0*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 7924kB
> kernel: DMA32: 7198*4kB 501*8kB 1*16kB 0*32kB 0*64kB 0*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 33328kB
> kernel: 63958 total pagecache pages
> kernel: 59163 pages in swap cache
> kernel: Swap cache stats: add 310806, delete 251643, find 16810381/16825997
> kernel: Free swap  = 1534944kB
> kernel: Total swap = 2097144kB
> kernel: 518064 pages RAM
> kernel: 10324 pages reserved
> kernel: 78783 pages shared
> kernel: 442988 pages non-shared
> kernel: iwlagn 0000:10:00.0: Can not allocate SKB buffers
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
