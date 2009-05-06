Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbZEFEn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbZEFEn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 00:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbZEFEnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 00:43:19 -0400
Received: from [192.16.179.4] ([192.16.179.4]:36568 "EHLO sh.osrg.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbZEFEnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 00:43:17 -0400
Date: Wed, 6 May 2009 13:39:57 +0900
To: optimusgd@gmail.com
Cc: aradford@gmail.com, grundler@google.com, fujita.tomonori@lab.ntt.co.jp,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Subject: Re: [Bug #13001] PCI-DMA: Out of IOMMU space
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <db2b43030905042246j770578e0xeb8d8ce8c01853d6@mail.gmail.com>
References: <da824cf30905041858t2cbd0fa2x4075f387973e2700@mail.gmail.com>
	<b1bc6a000905042131t3656f14arc98dc4a518543a86@mail.gmail.com>
	<db2b43030905042246j770578e0xeb8d8ce8c01853d6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090506134045Y.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 06 May 2009 13:39:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 May 2009 10:46:16 +0500
**UNKNOWN CHARSET** <optimusgd@gmail.com> wrote:

> Full dmesg there: http://bugzilla.kernel.org/attachment.cgi?id=21222
> Got this:
> ------------[ cut here ]------------
> WARNING: at fs/namei.c:1251 lookup_one_len+0xe9/0x100()
> Hardware name: HP xw9400 Workstation
> Modules linked in: fuse nfs auth_rpcgss lockd sunrpc scsi_wait_scan
> usbhid ohci_hcd usb_storage usb_libusual ehci_hcd usbcore
> Pid: 2717, comm: mount Not tainted 2.6.30-rc4-git1 #1
> Call Trace:
>  [<ffffffff8023ceca>] ? warn_slowpath+0xea/0x160
>  [<ffffffff80564d06>] ? printk+0x4e/0x58
>  [<ffffffff8032daea>] ? prepare_error_buf+0x51a/0x610
>  [<ffffffff802a0cfe>] ? new_slab+0x1ee/0x330
>  [<ffffffff8032dcc1>] ? reiserfs_info+0x71/0xa0
>  [<ffffffff802b3df9>] ? lookup_one_len+0xe9/0x100
>  [<ffffffff8033eaed>] ? reiserfs_xattr_init+0x3d/0xb0
>  [<ffffffff8032c4e3>] ? reiserfs_fill_super+0x663/0xb50
>  [<ffffffff805678f2>] ? __down_write_nested+0xb2/0xc0
>  [<ffffffff802a39e5>] ? kmem_cache_alloc+0x65/0xa0
>  [<ffffffff802acb22>] ? sget+0x3c2/0x410
>  [<ffffffff802ace94>] ? get_sb_bdev+0x174/0x1a0
>  [<ffffffff8032be80>] ? reiserfs_fill_super+0x0/0xb50
>  [<ffffffff802ab926>] ? vfs_kern_mount+0x56/0xd0
>  [<ffffffff802aba03>] ? do_kern_mount+0x53/0x120
>  [<ffffffff802c474a>] ? do_mount+0x2ba/0x8c0
>  [<ffffffff805691c8>] ? bad_gs+0xc34/0x1e0c
>  [<ffffffff802c4e1d>] ? sys_mount+0xcd/0x100
>  [<ffffffff8020b4eb>] ? system_call_fastpath+0x16/0x1b
> ---[ end trace 93edef2de057a0ed ]---

I think that this is a known issue.


> ------------[ cut here ]------------
> WARNING: at lib/dma-debug.c:625 check_unmap+0x3b3/0x610()
> Hardware name: HP xw9400 Workstation
> forcedeth 0000:00:09.0: DMA-API: device driver frees DMA memory with
> wrong function [device address=0x0000000023780c02] [size=42 bytes]
> [mapped as single] [unmapped as page]
> Modules linked in: nfsd exportfs iptable_filter iptable_mangle
> ip_tables x_tables snd_seq snd_seq_device vboxnetflt vboxdrv
> snd_hda_codec_realtek snd_hda_intel snd_hda_codec nvidia(P) snd_pcm
> snd_timer snd firewire_ohci firewire_core soundcore snd_page_alloc
> tpm_infineon tpm forcedeth floppy tpm_bios fuse nfs auth_rpcgss lockd
> sunrpc scsi_wait_scan usbhid ohci_hcd usb_storage usb_libusual
> ehci_hcd usbcore
> Pid: 0, comm: swapper Tainted: P        W  2.6.30-rc4-git1 #1
> Call Trace:
>  <IRQ>  [<ffffffff8023ceca>] ? warn_slowpath+0xea/0x160
>  [<ffffffff80231ad7>] ? task_rq_lock+0x47/0x90
>  [<ffffffff8029b287>] ? dma_pool_alloc+0x1b7/0x2d0
>  [<ffffffffa0059692>] ? ohci_urb_enqueue+0x1a2/0x980 [ohci_hcd]
>  [<ffffffff80231a63>] ? __wake_up+0x43/0x70
>  [<ffffffff802343f4>] ? find_busiest_group+0x244/0x920
>  [<ffffffffa00073b7>] ? usb_hcd_submit_urb+0x117/0xa40 [usbcore]
>  [<ffffffff803f0bb3>] ? check_unmap+0x3b3/0x610
>  [<ffffffff803f0e58>] ? debug_dma_unmap_page+0x48/0x50
>  [<ffffffffa014e639>] ? nv_tx_done_optimized+0xd9/0x2c0 [forcedeth]
>  [<ffffffffa0151346>] ? nv_napi_poll+0x76/0x630 [forcedeth]
>  [<ffffffff80256a1b>] ? hrtimer_get_next_event+0xdb/0xf0
>  [<ffffffff804dcc47>] ? net_rx_action+0x87/0x130
>  [<ffffffff802421fb>] ? __do_softirq+0x7b/0x110
>  [<ffffffff8020c56c>] ? call_softirq+0x1c/0x30
>  [<ffffffff8020e315>] ? do_softirq+0x35/0x80
>  [<ffffffff80242055>] ? irq_exit+0x95/0xa0
>  [<ffffffff8020db05>] ? do_IRQ+0x85/0xf0
>  [<ffffffff8020be13>] ? ret_from_intr+0x0/0xa
>  <EOI>  [<ffffffff80213182>] ? default_idle+0x42/0x50
>  [<ffffffff802131c4>] ? c1e_idle+0x34/0x100
>  [<ffffffff80258279>] ? __atomic_notifier_call_chain+0x19/0x50
>  [<ffffffff8020a09a>] ? cpu_idle+0x5a/0xc0
> ---[ end trace 93edef2de057a0ee ]---

Can you submit a bug report to netdev@vger.kernel.org? Well, I think
that the driver just uses pci_unmap_page for the areas mapped via
pci_map_single. That's not nice but causes no harm.
