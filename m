Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbYJ1XNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbYJ1XNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 19:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbYJ1XNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 19:13:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39694 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253AbYJ1XNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 19:13:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pascal Terjan <pterjan@mandriva.com>
Subject: Re: pm_op(): pci_pm_restore+0x0/0x70 returns -16
Date: Wed, 29 Oct 2008 00:18:24 +0100
User-Agent: KMail/1.9.9
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
References: <1225190519.8039.14.camel@plop>
In-Reply-To: <1225190519.8039.14.camel@plop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810290018.24479.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 28 of October 2008, Pascal Terjan wrote:
> Since I updated my laptop (Thikpad T40) to 2.6.27-rc5 and all new
> kernels until 2.6.27.3 (was using 2.6.25 before), I get this at resume
> time after hibernation :
> 
> Oct 28 10:39:18 plop kernel: pm_op(): pci_pm_restore+0x0/0x70 returns
> -16
> Oct 28 10:39:19 plop kernel: PM: Device 0000:00:00.0 failed to restore:
> error -16
> 
> This may or may not be related to resume issues I often get.
> 
> Sometimes it still work fine, sometimes it panics but I can't get any
> log, sometimes I get back to X but without USB mouse, without keyboard
> and ssh not responding (sysrq still work).

It looks like the ->restore() callback fails for your hostbridge.  It might
have done that before, but we've only been reporting such failures since the
2.6.27 development cycle.

Did hibernation work correctly with 2.6.25?

>  00:00.0 Host bridge: Intel Corporation 82855PM Processor to I/O
> Controller (rev 03)
> 	Subsystem: IBM Thinkpad T40 series
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort+ >SERR- <PERR- INTx-
> 	Latency: 0
> 	Region 0: Memory at d0000000 (32-bit, prefetchable) [size=256M]
> 	Capabilities: [e4] Vendor Specific Information <?>
> 	Capabilities: [a0] AGP version 2.0
> 		Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit-
> FW+ AGP3- Rate=x1,x2,x4
> 		Command: RQ=1 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW- Rate=x4
> 	Kernel driver in use: agpgart-intel
> 	Kernel modules: intel-agp
> 
> 
> Here is the warn level log of the resume :
> 
> Oct 28 10:39:16 plop kernel: Syncing filesystems ... done.
> Oct 28 10:39:18 plop kernel: Freezing user space processes ... (elapsed
> 0.06 seconds) done.
> Oct 28 10:39:18 plop kernel: Freezing remaining freezable tasks ...
> (elapsed 0.00 seconds) done.
> Oct 28 10:39:18 plop kernel: Suspending console(s) (use
> no_console_suspend to debug)
> Oct 28 10:39:18 plop kernel: Disabling non-boot CPUs ...
> Oct 28 10:39:21 plop kernel: Restarting tasks ... done.
> Oct 28 10:45:26 plop kernel: Emergency Sync complete
> 
> Here is the info level :
> 
> Oct 28 10:39:18 plop kernel: PM: Shrinking memory... done (92359 pages
> freed)
> Oct 28 10:39:18 plop kernel: PM: Freed 369436 kbytes in 12.51 seconds
> (29.53 MB/s)
> Oct 28 10:39:18 plop kernel: sd 0:0:0:0: [sda] Synchronizing SCSI cache
> Oct 28 10:39:18 plop kernel: nsc-ircc 00:0b: disabled
> Oct 28 10:39:18 plop kernel: parport_pc 00:0a: disabled
> Oct 28 10:39:18 plop kernel: serial 00:09: disabled
> Oct 28 10:39:18 plop kernel: eth4: Going into suspend...
> Oct 28 10:39:18 plop kernel: ipw2200 0000:02:02.0: PCI INT A disabled
> Oct 28 10:39:18 plop kernel: ACPI handle has no context!
> Oct 28 10:39:18 plop kernel: Intel ICH Modem 0000:00:1f.6: PCI INT B
> disabled
> Oct 28 10:39:18 plop kernel: Intel ICH 0000:00:1f.5: PCI INT B disabled
> Oct 28 10:39:18 plop kernel: ata_piix 0000:00:1f.1: PCI INT A disabled
> Oct 28 10:39:18 plop kernel: ehci_hcd 0000:00:1d.7: PCI INT D disabled
> Oct 28 10:39:18 plop kernel: uhci_hcd 0000:00:1d.2: PCI INT C disabled
> Oct 28 10:39:18 plop kernel: uhci_hcd 0000:00:1d.1: PCI INT B disabled
> Oct 28 10:39:18 plop kernel: uhci_hcd 0000:00:1d.0: PCI INT A disabled
> Oct 28 10:39:18 plop kernel: ACPI: Preparing to enter system sleep state
> S4
> Oct 28 10:39:18 plop kernel: Extended CMOS year: 2000
> Oct 28 10:39:18 plop kernel: PM: Creating hibernation image: 
> Oct 28 10:39:18 plop kernel: PM: Need to copy 91604 pages
> Oct 28 10:39:18 plop kernel: Intel machine check architecture supported.
> Oct 28 10:39:18 plop kernel: Intel machine check reporting enabled on
> CPU#0.
> Oct 28 10:39:18 plop kernel: Extended CMOS year: 2000
> Oct 28 10:39:18 plop kernel: ACPI: Waking up from system sleep state S4
> Oct 28 10:39:18 plop kernel: ACPI: EC: non-query interrupt received,
> switching to interrupt mode
> Oct 28 10:39:21 plop kernel: uhci_hcd 0000:00:1d.0: power state changed
> by ACPI to D0
> Oct 28 10:39:21 plop kernel: uhci_hcd 0000:00:1d.0: PCI INT A ->
> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
> Oct 28 10:39:21 plop kernel: uhci_hcd 0000:00:1d.0: setting latency
> timer to 64
> Oct 28 10:39:21 plop kernel: uhci_hcd 0000:00:1d.1: power state changed
> by ACPI to D0
> Oct 28 10:39:21 plop kernel: uhci_hcd 0000:00:1d.1: PCI INT B ->
> Link[LNKD] -> GSI 11 (level, low) -> IRQ 11
> Oct 28 10:39:21 plop kernel: uhci_hcd 0000:00:1d.1: setting latency
> timer to 64
> Oct 28 10:39:21 plop kernel: uhci_hcd 0000:00:1d.2: PCI INT C ->
> Link[LNKC] -> GSI 11 (level, low) -> IRQ 11
> Oct 28 10:39:21 plop kernel: uhci_hcd 0000:00:1d.2: setting latency
> timer to 64
> Oct 28 10:39:21 plop kernel: ehci_hcd 0000:00:1d.7: power state changed
> by ACPI to D0
> Oct 28 10:39:21 plop kernel: ehci_hcd 0000:00:1d.7: PCI INT D ->
> Link[LNKH] -> GSI 11 (level, low) -> IRQ 11
> Oct 28 10:39:21 plop kernel: ehci_hcd 0000:00:1d.7: setting latency
> timer to 64
> Oct 28 10:39:21 plop kernel: pci 0000:00:1e.0: restoring config space at
> offset 0x6 (was 0x40080200, writing 0x40100200)
> Oct 28 10:39:21 plop kernel: pci 0000:00:1e.0: setting latency timer to
> 64
> Oct 28 10:39:21 plop kernel: ata_piix 0000:00:1f.1: restoring config
> space at offset 0x1 (was 0x2800003, writing 0x2800007)
> Oct 28 10:39:21 plop kernel: ata_piix 0000:00:1f.1: PCI INT A ->
> Link[LNKC] -> GSI 11 (level, low) -> IRQ 11
> Oct 28 10:39:21 plop kernel: ata_piix 0000:00:1f.1: setting latency
> timer to 64
> Oct 28 10:39:21 plop kernel: Intel ICH 0000:00:1f.5: restoring config
> space at offset 0x1 (was 0x2900007, writing 0x2900003)
> Oct 28 10:39:21 plop kernel: Intel ICH 0000:00:1f.5: PCI INT B ->
> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
> Oct 28 10:39:21 plop kernel: Intel ICH 0000:00:1f.5: setting latency
> timer to 64
> Oct 28 10:39:21 plop kernel: ata2.00: ACPI cmd ef/03:42:00:00:00:a0
> filtered out
> Oct 28 10:39:21 plop kernel: ata2.00: ACPI cmd ef/03:0c:00:00:00:a0
> filtered out
> Oct 28 10:39:21 plop kernel: ata1.00: ACPI cmd ef/02:00:00:00:00:a0
> succeeded
> Oct 28 10:39:21 plop kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0
> filtered out
> Oct 28 10:39:21 plop kernel: ata1.00: ACPI cmd ef/03:45:00:00:00:a0
> filtered out
> Oct 28 10:39:21 plop kernel: ata1.00: ACPI cmd ef/03:0c:00:00:00:a0
> filtered out
> Oct 28 10:39:21 plop kernel: ata2.00: ACPI cmd e3/00:1f:00:00:00:a0
> succeeded
> Oct 28 10:39:21 plop kernel: ata2.00: ACPI cmd e3/00:02:00:00:00:a0
> succeeded
> Oct 28 10:39:21 plop kernel: ata1.00: configured for UDMA/100
> Oct 28 10:39:21 plop kernel: ata2.00: configured for UDMA/33
> Oct 28 10:39:21 plop kernel: ata1.00: configured for UDMA/100
> Oct 28 10:39:21 plop kernel: ata1: EH complete
> Oct 28 10:39:21 plop kernel: sd 0:0:0:0: [sda] 156301488 512-byte
> hardware sectors (80026 MB)
> Oct 28 10:39:21 plop kernel: sd 0:0:0:0: [sda] Write Protect is off
> Oct 28 10:39:21 plop kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> Oct 28 10:39:21 plop kernel: sd 0:0:0:0: [sda] Write cache: enabled,
> read cache: enabled, doesn't support DPO or FUA
> Oct 28 10:39:21 plop kernel: sd 0:0:0:0: [sda] 156301488 512-byte
> hardware sectors (80026 MB)
> Oct 28 10:39:21 plop kernel: sd 0:0:0:0: [sda] Write Protect is off
> Oct 28 10:39:21 plop kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> Oct 28 10:39:21 plop kernel: sd 0:0:0:0: [sda] Write cache: enabled,
> read cache: enabled, doesn't support DPO or FUA
> Oct 28 10:39:21 plop kernel: Intel ICH Modem 0000:00:1f.6: PCI INT B ->
> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
> Oct 28 10:39:21 plop kernel: Intel ICH Modem 0000:00:1f.6: setting
> latency timer to 64
> Oct 28 10:39:21 plop kernel: pci 0000:01:00.0: power state changed by
> ACPI to D0
> Oct 28 10:39:21 plop kernel: pci 0000:01:00.0: PCI INT A -> Link[LNKA]
> -> GSI 11 (level, low) -> IRQ 11
> Oct 28 10:39:21 plop kernel: yenta_cardbus 0000:02:00.0: restoring
> config space at offset 0xf (was 0x3c0010b, writing 0x5c0010b)
> Oct 28 10:39:21 plop kernel: yenta_cardbus 0000:02:00.0: restoring
> config space at offset 0x3 (was 0x824008, writing 0x82a820)
> Oct 28 10:39:21 plop kernel: yenta_cardbus 0000:02:00.0: restoring
> config space at offset 0x1 (was 0x2100107, writing 0x2100007)
> Oct 28 10:39:21 plop kernel: yenta_cardbus 0000:02:00.1: restoring
> config space at offset 0xf (was 0x3c0020b, writing 0x5c0020b)
> Oct 28 10:39:21 plop kernel: yenta_cardbus 0000:02:00.1: restoring
> config space at offset 0x3 (was 0x824008, writing 0x82a820)
> Oct 28 10:39:21 plop kernel: yenta_cardbus 0000:02:00.1: restoring
> config space at offset 0x1 (was 0x2100107, writing 0x2100007)
> Oct 28 10:39:21 plop kernel: eth4: Coming out of suspend...
> Oct 28 10:39:21 plop kernel: ipw2200 0000:02:02.0: PCI INT A ->
> Link[LNKC] -> GSI 11 (level, low) -> IRQ 11
> Oct 28 10:39:21 plop kernel: serial 00:09: activated
> Oct 28 10:39:21 plop kernel: parport_pc 00:0a: activated
> Oct 28 10:39:21 plop kernel: nsc-ircc 00:0b: activated
> Oct 28 10:39:21 plop kernel: sd 0:0:0:0: [sda] Starting disk
> Oct 28 10:39:21 plop kernel: usb 3-2: reset low speed USB device using
> uhci_hcd and address 3
> Oct 28 10:39:21 plop kernel: usb 3-2: device firmware changed
> Oct 28 10:39:21 plop kernel: usb 3-2: USB disconnect, address 3
> Oct 28 10:39:22 plop kernel: agpgart-intel 0000:00:00.0: AGP 2.0 bridge
> Oct 28 10:39:22 plop kernel: agpgart-intel 0000:00:00.0: putting AGP V2
> device into 4x mode
> Oct 28 10:39:22 plop kernel: pci 0000:01:00.0: putting AGP V2 device
> into 4x mode
> Oct 28 10:39:22 plop kernel: [drm] Loading R100 Microcode
> Oct 28 10:45:26 plop kernel: SysRq : Emergency Sync
> Oct 28 10:45:29 plop kernel: SysRq : Keyboard mode set to system default
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


