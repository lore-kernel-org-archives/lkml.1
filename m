Return-Path: <linux-kernel-owner+w=401wt.eu-S933581AbXCEVTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933581AbXCEVTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 16:19:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933592AbXCEVTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 16:19:34 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:21415 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933581AbXCEVTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 16:19:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:message-id:sender;
        b=Qsn6N/0/xyEaLZzUCabGe+zmyLxBw+zuD0uMv52tvNoI1rYCD79O/Xu4XaiEiB1rhRE0Z7XU/kJwEwhykoJS2CYT7VG5nIPpbrDP2M4oDeoBVu5D/fuDQ0HQucYq/wvqCUfujw8rfwqkDyDJhU0gWkgUpZjj2q5Kp1V5ugLd8ek=
From: Eric Lacombe <tuxiko@free.fr>
To: Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: Linux 2.6.19.2: maybe a bug inside the r8169 network driver (was Re: Linux 2.6.19.2: Freeze with CIFS mount)
Date: Mon, 5 Mar 2007 22:19:23 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Steve French <sfrench@us.ibm.com>
References: <OFC7B98576.0C582E30-ON87257274.0014583D-86257274.00153815@us.ibm.com> <20070213203047.GA4158@electric-eye.fr.zoreil.com> <200702141149.53041.tuxiko@free.fr>
In-Reply-To: <200702141149.53041.tuxiko@free.fr>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_blI7FpxQTrhDFsd"
Message-Id: <200703052219.23439.tuxiko@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_blI7FpxQTrhDFsd
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

Sorry for the long time without giving new information about the problem/bug, 
but I wasn't able to trigger it since now.

Well, this time, my system freeze on a 2.6.20.1.
I try to use the magic sysrq (which works fine when my system is running), but 
nothing happen (unraw, reboot, etc.).

Also, as I used the nvidia proprietary module when I reported this problem, 
I've not open PR at bugzilla.kernel.org.

During 5 days, my system on a fresh 2.6.20.1 hasn't freezed without the nvidia 
proprietary driver (just the nv driver from X).
So, I thought it was ok and I modprobe the nvidia driver (cause with nv I have 
some minor display problems). Since today, after 7 days of well-behavior, my 
system has freezed again.

So, now, I check again to see if it could crash without the nvidia driver... 
Grrrr.. 

I will also do what you recommend here :

> > 6. You may setup a cron to monitor an ethtool dump of the register of
> >    the 8169 at regular interval. ifconfig and /proc/interrupts could
> >    exhibit some unusual drift as time passes on too.


I join the result of dmesg as wanted. Feel free to ask more information if 
needed.
(the cifs log looks like before so I haven't joined it)

Also, if you have some new ideas about the problem or what I could try to 
trigger it more frequently (I already wake up the NAS as more as I can, but 
maybe I could write a script to do that), I would be thankful.

Best regards,

	Eric Lacombe

On Wednesday 14 February 2007 11:49:52 Eric Lacombe wrote:
> On Tuesday 13 February 2007 21:30:47 Francois Romieu wrote:
> > Eric Lacombe <tuxiko@free.fr> :
> > [...]
> >
> > > That problem also remind me that when I compiled this driver without
> > > the "CONFIG_NET_ETHERNET" (in the section "Ethernet (10 or 100Mbit)"),
> > > I have really poor performance with the net device. Maybe it is
> > > related, or not ;)
> > >
> > > If it gives you more ideas ?
> > > Maybe it could be interesting to know about the r8169 maintainer, but I
> > > dont know who he is.
> >
> > 1. $ ls
> >    arch     crypto         include  kernel       mm              scripts
> >    block    Documentation  init     lib          net             security
> >    COPYING  drivers        ipc      MAINTAINERS  README          sound
> >    CREDITS  fs             Kbuild   Makefile     REPORTING-BUGS  usr
> >
> >    The maintainer of the r8169 driver is listed in the MAINTAINERS file.
>
> I see, thanks ;)
>
> (I thought the MAINTAINERS file was not fully maintained ;)
>
> > 2. Disabling CONFIG_NET_ETHERNET is a bad idea. Don't do that.
>
> ok, but why having it only inside the "ethernet 100" menu ?
> It is misleading, no ?
>
> > 3. See tethereal -w or tcpdump on the adequate interface to save a
> >    traffic dump.
>
> yep, but the problem is that I cant do that from the NAS Box. I will try to
> monitor the traffic via the system that will freeze... For the moment I
> can't monitor the net traffic from an alternate PC, but soon.
>
> > 4. Are you using a binary module for your video adapter ?
>
> yes, I suppose that I have to unload this one before doing further tests.
>
> > 5. How does the 2.6.20 version of the r8169 driver behave ?
>
> I don't have installed it yet, but I'll do it this evening.
>
> > 6. You may setup a cron to monitor an ethtool dump of the register of
> >    the 8169 at regular interval. ifconfig and /proc/interrupts could
> >    exhibit some unusual drift as time passes on too.
>
> I will do that. When I could put a third system to monitor the traffic, I
> will make "the system that freeze" keep sending that information to it.
>
> > 7. A dmesg would be welcome.
>
> I could do that, this evening.
>
> > 8. Please open a PR at bugzilla.kernel.org.
>
> ok
>
> > |...]
> > |
> > > > There are various ways to analyze system hangs including (at least in
> > > > some cases) getting a system dump which
> > > > can be used to isolate the failing location - hopefully
> > >
> > > I would like to have more detailed help, if possible.
> >
> > CONFIG_MAGIC_SYSRQ is set. Check that the magic sysrq is not disabled at
> > runtime through /etc/sysctl.conf. See Documentation/sysrq.txt for
> > details.
>
> ok
>
> > Please keep Steve French in the loop.
>
> ok
>
> Thanks for your response ;)
>
> 	Eric



--Boundary-00=_blI7FpxQTrhDFsd
Content-Type: text/plain;
  charset="iso-8859-1";
  name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg"

Linux version 2.6.20.1 (root@tuxstation) (gcc version 4.1.1 (Gentoo 4.1.1-r3)) #16 SMP PREEMPT Wed Feb 21 01:32:51 CET 2007
Command line: root=/dev/sda3 vga=791
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
 BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ffa0000 (usable)
 BIOS-e820: 000000007ffa0000 - 000000007ffae000 (ACPI data)
 BIOS-e820: 000000007ffae000 - 000000007ffe0000 (ACPI NVS)
 BIOS-e820: 000000007ffe0000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 158) 0 entries of 256 used
Entering add_active_range(0, 256, 524192) 1 entries of 256 used
end_pfn_map = 1048576
DMI 2.4 present.
ACPI: RSDP (v002 ACPIAM                                ) @ 0x00000000000fa980
ACPI: XSDT (v001 A M I  OEMXSDT  0x09000606 MSFT 0x00000097) @ 0x000000007ffa0100
ACPI: FADT (v003 A M I  OEMFACP  0x09000606 MSFT 0x00000097) @ 0x000000007ffa0290
ACPI: MADT (v001 A M I  OEMAPIC  0x09000606 MSFT 0x00000097) @ 0x000000007ffa0390
ACPI: MCFG (v001 A M I  OEMMCFG  0x09000606 MSFT 0x00000097) @ 0x000000007ffa0400
ACPI: OEMB (v001 A M I  AMI_OEM  0x09000606 MSFT 0x00000097) @ 0x000000007ffae040
ACPI: DSDT (v001  A0637 A0637000 0x00000000 INTL 0x20060113) @ 0x0000000000000000
Entering add_active_range(0, 0, 158) 0 entries of 256 used
Entering add_active_range(0, 256, 524192) 1 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
early_node_map[2] active PFN ranges
    0:        0 ->      158
    0:      256 ->   524192
On node 0 totalpages: 524094
  DMA zone: 56 pages used for memmap
  DMA zone: 1781 pages reserved
  DMA zone: 2161 pages, LIFO batch:0
  DMA32 zone: 7110 pages used for memmap
  DMA32 zone: 512986 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
Nosave address range: 000000000009e000 - 000000000009f000
Nosave address range: 000000000009f000 - 00000000000a0000
Nosave address range: 00000000000a0000 - 00000000000e4000
Nosave address range: 00000000000e4000 - 0000000000100000
Allocating PCI resources starting at 88000000 (gap: 80000000:7ee00000)
PERCPU: Allocating 32000 bytes of per cpu data
Built 1 zonelists.  Total pages: 515147
Kernel command line: root=/dev/sda3 vga=791
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Console: colour dummy device 80x25
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Checking aperture...
Memory: 2057128k/2096768k available (4023k kernel code, 39028k reserved, 2080k data, 272k init)
Calibrating delay using timer specific routine.. 4826.17 BogoMIPS (lpj=8040276)
Security Framework v1.0.0 initialized
Capability LSM initialized
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
using mwait in idle threads.
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
Freeing SMP alternatives: 32k freed
ACPI: Core revision 20060707
Using local APIC timer interrupts.
result 16628404
Detected 16.628 MHz APIC timer.
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4790.10 BogoMIPS (lpj=7980964)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz stepping 06
Brought up 2 CPUs
testing NMI watchdog ... OK.
time.c: Using 3.579545 MHz WALL PM GTOD PIT/TSC timer.
time.c: Detected 2394.493 MHz processor.
migration_cost=18
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: Using configuration type 1
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 0480-04bf claimed by ICH6 GPIO
Boot video device is 0000:01:00.0
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 *15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 *14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: ACPI device : hid PNP0A08
pnp: ACPI device : hid PNP0C01
pnp: ACPI device : hid PNP0200
pnp: ACPI device : hid PNP0B00
pnp: ACPI device : hid PNP0800
pnp: ACPI device : hid PNP0C04
pnp: ACPI device : hid PNP0501
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0401
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0C02
pnp: ACPI device : hid PNP0C01
pnp: PnP ACPI: found 13 devices
SCSI subsystem initialized
libata version 2.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
PCI-GART: No AMD northbridge found.
pnp: the driver 'system' has been registered
pnp: match found with the PnP device '00:01' and the driver 'system'
pnp: match found with the PnP device '00:07' and the driver 'system'
pnp: 00:07: ioport range 0x290-0x297 has been reserved
pnp: match found with the PnP device '00:08' and the driver 'system'
pnp: match found with the PnP device '00:0a' and the driver 'system'
pnp: match found with the PnP device '00:0b' and the driver 'system'
pnp: match found with the PnP device '00:0c' and the driver 'system'
ACPI: PCI Interrupt 0000:04:03.0[A] -> GSI 21 (level, low) -> IRQ 21
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[21]  MMIO=[feaff000-feaff7ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: fa800000-fe8fffff
  PREFETCH window: bfd00000-dfcfffff
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: dfd00000-dfdfffff
PCI: Bridge: 0000:00:1c.3
  IO window: disabled.
  MEM window: fe900000-fe9fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: c000-cfff
  MEM window: fea00000-feafffff
  PREFETCH window: dfe00000-dfefffff
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1c.3 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
Total HugeTLB memory allocated, 0
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
fuse init (API version 7.8)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: Setting latency timer of device 0000:00:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:01.0:pcie00]
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
PCI: Setting latency timer of device 0000:00:1c.3 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.3:pcie00]
Allocate Port Service[0000:00:1c.3:pcie02]
vesafb: framebuffer at 0xc0000000, mapped to 0xffffc20000080000, using 3072k, total 262144k
vesafb: mode is 1024x768x16, linelength=2048, pages=1
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
vga16fb: initializing
vga16fb: mapped to 0xffff8100000a0000
fb1: VGA16 VGA frame buffer device
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI (exconfig-0455): Dynamic SSDT Load - OemId [   AMI] OemTableId [  CPU1PM] [20060707]
ACPI (exconfig-0455): Dynamic SSDT Load - OemId [   AMI] OemTableId [  CPU2PM] [20060707]
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.101 (c) Dave Jones
agpgart: Detected an Intel 965G Chipset.
agpgart: AGP aperture is 256M @ 0x0
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
pnp: the driver 'serial' has been registered
pnp: match found with the PnP device '00:06' and the driver 'serial'
00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
loop: loaded (max 8 devices)
PPP generic driver version 2.4.2
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
ACPI: PCI Interrupt 0000:04:01.0[A] -> GSI 22 (level, low) -> IRQ 22
eth0: RTL8169s/8110s at 0xffffc2000003cc00, 00:13:46:3b:e5:78, IRQ 22
netconsole: not configured, aborting
Linux video capture interface: v2.00
bttv: driver version 0.9.16 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
ACPI: PCI Interrupt 0000:04:02.0[A] -> GSI 23 (level, low) -> IRQ 23
bttv0: Bt878 (rev 17) at 0000:04:02.0, irq: 23, latency: 64, mmio: 0xdfefe000
bttv0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb
bttv0: using: Hauppauge (bt878) [card=10,autodetected]
bttv0: gpio: en=00000000, out=00000000 in=00ffffdb [init]
bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
tveeprom 0-0050: Hauppauge model 44906, rev D109, serial# 6249933
tveeprom 0-0050: tuner model is Philips FI1216MF MK2 (idx 9, type 3)
tveeprom 0-0050: TV standards PAL(B/G) SECAM(L/L') (eeprom 0x24)
tveeprom 0-0050: audio processor is None (idx 0)
tveeprom 0-0050: has radio
bttv0: Hauppauge eeprom indicates model#44906
bttv0: using tuner=3
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: registered device radio0
bttv0: PLL: 28636363 => 35468950 .. ok
input: i2c IR (Hauppauge) as /class/input/input2
ir-kbd-i2c: i2c IR (Hauppauge) detected at i2c-0/0-0018/ir0 [bt878 #0 [sw]]
tuner 0-0061: chip found @ 0xc2 (bt878 #0 [sw])
tuner 0-0061: type set to 3 (Philips (SECAM+PAL_BG) (FI1216MF, FM1216MF, FR1216MF))
tuner 0-0061: type set to 3 (Philips (SECAM+PAL_BG) (FI1216MF, FM1216MF, FR1216MF))
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Probing IDE interface ide0...
Probing IDE interface ide1...
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0011d80000df5890]
ahci 0000:00:1f.2: version 2.0
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1f.2 to 64
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq ilck stag pm led clo pmp pio slum part 
ata1: SATA max UDMA/133 cmd 0xFFFFC20000056900 ctl 0x0 bmdma 0x0 irq 316
ata2: SATA max UDMA/133 cmd 0xFFFFC20000056980 ctl 0x0 bmdma 0x0 irq 316
ata3: SATA max UDMA/133 cmd 0xFFFFC20000056A00 ctl 0x0 bmdma 0x0 irq 316
ata4: SATA max UDMA/133 cmd 0xFFFFC20000056A80 ctl 0x0 bmdma 0x0 irq 316
ata5: SATA max UDMA/133 cmd 0xFFFFC20000056B00 ctl 0x0 bmdma 0x0 irq 316
ata6: SATA max UDMA/133 cmd 0xFFFFC20000056B80 ctl 0x0 bmdma 0x0 irq 316
scsi0 : ahci
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7, max UDMA/133, 312581808 sectors: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
scsi1 : ahci
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATAPI, max UDMA/66
ata2.00: configured for UDMA/66
scsi2 : ahci
ata3: SATA link down (SStatus 0 SControl 300)
scsi3 : ahci
ata4: SATA link down (SStatus 0 SControl 300)
scsi4 : ahci
ata5: SATA link down (SStatus 0 SControl 300)
scsi5 : ahci
ata6: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      ST3160812SV      3.AS PQ: 0 ANSI: 5
SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
sd 0:0:0:0: Attached scsi disk sda
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: CD-ROM            PLEXTOR  DVDR   PX-760A   1.03 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
sr 1:0:0:0: Attached scsi generic sg1 type 5
ieee1394: raw1394: /dev/raw1394 device initialized
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfebff400
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfebff000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000e000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 17, io base 0x0000e080
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000d800
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d880
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000dc00
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
usb 5-1: new low speed USB device using uhci_hcd and address 2
usb 5-1: configuration #1 chosen from 1 choice
usb 5-2: new low speed USB device using uhci_hcd and address 3
usb 5-2: configuration #1 chosen from 1 choice
usbcore: registered new interface driver usblp
drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver hiddev
input: Logitech USB-PS/2 Optical Mouse as /class/input/input3
input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-1
input: NOVATEK USB Keyboard as /class/input/input4
input: USB HID v1.10 Keyboard [NOVATEK USB Keyboard] on usb-0000:00:1d.0-2
input: NOVATEK USB Keyboard as /class/input/input5
input,hiddev96: USB HID v1.10 Device [NOVATEK USB Keyboard] on usb-0000:00:1d.0-2
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
pnp: the driver 'i8042 kbd' has been registered
pnp: the driver 'i8042 aux' has been registered
pnp: the driver 'i8042 kbd' has been unregistered
pnp: the driver 'i8042 aux' has been unregistered
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
i2c /dev entries driver
PCI: Enabling device 0000:00:1f.3 (0001 -> 0003)
ACPI: PCI Interrupt 0000:00:1f.3[C] -> GSI 18 (level, low) -> IRQ 18
Advanced Linux Sound Architecture Driver Version 1.0.14rc1 (Tue Jan 09 09:56:17 2007 UTC).
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1b.0 to 64
hda_codec: Unknown model for AD1988, trying auto-probe from BIOS...
ALSA device list:
  #0: HDA Intel at 0xfebf8000 irq 22
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (8192 buckets, 65536 max)
IPv4 over IPv4 tunneling driver
ip_tables: (C) 2000-2006 Netfilter Core Team
ClusterIP Version 0.8 loaded successfully
arp_tables: (C) 2002 David S. Miller
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 272k freed
EXT3 FS on sda3, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on sda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 1020116k swap on /dev/sda2.  Priority:-1 extents:1 across:1020116k
r8169: eth0: link up
 CIFS VFS: Send error in SETFSUnixInfo = -5
 CIFS VFS: Send error in SETFSUnixInfo = -5
 CIFS VFS: Send error in SETFSUnixInfo = -5
 CIFS VFS: Send error in SETFSUnixInfo = -5
 CIFS VFS: Send error in SETFSUnixInfo = -5

--Boundary-00=_blI7FpxQTrhDFsd--
