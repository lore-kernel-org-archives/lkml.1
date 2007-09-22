Return-Path: <linux-kernel-owner+w=401wt.eu-S1757680AbXIVF2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680AbXIVF2S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 01:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbXIVF2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 01:28:10 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:7920 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbXIVF2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 01:28:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:mime-version:message-id:content-type;
        b=pxUHBRxOrPm7N9W4qa1O6kVJ0ohhRR2GR4VFyu3IhFteLPcZMuQ1PX8Sx0hVJKoilurJDXT9ADwTnQ9jFLJPTgvBs+SP2aLo7WCtJ3r4e+c8CTLMXDx+GUZmAZHyqQirmq/NTy292Ji135F0t68iamUcr139Xa3lC8L3l/rg00c=
From: Mihai =?utf-8?q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Organization: Home
To: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc7 + radeonfb/s2ram
Date: Sat, 22 Sep 2007 08:27:59 +0300
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Message-Id: <200709220828.00078.mihai.dontu@gmail.com>
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_gfK9GHzN0ooP5JF"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_gfK9GHzN0ooP5JF
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

Hi,

Today, out of curiosity, I pulled 2.6.23-rc7 (leave on the edge in a quiet weekend).
Anyway, it seems that radeonfb and my:
"01:05.0 VGA compatible controller: ATI Technologies Inc ATI Radeon XPRESS 200M 5955 (PCIE)"
don't get along anymore, by:
a) X somehow fails to initialize the card and everything moves really slow (I can
   see how surfaces are drawn pixel-by-pixel); furthermore, garbage stuff appears
   on the screen;
b) after powering up from a s2ram, the system freezes;

b) is not that bad, s2ram never worked on my machine (kjournald and some other kernel
processes, enter disk-sleep and in a matter of seconds, everything just... freezes.
I can type a few commands at the normal console but that is all);

Following the advices in 'Documentation/power/s2ram.txt' helped. Using the regular
VGA console got X on the right track (no more slowness);

Now that I got my hands "dirty", I'm in the mood to make my s2ram work (I've
been using Linux (exclusively) for three years now, it's about time I do a small
contribution). What kernel option must I enable to determine why some processes
enter (and stay in) disk-sleep? I'm on a laptop and I don't think it will withstand
too many reboots :)

I've also attached the output of lspci and dmesg. Maybe someone spots something.

Thanks,

-- 
Mihai Donțu

--Boundary-00=_gfK9GHzN0ooP5JF
Content-Type: text/plain;
  charset="utf-8";
  name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg.txt"

[    0.000000] Linux version 2.6.23-rc7 (root@mdontu-l) (gcc version 4.1.2 (Gentoo 4.1.2)) #3 PREEMPT Sat Sep 22 07:27:11 EEST 2007
[    0.000000] Command line: vga=791 nohz=on
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000037fd0000 (usable)
[    0.000000]  BIOS-e820: 0000000037fd0000 - 0000000037fefc00 (reserved)
[    0.000000]  BIOS-e820: 0000000037fefc00 - 0000000037ffb000 (ACPI NVS)
[    0.000000]  BIOS-e820: 0000000037ffb000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec02000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb80000 - 00000000ffc00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 229328) 1 entries of 256 used
[    0.000000] end_pfn_map = 1048576
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000FE270, 0014 (r0 HP    )
[    0.000000] ACPI: RSDT 37FEFC84, 0034 (r1 HP     0944     22110520 HP          1)
[    0.000000] ACPI: FACP 37FEFC00, 0084 (r2 HP     0944            2 HP          1)
[    0.000000] ACPI: DSDT 37FEFD50, 7489 (r1 HP        SB400    10000 MSFT  100000E)
[    0.000000] ACPI: FACS 37FFAE80, 0040
[    0.000000] ACPI: APIC 37FEFCB8, 005A (r1 HP     0944            1 HP          1)
[    0.000000] ACPI: MCFG 37FEFD14, 003C (r1 HP     0944            1 HP          1)
[    0.000000] ACPI: SSDT 37FF71D9, 0382 (r1 HP       HPQPpc     1001 MSFT  100000E)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 229328) 1 entries of 256 used
[    0.000000] No mptable found.
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   229328
[    0.000000] On node 0 totalpages: 229231
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1960 pages reserved
[    0.000000]   DMA zone: 1983 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 3079 pages used for memmap
[    0.000000]   DMA32 zone: 222153 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ATI board detected. Disabling timer routing over 8254.
[    0.000000] ACPI: PM-Timer IO Port: 0x8008
[    0.000000] ACPI: Local APIC address 0xfec01000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 21 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
[    0.000000] Built 1 zonelists in Zone order.  Total pages: 224136
[    0.000000] Kernel command line: vga=791 nohz=on
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[   12.786092] time.c: Detected 2194.600 MHz processor.
[   12.786144] Console: colour dummy device 80x25
[   12.786147] console [tty0] enabled
[   12.787596] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[   12.788545] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[   12.802567] Memory: 894672k/917312k available (4273k kernel code, 21992k reserved, 1859k data, 236k init)
[   12.861967] Calibrating delay using timer specific routine.. 4391.74 BogoMIPS (lpj=2195874)
[   12.862016] Mount-cache hash table entries: 256
[   12.862158] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   12.862164] CPU: L2 Cache: 1024K (64 bytes/line)
[   12.862180] CPU: AMD Turion(tm) 64 Mobile ML-40                  stepping 02
[   12.862198] ACPI: Core revision 20070126
[   12.908049] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[   12.918051] Using local APIC timer interrupts.
[   12.963563] result 12469321
[   12.963567] Detected 12.469 MHz APIC timer.
[   12.964004] NET: Registered protocol family 16
[   12.964170] No dock devices found.
[   12.964230] ACPI: bus type pci registered
[   12.969191] PCI: Using MMCONFIG at e0000000 - efffffff
[   12.969241] PCI: No mmconfig possible on device 00:18
[   12.972159] ACPI: EC: Look up EC in DSDT
[   12.972236] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[   12.988942] ACPI: Interpreter enabled
[   12.988949] ACPI: (supports S0 S3)
[   12.988959] ACPI: Using IOAPIC for interrupt routing
[   12.996274] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[   12.996315] ACPI: PCI Root Bridge [C047] (0000:00)
[   12.997693] PCI: Transparent bridge - 0000:00:14.4
[   12.997807] ACPI: PCI Interrupt Routing Table [\_SB_.C047._PRT]
[   12.998000] ACPI: PCI Interrupt Routing Table [\_SB_.C047.C048._PRT]
[   12.998090] ACPI: PCI Interrupt Routing Table [\_SB_.C047.C0AB._PRT]
[   13.011605] ACPI: PCI Interrupt Link [C0F0] (IRQs 10 11) *0, disabled.
[   13.011752] ACPI: PCI Interrupt Link [C0F1] (IRQs 10 11) *0, disabled.
[   13.011892] ACPI: PCI Interrupt Link [C0F2] (IRQs 10 11) *0, disabled.
[   13.012029] ACPI: PCI Interrupt Link [C0F3] (IRQs 10 11) *0, disabled.
[   13.012167] ACPI: PCI Interrupt Link [C0F4] (IRQs 10 11) *0, disabled.
[   13.012306] ACPI: PCI Interrupt Link [C0F5] (IRQs 9) *0, disabled.
[   13.012444] ACPI: PCI Interrupt Link [C0F6] (IRQs 10 11) *0, disabled.
[   13.012589] ACPI: PCI Interrupt Link [C0F7] (IRQs *10 11)
[   13.012707] ACPI: Power Resource [C1CF] (off)
[   13.012880] ACPI: Power Resource [C1B7] (on)
[   13.012923] ACPI: Power Resource [C1C7] (on)
[   13.013011] ACPI: Power Resource [C26C] (off)
[   13.013093] ACPI: Power Resource [C26D] (off)
[   13.013176] ACPI: Power Resource [C26E] (off)
[   13.013258] ACPI: Power Resource [C26F] (off)
[   13.013292] Linux Plug and Play Support v0.97 (c) Adam Belay
[   13.013314] pnp: PnP ACPI init
[   13.013322] ACPI: bus type pnp registered
[   13.019489] pnp: PnP ACPI: found 12 devices
[   13.019494] ACPI: ACPI bus type pnp unregistered
[   13.019665] SCSI subsystem initialized
[   13.019686] libata version 2.21 loaded.
[   13.019776] usbcore: registered new interface driver usbfs
[   13.019816] usbcore: registered new interface driver hub
[   13.019844] usbcore: registered new device driver usb
[   13.019977] PCI: Using ACPI for IRQ routing
[   13.019982] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   13.019993] PCI: Cannot allocate resource region 7 of bridge 0000:00:04.0
[   13.019997] PCI: Cannot allocate resource region 8 of bridge 0000:00:04.0
[   13.020002] PCI: Cannot allocate resource region 9 of bridge 0000:00:04.0
[   13.020006] PCI: Cannot allocate resource region 7 of bridge 0000:00:05.0
[   13.020010] PCI: Cannot allocate resource region 8 of bridge 0000:00:05.0
[   13.020015] PCI: Cannot allocate resource region 9 of bridge 0000:00:05.0
[   13.023732] Bluetooth: Core ver 2.11
[   13.023777] NET: Registered protocol family 31
[   13.023781] Bluetooth: HCI device and connection manager initialized
[   13.023786] Bluetooth: HCI socket layer initialized
[   13.023791] NET: Registered protocol family 8
[   13.023795] NET: Registered protocol family 20
[   13.024721] Time: tsc clocksource has been installed.
[   13.026739] pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
[   13.026745] pnp: 00:00: iomem range 0xe0000-0xfffff could not be reserved
[   13.026749] pnp: 00:00: iomem range 0x100000-0x37ffffff could not be reserved
[   13.026758] pnp: 00:09: ioport range 0x40b-0x40b has been reserved
[   13.026763] pnp: 00:09: ioport range 0x4d0-0x4d1 has been reserved
[   13.026768] pnp: 00:09: ioport range 0x4d6-0x4d6 has been reserved
[   13.026773] pnp: 00:09: iomem range 0xffb80000-0xffbfffff could not be reserved
[   13.026780] pnp: 00:09: iomem range 0xfff80000-0xffffffff could not be reserved
[   13.026788] pnp: 00:0a: ioport range 0x8000-0x802f has been reserved
[   13.026793] pnp: 00:0a: ioport range 0x8100-0x811f has been reserved
[   13.026799] pnp: 00:0a: iomem range 0xe0000000-0xefffffff could not be reserved
[   13.026806] pnp: 00:0a: iomem range 0xfec00000-0xfec000ff has been reserved
[   13.026812] pnp: 00:0b: iomem range 0xcf000-0xdffff has been reserved
[   13.026817] pnp: 00:0b: iomem range 0x38000000-0x3fffffff could not be reserved
[   13.026824] pnp: 00:0b: iomem range 0xfec01000-0xfec01fff could not be reserved
[   13.027038] PCI: Bridge: 0000:00:01.0
[   13.027043]   IO window: 2000-2fff
[   13.027047]   MEM window: d0400000-d07fffff
[   13.027051]   PREFETCH window: c0000000-cfffffff
[   13.027054] PCI: Bridge: 0000:00:04.0
[   13.027058]   IO window: disabled.
[   13.027061]   MEM window: disabled.
[   13.027065]   PREFETCH window: disabled.
[   13.027068] PCI: Bridge: 0000:00:05.0
[   13.027071]   IO window: disabled.
[   13.027075]   MEM window: disabled.
[   13.027078]   PREFETCH window: disabled.
[   13.027084] PCI: Bus 3, cardbus bridge: 0000:02:04.0
[   13.027088]   IO window: 00001000-000010ff
[   13.027091]   IO window: 00001400-000014ff
[   13.027095]   PREFETCH window: 50000000-53ffffff
[   13.027099]   MEM window: 54000000-57ffffff
[   13.027102] PCI: Bridge: 0000:00:14.4
[   13.027107]   IO window: 1000-1fff
[   13.027111]   MEM window: d0000000-d03fffff
[   13.027114]   PREFETCH window: 50000000-53ffffff
[   13.027128] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   13.027133] PCI: Setting latency timer of device 0000:00:05.0 to 64
[   13.027156] ACPI: PCI Interrupt 0000:02:04.0[A] -> GSI 20 (level, low) -> IRQ 20
[   13.027182] NET: Registered protocol family 2
[   13.035736] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[   13.036136] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[   13.038277] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[   13.038817] TCP: Hash tables configured (established 131072 bind 65536)
[   13.038823] TCP reno registered
[   13.042543] VFS: Disk quotas dquot_6.5.1
[   13.042559] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   13.042658] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   13.042878] NTFS driver 2.1.28 [Flags: R/O].
[   13.042907] fuse init (API version 7.8)
[   13.043048] io scheduler noop registered
[   13.043053] io scheduler anticipatory registered
[   13.043057] io scheduler deadline registered
[   13.043068] io scheduler cfq registered (default)
[   13.043076] PCI: MSI quirk detected. MSI deactivated.
[   13.044257] Boot video device is 0000:01:05.0
[   13.044406] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   13.044421] assign_interrupt_mode Found MSI capability
[   13.044431] Allocate Port Service[0000:00:04.0:pcie00]
[   13.044460] Allocate Port Service[0000:00:04.0:pcie01]
[   13.044484] Allocate Port Service[0000:00:04.0:pcie02]
[   13.044523] PCI: Setting latency timer of device 0000:00:05.0 to 64
[   13.044537] assign_interrupt_mode Found MSI capability
[   13.044542] Allocate Port Service[0000:00:05.0:pcie00]
[   13.044564] Allocate Port Service[0000:00:05.0:pcie01]
[   13.044586] Allocate Port Service[0000:00:05.0:pcie02]
[   13.044677] AER service couldn't init device 0000:00:04.0:pcie01 - no _OSC support
[   13.044745] AER service couldn't init device 0000:00:05.0:pcie01 - no _OSC support
[   13.044810] vesafb: framebuffer at 0xc0000000, mapped to 0xffffc20010100000, using 3072k, total 131072k
[   13.044818] vesafb: mode is 1024x768x16, linelength=2048, pages=84
[   13.044822] vesafb: scrolling: redraw
[   13.044827] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[   13.053803] Console: switching to colour frame buffer device 128x48
[   13.061906] fb0: VESA VGA frame buffer device
[   13.063401] ACPI: AC Adapter [C177] (on-line)
[   13.063651] ACPI: Battery Slot [C179] (battery present)
[   13.063922] ACPI: Battery Slot [C178] (battery absent)
[   13.064100] input: Power Button (FF) as /class/input/input0
[   13.064194] ACPI: Power Button (FF) [PWRF]
[   13.064325] input: Sleep Button (CM) as /class/input/input1
[   13.064420] ACPI: Sleep Button (CM) [C1F0]
[   13.064542] input: Lid Switch as /class/input/input2
[   13.064627] ACPI: Lid Switch [C1F1]
[   13.064874] ACPI: Transitioning device [C270] to D3
[   13.064957] ACPI: Transitioning device [C270] to D3
[   13.065040] ACPI: Fan [C270] (off)
[   13.065250] ACPI: Transitioning device [C271] to D3
[   13.065333] ACPI: Transitioning device [C271] to D3
[   13.065417] ACPI: Fan [C271] (off)
[   13.065626] ACPI: Transitioning device [C272] to D3
[   13.065713] ACPI: Transitioning device [C272] to D3
[   13.066913] ACPI: Fan [C272] (off)
[   13.068284] ACPI: Transitioning device [C273] to D3
[   13.069579] ACPI: Transitioning device [C273] to D3
[   13.070877] ACPI: Fan [C273] (off)
[   13.072497] input: Video Bus as /class/input/input3
[   13.073909] ACPI: Video Device [C049] (multi-head: yes  rom: no  post: no)
[   13.075691] ACPI: CPU0 (power states: C1[C1] C3[C3])
[   13.077280] ACPI: Processor [C000] (supports 8 throttling states)
[   13.086327] ACPI: Thermal Zone [TZ1] (65 C)
[   13.091176] ACPI: Thermal Zone [TZ2] (55 C)
[   13.100727] ACPI: Thermal Zone [TZ3] (27 C)
[   13.117727] Real Time Clock Driver v1.12ac
[   13.119654] Non-volatile memory driver v1.2
[   13.121483] Linux agpgart interface v0.102
[   13.123397] ipmi message handler version 39.1
[   13.125322] ipmi device interface
[   13.127304] IPMI System Interface driver.
[   13.137584] ipmi_si: Unable to find any System Interface(s)
[   13.139673] IPMI Watchdog: driver initialized
[   13.141809] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[   13.144104] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
[   13.146541] Hangcheck: Using get_cycles().
[   13.149000] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[   13.151966] ACPI: PCI Interrupt 0000:00:14.6[B] -> GSI 17 (level, low) -> IRQ 17
[   13.154613] ACPI: PCI interrupt for device 0000:00:14.6 disabled
[   13.157599] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
[   13.160468] loop: module loaded
[   13.163239] nbd: registered device at major 43
[   13.166448] ACPI: PCI Interrupt 0000:02:04.3[B] -> GSI 21 (level, low) -> IRQ 21
[   13.169287] tg3.c:v3.81 (September 5, 2007)
[   13.172048] ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 23 (level, low) -> IRQ 23
[   13.205300] eth0: Tigon3 [partno(BCM95788A50) rev 3003 PHY(5705)] (PCI:33MHz:32-bit) 10/100/1000Base-T Ethernet 00:0f:b0:f7:d7:da
[   13.211212] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[0] TSOcap[1]
[   13.214274] eth0: dma_rwctrl[763f0000] dma_mask[32-bit]
[   13.217410] PPP generic driver version 2.4.2
[   13.220572] PPP Deflate Compression module registered
[   13.223713] PPP BSD Compression module registered
[   13.226905] PPP MPPE Compression module registered
[   13.230100] NET: Registered protocol family 24
[   13.233358] tun: Universal TUN/TAP device driver, 1.6
[   13.236579] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   13.239910] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   13.243263] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[   13.246732] ATIIXP: IDE controller at PCI slot 0000:00:14.1
[   13.250243] ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 16
[   13.253834] ATIIXP: chipset revision 0
[   13.257379] ATIIXP: not 100% native mode: will probe irqs later
[   13.260940]     ide0: BM-DMA at 0x3010-0x3017, BIOS settings: hda:DMA, hdb:pio
[   13.264556]     ide1: BM-DMA at 0x3018-0x301f, BIOS settings: hdc:DMA, hdd:pio
[   13.268105] Probing IDE interface ide0...
[   13.310299] Marking TSC unstable due to TSC halts in C3
[   13.313839] Time: acpi_pm clocksource has been installed.
[   13.537401] hda: FUJITSU MHV2080AH, ATA DISK drive
[   14.156707] hda: selected mode 0x45
[   14.161267] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   14.164958] Probing IDE interface ide1...
[   14.835491] hdc: MATSHITAUJ-840D, ATAPI CD/DVD-ROM drive
[   15.144888] hdc: selected mode 0x22
[   15.145283] ide1 at 0x170-0x177,0x376 on irq 15
[   15.149147] hda: max request size: 128KiB
[   15.152842] hda: 156301488 sectors (80026 MB) w/8192KiB Cache, CHS=65535/16/63, UDMA(100)
[   15.172295] hda: cache flushes supported
[   15.176140]  hda: hda1 hda2 < hda5 hda6 hda7 hda8 >
[   15.226759] hdc: ATAPI 24X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, (U)DMA
[   15.230670] Uniform CD-ROM driver Revision: 3.20
[   15.238389] ACPI: PCI Interrupt 0000:02:04.2[C] -> GSI 21 (level, low) -> IRQ 21
[   15.292387] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21]  MMIO=[d0013000-d00137ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[   15.300272] ieee1394: raw1394: /dev/raw1394 device initialized
[   15.304211] usbmon: debugfs is not available
[   15.308141] ACPI: PCI Interrupt 0000:00:13.2[A] -> GSI 19 (level, low) -> IRQ 19
[   15.312464] ehci_hcd 0000:00:13.2: EHCI Host Controller
[   15.316490] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 1
[   15.320499] ehci_hcd 0000:00:13.2: irq 19, io mem 0xd0802000
[   15.324409] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   15.328456] usb usb1: configuration #1 chosen from 1 choice
[   15.332364] hub 1-0:1.0: USB hub found
[   15.336120] hub 1-0:1.0: 8 ports detected
[   15.440253] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[   15.440287] ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 19 (level, low) -> IRQ 19
[   15.444097] ohci_hcd 0000:00:13.0: OHCI Host Controller
[   15.447843] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
[   15.451508] ohci_hcd 0000:00:13.0: irq 19, io mem 0xd0800000
[   15.510167] usb usb2: configuration #1 chosen from 1 choice
[   15.513848] hub 2-0:1.0: USB hub found
[   15.517482] hub 2-0:1.0: 4 ports detected
[   15.621955] ACPI: PCI Interrupt 0000:00:13.1[A] -> GSI 19 (level, low) -> IRQ 19
[   15.625776] ohci_hcd 0000:00:13.1: OHCI Host Controller
[   15.629584] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
[   15.633294] ohci_hcd 0000:00:13.1: irq 19, io mem 0xd0801000
[   15.691925] usb usb3: configuration #1 chosen from 1 choice
[   15.695536] hub 3-0:1.0: USB hub found
[   15.699065] hub 3-0:1.0: 4 ports detected
[   15.888474] usb 1-5: new high speed USB device using ehci_hcd and address 3
[   16.008562] usb 1-5: configuration #1 chosen from 1 choice
[   16.623488] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023f99292d1c0c]
[   16.693280] usb 3-1: new full speed USB device using ohci_hcd and address 2
[   16.831344] usb 3-1: configuration #1 chosen from 1 choice
[   17.051747] usb 3-3: new low speed USB device using ohci_hcd and address 3
[   17.196856] usb 3-3: configuration #1 chosen from 1 choice
[   17.200917] usbcore: registered new interface driver usblp
[   17.204490] Initializing USB Mass Storage driver...
[   17.208103] scsi0 : SCSI emulation for USB Mass Storage devices
[   17.211724] usb-storage: device found at 3
[   17.211726] usb-storage: waiting for device to settle before scanning
[   17.211738] usbcore: registered new interface driver usb-storage
[   17.215347] USB Mass Storage support registered.
[   17.218957] PNP: PS/2 Controller [PNP0303:C1C4,PNP0f13:C1C5] at 0x60,0x64 irq 1,12
[   17.224328] i8042.c: Detected active multiplexing controller, rev 1.1.
[   17.228721] serio: i8042 KBD port at 0x60,0x64 irq 1
[   17.232352] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[   17.235937] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[   17.239431] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[   17.242781] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[   17.246015] mice: PS/2 mouse device common for all mice
[   17.271121] input: AT Translated Set 2 keyboard as /class/input/input4
[   17.285243] input: PC Speaker as /class/input/input5
[   17.895506] Synaptics Touchpad, model: 1, fw: 6.2, id: 0x1a0b1, caps: 0xa04713/0x200000
[   17.937983] input: SynPS/2 Synaptics TouchPad as /class/input/input6
[   17.944056] I2O subsystem v1.325
[   17.947253] i2o: max drivers = 8
[   17.950490] I2O Configuration OSM v1.323
[   17.953630] I2O Bus Adapter OSM v1.317
[   17.956741] I2O Block Device OSM v1.325
[   17.959898] I2O SCSI Peripheral OSM v1.316
[   17.962976] I2O ProcFS OSM v1.316
[   17.965987] i2c /dev entries driver
[   17.969229] sc520_wdt: WDT driver for SC520 initialised. timeout=30 sec (nowayout=0)
[   17.972309] sc1200wdt: build 20020303
[   17.975349] sc1200wdt: io parameter must be specified
[   17.978392] SoftDog: cannot register miscdev on minor=130 (err=-16)
[   17.981531] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
[   17.984701] Bluetooth: HCI USB driver ver 2.9
[   17.987836] usbcore: registered new interface driver hci_usb
[   17.990975] Bluetooth: Virtual HCI driver ver 1.2
[   17.994123] Bluetooth: HCI UART driver ver 2.2
[   17.997217] Bluetooth: HCI H4 protocol initialized
[   18.000286] Bluetooth: HCI BCSP protocol initialized
[   18.003363] Bluetooth: Broadcom Blutonium firmware driver ver 1.1
[   18.006459] usbcore: registered new interface driver bcm203x
[   18.009526] Bluetooth: Digianswer Bluetooth USB driver ver 0.8
[   18.012604] usbcore: registered new interface driver bpa10x
[   18.015653] Bluetooth: BlueFRITZ! USB driver ver 1.1
[   18.018700] usbcore: registered new interface driver bfusb
[   18.021734] EDAC MC: Ver: 2.1.0 Sep 22 2007
[   18.024919] sdhci: Secure Digital Host Controller Interface driver
[   18.027967] sdhci: Copyright(c) Pierre Ossman
[   18.031000] sdhci: SDHCI controller found at 0000:02:04.4 [104c:8034] (rev 0)
[   18.034075] ACPI: PCI Interrupt 0000:02:04.4[C] -> GSI 21 (level, low) -> IRQ 21
[   18.037726] mmc0: SDHCI at 0xd001a000 irq 21 DMA
[   18.041010] mmc1: SDHCI at 0xd001b000 irq 21 DMA
[   18.044221] mmc2: SDHCI at 0xd001c000 irq 21 DMA
[   18.047131] wbsd: Winbond W83L51xD SD/MMC card interface driver
[   18.050044] wbsd: Copyright(c) Pierre Ossman
[   18.053058] usbcore: registered new interface driver hiddev
[   18.063575] input: Logitech USB Receiver as /class/input/input7
[   18.066728] input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:13.1-3
[   18.069901] usbcore: registered new interface driver usbhid
[   18.073045] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   18.076250] Advanced Linux Sound Architecture Driver Version 1.0.14 (Fri Jul 20 09:12:58 2007 UTC).
[   18.079650] ACPI: PCI Interrupt 0000:00:14.5[B] -> GSI 17 (level, low) -> IRQ 17
[   18.092716] ACPI: PCI Interrupt 0000:00:14.6[B] -> GSI 17 (level, low) -> IRQ 17
[   18.198081] MC'97 0 converters and GPIO not ready (0x1)
[   18.201829] ALSA device list:
[   18.204961]   #0: ATI IXP rev 2 with unknown codec at 0xd0804000, irq 17
[   18.208194]   #1: ATI IXP Modem rev 2 at 0xd0805000, irq 17
[   18.211478] oprofile: using NMI interrupt.
[   18.214756] Netfilter messages via NETLINK v0.30.
[   18.218053] ip_tables: (C) 2000-2006 Netfilter Core Team
[   18.221387] arp_tables: (C) 2002 David S. Miller
[   18.224658] TCP cubic registered
[   18.227867] NET: Registered protocol family 1
[   18.231121] NET: Registered protocol family 10
[   18.234321] lo: Disabled Privacy Extensions
[   18.237451] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   18.240520] IPv6 over IPv4 tunneling driver
[   18.243620] sit0: Disabled Privacy Extensions
[   18.246710] NET: Registered protocol family 17
[   18.249742] Bluetooth: L2CAP ver 2.8
[   18.252770] Bluetooth: L2CAP socket layer initialized
[   18.255824] Bluetooth: SCO (Voice Link) ver 0.5
[   18.258861] Bluetooth: SCO socket layer initialized
[   18.261876] Bluetooth: RFCOMM socket layer initialized
[   18.264865] Bluetooth: RFCOMM TTY layer initialized
[   18.267795] Bluetooth: RFCOMM ver 1.8
[   18.270673] Bluetooth: BNEP (Ethernet Emulation) ver 1.2
[   18.273559] Bluetooth: BNEP filters: protocol multicast
[   18.276425] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   18.279325] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[   18.282216] All bugs added by David S. Miller <davem@redhat.com>
[   18.285124] ieee80211: 802.11 data/management/control stack, git-1.1.13
[   18.288006] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[   18.290927] ieee80211_crypt: registered algorithm 'NULL'
[   18.290929] ieee80211_crypt: registered algorithm 'WEP'
[   18.290930] ieee80211_crypt: registered algorithm 'CCMP'
[   18.290932] ieee80211_crypt: registered algorithm 'TKIP'
[   18.290956] powernow-k8: Found 1 AMD Turion(tm) 64 Mobile ML-40                  processors (1 cpu cores) (version 2.00.00)
[   18.296338] powernow-k8:    0 : fid 0xe (2200 MHz), vid 0x4
[   18.299463] powernow-k8:    1 : fid 0xc (2000 MHz), vid 0x6
[   18.302522] powernow-k8:    2 : fid 0xa (1800 MHz), vid 0x8
[   18.305531] powernow-k8:    3 : fid 0x8 (1600 MHz), vid 0xa
[   18.308487] powernow-k8:    4 : fid 0x0 (800 MHz), vid 0x16
[   18.311438] powernow-k8: ph2 null fid transition 0xe
[   18.314443] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[   18.331684] EXT3-fs: INFO: recovery required on readonly filesystem.
[   18.334541] EXT3-fs: write access will be enabled during recovery.
[   18.607940] kjournald starting.  Commit interval 5 seconds
[   18.610726] EXT3-fs: recovery complete.
[   18.615148] EXT3-fs: mounted filesystem with ordered data mode.
[   18.617951] VFS: Mounted root (ext3 filesystem) readonly.
[   18.620755] Freeing unused kernel memory: 236k freed
[   22.907511] scsi 0:0:0:0: Direct-Access     ST350064 1A               3.AA PQ: 0 ANSI: 0
[   22.908606] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
[   22.909610] sd 0:0:0:0: [sda] Write Protect is off
[   22.909613] sd 0:0:0:0: [sda] Mode Sense: 10 00 00 00
[   22.909616] sd 0:0:0:0: [sda] Assuming drive cache: write through
[   22.910474] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
[   22.911478] sd 0:0:0:0: [sda] Write Protect is off
[   22.911480] sd 0:0:0:0: [sda] Mode Sense: 10 00 00 00
[   22.911482] sd 0:0:0:0: [sda] Assuming drive cache: write through
[   22.911486]  sda:<6>EXT3 FS on hda7, internal journal
[   30.882062]  sda1 sda2 sda3 sda4 < sda5 sda6 >
[   30.940469] sd 0:0:0:0: [sda] Attached SCSI disk
[   30.940510] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   30.940686] usb-storage: device scan complete
[   36.775333] kjournald starting.  Commit interval 5 seconds
[   36.775653] EXT3 FS on hda8, internal journal
[   36.775657] EXT3-fs: mounted filesystem with ordered data mode.
[   36.824492] NTFS volume version 3.1.
[   36.933197] Adding 1791208k swap on /dev/hda6.  Priority:-1 extents:1 across:1791208k
[   49.724679] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   51.523363] tg3: eth0: Link is up at 100 Mbps, full duplex.
[   51.523367] tg3: eth0: Flow control is on for TX and on for RX.
[   51.524039] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   59.696255] APIC error on CPU0: 00(40)
[   61.626395] eth0: no IPv6 routers present
[   85.011221] [drm] Initialized drm 1.1.0 20060810
[   88.131615] ACPI: PCI Interrupt 0000:01:05.0[A] -> GSI 17 (level, low) -> IRQ 17
[   88.133400] [drm] Initialized radeon 1.28.0 20060524 on minor 0
[  311.178972] APIC error on CPU0: 40(40)
[  408.903659] APIC error on CPU0: 40(40)
[  636.175687] APIC error on CPU0: 40(40)

--Boundary-00=_gfK9GHzN0ooP5JF
Content-Type: text/plain;
  charset="utf-8";
  name="lspci.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lspci.txt"

00:00.0 Host bridge: ATI Technologies Inc RS480 Host Bridge (rev 01)
00:01.0 PCI bridge: ATI Technologies Inc RS480 PCI Bridge
00:04.0 PCI bridge: ATI Technologies Inc RS480 PCI Bridge
00:05.0 PCI bridge: ATI Technologies Inc Unknown device 5a37
00:13.0 USB Controller: ATI Technologies Inc IXP SB400 USB Host Controller
00:13.1 USB Controller: ATI Technologies Inc IXP SB400 USB Host Controller
00:13.2 USB Controller: ATI Technologies Inc IXP SB400 USB2 Host Controller
00:14.0 SMBus: ATI Technologies Inc IXP SB400 SMBus Controller (rev 11)
00:14.1 IDE interface: ATI Technologies Inc Standard Dual Channel PCI IDE Controller ATI
00:14.3 ISA bridge: ATI Technologies Inc IXP SB400 PCI-ISA Bridge
00:14.4 PCI bridge: ATI Technologies Inc IXP SB400 PCI-PCI Bridge
00:14.5 Multimedia audio controller: ATI Technologies Inc IXP SB400 AC'97 Audio Controller (rev 02)
00:14.6 Modem: ATI Technologies Inc ATI SB400 - AC'97 Modem Controller (rev 02)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
01:05.0 VGA compatible controller: ATI Technologies Inc ATI Radeon XPRESS 200M 5955 (PCIE)
02:01.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5788 Gigabit Ethernet (rev 03)
02:02.0 Network controller: Broadcom Corporation BCM4318 [AirForce One 54g] 802.11g Wireless LAN Controller (rev 02)
02:04.0 CardBus bridge: Texas Instruments PCIxx21/x515 Cardbus Controller
02:04.2 FireWire (IEEE 1394): Texas Instruments OHCI Compliant IEEE 1394 Host Controller
02:04.3 Mass storage controller: Texas Instruments PCIxx21 Integrated FlashMedia Controller
02:04.4 Generic system peripheral [0805]: Texas Instruments PCI6411, PCI6421, PCI6611, PCI6621, PCI7411, PCI7421, PCI7611, PCI7621 Secure Digital (SD) Controller

--Boundary-00=_gfK9GHzN0ooP5JF--
