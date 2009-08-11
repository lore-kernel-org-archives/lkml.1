Return-Path: <linux-kernel-owner+w=401wt.eu-S1752886AbZHKNVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbZHKNVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 09:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbZHKNVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 09:21:10 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:55599 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbZHKNVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 09:21:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=WRyHqBwXTuz5UFr1+RXhWFbLd7l2VJtGEHQNFKe1D8r9MQ3skRlMWN4IhVR2z9DDpR
         E+ZaJxWaIZylkQ0XiyGG3dzE01v32cqAGoI5dKA3yjKSSr8TvNnywA6yP3R8qYr/YCLY
         ngzWbLOxjz6lA+O3VetdQ4O3/2SdUxY/jtyB0=
MIME-Version: 1.0
Date: Tue, 11 Aug 2009 15:21:08 +0200
Message-ID: <c4e36d110908110621o75ff063ex6d42570ce635a243@mail.gmail.com>
Subject: 8139cp WARNING: at lib/dma-debug.c:803 check_unmap+0x41a/0x650()
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: jgarzik@pobox.com, davem@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I'm getting this warning message from my kvm machine (created with
this network card -net nic,model=rtl8139)

WARNING: at lib/dma-debug.c:803 check_unmap+0x41a/0x650()

Hardware name:

8139cp 0000:00:03.0: DMA-API: device driver frees DMA memory with
different size [device address=0x000000001ebda0b2] [map size=1536
bytes] [unmap size=1538 bytes]

Modules linked in: dm_crypt crypto_blkcipher crypto_algapi loop
virtio_balloon uhci_hcd ehci_hcd dm_mod psmouse i2c_piix4 8139cp evdev
virtio_pci virtio_ring serio_raw virtio mii i2c_core usbcore rtc_cmos
rtc_core rtc_lib floppy button

Pid: 0, comm: swapper Not tainted 2.6.31-rc5-00472-g3d32107 #4

Call Trace:

 <IRQ>  [<ffffffff8104c4fb>] warn_slowpath_common+0x7b/0xc0

 [<ffffffff8104c5a1>] warn_slowpath_fmt+0x41/0x50

 [<ffffffff811e881a>] check_unmap+0x41a/0x650

 [<ffffffff8107accc>] ? trace_hardirqs_on_caller+0x7c/0x1a0

 [<ffffffff811e8ca9>] debug_dma_unmap_page+0x59/0x60

 [<ffffffffa0096ce1>] cp_rx_poll+0x301/0x550 [8139cp]

 [<ffffffff812f9050>] net_rx_action+0x170/0x270

 [<ffffffff812f8fce>] ? net_rx_action+0xee/0x270

 [<ffffffff81052e7c>] __do_softirq+0xbc/0x200

 [<ffffffff8100d2dc>] call_softirq+0x1c/0x50

 [<ffffffff8100eb65>] do_softirq+0x75/0xb0

 [<ffffffff81052935>] irq_exit+0x95/0xa0

 [<ffffffff81386001>] smp_apic_timer_interrupt+0x71/0x9c

 [<ffffffff8100ccb3>] apic_timer_interrupt+0x13/0x20

 <EOI>  [<ffffffff81014513>] ? default_idle+0x53/0xe0

 [<ffffffff81014511>] ? default_idle+0x51/0xe0

 [<ffffffff8100ae80>] ? cpu_idle+0x70/0xc0

 [<ffffffff81379eea>] ? start_secondary+0x189/0x18e

---[ end trace d222049dbdb8d58c ]---

Mapped at:

 [<ffffffff811e98a6>] debug_dma_map_page+0x86/0x170

 [<ffffffffa00965d7>] cp_init_rings+0x167/0x230 [8139cp]

 [<ffffffffa009689d>] cp_open+0xdd/0x220 [8139cp]

 [<ffffffff812f81b1>] dev_open+0xa1/0x100

 [<ffffffff812f7fe6>] dev_change_flags+0x96/0x1c0

NET: Registered protocol family 10



Zdenek
