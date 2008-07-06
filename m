Return-Path: <linux-kernel-owner+w=401wt.eu-S1759957AbYGFVDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759957AbYGFVDZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 17:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757556AbYGFVDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 17:03:14 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:47136 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756685AbYGFVDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 17:03:12 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Alan Cox <alan@redhat.com>
Subject: Re: pata_it821x completely broken
Date: Sun, 6 Jul 2008 23:03:03 +0200
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
References: <200807042153.56644.linux@rainbow-software.org> <200807051242.00545.linux@rainbow-software.org> <20080705154951.GC20937@devserv.devel.redhat.com>
In-Reply-To: <20080705154951.GC20937@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807062303.05994.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 July 2008 17:49:51 Alan Cox wrote:
> On Sat, Jul 05, 2008 at 12:41:58PM +0200, Ondrej Zary wrote:
> > Samsungs). Seems like any drive that can't do UDMA fails (looks like
> > MWDMA is broken). The controller BIOS creates the array fine but it
> > doesn't work in
>
> I've no idea if the BIOS firmware mode can do MWDMA to the drives. The
> actual interface between the card and the kernel has no mode stuff at all.
>
> > When I force the pass-through mode, it oopses (haven't captured it yet as
> > it's > too long). Forcing pass-through mode works fine with UDMA-capable
> > drives:
>
> Interesting and definitely sounds like a bug.

Did some testing with older drives (and netconsole), everything in 
pass-through mode. Looks like the controller firmware does not like some of 
them (<1GB ones).

IBM H3256-A3 - firmware hangs (BIOS displays that the firmware is not ready)
Maxtor 7120AT - firmware hangs

WD Caviar 2850 - firmware does not detect it but works in Linux
WD Caviar 1425 - firmware does not detect it but works in Linux


WD Caviar 1270 - firmware does not detect it and fails in Linux - detected as 
8860MB instead of 270MB and is unreadable:

scsi 3:0:1:0: Direct-Access     ATA      WDC AC1270G ! !  12/0 PQ: 0 ANSI: 5
sd 3:0:1:0: [sdd] 17305408 512-byte hardware sectors (8860 MB)
sd 3:0:1:0: [sdd] Write Protect is off
sd 3:0:1:0: [sdd] Write cache: disabled, read cache: enabled, doesn't support 
DPO or FUA
sd 3:0:1:0: [sdd] 17305408 512-byte hardware sectors (8860 MB)
sd 3:0:1:0: [sdd] Write Protect is off
sd 3:0:1:0: [sdd] Write cache: disabled, read cache: enabled, doesn't support 
DPO or FUA
 sdd:<3>ata4.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata4.01: BMDMA stat 0x4
ata4.01: cmd c8/00:08:00:00:00/00:00:00:00:00/f0 tag 0 dma 4096 in
         res 59/04:08:00:00:00/00:00:00:00:00/f0 Emask 0x2 (HSM violation)
ata4.01: status: { DRDY DRQ ERR }
ata4.01: error: { ABRT }
ata4: soft resetting link
ata4.00: configured for UDMA/100
ata4.01: configured for MWDMA1 (device error ignored)
ata4: EH complete
ata4.01: limiting speed to MWDMA0:PIO3
ata4.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata4.01: BMDMA stat 0x4
ata4.01: cmd c8/00:08:00:00:00/00:00:00:00:00/f0 tag 0 dma 4096 in
         res 59/04:08:00:00:00/00:00:00:00:00/f0 Emask 0x2 (HSM violation)
ata4.01: status: { DRDY DRQ ERR }
ata4.01: error: { ABRT }
ata4: soft resetting link
ata4.00: configured for UDMA/100
ata4.01: configured for MWDMA0 (device error ignored)
ata4: EH complete
sd 3:0:0:0: [sdc] 781422768 512-byte hardware sectors (400088 MB)
ata4.01: limiting speed to PIO3
ata4.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata4.01: BMDMA stat 0x4
ata4.01: cmd c8/00:08:00:00:00/00:00:00:00:00/f0 tag 0 dma 4096 in
         res 59/04:08:00:00:00/00:00:00:00:00/f0 Emask 0x2 (HSM violation)
ata4.01: status: { DRDY DRQ ERR }
ata4.01: error: { ABRT }
ata4: soft resetting link
ata4.00: configured for UDMA/100
ata4.01: configured for PIO3
ata4: EH complete
sd 3:0:0:0: [sdc] Write Protect is off
ata4.01: limiting speed to PIO2
ata4.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata4.01: cmd 20/00:08:00:00:00/00:00:00:00:00/f0 tag 0 pio 4096 in
         res 51/04:08:00:00:00/00:00:00:00:00/f0 Emask 0x1 (device error)
ata4.01: status: { DRDY ERR }
ata4.01: error: { ABRT }
ata4: soft resetting link
ata4.00: configured for UDMA/100
ata4.01: configured for PIO2
ata4: EH complete
ata4.01: limiting speed to PIO0
ata4.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata4.01: cmd 20/00:08:00:00:00/00:00:00:00:00/f0 tag 0 pio 4096 in
         res 51/04:08:00:00:00/00:00:00:00:00/f0 Emask 0x1 (device error)
ata4.01: status: { DRDY ERR }
ata4.01: error: { ABRT }
ata4: soft resetting link
ata4.00: configured for UDMA/100
ata4.01: configured for PIO0
ata4: EH complete
sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
ata4.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata4.01: cmd 20/00:08:00:00:00/00:00:00:00:00/f0 tag 0 pio 4096 in
         res 51/04:08:00:00:00/00:00:00:00:00/f0 Emask 0x1 (device error)
ata4.01: status: { DRDY ERR }
ata4.01: error: { ABRT }
ata4.00: configured for UDMA/100
ata4.01: configured for PIO0
sd 3:0:1:0: [sdd] Result: hostbyte=0x00 driverbyte=0x08
sd 3:0:1:0: [sdd] Sense Key : 0xb [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
        00 00 00 00
sd 3:0:1:0: [sdd] ASC=0x0 ASCQ=0x0

...




Maxtor 7270 AV - is detected by firmware but oopses in Linux:

pata_it821x: forcing bypass mode.
pata_it821x: controller in pass through mode.
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:12.0[A] -> Link [LNKC] -> GSI 11 (level, low) -> 
IRQ 11
irq 11: nobody cared (try booting with the "irqpoll" option)
Pid: 1, comm: swapper Not tainted 2.6.25.3-pentium #5
 [<c012f48f>] __report_bad_irq+0x24/0x69
 [<c012f496>] __report_bad_irq+0x2b/0x69
 [<c012f680>] note_interrupt+0x1ac/0x1e4
 [<c012ee21>] handle_IRQ_event+0x1a/0x3f
 [<c012fcda>] handle_level_irq+0x0/0x8a
 [<c012fd27>] handle_level_irq+0x4d/0x8a
 [<c01051bb>] do_IRQ+0x78/0x9e
 [<c0103c53>] common_interrupt+0x23/0x30
 [<c013007b>] init_irq_proc+0x6/0x27
 [<c0115f59>] __do_softirq+0x2f/0x75
 [<c0105111>] do_softirq+0x3b/0x6d
 [<c012fcda>] handle_level_irq+0x0/0x8a
 [<c0115efc>] irq_exit+0x25/0x53
 [<c01051ce>] do_IRQ+0x8b/0x9e
 [<c0103c53>] common_interrupt+0x23/0x30
 [<c012f214>] setup_irq+0x11f/0x149
 [<c0120060>] cpu_clock_sample_group_locked+0x2/0xd3
 [<c023ce84>] ata_interrupt+0x0/0x1cc
 [<c012f2b5>] request_irq+0x77/0x93
 [<c023ce84>] ata_interrupt+0x0/0x1cc
 [<c012fe0c>] devm_request_irq+0x42/0x6e
 [<c02403a6>] ata_pci_activate_sff_host+0xb4/0x19f
 [<c023ce84>] ata_interrupt+0x0/0x1cc
 [<c0240850>] ata_pci_init_one+0x8c/0xd5
 [<c02475b5>] it821x_init_one+0x87/0x8c
 [<c01c632b>] pci_device_probe+0x36/0x55
 [<c021f6ce>] driver_probe_device+0x9c/0x112
 [<c021f824>] __driver_attach+0x50/0x83
 [<c021ed53>] bus_for_each_dev+0x31/0x52
 [<c021f582>] driver_attach+0x11/0x13
 [<c021f7d4>] __driver_attach+0x0/0x83
 [<c021f3c2>] bus_add_driver+0x91/0x193
 [<c021f9bd>] driver_register+0x45/0x9a
 [<c01c64bf>] __pci_register_driver+0x2b/0x58
 [<c0397600>] kernel_init+0x92/0x1d0
 [<c010fe52>] schedule_tail+0xe/0x39
 [<c01038a6>] ret_from_fork+0x6/0x20
 [<c039756e>] kernel_init+0x0/0x1d0
 [<c039756e>] kernel_init+0x0/0x1d0
 [<c0103d77>] kernel_thread_helper+0x7/0x10
 =======================
handlers:
[<c023ce84>] (ata_interrupt+0x0/0x1cc)
Disabling IRQ #11
scsi2 : pata_it821x
scsi3 : pata_it821x
ata3: PATA max UDMA/133 cmd 0x6800 ctl 0x6c00 bmdma 0x7800 irq 11
ata4: PATA max UDMA/133 cmd 0x7000 ctl 0x7400 bmdma 0x7808 irq 11



>
> > Then I created RAID 1 from the Seagate and Quantum drives. No matter if
> > the rebuild process is running or not, the result is the same - the
> > drives that form RAID aren't accessible, the other drives work:
>
> I would imagine the controller fakes a hotplug event when the rebuild
> finishes but that is guessing. The firmware mode is pretty minimally
> documented.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Ondrej Zary
