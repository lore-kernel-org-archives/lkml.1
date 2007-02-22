Return-Path: <linux-kernel-owner+w=401wt.eu-S1946011AbXBVPNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946011AbXBVPNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 10:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946016AbXBVPNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 10:13:21 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:49597 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946011AbXBVPNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 10:13:17 -0500
Message-ID: <45DDB31C.8070306@drzeus.cx>
Date: Thu, 22 Feb 2007 16:13:32 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_hera.drzeus.cx-4993-1172157194-0001-2"
To: Arjan van de Ven <arjan@infradead.org>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Luca Tettamanti <kronos.it@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: NO_HZ: timer interrupt stuck [Re: Linux 2.6.21-rc1]
References: <20070221230409.GA1158@dreamland.darkstar.lan>	 <1172099859.25076.132.camel@localhost.localdomain>	 <Pine.LNX.4.61.0702221334460.28624@yvahk01.tjqt.qr>	 <1172150712.3531.265.camel@laptopd505.fenrus.org>	 <45DDA43A.4030509@drzeus.cx> <1172154034.3531.270.camel@laptopd505.fenrus.org> <45DDADEB.3030309@drzeus.cx>
In-Reply-To: <45DDADEB.3030309@drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-4993-1172157194-0001-2
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

Pierre Ossman wrote:
> Arjan van de Ven wrote:
>> can you get us a dmesg somewhere? maybe the kernel mentions why ;)
>>
>>   
> 
> Sure. My dmesg is full of mmc debug crud right now, but I'll just reboot
> and I'll have a clean one for you.
> 

Here we go.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

--=_hera.drzeus.cx-4993-1172157194-0001-2
Content-Type: text/plain; name="badtick.dmesg"; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="badtick.dmesg"

[    0.000000] Linux version 2.6.21-rc1 (root@poseidon.drzeus.cx) (gcc version 4.1.2 20070214 (Red Hat 4.1.2-1)) #383 PREEMPT Thu Feb 22 08:34:36 CET 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] sanitize start
[    0.000000] sanitize end
[    0.000000] copy_e820_map() start: 0000000000000000 size: 000000000009fc00 end: 000000000009fc00 type: 1
[    0.000000] copy_e820_map() type is E820_RAM
[    0.000000] copy_e820_map() start: 000000000009fc00 size: 0000000000000400 end: 00000000000a0000 type: 2
[    0.000000] copy_e820_map() start: 00000000000e0000 size: 0000000000020000 end: 0000000000100000 type: 2
[    0.000000] copy_e820_map() start: 0000000000100000 size: 000000001fed0000 end: 000000001ffd0000 type: 1
[    0.000000] copy_e820_map() type is E820_RAM
[    0.000000] copy_e820_map() start: 000000001ffd0000 size: 0000000000020c00 end: 000000001fff0c00 type: 2
[    0.000000] copy_e820_map() start: 000000001fff0c00 size: 000000000000b400 end: 000000001fffc000 type: 4
[    0.000000] copy_e820_map() start: 000000001fffc000 size: 0000000000004000 end: 0000000020000000 type: 2
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001ffd0000 (usable)
[    0.000000]  BIOS-e820: 000000001ffd0000 - 000000001fff0c00 (reserved)
[    0.000000]  BIOS-e820: 000000001fff0c00 - 000000001fffc000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000001fffc000 - 0000000020000000 (reserved)
[    0.000000] 511MB LOWMEM available.
[    0.000000] Entering add_active_range(0, 0, 131024) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   131024
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   131024
[    0.000000] On node 0 totalpages: 131024
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 991 pages used for memmap
[    0.000000]   Normal zone: 125937 pages, LIFO batch:31
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000F6560, 0014 (r0 COMPAQ)
[    0.000000] ACPI: RSDT 1FFF0C84, 002C (r1 HP     CPQ0860  13090420 CPQ         1)
[    0.000000] ACPI: FACP 1FFF0C00, 0084 (r2 HP     CPQ0860         2 CPQ         1)
[    0.000000] ACPI: DSDT 1FFF0CB0, 4F8C (r1 HP       nx7000    10000 MSFT  100000E)
[    0.000000] ACPI: FACS 1FFFBE80, 0040
[    0.000000] ACPI: SSDT 1FFF5C3C, 028A (r1 COMPAQ  CPQGysr     1001 MSFT  100000E)
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] Allocating PCI resources starting at 30000000 (gap: 20000000:e0000000)
[    0.000000] Detected 1594.954 MHz processor.
[   14.448059] Built 1 zonelists.  Total pages: 130001
[   14.448062] Kernel command line: ro root=/dev/sda5 rhgb lapic quiet
[   14.448282] Local APIC disabled by BIOS -- reenabling.
[   14.448285] Found and enabled local APIC!
[   14.448289] mapped APIC to ffffd000 (fee00000)
[   14.448292] Enabling fast FPU save and restore... done.
[   14.448295] Enabling unmasked SIMD FPU exception support... done.
[   14.448306] Initializing CPU#0
[   14.448386] CPU 0 irqstacks, hard=c0409000 soft=c0408000
[   14.448390] PID hash table entries: 2048 (order: 11, 8192 bytes)
[   14.449530] Console: colour VGA+ 80x25
[   14.449549] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[   14.449552] ... MAX_LOCKDEP_SUBCLASSES:    8
[   14.449554] ... MAX_LOCK_DEPTH:          30
[   14.449556] ... MAX_LOCKDEP_KEYS:        2048
[   14.449558] ... CLASSHASH_SIZE:           1024
[   14.449560] ... MAX_LOCKDEP_ENTRIES:     8192
[   14.449563] ... MAX_LOCKDEP_CHAINS:      16384
[   14.449565] ... CHAINHASH_SIZE:          8192
[   14.449567]  memory used by lock dependency info: 1096 kB
[   14.449569]  per task-struct memory footprint: 1200 bytes
[   14.449840] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
[   14.450174] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
[   14.465505] Memory: 510664k/524096k available (2021k kernel code, 12812k reserved, 861k data, 196k init, 0k highmem)
[   14.465516] virtual kernel memory layout:
[   14.465517]     fixmap  : 0xfffb7000 - 0xfffff000   ( 288 kB)
[   14.465519]     vmalloc : 0xe0800000 - 0xfffb5000   ( 503 MB)
[   14.465520]     lowmem  : 0xc0000000 - 0xdffd0000   ( 511 MB)
[   14.465522]       .init : 0xc03d2000 - 0xc0403000   ( 196 kB)
[   14.465523]       .data : 0xc02f9796 - 0xc03d0c34   ( 861 kB)
[   14.465525]       .text : 0xc0100000 - 0xc02f9796   (2021 kB)
[   14.465528] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[   14.545754] Calibrating delay using timer specific routine.. 3192.49 BogoMIPS (lpj=6384997)
[   14.545859] Mount-cache hash table entries: 512
[   14.546172] CPU: After generic identify, caps: a7e9fbbf 00000000 00000000 00000000 00000180 00000000 00000000
[   14.546184] CPU: L1 I cache: 32K, L1 D cache: 32K
[   14.546187] CPU: L2 cache: 1024K
[   14.546189] CPU: After all inits, caps: a7e9fbbf 00000000 00000000 00002040 00000180 00000000 00000000
[   14.546197] Intel machine check architecture supported.
[   14.546201] Intel machine check reporting enabled on CPU#0.
[   14.546212] CPU: Intel(R) Pentium(R) M processor 1600MHz stepping 05
[   14.546219] Checking 'hlt' instruction... OK.
[   14.561817] ACPI: Core revision 20070126
[   14.565737] ACPI: setting ELCR to 0200 (from 0c20)
[   14.841876] PM: Adding info for No Bus:platform
[   14.842084] NET: Registered protocol family 16
[   14.842201] PM: Adding info for No Bus:vtcon0
[   14.842321] ACPI: bus type pci registered
[   14.843667] PCI: PCI BIOS revision 2.10 entry at 0xf031f, last bus=3
[   14.843669] PCI: Using configuration type 1
[   14.843672] Setting up standard PCI resources
[   14.856589] ACPI: Interpreter enabled
[   14.856594] ACPI: (supports S0 S3 S4 S5)
[   14.856624] ACPI: Using PIC for interrupt routing
[   14.856672] PM: Adding info for acpi:acpi_system:00
[   14.856761] PM: Adding info for acpi:button_power:00
[   14.856830] PM: Adding info for acpi:ACPI0007:00
[   14.856923] PM: Adding info for acpi:device:00
[   14.857012] PM: Adding info for acpi:PNP0C01:00
[   14.857101] PM: Adding info for acpi:PNP0A03:00
[   14.857179] PM: Adding info for acpi:device:01
[   14.857274] PM: Adding info for acpi:video:00
[   14.857354] PM: Adding info for acpi:device:02
[   14.857434] PM: Adding info for acpi:device:03
[   14.857529] PM: Adding info for acpi:device:04
[   14.857613] PM: Adding info for acpi:device:05
[   14.857700] PM: Adding info for acpi:device:06
[   14.857798] PM: Adding info for acpi:device:07
[   14.857955] PM: Adding info for acpi:device:08
[   14.858039] PM: Adding info for acpi:device:09
[   14.858135] PM: Adding info for acpi:device:0a
[   14.858230] PM: Adding info for acpi:device:0b
[   14.858389] PM: Adding info for acpi:PNP0C09:00
[   14.858798] PM: Adding info for acpi:WEC0518:00
[   14.858889] PM: Adding info for acpi:PNP0A06:00
[   14.859583] PM: Adding info for acpi:PNP0501:00
[   14.859677] PM: Adding info for acpi:power_resource:00
[   14.860356] PM: Adding info for acpi:SMCF010:00
[   14.860433] PM: Adding info for acpi:power_resource:01
[   14.861360] PM: Adding info for acpi:PNP0401:00
[   14.861442] PM: Adding info for acpi:power_resource:02
[   14.861530] PM: Adding info for acpi:PNP0C04:00
[   14.861629] PM: Adding info for acpi:PNP0100:00
[   14.861715] PM: Adding info for acpi:PNP0200:00
[   14.861810] PM: Adding info for acpi:PNP0800:00
[   14.861905] PM: Adding info for acpi:PNP0B00:00
[   14.861992] PM: Adding info for acpi:PNP0303:00
[   14.862108] PM: Adding info for acpi:SYN0107:00
[   14.862198] PM: Adding info for acpi:power_resource:03
[   14.862286] PM: Adding info for acpi:PNP0000:00
[   14.862369] PM: Adding info for acpi:PNP0C02:00
[   14.862473] PM: Adding info for acpi:device:0c
[   14.862562] PM: Adding info for acpi:device:0d
[   14.862646] PM: Adding info for acpi:device:0e
[   14.862744] PM: Adding info for acpi:device:0f
[   14.862841] PM: Adding info for acpi:device:10
[   14.862927] PM: Adding info for acpi:device:11
[   14.863033] PM: Adding info for acpi:device:12
[   14.863121] PM: Adding info for acpi:device:13
[   14.863208] PM: Adding info for acpi:device:14
[   14.863310] PM: Adding info for acpi:device:15
[   14.863408] PM: Adding info for acpi:device:16
[   14.863493] PM: Adding info for acpi:device:17
[   14.863594] PM: Adding info for acpi:device:18
[   14.863680] PM: Adding info for acpi:device:19
[   14.863774] PM: Adding info for acpi:device:1a
[   14.863873] PM: Adding info for acpi:device:1b
[   14.863960] PM: Adding info for acpi:device:1c
[   14.864045] PM: Adding info for acpi:device:1d
[   14.864152] PM: Adding info for acpi:device:1e
[   14.864242] PM: Adding info for acpi:device:1f
[   14.864333] PM: Adding info for acpi:device:20
[   14.864432] PM: Adding info for acpi:device:21
[   14.864522] PM: Adding info for acpi:device:22
[   14.864608] PM: Adding info for acpi:device:23
[   14.864715] PM: Adding info for acpi:device:24
[   14.864802] PM: Adding info for acpi:device:25
[   14.865109] PM: Adding info for acpi:PNP0C0F:00
[   14.865402] PM: Adding info for acpi:PNP0C0F:01
[   14.865681] PM: Adding info for acpi:PNP0C0F:02
[   14.865966] PM: Adding info for acpi:PNP0C0F:03
[   14.866259] PM: Adding info for acpi:PNP0C0F:04
[   14.866537] PM: Adding info for acpi:PNP0C0F:05
[   14.866819] PM: Adding info for acpi:PNP0C0F:06
[   14.867109] PM: Adding info for acpi:PNP0C0F:07
[   14.867205] PM: Adding info for acpi:device:26
[   14.867398] PM: Adding info for acpi:device:27
[   14.867503] PM: Adding info for acpi:PNP0C02:01
[   14.867988] PM: Adding info for acpi:PNP0C0A:00
[   14.868085] PM: Adding info for acpi:ACPI0003:00
[   14.868188] PM: Adding info for acpi:PNP0C0C:00
[   14.868286] PM: Adding info for acpi:PNP0C0D:00
[   14.868602] PM: Adding info for acpi:PNP0C02:02
[   14.868701] PM: Adding info for acpi:thermal:00
[   14.888562] ACPI: PCI Root Bridge [C046] (0000:00)
[   14.888582] PCI: Probing PCI hardware (bus 00)
[   14.888600] PM: Adding info for No Bus:pci0000:00
[   14.889160] PCI quirk: region 1000-107f claimed by ICH4 ACPI/GPIO/TCO
[   14.889166] PCI quirk: region 1100-113f claimed by ICH4 GPIO
[   14.889542] Boot video device is 0000:01:00.0
[   14.889926] PCI: Transparent bridge - 0000:00:1e.0
[   14.890017] PCI: Bus #03 (-#06) is hidden behind transparent bridge #02 (-#03) (try 'pci=assign-busses')
[   14.890020] Please report the result to linux-kernel to fix this permanently
[   14.890046] ACPI: PCI Interrupt Routing Table [\_SB_.C046._PRT]
[   14.890134] ACPI: PCI Interrupt Routing Table [\_SB_.C046.C047._PRT]
[   14.890159] ACPI: PCI Interrupt Routing Table [\_SB_.C046.C058._PRT]
[   14.891226] PM: Adding info for pci:0000:00:00.0
[   14.892273] PM: Adding info for pci:0000:00:01.0
[   14.893301] PM: Adding info for pci:0000:00:1d.0
[   14.894334] PM: Adding info for pci:0000:00:1d.1
[   14.895374] PM: Adding info for pci:0000:00:1d.2
[   14.896400] PM: Adding info for pci:0000:00:1d.7
[   14.897426] PM: Adding info for pci:0000:00:1e.0
[   14.898489] PM: Adding info for pci:0000:00:1f.0
[   14.899515] PM: Adding info for pci:0000:00:1f.1
[   14.900540] PM: Adding info for pci:0000:00:1f.3
[   14.901584] PM: Adding info for pci:0000:00:1f.5
[   14.902616] PM: Adding info for pci:0000:00:1f.6
[   14.902707] PM: Adding info for pci:0000:01:00.0
[   14.902866] PM: Adding info for pci:0000:02:00.0
[   14.903010] PM: Adding info for pci:0000:02:01.0
[   14.903154] PM: Adding info for pci:0000:02:02.0
[   14.903315] PM: Adding info for pci:0000:02:04.0
[   14.903675] ACPI: PCI Interrupt Link [C0C2] (IRQs 5 *10)
[   14.903920] ACPI: PCI Interrupt Link [C0C3] (IRQs 5 *10)
[   14.904159] ACPI: PCI Interrupt Link [C0C4] (IRQs *5 10)
[   14.904398] ACPI: PCI Interrupt Link [C0C5] (IRQs *5 10)
[   14.904622] ACPI: PCI Interrupt Link [C0C6] (IRQs 5 10) *0, disabled.
[   14.904865] ACPI: PCI Interrupt Link [C0C7] (IRQs 5 10) *11
[   14.905089] ACPI: PCI Interrupt Link [C0C8] (IRQs 5 10) *0, disabled.
[   14.905329] ACPI: PCI Interrupt Link [C0C9] (IRQs *5 10)
[   14.905696] ACPI: Power Resource [C18D] (on)
[   14.905914] ACPI: Power Resource [C195] (on)
[   14.906095] ACPI: Power Resource [C19C] (on)
[   14.906149] ACPI: Power Resource [C1A6] (on)
[   14.906181] Linux Plug and Play Support v0.97 (c) Adam Belay
[   14.906215] pnp: PnP ACPI init
[   14.906231] PM: Adding info for No Bus:pnp0
[   14.906407] PM: Adding info for pnp:00:00
[   14.913640] PM: Adding info for pnp:00:01
[   14.914004] PM: Adding info for pnp:00:02
[   14.915128] PM: Adding info for pnp:00:03
[   14.916340] PM: Adding info for pnp:00:04
[   14.917556] PM: Adding info for pnp:00:05
[   14.917633] PM: Adding info for pnp:00:06
[   14.917708] PM: Adding info for pnp:00:07
[   14.917800] PM: Adding info for pnp:00:08
[   14.917870] PM: Adding info for pnp:00:09
[   14.917943] PM: Adding info for pnp:00:0a
[   14.918034] PM: Adding info for pnp:00:0b
[   14.918251] PM: Adding info for pnp:00:0c
[   14.919198] PM: Adding info for pnp:00:0d
[   14.920447] PM: Adding info for pnp:00:0e
[   14.920504] pnp: PnP ACPI: found 15 devices
[   14.920698] PCI: Using ACPI for IRQ routing
[   14.920701] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   14.978391] pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
[   14.978396] pnp: 00:00: iomem range 0xe0000-0xfffff could not be reserved
[   14.978400] pnp: 00:00: iomem range 0x100000-0x1fffffff could not be reserved
[   14.978417] pnp: 00:0c: iomem range 0xffb00000-0xffbfffff has been reserved
[   14.978421] pnp: 00:0c: iomem range 0xfff00000-0xffffffff has been reserved
[   14.978430] pnp: 00:0d: ioport range 0x4d0-0x4d1 has been reserved
[   14.978434] pnp: 00:0d: ioport range 0x1000-0x107f has been reserved
[   14.978438] pnp: 00:0d: ioport range 0x1100-0x113f has been reserved
[   14.978441] pnp: 00:0d: ioport range 0x1200-0x121f has been reserved
[   14.978445] pnp: 00:0d: iomem range 0xfec00000-0xfec000ff has been reserved
[   14.978454] pnp: 00:0e: iomem range 0xd5000-0xd7fff has been reserved
[   14.978458] pnp: 00:0e: iomem range 0xfec01000-0xfec01fff has been reserved
[   14.978506] PM: Adding info for No Bus:mem
[   14.978563] PM: Adding info for No Bus:kmem
[   14.978618] PM: Adding info for No Bus:null
[   14.978687] PM: Adding info for No Bus:port
[   14.978750] PM: Adding info for No Bus:zero
[   14.978805] PM: Adding info for No Bus:full
[   14.978873] PM: Adding info for No Bus:random
[   14.978927] PM: Adding info for No Bus:urandom
[   14.978983] PM: Adding info for No Bus:kmsg
[   14.979082] PCI: Bridge: 0000:00:01.0
[   14.979086]   IO window: 3000-3fff
[   14.979091]   MEM window: 90400000-904fffff
[   14.979096]   PREFETCH window: 98000000-9fffffff
[   14.979106] PCI: Bus 3, cardbus bridge: 0000:02:04.0
[   14.979109]   IO window: 00002800-000028ff
[   14.979114]   IO window: 00002c00-00002cff
[   14.979120]   PREFETCH window: 30000000-33ffffff
[   14.979125]   MEM window: 38000000-3bffffff
[   14.979130] PCI: Bridge: 0000:00:1e.0
[   14.979134]   IO window: 2000-2fff
[   14.979141]   MEM window: 90000000-903fffff
[   14.979146]   PREFETCH window: 30000000-33ffffff
[   14.979167] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[   14.979545] ACPI: PCI Interrupt Link [C0C4] enabled at IRQ 5
[   14.979549] PCI: setting IRQ 5 as level-triggered
[   14.979553] ACPI: PCI Interrupt 0000:02:04.0[A] -> Link [C0C4] -> GSI 5 (level, low) -> IRQ 5
[   14.979600] NET: Registered protocol family 2
[   15.013809] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
[   15.013972] TCP established hash table entries: 16384 (order: 7, 720896 bytes)
[   15.016348] TCP bind hash table entries: 16384 (order: 7, 720896 bytes)
[   15.018857] TCP: Hash tables configured (established 16384 bind 16384)
[   15.018869] TCP reno registered
[   15.030033] checking if image is initramfs... it is
[   15.312865] Freeing initrd memory: 2727k freed
[   15.313192] Machine check exception polling timer started.
[   15.313295] PM: Adding info for platform:pcspkr
[   15.313697] PM: Adding info for No Bus:snapshot
[   15.313774] audit: initializing netlink socket (disabled)
[   15.313806] audit(1172159879.500:1): initialized
[   15.314097] VFS: Disk quotas dquot_6.5.1
[   15.314117] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[   15.314321] io scheduler noop registered
[   15.314325] io scheduler anticipatory registered
[   15.314328] io scheduler deadline registered
[   15.314351] io scheduler cfq registered (default)
[   15.315217] ACPI: PCI Interrupt Link [C0C2] enabled at IRQ 10
[   15.315222] PCI: setting IRQ 10 as level-triggered
[   15.315226] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [C0C2] -> GSI 10 (level, low) -> IRQ 10
[   15.315274] radeonfb: Retrieved PLL infos from BIOS
[   15.315278] radeonfb: Reference=27.00 MHz (RefDiv=12) Memory=250.00 Mhz, System=220.00 MHz
[   15.315282] radeonfb: PLL min 20000 max 35000
[   15.315359] PM: Adding info for No Bus:i2c-0
[   15.315505] PM: Adding info for No Bus:i2c-1
[   15.315600] PM: Adding info for No Bus:i2c-2
[   15.315711] PM: Adding info for No Bus:i2c-3
[   15.415165] i2c_adapter i2c-1: unable to read EDID block.
[   15.571135] i2c_adapter i2c-1: unable to read EDID block.
[   15.727123] i2c_adapter i2c-1: unable to read EDID block.
[   15.883109] i2c_adapter i2c-3: unable to read EDID block.
[   16.039095] i2c_adapter i2c-3: unable to read EDID block.
[   16.195082] i2c_adapter i2c-3: unable to read EDID block.
[   16.249641] Non-DDC laptop panel detected
[   16.351069] i2c_adapter i2c-2: unable to read EDID block.
[   16.507056] i2c_adapter i2c-2: unable to read EDID block.
[   16.663042] i2c_adapter i2c-2: unable to read EDID block.
[   16.819029] i2c_adapter i2c-3: unable to read EDID block.
[   16.975016] i2c_adapter i2c-3: unable to read EDID block.
[   17.131002] i2c_adapter i2c-3: unable to read EDID block.
[   17.186560] radeonfb: Monitor 1 type LCD found
[   17.186562] radeonfb: Monitor 2 type no found
[   17.186569] radeonfb: panel ID string: SEC                     
[   17.186572] radeonfb: detected LVDS panel size from BIOS: 1680x1050
[   17.186576] radeondb: BIOS provided dividers will be used
[   17.305548] radeonfb: Dynamic Clock Power Management enabled
[   17.305566] PM: Adding info for No Bus:fb0
[   17.306919] PM: Adding info for No Bus:vtcon1
[   17.345666] Console: switching to colour frame buffer device 210x65
[   17.379016] radeonfb: Backlight initialized (radeonbl0)
[   17.379021] radeonfb (0000:01:00.0): ATI Radeon Lf 
[   17.379179] PM: Adding info for No Bus:tty
[   17.379246] PM: Adding info for No Bus:console
[   17.379323] PM: Adding info for No Bus:ptmx
[   17.379388] PM: Adding info for No Bus:tty0
[   17.379473] PM: Adding info for No Bus:vcs
[   17.379545] PM: Adding info for No Bus:vcsa
[   17.379602] PM: Adding info for No Bus:tty1
[   17.379685] PM: Adding info for No Bus:tty2
[   17.379739] PM: Adding info for No Bus:tty3
[   17.379804] PM: Adding info for No Bus:tty4
[   17.379870] PM: Adding info for No Bus:tty5
[   17.379935] PM: Adding info for No Bus:tty6
[   17.379995] PM: Adding info for No Bus:tty7
[   17.380068] PM: Adding info for No Bus:tty8
[   17.380127] PM: Adding info for No Bus:tty9
[   17.380189] PM: Adding info for No Bus:tty10
[   17.380266] PM: Adding info for No Bus:tty11
[   17.380327] PM: Adding info for No Bus:tty12
[   17.380386] PM: Adding info for No Bus:tty13
[   17.380463] PM: Adding info for No Bus:tty14
[   17.380525] PM: Adding info for No Bus:tty15
[   17.380585] PM: Adding info for No Bus:tty16
[   17.380659] PM: Adding info for No Bus:tty17
[   17.380719] PM: Adding info for No Bus:tty18
[   17.380781] PM: Adding info for No Bus:tty19
[   17.380859] PM: Adding info for No Bus:tty20
[   17.380920] PM: Adding info for No Bus:tty21
[   17.380986] PM: Adding info for No Bus:tty22
[   17.381063] PM: Adding info for No Bus:tty23
[   17.381124] PM: Adding info for No Bus:tty24
[   17.381185] PM: Adding info for No Bus:tty25
[   17.381263] PM: Adding info for No Bus:tty26
[   17.381328] PM: Adding info for No Bus:tty27
[   17.381390] PM: Adding info for No Bus:tty28
[   17.381465] PM: Adding info for No Bus:tty29
[   17.381527] PM: Adding info for No Bus:tty30
[   17.381604] PM: Adding info for No Bus:tty31
[   17.381680] PM: Adding info for No Bus:tty32
[   17.381742] PM: Adding info for No Bus:tty33
[   17.381806] PM: Adding info for No Bus:tty34
[   17.381888] PM: Adding info for No Bus:tty35
[   17.381952] PM: Adding info for No Bus:tty36
[   17.382017] PM: Adding info for No Bus:tty37
[   17.382101] PM: Adding info for No Bus:tty38
[   17.382169] PM: Adding info for No Bus:tty39
[   17.382233] PM: Adding info for No Bus:tty40
[   17.382313] PM: Adding info for No Bus:tty41
[   17.382378] PM: Adding info for No Bus:tty42
[   17.382450] PM: Adding info for No Bus:tty43
[   17.382532] PM: Adding info for No Bus:tty44
[   17.382597] PM: Adding info for No Bus:tty45
[   17.382663] PM: Adding info for No Bus:tty46
[   17.382746] PM: Adding info for No Bus:tty47
[   17.382812] PM: Adding info for No Bus:tty48
[   17.382878] PM: Adding info for No Bus:tty49
[   17.382966] PM: Adding info for No Bus:tty50
[   17.383033] PM: Adding info for No Bus:tty51
[   17.383099] PM: Adding info for No Bus:tty52
[   17.383182] PM: Adding info for No Bus:tty53
[   17.383248] PM: Adding info for No Bus:tty54
[   17.383316] PM: Adding info for No Bus:tty55
[   17.383399] PM: Adding info for No Bus:tty56
[   17.383467] PM: Adding info for No Bus:tty57
[   17.383537] PM: Adding info for No Bus:tty58
[   17.383622] PM: Adding info for No Bus:tty59
[   17.383690] PM: Adding info for No Bus:tty60
[   17.383756] PM: Adding info for No Bus:tty61
[   17.383846] PM: Adding info for No Bus:tty62
[   17.383916] PM: Adding info for No Bus:tty63
[   17.384003] PM: Adding info for No Bus:ptyp0
[   17.384085] PM: Adding info for No Bus:ptyp1
[   17.384153] PM: Adding info for No Bus:ptyp2
[   17.384220] PM: Adding info for No Bus:ptyp3
[   17.384303] PM: Adding info for No Bus:ptyp4
[   17.384370] PM: Adding info for No Bus:ptyp5
[   17.384436] PM: Adding info for No Bus:ptyp6
[   17.384519] PM: Adding info for No Bus:ptyp7
[   17.384589] PM: Adding info for No Bus:ptyp8
[   17.384656] PM: Adding info for No Bus:ptyp9
[   17.384742] PM: Adding info for No Bus:ptypa
[   17.384810] PM: Adding info for No Bus:ptypb
[   17.384878] PM: Adding info for No Bus:ptypc
[   17.384961] PM: Adding info for No Bus:ptypd
[   17.385029] PM: Adding info for No Bus:ptype
[   17.385099] PM: Adding info for No Bus:ptypf
[   17.385183] PM: Adding info for No Bus:ptyq0
[   17.385255] PM: Adding info for No Bus:ptyq1
[   17.385328] PM: Adding info for No Bus:ptyq2
[   17.385416] PM: Adding info for No Bus:ptyq3
[   17.385488] PM: Adding info for No Bus:ptyq4
[   17.385563] PM: Adding info for No Bus:ptyq5
[   17.385658] PM: Adding info for No Bus:ptyq6
[   17.385729] PM: Adding info for No Bus:ptyq7
[   17.385799] PM: Adding info for No Bus:ptyq8
[   17.385889] PM: Adding info for No Bus:ptyq9
[   17.385959] PM: Adding info for No Bus:ptyqa
[   17.386032] PM: Adding info for No Bus:ptyqb
[   17.386118] PM: Adding info for No Bus:ptyqc
[   17.386189] PM: Adding info for No Bus:ptyqd
[   17.386260] PM: Adding info for No Bus:ptyqe
[   17.386349] PM: Adding info for No Bus:ptyqf
[   17.386421] PM: Adding info for No Bus:ptyr0
[   17.386491] PM: Adding info for No Bus:ptyr1
[   17.386583] PM: Adding info for No Bus:ptyr2
[   17.386662] PM: Adding info for No Bus:ptyr3
[   17.386734] PM: Adding info for No Bus:ptyr4
[   17.386822] PM: Adding info for No Bus:ptyr5
[   17.386896] PM: Adding info for No Bus:ptyr6
[   17.386968] PM: Adding info for No Bus:ptyr7
[   17.387059] PM: Adding info for No Bus:ptyr8
[   17.387132] PM: Adding info for No Bus:ptyr9
[   17.387204] PM: Adding info for No Bus:ptyra
[   17.387296] PM: Adding info for No Bus:ptyrb
[   17.387370] PM: Adding info for No Bus:ptyrc
[   17.387444] PM: Adding info for No Bus:ptyrd
[   17.387537] PM: Adding info for No Bus:ptyre
[   17.387613] PM: Adding info for No Bus:ptyrf
[   17.387689] PM: Adding info for No Bus:ptys0
[   17.387781] PM: Adding info for No Bus:ptys1
[   17.387859] PM: Adding info for No Bus:ptys2
[   17.387937] PM: Adding info for No Bus:ptys3
[   17.388028] PM: Adding info for No Bus:ptys4
[   17.388102] PM: Adding info for No Bus:ptys5
[   17.388187] PM: Adding info for No Bus:ptys6
[   17.388283] PM: Adding info for No Bus:ptys7
[   17.388362] PM: Adding info for No Bus:ptys8
[   17.388438] PM: Adding info for No Bus:ptys9
[   17.388536] PM: Adding info for No Bus:ptysa
[   17.388617] PM: Adding info for No Bus:ptysb
[   17.388695] PM: Adding info for No Bus:ptysc
[   17.388794] PM: Adding info for No Bus:ptysd
[   17.388877] PM: Adding info for No Bus:ptyse
[   17.388961] PM: Adding info for No Bus:ptysf
[   17.389060] PM: Adding info for No Bus:ptyt0
[   17.389143] PM: Adding info for No Bus:ptyt1
[   17.389222] PM: Adding info for No Bus:ptyt2
[   17.389321] PM: Adding info for No Bus:ptyt3
[   17.389404] PM: Adding info for No Bus:ptyt4
[   17.389487] PM: Adding info for No Bus:ptyt5
[   17.389653] PM: Adding info for No Bus:ptyt6
[   17.389737] PM: Adding info for No Bus:ptyt7
[   17.389817] PM: Adding info for No Bus:ptyt8
[   17.389913] PM: Adding info for No Bus:ptyt9
[   17.389996] PM: Adding info for No Bus:ptyta
[   17.390076] PM: Adding info for No Bus:ptytb
[   17.390170] PM: Adding info for No Bus:ptytc
[   17.390254] PM: Adding info for No Bus:ptytd
[   17.390335] PM: Adding info for No Bus:ptyte
[   17.390432] PM: Adding info for No Bus:ptytf
[   17.390513] PM: Adding info for No Bus:ptyu0
[   17.390595] PM: Adding info for No Bus:ptyu1
[   17.390695] PM: Adding info for No Bus:ptyu2
[   17.390777] PM: Adding info for No Bus:ptyu3
[   17.390859] PM: Adding info for No Bus:ptyu4
[   17.390958] PM: Adding info for No Bus:ptyu5
[   17.391040] PM: Adding info for No Bus:ptyu6
[   17.391124] PM: Adding info for No Bus:ptyu7
[   17.391221] PM: Adding info for No Bus:ptyu8
[   17.391304] PM: Adding info for No Bus:ptyu9
[   17.391387] PM: Adding info for No Bus:ptyua
[   17.391490] PM: Adding info for No Bus:ptyub
[   17.391583] PM: Adding info for No Bus:ptyuc
[   17.391675] PM: Adding info for No Bus:ptyud
[   17.391782] PM: Adding info for No Bus:ptyue
[   17.391875] PM: Adding info for No Bus:ptyuf
[   17.391969] PM: Adding info for No Bus:ptyv0
[   17.392072] PM: Adding info for No Bus:ptyv1
[   17.392163] PM: Adding info for No Bus:ptyv2
[   17.392259] PM: Adding info for No Bus:ptyv3
[   17.392368] PM: Adding info for No Bus:ptyv4
[   17.392457] PM: Adding info for No Bus:ptyv5
[   17.392549] PM: Adding info for No Bus:ptyv6
[   17.392656] PM: Adding info for No Bus:ptyv7
[   17.392747] PM: Adding info for No Bus:ptyv8
[   17.392838] PM: Adding info for No Bus:ptyv9
[   17.392950] PM: Adding info for No Bus:ptyva
[   17.393043] PM: Adding info for No Bus:ptyvb
[   17.393137] PM: Adding info for No Bus:ptyvc
[   17.393246] PM: Adding info for No Bus:ptyvd
[   17.393335] PM: Adding info for No Bus:ptyve
[   17.393430] PM: Adding info for No Bus:ptyvf
[   17.393605] PM: Adding info for No Bus:ptyw0
[   17.393699] PM: Adding info for No Bus:ptyw1
[   17.393792] PM: Adding info for No Bus:ptyw2
[   17.393898] PM: Adding info for No Bus:ptyw3
[   17.393989] PM: Adding info for No Bus:ptyw4
[   17.394077] PM: Adding info for No Bus:ptyw5
[   17.394185] PM: Adding info for No Bus:ptyw6
[   17.394277] PM: Adding info for No Bus:ptyw7
[   17.394367] PM: Adding info for No Bus:ptyw8
[   17.394472] PM: Adding info for No Bus:ptyw9
[   17.394565] PM: Adding info for No Bus:ptywa
[   17.394658] PM: Adding info for No Bus:ptywb
[   17.394764] PM: Adding info for No Bus:ptywc
[   17.394855] PM: Adding info for No Bus:ptywd
[   17.394948] PM: Adding info for No Bus:ptywe
[   17.395058] PM: Adding info for No Bus:ptywf
[   17.395150] PM: Adding info for No Bus:ptyx0
[   17.395241] PM: Adding info for No Bus:ptyx1
[   17.395355] PM: Adding info for No Bus:ptyx2
[   17.395449] PM: Adding info for No Bus:ptyx3
[   17.395540] PM: Adding info for No Bus:ptyx4
[   17.395649] PM: Adding info for No Bus:ptyx5
[   17.395750] PM: Adding info for No Bus:ptyx6
[   17.395849] PM: Adding info for No Bus:ptyx7
[   17.395963] PM: Adding info for No Bus:ptyx8
[   17.396064] PM: Adding info for No Bus:ptyx9
[   17.396165] PM: Adding info for No Bus:ptyxa
[   17.396280] PM: Adding info for No Bus:ptyxb
[   17.396383] PM: Adding info for No Bus:ptyxc
[   17.396481] PM: Adding info for No Bus:ptyxd
[   17.396596] PM: Adding info for No Bus:ptyxe
[   17.396697] PM: Adding info for No Bus:ptyxf
[   17.396796] PM: Adding info for No Bus:ptyy0
[   17.396913] PM: Adding info for No Bus:ptyy1
[   17.397013] PM: Adding info for No Bus:ptyy2
[   17.397113] PM: Adding info for No Bus:ptyy3
[   17.397225] PM: Adding info for No Bus:ptyy4
[   17.397329] PM: Adding info for No Bus:ptyy5
[   17.397430] PM: Adding info for No Bus:ptyy6
[   17.397603] PM: Adding info for No Bus:ptyy7
[   17.397703] PM: Adding info for No Bus:ptyy8
[   17.397798] PM: Adding info for No Bus:ptyy9
[   17.397913] PM: Adding info for No Bus:ptyya
[   17.398012] PM: Adding info for No Bus:ptyyb
[   17.398113] PM: Adding info for No Bus:ptyyc
[   17.398225] PM: Adding info for No Bus:ptyyd
[   17.398324] PM: Adding info for No Bus:ptyye
[   17.398425] PM: Adding info for No Bus:ptyyf
[   17.398541] PM: Adding info for No Bus:ptyz0
[   17.398640] PM: Adding info for No Bus:ptyz1
[   17.398738] PM: Adding info for No Bus:ptyz2
[   17.398853] PM: Adding info for No Bus:ptyz3
[   17.398954] PM: Adding info for No Bus:ptyz4
[   17.399054] PM: Adding info for No Bus:ptyz5
[   17.399173] PM: Adding info for No Bus:ptyz6
[   17.399277] PM: Adding info for No Bus:ptyz7
[   17.399377] PM: Adding info for No Bus:ptyz8
[   17.399492] PM: Adding info for No Bus:ptyz9
[   17.399594] PM: Adding info for No Bus:ptyza
[   17.399695] PM: Adding info for No Bus:ptyzb
[   17.399819] PM: Adding info for No Bus:ptyzc
[   17.399923] PM: Adding info for No Bus:ptyzd
[   17.400027] PM: Adding info for No Bus:ptyze
[   17.400154] PM: Adding info for No Bus:ptyzf
[   17.400260] PM: Adding info for No Bus:ptya0
[   17.400368] PM: Adding info for No Bus:ptya1
[   17.400494] PM: Adding info for No Bus:ptya2
[   17.400606] PM: Adding info for No Bus:ptya3
[   17.400712] PM: Adding info for No Bus:ptya4
[   17.400836] PM: Adding info for No Bus:ptya5
[   17.400949] PM: Adding info for No Bus:ptya6
[   17.401059] PM: Adding info for No Bus:ptya7
[   17.401184] PM: Adding info for No Bus:ptya8
[   17.401293] PM: Adding info for No Bus:ptya9
[   17.401401] PM: Adding info for No Bus:ptyaa
[   17.401528] PM: Adding info for No Bus:ptyab
[   17.401694] PM: Adding info for No Bus:ptyac
[   17.401799] PM: Adding info for No Bus:ptyad
[   17.401922] PM: Adding info for No Bus:ptyae
[   17.402029] PM: Adding info for No Bus:ptyaf
[   17.402133] PM: Adding info for No Bus:ptyb0
[   17.402255] PM: Adding info for No Bus:ptyb1
[   17.402360] PM: Adding info for No Bus:ptyb2
[   17.402469] PM: Adding info for No Bus:ptyb3
[   17.402590] PM: Adding info for No Bus:ptyb4
[   17.402701] PM: Adding info for No Bus:ptyb5
[   17.402812] PM: Adding info for No Bus:ptyb6
[   17.402936] PM: Adding info for No Bus:ptyb7
[   17.403045] PM: Adding info for No Bus:ptyb8
[   17.403154] PM: Adding info for No Bus:ptyb9
[   17.403281] PM: Adding info for No Bus:ptyba
[   17.403392] PM: Adding info for No Bus:ptybb
[   17.403502] PM: Adding info for No Bus:ptybc
[   17.403630] PM: Adding info for No Bus:ptybd
[   17.403740] PM: Adding info for No Bus:ptybe
[   17.403854] PM: Adding info for No Bus:ptybf
[   17.403984] PM: Adding info for No Bus:ptyc0
[   17.404103] PM: Adding info for No Bus:ptyc1
[   17.404221] PM: Adding info for No Bus:ptyc2
[   17.404353] PM: Adding info for No Bus:ptyc3
[   17.404472] PM: Adding info for No Bus:ptyc4
[   17.404589] PM: Adding info for No Bus:ptyc5
[   17.404723] PM: Adding info for No Bus:ptyc6
[   17.404840] PM: Adding info for No Bus:ptyc7
[   17.404962] PM: Adding info for No Bus:ptyc8
[   17.405094] PM: Adding info for No Bus:ptyc9
[   17.405216] PM: Adding info for No Bus:ptyca
[   17.405338] PM: Adding info for No Bus:ptycb
[   17.405476] PM: Adding info for No Bus:ptycc
[   17.405658] PM: Adding info for No Bus:ptycd
[   17.405777] PM: Adding info for No Bus:ptyce
[   17.405908] PM: Adding info for No Bus:ptycf
[   17.406025] PM: Adding info for No Bus:ptyd0
[   17.406138] PM: Adding info for No Bus:ptyd1
[   17.406271] PM: Adding info for No Bus:ptyd2
[   17.406388] PM: Adding info for No Bus:ptyd3
[   17.406502] PM: Adding info for No Bus:ptyd4
[   17.406636] PM: Adding info for No Bus:ptyd5
[   17.406752] PM: Adding info for No Bus:ptyd6
[   17.406870] PM: Adding info for No Bus:ptyd7
[   17.406999] PM: Adding info for No Bus:ptyd8
[   17.407116] PM: Adding info for No Bus:ptyd9
[   17.407234] PM: Adding info for No Bus:ptyda
[   17.407367] PM: Adding info for No Bus:ptydb
[   17.407486] PM: Adding info for No Bus:ptydc
[   17.407602] PM: Adding info for No Bus:ptydd
[   17.407741] PM: Adding info for No Bus:ptyde
[   17.407862] PM: Adding info for No Bus:ptydf
[   17.407984] PM: Adding info for No Bus:ptye0
[   17.408120] PM: Adding info for No Bus:ptye1
[   17.408248] PM: Adding info for No Bus:ptye2
[   17.408373] PM: Adding info for No Bus:ptye3
[   17.408510] PM: Adding info for No Bus:ptye4
[   17.408635] PM: Adding info for No Bus:ptye5
[   17.408764] PM: Adding info for No Bus:ptye6
[   17.408908] PM: Adding info for No Bus:ptye7
[   17.409038] PM: Adding info for No Bus:ptye8
[   17.409163] PM: Adding info for No Bus:ptye9
[   17.409310] PM: Adding info for No Bus:ptyea
[   17.409442] PM: Adding info for No Bus:ptyeb
[   17.409634] PM: Adding info for No Bus:ptyec
[   17.409777] PM: Adding info for No Bus:ptyed
[   17.409901] PM: Adding info for No Bus:ptyee
[   17.410027] PM: Adding info for No Bus:ptyef
[   17.410173] PM: Adding info for No Bus:ttyp0
[   17.410293] PM: Adding info for No Bus:ttyp1
[   17.410412] PM: Adding info for No Bus:ttyp2
[   17.410548] PM: Adding info for No Bus:ttyp3
[   17.410672] PM: Adding info for No Bus:ttyp4
[   17.410792] PM: Adding info for No Bus:ttyp5
[   17.410932] PM: Adding info for No Bus:ttyp6
[   17.411053] PM: Adding info for No Bus:ttyp7
[   17.411176] PM: Adding info for No Bus:ttyp8
[   17.411313] PM: Adding info for No Bus:ttyp9
[   17.411435] PM: Adding info for No Bus:ttypa
[   17.411559] PM: Adding info for No Bus:ttypb
[   17.411698] PM: Adding info for No Bus:ttypc
[   17.411822] PM: Adding info for No Bus:ttypd
[   17.411947] PM: Adding info for No Bus:ttype
[   17.412089] PM: Adding info for No Bus:ttypf
[   17.412217] PM: Adding info for No Bus:ttyq0
[   17.412345] PM: Adding info for No Bus:ttyq1
[   17.412495] PM: Adding info for No Bus:ttyq2
[   17.412628] PM: Adding info for No Bus:ttyq3
[   17.412755] PM: Adding info for No Bus:ttyq4
[   17.412906] PM: Adding info for No Bus:ttyq5
[   17.413041] PM: Adding info for No Bus:ttyq6
[   17.413180] PM: Adding info for No Bus:ttyq7
[   17.413327] PM: Adding info for No Bus:ttyq8
[   17.413464] PM: Adding info for No Bus:ttyq9
[   17.413655] PM: Adding info for No Bus:ttyqa
[   17.413802] PM: Adding info for No Bus:ttyqb
[   17.413931] PM: Adding info for No Bus:ttyqc
[   17.414060] PM: Adding info for No Bus:ttyqd
[   17.414208] PM: Adding info for No Bus:ttyqe
[   17.414342] PM: Adding info for No Bus:ttyqf
[   17.414471] PM: Adding info for No Bus:ttyr0
[   17.414614] PM: Adding info for No Bus:ttyr1
[   17.414746] PM: Adding info for No Bus:ttyr2
[   17.414877] PM: Adding info for No Bus:ttyr3
[   17.415022] PM: Adding info for No Bus:ttyr4
[   17.415154] PM: Adding info for No Bus:ttyr5
[   17.415290] PM: Adding info for No Bus:ttyr6
[   17.415438] PM: Adding info for No Bus:ttyr7
[   17.415569] PM: Adding info for No Bus:ttyr8
[   17.415702] PM: Adding info for No Bus:ttyr9
[   17.415854] PM: Adding info for No Bus:ttyra
[   17.415987] PM: Adding info for No Bus:ttyrb
[   17.416119] PM: Adding info for No Bus:ttyrc
[   17.416270] PM: Adding info for No Bus:ttyrd
[   17.416405] PM: Adding info for No Bus:ttyre
[   17.416548] PM: Adding info for No Bus:ttyrf
[   17.416700] PM: Adding info for No Bus:ttys0
[   17.416838] PM: Adding info for No Bus:ttys1
[   17.416980] PM: Adding info for No Bus:ttys2
[   17.417139] PM: Adding info for No Bus:ttys3
[   17.417276] PM: Adding info for No Bus:ttys4
[   17.417420] PM: Adding info for No Bus:ttys5
[   17.417645] PM: Adding info for No Bus:ttys6
[   17.417790] PM: Adding info for No Bus:ttys7
[   17.417925] PM: Adding info for No Bus:ttys8
[   17.418076] PM: Adding info for No Bus:ttys9
[   17.418213] PM: Adding info for No Bus:ttysa
[   17.418352] PM: Adding info for No Bus:ttysb
[   17.418506] PM: Adding info for No Bus:ttysc
[   17.418645] PM: Adding info for No Bus:ttysd
[   17.418782] PM: Adding info for No Bus:ttyse
[   17.418938] PM: Adding info for No Bus:ttysf
[   17.419076] PM: Adding info for No Bus:ttyt0
[   17.419213] PM: Adding info for No Bus:ttyt1
[   17.419370] PM: Adding info for No Bus:ttyt2
[   17.419515] PM: Adding info for No Bus:ttyt3
[   17.419657] PM: Adding info for No Bus:ttyt4
[   17.419814] PM: Adding info for No Bus:ttyt5
[   17.419954] PM: Adding info for No Bus:ttyt6
[   17.420096] PM: Adding info for No Bus:ttyt7
[   17.420256] PM: Adding info for No Bus:ttyt8
[   17.420399] PM: Adding info for No Bus:ttyt9
[   17.420540] PM: Adding info for No Bus:ttyta
[   17.420704] PM: Adding info for No Bus:ttytb
[   17.420856] PM: Adding info for No Bus:ttytc
[   17.421003] PM: Adding info for No Bus:ttytd
[   17.421171] PM: Adding info for No Bus:ttyte
[   17.421323] PM: Adding info for No Bus:ttytf
[   17.421470] PM: Adding info for No Bus:ttyu0
[   17.421695] PM: Adding info for No Bus:ttyu1
[   17.421842] PM: Adding info for No Bus:ttyu2
[   17.421986] PM: Adding info for No Bus:ttyu3
[   17.422145] PM: Adding info for No Bus:ttyu4
[   17.422289] PM: Adding info for No Bus:ttyu5
[   17.422431] PM: Adding info for No Bus:ttyu6
[   17.422593] PM: Adding info for No Bus:ttyu7
[   17.422737] PM: Adding info for No Bus:ttyu8
[   17.422885] PM: Adding info for No Bus:ttyu9
[   17.423054] PM: Adding info for No Bus:ttyua
[   17.423203] PM: Adding info for No Bus:ttyub
[   17.423350] PM: Adding info for No Bus:ttyuc
[   17.423514] PM: Adding info for No Bus:ttyud
[   17.423664] PM: Adding info for No Bus:ttyue
[   17.423814] PM: Adding info for No Bus:ttyuf
[   17.423976] PM: Adding info for No Bus:ttyv0
[   17.424129] PM: Adding info for No Bus:ttyv1
[   17.424276] PM: Adding info for No Bus:ttyv2
[   17.424441] PM: Adding info for No Bus:ttyv3
[   17.424589] PM: Adding info for No Bus:ttyv4
[   17.424738] PM: Adding info for No Bus:ttyv5
[   17.424918] PM: Adding info for No Bus:ttyv6
[   17.425075] PM: Adding info for No Bus:ttyv7
[   17.425227] PM: Adding info for No Bus:ttyv8
[   17.425403] PM: Adding info for No Bus:ttyv9
[   17.425621] PM: Adding info for No Bus:ttyva
[   17.425779] PM: Adding info for No Bus:ttyvb
[   17.425945] PM: Adding info for No Bus:ttyvc
[   17.426096] PM: Adding info for No Bus:ttyvd
[   17.426247] PM: Adding info for No Bus:ttyve
[   17.426421] PM: Adding info for No Bus:ttyvf
[   17.426574] PM: Adding info for No Bus:ttyw0
[   17.426727] PM: Adding info for No Bus:ttyw1
[   17.426900] PM: Adding info for No Bus:ttyw2
[   17.427057] PM: Adding info for No Bus:ttyw3
[   17.427211] PM: Adding info for No Bus:ttyw4
[   17.427380] PM: Adding info for No Bus:ttyw5
[   17.427536] PM: Adding info for No Bus:ttyw6
[   17.427696] PM: Adding info for No Bus:ttyw7
[   17.427868] PM: Adding info for No Bus:ttyw8
[   17.428025] PM: Adding info for No Bus:ttyw9
[   17.428181] PM: Adding info for No Bus:ttywa
[   17.428357] PM: Adding info for No Bus:ttywb
[   17.428516] PM: Adding info for No Bus:ttywc
[   17.428672] PM: Adding info for No Bus:ttywd
[   17.428848] PM: Adding info for No Bus:ttywe
[   17.429017] PM: Adding info for No Bus:ttywf
[   17.429182] PM: Adding info for No Bus:ttyx0
[   17.429361] PM: Adding info for No Bus:ttyx1
[   17.429523] PM: Adding info for No Bus:ttyx2
[   17.429745] PM: Adding info for No Bus:ttyx3
[   17.429919] PM: Adding info for No Bus:ttyx4
[   17.430084] PM: Adding info for No Bus:ttyx5
[   17.430244] PM: Adding info for No Bus:ttyx6
[   17.430423] PM: Adding info for No Bus:ttyx7
[   17.430585] PM: Adding info for No Bus:ttyx8
[   17.430744] PM: Adding info for No Bus:ttyx9
[   17.430924] PM: Adding info for No Bus:ttyxa
[   17.431087] PM: Adding info for No Bus:ttyxb
[   17.431249] PM: Adding info for No Bus:ttyxc
[   17.431430] PM: Adding info for No Bus:ttyxd
[   17.431593] PM: Adding info for No Bus:ttyxe
[   17.431759] PM: Adding info for No Bus:ttyxf
[   17.431936] PM: Adding info for No Bus:ttyy0
[   17.432102] PM: Adding info for No Bus:ttyy1
[   17.432265] PM: Adding info for No Bus:ttyy2
[   17.432446] PM: Adding info for No Bus:ttyy3
[   17.432611] PM: Adding info for No Bus:ttyy4
[   17.432777] PM: Adding info for No Bus:ttyy5
[   17.432963] PM: Adding info for No Bus:ttyy6
[   17.433137] PM: Adding info for No Bus:ttyy7
[   17.433304] PM: Adding info for No Bus:ttyy8
[   17.433488] PM: Adding info for No Bus:ttyy9
[   17.433723] PM: Adding info for No Bus:ttyya
[   17.433896] PM: Adding info for No Bus:ttyyb
[   17.434080] PM: Adding info for No Bus:ttyyc
[   17.434249] PM: Adding info for No Bus:ttyyd
[   17.434418] PM: Adding info for No Bus:ttyye
[   17.434602] PM: Adding info for No Bus:ttyyf
[   17.434771] PM: Adding info for No Bus:ttyz0
[   17.434937] PM: Adding info for No Bus:ttyz1
[   17.435125] PM: Adding info for No Bus:ttyz2
[   17.435299] PM: Adding info for No Bus:ttyz3
[   17.435465] PM: Adding info for No Bus:ttyz4
[   17.435647] PM: Adding info for No Bus:ttyz5
[   17.435817] PM: Adding info for No Bus:ttyz6
[   17.435988] PM: Adding info for No Bus:ttyz7
[   17.436171] PM: Adding info for No Bus:ttyz8
[   17.436342] PM: Adding info for No Bus:ttyz9
[   17.436511] PM: Adding info for No Bus:ttyza
[   17.436703] PM: Adding info for No Bus:ttyzb
[   17.436875] PM: Adding info for No Bus:ttyzc
[   17.437045] PM: Adding info for No Bus:ttyzd
[   17.437237] PM: Adding info for No Bus:ttyze
[   17.437413] PM: Adding info for No Bus:ttyzf
[   17.437651] PM: Adding info for No Bus:ttya0
[   17.437849] PM: Adding info for No Bus:ttya1
[   17.438024] PM: Adding info for No Bus:ttya2
[   17.438198] PM: Adding info for No Bus:ttya3
[   17.438386] PM: Adding info for No Bus:ttya4
[   17.438562] PM: Adding info for No Bus:ttya5
[   17.438736] PM: Adding info for No Bus:ttya6
[   17.438926] PM: Adding info for No Bus:ttya7
[   17.439103] PM: Adding info for No Bus:ttya8
[   17.439281] PM: Adding info for No Bus:ttya9
[   17.439474] PM: Adding info for No Bus:ttyaa
[   17.439651] PM: Adding info for No Bus:ttyab
[   17.439826] PM: Adding info for No Bus:ttyac
[   17.440016] PM: Adding info for No Bus:ttyad
[   17.440195] PM: Adding info for No Bus:ttyae
[   17.440374] PM: Adding info for No Bus:ttyaf
[   17.440564] PM: Adding info for No Bus:ttyb0
[   17.440746] PM: Adding info for No Bus:ttyb1
[   17.440926] PM: Adding info for No Bus:ttyb2
[   17.441123] PM: Adding info for No Bus:ttyb3
[   17.441302] PM: Adding info for No Bus:ttyb4
[   17.441486] PM: Adding info for No Bus:ttyb5
[   17.441746] PM: Adding info for No Bus:ttyb6
[   17.441933] PM: Adding info for No Bus:ttyb7
[   17.442111] PM: Adding info for No Bus:ttyb8
[   17.442311] PM: Adding info for No Bus:ttyb9
[   17.442493] PM: Adding info for No Bus:ttyba
[   17.442677] PM: Adding info for No Bus:ttybb
[   17.442872] PM: Adding info for No Bus:ttybc
[   17.443054] PM: Adding info for No Bus:ttybd
[   17.443234] PM: Adding info for No Bus:ttybe
[   17.443436] PM: Adding info for No Bus:ttybf
[   17.443618] PM: Adding info for No Bus:ttyc0
[   17.443800] PM: Adding info for No Bus:ttyc1
[   17.444003] PM: Adding info for No Bus:ttyc2
[   17.444193] PM: Adding info for No Bus:ttyc3
[   17.444375] PM: Adding info for No Bus:ttyc4
[   17.444573] PM: Adding info for No Bus:ttyc5
[   17.444757] PM: Adding info for No Bus:ttyc6
[   17.444949] PM: Adding info for No Bus:ttyc7
[   17.445149] PM: Adding info for No Bus:ttyc8
[   17.445335] PM: Adding info for No Bus:ttyc9
[   17.445520] PM: Adding info for No Bus:ttyca
[   17.445785] PM: Adding info for No Bus:ttycb
[   17.445974] PM: Adding info for No Bus:ttycc
[   17.446160] PM: Adding info for No Bus:ttycd
[   17.446369] PM: Adding info for No Bus:ttyce
[   17.446559] PM: Adding info for No Bus:ttycf
[   17.446748] PM: Adding info for No Bus:ttyd0
[   17.446950] PM: Adding info for No Bus:ttyd1
[   17.447138] PM: Adding info for No Bus:ttyd2
[   17.447326] PM: Adding info for No Bus:ttyd3
[   17.447528] PM: Adding info for No Bus:ttyd4
[   17.447719] PM: Adding info for No Bus:ttyd5
[   17.447909] PM: Adding info for No Bus:ttyd6
[   17.448117] PM: Adding info for No Bus:ttyd7
[   17.448306] PM: Adding info for No Bus:ttyd8
[   17.448493] PM: Adding info for No Bus:ttyd9
[   17.448701] PM: Adding info for No Bus:ttyda
[   17.448896] PM: Adding info for No Bus:ttydb
[   17.449084] PM: Adding info for No Bus:ttydc
[   17.449294] PM: Adding info for No Bus:ttydd
[   17.449482] PM: Adding info for No Bus:ttyde
[   17.449737] PM: Adding info for No Bus:ttydf
[   17.449944] PM: Adding info for No Bus:ttye0
[   17.450134] PM: Adding info for No Bus:ttye1
[   17.450324] PM: Adding info for No Bus:ttye2
[   17.450533] PM: Adding info for No Bus:ttye3
[   17.450729] PM: Adding info for No Bus:ttye4
[   17.450921] PM: Adding info for No Bus:ttye5
[   17.451131] PM: Adding info for No Bus:ttye6
[   17.451325] PM: Adding info for No Bus:ttye7
[   17.451519] PM: Adding info for No Bus:ttye8
[   17.451730] PM: Adding info for No Bus:ttye9
[   17.451926] PM: Adding info for No Bus:ttyea
[   17.452126] PM: Adding info for No Bus:ttyeb
[   17.452339] PM: Adding info for No Bus:ttyec
[   17.452536] PM: Adding info for No Bus:ttyed
[   17.452733] PM: Adding info for No Bus:ttyee
[   17.452950] PM: Adding info for No Bus:ttyef
[   17.453041] PM: Adding info for No Bus:rtc
[   17.453112] Real Time Clock Driver v1.12ac
[   17.453127] PM: Adding info for No Bus:hpet
[   17.453349] PM: Adding info for No Bus:nvram
[   17.453410] Non-volatile memory driver v1.2
[   17.453414] Linux agpgart interface v0.102 (c) Dave Jones
[   17.453491] agpgart: Detected an Intel 855PM Chipset.
[   17.467082] PM: Adding info for No Bus:agpgart
[   17.467185] agpgart: AGP aperture is 256M @ 0xb0000000
[   17.467259] [drm] Initialized drm 1.1.0 20060810
[   17.467262] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
[   17.467265] Hangcheck: Using get_cycles().
[   17.467295] PM: Adding info for No Bus:isa
[   17.468471] RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
[   17.468583] PM: Adding info for No Bus:lo
[   17.469040] PNP: PS/2 Controller [PNP0303:C1A3,PNP0f13:C1A4] at 0x60,0x64 irq 1,12
[   17.469143] PM: Adding info for platform:i8042
[   17.479662] i8042.c: Detected active multiplexing controller, rev 1.1.
[   17.484951] serio: i8042 KBD port at 0x60,0x64 irq 1
[   17.484981] PM: Adding info for serio:serio0
[   17.485019] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[   17.485023] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[   17.485028] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[   17.485032] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[   17.485134] PM: Adding info for serio:serio1
[   17.485191] mice: PS/2 mouse device common for all mice
[   17.485257] PM: Adding info for serio:serio2
[   17.485976] input: PC Speaker as /class/input/input0
[   17.489176] PM: Adding info for serio:serio3
[   17.516161] NET: Registered protocol family 1
[   17.516168] NET: Registered protocol family 17
[   17.516437] Testing NMI watchdog ... <7>PM: Adding info for serio:serio4
[   17.556788] OK.
[   17.556791] Using IPI Shortcut mode
[   17.556923] swsusp: Resume From Partition /dev/hda2
[   17.556925] PM: Checking swsusp image.
[   17.556942] swsusp: Error -6 check for resume file
[   17.556944] PM: Resume from disk failed.
[   17.557449] Freeing unused kernel memory: 196k freed
[   17.557515] Write protecting the kernel read-only data: 646k
[   17.557524] Time: tsc clocksource has been installed.
[   17.557605] PM: Adding info for No Bus:vcs1
[   17.557674] PM: Adding info for No Bus:vcsa1
[   17.833716] usbcore: registered new interface driver usbfs
[   17.833786] usbcore: registered new interface driver hub
[   17.833871] usbcore: registered new device driver usb
[   17.836138] USB Universal Host Controller Interface driver v3.0
[   17.836237] ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [C0C2] -> GSI 10 (level, low) -> IRQ 10
[   17.836253] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[   17.836258] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   17.836502] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
[   17.836533] uhci_hcd 0000:00:1d.0: irq 10, io base 0x000048c0
[   17.836648] PM: Adding info for usb:usb1
[   17.836812] PM: Adding info for No Bus:usbdev1.1_ep00
[   17.836864] usb usb1: configuration #1 chosen from 1 choice
[   17.836901] PM: Adding info for usb:1-0:1.0
[   17.836970] hub 1-0:1.0: USB hub found
[   17.836995] hub 1-0:1.0: 2 ports detected
[   17.937548] PM: Adding info for No Bus:usbdev1.1_ep81
[   17.937647] PM: Adding info for No Bus:usbdev1.1
[   17.938191] ACPI: PCI Interrupt Link [C0C5] enabled at IRQ 5
[   17.938194] ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [C0C5] -> GSI 5 (level, low) -> IRQ 5
[   17.938206] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[   17.938210] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   17.938263] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
[   17.938289] uhci_hcd 0000:00:1d.1: irq 5, io base 0x000048e0
[   17.938380] PM: Adding info for usb:usb2
[   17.938473] PM: Adding info for No Bus:usbdev2.1_ep00
[   17.938519] usb usb2: configuration #1 chosen from 1 choice
[   17.938538] PM: Adding info for usb:2-0:1.0
[   17.938585] hub 2-0:1.0: USB hub found
[   17.938597] hub 2-0:1.0: 2 ports detected
[   18.017509] Switched to high resolution mode on CPU 0
[   18.041396] PM: Adding info for No Bus:usbdev2.1_ep81
[   18.041461] PM: Adding info for No Bus:usbdev2.1
[   18.041546] ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [C0C4] -> GSI 5 (level, low) -> IRQ 5
[   18.041561] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[   18.041565] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   18.041633] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
[   18.041656] uhci_hcd 0000:00:1d.2: irq 5, io base 0x00004c00
[   18.041734] PM: Adding info for usb:usb3
[   18.041821] PM: Adding info for No Bus:usbdev3.1_ep00
[   18.041866] usb usb3: configuration #1 chosen from 1 choice
[   18.041885] PM: Adding info for usb:3-0:1.0
[   18.041948] hub 3-0:1.0: USB hub found
[   18.041959] hub 3-0:1.0: 2 ports detected
[   18.145369] PM: Adding info for No Bus:usbdev3.1_ep81
[   18.145436] PM: Adding info for No Bus:usbdev3.1
[   18.147639] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[   18.151112] ACPI: PCI Interrupt Link [C0C9] enabled at IRQ 5
[   18.151117] ACPI: PCI Interrupt 0000:00:1d.7[D] -> Link [C0C9] -> GSI 5 (level, low) -> IRQ 5
[   18.151133] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[   18.151138] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   18.151199] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 4
[   18.151239] ehci_hcd 0000:00:1d.7: debug port 1
[   18.151248] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[   18.151257] ehci_hcd 0000:00:1d.7: irq 5, io mem 0xa0000000
[   18.155131] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   18.155193] PM: Adding info for usb:usb4
[   18.155277] PM: Adding info for No Bus:usbdev4.1_ep00
[   18.155308] usb usb4: configuration #1 chosen from 1 choice
[   18.155330] PM: Adding info for usb:4-0:1.0
[   18.155377] hub 4-0:1.0: USB hub found
[   18.155436] hub 4-0:1.0: 6 ports detected
[   18.257358] PM: Adding info for No Bus:usbdev4.1_ep81
[   18.257424] PM: Adding info for No Bus:usbdev4.1
[   18.274141] SCSI subsystem initialized
[   18.289005] libata version 2.10 loaded.
[   18.292848] ata_piix 0000:00:1f.1: version 2.00ac7
[   18.292871] PCI: Enabling device 0000:00:1f.1 (0005 -> 0007)
[   18.292884] ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [C0C4] -> GSI 5 (level, low) -> IRQ 5
[   18.292912] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[   18.293061] ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x00014c40 irq 14
[   18.293109] ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x00014c48 irq 15
[   18.293143] scsi0 : ata_piix
[   18.293158] PM: Adding info for No Bus:host0
[   18.317733] Synaptics Touchpad, model: 1, fw: 5.9, id: 0x236eb3, caps: 0x904713/0x10008
[   18.375112] input: SynPS/2 Synaptics TouchPad as /class/input/input1
[   18.403567] input: AT Translated Set 2 keyboard as /class/input/input2
[   18.457965] ata1.00: ATA-6: FUJITSU MHT2080AH PL, 006C, max UDMA/100
[   18.457969] ata1.00: 156301488 sectors, multi 16: LBA 
[   18.469868] ata1.00: configured for UDMA/100
[   18.469878] scsi1 : ata_piix
[   18.469907] PM: Adding info for No Bus:host1
[   18.789870] ata2.00: ATAPI, max MWDMA2
[   18.889270] usb 3-2: new full speed USB device using uhci_hcd and address 2
[   18.953823] ata2.00: configured for MWDMA2
[   18.953843] PM: Adding info for No Bus:target0:0:0
[   18.954047] scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHT2080A 006C PQ: 0 ANSI: 5
[   18.954076] PM: Adding info for scsi:0:0:0:0
[   18.954276] SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
[   18.954296] sda: Write Protect is off
[   18.954298] sda: Mode Sense: 00 3a 00 00
[   18.954331] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   18.954458] SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
[   18.954477] sda: Write Protect is off
[   18.954479] sda: Mode Sense: 00 3a 00 00
[   18.954512] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   18.954516]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   18.998407] sd 0:0:0:0: Attached scsi disk sda
[   18.998481] PM: Adding info for No Bus:target1:0:0
[   19.003578] scsi 1:0:0:0: CD-ROM            HL-DT-ST RW/DVD GCC-4241N 0C29 PQ: 0 ANSI: 5
[   19.003590] PM: Adding info for scsi:1:0:0:0
[   19.121408] PM: Adding info for usb:3-2
[   19.121488] PM: Adding info for No Bus:usbdev3.2_ep00
[   19.121520] usb 3-2: configuration #1 chosen from 1 choice
[   19.125419] PM: Adding info for usb:3-2:1.0
[   19.125473] PM: Adding info for No Bus:usbdev3.2_ep81
[   19.125513] PM: Adding info for No Bus:usbdev3.2_ep02
[   19.125567] PM: Adding info for No Bus:usbdev3.2_ep82
[   19.125601] PM: Adding info for usb:3-2:1.1
[   19.125649] PM: Adding info for No Bus:usbdev3.2_ep03
[   19.125701] PM: Adding info for No Bus:usbdev3.2_ep83
[   19.125737] PM: Adding info for usb:3-2:1.2
[   19.125807] PM: Adding info for No Bus:usbdev3.2
[   22.019963] EXT3-fs: mounted filesystem with ordered data mode.
[   22.020261] kjournald starting.  Commit interval 5 seconds
[   22.745062] PM: Removing info for No Bus:vcs1
[   22.745148] PM: Removing info for No Bus:vcsa1
[   22.745238] PM: Adding info for No Bus:vcs1
[   22.745264] PM: Adding info for No Bus:vcsa1
[   22.745307] PM: Removing info for No Bus:vcs1
[   22.745337] PM: Removing info for No Bus:vcsa1
[   22.853108] PM: Adding info for No Bus:vcs1
[   22.853136] PM: Adding info for No Bus:vcsa1
[   29.827217] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   29.827249] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[   30.101069] ieee80211_crypt: registered algorithm 'NULL'
[   30.182908] ACPI: PCI Interrupt Link [C0C3] enabled at IRQ 10
[   30.182914] ACPI: PCI Interrupt 0000:00:1f.3[B] -> Link [C0C3] -> GSI 10 (level, low) -> IRQ 10
[   30.182966] PM: Adding info for No Bus:i2c-4
[   30.344355] ieee80211: 802.11 data/management/control stack, git-1.1.13
[   30.344361] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[   30.481651] ieee1394: Initialized config rom entry `ip1394'
[   30.531451] intel_rng: FWH not detected
[   30.578518] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[   30.578526] Uniform CD-ROM driver Revision: 3.20
[   30.578720] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   30.598491] 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
[   30.598576] ACPI: PCI Interrupt 0000:02:01.0[A] -> Link [C0C3] -> GSI 10 (level, low) -> IRQ 10
[   30.598941] PM: Adding info for No Bus:eth0
[   30.599142] eth0: RTL-8139C+ at 0xe18e8000, 00:02:3f:22:db:8c, IRQ 10
[   30.727508] Serial: 8250/16550 driver $Revision: 1.90 $ 2 ports, IRQ sharing disabled
[   30.727636] PM: Adding info for platform:serial8250
[   30.727840] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   30.728078] PM: Adding info for No Bus:ttyS0
[   30.728232] PM: Adding info for No Bus:ttyS1
[   30.749708] PM: Removing info for No Bus:ttyS0
[   30.749880] 00:03: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   30.750112] PM: Adding info for No Bus:ttyS0
[   30.890646] parport: PnPBIOS parport detected.
[   30.890771] parport0: PC-style at 0x378 (0x778), irq 7, dma 1 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
[   30.924586] ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [C0C2] -> GSI 10 (level, low) -> IRQ 10
[   30.924707] PM: Adding info for ieee1394:fw-host0
[   30.977898] ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[10]  MMIO=[90200000-902007ff]  Max Packet=[1024]  IR/IT contexts=[4/8]
[   31.317914] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.0kmprq
[   31.317919] ipw2200: Copyright(c) 2003-2006 Intel Corporation
[   31.318059] ACPI: PCI Interrupt 0000:02:02.0[A] -> Link [C0C5] -> GSI 5 (level, low) -> IRQ 5
[   31.318128] ipw2200: Detected Intel PRO/Wireless 2200BG Network Connection
[   31.318341] PM: Adding info for No Bus:0000:02:02.0
[   31.521036] rtc_cmos 00:09: rtc core: registered rtc_cmos as rtc0
[   31.521090] pnp: Device 00:09 does not support disabling.
[   31.521098] rtc_cmos: probe of 00:09 failed with error -16
[   31.567553] Bluetooth: Core ver 2.11
[   31.567578] PM: Adding info for platform:bluetooth
[   31.567672] NET: Registered protocol family 31
[   31.567674] Bluetooth: HCI device and connection manager initialized
[   31.567776] Bluetooth: HCI socket layer initialized
[   31.809583] NET: Registered protocol family 23
[   31.890511] PM: Adding info for No Bus:timer
[   31.923764] wbsd: Winbond W83L51xD SD/MMC card interface driver
[   31.923768] wbsd: Copyright(c) Pierre Ossman
[   31.924599] pnp: Device 00:02 activated.
[   31.924603] wbsd [wbsd_pnp_probe()]: PnP resources: port 248 irq 6 dma 0
[   31.929771] PM: Adding info for No Bus:mmc0
[   31.929793] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
[   31.929862] mmc0: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 21 width 0 timing 0
[   31.930866] mmc0: clock 375000Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[   31.932863] mmc0: clock 375000Hz busmode 1 powermode 2 cs 1 Vdd 21 width 0 timing 0
[   31.933867] mmc0: starting CMD0 arg 00000000 flags 00000040
[   31.933870] wbsd [wbsd_request_end()]: Ending request, cmd (0)
[   31.933894] mmc0: req done (CMD0): 1/0/0: 00000000 00000000 00000000 00000000
[   31.934892] mmc0: clock 375000Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[   31.935898] mmc0: starting CMD8 arg 000001aa flags 00000075
[   31.935901] wbsd [wbsd_request_end()]: Ending request, cmd (8)
[   31.935909] mmc0: req done (CMD8): 1/0/0: 00000000 00000000 00000000 00000000
[   31.935914] mmc0: starting CMD55 arg 00000000 flags 00000015
[   31.935917] wbsd [wbsd_request_end()]: Ending request, cmd (37)
[   31.935925] mmc0: req done (CMD55): 1/0/0: 00000000 00000000 00000000 00000000
[   31.935930] mmc0: starting CMD55 arg 00000000 flags 00000015
[   31.935932] wbsd [wbsd_request_end()]: Ending request, cmd (37)
[   31.935940] mmc0: req done (CMD55): 1/0/0: 00000000 00000000 00000000 00000000
[   31.935945] mmc0: starting CMD55 arg 00000000 flags 00000015
[   31.935948] wbsd [wbsd_request_end()]: Ending request, cmd (37)
[   31.935956] mmc0: req done (CMD55): 1/0/0: 00000000 00000000 00000000 00000000
[   31.935960] mmc0: starting CMD55 arg 00000000 flags 00000015
[   31.935963] wbsd [wbsd_request_end()]: Ending request, cmd (37)
[   31.935971] mmc0: req done (CMD55): 1/0/0: 00000000 00000000 00000000 00000000
[   31.935975] mmc0: starting CMD1 arg 00000000 flags 00000061
[   31.935978] wbsd [wbsd_request_end()]: Ending request, cmd (1)
[   31.935986] mmc0: req done (CMD1): 1/0/0: 00000000 00000000 00000000 00000000
[   31.935991] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
[   31.936317] mmc0: W83L51xD id 7112 at 0x248 irq 6 dma 0 PnP
[   31.940026] wbsd: Resetting card detection ignore
[   31.946630] Bluetooth: HCI USB driver ver 2.9
[   31.991096] Detected unconfigured Compaq x1000 family SMSC IrDA chip, pre-configuring device.
[   31.991101] Setting up Intel 82801 controller and SMSC device
[   31.991232] found SMC SuperIO Chip (devid=0x5a rev=00 base=0x002e): LPC47N227
[   31.991248] smsc_superio_flat(): fir: 0x2f8, sir: 0x2e8, dma: 03, irq: 7, mode: 0x0e
[   31.991264] SMsC IrDA Controller found
[   31.991266]  IrCC version 2.0, firport 0x2f8, sirport 0x2e8 dma=3, irq=7
[   31.991329] No transceiver found. Defaulting to Fast pin select
[   32.037151] PM: Removing info for No Bus:usbdev3.2_ep03
[   32.037226] PM: Removing info for No Bus:usbdev3.2_ep83
[   32.037305] PM: Adding info for No Bus:usbdev3.2_ep03
[   32.037347] PM: Adding info for No Bus:usbdev3.2_ep83
[   32.037430] PM: Adding info for No Bus:hci0
[   32.037518] usbcore: registered new interface driver hci_usb
[   32.108177] PM: Removing info for No Bus:0000:02:02.0
[   32.227503] PM: Adding info for No Bus:eth1
[   32.227593] ipw2200: Detected geography ZZR (14 802.11bg channels, 0 802.11a channels)
[   32.228010] PM: Adding info for No Bus:irda0
[   32.228064] PM: Adding info for platform:smsc-ircc2.0
[   32.228098] IrDA: Registered device irda0
[   32.228317] Yenta: CardBus bridge found at 0000:02:04.0 [0e11:0860]
[   32.228341] Yenta: Using CSCINT to route CSC interrupts to PCI
[   32.228344] Yenta: Routing CardBus interrupts to PCI
[   32.228350] Yenta TI: socket 0000:02:04.0, mfunc 0x001c1112, devctl 0x44
[   32.252311] PM: Adding info for ieee1394:00023f454a000284
[   32.252452] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023f454a000284]
[   32.252486] PM: Adding info for ieee1394:00023f454a000284-0
[   32.435247] PM: Adding info for No Bus:seq
[   32.464486] Yenta: ISA IRQ mask 0x0818, PCI irq 5
[   32.464491] Socket status: 30000006
[   32.464495] Yenta: Raising subordinate bus# of parent bus (#02) from #03 to #06
[   32.464511] pcmcia: parent PCI bridge I/O window: 0x2000 - 0x2fff
[   32.464595] cs: IO port probe 0x2000-0x2fff: clean.
[   32.465321] pcmcia: parent PCI bridge Memory window: 0x90000000 - 0x903fffff
[   32.465325] pcmcia: parent PCI bridge Memory window: 0x30000000 - 0x33ffffff
[   32.465507] PM: Adding info for No Bus:pcmcia_socket0
[   32.521484] PM: Adding info for No Bus:sequencer
[   32.521601] PM: Adding info for No Bus:sequencer2
[   32.665760] ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [C0C3] -> GSI 10 (level, low) -> IRQ 10
[   32.665798] PCI: Setting latency timer of device 0000:00:1f.5 to 64
[   32.912227] cs: IO port probe 0x100-0x3af: excluding 0x140-0x14f 0x200-0x20f
[   32.914055] cs: IO port probe 0x3e0-0x4ff: clean.
[   32.914883] cs: IO port probe 0x820-0x8ff: clean.
[   32.915596] cs: IO port probe 0xc00-0xcf7: clean.
[   32.916632] cs: IO port probe 0xa00-0xaff: clean.
[   33.591857] intel8x0_measure_ac97_clock: measured 55258 usecs
[   33.591861] intel8x0: clocking to 48000
[   33.591899] PM: Adding info for No Bus:card0
[   33.592421] PM: Adding info for No Bus:pcmC0D4p
[   33.592727] PM: Adding info for No Bus:pcmC0D3c
[   33.592902] PM: Adding info for No Bus:pcmC0D2c
[   33.593082] PM: Adding info for No Bus:pcmC0D1c
[   33.593321] PM: Adding info for No Bus:adsp
[   33.593545] PM: Adding info for No Bus:pcmC0D0p
[   33.593716] PM: Adding info for No Bus:pcmC0D0c
[   33.593911] PM: Adding info for No Bus:dsp
[   33.594085] PM: Adding info for No Bus:audio
[   33.594275] PM: Adding info for ac97:0-0:AD1981B
[   33.594644] PM: Adding info for No Bus:controlC0
[   33.594905] PM: Adding info for No Bus:mixer
[   33.758500] ACPI: PCI Interrupt 0000:00:1f.6[B] -> Link [C0C3] -> GSI 10 (level, low) -> IRQ 10
[   33.758524] PCI: Setting latency timer of device 0000:00:1f.6 to 64
[   33.764207] PM: Adding info for No Bus:card1
[   33.764266] PM: Adding info for No Bus:pcmC1D0p
[   33.764315] PM: Adding info for No Bus:pcmC1D0c
[   33.764395] PM: Adding info for No Bus:dsp1
[   33.764430] PM: Adding info for No Bus:audio1
[   33.764476] PM: Adding info for ac97:1-1:Si3036,8
[   33.764537] PM: Adding info for No Bus:controlC1
[   33.764589] PM: Adding info for No Bus:mixer1
[   34.259958] lp0: using parport0 (interrupt-driven).
[   36.009355] PM: Adding info for No Bus:vcs8
[   36.009578] PM: Adding info for No Bus:vcsa8
[   36.010233] PM: Removing info for No Bus:vcs8
[   36.010430] PM: Removing info for No Bus:vcsa8
[   36.011992] PM: Adding info for No Bus:vcs8
[   36.012128] PM: Adding info for No Bus:vcsa8
[   36.016604] PM: Removing info for No Bus:vcs8
[   36.016788] PM: Removing info for No Bus:vcsa8
[   36.746895] NET: Registered protocol family 10
[   36.747096] lo: Disabled Privacy Extensions
[   36.747345] Mobile IPv6
[   37.069451] PM: Adding info for No Bus:vcs8
[   37.069650] PM: Adding info for No Bus:vcsa8
[   37.508858] [drm] Initialized radeon 1.25.0 20060524 on minor 0
[   44.424120] ACPI: AC Adapter [C134] (on-line)
[   44.445177] ACPI: Battery Slot [C11F] (battery absent)
[   44.472180] input: Power Button (FF) as /class/input/input3
[   44.487990] ACPI: Power Button (FF) [PWRF]
[   44.497199] input: Power Button (CM) as /class/input/input4
[   44.497648] ACPI: Power Button (CM) [C1BE]
[   44.498073] input: Lid Switch as /class/input/input5
[   44.498253] ACPI: Lid Switch [C136]
[   44.577672] No dock devices found.
[   44.714156] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[   44.714165] ACPI: Processor [CPU0] (supports 8 throttling states)
[   44.738813] Time: acpi_pm clocksource has been installed.
[   44.754662] ACPI: Video Device [C0D0] (multi-head: yes  rom: no  post: no)
[   48.399426] EXT3 FS on sda5, internal journal
[   48.516847] kjournald starting.  Commit interval 5 seconds
[   48.517208] EXT3 FS on sda1, internal journal
[   48.517218] EXT3-fs: mounted filesystem with ordered data mode.
[   48.616915] FAT: utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
[   48.642486] FAT: utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
[   49.233012] Adding 1000432k swap on /dev/sda2.  Priority:-1 extents:1 across:1000432k
[   49.396740] PM: Removing info for No Bus:vcs1
[   49.396980] PM: Removing info for No Bus:vcsa1
[   49.656687] PM: Adding info for No Bus:microcode
[   49.672342] PM: Adding info for platform:microcode
[   49.677982] PM: Adding info for No Bus:microcode
[   49.680015] PM: Removing info for No Bus:microcode
[   49.680983] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
[   49.821236] PM: Removing info for No Bus:microcode
[   49.822660] PM: Removing info for platform:microcode
[   50.859647] Clocksource tsc unstable (delta = -150132146 ns)
[   54.182545] audit(1172156319.053:2): audit_pid=2713 old=0 by auid=4294967295
[   76.598140] Bluetooth: L2CAP ver 2.8
[   76.598147] Bluetooth: L2CAP socket layer initialized
[   76.780339] Bluetooth: RFCOMM socket layer initialized
[   76.780360] Bluetooth: RFCOMM TTY layer initialized
[   76.780363] Bluetooth: RFCOMM ver 1.8
[   93.468314] Bluetooth: HIDP (Human Interface Emulation) ver 1.1
[   94.821804] IrCOMM protocol (Dag Brattli)
[   94.971210] PM: Adding info for No Bus:ircomm0
[  118.771468] PM: Adding info for No Bus:ircomm1
[  118.806250] PM: Adding info for No Bus:ircomm2
[  118.807503] PM: Adding info for No Bus:ircomm3
[  118.808667] PM: Adding info for No Bus:ircomm4
[  118.809714] PM: Adding info for No Bus:ircomm5
[  118.810773] PM: Adding info for No Bus:ircomm6
[  118.811908] PM: Adding info for No Bus:ircomm7
[  118.812755] PM: Adding info for No Bus:ircomm8
[  118.813158] PM: Adding info for No Bus:ircomm9
[  118.813566] PM: Adding info for No Bus:ircomm10
[  118.813952] PM: Adding info for No Bus:ircomm11
[  118.814330] PM: Adding info for No Bus:ircomm12
[  118.814732] PM: Adding info for No Bus:ircomm13
[  118.815110] PM: Adding info for No Bus:ircomm14
[  118.815576] PM: Adding info for No Bus:ircomm15
[  118.815983] PM: Adding info for No Bus:ircomm16
[  118.816365] PM: Adding info for No Bus:ircomm17
[  118.816742] PM: Adding info for No Bus:ircomm18
[  118.817152] PM: Adding info for No Bus:ircomm19
[  118.817531] PM: Adding info for No Bus:ircomm20
[  118.817916] PM: Adding info for No Bus:ircomm21
[  118.818384] PM: Adding info for No Bus:ircomm22
[  118.818772] PM: Adding info for No Bus:ircomm23
[  118.819154] PM: Adding info for No Bus:ircomm24
[  118.819578] PM: Adding info for No Bus:ircomm25
[  118.819963] PM: Adding info for No Bus:ircomm26
[  118.820351] PM: Adding info for No Bus:ircomm27
[  118.820766] PM: Adding info for No Bus:ircomm28
[  118.821158] PM: Adding info for No Bus:ircomm29
[  118.821545] PM: Adding info for No Bus:ircomm30
[  118.821961] PM: Adding info for No Bus:ircomm31
[  119.961500] PPP generic driver version 2.4.2
[  119.961812] PM: Adding info for No Bus:ppp
[  120.114758] PM: Adding info for No Bus:irnet
[  120.397247] PM: Adding info for No Bus:irda1
[  120.398141] IrDA: Registered device irda1 (irport io=0x3E8 irq=3)
[  123.513058] tun: Universal TUN/TAP device driver, 1.6
[  123.513303] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[  123.513505] PM: Adding info for No Bus:tun
[   86.581310] eth0: link down
[   86.581521] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  148.171216] PM: Adding info for No Bus:vcs1
[  148.171292] PM: Adding info for No Bus:vcsa1
[  148.171409] PM: Removing info for No Bus:vcs1
[  148.171482] PM: Removing info for No Bus:vcsa1
[  148.171601] PM: Adding info for No Bus:vcs1
[  148.171652] PM: Adding info for No Bus:vcsa1
[  148.231785] PM: Adding info for No Bus:vcs2
[  148.232003] PM: Adding info for No Bus:vcsa2
[  148.232204] PM: Removing info for No Bus:vcs2
[  148.232369] PM: Removing info for No Bus:vcsa2
[  148.232753] PM: Adding info for No Bus:vcs2
[  148.232896] PM: Adding info for No Bus:vcsa2
[  148.235379] PM: Adding info for No Bus:vcs3
[  148.235559] PM: Adding info for No Bus:vcsa3
[  148.235776] PM: Removing info for No Bus:vcs3
[  148.235936] PM: Removing info for No Bus:vcsa3
[  148.236147] PM: Adding info for No Bus:vcs3
[  148.236287] PM: Adding info for No Bus:vcsa3
[  148.263994] PM: Adding info for No Bus:vcs4
[  148.264245] PM: Adding info for No Bus:vcsa4
[  148.264832] PM: Removing info for No Bus:vcs4
[  148.264998] PM: Removing info for No Bus:vcsa4
[  148.267191] PM: Adding info for No Bus:vcs5
[  148.267367] PM: Adding info for No Bus:vcsa5
[  148.267556] PM: Removing info for No Bus:vcs5
[  148.267711] PM: Removing info for No Bus:vcsa5
[  148.267920] PM: Adding info for No Bus:vcs5
[  148.268059] PM: Adding info for No Bus:vcsa5
[  148.270719] PM: Adding info for No Bus:vcs6
[  148.270896] PM: Adding info for No Bus:vcsa6
[  148.271110] PM: Removing info for No Bus:vcs6
[  148.271266] PM: Removing info for No Bus:vcsa6
[  148.271474] PM: Adding info for No Bus:vcs6
[  148.271614] PM: Adding info for No Bus:vcsa6
[  148.280530] PM: Adding info for No Bus:vcs4
[  148.280901] PM: Adding info for No Bus:vcsa4
[  119.929036] mtrr: no MTRR for 98000000,4000000 found
[  120.515772] PM: Adding info for No Bus:vcs7
[  120.516152] PM: Adding info for No Bus:vcsa7
[  101.915202] agpgart: Found an AGP 2.0 compliant device at 0000:00:00.0.
[  101.915228] agpgart: Putting AGP V2 device at 0000:00:00.0 into 1x mode
[  101.915284] agpgart: Putting AGP V2 device at 0000:01:00.0 into 1x mode
[  102.236240] [drm] Setting GART location based on new memory map
[  102.236253] [drm] Loading R200 Microcode
[  102.236346] [drm] writeback test succeeded in 2 usecs
[  157.770700] ieee80211_crypt: registered algorithm 'WEP'
[  158.285463] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[  151.274779] eth1: no IPv6 routers present

--=_hera.drzeus.cx-4993-1172157194-0001-2--
