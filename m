Return-Path: <linux-kernel-owner+w=401wt.eu-S1762303AbXHAIOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762303AbXHAIOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 04:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbXHAIO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 04:14:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56381 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757217AbXHAIO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 04:14:26 -0400
Date: Wed, 1 Aug 2007 01:13:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       gregkh@suse.de, linuxppc-dev@ozlabs.org, paulus@samba.org
Subject: Re: 2.6.23-rc1-mm2
Message-Id: <20070801011323.6e8d8259.akpm@linux-foundation.org>
In-Reply-To: <200708011002.30962.m.kozlowski@tuxland.pl>
References: <20070731230932.a9459617.akpm@linux-foundation.org>
	<200708011002.30962.m.kozlowski@tuxland.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2007 10:02:30 +0200 Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> Hello,
> 
> 	I get this warning. Looking at the comment in kernel/irq/resend.c
> it's harmless. Is it?
> 
> WARNING: at kernel/irq/resend.c:69 check_irq_resend()
>  [<c010456a>] show_trace_log_lvl+0x1a/0x30
>  [<c010508d>] show_trace+0x12/0x14
>  [<c01051e0>] dump_stack+0x15/0x17
>  [<c013b001>] check_irq_resend+0x91/0xa0
>  [<c013ab58>] enable_irq+0xb1/0xb3
>  [<c02d7b81>] ide_config_drive_speed+0xda/0x269
>  [<c02d391c>] ali15x3_tune_chipset+0xcc/0x161
>  [<c02dd367>] ide_tune_dma+0x43/0x4d
>  [<c02d29e0>] ali15x3_config_drive_for_dma+0xf/0x2a
>  [<c02dc89a>] ide_set_dma+0x11/0x40
>  [<c02d41cf>] set_using_dma+0x84/0xd1
>  [<c02d4dfe>] generic_ide_ioctl+0xb9/0x3fb
>  [<c02df7e4>] idedisk_ioctl+0x3f/0x10c
>  [<c023d779>] blkdev_driver_ioctl+0x55/0x5e
>  [<c023da3e>] blkdev_ioctl+0x2bc/0x83e
>  [<c017e5ca>] block_ioctl+0x1b/0x21
>  [<c01664c2>] do_ioctl+0x22/0x71
>  [<c0166566>] vfs_ioctl+0x55/0x28a
>  [<c01667ce>] sys_ioctl+0x33/0x51
>  [<c0103f32>] sysenter_past_esp+0x5f/0x85
>  =======================

Ingo debug stuff.

> Then reattaching a usb mouse caused this (only once)
> 
> usb 2-1: USB disconnect, address 2
> BUG: atomic counter underflow at:
>  [<c010456a>] show_trace_log_lvl+0x1a/0x30
>  [<c010508d>] show_trace+0x12/0x14
>  [<c01051e0>] dump_stack+0x15/0x17
>  [<c01418cf>] __free_pages+0x50/0x52
>  [<c01418f0>] free_pages+0x1f/0x21
>  [<c010783d>] dma_free_coherent+0x43/0x9c
>  [<c0315067>] hcd_buffer_free+0x43/0x6a
>  [<c030b2b4>] usb_buffer_free+0x23/0x29
>  [<c0346db4>] hid_free_buffers+0x23/0x71
>  [<c0346eb2>] hid_disconnect+0xb0/0xc8
>  [<c0313676>] usb_unbind_interface+0x30/0x72
>  [<c02c6df0>] __device_release_driver+0x6a/0x92
>  [<c02c71c3>] device_release_driver+0x20/0x36
>  [<c02c6736>] bus_remove_device+0x62/0x85
>  [<c02c49f8>] device_del+0x16d/0x27c
>  [<c0310f25>] usb_disable_device+0x7a/0xe2
>  [<c030d0bc>] usb_disconnect+0x94/0xde
>  [<c030e030>] hub_thread+0x2fe/0xc1b
>  [<c0128aee>] kthread+0x36/0x58
>  [<c0104233>] kernel_thread_helper+0x7/0x14
>  =======================
> uhci_hcd 0000:00:0c.0: dma_pool_free buffer-32, 6b6b6b6b/6b6b6b6b (bad dma)

whoa. huuuuuuuuuuge USB bug!

> Every new try shows:
> 
> usb 2-1: new low speed USB device using uhci_hcd and address 3
> usb 2-1: new device found, idVendor=046d, idProduct=c00e
> usb 2-1: new device strings: Mfr=1, Product=2, SerialNumber=0
> usb 2-1: Product: USB-PS/2 Optical Mouse
> usb 2-1: Manufacturer: Logitech
> usb 2-1: configuration #1 chosen from 1 choice
> input: Logitech USB-PS/2 Optical Mouse as /class/input/input9
> input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:0c.0-1
> usb 2-1: USB disconnect, address 3
> uhci_hcd 0000:00:0c.0: dma_pool_free buffer-32, 6b6b6b6b/6b6b6b6b (bad dma)
> 
> But mouse works ok.
> 

ok..

> 
> Second issue as reported earilier allmodconfig fails to build on imac g3.
> 
>   CC      arch/powerpc/kernel/lparmap.s
>   AS      arch/powerpc/kernel/head_64.o
> lparmap.c: Assembler messages:
> lparmap.c:84: Error: file number 1 already allocated
> make[1]: *** [arch/powerpc/kernel/head_64.o] Blad 1
> make: *** [arch/powerpc/kernel] Blad 2

hm, someone is working that, I think?
