Return-Path: <linux-kernel-owner+w=401wt.eu-S1755559AbXJKE7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbXJKE7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 00:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbXJKE7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 00:59:12 -0400
Received: from fed1rmpop112.cox.net ([68.230.241.16]:48868 "EHLO
	fed1rmpop112.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbXJKE7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 00:59:06 -0400
X-Greylist: delayed 6742 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Oct 2007 00:59:06 EDT
From: Kevin <spaceman__spiff@cox.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: ARPM shutdown oops (Re: [stable] [patch 09/12] Fix SMP poweroff hangs)
Date: Wed, 10 Oct 2007 20:05:01 -0700
User-Agent: KMail/1.9.7
References: <20071008180406.052382073@mini.kroah.org> <200710092359.47144.spaceman__spiff@cox.net> <alpine.LFD.0.999.0710100747120.3838@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710100747120.3838@woody.linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, Olof Johansson <olof@lixom.net>,
       Greg KH <gregkh@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>, Mark Lord <mlord@pobox.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, akpm@linux-foundation.org,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk, BDFL <volkerdi@slackware.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_eLZDHCxOdAfx+/Z"
Message-Id: <200710102005.02184.spaceman__spiff@cox.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_eLZDHCxOdAfx+/Z
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 10 October 2007 07:57:52 am you wrote:
> On Tue, 9 Oct 2007, Kevin wrote:
> > I don't own a digital camera but I did jot the info down by hand.
>
> Heh, yeah, that's what I used to do too (and still do if a camera isn't
> handy).
>
> > Call Trace:
> > [<c010e852>] apm_bios_call_simple+0x92/0x110
> > [<c0285a0>] acpi_hw_clear_gpe_block+00/0x32
> > [<c010e8ec>] set_system_power_state+0x1c/0x30
> > [<c010f93a>] apm_system_power_off+0x6a/0x80
> > [<c010f8d0>] apm_system_power_off+0x0/0x80
> > [<c010e434>] native_machine_power_off+0x14/0x20
> > [<c010e406>] machine_power_off+0x6/0x10
> > [<c0127cb9>] sys_reboot+0x99/0x140
> >...
> > Code: Bad EIP Value
> > EIP: [<00007825>] 0x7825 SS:ESP 0068:e7305de8
> > /etc/rc.d/rc.0: Line 261: 2796 Segmentation Fault   /sbin/poweroff
>
> Ahh. APM. That does explain the strange EIP register values: we're jumping
> into the BIOS, and the BIOS is doing something unexpected.
>
> However, that doesn't really explain the oops, because I don't think
> anything changed in APM from 2.6.22->23, and in particular, I don't think
> it has anything to do with the thing that caused problems for PPC.
>
> We did have some APM *detection* changes, and maybe APM wasn't even
> detected for you before, or it was detected differently. That would be due
> to the bootup changes, I'm Cc'ing Peter Anvin (and the kernel mailing
> list, in case somebody else see a pattern to this).
>
> Can you please
>  - try with APM turned off (APM really shouldn't be useful on any machines
>    built in the last ten years or so), just to verify that things work
>    without APM.

That fixed the problem. =20

>  - send the bootup "dmesg" output and a machine description (and please
>    keep people Cc'd - sending things just to me is a sure-fire way to get
>    things dropped eventually, if only because I'm a lazy clutz).

Both "dmesg" (before and after the fix) are attached.  Also, here is the=20
machine specs:

Gigabyte Main Board
Name	GA-K8NSC -939
Type / Chipset	Socket 939 / nVidia nForce3 250 Gb Chipset
Dimensions 	+++ 35 mm (58 mm radius) around the socket to the next capacito=
r=20
or other parts of the
mainboard - for further information see Fit for Fan.
The overall size is 305 x 245mm.
Slots	+++ 5x pci, 1x AGP (1.5V 4x/8x), 4x DDR PC2100 - PC3200 (max. 4GB RAM)
Connectors=09
+++ 1x Floppy, 4x UDMA133, 2x SATA150, 2x seriell, 1x parallel, 2x PS/2,
onBoard 10/100/1000 Mbps base-T Ethernet LAN (Marvell 8001),
8x USB 2.0/1.1 (4x internal but mounting bracket isn't included),
8-Channel AC'97 RealTek ALC850 onboard (1x int. CD in, 1x int. S/PDIF, ext.=
=20
Line in, ext. Mic, ext. Line out, int. optional connector for 8-Channel Aud=
io=20
Combo Kit, not included)
and 3x fan connectors (1x used for chipset fan).
Vcore	++++ BIOS between 0.80 Volt and 1.7 Volt in steps of 0.025 and 0.05=20
Volt / Jumper not available
Multiplier	++++ BIOS between 4x and 25x (max multi depends on used CPU) /=20
Jumper not available
=46SB	++++ BIOS between 200 and 455 MHz (AGP 66 - 100 MHz) / Jumper not=20
available
VIO/VDD	++++ VDDR +0.1 - +0.2 / VAGP +0.1 - +0.3 / V HT-Link +0.1 - +0.3=20



Home page:
http://www.gigabyte.com.tw/Products/Motherboard/Products_Overview.aspx?Prod=
uctID=3D1881


BIOS upgrade (F8)
http://www.gigabyte.com.tw/Support/Motherboard/BIOS_Model.aspx?ProductID=3D=
1881





Also lspci -v

root@fosters:/home/kevin# lspci -v
00:00.0 Host bridge: nVidia Corporation nForce3 250Gb Host Bridge (rev a1)
        Flags: bus master, 66MHz, fast devsel, latency 0
        Memory at f4000000 (32-bit, prefetchable) [size=3D32M]
        Capabilities: [44] HyperTransport: Slave or Primary Interface
        Capabilities: [c0] AGP version 2.0

00:01.0 ISA bridge: nVidia Corporation nForce3 250Gb LPC Bridge (rev a2)
        Subsystem: Giga-byte Technology Unknown device 0c11
        Flags: bus master, 66MHz, fast devsel, latency 0

00:01.1 SMBus: nVidia Corporation nForce 250Gb PCI System Management (rev a=
1)
        Subsystem: Giga-byte Technology Unknown device 0c11
        Flags: 66MHz, fast devsel, IRQ 11
        I/O ports at e400 [size=3D32]
        I/O ports at 1c00 [size=3D64]
        I/O ports at 2000 [size=3D64]
        Capabilities: [44] Power Management version 2

00:02.0 USB Controller: nVidia Corporation CK8S USB Controller (rev a1)=20
(prog-if 10 [OHCI])
        Subsystem: Giga-byte Technology Unknown device 5004
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 9
        Memory at fd003000 (32-bit, non-prefetchable) [size=3D4K]
        Capabilities: [44] Power Management version 2

00:02.1 USB Controller: nVidia Corporation CK8S USB Controller (rev a1)=20
(prog-if 10 [OHCI])
        Subsystem: Giga-byte Technology Unknown device 5004
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 9
        Memory at fd004000 (32-bit, non-prefetchable) [size=3D4K]
        Capabilities: [44] Power Management version 2

00:02.2 USB Controller: nVidia Corporation nForce3 EHCI USB 2.0 Controller=
=20
(rev a2) (prog-if 20 [EHCI])
        Subsystem: Giga-byte Technology Unknown device 5004
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 9
        Memory at fd005000 (32-bit, non-prefetchable) [size=3D256]
        Capabilities: [44] Debug port
        Capabilities: [80] Power Management version 2

00:06.0 Multimedia audio controller: nVidia Corporation nForce3 250Gb AC'97=
=20
Audio Controller (rev a1)
        Subsystem: Giga-byte Technology Unknown device a002
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 7
        I/O ports at bc00 [size=3D256]
        I/O ports at c000 [size=3D128]
        Memory at fd001000 (32-bit, non-prefetchable) [size=3D4K]
        Capabilities: [44] Power Management version 2

00:08.0 IDE interface: nVidia Corporation CK8S Parallel ATA Controller (v2.=
5)=20
(rev a2) (prog-if 8a [Master SecP PriP])
        Subsystem: Giga-byte Technology Unknown device 5002
        Flags: bus master, 66MHz, fast devsel, latency 0
        [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled]=
=20
[size=3D8]
        [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled]=
=20
[size=3D1]
        [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled]=
=20
[size=3D8]
        [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled]=
=20
[size=3D1]
        I/O ports at f000 [size=3D16]
        Capabilities: [44] Power Management version 2

00:0a.0 IDE interface: nVidia Corporation CK8S Serial ATA Controller (v2.5)=
=20
(rev a2) (prog-if 85 [Master SecO PriO])
        Subsystem: Giga-byte Technology Unknown device b002
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 11
        I/O ports at 09f0 [size=3D8]
        I/O ports at 0bf0 [size=3D4]
        I/O ports at 0970 [size=3D8]
        I/O ports at 0b70 [size=3D4]
        I/O ports at dc00 [size=3D16]
        I/O ports at e000 [size=3D128]
        Capabilities: [44] Power Management version 2

00:0b.0 PCI bridge: nVidia Corporation nForce3 250Gb AGP Host to PCI Bridge=
=20
(rev a2) (prog-if 00 [Normal decode])
        Flags: bus master, 66MHz, medium devsel, latency 16
        Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D=
10
        Memory behind bridge: f8000000-faffffff
        Prefetchable memory behind bridge: f6000000-f7ffffff

00:0e.0 PCI bridge: nVidia Corporation nForce3 250Gb PCI-to-PCI Bridge (rev=
=20
a2) (prog-if 00 [Normal decode])
        Flags: bus master, 66MHz, fast devsel, latency 0
        Bus: primary=3D00, secondary=3D02, subordinate=3D02, sec-latency=3D=
128
        I/O behind bridge: 0000a000-0000afff
        Memory behind bridge: fb000000-fcffffff
        Prefetchable memory behind bridge: 88000000-880fffff

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]=20
HyperTransport Technology Configuration
        Flags: fast devsel
        Capabilities: [80] HyperTransport: Host or Secondary Interface

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]=20
Address Map
        Flags: fast devsel

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRA=
M=20
Controller
        Flags: fast devsel

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]=20
Miscellaneous Control
        Flags: fast devsel

01:00.0 VGA compatible controller: Matrox Graphics, Inc. MGA G550 AGP (rev =
01)=20
(prog-if 00 [VGA])
        Subsystem: Matrox Graphics, Inc. Millennium G550 Dual Head DDR 32Mb
        Flags: bus master, medium devsel, latency 32, IRQ 5
        Memory at f6000000 (32-bit, prefetchable) [size=3D32M]
        Memory at f8000000 (32-bit, non-prefetchable) [size=3D16K]
        Memory at f9000000 (32-bit, non-prefetchable) [size=3D8M]
        [virtual] Expansion ROM at f8020000 [disabled] [size=3D128K]
        Capabilities: [dc] Power Management version 2
        Capabilities: [f0] AGP version 2.0

02:06.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1=20
Controller (rev 50) (prog-if 00 [UHCI])
        Subsystem: VIA Technologies, Inc. (Wrong ID) USB Controller
        Flags: bus master, medium devsel, latency 32, IRQ 4
        I/O ports at a000 [size=3D32]
        Capabilities: [80] Power Management version 2

02:06.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1=20
Controller (rev 50) (prog-if 00 [UHCI])
        Subsystem: VIA Technologies, Inc. (Wrong ID) USB Controller
        Flags: bus master, medium devsel, latency 32, IRQ 10
        I/O ports at a400 [size=3D32]
        Capabilities: [80] Power Management version 2

02:06.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 51) (prog-if 20=
=20
[EHCI])
        Subsystem: VIA Technologies, Inc. (Wrong ID) Unknown device 1234
        Flags: bus master, medium devsel, latency 32, IRQ 3
        Memory at fc004000 (32-bit, non-prefetchable) [size=3D256]
        Capabilities: [80] Power Management version 2

02:07.0 Multimedia controller: Philips Semiconductors SAA7130 Video Broadca=
st=20
Decoder (rev 01)
        Subsystem: Avermedia Technologies Inc AVerMedia DVD EZMaker
        Flags: bus master, medium devsel, latency 32, IRQ 10
        Memory at fc005000 (32-bit, non-prefetchable) [size=3D1K]
        Capabilities: [40] Power Management version 1

02:0b.0 Ethernet controller: Marvell Technology Group Ltd. 88E8001 Gigabit=
=20
Ethernet Controller (rev 13)
        Subsystem: Giga-byte Technology Marvell 88E8001 Gigabit Ethernet=20
Controller (Gigabyte)
        Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 10
        Memory at fc000000 (32-bit, non-prefetchable) [size=3D16K]
        I/O ports at a800 [size=3D256]
        [virtual] Expansion ROM at 88000000 [disabled] [size=3D128K]
        Capabilities: [48] Power Management version 2
        Capabilities: [50] Vital Product Data

root@fosters:/home/kevin#
=20


>  - what was the last kernel that worked (and if you can bisect the
>    problem, that would likely help enormously)


The last kernel I used was 6.2.22 the "dmesg" the file is attached:

dmesg 2.6.22 line 158 >  apm: overridden by ACPI.

dmesg, APM on, has no line > apm: overridden by ACPI.

Also, a diff -u file is enclosed in case it might help.


> Thanks,
>=20
>=20
> 		Linus

Hope this helps


Kevin

=2D-=20
=2D---------------------- ++ ---------------------------
                        Kevin Myers
=A0 =A0=A0=A0=A0  =A0 spaceman__spiff@cox.net
=A0=A0=A0 =A0http://members.cox.net/jwblack
=2D---------------------- ++ ---------------------------
=2D-
=20
Your Fortune:

The Killer Ducks are coming!!!

--Boundary-00=_eLZDHCxOdAfx+/Z
Content-Type: text/plain;
  charset="iso-8859-1";
  name="dmesg  APM off"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg  APM off"

Linux version 2.6.23-10.10.07 (root@dosxx) (gcc version 4.1.2) #2 Wed Oct 10 11:30:12 MST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fff0000 (usable)
 BIOS-e820: 000000007fff0000 - 000000007fff3000 (ACPI NVS)
 BIOS-e820: 000000007fff3000 - 0000000080000000 (ACPI data)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
Warning only 896MB will be used.
Use a HIGHMEM enabled kernel.
896MB LOWMEM available.
found SMP MP-table at 000f5060
Entering add_active_range(0, 0, 229376) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   229376
On node 0 totalpages: 229376
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI 2.3 present.
ACPI: RSDP 000F69F0, 0014 (r0 Nvidia)
ACPI: RSDT 7FFF3000, 002C (r1 Nvidia AWRDACPI 42302E31 AWRD  1010101)
ACPI: FACP 7FFF3040, 0074 (r1 Nvidia AWRDACPI 42302E31 AWRD  1010101)
ACPI: DSDT 7FFF30C0, 4AC4 (r1 NVIDIA AWRDACPI     1000 MSFT  100000C)
ACPI: FACS 7FFF0000, 0040
ACPI: APIC 7FFF7BC0, 007C (r1 Nvidia AWRDACPI 42302E31 AWRD  1010101)
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 15:15 APIC version 16
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
Using ACPI for processor (LAPIC) configuration information
Intel MultiProcessor Specification v1.4
    Virtual Wire compatibility mode.
OEM ID: OEM00000 Product ID: PROD00000000 APIC at: 0xFEE00000
I/O APIC #2 Version 17 at 0xFEC00000.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Processors: 1
Allocating PCI resources starting at 88000000 (gap: 80000000:7ec00000)
Built 1 zonelists in Zone order.  Total pages: 227584
Kernel command line: BOOT_IMAGE=dosxx ro root=805
mapped APIC to ffffb000 (fee00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2411.789 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 902652k/917504k available (4212k kernel code, 14368k reserved, 1513k data, 368k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffff5000 - 0xfffff000   (  40 kB)
    vmalloc : 0xf8800000 - 0xffff3000   ( 119 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc069a000 - 0xc06f6000   ( 368 kB)
      .data : 0xc051d39a - 0xc069785c   (1513 kB)
      .text : 0xc0100000 - 0xc051d39a   (4212 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 4824.85 BogoMIPS (lpj=2412427)
Security Framework v1.0.0 initialized
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 078bfbff e3d3fbff 00000000 00000000 00000001 00000000 00000001 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: After all inits, caps: 078bfbff e3d3fbff 00000000 00000410 00000001 00000000 00000001 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
CPU: AMD Athlon(tm) 64 Processor 3800+ stepping 02
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 0eb8)
NET: Registered protocol family 16
EISA bus registered
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfb0a0, last bus=2
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGPB._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs *3 4 5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK3] (IRQs 3 *4 5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LAPU] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LACI] (IRQs 3 4 5 6 *7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LFIR] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [L3CM] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0
ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.
ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0
ACPI: PCI Interrupt Link [APC5] (IRQs *16)
ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCI] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCS] (IRQs *23)
ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [AP3C] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22) *0, disabled.
ACPI: Power Resource [ISAV] (on)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 8 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 2.21 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Time: tsc clocksource has been installed.
pnp: 00:00: ioport range 0x1000-0x107f has been reserved
pnp: 00:00: ioport range 0x1080-0x10ff has been reserved
pnp: 00:00: ioport range 0x1400-0x147f has been reserved
pnp: 00:00: ioport range 0x1480-0x14ff has been reserved
pnp: 00:00: ioport range 0x1800-0x187f has been reserved
pnp: 00:00: ioport range 0x1880-0x18ff has been reserved
pnp: 00:01: iomem range 0xcc000-0xcffff has been reserved
pnp: 00:01: iomem range 0xf0000-0xf7fff could not be reserved
pnp: 00:01: iomem range 0xf8000-0xfbfff could not be reserved
pnp: 00:01: iomem range 0xfc000-0xfffff could not be reserved
PCI: Bridge: 0000:00:0b.0
  IO window: disabled.
  MEM window: f8000000-faffffff
  PREFETCH window: f6000000-f7ffffff
PCI: Bridge: 0000:00:0e.0
  IO window: a000-afff
  MEM window: fb000000-fcffffff
  PREFETCH window: 88000000-880fffff
PCI: Setting latency timer of device 0000:00:0e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NTFS driver 2.1.28 [Flags: R/W].
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered (default)
io scheduler cfq registered
Boot video device is 0000:01:00.0
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Linux agpgart interface v0.102
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt Link [LNK5] enabled at IRQ 5
PCI: setting IRQ 5 as level-triggered
ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNK5] -> GSI 5 (level, low) -> IRQ 5
[drm] Initialized mga 3.2.1 20051102 on minor 0
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
loop: module loaded
sk98lin: driver has been replaced by the skge driver and is scheduled for removal
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
NFORCE3-250: IDE controller at PCI slot 0000:00:08.0
NFORCE3-250: chipset revision 162
NFORCE3-250: not 100% native mode: will probe irqs later
NFORCE3-250: BIOS didn't set cable bits correctly. Enabling workaround.
NFORCE3-250: BIOS didn't set cable bits correctly. Enabling workaround.
NFORCE3-250: 0000:00:08.0 (rev a2) UDMA133 controller
    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:DMA, hdd:DMA
Probing IDE interface ide0...
Switched to high resolution mode on CPU 0
hda: Maxtor 6L100P0, ATA DISK drive
hdb: WDC WD800JB-00CRA1, ATA DISK drive
hda: selected mode 0x46
hdb: selected mode 0x45
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: DVD-RW IDE1004, ATAPI CD/DVD-ROM drive
hdd: PLEXTOR DVDR PX-716A, ATAPI CD/DVD-ROM drive
hdc: drive side 80-wire cable detection failed, limiting max speed to UDMA33
hdc: selected mode 0x42
hdd: selected mode 0x44
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 128KiB
hda: Host Protected Area detected.
	current capacity is 195810959 sectors (100255 MB)
	native  capacity is 195813072 sectors (100256 MB)
hda: Host Protected Area disabled.
hda: 195813072 sectors (100256 MB) w/8192KiB Cache, CHS=65535/16/63, UDMA(133)
hda: cache flushes supported
 hda: hda1 hda2 hda3 < hda5 hda6 hda7 hda8 hda9 >
hdb: max request size: 128KiB
hdb: 156301488 sectors (80026 MB) w/8192KiB Cache, CHS=65535/16/63, UDMA(100)
hdb: cache flushes not supported
 hdb: hdb1
hdc: ATAPI 40X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
hdd: ATAPI 40X DVD-ROM DVD-R CD-R/RW drive, 8192kB Cache, UDMA(66)
Loading iSCSI transport class v2.0-724.
iscsi: registered transport (tcp)
Loading Adaptec I2O RAID: Version 2.4 Build 5go
Detecting Adaptec I2O RAID controllers...
Adaptec aacraid driver 1.1-5[2449]-ms
aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
scsi: <fdomain> Detection failed (no card)
sym53c416.c: Version 1.0.0-ac
qlogicfas: no cards were found, please specify I/O address and IRQ using iobase= and irq= options<6>QLogic Fibre Channel HBA Driver
iscsi: registered transport (qla4xxx)
QLogic iSCSI HBA Driver
Emulex LightPulse Fibre Channel SCSI driver 8.2.2
Copyright(c) 2004-2007 Emulex.  All rights reserved.
seagate: ST0x/TMC-8xx not detected.
Failed initialization of WD-7000 SCSI card!
DC390: clustering now enabled by default. If you get problems load
	with "disable_clustering=1" and report to maintainers
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
megasas: 00.00.03.10-rc5 Thu May 17 10:09:32 PDT 2007
GDT-HA: Storage RAID Controller Driver. Version: 3.05
GDT-HA: Found 0 PCI Storage RAID Controllers
3ware Storage Controller device driver for Linux v1.26.02.002.
3ware 9000 Storage Controller device driver for Linux v2.26.02.010.
nsp32: loading...
ipr: IBM Power RAID SCSI Device Driver version: 2.4.1 (April 24, 2007)
RocketRAID 3xxx SATA Controller driver v1.0 (060426)
sata_nv 0000:00:0a.0: version 3.5
ACPI: PCI Interrupt Link [LFID] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LFID] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:0a.0 to 64
scsi2 : sata_nv
scsi3 : sata_nv
ata1: SATA max UDMA/133 cmd 0x000109f0 ctl 0x00010bf2 bmdma 0x0001dc00 irq 11
ata2: SATA max UDMA/133 cmd 0x00010970 ctl 0x00010b72 bmdma 0x0001dc08 irq 11
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: Host Protected Area detected:
	current size: 586070255 sectors
	native size: 586072368 sectors
ata1.00: ATA-7: ST3300620AS, 3.AAD, max UDMA/133
ata1.00: 586070255 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: Host Protected Area detected:
	current size: 586070255 sectors
	native size: 586072368 sectors
ata1.00: configured for UDMA/133
ata2: SATA link down (SStatus 0 SControl 300)
scsi 2:0:0:0: Direct-Access     ATA      ST3300620AS      3.AA PQ: 0 ANSI: 5
sd 2:0:0:0: [sda] 586070255 512-byte hardware sectors (300068 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sda] 586070255 512-byte hardware sectors (300068 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 >
sd 2:0:0:0: [sda] Attached SCSI disk
ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 9
PCI: setting IRQ 9 as level-triggered
ACPI: PCI Interrupt 0000:00:02.2[C] -> Link [LUB2] -> GSI 9 (level, low) -> IRQ 9
PCI: Setting latency timer of device 0000:00:02.2 to 64
ehci_hcd 0000:00:02.2: EHCI Host Controller
ehci_hcd 0000:00:02.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.2: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:02.2
ehci_hcd 0000:00:02.2: irq 9, io mem 0xfd005000
ehci_hcd 0000:00:02.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 3
PCI: setting IRQ 3 as level-triggered
ACPI: PCI Interrupt 0000:02:06.2[C] -> Link [LNK1] -> GSI 3 (level, low) -> IRQ 3
ehci_hcd 0000:02:06.2: EHCI Host Controller
ehci_hcd 0000:02:06.2: new USB bus registered, assigned bus number 2
ehci_hcd 0000:02:06.2: irq 3, io mem 0xfc004000
ehci_hcd 0000:02:06.2: USB 2.0 started, EHCI 0.95, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 4 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LUBA] enabled at IRQ 9
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUBA] -> GSI 9 (level, low) -> IRQ 9
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:02.0: irq 9, io mem 0xfd003000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 4 ports detected
ACPI: PCI Interrupt Link [LUBB] enabled at IRQ 9
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUBB] -> GSI 9 (level, low) -> IRQ 9
PCI: Setting latency timer of device 0000:00:02.1 to 64
ohci_hcd 0000:00:02.1: OHCI Host Controller
ohci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:02.1: irq 9, io mem 0xfd004000
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 4 ports detected
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt Link [LNK3] enabled at IRQ 4
PCI: setting IRQ 4 as level-triggered
ACPI: PCI Interrupt 0000:02:06.0[A] -> Link [LNK3] -> GSI 4 (level, low) -> IRQ 4
uhci_hcd 0000:02:06.0: UHCI Host Controller
uhci_hcd 0000:02:06.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:02:06.0: irq 4, io base 0x0000a000
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
ACPI: PCI Interrupt Link [LNK4] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:02:06.1[B] -> Link [LNK4] -> GSI 10 (level, low) -> IRQ 10
uhci_hcd 0000:02:06.1: UHCI Host Controller
uhci_hcd 0000:02:06.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:02:06.1: irq 10, io base 0x0000a400
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
usb 3-3: new low speed USB device using ohci_hcd and address 2
usb 3-3: configuration #1 chosen from 1 choice
usb 3-4: new full speed USB device using ohci_hcd and address 3
usb 3-4: configuration #1 chosen from 1 choice
usb 4-3: new low speed USB device using ohci_hcd and address 2
usb 4-3: configuration #1 chosen from 1 choice
usb 6-1: new full speed USB device using uhci_hcd and address 2
usb 6-1: configuration #1 chosen from 1 choice
usblp0: USB Bidirectional printer dev 3 if 0 alt 0 proto 2 vid 0x04B8 pid 0x0005
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
EISA: Probing bus 0 at eisa.0
Cannot allocate resource for EISA slot 1
Cannot allocate resource for EISA slot 2
EISA: Detected 0 cards.
usbcore: registered new interface driver hiddev
input: Logitech Optical USB Mouse as /devices/pci0000:00/0000:00:02.0/usb3/3-3/3-3:1.0/input/input0
input: USB HID v1.10 Mouse [Logitech Optical USB Mouse] on usb-0000:00:02.0-3
input: Logitech Logitech USB Keyboard as /devices/pci0000:00/0000:00:02.1/usb4/4-3/4-3:1.0/input/input1
input: USB HID v1.10 Keyboard [Logitech Logitech USB Keyboard] on usb-0000:00:02.1-3
input: Logitech Logitech USB Keyboard as /devices/pci0000:00/0000:00:02.1/usb4/4-3/4-3:1.1/input/input2
input: USB HID v1.10 Mouse [Logitech Logitech USB Keyboard] on usb-0000:00:02.1-3
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.14 (Fri Jul 20 09:12:58 2007 UTC).
ACPI: PCI Interrupt Link [LACI] enabled at IRQ 7
PCI: setting IRQ 7 as level-triggered
ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LACI] -> GSI 7 (level, low) -> IRQ 7
PCI: Setting latency timer of device 0000:00:06.0 to 64
intel8x0_measure_ac97_clock: measured 50762 usecs
intel8x0: clocking to 46857
ALSA device list:
  #0: NVidia CK8S with ALC850 at irq 7
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 368k freed
Adding 1566328k swap on /dev/sda3.  Priority:-1 extents:1 across:1566328k
EXT3 FS on sda5, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hdb1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda9, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda10, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda11, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
FAT: bogus number of reserved sectors
VFS: Can't find a valid FAT filesystem on dev hda1.

--Boundary-00=_eLZDHCxOdAfx+/Z
Content-Type: text/plain;
  charset="iso-8859-1";
  name="dmesg APM on"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg APM on"

Linux version 2.6.23-10.09.07 (root@dosxx) (gcc version 4.1.2) #1 Tue Oct 9 20:19:03 MST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fff0000 (usable)
 BIOS-e820: 000000007fff0000 - 000000007fff3000 (ACPI NVS)
 BIOS-e820: 000000007fff3000 - 0000000080000000 (ACPI data)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
Warning only 896MB will be used.
Use a HIGHMEM enabled kernel.
896MB LOWMEM available.
found SMP MP-table at 000f5060
Entering add_active_range(0, 0, 229376) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   229376
On node 0 totalpages: 229376
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI 2.3 present.
ACPI: RSDP 000F69F0, 0014 (r0 Nvidia)
ACPI: RSDT 7FFF3000, 002C (r1 Nvidia AWRDACPI 42302E31 AWRD  1010101)
ACPI: FACP 7FFF3040, 0074 (r1 Nvidia AWRDACPI 42302E31 AWRD  1010101)
ACPI: DSDT 7FFF30C0, 4AC4 (r1 NVIDIA AWRDACPI     1000 MSFT  100000C)
ACPI: FACS 7FFF0000, 0040
ACPI: APIC 7FFF7BC0, 007C (r1 Nvidia AWRDACPI 42302E31 AWRD  1010101)
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 15:15 APIC version 16
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
Using ACPI for processor (LAPIC) configuration information
Intel MultiProcessor Specification v1.4
    Virtual Wire compatibility mode.
OEM ID: OEM00000 Product ID: PROD00000000 APIC at: 0xFEE00000
I/O APIC #2 Version 17 at 0xFEC00000.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Processors: 1
Allocating PCI resources starting at 88000000 (gap: 80000000:7ec00000)
Built 1 zonelists in Zone order.  Total pages: 227584
Kernel command line: BOOT_IMAGE=dosxx ro root=805
mapped APIC to ffffb000 (fee00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2411.744 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 902632k/917504k available (4218k kernel code, 14388k reserved, 1519k data, 372k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffff5000 - 0xfffff000   (  40 kB)
    vmalloc : 0xf8800000 - 0xffff3000   ( 119 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc069e000 - 0xc06fb000   ( 372 kB)
      .data : 0xc051e9ae - 0xc069a87c   (1519 kB)
      .text : 0xc0100000 - 0xc051e9ae   (4218 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 4824.86 BogoMIPS (lpj=2412431)
Security Framework v1.0.0 initialized
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 078bfbff e3d3fbff 00000000 00000000 00000001 00000000 00000001 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: After all inits, caps: 078bfbff e3d3fbff 00000000 00000410 00000001 00000000 00000001 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
CPU: AMD Athlon(tm) 64 Processor 3800+ stepping 02
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 0eb8)
NET: Registered protocol family 16
EISA bus registered
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfb0a0, last bus=2
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGPB._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs *3 4 5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK3] (IRQs 3 *4 5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LAPU] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LACI] (IRQs 3 4 5 6 *7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LFIR] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [L3CM] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0
ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.
ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0
ACPI: PCI Interrupt Link [APC5] (IRQs *16)
ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCI] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCS] (IRQs *23)
ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [AP3C] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22) *0, disabled.
ACPI: Power Resource [ISAV] (on)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 8 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 2.21 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Time: tsc clocksource has been installed.
pnp: 00:00: ioport range 0x1000-0x107f has been reserved
pnp: 00:00: ioport range 0x1080-0x10ff has been reserved
pnp: 00:00: ioport range 0x1400-0x147f has been reserved
pnp: 00:00: ioport range 0x1480-0x14ff has been reserved
pnp: 00:00: ioport range 0x1800-0x187f has been reserved
pnp: 00:00: ioport range 0x1880-0x18ff has been reserved
pnp: 00:01: iomem range 0xcc000-0xcffff has been reserved
pnp: 00:01: iomem range 0xf0000-0xf7fff could not be reserved
pnp: 00:01: iomem range 0xf8000-0xfbfff could not be reserved
pnp: 00:01: iomem range 0xfc000-0xfffff could not be reserved
PCI: Bridge: 0000:00:0b.0
  IO window: disabled.
  MEM window: f8000000-faffffff
  PREFETCH window: f6000000-f7ffffff
PCI: Bridge: 0000:00:0e.0
  IO window: a000-afff
  MEM window: fb000000-fcffffff
  PREFETCH window: 88000000-880fffff
PCI: Setting latency timer of device 0000:00:0e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
NTFS driver 2.1.28 [Flags: R/W].
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered (default)
io scheduler cfq registered
Boot video device is 0000:01:00.0
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Linux agpgart interface v0.102
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt Link [LNK5] enabled at IRQ 5
PCI: setting IRQ 5 as level-triggered
ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNK5] -> GSI 5 (level, low) -> IRQ 5
[drm] Initialized mga 3.2.1 20051102 on minor 0
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
loop: module loaded
sk98lin: driver has been replaced by the skge driver and is scheduled for removal
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
NFORCE3-250: IDE controller at PCI slot 0000:00:08.0
NFORCE3-250: chipset revision 162
NFORCE3-250: not 100% native mode: will probe irqs later
NFORCE3-250: BIOS didn't set cable bits correctly. Enabling workaround.
NFORCE3-250: BIOS didn't set cable bits correctly. Enabling workaround.
NFORCE3-250: 0000:00:08.0 (rev a2) UDMA133 controller
    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:DMA, hdd:DMA
Probing IDE interface ide0...
Switched to high resolution mode on CPU 0
hda: Maxtor 6L100P0, ATA DISK drive
hdb: WDC WD800JB-00CRA1, ATA DISK drive
hda: selected mode 0x46
hdb: selected mode 0x45
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: DVD-RW IDE1004, ATAPI CD/DVD-ROM drive
hdd: PLEXTOR DVDR PX-316A, ATAPI CD/DVD-ROM drive
hdc: drive side 80-wire cable detection failed, limiting max speed to UDMA33
hdc: selected mode 0x42
hdd: selected mode 0x44
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 128KiB
hda: Host Protected Area detected.
	current capacity is 195810959 sectors (100255 MB)
	native  capacity is 195813072 sectors (100256 MB)
hda: Host Protected Area disabled.
hda: 195813072 sectors (100256 MB) w/8192KiB Cache, CHS=65535/16/63, UDMA(133)
hda: cache flushes supported
 hda: hda1 hda2 hda3 < hda5 hda6 hda7 hda8 hda9 >
hdb: max request size: 128KiB
hdb: 156301488 sectors (80026 MB) w/8192KiB Cache, CHS=65535/16/63, UDMA(100)
hdb: cache flushes not supported
 hdb: hdb1
hdc: ATAPI 40X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
hdd: ATAPI 40X DVD-ROM DVD-R CD-R/RW drive, 8192kB Cache, UDMA(66)
Loading iSCSI transport class v2.0-724.
iscsi: registered transport (tcp)
Loading Adaptec I2O RAID: Version 2.4 Build 5go
Detecting Adaptec I2O RAID controllers...
Adaptec aacraid driver 1.1-5[2449]-ms
aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
scsi: <fdomain> Detection failed (no card)
sym53c416.c: Version 1.0.0-ac
qlogicfas: no cards were found, please specify I/O address and IRQ using iobase= and irq= options<6>QLogic Fibre Channel HBA Driver
iscsi: registered transport (qla4xxx)
QLogic iSCSI HBA Driver
Emulex LightPulse Fibre Channel SCSI driver 8.2.2
Copyright(c) 2004-2007 Emulex.  All rights reserved.
seagate: ST0x/TMC-8xx not detected.
Failed initialization of WD-7000 SCSI card!
DC390: clustering now enabled by default. If you get problems load
	with "disable_clustering=1" and report to maintainers
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
megasas: 00.00.03.10-rc5 Thu May 17 10:09:32 PDT 2007
GDT-HA: Storage RAID Controller Driver. Version: 3.05
GDT-HA: Found 0 PCI Storage RAID Controllers
3ware Storage Controller device driver for Linux v1.26.02.002.
3ware 9000 Storage Controller device driver for Linux v2.26.02.010.
nsp32: loading...
ipr: IBM Power RAID SCSI Device Driver version: 2.4.1 (April 24, 2007)
RocketRAID 3xxx SATA Controller driver v1.0 (060426)
sata_nv 0000:00:0a.0: version 3.5
ACPI: PCI Interrupt Link [LFID] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LFID] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:0a.0 to 64
scsi2 : sata_nv
scsi3 : sata_nv
ata1: SATA max UDMA/133 cmd 0x000109f0 ctl 0x00010bf2 bmdma 0x0001dc00 irq 11
ata2: SATA max UDMA/133 cmd 0x00010970 ctl 0x00010b72 bmdma 0x0001dc08 irq 11
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: Host Protected Area detected:
	current size: 586070255 sectors
	native size: 586072368 sectors
ata1.00: ATA-7: ST3300620AS, 3.AAD, max UDMA/133
ata1.00: 586070255 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: Host Protected Area detected:
	current size: 586070255 sectors
	native size: 586072368 sectors
ata1.00: configured for UDMA/133
ata2: SATA link down (SStatus 0 SControl 300)
scsi 2:0:0:0: Direct-Access     ATA      ST3300620AS      3.AA PQ: 0 ANSI: 5
sd 2:0:0:0: [sda] 586070255 512-byte hardware sectors (300068 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sda] 586070255 512-byte hardware sectors (300068 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 >
sd 2:0:0:0: [sda] Attached SCSI disk
ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 9
PCI: setting IRQ 9 as level-triggered
ACPI: PCI Interrupt 0000:00:02.2[C] -> Link [LUB2] -> GSI 9 (level, low) -> IRQ 9
PCI: Setting latency timer of device 0000:00:02.2 to 64
ehci_hcd 0000:00:02.2: EHCI Host Controller
ehci_hcd 0000:00:02.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.2: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:02.2
ehci_hcd 0000:00:02.2: irq 9, io mem 0xfd005000
ehci_hcd 0000:00:02.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 3
PCI: setting IRQ 3 as level-triggered
ACPI: PCI Interrupt 0000:02:06.2[C] -> Link [LNK1] -> GSI 3 (level, low) -> IRQ 3
ehci_hcd 0000:02:06.2: EHCI Host Controller
ehci_hcd 0000:02:06.2: new USB bus registered, assigned bus number 2
ehci_hcd 0000:02:06.2: irq 3, io mem 0xfc004000
ehci_hcd 0000:02:06.2: USB 2.0 started, EHCI 0.95, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 4 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LUBA] enabled at IRQ 9
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUBA] -> GSI 9 (level, low) -> IRQ 9
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:02.0: irq 9, io mem 0xfd003000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 4 ports detected
ACPI: PCI Interrupt Link [LUBB] enabled at IRQ 9
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUBB] -> GSI 9 (level, low) -> IRQ 9
PCI: Setting latency timer of device 0000:00:02.1 to 64
ohci_hcd 0000:00:02.1: OHCI Host Controller
ohci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:02.1: irq 9, io mem 0xfd004000
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 4 ports detected
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt Link [LNK3] enabled at IRQ 4
PCI: setting IRQ 4 as level-triggered
ACPI: PCI Interrupt 0000:02:06.0[A] -> Link [LNK3] -> GSI 4 (level, low) -> IRQ 4
uhci_hcd 0000:02:06.0: UHCI Host Controller
uhci_hcd 0000:02:06.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:02:06.0: irq 4, io base 0x0000a000
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
ACPI: PCI Interrupt Link [LNK4] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:02:06.1[B] -> Link [LNK4] -> GSI 10 (level, low) -> IRQ 10
uhci_hcd 0000:02:06.1: UHCI Host Controller
uhci_hcd 0000:02:06.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:02:06.1: irq 10, io base 0x0000a400
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
usb 3-3: new low speed USB device using ohci_hcd and address 2
usb 3-3: configuration #1 chosen from 1 choice
usb 3-4: new full speed USB device using ohci_hcd and address 3
usb 3-4: configuration #1 chosen from 1 choice
usb 4-3: new low speed USB device using ohci_hcd and address 2
usb 4-3: configuration #1 chosen from 1 choice
usb 6-1: new full speed USB device using uhci_hcd and address 2
usb 6-1: configuration #1 chosen from 1 choice
usblp0: USB Bidirectional printer dev 3 if 0 alt 0 proto 2 vid 0x04B8 pid 0x0005
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
EISA: Probing bus 0 at eisa.0
Cannot allocate resource for EISA slot 1
Cannot allocate resource for EISA slot 2
EISA: Detected 0 cards.
usbcore: registered new interface driver hiddev
input: Logitech Optical USB Mouse as /devices/pci0000:00/0000:00:02.0/usb3/3-3/3-3:1.0/input/input0
input: USB HID v1.10 Mouse [Logitech Optical USB Mouse] on usb-0000:00:02.0-3
input: Logitech Logitech USB Keyboard as /devices/pci0000:00/0000:00:02.1/usb4/4-3/4-3:1.0/input/input1
input: USB HID v1.10 Keyboard [Logitech Logitech USB Keyboard] on usb-0000:00:02.1-3
input: Logitech Logitech USB Keyboard as /devices/pci0000:00/0000:00:02.1/usb4/4-3/4-3:1.1/input/input2
input: USB HID v1.10 Mouse [Logitech Logitech USB Keyboard] on usb-0000:00:02.1-3
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.14 (Fri Jul 20 09:12:58 2007 UTC).
ACPI: PCI Interrupt Link [LACI] enabled at IRQ 7
PCI: setting IRQ 7 as level-triggered
ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LACI] -> GSI 7 (level, low) -> IRQ 7
PCI: Setting latency timer of device 0000:00:06.0 to 64
intel8x0_measure_ac97_clock: measured 50748 usecs
intel8x0: clocking to 46844
ALSA device list:
  #0: NVidia CK8S with ALC850 at irq 7
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 372k freed
Adding 1566328k swap on /dev/sda3.  Priority:-1 extents:1 across:1566328k
EXT3 FS on sda5, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hdb1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda9, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda10, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda11, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
FAT: bogus number of reserved sectors
VFS: Can't find a valid FAT filesystem on dev hda1.

--Boundary-00=_eLZDHCxOdAfx+/Z
Content-Type: text/plain;
  charset="iso-8859-1";
  name="dmesg-2.6.22"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg-2.6.22"

Linux version 2.6.22-08.10.07a (root@dosxx) (gcc version 4.1.2) #12 Wed Oct 10 19:34:34 MST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fff0000 (usable)
 BIOS-e820: 000000007fff0000 - 000000007fff3000 (ACPI NVS)
 BIOS-e820: 000000007fff3000 - 0000000080000000 (ACPI data)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
Warning only 896MB will be used.
Use a HIGHMEM enabled kernel.
896MB LOWMEM available.
Entering add_active_range(0, 0, 229376) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
early_node_map[1] active PFN ranges
    0:        0 ->   229376
On node 0 totalpages: 229376
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
DMI 2.3 present.
ACPI: RSDP 000F69F0, 0014 (r0 Nvidia)
ACPI: RSDT 7FFF3000, 002C (r1 Nvidia AWRDACPI 42302E31 AWRD  1010101)
ACPI: FACP 7FFF3040, 0074 (r1 Nvidia AWRDACPI 42302E31 AWRD  1010101)
ACPI: DSDT 7FFF30C0, 4AC4 (r1 NVIDIA AWRDACPI     1000 MSFT  100000C)
ACPI: FACS 7FFF0000, 0040
ACPI: APIC 7FFF7BC0, 007C (r1 Nvidia AWRDACPI 42302E31 AWRD  1010101)
ACPI: PM-Timer IO Port: 0x1008
Allocating PCI resources starting at 88000000 (gap: 80000000:7ec00000)
Built 1 zonelists.  Total pages: 227584
Kernel command line: BOOT_IMAGE=dosxx ro root=805
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2411.794 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 902508k/917504k available (4313k kernel code, 14576k reserved, 1555k data, 364k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffff8000 - 0xfffff000   (  28 kB)
    vmalloc : 0xf8800000 - 0xffff6000   ( 119 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc06be000 - 0xc0719000   ( 364 kB)
      .data : 0xc05367ad - 0xc06bb69c   (1555 kB)
      .text : 0xc0100000 - 0xc05367ad   (4313 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 4824.85 BogoMIPS (lpj=2412429)
Security Framework v1.0.0 initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 078bfbff e3d3fbff 00000000 00000000 00000001 00000000 00000001
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: After all inits, caps: 078bfbff e3d3fbff 00000000 00000410 00000001 00000000 00000001
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
CPU: AMD Athlon(tm) 64 Processor 3800+ stepping 02
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 0eb8)
NET: Registered protocol family 16
EISA bus registered
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfb0a0, last bus=2
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGPB._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs *3 4 5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK3] (IRQs 3 *4 5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LAPU] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LACI] (IRQs 3 4 5 6 *7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LFIR] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [L3CM] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0
ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.
ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0
ACPI: PCI Interrupt Link [APC5] (IRQs *16)
ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCI] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCS] (IRQs *23)
ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [AP3C] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22) *0, disabled.
ACPI: Power Resource [ISAV] (on)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 8 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 2.21 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
pnp: 00:00: ioport range 0x1000-0x107f has been reserved
pnp: 00:00: ioport range 0x1080-0x10ff has been reserved
pnp: 00:00: ioport range 0x1400-0x147f has been reserved
pnp: 00:00: ioport range 0x1480-0x14ff has been reserved
Time: tsc clocksource has been installed.
pnp: 00:00: ioport range 0x1800-0x187f has been reserved
pnp: 00:00: ioport range 0x1880-0x18ff has been reserved
pnp: 00:01: iomem range 0xcc000-0xcffff has been reserved
pnp: 00:01: iomem range 0xf0000-0xf7fff could not be reserved
pnp: 00:01: iomem range 0xf8000-0xfbfff could not be reserved
pnp: 00:01: iomem range 0xfc000-0xfffff could not be reserved
PCI: Bridge: 0000:00:0b.0
  IO window: disabled.
  MEM window: f8000000-faffffff
  PREFETCH window: f6000000-f7ffffff
PCI: Bridge: 0000:00:0e.0
  IO window: a000-afff
  MEM window: fb000000-fcffffff
  PREFETCH window: 88000000-880fffff
PCI: Setting latency timer of device 0000:00:0e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
apm: overridden by ACPI.
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NTFS driver 2.1.28 [Flags: R/W].
io scheduler noop registered
io scheduler cfq registered (default)
Boot video device is 0000:01:00.0
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Linux agpgart interface v0.102 (c) Dave Jones
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt Link [LNK5] enabled at IRQ 5
PCI: setting IRQ 5 as level-triggered
ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNK5] -> GSI 5 (level, low) -> IRQ 5
[drm] Initialized mga 3.2.1 20051102 on minor 0
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
loop: module loaded
sk98lin: driver has been replaced by the skge driver and is scheduled for removal
ACPI: PCI Interrupt Link [LNK4] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:02:0b.0[A] -> Link [LNK4] -> GSI 10 (level, low) -> IRQ 10
eth0: Yukon Gigabit Ethernet 10/100/1000Base-T Adapter
      PrefPort:A  RlmtMode:Check Link State
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
NFORCE3-250: IDE controller at PCI slot 0000:00:08.0
NFORCE3-250: chipset revision 162
NFORCE3-250: not 100% native mode: will probe irqs later
NFORCE3-250: BIOS didn't set cable bits correctly. Enabling workaround.
NFORCE3-250: BIOS didn't set cable bits correctly. Enabling workaround.
NFORCE3-250: 0000:00:08.0 (rev a2) UDMA133 controller
    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:DMA, hdd:DMA
Probing IDE interface ide0...
Switched to high resolution mode on CPU 0
hda: Maxtor 6L100P0, ATA DISK drive
hdb: WDC WD800JB-00CRA1, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: DVD-RW IDE1004, ATAPI CD/DVD-ROM drive
hdd: PLEXTOR DVDR PX-716A, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 128KiB
hda: Host Protected Area detected.
	current capacity is 195810959 sectors (100255 MB)
	native  capacity is 195813072 sectors (100256 MB)
hda: Host Protected Area disabled.
hda: 195813072 sectors (100256 MB) w/8192KiB Cache, CHS=65535/16/63, UDMA(133)
hda: cache flushes supported
 hda: hda1 hda2 hda3 < hda5 hda6 hda7 hda8 hda9 >
hdb: max request size: 128KiB
hdb: 156301488 sectors (80026 MB) w/8192KiB Cache, CHS=65535/16/63, UDMA(100)
hdb: cache flushes not supported
 hdb: hdb1
hdc: ATAPI 40X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache<4>hdc: drive side 80-wire cable detection failed, limiting max speed to UDMA33

Uniform CD-ROM driver Revision: 3.20
hdd: ATAPI 40X DVD-ROM DVD-R CD-R/RW drive, 8192kB Cache, UDMA(66)
Loading iSCSI transport class v2.0-724.
iscsi: registered transport (tcp)
Loading Adaptec I2O RAID: Version 2.4 Build 5go
Detecting Adaptec I2O RAID controllers...
Adaptec aacraid driver (1.1-5[2437]-mh4)
aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
scsi: <fdomain> Detection failed (no card)
sym53c416.c: Version 1.0.0-ac
qlogicfas: no cards were found, please specify I/O address and IRQ using iobase= and irq= options<6>QLogic Fibre Channel HBA Driver
iscsi: registered transport (qla4xxx)
QLogic iSCSI HBA Driver
Emulex LightPulse Fibre Channel SCSI driver 8.1.12
Copyright(c) 2004-2007 Emulex.  All rights reserved.
seagate: ST0x/TMC-8xx not detected.
Failed initialization of WD-7000 SCSI card!
DC390: clustering now enabled by default. If you get problems load
	with "disable_clustering=1" and report to maintainers
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
megasas: 00.00.03.10-rc5 Thu May 17 10:09:32 PDT 2007
GDT-HA: Storage RAID Controller Driver. Version: 3.05
GDT-HA: Found 0 PCI Storage RAID Controllers
3ware Storage Controller device driver for Linux v1.26.02.002.
3ware 9000 Storage Controller device driver for Linux v2.26.02.008.
nsp32: loading...
ipr: IBM Power RAID SCSI Device Driver version: 2.4.1 (April 24, 2007)
RocketRAID 3xxx SATA Controller driver v1.0 (060426)
sata_nv 0000:00:0a.0: version 3.4
ACPI: PCI Interrupt Link [LFID] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LFID] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:0a.0 to 64
scsi2 : sata_nv
scsi3 : sata_nv
ata1: SATA max UDMA/133 cmd 0x000109f0 ctl 0x00010bf2 bmdma 0x0001dc00 irq 11
ata2: SATA max UDMA/133 cmd 0x00010970 ctl 0x00010b72 bmdma 0x0001dc08 irq 11
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: Host Protected Area detected:
	current size: 586070255 sectors
	native size: 586072368 sectors
ata1.00: ATA-7: ST3300620AS, 3.AAD, max UDMA/133
ata1.00: 586070255 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: Host Protected Area detected:
	current size: 586070255 sectors
	native size: 586072368 sectors
ata1.00: configured for UDMA/133
ata2: SATA link down (SStatus 0 SControl 300)
scsi 2:0:0:0: Direct-Access     ATA      ST3300620AS      3.AA PQ: 0 ANSI: 5
sd 2:0:0:0: [sda] 586070255 512-byte hardware sectors (300068 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sda] 586070255 512-byte hardware sectors (300068 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 >
sd 2:0:0:0: [sda] Attached SCSI disk
Fusion MPT base driver 3.04.04
Copyright (c) 1999-2007 LSI Logic Corporation
Fusion MPT SPI Host driver 3.04.04
Fusion MPT FC Host driver 3.04.04
Fusion MPT SAS Host driver 3.04.04
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LUBA] enabled at IRQ 9
PCI: setting IRQ 9 as level-triggered
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUBA] -> GSI 9 (level, low) -> IRQ 9
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:02.0: irq 9, io mem 0xfd003000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
ACPI: PCI Interrupt Link [LUBB] enabled at IRQ 9
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUBB] -> GSI 9 (level, low) -> IRQ 9
PCI: Setting latency timer of device 0000:00:02.1 to 64
ohci_hcd 0000:00:02.1: OHCI Host Controller
ohci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.1: irq 9, io mem 0xfd004000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 4 ports detected
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt Link [LNK3] enabled at IRQ 4
PCI: setting IRQ 4 as level-triggered
ACPI: PCI Interrupt 0000:02:06.0[A] -> Link [LNK3] -> GSI 4 (level, low) -> IRQ 4
uhci_hcd 0000:02:06.0: UHCI Host Controller
uhci_hcd 0000:02:06.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:02:06.0: irq 4, io base 0x0000a000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb 1-3: new low speed USB device using ohci_hcd and address 2
ACPI: PCI Interrupt 0000:02:06.1[B] -> Link [LNK4] -> GSI 10 (level, low) -> IRQ 10
uhci_hcd 0000:02:06.1: UHCI Host Controller
uhci_hcd 0000:02:06.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:02:06.1: irq 10, io base 0x0000a400
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 1-3: configuration #1 chosen from 1 choice
usb 1-4: new full speed USB device using ohci_hcd and address 3
usb 1-4: configuration #1 chosen from 1 choice
usb 2-3: new low speed USB device using ohci_hcd and address 2
usb 2-3: configuration #1 chosen from 1 choice
usb 4-1: new full speed USB device using uhci_hcd and address 2
usb 4-1: configuration #1 chosen from 1 choice
drivers/usb/class/usblp.c: usblp0: USB Bidirectional printer dev 3 if 0 alt 0 proto 2 vid 0x04B8 pid 0x0005
usbcore: registered new interface driver usblp
drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
EISA: Probing bus 0 at eisa.0
Cannot allocate resource for EISA slot 1
Cannot allocate resource for EISA slot 2
EISA: Detected 0 cards.
usbcore: registered new interface driver hiddev
input: Logitech Optical USB Mouse as /class/input/input0
input: USB HID v1.10 Mouse [Logitech Optical USB Mouse] on usb-0000:00:02.0-3
input: Logitech Logitech USB Keyboard as /class/input/input1
input: USB HID v1.10 Keyboard [Logitech Logitech USB Keyboard] on usb-0000:00:02.1-3
input: Logitech Logitech USB Keyboard as /class/input/input2
input: USB HID v1.10 Mouse [Logitech Logitech USB Keyboard] on usb-0000:00:02.1-3
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.14 (Thu May 31 09:03:25 2007 UTC).
ACPI: PCI Interrupt Link [LACI] enabled at IRQ 7
PCI: setting IRQ 7 as level-triggered
ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LACI] -> GSI 7 (level, low) -> IRQ 7
PCI: Setting latency timer of device 0000:00:06.0 to 64
intel8x0_measure_ac97_clock: measured 50771 usecs
intel8x0: clocking to 46866
ALSA device list:
  #0: NVidia CK8S with ALC850 at irq 7
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 364k freed
Adding 1566328k swap on /dev/sda3.  Priority:-1 extents:1 across:1566328k
EXT3 FS on sda5, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hdb1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda9, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda10, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda11, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
FAT: bogus number of reserved sectors
VFS: Can't find a valid FAT filesystem on dev hda1.

--Boundary-00=_eLZDHCxOdAfx+/Z
Content-Type: text/x-java;
  charset="iso-8859-1";
  name="DOT_config.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="DOT_config.txt"

# diff -u .config-2.6.22 .config-2.6.23




--- .config-2.6.22	2007-10-10 19:27:42.000000000 -0700
+++ .config-2.6.23	2007-10-10 11:23:33.000000000 -0700
@@ -1,12 +1,14 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.22
-# Wed Oct 10 19:27:39 2007
+# Linux kernel version: 2.6.23
+# Wed Oct 10 11:23:31 2007
 #
 CONFIG_X86_32=y
 CONFIG_GENERIC_TIME=y
+CONFIG_GENERIC_CMOS_UPDATE=y
 CONFIG_CLOCKSOURCE_WATCHDOG=y
 CONFIG_GENERIC_CLOCKEVENTS=y
+CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
 CONFIG_LOCKDEP_SUPPORT=y
 CONFIG_STACKTRACE_SUPPORT=y
 CONFIG_SEMAPHORE_SLEEPERS=y
@@ -23,29 +25,24 @@
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 
 #
-# Code maturity level options
+# General setup
 #
 CONFIG_EXPERIMENTAL=y
 CONFIG_BROKEN_ON_SMP=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
-
-#
-# General setup
-#
-CONFIG_LOCALVERSION="-08.10.07a"
+CONFIG_LOCALVERSION="-10.10.07"
 CONFIG_LOCALVERSION_AUTO=y
 CONFIG_SWAP=y
 CONFIG_SYSVIPC=y
-CONFIG_IPC_NS=y
 CONFIG_SYSVIPC_SYSCTL=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
 # CONFIG_BSD_PROCESS_ACCT_V3 is not set
 # CONFIG_TASKSTATS is not set
-CONFIG_UTS_NS=y
+# CONFIG_USER_NS is not set
 # CONFIG_AUDIT is not set
 CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
+# CONFIG_IKCONFIG_PROC is not set
 CONFIG_LOG_BUF_SHIFT=15
 # CONFIG_SYSFS_DEPRECATED is not set
 # CONFIG_RELAY is not set
@@ -67,7 +64,6 @@
 CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
-CONFIG_TIMERFD=y
 CONFIG_EVENTFD=y
 CONFIG_SHMEM=y
 CONFIG_VM_EVENT_COUNTERS=y
@@ -77,37 +73,30 @@
 CONFIG_RT_MUTEXES=y
 # CONFIG_TINY_SHMEM is not set
 CONFIG_BASE_SMALL=0
-
-#
-# Loadable module support
-#
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_MODULE_FORCE_UNLOAD is not set
 # CONFIG_MODVERSIONS is not set
 # CONFIG_MODULE_SRCVERSION_ALL is not set
 CONFIG_KMOD=y
-
-#
-# Block layer
-#
 CONFIG_BLOCK=y
 # CONFIG_LBD is not set
 # CONFIG_BLK_DEV_IO_TRACE is not set
 # CONFIG_LSF is not set
+# CONFIG_BLK_DEV_BSG is not set
 
 #
 # IO Schedulers
 #
 CONFIG_IOSCHED_NOOP=y
-# CONFIG_IOSCHED_AS is not set
-# CONFIG_IOSCHED_DEADLINE is not set
+CONFIG_IOSCHED_AS=y
+CONFIG_IOSCHED_DEADLINE=y
 CONFIG_IOSCHED_CFQ=y
 # CONFIG_DEFAULT_AS is not set
-# CONFIG_DEFAULT_DEADLINE is not set
-CONFIG_DEFAULT_CFQ=y
+CONFIG_DEFAULT_DEADLINE=y
+# CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
-CONFIG_DEFAULT_IOSCHED="cfq"
+CONFIG_DEFAULT_IOSCHED="deadline"
 
 #
 # Processor type and features
@@ -150,9 +139,9 @@
 # CONFIG_MCYRIXIII is not set
 # CONFIG_MVIAC3_2 is not set
 # CONFIG_MVIAC7 is not set
-# CONFIG_X86_GENERIC is not set
+CONFIG_X86_GENERIC=y
 CONFIG_X86_CMPXCHG=y
-CONFIG_X86_L1_CACHE_SHIFT=6
+CONFIG_X86_L1_CACHE_SHIFT=7
 CONFIG_X86_XADD=y
 CONFIG_RWSEM_XCHGADD_ALGORITHM=y
 # CONFIG_ARCH_HAS_ILOG2_U32 is not set
@@ -166,14 +155,17 @@
 CONFIG_X86_INTEL_USERCOPY=y
 CONFIG_X86_USE_PPRO_CHECKSUM=y
 CONFIG_X86_TSC=y
-CONFIG_X86_MINIMUM_CPU_MODEL=4
+CONFIG_X86_MINIMUM_CPU_FAMILY=4
 # CONFIG_HPET_TIMER is not set
-CONFIG_PREEMPT_NONE=y
-# CONFIG_PREEMPT_VOLUNTARY is not set
+# CONFIG_PREEMPT_NONE is not set
+CONFIG_PREEMPT_VOLUNTARY=y
 # CONFIG_PREEMPT is not set
-# CONFIG_X86_UP_APIC is not set
+CONFIG_X86_UP_APIC=y
+# CONFIG_X86_UP_IOAPIC is not set
+CONFIG_X86_LOCAL_APIC=y
 CONFIG_X86_MCE=y
-CONFIG_X86_MCE_NONFATAL=m
+# CONFIG_X86_MCE_NONFATAL is not set
+CONFIG_X86_MCE_P4THERMAL=y
 CONFIG_VM86=y
 # CONFIG_TOSHIBA is not set
 # CONFIG_I8K is not set
@@ -185,13 +177,15 @@
 #
 # Firmware Drivers
 #
-CONFIG_EDD=m
-CONFIG_DELL_RBU=m
-CONFIG_DCDBAS=m
+# CONFIG_EDD is not set
+# CONFIG_DELL_RBU is not set
+# CONFIG_DCDBAS is not set
+CONFIG_DMIID=y
 CONFIG_NOHIGHMEM=y
 # CONFIG_HIGHMEM4G is not set
 # CONFIG_HIGHMEM64G is not set
 CONFIG_PAGE_OFFSET=0xC0000000
+# CONFIG_X86_PAE is not set
 CONFIG_ARCH_FLATMEM_ENABLE=y
 CONFIG_ARCH_SPARSEMEM_ENABLE=y
 CONFIG_ARCH_SELECT_MEMORY_MODEL=y
@@ -206,9 +200,11 @@
 CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_RESOURCES_64BIT is not set
 CONFIG_ZONE_DMA_FLAG=1
+CONFIG_BOUNCE=y
 CONFIG_NR_QUICK=1
-CONFIG_MATH_EMULATION=y
-CONFIG_MTRR=y
+CONFIG_VIRT_TO_BUS=y
+# CONFIG_MATH_EMULATION is not set
+# CONFIG_MTRR is not set
 # CONFIG_EFI is not set
 # CONFIG_SECCOMP is not set
 # CONFIG_HZ_100 is not set
@@ -226,19 +222,17 @@
 # Power management options (ACPI, APM)
 #
 CONFIG_PM=y
-CONFIG_PM_LEGACY=y
+# CONFIG_PM_LEGACY is not set
 # CONFIG_PM_DEBUG is not set
-# CONFIG_PM_SYSFS_DEPRECATED is not set
-# CONFIG_SOFTWARE_SUSPEND is not set
-
-#
-# ACPI (Advanced Configuration and Power Interface) Support
-#
+CONFIG_PM_SLEEP=y
+CONFIG_SUSPEND_UP_POSSIBLE=y
+CONFIG_SUSPEND=y
+CONFIG_HIBERNATION_UP_POSSIBLE=y
+# CONFIG_HIBERNATION is not set
 CONFIG_ACPI=y
 CONFIG_ACPI_SLEEP=y
-CONFIG_ACPI_SLEEP_PROC_FS=y
-# CONFIG_ACPI_SLEEP_PROC_SLEEP is not set
 CONFIG_ACPI_PROCFS=y
+CONFIG_ACPI_PROC_EVENT=y
 CONFIG_ACPI_AC=m
 CONFIG_ACPI_BATTERY=m
 CONFIG_ACPI_BUTTON=m
@@ -258,13 +252,7 @@
 CONFIG_X86_PM_TIMER=y
 CONFIG_ACPI_CONTAINER=m
 # CONFIG_ACPI_SBS is not set
-CONFIG_APM=y
-# CONFIG_APM_IGNORE_USER_SUSPEND is not set
-# CONFIG_APM_DO_ENABLE is not set
-# CONFIG_APM_CPU_IDLE is not set
-# CONFIG_APM_DISPLAY_BLANK is not set
-# CONFIG_APM_ALLOW_INTS is not set
-# CONFIG_APM_REAL_MODE_POWER_OFF is not set
+# CONFIG_APM is not set
 
 #
 # CPU Frequency scaling
@@ -293,7 +281,6 @@
 CONFIG_X86_POWERNOW_K8_ACPI=y
 CONFIG_X86_GX_SUSPMOD=m
 CONFIG_X86_SPEEDSTEP_CENTRINO=m
-CONFIG_X86_SPEEDSTEP_CENTRINO_ACPI=y
 CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
 CONFIG_X86_SPEEDSTEP_ICH=m
 CONFIG_X86_SPEEDSTEP_SMI=m
@@ -321,8 +308,7 @@
 CONFIG_PCI_BIOS=y
 CONFIG_PCI_DIRECT=y
 CONFIG_PCI_MMCONFIG=y
-CONFIG_PCIEPORTBUS=y
-CONFIG_PCIEAER=y
+# CONFIG_PCIEPORTBUS is not set
 # CONFIG_ARCH_SUPPORTS_MSI is not set
 CONFIG_ISA_DMA_API=y
 CONFIG_ISA=y
@@ -344,8 +330,8 @@
 # Executable file formats
 #
 CONFIG_BINFMT_ELF=y
-CONFIG_BINFMT_AOUT=m
-CONFIG_BINFMT_MISC=m
+CONFIG_BINFMT_AOUT=y
+CONFIG_BINFMT_MISC=y
 
 #
 # Networking
@@ -372,7 +358,6 @@
 CONFIG_IP_FIB_HASH=y
 CONFIG_IP_MULTIPLE_TABLES=y
 CONFIG_IP_ROUTE_MULTIPATH=y
-# CONFIG_IP_ROUTE_MULTIPATH_CACHED is not set
 CONFIG_IP_ROUTE_VERBOSE=y
 # CONFIG_IP_PNP is not set
 CONFIG_NET_IPIP=m
@@ -434,9 +419,7 @@
 # CONFIG_HAMRADIO is not set
 # CONFIG_IRDA is not set
 # CONFIG_BT is not set
-CONFIG_AF_RXRPC=m
-# CONFIG_AF_RXRPC_DEBUG is not set
-# CONFIG_RXKAD is not set
+# CONFIG_AF_RXRPC is not set
 CONFIG_FIB_RULES=y
 
 #
@@ -447,6 +430,7 @@
 # CONFIG_MAC80211 is not set
 # CONFIG_IEEE80211 is not set
 # CONFIG_RFKILL is not set
+# CONFIG_NET_9P is not set
 
 #
 # Device Drivers
@@ -459,21 +443,9 @@
 CONFIG_PREVENT_FIRMWARE_BUILD=y
 CONFIG_FW_LOADER=y
 # CONFIG_SYS_HYPERVISOR is not set
-
-#
-# Connector - unified userspace <-> kernelspace linker
-#
 CONFIG_CONNECTOR=m
 # CONFIG_MTD is not set
-
-#
-# Parallel port support
-#
 # CONFIG_PARPORT is not set
-
-#
-# Plug and Play support
-#
 CONFIG_PNP=y
 # CONFIG_PNP_DEBUG is not set
 
@@ -483,10 +455,7 @@
 CONFIG_ISAPNP=y
 # CONFIG_PNPBIOS is not set
 CONFIG_PNPACPI=y
-
-#
-# Block devices
-#
+CONFIG_BLK_DEV=y
 # CONFIG_BLK_DEV_FD is not set
 # CONFIG_BLK_DEV_XD is not set
 # CONFIG_BLK_CPQ_DA is not set
@@ -495,7 +464,7 @@
 # CONFIG_BLK_DEV_UMEM is not set
 # CONFIG_BLK_DEV_COW_COMMON is not set
 CONFIG_BLK_DEV_LOOP=y
-# CONFIG_BLK_DEV_CRYPTOLOOP is not set
+CONFIG_BLK_DEV_CRYPTOLOOP=m
 # CONFIG_BLK_DEV_NBD is not set
 # CONFIG_BLK_DEV_SX8 is not set
 # CONFIG_BLK_DEV_UB is not set
@@ -504,18 +473,16 @@
 CONFIG_CDROM_PKTCDVD_BUFFERS=8
 # CONFIG_CDROM_PKTCDVD_WCACHE is not set
 # CONFIG_ATA_OVER_ETH is not set
-
-#
-# Misc devices
-#
-CONFIG_IBM_ASM=m
+CONFIG_MISC_DEVICES=y
+# CONFIG_IBM_ASM is not set
 # CONFIG_PHANTOM is not set
-CONFIG_SGI_IOC4=m
+# CONFIG_EEPROM_93CX6 is not set
+# CONFIG_SGI_IOC4 is not set
 CONFIG_TIFM_CORE=m
-CONFIG_TIFM_7XX1=m
-CONFIG_MSI_LAPTOP=m
-CONFIG_SONY_LAPTOP=m
-# CONFIG_SONYPI_COMPAT is not set
+# CONFIG_TIFM_7XX1 is not set
+# CONFIG_ASUS_LAPTOP is not set
+# CONFIG_MSI_LAPTOP is not set
+# CONFIG_SONY_LAPTOP is not set
 # CONFIG_THINKPAD_ACPI is not set
 CONFIG_IDE=y
 CONFIG_BLK_DEV_IDE=y
@@ -530,7 +497,7 @@
 CONFIG_BLK_DEV_IDECD=y
 # CONFIG_BLK_DEV_IDETAPE is not set
 # CONFIG_BLK_DEV_IDEFLOPPY is not set
-CONFIG_BLK_DEV_IDESCSI=m
+CONFIG_BLK_DEV_IDESCSI=y
 # CONFIG_BLK_DEV_IDEACPI is not set
 # CONFIG_IDE_TASK_IOCTL is not set
 CONFIG_IDE_PROC_FS=y
@@ -540,7 +507,7 @@
 #
 CONFIG_IDE_GENERIC=y
 # CONFIG_BLK_DEV_CMD640 is not set
-CONFIG_BLK_DEV_IDEPNP=y
+# CONFIG_BLK_DEV_IDEPNP is not set
 CONFIG_BLK_DEV_IDEPCI=y
 CONFIG_IDEPCI_SHARE_IRQ=y
 CONFIG_IDEPCI_PCIBUS_ORDER=y
@@ -590,6 +557,7 @@
 #
 CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
+CONFIG_SCSI_DMA=y
 CONFIG_SCSI_TGT=y
 CONFIG_SCSI_NETLINK=y
 CONFIG_SCSI_PROC_FS=y
@@ -608,7 +576,7 @@
 #
 # Some SCSI devices (e.g. CD jukebox) support multiple LUNs
 #
-# CONFIG_SCSI_MULTI_LUN is not set
+CONFIG_SCSI_MULTI_LUN=y
 # CONFIG_SCSI_CONSTANTS is not set
 # CONFIG_SCSI_LOGGING is not set
 # CONFIG_SCSI_SCAN_ASYNC is not set
@@ -622,11 +590,9 @@
 CONFIG_SCSI_ISCSI_ATTRS=y
 CONFIG_SCSI_SAS_ATTRS=y
 CONFIG_SCSI_SAS_LIBSAS=y
+# CONFIG_SCSI_SAS_ATA is not set
 # CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
-
-#
-# SCSI low-level drivers
-#
+CONFIG_SCSI_LOWLEVEL=y
 CONFIG_ISCSI_TCP=y
 CONFIG_BLK_DEV_3W_XXXX_RAID=y
 CONFIG_SCSI_3W_9XXX=y
@@ -768,75 +734,32 @@
 # CONFIG_PATA_VIA is not set
 # CONFIG_PATA_WINBOND is not set
 # CONFIG_PATA_WINBOND_VLB is not set
-
-#
-# Old CD-ROM drivers (not SCSI, not IDE)
-#
-# CONFIG_CD_NO_IDESCSI is not set
-
-#
-# Multi-device support (RAID and LVM)
-#
 # CONFIG_MD is not set
 
 #
 # Fusion MPT device support
 #
-CONFIG_FUSION=y
-CONFIG_FUSION_SPI=y
-CONFIG_FUSION_FC=y
-CONFIG_FUSION_SAS=y
-CONFIG_FUSION_MAX_SGE=128
-CONFIG_FUSION_CTL=m
+# CONFIG_FUSION is not set
+# CONFIG_FUSION_SPI is not set
+# CONFIG_FUSION_FC is not set
+# CONFIG_FUSION_SAS is not set
 
 #
 # IEEE 1394 (FireWire) support
 #
 # CONFIG_FIREWIRE is not set
-CONFIG_IEEE1394=y
-
-#
-# Subsystem Options
-#
-# CONFIG_IEEE1394_VERBOSEDEBUG is not set
-
-#
-# Controllers
-#
-CONFIG_IEEE1394_PCILYNX=m
-CONFIG_IEEE1394_OHCI1394=y
-
-#
-# Protocols
-#
-CONFIG_IEEE1394_VIDEO1394=m
-CONFIG_IEEE1394_SBP2=y
-# CONFIG_IEEE1394_SBP2_PHYS_DMA is not set
-CONFIG_IEEE1394_ETH1394_ROM_ENTRY=y
-CONFIG_IEEE1394_ETH1394=m
-CONFIG_IEEE1394_DV1394=m
-CONFIG_IEEE1394_RAWIO=m
-
-#
-# I2O device support
-#
+# CONFIG_IEEE1394 is not set
 # CONFIG_I2O is not set
 # CONFIG_MACINTOSH_DRIVERS is not set
-
-#
-# Network device support
-#
 CONFIG_NETDEVICES=y
+# CONFIG_NETDEVICES_MULTIQUEUE is not set
 # CONFIG_DUMMY is not set
 # CONFIG_BONDING is not set
+# CONFIG_MACVLAN is not set
 # CONFIG_EQUALIZER is not set
 # CONFIG_TUN is not set
 # CONFIG_NET_SB1000 is not set
 # CONFIG_ARCNET is not set
-
-#
-# Ethernet (10 or 100Mbit)
-#
 # CONFIG_NET_ETHERNET is not set
 CONFIG_MII=m
 CONFIG_NETDEV_1000=y
@@ -899,15 +822,7 @@
 # CONFIG_NETCONSOLE is not set
 # CONFIG_NETPOLL is not set
 # CONFIG_NET_POLL_CONTROLLER is not set
-
-#
-# ISDN subsystem
-#
 # CONFIG_ISDN is not set
-
-#
-# Telephony Support
-#
 # CONFIG_PHONE is not set
 
 #
@@ -915,7 +830,7 @@
 #
 CONFIG_INPUT=y
 CONFIG_INPUT_FF_MEMLESS=y
-# CONFIG_INPUT_POLLDEV is not set
+CONFIG_INPUT_POLLDEV=m
 
 #
 # Userland interfaces
@@ -979,6 +894,7 @@
 # CONFIG_JOYSTICK_XPAD is not set
 # CONFIG_INPUT_TABLET is not set
 CONFIG_INPUT_TOUCHSCREEN=y
+# CONFIG_TOUCHSCREEN_FUJITSU is not set
 CONFIG_TOUCHSCREEN_GUNZE=m
 CONFIG_TOUCHSCREEN_ELO=m
 CONFIG_TOUCHSCREEN_MTOUCH=m
@@ -1029,6 +945,7 @@
 #
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_FIX_EARLYCON_MEM=y
 CONFIG_SERIAL_8250_PCI=y
 CONFIG_SERIAL_8250_PNP=y
 CONFIG_SERIAL_8250_NR_UARTS=4
@@ -1052,11 +969,12 @@
 CONFIG_SERIAL_JSM=m
 CONFIG_UNIX98_PTYS=y
 # CONFIG_LEGACY_PTYS is not set
-
-#
-# IPMI
-#
-# CONFIG_IPMI_HANDLER is not set
+CONFIG_IPMI_HANDLER=m
+# CONFIG_IPMI_PANIC_EVENT is not set
+CONFIG_IPMI_DEVICE_INTERFACE=m
+CONFIG_IPMI_SI=m
+CONFIG_IPMI_WATCHDOG=m
+CONFIG_IPMI_POWEROFF=m
 # CONFIG_WATCHDOG is not set
 # CONFIG_HW_RANDOM is not set
 # CONFIG_NVRAM is not set
@@ -1095,16 +1013,12 @@
 # CONFIG_RAW_DRIVER is not set
 # CONFIG_HPET is not set
 # CONFIG_HANGCHECK_TIMER is not set
-
-#
-# TPM devices
-#
 # CONFIG_TCG_TPM is not set
 # CONFIG_TELCLOCK is not set
 CONFIG_DEVPORT=y
 CONFIG_I2C=m
 CONFIG_I2C_BOARDINFO=y
-CONFIG_I2C_CHARDEV=m
+# CONFIG_I2C_CHARDEV is not set
 
 #
 # I2C Algorithms
@@ -1136,6 +1050,7 @@
 CONFIG_I2C_SIS5595=m
 CONFIG_I2C_SIS630=m
 CONFIG_I2C_SIS96X=m
+# CONFIG_I2C_TAOS_EVM is not set
 CONFIG_I2C_STUB=m
 # CONFIG_I2C_TINY_USB is not set
 CONFIG_I2C_VIA=m
@@ -1148,11 +1063,13 @@
 #
 CONFIG_SENSORS_DS1337=m
 CONFIG_SENSORS_DS1374=m
+# CONFIG_DS1682 is not set
 CONFIG_SENSORS_EEPROM=m
 CONFIG_SENSORS_PCF8574=m
 CONFIG_SENSORS_PCA9539=m
 CONFIG_SENSORS_PCF8591=m
 CONFIG_SENSORS_MAX6875=m
+# CONFIG_SENSORS_TSL2550 is not set
 # CONFIG_I2C_DEBUG_CORE is not set
 # CONFIG_I2C_DEBUG_ALGO is not set
 # CONFIG_I2C_DEBUG_BUS is not set
@@ -1163,11 +1080,25 @@
 #
 # CONFIG_SPI is not set
 # CONFIG_SPI_MASTER is not set
+CONFIG_W1=m
+CONFIG_W1_CON=y
+
+#
+# 1-wire Bus Masters
+#
+CONFIG_W1_MASTER_MATROX=m
+CONFIG_W1_MASTER_DS2490=m
+CONFIG_W1_MASTER_DS2482=m
 
 #
-# Dallas's 1-wire bus
+# 1-wire Slaves
 #
-# CONFIG_W1 is not set
+CONFIG_W1_SLAVE_THERM=m
+CONFIG_W1_SLAVE_SMEM=m
+CONFIG_W1_SLAVE_DS2433=m
+CONFIG_W1_SLAVE_DS2433_CRC=y
+# CONFIG_W1_SLAVE_DS2760 is not set
+# CONFIG_POWER_SUPPLY is not set
 # CONFIG_HWMON is not set
 
 #
@@ -1255,6 +1186,7 @@
 CONFIG_VIDEO_SAA5246A=m
 CONFIG_VIDEO_SAA5249=m
 CONFIG_TUNER_3036=m
+# CONFIG_TUNER_TEA5761 is not set
 CONFIG_VIDEO_STRADIS=m
 CONFIG_VIDEO_ZORAN_ZR36060=m
 CONFIG_VIDEO_ZORAN=m
@@ -1264,7 +1196,6 @@
 CONFIG_VIDEO_ZORAN_LML33=m
 CONFIG_VIDEO_ZORAN_LML33R10=m
 CONFIG_VIDEO_ZORAN_AVS6EYES=m
-CONFIG_VIDEO_MEYE=m
 CONFIG_VIDEO_SAA7134=m
 CONFIG_VIDEO_SAA7134_ALSA=m
 CONFIG_VIDEO_SAA7134_DVB=m
@@ -1357,6 +1288,7 @@
 CONFIG_DVB_USB_TTUSB2=m
 CONFIG_DVB_USB_DTT200U=m
 # CONFIG_DVB_USB_OPERA1 is not set
+# CONFIG_DVB_USB_AF9005 is not set
 CONFIG_DVB_TTUSB_BUDGET=m
 CONFIG_DVB_TTUSB_DEC=m
 CONFIG_DVB_CINERGYT2=m
@@ -1460,6 +1392,7 @@
 CONFIG_VIDEO_BUF=m
 CONFIG_VIDEO_BUF_DVB=m
 CONFIG_VIDEO_BTCX=m
+CONFIG_VIDEO_IR_I2C=m
 CONFIG_VIDEO_IR=m
 CONFIG_VIDEO_TVEEPROM=m
 CONFIG_DAB=y
@@ -1477,16 +1410,16 @@
 #
 # CONFIG_DISPLAY_SUPPORT is not set
 # CONFIG_VGASTATE is not set
+CONFIG_VIDEO_OUTPUT_CONTROL=m
 # CONFIG_FB is not set
 
 #
 # Console display driver support
 #
 CONFIG_VGA_CONSOLE=y
-CONFIG_VGACON_SOFT_SCROLLBACK=y
-CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
-CONFIG_VIDEO_SELECT=y
-CONFIG_MDA_CONSOLE=m
+# CONFIG_VGACON_SOFT_SCROLLBACK is not set
+# CONFIG_VIDEO_SELECT is not set
+# CONFIG_MDA_CONSOLE is not set
 CONFIG_DUMMY_CONSOLE=y
 
 #
@@ -1574,6 +1507,7 @@
 # CONFIG_SND_CMIPCI is not set
 # CONFIG_SND_CS4281 is not set
 # CONFIG_SND_CS46XX is not set
+# CONFIG_SND_CS5530 is not set
 # CONFIG_SND_CS5535AUDIO is not set
 # CONFIG_SND_DARLA20 is not set
 # CONFIG_SND_GINA20 is not set
@@ -1631,14 +1565,15 @@
 # CONFIG_SND_SOC is not set
 
 #
-# Open Sound System
+# SoC Audio support for SuperH
 #
-# CONFIG_SOUND_PRIME is not set
-CONFIG_AC97_BUS=y
 
 #
-# HID Devices
+# Open Sound System
 #
+# CONFIG_SOUND_PRIME is not set
+CONFIG_AC97_BUS=y
+CONFIG_HID_SUPPORT=y
 CONFIG_HID=y
 # CONFIG_HID_DEBUG is not set
 
@@ -1654,10 +1589,7 @@
 CONFIG_THRUSTMASTER_FF=y
 CONFIG_ZEROPLUS_FF=y
 CONFIG_USB_HIDDEV=y
-
-#
-# USB support
-#
+CONFIG_USB_SUPPORT=y
 CONFIG_USB_ARCH_HAS_HCD=y
 CONFIG_USB_ARCH_HAS_OHCI=y
 CONFIG_USB_ARCH_HAS_EHCI=y
@@ -1671,16 +1603,16 @@
 # CONFIG_USB_DEVICE_CLASS is not set
 # CONFIG_USB_DYNAMIC_MINORS is not set
 # CONFIG_USB_SUSPEND is not set
+# CONFIG_USB_PERSIST is not set
 # CONFIG_USB_OTG is not set
 
 #
 # USB Host Controller Drivers
 #
-CONFIG_USB_EHCI_HCD=m
+CONFIG_USB_EHCI_HCD=y
 CONFIG_USB_EHCI_SPLIT_ISO=y
 CONFIG_USB_EHCI_ROOT_HUB_TT=y
 CONFIG_USB_EHCI_TT_NEWSCHED=y
-# CONFIG_USB_EHCI_BIG_ENDIAN_MMIO is not set
 # CONFIG_USB_ISP116X_HCD is not set
 CONFIG_USB_OHCI_HCD=y
 # CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
@@ -1688,6 +1620,7 @@
 CONFIG_USB_OHCI_LITTLE_ENDIAN=y
 CONFIG_USB_UHCI_HCD=y
 # CONFIG_USB_SL811_HCD is not set
+# CONFIG_USB_R8A66597_HCD is not set
 
 #
 # USB Device Class drivers
@@ -1772,6 +1705,7 @@
 # MMC/SD Card Drivers
 #
 CONFIG_MMC_BLOCK=m
+CONFIG_MMC_BLOCK_BOUNCE=y
 
 #
 # MMC/SD Host Controller Drivers
@@ -1779,11 +1713,8 @@
 CONFIG_MMC_SDHCI=m
 CONFIG_MMC_WBSD=m
 CONFIG_MMC_TIFM_SD=m
-
-#
-# LED devices
-#
-# CONFIG_NEW_LEDS is not set
+CONFIG_NEW_LEDS=y
+CONFIG_LEDS_CLASS=m
 
 #
 # LED drivers
@@ -1792,20 +1723,9 @@
 #
 # LED Triggers
 #
-
-#
-# InfiniBand support
-#
+# CONFIG_LEDS_TRIGGERS is not set
 # CONFIG_INFINIBAND is not set
-
-#
-# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
-#
 # CONFIG_EDAC is not set
-
-#
-# Real Time Clock
-#
 # CONFIG_RTC_CLASS is not set
 
 #
@@ -1816,17 +1736,19 @@
 #
 # DMA Clients
 #
-CONFIG_NET_DMA=y
+# CONFIG_NET_DMA is not set
 
 #
 # DMA Devices
 #
 CONFIG_INTEL_IOATDMA=m
+CONFIG_VIRTUALIZATION=y
+# CONFIG_KVM is not set
 
 #
-# Virtualization
+# Userspace I/O
 #
-# CONFIG_KVM is not set
+# CONFIG_UIO is not set
 
 #
 # File systems
@@ -1919,24 +1841,25 @@
 # CONFIG_NFS_V3_ACL is not set
 # CONFIG_NFS_V4 is not set
 # CONFIG_NFS_DIRECTIO is not set
-CONFIG_NFSD=y
-# CONFIG_NFSD_V3 is not set
-# CONFIG_NFSD_TCP is not set
+CONFIG_NFSD=m
+CONFIG_NFSD_V3=y
+# CONFIG_NFSD_V3_ACL is not set
+CONFIG_NFSD_V4=y
+CONFIG_NFSD_TCP=y
 CONFIG_LOCKD=y
 CONFIG_LOCKD_V4=y
-CONFIG_EXPORTFS=y
+CONFIG_EXPORTFS=m
 CONFIG_NFS_COMMON=y
 CONFIG_SUNRPC=y
-CONFIG_SUNRPC_GSS=y
+CONFIG_SUNRPC_GSS=m
 # CONFIG_SUNRPC_BIND34 is not set
-CONFIG_RPCSEC_GSS_KRB5=y
+CONFIG_RPCSEC_GSS_KRB5=m
 # CONFIG_RPCSEC_GSS_SPKM3 is not set
 # CONFIG_SMB_FS is not set
 # CONFIG_CIFS is not set
 # CONFIG_NCP_FS is not set
 # CONFIG_CODA_FS is not set
 # CONFIG_AFS_FS is not set
-# CONFIG_9P_FS is not set
 
 #
 # Partition Types
@@ -1993,10 +1916,7 @@
 #
 CONFIG_DLM=m
 # CONFIG_DLM_DEBUG is not set
-
-#
-# Instrumentation Support
-#
+CONFIG_INSTRUMENTATION=y
 # CONFIG_PROFILING is not set
 # CONFIG_KPROBES is not set
 
@@ -2013,6 +1933,8 @@
 # CONFIG_DEBUG_KERNEL is not set
 CONFIG_DEBUG_BUGVERBOSE=y
 CONFIG_EARLY_PRINTK=y
+CONFIG_X86_FIND_SMP_CONFIG=y
+CONFIG_X86_MPPARSE=y
 CONFIG_DOUBLEFAULT=y
 
 #
@@ -2023,12 +1945,8 @@
 CONFIG_SECURITY=y
 CONFIG_SECURITY_NETWORK=y
 CONFIG_SECURITY_NETWORK_XFRM=y
-CONFIG_SECURITY_CAPABILITIES=m
+CONFIG_SECURITY_CAPABILITIES=y
 CONFIG_SECURITY_ROOTPLUG=m
-
-#
-# Cryptographic options
-#
 CONFIG_CRYPTO=y
 CONFIG_CRYPTO_ALGAPI=y
 CONFIG_CRYPTO_BLKCIPHER=y
@@ -2070,10 +1988,7 @@
 CONFIG_CRYPTO_CRC32C=y
 CONFIG_CRYPTO_CAMELLIA=y
 CONFIG_CRYPTO_TEST=m
-
-#
-# Hardware crypto devices
-#
+CONFIG_CRYPTO_HW=y
 CONFIG_CRYPTO_DEV_PADLOCK=m
 CONFIG_CRYPTO_DEV_PADLOCK_AES=m
 CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
@@ -2087,6 +2002,7 @@
 CONFIG_CRC16=m
 # CONFIG_CRC_ITU_T is not set
 CONFIG_CRC32=y
+# CONFIG_CRC7 is not set
 CONFIG_LIBCRC32C=y
 CONFIG_ZLIB_INFLATE=y
 CONFIG_ZLIB_DEFLATE=y
@@ -2094,6 +2010,7 @@
 CONFIG_HAS_IOMEM=y
 CONFIG_HAS_IOPORT=y
 CONFIG_HAS_DMA=y
+CONFIG_CHECK_SIGNATURE=y
 CONFIG_GENERIC_HARDIRQS=y
 CONFIG_GENERIC_IRQ_PROBE=y
 CONFIG_X86_BIOS_REBOOT=y

--Boundary-00=_eLZDHCxOdAfx+/Z--
