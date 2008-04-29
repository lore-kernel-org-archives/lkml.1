Return-Path: <linux-kernel-owner+w=401wt.eu-S1761574AbYD2UXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761574AbYD2UXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760187AbYD2UXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:23:19 -0400
Received: from brick.kernel.dk ([87.55.233.238]:28169 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759390AbYD2UXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:23:18 -0400
Date: Tue, 29 Apr 2008 22:23:10 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: queue_flag_clear warnings with the latest git tree
Message-ID: <20080429202310.GJ12774@kernel.dk>
References: <200804292107.09770.bzolnier@gmail.com> <20080429192358.GA12774@kernel.dk> <200804292157.28169.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804292157.28169.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29 2008, Bartlomiej Zolnierkiewicz wrote:
> On Tuesday 29 April 2008, Jens Axboe wrote:
> > On Tue, Apr 29 2008, Bartlomiej Zolnierkiewicz wrote:
> > > 
> > > They happen both with IDE and SCSI/libata...
> > > 
> > > IDE:
> > > 
> > > Linux version 2.6.25-06476-gc9a3f6d-dirty (bzolnier@localhost.localdomain) (gcc version 4.1.2 20070925 (Red Hat 4.1.2-27)) #225 PREEMPT Tue Apr 29 20:53:53 CEST 2008
> > > BIOS-provided physical RAM map:
> > >  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
> > >  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
> > >  BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
> > >  BIOS-e820: 0000000000100000 - 0000000007ff0000 (usable)
> > >  BIOS-e820: 0000000007ff0000 - 0000000008000000 (ACPI data)
> > >  BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
> > > 127MB LOWMEM available.
> > > Zone PFN ranges:
> > >   DMA             0 ->     4096
> > >   Normal       4096 ->    32752
> > > Movable zone start PFN for each node
> > > early_node_map[1] active PFN ranges
> > >     0:        0 ->    32752
> > > DMI not present or invalid.
> > > ACPI: RSDP 000FA5D0, 0014 (r0 QEMU  )
> > > ACPI: RSDT 07FF0000, 002C (r0 QEMU   QEMURSDT        1 QEMU        1)
> > > ACPI: FACP 07FF002C, 0074 (r0 QEMU   QEMUFACP        1 QEMU        1)
> > > ACPI: DSDT 07FF0100, 0832 (r1   BXPC   BXDSDT        1 INTL 20060912)
> > > ACPI: FACS 07FF00C0, 0040
> > > ACPI: APIC 07FF0938, 0040 (r0 QEMU   QEMUAPIC        1 QEMU        1)
> > > ACPI: PM-Timer IO Port: 0xb008
> > > ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> > > BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
> > > ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
> > > IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23
> > > Enabling APIC mode:  Flat.  Using 1 I/O APICs
> > > Using ACPI (MADT) for SMP configuration information
> > > Allocating PCI resources starting at 10000000 (gap: 08000000:f7fc0000)
> > > Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32497
> > > Kernel command line: root=/dev/hda init=/bin/sh  console=ttyS0,115200
> > > Enabling fast FPU save and restore... done.
> > > Enabling unmasked SIMD FPU exception support... done.
> > > Initializing CPU#0
> > > CPU 0 irqstacks, hard=c03e1000 soft=c03e0000
> > > PID hash table entries: 512 (order: 9, 2048 bytes)
> > > Detected 1495.172 MHz processor.
> > > Console: colour VGA+ 80x25
> > > console [ttyS0] enabled
> > > Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
> > > Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
> > > Memory: 126096k/131008k available (1912k kernel code, 4432k reserved, 832k data, 180k init, 0k highmem)
> > > virtual kernel memory layout:
> > >     fixmap  : 0xfffb5000 - 0xfffff000   ( 296 kB)
> > >     vmalloc : 0xc8800000 - 0xfffb3000   ( 887 MB)
> > >     lowmem  : 0xc0000000 - 0xc7ff0000   ( 127 MB)
> > >       .init : 0xc03b0000 - 0xc03dd000   ( 180 kB)
> > >       .data : 0xc02de117 - 0xc03ae1e0   ( 832 kB)
> > >       .text : 0xc0100000 - 0xc02de117   (1912 kB)
> > > Checking if this processor honours the WP bit even in supervisor mode...Ok.
> > > Calibrating delay using timer specific routine.. 3012.98 BogoMIPS (lpj=6025962)
> > > Mount-cache hash table entries: 512
> > > CPU: L1 I cache: 8K
> > > CPU: L2 cache: 128K
> > > Compat vDSO mapped to ffffe000.
> > > CPU: Intel Pentium II (Klamath) stepping 03
> > > Checking 'hlt' instruction... OK.
> > > Freeing SMP alternatives: 0k freed
> > > ACPI: Core revision 20070126
> > > ENABLING IO-APIC IRQs
> > > ..TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
> > > APIC calibration not consistent with PM Timer: 52ms instead of 100ms
> > > APIC delta adjusted to PM-Timer: 6250026 (3292476)
> > > net_namespace: 480 bytes
> > > NET: Registered protocol family 16
> > > No dock devices found.
> > > ACPI: bus type pci registered
> > > PCI: PCI BIOS revision 2.10 entry at 0xfa110, last bus=0
> > > PCI: Using configuration type 1 for base access
> > > Setting up standard PCI resources
> > > ACPI: Interpreter enabled
> > > ACPI: (supports S0 S5)
> > > ACPI: Using IOAPIC for interrupt routing
> > > ACPI: PCI Root Bridge [PCI0] (0000:00)
> > > * Found PM-Timer Bug on the chipset. Due to workarounds for a bug,
> > > * this clock source is slow. Consider trying other clock sources
> > > pci 0000:00:01.3: quirk: region b000-b03f claimed by PIIX4 ACPI
> > > pci 0000:00:01.3: quirk: region b100-b10f claimed by PIIX4 SMB
> > > ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12)
> > > ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *9 10 11 12)
> > > ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11 12)
> > > ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *9 10 11 12)
> > > Linux Plug and Play Support v0.97 (c) Adam Belay
> > > pnp: PnP ACPI init
> > > ACPI: bus type pnp registered
> > > pnp: PnP ACPI: found 6 devices
> > > ACPI: ACPI bus type pnp unregistered
> > > SCSI subsystem initialized
> > > usbcore: registered new interface driver usbfs
> > > usbcore: registered new interface driver hub
> > > usbcore: registered new device driver usb
> > > PCI: Using ACPI for IRQ routing
> > > NET: Registered protocol family 2
> > > IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
> > > TCP established hash table entries: 4096 (order: 3, 32768 bytes)
> > > TCP bind hash table entries: 4096 (order: 2, 16384 bytes)
> > > TCP: Hash tables configured (established 4096 bind 4096)
> > > TCP reno registered
> > > NET: Registered protocol family 1
> > > audit: initializing netlink socket (disabled)
> > > type=2000 audit(1209495511.389:1): initialized
> > > Total HugeTLB memory allocated, 0
> > > fuse init (API version 7.9)
> > > msgmni has been set to 246 for ipc namespace c0394260
> > > io scheduler noop registered
> > > io scheduler anticipatory registered (default)
> > > io scheduler deadline registered
> > > io scheduler cfq registered
> > > pci 0000:00:00.0: Limiting direct PCI/PCI transfers
> > > pci 0000:00:01.0: PIIX3: Enabling Passive Release
> > > pci 0000:00:01.0: Activating ISA DMA hang workarounds
> > > isapnp: Scanning for PnP cards...
> > > isapnp: No Plug & Play device found
> > > Real Time Clock Driver v1.12ac
> > > Linux agpgart interface v0.103
> > > Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
> > > Switched to NOHz mode on CPU #0
> > > ?serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16450
> > > 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16450
> > > Uniform Multi-Platform E-IDE driver
> > > PIIX3: IDE controller (0x8086:0x7010 rev 0x00) at  PCI slot 0000:00:01.1
> > > PIIX3: not 100% native mode: will probe irqs later
> > >     ide0: BM-DMA at 0xc000-0xc007
> > >     ide1: BM-DMA at 0xc008-0xc00f
> > > hda: QEMU HARDDISK, ATA DISK drive
> > > Clocksource tsc unstable (delta = -713139329 ns)
> > > hda: MWDMA2 mode selected
> > > hdc: QEMU CD-ROM, ATAPI CD/DVD-ROM drive
> > > hdc: MWDMA2 mode selected
> > > ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> > > ide1 at 0x170-0x177,0x376 on irq 15
> > > ide_generic: I/O resource 0x1F0-0x1F7 not free.
> > > ide_generic: I/O resource 0x170-0x177 not free.
> > > hda: max request size: 512KiB
> > > hda: 102400 sectors (52 MB) w/256KiB Cache, CHS=101/255/63
> > > hda: cache flushes supported
> > >  hda:<4>------------[ cut here ]------------
> > > WARNING: at include/linux/blkdev.h:439 queue_flag_clear+0x1e/0x3e()
> > > Modules linked in:
> > > Pid: 1, comm: swapper Not tainted 2.6.25-06476-gc9a3f6d-dirty #225
> > >  [<c011a21e>] warn_on_slowpath+0x40/0x67
> > >  [<c01b6ce3>] elv_rb_add+0x47/0x4f
> > >  [<c01bda3e>] as_add_request+0x92/0xbe
> > >  [<c01b6b8a>] elv_insert+0x11a/0x142
> > >  [<c01b8b30>] __make_request+0x24e/0x292
> > >  [<c01b8b53>] __make_request+0x271/0x292
> > >  [<c01b7cb0>] generic_make_request+0x163/0x190
> > 
> > Hmm, I'm guessing UP and spin_is_locked() doesn't work there? I was
> > pretty sure that was 'fixed' years ago. I lieu of a better fix,
> > something like this should suffice.
> > 
> > diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> > index 669b65c..9e2e23b 100644
> > --- a/include/linux/blkdev.h
> > +++ b/include/linux/blkdev.h
> > @@ -418,8 +418,12 @@ struct request_queue
> >  
> >  static inline int queue_is_locked(struct request_queue *q)
> >  {
> > +#ifdef CONFIG_SMP
> >  	spinlock_t *lock = q->queue_lock;
> >  	return lock && spin_is_locked(lock);
> > +#else
> > +	return 1;
> > +#endif
> >  }
> >  
> >  static inline void queue_flag_set_unlocked(unsigned int flag,
> 
> Yeah, all warnings are gone.

Goodie, thanks for the report :)

-- 
Jens Axboe

