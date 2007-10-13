Return-Path: <linux-kernel-owner+w=401wt.eu-S1760861AbXJMJaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760861AbXJMJaF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 05:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbXJMJ3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 05:29:52 -0400
Received: from maxwell.spina.si ([193.77.104.223]:61114 "EHLO maxwell.spina.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215AbXJMJ3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 05:29:47 -0400
Message-ID: <47109008.5090405@kanardia.eu>
Date: Sat, 13 Oct 2007 11:29:44 +0200
From: Rok Markovic <kernel@kanardia.eu>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rt1 lockup after loading HAL deamon
References: <470F27DA.9020307@kanardia.eu> <20071012083551.GA17937@elte.hu> <470FB4F4.60707@kanardia.eu> <20071012175831.GA27420@elte.hu> <470FD96A.8040505@kanardia.eu> <20071013055922.GB26370@elte.hu>
In-Reply-To: <20071013055922.GB26370@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------090408030904070103000709"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090408030904070103000709
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi

I have recompiled kernel with OPROFILE disabled. I am sending in
attachment /proc/interrupts (i ran it 3 times with 2 sec delay) and
netconsole log. Lockup in the lock is software made with ./lockup.
The kernel still locks 4-5minutes after boot without any further
messages (waited more than 2 minutes). Any ideas?


Rok


Ingo Molnar wrote:
> could you disable CONFIG_OPROFILE? Maybe it interferes with the NMI 
> watchdog?
> 
> how does /proc/interrupts look like shortly after bootup? Does a simple 
> "intentional lockup" piece of code, which provokes a hard lockup from 
> user-space, get properly zapped by the NMI watchdog (within a minute or 
> so):
> 
> the NMI watchdog should produce a console message similar to:
> 
>  BUG: NMI Watchdog detected LOCKUP on CPU0, eip bff12345, registers:
>  ...
> 
> ( if you test ./lockup and get the message properly then i'd suggest a 
>   new reboot - i think we inhibit further console output after an NMI 
>   printout. )
> 
> 	Ingo
> 
> 



--------------090408030904070103000709
Content-Type: text/x-log;
 name="interrupts.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="interrupts.log"

           CPU0       CPU1       
  0:        151          0   IO-APIC-edge      timer
  1:        206          0   IO-APIC-edge      i8042
  5:          0          0   IO-APIC-edge      parport0
  6:          3          0   IO-APIC-edge      floppy
  8:          1          0   IO-APIC-edge      rtc
  9:          0          0   IO-APIC-fasteoi   acpi
 12:        102          0   IO-APIC-edge      i8042
 15:         24         84   IO-APIC-edge      ide1
 19:          3          0   IO-APIC-fasteoi   bttv0
 20:       8873          0   IO-APIC-fasteoi   sata_via
 21:      11741          0   IO-APIC-fasteoi   uhci_hcd:usb1, uhci_hcd:usb2, uhci_hcd:usb3, uhci_hcd:usb4, ehci_hcd:usb5
 22:          0          0   IO-APIC-fasteoi   VIA8237
 23:        380          0   IO-APIC-fasteoi   eth0
NMI:        253        194 
LOC:      61512      64324 
ERR:          0
           CPU0       CPU1       
  0:        151          0   IO-APIC-edge      timer
  1:        286          0   IO-APIC-edge      i8042
  5:          0          0   IO-APIC-edge      parport0
  6:          3          0   IO-APIC-edge      floppy
  8:          1          0   IO-APIC-edge      rtc
  9:          0          0   IO-APIC-fasteoi   acpi
 12:        102          0   IO-APIC-edge      i8042
 15:         24        120   IO-APIC-edge      ide1
 19:          5          0   IO-APIC-fasteoi   bttv0
 20:       8879          0   IO-APIC-fasteoi   sata_via
 21:      12641          0   IO-APIC-fasteoi   uhci_hcd:usb1, uhci_hcd:usb2, uhci_hcd:usb3, uhci_hcd:usb4, ehci_hcd:usb5
 22:          0          0   IO-APIC-fasteoi   VIA8237
 23:        380          0   IO-APIC-fasteoi   eth0
NMI:        255        196 
LOC:      61993      64918 
ERR:          0
           CPU0       CPU1       
  0:        151          0   IO-APIC-edge      timer
  1:        292          0   IO-APIC-edge      i8042
  5:          0          0   IO-APIC-edge      parport0
  6:          3          0   IO-APIC-edge      floppy
  8:          1          0   IO-APIC-edge      rtc
  9:          0          0   IO-APIC-fasteoi   acpi
 12:        102          0   IO-APIC-edge      i8042
 15:         24        144   IO-APIC-edge      ide1
 19:         15          0   IO-APIC-fasteoi   bttv0
 20:       8879          0   IO-APIC-fasteoi   sata_via
 21:      13169          0   IO-APIC-fasteoi   uhci_hcd:usb1, uhci_hcd:usb2, uhci_hcd:usb3, uhci_hcd:usb4, ehci_hcd:usb5
 22:          0          0   IO-APIC-fasteoi   VIA8237
 23:        380          0   IO-APIC-fasteoi   eth0
NMI:        255        196 
LOC:      62237      65219 
ERR:          0


--------------090408030904070103000709
Content-Type: text/x-log;
 name="kernel.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kernel.log"

[  177.078312] 
[  190.712608] ide-cd: cmd 0x1e timed out
[  190.731121] hdc: lost interrupt
[    0.000000] Linux version 2.6.23-rt1 (root@rok.spina.si) (gcc version 4.1.2 20070925 (Red Hat 4.1.2-27)) #5 SMP PREEMPT RT Sat Oct 13 09:36:19 CEST 2007
[    0.000000] Command line: ro root=/dev/VolGroup00/LogVol01 netconsole=@192.168.10.124/eth0,9354@192.168.10.1/ nmi_watchdog=2
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003ffb0000 (usable)
[    0.000000]  BIOS-e820: 000000003ffb0000 - 000000003ffc0000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003ffc0000 - 000000003fff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fff0000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
[    0.000000] end_pfn_map = 1048576
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000F7C80, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT 3FFB0000, 0034 (r1 A M I  OEMRSDT  12000521 MSFT       97)
[    0.000000] ACPI: FACP 3FFB0200, 0084 (r2 A M I  OEMFACP  12000521 MSFT       97)
[    0.000000] ACPI: DSDT 3FFB0450, 3CF4 (r1  75D8P 75D8P004        4 INTL  2002026)
[    0.000000] ACPI: FACS 3FFC0000, 0040
[    0.000000] ACPI: APIC 3FFB0390, 0078 (r1 A M I  OEMAPIC  12000521 MSFT       97)
[    0.000000] ACPI: MCFG 3FFB0410, 003C (r1 A M I  OEMMCFG  12000521 MSFT       97)
[    0.000000] ACPI: OEMB 3FFC0040, 0046 (r1 A M I  AMI_OEM  12000521 MSFT       97)
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   262064
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfecc0000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 3, address 0xfecc0000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] Setting APIC routing to flat
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:bee00000)
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] PERCPU: Allocating 38072 bytes of per cpu data
[    0.000000] Real-Time Preemption Support (C) 2004-2007 Ingo Molnar
[    0.000000] Built 1 zonelists in Zone order.  Total pages: 245927
[    0.000000] Kernel command line: ro root=/dev/VolGroup00/LogVol01 netconsole=@192.168.10.124/eth0,9354@192.168.10.1/ nmi_watchdog=2
[    0.000000] netconsole: local port 6665
[    0.000000] netconsole: local IP 192.168.10.124
[    0.000000] netconsole: interface eth0
[    0.000000] netconsole: remote port 9354
[    0.000000] netconsole: remote IP 192.168.10.1
[    0.000000] netconsole: remote ethernet address ff:ff:ff:ff:ff:ff
[    0.000000] Initializing CPU#0
[    0.000000] WARNING: experimental RCU implementation.
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] TSC calibrated against PM_TIMER
[   24.186195] time.c: Detected 3139.771 MHz processor.
[   24.189104] Console: colour VGA+ 80x25
[   24.189109] console [tty0] enabled
[   24.199477] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[   24.199738] ... MAX_LOCKDEP_SUBCLASSES:      8
[   24.199896] ... MAX_LOCK_DEPTH:             30
[   24.200054] ... MAX_LOCKDEP_KEYS:         2048
[   24.200224] ... CLASSHASH_SIZE:           1024
[   24.200382] ... MAX_LOCKDEP_ENTRIES:     16384
[   24.200540] ... MAX_LOCKDEP_CHAINS:      32768
[   24.200697] ... CHAINHASH_SIZE:          16384
[   24.200855]  memory used by lock dependency info: 2608 kB
[   24.201018]  per task-struct memory footprint: 1680 bytes
[   24.201872] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[   24.202620] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[   24.202885] Checking aperture...
[   24.240447] Memory: 977344k/1048256k available (3281k kernel code, 70048k reserved, 1787k data, 272k init)
[   24.301099] Calibrating delay using timer specific routine.. 6285.79 BogoMIPS (lpj=3142895)
[   24.301899] Mount-cache hash table entries: 256
[   24.304136] CPU: Trace cache: 12K uops, L1 D cache: 16K
[   24.304349] CPU: L2 cache: 2048K
[   24.304502] using mwait in idle threads.
[   24.304658] CPU: Physical Processor ID: 0
[   24.304813] CPU: Processor Core ID: 0
[   24.304978] CPU0: Thermal monitoring enabled (TM1)
[   24.305188] lockdep: not fixing up alternatives.
[   24.305350] ACPI: Core revision 20070126
[   24.334335] Using local APIC timer interrupts.
[   24.366341] Detected 13.082 MHz APIC timer.
[   24.369742] lockdep: not fixing up alternatives.
[   24.370164] Booting processor 1/2 APIC 0x1
[   25.027370] Initializing CPU#1
[   25.087749] Calibrating delay using timer specific routine.. 6279.44 BogoMIPS (lpj=3139722)
[   25.087767] CPU: Trace cache: 12K uops, L1 D cache: 16K
[   25.087772] CPU: L2 cache: 2048K
[   25.087777] CPU: Physical Processor ID: 0
[   25.087779] CPU: Processor Core ID: 0
[   25.087794] CPU1: Thermal monitoring enabled (TM1)
[   25.088309]               Intel(R) Pentium(R) 4 CPU 3.00GHz stepping 03
[   24.442078] checking TSC synchronization [CPU#0 -> CPU#1]:
[   24.463713] Measured 2029973108 cycles TSC warp between CPUs, turning off TSC clock.
[   24.463978] Marking TSC unstable due to check_tsc_sync_source failed
[   24.464329] Brought up 2 CPUs
[   24.464700] testing NMI watchdog ... OK.
[   24.487943] NET: Registered protocol family 16
[   24.489623] ACPI: bus type pci registered
[   24.490404] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
[   24.490591] PCI: Not using MMCONFIG.
[   24.490748] PCI: Using configuration type 1
[   24.539703] ACPI: Interpreter enabled
[   24.539864] ACPI: (supports S0 S1 S3 S5)
[   24.540361] ACPI: Using IOAPIC for interrupt routing
[   24.590866] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   24.663431] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[   24.664721] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[   24.665921] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 10 11 12 14 15)
[   24.667057] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[   24.668229] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   24.669575] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   24.670914] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   24.672249] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[   24.673793] ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] -  C2, should be B5 [20070126]
[   24.674174] Linux Plug and Play Support v0.97 (c) Adam Belay
[   24.674580] pnp: PnP ACPI init
[   24.674800] ACPI: bus type pnp registered
[   24.695023] pnp: PnP ACPI: found 14 devices
[   24.695186] ACPI: ACPI bus type pnp unregistered
[   25.343063] SCSI subsystem initialized
[   25.344849] PCI: Using ACPI for IRQ routing
[   25.345008] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   24.708172] Bluetooth: Core ver 2.11
[   24.708835] NET: Registered protocol family 31
[   24.708995] Bluetooth: HCI device and connection manager initialized
[   24.709220] Bluetooth: HCI socket layer initialized
[   24.709454] PCI-GART: No AMD northbridge found.
[   24.709701] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[   24.710059] hpet0: 3 32-bit timers, 14318180 Hz
[   25.366130] pnp: 00:08: iomem range 0xfec00000-0xfec00fff has been reserved
[   25.366333] pnp: 00:08: iomem range 0xfee00000-0xfee00fff could not be reserved
[   25.366633] pnp: 00:0c: iomem range 0xe0000000-0xefffffff has been reserved
[   25.366875] pnp: 00:0d: iomem range 0x0-0x9ffff could not be reserved
[   25.367048] pnp: 00:0d: iomem range 0xc0000-0xcffff has been reserved
[   25.367224] pnp: 00:0d: iomem range 0xe0000-0xfffff could not be reserved
[   25.367401] pnp: 00:0d: iomem range 0x100000-0x3fffffff could not be reserved
[   24.724173] PCI: Bridge: 0000:00:01.0
[   24.724329]   IO window: disabled.
[   24.724518]   MEM window: disabled.
[   24.724678]   PREFETCH window: disabled.
[   24.724840] PCI: Bridge: 0000:00:02.0
[   24.724993]   IO window: disabled.
[   24.725151]   MEM window: f1e00000-fbefffff
[   24.725312]   PREFETCH window: cff00000-dfefffff
[   24.725583] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 27 (level, low) -> IRQ 27
[   24.726063] NET: Registered protocol family 2
[   25.401081] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[   25.402799] TCP established hash table entries: 16384 (order: 9, 3014656 bytes)
[   25.408711] TCP bind hash table entries: 16384 (order: 9, 2883584 bytes)
[   25.413974] TCP: Hash tables configured (established 16384 bind 16384)
[   25.414252] TCP reno registered
[   24.781085] checking if image is initramfs... it is
[   25.148173] Freeing initrd memory: 3677k freed
[   25.808178] Initializing RT-Tester: OK
[   25.163168] Total HugeTLB memory allocated, 0
[   25.810569] VFS: Disk quotas dquot_6.5.1
[   25.810794] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   25.166431] io scheduler noop registered
[   25.166591] io scheduler anticipatory registered
[   25.168162] io scheduler deadline registered
[   25.168414] io scheduler cfq registered (default)
[   25.168600] PCI: VIA PCI bridge detected. Disabling DAC.
[   25.171419] PCI: Bypassing VIA 8237 APIC De-Assert Message
[   25.172765] assign_interrupt_mode Found MSI capability
[   25.174919] vga16fb: mapped to 0xffff8100000a0000
[   25.412953] Console: switching to colour frame buffer device 80x30
[   25.661618] fb0: VGA16 VGA frame buffer device
[   25.666028] input: Power Button (FF) as /devices/virtual/input/input0
[   25.669634] ACPI: Power Button (FF) [PWRF]
[   25.674184] input: Power Button (CM) as /devices/virtual/input/input1
[   25.678945] ACPI: Power Button (CM) [PWRB]
[   25.685820] ACPI: SSDT 3FFB4150, 02FC (r1    AMI   CPU1PM        1 INTL  2002026)
[   25.699680] ACPI Warning (tbutils-0217): Incorrect checksum in table [SSDT] -  AE, should be 57 [20070126]
[   25.716642] ACPI: SSDT 3FFB4450, 02FC (r1    AMI   CPU2PM        1 INTL  2002026)
[   25.737589] ACPI Exception (processor_core-0819): AE_NOT_FOUND, Processor Device is not present [20070126]
[   25.749800] ACPI Exception (processor_core-0819): AE_NOT_FOUND, Processor Device is not present [20070126]
[   25.885565] Real Time Clock Driver v1.12ac
[   25.902834] Linux agpgart interface v0.102
[   25.917872] Serial: 8250/16550 driver $Revision: 1.90 $ 16 ports, IRQ sharing enabled
[   25.951240] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   26.623010] 00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   25.996535] ACPI: PCI Interrupt 0000:00:09.0[A] -> GSI 17 (level, low) -> IRQ 17
[   26.683545] 0000:00:09.0: ttyS4 at I/O 0xd000 (irq = 17) is a 16550A
[   26.059824] 0000:00:09.0: ttyS5 at I/O 0xcc00 (irq = 17) is a 16550A
[   26.081265] 0000:00:09.0: ttyS6 at I/O 0xc480 (irq = 17) is a 16550A
[   26.102209] 0000:00:09.0: ttyS7 at I/O 0xc400 (irq = 17) is a 16550A
[   26.122730] 0000:00:09.0: ttyS8 at I/O 0xc080 (irq = 17) is a 16550A
[   26.143318] 0000:00:09.0: ttyS9 at I/O 0xc000 (irq = 17) is a 16550A
[   26.167947] RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
[   26.208394] loop: module loaded
[   26.227255] via-rhine.c:v1.10-LK1.4.3 2007-03-06 Written by Donald Becker
[   26.245954] ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 23 (level, low) -> IRQ 23
[   26.285233] eth0: VIA Rhine II at 0xfbfffc00, 00:13:8f:27:34:8c, IRQ 23.
[   26.305773] eth0: MII PHY found at address 1, status 0x786d advertising 05e1 Link 45e1.
[   26.343912] netconsole: device eth0 not up yet, forcing it
[   26.364229] eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
[   26.426981] netconsole: carrier detect appears untrustworthy, waiting 4 seconds
[   30.476904] console [netcon0] enabled
[   34.463786] netconsole: network logging started
[   34.466191] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[   34.466211] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[   34.467094] megasas: 00.00.03.10-rc5 Thu May 17 10:09:32 PDT 2007
[   34.469608] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[   34.472410] serio: i8042 KBD port at 0x60,0x64 irq 1
[   34.474939] serio: i8042 AUX port at 0x60,0x64 irq 12
[   34.478914] mice: PS/2 mouse device common for all mice
[   34.502813] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[   34.511006] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
[   34.512980] Advanced Linux Sound Architecture Driver Version 1.0.14 (Fri Jul 20 09:12:58 2007 UTC).
[   34.522966] ACPI: PCI Interrupt 0000:00:11.5[C] -> GSI 22 (level, low) -> IRQ 22
[   34.669507] logips2pp: Detected unknown logitech mouse model 127
[   35.045556] ALSA device list:
[   35.066790]   #0: VIA 8237 with ALC850 at 0xe400, irq 22
[   35.089932] TCP cubic registered
[   35.111455] Initializing XFRM netlink socket
[   35.132464] NET: Registered protocol family 1
[   35.787214] input: ImExPS/2 Logitech Explorer Mouse as /devices/platform/i8042/serio1/input/input3
[   35.195152] NET: Registered protocol family 17
[   35.870659] *****************************************************************************
[   35.264125] *                                                                           *
[   35.301890] *  REMINDER, the following debugging options are turned on in your .config: *
[   35.340547] *                                                                           *
[   35.340551] *        CONFIG_DEBUG_RT_MUTEXES                                            *
[   35.340620] *        CONFIG_DEBUG_SLAB                                                  *
[   35.340624] *        CONFIG_LOCKDEP                                                     *
[   35.340627] *                                                                           *
[   35.340629] *  they may increase runtime overhead and latencies.                        *
[   35.340632] *                                                                           *
[   35.340635] *****************************************************************************
[   35.340640] Freeing unused kernel memory: 272k freed
[   36.082628] usbcore: registered new interface driver usbfs
[   36.095018] usbcore: registered new interface driver hub
[   36.107068] usbcore: registered new device driver usb
[   36.137452] USB Universal Host Controller Interface driver v3.0
[   36.150123] ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 21 (level, low) -> IRQ 21
[   36.175876] uhci_hcd 0000:00:10.0: UHCI Host Controller
[   36.191751] uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 1
[   36.866368] uhci_hcd 0000:00:10.0: irq 21, io base 0x0000ec00
[   36.883947] usb usb1: configuration #1 chosen from 1 choice
[   36.899234] hub 1-0:1.0: USB hub found
[   36.268595] hub 1-0:1.0: 2 ports detected
[   37.042790] ACPI: PCI Interrupt 0000:00:10.1[A] -> GSI 21 (level, low) -> IRQ 21
[   37.073551] uhci_hcd 0000:00:10.1: UHCI Host Controller
[   37.089768] uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 2
[   36.476214] uhci_hcd 0000:00:10.1: irq 21, io base 0x0000e080
[   36.495231] usb usb2: configuration #1 chosen from 1 choice
[   37.159884] hub 2-0:1.0: USB hub found
[   37.178369] hub 2-0:1.0: 2 ports detected
[   37.248589] usb 1-1: new full speed USB device using uhci_hcd and address 2
[   37.302584] ACPI: PCI Interrupt 0000:00:10.2[B] -> GSI 21 (level, low) -> IRQ 21
[   36.695635] uhci_hcd 0000:00:10.2: UHCI Host Controller
[   36.716955] uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 3
[   36.758096] uhci_hcd 0000:00:10.2: irq 21, io base 0x0000e000
[   36.780278] usb usb3: configuration #1 chosen from 1 choice
[   36.801141] hub 3-0:1.0: USB hub found
[   37.449193] usb 1-1: configuration #1 chosen from 1 choice
[   37.488794] hub 3-0:1.0: 2 ports detected
[   36.964412] ACPI: PCI Interrupt 0000:00:10.3[B] -> GSI 21 (level, low) -> IRQ 21
[   37.005822] uhci_hcd 0000:00:10.3: UHCI Host Controller
[   37.027185] uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 4
[   37.069661] uhci_hcd 0000:00:10.3: irq 21, io base 0x0000dc00
[   37.091902] usb usb4: configuration #1 chosen from 1 choice
[   37.113286] hub 4-0:1.0: USB hub found
[   37.134395] hub 4-0:1.0: 2 ports detected
[   37.311890] ACPI: PCI Interrupt 0000:00:10.4[C] -> GSI 21 (level, low) -> IRQ 21
[   37.352668] ehci_hcd 0000:00:10.4: EHCI Host Controller
[   37.373117] ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 5
[   37.412736] ehci_hcd 0000:00:10.4: irq 21, io mem 0xfbfff800
[   37.432823] ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   37.474395] usb usb5: configuration #1 chosen from 1 choice
[   37.494798] hub 5-0:1.0: USB hub found
[   37.515105] hub 5-0:1.0: 8 ports detected
[   37.641177] usb 1-1: USB disconnect, address 2
[   37.741279] ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 20 (level, low) -> IRQ 20
[   37.778751] sata_via 0000:00:0f.0: routed to hard irq line 7
[   38.444787] scsi0 : sata_via
[   37.817555] scsi1 : sata_via
[   37.835771] ata1: SATA max UDMA/133 cmd 0x000000000001d880 ctl 0x000000000001d802 bmdma 0x000000000001d080 irq 20
[   37.872525] ata2: SATA max UDMA/133 cmd 0x000000000001d480 ctl 0x000000000001d402 bmdma 0x000000000001d088 irq 20
[   38.116771] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   38.847087] usb 5-7: new high speed USB device using ehci_hcd and address 3
[   38.957404] ata1.00: ATA-6: WDC WD2000JD-00KLB0, 08.05J08, max UDMA/100
[   38.331116] ata1.00: 390721968 sectors, multi 16: LBA48 
[   38.987230] usb 5-7: configuration #1 chosen from 1 choice
[   39.020413] ata1.00: configured for UDMA/100
[   39.197990] usb 1-1: new full speed USB device using uhci_hcd and address 3
[   38.593642] ata2: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
[   38.637311] scsi 0:0:0:0: Direct-Access     ATA      WDC WD2000JD-00K 08.0 PQ: 0 ANSI: 5
[   38.677306] sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
[   38.697331] sd 0:0:0:0: [sda] Write Protect is off
[   38.717766] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   39.389268] usb 1-1: configuration #1 chosen from 1 choice
[   38.782598] sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
[   38.803899] sd 0:0:0:0: [sda] Write Protect is off
[   38.824455] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   38.866034]  sda: sda1 sda2 sda3
[   38.904125] sd 0:0:0:0: [sda] Attached SCSI disk
[   41.503094] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   41.521962] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[   41.610373] Initializing USB Mass Storage driver...
[   41.629652] scsi2 : SCSI emulation for USB Mass Storage devices
[   42.294397] usbcore: registered new interface driver usb-storage
[   41.665966] USB Mass Storage support registered.
[   47.295655] scsi 2:0:0:0: Direct-Access     Generic  USB Storage-CFC  I19A PQ: 0 ANSI: 0 CCS
[   46.699811] sd 2:0:0:0: [sdb] Attached SCSI removable disk
[   46.718586] scsi 2:0:0:1: Direct-Access     Generic  USB Storage-SDC  I19A PQ: 0 ANSI: 0 CCS
[   46.755166] sd 2:0:0:1: [sdc] 494080 512-byte hardware sectors (253 MB)
[   46.773791] sd 2:0:0:1: [sdc] Write Protect is off
[   46.791483] sd 2:0:0:1: [sdc] Assuming drive cache: write through
[   46.815888] sd 2:0:0:1: [sdc] 494080 512-byte hardware sectors (253 MB)
[   46.833882] sd 2:0:0:1: [sdc] Write Protect is off
[   46.851125] sd 2:0:0:1: [sdc] Assuming drive cache: write through
[   46.868483]  sdc: sdc1
[   46.889825] sd 2:0:0:1: [sdc] Attached SCSI removable disk
[   46.909026] scsi 2:0:0:2: Direct-Access     Generic  USB Storage-SMC  I19A PQ: 0 ANSI: 0 CCS
[   46.948708] sd 2:0:0:2: [sdd] Attached SCSI removable disk
[   46.969266] scsi 2:0:0:3: Direct-Access     Generic  USB Storage-MSC  I19A PQ: 0 ANSI: 0 CCS
[   47.009862] sd 2:0:0:3: [sde] Attached SCSI removable disk
[   50.331658] kjournald starting.  Commit interval 5 seconds
[   50.979221] EXT3-fs: mounted filesystem with ordered data mode.
[  185.600900] hdc: lost interrupt
[  222.420462] stopped custom tracer.
[  221.774206] NMI show regs on CPU#0:
[  221.774210] apic_timer_irqs: 69292
[  221.774213] CPU 0:
[  221.774215] Modules linked in: nfsd exportfs lockd nfs_acl sunrpc w83627hf hwmon_vid rfcomm l2cap ipv6 floppy ide_cd cdrom tuner parport_pc parport i2c_viapro bttv video_buf ir_common compat_ioctl32 i2c_algo_bit btcx_risc tveeprom i2c_core hci_usb via82cxxx videodev v4l2_common v4l1_compat sg usb_storage generic ide_core ata_generic sata_via libata ehci_hcd ohci_hcd uhci_hcd usbcore
[  221.774257] Pid: 0, comm: swapper Not tainted 2.6.23-rt1 #5
[  221.774260] RIP: 0010:[<ffffffff8020a9a8>]  [<ffffffff8020a9a8>] mwait_idle+0x61/0x6b
[  221.774272] RSP: 0018:ffffffff80735f48  EFLAGS: 00000246
[  221.774275] RAX: 0000000000000000 RBX: ffffffff80735f48 RCX: 0000000000000000
[  221.774278] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff80697760
[  221.774281] RBP: ffffffff80735ee8 R08: 0000000000000001 R09: 0000000000000000
[  221.774284] R10: 0000000000000001 R11: 0000000000000002 R12: ffffffff8025bee6
[  221.774287] R13: ffffffff80735eb8 R14: 0000000000000046 R15: ffffffff80697760
[  221.774291] FS:  0000000000000000(0000) GS:ffffffff806f4280(0000) knlGS:0000000000000000
[  221.774295] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  221.774297] CR2: 00002ba31e3eb000 CR3: 000000003c159000 CR4: 00000000000006e0
[  221.774301] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  221.774304] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  221.774307] 
[  221.774308] Call Trace:
[  221.774312]  [<ffffffff8020a99f>] mwait_idle+0x58/0x6b
[  221.774318]  [<ffffffff8020a875>] cpu_idle+0x81/0xef
[  221.774327]  [<ffffffff8052d831>] rest_init+0x75/0x84
[  221.774380]  [<ffffffff8073ed05>] start_kernel+0x2d4/0x38f
[  221.774421]  [<ffffffff8073e111>] _sinittext+0x111/0x150
[  221.774452] 
[  221.774543] INFO: lockdep is turned off.
[  221.774582] ---------------------------
[  221.774585] | preempt count: 00000002 ]
[  221.774587] | 2-level deep critical section nesting:
[  221.774592] ----------------------------------------
[  221.774595] .. [<ffffffff8020a8b1>] .... cpu_idle+0xbd/0xef
[  221.774600] .....[<ffffffff8052d831>] ..   ( <= rest_init+0x75/0x84)
[  221.774605] .. [<ffffffff80530b0a>] .... __spin_lock+0x16/0x3e
[  221.774610] .....[<ffffffff8021eb18>] ..   ( <= irq_show_regs_callback+0x33/0x72)
[  221.774614] 
[  223.156787] NMI Watchdog detected LOCKUP on CPU 1
[  223.173795] CPU 1 
[  223.190714] Modules linked in: nfsd exportfs lockd nfs_acl sunrpc w83627hf hwmon_vid rfcomm l2cap ipv6 floppy ide_cd cdrom tuner parport_pc parport i2c_viapro bttv video_buf ir_common compat_ioctl32 i2c_algo_bit btcx_risc tveeprom i2c_core hci_usb via82cxxx videodev v4l2_common v4l1_compat sg usb_storage generic ide_core ata_generic sata_via libata ehci_hcd ohci_hcd uhci_hcd usbcore
[  223.286834] Pid: 3321, comm: lockup Not tainted 2.6.23-rt1 #5
[  223.304037] RIP: 0033:[<00000000004004ac>]  [<00000000004004ac>]
[  223.321411] RSP: 002b:00007fff0cff8870  EFLAGS: 00003017
[  223.338752] RAX: 0000000000000000 RBX: 00002b909dcc9bc0 RCX: 00002b909dd9be57
[  223.356230] RDX: 00007fff0cff8968 RSI: 00007fff0cff8958 RDI: 0000000000000003
[  223.374296] RBP: 00007fff0cff8870 R08: 00002b909e017270 R09: 00002b909dabc530
[  223.392575] R10: 0000000000000000 R11: 0000000000003202 R12: 0000000000000000
[  223.411437] R13: 00007fff0cff8950 R14: 0000000000000000 R15: 0000000000000000
[  223.430467] FS:  00002b909e01c6f0(0000) GS:ffff81003ff8e858(0000) knlGS:0000000000000000
[  223.468917] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  223.488993] CR2: 00002b909dcfb3d0 CR3: 0000000028022000 CR4: 00000000000006e0
[  223.509580] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  223.530658] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  223.551895] Process lockup (pid: 3321, threadinfo ffff810027602000, task ffff810033fdc940)
[  223.594978] 
[  223.616405] BUG: sleeping function called from invalid context lockup(3321) at kernel/rtmutex.c:637
[  223.660807] in_atomic():1 [00010000], irqs_disabled():1
[  223.683341] INFO: lockdep is turned off.
[  223.705476] irq event stamp: 7459
[  223.727818] hardirqs last  enabled at (7459): [<ffffffff8025d987>] trace_hardirqs_on+0xd/0xf
[  223.773266] hardirqs last disabled at (7458): [<ffffffff8025bee6>] trace_hardirqs_off+0xd/0xf
[  223.818723] softirqs last  enabled at (0): [<ffffffff8023a378>] copy_process+0x51c/0x174a
[  223.864754] softirqs last disabled at (0): [<0000000000000000>] 0x0
[  223.888433] 
[  223.888434] Call Trace:
[  223.934292]  <NMI>  [<ffffffff802345ed>] __might_sleep+0xed/0x132
[  223.957450]  [<ffffffff8053037b>] __rt_spin_lock+0x30/0x3f
[  223.980156]  [<ffffffff80530470>] rt_spin_lock+0x30/0x37
[  224.002566]  [<ffffffff80238ee5>] __wake_up+0x1c/0x5d
[  224.024723]  [<ffffffff8023cb6e>] wake_up_klogd+0x35/0x37
[  224.046449]  [<ffffffff80376564>] bust_spinlocks+0x28/0x34
[  224.068190]  [<ffffffff8020cf15>] oops_end+0x1d/0x77
[  224.089599]  [<ffffffff8020da9e>] die_nmi+0x5c/0x90
[  224.110581]  [<ffffffff8021ed78>] nmi_watchdog_tick+0x221/0x252
[  224.131308]  [<ffffffff8020d537>] default_do_nmi+0x53/0x1a6
[  224.151612]  [<ffffffff8021f04a>] do_nmi+0x4b/0x81
[  224.171488]  [<ffffffff80531d2f>] nmi+0x7f/0x80
[  224.191305]  <<EOE>> 
[  224.210762] INFO: lockdep is turned off.
[  224.229639] ---------------------------
[  224.248686] | preempt count: 00010000 ]
[  224.267138] | 0-level deep critical section nesting:
[  224.285213] ----------------------------------------
[  224.303156] 
 


--------------090408030904070103000709--
