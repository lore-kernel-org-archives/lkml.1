Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbZFCNj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbZFCNj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 09:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbZFCNjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 09:39:51 -0400
Received: from mail-ew0-f162.google.com ([209.85.219.162]:44637 "EHLO
	mail-ew0-f162.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbZFCNju convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 09:39:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cONu5E+A6OBROWI98JrbrL9pHeA4aN+6EQbJghUp6H8g+OfbZR12j+7YKC9AT7qcMV
         imKF79VqglsmRrZJ9R/mLk15hua2RTpXoc37CXHr0bnoM1tVXcFLl1gcJWckefeVSu9Y
         XD12r74KnCa/t5A4Euwey/aM2+dA7F1R8F0+E=
MIME-Version: 1.0
In-Reply-To: <20090603140140.491a8ea8@lxorguk.ukuu.org.uk>
References: <c5bd819b0906021525l13ee9282j1fb270e141985f66@mail.gmail.com>
	 <4A25F688.9000407@gmail.com>
	 <c5bd819b0906030435w466368cbsd48be91a97597437@mail.gmail.com>
	 <20090603131407.57c490ed@lxorguk.ukuu.org.uk>
	 <c5bd819b0906030552w6f23185etb394f83c8b630e6@mail.gmail.com>
	 <20090603140140.491a8ea8@lxorguk.ukuu.org.uk>
Date: Wed, 3 Jun 2009 15:39:48 +0200
Message-ID: <c5bd819b0906030639o5f9c34ffg500e132d3a0b5117@mail.gmail.com>
Subject: Re: Kernel 2.6.30rc7 limits IDE to UDMA33
From: Grozdan <neutrino8@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: hancockrwd@gmail.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/3 Alan Cox <alan@lxorguk.ukuu.org.uk>:
> What about 2.6.28 or 2.6.29 ?
>

Hi,

I just installed kernel 2.6.29.4-rt16-2-rt from the SUSE build service
(there's no 2.6.28 one available nor a 'normal' 2.6.29 one) and my
UDMA is set correctly just as when using the default 2.6.27.21 kernel.
Now I'm not sure if there really is a problem in 2.6.30-rc7-git4 or
did I somehow introduced it by configuring something incorrectly
(which I doubt because as I said, I didn't touch anything related to
IDE during configuration. I only tweaked a few options, most of them
in the General and Processor sections). However, this
2.6.29.4-rt16-2-rt kernel seems to have a bug (not sure if it's
present in mainline too or because of the patches Novell used to build
this rt kernel) in rtmutex as I get things such as...

BUG: sleeping function called from invalid context at
/usr/src/packages/BUILD/kernel-rt-2.6.29.4/linux-2.6.29/kernel/rtmutex.c:685
in_atomic(): 1, irqs_disabled(): 1, pid: 17, name: work_on_cpu/0
Pid: 17, comm: work_on_cpu/0 Not tainted 2.6.29.4-rt16-2-rt #1
Call Trace:
[<ffffffff80227b4a>] dump_trace+0xda/0x3d0
[<ffffffff802288ff>] show_trace_log_lvl+0x4c/0x58
[<ffffffff8022891b>] show_trace+0x10/0x12
[<ffffffff804ee605>] dump_stack+0x72/0x7b
[<ffffffff80252635>] __might_sleep+0x10a/0x10c
[<ffffffff804f0af7>] rt_spin_lock+0x2f/0x78
[<ffffffff802ee5b1>] _slab_irq_disable+0x40/0x63
[<ffffffff802f0495>] kmem_cache_alloc_node+0x3a/0x21b
[<ffffffff802a9621>] irq_to_desc_alloc_cpu+0xb7/0x20e
[<ffffffff8023d47a>] io_apic_set_pci_routing+0x63/0xbe
[<ffffffff80238555>] mp_register_gsi+0xc1/0xcc
[<ffffffff802385cc>] acpi_register_gsi+0x3f/0x4b
[<ffffffff803fb41b>] acpi_pci_irq_enable+0x145/0x233
[<ffffffff8045c4bb>] pcibios_enable_device+0x29/0x2e
[<ffffffff803ae1b7>] do_pci_enable_device+0x28/0x40
[<ffffffff803ae224>] __pci_enable_device_flags+0x55/0x70
[<ffffffff803ae24d>] pci_enable_device+0xe/0x10
[<ffffffffa0116292>] usb_hcd_pci_probe+0x42/0x2a0 [usbcore]
[<ffffffff803afc7b>] local_pci_probe+0x12/0x16
[<ffffffff80273224>] do_work_for_cpu+0x13/0x1b
[<ffffffff80273429>] run_workqueue+0x110/0x1b0
[<ffffffff802735a9>] worker_thread+0xe0/0xf1
[<ffffffff80277028>] kthread+0x49/0x76
[<ffffffff80225f9a>] child_rip+0xa/0x20


---------- dmesg IDE of 2.6.29.4-rt16-2-rt----------------

pata_via 0000:00:0f.0: PCI INT A -> Link[ALKA] -> GSI 20 (level, low) -> IRQ 20
scsi0 : pata_via
scsi1 : pata_via
ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xdc00 irq 14
ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xdc08 irq 15
ata1.00: ATA-7: Maxtor 6Y080L0, YAR41BW0, max UDMA/133
ata1.00: 160086528 sectors, multi 16: LBA
ata1.01: ATA-5: ST340016A, 3.10, max UDMA/100
ata1.01: 78165360 sectors, multi 16: LBA
ata1.00: configured for UDMA/133
ata1.01: configured for UDMA/100
isa bounce pool size: 16 pages
scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6Y080L0   YAR4 PQ: 0 ANSI: 5
scsi 0:0:1:0: Direct-Access     ATA      ST340016A        3.10 PQ: 0 ANSI: 5
ata2.00: ATAPI: TSSTcorpCD/DVDW TS-H552U, US08, max UDMA/33
ata2.00: configured for UDMA/33
scsi 1:0:0:0: CD-ROM            TSSTcorp CD/DVDW TS-H552U US08 PQ: 0 ANSI: 5
BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
udevd version 128 started
Driver 'sd' needs updating - please use bus_type methods
sd 0:0:0:0: [sda] 160086528 512-byte hardware sectors: (81.9 GB/76.3 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 0:0:0:0: [sda] 160086528 512-byte hardware sectors: (81.9 GB/76.3 GiB)
