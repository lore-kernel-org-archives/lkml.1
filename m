Return-Path: <linux-kernel-owner+w=401wt.eu-S1759037AbXLNPsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759037AbXLNPsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 10:48:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754131AbXLNPr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 10:47:58 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:57897 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbXLNPrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 10:47:55 -0500
Date: Fri, 14 Dec 2007 21:17:11 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Greg KH <gregkh@suse.de>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, maneesh@linux.vnet.ibm.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Gautham Shenoy <ego@in.ibm.com>
Subject: Re: 2.6.22-stable causes oomkiller to be invoked
Message-ID: <20071214154711.GD23670@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20071213123333.GA16905@linux.vnet.ibm.com> <20071213132326.GC16905@linux.vnet.ibm.com> <20071213151847.GB5676@linux.vnet.ibm.com> <20071213162936.GA7635@suse.de> <20071213164658.GA30865@linux.vnet.ibm.com> <20071213175423.GA2977@linux.vnet.ibm.com> <476295FF.1040202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476295FF.1040202@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > OK, so it ooms there as well. I am attaching its config and part of the
> > dmesg (whatever I could capture).
> 
> I can't reproduce it here either.  Please apply the attached patch and
> reproduce the problem.  It will report the number of allocated buffer
> pages every 10 sec.  After oom occurs, please report how this number
> changed and the result of 'cat /proc/slabinfo'.
> 

Here you go.

elay using timer specific routine.. 4976.59 BogoMIPS (lpj=9953199)
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 00004400 00000000 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: L3 cache: 1024K
CPU: Physical Processor ID: 3
CPU: After all inits, caps: bfebfbff 00000000 00000000 0000b080 00004400 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#6.
CPU6: Intel P4/Xeon Extended MCE MSRs (12) available
CPU6: Thermal monitoring enabled
CPU6: Intel(R) Xeon(TM) MP CPU 2.50GHz stepping 05
lockdep: not fixing up alternatives.
Booting processor 7/7 ip 3000
Initializing CPU#7
Calibrating delay using timer specific routine.. 4976.45 BogoMIPS (lpj=9952905)
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 00004400 00000000 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: L3 cache: 1024K
CPU: Physical Processor ID: 3
CPU: After all inits, caps: bfebfbff 00000000 00000000 0000b080 00004400 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#7.
CPU7: Intel P4/Xeon Extended MCE MSRs (12) available
CPU7: Thermal monitoring enabled
CPU7: Intel(R) Xeon(TM) MP CPU 2.50GHz stepping 05
Total of 8 processors activated (39819.96 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
APIC timer registered as dummy, due to nmi_watchdog=1!
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
checking TSC synchronization [CPU#0 -> CPU#4]: passed.
checking TSC synchronization [CPU#0 -> CPU#5]: passed.
checking TSC synchronization [CPU#0 -> CPU#6]: passed.
checking TSC synchronization [CPU#0 -> CPU#7]: passed.
Brought up 8 CPUs
net_namespace: 136 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd74c, last bus=12
PCI: Using configuration type 1
Setting up standard PCI resources
evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x7
evgpeblk-0956 [00] ev_create_gpe_block   : GPE 20 to 3F [_GPE] 4 regs on int 0x7
evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 1 Wake, Enabled 0 Runtime GPEs in this block
evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 0 Wake, Enabled 1 Runtime GPEs in this block
ACPI: EC: Look up EC in DSDT
Completing Region/Field/Buffer/Package initialization:.................................
Initialized 8/13 Regions 0/0 Fields 8/8 Buffers 17/18 Packages (999 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:.
Executed 1 _INI methods requiring 0 _STA executions (examined 123 objects)
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Root Bridge [PCI1] (0000:01)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1._PRT]
ACPI: PCI Root Bridge [PCI2] (0000:05)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI2._PRT]
ACPI: PCI Root Bridge [PCI3] (0000:08)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI3._PRT]
ACPI: PCI Root Bridge [PCI4] (0000:09)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI4._PRT]
ACPI: PCI Interrupt Link [LP00] (IRQs *10)
ACPI: Blank IRQ resource
ACPI: Resource is not an IRQ entry
ACPI: PCI Interrupt Link [LP01] (IRQs) *0, disabled.
ACPI: Blank IRQ resource
ACPI: Resource is not an IRQ entry
ACPI: PCI Interrupt Link [LP02] (IRQs) *0, disabled.
ACPI: Blank IRQ resource
ACPI: Resource is not an IRQ entry
ACPI: PCI Interrupt Link [LP03] (IRQs) *0, disabled.
ACPI: PCI Interrupt Link [LP04] (IRQs *5)
ACPI: PCI Interrupt Link [LP05] (IRQs *5)
ACPI: PCI Interrupt Link [LP06] (IRQs *5)
ACPI: PCI Interrupt Link [LP07] (IRQs *5)
ACPI: PCI Interrupt Link [LP08] (IRQs *5)
ACPI: PCI Interrupt Link [LP09] (IRQs *5)
ACPI: PCI Interrupt Link [LP0A] (IRQs *5)
ACPI: PCI Interrupt Link [LP0B] (IRQs *5)
ACPI: PCI Interrupt Link [LP0C] (IRQs *5)
ACPI: PCI Interrupt Link [LP0D] (IRQs *5)
ACPI: PCI Interrupt Link [LP0E] (IRQs *5)
ACPI: PCI Interrupt Link [LP0F] (IRQs *5)
ACPI: PCI Interrupt Link [LP10] (IRQs *5)
ACPI: PCI Interrupt Link [LP11] (IRQs *5)
ACPI: PCI Interrupt Link [LP12] (IRQs *5)
ACPI: PCI Interrupt Link [LP13] (IRQs *5)
ACPI: PCI Interrupt Link [LP14] (IRQs *5)
ACPI: PCI Interrupt Link [LP15] (IRQs *5)
ACPI: PCI Interrupt Link [LP16] (IRQs *5)
ACPI: PCI Interrupt Link [LP17] (IRQs *5)
ACPI: PCI Interrupt Link [LP18] (IRQs *5)
ACPI: PCI Interrupt Link [LP19] (IRQs *5)
ACPI: PCI Interrupt Link [LP1A] (IRQs *5)
ACPI: PCI Interrupt Link [LP1B] (IRQs *5)
ACPI: PCI Interrupt Link [LP1C] (IRQs *9)
ACPI: PCI Interrupt Link [LP1D] (IRQs *9)
ACPI: Blank IRQ resource
ACPI: Resource is not an IRQ entry
ACPI: PCI Interrupt Link [LP1E] (IRQs) *0, disabled.
ACPI: PCI Interrupt Link [LP1F] (IRQs *3)
ACPI: PCI Interrupt Link [LPUS] (IRQs *11)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
Clocksource tsc unstable (delta = 263383199 ns)
pnp: PnP ACPI: found 16 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
system 00:01: ioport range 0x900-0x93f has been reserved
system 00:01: ioport range 0x510-0x517 has been reserved
system 00:01: ioport range 0x504-0x507 has been reserved
system 00:01: ioport range 0x500-0x503 has been reserved
system 00:01: ioport range 0x520-0x53f has been reserved
system 00:01: ioport range 0x420-0x427 has been reserved
system 00:01: ioport range 0x460-0x461 has been reserved
system 00:0b: ioport range 0x1ec-0x1ef has been reserved
system 00:0b: ioport range 0x400-0x4fe could not be reserved
system 00:0b: ioport range 0x600-0x600 has been reserved
system 00:0b: ioport range 0x800-0x80f has been reserved
system 00:0b: ioport range 0xc00-0xcfe could not be reserved
system 00:0b: ioport range 0xf50-0xf58 has been reserved
system 00:0b: iomem range 0xfec00000-0xffffffff could not be reserved
NET: Registered protocol family 2
Time: acpi_pm clocksource has been installed.
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 377k freed
Machine check exception polling timer started.
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
audit: initializing netlink socket (disabled)
audit(1197666594.812:1): initialized
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
Boot video device is 0000:00:07.0
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.103
agpgart: suspend/resume problematic: resume with 3D/DRI active may lockup X.Org
on some chipset/BIOS combos (see DEBUG_AGP_PM in intel-agp.c)
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:00:07.0[A] -> GSI 16 (level, low) -> IRQ 16
[drm] Initialized radeon 1.28.0 20060524 on minor 0
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Hangcheck: Using get_cycles().
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
brd: module loaded
loop: module loaded
Ethernet Channel Bonding Driver: v3.2.3 (December 6, 2007)
bonding: Warning: either miimon or arp_interval and arp_ip_target module parameters must be specified, otherwise bonding will not detect link failures! see bonding.txt for details.
tg3.c:v3.86 (November 9, 2007)
ACPI: PCI Interrupt 0000:09:08.0[A] -> GSI 47 (level, low) -> IRQ 47
eth0: Tigon3 [partno(BCM95703) rev 1002 PHY(5703)] (PCIX:100MHz:64-bit) 10/100/1000Base-T Ethernet 00:02:55:df:b4:13
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth0: dma_rwctrl[769c4000] dma_mask[64-bit]
PPP generic driver version 2.4.2
console [netcon0] enabled
netconsole: network logging started
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Probing IDE interface ide0...
hda: SAMSUNG CD-ROM SC-148A, ATAPI CD/DVD-ROM drive
Probing IDE interface ide1...
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: ATAPI 48X CD-ROM drive, 128kB Cache
Uniform CD-ROM driver Revision: 3.20
PCI: Enabling device 0000:08:0a.0 (0156 -> 0157)
ACPI: PCI Interrupt 0000:08:0a.0[A] -> GSI 44 (level, low) -> IRQ 44
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
        <Adaptec aic7899 Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

PCI: Enabling device 0000:08:0a.1 (0156 -> 0157)
ACPI: PCI Interrupt 0000:08:0a.1[B] -> GSI 45 (level, low) -> IRQ 45
scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
        <Adaptec aic7899 Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel B, SCSI Id=7, 32/253 SCBs

scsi 1:0:0:0: Direct-Access     IBM-ESXS DTN036C3UCDY10FN S27Y PQ: 0 ANSI: 3
scsi1:A:0:0: Tagged Queuing enabled.  Depth 32
 target1:0:0: Beginning Domain Validation
 target1:0:0: wide asynchronous
 target1:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
 target1:0:0: Ending Domain Validation
scsi 1:0:1:0: Direct-Access     IBM-ESXS DTN036C3UCDY10FN S27Y PQ: 0 ANSI: 3
scsi1:A:1:0: Tagged Queuing enabled.  Depth 32
 target1:0:1: Beginning Domain Validation
 target1:0:1: wide asynchronous
 target1:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
 target1:0:1: Ending Domain Validation
scsi 1:0:2:0: Direct-Access     IBM-ESXS DTN036C3UCDY10FN S27Y PQ: 0 ANSI: 3
scsi1:A:2:0: Tagged Queuing enabled.  Depth 32
 target1:0:2: Beginning Domain Validation
 target1:0:2: wide asynchronous
 target1:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
 target1:0:2: Ending Domain Validation
scsi 1:0:3:0: Direct-Access     IBM-ESXS DTN036C3UCDY10FN S27Y PQ: 0 ANSI: 3
scsi1:A:3:0: Tagged Queuing enabled.  Depth 32
 target1:0:3: Beginning Domain Validation
 target1:0:3: wide asynchronous
 target1:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
 target1:0:3: Ending Domain Validation
scsi 1:0:4:0: Direct-Access     IBM-ESXS DTN036C3UCDY10FN S27Y PQ: 0 ANSI: 3
scsi1:A:4:0: Tagged Queuing enabled.  Depth 32
 target1:0:4: Beginning Domain Validation
 target1:0:4: wide asynchronous
 target1:0:4: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
 target1:0:4: Ending Domain Validation
scsi 1:0:5:0: Direct-Access     IBM-ESXS ST336607LC    FN B25H PQ: 0 ANSI: 3
scsi1:A:5:0: Tagged Queuing enabled.  Depth 32
 target1:0:5: Beginning Domain Validation
 target1:0:5: wide asynchronous
 target1:0:5: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 63)
 target1:0:5: Ending Domain Validation
scsi 1:0:8:0: Processor         IBM      02R0980a S320  1 1    PQ: 0 ANSI: 2
 target1:0:8: Beginning Domain Validation
 target1:0:8: Ending Domain Validation
PCI: Unable to reserve mem region #2:1000@edfff000 for device 0000:08:0a.0
aic7xxx: <Adaptec AIC-7899 Ultra 160/m SCSI host adapter> at PCI 8/10/0
aic7xxx: I/O ports already in use, ignoring.
PCI: Unable to reserve mem region #2:1000@edffe000 for device 0000:08:0a.1
aic7xxx: <Adaptec AIC-7899 Ultra 160/m SCSI host adapter> at PCI 8/10/1
aic7xxx: I/O ports already in use, ignoring.
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
megasas: 00.00.03.16-rc1 Thu. Nov. 07 10:09:32 PDT 2007
st: Version 20070203, fixed bufsize 32768, s/g segs 256
osst :I: Tape driver with OnStream support version 0.99.4
osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
sd 1:0:0:0: [sda] 71096640 512-byte hardware sectors (36401 MB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: cb 00 00 08
sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sda] 71096640 512-byte hardware sectors (36401 MB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: cb 00 00 08
sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1
sd 1:0:0:0: [sda] Attached SCSI disk
sd 1:0:1:0: [sdb] 71096640 512-byte hardware sectors (36401 MB)
sd 1:0:1:0: [sdb] Write Protect is off
sd 1:0:1:0: [sdb] Mode Sense: cb 00 00 08
sd 1:0:1:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:1:0: [sdb] 71096640 512-byte hardware sectors (36401 MB)
sd 1:0:1:0: [sdb] Write Protect is off
sd 1:0:1:0: [sdb] Mode Sense: cb 00 00 08
sd 1:0:1:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3 sdb4
sd 1:0:1:0: [sdb] Attached SCSI disk
sd 1:0:2:0: [sdc] 71096640 512-byte hardware sectors (36401 MB)
sd 1:0:2:0: [sdc] Write Protect is off
sd 1:0:2:0: [sdc] Mode Sense: cb 00 00 08
sd 1:0:2:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:2:0: [sdc] 71096640 512-byte hardware sectors (36401 MB)
sd 1:0:2:0: [sdc] Write Protect is off
sd 1:0:2:0: [sdc] Mode Sense: cb 00 00 08
sd 1:0:2:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1 sdc2
sd 1:0:2:0: [sdc] Attached SCSI disk
sd 1:0:3:0: [sdd] 71096640 512-byte hardware sectors (36401 MB)
sd 1:0:3:0: [sdd] Write Protect is off
sd 1:0:3:0: [sdd] Mode Sense: cb 00 00 08
sd 1:0:3:0: [sdd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:3:0: [sdd] 71096640 512-byte hardware sectors (36401 MB)
sd 1:0:3:0: [sdd] Write Protect is off
sd 1:0:3:0: [sdd] Mode Sense: cb 00 00 08
sd 1:0:3:0: [sdd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdd: sdd1 sdd2 sdd3
sd 1:0:3:0: [sdd] Attached SCSI disk
sd 1:0:4:0: [sde] 71096640 512-byte hardware sectors (36401 MB)
sd 1:0:4:0: [sde] Write Protect is off
sd 1:0:4:0: [sde] Mode Sense: cb 00 00 08
sd 1:0:4:0: [sde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:4:0: [sde] 71096640 512-byte hardware sectors (36401 MB)
sd 1:0:4:0: [sde] Write Protect is off
sd 1:0:4:0: [sde] Mode Sense: cb 00 00 08
sd 1:0:4:0: [sde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sde: sde1
sd 1:0:4:0: [sde] Attached SCSI disk
sd 1:0:5:0: [sdf] 71096640 512-byte hardware sectors (36401 MB)
sd 1:0:5:0: [sdf] Write Protect is off
sd 1:0:5:0: [sdf] Mode Sense: b3 00 10 08
sd 1:0:5:0: [sdf] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 1:0:5:0: [sdf] 71096640 512-byte hardware sectors (36401 MB)
sd 1:0:5:0: [sdf] Write Protect is off
sd 1:0:5:0: [sdf] Mode Sense: b3 00 10 08
sd 1:0:5:0: [sdf] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdf: sdf1
sd 1:0:5:0: [sdf] Attached SCSI disk
sd 1:0:0:0: Attached scsi generic sg0 type 0
sd 1:0:1:0: Attached scsi generic sg1 type 0
sd 1:0:2:0: Attached scsi generic sg2 type 0
sd 1:0:3:0: Attached scsi generic sg3 type 0
sd 1:0:4:0: Attached scsi generic sg4 type 0
sd 1:0:5:0: Attached scsi generic sg5 type 0
scsi 1:0:8:0: Attached scsi generic sg6 type 3
Fusion MPT base driver 3.04.06
Copyright (c) 1999-2007 LSI Corporation
Fusion MPT SPI Host driver 3.04.06
Fusion MPT FC Host driver 3.04.06
Fusion MPT SAS Host driver 3.04.06
Fusion MPT misc device (ioctl) driver 3.04.06
mptctl: Registered with Fusion MPT base driver
mptctl: /dev/mptctl @ (major,minor=10,220)
ieee1394: raw1394: /dev/raw1394 device initialized
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x64,0x60 irq 1,12
PNP: PS/2 controller has invalid data port 0x64; using default 0x60
PNP: PS/2 controller has invalid command port 0x60; using default 0x64
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
oprofile: using NMI interrupt.
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation available
Testing NMI watchdog ... OK.
Using IPI No-Shortcut mode
Freeing unused kernel memory: 240k freed
XXX sysfs_page_cnt=1
sd_mod: version magic '2.6.15.4 SMP PENTIUM4 REGPARM 4KSTACKS gcc-3.4' should be '2.6.24-rc5-mm1 SMP mod_unload PENTIUM4 '
aic7xxx: version magic '2.6.15.4 SMP PENTIUM4 REGPARM 4KSTACKS gcc-3.4' should be '2.6.24-rc5-mm1 SMP mod_unload PENTIUM4 '
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
XXX sysfs_page_cnt=1
warning: process `kmodule' used the deprecated sysctl system call with 1.23.
EXT3 FS on sdd1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdd3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdf1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 1863532k swap on /dev/sdb3.  Priority:-1 extents:1 across:1863532k
tg3: eth0: Link is up at 100 Mbps, full duplex.
tg3: eth0: Flow control is off for TX and off for RX.
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
XXX sysfs_page_cnt=1
bash invoked oom-killer: gfp_mask=0x84d0, order=0, oomkilladj=0
Pid: 4542, comm: bash Not tainted 2.6.24-rc5-mm1 #6
 [<c010582a>] show_trace_log_lvl+0x12/0x22
 [<c0105847>] show_trace+0xd/0xf
 [<c0105959>] dump_stack+0x57/0x5e
 [<c015a0db>] oom_kill_process+0x37/0xdb
 [<c015a2e8>] out_of_memory+0xbd/0xf1
 [<c015b89d>] __alloc_pages+0x23f/0x2bc
 [<c011b6ca>] pte_alloc_one+0x15/0x3e
 [<c0163000>] __pte_alloc+0x15/0xaf
 [<c016320f>] copy_pte_range+0x43/0x293
 [<c016357b>] copy_page_range+0x11c/0x154
 [<c0122a79>] dup_mmap+0x1ab/0x20c
 [<c0122e22>] dup_mm+0x81/0xd1
 [<c0122eda>] copy_mm+0x68/0x98
 [<c0123b8c>] copy_process+0x47d/0x9fd
 [<c0124229>] do_fork+0x8d/0x1d2
 [<c0103aba>] sys_clone+0x1f/0x21
 [<c01049fa>] sysenter_past_esp+0x5f/0xa5
 =======================
Mem-info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
CPU    4: hi:    0, btch:   1 usd:   0
CPU    5: hi:    0, btch:   1 usd:   0
CPU    6: hi:    0, btch:   1 usd:   0
CPU    7: hi:    0, btch:   1 usd:   0
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:   9
CPU    1: hi:  186, btch:  31 usd: 103
CPU    2: hi:  186, btch:  31 usd:  26
CPU    3: hi:  186, btch:  31 usd: 153
CPU    4: hi:  186, btch:  31 usd:  34
CPU    5: hi:  186, btch:  31 usd: 165
CPU    6: hi:  186, btch:  31 usd:  36
CPU    7: hi:  186, btch:  31 usd: 109
HighMem per-cpu:
CPU    0: hi:  186, btch:  31 usd:  30
CPU    1: hi:  186, btch:  31 usd: 174
CPU    2: hi:  186, btch:  31 usd:  29
CPU    3: hi:  186, btch:  31 usd: 157
CPU    4: hi:  186, btch:  31 usd:  10
CPU    5: hi:  186, btch:  31 usd: 177
CPU    6: hi:  186, btch:  31 usd:  25
CPU    7: hi:  186, btch:  31 usd: 180
Active:2046 inactive:1266 dirty:0 writeback:0 unstable:0
 free:986692 slab:2350 mapped:840 pagetables:136 bounce:0
DMA free:3564kB min:64kB low:80kB high:96kB active:0kB inactive:0kB present:16176kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 868 5039 5039
Normal free:3576kB min:3736kB low:4668kB high:5604kB active:200kB inactive:0kB present:889680kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 33363 33363
HighMem free:3939628kB min:512kB low:4992kB high:9476kB active:7984kB inactive:5064kB present:4270464kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 3*4kB 4*8kB 4*16kB 4*32kB 4*64kB 2*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 3564kB
Normal: 0*4kB 2*8kB 1*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3552kB
HighMem: 89*4kB 502*8kB 253*16kB 75*32kB 27*64kB 6*128kB 1*256kB 0*512kB 2*1024kB 0*2048kB 958*4096kB = 3939588kB
Swap cache: add 0, delete 0, find 0/0, race 0+0
Free swap  = 1863532kB
Total swap = 1863532kB
Free swap:       1863532kB
1310720 pages of RAM
1081344 pages of HIGHMEM
127455 reserved pages
3147 pages shared
0 pages swap cached
0 pages dirty
0 pages writeback
840 pages mapped
2350 pages slab
136 pages pagetables
Out of memory: kill process 3944 (slpd) score 897 or a child
Killed process 3944 (slpd)
irqbalance invoked oom-killer: gfp_mask=0x40d0, order=0, oomkilladj=0
Pid: 3839, comm: irqbalance Not tainted 2.6.24-rc5-mm1 #6
 [<c010582a>] show_trace_log_lvl+0x12/0x22
 [<c0105847>] show_trace+0xd/0xf
 [<c0105959>] dump_stack+0x57/0x5e
 [<c015a0db>] oom_kill_process+0x37/0xdb
 [<c015a2e8>] out_of_memory+0xbd/0xf1
 [<c015b89d>] __alloc_pages+0x23f/0x2bc
 [<c015b956>] __get_free_pages+0x3c/0x4c
 [<c018dabb>] seq_read+0x5e/0x255
 [<c01a3e0b>] proc_reg_read+0x63/0x79
 [<c01775d0>] vfs_read+0x80/0xf6
 [<c017786e>] sys_read+0x3b/0x60
 [<c01049fa>] sysenter_past_esp+0x5f/0xa5
 =======================
Mem-info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
CPU    4: hi:    0, btch:   1 usd:   0
CPU    5: hi:    0, btch:   1 usd:   0
CPU    6: hi:    0, btch:   1 usd:   0
CPU    7: hi:    0, btch:   1 usd:   0
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  24
CPU    1: hi:  186, btch:  31 usd: 103
CPU    2: hi:  186, btch:  31 usd:  26
CPU    3: hi:  186, btch:  31 usd: 157
CPU    4: hi:  186, btch:  31 usd:  34
CPU    5: hi:  186, btch:  31 usd: 166
CPU    6: hi:  186, btch:  31 usd:  36
CPU    7: hi:  186, btch:  31 usd: 109
HighMem per-cpu:
CPU    0: hi:  186, btch:  31 usd:  71
CPU    1: hi:  186, btch:  31 usd: 174
CPU    2: hi:  186, btch:  31 usd:  29
CPU    3: hi:  186, btch:  31 usd: 152
CPU    4: hi:  186, btch:  31 usd:  10
CPU    5: hi:  186, btch:  31 usd: 177
CPU    6: hi:  186, btch:  31 usd:  16
CPU    7: hi:  186, btch:  31 usd: 178
Active:1946 inactive:1280 dirty:0 writeback:0 unstable:0
 free:986685 slab:2359 mapped:829 pagetables:127 bounce:0
DMA free:3528kB min:64kB low:80kB high:96kB active:0kB inactive:0kB present:16176kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 868 5039 5039
Normal free:3624kB min:3736kB low:4668kB high:5604kB active:20kB inactive:56kB present:889680kB pages_scanned:277 all_unreclaimable? yes
lowmem_reserve[]: 0 0 33363 33363
HighMem free:3939588kB min:512kB low:4992kB high:9476kB active:7764kB inactive:5064kB present:4270464kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 2*4kB 4*8kB 4*16kB 5*32kB 5*64kB 1*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 3528kB
Normal: 0*4kB 14*8kB 1*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3648kB
HighMem: 89*4kB 502*8kB 253*16kB 75*32kB 27*64kB 6*128kB 1*256kB 0*512kB 2*1024kB 0*2048kB 958*4096kB = 3939588kB
Swap cache: add 0, delete 0, find 0/0, race 0+0
Free swap  = 1863532kB
Total swap = 1863532kB
Free swap:       1863532kB
1310720 pages of RAM
1081344 pages of HIGHMEM
127455 reserved pages
3079 pages shared
0 pages swap cached
0 pages dirty
0 pages writeback
829 pages mapped
2359 pages slab
127 pages pagetables
Out of memory: kill process 4055 (xfs) score 817 or a child
Killed process 4055 (xfs)
irqbalance invoked oom-killer: gfp_mask=0x40d0, order=0, oomkilladj=0
Pid: 3839, comm: irqbalance Not tainted 2.6.24-rc5-mm1 #6
 [<c010582a>] show_trace_log_lvl+0x12/0x22
 [<c0105847>] show_trace+0xd/0xf
 [<c0105959>] dump_stack+0x57/0x5e
 [<c015a0db>] oom_kill_process+0x37/0xdb
 [<c015a2e8>] out_of_memory+0xbd/0xf1
 [<c015b89d>] __alloc_pages+0x23f/0x2bc
 [<c015b956>] __get_free_pages+0x3c/0x4c
 [<c018dabb>] seq_read+0x5e/0x255
 [<c01a3e0b>] proc_reg_read+0x63/0x79
 [<c01775d0>] vfs_read+0x80/0xf6
 [<c017786e>] sys_read+0x3b/0x60
 [<c01049fa>] sysenter_past_esp+0x5f/0xa5
 =======================
Mem-info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
CPU    4: hi:    0, btch:   1 usd:   0
CPU    5: hi:    0, btch:   1 usd:   0
CPU    6: hi:    0, btch:   1 usd:   0
CPU    7: hi:    0, btch:   1 usd:   0
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  24
CPU    1: hi:  186, btch:  31 usd: 111
CPU    2: hi:  186, btch:  31 usd:  26
CPU    3: hi:  186, btch:  31 usd: 157
CPU    4: hi:  186, btch:  31 usd:  34
CPU    5: hi:  186, btch:  31 usd: 166
CPU    6: hi:  186, btch:  31 usd:  36
CPU    7: hi:  186, btch:  31 usd: 109
HighMem per-cpu:
CPU    0: hi:  186, btch:  31 usd:  71
CPU    1: hi:  186, btch:  31 usd: 173
CPU    2: hi:  186, btch:  31 usd:  29
CPU    3: hi:  186, btch:  31 usd: 152
CPU    4: hi:  186, btch:  31 usd:  10
CPU    5: hi:  186, btch:  31 usd: 177
CPU    6: hi:  186, btch:  31 usd:  16
CPU    7: hi:  186, btch:  31 usd: 178
Active:1805 inactive:1305 dirty:0 writeback:0 unstable:0
 free:986856 slab:2359 mapped:744 pagetables:127 bounce:0
DMA free:3528kB min:64kB low:80kB high:96kB active:0kB inactive:0kB present:16176kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 868 5039 5039
Normal free:3624kB min:3736kB low:4668kB high:5604kB active:136kB inactive:156kB present:889680kB pages_scanned:401 all_unreclaimable? yes
lowmem_reserve[]: 0 0 33363 33363
HighMem free:3940272kB min:512kB low:4992kB high:9476kB active:7084kB inactive:5064kB present:4270464kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 2*4kB 4*8kB 4*16kB 5*32kB 5*64kB 1*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 3528kB
Normal: 0*4kB 17*8kB 1*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3672kB
HighMem: 269*4kB 503*8kB 254*16kB 75*32kB 27*64kB 6*128kB 1*256kB 0*512kB 2*1024kB 0*2048kB 958*4096kB = 3940332kB
Swap cache: add 0, delete 0, find 0/0, race 0+0
Free swap  = 1863532kB
Total swap = 1863532kB
Free swap:       1863532kB
1310720 pages of RAM
1081344 pages of HIGHMEM
127455 reserved pages
2885 pages shared
0 pages swap cached
0 pages dirty
0 pages writeback
772 pages mapped
2353 pages slab
119 pages pagetables
Out of memory: kill process 3850 (portmap) score 418 or a child
Killed process 3850 (portmap)
irqbalance invoked oom-killer: gfp_mask=0x40d0, order=0, oomkilladj=0
Pid: 3839, comm: irqbalance Not tainted 2.6.24-rc5-mm1 #6
 [<c010582a>] show_trace_log_lvl+0x12/0x22
 [<c0105847>] show_trace+0xd/0xf
 [<c0105959>] dump_stack+0x57/0x5e
 [<c015a0db>] oom_kill_process+0x37/0xdb
 [<c015a2e8>] out_of_memory+0xbd/0xf1
 [<c015b89d>] __alloc_pages+0x23f/0x2bc
 [<c015b956>] __get_free_pages+0x3c/0x4c
 [<c018dabb>] seq_read+0x5e/0x255
 [<c01a3e0b>] proc_reg_read+0x63/0x79
 [<c01775d0>] vfs_read+0x80/0xf6
 [<c017786e>] sys_read+0x3b/0x60
 [<c01049fa>] sysenter_past_esp+0x5f/0xa5
 =======================
Mem-info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
CPU    4: hi:    0, btch:   1 usd:   0
CPU    5: hi:    0, btch:   1 usd:   0
CPU    6: hi:    0, btch:   1 usd:   0
CPU    7: hi:    0, btch:   1 usd:   0
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  30
CPU    1: hi:  186, btch:  31 usd: 111
CPU    2: hi:  186, btch:  31 usd:  26
CPU    3: hi:  186, btch:  31 usd: 157
CPU    4: hi:  186, btch:  31 usd:  34
CPU    5: hi:  186, btch:  31 usd: 168
CPU    6: hi:  186, btch:  31 usd:  36
CPU    7: hi:  186, btch:  31 usd: 109
HighMem per-cpu:
CPU    0: hi:  186, btch:  31 usd:  92
CPU    1: hi:  186, btch:  31 usd: 173
CPU    2: hi:  186, btch:  31 usd:  29
CPU    3: hi:  186, btch:  31 usd: 152
CPU    4: hi:  186, btch:  31 usd:  10
CPU    5: hi:  186, btch:  31 usd: 177
CPU    6: hi:  186, btch:  31 usd:  16
CPU    7: hi:  186, btch:  31 usd: 180
Active:1790 inactive:1270 dirty:0 writeback:0 unstable:0
 free:986883 slab:2347 mapped:772 pagetables:119 bounce:0
DMA free:3528kB min:64kB low:80kB high:96kB active:0kB inactive:0kB present:16176kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 868 5039 5039
Normal free:3672kB min:3736kB low:4668kB high:5604kB active:132kB inactive:16kB present:889680kB pages_scanned:270 all_unreclaimable? yes
lowmem_reserve[]: 0 0 33363 33363
HighMem free:3940332kB min:512kB low:4992kB high:9476kB active:7028kB inactive:5064kB present:4270464kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 2*4kB 4*8kB 4*16kB 5*32kB 5*64kB 1*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 3528kB
Normal: 0*4kB 24*8kB 1*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3728kB
HighMem: 269*4kB 503*8kB 254*16kB 75*32kB 27*64kB 6*128kB 1*256kB 0*512kB 2*1024kB 0*2048kB 958*4096kB = 3940332kB
Swap cache: add 0, delete 0, find 0/0, race 0+0
Free swap  = 1863532kB
Total swap = 1863532kB
Free swap:       1863532kB
1310720 pages of RAM
1081344 pages of HIGHMEM
127455 reserved pages
2768 pages shared
0 pages swap cached
0 pages dirty
0 pages writeback
772 pages mapped
2347 pages slab
119 pages pagetables
Out of memory: kill process 4540 (sshd) score 142 or a child
Killed process 4542 (bash)
XXX sysfs_page_cnt=1

-- 
regards,
Dhaval
