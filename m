Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbYKEWEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbYKEWEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 17:04:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbYKEWEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 17:04:37 -0500
Received: from vs02.svr02.mucip.net ([83.170.6.69]:33662 "EHLO
	mailout.mucip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbYKEWEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 17:04:33 -0500
Date: Wed, 5 Nov 2008 23:04:21 +0100
From: Bernhard Schmidt <berni@birkenwald.de>
To: linux-kernel@vger.kernel.org
Subject: [2.6.28-rc3] regression when switching TTY->X, input related?
Message-ID: <20081105220419.GA15685@pest>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I have a pretty weird issue with 2.6.28-rc3 that I originally thought to
be related with suspend2ram, then with intel's xorg driver and now it
looks like something related to the input subsystem.

I have a Dell Latitude D630 (Intel GM965 graphics) running Ubuntu 8.10
amd64. Since the included (heavily patched by Ubuntu) 2.6.27 is
extremely unstable in iwlagn I've been trying my luck with 2.6.28-rc3.

One thing that did not work anymore was suspend2ram and resume. It would
suspend just fine and resume as well, but then I would sit in front of a
black screen with an unmovable mouse cursor and not be able to do
anything, not even switch vtys or kill X with ctrl-alt-backspace. Magic
Sysrq to reboot did usually work though.

I've been following a few threads about similar issues in here, among
others this one: http://lkml.org/lkml/2008/11/5/217 . However, the
workaround mentioned in there (switch to a textmode console prior to
suspend) didn't work, in fact when switching back to X without
suspending I had the same problem. After sitting there and scratching my
head for a couple of minutes the screensaver unlock dialog suddenly
appeared and I could enter my password and "work", but the touchpad
didn't work. I verified that a couple of times and it is always the
same, after switching to a textmode vty and back to X I have a black
screen with my mousecursor, I can neither move the cursor with the
touchpad nor any keypress has any effect, but the box isn't locked up.
There is a bit of disk activity, I can login using the serial console
just fine and immediately kill and restart X and it comes back fine, in
seldom cases without a working touchpad, but that might be a different
issue.  After about 30-120s the situation resolves itself and I get my
normal X, but again sometimes without touchpad.

I think this is an input issue because I get the following messages in
/var/log/Xorg.0.log when switching away:

(II) AIGLX: Suspending AIGLX clients for VT switch
(II) intel(0): xf86UnbindGARTMemory: unbind key 0
(II) intel(0): xf86UnbindGARTMemory: unbind key 1

when switching back

(II) Open ACPI successful (/var/run/acpid.socket) 
(II) AIGLX: Resuming AIGLX clients after VT switch
(II) intel(0): xf86BindGARTMemory: bind key 0 at 0x0c6b0000 (pgoffset 50864)
(II) intel(0): xf86BindGARTMemory: bind key 1 at 0x0e000000 (pgoffset 57344)
(II) intel(0): Fixed memory allocation layout:                              
(II) intel(0): 0x00000000-0x00000fff: power context (4 kB)                  
(II) intel(0): 0x0077f000:            end of stolen memory                  
(II) intel(0): 0x0077f000-0x0c6affff: DRI memory manager (195780 kB)        
(II) intel(0): 0x0c6b0000-0x0dffffff: exa offscreen (25920 kB)              
(II) intel(0): 0x0e000000-0x0fffffff: classic textures (32768 kB)           
(II) intel(0): 0x10000000:            end of aperture                       
(II) intel(0): BO memory allocation layout:                                 
(II) intel(0): 0x0077f000:            start of memory manager               
(II) intel(0): 0x0079f000-0x0100efff: depth buffer (8640 kB) Y tiled        
(II) intel(0): 0x0179f000-0x0200efff: back buffer (8640 kB) X tiled         
(II) intel(0): 0x02800000-0x0306ffff: front buffer (8640 kB) X tiled        
(II) intel(0): 0x0279f000-0x0279ffff: overlay registers (4 kB)              
(II) intel(0): 0x027a0000-0x027b5fff: exa G965 state buffer (88 kB)         
(II) intel(0): 0x027c0000-0x027c7fff: logical 3D context (32 kB)            
(II) intel(0): 0x027c8000-0x027d1fff: HW cursors (40 kB)                    
(II) intel(0): 0x0c6b0000:            end of memory manager
(WW) intel(0): ESR is 0x00000001
(WW) intel(0): PRB0_CTL (0x0001f001) indicates ring buffer enabled
(WW) intel(0): Existing errors found in hardware state.
(II) intel(0): using SSC reference clock of 100 MHz
(II) intel(0): Selecting standard 18 bit TMDS pixel format.
(II) intel(0): Output configuration:
(II) intel(0):   Pipe A is off
(II) intel(0):   Display plane A is now disabled and connected to pipe A.
(II) intel(0):   Pipe B is on
(II) intel(0):   Display plane B is now enabled and connected to pipe B.
(II) intel(0):   Output VGA is connected to pipe none
(II) intel(0):   Output LVDS is connected to pipe B
(II) intel(0):   Output TMDS-1 is connected to pipe none
(II) intel(0):   Output TV is connected to pipe none
(II) intel(0): [drm] mapped front buffer at 0xe2800000, handle = 0x2fff8000
(II) Configured Mouse: x-axis range 0 - 1023
(II) Configured Mouse: y-axis range 0 - 767
(--) Configured Mouse touchpad found
(II) AlpsPS/2 ALPS GlidePoint: x-axis range 0 - 1023
(II) AlpsPS/2 ALPS GlidePoint: y-axis range 0 - 767
(WW) AlpsPS/2 ALPS GlidePoint can't grab event device, errno=16
(--) AlpsPS/2 ALPS GlidePoint touchpad found

then it hangs some seconds/minutes with the usual symptoms.  When I move
my finger on the touchpad in this stage I get my xorg log flooded with

[mi] EQ overflowing. The server is probably stuck in an infinite loop.
[mi] mieqEnequeue: out-of-order valuator event; dropping.

And then it suddenly shows me the login screen, and at the same time the
Xorg logfile gets the following lines added (at once, so there is a long
delay right before the following line)

(II) PS/2 Mouse: Device reopened after 10 attempts.
(**) PS/2 Mouse: YAxisMapping: buttons 4 and 5
(**) PS/2 Mouse: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
(II) AT Translated Set 2 keyboard: Device reopened after 10 attempts.
(II) Video Bus: Device reopened after 10 attempts.
(II) Video Bus: Device reopened after 10 attempts.
(II) Video Bus: Device reopened after 10 attempts.
(II) intel(0): EDID vendor "SEC", prod id 17495
(II) intel(0): Printing DDC gathered Modelines:
(II) intel(0): Modeline "1440x900"x0.0  105.06  1440 1488 1616 1920  900 906 909 912 -hsync -vsync (54.7 kHz)

I think this is a regression because it used to work with the 2.6.27
kernel from Ubuntu. I'll try with a vanilla 2.6.27 but I had been
running ext4dev which I need to work a bit to mount on 2.6.27 (it got
flagged as ext4 without test_fs flag the first time 2.6.28-rc was
booting). It's not really related to suspend, because it happens on VTY
switching as well. It happens with both Intel xorg driver 2.4.1 and
2.5.0. I think it's related to input because the first message after it
starts working again is always related to the mouse.

Anyone having an idea where to look? dmesg and config attached.

Bernhard

--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.txt"

[    0.000000] BIOS EBDA/lowmem at: 0009f000/0009f000
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.28-rc3 (root@schleppi) (gcc version 4.3.2 (Ubuntu 4.3.2-1ubuntu11) ) #1 SMP Wed Nov 5 16:49:22 CET 2008
[    0.000000] Command line: root=/dev/mapper/lvm-root ro quiet splash locale=de_DE rootfstype=ext4 
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f65b800 (usable)
[    0.000000]  BIOS-e820: 000000007f65b800 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1c000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000feda6000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x7f65b max_arch_pfn = 0x3ffffffff
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] init_memory_mapping: 0000000000000000-000000007f65b000
[    0.000000]  0000000000 - 007f600000 page 2M
[    0.000000]  007f600000 - 007f65b000 page 4k
[    0.000000] kernel direct mapping tables up to 7f65b000 @ 8000-c000
[    0.000000] last_map_addr: 7f65b000 end: 7f65b000
[    0.000000] RAMDISK: 377b3000 - 37fef146
[    0.000000] ACPI: RSDP 000FBB00, 0024 (r2 DELL  )
[    0.000000] ACPI: XSDT 7F65D200, 005C (r1 DELL    M08     27D8011E ASL        61)
[    0.000000] ACPI: FACP 7F65D09C, 00F4 (r4 DELL    M08     27D8011E ASL        61)
[    0.000000] ACPI: DSDT 7F65D800, 6152 (r2 INT430 SYSFexxx     1001 INTL 20050624)
[    0.000000] ACPI: FACS 7F66C000, 0040
[    0.000000] ACPI: HPET 7F65D300, 0038 (r1 DELL    M08            1 ASL        61)
[    0.000000] ACPI: APIC 7F65D400, 0068 (r1 DELL    M08     27D8011E ASL        47)
[    0.000000] ACPI: ASF! 7F65D000, 007E (r32 DELL    M08     27D8011E ASL        61)
[    0.000000] ACPI: MCFG 7F65D3C0, 003E (r16 DELL    M08     27D8011E ASL        61)
[    0.000000] ACPI: TCPA 7F65D700, 0032 (r1                        0 ASL         0)
[    0.000000] ACPI: SSDT 7F65B97A, 04CC (r1  PmRef    CpuPm     3000 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000007f65b000
[    0.000000] Bootmem setup node 0 0000000000000000-000000007f65b000
[    0.000000]   NODE_DATA [0000000000001000 - 0000000000005fff]
[    0.000000]   bootmap [000000000000a000 -  0000000000019ecf] pages 10
[    0.000000] (6 early reservations) ==> bootmem [0000000000 - 007f65b000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 00008b0afc]    TEXT DATA BSS ==> [0000200000 - 00008b0afc]
[    0.000000]   #3 [00377b3000 - 0037fef146]          RAMDISK ==> [00377b3000 - 0037fef146]
[    0.000000]   #4 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
[    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
[    0.000000]  [ffffe20000000000-ffffe20001bfffff] PMD -> [ffff880001200000-ffff880002dfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007f65b
[    0.000000] On node 0 totalpages: 521722
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1814 pages reserved
[    0.000000]   DMA zone: 2129 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7079 pages used for memmap
[    0.000000]   DMA32 zone: 510644 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000:78000000)
[    0.000000] PERCPU: Allocating 57344 bytes of per cpu data
[    0.000000] per cpu data for cpu0 on node0 at 0000000001010000
[    0.000000] per cpu data for cpu1 on node0 at 000000000101e000
[    0.000000] NR_CPUS: 64, nr_cpu_ids: 2, nr_node_ids 1
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 512773
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=/dev/mapper/lvm-root ro quiet splash locale=de_DE rootfstype=ext4 
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2394.489 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] allocated 20971520 bytes of page_cgroup
[    0.004000] please try cgroup_disable=memory option if you don't want
[    0.004000] Checking aperture...
[    0.004000] No AGP bridge found
[    0.004000] Calgary: detecting Calgary via BIOS EBDA area
[    0.004000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.004000] Memory: 2022164k/2087276k available (3194k kernel code, 388k absent, 64724k reserved, 1766k data, 492k init)
[    0.004000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 4788.97 BogoMIPS (lpj=9577956)
[    0.004000] Security Framework initialized
[    0.004000] SELinux:  Disabled at boot.
[    0.004000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004000] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.004000] Mount-cache hash table entries: 256
[    0.004000] Initializing cgroup subsys ns
[    0.004000] Initializing cgroup subsys cpuacct
[    0.004000] Initializing cgroup subsys memory
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU 0/0x0 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] CPU0: Thermal monitoring enabled (TM2)
[    0.004000] using mwait in idle threads.
[    0.004000] ACPI: Core revision 20080926
[    0.012062] Setting APIC routing to flat
[    0.012439] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.052877] CPU0: Intel(R) Core(TM)2 Duo CPU     T7700  @ 2.40GHz stepping 0a
[    0.056001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 4787.97 BogoMIPS (lpj=9575950)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU 1/0x1 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] CPU1: Thermal monitoring enabled (TM2)
[    0.004000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.141304] CPU1: Intel(R) Core(TM)2 Duo CPU     T7700  @ 2.40GHz stepping 0a
[    0.141326] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.144021] Brought up 2 CPUs
[    0.144023] Total of 2 processors activated (9576.95 BogoMIPS).
[    0.144077] CPU0 attaching sched-domain:
[    0.144080]  domain 0: span 0-1 level MC
[    0.144082]   groups: 0 1
[    0.144084]   domain 1: span 0-1 level NODE
[    0.144086]    groups: 0-1
[    0.144089] CPU1 attaching sched-domain:
[    0.144091]  domain 0: span 0-1 level MC
[    0.144092]   groups: 1 0
[    0.144094]   domain 1: span 0-1 level NODE
[    0.144095]    groups: 0-1
[    0.144169] net_namespace: 1400 bytes
[    0.144169] Time: 17:07:47  Date: 11/05/08
[    0.144169] regulator: core version 0.5
[    0.144169] NET: Registered protocol family 16
[    0.144169] ACPI: bus type pci registered
[    0.144169] PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
[    0.144169] PCI: MCFG area at f8000000 reserved in E820
[    0.145724] PCI: Using MMCONFIG at f8000000 - fbffffff
[    0.145726] PCI: Using configuration type 1 for base access
[    0.148589] ACPI: EC: Look up EC in DSDT
[    0.148773] ACPI: BIOS _OSI(Linux) query ignored
[    0.148775] ACPI: DMI System Vendor: Dell Inc.
[    0.148776] ACPI: DMI Product Name: Latitude D630                   
[    0.148777] ACPI: DMI Product Version: 
[    0.148778] ACPI: DMI Board Name: 0KU184
[    0.148779] ACPI: DMI BIOS Vendor: Dell Inc.
[    0.148780] ACPI: DMI BIOS Date: 01/30/2008
[    0.148781] ACPI: Please send DMI info above to linux-acpi@vger.kernel.org
[    0.148782] ACPI: If "acpi_osi=Linux" works better, please notify linux-acpi@vger.kernel.org
[    0.181912] ACPI: SSDT 7F66C080, 0043 (r1  LMPWR  DELLLOM     1001 INTL 20050624)
[    0.197601] ACPI: Interpreter enabled
[    0.197603] ACPI: (supports S0 S3 S4 S5)
[    0.198074] ACPI: Using IOAPIC for interrupt routing
[    0.277736] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.277736] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.277736] pci 0000:00:02.0: reg 10 64bit mmio: [0xfea00000-0xfeafffff]
[    0.277736] pci 0000:00:02.0: reg 18 64bit mmio: [0xe0000000-0xefffffff]
[    0.277736] pci 0000:00:02.0: reg 20 io port: [0xeff8-0xefff]
[    0.277736] pci 0000:00:02.1: reg 10 64bit mmio: [0xfeb00000-0xfebfffff]
[    0.277736] pci 0000:00:1a.0: reg 20 io port: [0x6f20-0x6f3f]
[    0.277736] pci 0000:00:1a.1: reg 20 io port: [0x6f00-0x6f1f]
[    0.277736] pci 0000:00:1a.7: reg 10 32bit mmio: [0xfed1c400-0xfed1c7ff]
[    0.277736] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.277736] pci 0000:00:1a.7: PME# disabled
[    0.277736] pci 0000:00:1b.0: reg 10 64bit mmio: [0xfe9fc000-0xfe9fffff]
[    0.277736] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.277736] pci 0000:00:1b.0: PME# disabled
[    0.277736] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.277736] pci 0000:00:1c.0: PME# disabled
[    0.277736] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.277736] pci 0000:00:1c.1: PME# disabled
[    0.277736] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.277736] pci 0000:00:1c.5: PME# disabled
[    0.277736] pci 0000:00:1d.0: reg 20 io port: [0x6f80-0x6f9f]
[    0.277736] pci 0000:00:1d.1: reg 20 io port: [0x6f60-0x6f7f]
[    0.277736] pci 0000:00:1d.2: reg 20 io port: [0x6f40-0x6f5f]
[    0.277736] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfed1c000-0xfed1c3ff]
[    0.280038] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.280043] pci 0000:00:1d.7: PME# disabled
[    0.280197] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
[    0.280200] pci 0000:00:1f.0: quirk: region 1080-10bf claimed by ICH6 GPIO
[    0.280235] pci 0000:00:1f.1: reg 10 io port: [0x1f0-0x1f7]
[    0.280242] pci 0000:00:1f.1: reg 14 io port: [0x3f4-0x3f7]
[    0.280249] pci 0000:00:1f.1: reg 18 io port: [0x170-0x177]
[    0.280256] pci 0000:00:1f.1: reg 1c io port: [0x374-0x377]
[    0.280263] pci 0000:00:1f.1: reg 20 io port: [0x6fa0-0x6faf]
[    0.280332] pci 0000:00:1f.2: reg 10 io port: [0x6eb0-0x6eb7]
[    0.280339] pci 0000:00:1f.2: reg 14 io port: [0x6eb8-0x6ebb]
[    0.280346] pci 0000:00:1f.2: reg 18 io port: [0x6ec0-0x6ec7]
[    0.280353] pci 0000:00:1f.2: reg 1c io port: [0x6ec8-0x6ecb]
[    0.280360] pci 0000:00:1f.2: reg 20 io port: [0x6ee0-0x6eff]
[    0.280367] pci 0000:00:1f.2: reg 24 32bit mmio: [0xfe9fb800-0xfe9fbfff]
[    0.280386] pci 0000:00:1f.2: PME# supported from D3hot
[    0.280390] pci 0000:00:1f.2: PME# disabled
[    0.280421] pci 0000:00:1f.3: reg 10 32bit mmio: [0xfe9fb700-0xfe9fb7ff]
[    0.280445] pci 0000:00:1f.3: reg 20 io port: [0x10c0-0x10df]
[    0.280655] pci 0000:0c:00.0: reg 10 64bit mmio: [0xfe8fe000-0xfe8fffff]
[    0.280747] pci 0000:0c:00.0: PME# supported from D0 D3hot D3cold
[    0.280759] pci 0000:0c:00.0: PME# disabled
[    0.280845] pci 0000:00:1c.1: bridge 32bit mmio: [0xfe800000-0xfe8fffff]
[    0.280937] pci 0000:09:00.0: reg 10 64bit mmio: [0xfe7f0000-0xfe7fffff]
[    0.280994] pci 0000:09:00.0: PME# supported from D3hot D3cold
[    0.280999] pci 0000:09:00.0: PME# disabled
[    0.281069] pci 0000:00:1c.5: bridge 32bit mmio: [0xfe700000-0xfe7fffff]
[    0.281126] pci 0000:03:01.0: reg 10 32bit mmio: [0x000000-0x000fff]
[    0.281138] pci 0000:03:01.0: supports D1 D2
[    0.281140] pci 0000:03:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.281145] pci 0000:03:01.0: PME# disabled
[    0.281190] pci 0000:03:01.4: reg 10 32bit mmio: [0xfe6ff000-0xfe6fffff]
[    0.281197] pci 0000:03:01.4: reg 14 32bit mmio: [0xfe6fe800-0xfe6fefff]
[    0.281237] pci 0000:03:01.4: supports D1 D2
[    0.281238] pci 0000:03:01.4: PME# supported from D0 D1 D2 D3hot D3cold
[    0.281242] pci 0000:03:01.4: PME# disabled
[    0.281309] pci 0000:00:1e.0: transparent bridge
[    0.281316] pci 0000:00:1e.0: bridge 32bit mmio: [0xfe600000-0xfe6fffff]
[    0.281373] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.281783] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
[    0.281943] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.282058] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.282175] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    0.298973] ACPI: PCI Interrupt Link [LNKA] (IRQs 9 10 *11)
[    0.298973] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *10
[    0.298973] ACPI: PCI Interrupt Link [LNKC] (IRQs 9 10 11) *0, disabled.
[    0.298973] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 9 10 11) *3
[    0.298973] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.298973] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
[    0.298973] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    0.298973] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.300037] PCI: Using ACPI for IRQ routing
[    0.320008] NET: Registered protocol family 8
[    0.320009] NET: Registered protocol family 20
[    0.320020] NetLabel: Initializing
[    0.320020] NetLabel:  domain hash size = 128
[    0.320020] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.320027] NetLabel:  unlabeled traffic allowed by default
[    0.320042] PCI-GART: No AMD GART found.
[    0.320049] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.320053] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.340005] pnp: PnP ACPI init
[    0.340011] ACPI: bus type pnp registered
[    0.386238] pnp 00:0b: io resource (0x1000-0x1005) overlaps 0000:00:1f.0 BAR 7 (0x1000-0x107f), disabling
[    0.386240] pnp 00:0b: io resource (0x1008-0x100f) overlaps 0000:00:1f.0 BAR 7 (0x1000-0x107f), disabling
[    0.386347] pnp 00:0c: io resource (0x1006-0x1007) overlaps 0000:00:1f.0 BAR 7 (0x1000-0x107f), disabling
[    0.386349] pnp 00:0c: io resource (0x100a-0x1059) overlaps 0000:00:1f.0 BAR 7 (0x1000-0x107f), disabling
[    0.386351] pnp 00:0c: io resource (0x1060-0x107f) overlaps 0000:00:1f.0 BAR 7 (0x1000-0x107f), disabling
[    0.386353] pnp 00:0c: io resource (0x1010-0x102f) overlaps 0000:00:1f.0 BAR 7 (0x1000-0x107f), disabling
[    0.407617] pnp: PnP ACPI: found 14 devices
[    0.407619] ACPI: ACPI bus type pnp unregistered
[    0.407632] system 00:05: ioport range 0xc80-0xcaf has been reserved
[    0.407634] system 00:05: ioport range 0xcc0-0xcff could not be reserved
[    0.407639] system 00:08: iomem range 0xfed00000-0xfed003ff has been reserved
[    0.407643] system 00:0a: ioport range 0xcb0-0xcbb has been reserved
[    0.407647] system 00:0a: iomem range 0xfed40000-0xfed44fff has been reserved
[    0.407651] system 00:0b: ioport range 0x900-0x97f has been reserved
[    0.407653] system 00:0b: ioport range 0x4d0-0x4d1 has been reserved
[    0.407660] system 00:0c: ioport range 0xf400-0xf4fe has been reserved
[    0.407662] system 00:0c: ioport range 0x1080-0x10bf has been reserved
[    0.407664] system 00:0c: ioport range 0x10c0-0x10df has been reserved
[    0.407666] system 00:0c: ioport range 0x809-0x809 has been reserved
[    0.407671] system 00:0d: iomem range 0x0-0x9efff could not be reserved
[    0.407672] system 00:0d: iomem range 0x9f000-0x9ffff could not be reserved
[    0.407674] system 00:0d: iomem range 0xc0000-0xcffff has been reserved
[    0.407676] system 00:0d: iomem range 0xe0000-0xfffff has been reserved
[    0.407678] system 00:0d: iomem range 0x100000-0x7f65b7ff could not be reserved
[    0.407680] system 00:0d: iomem range 0x7f65b800-0x7f6fffff has been reserved
[    0.407681] system 00:0d: iomem range 0x7f700000-0x7f7fffff has been reserved
[    0.407683] system 00:0d: iomem range 0x7f700000-0x7fefffff could not be reserved
[    0.407685] system 00:0d: iomem range 0xffe00000-0xffffffff has been reserved
[    0.407687] system 00:0d: iomem range 0xffa00000-0xffbfffff has been reserved
[    0.407689] system 00:0d: iomem range 0xfec00000-0xfec0ffff has been reserved
[    0.407691] system 00:0d: iomem range 0xfee00000-0xfee0ffff has been reserved
[    0.407693] system 00:0d: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.407695] system 00:0d: iomem range 0xfed45000-0xfed8ffff has been reserved
[    0.407696] system 00:0d: iomem range 0xfeda0000-0xfeda3fff has been reserved
[    0.407698] system 00:0d: iomem range 0xfeda4000-0xfeda4fff has been reserved
[    0.407702] system 00:0d: iomem range 0xfeda5000-0xfeda5fff has been reserved
[    0.407704] system 00:0d: iomem range 0xfeda6000-0xfeda6fff has been reserved
[    0.407706] system 00:0d: iomem range 0xfed18000-0xfed1bfff has been reserved
[    0.407708] system 00:0d: iomem range 0xf8000000-0xfbffffff has been reserved
[    0.412618] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:0b
[    0.412619] pci 0000:00:1c.0:   IO window: disabled
[    0.412625] pci 0000:00:1c.0:   MEM window: disabled
[    0.412629] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.412636] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:0c
[    0.412637] pci 0000:00:1c.1:   IO window: disabled
[    0.412643] pci 0000:00:1c.1:   MEM window: 0xfe800000-0xfe8fffff
[    0.412647] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.412654] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:09
[    0.412655] pci 0000:00:1c.5:   IO window: disabled
[    0.412660] pci 0000:00:1c.5:   MEM window: 0xfe700000-0xfe7fffff
[    0.412664] pci 0000:00:1c.5:   PREFETCH window: disabled
[    0.412677] pci 0000:03:01.0: CardBus bridge, secondary bus 0000:04
[    0.412678] pci 0000:03:01.0:   IO window: 0x002000-0x0020ff
[    0.412683] pci 0000:03:01.0:   IO window: 0x002400-0x0024ff
[    0.412688] pci 0000:03:01.0:   PREFETCH window: 0x88000000-0x8bffffff
[    0.412693] pci 0000:03:01.0:   MEM window: 0x8c000000-0x8fffffff
[    0.412697] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:03
[    0.412700] pci 0000:00:1e.0:   IO window: 0x2000-0x2fff
[    0.412705] pci 0000:00:1e.0:   MEM window: 0xfe600000-0xfe6fffff
[    0.412710] pci 0000:00:1e.0:   PREFETCH window: 0x00000088000000-0x0000008bffffff
[    0.412726] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.412731] pci 0000:00:1c.0: setting latency timer to 64
[    0.412739] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.412744] pci 0000:00:1c.1: setting latency timer to 64
[    0.412751] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.412755] pci 0000:00:1c.5: setting latency timer to 64
[    0.412763] pci 0000:00:1e.0: setting latency timer to 64
[    0.412771] pci 0000:03:01.0: enabling device (0000 -> 0003)
[    0.412775] pci 0000:03:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.412782] bus: 00 index 0 io port: [0x00-0xffff]
[    0.412784] bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
[    0.412785] bus: 0b index 0 mmio: [0x0-0x0]
[    0.412786] bus: 0b index 1 mmio: [0x0-0x0]
[    0.412787] bus: 0b index 2 mmio: [0x0-0x0]
[    0.412788] bus: 0b index 3 mmio: [0x0-0x0]
[    0.412790] bus: 0c index 0 mmio: [0x0-0x0]
[    0.412791] bus: 0c index 1 mmio: [0xfe800000-0xfe8fffff]
[    0.412792] bus: 0c index 2 mmio: [0x0-0x0]
[    0.412793] bus: 0c index 3 mmio: [0x0-0x0]
[    0.412794] bus: 09 index 0 mmio: [0x0-0x0]
[    0.412796] bus: 09 index 1 mmio: [0xfe700000-0xfe7fffff]
[    0.412797] bus: 09 index 2 mmio: [0x0-0x0]
[    0.412798] bus: 09 index 3 mmio: [0x0-0x0]
[    0.412799] bus: 03 index 0 io port: [0x2000-0x2fff]
[    0.412801] bus: 03 index 1 mmio: [0xfe600000-0xfe6fffff]
[    0.412802] bus: 03 index 2 mmio: [0x88000000-0x8bffffff]
[    0.412803] bus: 03 index 3 io port: [0x00-0xffff]
[    0.412805] bus: 03 index 4 mmio: [0x000000-0xffffffffffffffff]
[    0.412806] bus: 04 index 0 io port: [0x2000-0x20ff]
[    0.412807] bus: 04 index 1 io port: [0x2400-0x24ff]
[    0.412809] bus: 04 index 2 mmio: [0x88000000-0x8bffffff]
[    0.412810] bus: 04 index 3 mmio: [0x8c000000-0x8fffffff]
[    0.412819] NET: Registered protocol family 2
[    0.452056] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.452604] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.454134] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.454667] TCP: Hash tables configured (established 262144 bind 65536)
[    0.454669] TCP reno registered
[    0.464066] NET: Registered protocol family 1
[    0.464172] checking if image is initramfs...<7>Switched to high resolution mode on CPU 1
[    0.503964] Switched to high resolution mode on CPU 0
[    0.766395]  it is
[    1.089688] Freeing initrd memory: 8432k freed
[    1.094365] audit: initializing netlink socket (disabled)
[    1.094386] type=2000 audit(1225904868.093:1): initialized
[    1.099457] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.101343] VFS: Disk quotas dquot_6.5.1
[    1.101406] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.101860] msgmni has been set to 3966
[    1.102005] alg: No test for stdrng (krng)
[    1.102015] io scheduler noop registered
[    1.102016] io scheduler anticipatory registered
[    1.102017] io scheduler deadline registered
[    1.102103] io scheduler cfq registered (default)
[    1.102115] pci 0000:00:02.0: Boot video device
[    1.145711] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    1.145759] pcieport-driver 0000:00:1c.0: found MSI capability
[    1.145794] pcieport-driver 0000:00:1c.0: irq 47 for MSI/MSI-X
[    1.145809] pci_express 0000:00:1c.0:pcie00: allocate port service
[    1.145840] pci_express 0000:00:1c.0:pcie02: allocate port service
[    1.145867] pci_express 0000:00:1c.0:pcie03: allocate port service
[    1.145957] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    1.146003] pcieport-driver 0000:00:1c.1: found MSI capability
[    1.146033] pcieport-driver 0000:00:1c.1: irq 46 for MSI/MSI-X
[    1.146048] pci_express 0000:00:1c.1:pcie00: allocate port service
[    1.146075] pci_express 0000:00:1c.1:pcie02: allocate port service
[    1.146101] pci_express 0000:00:1c.1:pcie03: allocate port service
[    1.146188] pcieport-driver 0000:00:1c.5: setting latency timer to 64
[    1.146234] pcieport-driver 0000:00:1c.5: found MSI capability
[    1.146264] pcieport-driver 0000:00:1c.5: irq 45 for MSI/MSI-X
[    1.146279] pci_express 0000:00:1c.5:pcie00: allocate port service
[    1.146309] pci_express 0000:00:1c.5:pcie02: allocate port service
[    1.146337] pci_express 0000:00:1c.5:pcie03: allocate port service
[    1.170553] Linux agpgart interface v0.103
[    1.170558] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
[    1.170700] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.171295] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.172663] brd: module loaded
[    1.172739] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    1.176154] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.176158] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.176249] mice: PS/2 mouse device common for all mice
[    1.176305] rtc_cmos 00:03: RTC can wake from S4
[    1.176356] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.176387] rtc0: alarms up to one month, y3k, 114 bytes nvram, , hpet irqs irqs
[    1.176414] cpuidle: using governor ladder
[    1.176415] cpuidle: using governor menu
[    1.176696] TCP cubic registered
[    1.176840] registered taskstats version 1
[    1.176952]   Magic number: 0:274:137
[    1.176955] block ram2: hash matches
[    1.177124] rtc_cmos 00:03: setting system clock to 2008-11-05 17:07:48 UTC (1225904868)
[    1.177127] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.177128] EDD information not available.
[    1.177161] Freeing unused kernel memory: 492k freed
[    1.177374] Write protecting the kernel read-only data: 4504k
[    1.179930] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    1.280026] fuse init (API version 7.10)
[    1.344433] ACPI: SSDT 7F65C4B0, 02C8 (r1  PmRef  Cpu0Ist     3000 INTL 20050624)
[    1.344807] ACPI: SSDT 7F65BE46, 05E5 (r1  PmRef  Cpu0Cst     3001 INTL 20050624)
[    1.345087] Monitor-Mwait will be used to enter C-1 state
[    1.345090] Monitor-Mwait will be used to enter C-2 state
[    1.345091] Monitor-Mwait will be used to enter C-3 state
[    1.345218] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    1.345258] processor ACPI0007:00: registered as cooling_device0
[    1.345261] ACPI: Processor [CPU0] (supports 8 throttling states)
[    1.345555] ACPI: SSDT 7F65C778, 00C4 (r1  PmRef  Cpu1Ist     3000 INTL 20050624)
[    1.345804] ACPI: SSDT 7F65C42B, 0085 (r1  PmRef  Cpu1Cst     3000 INTL 20050624)
[    1.346210] Marking TSC unstable due to TSC halts in idle
[    1.346343] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    1.346379] processor ACPI0007:01: registered as cooling_device1
[    1.346382] ACPI: Processor [CPU1] (supports 8 throttling states)
[    1.351225] thermal LNXTHERM:01: registered as thermal_zone0
[    1.354862] ACPI: Thermal Zone [THM] (57 C)
[    1.381156] device-mapper: uevent: version 1.0.3
[    1.381329] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    1.672773] usbcore: registered new interface driver usbfs
[    1.672793] usbcore: registered new interface driver hub
[    1.687166] usbcore: registered new device driver usb
[    1.688418] uhci_hcd: USB Universal Host Controller Interface driver
[    1.688467] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.688478] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.688481] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.688515] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    1.688553] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00006f20
[    1.688675] usb usb1: configuration #1 chosen from 1 choice
[    1.688695] hub 1-0:1.0: USB hub found
[    1.688699] hub 1-0:1.0: 2 ports detected
[    1.688803] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.688809] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    1.688812] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    1.688828] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
[    1.688860] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00006f00
[    1.688928] usb usb2: configuration #1 chosen from 1 choice
[    1.688946] hub 2-0:1.0: USB hub found
[    1.688951] hub 2-0:1.0: 2 ports detected
[    1.689058] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.689065] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.689068] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.689086] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 3
[    1.689112] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006f80
[    1.689183] usb usb3: configuration #1 chosen from 1 choice
[    1.689201] hub 3-0:1.0: USB hub found
[    1.689205] hub 3-0:1.0: 2 ports detected
[    1.689288] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.689295] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.689297] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.689313] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 4
[    1.689339] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006f60
[    1.689407] usb usb4: configuration #1 chosen from 1 choice
[    1.689424] hub 4-0:1.0: USB hub found
[    1.689429] hub 4-0:1.0: 2 ports detected
[    1.689516] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    1.689522] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.689524] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.689544] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 5
[    1.689578] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00006f40
[    1.689652] usb usb5: configuration #1 chosen from 1 choice
[    1.689670] hub 5-0:1.0: USB hub found
[    1.689675] hub 5-0:1.0: 2 ports detected
[    1.691670] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.691672] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    1.691691] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    1.691718] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    1.691721] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.691740] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 6
[    1.695658] ehci_hcd 0000:00:1a.7: debug port 1
[    1.695664] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    1.695669] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfed1c400
[    1.709016] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.709123] usb usb6: configuration #1 chosen from 1 choice
[    1.709144] hub 6-0:1.0: USB hub found
[    1.709149] hub 6-0:1.0: 4 ports detected
[    1.709252] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.709268] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.709271] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.709288] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 7
[    1.713209] ehci_hcd 0000:00:1d.7: debug port 1
[    1.713215] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    1.713221] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfed1c000
[    1.716669] tg3.c:v3.94 (August 14, 2008)
[    1.716684] tg3 0000:09:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.716692] tg3 0000:09:00.0: setting latency timer to 64
[    1.729043] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.729172] usb usb7: configuration #1 chosen from 1 choice
[    1.729193] hub 7-0:1.0: USB hub found
[    1.729198] hub 7-0:1.0: 6 ports detected
[    1.736771] eth0: Tigon3 [partno(BCM95755m) rev a002 PHY(5755)] (PCI Express) 10/100/1000Base-T Ethernet 00:1c:23:27:fc:e9
[    1.736773] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
[    1.736775] eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    1.755201] SCSI subsystem initialized
[    1.771054] libata version 3.00 loaded.
[    1.772817] ata_piix 0000:00:1f.1: version 2.12
[    1.772829] ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.772866] ata_piix 0000:00:1f.1: setting latency timer to 64
[    1.775487] scsi0 : ata_piix
[    1.779890] scsi1 : ata_piix
[    1.782347] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x6fa0 irq 14
[    1.782349] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x6fa8 irq 15
[    1.961706] ata1.00: ATAPI: TSSTcorp DVD+/-RW TS-L632H, D200, max UDMA/33
[    1.993418] ata1.00: configured for UDMA/33
[    2.003490] ata2: port disabled. ignoring.
[    2.003520] isa bounce pool size: 16 pages
[    2.007382] scsi 0:0:0:0: CD-ROM            TSSTcorp DVD+-RW TS-L632H D200 PQ: 0 ANSI: 5
[    2.009014] ahci 0000:00:1f.2: version 3.0
[    2.009028] ahci 0000:00:1f.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.009082] ahci 0000:00:1f.2: irq 44 for MSI/MSI-X
[    2.009148] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x5 impl SATA mode
[    2.009150] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems 
[    2.009155] ahci 0000:00:1f.2: setting latency timer to 64
[    2.014319] scsi2 : ahci
[    2.014381] scsi3 : ahci
[    2.014425] scsi4 : ahci
[    2.014660] ata3: SATA max UDMA/133 abar m2048@0xfe9fb800 port 0xfe9fb900 irq 44
[    2.014662] ata4: DUMMY
[    2.014665] ata5: SATA max UDMA/133 abar m2048@0xfe9fb800 port 0xfe9fba00 irq 44
[    2.336195] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.337108] ata3.00: ATA-8: Hitachi HTS722080K9A300, DCBOC54P, max UDMA/133
[    2.337112] ata3.00: 156301488 sectors, multi 8: LBA48 NCQ (depth 31/32)
[    2.338285] ata3.00: configured for UDMA/133
[    2.497156] usb 1-2: new full speed USB device using uhci_hcd and address 2
[    2.500170] Clocksource tsc unstable (delta = -385077209 ns)
[    2.672190] ata5: SATA link down (SStatus 0 SControl 300)
[    2.681436] usb 1-2: configuration #1 chosen from 1 choice
[    2.689678] scsi 2:0:0:0: Direct-Access     ATA      Hitachi HTS72208 DCBO PQ: 0 ANSI: 5
[    2.696271] scsi 0:0:0:0: Attached scsi generic sg0 type 5
[    2.696302] scsi 2:0:0:0: Attached scsi generic sg1 type 0
[    2.706269] Driver 'sr' needs updating - please use bus_type methods
[    2.708829] Driver 'sd' needs updating - please use bus_type methods
[    2.720080] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    2.720084] Uniform CD-ROM driver Revision: 3.20
[    2.720203] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    2.720313] sd 2:0:0:0: [sda] 156301488 512-byte hardware sectors: (80.0 GB/74.5 GiB)
[    2.721817] sd 2:0:0:0: [sda] Write Protect is off
[    2.721819] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.721845] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.721894] sd 2:0:0:0: [sda] 156301488 512-byte hardware sectors: (80.0 GB/74.5 GiB)
[    2.721905] sd 2:0:0:0: [sda] Write Protect is off
[    2.721907] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.721924] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.721927]  sda: sda1 sda2 sda3 sda4
[    2.741680] sd 2:0:0:0: [sda] Attached SCSI disk
[    2.925071] usb 2-2: new full speed USB device using uhci_hcd and address 2
[    3.090296] usb 2-2: configuration #1 chosen from 1 choice
[    3.337235] usb 5-1: new full speed USB device using uhci_hcd and address 2
[    3.491007] usb 5-1: configuration #1 chosen from 1 choice
[    3.492709] hub 5-1:1.0: USB hub found
[    3.494639] hub 5-1:1.0: 4 ports detected
[    3.778661] usb 5-1.2: new full speed USB device using uhci_hcd and address 3
[    3.895257] usb 5-1.2: configuration #1 chosen from 1 choice
[    8.318856] EXT4-fs: barriers enabled
[    8.328003] kjournald2 starting.  Commit interval 5 seconds
[    8.328016] EXT4-fs: delayed allocation enabled
[    8.328018] EXT4-fs: file extents enabled
[    8.328108] EXT4-fs: mballoc enabled
[    8.328111] EXT4-fs: mounted filesystem with ordered data mode.
[   15.498514] udevd version 124 started
[   15.828626] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   15.852130] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   15.889019] ACPI Warning (nspredef-0858): \_SB_.BAT0._BIF: Return Package type mismatch at index 9 - found Buffer, expected String [20080926]
[   15.894679] ACPI: Battery Slot [BAT0] (battery present)
[   15.894727] ACPI: Battery Slot [BAT1] (battery absent)
[   15.912442] yenta_cardbus 0000:03:01.0: CardBus bridge found [1028:01f9]
[   15.912467] yenta_cardbus 0000:03:01.0: O2: res at 0x94/0xD4: 00/ea
[   15.912468] yenta_cardbus 0000:03:01.0: O2: enabling read prefetch/write burst
[   15.913897] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[   15.914394] ACPI: Lid Switch [LID]
[   15.914446] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
[   15.926380] agpgart-intel 0000:00:00.0: Intel 965GM Chipset
[   15.927206] agpgart-intel 0000:00:00.0: detected 7676K stolen memory
[   15.930289] ACPI: Power Button (CM) [PBTN]
[   15.930356] input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3
[   15.930362] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[   15.944017] ACPI: Sleep Button (CM) [SBTN]
[   15.961905] ACPI: WMI: Mapper loaded
[   15.973491] ACPI: AC Adapter [AC] (on-line)
[   16.040945] yenta_cardbus 0000:03:01.0: ISA IRQ mask 0x0cb8, PCI irq 19
[   16.040949] yenta_cardbus 0000:03:01.0: Socket status: 30000006
[   16.040951] pci_bus 0000:03: Raising subordinate bus# of parent bus (#03) from #04 to #07
[   16.040956] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge I/O window: 0x2000 - 0x2fff
[   16.040959] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge Memory window: 0xfe600000 - 0xfe6fffff
[   16.040961] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge Memory window: 0x88000000 - 0x8bffffff
[   16.142313] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:31/device:32/input/input4
[   16.156022] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[   16.156635] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:37/input/input5
[   16.168017] ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)
[   16.168086] ACPI Warning (nspredef-0357): \_SB_.PCI0.VID2._DOD: Return Package has no elements (empty) [20080926]
[   16.168176] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:3c/input/input6
[   16.184045] ACPI: Video Device [VID2] (multi-head: yes  rom: no  post: no)
[   16.245064] cfg80211: Using static regulatory domain info
[   16.245067] cfg80211: Regulatory domain: US
[   16.245068] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   16.245070] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[   16.245072] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[   16.245073] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[   16.245075] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[   16.245076] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[   16.245078] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[   16.245080] cfg80211: Calling CRDA for country: US
[   16.324137] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[   16.324199] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   16.425603] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27ks
[   16.425605] iwlagn: Copyright(c) 2003-2008 Intel Corporation
[   16.425700] iwlagn 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   16.425728] iwlagn 0000:0c:00.0: setting latency timer to 64
[   16.425794] iwlagn: Detected Intel Wireless WiFi Link 4965AGN REV=0x4
[   16.444644] input: PC Speaker as /devices/platform/pcspkr/input/input7
[   16.475587] iwlagn: Tunable channels: 13 802.11bg, 19 802.11a channels
[   16.480077] iwlagn 0000:0c:00.0: PCI INT A disabled
[   16.480862] phy0: Selected rate control algorithm 'iwl-agn-rs'
[   16.648596] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   17.205252] input: PS/2 Mouse as /devices/platform/i8042/serio1/input/input8
[   17.253877] input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio1/input/input9
[   17.705157] CE: hpet increasing min_delta_ns to 15000 nsec
[   18.607674] EXT4 FS on dm-1, internal journal on dm-1:8
[   23.805970] JBD: barrier-based sync failed on dm-1:8 - disabling barriers
[   29.988655] kjournald starting.  Commit interval 5 seconds
[   29.997187] EXT3 FS on sda1, internal journal
[   29.997270] EXT3-fs: mounted filesystem with ordered data mode.
[   29.997527] EXT4-fs: Update your userspace programs to mount using ext4
[   29.997572] EXT4-fs: ext4dev backwards compatibility will go away by 2.6.31
[   30.030419] EXT4-fs: barriers enabled
[   30.033609] kjournald2 starting.  Commit interval 5 seconds
[   30.033965] EXT4 FS on dm-2, internal journal on dm-2:8
[   30.034016] EXT4-fs: delayed allocation enabled
[   30.034064] EXT4-fs: file extents enabled
[   30.034216] EXT4-fs: mballoc enabled
[   30.034266] EXT4-fs: mounted filesystem with ordered data mode.
[   30.235856] ip_tables: (C) 2000-2006 Netfilter Core Team
[   30.313382] tun: Universal TUN/TAP device driver, 1.6
[   30.313437] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   30.352176] NET: Registered protocol family 10
[   30.352554] lo: Disabled Privacy Extensions
[   30.408618] warning: `miredo' uses 32-bit capabilities (legacy support in use)
[   30.417619] teredo: Disabled Privacy Extensions
[   33.684326] lp: driver loaded but no devices found
[   33.707318] ppdev: user-space parallel port driver
[   35.423017] Bluetooth: Core ver 2.13
[   35.423623] NET: Registered protocol family 31
[   35.423674] Bluetooth: HCI device and connection manager initialized
[   35.423731] Bluetooth: HCI socket layer initialized
[   35.466866] Bluetooth: L2CAP ver 2.11
[   35.466917] Bluetooth: L2CAP socket layer initialized
[   35.474112] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   35.474164] Bluetooth: BNEP filters: protocol multicast
[   35.510582] Bridge firewalling registered
[   35.518210] Bluetooth: SCO (Voice Link) ver 0.6
[   35.518259] Bluetooth: SCO socket layer initialized
[   35.597270] Bluetooth: RFCOMM socket layer initialized
[   35.597329] Bluetooth: RFCOMM TTY layer initialized
[   35.597376] Bluetooth: RFCOMM ver 1.10
[   38.425852] CPU0 attaching NULL sched-domain.
[   38.425856] CPU1 attaching NULL sched-domain.
[   38.440089] CPU0 attaching sched-domain:
[   38.440092]  domain 0: span 0-1 level MC
[   38.440094]   groups: 0 1
[   38.440096]   domain 1: span 0-1 level CPU
[   38.440098]    groups: 0-1
[   38.440100]    domain 2: span 0-1 level NODE
[   38.440101]     groups: 0-1
[   38.440104] CPU1 attaching sched-domain:
[   38.440105]  domain 0: span 0-1 level MC
[   38.440106]   groups: 1 0
[   38.440108]   domain 1: span 0-1 level CPU
[   38.440110]    groups: 0-1
[   38.440112]    domain 2: span 0-1 level NODE
[   38.440113]     groups: 0-1
[   39.088444] [drm] Initialized drm 1.1.0 20060810
[   39.122244] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   39.122256] pci 0000:00:02.0: setting latency timer to 64
[   39.122665] [drm] Initialized i915 1.6.0 20080730 on minor 0
[   39.661092] tg3 0000:09:00.0: irq 43 for MSI/MSI-X
[   39.721179] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   39.735183] iwlagn 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   39.735272] iwlagn 0000:0c:00.0: restoring config space at offset 0x1 (was 0x100102, writing 0x100106)
[   39.735379] iwlagn 0000:0c:00.0: irq 42 for MSI/MSI-X
[   39.735448] iwlagn 0000:0c:00.0: firmware: requesting iwlwifi-4965-2.ucode
[   40.017132] Registered led device: iwl-phy0:radio
[   40.017175] Registered led device: iwl-phy0:assoc
[   40.017209] Registered led device: iwl-phy0:RX
[   40.017243] Registered led device: iwl-phy0:TX
[   40.055963] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   40.165718] NET: Registered protocol family 17
[   40.913098] wlan0: authenticate with AP 00:03:52:5b:8a:92
[   40.942307] wlan0: authenticated
[   40.942317] wlan0: associate with AP 00:03:52:5b:8a:92
[   40.944648] wlan0: RX AssocResp from 00:03:52:5b:8a:92 (capab=0xc21 status=0 aid=1)
[   40.944655] wlan0: associated
[   40.965419] wlan0: disassociating by local choice (reason=3)
[  115.988341] JBD: barrier-based sync failed on dm-2:8 - disabling barriers
[  139.288962] wlan0: authenticate with AP 00:03:52:5b:8a:94
[  139.314896] wlan0: authenticate with AP 00:03:52:5b:8a:94
[  139.320030] wlan0: authenticate with AP 00:03:52:5b:8a:94
[  139.320063] wlan0: authenticated
[  139.320068] wlan0: associate with AP 00:03:52:5b:8a:94
[  139.324352] wlan0: RX AssocResp from 00:03:52:5b:8a:94 (capab=0xc31 status=0 aid=1)
[  139.324360] wlan0: associated
[  139.344836] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready

--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=config

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.28-rc3
# Wed Nov  5 16:45:05 2008
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=y
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
# CONFIG_USER_SCHED is not set
CONFIG_CGROUP_SCHED=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MM_OWNER=y
CONFIG_CGROUP_MEM_RES_CTLR=y
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_PROC_PID_CPUSET=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_COMPAT_BRK is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_MARKERS=y
CONFIG_OPROFILE=m
# CONFIG_OPROFILE_IBS is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_IO_TRACE=y
# CONFIG_BLK_DEV_BSG is not set
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_CLASSIC_RCU=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_VSMP is not set
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=y
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR_64=y
CONFIG_X86_DS=y
CONFIG_X86_PTRACE_BTS=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_AMD_IOMMU=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=64
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_I8K=m
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_NUMA=y
CONFIG_K8_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y

#
# Memory hotplug is currently incompatible with Software Suspend
#
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MIGRATION=y
CONFIG_RESOURCES_64BIT=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_UNEVICTABLE_LRU=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_EFI=y
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x200000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=y

#
# Power management options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_VERBOSE is not set
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_PM_TEST_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_NUMA=y
CONFIG_ACPI_WMI=m
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_PCI_SLOT=m
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=m
CONFIG_ACPI_SBS=m

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=m
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_POWERNOW_K8=m
CONFIG_X86_POWERNOW_K8_ACPI=y
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_DMAR is not set
# CONFIG_INTR_REMAP is not set
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=m
CONFIG_PCIEAER=y
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
CONFIG_PCCARD=m
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_PCMCIA_IOCTL=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=m
CONFIG_I82092=m
CONFIG_PCCARD_NONSTATIC=m
CONFIG_HOTPLUG_PCI=m
CONFIG_HOTPLUG_PCI_FAKE=m
CONFIG_HOTPLUG_PCI_ACPI=m
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=m
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=m
CONFIG_HOTPLUG_PCI_SHPC=m

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=m
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=m
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
# CONFIG_IPV6_MIP6 is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
# CONFIG_NF_CT_PROTO_DCCP is not set
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_PPTP=m
# CONFIG_NF_CONNTRACK_SANE is not set
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
# CONFIG_NETFILTER_TPROXY is not set
CONFIG_NETFILTER_XTABLES=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
# CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP is not set
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
# CONFIG_NETFILTER_XT_MATCH_RECENT is not set
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
CONFIG_IP_VS=m
# CONFIG_IP_VS_IPV6 is not set
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_PROTO_UDPLITE=m
CONFIG_NF_NAT_PROTO_SCTP=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_NF_NAT_SIP=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_QUEUE=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_TARGET_LOG=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=m
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_ULOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m
CONFIG_IP_DCCP_ACKVEC=y

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
CONFIG_IP_DCCP_CCID2=m
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=m
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_CCID3_RTO=100
CONFIG_IP_DCCP_TFRC_LIB=m

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_NET_DCCPPROBE=m
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
CONFIG_TIPC=m
# CONFIG_TIPC_ADVANCED is not set
# CONFIG_TIPC_DEBUG is not set
CONFIG_ATM=y
CONFIG_ATM_CLIP=y
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
CONFIG_ATM_MPOA=m
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_BRIDGE=m
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_DECNET=m
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
CONFIG_LLC2=m
CONFIG_IPX=m
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
CONFIG_IPDDP=m
CONFIG_IPDDP_ENCAP=y
CONFIG_IPDDP_DECAP=y
CONFIG_X25=m
CONFIG_LAPB=m
CONFIG_ECONET=m
CONFIG_ECONET_AUNUDP=y
CONFIG_ECONET_NATIVE=y
CONFIG_WAN_ROUTER=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_INGRESS=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
# CONFIG_CLS_U32_PERF is not set
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
# CONFIG_NET_ACT_SKBEDIT is not set
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
CONFIG_NET_TCPPROBE=m
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
CONFIG_BT_L2CAP=m
CONFIG_BT_SCO=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIDTL1=m
CONFIG_BT_HCIBT3C=m
CONFIG_BT_HCIBLUECARD=m
CONFIG_BT_HCIBTUART=m
CONFIG_BT_HCIVHCI=m
CONFIG_AF_RXRPC=m
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=m
# CONFIG_PHONET is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=m
CONFIG_NL80211=y
CONFIG_WIRELESS_OLD_REGULATORY=y
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_MAC80211=m

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_PID=y
# CONFIG_MAC80211_RC_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT_PID=y
# CONFIG_MAC80211_RC_DEFAULT_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT="pid"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_IEEE80211=m
# CONFIG_IEEE80211_DEBUG is not set
CONFIG_IEEE80211_CRYPT_WEP=m
CONFIG_IEEE80211_CRYPT_CCMP=m
CONFIG_IEEE80211_CRYPT_TKIP=m
CONFIG_RFKILL=m
CONFIG_RFKILL_INPUT=m
CONFIG_RFKILL_LEDS=y
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_MTD=m
# CONFIG_MTD_DEBUG is not set
CONFIG_MTD_CONCAT=m
CONFIG_MTD_PARTITIONS=y
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
CONFIG_MTD_CHAR=m
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
CONFIG_MTD_BLOCK_RO=m
CONFIG_FTL=m
CONFIG_NFTL=m
CONFIG_NFTL_RW=y
CONFIG_INFTL=m
CONFIG_RFD_FTL=m
CONFIG_SSFDC=m
CONFIG_MTD_OOPS=m

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_CFI_INTELEXT=m
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=m
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=m
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0x4000000
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
CONFIG_MTD_SC520CDP=m
CONFIG_MTD_NETSC520=m
CONFIG_MTD_TS5500=m
CONFIG_MTD_SBC_GXX=m
CONFIG_MTD_AMD76XROM=m
CONFIG_MTD_ICHXROM=m
CONFIG_MTD_ESB2ROM=m
CONFIG_MTD_CK804XROM=m
CONFIG_MTD_SCB2_FLASH=m
CONFIG_MTD_NETtel=m
CONFIG_MTD_DILNETPC=m
CONFIG_MTD_DILNETPC_BOOTSIZE=0x80000
CONFIG_MTD_L440GX=m
CONFIG_MTD_PCI=m
CONFIG_MTD_INTEL_VR_NOR=m
CONFIG_MTD_PLATRAM=m

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=m
# CONFIG_MTD_PMC551_BUGFIX is not set
# CONFIG_MTD_PMC551_DEBUG is not set
CONFIG_MTD_DATAFLASH=m
# CONFIG_MTD_DATAFLASH_WRITE_VERIFY is not set
# CONFIG_MTD_DATAFLASH_OTP is not set
CONFIG_MTD_M25P80=m
CONFIG_M25PXX_USE_FAST_READ=y
CONFIG_MTD_SLRAM=m
CONFIG_MTD_PHRAM=m
CONFIG_MTD_MTDRAM=m
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTD_BLOCK2MTD=m

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOC2000=m
CONFIG_MTD_DOC2001=m
CONFIG_MTD_DOC2001PLUS=m
CONFIG_MTD_DOCPROBE=m
CONFIG_MTD_DOCECC=m
# CONFIG_MTD_DOCPROBE_ADVANCED is not set
CONFIG_MTD_DOCPROBE_ADDRESS=0
CONFIG_MTD_NAND=m
# CONFIG_MTD_NAND_VERIFY_WRITE is not set
# CONFIG_MTD_NAND_ECC_SMC is not set
# CONFIG_MTD_NAND_MUSEUM_IDS is not set
CONFIG_MTD_NAND_IDS=m
CONFIG_MTD_NAND_DISKONCHIP=m
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
CONFIG_MTD_NAND_CAFE=m
CONFIG_MTD_NAND_NANDSIM=m
CONFIG_MTD_NAND_PLATFORM=m
CONFIG_MTD_ALAUDA=m
CONFIG_MTD_ONENAND=m
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
# CONFIG_MTD_ONENAND_OTP is not set
CONFIG_MTD_ONENAND_2X_PROGRAM=y
CONFIG_MTD_ONENAND_SIM=m

#
# UBI - Unsorted block images
#
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_RESERVE=1
CONFIG_MTD_UBI_GLUEBI=y

#
# UBI debugging options
#
# CONFIG_MTD_UBI_DEBUG is not set
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
CONFIG_PARPORT_PC_FIFO=y
# CONFIG_PARPORT_PC_SUPERIO is not set
CONFIG_PARPORT_PC_PCMCIA=m
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=m
CONFIG_PARIDE=m

#
# Parallel IDE high-level drivers
#
CONFIG_PARIDE_PD=m
CONFIG_PARIDE_PCD=m
CONFIG_PARIDE_PF=m
CONFIG_PARIDE_PT=m
CONFIG_PARIDE_PG=m

#
# Parallel IDE protocol modules
#
CONFIG_PARIDE_ATEN=m
CONFIG_PARIDE_BPCK=m
CONFIG_PARIDE_COMM=m
CONFIG_PARIDE_DSTR=m
CONFIG_PARIDE_FIT2=m
CONFIG_PARIDE_FIT3=m
CONFIG_PARIDE_EPAT=m
# CONFIG_PARIDE_EPATC8 is not set
CONFIG_PARIDE_EPIA=m
CONFIG_PARIDE_FRIQ=m
CONFIG_PARIDE_FRPW=m
CONFIG_PARIDE_KBIC=m
CONFIG_PARIDE_KTTI=m
CONFIG_PARIDE_ON20=m
CONFIG_PARIDE_ON26=m
CONFIG_BLK_CPQ_DA=m
CONFIG_BLK_CPQ_CISS_DA=m
CONFIG_CISS_SCSI_TAPE=y
CONFIG_BLK_DEV_DAC960=m
CONFIG_BLK_DEV_UMEM=m
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_SX8=m
CONFIG_BLK_DEV_UB=m
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=65536
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=m
CONFIG_VIRTIO_BLK=m
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
CONFIG_IBM_ASM=m
CONFIG_PHANTOM=m
CONFIG_EEPROM_93CX6=m
CONFIG_SGI_IOC4=m
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
CONFIG_ACER_WMI=m
CONFIG_ASUS_LAPTOP=m
CONFIG_FUJITSU_LAPTOP=m
# CONFIG_FUJITSU_LAPTOP_DEBUG is not set
CONFIG_HP_WMI=m
CONFIG_MSI_LAPTOP=m
# CONFIG_PANASONIC_LAPTOP is not set
CONFIG_COMPAL_LAPTOP=m
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
CONFIG_THINKPAD_ACPI=m
# CONFIG_THINKPAD_ACPI_DEBUG is not set
CONFIG_THINKPAD_ACPI_BAY=y
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_INTEL_MENLOW=m
CONFIG_EEEPC_LAPTOP=m
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_SGI_XP=m
CONFIG_HP_ILO=m
CONFIG_SGI_GRU=m
# CONFIG_SGI_GRU_DEBUG is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
CONFIG_BLK_DEV_3W_XXXX_RAID=m
CONFIG_SCSI_3W_9XXX=m
CONFIG_SCSI_ACARD=m
CONFIG_SCSI_AACRAID=m
CONFIG_SCSI_AIC7XXX=m
CONFIG_AIC7XXX_CMDS_PER_DEVICE=8
CONFIG_AIC7XXX_RESET_DELAY_MS=15000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC7XXX_OLD is not set
CONFIG_SCSI_AIC79XX=m
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=15000
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC94XX=m
# CONFIG_AIC94XX_DEBUG is not set
CONFIG_SCSI_DPT_I2O=m
CONFIG_SCSI_ADVANSYS=m
CONFIG_SCSI_ARCMSR=m
CONFIG_SCSI_ARCMSR_AER=y
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=m
CONFIG_MEGARAID_MAILBOX=m
CONFIG_MEGARAID_LEGACY=m
CONFIG_MEGARAID_SAS=m
CONFIG_SCSI_HPTIOP=m
CONFIG_SCSI_BUSLOGIC=m
CONFIG_SCSI_DMX3191D=m
CONFIG_SCSI_EATA=m
CONFIG_SCSI_EATA_TAGGED_QUEUE=y
CONFIG_SCSI_EATA_LINKED_COMMANDS=y
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=m
CONFIG_SCSI_GDTH=m
CONFIG_SCSI_IPS=m
CONFIG_SCSI_INITIO=m
CONFIG_SCSI_INIA100=m
CONFIG_SCSI_PPA=m
CONFIG_SCSI_IMM=m
# CONFIG_SCSI_IZIP_EPP16 is not set
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
# CONFIG_SCSI_MVSAS is not set
CONFIG_SCSI_STEX=m
CONFIG_SCSI_SYM53C8XX_2=m
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
CONFIG_SCSI_IPR=m
# CONFIG_SCSI_IPR_TRACE is not set
# CONFIG_SCSI_IPR_DUMP is not set
CONFIG_SCSI_QLOGIC_1280=m
CONFIG_SCSI_QLA_FC=m
CONFIG_SCSI_QLA_ISCSI=m
CONFIG_SCSI_LPFC=m
CONFIG_SCSI_DC395x=m
CONFIG_SCSI_DC390T=m
CONFIG_SCSI_DEBUG=m
CONFIG_SCSI_SRP=m
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_PCMCIA_FDOMAIN=m
CONFIG_PCMCIA_QLOGIC=m
CONFIG_PCMCIA_SYM53C500=m
CONFIG_SCSI_DH=m
# CONFIG_SCSI_DH_RDAC is not set
# CONFIG_SCSI_DH_HP_SW is not set
# CONFIG_SCSI_DH_EMC is not set
# CONFIG_SCSI_DH_ALUA is not set
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=m
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y
CONFIG_SATA_SVW=m
CONFIG_ATA_PIIX=m
CONFIG_SATA_MV=m
CONFIG_SATA_NV=m
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=m
CONFIG_SATA_PROMISE=m
CONFIG_SATA_SX4=m
CONFIG_SATA_SIL=m
CONFIG_SATA_SIS=m
CONFIG_SATA_ULI=m
CONFIG_SATA_VIA=m
CONFIG_SATA_VITESSE=m
CONFIG_SATA_INIC162X=m
CONFIG_PATA_ACPI=m
CONFIG_PATA_ALI=m
CONFIG_PATA_AMD=m
CONFIG_PATA_ARTOP=m
CONFIG_PATA_ATIIXP=m
# CONFIG_PATA_CMD640_PCI is not set
CONFIG_PATA_CMD64X=m
CONFIG_PATA_CS5520=m
CONFIG_PATA_CS5530=m
# CONFIG_PATA_CYPRESS is not set
CONFIG_PATA_EFAR=m
CONFIG_ATA_GENERIC=m
CONFIG_PATA_HPT366=m
CONFIG_PATA_HPT37X=m
# CONFIG_PATA_HPT3X2N is not set
CONFIG_PATA_HPT3X3=m
# CONFIG_PATA_HPT3X3_DMA is not set
CONFIG_PATA_IT821X=m
CONFIG_PATA_IT8213=m
CONFIG_PATA_JMICRON=m
CONFIG_PATA_TRIFLEX=m
CONFIG_PATA_MARVELL=m
CONFIG_PATA_MPIIX=m
CONFIG_PATA_OLDPIIX=m
CONFIG_PATA_NETCELL=m
CONFIG_PATA_NINJA32=m
CONFIG_PATA_NS87410=m
CONFIG_PATA_NS87415=m
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
CONFIG_PATA_PCMCIA=m
CONFIG_PATA_PDC_OLD=m
# CONFIG_PATA_RADISYS is not set
CONFIG_PATA_RZ1000=m
# CONFIG_PATA_SC1200 is not set
CONFIG_PATA_SERVERWORKS=m
CONFIG_PATA_PDC2027X=m
CONFIG_PATA_SIL680=m
CONFIG_PATA_SIS=m
CONFIG_PATA_VIA=m
CONFIG_PATA_WINBOND=m
CONFIG_PATA_SCH=m
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_RAID5_RESHAPE=y
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
CONFIG_I2O=m
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_EXT_ADAPTEC_DMA64=y
CONFIG_I2O_CONFIG=m
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=m
CONFIG_I2O_BLOCK=m
CONFIG_I2O_SCSI=m
CONFIG_I2O_PROC=m
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_IFB=m
CONFIG_DUMMY=m
CONFIG_BONDING=m
CONFIG_MACVLAN=m
CONFIG_EQUALIZER=m
CONFIG_TUN=m
CONFIG_VETH=m
CONFIG_NET_SB1000=m
CONFIG_ARCNET=m
CONFIG_ARCNET_1201=m
CONFIG_ARCNET_1051=m
CONFIG_ARCNET_RAW=m
CONFIG_ARCNET_CAP=m
CONFIG_ARCNET_COM90xx=m
CONFIG_ARCNET_COM90xxIO=m
CONFIG_ARCNET_RIM_I=m
CONFIG_ARCNET_COM20020=m
CONFIG_ARCNET_COM20020_PCI=m
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=m
CONFIG_CICADA_PHY=m
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_BROADCOM_PHY=m
CONFIG_ICPLUS_PHY=m
# CONFIG_REALTEK_PHY is not set
CONFIG_MDIO_BITBANG=m
CONFIG_NET_ETHERNET=y
CONFIG_MII=m
CONFIG_HAPPYMEAL=m
CONFIG_SUNGEM=m
CONFIG_CASSINI=m
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=m
CONFIG_TYPHOON=m
# CONFIG_ENC28J60 is not set
CONFIG_NET_TULIP=y
CONFIG_DE2104X=m
CONFIG_TULIP=m
# CONFIG_TULIP_MWI is not set
# CONFIG_TULIP_MMIO is not set
# CONFIG_TULIP_NAPI is not set
CONFIG_DE4X5=m
CONFIG_WINBOND_840=m
CONFIG_DM9102=m
CONFIG_ULI526X=m
CONFIG_PCMCIA_XIRCOM=m
CONFIG_HP100=m
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=m
CONFIG_AMD8111_ETH=m
CONFIG_ADAPTEC_STARFIRE=m
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=m
# CONFIG_FORCEDETH_NAPI is not set
CONFIG_EEPRO100=m
CONFIG_E100=m
CONFIG_FEALNX=m
CONFIG_NATSEMI=m
CONFIG_NE2K_PCI=m
CONFIG_8139CP=m
CONFIG_8139TOO=m
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
# CONFIG_R6040 is not set
CONFIG_SIS900=m
CONFIG_EPIC100=m
CONFIG_SUNDANCE=m
# CONFIG_SUNDANCE_MMIO is not set
CONFIG_TLAN=m
CONFIG_VIA_RHINE=m
CONFIG_VIA_RHINE_MMIO=y
CONFIG_SC92031=m
CONFIG_NET_POCKET=y
CONFIG_ATP=m
CONFIG_DE600=m
CONFIG_DE620=m
CONFIG_ATL2=m
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=m
# CONFIG_ACENIC_OMIT_TIGON_I is not set
# CONFIG_DL2K is not set
CONFIG_E1000=m
CONFIG_E1000E=m
CONFIG_IP1000=m
CONFIG_IGB=m
# CONFIG_IGB_LRO is not set
CONFIG_IGB_DCA=y
CONFIG_NS83820=m
CONFIG_HAMACHI=m
CONFIG_YELLOWFIN=m
CONFIG_R8169=m
CONFIG_R8169_VLAN=y
CONFIG_SIS190=m
CONFIG_SKGE=m
# CONFIG_SKGE_DEBUG is not set
CONFIG_SKY2=m
# CONFIG_SKY2_DEBUG is not set
CONFIG_VIA_VELOCITY=m
CONFIG_TIGON3=m
CONFIG_BNX2=m
CONFIG_QLA3XXX=m
CONFIG_ATL1=m
CONFIG_ATL1E=m
# CONFIG_JME is not set
CONFIG_NETDEV_10000=y
CONFIG_CHELSIO_T1=m
CONFIG_CHELSIO_T1_1G=y
CONFIG_CHELSIO_T3=m
# CONFIG_ENIC is not set
CONFIG_IXGBE=m
CONFIG_IXGBE_DCA=y
CONFIG_IXGB=m
CONFIG_S2IO=m
CONFIG_MYRI10GE=m
CONFIG_MYRI10GE_DCA=y
CONFIG_NETXEN_NIC=m
CONFIG_NIU=m
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
CONFIG_TEHUTI=m
CONFIG_BNX2X=m
# CONFIG_QLGE is not set
CONFIG_SFC=m
CONFIG_TR=y
CONFIG_IBMOL=m
CONFIG_3C359=m
CONFIG_TMS380TR=m
CONFIG_TMSPCI=m
CONFIG_ABYSS=m

#
# Wireless LAN
#
CONFIG_WLAN_PRE80211=y
CONFIG_STRIP=m
CONFIG_PCMCIA_WAVELAN=m
CONFIG_PCMCIA_NETWAVE=m
CONFIG_WLAN_80211=y
CONFIG_PCMCIA_RAYCS=m
CONFIG_IPW2100=m
CONFIG_IPW2100_MONITOR=y
# CONFIG_IPW2100_DEBUG is not set
CONFIG_IPW2200=m
CONFIG_IPW2200_MONITOR=y
CONFIG_IPW2200_RADIOTAP=y
CONFIG_IPW2200_PROMISCUOUS=y
CONFIG_IPW2200_QOS=y
# CONFIG_IPW2200_DEBUG is not set
CONFIG_LIBERTAS=m
CONFIG_LIBERTAS_USB=m
CONFIG_LIBERTAS_CS=m
CONFIG_LIBERTAS_SDIO=m
# CONFIG_LIBERTAS_DEBUG is not set
# CONFIG_LIBERTAS_THINFIRM is not set
CONFIG_AIRO=m
CONFIG_HERMES=m
CONFIG_PLX_HERMES=m
CONFIG_TMD_HERMES=m
CONFIG_NORTEL_HERMES=m
CONFIG_PCI_HERMES=m
CONFIG_PCMCIA_HERMES=m
CONFIG_PCMCIA_SPECTRUM=m
CONFIG_ATMEL=m
CONFIG_PCI_ATMEL=m
CONFIG_PCMCIA_ATMEL=m
CONFIG_AIRO_CS=m
CONFIG_PCMCIA_WL3501=m
CONFIG_PRISM54=m
CONFIG_USB_ZD1201=m
CONFIG_USB_NET_RNDIS_WLAN=m
CONFIG_RTL8180=m
CONFIG_RTL8187=m
CONFIG_ADM8211=m
# CONFIG_MAC80211_HWSIM is not set
CONFIG_P54_COMMON=m
CONFIG_P54_USB=m
CONFIG_P54_PCI=m
# CONFIG_ATH5K is not set
CONFIG_ATH9K=m
CONFIG_IWLWIFI=m
CONFIG_IWLCORE=m
CONFIG_IWLWIFI_LEDS=y
CONFIG_IWLWIFI_RFKILL=y
# CONFIG_IWLWIFI_DEBUG is not set
CONFIG_IWLAGN=m
CONFIG_IWLAGN_SPECTRUM_MEASUREMENT=y
CONFIG_IWLAGN_LEDS=y
CONFIG_IWL4965=y
CONFIG_IWL5000=y
CONFIG_IWL3945=m
CONFIG_IWL3945_RFKILL=y
CONFIG_IWL3945_SPECTRUM_MEASUREMENT=y
CONFIG_IWL3945_LEDS=y
# CONFIG_IWL3945_DEBUG is not set
CONFIG_HOSTAP=m
CONFIG_HOSTAP_FIRMWARE=y
CONFIG_HOSTAP_FIRMWARE_NVRAM=y
CONFIG_HOSTAP_PLX=m
CONFIG_HOSTAP_PCI=m
CONFIG_HOSTAP_CS=m
CONFIG_B43=m
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
# CONFIG_B43_PCMCIA is not set
CONFIG_B43_LEDS=y
CONFIG_B43_RFKILL=y
# CONFIG_B43_DEBUG is not set
CONFIG_B43LEGACY=m
CONFIG_B43LEGACY_PCI_AUTOSELECT=y
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
CONFIG_B43LEGACY_LEDS=y
CONFIG_B43LEGACY_RFKILL=y
CONFIG_B43LEGACY_DEBUG=y
CONFIG_B43LEGACY_DMA=y
CONFIG_B43LEGACY_PIO=y
CONFIG_B43LEGACY_DMA_AND_PIO_MODE=y
# CONFIG_B43LEGACY_DMA_MODE is not set
# CONFIG_B43LEGACY_PIO_MODE is not set
CONFIG_ZD1211RW=m
# CONFIG_ZD1211RW_DEBUG is not set
# CONFIG_RT2X00 is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=m
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_DM9601=m
# CONFIG_USB_NET_SMSC95XX is not set
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=m
CONFIG_USB_HSO=m
CONFIG_NET_PCMCIA=y
CONFIG_PCMCIA_3C589=m
CONFIG_PCMCIA_3C574=m
CONFIG_PCMCIA_FMVJ18X=m
CONFIG_PCMCIA_PCNET=m
CONFIG_PCMCIA_NMCLAN=m
CONFIG_PCMCIA_SMC91C92=m
CONFIG_PCMCIA_XIRC2PS=m
CONFIG_PCMCIA_AXNET=m
CONFIG_ARCNET_COM20020_CS=m
# CONFIG_PCMCIA_IBMTR is not set
CONFIG_WAN=y
CONFIG_LANMEDIA=m
CONFIG_HDLC=m
CONFIG_HDLC_RAW=m
CONFIG_HDLC_RAW_ETH=m
CONFIG_HDLC_CISCO=m
CONFIG_HDLC_FR=m
CONFIG_HDLC_PPP=m
CONFIG_HDLC_X25=m
CONFIG_PCI200SYN=m
CONFIG_WANXL=m
# CONFIG_PC300TOO is not set
CONFIG_FARSYNC=m
CONFIG_DSCC4=m
CONFIG_DSCC4_PCISYNC=y
CONFIG_DSCC4_PCI_RST=y
CONFIG_DLCI=m
CONFIG_DLCI_MAX=8
CONFIG_WAN_ROUTER_DRIVERS=m
CONFIG_CYCLADES_SYNC=m
CONFIG_CYCLOMX_X25=y
CONFIG_LAPBETHER=m
CONFIG_X25_ASY=m
CONFIG_SBNI=m
# CONFIG_SBNI_MULTILINE is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
CONFIG_ATM_TCP=m
CONFIG_ATM_LANAI=m
CONFIG_ATM_ENI=m
# CONFIG_ATM_ENI_DEBUG is not set
# CONFIG_ATM_ENI_TUNE_BURST is not set
CONFIG_ATM_FIRESTREAM=m
CONFIG_ATM_ZATM=m
# CONFIG_ATM_ZATM_DEBUG is not set
CONFIG_ATM_IDT77252=m
# CONFIG_ATM_IDT77252_DEBUG is not set
# CONFIG_ATM_IDT77252_RCV_ALL is not set
CONFIG_ATM_IDT77252_USE_SUNI=y
CONFIG_ATM_AMBASSADOR=m
# CONFIG_ATM_AMBASSADOR_DEBUG is not set
CONFIG_ATM_HORIZON=m
# CONFIG_ATM_HORIZON_DEBUG is not set
CONFIG_ATM_IA=m
# CONFIG_ATM_IA_DEBUG is not set
CONFIG_ATM_FORE200E=m
# CONFIG_ATM_FORE200E_USE_TASKLET is not set
CONFIG_ATM_FORE200E_TX_RETRY=16
CONFIG_ATM_FORE200E_DEBUG=0
CONFIG_ATM_HE=m
CONFIG_ATM_HE_USE_SUNI=y
CONFIG_FDDI=y
CONFIG_DEFXX=m
# CONFIG_DEFXX_MMIO is not set
CONFIG_SKFP=m
CONFIG_HIPPI=y
CONFIG_ROADRUNNER=m
# CONFIG_ROADRUNNER_LARGE_RINGS is not set
CONFIG_PLIP=m
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_MPPE=m
CONFIG_PPPOE=m
CONFIG_PPPOATM=m
CONFIG_PPPOL2TP=m
CONFIG_SLIP=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLHC=m
CONFIG_SLIP_SMART=y
CONFIG_SLIP_MODE_SLIP6=y
CONFIG_NET_FC=y
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_VIRTIO_NET=m
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=m
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_SUNKBD=m
CONFIG_KEYBOARD_LKKBD=m
CONFIG_KEYBOARD_XTKBD=m
CONFIG_KEYBOARD_NEWTON=m
CONFIG_KEYBOARD_STOWAWAY=m
CONFIG_KEYBOARD_GPIO=m
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=m
CONFIG_MOUSE_BCM5974=m
CONFIG_MOUSE_VSXXXAA=m
CONFIG_MOUSE_GPIO=m
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
CONFIG_JOYSTICK_A3D=m
CONFIG_JOYSTICK_ADI=m
CONFIG_JOYSTICK_COBRA=m
CONFIG_JOYSTICK_GF2K=m
CONFIG_JOYSTICK_GRIP=m
CONFIG_JOYSTICK_GRIP_MP=m
CONFIG_JOYSTICK_GUILLEMOT=m
CONFIG_JOYSTICK_INTERACT=m
CONFIG_JOYSTICK_SIDEWINDER=m
CONFIG_JOYSTICK_TMDC=m
CONFIG_JOYSTICK_IFORCE=m
CONFIG_JOYSTICK_IFORCE_USB=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=m
CONFIG_JOYSTICK_MAGELLAN=m
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=m
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=m
CONFIG_JOYSTICK_ZHENHUA=m
CONFIG_JOYSTICK_DB9=m
CONFIG_JOYSTICK_GAMECON=m
CONFIG_JOYSTICK_TURBOGRAFX=m
CONFIG_JOYSTICK_JOYDUMP=m
CONFIG_JOYSTICK_XPAD=m
CONFIG_JOYSTICK_XPAD_FF=y
CONFIG_JOYSTICK_XPAD_LEDS=y
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=m
CONFIG_TABLET_USB_KBTAB=m
CONFIG_TABLET_USB_WACOM=m
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=m
CONFIG_TOUCHSCREEN_FUJITSU=m
CONFIG_TOUCHSCREEN_GUNZE=m
CONFIG_TOUCHSCREEN_ELO=m
CONFIG_TOUCHSCREEN_MTOUCH=m
CONFIG_TOUCHSCREEN_INEXIO=m
CONFIG_TOUCHSCREEN_MK712=m
CONFIG_TOUCHSCREEN_PENMOUNT=m
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
CONFIG_TOUCHSCREEN_TOUCHWIN=m
CONFIG_TOUCHSCREEN_WM97XX=m
CONFIG_TOUCHSCREEN_WM9705=y
CONFIG_TOUCHSCREEN_WM9712=y
CONFIG_TOUCHSCREEN_WM9713=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_TOUCHIT213=m
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_APANEL is not set
CONFIG_INPUT_ATLAS_BTNS=m
CONFIG_INPUT_ATI_REMOTE=m
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PARKBD=m
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=m
CONFIG_GAMEPORT_EMU10K1=m
CONFIG_GAMEPORT_FM801=m

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_DEVKMEM=y
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_COMPUTONE=m
CONFIG_ROCKETPORT=m
CONFIG_CYCLADES=m
# CONFIG_CYZ_INTR is not set
CONFIG_DIGIEPCA=m
CONFIG_MOXA_INTELLIO=m
CONFIG_MOXA_SMARTIO=m
# CONFIG_ISI is not set
CONFIG_SYNCLINK=m
CONFIG_SYNCLINKMP=m
CONFIG_SYNCLINK_GT=m
CONFIG_N_HDLC=m
CONFIG_RISCOM8=m
CONFIG_SPECIALIX=m
CONFIG_SX=m
CONFIG_RIO=m
# CONFIG_RIO_OLDPCI is not set
CONFIG_STALDRV=y
# CONFIG_STALLION is not set
# CONFIG_ISTALLION is not set
CONFIG_NOZOMI=m

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=48
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_CONSOLE_POLL=y
CONFIG_SERIAL_JSM=m
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_VIRTIO=m
CONFIG_NVRAM=m
CONFIG_R3964=m
CONFIG_APPLICOM=m

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=m
CONFIG_IPWIRELESS=m
CONFIG_MWAVE=m
CONFIG_PC8736x_GPIO=m
CONFIG_NSC_GPIO=m
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=m
CONFIG_TCG_TIS=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
# CONFIG_I2C_HELPER_AUTO is not set

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=m
CONFIG_I2C_ALI1563=m
CONFIG_I2C_ALI15X3=m
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
CONFIG_I2C_SIS5595=m
CONFIG_I2C_SIS630=m
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_GPIO=m
CONFIG_I2C_OCORES=m
CONFIG_I2C_SIMTEC=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_TAOS_EVM=m
CONFIG_I2C_TINY_USB=m

#
# Graphics adapter I2C/DDC channel drivers
#
CONFIG_I2C_VOODOO3=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_PLATFORM=m
CONFIG_I2C_STUB=m

#
# Miscellaneous I2C Chip support
#
CONFIG_DS1682=m
CONFIG_AT24=m
CONFIG_SENSORS_EEPROM=m
CONFIG_SENSORS_PCF8591=m
CONFIG_TPS65010=m
CONFIG_SENSORS_MAX6875=m
CONFIG_SENSORS_TSL2550=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_BITBANG=m
CONFIG_SPI_BUTTERFLY=m
CONFIG_SPI_LM70_LLP=m

#
# SPI Protocol Masters
#
CONFIG_SPI_AT25=m
CONFIG_SPI_SPIDEV=m
CONFIG_SPI_TLE62X0=m
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX732X=m
CONFIG_GPIO_PCA953X=m
CONFIG_GPIO_PCF857X=m

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=m
CONFIG_GPIO_MCP23S08=m
CONFIG_W1=m
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=m
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=m
CONFIG_W1_SLAVE_DS2433=m
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=m
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=m
CONFIG_BATTERY_DS2760=m
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADCXX=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7473=m
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHER=m
CONFIG_SENSORS_FSCPOS=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM70=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
# CONFIG_SENSORS_MAX1111 is not set
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_HDAPS=m
CONFIG_SENSORS_APPLESMC=m
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_WATCHDOG is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
# CONFIG_SSB_PCMCIAHOST is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_UCB1400_CORE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM8350_I2C is not set

#
# Voltage and Current regulators
#
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_FIXED_VOLTAGE is not set
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
# CONFIG_REGULATOR_BQ24022 is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_DVB_CORE=m
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=m
# CONFIG_MEDIA_TUNER_CUSTOMIZE is not set
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L1=m
# CONFIG_VIDEO_CAPTURE_DRIVERS is not set
# CONFIG_RADIO_ADAPTERS is not set
# CONFIG_DVB_CAPTURE_DRIVERS is not set
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=m
CONFIG_AGP_SIS=m
CONFIG_AGP_VIA=m
CONFIG_DRM=m
CONFIG_DRM_TDFX=m
CONFIG_DRM_R128=m
CONFIG_DRM_RADEON=m
CONFIG_DRM_I810=m
CONFIG_DRM_I830=m
CONFIG_DRM_I915=m
CONFIG_DRM_MGA=m
CONFIG_DRM_SIS=m
CONFIG_DRM_VIA=m
CONFIG_DRM_SAVAGE=m
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=m
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=m
CONFIG_FB_PM2=m
CONFIG_FB_PM2_FIFO_DISCONNECT=y
CONFIG_FB_CYBER2000=m
CONFIG_FB_ARC=m
CONFIG_FB_ASILIANT=y
CONFIG_FB_IMSTT=y
CONFIG_FB_VGA16=m
CONFIG_FB_UVESA=m
# CONFIG_FB_VESA is not set
CONFIG_FB_EFI=y
CONFIG_FB_N411=m
CONFIG_FB_HGA=m
# CONFIG_FB_HGA_ACCEL is not set
CONFIG_FB_S1D13XXX=m
CONFIG_FB_NVIDIA=m
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=m
CONFIG_FB_RIVA_I2C=y
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_LE80578=m
CONFIG_FB_CARILLO_RANCH=m
CONFIG_FB_INTEL=m
# CONFIG_FB_INTEL_DEBUG is not set
CONFIG_FB_INTEL_I2C=y
CONFIG_FB_MATROX=m
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=m
CONFIG_FB_MATROX_MAVEN=m
CONFIG_FB_MATROX_MULTIHEAD=y
CONFIG_FB_RADEON=m
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=m
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=m
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
CONFIG_FB_S3=m
CONFIG_FB_SAVAGE=m
CONFIG_FB_SAVAGE_I2C=y
CONFIG_FB_SAVAGE_ACCEL=y
CONFIG_FB_SIS=m
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
# CONFIG_FB_VIA is not set
CONFIG_FB_NEOMAGIC=m
CONFIG_FB_KYRO=m
CONFIG_FB_3DFX=m
# CONFIG_FB_3DFX_ACCEL is not set
CONFIG_FB_VOODOO1=m
CONFIG_FB_VT8623=m
CONFIG_FB_TRIDENT=m
# CONFIG_FB_TRIDENT_ACCEL is not set
CONFIG_FB_ARK=m
CONFIG_FB_PM3=m
CONFIG_FB_CARMINE=m
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=m
CONFIG_FB_GEODE_GX=m
CONFIG_FB_GEODE_GX1=m
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_LCD_LTV350QV=m
CONFIG_LCD_ILI9320=m
# CONFIG_LCD_TDO24M is not set
CONFIG_LCD_VGG2432A4=m
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_CORGI=m
CONFIG_BACKLIGHT_PROGEAR=m
CONFIG_BACKLIGHT_CARILLO_RANCH=m
CONFIG_BACKLIGHT_MBP_NVIDIA=m
# CONFIG_BACKLIGHT_SAHARA is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=m

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=m
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_LOGO is not set
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_VX_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=m
CONFIG_SND_DUMMY=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
CONFIG_SND_MTS64=m
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m
CONFIG_SND_PORTMAN2X4=m
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0
CONFIG_SND_SB_COMMON=m
CONFIG_SND_SB16_DSP=m
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=m
CONFIG_SND_ALS300=m
CONFIG_SND_ALS4000=m
CONFIG_SND_ALI5451=m
CONFIG_SND_ATIIXP=m
CONFIG_SND_ATIIXP_MODEM=m
CONFIG_SND_AU8810=m
CONFIG_SND_AU8820=m
CONFIG_SND_AU8830=m
CONFIG_SND_AW2=m
CONFIG_SND_AZT3328=m
CONFIG_SND_BT87X=m
# CONFIG_SND_BT87X_OVERCLOCK is not set
CONFIG_SND_CA0106=m
CONFIG_SND_CMIPCI=m
CONFIG_SND_OXYGEN_LIB=m
CONFIG_SND_OXYGEN=m
CONFIG_SND_CS4281=m
CONFIG_SND_CS46XX=m
CONFIG_SND_CS46XX_NEW_DSP=y
CONFIG_SND_CS5530=m
CONFIG_SND_DARLA20=m
CONFIG_SND_GINA20=m
CONFIG_SND_LAYLA20=m
CONFIG_SND_DARLA24=m
CONFIG_SND_GINA24=m
CONFIG_SND_LAYLA24=m
CONFIG_SND_MONA=m
CONFIG_SND_MIA=m
CONFIG_SND_ECHO3G=m
CONFIG_SND_INDIGO=m
CONFIG_SND_INDIGOIO=m
CONFIG_SND_INDIGODJ=m
CONFIG_SND_EMU10K1=m
CONFIG_SND_EMU10K1X=m
CONFIG_SND_ENS1370=m
CONFIG_SND_ENS1371=m
CONFIG_SND_ES1938=m
CONFIG_SND_ES1968=m
CONFIG_SND_FM801=m
CONFIG_SND_FM801_TEA575X_BOOL=y
CONFIG_SND_FM801_TEA575X=m
CONFIG_SND_HDA_INTEL=m
# CONFIG_SND_HDA_HWDEP is not set
# CONFIG_SND_HDA_INPUT_BEEP is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_ATIHDMI=y
CONFIG_SND_HDA_CODEC_NVHDMI=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
CONFIG_SND_HDSP=m
CONFIG_SND_HDSPM=m
CONFIG_SND_HIFIER=m
CONFIG_SND_ICE1712=m
CONFIG_SND_ICE1724=m
CONFIG_SND_INTEL8X0=m
CONFIG_SND_INTEL8X0M=m
CONFIG_SND_KORG1212=m
CONFIG_SND_MAESTRO3=m
CONFIG_SND_MIXART=m
CONFIG_SND_NM256=m
CONFIG_SND_PCXHR=m
CONFIG_SND_RIPTIDE=m
CONFIG_SND_RME32=m
CONFIG_SND_RME96=m
CONFIG_SND_RME9652=m
CONFIG_SND_SONICVIBES=m
CONFIG_SND_TRIDENT=m
CONFIG_SND_VIA82XX=m
CONFIG_SND_VIA82XX_MODEM=m
CONFIG_SND_VIRTUOSO=m
CONFIG_SND_VX222=m
CONFIG_SND_YMFPCI=m
CONFIG_SND_SPI=y
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
CONFIG_SND_USB_USX2Y=m
CONFIG_SND_USB_CAIAQ=m
CONFIG_SND_USB_CAIAQ_INPUT=y
# CONFIG_SND_USB_US122L is not set
CONFIG_SND_PCMCIA=y
CONFIG_SND_VXPOCKET=m
CONFIG_SND_PDAUDIOCF=m
CONFIG_SND_SOC=m
# CONFIG_SND_SOC_ALL_CODECS is not set
CONFIG_SOUND_PRIME=m
CONFIG_SOUND_OSS=m
# CONFIG_SOUND_TRACEINIT is not set
CONFIG_SOUND_DMAP=y
CONFIG_SOUND_SSCAPE=m
CONFIG_SOUND_VMIDI=m
CONFIG_SOUND_TRIX=m
CONFIG_SOUND_MSS=m
CONFIG_SOUND_MPU401=m
CONFIG_SOUND_PAS=m
CONFIG_SOUND_PSS=m
CONFIG_PSS_MIXER=y
# CONFIG_PSS_HAVE_BOOT is not set
CONFIG_SOUND_SB=m
CONFIG_SOUND_YM3812=m
CONFIG_SOUND_UART6850=m
CONFIG_SOUND_AEDSP16=m
CONFIG_SC6600=y
CONFIG_SC6600_JOY=y
CONFIG_SC6600_CDROM=4
CONFIG_SC6600_CDROMBASE=0
CONFIG_SOUND_KAHLUA=m
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=m
# CONFIG_HID_DEBUG is not set
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=m
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=y

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=m
CONFIG_USB_MOUSE=m

#
# Special HID drivers
#
CONFIG_HID_COMPAT=y
CONFIG_HID_A4TECH=m
CONFIG_HID_APPLE=m
CONFIG_HID_BELKIN=m
CONFIG_HID_BRIGHT=m
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
CONFIG_HID_CYPRESS=m
CONFIG_HID_DELL=m
CONFIG_HID_EZKEY=m
CONFIG_HID_GYRATION=m
CONFIG_HID_LOGITECH=m
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=m
CONFIG_HID_SUNPLUS=m
CONFIG_THRUSTMASTER_FF=m
CONFIG_ZEROPLUS_FF=m
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=m
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=m
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_ISP116X_HCD=m
CONFIG_USB_ISP1760_HCD=m
# CONFIG_USB_ISP1760_PCI is not set
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_HCD_SSB is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=m
CONFIG_USB_U132_HCD=m
CONFIG_USB_SL811_HCD=m
CONFIG_USB_SL811_CS=m
CONFIG_USB_R8A66597_HCD=m
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set
# CONFIG_USB_GADGET_MUSB_HDRC is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_DPCM=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
# CONFIG_USB_STORAGE_ONETOUCH is not set
CONFIG_USB_STORAGE_KARMA=y
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m

#
# USB port drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_SERIAL=m
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP2101=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_FUNSOFT=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
# CONFIG_USB_SERIAL_IR is not set
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
# CONFIG_USB_SERIAL_IUU is not set
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_MOTOROLA=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_HP4X=m
CONFIG_USB_SERIAL_SAFE=m
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
# CONFIG_USB_SEVSEG is not set
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
CONFIG_USB_BERRY_CHARGE=m
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=m
CONFIG_USB_CYTHERM=m
CONFIG_USB_PHIDGET=m
CONFIG_USB_PHIDGETKIT=m
CONFIG_USB_PHIDGETMOTORCONTROL=m
CONFIG_USB_PHIDGETSERVO=m
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
# CONFIG_USB_SISUSBVGA_CON is not set
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
CONFIG_USB_IOWARRIOR=m
# CONFIG_USB_TEST is not set
CONFIG_USB_ISIGHTFW=m
# CONFIG_USB_VST is not set
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=m
CONFIG_USB_GADGET=m
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FILES is not set
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_SELECTED=y
# CONFIG_USB_GADGET_AT91 is not set
# CONFIG_USB_GADGET_ATMEL_USBA is not set
# CONFIG_USB_GADGET_FSL_USB2 is not set
# CONFIG_USB_GADGET_LH7A40X is not set
# CONFIG_USB_GADGET_OMAP is not set
# CONFIG_USB_GADGET_PXA25X is not set
# CONFIG_USB_GADGET_PXA27X is not set
# CONFIG_USB_GADGET_S3C2410 is not set
# CONFIG_USB_GADGET_M66592 is not set
# CONFIG_USB_GADGET_AMD5536UDC is not set
# CONFIG_USB_GADGET_FSL_QE is not set
CONFIG_USB_GADGET_NET2280=y
CONFIG_USB_NET2280=m
# CONFIG_USB_GADGET_GOKU is not set
# CONFIG_USB_GADGET_DUMMY_HCD is not set
CONFIG_USB_GADGET_DUALSPEED=y
CONFIG_USB_ZERO=m
CONFIG_USB_ETH=m
CONFIG_USB_ETH_RNDIS=y
CONFIG_USB_GADGETFS=m
CONFIG_USB_FILE_STORAGE=m
# CONFIG_USB_FILE_STORAGE_TEST is not set
CONFIG_USB_G_SERIAL=m
# CONFIG_USB_MIDI_GADGET is not set
# CONFIG_USB_G_PRINTER is not set
CONFIG_USB_CDC_COMPOSITE=m
# CONFIG_UWB is not set
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=m
CONFIG_MMC_WBSD=m
CONFIG_MMC_TIFM_SD=m
CONFIG_MMC_SPI=m
CONFIG_MMC_SDRICOH_CS=m
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
CONFIG_LEDS_PCA9532=m
CONFIG_LEDS_GPIO=m
# CONFIG_LEDS_HP_DISK is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=m

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=m
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
# CONFIG_EDAC_X38 is not set
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=m

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1374=m
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T94=m
CONFIG_RTC_DRV_DS1305=m
CONFIG_RTC_DRV_MAX6902=m
# CONFIG_RTC_DRV_R9701 is not set
CONFIG_RTC_DRV_RS5C348=m
# CONFIG_RTC_DRV_DS3234 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_STK17TA8=m
CONFIG_RTC_DRV_M48T86=m
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=m
# CONFIG_RTC_DRV_BQ4802 is not set
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y

#
# DMA Devices
#
CONFIG_INTEL_IOATDMA=m
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
# CONFIG_DMATEST is not set
CONFIG_DCA=m
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=m
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=m
CONFIG_CFAG12864B_RATE=20
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV=m
CONFIG_UIO_PDRV_GENIRQ=m
CONFIG_UIO_SMX=m
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_STAGING is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_EFI_VARS=y
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=m
CONFIG_DMIID=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=m

#
# File systems
#
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=m
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4DEV_COMPAT=y
CONFIG_EXT4_FS_XATTR=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
CONFIG_JBD=m
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QFMT_V1=m
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
CONFIG_AUTOFS_FS=m
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
CONFIG_GENERIC_ACL=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m

#
# Miscellaneous filesystems
#
CONFIG_ADFS_FS=m
# CONFIG_ADFS_FS_RW is not set
CONFIG_AFFS_FS=m
CONFIG_ECRYPT_FS=m
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=m
CONFIG_BEFS_FS=m
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=m
CONFIG_EFS_FS=m
CONFIG_JFFS2_FS=m
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
# CONFIG_JFFS2_SUMMARY is not set
# CONFIG_JFFS2_FS_XATTR is not set
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
CONFIG_JFFS2_LZO=y
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
# CONFIG_JFFS2_CMODE_NONE is not set
# CONFIG_JFFS2_CMODE_PRIORITY is not set
# CONFIG_JFFS2_CMODE_SIZE is not set
CONFIG_JFFS2_CMODE_FAVOURLZO=y
CONFIG_UBIFS_FS=m
CONFIG_UBIFS_FS_XATTR=y
# CONFIG_UBIFS_FS_ADVANCED_COMPR is not set
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
# CONFIG_UBIFS_FS_DEBUG is not set
CONFIG_CRAMFS=y
CONFIG_VXFS_FS=m
CONFIG_MINIX_FS=m
CONFIG_OMFS_FS=m
CONFIG_HPFS_FS=m
CONFIG_QNX4FS_FS=m
CONFIG_ROMFS_FS=m
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=m
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
# CONFIG_SUNRPC_REGISTER_V4 is not set
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_RPCSEC_GSS_SPKM3=m
CONFIG_SMB_FS=m
# CONFIG_SMB_NLS_DEFAULT is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_EXPERIMENTAL=y
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
# CONFIG_ACORN_PARTITION_CUMANA is not set
# CONFIG_ACORN_PARTITION_EESOX is not set
CONFIG_ACORN_PARTITION_ICS=y
# CONFIG_ACORN_PARTITION_ADFS is not set
# CONFIG_ACORN_PARTITION_POWERTEC is not set
CONFIG_ACORN_PARTITION_RISCIX=y
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="cp437"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
# CONFIG_DLM_DEBUG is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_LKDTM is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_RING_BUFFER=y
CONFIG_TRACING=y

#
# Tracers
#
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
CONFIG_CONTEXT_SWITCH_TRACER=y
# CONFIG_BOOT_TRACER is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_PRINTK_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=y
# CONFIG_KGDB_TESTS is not set
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DIRECT_GBPAGES is not set
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_MMIOTRACE is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
CONFIG_SECURITY_FILE_CAPABILITIES=y
CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=0
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_ENABLE_SECMARK_DEFAULT is not set
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
CONFIG_SECURITY_SMACK=y
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_X86_64=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_X86_64=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_HIFN_795X=m
CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
CONFIG_KVM_AMD=m
# CONFIG_KVM_TRACE is not set
CONFIG_VIRTIO=m
CONFIG_VIRTIO_RING=m
CONFIG_VIRTIO_PCI=m
CONFIG_VIRTIO_BALLOON=m

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=m
CONFIG_LZO_DECOMPRESS=m
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y

--J/dobhs11T7y2rNN--
