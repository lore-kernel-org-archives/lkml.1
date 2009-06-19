Return-Path: <linux-kernel-owner+w=401wt.eu-S1754427AbZFSPFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbZFSPFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 11:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbZFSPEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 11:04:52 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42646 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbZFSPEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 11:04:51 -0400
Date: Fri, 19 Jun 2009 17:04:42 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Niel Lambrechts <niel.lambrechts@gmail.com>
Cc: Tejun Heo <htejun@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux.kernel" <linux-kernel@vger.kernel.org>,
       Theodore Tso <tytso@mit.edu>
Subject: Re: 2.6.29 regression: ATA bus errors on resume
Message-ID: <20090619150051.GD1389@ucw.cz>
References: <4A1B8328.80801@kernel.org> <4A1B8873.1040101@gmail.com> <4A1BEFB6.80205@kernel.org> <4A1C316C.9040201@gmail.com> <4A1C8444.9040605@kernel.org> <4A1D47C6.1070504@gmail.com> <4A2424A2.5020704@gmail.com> <4A25EA78.7070705@kernel.org> <4A25FBD1.70000@gmail.com> <4A2A1521.5020407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2A1521.5020407@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-06-06 09:05:05, Niel Lambrechts wrote:
> Morning Tejun,
> 
> Tejun Heo wrote:
> > Hello,
> >
> > Can you please do the followings?
> >
> > 1. Apply the attached patch, build & boot
> >   
> I chose 2.6.30-rc7...
> > 2. Trigger the problem and record dmesg
> >   
> It took 3 days and quite a few hibernate attempts ... :-)
> 
> > 3. On failed IO, the kernel will print the address of bi_endio.  Run
> >    "nm -n" on the vmlinux in the kernel build root and look up which
> >    function it is and post the dmesg and function name.
> I did not have that specific vmlinux.o file any more, but
> /boot/System.map-2.6.30-rc7-pae shows:
> c01a49fd t end_bio_bh_io_sync
> 
> Hope this is sufficient to help you. Sorry if this is silly - being so
> inexperienced with the kernel - but I wondered if or why a dump_stack()
> in that debug patch would not be helpful?

I guess dump_stack would be very helpful :-).

> Regards,
> Niel
> 
> 

> Jun  5 09:26:12 linux-7vph -- MARK --
> Jun  5 09:26:12 linux-7vph syslog-ng[24615]: Log statistics; dropped='pipe(/dev/xconsole)=0', dropped='pipe(/dev/tty10)=0', processed='center(queued)=3777', processed='center(received)=3142', processed='destination(newsnotice)=0', processed='destination(acpid)=13', processed='destination(firewall)=18', processed='destination(null)=208', processed='destination(mail)=0', processed='destination(mailinfo)=0', processed='destination(console)=200', processed='destination(newserr)=0', processed='destination(newscrit)=0', processed='destination(messages)=1909', processed='destination(mailwarn)=0', processed='destination(localmessages)=0', processed='destination(netmgm)=994', processed='destination(mailerr)=0', processed='destination(xconsole)=200', processed='destination(warn)=235', processed='source(src)=3142'
> Jun  5 09:26:11 linux-7vph kernel: Syncing filesystems ... done.
> Jun  5 09:26:12 linux-7vph kernel: Freezing user space processes ... (elapsed 0.00 seconds) done.
> Jun  5 09:26:12 linux-7vph kernel: Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
> Jun  5 09:26:12 linux-7vph kernel: PM: Shrinking memory... done (149507 pages freed)
> Jun  5 09:26:12 linux-7vph kernel: PM: Freed 598028 kbytes in 6.49 seconds (92.14 MB/s)
> Jun  5 09:26:12 linux-7vph kernel: Suspending console(s) (use no_console_suspend to debug)
> Jun  5 09:26:12 linux-7vph kernel: sd 0:0:0:0: [sda] Synchronizing SCSI cache
> Jun  5 09:26:12 linux-7vph kernel: ACPI handle has no context!
> Jun  5 09:26:12 linux-7vph kernel: ehci_hcd 0000:00:1d.7: PCI INT D disabled
> Jun  5 09:26:12 linux-7vph kernel: ehci_hcd 0000:00:1d.7: PME# disabled
> Jun  5 09:26:12 linux-7vph kernel: uhci_hcd 0000:00:1d.2: PCI INT C disabled
> Jun  5 09:26:12 linux-7vph kernel: uhci_hcd 0000:00:1d.1: PCI INT B disabled
> Jun  5 09:26:12 linux-7vph kernel: uhci_hcd 0000:00:1d.0: PCI INT A disabled
> Jun  5 09:26:12 linux-7vph kernel: HDA Intel 0000:00:1b.0: PCI INT B disabled
> Jun  5 09:26:12 linux-7vph kernel: ehci_hcd 0000:00:1a.7: PCI INT D disabled
> Jun  5 09:26:12 linux-7vph kernel: ehci_hcd 0000:00:1a.7: PME# disabled
> Jun  5 09:26:12 linux-7vph kernel: uhci_hcd 0000:00:1a.2: PCI INT C disabled
> Jun  5 09:26:12 linux-7vph kernel: uhci_hcd 0000:00:1a.1: PCI INT B disabled
> Jun  5 09:26:12 linux-7vph kernel: uhci_hcd 0000:00:1a.0: PCI INT A disabled
> Jun  5 09:26:13 linux-7vph kernel: e1000e 0000:00:19.0: PCI INT A disabled
> Jun  5 09:26:13 linux-7vph kernel: e1000e 0000:00:19.0: PME# enabled
> Jun  5 09:26:13 linux-7vph kernel: e1000e 0000:00:19.0: wake-up capability enabled by ACPI
> Jun  5 09:26:13 linux-7vph kernel: ACPI: Preparing to enter system sleep state S4
> Jun  5 09:26:13 linux-7vph kernel: PM: Saving platform NVS memory
> Jun  5 09:26:13 linux-7vph kernel: Disabling non-boot CPUs ...
> Jun  5 09:26:13 linux-7vph kernel: CPU 1 is now offline
> Jun  5 09:26:13 linux-7vph kernel: SMP alternatives: switching to UP code
> Jun  5 09:26:13 linux-7vph kernel: CPU0 attaching NULL sched-domain.
> Jun  5 09:26:13 linux-7vph kernel: CPU1 attaching NULL sched-domain.
> Jun  5 09:26:13 linux-7vph kernel: CPU0 attaching NULL sched-domain.
> Jun  5 09:26:13 linux-7vph kernel: CPU1 is down
> Jun  5 09:26:13 linux-7vph kernel: Extended CMOS year: 2000
> Jun  5 09:26:13 linux-7vph kernel: PM: Creating hibernation image: 
> Jun  5 09:26:13 linux-7vph kernel: PM: Need to copy 223773 pages
> Jun  5 09:26:13 linux-7vph kernel: x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> Jun  5 09:26:13 linux-7vph kernel: Intel machine check architecture supported.
> Jun  5 09:26:13 linux-7vph kernel: Intel machine check reporting enabled on CPU#0.
> Jun  5 09:26:13 linux-7vph kernel: PM: Restoring platform NVS memory
> Jun  5 09:26:13 linux-7vph kernel: Extended CMOS year: 2000
> Jun  5 09:26:13 linux-7vph kernel: Enabling non-boot CPUs ...
> Jun  5 09:26:13 linux-7vph kernel: SMP alternatives: switching to SMP code
> Jun  5 09:26:13 linux-7vph kernel: Booting processor 1 APIC 0x1 ip 0x6000
> Jun  5 09:26:13 linux-7vph kernel: Initializing CPU#1
> Jun  5 09:26:13 linux-7vph kernel: Calibrating delay using timer specific routine.. 5134.67 BogoMIPS (lpj=10269343)
> Jun  5 09:26:13 linux-7vph kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
> Jun  5 09:26:13 linux-7vph kernel: CPU: L2 cache: 6144K
> Jun  5 09:26:13 linux-7vph kernel: CPU: Physical Processor ID: 0
> Jun  5 09:26:13 linux-7vph kernel: CPU: Processor Core ID: 1
> Jun  5 09:26:13 linux-7vph kernel: Intel machine check architecture supported.
> Jun  5 09:26:13 linux-7vph kernel: Intel machine check reporting enabled on CPU#1.
> Jun  5 09:26:13 linux-7vph kernel: x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
> Jun  5 09:26:13 linux-7vph kernel: CPU1: Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz stepping 06
> Jun  5 09:26:13 linux-7vph kernel: CPU0 attaching NULL sched-domain.
> Jun  5 09:26:13 linux-7vph kernel: Switched to high resolution mode on CPU 1
> Jun  5 09:26:13 linux-7vph kernel: CPU0 attaching sched-domain:
> Jun  5 09:26:13 linux-7vph kernel:  domain 0: span 0-1 level MC
> Jun  5 09:26:13 linux-7vph kernel:   groups: 0 1
> Jun  5 09:26:13 linux-7vph kernel:   domain 1: span 0-1 level CPU
> Jun  5 09:26:13 linux-7vph kernel:    groups: 0-1 (__cpu_power = 2048)
> Jun  5 09:26:13 linux-7vph kernel: CPU1 attaching sched-domain:
> Jun  5 09:26:13 linux-7vph kernel:  domain 0: span 0-1 level MC
> Jun  5 09:26:13 linux-7vph kernel:   groups: 1 0
> Jun  5 09:26:13 linux-7vph kernel:   domain 1: span 0-1 level CPU
> Jun  5 09:26:13 linux-7vph kernel:    groups: 0-1 (__cpu_power = 2048)
> Jun  5 09:26:13 linux-7vph kernel: microcode: failed to init CPU1
> Jun  5 09:26:13 linux-7vph kernel: CPU1 is up
> Jun  5 09:26:13 linux-7vph kernel: ACPI: Waking up from system sleep state S4
> Jun  5 09:26:13 linux-7vph kernel: pci 0000:00:02.0: restoring config space at offset 0x1 (was 0x900007, writing 0x900403)
> Jun  5 09:26:13 linux-7vph kernel: uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
> Jun  5 09:26:13 linux-7vph kernel: uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
> Jun  5 09:26:13 linux-7vph kernel: HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100106, writing 0x100102)
> Jun  5 09:26:13 linux-7vph kernel: uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
> Jun  5 09:26:13 linux-7vph kernel: ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00403, writing 0x2b00407)
> Jun  5 09:26:13 linux-7vph kernel: iwlagn 0000:03:00.0: restoring config space at offset 0x1 (was 0x100106, writing 0x100506)
> Jun  5 09:26:13 linux-7vph kernel: pci 0000:00:02.0: PME# disabled
> Jun  5 09:26:13 linux-7vph kernel: pci 0000:00:02.0: setting latency timer to 64
> Jun  5 09:26:13 linux-7vph kernel: pci 0000:00:02.1: PME# disabled
> Jun  5 09:26:13 linux-7vph kernel: pci 0000:00:03.0: PME# disabled
> Jun  5 09:26:13 linux-7vph kernel: e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> Jun  5 09:26:13 linux-7vph kernel: e1000e 0000:00:19.0: pci_enable_pcie_error_reporting failed 0xfffffffb
> Jun  5 09:26:13 linux-7vph kernel: e1000e 0000:00:19.0: setting latency timer to 64
> Jun  5 09:26:14 linux-7vph kernel: e1000e 0000:00:19.0: wake-up capability disabled by ACPI
> Jun  5 09:26:14 linux-7vph kernel: e1000e 0000:00:19.0: PME# disabled
> Jun  5 09:26:14 linux-7vph kernel: e1000e 0000:00:19.0: wake-up capability disabled by ACPI
> Jun  5 09:26:14 linux-7vph kernel: e1000e 0000:00:19.0: PME# disabled
> Jun  5 09:26:14 linux-7vph kernel: e1000e 0000:00:19.0: irq 29 for MSI/MSI-X
> Jun  5 09:26:14 linux-7vph kernel: uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> Jun  5 09:26:14 linux-7vph kernel: uhci_hcd 0000:00:1a.0: setting latency timer to 64
> Jun  5 09:26:14 linux-7vph kernel: uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
> Jun  5 09:26:14 linux-7vph kernel: uhci_hcd 0000:00:1a.1: setting latency timer to 64
> Jun  5 09:26:14 linux-7vph kernel: uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
> Jun  5 09:26:14 linux-7vph kernel: uhci_hcd 0000:00:1a.2: setting latency timer to 64
> Jun  5 09:26:14 linux-7vph kernel: ehci_hcd 0000:00:1a.7: PME# disabled
> Jun  5 09:26:14 linux-7vph kernel: ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
> Jun  5 09:26:14 linux-7vph kernel: ehci_hcd 0000:00:1a.7: setting latency timer to 64
> Jun  5 09:26:14 linux-7vph kernel: ehci_hcd 0000:00:1a.7: PME# disabled
> Jun  5 09:26:14 linux-7vph kernel: HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> Jun  5 09:26:14 linux-7vph kernel: HDA Intel 0000:00:1b.0: setting latency timer to 64
> Jun  5 09:26:14 linux-7vph kernel: uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> Jun  5 09:26:14 linux-7vph kernel: uhci_hcd 0000:00:1d.0: setting latency timer to 64
> Jun  5 09:26:14 linux-7vph kernel: uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> Jun  5 09:26:14 linux-7vph kernel: uhci_hcd 0000:00:1d.1: setting latency timer to 64
> Jun  5 09:26:14 linux-7vph kernel: uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> Jun  5 09:26:14 linux-7vph kernel: uhci_hcd 0000:00:1d.2: setting latency timer to 64
> Jun  5 09:26:14 linux-7vph kernel: ehci_hcd 0000:00:1d.7: PME# disabled
> Jun  5 09:26:14 linux-7vph kernel: ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
> Jun  5 09:26:14 linux-7vph kernel: ehci_hcd 0000:00:1d.7: setting latency timer to 64
> Jun  5 09:26:14 linux-7vph kernel: ehci_hcd 0000:00:1d.7: PME# disabled
> Jun  5 09:26:14 linux-7vph kernel: pci 0000:00:1e.0: setting latency timer to 64
> Jun  5 09:26:14 linux-7vph kernel: ahci 0000:00:1f.2: setting latency timer to 64
> Jun  5 09:26:14 linux-7vph kernel: pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> Jun  5 09:26:14 linux-7vph kernel: ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[f4801000-f48017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
> Jun  5 09:26:14 linux-7vph kernel: pci 0000:15:00.2: PME# disabled
> Jun  5 09:26:14 linux-7vph kernel: pci 0000:15:00.3: PME# disabled
> Jun  5 09:26:14 linux-7vph kernel: pci 0000:15:00.4: PME# disabled
> Jun  5 09:26:14 linux-7vph kernel: pci 0000:15:00.5: PME# disabled
> Jun  5 09:26:14 linux-7vph kernel: sd 0:0:0:0: [sda] Starting disk
> Jun  5 09:26:14 linux-7vph kernel: ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> Jun  5 09:26:14 linux-7vph kernel: ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> Jun  5 09:26:14 linux-7vph kernel: ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
> Jun  5 09:26:14 linux-7vph kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
> Jun  5 09:26:14 linux-7vph kernel: ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
> Jun  5 09:26:14 linux-7vph kernel: ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
> Jun  5 09:26:14 linux-7vph kernel: ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
> Jun  5 09:26:14 linux-7vph kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
> Jun  5 09:26:14 linux-7vph kernel: ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
> Jun  5 09:26:14 linux-7vph kernel: ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
> Jun  5 09:26:14 linux-7vph kernel: ata1.00: configured for UDMA/133
> Jun  5 09:26:14 linux-7vph kernel: ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
> Jun  5 09:26:14 linux-7vph kernel: ata1: irq_stat 0x00400040, connection status changed
> Jun  5 09:26:14 linux-7vph kernel: ata1.00: configured for UDMA/133
> Jun  5 09:26:14 linux-7vph kernel: ata1: EH complete
> Jun  5 09:26:14 linux-7vph kernel: pci 0000:00:02.0: restoring config space at offset 0x1 (was 0x900407, writing 0x900403)
> Jun  5 09:26:14 linux-7vph kernel: pci 0000:00:02.0: setting latency timer to 64
> Jun  5 09:26:14 linux-7vph kernel: ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
> Jun  5 09:26:14 linux-7vph kernel: ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
> Jun  5 09:26:14 linux-7vph kernel: ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
> Jun  5 09:26:14 linux-7vph kernel: ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
> Jun  5 09:26:14 linux-7vph kernel: ata2.00: configured for UDMA/133
> Jun  5 09:26:14 linux-7vph kernel: Restarting tasks ... <3>ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
> Jun  5 09:26:14 linux-7vph kernel: ata2: irq_stat 0x40000001
> Jun  5 09:26:14 linux-7vph kernel: ata1.00: exception Emask 0x10 SAct 0x1ff SErr 0x50000 action 0xe frozen
> Jun  5 09:26:14 linux-7vph kernel: ata1.00: irq_stat 0x00400008, PHY RDY changed
> Jun  5 09:26:14 linux-7vph kernel: ata1: SError: { PHYRdyChg CommWake }
> Jun  5 09:26:14 linux-7vph kernel: ata1.00: cmd 60/08:00:5f:06:44/00:00:0c:00:00/40 tag 0 ncq 4096 in
> Jun  5 09:26:14 linux-7vph kernel:          res 50/00:28:3f:8a:6f/00:00:0e:00:00/40 Emask 0x10 (ATA bus error)
> Jun  5 09:26:14 linux-7vph kernel: ata1.00: status: { DRDY }
> Jun  5 09:26:14 linux-7vph kernel: ata1.00: cmd 60/58:08:6f:06:44/00:00:0c:00:00/40 tag 1 ncq 45056 in
> Jun  5 09:26:14 linux-7vph kernel:          res 50/00:28:3f:8a:6f/00:00:0e:00:00/40 Emask 0x10 (ATA bus error)
> Jun  5 09:26:14 linux-7vph kernel: ata1.00: status: { DRDY }
> Jun  5 09:26:14 linux-7vph kernel: ata1.00: cmd 60/08:10:d7:06:44/00:00:0c:00:00/40 tag 2 ncq 4096 in
> Jun  5 09:26:14 linux-7vph kernel:          res 50/00:28:3f:8a:6f/00:00:0e:00:00/40 Emask 0x10 (ATA bus error)
> Jun  5 09:26:14 linux-7vph kernel: ata1.00: status: { DRDY }
> Jun  5 09:26:14 linux-7vph kernel: ata1.00: cmd 60/08:18:07:07:44/00:00:0c:00:00/40 tag 3 ncq 4096 in
> Jun  5 09:26:14 linux-7vph kernel:          res 50/00:28:3f:8a:6f/00:00:0e:00:00/40 Emask 0x10 (ATA bus error)
> Jun  5 09:26:14 linux-7vph kernel: ata1.00: status: { DRDY }
> Jun  5 09:26:14 linux-7vph kernel: ata1.00: cmd 60/18:20:17:07:44/00:00:0c:00:00/40 tag 4 ncq 12288 in
> Jun  5 09:26:14 linux-7vph kernel:          res 50/00:28:3f:8a:6f/00:00:0e:00:00/40 Emask 0x10 (ATA bus error)
> Jun  5 09:26:14 linux-7vph kernel: ata1.00: status: { DRDY }
> Jun  5 09:26:14 linux-7vph kernel: ata1.00: cmd 60/08:28:67:88:70/00:00:0e:00:00/40 tag 5 ncq 4096 in
> Jun  5 09:26:14 linux-7vph kernel:          res 50/00:28:3f:8a:6f/00:00:0e:00:00/40 Emask 0x10 (ATA bus error)
> Jun  5 09:26:14 linux-7vph kernel: ata1.00: status: { DRDY }
> Jun  5 09:26:14 linux-7vph kernel: ata1.00: cmd 60/08:30:17:70:14/00:00:0d:00:00/40 tag 6 ncq 4096 in
> Jun  5 09:26:14 linux-7vph kernel:          res 50/00:28:3f:8a:6f/00:00:0e:00:00/40 Emask 0x10 (ATA bus error)
> Jun  5 09:26:14 linux-7vph kernel: ata1.00: status: { DRDY }
> Jun  5 09:26:14 linux-7vph kernel: ata1.00: cmd 60/d8:38:5f:89:6f/00:00:0e:00:00/40 tag 7 ncq 110592 in
> Jun  5 09:26:15 linux-7vph kernel:          res 50/00:28:3f:8a:6f/00:00:0e:00:00/40 Emask 0x10 (ATA bus error)
> Jun  5 09:26:15 linux-7vph kernel: ata1.00: status: { DRDY }
> Jun  5 09:26:15 linux-7vph kernel: ata1.00: cmd 60/28:40:3f:8a:6f/00:00:0e:00:00/40 tag 8 ncq 20480 in
> Jun  5 09:26:15 linux-7vph kernel:          res 50/00:28:3f:8a:6f/00:00:0e:00:00/40 Emask 0x10 (ATA bus error)
> Jun  5 09:26:15 linux-7vph kernel: ata1.00: status: { DRDY }
> Jun  5 09:26:15 linux-7vph kernel: ata1: hard resetting link
> Jun  5 09:26:15 linux-7vph kernel: ata2.00: configured for UDMA/133
> Jun  5 09:26:15 linux-7vph kernel: ata2: EH complete
> Jun  5 09:26:15 linux-7vph kernel: done.
> Jun  5 09:26:15 linux-7vph kernel: ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> Jun  5 09:26:16 linux-7vph kernel: ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
> Jun  5 09:26:16 linux-7vph kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
> Jun  5 09:26:16 linux-7vph kernel: ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
> Jun  5 09:26:16 linux-7vph kernel: ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
> Jun  5 09:26:16 linux-7vph kernel: ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
> Jun  5 09:26:16 linux-7vph kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
> Jun  5 09:26:16 linux-7vph kernel: ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
> Jun  5 09:26:16 linux-7vph kernel: ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
> Jun  5 09:26:16 linux-7vph kernel: ata1.00: configured for UDMA/133
> Jun  5 09:26:16 linux-7vph kernel: ata1.00: configured for UDMA/133
> Jun  5 09:26:16 linux-7vph kernel: sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> Jun  5 09:26:16 linux-7vph kernel: sd 0:0:0:0: [sda] Sense Key : Aborted Command [current] [descriptor]
> Jun  5 09:26:16 linux-7vph kernel: Descriptor sense data with sense descriptors (in hex):
> Jun  5 09:26:16 linux-7vph kernel:         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
> Jun  5 09:26:16 linux-7vph kernel:         0e 6f 8a 3f 
> Jun  5 09:26:16 linux-7vph kernel: sd 0:0:0:0: [sda] Add. Sense: No additional sense information
> Jun  5 09:26:16 linux-7vph kernel: end_request: I/O error, dev sda, sector 242190687
> Jun  5 09:26:16 linux-7vph kernel: XXX sda: failing bio e1223140 with -5
> Jun  5 09:26:16 linux-7vph kernel: XXX sda: bio=e1223140 error=-5 bi_end_io=c01a49fd
> Jun  5 09:26:16 linux-7vph kernel: XXX sda: failing bio f5caa0c0 with -5
> Jun  5 09:26:16 linux-7vph kernel: XXX sda: bio=f5caa0c0 error=-5 bi_end_io=c01a49fd
> Jun  5 09:26:16 linux-7vph kernel: XXX sda: failing bio f5caa140 with -5
> Jun  5 09:26:16 linux-7vph kernel: XXX sda: bio=f5caa140 error=-5 bi_end_io=c01a49fd
> Jun  5 09:26:16 linux-7vph kernel: XXX sda: failing bio f5caa1c0 with -5
> Jun  5 09:26:16 linux-7vph kernel: XXX sda: bio=f5caa1c0 error=-5 bi_end_io=c01a49fd
> Jun  5 09:26:16 linux-7vph kernel: XXX sda: failing bio f5caa240 with -5
> Jun  5 09:26:16 linux-7vph kernel: XXX sda: bio=f5caa240 error=-5 bi_end_io=c01a49fd
> Jun  5 09:26:16 linux-7vph kernel: XXX sda: failing bio f5caa2c0 with -5
> Jun  5 09:26:16 linux-7vph kernel: XXX sda: bio=f5caa2c0 error=-5 bi_end_io=c01a49fd
> Jun  5 09:26:16 linux-7vph kernel: XXX sda: failing bio f5caa340 with -5
> Jun  5 09:26:16 linux-7vph kernel: XXX sda: bio=f5caa340 error=-5 bi_end_io=c01a49fd
> Jun  5 09:26:16 linux-7vph kernel: XXX sda: failing bio f5caa3c0 with -5
> Jun  5 09:26:16 linux-7vph kernel: XXX sda: bio=f5caa3c0 error=-5 bi_end_io=c01a49fd
> Jun  5 09:26:16 linux-7vph kernel: XXX sda: failing bio f5caa440 with -5
> Jun  5 09:26:16 linux-7vph kernel: XXX sda: bio=f5caa440 error=-5 bi_end_io=c01a49fd
> Jun  5 09:26:16 linux-7vph kernel: XXX sda: failing bio f5caa4c0 with -5
> Jun  5 09:26:16 linux-7vph kernel: XXX sda: bio=f5caa4c0 error=-5 bi_end_io=c01a49fd
> Jun  5 09:26:16 linux-7vph kernel: XXX sda: failing bio f5caa540 with -5
> Jun  5 09:26:16 linux-7vph kernel: XXX sda: bio=f5caa540 error=-5 bi_end_io=c01a49fd
> Jun  5 09:26:16 linux-7vph kernel: XXX sda: failing bio f5caa5c0 with -5
> Jun  5 09:26:19 linux-7vph kernel: XXX sda: bio=f5caa5c0 error=-5 bi_end_io=c01a49fd
> Jun  5 09:26:19 linux-7vph kernel: XXX sda: failing bio f5caa640 with -5
> Jun  5 09:26:19 linux-7vph kernel: XXX sda: bio=f5caa640 error=-5 bi_end_io=c01a49fd
> Jun  5 09:26:19 linux-7vph kernel: XXX sda: failing bio f5caa6c0 with -5
> Jun  5 09:26:19 linux-7vph kernel: XXX sda: bio=f5caa6c0 error=-5 bi_end_io=c01a49fd
> Jun  5 09:26:19 linux-7vph kernel: XXX sda: failing bio f5caa740 with -5
> Jun  5 09:26:19 linux-7vph kernel: XXX sda: bio=f5caa740 error=-5 bi_end_io=c01a49fd
> Jun  5 09:26:19 linux-7vph kernel: XXX sda: failing bio f5caa7c0 with -5
> Jun  5 09:26:19 linux-7vph kernel: XXX sda: bio=f5caa7c0 error=-5 bi_end_io=c01a49fd
> Jun  5 09:26:19 linux-7vph kernel: XXX sda: failing bio f5caa840 with -5
> Jun  5 09:26:21 linux-7vph kernel: XXX sda: bio=f5caa840 error=-5 bi_end_io=c01a49fd
> Jun  5 09:26:21 linux-7vph kernel: XXX sda: failing bio f5caa8c0 with -5
> Jun  5 09:26:21 linux-7vph kernel: XXX sda: bio=f5caa8c0 error=-5 bi_end_io=c01a49fd
> Jun  5 09:26:21 linux-7vph kernel: XXX sda: failing bio f5caa940 with -5
> Jun  5 09:26:21 linux-7vph kernel: XXX sda: bio=f5caa940 error=-5 bi_end_io=c01a49fd
> Jun  5 09:26:21 linux-7vph kernel: XXX sda: failing bio f5caa9c0 with -5
> Jun  5 09:26:21 linux-7vph kernel: XXX sda: bio=f5caa9c0 error=-5 bi_end_io=c01a49fd
> Jun  5 09:26:21 linux-7vph kernel: XXX sda: failing bio f5caaa40 with -5
> Jun  5 09:26:21 linux-7vph kernel: XXX sda: bio=f5caaa40 error=-5 bi_end_io=c01a49fd
> Jun  5 09:26:21 linux-7vph kernel: XXX sda: failing bio f5caaac0 with -5
> Jun  5 09:26:22 linux-7vph kernel: XXX sda: bio=f5caaac0 error=-5 bi_end_io=c01a49fd
> Jun  5 09:26:22 linux-7vph kernel: XXX sda: failing bio f5caab40 with -5
> Jun  5 09:26:22 linux-7vph kernel: XXX sda: bio=f5caab40 error=-5 bi_end_io=c01a49fd
> Jun  5 09:26:22 linux-7vph kernel: XXX sda: failing bio f5caabc0 with -5
> Jun  5 09:26:22 linux-7vph kernel: XXX sda: bio=f5caabc0 error=-5 bi_end_io=c01a49fd
> Jun  5 09:26:22 linux-7vph kernel: XXX sda: failing bio f5caac40 with -5
> Jun  5 09:26:22 linux-7vph kernel: XXX sda: bio=f5caac40 error=-5 bi_end_io=c01a49fd
> Jun  5 09:26:22 linux-7vph kernel: XXX sda: failing bio f5caacc0 with -5
> Jun  5 09:26:22 linux-7vph kernel: XXX sda: bio=f5caacc0 error=-5 bi_end_io=c01a49fd
> Jun  5 09:26:22 linux-7vph kernel: XXX sda: failing bio f5caad40 with -5
> Jun  5 09:26:22 linux-7vph kernel: XXX sda: bio=f5caad40 error=-5 bi_end_io=c01a49fd
> Jun  5 09:26:22 linux-7vph kernel: sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> Jun  5 09:26:22 linux-7vph kernel: sd 0:0:0:0: [sda] Sense Key : Aborted Command [current] [descriptor]
> Jun  5 09:26:22 linux-7vph kernel: Descriptor sense data with sense descriptors (in hex):
> Jun  5 09:26:22 linux-7vph kernel:         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
> Jun  5 09:26:22 linux-7vph kernel:         0e 6f 8a 3f 
> Jun  5 09:26:22 linux-7vph kernel: sd 0:0:0:0: [sda] Add. Sense: No additional sense information
> Jun  5 09:26:22 linux-7vph kernel: end_request: I/O error, dev sda, sector 242190911
> Jun  5 09:26:22 linux-7vph kernel: XXX sda: failing bio f5caadc0 with -5
> Jun  5 09:26:22 linux-7vph kernel: XXX sda: bio=f5caadc0 error=-5 bi_end_io=c01a49fd
> Jun  5 09:26:22 linux-7vph kernel: XXX sda: failing bio f5caae40 with -5
> Jun  5 09:26:22 linux-7vph kernel: XXX sda: bio=f5caae40 error=-5 bi_end_io=c01a49fd
> Jun  5 09:26:22 linux-7vph kernel: XXX sda: failing bio f5caaec0 with -5
> Jun  5 09:26:22 linux-7vph kernel: XXX sda: bio=f5caaec0 error=-5 bi_end_io=c01a49fd
> Jun  5 09:26:22 linux-7vph kernel: XXX sda: failing bio f5caaf40 with -5
> Jun  5 09:26:22 linux-7vph kernel: XXX sda: bio=f5caaf40 error=-5 bi_end_io=c01a49fd
> Jun  5 09:26:22 linux-7vph kernel: XXX sda: failing bio e12230c0 with -5
> Jun  5 09:26:22 linux-7vph kernel: XXX sda: bio=e12230c0 error=-5 bi_end_io=c01a49fd
> Jun  5 09:26:22 linux-7vph kernel: ata1: EH complete
> Jun  5 09:26:22 linux-7vph kernel: EXT4-fs error (device sda6): __ext4_get_inode_loc: unable to read inode block - inode=2346994, block=9404448
> Jun  5 09:26:22 linux-7vph kernel: EXT4-fs error (device sda6) in ext4_reserve_inode_write: IO failure
> 


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
