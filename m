Return-Path: <linux-kernel-owner+w=401wt.eu-S1758883AbYDBE2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883AbYDBE2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 00:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbYDBE16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 00:27:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:26963 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbYDBE14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 00:27:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:message-id;
        b=qobnq/eZcdcfTjfYkOQiuw7Ob+2xpx/7XrZxhclsWFUTUIvLZ+kjArxclyOv7NrXmsLW2AayH2ZEM0SYTESQXAWX1Z12Hp9D4rQ3aJnb6nfneOwxpYAkZ2l7gBBxm5zPt/0GLt93vEXpDD/z5urAkj6KN77mVJnhgRwat1hQTEI=
From: Mihai =?utf-8?q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Organization: Home
To: Tim Ricketts <tr@earth.li>
Subject: Re: gettimeofday() jumping into the future
Date: Wed, 2 Apr 2008 07:27:51 +0300
User-Agent: KMail/1.9.7
Cc: Michael Smith <msmith@xiph.org>, LKML <linux-kernel@vger.kernel.org>,
       Andy Wingo <wingo@fluendo.com>
References: <3c1737210708230408i7a8049a9m5db49e6c4d89ab62@mail.gmail.com> <Pine.LNX.4.64.0803302210060.3056@falcon.foo> <200804020726.11300.mihai.dontu@gmail.com>
In-Reply-To: <200804020726.11300.mihai.dontu@gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Htw8HNUbDqUPYCn"
Message-Id: <200804020727.51985.mihai.dontu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_Htw8HNUbDqUPYCn
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

On Wednesday 02 April 2008, Mihai Donțu wrote:
> On Monday 31 March 2008, Tim Ricketts wrote:
> > On Thu, 23 Aug 2007, Michael Smith wrote:
> > 
> > > We've been seeing some strange behaviour on some of our applications
> > > recently. I've tracked this down to gettimeofday() returning spurious
> > > values occasionally.
> > >
> > > Specifically, gettimeofday() will suddenly, for a single call, return
> > > a value about 4398 seconds (~1 hour 13 minutes) in the future. The
> > > following call goes back to a normal value.
> > 
> > I have also seen this.
> 
> I don't know if gettimeofday() and dmesg's logging facility use the same
> time source, but I'm seeing jumps into the past:
> 
> [   11.010300] ACPI: SSDT 3F6D3F27, 01C6 (r1  PmRef  Cpu0Cst     3001 INTL 20050624)
> [    9.344283] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
> [    9.344528] ACPI: Processor [CPU0] (supports 8 throttling states)
> [    9.344989] ACPI: SSDT 3F6D4374, 00C4 (r1  PmRef  Cpu1Ist     3000 INTL 20050624)
> [    9.345458] ACPI: SSDT 3F6D40ED, 0085 (r1  PmRef  Cpu1Cst     3000 INTL 20050624)
> [   11.013089] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
> 
> and the future:
> 
> [   11.081332] usb 1-2: new high speed USB device using ehci_hcd and address 2
> [   12.748489] usb usb4: configuration #1 chosen from 1 choice
> [   12.748653] hub 4-0:1.0: USB hub found
> [   12.748772] hub 4-0:1.0: 2 ports detected
> [   12.849090] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 23 (level, low) -> IRQ 23
> [   12.849338] PCI: Setting latency timer of device 0000:00:1d.3 to 64
> [   12.849341] uhci_hcd 0000:00:1d.3: UHCI Host Controller
> [   12.849505] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
> [   12.849734] uhci_hcd 0000:00:1d.3: irq 23, io base 0x0000bf20
> [   12.850020] usb usb5: configuration #1 chosen from 1 choice
> [   12.850185] hub 5-0:1.0: USB hub found
> [   12.850311] hub 5-0:1.0: 2 ports detected
> [   11.194688] usb 1-2: configuration #1 chosen from 1 choice
> 
> I have a 2.6.24, 64bit, SMP kernel (Intel Core 2 Duo).

The full dmesg, attached.

-- 
Mihai Donțu

--Boundary-00=_Htw8HNUbDqUPYCn
Content-Type: text/x-log;
  charset="utf-8";
  name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg.log"

[    0.000000] Linux version 2.6.24.4 (root@mdontu-dell) (gcc version 4.1.2 (Gentoo 4.1.2 p1.0.2)) #1 SMP PREEMPT Tue Mar 25 01:41:54 EET 2008
[    0.000000] Command line: root=/dev/sda7 nohz=on libata.noacpi=0
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003f6d3400 (usable)
[    0.000000]  BIOS-e820: 000000003f6d3400 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4007000 (reserved)
[    0.000000]  BIOS-e820: 00000000f4008000 - 00000000f400c000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000feda0000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 259795) 1 entries of 256 used
[    0.000000] end_pfn_map = 1048576
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000FC1F0, 0014 (r0 DELL  )
[    0.000000] ACPI: RSDT 3F6D3A0F, 003C (r1 DELL    M07     27D7051C ASL        61)
[    0.000000] ACPI: FACP 3F6D4800, 0074 (r1 DELL    M07     27D7051C ASL        61)
[    0.000000] ACPI: DSDT 3F6D5400, 49A3 (r1 INT430 SYSFexxx     1001 INTL 20050624)
[    0.000000] ACPI: FACS 3F6E3C00, 0040
[    0.000000] ACPI: HPET 3F6D4F00, 0038 (r1 DELL    M07            1 ASL        61)
[    0.000000] ACPI: APIC 3F6D5000, 0068 (r1 DELL    M07     27D7051C ASL        47)
[    0.000000] ACPI: MCFG 3F6D4FC0, 003E (r16 DELL    M07     27D7051C ASL        61)
[    0.000000] ACPI: SLIC 3F6D509C, 0176 (r1 DELL    M07     27D7051C ASL        61)
[    0.000000] ACPI: SSDT 3F6D3A4B, 04DC (r1  PmRef    CpuPm     3000 INTL 20050624)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 259795) 1 entries of 256 used
[    0.000000] No mptable found.
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   259795
[    0.000000] On node 0 totalpages: 259698
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1954 pages reserved
[    0.000000]   DMA zone: 1989 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 3495 pages used for memmap
[    0.000000]   DMA32 zone: 252204 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:b0000000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 36896 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 254193
[    0.000000] Kernel command line: root=/dev/sda7 nohz=on libata.noacpi=0
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] hpet clockevent registered
[    0.000000] TSC calibrated against HPET
[    8.887544] Marking TSC unstable due to TSCs unsynchronized
[    8.887546] time.c: Detected 1662.506 MHz processor.
[    8.891109] Console: colour VGA+ 80x25
[    8.891113] console [tty0] enabled
[    8.898653] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    8.899199] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    8.899416] Checking aperture...
[    8.913856] Memory: 1014504k/1039180k available (4414k kernel code, 23992k reserved, 2210k data, 288k init)
[    8.914117] SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
[    8.973397] Calibrating delay using timer specific routine.. 3327.78 BogoMIPS (lpj=1663893)
[    8.973683] Mount-cache hash table entries: 256
[    8.973970] CPU: L1 I cache: 32K, L1 D cache: 32K
[    8.974121] CPU: L2 cache: 2048K
[    8.974243] using mwait in idle threads.
[    8.974366] CPU: Physical Processor ID: 0
[    8.974504] CPU: Processor Core ID: 0
[    8.974634] CPU0: Thermal monitoring enabled (TM2)
[    8.974771] SMP alternatives: switching to UP code
[    8.976090] ACPI: Core revision 20070126
[    8.990904] Using local APIC timer interrupts.
[    9.051083] APIC timer calibration result 10390656
[    9.051085] Detected 10.390 MHz APIC timer.
[    9.051276] SMP alternatives: switching to SMP code
[    9.052146] Booting processor 1/2 APIC 0x1
[   10.729609] Initializing CPU#1
[   10.789900] Calibrating delay using timer specific routine.. 3324.86 BogoMIPS (lpj=1662431)
[   10.789907] CPU: L1 I cache: 32K, L1 D cache: 32K
[   10.789909] CPU: L2 cache: 2048K
[   10.789912] CPU: Physical Processor ID: 0
[   10.789913] CPU: Processor Core ID: 1
[   10.789920] CPU1: Thermal monitoring enabled (TM2)
[   10.790277] Intel(R) Core(TM)2 CPU         T5500  @ 1.66GHz stepping 06
[    9.123498] Brought up 2 CPUs
[   10.791734] net_namespace: 120 bytes
[   10.792239] NET: Registered protocol family 16
[   10.792602] ACPI: bus type pci registered
[   10.794442] PCI: Using MMCONFIG at f0000000 - f3ffffff
[   10.802102] ACPI: EC: Look up EC in DSDT
[   10.811113] ACPI: Interpreter enabled
[   10.811232] ACPI: (supports S0 S3 S5)
[   10.811452] ACPI: Using IOAPIC for interrupt routing
[   10.834574] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   10.835515] PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
[   10.835637] PCI quirk: region 1080-10bf claimed by ICH6 GPIO
[   10.836717] PCI: Transparent bridge - 0000:00:1e.0
[   10.836924] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   10.837537] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
[   10.837736] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[   10.837880] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[   10.855705] ACPI: PCI Interrupt Link [LNKA] (IRQs 9 10 *11)
[   10.856099] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *11
[   10.856478] ACPI: PCI Interrupt Link [LNKC] (IRQs 9 10 11) *0, disabled.
[   10.856935] ACPI: PCI Interrupt Link [LNKD] (IRQs *5 7 9 10 11)
[   10.857393] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
[   10.858112] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[   10.858834] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[   10.859557] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 9 10 11 12 14 15)
[   10.860307] Linux Plug and Play Support v0.97 (c) Adam Belay
[   10.860457] pnp: PnP ACPI init
[   10.860576] ACPI: bus type pnp registered
[   10.878488] pnpacpi: exceeded the max number of mem resources: 12
[   10.904597] pnp: PnP ACPI: found 13 devices
[   10.904714] ACPI: ACPI bus type pnp unregistered
[   10.905038] SCSI subsystem initialized
[   10.905204] libata version 3.00 loaded.
[   10.905344] usbcore: registered new interface driver usbfs
[   10.905503] usbcore: registered new interface driver hub
[   10.905666] usbcore: registered new device driver usb
[   10.906004] PCI: Using ACPI for IRQ routing
[   10.906122] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   10.910112] Bluetooth: Core ver 2.11
[   10.910352] NET: Registered protocol family 31
[   10.910469] Bluetooth: HCI device and connection manager initialized
[   10.910591] Bluetooth: HCI socket layer initialized
[   10.914136] PCI-GART: No AMD northbridge found.
[   10.914258] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[   10.914501] hpet0: 3 64-bit timers, 14318180 Hz
[    9.248892] Time: hpet clocksource has been installed.
[    9.249021] Switched to high resolution mode on CPU 0
[   10.916102] Switched to high resolution mode on CPU 1
[   10.920037] system 00:00: iomem range 0x0-0x9fbff could not be reserved
[   10.920160] system 00:00: iomem range 0x9fc00-0x9ffff could not be reserved
[   10.920281] system 00:00: iomem range 0xc0000-0xcffff has been reserved
[   10.920401] system 00:00: iomem range 0xe0000-0xfffff has been reserved
[   10.920521] system 00:00: iomem range 0x100000-0x3f6d33ff could not be reserved
[   10.920718] system 00:00: iomem range 0x3f6d3400-0x3f6fffff could not be reserved
[   10.920919] system 00:00: iomem range 0x3f700000-0x3f7fffff could not be reserved
[   10.921123] system 00:00: iomem range 0x3f700000-0x3fefffff could not be reserved
[   10.921323] system 00:00: iomem range 0xffb00000-0xffffffff could not be reserved
[   10.921522] system 00:00: iomem range 0xfec00000-0xfec0ffff could not be reserved
[   10.921722] system 00:00: iomem range 0xfee00000-0xfee0ffff could not be reserved
[   10.921925] system 00:00: iomem range 0xfed20000-0xfed9ffff could not be reserved
[   10.922134] system 00:02: ioport range 0x4d0-0x4d1 has been reserved
[   10.922255] system 00:02: ioport range 0x1000-0x1005 has been reserved
[   10.922376] system 00:02: ioport range 0x1008-0x100f has been reserved
[   10.922500] system 00:03: ioport range 0xf400-0xf4fe has been reserved
[   10.922621] system 00:03: ioport range 0x1006-0x1007 has been reserved
[   10.922744] system 00:03: ioport range 0x100a-0x1059 could not be reserved
[   10.922865] system 00:03: ioport range 0x1060-0x107f has been reserved
[   10.922986] system 00:03: ioport range 0x1080-0x10bf has been reserved
[   10.923112] system 00:03: ioport range 0x10c0-0x10df has been reserved
[   10.923233] system 00:03: ioport range 0x1010-0x102f has been reserved
[   10.923353] system 00:03: ioport range 0x809-0x809 has been reserved
[   10.923479] system 00:08: ioport range 0xc80-0xcff could not be reserved
[   10.923600] system 00:08: ioport range 0x910-0x91f has been reserved
[   10.923720] system 00:08: ioport range 0x920-0x92f has been reserved
[   10.923843] system 00:08: ioport range 0xcb0-0xcbf has been reserved
[   10.923964] system 00:08: ioport range 0x930-0x97f has been reserved
[   10.924094] system 00:0b: iomem range 0xfed00000-0xfed003ff has been reserved
[   10.924865] ACPI: PCI Interrupt 0000:0c:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[   10.925116] PCI: Setting latency timer of device 0000:0c:00.0 to 64
[   10.949894] ssb: Sonics Silicon Backplane found on PCI device 0000:0c:00.0
[   10.950067] PCI: Bridge: 0000:00:1c.0
[   10.950182]   IO window: disabled.
[   10.950301]   MEM window: disabled.
[   10.950418]   PREFETCH window: disabled.
[   10.950538] PCI: Bridge: 0000:00:1c.1
[   10.950652]   IO window: disabled.
[   10.950776]   MEM window: efd00000-efdfffff
[   10.953105]   PREFETCH window: disabled.
[   10.953236] PCI: Bus 3, cardbus bridge: 0000:02:01.0
[   10.953353]   IO window: 00001400-000014ff
[   10.953471]   IO window: 00001800-000018ff
[   10.953591]   PREFETCH window: 50000000-53ffffff
[   10.953715]   MEM window: 54000000-57ffffff
[   10.953832] PCI: Bridge: 0000:00:1e.0
[   10.953951]   IO window: disabled.
[   10.954069]   MEM window: efc00000-efcfffff
[   10.954187]   PREFETCH window: disabled.
[   10.954339] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
[   10.954573] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   10.954597] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
[   10.954834] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[   10.954848] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[   10.954865] PCI: Enabling device 0000:02:01.0 (0000 -> 0003)
[   10.954993] ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 19 (level, low) -> IRQ 19
[   10.955240] NET: Registered protocol family 2
[   10.965010] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[   10.965387] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[   10.966413] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[   10.967184] TCP: Hash tables configured (established 131072 bind 65536)
[   10.967305] TCP reno registered
[   10.971034] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
[   10.971906] Total HugeTLB memory allocated, 0
[   10.975293] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   10.975741] NTFS driver 2.1.29 [Flags: R/O].
[   10.976009] fuse init (API version 7.9)
[   10.976584] io scheduler noop registered
[   10.976707] io scheduler deadline registered
[   10.976956] io scheduler cfq registered (default)
[   10.977087] Boot video device is 0000:00:02.0
[   10.978612] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   10.978678] assign_interrupt_mode Found MSI capability
[   10.978862] Allocate Port Service[0000:00:1c.0:pcie00]
[   10.978914] Allocate Port Service[0000:00:1c.0:pcie02]
[   10.978955] Allocate Port Service[0000:00:1c.0:pcie03]
[   10.979064] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[   10.979124] assign_interrupt_mode Found MSI capability
[   10.979288] Allocate Port Service[0000:00:1c.1:pcie00]
[   10.979328] Allocate Port Service[0000:00:1c.1:pcie02]
[   10.979372] Allocate Port Service[0000:00:1c.1:pcie03]
[   10.980220] ACPI: AC Adapter [AC] (on-line)
[   11.007676] ACPI: Battery Slot [BAT0] (battery present)
[   11.007848] ACPI: Battery Slot [BAT1] (battery absent)
[   11.008102] input: Lid Switch as /class/input/input0
[   11.008630] ACPI: Lid Switch [LID]
[   11.008816] input: Power Button (CM) as /class/input/input1
[   11.008945] ACPI: Power Button (CM) [PBTN]
[   11.009126] input: Sleep Button (CM) as /class/input/input2
[   11.009245] ACPI: Sleep Button (CM) [SBTN]
[   11.009811] ACPI: SSDT 3F6D4172, 0202 (r1  PmRef  Cpu0Ist     3000 INTL 20050624)
[   11.010300] ACPI: SSDT 3F6D3F27, 01C6 (r1  PmRef  Cpu0Cst     3001 INTL 20050624)
[    9.344283] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    9.344528] ACPI: Processor [CPU0] (supports 8 throttling states)
[    9.344989] ACPI: SSDT 3F6D4374, 00C4 (r1  PmRef  Cpu1Ist     3000 INTL 20050624)
[    9.345458] ACPI: SSDT 3F6D40ED, 0085 (r1  PmRef  Cpu1Cst     3000 INTL 20050624)
[   11.013089] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[   11.013334] ACPI: Processor [CPU1] (supports 8 throttling states)
[   11.026426] ACPI: Thermal Zone [THM] (28 C)
[   11.058652] Real Time Clock Driver v1.12ac
[   11.058939] hpet_resources: 0xfed00000 is busy
[   11.059729] intel_rng: FWH not detected
[   11.060385] Linux agpgart interface v0.102
[   11.060602] agpgart: Detected an Intel 945GM Chipset.
[   11.061733] agpgart: Detected 7932K stolen memory.
[   11.077243] agpgart: AGP aperture is 256M @ 0xd0000000
[   11.077434] [drm] Initialized drm 1.1.0 20060810
[   11.077555] intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM chipsets
[   11.077767] intelfb: Version 0.9.4
[   11.077958] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
[   11.078196] intelfb: 00:02.0: Intel(R) 945GM, aperture size 256MB, stolen memory 7932kB
[   11.081999] intelfb: Non-CRT device is enabled ( LVDS port ).  Disabling mode switching.
[   11.082268] intelfb: Video mode must be programmed at boot time.
[   11.085826] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
[   11.086232] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   11.087046] 00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   11.088000] RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
[   11.088546] loop: module loaded
[   11.088816] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[   11.115592] ssb: Sonics Silicon Backplane found on PCI device 0000:02:00.0
[   11.115771] b44.c:v2.0
[   11.123801] eth0: Broadcom 44xx/47xx 10/100BaseT Ethernet 00:1c:23:a2:a0:6d
[   11.123926] PPP generic driver version 2.4.2
[   11.124114] PPP Deflate Compression module registered
[   11.124230] PPP BSD Compression module registered
[   11.124385] PPP MPPE Compression module registered
[   11.124508] NET: Registered protocol family 24
[   11.124630] PPPoL2TP kernel driver, V1.0
[   11.124752] tun: Universal TUN/TAP device driver, 1.6
[   11.124869] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   11.125108] b43-phy0: Broadcom 4311 WLAN found
[   11.139426] b43-phy0 debug: Found PHY: Analog 4, Type 2, Revision 8
[   11.139449] b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
[   11.146506] b43-phy0 debug: DebugFS (CONFIG_DEBUG_FS) not enabled in kernel config
[   11.146805] phy0: Selected rate control algorithm 'simple'
[   11.147326] Driver 'sd' needs updating - please use bus_type methods
[   11.147486] Driver 'sr' needs updating - please use bus_type methods
[   11.147715] ata_piix 0000:00:1f.2: version 2.12
[   11.147721] ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
[   11.147990] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 17 (level, low) -> IRQ 17
[   11.148250] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[   11.148329] scsi0 : ata_piix
[   11.148522] scsi1 : ata_piix
[   11.150406] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xbfa0 irq 14
[   11.150528] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xbfa8 irq 15
[    9.701611] ata1.00: ATA-8: WDC WD1200BEVS-75UST0, 01.01A01, max UDMA/133
[    9.701733] ata1.00: 234441648 sectors, multi 8: LBA48 NCQ (depth 0/32)
[    9.708687] ata1.00: configured for UDMA/133
[   11.699070] ata2.00: ATAPI: TSSTcorp DVD+/-RW TS-L632H, D200, max UDMA/33
[   11.874774] ata2.00: configured for UDMA/33
[   10.208177] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1200BEVS-7 01.0 PQ: 0 ANSI: 5
[   10.208511] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
[   10.208650] sd 0:0:0:0: [sda] Write Protect is off
[   10.208769] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   10.208786] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   10.209031] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
[   10.209160] sd 0:0:0:0: [sda] Write Protect is off
[   10.209278] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   10.209294] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   10.209495]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 >
[   10.303680] sd 0:0:0:0: [sda] Attached SCSI disk
[   10.303885] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   10.307355] scsi 1:0:0:0: CD-ROM            TSSTcorp DVD+-RW TS-L632H D200 PQ: 0 ANSI: 5
[   11.995153] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[   11.995275] Uniform CD-ROM driver Revision: 3.20
[   11.995493] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   11.995582] sr 1:0:0:0: Attached scsi generic sg1 type 5
[   11.995765] I2O subsystem v1.325
[   11.995880] i2o: max drivers = 8
[   11.996155] Fusion MPT base driver 3.04.06
[   11.996276] Copyright (c) 1999-2007 LSI Corporation
[   11.996397] Fusion MPT SPI Host driver 3.04.06
[   11.996822] ACPI: PCI Interrupt 0000:02:01.4[A] -> GSI 19 (level, low) -> IRQ 19
[   12.048167] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[efcfd000-efcfd7ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
[   12.050483] ieee1394: raw1394: /dev/raw1394 device initialized
[   12.050681] Yenta: CardBus bridge found at 0000:02:01.0 [1028:01d4]
[   12.050822] Yenta O2: res at 0x94/0xD4: 00/ea
[   12.050938] Yenta O2: enabling read prefetch/write burst
[   12.173976] Yenta: ISA IRQ mask 0x0cb8, PCI irq 19
[   12.174095] Socket status: 30000006
[   12.174216] Yenta: Raising subordinate bus# of parent bus (#02) from #03 to #06
[   12.174417] pcmcia: parent PCI bridge Memory window: 0xefc00000 - 0xefcfffff
[   12.425694] usbmon: debugfs is not available
[   12.425862] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 20
[   12.426644] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[   12.426650] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   12.426878] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[   12.430973] ehci_hcd 0000:00:1d.7: debug port 1
[   12.431096] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[   12.431106] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xffa80000
[   12.440564] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   12.440964] usb usb1: configuration #1 chosen from 1 choice
[   12.441133] hub 1-0:1.0: USB hub found
[   12.441253] hub 1-0:1.0: 8 ports detected
[   12.541511] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[   12.541561] USB Universal Host Controller Interface driver v3.0
[   12.541752] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 20
[   12.541990] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[   12.541994] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   12.542165] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[   12.542389] uhci_hcd 0000:00:1d.0: irq 20, io base 0x0000bf80
[   12.542662] usb usb2: configuration #1 chosen from 1 choice
[   12.542834] hub 2-0:1.0: USB hub found
[   12.542952] hub 2-0:1.0: 2 ports detected
[   12.643385] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 21 (level, low) -> IRQ 21
[   12.643625] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[   12.643629] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   12.643789] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[   12.644015] uhci_hcd 0000:00:1d.1: irq 21, io base 0x0000bf60
[   12.644282] usb usb3: configuration #1 chosen from 1 choice
[   12.644447] hub 3-0:1.0: USB hub found
[   12.644572] hub 3-0:1.0: 2 ports detected
[   12.745229] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 22 (level, low) -> IRQ 22
[   12.745470] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[   12.745473] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   12.747847] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[   12.748072] uhci_hcd 0000:00:1d.2: irq 22, io base 0x0000bf40
[   11.081332] usb 1-2: new high speed USB device using ehci_hcd and address 2
[   12.748489] usb usb4: configuration #1 chosen from 1 choice
[   12.748653] hub 4-0:1.0: USB hub found
[   12.748772] hub 4-0:1.0: 2 ports detected
[   12.849090] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 23 (level, low) -> IRQ 23
[   12.849338] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[   12.849341] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   12.849505] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[   12.849734] uhci_hcd 0000:00:1d.3: irq 23, io base 0x0000bf20
[   12.850020] usb usb5: configuration #1 chosen from 1 choice
[   12.850185] hub 5-0:1.0: USB hub found
[   12.850311] hub 5-0:1.0: 2 ports detected
[   11.194688] usb 1-2: configuration #1 chosen from 1 choice
[   11.194976] hub 1-2:1.0: USB hub found
[   11.195179] hub 1-2:1.0: 4 ports detected
[   11.638762] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[474fc00001ad9c70]
[   11.761396] usb 4-2: new low speed USB device using uhci_hcd and address 2
[   11.923389] usb 4-2: configuration #1 chosen from 1 choice
[   13.593641] usbcore: registered new interface driver usblp
[   13.593763] Initializing USB Mass Storage driver...
[   13.593927] usbcore: registered new interface driver usb-storage
[   13.594052] USB Mass Storage support registered.
[   13.594275] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[   11.930335] serio: i8042 KBD port at 0x60,0x64 irq 1
[   11.930462] serio: i8042 AUX port at 0x60,0x64 irq 12
[   11.930676] mice: PS/2 mouse device common for all mice
[   11.944662] input: AT Translated Set 2 keyboard as /class/input/input3
[   13.622242] i2c /dev entries driver
[   12.238669] input: PS/2 Mouse as /class/input/input4
[   12.264504] input: AlpsPS/2 ALPS GlidePoint as /class/input/input5
[   13.940947] device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: dm-devel@redhat.com
[   13.941238] device-mapper: multipath: version 1.0.5 loaded
[   13.941358] device-mapper: multipath round-robin: version 1.0.0 loaded
[   13.941479] device-mapper: multipath emc: version 0.0.3 loaded
[   13.941621] device-mapper: multipath rdac: rdac: version 0.4 loaded
[   13.942001] cpuidle: using governor ladder
[   14.941499] cpuidle: using governor menu
[   14.941736] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   13.293560] input: Logitech USB Receiver as /class/input/input6
[   13.300380] input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:1d.2-2
[   13.300658] usbcore: registered new interface driver usbhid
[   13.300781] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   13.300972] Advanced Linux Sound Architecture Driver Version 1.0.15 (Tue Nov 20 19:16:42 2007 UTC).
[   13.301546] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 21 (level, low) -> IRQ 21
[   13.302350] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   13.412332] ALSA device list:
[   13.412463]   #0: HDA Intel at 0xefebc000 irq 21
[   13.412724] oprofile: using NMI interrupt.
[   13.412849] Netfilter messages via NETLINK v0.30.
[   13.413003] nf_conntrack version 0.5.0 (8192 buckets, 32768 max)
[   13.413444] ctnetlink v0.93: registering with nfnetlink.
[   13.413687] GRE over IPv4 tunneling driver
[   13.414473] ip_tables: (C) 2000-2006 Netfilter Core Team
[   13.414613] ClusterIP Version 0.8 loaded successfully
[   13.414742] arp_tables: (C) 2002 David S. Miller
[   13.414866] TCP cubic registered
[   13.414988] NET: Registered protocol family 1
[   13.415328] NET: Registered protocol family 10
[   13.417442] IPv6 over IPv4 tunneling driver
[   13.418366] NET: Registered protocol family 17
[   13.418769] RPC: Registered udp transport module.
[   13.418886] RPC: Registered tcp transport module.
[   13.419003] ieee80211: 802.11 data/management/control stack, git-1.1.13
[   13.419133] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[   13.419334] ieee80211_crypt: registered algorithm 'NULL'
[   13.419336] ieee80211_crypt: registered algorithm 'WEP'
[   13.419338] ieee80211_crypt: registered algorithm 'CCMP'
[   13.419340] ieee80211_crypt: registered algorithm 'TKIP'
[   13.419855] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[   15.159422] kjournald starting.  Commit interval 5 seconds
[   13.492652] EXT3-fs: mounted filesystem with ordered data mode.
[   13.492674] VFS: Mounted root (ext3 filesystem) readonly.
[   13.492700] Freeing unused kernel memory: 288k freed
[   17.084419] EXT3 FS on sda7, internal journal
[   30.202837] kjournald starting.  Commit interval 5 seconds
[   30.204385] EXT3 FS on dm-0, internal journal
[   30.204395] EXT3-fs: mounted filesystem with ordered data mode.
[   30.263485] NTFS volume version 3.1.
[   30.366837] Adding 2104472k swap on /dev/sda6.  Priority:-1 extents:1 across:2104472k
[   38.773995] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   42.276760] b44: eth0: Link is up at 100 Mbps, full duplex.
[   42.276766] b44: eth0: Flow control is off for TX and off for RX.
[   42.281446] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   45.085594] b43-phy0 debug: Loading firmware version 351.126 (2006-07-29 05:54:02)
[   45.976994] b43-phy0 debug: Chip initialized
[   45.977158] b43-phy0 debug: 32-bit DMA initialized
[   45.984867] b43-phy0 debug: Wireless interface started
[   47.673518] b43-phy0 debug: Adding Interface type 2
[   47.682378] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   52.716195] eth0: no IPv6 routers present
[   60.636199] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   60.636280] [drm] Initialized i915 1.6.0 20060119 on minor 0

--Boundary-00=_Htw8HNUbDqUPYCn--
