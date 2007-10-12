Return-Path: <linux-kernel-owner+w=401wt.eu-S1758407AbXJLUcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758407AbXJLUcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 16:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759613AbXJLUc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 16:32:29 -0400
Received: from maxwell.spina.si ([193.77.104.223]:57712 "EHLO maxwell.spina.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759988AbXJLUcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 16:32:25 -0400
Message-ID: <470FD9D7.2070103@kanardia.eu>
Date: Fri, 12 Oct 2007 22:32:23 +0200
From: Rok Markovic <kernel@kanardia.eu>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rt1 lockup after loading HAL deamon
References: <470F27DA.9020307@kanardia.eu> <20071012083551.GA17937@elte.hu> <470FB4F4.60707@kanardia.eu> <20071012175831.GA27420@elte.hu> <470FD96A.8040505@kanardia.eu>
In-Reply-To: <470FD96A.8040505@kanardia.eu>
Content-Type: multipart/mixed;
 boundary="------------050502030908050408030704"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050502030908050408030704
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

I forgot attachment.

Rok

Rok Markovic wrote:
> Hi
> 
> I enabled netconsole but I am affraid that it won't help. In attachment
> I am sending complete log over netconsole. While I was trying to make
> everything, I got a lockup on linux-2.6.23-rc8, but I am not sure into
> this. But all lockups happend in VGA console mode. Any ideas.
> 
> Rok
> 
> 
> Ingo Molnar wrote:
>>> I tried to recompile with those options enabled, kernel and linux 
>>> boots and loads fine, but after few minutes (if i try to recompile 
>>> kernel in console) the system locks completely (hard reset) without 
>>> any messages. Is there anything I can do, maybe console on serial 
>>> port? My new config is atached.
>> yes, serial console (or netconsole) output would be useful, if you can 
>> solve that. Another way would be to boot with nmi_watchdog=2, do the 
>> kernel recompile in a VGA text console, and wait for the lockup to 
>> occur. Either you get some crash message to the text console 
>> immediately, or you should get the NMI watchdog print something within a 
>> minute or so. If neither happens you just get a blank hard lockup then 
>> the wedge is very deep ...
>>
>> (also make sure that the NMI counter in /proc/interrupts is increasing 
>> on all CPUs properly, with nmi_watchdog=2. If not all CPUs/cores are 
>> increasing their NMI counters once per second then the NMI watchdog wont 
>> be able to print out a stackdump.)
>>
>> 	Ingo


--------------050502030908050408030704
Content-Type: text/x-log;
 name="linux.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux.log"

[  859.950668] sd 2:0:0:1: [sdc] 494080 512-byte hardware sectors (253 MB)
[  859.951294] sd 2:0:0:1: [sdc] Write Protect is off
[  859.951313] sd 2:0:0:1: [sdc] Assuming drive cache: write through
[  860.618633] sd 2:0:0:1: [sdc] 494080 512-byte hardware sectors (253 MB)
[  860.619414] sd 2:0:0:1: [sdc] Write Protect is off
[  860.619433] sd 2:0:0:1: [sdc] Assuming drive cache: write through
[ 1007.878314] nfsd: last server has exited
[ 1007.926075] nfsd: unexporting all filesystems
[ 1324.899757] nfsd: last server has exited
[ 1324.952596] nfsd: unexporting all filesystems
[    0.000000] Linux version 2.6.23-rt1 (root@rok.spina.si) (gcc version 4.1.2 20070925 (Red Hat 4.1.2-27)) #4 SMP PREEMPT RT Fri Oct 12 22:07:05 CEST 2007
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
[    0.000000] PERCPU: Allocating 38456 bytes of per cpu data
[    0.000000] Real-Time Preemption Support (C) 2004-2007 Ingo Molnar
[    0.000000] Built 1 zonelists in Zone order.  Total pages: 245914
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
[   93.054085] time.c: Detected 3039.840 MHz processor.
[   93.057058] Console: colour VGA+ 80x25
[   93.057063] console [tty0] enabled
[   93.067620] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[   93.067886] ... MAX_LOCKDEP_SUBCLASSES:      8
[   93.068060] ... MAX_LOCK_DEPTH:             30
[   93.068221] ... MAX_LOCKDEP_KEYS:         2048
[   93.068381] ... CLASSHASH_SIZE:           1024
[   93.068542] ... MAX_LOCKDEP_ENTRIES:     16384
[   93.068703] ... MAX_LOCKDEP_CHAINS:      32768
[   93.068864] ... CHAINHASH_SIZE:          16384
[   93.069037]  memory used by lock dependency info: 2608 kB
[   93.069203]  per task-struct memory footprint: 1680 bytes
[   93.070085] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[   93.070831] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[   93.071115] Checking aperture...
[   93.109735] Memory: 977292k/1048256k available (3303k kernel code, 70100k reserved, 1806k data, 272k init)
[   93.170740] Calibrating delay using timer specific routine.. 6085.99 BogoMIPS (lpj=3042998)
[   93.171561] Mount-cache hash table entries: 256
[   93.173867] CPU: Trace cache: 12K uops, L1 D cache: 16K
[   93.174085] CPU: L2 cache: 2048K
[   93.174241] using mwait in idle threads.
[   93.174400] CPU: Physical Processor ID: 0
[   93.174558] CPU: Processor Core ID: 0
[   93.174740] CPU0: Thermal monitoring enabled (TM1)
[   93.174924] lockdep: not fixing up alternatives.
[   93.175088] ACPI: Core revision 20070126
[   93.199116] Using local APIC timer interrupts.
[   93.232100] Detected 12.665 MHz APIC timer.
[   93.234370] lockdep: not fixing up alternatives.
[   93.234606] Booting processor 1/2 APIC 0x1
[   93.911541] Initializing CPU#1
[   93.971169] Calibrating delay using timer specific routine.. 6079.30 BogoMIPS (lpj=3039650)
[   93.971186] CPU: Trace cache: 12K uops, L1 D cache: 16K
[   93.971190] CPU: L2 cache: 2048K
[   93.971195] CPU: Physical Processor ID: 0
[   93.971197] CPU: Processor Core ID: 0
[   93.971213] CPU1: Thermal monitoring enabled (TM1)
[   93.971736]               Intel(R) Pentium(R) 4 CPU 3.00GHz stepping 03
[   93.305728] checking TSC synchronization [CPU#0 -> CPU#1]:
[   93.327326] Measured 2029973100 cycles TSC warp between CPUs, turning off TSC clock.
[   93.327596] Marking TSC unstable due to check_tsc_sync_source failed
[   93.327838] Brought up 2 CPUs
[   93.328205] testing NMI watchdog ... OK.
[   93.349780] NET: Registered protocol family 16
[   93.350928] ACPI: bus type pci registered
[   93.351545] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
[   93.351718] PCI: Not using MMCONFIG.
[   93.351878] PCI: Using configuration type 1
[   94.054177] ACPI: Interpreter enabled
[   94.054338] ACPI: (supports S0 S1 S3 S5)
[   94.054779] ACPI: Using IOAPIC for interrupt routing
[   94.092159] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   93.480417] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[   93.481489] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[   93.482560] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 10 11 12 14 15)
[   93.483608] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[   93.484669] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   93.485904] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   93.487135] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   93.488381] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[   93.489748] ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] -  C2, should be B5 [20070126]
[   93.490132] Linux Plug and Play Support v0.97 (c) Adam Belay
[   93.490477] pnp: PnP ACPI init
[   93.490675] ACPI: bus type pnp registered
[   93.505890] pnp: PnP ACPI: found 14 devices
[   93.506052] ACPI: ACPI bus type pnp unregistered
[   93.507378] SCSI subsystem initialized
[   94.174860] PCI: Using ACPI for IRQ routing
[   94.175023] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   93.518470] Bluetooth: Core ver 2.11
[   93.519015] NET: Registered protocol family 31
[   93.519176] Bluetooth: HCI device and connection manager initialized
[   93.519351] Bluetooth: HCI socket layer initialized
[   93.519547] PCI-GART: No AMD northbridge found.
[   93.519810] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[   93.520171] hpet0: 3 32-bit timers, 14318180 Hz
[   94.196097] pnp: 00:08: iomem range 0xfec00000-0xfec00fff has been reserved
[   94.196278] pnp: 00:08: iomem range 0xfee00000-0xfee00fff could not be reserved
[   94.196570] pnp: 00:0c: iomem range 0xe0000000-0xefffffff has been reserved
[   94.196765] pnp: 00:0d: iomem range 0x0-0x9ffff could not be reserved
[   94.196968] pnp: 00:0d: iomem range 0xc0000-0xcffff has been reserved
[   94.197145] pnp: 00:0d: iomem range 0xe0000-0xfffff could not be reserved
[   94.197322] pnp: 00:0d: iomem range 0x100000-0x3fffffff could not be reserved
[   94.199602] PCI: Bridge: 0000:00:01.0
[   94.199759]   IO window: disabled.
[   94.199946]   MEM window: disabled.
[   94.200104]   PREFETCH window: disabled.
[   94.200266] PCI: Bridge: 0000:00:02.0
[   94.200422]   IO window: disabled.
[   94.200581]   MEM window: f1e00000-fbefffff
[   94.200743]   PREFETCH window: cff00000-dfefffff
[   94.200997] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 27 (level, low) -> IRQ 27
[   94.201433] NET: Registered protocol family 2
[   93.566824] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[   93.568047] TCP established hash table entries: 16384 (order: 9, 3014656 bytes)
[   93.571333] TCP bind hash table entries: 16384 (order: 9, 2883584 bytes)
[   93.574399] TCP: Hash tables configured (established 16384 bind 16384)
[   93.574583] TCP reno registered
[   94.253859] checking if image is initramfs... it is
[   94.602233] Freeing initrd memory: 3678k freed
[   93.946587] Initializing RT-Tester: OK
[   94.613377] Total HugeTLB memory allocated, 0
[   93.947903] VFS: Disk quotas dquot_6.5.1
[   93.948095] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   93.948952] io scheduler noop registered
[   93.949111] io scheduler anticipatory registered
[   93.950721] io scheduler deadline registered
[   93.950941] io scheduler cfq registered (default)
[   93.951124] PCI: VIA PCI bridge detected. Disabling DAC.
[   93.953240] PCI: Bypassing VIA 8237 APIC De-Assert Message
[   94.620330] assign_interrupt_mode Found MSI capability
[   94.621974] vga16fb: mapped to 0xffff8100000a0000
[   94.194240] Console: switching to colour frame buffer device 80x30
[   94.448623] fb0: VGA16 VGA frame buffer device
[   94.451839] input: Power Button (FF) as /devices/virtual/input/input0
[   94.455506] ACPI: Power Button (FF) [PWRF]
[   94.460014] input: Power Button (CM) as /devices/virtual/input/input1
[   94.464928] ACPI: Power Button (CM) [PWRB]
[   94.471509] ACPI: SSDT 3FFB4150, 02FC (r1    AMI   CPU1PM        1 INTL  2002026)
[   94.485419] ACPI Warning (tbutils-0217): Incorrect checksum in table [SSDT] -  AE, should be 57 [20070126]
[   94.502770] ACPI: SSDT 3FFB4450, 02FC (r1    AMI   CPU2PM        1 INTL  2002026)
[   94.524084] ACPI Exception (processor_core-0819): AE_NOT_FOUND, Processor Device is not present [20070126]
[   94.548896] ACPI Exception (processor_core-0819): AE_NOT_FOUND, Processor Device is not present [20070126]
[   95.323865] Real Time Clock Driver v1.12ac
[   95.340173] Linux agpgart interface v0.102
[   95.355492] Serial: 8250/16550 driver $Revision: 1.90 $ 16 ports, IRQ sharing enabled
[   94.723020] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   95.412021] 00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   94.765752] ACPI: PCI Interrupt 0000:00:09.0[A] -> GSI 17 (level, low) -> IRQ 17
[   94.807195] 0000:00:09.0: ttyS4 at I/O 0xd000 (irq = 17) is a 16550A
[   94.829200] 0000:00:09.0: ttyS5 at I/O 0xcc00 (irq = 17) is a 16550A
[   94.850764] 0000:00:09.0: ttyS6 at I/O 0xc480 (irq = 17) is a 16550A
[   94.871918] 0000:00:09.0: ttyS7 at I/O 0xc400 (irq = 17) is a 16550A
[   94.892656] 0000:00:09.0: ttyS8 at I/O 0xc080 (irq = 17) is a 16550A
[   94.912963] 0000:00:09.0: ttyS9 at I/O 0xc000 (irq = 17) is a 16550A
[   94.936470] RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
[   94.977026] loop: module loaded
[   94.996106] via-rhine.c:v1.10-LK1.4.3 2007-03-06 Written by Donald Becker
[   95.015180] ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 23 (level, low) -> IRQ 23
[   95.054240] eth0: VIA Rhine II at 0xfbfffc00, 00:13:8f:27:34:8c, IRQ 23.
[   95.075223] eth0: MII PHY found at address 1, status 0x786d advertising 05e1 Link 45e1.
[   95.113808] netconsole: device eth0 not up yet, forcing it
[   95.133982] eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
[   95.173815] netconsole: carrier detect appears untrustworthy, waiting 4 seconds
[   99.882109] console [netcon0] enabled
[  103.963986] netconsole: network logging started
[  103.317488] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[  103.355647] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[  103.375428] megasas: 00.00.03.10-rc5 Thu May 17 10:09:32 PDT 2007
[  104.061849] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[  103.436546] serio: i8042 KBD port at 0x60,0x64 irq 1
[  103.457648] serio: i8042 AUX port at 0x60,0x64 irq 12
[  104.145577] mice: PS/2 mouse device common for all mice
[  104.185846] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[  104.233042] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
[  104.277431] Advanced Linux Sound Architecture Driver Version 1.0.14 (Fri Jul 20 09:12:58 2007 UTC).
[  103.656495] ACPI: PCI Interrupt 0000:00:11.5[C] -> GSI 22 (level, low) -> IRQ 22
[  104.390010] logips2pp: Detected unknown logitech mouse model 127
[  104.878492] input: ImExPS/2 Logitech Explorer Mouse as /devices/platform/i8042/serio1/input/input3
[  104.224133] ALSA device list:
[  104.224137]   #0: VIA 8237 with ALC850 at 0xe400, irq 22
[  104.224904] oprofile: using NMI interrupt.
[  104.225258] TCP cubic registered
[  104.225261] Initializing XFRM netlink socket
[  104.225414] NET: Registered protocol family 1
[  104.225453] NET: Registered protocol family 17
[  105.072768] *****************************************************************************
[  104.444236] *                                                                           *
[  104.479459] *  REMINDER, the following debugging options are turned on in your .config: *
[  104.516370] *                                                                           *
[  104.516374] *        CONFIG_DEBUG_RT_MUTEXES                                            *
[  104.516377] *        CONFIG_DEBUG_SLAB                                                  *
[  104.516439] *        CONFIG_LOCKDEP                                                     *
[  104.516442] *                                                                           *
[  104.516445] *  they may increase runtime overhead and latencies.                        *
[  104.516448] *                                                                           *
[  104.516451] *****************************************************************************
[  104.516456] Freeing unused kernel memory: 272k freed
[  105.860996] usbcore: registered new interface driver usbfs
[  105.207493] usbcore: registered new interface driver hub
[  105.885904] usbcore: registered new device driver usb
[  105.248118] USB Universal Host Controller Interface driver v3.0
[  105.260987] ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 21 (level, low) -> IRQ 21
[  105.287330] uhci_hcd 0000:00:10.0: UHCI Host Controller
[  105.301786] uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 1
[  105.996693] uhci_hcd 0000:00:10.0: irq 21, io base 0x0000ec00
[  105.345857] usb usb1: configuration #1 chosen from 1 choice
[  105.360932] hub 1-0:1.0: USB hub found
[  105.376179] hub 1-0:1.0: 2 ports detected
[  105.491424] ACPI: PCI Interrupt 0000:00:10.1[A] -> GSI 21 (level, low) -> IRQ 21
[  105.522246] uhci_hcd 0000:00:10.1: UHCI Host Controller
[  105.538133] uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 2
[  105.570693] uhci_hcd 0000:00:10.1: irq 21, io base 0x0000e080
[  105.588798] usb usb2: configuration #1 chosen from 1 choice
[  105.606870] hub 2-0:1.0: USB hub found
[  105.625014] hub 2-0:1.0: 2 ports detected
[  105.696495] usb 1-1: new full speed USB device using uhci_hcd and address 2
[  105.743782] ACPI: PCI Interrupt 0000:00:10.2[B] -> GSI 21 (level, low) -> IRQ 21
[  106.448783] uhci_hcd 0000:00:10.2: UHCI Host Controller
[  105.803172] uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 3
[  105.843731] uhci_hcd 0000:00:10.2: irq 21, io base 0x0000e000
[  105.865161] usb usb3: configuration #1 chosen from 1 choice
[  105.885712] hub 3-0:1.0: USB hub found
[  106.561793] usb 1-1: configuration #1 chosen from 1 choice
[  105.926602] hub 3-0:1.0: 2 ports detected
[  106.047044] ACPI: PCI Interrupt 0000:00:10.3[B] -> GSI 21 (level, low) -> IRQ 21
[  106.088337] uhci_hcd 0000:00:10.3: UHCI Host Controller
[  106.109515] uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 4
[  106.151837] uhci_hcd 0000:00:10.3: irq 21, io base 0x0000dc00
[  106.839680] usb usb4: configuration #1 chosen from 1 choice
[  106.860932] hub 4-0:1.0: USB hub found
[  106.215926] hub 4-0:1.0: 2 ports detected
[  106.385272] ACPI: PCI Interrupt 0000:00:10.4[C] -> GSI 21 (level, low) -> IRQ 21
[  107.092451] ehci_hcd 0000:00:10.4: EHCI Host Controller
[  106.446848] ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 5
[  106.486922] ehci_hcd 0000:00:10.4: irq 21, io mem 0xfbfff800
[  106.507322] ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[  106.509190] usb usb5: configuration #1 chosen from 1 choice
[  106.509466] hub 5-0:1.0: USB hub found
[  106.509743] hub 5-0:1.0: 8 ports detected
[  107.347630] ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 20 (level, low) -> IRQ 20
[  106.719466] sata_via 0000:00:0f.0: routed to hard irq line 7
[  107.396271] usb 1-1: USB disconnect, address 2
[  106.758126] scsi0 : sata_via
[  106.776933] scsi1 : sata_via
[  106.794893] ata1: SATA max UDMA/133 cmd 0x000000000001d880 ctl 0x000000000001d802 bmdma 0x000000000001d080 irq 20
[  106.831248] ata2: SATA max UDMA/133 cmd 0x000000000001d480 ctl 0x000000000001d402 bmdma 0x000000000001d088 irq 20
[  107.735274] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  107.914894] usb 5-7: new high speed USB device using ehci_hcd and address 3
[  107.939191] ata1.00: ATA-6: WDC WD2000JD-00KLB0, 08.05J08, max UDMA/100
[  107.292919] ata1.00: 390721968 sectors, multi 16: LBA48 
[  107.297708] ata1.00: configured for UDMA/100
[  108.051557] usb 5-7: configuration #1 chosen from 1 choice
[  108.164235] ata2: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
[  108.193515] scsi 0:0:0:0: Direct-Access     ATA      WDC WD2000JD-00K 08.0 PQ: 0 ANSI: 5
[  107.564640] sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
[  108.249727] sd 0:0:0:0: [sda] Write Protect is off
[  108.268567] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  107.610897] usb 1-1: new full speed USB device using uhci_hcd and address 3
[  107.662082] sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
[  107.682620] sd 0:0:0:0: [sda] Write Protect is off
[  107.702581] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  107.742074]  sda: sda1 sda2 sda3
[  107.778210] sd 0:0:0:0: [sda] Attached SCSI disk
[  108.450239] usb 1-1: configuration #1 chosen from 1 choice
[  110.384304] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[  110.403216] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[  110.486685] Initializing USB Mass Storage driver...
[  110.505469] scsi2 : SCSI emulation for USB Mass Storage devices
[  111.190443] usbcore: registered new interface driver usb-storage
[  111.208830] USB Mass Storage support registered.
[  116.179103] scsi 2:0:0:0: Direct-Access     Generic  USB Storage-CFC  I19A PQ: 0 ANSI: 0 CCS
[  116.215949] sd 2:0:0:0: [sdb] Attached SCSI removable disk
[  115.568742] scsi 2:0:0:1: Direct-Access     Generic  USB Storage-SDC  I19A PQ: 0 ANSI: 0 CCS
[  115.605137] sd 2:0:0:1: [sdc] 494080 512-byte hardware sectors (253 MB)
[  115.624090] sd 2:0:0:1: [sdc] Write Protect is off
[  115.642178] sd 2:0:0:1: [sdc] Assuming drive cache: write through
[  115.661490] sd 2:0:0:1: [sdc] 494080 512-byte hardware sectors (253 MB)
[  115.680070] sd 2:0:0:1: [sdc] Write Protect is off
[  115.697845] sd 2:0:0:1: [sdc] Assuming drive cache: write through
[  115.715526]  sdc: sdc1
[  115.736600] sd 2:0:0:1: [sdc] Attached SCSI removable disk
[  115.755651] scsi 2:0:0:2: Direct-Access     Generic  USB Storage-SMC  I19A PQ: 0 ANSI: 0 CCS
[  116.460943] sd 2:0:0:2: [sdd] Attached SCSI removable disk
[  115.815152] scsi 2:0:0:3: Direct-Access     Generic  USB Storage-MSC  I19A PQ: 0 ANSI: 0 CCS
[  115.855240] sd 2:0:0:3: [sde] Attached SCSI removable disk
[  119.559608] kjournald starting.  Commit interval 5 seconds
[  118.893579] EXT3-fs: mounted filesystem with ordered data mode.

--------------050502030908050408030704--
