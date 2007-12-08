Return-Path: <linux-kernel-owner+w=401wt.eu-S1757627AbXLHKUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627AbXLHKUt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 05:20:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbXLHKUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 05:20:39 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59139 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750963AbXLHKUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 05:20:36 -0500
Date: Sat, 8 Dec 2007 02:20:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andreas Mohr <andi@lisas.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-ide@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Message-Id: <20071208022001.155e0c52.akpm@linux-foundation.org>
In-Reply-To: <20071208101256.GA25807@rhlx01.hs-esslingen.de>
References: <200712080340.49546.rjw@sisk.pl>
	<20071208013631.3147986a.akpm@linux-foundation.org>
	<20071208101256.GA25807@rhlx01.hs-esslingen.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Dec 2007 11:12:57 +0100 Andreas Mohr <andi@lisas.de> wrote:

> Hi,
> 
> On Sat, Dec 08, 2007 at 01:36:31AM -0800, Andrew Morton wrote:
> > > Subject		: PATA scan: ACPI Exception AE_AML_PACKAGE_LIMIT... is beyond end of object
> > > Submitter	: Hans de Bruin <bruinjm@xs4all.nl>
> > > References	: http://bugzilla.kernel.org/show_bug.cgi?id=9320
> > > Handled-By	: Robert Moore <Robert.Moore@intel.com>
> > > 		  Tejun Heo <htejun@gmail.com>
> > > 		  Fu Michael <michael.fu@intel.com>
> > > Patch		: 
> > > 
> > 
> > A number of other people are seeing the same thing and Tejun is putting in
> > a blacklist of machines which cannot use libata+acpi.  That patch is not
> > yet in any git tree which I pull.
> > 
> > AFACIT the machines kepe working OK - there's just some nasty dmesg spew.
> > 
> > If any machines _are_ breaking then this could cause real problems and I'd
> > prefer that we either go for a whitelist or arrange to detect the condition
> > and fall back to non-acpi ata.
> 
> Does this report now win me the lucky draw, pretty please? ;)

nah, you have to cc the acpi guys to get a prize ;)

Len&co, could you please take a look?

Andreas, please do separately report that WOL problem too..

Our list just reached 30.

> STD regression rc1 -> rc234, suspend fails completely, recovering is
> pretty much useless since HDD is DEAD from this point on anyway.
> Managed to capture -rc2 suspend logging via still-alive ssh session.
> 
> 2.6.24-rc1 suspend/resume log, successful (well, a couple seconds delay, most likely due to
> well-recovered AML failure):
> 
> swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
> swsusp: Basic memory bitmaps created
> Syncing filesystems ... done.
> Freezing user space processes ... (elapsed 0.00 seconds) done.
> Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
> Shrinking memory... done (0 pages freed)
> Freed 0 kbytes in 0.02 seconds (0.00 MB/s)
> Suspending console(s)
> hub 4-0:1.0: hub_suspend
> usb usb4: bus suspend
> ehci_hcd 0000:00:10.3: suspend root hub
> hub 3-0:1.0: hub_suspend
> usb usb3: bus suspend
> usb usb3: suspend_rh
> hub 2-0:1.0: hub_suspend
> usb usb2: bus suspend
> usb usb2: suspend_rh
> hub 1-0:1.0: hub_suspend
> usb usb1: bus suspend
> usb usb1: suspend_rh
> sd 0:0:0:0: [sda] Synchronizing SCSI cache
> parport_pc 00:09: disabled
> serial 00:08: disabled
> serial 00:07: disabled
> ACPI: PCI interrupt for device 0000:00:11.5 disabled
> ACPI handle has no context!
> ACPI: PCI interrupt for device 0000:00:11.1 disabled
> ACPI: PCI interrupt for device 0000:00:10.3 disabled
> ehci_hcd 0000:00:10.3: --> PCI D3/wakeup
> uhci_hcd 0000:00:10.2: uhci_suspend
> ACPI: PCI interrupt for device 0000:00:10.2 disabled
> uhci_hcd 0000:00:10.2: --> PCI D3
> uhci_hcd 0000:00:10.1: uhci_suspend
> ACPI: PCI interrupt for device 0000:00:10.1 disabled
> uhci_hcd 0000:00:10.1: --> PCI D3
> uhci_hcd 0000:00:10.0: uhci_suspend
> ACPI: PCI interrupt for device 0000:00:10.0 disabled
> uhci_hcd 0000:00:10.0: --> PCI D3
> ACPI: PCI interrupt for device 0000:00:0d.0 disabled
> ACPI handle has no context!
> ACPI: PCI interrupt for device 0000:00:0c.0 disabled
> ACPI handle has no context!
> pci_set_power_state(): 0000:00:00.0: state=3, current state=5
> swsusp: critical section:
> swsusp: Need to copy 51195 pages
> Intel machine check architecture supported.
> Intel machine check reporting enabled on CPU#0.
> evxfevnt-0079 [00] enable                : System is already in ACPI mode
> ACPI: PCI Interrupt Link [ALKA] BIOS reported IRQ 0, using IRQ 20
> ACPI: PCI Interrupt Link [ALKB] BIOS reported IRQ 0, using IRQ 21
> ACPI: PCI Interrupt Link [ALKC] BIOS reported IRQ 0, using IRQ 22
> ACPI: PCI Interrupt Link [ALKD] BIOS reported IRQ 0, using IRQ 23
> evxfevnt-0079 [00] enable                : System is already in ACPI mode
> ACPI: Unable to turn cooling device [c180ff60] 'off'
> PCI: Setting latency timer of device 0000:00:01.0 to 64
> ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[19]  MMIO=[db140000-db1407ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
> ACPI: PCI Interrupt 0000:00:0a.0[A] -> GSI 18 (level, low) -> IRQ 18
> e100: eth-intel: e100_watchdog: link up, 100Mbps, full-duplex
> PM: Writing back config space on device 0000:00:0d.0 at offset 1 (was 2100007, writing 2100003)
> ACPI: PCI Interrupt 0000:00:0d.0[A] -> GSI 19 (level, low) -> IRQ 22
> uhci_hcd 0000:00:10.0: PCI D0, from previous PCI D3
> ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 20
> uhci_hcd 0000:00:10.0: uhci_resume
> uhci_hcd 0000:00:10.0: uhci_check_and_reset_hc: cmd = 0x0000
> uhci_hcd 0000:00:10.0: Performing full reset
> usb usb1: root hub lost power or was reset
> usb usb1: suspend_rh
> uhci_hcd 0000:00:10.1: PCI D0, from previous PCI D3
> ACPI: PCI Interrupt 0000:00:10.1[B] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 20
> uhci_hcd 0000:00:10.1: uhci_resume
> uhci_hcd 0000:00:10.1: uhci_check_and_reset_hc: cmd = 0x0000
> uhci_hcd 0000:00:10.1: Performing full reset
> usb usb2: root hub lost power or was reset
> usb usb2: suspend_rh
> uhci_hcd 0000:00:10.2: PCI D0, from previous PCI D3
> ACPI: PCI Interrupt 0000:00:10.2[C] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 20
> uhci_hcd 0000:00:10.2: uhci_resume
> uhci_hcd 0000:00:10.2: uhci_check_and_reset_hc: cmd = 0x0000
> uhci_hcd 0000:00:10.2: Performing full reset
> usb usb3: root hub lost power or was reset
> usb usb3: suspend_rh
> ehci_hcd 0000:00:10.3: PCI D0, from previous PCI D3
> ACPI: PCI Interrupt 0000:00:10.3[D] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 20
> PM: Writing back config space on device 0000:00:10.3 at offset 3 (was 2008, writing 2010)
> PM: Writing back config space on device 0000:00:10.3 at offset 1 (was 2100007, writing 2100017)
> PM: Writing back config space on device 0000:00:11.1 at offset 1 (was 2900003, writing 2900007)
> ACPI: PCI Interrupt 0000:00:11.1[A] -> Link [ALKA] -> GSI 20 (level, low) -> IRQ 17
> ACPI: PCI Interrupt 0000:00:11.5[C] -> Link [ALKC] -> GSI 22 (level, low) -> IRQ 23
> PCI: Setting latency timer of device 0000:00:11.5 to 64
> ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
> serial 00:07: activated
> serial 00:08: activated
> parport_pc 00:09: activated
> i8042 aux 00:0a: activation failed
> i8042 kbd 00:0b: activation failed
> sd 0:0:0:0: [sda] Starting disk
> ACPI Exception (exoparg2-0442): AE_AML_PACKAGE_LIMIT, Index (0FFFFFFFF) is beyond end of object [20070126]
> ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.GTF_] (Node c180b990), AE_AML_PACKAGE_LIMIT
> ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN0.DRV1._GTF] (Node c180b888), AE_AML_PACKAGE_LIMIT
> ata1.01: _GTF evaluation failed (AE 0x300d)
> ata1.01: revalidation failed (errno=-5)
> ata1: failed to recover some devices, retrying in 5 secs
> ACPI Exception (exoparg2-0442): AE_AML_PACKAGE_LIMIT, Index (0FFFFFFFF) is beyond end of object [20070126]
> ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.GTF_] (Node c180b990), AE_AML_PACKAGE_LIMIT
> ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN0.DRV1._GTF] (Node c180b888), AE_AML_PACKAGE_LIMIT
> ata1.01: _GTF evaluation failed (AE 0x300d)
> ata1.01: ACPI on devcfg failed the second time, disabling (errno=-5)
> ata1.01: revalidation failed (errno=1)
> ata1: failed to recover some devices, retrying in 5 secs
> ACPI Exception (exoparg2-0442): AE_AML_PACKAGE_LIMIT, Index (0FFFFFFFF) is beyond end of object [20070126]
> ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.GTF_] (Node c180b990), AE_AML_PACKAGE_LIMIT
> ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN0.DRV0._GTF] (Node c180b840), AE_AML_PACKAGE_LIMIT
> ata1.00: _GTF evaluation failed (AE 0x300d)
> ata1.00: revalidation failed (errno=-5)
> ata1: failed to recover some devices, retrying in 5 secs
> ACPI Exception (exoparg2-0442): AE_AML_PACKAGE_LIMIT, Index (0FFFFFFFF) is beyond end of object [20070126]
> ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.GTF_] (Node c180b990), AE_AML_PACKAGE_LIMIT
> ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN0.DRV0._GTF] (Node c180b840), AE_AML_PACKAGE_LIMIT
> ata1.00: _GTF evaluation failed (AE 0x300d)
> ata1.00: ACPI on devcfg failed the second time, disabling (errno=-5)
> ata1.00: revalidation failed (errno=1)
> ata1: failed to recover some devices, retrying in 5 secs
> ata1.00: configured for UDMA/100
> ata1.01: configured for UDMA/33
> sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> usb usb1: usb resume
> usb usb1: wakeup_rh
> hub 1-0:1.0: trying to enable port power on non-switchable hub
> usb usb2: usb resume
> usb usb2: wakeup_rh
> hub 2-0:1.0: trying to enable port power on non-switchable hub
> usb usb3: usb resume
> usb usb3: wakeup_rh
> hub 3-0:1.0: trying to enable port power on non-switchable hub
> usb usb4: usb resume
> ehci_hcd 0000:00:10.3: resume root hub
> hub 4-0:1.0: hub_resume
> Restarting tasks ... <7>hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0006
> uhci_hcd 0000:00:10.0: port 1 portsc 018a,00
> hub 1-0:1.0: port 1, status 0300, change 0003, 1.5 Mb/s
> done.
> swsusp: Basic memory bitmaps freed
> hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x300
> uhci_hcd 0000:00:10.0: port 2 portsc 008a,00
> hub 1-0:1.0: port 2, status 0100, change 0003, 12 Mb/s
> hub 1-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100
> hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0006
> uhci_hcd 0000:00:10.1: port 1 portsc 018a,00
> hub 2-0:1.0: port 1, status 0300, change 0003, 1.5 Mb/s
> hub 2-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x300
> uhci_hcd 0000:00:10.1: port 2 portsc 008a,00
> hub 2-0:1.0: port 2, status 0100, change 0003, 12 Mb/s
> hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100
> hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0006
> uhci_hcd 0000:00:10.2: port 1 portsc 008a,00
> hub 3-0:1.0: port 1, status 0100, change 0003, 12 Mb/s
> hub 3-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x100
> uhci_hcd 0000:00:10.2: port 2 portsc 008a,00
> hub 3-0:1.0: port 2, status 0100, change 0003, 12 Mb/s
> hub 3-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100
> hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0000
> hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
> hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
> hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
> usb usb1: suspend_rh (auto-stop)
> usb usb2: suspend_rh (auto-stop)
> usb usb3: suspend_rh (auto-stop)
> agpgart: Found an AGP 2.0 compliant device at 0000:00:00.0.
> agpgart: Putting AGP V2 device at 0000:00:00.0 into 4x mode
> agpgart: Putting AGP V2 device at 0000:01:00.0 into 4x mode
> [drm] Loading R200 Microcode
> 
> 
> 
> 2.6.24-rc2 suspend log (one screenful), UNSUCCESSFUL:
> 
> serial 00:07: disabled
> ACPI: PCI interrupt for device 0000:00:11.5 disabled
> ACPI Exception (exoparg2-0442): AE_AML_PACKAGE_LIMIT, Index (0FFFFFFFF) is beyond end of object [20070126]
> ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.GTM_]
> (Node c180b9a8), AE_AML_PACKAGE_LIMIT
> ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN1._GTM] (Node c180b8d0), AE_AML_PACKAGE_LIMIT
> ata2: ACPI get timing mode failed (AE 0x300d)
> pci_device_suspend(): ata_pci_device_suspend+0x0/0x40() returns -22
> suspend_device(): pci_device_suspend+0x0/0x70() returns -22
> Could not suspend device 0000:00:11.1: error -22
> ACPI: PCI Interrupt 0000:00:11.5[C] -> Link [ALKC] -> GSI 22 (level, low) -> IRQ 23
> ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
> serial 00:07: activated
> serial 00:08: activated
> parport_pc 00:09: activated
> i8042 aux 00:0a: activation failed
> i8042 kbd 00:0b: activation failed
> sd 0:0:0:0: [sda] Starting disk
> sd 0:0:0:0: timing out command, waited 180s
> sd 0:0:0:0: [sda] START_STOP FAILED
> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
> Restarting tasks ... <7>hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0000
> done.
> swsusp: Basic memory bitmaps freed
> swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
> swsusp: Basic memory bitmaps created
> Syncing filesystems ...
> 
> 
> 
> # lspci
> 00:00.0 Host bridge: VIA Technologies, Inc. VT8366/A/7 [Apollo KT266/A/333]
> 00:01.0 PCI bridge: VIA Technologies, Inc. VT8366/A/7 [Apollo KT266/A/333 AGP]
> 00:09.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host Controller (rev 46)
> 00:0a.0 Multimedia audio controller: Aureal Semiconductor Vortex 2 (rev fe)
> 00:0c.0 Ethernet controller: Intel Corporation 82557/8/9 [Ethernet Pro 100] (rev 08)
> 00:0d.0 Multimedia audio controller: Aztech System Ltd 3328 Audio (rev 10)
> 00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 80)
> 00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 80)
> 00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 80)
> 00:10.3 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 82)
> 00:11.0 ISA bridge: VIA Technologies, Inc. VT8235 ISA Bridge
> 00:11.1 IDE interface: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
> 00:11.5 Multimedia audio controller: VIA Technologies, Inc. VT8233/A/8235/8237 AC97 Audio Controller (rev 50)
> 00:12.0 Ethernet controller: VIA Technologies, Inc. VT6102 [Rhine-II] (rev 74)
> 01:00.0 VGA compatible controller: ATI Technologies Inc Radeon RV250 If [Radeon 9000] (rev 01)
> 01:00.1 Display controller: ATI Technologies Inc Radeon RV250 [Radeon 9000] (Secondary) (rev 01)
> 
> 
> # dmidecode 2.9
> SMBIOS 2.2 present.
> 39 structures occupying 1035 bytes.
> Table at 0x000F0800.
> 
> Handle 0x0000, DMI type 0, 19 bytes
> BIOS Information
>         Vendor: Award Software International, Inc.
>         Version: 6.00 PG
>         Release Date: 09/16/2003
>         Address: 0xE0000
>         Runtime Size: 128 kB
>         ROM Size: 512 kB
>         Characteristics:
>                 ISA is supported
>                 PCI is supported
>                 PNP is supported
>                 APM is supported
>                 BIOS is upgradeable
>                 BIOS shadowing is allowed
>                 ESCD support is available
>                 Boot from CD is supported
>                 Selectable boot is supported
>                 BIOS ROM is socketed
>                 EDD is supported
>                 5.25"/360 KB floppy services are supported (int 13h)
>                 5.25"/1.2 MB floppy services are supported (int 13h)
>                 3.5"/720 KB floppy services are supported (int 13h)
>                 3.5"/2.88 MB floppy services are supported (int 13h)
>                 Print screen service is supported (int 5h)
>                 8042 keyboard services are supported (int 9h)
>                 Serial services are supported (int 14h)
>                 Printer services are supported (int 17h)
>                 CGA/mono video services are supported (int 10h)
>                 ACPI is supported
>                 USB legacy is supported
>                 AGP is supported
>                 LS-120 boot is supported
>                 ATAPI Zip drive boot is supported
> 
> Handle 0x0001, DMI type 1, 25 bytes
> System Information
>         Manufacturer: VIA Technologies, Inc.
>         Product Name: VT8367-8235
>         Version:
>         Serial Number:
>         UUID: Not Present
>         Wake-up Type: Power Switch
> 
> Handle 0x0002, DMI type 2, 8 bytes
> Base Board Information
>         Manufacturer:
>         Product Name: VT8367-8235
>         Version:
>         Serial Number:
> 
> Handle 0x0003, DMI type 3, 13 bytes
> Chassis Information
>         Manufacturer:
>         Type: Desktop
>         Lock: Not Present
>         Version:
>         Serial Number:
>         Asset Tag:
>         Boot-up State: Unknown
>         Power Supply State: Unknown
>         Thermal State: Unknown
>         Security Status: Unknown
> 
> Handle 0x0004, DMI type 4, 32 bytes
> Processor Information
>         Socket Designation: Socket A
>         Type: Central Processor
>         Family: Duron
>         Manufacturer: AMD
>         ID: 81 06 00 00 FF FB 83 03
>         Signature: Family 6, Model 8, Stepping 1
>         Flags:
>                 FPU (Floating-point unit on-chip)
>                 VME (Virtual mode extension)
>                 DE (Debugging extension)
>                 PSE (Page size extension)
>                 TSC (Time stamp counter)
>                 MSR (Model specific registers)
>                 PAE (Physical address extension)
>                 MCE (Machine check exception)
>                 CX8 (CMPXCHG8 instruction supported)
>                 APIC (On-chip APIC hardware supported)
>                 SEP (Fast system call)
>                 MTRR (Memory type range registers)
>                 PGE (Page global enable)
>                 MCA (Machine check architecture)
>                 CMOV (Conditional move instruction supported)
>                 PAT (Page attribute table)
>                 PSE-36 (36-bit page size extension)
>                 MMX (MMX technology supported)
>                 FXSR (Fast floating-point save and restore)
>                 SSE (Streaming SIMD extensions)
>         Version: AMD K7 processor
>         Voltage: 3.3 V
>         External Clock: 133 MHz
>         Max Speed: 1500 MHz
>         Current Speed: 1200 MHz
>         Status: Populated, Enabled
>         Upgrade: ZIF Socket
>         L1 Cache Handle: 0x000A
>         L2 Cache Handle: 0x000B
>         L3 Cache Handle: No L3 Cache
> 
> Handle 0x0005, DMI type 5, 24 bytes
> Memory Controller Information
>         Error Detecting Method: None
>         Error Correcting Capabilities:
>                 None
>         Supported Interleave: One-way Interleave
>         Current Interleave: Four-way Interleave
>         Maximum Memory Module Size: 32 MB
>         Maximum Total Memory Size: 128 MB
>         Supported Speeds:
>                 70 ns
>                 60 ns
>         Supported Memory Types:
>                 Standard
>                 EDO
>         Memory Module Voltage: 5.0 V
>         Associated Memory Slots: 4
>                 0x0006
>                 0x0007
>                 0x0008
>                 0x0009
>         Enabled Error Correcting Capabilities: None
> 
> .
> .
> .
> 
> 
> # hdparm -i /dev/sda
> 
> /dev/sda:
> 
>  Model=WDC WD1200JB-00CRA1                     , FwRev=17.07W17, SerialNo=WD-WCA8C4285629
>  Config={ HardSect NotMFM HdSw>15uSec SpinMotCtl Fixed DTR>5Mbs FmtGapReq }
>  RawCHS=16383/16/63, TrkSize=57600, SectSize=600, ECCbytes=40
>  BuffType=DualPortCache, BuffSize=8192kB, MaxMultSect=16, MultSect=?16?
>  CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=234441648
>  IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
>  PIO modes:  pio0 pio1 pio2 pio3 pio4
>  DMA modes:  mdma0 mdma1 mdma2
>  UDMA modes: udma0 udma1 udma2 udma3 udma4 *udma5
>  AdvancedPM=no WriteCache=enabled
>  Drive conforms to: Unspecified:  ATA/ATAPI-1,2,3,4,5
> 
>  * signifies the current active mode
> 
> 
> 
> Athlon on EPOX 8K5A2+ board.
> 
> 
> 
> Again, 2.6.23 and 2.6.24-rc1 work, yet 2.6.24 -rc2, -rc3 and -rc4 FAIL.
> 
> Probably won't be able to do any reporting over the weekend (WOL is
> inoperable ATM for some weird reason), let me know what you need.
> Took too much time to gather this report already anyway ;)
> 
> Thanks,
> 
> Andreas Mohr
