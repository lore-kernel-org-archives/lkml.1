Return-Path: <linux-kernel-owner+w=401wt.eu-S1752782AbXCJBJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbXCJBJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 20:09:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767693AbXCJBJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 20:09:35 -0500
Received: from smtp1-g19.free.fr ([212.27.42.27]:55995 "EHLO smtp1-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbXCJBJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 20:09:30 -0500
Message-ID: <45F20541.9090208@crans.org>
Date: Sat, 10 Mar 2007 02:09:21 +0100
From: =?UTF-8?B?TWF0aGlldSBCw6lyYXJk?= <Mathieu.Berard@crans.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org,
       Michal Jaegermann <michal@ellpspace.math.ualberta.ca>,
       Fabio Comolli <fabio.comolli@gmail.com>, Tejun Heo <htejun@gmail.com>,
       Janosch Machowinski <jmachowinski@gmx.de>,
       Lukas Hejtmanek <xhejtman@fi.muni.cz>, Meelis Roos <mroos@linux.ee>,
       Olivier Mondoloni <darkcore71@yahoo.fr>,
       Thomas Renninger <trenn@suse.de>, Robert Moore <robert.moore@intel.com>,
       lenb@kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [3/6] 2.6.21-rc2: known regressions
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015036.GH3441@stusta.de> <45EE9E39.3010800@garzik.org>
In-Reply-To: <45EE9E39.3010800@garzik.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik a écrit :
> Adrian Bunk wrote:
>> Subject    : NCQ problem with ahci and Hitachi drive
>> References : http://lkml.org/lkml/2007/3/4/178
>> Submitter  : Mathieu Bérard <Mathieu.Berard@crans.org>
>> Status     : unknown
>
> according to the last message in that thread, it sounds like ACPI and
> interrupt problems
>
Hi,
after more testing with a 2.6.21-rc3, it appears that after several ata
errors the boot process
somehow continued as normal, after a "NCQ disabled due to excessive
errors" message.
"pci=noacpi" or "noacpi" parameters workarounds the problem "irqpoll"
does nothing.

lspci:
00:00.0 Host bridge: Intel Corporation Mobile 915GM/PM/GMS/910GML
Express Processor to DRAM Controller (rev 03)
00:01.0 PCI bridge: Intel Corporation Mobile 915GM/PM Express PCI
Express Root Port (rev 03)
00:1c.0 PCI bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) PCI Express Port 1 (rev 03)
00:1c.1 PCI bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) PCI Express Port 2 (rev 03)
00:1d.0 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB UHCI #1 (rev 03)
00:1d.1 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB UHCI #2 (rev 03)
00:1d.2 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB UHCI #3 (rev 03)
00:1d.3 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB UHCI #4 (rev 03)
00:1d.7 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB2 EHCI Controller (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev d3)
00:1e.2 Multimedia audio controller: Intel Corporation
82801FB/FBM/FR/FW/FRW (ICH6 Family) AC'97 Audio Controller (rev 03)
00:1e.3 Modem: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family)
AC'97 Modem Controller (rev 03)
00:1f.0 ISA bridge: Intel Corporation 82801FBM (ICH6M) LPC Interface
Bridge (rev 03)
00:1f.1 IDE interface: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) IDE Controller (rev 03)
00:1f.2 IDE interface: Intel Corporation 82801FBM (ICH6M) SATA
Controller (rev 03)
00:1f.3 SMBus: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family)
SMBus Controller (rev 03)
01:00.0 VGA compatible controller: ATI Technologies Inc M24 [Radeon
Mobility X600]
06:01.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL-8139/8139C/8139C+ (rev 10)
06:02.0 Network controller: Intel Corporation PRO/Wireless 2200BG
Network Connection (rev 05)
06:04.0 CardBus bridge: Texas Instruments PCIxx21/x515 Cardbus Controller
06:04.2 FireWire (IEEE 1394): Texas Instruments OHCI Compliant IEEE 1394
Host Controller
06:04.3 Mass storage controller: Texas Instruments PCIxx21 Integrated
FlashMedia Controller
06:04.4 Generic system peripheral [0805]: Texas Instruments
PCI6411/6421/6611/6621/7411/7421/7611/7621 Secure Digital Controller


/proc/interrupts:
        CPU0      
  0:       3242   IO-APIC-edge      timer
  1:        863   IO-APIC-edge      i8042
  8:          3   IO-APIC-edge      rtc
  9:          1   IO-APIC-fasteoi   acpi
 12:        116   IO-APIC-edge      i8042
 14:        128   IO-APIC-edge      libata
 15:          0   IO-APIC-edge      libata
 16:          1   IO-APIC-fasteoi   uhci_hcd:usb4, yenta
 17:          0   IO-APIC-fasteoi   tifm_7xx1, Intel ICH6
 18:        249   IO-APIC-fasteoi   eth0
 19:       2712   IO-APIC-fasteoi   libata, uhci_hcd:usb2, sdhci:slot0,
sdhci:slot1, sdhci:slot2
 20:         47   IO-APIC-fasteoi   uhci_hcd:usb1, ehci_hcd:usb5
 21:          3   IO-APIC-fasteoi   uhci_hcd:usb3, ohci1394
 22:          1   IO-APIC-fasteoi   ipw2200
NMI:          0
LOC:      15767
ERR:          0
MIS:          0


/proc/interrupts with pci=noacpi:
    CPU0      
  0:       2886    XT-PIC-XT        timer
  1:         79    XT-PIC-XT        i8042
  2:          0    XT-PIC-XT        cascade
  8:          3    XT-PIC-XT        rtc
  9:          1    XT-PIC-XT        acpi
 10:          1    XT-PIC-XT        uhci_hcd:usb4, tifm_7xx1, yenta,
sdhci:slot0, sdhci:slot1, sdhci:slot2, Intel ICH6
 11:       3415    XT-PIC-XT        eth0, libata, uhci_hcd:usb1,
uhci_hcd:usb2, uhci_hcd:usb3, ehci_hcd:usb5, ohci1394, ipw2200
 12:        116    XT-PIC-XT        i8042
 14:        129    XT-PIC-XT        libata
 15:          0    XT-PIC-XT        libata
NMI:          0
LOC:       6594
ERR:          0
MIS:          0

Full 2.6.21-rc3 boot log:
[    0.000000] Linux version 2.6.21-rc3 (root@manwe) (gcc version 4.1.2
(Ubuntu 4.1.2-0ubuntu4)) #1 PREEMPT Fri Mar 9 01:54:11 CET 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] sanitize start
[    0.000000] sanitize end
[    0.000000] copy_e820_map() start: 0000000000000000 size:
000000000009f800 end: 000000000009f800 type: 1
[    0.000000] copy_e820_map() type is E820_RAM
[    0.000000] copy_e820_map() start: 000000000009f800 size:
0000000000000800 end: 00000000000a0000 type: 2
[    0.000000] copy_e820_map() start: 00000000000d2000 size:
0000000000002000 end: 00000000000d4000 type: 2
[    0.000000] copy_e820_map() start: 00000000000dc000 size:
0000000000024000 end: 0000000000100000 type: 2
[    0.000000] copy_e820_map() start: 0000000000100000 size:
000000003fde0000 end: 000000003fee0000 type: 1
[    0.000000] copy_e820_map() type is E820_RAM
[    0.000000] copy_e820_map() start: 000000003fee0000 size:
000000000000a000 end: 000000003feea000 type: 3
[    0.000000] copy_e820_map() start: 000000003feea000 size:
0000000000016000 end: 000000003ff00000 type: 4
[    0.000000] copy_e820_map() start: 000000003ff00000 size:
0000000000100000 end: 0000000040000000 type: 2
[    0.000000] copy_e820_map() start: 00000000e0000000 size:
0000000010006000 end: 00000000f0006000 type: 2
[    0.000000] copy_e820_map() start: 00000000f0008000 size:
0000000000004000 end: 00000000f000c000 type: 2
[    0.000000] copy_e820_map() start: 00000000fed20000 size:
0000000000070000 end: 00000000fed90000 type: 2
[    0.000000] copy_e820_map() start: 00000000ff000000 size:
0000000001000000 end: 0000000100000000 type: 2
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fee0000 (usable)
[    0.000000]  BIOS-e820: 000000003fee0000 - 000000003feea000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003feea000 - 000000003ff00000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003ff00000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0006000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0008000 - 00000000f000c000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000] 126MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   261856
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   261856
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F6980, 0014 (r0 TOSCPL)
[    0.000000] ACPI: RSDT 3FEE276F, 0044 (r1 TOSCPL   RSDT    6040000 
LTP        0)
[    0.000000] ACPI: APIC 3FEE9E88, 0068 (r1 INTEL  ALVISO    6040000
LOHR       5F)
[    0.000000] ACPI: FACP 3FEE9EF0, 0074 (r1 TOSCPL ALVISO    6040000
LOHR       32)
[    0.000000] ACPI: DSDT 3FEE3217, 6C71 (r1 TOSCPL ALVISO    6040000
MSFT  100000E)
[    0.000000] ACPI: FACS 3FEFAFC0, 0040
[    0.000000] ACPI: BOOT 3FEE9FD8, 0028 (r1 PTLTD  $SBFTBL$  6040000 
LTP        1)
[    0.000000] ACPI: MCFG 3FEE9F9C, 003C (r1 INTEL  ALVISO    6040000
LOHR       5F)
[    0.000000] ACPI: SSDT 3FEE2FE5, 022E (r1 SataRe SataAhci     1000
INTL 20030224)
[    0.000000] ACPI: SSDT 3FEE2BAA, 022B (r1  PmRef  Cpu0Ist     3000
INTL 20030224)
[    0.000000] ACPI: SSDT 3FEE29CC, 01DE (r1  PmRef  Cpu0Cst     3001
INTL 20030224)
[    0.000000] ACPI: SSDT 3FEE27B3, 0219 (r1  PmRef    CpuPm     3000
INTL 20030224)
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 6:13 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 50000000 (gap:
40000000:a0000000)
[    0.000000] Built 1 zonelists.  Total pages: 259811
[    0.000000] Kernel command line: root=/dev/mapper/Base-Root ro single
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=c034f000 soft=c034e000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 1729.086 MHz processor.
[   82.100659] Console: colour VGA+ 80x25
[   82.104287] Dentry cache hash table entries: 131072 (order: 7, 524288
bytes)
[   82.104813] Inode-cache hash table entries: 65536 (order: 6, 262144
bytes)
[   82.128315] Memory: 1031112k/1047424k available (1606k kernel code,
15544k reserved, 544k data, 184k init, 129920k highmem)
[   82.128378] virtual kernel memory layout:
[   82.128379]     fixmap  : 0xfffaa000 - 0xfffff000   ( 340 kB)
[   82.128381]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[   82.128383]     vmalloc : 0xf8800000 - 0xffbfe000   ( 115 MB)
[   82.128385]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[   82.128386]       .init : 0xc031b000 - 0xc0349000   ( 184 kB)
[   82.128388]       .data : 0xc029183b - 0xc0319bb4   ( 544 kB)
[   82.128390]       .text : 0xc0100000 - 0xc029183b   (1606 kB)
[   82.128741] Checking if this processor honours the WP bit even in
supervisor mode... Ok.
[   82.188878] Calibrating delay using timer specific routine.. 3460.07
BogoMIPS (lpj=1730037)
[   82.188995] Security Framework v1.0.0 initialized
[   82.189054] Mount-cache hash table entries: 512
[   82.189191] CPU: L1 I cache: 32K, L1 D cache: 32K
[   82.189271] CPU: L2 cache: 2048K
[   82.189321] Intel machine check architecture supported.
[   82.189367] Intel machine check reporting enabled on CPU#0.
[   82.189422] CPU: Intel(R) Pentium(R) M processor 1.73GHz stepping 08
[   82.189539] Checking 'hlt' instruction... OK.
[   82.192970] ACPI: Core revision 20070126
[   82.193084] ACPI: Table DSDT replaced by host OS
[   82.193197] ACPI: DSDT 00000000, 6305 (r1 TOSCPL ALVISO    6040000
INTL 20051117)
[   82.202965] ENABLING IO-APIC IRQs
[   82.203196] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[   82.416878] NET: Registered protocol family 16
[   82.416994] ACPI: bus type pci registered
[   82.417047] PCI: Using MMCONFIG
[   82.417737] Setting up standard PCI resources
[   82.422950] ACPI: Interpreter enabled
[   82.422996] ACPI: (supports S0 S3 S4 S5)
[   82.423228] ACPI: Using IOAPIC for interrupt routing
[   82.468401] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   82.468914] PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
[   82.468962] PCI quirk: region 1180-11bf claimed by ICH6 GPIO
[   82.469042] 0000:00:1f.1: trying to change BAR0 from 0000 to 01F0
[   82.469090] 0000:00:1f.1: trying to change BAR1 from 0000 to 03F4
[   82.469137] 0000:00:1f.1: trying to change BAR2 from 0000 to 0170
[   82.469184] 0000:00:1f.1: trying to change BAR3 from 0000 to 0374
[   82.469927] PCI: Transparent bridge - 0000:00:1e.0
[   82.470019] PCI: Bus #07 (-#0a) is hidden behind transparent bridge
#06 (-#07) (try 'pci=assign-busses')
[   82.470074] Please report the result to linux-kernel to fix this
permanently
[   82.477076] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 *10 12
14 15)
[   82.477633] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12
14 15) *10
[   82.478229] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12
14 15) *11
[   82.478831] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12
14 15)
[   82.479384] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12
14 15) *11
[   82.479979] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 *11 12
14 15)
[   82.480532] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12
14 15) *11
[   82.481129] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 *11 12
14 15)
[   82.481670] Linux Plug and Play Support v0.97 (c) Adam Belay
[   82.481721] pnp: PnP ACPI init
[   82.503859] pnp: PnP ACPI: found 9 devices
[   82.503925] PCI: Using ACPI for IRQ routing
[   82.503970] PCI: If a device doesn't work, try "pci=routeirq".  If it
helps, post a report
[   82.504135] pnp: 00:01: ioport range 0xfe00-0xfe7f has been reserved
[   82.504182] pnp: 00:01: ioport range 0xfe80-0xfeff has been reserved
[   82.504229] pnp: 00:01: ioport range 0xff00-0xff7f has been reserved
[   82.504277] pnp: 00:01: iomem range 0xe0000000-0xefffffff has been
reserved
[   82.504324] pnp: 00:01: iomem range 0xf0000000-0xf0003fff has been
reserved
[   82.504372] pnp: 00:01: iomem range 0xf0004000-0xf0004fff has been
reserved
[   82.504420] pnp: 00:01: iomem range 0xf0005000-0xf0005fff has been
reserved
[   82.504712] Time: tsc clocksource has been installed.
[   82.534686] PCI: Bridge: 0000:00:01.0
[   82.534732]   IO window: 3000-3fff
[   82.534777]   MEM window: b8100000-b81fffff
[   82.534822]   PREFETCH window: c8000000-cfffffff
[   82.534868] PCI: Bridge: 0000:00:1c.0
[   82.534913]   IO window: 4000-4fff
[   82.534959]   MEM window: bc000000-bfffffff
[   82.535006]   PREFETCH window: d0000000-d3ffffff
[   82.535053] PCI: Bridge: 0000:00:1c.1
[   82.535098]   IO window: 5000-5fff
[   82.535144]   MEM window: c0000000-c3ffffff
[   82.535191]   PREFETCH window: d4000000-d7ffffff
[   82.535241] PCI: Bus 7, cardbus bridge: 0000:06:04.0
[   82.535287]   IO window: 00006400-000064ff
[   82.535334]   IO window: 00006800-000068ff
[   82.535381]   PREFETCH window: 50000000-53ffffff
[   82.535428]   MEM window: 54000000-57ffffff
[   82.535475] PCI: Bridge: 0000:00:1e.0
[   82.535520]   IO window: 6000-6fff
[   82.535567]   MEM window: c4000000-c40fffff
[   82.535614]   PREFETCH window: 50000000-53ffffff
[   82.535668] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level,
low) -> IRQ 16
[   82.536458] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level,
low) -> IRQ 17
[   82.536562] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level,
low) -> IRQ 16
[   82.536674] ACPI: PCI Interrupt 0000:06:04.0[A] -> GSI 16 (level,
low) -> IRQ 16
[   82.536778] NET: Registered protocol family 2
[   82.546708] IP route cache hash table entries: 32768 (order: 5,
131072 bytes)
[   82.546828] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[   82.547737] TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
[   82.548053] TCP: Hash tables configured (established 131072 bind 65536)
[   82.548103] TCP reno registered
[   82.550814] checking if image is initramfs... it is
[   82.926145] Freeing initrd memory: 3943k freed
[   82.926322] Simple Boot Flag at 0x36 set to 0x1
[   82.926670] highmem bounce pool size: 64 pages
[   82.926717] Total HugeTLB memory allocated, 0
[   82.926848] io scheduler noop registered
[   82.926934] io scheduler cfq registered (default)
[   82.927311] assign_interrupt_mode Found MSI capability
[   82.927524] assign_interrupt_mode Found MSI capability
[   82.927748] assign_interrupt_mode Found MSI capability
[   82.929989] RAMDISK driver initialized: 16 RAM disks of 65536K size
1024 blocksize
[   82.930197] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at
0x60,0x64 irq 1,12
[   82.930435] i8042.c: Detected active multiplexing controller, rev 1.1.
[   82.930548] serio: i8042 KBD port at 0x60,0x64 irq 1
[   82.930624] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[   82.930694] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[   82.930762] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[   82.930830] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[   82.930924] mice: PS/2 mouse device common for all mice
[   82.931061] TCP cubic registered
[   82.931110] NET: Registered protocol family 1
[   82.931162] Using IPI Shortcut mode
[   82.931366] Freeing unused kernel memory: 184k freed
[   82.933520] input: AT Translated Set 2 keyboard as /class/input/input0
[   83.034411] Switched to high resolution mode on CPU 0
[   83.038869] 8139too Fast Ethernet driver 0.9.28
[   83.038971] ACPI: PCI Interrupt 0000:06:01.0[A] -> GSI 21 (level,
low) -> IRQ 18
[   83.039529] eth0: RealTek RTL8139 at 0xf8820000, 00:0f:b0:a5:9a:81,
IRQ 18
[   83.041859] netconsole: local port 5000
[   83.041905] netconsole: local IP 192.168.0.20
[   83.041950] netconsole: interface eth0
[   83.041994] netconsole: remote port 5000
[   83.042039] netconsole: remote IP 192.168.0.1
[   83.042084] netconsole: remote ethernet address ff:ff:ff:ff:ff:ff
[   83.042131] netconsole: device eth0 not up yet, forcing it
[   83.042210] eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
[   83.042967] netconsole: carrier detect appears untrustworthy, waiting
4 seconds
[   87.059120] netconsole: network logging started
[   87.064954] SCSI subsystem initialized
[   87.070057] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level,
low) -> IRQ 19
[   88.070489] ahci 0000:00:1f.2: AHCI 0001.0000 32 slots 4 ports 1.5
Gbps 0x5 impl IDE mode
[   88.070546] ahci 0000:00:1f.2: flags: 64bit ncq pm led slum part
[   88.070671] ata1: SATA max UDMA/133 cmd 0xf8824d00 ctl 0x00000000
bmdma 0x00000000 irq 19
[   88.070789] ata2: SATA max UDMA/133 cmd 0xf8824d80 ctl 0x00000000
bmdma 0x00000000 irq 19
[   88.070910] ata3: SATA max UDMA/133 cmd 0xf8824e00 ctl 0x00000000
bmdma 0x00000000 irq 19
[   88.071027] ata4: SATA max UDMA/133 cmd 0xf8824e80 ctl 0x00000000
bmdma 0x00000000 irq 19
[   88.071091] scsi0 : ahci
[   88.528373] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   88.573162] ata1.00: ATA-7: HTS541010G9SA00, MBZOC60D, max UDMA/100
[   88.573212] ata1.00: 195371568 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   88.575453] ata1.00: configured for UDMA/100
[   88.575503] scsi1 : ahci
[   88.878284] ata2: SATA link down (SStatus 0 SControl 0)
[   88.878338] scsi2 : ahci
[   89.181217] ata3: SATA link down (SStatus 0 SControl 300)
[   89.181270] scsi3 : ahci
[   89.484151] ata4: SATA link down (SStatus 0 SControl 0)
[   89.484277] scsi 0:0:0:0: Direct-Access     ATA      HTS541010G9SA00 
MBZO PQ: 0 ANSI: 5
[   89.488409] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12)
initialised: dm-devel@redhat.com
[   89.601570] usbcore: registered new interface driver usbfs
[   89.601649] usbcore: registered new interface driver hub
[   89.601716] usbcore: registered new device driver usb
[   89.602398] USB Universal Host Controller Interface driver v3.0
[   89.602495] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level,
low) -> IRQ 20
[   89.602607] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   89.602735] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 1
[   89.602821] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00001800
[   89.602958] usb usb1: configuration #1 chosen from 1 choice
[   89.603026] hub 1-0:1.0: USB hub found
[   89.603077] hub 1-0:1.0: 2 ports detected
[   89.705230] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level,
low) -> IRQ 19
[   89.705354] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   89.705423] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 2
[   89.705506] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001820
[   89.705633] usb usb2: configuration #1 chosen from 1 choice
[   89.705702] hub 2-0:1.0: USB hub found
[   89.705752] hub 2-0:1.0: 2 ports detected
[   89.806175] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level,
low) -> IRQ 21
[   89.806300] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   89.806370] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 3
[   89.806455] uhci_hcd 0000:00:1d.2: irq 21, io base 0x00001840
[   89.806582] usb usb3: configuration #1 chosen from 1 choice
[   89.806652] hub 3-0:1.0: USB hub found
[   89.806703] hub 3-0:1.0: 2 ports detected
[   89.907109] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level,
low) -> IRQ 16
[   89.907217] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   89.907288] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned
bus number 4
[   89.907370] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00001860
[   89.907488] usb usb4: configuration #1 chosen from 1 choice
[   89.907556] hub 4-0:1.0: USB hub found
[   89.907606] hub 4-0:1.0: 2 ports detected
[   89.911054] usb 1-1: new low speed USB device using uhci_hcd and
address 2
[   90.008647] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level,
low) -> IRQ 20
[   90.008762] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   90.008827] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 5
[   90.008912] ehci_hcd 0000:00:1d.7: debug port 1
[   90.008969] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xb8000000
[   90.012903] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver
10 Dec 2004
[   90.013011] usb usb5: configuration #1 chosen from 1 choice
[   90.013084] hub 5-0:1.0: USB hub found
[   90.013135] hub 5-0:1.0: 8 ports detected
[   90.114194] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level,
low) -> IRQ 21
[   90.114347] ata5: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6
bmdma 0x000118c0 irq 14
[   90.114430] ata6: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376
bmdma 0x000118c8 irq 15
[   90.114511] scsi4 : ata_piix
[   90.419698] ata5.00: ATAPI, max UDMA/33
[   90.426941] usb 1-1: device not accepting address 2, error -71
[   90.574569] ata5.00: configured for UDMA/33
[   90.574624] scsi5 : ata_piix
[   90.574727] ata6: port disabled. ignoring.
[   90.576634] scsi 4:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-841S 
1.50 PQ: 0 ANSI: 5
[   90.576836] ACPI: PCI Interrupt 0000:06:04.2[C] -> GSI 18 (level,
low) -> IRQ 21
[   90.627288] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21] 
MMIO=[c4006800-c4006fff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[   90.636552] SCSI device sda: 195371568 512-byte hdwr sectors (100030 MB)
[   90.636620] sda: Write Protect is off
[   90.636689] SCSI device sda: write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   90.636787] SCSI device sda: 195371568 512-byte hdwr sectors (100030 MB)
[   90.636842] sda: Write Protect is off
[   90.636913] SCSI device sda: write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   90.636970]  sda:<6>usb 1-1: new low speed USB device using uhci_hcd
and address 4
[   91.072397] usb 1-1: configuration #1 chosen from 1 choice
[   91.098889] input: Logitech USB Receiver as /class/input/input1
[   91.099036] input: USB HID v1.10 Mouse [Logitech USB Receiver] on
usb-0000:00:1d.0-1
[   91.099185] usbcore: registered new interface driver usbhid
[   91.099239] drivers/usb/input/hid-core.c: v2.6:USB HID core driver
[  120.630313] ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2
frozen
[  120.630373] ata1.00: cmd 60/08:00:00:00:00/00:00:00:00:00/40 tag 0
cdb 0x0 data 4096 in
[  120.630375]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[  120.933235] ata1: soft resetting port
[  121.088217] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  121.093545] ata1.00: configured for UDMA/100
[  121.093600] ata1: EH complete
[  121.093682] SCSI device sda: 195371568 512-byte hdwr sectors (100030 MB)
[  121.093739] sda: Write Protect is off
[  121.093805] SCSI device sda: write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[  151.086611] ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2
frozen
[  151.086665] ata1.00: cmd 60/08:00:00:00:00/00:00:00:00:00/40 tag 0
cdb 0x0 data 4096 in
[  151.086667]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[  151.389541] ata1: soft resetting port
[  151.544521] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  151.549801] ata1.00: configured for UDMA/100
[  151.549852] ata1: EH complete
[  151.549921] SCSI device sda: 195371568 512-byte hdwr sectors (100030 MB)
[  151.549976] sda: Write Protect is off
[  151.550042] SCSI device sda: write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[  181.542915] ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2
frozen
[  181.542970] ata1.00: cmd 60/08:00:00:00:00/00:00:00:00:00/40 tag 0
cdb 0x0 data 4096 in
[  181.542971]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[  181.845846] ata1: soft resetting port
[  182.000827] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  182.006151] ata1.00: configured for UDMA/100
[  182.006202] ata1: EH complete
[  182.006271] SCSI device sda: 195371568 512-byte hdwr sectors (100030 MB)
[  182.006325] sda: Write Protect is off
[  182.006391] SCSI device sda: write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[  211.999220] ata1.00: NCQ disabled due to excessive errors
[  211.999271] ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2
frozen
[  211.999329] ata1.00: cmd 60/08:00:00:00:00/00:00:00:00:00/40 tag 0
cdb 0x0 data 4096 in
[  211.999331]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[  212.302152] ata1: soft resetting port
[  212.457132] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  212.462428] ata1.00: configured for UDMA/100
[  212.462479] ata1: EH complete
[  212.462547] SCSI device sda: 195371568 512-byte hdwr sectors (100030 MB)
[  212.462602] sda: Write Protect is off
[  212.462668] SCSI device sda: write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[  212.477303]  sda1 sda2 < sda5 sda6 > sda3
[  212.521233] sd 0:0:0:0: Attached scsi disk sda
[  212.524556] sd 0:0:0:0: Attached scsi generic sg0 type 0
[  212.524782] sr 4:0:0:0: Attached scsi generic sg1 type 5
[  212.530683] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw
xa/form2 cdda tray
[  212.530745] Uniform CD-ROM driver Revision: 3.20
[  212.855075] Attempting manual resume
[  212.923490] SGI XFS with ACLs, realtime, no debug enabled
[  212.982545] Filesystem "dm-0": Disabling barriers, not supported by
the underlying device
[  212.982815] XFS mounting filesystem dm-0
[  216.458088] input: PC Speaker as /class/input/input2
[  216.869753] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.01 (21-Jan-2007)
[  216.874226] input: PS/2 Mouse as /class/input/input3
[  216.891684] Real Time Clock Driver v1.12ac
[  216.893113] input: AlpsPS/2 ALPS GlidePoint as /class/input/input4
[  216.896321] iTCO_wdt: Found a ICH6-M TCO device (Version=2,
TCOBASE=0x1060)
[  216.896402] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[  217.001241] Linux agpgart interface v0.102 (c) Dave Jones
[  217.007834] agpgart: Detected an Intel 915GM Chipset.
[  217.024646] agpgart: AGP aperture is 256M @ 0x0
[  217.044332] ACPI: PCI Interrupt 0000:06:04.3[B] -> GSI 17 (level,
low) -> IRQ 17
[  217.058492] sdhci: Secure Digital Host Controller Interface driver
[  217.058545] sdhci: Copyright(c) Pierre Ossman
[  217.058620] sdhci: SDHCI controller found at 0000:06:04.4 [104c:8034]
(rev 0)
[  217.058684] ACPI: PCI Interrupt 0000:06:04.4[D] -> GSI 19 (level,
low) -> IRQ 19
[  217.058832] mmc0: SDHCI at 0xc4009400 irq 19 DMA
[  217.058910] mmc1: SDHCI at 0xc4009000 irq 19 DMA
[  217.058988] mmc2: SDHCI at 0xc4006400 irq 19 DMA
[  217.590753] ieee80211: 802.11 data/management/control stack, git-1.1.13
[  217.590810] ieee80211: Copyright (C) 2004-2005 Intel Corporation
<jketreno@linux.intel.com>
[  217.622453] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver,
1.2.0kmprq
[  217.622511] ipw2200: Copyright(c) 2003-2006 Intel Corporation
[  217.622637] ACPI: PCI Interrupt 0000:06:02.0[A] -> GSI 22 (level,
low) -> IRQ 22
[  217.622770] ipw2200: Detected Intel PRO/Wireless 2200BG Network
Connection
[  218.194017] ipw2200: Radio Frequency Kill Switch is On:
[  218.194020] Kill switch must be turned off for wireless networking to
work.
[  218.194193] ipw2200: Detected geography ZZM (11 802.11bg channels, 0
802.11a channels)
[  218.194287] Yenta: CardBus bridge found at 0000:06:04.0 [1179:ff00]
[  218.194356] Yenta: Enabling burst memory read transactions
[  218.194407] Yenta: Using CSCINT to route CSC interrupts to PCI
[  218.194460] Yenta: Routing CardBus interrupts to PCI
[  218.194515] Yenta TI: socket 0000:06:04.0, mfunc 0x10aa1b22, devctl 0x66
[  218.417563] Yenta: ISA IRQ mask 0x0cf8, PCI irq 16
[  218.417622] Socket status: 30000006
[  218.417675] Yenta: Raising subordinate bus# of parent bus (#06) from
#07 to #0a
[  218.417739] pcmcia: parent PCI bridge I/O window: 0x6000 - 0x6fff
[  218.417794] pcmcia: parent PCI bridge Memory window: 0xc4000000 -
0xc40fffff
[  218.417850] pcmcia: parent PCI bridge Memory window: 0x50000000 -
0x53ffffff
[  218.419219] ACPI: PCI Interrupt 0000:00:1e.2[A] -> GSI 17 (level,
low) -> IRQ 17
[  219.231630] intel8x0_measure_ac97_clock: measured 50495 usecs
[  219.231686] intel8x0: clocking to 48000
[  219.357519] Capability LSM initialized
[  219.432905] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3] C4[C3])
[  219.468590] Time: acpi_pm clocksource has been installed.
[  219.481281] Non-volatile memory driver v1.2
[  219.493925] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[  219.530293] IA-32 Microcode Update Driver: v1.14a
<tigran@aivazian.fsnet.co.uk>
[  219.542486] Machine check exception polling timer started.
[  219.592529] fuse init (API version 7.8)

Full 2.6.21-rc3 boot log with pci=noacpi:
[    0.000000] Linux version 2.6.21-rc3 (root@manwe) (gcc version 4.1.2
(Ubuntu 4.1.2-0ubuntu4)) #1 PREEMPT Fri Mar 9 01:54:11 CET 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] sanitize start
[    0.000000] sanitize end
[    0.000000] copy_e820_map() start: 0000000000000000 size:
000000000009f800 end: 000000000009f800 type: 1
[    0.000000] copy_e820_map() type is E820_RAM
[    0.000000] copy_e820_map() start: 000000000009f800 size:
0000000000000800 end: 00000000000a0000 type: 2
[    0.000000] copy_e820_map() start: 00000000000d2000 size:
0000000000002000 end: 00000000000d4000 type: 2
[    0.000000] copy_e820_map() start: 00000000000dc000 size:
0000000000024000 end: 0000000000100000 type: 2
[    0.000000] copy_e820_map() start: 0000000000100000 size:
000000003fde0000 end: 000000003fee0000 type: 1
[    0.000000] copy_e820_map() type is E820_RAM
[    0.000000] copy_e820_map() start: 000000003fee0000 size:
000000000000a000 end: 000000003feea000 type: 3
[    0.000000] copy_e820_map() start: 000000003feea000 size:
0000000000016000 end: 000000003ff00000 type: 4
[    0.000000] copy_e820_map() start: 000000003ff00000 size:
0000000000100000 end: 0000000040000000 type: 2
[    0.000000] copy_e820_map() start: 00000000e0000000 size:
0000000010006000 end: 00000000f0006000 type: 2
[    0.000000] copy_e820_map() start: 00000000f0008000 size:
0000000000004000 end: 00000000f000c000 type: 2
[    0.000000] copy_e820_map() start: 00000000fed20000 size:
0000000000070000 end: 00000000fed90000 type: 2
[    0.000000] copy_e820_map() start: 00000000ff000000 size:
0000000001000000 end: 0000000100000000 type: 2
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fee0000 (usable)
[    0.000000]  BIOS-e820: 000000003fee0000 - 000000003feea000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003feea000 - 000000003ff00000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003ff00000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0006000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0008000 - 00000000f000c000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000] 126MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   261856
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   261856
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F6980, 0014 (r0 TOSCPL)
[    0.000000] ACPI: RSDT 3FEE276F, 0044 (r1 TOSCPL   RSDT    6040000 
LTP        0)
[    0.000000] ACPI: APIC 3FEE9E88, 0068 (r1 INTEL  ALVISO    6040000
LOHR       5F)
[    0.000000] ACPI: FACP 3FEE9EF0, 0074 (r1 TOSCPL ALVISO    6040000
LOHR       32)
[    0.000000] ACPI: DSDT 3FEE3217, 6C71 (r1 TOSCPL ALVISO    6040000
MSFT  100000E)
[    0.000000] ACPI: FACS 3FEFAFC0, 0040
[    0.000000] ACPI: BOOT 3FEE9FD8, 0028 (r1 PTLTD  $SBFTBL$  6040000 
LTP        1)
[    0.000000] ACPI: MCFG 3FEE9F9C, 003C (r1 INTEL  ALVISO    6040000
LOHR       5F)
[    0.000000] ACPI: SSDT 3FEE2FE5, 022E (r1 SataRe SataAhci     1000
INTL 20030224)
[    0.000000] ACPI: SSDT 3FEE2BAA, 022B (r1  PmRef  Cpu0Ist     3000
INTL 20030224)
[    0.000000] ACPI: SSDT 3FEE29CC, 01DE (r1  PmRef  Cpu0Cst     3001
INTL 20030224)
[    0.000000] ACPI: SSDT 3FEE27B3, 0219 (r1  PmRef    CpuPm     3000
INTL 20030224)
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 6:13 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] Allocating PCI resources starting at 50000000 (gap:
40000000:a0000000)
[    0.000000] Built 1 zonelists.  Total pages: 259811
[    0.000000] Kernel command line: root=/dev/mapper/Base-Root ro single
pci=noacpi
[    0.000000] Found and enabled local APIC!
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=c034f000 soft=c034e000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 1729.052 MHz processor.
[   28.094814] Console: colour VGA+ 80x25
[   28.098208] Dentry cache hash table entries: 131072 (order: 7, 524288
bytes)
[   28.098736] Inode-cache hash table entries: 65536 (order: 6, 262144
bytes)
[   28.122214] Memory: 1031112k/1047424k available (1606k kernel code,
15544k reserved, 544k data, 184k init, 129920k highmem)
[   28.122277] virtual kernel memory layout:
[   28.122279]     fixmap  : 0xfffaa000 - 0xfffff000   ( 340 kB)
[   28.122281]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[   28.122282]     vmalloc : 0xf8800000 - 0xffbfe000   ( 115 MB)
[   28.122284]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[   28.122286]       .init : 0xc031b000 - 0xc0349000   ( 184 kB)
[   28.122287]       .data : 0xc029183b - 0xc0319bb4   ( 544 kB)
[   28.122289]       .text : 0xc0100000 - 0xc029183b   (1606 kB)
[   28.122640] Checking if this processor honours the WP bit even in
supervisor mode... Ok.
[   28.182778] Calibrating delay using timer specific routine.. 3460.10
BogoMIPS (lpj=1730052)
[   28.182893] Security Framework v1.0.0 initialized
[   28.182952] Mount-cache hash table entries: 512
[   28.183089] CPU: L1 I cache: 32K, L1 D cache: 32K
[   28.183169] CPU: L2 cache: 2048K
[   28.183217] Intel machine check architecture supported.
[   28.183264] Intel machine check reporting enabled on CPU#0.
[   28.183318] CPU: Intel(R) Pentium(R) M processor 1.73GHz stepping 08
[   28.183435] Checking 'hlt' instruction... OK.
[   28.186871] ACPI: Core revision 20070126
[   28.186986] ACPI: Table DSDT replaced by host OS
[   28.187101] ACPI: DSDT 00000000, 6305 (r1 TOSCPL ALVISO    6040000
INTL 20051117)
[   28.189974] ACPI: setting ELCR to 0e00 (from 0c00)
[   28.400789] NET: Registered protocol family 16
[   28.400904] ACPI: bus type pci registered
[   28.400957] PCI: Using MMCONFIG
[   28.401645] Setting up standard PCI resources
[   28.406853] ACPI: Interpreter enabled
[   28.406900] ACPI: (supports S0 S3 S4 S5)
[   28.407132] ACPI: Using PIC for interrupt routing
[   28.452326] Linux Plug and Play Support v0.97 (c) Adam Belay
[   28.452378] pnp: PnP ACPI init
[   28.474767] pnp: PnP ACPI: found 9 devices
[   28.474837] PCI: Probing PCI hardware
[   28.475352] PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
[   28.475400] PCI quirk: region 1180-11bf claimed by ICH6 GPIO
[   28.475480] 0000:00:1f.1: trying to change BAR0 from 0000 to 01F0
[   28.475527] 0000:00:1f.1: trying to change BAR1 from 0000 to 03F4
[   28.475574] 0000:00:1f.1: trying to change BAR2 from 0000 to 0170
[   28.475621] 0000:00:1f.1: trying to change BAR3 from 0000 to 0374
[   28.476362] PCI: Transparent bridge - 0000:00:1e.0
[   28.476455] PCI: Bus #07 (-#0a) is hidden behind transparent bridge
#06 (-#07) (try 'pci=assign-busses')
[   28.476509] Please report the result to linux-kernel to fix this
permanently
[   28.477400] pnp: 00:01: ioport range 0xfe00-0xfe7f has been reserved
[   28.477448] pnp: 00:01: ioport range 0xfe80-0xfeff has been reserved
[   28.477496] pnp: 00:01: ioport range 0xff00-0xff7f has been reserved
[   28.477543] pnp: 00:01: iomem range 0xe0000000-0xefffffff has been
reserved
[   28.477591] pnp: 00:01: iomem range 0xf0000000-0xf0003fff has been
reserved
[   28.477638] Time: tsc clocksource has been installed.
[   28.477687] pnp: 00:01: iomem range 0xf0004000-0xf0004fff has been
reserved
[   28.477735] pnp: 00:01: iomem range 0xf0005000-0xf0005fff has been
reserved
[   28.508000] PCI: Bridge: 0000:00:01.0
[   28.508045]   IO window: 3000-3fff
[   28.508090]   MEM window: b8100000-b81fffff
[   28.508135]   PREFETCH window: c8000000-cfffffff
[   28.508181] PCI: Bridge: 0000:00:1c.0
[   28.508226]   IO window: 4000-4fff
[   28.508273]   MEM window: bc000000-bfffffff
[   28.508319]   PREFETCH window: d0000000-d3ffffff
[   28.508367] PCI: Bridge: 0000:00:1c.1
[   28.508412]   IO window: 5000-5fff
[   28.508458]   MEM window: c0000000-c3ffffff
[   28.508504]   PREFETCH window: d4000000-d7ffffff
[   28.508555] PCI: Bus 7, cardbus bridge: 0000:06:04.0
[   28.508600]   IO window: 00006400-000064ff
[   28.508648]   IO window: 00006800-000068ff
[   28.508695]   PREFETCH window: 50000000-53ffffff
[   28.508742]   MEM window: 54000000-57ffffff
[   28.508789] PCI: Bridge: 0000:00:1e.0
[   28.508834]   IO window: 6000-6fff
[   28.508881]   MEM window: c4000000-c40fffff
[   28.508927]   PREFETCH window: 50000000-53ffffff
[   28.509056] NET: Registered protocol family 2
[   28.517623] IP route cache hash table entries: 32768 (order: 5,
131072 bytes)
[   28.517744] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[   28.518638] TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
[   28.518950] TCP: Hash tables configured (established 131072 bind 65536)
[   28.518999] TCP reno registered
[   28.521728] checking if image is initramfs... it is
[   28.897082] Freeing initrd memory: 3943k freed
[   28.897258] Simple Boot Flag at 0x36 set to 0x1
[   28.897591] highmem bounce pool size: 64 pages
[   28.897638] Total HugeTLB memory allocated, 0
[   28.897770] io scheduler noop registered
[   28.897855] io scheduler cfq registered (default)
[   28.898234] assign_interrupt_mode Found MSI capability
[   28.898443] assign_interrupt_mode Found MSI capability
[   28.898670] assign_interrupt_mode Found MSI capability
[   28.900923] RAMDISK driver initialized: 16 RAM disks of 65536K size
1024 blocksize
[   28.901109] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at
0x60,0x64 irq 1,12
[   28.902057] i8042.c: Detected active multiplexing controller, rev 1.1.
[   28.902162] serio: i8042 KBD port at 0x60,0x64 irq 1
[   28.902241] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[   28.902314] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[   28.902401] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[   28.902470] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[   28.902560] mice: PS/2 mouse device common for all mice
[   28.902702] TCP cubic registered
[   28.902750] NET: Registered protocol family 1
[   28.902803] Using IPI Shortcut mode
[   28.903006] Freeing unused kernel memory: 184k freed
[   28.905169] input: AT Translated Set 2 keyboard as /class/input/input0
[   29.008326] Switched to high resolution mode on CPU 0
[   29.010655] 8139too Fast Ethernet driver 0.9.28
[   29.011221] eth0: RealTek RTL8139 at 0xf8820000, 00:0f:b0:a5:9a:81,
IRQ 11
[   29.013527] netconsole: local port 5000
[   29.013573] netconsole: local IP 192.168.0.20
[   29.013618] netconsole: interface eth0
[   29.013663] netconsole: remote port 5000
[   29.013708] netconsole: remote IP 192.168.0.1
[   29.013753] netconsole: remote ethernet address ff:ff:ff:ff:ff:ff
[   29.013801] netconsole: device eth0 not up yet, forcing it
[   29.013879] eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
[   29.014630] netconsole: carrier detect appears untrustworthy, waiting
4 seconds
[   33.029671] netconsole: network logging started
[   33.035522] SCSI subsystem initialized
[   34.041305] ahci 0000:00:1f.2: AHCI 0001.0000 32 slots 4 ports 1.5
Gbps 0x5 impl IDE mode
[   34.041363] ahci 0000:00:1f.2: flags: 64bit ncq pm led slum part
[   34.041503] ata1: SATA max UDMA/133 cmd 0xf8824d00 ctl 0x00000000
bmdma 0x00000000 irq 11
[   34.041628] ata2: SATA max UDMA/133 cmd 0xf8824d80 ctl 0x00000000
bmdma 0x00000000 irq 11
[   34.041754] ata3: SATA max UDMA/133 cmd 0xf8824e00 ctl 0x00000000
bmdma 0x00000000 irq 11
[   34.041881] ata4: SATA max UDMA/133 cmd 0xf8824e80 ctl 0x00000000
bmdma 0x00000000 irq 11
[   34.041942] scsi0 : ahci
[   34.499179] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   34.500247] ata1.00: ATA-7: HTS541010G9SA00, MBZOC60D, max UDMA/100
[   34.500297] ata1.00: 195371568 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   34.501605] ata1.00: configured for UDMA/100
[   34.501655] scsi1 : ahci
[   34.804094] ata2: SATA link down (SStatus 0 SControl 0)
[   34.804147] scsi2 : ahci
[   35.107022] ata3: SATA link down (SStatus 0 SControl 300)
[   35.107075] scsi3 : ahci
[   35.409949] ata4: SATA link down (SStatus 0 SControl 0)
[   35.410086] scsi 0:0:0:0: Direct-Access     ATA      HTS541010G9SA00 
MBZO PQ: 0 ANSI: 5
[   35.414197] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12)
initialised: dm-devel@redhat.com
[   35.525666] usbcore: registered new interface driver usbfs
[   35.525759] usbcore: registered new interface driver hub
[   35.525834] usbcore: registered new device driver usb
[   35.526522] USB Universal Host Controller Interface driver v3.0
[   35.526634] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   35.526769] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 1
[   35.526860] uhci_hcd 0000:00:1d.0: irq 11, io base 0x00001800
[   35.527012] usb usb1: configuration #1 chosen from 1 choice
[   35.527090] hub 1-0:1.0: USB hub found
[   35.527140] hub 1-0:1.0: 2 ports detected
[   35.628035] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   35.628131] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 2
[   35.628224] uhci_hcd 0000:00:1d.1: irq 11, io base 0x00001820
[   35.628362] usb usb2: configuration #1 chosen from 1 choice
[   35.628442] hub 2-0:1.0: USB hub found
[   35.628492] hub 2-0:1.0: 2 ports detected
[   35.728979] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   35.729070] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 3
[   35.729164] uhci_hcd 0000:00:1d.2: irq 11, io base 0x00001840
[   35.729308] usb usb3: configuration #1 chosen from 1 choice
[   35.729391] hub 3-0:1.0: USB hub found
[   35.729442] hub 3-0:1.0: 2 ports detected
[   35.829912] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   35.829972] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned
bus number 4
[   35.830083] uhci_hcd 0000:00:1d.3: irq 10, io base 0x00001860
[   35.830216] usb usb4: configuration #1 chosen from 1 choice
[   35.830297] hub 4-0:1.0: USB hub found
[   35.830347] hub 4-0:1.0: 2 ports detected
[   35.833845] usb 1-1: new low speed USB device using uhci_hcd and
address 2
[   35.931272] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   35.931352] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 5
[   35.931449] ehci_hcd 0000:00:1d.7: debug port 1
[   35.931505] ehci_hcd 0000:00:1d.7: irq 11, io mem 0xb8000000
[   35.935482] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver
10 Dec 2004
[   35.935607] usb usb5: configuration #1 chosen from 1 choice
[   35.935689] hub 5-0:1.0: USB hub found
[   35.935740] hub 5-0:1.0: 8 ports detected
[   36.092619] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[11] 
MMIO=[c4006800-c4006fff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[   36.092998] ata5: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6
bmdma 0x000118c0 irq 14
[   36.093093] ata6: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376
bmdma 0x000118c8 irq 15
[   36.093188] scsi4 : ata_piix
[   36.350721] usb 1-1: device not accepting address 2, error -71
[   36.398196] ata5.00: ATAPI, max UDMA/33
[   36.553176] ata5.00: configured for UDMA/33
[   36.553230] scsi5 : ata_piix
[   36.553348] ata6: port disabled. ignoring.
[   36.555292] scsi 4:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-841S 
1.50 PQ: 0 ANSI: 5
[   36.564056] SCSI device sda: 195371568 512-byte hdwr sectors (100030 MB)
[   36.564122] sda: Write Protect is off
[   36.564221] SCSI device sda: write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   36.564332] SCSI device sda: 195371568 512-byte hdwr sectors (100030 MB)
[   36.564386] sda: Write Protect is off
[   36.564478] SCSI device sda: write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   36.564535]  sda:<6>usb 1-1: new low speed USB device using uhci_hcd
and address 4
[   36.995244]  sda1 sda2 <<6>usb 1-1: configuration #1 chosen from 1 choice
[   37.009405]  sda5 sda6 > sda3
[   37.016674] sd 0:0:0:0: Attached scsi disk sda
[   37.019316] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   37.019376] scsi 4:0:0:0: Attached scsi generic sg1 type 5
[   37.024809] input: Logitech USB Receiver as /class/input/input1
[   37.025012] input: USB HID v1.10 Mouse [Logitech USB Receiver] on
usb-0000:00:1d.0-1
[   37.025333] usbcore: registered new interface driver usbhid
[   37.025382] drivers/usb/input/hid-core.c: v2.6:USB HID core driver
[   37.026312] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw
xa/form2 cdda tray
[   37.026370] Uniform CD-ROM driver Revision: 3.20
[   37.362728] Attempting manual resume
[   37.419339] SGI XFS with ACLs, realtime, no debug enabled
[   37.472334] Filesystem "dm-0": Disabling barriers, not supported by
the underlying device
[   37.472746] XFS mounting filesystem dm-0
[   37.662579] Starting XFS recovery on filesystem: dm-0 (logdev: internal)
[   38.461059] Ending XFS recovery on filesystem: dm-0 (logdev: internal)
[   41.585513] Linux agpgart interface v0.102 (c) Dave Jones
[   41.724841] agpgart: Detected an Intel 915GM Chipset.
[   41.741921] agpgart: AGP aperture is 256M @ 0x0
[   41.757296] input: PS/2 Mouse as /class/input/input2
[   41.776092] input: AlpsPS/2 ALPS GlidePoint as /class/input/input3
[   41.804732] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.01 (21-Jan-2007)
[   41.804867] iTCO_wdt: Found a ICH6-M TCO device (Version=2,
TCOBASE=0x1060)
[   41.804960] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   41.851929] Real Time Clock Driver v1.12ac
[   41.879265] input: PC Speaker as /class/input/input4
[   42.130778] ieee80211: 802.11 data/management/control stack, git-1.1.13
[   42.130835] ieee80211: Copyright (C) 2004-2005 Intel Corporation
<jketreno@linux.intel.com>
[   42.140470] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver,
1.2.0kmprq
[   42.140528] ipw2200: Copyright(c) 2003-2006 Intel Corporation
[   42.140732] ipw2200: Detected Intel PRO/Wireless 2200BG Network
Connection
[   42.195824] sdhci: Secure Digital Host Controller Interface driver
[   42.195881] sdhci: Copyright(c) Pierre Ossman
[   43.540318] ipw2200: Radio Frequency Kill Switch is On:
[   43.540320] Kill switch must be turned off for wireless networking to
work.
[   43.540528] ipw2200: Detected geography ZZM (11 802.11bg channels, 0
802.11a channels)
[   43.540731] Yenta: CardBus bridge found at 0000:06:04.0 [1179:ff00]
[   43.540817] Yenta: Enabling burst memory read transactions
[   43.540869] Yenta: Using CSCINT to route CSC interrupts to PCI
[   43.540957] Yenta: Routing CardBus interrupts to PCI
[   43.541011] Yenta TI: socket 0000:06:04.0, mfunc 0x10aa1b22, devctl 0x66
[   43.764493] Yenta: ISA IRQ mask 0x00f8, PCI irq 10
[   43.764551] Socket status: 30000006
[   43.764641] Yenta: Raising subordinate bus# of parent bus (#06) from
#07 to #0a
[   43.764699] pcmcia: parent PCI bridge I/O window: 0x6000 - 0x6fff
[   43.764789] pcmcia: parent PCI bridge Memory window: 0xc4000000 -
0xc40fffff
[   43.764839] pcmcia: parent PCI bridge Memory window: 0x50000000 -
0x53ffffff
[   43.766222] sdhci: SDHCI controller found at 0000:06:04.4 [104c:8034]
(rev 0)
[   43.766360] mmc0: SDHCI at 0xc4009400 irq 10 DMA
[   43.766457] mmc1: SDHCI at 0xc4009000 irq 10 DMA
[   43.766552] mmc2: SDHCI at 0xc4006400 irq 10 DMA
[   44.580756] intel8x0_measure_ac97_clock: measured 50508 usecs
[   44.580812] intel8x0: clocking to 48000
[   44.704886] Capability LSM initialized
[   44.780120] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3] C4[C3])
[   44.801715] Time: acpi_pm clocksource has been installed.
[   44.828491] Non-volatile memory driver v1.2
[   44.841139] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[   44.877491] IA-32 Microcode Update Driver: v1.14a
<tigran@aivazian.fsnet.co.uk>
[   44.889690] Machine check exception polling timer started.
[   44.939740] fuse init (API version 7.8)
[   67.168309] Restarting system.

Thanks
-- 
Mathieu
