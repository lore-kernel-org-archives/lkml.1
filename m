Return-Path: <linux-kernel-owner+w=401wt.eu-S2992879AbXCICCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992879AbXCICCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 21:02:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992863AbXCICCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 21:02:11 -0500
Received: from tapsys.com ([72.36.178.242]:39271 "EHLO tapsys.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992879AbXCICCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 21:02:06 -0500
Message-ID: <45F0C018.2020409@madrabbit.org>
Date: Thu, 08 Mar 2007 21:02:00 -0500
From: Ray Lee <ray-lk@madrabbit.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Odd suspend regression in 2.6.21-rc[123]
Content-Type: multipart/mixed;
 boundary="------------070303070806090508090900"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070303070806090508090900
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hey there,

In 2.6.21-rc1,2,3, my laptop will fully suspend to ram, but then
*immediately* resumes back from suspension. (It resumes just fine, as well.)

Nothing out of the ordinary is logged, and this happens even when
booting into init=/bin/sh with minimal modules loaded and executing
s2ram from that minimal environment.

I'm going to ponder the 2.6.20 to 2.6.21-rc1 changelog, but I'm hoping
someone with a clue can offer a suggestion before I end up bisecting the
whole thing. (Wouldn't be so bad, except I'm given to understand that
there are multiple places in those changes where nothing quite works
with respect to suspend.)

HP/Compaq NX6125 system, AMD64, dmesg attached.

Ray


--------------070303070806090508090900
Content-Type: text/plain;
 name="2.6.20-rc3.dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="2.6.20-rc3.dmesg"

[    0.000000] Linux version 2.6.21-rc3 (ray@phoenix) (gcc version 4.1.2 (Ubuntu 4.1.2-0ubuntu3)) #1 PREEMPT Thu Mar 8 09:09:11 PST 2007
[    0.000000] Command line: root=UUID=bf7dc35f-5eff-4a85-b398-590f37c5679e ro
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
[    0.000000] ACPI: RSDT 37FEFC84, 0034 (r1 HP     0944     10030620 HP          1)
[    0.000000] ACPI: FACP 37FEFC00, 0084 (r2 HP     0944            2 HP          1)
[    0.000000] ACPI: DSDT 37FEFD50, 755D (r1 HP        SB400    10000 MSFT  100000E)
[    0.000000] ACPI: FACS 37FFAE80, 0040
[    0.000000] ACPI: APIC 37FEFCB8, 005A (r1 HP     0944            1 HP          1)
[    0.000000] ACPI: MCFG 37FEFD14, 003C (r1 HP     0944            1 HP          1)
[    0.000000] ACPI: SSDT 37FF72AD, 0382 (r1 HP       HPQPpc     1001 MSFT  100000E)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 229328) 1 entries of 256 used
[    0.000000] No mptable found.
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   229328
[    0.000000] On node 0 totalpages: 229231
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 2213 pages reserved
[    0.000000]   DMA zone: 1730 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 3079 pages used for memmap
[    0.000000]   DMA32 zone: 222153 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
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
[    0.000000] Nosave address range: 000000000009f000 - 00000000000a0000
[    0.000000] Nosave address range: 00000000000a0000 - 00000000000e0000
[    0.000000] Nosave address range: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
[    0.000000] Built 1 zonelists.  Total pages: 223883
[    0.000000] Kernel command line: root=UUID=bf7dc35f-5eff-4a85-b398-590f37c5679e ro
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[   12.863367] time.c: Detected 2194.596 MHz processor.
[   12.864332] Console: colour VGA+ 80x25
[   12.867364] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[   12.867442] ... MAX_LOCKDEP_SUBCLASSES:    8
[   12.867499] ... MAX_LOCK_DEPTH:          30
[   12.867557] ... MAX_LOCKDEP_KEYS:        2048
[   12.867615] ... CLASSHASH_SIZE:           1024
[   12.867672] ... MAX_LOCKDEP_ENTRIES:     8192
[   12.867729] ... MAX_LOCKDEP_CHAINS:      16384
[   12.867787] ... CHAINHASH_SIZE:          8192
[   12.867845]  memory used by lock dependency info: 1648 kB
[   12.867903]  per task-struct memory footprint: 1680 bytes
[   12.869381] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[   12.870260] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[   12.870439] Checking aperture...
[   12.870497] CPU 0: aperture @ e04a000000 size 32 MB
[   12.870556] Aperture too small (32 MB)
[   12.882826] No AGP bridge found
[   12.898241] Memory: 882400k/917312k available (2241k kernel code, 34272k reserved, 1295k data, 204k init)
[   12.958216] Calibrating delay using timer specific routine.. 4392.39 BogoMIPS (lpj=2196198)
[   12.958439] Security Framework v1.0.0 initialized
[   12.958536] Mount-cache hash table entries: 256
[   12.959112] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   12.959173] CPU: L2 Cache: 1024K (64 bytes/line)
[   12.959253] CPU: AMD Turion(tm) 64 Mobile ML-40                  stepping 02
[   12.959393] ACPI: Core revision 20070126
[   12.967737] Parsing all Control Methods:
[   12.967940] Table [DSDT](id 0001) - 953 Objects with 106 Devices 297 Methods 26 Regions
[   12.968164] Parsing all Control Methods:
[   12.968336] Table [SSDT](id 0002) - 8 Objects with 0 Devices 6 Methods 0 Regions
[   12.968469]  tbxface-0587 [02] tb_load_namespace     : ACPI Tables successfully acquired
[   13.001824] evxfevnt-0091 [02] enable                : Transition to ACPI mode successful
[   13.012586] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[   13.022644] Using local APIC timer interrupts.
[   13.068211] result 12469381
[   13.068270] Detected 12.469 MHz APIC timer.
[   13.069058] testing NMI watchdog ... OK.
[   13.079375] PM: Adding info for No Bus:platform
[   13.079651] NET: Registered protocol family 16
[   13.079839] PM: Adding info for No Bus:vtcon0
[   13.080129] ACPI: bus type pci registered
[   13.083393] PCI: Using MMCONFIG at e0000000 - efffffff
[   13.083497] PCI: No mmconfig possible on device 00:18
[   13.086140] evgpeblk-0952 [04] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x15
[   13.086739] evgpeblk-1049 [03] ev_initialize_gpe_bloc: Found 4 Wake, Enabled 9 Runtime GPEs in this block
[   13.088347] Completing Region/Field/Buffer/Package initialization:............................................................................................................
[   13.096126] Initialized 25/26 Regions 0/0 Fields 30/30 Buffers 53/61 Packages (970 nodes)
[   13.096260] Initializing Device/Processor/Thermal objects by executing _INI methods:......
[   13.119192] Executed 6 _INI methods requiring 2 _STA executions (examined 113 objects)
[   13.119343] ACPI: Interpreter enabled
[   13.119402] ACPI: (supports S0 S3 S4 S5)
[   13.119679] ACPI: Using IOAPIC for interrupt routing
[   13.120072] PM: Adding info for acpi:acpi_system:00
[   13.120157] PM: Adding info for acpi:button_power:00
[   13.120231] PM: Adding info for acpi:ACPI0007:00
[   13.120327] PM: Adding info for acpi:device:00
[   13.120404] PM: Adding info for acpi:PNP0C01:00
[   13.120516] PM: Adding info for acpi:PNP0A03:00
[   13.120607] PM: Adding info for acpi:device:01
[   13.120690] PM: Adding info for acpi:video:00
[   13.120782] PM: Adding info for acpi:device:02
[   13.120874] PM: Adding info for acpi:device:03
[   13.120977] PM: Adding info for acpi:device:04
[   13.121071] PM: Adding info for acpi:device:05
[   13.121174] PM: Adding info for acpi:device:06
[   13.121279] PM: Adding info for acpi:device:07
[   13.121369] PM: Adding info for acpi:device:08
[   13.121460] PM: Adding info for acpi:device:09
[   13.121546] PM: Adding info for acpi:device:0a
[   13.121647] PM: Adding info for acpi:device:0b
[   13.121756] PM: Adding info for acpi:device:0c
[   13.121825] PM: Adding info for acpi:power_resource:00
[   13.121924] PM: Adding info for acpi:device:0d
[   13.122029] PM: Adding info for acpi:device:0e
[   13.122218] PM: Adding info for acpi:PNP0C09:00
[   13.122338] PM: Adding info for acpi:PNP0A06:00
[   13.123892] PM: Adding info for acpi:PNP0401:00
[   13.123966] PM: Adding info for acpi:power_resource:01
[   13.124296] PM: Adding info for acpi:PNP0C04:00
[   13.124387] PM: Adding info for acpi:PNP0100:00
[   13.124470] PM: Adding info for acpi:PNP0200:00
[   13.124558] PM: Adding info for acpi:PNP0800:00
[   13.124645] PM: Adding info for acpi:PNP0B00:00
[   13.124726] PM: Adding info for acpi:PNP0303:00
[   13.124837] PM: Adding info for acpi:SYN010E:00
[   13.124911] PM: Adding info for acpi:power_resource:02
[   13.125022] PM: Adding info for acpi:PNP0000:00
[   13.125111] PM: Adding info for acpi:PNP0C02:00
[   13.125204] PM: Adding info for acpi:device:0f
[   13.125295] PM: Adding info for acpi:device:10
[   13.125383] PM: Adding info for acpi:device:11
[   13.125474] PM: Adding info for acpi:device:12
[   13.125569] PM: Adding info for acpi:device:13
[   13.125670] PM: Adding info for acpi:device:14
[   13.125762] PM: Adding info for acpi:device:15
[   13.125846] PM: Adding info for acpi:device:16
[   13.125939] PM: Adding info for acpi:device:17
[   13.126037] PM: Adding info for acpi:device:18
[   13.126120] PM: Adding info for acpi:device:19
[   13.126227] PM: Adding info for acpi:device:1a
[   13.126319] PM: Adding info for acpi:device:1b
[   13.126409] PM: Adding info for acpi:device:1c
[   13.126503] PM: Adding info for acpi:device:1d
[   13.126601] PM: Adding info for acpi:device:1e
[   13.126701] PM: Adding info for acpi:device:1f
[   13.126798] PM: Adding info for acpi:device:20
[   13.126892] PM: Adding info for acpi:device:21
[   13.127007] PM: Adding info for acpi:device:22
[   13.127097] PM: Adding info for acpi:device:23
[   13.127188] PM: Adding info for acpi:device:24
[   13.127284] PM: Adding info for acpi:device:25
[   13.127376] PM: Adding info for acpi:device:26
[   13.127468] PM: Adding info for acpi:device:27
[   13.127553] PM: Adding info for acpi:device:28
[   13.127644] PM: Adding info for acpi:device:29
[   13.127739] PM: Adding info for acpi:device:2a
[   13.127828] PM: Adding info for acpi:device:2b
[   13.127921] PM: Adding info for acpi:device:2c
[   13.128023] PM: Adding info for acpi:device:2d
[   13.128116] PM: Adding info for acpi:device:2e
[   13.128213] PM: Adding info for acpi:device:2f
[   13.128314] PM: Adding info for acpi:device:30
[   13.128403] PM: Adding info for acpi:device:31
[   13.128502] PM: Adding info for acpi:device:32
[   13.128600] PM: Adding info for acpi:device:33
[   13.129037] PM: Adding info for acpi:PNP0C0F:00
[   13.129408] PM: Adding info for acpi:PNP0C0F:01
[   13.129778] PM: Adding info for acpi:PNP0C0F:02
[   13.130150] PM: Adding info for acpi:PNP0C0F:03
[   13.130521] PM: Adding info for acpi:PNP0C0F:04
[   13.130895] PM: Adding info for acpi:PNP0C0F:05
[   13.131300] PM: Adding info for acpi:PNP0C0F:06
[   13.131672] PM: Adding info for acpi:PNP0C0F:07
[   13.131776] PM: Adding info for acpi:device:34
[   13.131865] PM: Adding info for acpi:device:35
[   13.131962] PM: Adding info for acpi:device:36
[   13.132056] PM: Adding info for acpi:device:37
[   13.132141] PM: Adding info for acpi:device:38
[   13.132235] PM: Adding info for acpi:device:39
[   13.132330] PM: Adding info for acpi:device:3a
[   13.132417] PM: Adding info for acpi:device:3b
[   13.132510] PM: Adding info for acpi:device:3c
[   13.132604] PM: Adding info for acpi:device:3d
[   13.132691] PM: Adding info for acpi:device:3e
[   13.132782] PM: Adding info for acpi:device:3f
[   13.132875] PM: Adding info for acpi:device:40
[   13.132976] PM: Adding info for acpi:device:41
[   13.133070] PM: Adding info for acpi:device:42
[   13.133161] PM: Adding info for acpi:device:43
[   13.133247] PM: Adding info for acpi:device:44
[   13.133345] PM: Adding info for acpi:device:45
[   13.133439] PM: Adding info for acpi:PNP0C02:01
[   13.134150] PM: Adding info for acpi:PNP0C0A:00
[   13.134884] PM: Adding info for acpi:PNP0C0A:01
[   13.135009] PM: Adding info for acpi:ACPI0003:00
[   13.135090] PM: Adding info for acpi:PNP0C0E:00
[   13.135179] PM: Adding info for acpi:PNP0C0D:00
[   13.135272] PM: Adding info for acpi:PNP0C14:00
[   13.135722] PM: Adding info for acpi:PNP0C02:02
[   13.135809] PM: Adding info for acpi:thermal:00
[   13.135887] PM: Adding info for acpi:power_resource:03
[   13.135959] PM: Adding info for acpi:power_resource:04
[   13.136038] PM: Adding info for acpi:power_resource:05
[   13.136113] PM: Adding info for acpi:power_resource:06
[   13.136216] PM: Adding info for acpi:PNP0C0B:00
[   13.136329] PM: Adding info for acpi:PNP0C0B:01
[   13.136438] PM: Adding info for acpi:PNP0C0B:02
[   13.136541] PM: Adding info for acpi:PNP0C0B:03
[   13.136617] PM: Adding info for acpi:thermal:01
[   13.136698] PM: Adding info for acpi:thermal:02
[   13.136768] PM: Adding info for acpi:thermal:03
[   13.136847] PM: Adding info for acpi:thermal:04
[   13.151256] ACPI: PCI Root Bridge [C047] (0000:00)
[   13.151349] PCI: Probing PCI hardware (bus 00)
[   13.151374] PM: Adding info for No Bus:pci0000:00
[   13.151432] PCI: Scanning bus 0000:00
[   13.151449] PCI: Found 0000:00:00.0 [1002/5950] 000600 00
[   13.151466] PCI: Calling quirk ffffffff803d0720 for 0000:00:00.0
[   13.151483] PCI: Found 0000:00:01.0 [1002/5a3f] 000604 01
[   13.151490] PCI: Calling quirk ffffffff803d0720 for 0000:00:01.0
[   13.151508] PCI: Found 0000:00:04.0 [1002/5a36] 000604 01
[   13.151516] PCI: Calling quirk ffffffff803d0720 for 0000:00:04.0
[   13.151528] PCI: Found 0000:00:05.0 [1002/5a37] 000604 01
[   13.151536] PCI: Calling quirk ffffffff803d0720 for 0000:00:05.0
[   13.151586] PCI: Found 0000:00:13.0 [1002/4374] 000c03 00
[   13.151634] PCI: Calling quirk ffffffff803d0720 for 0000:00:13.0
[   13.151661] PCI: Found 0000:00:13.1 [1002/4375] 000c03 00
[   13.151709] PCI: Calling quirk ffffffff803d0720 for 0000:00:13.1
[   13.151744] PCI: Found 0000:00:13.2 [1002/4373] 000c03 00
[   13.151792] PCI: Calling quirk ffffffff803d0720 for 0000:00:13.2
[   13.151827] PCI: Found 0000:00:14.0 [1002/4372] 000c05 00
[   13.151871] PCI: Calling quirk ffffffff803d0720 for 0000:00:14.0
[   13.151898] PCI: Found 0000:00:14.1 [1002/4376] 000101 00
[   13.151953] 0000:00:14.1: trying to change BAR0 from 0000 to 01F0
[   13.152014] 0000:00:14.1: trying to change BAR1 from 0000 to 03F4
[   13.152073] 0000:00:14.1: trying to change BAR2 from 0000 to 0170
[   13.152133] 0000:00:14.1: trying to change BAR3 from 0000 to 0374
[   13.152194] PCI: Calling quirk ffffffff803d0720 for 0000:00:14.1
[   13.152212] PCI: Found 0000:00:14.3 [1002/4377] 000601 00
[   13.152258] PCI: Calling quirk ffffffff803d0720 for 0000:00:14.3
[   13.152275] PCI: Found 0000:00:14.4 [1002/4371] 000604 01
[   13.152295] PCI: Calling quirk ffffffff803d0720 for 0000:00:14.4
[   13.152321] PCI: Found 0000:00:14.5 [1002/4370] 000401 00
[   13.152368] PCI: Calling quirk ffffffff803d0720 for 0000:00:14.5
[   13.152395] PCI: Found 0000:00:14.6 [1002/4378] 000703 00
[   13.152442] PCI: Calling quirk ffffffff803d0720 for 0000:00:14.6
[   13.152474] PCI: Found 0000:00:18.0 [1022/1100] 000600 00
[   13.152493] PCI: Calling quirk ffffffff803d0720 for 0000:00:18.0
[   13.152506] PCI: Found 0000:00:18.1 [1022/1101] 000600 00
[   13.152525] PCI: Calling quirk ffffffff803d0720 for 0000:00:18.1
[   13.152537] PCI: Found 0000:00:18.2 [1022/1102] 000600 00
[   13.152556] PCI: Calling quirk ffffffff803d0720 for 0000:00:18.2
[   13.152567] PCI: Found 0000:00:18.3 [1022/1103] 000600 00
[   13.152586] PCI: Calling quirk ffffffff803d0720 for 0000:00:18.3
[   13.152603] PCI: Fixups for bus 0000:00
[   13.152607] PCI: Scanning behind PCI bridge 0000:00:01.0, config 010100, pass 0
[   13.152655] PCI: Scanning bus 0000:01
[   13.152669] PCI: Found 0000:01:05.0 [1002/5955] 000300 00
[   13.152683] PCI: Calling quirk ffffffff803d0720 for 0000:01:05.0
[   13.152686] Boot video device is 0000:01:05.0
[   13.152703] PCI: Fixups for bus 0000:01
[   13.152709] PCI: Bus scan for 0000:01 returning with max=01
[   13.152713] PCI: Scanning behind PCI bridge 0000:00:04.0, config 101000, pass 0
[   13.152766] PCI: Scanning bus 0000:10
[   13.152823] PCI: Fixups for bus 0000:10
[   13.152828] PCI: Bus scan for 0000:10 returning with max=10
[   13.152832] PCI: Scanning behind PCI bridge 0000:00:05.0, config 202000, pass 0
[   13.152878] PCI: Scanning bus 0000:20
[   13.152939] PCI: Fixups for bus 0000:20
[   13.152945] PCI: Bus scan for 0000:20 returning with max=20
[   13.152950] PCI: Scanning behind PCI bridge 0000:00:14.4, config 030200, pass 0
[   13.152995] PCI: Scanning bus 0000:02
[   13.153045] PCI: Found 0000:02:01.0 [14e4/169c] 000200 00
[   13.153108] PCI: Calling quirk ffffffff803d0720 for 0000:02:01.0
[   13.153126] PCI: Found 0000:02:02.0 [14e4/4324] 000280 00
[   13.153185] PCI: Calling quirk ffffffff803d0720 for 0000:02:02.0
[   13.153221] PCI: Found 0000:02:04.0 [104c/8031] 000607 02
[   13.153240] PCI: Calling quirk ffffffff803d0720 for 0000:02:04.0
[   13.153275] PCI: Found 0000:02:04.2 [104c/8032] 000c00 00
[   13.153337] PCI: Calling quirk ffffffff803d02c0 for 0000:02:04.2
[   13.153341] PCI: Calling quirk ffffffff803d0720 for 0000:02:04.2
[   13.153372] PCI: Found 0000:02:04.3 [104c/8033] 000180 00
[   13.153431] PCI: Calling quirk ffffffff803d0720 for 0000:02:04.3
[   13.153464] PCI: Found 0000:02:04.4 [104c/8034] 000805 00
[   13.153524] PCI: Calling quirk ffffffff803d0720 for 0000:02:04.4
[   13.153591] PCI: Fixups for bus 0000:02
[   13.153593] PCI: Transparent bridge - 0000:00:14.4
[   13.153667] PCI: Scanning behind PCI bridge 0000:02:04.0, config 030302, pass 0
[   13.153686] PCI: Scanning behind PCI bridge 0000:02:04.0, config 030302, pass 1
[   13.153753] PCI: Bus #03 (-#06) is hidden behind transparent bridge #02 (-#03) (try 'pci=assign-busses')
[   13.153832] Please report the result to linux-kernel to fix this permanently
[   13.153892] PCI: Bus scan for 0000:02 returning with max=06
[   13.153896] PCI: Scanning behind PCI bridge 0000:00:01.0, config 010100, pass 1
[   13.153902] PCI: Scanning behind PCI bridge 0000:00:04.0, config 101000, pass 1
[   13.153910] PCI: Scanning behind PCI bridge 0000:00:05.0, config 202000, pass 1
[   13.153928] PCI: Scanning behind PCI bridge 0000:00:14.4, config 030200, pass 1
[   13.153935] PCI: Bus scan for 0000:00 returning with max=20
[   13.153943] ACPI: PCI Interrupt Routing Table [\_SB_.C047._PRT]
[   13.154512] ACPI: PCI Interrupt Routing Table [\_SB_.C047.C048._PRT]
[   13.154684] ACPI: PCI Interrupt Routing Table [\_SB_.C047.C0AB._PRT]
[   13.156551] PM: Adding info for pci:0000:00:00.0
[   13.158063] PM: Adding info for pci:0000:00:01.0
[   13.159545] PM: Adding info for pci:0000:00:04.0
[   13.161045] PM: Adding info for pci:0000:00:05.0
[   13.162537] PM: Adding info for pci:0000:00:13.0
[   13.164030] PM: Adding info for pci:0000:00:13.1
[   13.165522] PM: Adding info for pci:0000:00:13.2
[   13.167027] PM: Adding info for pci:0000:00:14.0
[   13.168509] PM: Adding info for pci:0000:00:14.1
[   13.170015] PM: Adding info for pci:0000:00:14.3
[   13.171510] PM: Adding info for pci:0000:00:14.4
[   13.173003] PM: Adding info for pci:0000:00:14.5
[   13.174497] PM: Adding info for pci:0000:00:14.6
[   13.176001] PM: Adding info for pci:0000:00:18.0
[   13.177482] PM: Adding info for pci:0000:00:18.1
[   13.178986] PM: Adding info for pci:0000:00:18.2
[   13.180478] PM: Adding info for pci:0000:00:18.3
[   13.180559] PM: Adding info for pci:0000:01:05.0
[   13.180696] PM: Adding info for pci:0000:02:01.0
[   13.180824] PM: Adding info for pci:0000:02:02.0
[   13.180957] PM: Adding info for pci:0000:02:04.0
[   13.181085] PM: Adding info for pci:0000:02:04.2
[   13.181215] PM: Adding info for pci:0000:02:04.3
[   13.181341] PM: Adding info for pci:0000:02:04.4
[   13.181737] ACPI: PCI Interrupt Link [C0F0] (IRQs 10 11) *0, disabled.
[   13.182273] ACPI: PCI Interrupt Link [C0F1] (IRQs 10 11) *0, disabled.
[   13.182801] ACPI: PCI Interrupt Link [C0F2] (IRQs 10 11) *0, disabled.
[   13.183344] ACPI: PCI Interrupt Link [C0F3] (IRQs 10 11) *0, disabled.
[   13.183870] ACPI: PCI Interrupt Link [C0F4] (IRQs 10 11) *0, disabled.
[   13.184417] ACPI: PCI Interrupt Link [C0F5] (IRQs 9) *0, disabled.
[   13.184913] ACPI: PCI Interrupt Link [C0F6] (IRQs 10 11) *0, disabled.
[   13.185473] ACPI: PCI Interrupt Link [C0F7] (IRQs *10 11)
[   13.185895] ACPI: Power Resource [C1D3] (off)
[   13.186225] ACPI: Power Resource [C1BB] (on)
[   13.186347] ACPI: Power Resource [C1CB] (on)
[   13.186590] ACPI: Power Resource [C251] (off)
[   13.186808] ACPI: Power Resource [C252] (off)
[   13.187043] ACPI: Power Resource [C253] (off)
[   13.187263] ACPI: Power Resource [C254] (off)
[   13.187335] Linux Plug and Play Support v0.97 (c) Adam Belay
[   13.187416] pnp: PnP ACPI init
[   13.187499] PM: Adding info for No Bus:pnp0
[   13.187767] PM: Adding info for pnp:00:00
[   13.197250] PM: Adding info for pnp:00:01
[   13.199334] PM: Adding info for pnp:00:02
[   13.199636] PM: Adding info for pnp:00:03
[   13.199716] PM: Adding info for pnp:00:04
[   13.199786] PM: Adding info for pnp:00:05
[   13.199859] PM: Adding info for pnp:00:06
[   13.199936] PM: Adding info for pnp:00:07
[   13.200015] PM: Adding info for pnp:00:08
[   13.200525] PM: Adding info for pnp:00:09
[   13.201952] PM: Adding info for pnp:00:0a
[   13.205361] PM: Adding info for pnp:00:0b
[   13.205425] pnp: PnP ACPI: found 12 devices
[   13.205747] SCSI subsystem initialized
[   13.205866] libata version 2.20 loaded.
[   13.205995] PCI: Using ACPI for IRQ routing
[   13.206054] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   13.206140] PCI: Cannot allocate resource region 7 of bridge 0000:00:04.0
[   13.206199] PCI: Cannot allocate resource region 8 of bridge 0000:00:04.0
[   13.206259] PCI: Cannot allocate resource region 9 of bridge 0000:00:04.0
[   13.206318] PCI: Cannot allocate resource region 7 of bridge 0000:00:05.0
[   13.206377] PCI: Cannot allocate resource region 8 of bridge 0000:00:05.0
[   13.206437] PCI: Cannot allocate resource region 9 of bridge 0000:00:05.0
[   13.206841] Time: tsc clocksource has been installed.
[   13.206969] pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
[   13.207031] pnp: 00:00: iomem range 0xe0000-0xfffff could not be reserved
[   13.207091] pnp: 00:00: iomem range 0x100000-0x37ffffff could not be reserved
[   13.207161] pnp: 00:09: ioport range 0x40b-0x40b has been reserved
[   13.207220] pnp: 00:09: ioport range 0x4d0-0x4d1 has been reserved
[   13.207280] pnp: 00:09: ioport range 0x4d6-0x4d6 has been reserved
[   13.207341] pnp: 00:09: iomem range 0xffb80000-0xffbfffff has been reserved
[   13.207402] pnp: 00:09: iomem range 0xfff80000-0xffffffff has been reserved
[   13.207467] pnp: 00:0a: ioport range 0x8000-0x802f has been reserved
[   13.207527] pnp: 00:0a: ioport range 0x8100-0x811f has been reserved
[   13.207587] pnp: 00:0a: iomem range 0xe0000000-0xefffffff has been reserved
[   13.207649] pnp: 00:0a: iomem range 0xfec00000-0xfec000ff has been reserved
[   13.207714] pnp: 00:0b: iomem range 0xcf000-0xdffff has been reserved
[   13.207774] pnp: 00:0b: iomem range 0x38000000-0x3fffffff could not be reserved
[   13.207860] pnp: 00:0b: iomem range 0xfec01000-0xfec01fff has been reserved
[   13.207957] PM: Adding info for No Bus:mem
[   13.208014] PM: Adding info for No Bus:kmem
[   13.208067] PM: Adding info for No Bus:null
[   13.208121] PM: Adding info for No Bus:port
[   13.208178] PM: Adding info for No Bus:zero
[   13.208234] PM: Adding info for No Bus:full
[   13.208282] PM: Adding info for No Bus:random
[   13.208340] PM: Adding info for No Bus:urandom
[   13.208395] PM: Adding info for No Bus:kmsg
[   13.208505]   got res [d0620000:d063ffff] bus [d0620000:d063ffff] flags 7202 for BAR 6 of 0000:01:05.0
[   13.208508] PCI: Bridge: 0000:00:01.0
[   13.208567]   IO window: 3000-3fff
[   13.208625]   MEM window: d0600000-d09fffff
[   13.208684]   PREFETCH window: c0000000-cfffffff
[   13.208742] PCI: Bridge: 0000:00:04.0
[   13.208799]   IO window: disabled.
[   13.208866]   MEM window: disabled.
[   13.208924]   PREFETCH window: disabled.
[   13.208981] PCI: Bridge: 0000:00:05.0
[   13.209038]   IO window: disabled.
[   13.209096]   MEM window: disabled.
[   13.209153]   PREFETCH window: disabled.
[   13.209636] PCI: Bus 3, cardbus bridge: 0000:02:04.0
[   13.209694]   IO window: 00002000-000020ff
[   13.209753]   IO window: 00002400-000024ff
[   13.209811]   PREFETCH window: 50000000-53ffffff
[   13.209875]   MEM window: 54000000-57ffffff
[   13.209933] PCI: Bridge: 0000:00:14.4
[   13.209992]   IO window: 2000-2fff
[   13.210051]   MEM window: d0000000-d05fffff
[   13.210110]   PREFETCH window: 50000000-53ffffff
[   13.210183] PCI: Enabling bus mastering for device 0000:00:04.0
[   13.210186] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   13.210192] PCI: Enabling bus mastering for device 0000:00:05.0
[   13.210195] PCI: Setting latency timer of device 0000:00:05.0 to 64
[   13.210224] ACPI: PCI Interrupt 0000:02:04.0[A] -> GSI 20 (level, low) -> IRQ 20
[   13.210370] NET: Registered protocol family 2
[   13.219904] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[   13.220363] TCP established hash table entries: 32768 (order: 9, 2621440 bytes)
[   13.224528] TCP bind hash table entries: 32768 (order: 9, 2621440 bytes)
[   13.229109] TCP: Hash tables configured (established 32768 bind 32768)
[   13.229217] TCP reno registered
[   13.232096] checking if image is initramfs... it is
[   14.112002] Freeing initrd memory: 11122k freed
[   14.125734] PM: Adding info for No Bus:mcelog
[   14.126073] PM: Adding info for platform:pcspkr
[   14.126404] PM: Adding info for No Bus:snapshot
[   14.126448] audit: initializing netlink socket (disabled)
[   14.126545] audit(1173385735.174:1): initialized
[   14.126990] VFS: Disk quotas dquot_6.5.1
[   14.127059] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   14.127368] io scheduler noop registered
[   14.127464] io scheduler anticipatory registered
[   14.127564] io scheduler deadline registered
[   14.127670] io scheduler cfq registered (default)
[   14.127806] PCI: Calling quirk ffffffff8032cbc0 for 0000:00:00.0
[   14.127809] PCI: Calling quirk ffffffff803bc590 for 0000:00:00.0
[   14.127813] PCI: Calling quirk ffffffff8032cbc0 for 0000:00:01.0
[   14.127816] PCI: Calling quirk ffffffff803bc590 for 0000:00:01.0
[   14.127820] PCI: Calling quirk ffffffff8032cbc0 for 0000:00:04.0
[   14.127822] PCI: Calling quirk ffffffff803bc590 for 0000:00:04.0
[   14.127826] PCI: Calling quirk ffffffff8032cbc0 for 0000:00:05.0
[   14.127828] PCI: Calling quirk ffffffff803bc590 for 0000:00:05.0
[   14.127832] PCI: Calling quirk ffffffff8032cbc0 for 0000:00:13.0
[   14.127834] PCI: Calling quirk ffffffff803bc590 for 0000:00:13.0
[   14.127862] PCI: Calling quirk ffffffff8032cbc0 for 0000:00:13.1
[   14.127865] PCI: Calling quirk ffffffff803bc590 for 0000:00:13.1
[   14.127877] PCI: Calling quirk ffffffff8032cbc0 for 0000:00:13.2
[   14.127880] PCI: Calling quirk ffffffff803bc590 for 0000:00:13.2
[   14.127899] PCI: Calling quirk ffffffff8032cbc0 for 0000:00:14.0
[   14.127901] PCI: Calling quirk ffffffff803bc590 for 0000:00:14.0
[   14.127905] PCI: Calling quirk ffffffff8032cbc0 for 0000:00:14.1
[   14.127908] PCI: Calling quirk ffffffff803bc590 for 0000:00:14.1
[   14.127911] PCI: Calling quirk ffffffff8032cbc0 for 0000:00:14.3
[   14.127914] PCI: Calling quirk ffffffff803bc590 for 0000:00:14.3
[   14.127917] PCI: Calling quirk ffffffff8032cbc0 for 0000:00:14.4
[   14.127920] PCI: Calling quirk ffffffff803bc590 for 0000:00:14.4
[   14.127924] PCI: Calling quirk ffffffff8032cbc0 for 0000:00:14.5
[   14.127926] PCI: Calling quirk ffffffff803bc590 for 0000:00:14.5
[   14.127930] PCI: Calling quirk ffffffff8032cbc0 for 0000:00:14.6
[   14.127932] PCI: Calling quirk ffffffff803bc590 for 0000:00:14.6
[   14.127936] PCI: Calling quirk ffffffff8032cbc0 for 0000:00:18.0
[   14.127939] PCI: Calling quirk ffffffff803bc590 for 0000:00:18.0
[   14.127943] PCI: Calling quirk ffffffff8032cbc0 for 0000:00:18.1
[   14.127945] PCI: Calling quirk ffffffff803bc590 for 0000:00:18.1
[   14.127949] PCI: Calling quirk ffffffff8032cbc0 for 0000:00:18.2
[   14.127951] PCI: Calling quirk ffffffff803bc590 for 0000:00:18.2
[   14.127955] PCI: Calling quirk ffffffff8032cbc0 for 0000:00:18.3
[   14.127957] PCI: Calling quirk ffffffff803bc590 for 0000:00:18.3
[   14.127961] PCI: Calling quirk ffffffff8032cbc0 for 0000:01:05.0
[   14.127963] PCI: Calling quirk ffffffff803bc590 for 0000:01:05.0
[   14.127967] PCI: Calling quirk ffffffff8032cbc0 for 0000:02:01.0
[   14.127970] PCI: Calling quirk ffffffff803bc590 for 0000:02:01.0
[   14.127974] PCI: Calling quirk ffffffff8032cbc0 for 0000:02:02.0
[   14.127976] PCI: Calling quirk ffffffff803bc590 for 0000:02:02.0
[   14.127980] PCI: Calling quirk ffffffff8032cbc0 for 0000:02:04.0
[   14.127983] PCI: Calling quirk ffffffff803bc590 for 0000:02:04.0
[   14.127986] PCI: Calling quirk ffffffff8032cbc0 for 0000:02:04.2
[   14.127989] PCI: Calling quirk ffffffff803bc590 for 0000:02:04.2
[   14.127993] PCI: Calling quirk ffffffff8032cbc0 for 0000:02:04.3
[   14.127995] PCI: Calling quirk ffffffff803bc590 for 0000:02:04.3
[   14.127999] PCI: Calling quirk ffffffff8032cbc0 for 0000:02:04.4
[   14.128001] PCI: Calling quirk ffffffff803bc590 for 0000:02:04.4
[   14.128294] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   14.128317] assign_interrupt_mode Found MSI capability
[   14.128408] Allocate Port Service[0000:00:04.0:pcie00]
[   14.128424] PM: Adding info for pci_express:0000:00:04.0:pcie00
[   14.128511] Allocate Port Service[0000:00:04.0:pcie01]
[   14.128520] PM: Adding info for pci_express:0000:00:04.0:pcie01
[   14.128570] Allocate Port Service[0000:00:04.0:pcie02]
[   14.128582] PM: Adding info for pci_express:0000:00:04.0:pcie02
[   14.128659] PCI: Setting latency timer of device 0000:00:05.0 to 64
[   14.128682] assign_interrupt_mode Found MSI capability
[   14.128761] Allocate Port Service[0000:00:05.0:pcie00]
[   14.128777] PM: Adding info for pci_express:0000:00:05.0:pcie00
[   14.128821] Allocate Port Service[0000:00:05.0:pcie01]
[   14.128830] PM: Adding info for pci_express:0000:00:05.0:pcie01
[   14.128877] Allocate Port Service[0000:00:05.0:pcie02]
[   14.128885] PM: Adding info for pci_express:0000:00:05.0:pcie02
[   14.129069] Evaluate _OSC Set fails. Status = 0x0005
[   14.129078] Evaluate _OSC Set fails. Status = 0x0005
[   14.129080] aer_init: AER service init fails - Run ACPI _OSC fails
[   14.129085] aer: probe of 0000:00:04.0:pcie01 failed with error 2
[   14.129169] Evaluate _OSC Set fails. Status = 0x0005
[   14.129177] Evaluate _OSC Set fails. Status = 0x0005
[   14.129179] aer_init: AER service init fails - Run ACPI _OSC fails
[   14.129183] aer: probe of 0000:00:05.0:pcie01 failed with error 2
[   14.129296] PM: Adding info for platform:vesafb.0
[   14.129430] PM: Adding info for No Bus:tty
[   14.129494] PM: Adding info for No Bus:console
[   14.129539] PM: Adding info for No Bus:ptmx
[   14.129595] PM: Adding info for No Bus:tty0
[   14.129663] PM: Adding info for No Bus:vcs
[   14.129717] PM: Adding info for No Bus:vcsa
[   14.129775] PM: Adding info for No Bus:tty1
[   14.129821] PM: Adding info for No Bus:tty2
[   14.129876] PM: Adding info for No Bus:tty3
[   14.129932] PM: Adding info for No Bus:tty4
[   14.129984] PM: Adding info for No Bus:tty5
[   14.130037] PM: Adding info for No Bus:tty6
[   14.130092] PM: Adding info for No Bus:tty7
[   14.130139] PM: Adding info for No Bus:tty8
[   14.130198] PM: Adding info for No Bus:tty9
[   14.130255] PM: Adding info for No Bus:tty10
[   14.130305] PM: Adding info for No Bus:tty11
[   14.130362] PM: Adding info for No Bus:tty12
[   14.130420] PM: Adding info for No Bus:tty13
[   14.130478] PM: Adding info for No Bus:tty14
[   14.130532] PM: Adding info for No Bus:tty15
[   14.130587] PM: Adding info for No Bus:tty16
[   14.130638] PM: Adding info for No Bus:tty17
[   14.130695] PM: Adding info for No Bus:tty18
[   14.130755] PM: Adding info for No Bus:tty19
[   14.130806] PM: Adding info for No Bus:tty20
[   14.130863] PM: Adding info for No Bus:tty21
[   14.130923] PM: Adding info for No Bus:tty22
[   14.130976] PM: Adding info for No Bus:tty23
[   14.131032] PM: Adding info for No Bus:tty24
[   14.131090] PM: Adding info for No Bus:tty25
[   14.131143] PM: Adding info for No Bus:tty26
[   14.131202] PM: Adding info for No Bus:tty27
[   14.131259] PM: Adding info for No Bus:tty28
[   14.131313] PM: Adding info for No Bus:tty29
[   14.131374] PM: Adding info for No Bus:tty30
[   14.131435] PM: Adding info for No Bus:tty31
[   14.131494] PM: Adding info for No Bus:tty32
[   14.131552] PM: Adding info for No Bus:tty33
[   14.131611] PM: Adding info for No Bus:tty34
[   14.131666] PM: Adding info for No Bus:tty35
[   14.131728] PM: Adding info for No Bus:tty36
[   14.131789] PM: Adding info for No Bus:tty37
[   14.131840] PM: Adding info for No Bus:tty38
[   14.131901] PM: Adding info for No Bus:tty39
[   14.131961] PM: Adding info for No Bus:tty40
[   14.132016] PM: Adding info for No Bus:tty41
[   14.132076] PM: Adding info for No Bus:tty42
[   14.132136] PM: Adding info for No Bus:tty43
[   14.132188] PM: Adding info for No Bus:tty44
[   14.132248] PM: Adding info for No Bus:tty45
[   14.132309] PM: Adding info for No Bus:tty46
[   14.132361] PM: Adding info for No Bus:tty47
[   14.132420] PM: Adding info for No Bus:tty48
[   14.132530] PM: Adding info for No Bus:tty49
[   14.132580] PM: Adding info for No Bus:tty50
[   14.132635] PM: Adding info for No Bus:tty51
[   14.132735] PM: Adding info for No Bus:tty52
[   14.132784] PM: Adding info for No Bus:tty53
[   14.132839] PM: Adding info for No Bus:tty54
[   14.132897] PM: Adding info for No Bus:tty55
[   14.132945] PM: Adding info for No Bus:tty56
[   14.133001] PM: Adding info for No Bus:tty57
[   14.133057] PM: Adding info for No Bus:tty58
[   14.133107] PM: Adding info for No Bus:tty59
[   14.133162] PM: Adding info for No Bus:tty60
[   14.133219] PM: Adding info for No Bus:tty61
[   14.133268] PM: Adding info for No Bus:tty62
[   14.133327] PM: Adding info for No Bus:tty63
[   14.133459] PM: Adding info for No Bus:ptyp0
[   14.133549] PM: Adding info for No Bus:ptyp1
[   14.133601] PM: Adding info for No Bus:ptyp2
[   14.133658] PM: Adding info for No Bus:ptyp3
[   14.133750] PM: Adding info for No Bus:ptyp4
[   14.133803] PM: Adding info for No Bus:ptyp5
[   14.133856] PM: Adding info for No Bus:ptyp6
[   14.133903] PM: Adding info for No Bus:ptyp7
[   14.133954] PM: Adding info for No Bus:ptyp8
[   14.134007] PM: Adding info for No Bus:ptyp9
[   14.134056] PM: Adding info for No Bus:ptypa
[   14.134109] PM: Adding info for No Bus:ptypb
[   14.134164] PM: Adding info for No Bus:ptypc
[   14.134216] PM: Adding info for No Bus:ptypd
[   14.134270] PM: Adding info for No Bus:ptype
[   14.134327] PM: Adding info for No Bus:ptypf
[   14.134376] PM: Adding info for No Bus:ptyq0
[   14.134434] PM: Adding info for No Bus:ptyq1
[   14.134499] PM: Adding info for No Bus:ptyq2
[   14.134549] PM: Adding info for No Bus:ptyq3
[   14.134607] PM: Adding info for No Bus:ptyq4
[   14.134665] PM: Adding info for No Bus:ptyq5
[   14.134717] PM: Adding info for No Bus:ptyq6
[   14.134774] PM: Adding info for No Bus:ptyq7
[   14.134829] PM: Adding info for No Bus:ptyq8
[   14.134881] PM: Adding info for No Bus:ptyq9
[   14.134939] PM: Adding info for No Bus:ptyqa
[   14.134999] PM: Adding info for No Bus:ptyqb
[   14.135052] PM: Adding info for No Bus:ptyqc
[   14.135113] PM: Adding info for No Bus:ptyqd
[   14.135170] PM: Adding info for No Bus:ptyqe
[   14.135223] PM: Adding info for No Bus:ptyqf
[   14.135287] PM: Adding info for No Bus:ptyr0
[   14.135346] PM: Adding info for No Bus:ptyr1
[   14.135399] PM: Adding info for No Bus:ptyr2
[   14.135471] PM: Adding info for No Bus:ptyr3
[   14.135528] PM: Adding info for No Bus:ptyr4
[   14.135584] PM: Adding info for No Bus:ptyr5
[   14.135642] PM: Adding info for No Bus:ptyr6
[   14.135704] PM: Adding info for No Bus:ptyr7
[   14.135760] PM: Adding info for No Bus:ptyr8
[   14.135823] PM: Adding info for No Bus:ptyr9
[   14.135886] PM: Adding info for No Bus:ptyra
[   14.135943] PM: Adding info for No Bus:ptyrb
[   14.136004] PM: Adding info for No Bus:ptyrc
[   14.136067] PM: Adding info for No Bus:ptyrd
[   14.136121] PM: Adding info for No Bus:ptyre
[   14.136185] PM: Adding info for No Bus:ptyrf
[   14.136247] PM: Adding info for No Bus:ptys0
[   14.136305] PM: Adding info for No Bus:ptys1
[   14.136369] PM: Adding info for No Bus:ptys2
[   14.136433] PM: Adding info for No Bus:ptys3
[   14.136494] PM: Adding info for No Bus:ptys4
[   14.136557] PM: Adding info for No Bus:ptys5
[   14.136620] PM: Adding info for No Bus:ptys6
[   14.136677] PM: Adding info for No Bus:ptys7
[   14.136745] PM: Adding info for No Bus:ptys8
[   14.136812] PM: Adding info for No Bus:ptys9
[   14.136871] PM: Adding info for No Bus:ptysa
[   14.136937] PM: Adding info for No Bus:ptysb
[   14.137003] PM: Adding info for No Bus:ptysc
[   14.137066] PM: Adding info for No Bus:ptysd
[   14.137130] PM: Adding info for No Bus:ptyse
[   14.137197] PM: Adding info for No Bus:ptysf
[   14.137256] PM: Adding info for No Bus:ptyt0
[   14.137324] PM: Adding info for No Bus:ptyt1
[   14.137389] PM: Adding info for No Bus:ptyt2
[   14.137448] PM: Adding info for No Bus:ptyt3
[   14.137558] PM: Adding info for No Bus:ptyt4
[   14.137622] PM: Adding info for No Bus:ptyt5
[   14.137718] PM: Adding info for No Bus:ptyt6
[   14.137780] PM: Adding info for No Bus:ptyt7
[   14.137842] PM: Adding info for No Bus:ptyt8
[   14.137897] PM: Adding info for No Bus:ptyt9
[   14.137957] PM: Adding info for No Bus:ptyta
[   14.138020] PM: Adding info for No Bus:ptytb
[   14.138073] PM: Adding info for No Bus:ptytc
[   14.138136] PM: Adding info for No Bus:ptytd
[   14.138197] PM: Adding info for No Bus:ptyte
[   14.138254] PM: Adding info for No Bus:ptytf
[   14.138316] PM: Adding info for No Bus:ptyu0
[   14.138378] PM: Adding info for No Bus:ptyu1
[   14.138437] PM: Adding info for No Bus:ptyu2
[   14.138541] PM: Adding info for No Bus:ptyu3
[   14.138600] PM: Adding info for No Bus:ptyu4
[   14.138655] PM: Adding info for No Bus:ptyu5
[   14.138756] PM: Adding info for No Bus:ptyu6
[   14.138815] PM: Adding info for No Bus:ptyu7
[   14.138870] PM: Adding info for No Bus:ptyu8
[   14.138933] PM: Adding info for No Bus:ptyu9
[   14.138990] PM: Adding info for No Bus:ptyua
[   14.139044] PM: Adding info for No Bus:ptyub
[   14.139102] PM: Adding info for No Bus:ptyuc
[   14.139162] PM: Adding info for No Bus:ptyud
[   14.139216] PM: Adding info for No Bus:ptyue
[   14.139277] PM: Adding info for No Bus:ptyuf
[   14.139338] PM: Adding info for No Bus:ptyv0
[   14.139394] PM: Adding info for No Bus:ptyv1
[   14.139459] PM: Adding info for No Bus:ptyv2
[   14.139521] PM: Adding info for No Bus:ptyv3
[   14.139576] PM: Adding info for No Bus:ptyv4
[   14.139641] PM: Adding info for No Bus:ptyv5
[   14.139706] PM: Adding info for No Bus:ptyv6
[   14.139767] PM: Adding info for No Bus:ptyv7
[   14.139832] PM: Adding info for No Bus:ptyv8
[   14.139898] PM: Adding info for No Bus:ptyv9
[   14.139957] PM: Adding info for No Bus:ptyva
[   14.140025] PM: Adding info for No Bus:ptyvb
[   14.140088] PM: Adding info for No Bus:ptyvc
[   14.140150] PM: Adding info for No Bus:ptyvd
[   14.140216] PM: Adding info for No Bus:ptyve
[   14.140283] PM: Adding info for No Bus:ptyvf
[   14.140341] PM: Adding info for No Bus:ptyw0
[   14.140408] PM: Adding info for No Bus:ptyw1
[   14.140485] PM: Adding info for No Bus:ptyw2
[   14.140544] PM: Adding info for No Bus:ptyw3
[   14.140612] PM: Adding info for No Bus:ptyw4
[   14.140678] PM: Adding info for No Bus:ptyw5
[   14.140739] PM: Adding info for No Bus:ptyw6
[   14.140808] PM: Adding info for No Bus:ptyw7
[   14.140874] PM: Adding info for No Bus:ptyw8
[   14.140937] PM: Adding info for No Bus:ptyw9
[   14.141002] PM: Adding info for No Bus:ptywa
[   14.141073] PM: Adding info for No Bus:ptywb
[   14.141136] PM: Adding info for No Bus:ptywc
[   14.141206] PM: Adding info for No Bus:ptywd
[   14.141278] PM: Adding info for No Bus:ptywe
[   14.141342] PM: Adding info for No Bus:ptywf
[   14.141413] PM: Adding info for No Bus:ptyx0
[   14.141492] PM: Adding info for No Bus:ptyx1
[   14.141559] PM: Adding info for No Bus:ptyx2
[   14.141629] PM: Adding info for No Bus:ptyx3
[   14.141699] PM: Adding info for No Bus:ptyx4
[   14.141764] PM: Adding info for No Bus:ptyx5
[   14.141833] PM: Adding info for No Bus:ptyx6
[   14.141908] PM: Adding info for No Bus:ptyx7
[   14.141970] PM: Adding info for No Bus:ptyx8
[   14.142042] PM: Adding info for No Bus:ptyx9
[   14.142114] PM: Adding info for No Bus:ptyxa
[   14.142182] PM: Adding info for No Bus:ptyxb
[   14.142251] PM: Adding info for No Bus:ptyxc
[   14.142323] PM: Adding info for No Bus:ptyxd
[   14.142387] PM: Adding info for No Bus:ptyxe
[   14.142505] PM: Adding info for No Bus:ptyxf
[   14.142578] PM: Adding info for No Bus:ptyy0
[   14.142640] PM: Adding info for No Bus:ptyy1
[   14.142750] PM: Adding info for No Bus:ptyy2
[   14.142820] PM: Adding info for No Bus:ptyy3
[   14.142880] PM: Adding info for No Bus:ptyy4
[   14.142946] PM: Adding info for No Bus:ptyy5
[   14.143014] PM: Adding info for No Bus:ptyy6
[   14.143077] PM: Adding info for No Bus:ptyy7
[   14.143147] PM: Adding info for No Bus:ptyy8
[   14.143216] PM: Adding info for No Bus:ptyy9
[   14.143280] PM: Adding info for No Bus:ptyya
[   14.143350] PM: Adding info for No Bus:ptyyb
[   14.143417] PM: Adding info for No Bus:ptyyc
[   14.143521] PM: Adding info for No Bus:ptyyd
[   14.143586] PM: Adding info for No Bus:ptyye
[   14.143654] PM: Adding info for No Bus:ptyyf
[   14.143713] PM: Adding info for No Bus:ptyz0
[   14.143781] PM: Adding info for No Bus:ptyz1
[   14.143848] PM: Adding info for No Bus:ptyz2
[   14.143910] PM: Adding info for No Bus:ptyz3
[   14.143982] PM: Adding info for No Bus:ptyz4
[   14.144051] PM: Adding info for No Bus:ptyz5
[   14.144113] PM: Adding info for No Bus:ptyz6
[   14.144184] PM: Adding info for No Bus:ptyz7
[   14.144254] PM: Adding info for No Bus:ptyz8
[   14.144317] PM: Adding info for No Bus:ptyz9
[   14.144386] PM: Adding info for No Bus:ptyza
[   14.144465] PM: Adding info for No Bus:ptyzb
[   14.144530] PM: Adding info for No Bus:ptyzc
[   14.144602] PM: Adding info for No Bus:ptyzd
[   14.144674] PM: Adding info for No Bus:ptyze
[   14.144737] PM: Adding info for No Bus:ptyzf
[   14.144807] PM: Adding info for No Bus:ptya0
[   14.144879] PM: Adding info for No Bus:ptya1
[   14.144947] PM: Adding info for No Bus:ptya2
[   14.145019] PM: Adding info for No Bus:ptya3
[   14.145089] PM: Adding info for No Bus:ptya4
[   14.145157] PM: Adding info for No Bus:ptya5
[   14.145227] PM: Adding info for No Bus:ptya6
[   14.145300] PM: Adding info for No Bus:ptya7
[   14.145363] PM: Adding info for No Bus:ptya8
[   14.145436] PM: Adding info for No Bus:ptya9
[   14.145532] PM: Adding info for No Bus:ptyaa
[   14.145597] PM: Adding info for No Bus:ptyab
[   14.145668] PM: Adding info for No Bus:ptyac
[   14.145739] PM: Adding info for No Bus:ptyad
[   14.145804] PM: Adding info for No Bus:ptyae
[   14.145878] PM: Adding info for No Bus:ptyaf
[   14.145949] PM: Adding info for No Bus:ptyb0
[   14.146016] PM: Adding info for No Bus:ptyb1
[   14.146088] PM: Adding info for No Bus:ptyb2
[   14.146159] PM: Adding info for No Bus:ptyb3
[   14.146227] PM: Adding info for No Bus:ptyb4
[   14.146304] PM: Adding info for No Bus:ptyb5
[   14.146377] PM: Adding info for No Bus:ptyb6
[   14.146452] PM: Adding info for No Bus:ptyb7
[   14.146529] PM: Adding info for No Bus:ptyb8
[   14.146603] PM: Adding info for No Bus:ptyb9
[   14.146671] PM: Adding info for No Bus:ptyba
[   14.146747] PM: Adding info for No Bus:ptybb
[   14.146820] PM: Adding info for No Bus:ptybc
[   14.146892] PM: Adding info for No Bus:ptybd
[   14.146966] PM: Adding info for No Bus:ptybe
[   14.147045] PM: Adding info for No Bus:ptybf
[   14.147114] PM: Adding info for No Bus:ptyc0
[   14.147190] PM: Adding info for No Bus:ptyc1
[   14.147265] PM: Adding info for No Bus:ptyc2
[   14.147336] PM: Adding info for No Bus:ptyc3
[   14.147412] PM: Adding info for No Bus:ptyc4
[   14.147535] PM: Adding info for No Bus:ptyc5
[   14.147601] PM: Adding info for No Bus:ptyc6
[   14.147712] PM: Adding info for No Bus:ptyc7
[   14.147784] PM: Adding info for No Bus:ptyc8
[   14.147852] PM: Adding info for No Bus:ptyc9
[   14.147923] PM: Adding info for No Bus:ptyca
[   14.147997] PM: Adding info for No Bus:ptycb
[   14.148063] PM: Adding info for No Bus:ptycc
[   14.148136] PM: Adding info for No Bus:ptycd
[   14.148208] PM: Adding info for No Bus:ptyce
[   14.148276] PM: Adding info for No Bus:ptycf
[   14.148350] PM: Adding info for No Bus:ptyd0
[   14.148425] PM: Adding info for No Bus:ptyd1
[   14.148535] PM: Adding info for No Bus:ptyd2
[   14.148607] PM: Adding info for No Bus:ptyd3
[   14.148681] PM: Adding info for No Bus:ptyd4
[   14.148749] PM: Adding info for No Bus:ptyd5
[   14.148824] PM: Adding info for No Bus:ptyd6
[   14.148899] PM: Adding info for No Bus:ptyd7
[   14.148965] PM: Adding info for No Bus:ptyd8
[   14.149042] PM: Adding info for No Bus:ptyd9
[   14.149117] PM: Adding info for No Bus:ptyda
[   14.149185] PM: Adding info for No Bus:ptydb
[   14.149259] PM: Adding info for No Bus:ptydc
[   14.149333] PM: Adding info for No Bus:ptydd
[   14.149401] PM: Adding info for No Bus:ptyde
[   14.149486] PM: Adding info for No Bus:ptydf
[   14.149563] PM: Adding info for No Bus:ptye0
[   14.149633] PM: Adding info for No Bus:ptye1
[   14.149707] PM: Adding info for No Bus:ptye2
[   14.149785] PM: Adding info for No Bus:ptye3
[   14.149853] PM: Adding info for No Bus:ptye4
[   14.149929] PM: Adding info for No Bus:ptye5
[   14.150008] PM: Adding info for No Bus:ptye6
[   14.150079] PM: Adding info for No Bus:ptye7
[   14.150156] PM: Adding info for No Bus:ptye8
[   14.150234] PM: Adding info for No Bus:ptye9
[   14.150305] PM: Adding info for No Bus:ptyea
[   14.150385] PM: Adding info for No Bus:ptyeb
[   14.150488] PM: Adding info for No Bus:ptyec
[   14.150560] PM: Adding info for No Bus:ptyed
[   14.150636] PM: Adding info for No Bus:ptyee
[   14.150712] PM: Adding info for No Bus:ptyef
[   14.150794] PM: Adding info for No Bus:ttyp0
[   14.150868] PM: Adding info for No Bus:ttyp1
[   14.150945] PM: Adding info for No Bus:ttyp2
[   14.151015] PM: Adding info for No Bus:ttyp3
[   14.151089] PM: Adding info for No Bus:ttyp4
[   14.151165] PM: Adding info for No Bus:ttyp5
[   14.151233] PM: Adding info for No Bus:ttyp6
[   14.151311] PM: Adding info for No Bus:ttyp7
[   14.151387] PM: Adding info for No Bus:ttyp8
[   14.151467] PM: Adding info for No Bus:ttyp9
[   14.151545] PM: Adding info for No Bus:ttypa
[   14.151624] PM: Adding info for No Bus:ttypb
[   14.151696] PM: Adding info for No Bus:ttypc
[   14.151773] PM: Adding info for No Bus:ttypd
[   14.151851] PM: Adding info for No Bus:ttype
[   14.151922] PM: Adding info for No Bus:ttypf
[   14.152000] PM: Adding info for No Bus:ttyq0
[   14.152078] PM: Adding info for No Bus:ttyq1
[   14.152150] PM: Adding info for No Bus:ttyq2
[   14.152232] PM: Adding info for No Bus:ttyq3
[   14.152309] PM: Adding info for No Bus:ttyq4
[   14.152382] PM: Adding info for No Bus:ttyq5
[   14.152506] PM: Adding info for No Bus:ttyq6
[   14.152583] PM: Adding info for No Bus:ttyq7
[   14.152691] PM: Adding info for No Bus:ttyq8
[   14.152769] PM: Adding info for No Bus:ttyq9
[   14.152843] PM: Adding info for No Bus:ttyqa
[   14.152912] PM: Adding info for No Bus:ttyqb
[   14.152992] PM: Adding info for No Bus:ttyqc
[   14.153067] PM: Adding info for No Bus:ttyqd
[   14.153136] PM: Adding info for No Bus:ttyqe
[   14.153213] PM: Adding info for No Bus:ttyqf
[   14.153289] PM: Adding info for No Bus:ttyr0
[   14.153359] PM: Adding info for No Bus:ttyr1
[   14.153466] PM: Adding info for No Bus:ttyr2
[   14.153544] PM: Adding info for No Bus:ttyr3
[   14.153612] PM: Adding info for No Bus:ttyr4
[   14.153689] PM: Adding info for No Bus:ttyr5
[   14.153766] PM: Adding info for No Bus:ttyr6
[   14.153836] PM: Adding info for No Bus:ttyr7
[   14.153911] PM: Adding info for No Bus:ttyr8
[   14.153988] PM: Adding info for No Bus:ttyr9
[   14.154060] PM: Adding info for No Bus:ttyra
[   14.154137] PM: Adding info for No Bus:ttyrb
[   14.154215] PM: Adding info for No Bus:ttyrc
[   14.154289] PM: Adding info for No Bus:ttyrd
[   14.154366] PM: Adding info for No Bus:ttyre
[   14.154450] PM: Adding info for No Bus:ttyrf
[   14.154521] PM: Adding info for No Bus:ttys0
[   14.154599] PM: Adding info for No Bus:ttys1
[   14.154678] PM: Adding info for No Bus:ttys2
[   14.154753] PM: Adding info for No Bus:ttys3
[   14.154833] PM: Adding info for No Bus:ttys4
[   14.154914] PM: Adding info for No Bus:ttys5
[   14.154985] PM: Adding info for No Bus:ttys6
[   14.155066] PM: Adding info for No Bus:ttys7
[   14.155148] PM: Adding info for No Bus:ttys8
[   14.155221] PM: Adding info for No Bus:ttys9
[   14.155298] PM: Adding info for No Bus:ttysa
[   14.155383] PM: Adding info for No Bus:ttysb
[   14.155483] PM: Adding info for No Bus:ttysc
[   14.155563] PM: Adding info for No Bus:ttysd
[   14.155641] PM: Adding info for No Bus:ttyse
[   14.155714] PM: Adding info for No Bus:ttysf
[   14.155796] PM: Adding info for No Bus:ttyt0
[   14.155875] PM: Adding info for No Bus:ttyt1
[   14.155949] PM: Adding info for No Bus:ttyt2
[   14.156031] PM: Adding info for No Bus:ttyt3
[   14.156112] PM: Adding info for No Bus:ttyt4
[   14.156186] PM: Adding info for No Bus:ttyt5
[   14.156265] PM: Adding info for No Bus:ttyt6
[   14.156350] PM: Adding info for No Bus:ttyt7
[   14.156426] PM: Adding info for No Bus:ttyt8
[   14.156520] PM: Adding info for No Bus:ttyt9
[   14.156600] PM: Adding info for No Bus:ttyta
[   14.156678] PM: Adding info for No Bus:ttytb
[   14.156760] PM: Adding info for No Bus:ttytc
[   14.156843] PM: Adding info for No Bus:ttytd
[   14.156919] PM: Adding info for No Bus:ttyte
[   14.157002] PM: Adding info for No Bus:ttytf
[   14.157085] PM: Adding info for No Bus:ttyu0
[   14.157162] PM: Adding info for No Bus:ttyu1
[   14.157247] PM: Adding info for No Bus:ttyu2
[   14.157334] PM: Adding info for No Bus:ttyu3
[   14.157413] PM: Adding info for No Bus:ttyu4
[   14.157543] PM: Adding info for No Bus:ttyu5
[   14.157626] PM: Adding info for No Bus:ttyu6
[   14.157737] PM: Adding info for No Bus:ttyu7
[   14.157816] PM: Adding info for No Bus:ttyu8
[   14.157897] PM: Adding info for No Bus:ttyu9
[   14.157972] PM: Adding info for No Bus:ttyua
[   14.158056] PM: Adding info for No Bus:ttyub
[   14.158135] PM: Adding info for No Bus:ttyuc
[   14.158212] PM: Adding info for No Bus:ttyud
[   14.158293] PM: Adding info for No Bus:ttyue
[   14.158375] PM: Adding info for No Bus:ttyuf
[   14.158478] PM: Adding info for No Bus:ttyv0
[   14.158559] PM: Adding info for No Bus:ttyv1
[   14.158638] PM: Adding info for No Bus:ttyv2
[   14.158713] PM: Adding info for No Bus:ttyv3
[   14.158793] PM: Adding info for No Bus:ttyv4
[   14.158876] PM: Adding info for No Bus:ttyv5
[   14.158954] PM: Adding info for No Bus:ttyv6
[   14.159038] PM: Adding info for No Bus:ttyv7
[   14.159121] PM: Adding info for No Bus:ttyv8
[   14.159198] PM: Adding info for No Bus:ttyv9
[   14.159282] PM: Adding info for No Bus:ttyva
[   14.159368] PM: Adding info for No Bus:ttyvb
[   14.159452] PM: Adding info for No Bus:ttyvc
[   14.159539] PM: Adding info for No Bus:ttyvd
[   14.159622] PM: Adding info for No Bus:ttyve
[   14.159700] PM: Adding info for No Bus:ttyvf
[   14.159784] PM: Adding info for No Bus:ttyw0
[   14.159870] PM: Adding info for No Bus:ttyw1
[   14.159949] PM: Adding info for No Bus:ttyw2
[   14.160032] PM: Adding info for No Bus:ttyw3
[   14.160116] PM: Adding info for No Bus:ttyw4
[   14.160193] PM: Adding info for No Bus:ttyw5
[   14.160278] PM: Adding info for No Bus:ttyw6
[   14.160364] PM: Adding info for No Bus:ttyw7
[   14.160469] PM: Adding info for No Bus:ttyw8
[   14.160555] PM: Adding info for No Bus:ttyw9
[   14.160638] PM: Adding info for No Bus:ttywa
[   14.160717] PM: Adding info for No Bus:ttywb
[   14.160801] PM: Adding info for No Bus:ttywc
[   14.160887] PM: Adding info for No Bus:ttywd
[   14.160968] PM: Adding info for No Bus:ttywe
[   14.161054] PM: Adding info for No Bus:ttywf
[   14.161139] PM: Adding info for No Bus:ttyx0
[   14.161218] PM: Adding info for No Bus:ttyx1
[   14.161303] PM: Adding info for No Bus:ttyx2
[   14.161391] PM: Adding info for No Bus:ttyx3
[   14.161480] PM: Adding info for No Bus:ttyx4
[   14.161568] PM: Adding info for No Bus:ttyx5
[   14.161656] PM: Adding info for No Bus:ttyx6
[   14.161739] PM: Adding info for No Bus:ttyx7
[   14.161825] PM: Adding info for No Bus:ttyx8
[   14.161915] PM: Adding info for No Bus:ttyx9
[   14.161996] PM: Adding info for No Bus:ttyxa
[   14.162084] PM: Adding info for No Bus:ttyxb
[   14.162175] PM: Adding info for No Bus:ttyxc
[   14.162258] PM: Adding info for No Bus:ttyxd
[   14.162348] PM: Adding info for No Bus:ttyxe
[   14.162486] PM: Adding info for No Bus:ttyxf
[   14.162566] PM: Adding info for No Bus:ttyy0
[   14.162696] PM: Adding info for No Bus:ttyy1
[   14.162783] PM: Adding info for No Bus:ttyy2
[   14.162862] PM: Adding info for No Bus:ttyy3
[   14.162946] PM: Adding info for No Bus:ttyy4
[   14.163029] PM: Adding info for No Bus:ttyy5
[   14.163107] PM: Adding info for No Bus:ttyy6
[   14.163192] PM: Adding info for No Bus:ttyy7
[   14.163275] PM: Adding info for No Bus:ttyy8
[   14.163355] PM: Adding info for No Bus:ttyy9
[   14.163462] PM: Adding info for No Bus:ttyya
[   14.163550] PM: Adding info for No Bus:ttyyb
[   14.163629] PM: Adding info for No Bus:ttyyc
[   14.163716] PM: Adding info for No Bus:ttyyd
[   14.163802] PM: Adding info for No Bus:ttyye
[   14.163883] PM: Adding info for No Bus:ttyyf
[   14.163968] PM: Adding info for No Bus:ttyz0
[   14.164057] PM: Adding info for No Bus:ttyz1
[   14.164139] PM: Adding info for No Bus:ttyz2
[   14.164226] PM: Adding info for No Bus:ttyz3
[   14.164314] PM: Adding info for No Bus:ttyz4
[   14.164397] PM: Adding info for No Bus:ttyz5
[   14.164492] PM: Adding info for No Bus:ttyz6
[   14.164581] PM: Adding info for No Bus:ttyz7
[   14.164667] PM: Adding info for No Bus:ttyz8
[   14.164757] PM: Adding info for No Bus:ttyz9
[   14.164846] PM: Adding info for No Bus:ttyza
[   14.164930] PM: Adding info for No Bus:ttyzb
[   14.165019] PM: Adding info for No Bus:ttyzc
[   14.165111] PM: Adding info for No Bus:ttyzd
[   14.165194] PM: Adding info for No Bus:ttyze
[   14.165285] PM: Adding info for No Bus:ttyzf
[   14.165377] PM: Adding info for No Bus:ttya0
[   14.165485] PM: Adding info for No Bus:ttya1
[   14.165575] PM: Adding info for No Bus:ttya2
[   14.165662] PM: Adding info for No Bus:ttya3
[   14.165744] PM: Adding info for No Bus:ttya4
[   14.165834] PM: Adding info for No Bus:ttya5
[   14.165924] PM: Adding info for No Bus:ttya6
[   14.166009] PM: Adding info for No Bus:ttya7
[   14.166098] PM: Adding info for No Bus:ttya8
[   14.166190] PM: Adding info for No Bus:ttya9
[   14.166274] PM: Adding info for No Bus:ttyaa
[   14.166365] PM: Adding info for No Bus:ttyab
[   14.166465] PM: Adding info for No Bus:ttyac
[   14.166555] PM: Adding info for No Bus:ttyad
[   14.166649] PM: Adding info for No Bus:ttyae
[   14.166743] PM: Adding info for No Bus:ttyaf
[   14.166832] PM: Adding info for No Bus:ttyb0
[   14.166927] PM: Adding info for No Bus:ttyb1
[   14.167019] PM: Adding info for No Bus:ttyb2
[   14.167106] PM: Adding info for No Bus:ttyb3
[   14.167204] PM: Adding info for No Bus:ttyb4
[   14.167301] PM: Adding info for No Bus:ttyb5
[   14.167387] PM: Adding info for No Bus:ttyb6
[   14.167524] PM: Adding info for No Bus:ttyb7
[   14.167614] PM: Adding info for No Bus:ttyb8
[   14.167739] PM: Adding info for No Bus:ttyb9
[   14.167829] PM: Adding info for No Bus:ttyba
[   14.167920] PM: Adding info for No Bus:ttybb
[   14.168003] PM: Adding info for No Bus:ttybc
[   14.168094] PM: Adding info for No Bus:ttybd
[   14.168182] PM: Adding info for No Bus:ttybe
[   14.168267] PM: Adding info for No Bus:ttybf
[   14.168360] PM: Adding info for No Bus:ttyc0
[   14.168469] PM: Adding info for No Bus:ttyc1
[   14.168555] PM: Adding info for No Bus:ttyc2
[   14.168647] PM: Adding info for No Bus:ttyc3
[   14.168737] PM: Adding info for No Bus:ttyc4
[   14.168822] PM: Adding info for No Bus:ttyc5
[   14.168914] PM: Adding info for No Bus:ttyc6
[   14.169007] PM: Adding info for No Bus:ttyc7
[   14.169092] PM: Adding info for No Bus:ttyc8
[   14.169187] PM: Adding info for No Bus:ttyc9
[   14.169278] PM: Adding info for No Bus:ttyca
[   14.169365] PM: Adding info for No Bus:ttycb
[   14.169466] PM: Adding info for No Bus:ttycc
[   14.169560] PM: Adding info for No Bus:ttycd
[   14.169648] PM: Adding info for No Bus:ttyce
[   14.169743] PM: Adding info for No Bus:ttycf
[   14.169841] PM: Adding info for No Bus:ttyd0
[   14.169931] PM: Adding info for No Bus:ttyd1
[   14.170025] PM: Adding info for No Bus:ttyd2
[   14.170120] PM: Adding info for No Bus:ttyd3
[   14.170209] PM: Adding info for No Bus:ttyd4
[   14.170304] PM: Adding info for No Bus:ttyd5
[   14.170399] PM: Adding info for No Bus:ttyd6
[   14.170513] PM: Adding info for No Bus:ttyd7
[   14.170605] PM: Adding info for No Bus:ttyd8
[   14.170698] PM: Adding info for No Bus:ttyd9
[   14.170785] PM: Adding info for No Bus:ttyda
[   14.170881] PM: Adding info for No Bus:ttydb
[   14.170975] PM: Adding info for No Bus:ttydc
[   14.171065] PM: Adding info for No Bus:ttydd
[   14.171158] PM: Adding info for No Bus:ttyde
[   14.171255] PM: Adding info for No Bus:ttydf
[   14.171344] PM: Adding info for No Bus:ttye0
[   14.171448] PM: Adding info for No Bus:ttye1
[   14.171544] PM: Adding info for No Bus:ttye2
[   14.171638] PM: Adding info for No Bus:ttye3
[   14.171737] PM: Adding info for No Bus:ttye4
[   14.171836] PM: Adding info for No Bus:ttye5
[   14.171925] PM: Adding info for No Bus:ttye6
[   14.172022] PM: Adding info for No Bus:ttye7
[   14.172122] PM: Adding info for No Bus:ttye8
[   14.172213] PM: Adding info for No Bus:ttye9
[   14.172308] PM: Adding info for No Bus:ttyea
[   14.172457] PM: Adding info for No Bus:ttyeb
[   14.172551] PM: Adding info for No Bus:ttyec
[   14.172655] PM: Adding info for No Bus:ttyed
[   14.172749] PM: Adding info for No Bus:ttyee
[   14.172842] PM: Adding info for No Bus:ttyef
[   14.172934] PM: Adding info for No Bus:rtc
[   14.172996] Real Time Clock Driver v1.12ac
[   14.173076] PM: Adding info for No Bus:hpet
[   14.173229] Linux agpgart interface v0.102 (c) Dave Jones
[   14.173289] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[   14.173484] PM: Adding info for platform:serial8250
[   14.173713] PM: Adding info for No Bus:ttyS0
[   14.173872] PM: Adding info for No Bus:ttyS1
[   14.173958] PM: Adding info for No Bus:ttyS2
[   14.174039] PM: Adding info for No Bus:ttyS3
[   14.174322] ACPI: PCI Interrupt 0000:00:14.6[B] -> GSI 17 (level, low) -> IRQ 17
[   14.174463] ACPI: PCI interrupt for device 0000:00:14.6 disabled
[   14.175504] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
[   14.175698] PM: Adding info for No Bus:lo
[   14.176035] ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 16
[   14.176294] ata1: PATA max UDMA/100 cmd 0x00000000000101f0 ctl 0x00000000000103f6 bmdma 0x0000000000014010 irq 14
[   14.176444] ata2: PATA max UDMA/100 cmd 0x0000000000010170 ctl 0x0000000000010376 bmdma 0x0000000000014018 irq 15
[   14.176550] scsi0 : pata_atiixp
[   14.176616] PM: Adding info for No Bus:host0
[   14.347320] ata1.00: ATA-6: ST9808211A, 3.02, max UDMA/100
[   14.347380] ata1.00: 156301488 sectors, multi 16: LBA48 
[   14.367169] ata1.00: configured for UDMA/100
[   14.367234] scsi1 : pata_atiixp
[   14.367299] PM: Adding info for No Bus:host1
[   14.672855] ata2.00: ATAPI, max MWDMA2
[   14.827600] ata2.00: configured for MWDMA2
[   14.827672] PM: Adding info for No Bus:target0:0:0
[   14.827958] scsi 0:0:0:0: Direct-Access     ATA      ST9808211A       3.02 PQ: 0 ANSI: 5
[   14.828097] PM: Adding info for scsi:0:0:0:0
[   14.828283] PM: Adding info for No Bus:target1:0:0
[   14.830091] scsi 1:0:0:0: CD-ROM            MATSHITA UJ-840D          1.02 PQ: 0 ANSI: 5
[   14.830177] PM: Adding info for scsi:1:0:0:0
[   14.830426] PNP: PS/2 Controller [PNP0303:C1C8,PNP0f13:C1C9] at 0x60,0x64 irq 1,12
[   14.830575] PM: Adding info for platform:i8042
[   14.832395] i8042.c: Detected active multiplexing controller, rev 1.1.
[   14.833236] serio: i8042 KBD port at 0x60,0x64 irq 1
[   14.833344] PM: Adding info for serio:serio0
[   14.833405] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[   14.833470] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[   14.833531] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[   14.833591] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[   14.833725] PM: Adding info for serio:serio1
[   14.833792] PM: Adding info for No Bus:psaux
[   14.833853] PM: Adding info for serio:serio2
[   14.833898] mice: PS/2 mouse device common for all mice
[   14.834016] PM: Adding info for serio:serio3
[   14.834212] TCP cubic registered
[   14.834279] NET: Registered protocol family 1
[   14.834803] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[   14.834913] Freeing unused kernel memory: 204k freed
[   14.835241] PM: Adding info for No Bus:vcs1
[   14.835376] PM: Adding info for No Bus:vcsa1
[   14.836359] PM: Adding info for serio:serio4
[   14.913585] PM: Adding info for No Bus:vcs2
[   14.913661] PM: Adding info for No Bus:vcsa2
[   14.914102] PM: Removing info for No Bus:vcs2
[   14.914292] PM: Removing info for No Bus:vcsa2
[   14.915704] input: AT Translated Set 2 keyboard as /class/input/input0
[   14.916498] PM: Adding info for No Bus:vcs2
[   14.916567] PM: Adding info for No Bus:vcsa2
[   14.919315] PM: Removing info for No Bus:vcs2
[   14.919388] PM: Removing info for No Bus:vcsa2
[   14.920918] PM: Adding info for No Bus:vcs2
[   14.920970] PM: Adding info for No Bus:vcsa2
[   14.922236] PM: Removing info for No Bus:vcs2
[   14.922335] PM: Removing info for No Bus:vcsa2
[   14.923234] PM: Adding info for No Bus:vcs3
[   14.923297] PM: Adding info for No Bus:vcsa3
[   14.923810] PM: Removing info for No Bus:vcs3
[   14.923862] PM: Removing info for No Bus:vcsa3
[   14.925629] PM: Adding info for No Bus:vcs3
[   14.925702] PM: Adding info for No Bus:vcsa3
[   14.928452] PM: Removing info for No Bus:vcs3
[   14.928525] PM: Removing info for No Bus:vcsa3
[   14.929865] PM: Adding info for No Bus:vcs3
[   14.929921] PM: Adding info for No Bus:vcsa3
[   14.931120] PM: Removing info for No Bus:vcs3
[   14.931192] PM: Removing info for No Bus:vcsa3
[   14.932042] PM: Adding info for No Bus:vcs4
[   14.932095] PM: Adding info for No Bus:vcsa4
[   14.932548] PM: Removing info for No Bus:vcs4
[   14.932599] PM: Removing info for No Bus:vcsa4
[   14.934362] PM: Adding info for No Bus:vcs4
[   14.934431] PM: Adding info for No Bus:vcsa4
[   14.937068] PM: Removing info for No Bus:vcs4
[   14.937137] PM: Removing info for No Bus:vcsa4
[   14.938466] PM: Adding info for No Bus:vcs4
[   14.938518] PM: Adding info for No Bus:vcsa4
[   14.939686] PM: Removing info for No Bus:vcs4
[   14.939758] PM: Removing info for No Bus:vcsa4
[   14.940622] PM: Adding info for No Bus:vcs5
[   14.940675] PM: Adding info for No Bus:vcsa5
[   14.941094] PM: Removing info for No Bus:vcs5
[   14.941146] PM: Removing info for No Bus:vcsa5
[   14.942920] PM: Adding info for No Bus:vcs5
[   14.942988] PM: Adding info for No Bus:vcsa5
[   14.945651] PM: Removing info for No Bus:vcs5
[   14.945722] PM: Removing info for No Bus:vcsa5
[   14.947066] PM: Adding info for No Bus:vcs5
[   14.947118] PM: Adding info for No Bus:vcsa5
[   14.948305] PM: Removing info for No Bus:vcs5
[   14.948374] PM: Removing info for No Bus:vcsa5
[   14.949209] PM: Adding info for No Bus:vcs6
[   14.949271] PM: Adding info for No Bus:vcsa6
[   14.949704] PM: Removing info for No Bus:vcs6
[   14.949755] PM: Removing info for No Bus:vcsa6
[   14.951523] PM: Adding info for No Bus:vcs6
[   14.951596] PM: Adding info for No Bus:vcsa6
[   14.954304] PM: Removing info for No Bus:vcs6
[   14.954374] PM: Removing info for No Bus:vcsa6
[   14.955702] PM: Adding info for No Bus:vcs6
[   14.955756] PM: Adding info for No Bus:vcsa6
[   14.956948] PM: Removing info for No Bus:vcs6
[   14.957016] PM: Removing info for No Bus:vcsa6
[   15.011336] ACPI: Transitioning device [C255] to D3
[   15.011401] ACPI: Transitioning device [C255] to D3
[   15.011462] ACPI: Fan [C255] (off)
[   15.011834] ACPI: Transitioning device [C256] to D3
[   15.011894] ACPI: Transitioning device [C256] to D3
[   15.011954] ACPI: Fan [C256] (off)
[   15.012343] ACPI: Transitioning device [C257] to D3
[   15.012402] ACPI: Transitioning device [C257] to D3
[   15.012462] ACPI: Fan [C257] (off)
[   15.012830] ACPI: Transitioning device [C258] to D3
[   15.012889] ACPI: Transitioning device [C258] to D3
[   15.012949] ACPI: Fan [C258] (off)
[   15.020037] ACPI: CPU0 (power states: C1[C1] C3[C3])
[   15.020221] ACPI: Processor [C000] (supports 8 throttling states)
[   15.036059] ACPI: Thermal Zone [TZ1] (66 C)
[   15.041893] ACPI: Thermal Zone [TZ2] (53 C)
[   15.051285] ACPI: Thermal Zone [TZ3] (33 C)
[   15.054922] ACPI: Thermal Zone [TZ4] (34 C)
[   15.324729] usbcore: registered new interface driver usbfs
[   15.324906] usbcore: registered new interface driver hub
[   15.325022] usbcore: registered new device driver usb
[   15.326550] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[   15.326609] ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 19 (level, low) -> IRQ 19
[   15.326751] ohci_hcd 0000:00:13.0: OHCI Host Controller
[   15.327864] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 1
[   15.327966] ohci_hcd 0000:00:13.0: irq 19, io mem 0xd0a00000
[   15.385458] PM: Adding info for usb:usb1
[   15.385837] PM: Adding info for No Bus:usbdev1.1_ep00
[   15.385869] usb usb1: configuration #1 chosen from 1 choice
[   15.385978] PM: Adding info for usb:1-0:1.0
[   15.386174] hub 1-0:1.0: USB hub found
[   15.386311] hub 1-0:1.0: 4 ports detected
[   15.418490] ieee1394: Initialized config rom entry `ip1394'
[   15.487891] PM: Adding info for No Bus:usbdev1.1_ep81
[   15.488218] PM: Adding info for No Bus:usbdev1.1
[   15.488681] ACPI: PCI Interrupt 0000:00:13.1[A] -> GSI 19 (level, low) -> IRQ 19
[   15.488820] ohci_hcd 0000:00:13.1: OHCI Host Controller
[   15.488922] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 2
[   15.489022] ohci_hcd 0000:00:13.1: irq 19, io mem 0xd0a01000
[   15.543987] PM: Adding info for usb:usb2
[   15.544084] PM: Adding info for No Bus:usbdev2.1_ep00
[   15.544107] usb usb2: configuration #1 chosen from 1 choice
[   15.544195] PM: Adding info for usb:2-0:1.0
[   15.544221] hub 2-0:1.0: USB hub found
[   15.544299] hub 2-0:1.0: 4 ports detected
[   15.649122] PM: Adding info for No Bus:usbdev2.1_ep81
[   15.649199] PM: Adding info for No Bus:usbdev2.1
[   15.649431] ACPI: PCI Interrupt 0000:00:13.2[A] -> GSI 19 (level, low) -> IRQ 19
[   15.649574] ehci_hcd 0000:00:13.2: EHCI Host Controller
[   15.649667] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 3
[   15.649819] PCI: Enabling Mem-Wr-Inval for device 0000:00:13.2
[   15.649829] ehci_hcd 0000:00:13.2: irq 19, io mem 0xd0a02000
[   15.649900] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   15.650131] PM: Adding info for usb:usb3
[   15.650194] PM: Adding info for No Bus:usbdev3.1_ep00
[   15.650240] usb usb3: configuration #1 chosen from 1 choice
[   15.650315] PM: Adding info for usb:3-0:1.0
[   15.650340] hub 3-0:1.0: USB hub found
[   15.650477] hub 3-0:1.0: 8 ports detected
[   15.751220] PM: Adding info for No Bus:usbdev3.1_ep81
[   15.751287] PM: Adding info for No Bus:usbdev3.1
[   15.752166] tg3.c:v3.74 (February 20, 2007)
[   15.752261] ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 23 (level, low) -> IRQ 23
[   15.788932] PM: Adding info for No Bus:eth0
[   15.789089] eth0: Tigon3 [partno(BCM95788A50) rev 3003 PHY(5705)] (PCI:33MHz:32-bit) 10/100/1000Base-T Ethernet 00:0f:b0:bb:bc:f8
[   15.789393] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] Split[0] WireSpeed[0] TSOcap[1] 
[   15.789473] eth0: dma_rwctrl[763f0000] dma_mask[32-bit]
[   15.790596] ACPI: PCI Interrupt 0000:02:04.2[C] -> GSI 21 (level, low) -> IRQ 21
[   15.790714] PCI: Calling quirk ffffffff803d0690 for 0000:02:04.2
[   15.790844] PM: Adding info for ieee1394:fw-host0
[   15.813995] SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
[   15.814373] sda: Write Protect is off
[   15.814432] sda: Mode Sense: 00 3a 00 00
[   15.814458] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.815459] SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
[   15.815531] sda: Write Protect is off
[   15.815588] sda: Mode Sense: 00 3a 00 00
[   15.815612] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.815815]  sda:<6>ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21]  MMIO=[d0013000-d00137ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[   15.909674]  sda1 sda2 sda3 < sda5 >
[   15.936200] sd 0:0:0:0: Attached scsi disk sda
[   15.941001] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   15.941092] sr 1:0:0:0: Attached scsi generic sg1 type 5
[   15.951267] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[   15.951337] Uniform CD-ROM driver Revision: 3.20
[   15.951603] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   16.245366] usb 2-1: new full speed USB device using ohci_hcd and address 2
[   16.379833] PM: Adding info for usb:2-1
[   16.379911] PM: Adding info for No Bus:usbdev2.2_ep00
[   16.379936] usb 2-1: configuration #1 chosen from 1 choice
[   16.381932] PM: Adding info for usb:2-1:1.0
[   16.382013] PM: Adding info for No Bus:usbdev2.2_ep81
[   16.382052] PM: Adding info for No Bus:usbdev2.2_ep02
[   16.382117] PM: Adding info for No Bus:usbdev2.2
[   16.483145] Attempting manual resume
[   16.483206] swsusp: Resume From Partition 8:5
[   16.483208] PM: Checking swsusp image.
[   16.483688] PM: Resume from disk failed.
[   16.528666] kjournald starting.  Commit interval 5 seconds
[   16.529150] EXT3-fs: mounted filesystem with writeback data mode.
[   16.981708] PM: Removing info for No Bus:vcs1
[   16.981755] PM: Removing info for No Bus:vcsa1
[   16.981825] PM: Adding info for No Bus:vcs1
[   16.981846] PM: Adding info for No Bus:vcsa1
[   17.117701] PM: Adding info for ieee1394:00023f99294d520a
[   17.117858] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023f99294d520a]
[   17.117887] PM: Adding info for ieee1394:00023f99294d520a-0
[   29.448749] PM: Adding info for No Bus:vcs2
[   29.448797] PM: Adding info for No Bus:vcsa2
[   29.449960] PM: Removing info for No Bus:vcs2
[   29.449995] PM: Removing info for No Bus:vcsa2
[   29.450121] PM: Adding info for No Bus:vcs3
[   29.450144] PM: Adding info for No Bus:vcsa3
[   29.451249] PM: Removing info for No Bus:vcs3
[   29.451278] PM: Removing info for No Bus:vcsa3
[   29.451399] PM: Adding info for No Bus:vcs4
[   29.451419] PM: Adding info for No Bus:vcsa4
[   29.452524] PM: Removing info for No Bus:vcs4
[   29.452553] PM: Removing info for No Bus:vcsa4
[   29.452673] PM: Adding info for No Bus:vcs5
[   29.452693] PM: Adding info for No Bus:vcsa5
[   29.453798] PM: Removing info for No Bus:vcs5
[   29.453828] PM: Removing info for No Bus:vcsa5
[   29.453950] PM: Adding info for No Bus:vcs6
[   29.453970] PM: Adding info for No Bus:vcsa6
[   29.455089] PM: Removing info for No Bus:vcs6
[   29.455118] PM: Removing info for No Bus:vcsa6
[   32.664618] input: PC Speaker as /class/input/input1
[   33.375214] ieee80211_crypt: registered algorithm 'NULL'
[   33.426468] sdhci: Secure Digital Host Controller Interface driver
[   33.426533] sdhci: Copyright(c) Pierre Ossman
[   33.426669] sdhci: SDHCI controller found at 0000:02:04.4 [104c:8034] (rev 0)
[   33.426732] sdhci [sdhci_probe()]: found 3 slot(s)
[   33.426754] ACPI: PCI Interrupt 0000:02:04.4[C] -> GSI 21 (level, low) -> IRQ 21
[   33.426892] sdhci [sdhci_probe_slot()]: slot 0 at 0xd001a000, irq 21
[   33.426929] sdhci: ============== REGISTER DUMP ==============
[   33.426935] sdhci: Sys addr: 0x00000000 | Version:  0x00008400
[   33.426940] sdhci: Blk size: 0x00000000 | Blk cnt:  0x00000000
[   33.426946] sdhci: Argument: 0x00000000 | Trn mode: 0x00000000
[   33.426951] sdhci: Present:  0x00020000 | Host ctl: 0x00000000
[   33.426957] sdhci: Power:    0x00000000 | Blk gap:  0x00000000
[   33.426962] sdhci: Wake-up:  0x00000000 | Clock:    0x00000002
[   33.426967] sdhci: Timeout:  0x00000000 | Int stat: 0x00000000
[   33.426973] sdhci: Int enab: 0x00ff00fb | Sig enab: 0x00ff00fb
[   33.426979] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[   33.426984] sdhci: Caps:     0x01821090 | Max curr: 0x00000000
[   33.426986] sdhci: ===========================================
[   33.427248] PM: Adding info for No Bus:mmc0
[   33.427283] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
[   33.427364] mmc0: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 21 width 0 timing 0
[   33.427371] mmc0: SDHCI at 0xd001a000 irq 21 DMA
[   33.427434] sdhci [sdhci_probe_slot()]: slot 1 at 0xd001b000, irq 21
[   33.427455] sdhci: ============== REGISTER DUMP ==============
[   33.427461] sdhci: Sys addr: 0x00000000 | Version:  0x00008400
[   33.427466] sdhci: Blk size: 0x00000000 | Blk cnt:  0x00000000
[   33.427471] sdhci: Argument: 0x00000000 | Trn mode: 0x00000000
[   33.427477] sdhci: Present:  0x00020000 | Host ctl: 0x00000000
[   33.427482] sdhci: Power:    0x00000000 | Blk gap:  0x00000000
[   33.427488] sdhci: Wake-up:  0x00000000 | Clock:    0x00000002
[   33.427493] sdhci: Timeout:  0x00000000 | Int stat: 0x00000000
[   33.427499] sdhci: Int enab: 0x00ff00fb | Sig enab: 0x00ff00fb
[   33.427505] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[   33.427510] sdhci: Caps:     0x01821090 | Max curr: 0x00000000
[   33.427512] sdhci: ===========================================
[   33.427525] PM: Adding info for No Bus:mmc1
[   33.427548] mmc1: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
[   33.427557] mmc1: SDHCI at 0xd001b000 irq 21 DMA
[   33.427619] sdhci [sdhci_probe_slot()]: slot 2 at 0xd001c000, irq 21
[   33.427641] sdhci: ============== REGISTER DUMP ==============
[   33.427647] sdhci: Sys addr: 0x00000000 | Version:  0x00008400
[   33.427652] sdhci: Blk size: 0x00000000 | Blk cnt:  0x00000000
[   33.427658] sdhci: Argument: 0x00000000 | Trn mode: 0x00000000
[   33.427663] sdhci: Present:  0x000a0000 | Host ctl: 0x00000000
[   33.427669] sdhci: Power:    0x00000000 | Blk gap:  0x00000000
[   33.427674] sdhci: Wake-up:  0x00000000 | Clock:    0x00000002
[   33.427680] sdhci: Timeout:  0x00000000 | Int stat: 0x00000000
[   33.427686] sdhci: Int enab: 0x00ff00fb | Sig enab: 0x00ff00fb
[   33.427691] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[   33.427697] sdhci: Caps:     0x01821898 | Max curr: 0x00000000
[   33.427699] sdhci: ===========================================
[   33.427715] PM: Adding info for No Bus:mmc2
[   33.427739] mmc2: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
[   33.427747] mmc2: SDHCI at 0xd001c000 irq 21 DMA
[   33.428855] mmc0: clock 62500Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[   33.431849] mmc0: clock 62500Hz busmode 1 powermode 2 cs 1 Vdd 21 width 0 timing 0
[   33.433852] mmc0: starting CMD0 arg 00000000 flags 00000040
[   33.434276] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (0)
[   33.434285] mmc0: req done (CMD0): 1/0/0: 00000000 00000000 00000000 00000000
[   33.435847] mmc0: clock 62500Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[   33.437846] mmc0: starting CMD8 arg 000001aa flags 00000075
[   33.438797] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (8)
[   33.438807] mmc0: req done (CMD8): 1/0/0: 00000000 00000000 00000000 00000000
[   33.438814] mmc0: starting CMD55 arg 00000000 flags 00000015
[   33.438841] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
[   33.439855] mmc0: req done (CMD55): 1/0/0: 00000000 00000000 00000000 00000000
[   33.439885] mmc0: starting CMD55 arg 00000000 flags 00000015
[   33.440835] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
[   33.440845] mmc0: req done (CMD55): 1/0/0: 00000000 00000000 00000000 00000000
[   33.440850] mmc0: starting CMD55 arg 00000000 flags 00000015
[   33.441768] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
[   33.441777] mmc0: req done (CMD55): 1/0/0: 00000000 00000000 00000000 00000000
[   33.441783] mmc0: starting CMD55 arg 00000000 flags 00000015
[   33.441842] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
[   33.441851] mmc0: req done (CMD55): 1/0/0: 00000000 00000000 00000000 00000000
[   33.441867] mmc0: starting CMD1 arg 00000000 flags 00000061
[   33.442832] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (1)
[   33.443872] mmc0: req done (CMD1): 1/0/0: 00000000 00000000 00000000 00000000
[   33.443896] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
[   33.443908] mmc1: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 21 width 0 timing 0
[   33.444502] piix4_smbus 0000:00:14.0: Found 0000:00:14.0 device
[   33.445282] PM: Adding info for No Bus:i2c-0
[   33.445859] mmc1: clock 62500Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[   33.448835] mmc1: clock 62500Hz busmode 1 powermode 2 cs 1 Vdd 21 width 0 timing 0
[   33.456716] PM: Writing back config space on device 0000:02:01.0 at offset b (was 3ed173b, writing 308b103c)
[   33.456740] PM: Writing back config space on device 0000:02:01.0 at offset 3 (was 0, writing 4010)
[   33.456748] PM: Writing back config space on device 0000:02:01.0 at offset 2 (was 2000000, writing 2000003)
[   33.456755] PM: Writing back config space on device 0000:02:01.0 at offset 1 (was 2b00000, writing 2b00006)
[   33.456762] PM: Writing back config space on device 0000:02:01.0 at offset 0 (was 3ed173b, writing 169c14e4)
[   33.756657] mmc1: starting CMD0 arg 00000000 flags 00000040
[   33.757368] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (0)
[   33.758407] mmc1: req done (CMD0): 1/0/0: 00000000 00000000 00000000 00000000
[   33.760364] mmc1: clock 62500Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[   33.762364] mmc1: starting CMD8 arg 000001aa flags 00000075
[   33.762407] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (8)
[   33.762416] mmc1: req done (CMD8): 1/0/0: 00000000 00000000 00000000 00000000
[   33.762421] mmc1: starting CMD55 arg 00000000 flags 00000015
[   33.763374] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
[   33.763383] mmc1: req done (CMD55): 1/0/0: 00000000 00000000 00000000 00000000
[   33.763397] mmc1: starting CMD55 arg 00000000 flags 00000015
[   33.764361] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
[   33.764370] mmc1: req done (CMD55): 1/0/0: 00000000 00000000 00000000 00000000
[   33.764375] mmc1: starting CMD55 arg 00000000 flags 00000015
[   33.765036] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
[   33.765046] mmc1: req done (CMD55): 1/0/0: 00000000 00000000 00000000 00000000
[   33.765124] mmc1: starting CMD55 arg 00000000 flags 00000015
[   33.765330] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
[   33.765339] mmc1: req done (CMD55): 1/0/0: 00000000 00000000 00000000 00000000
[   33.765350] mmc1: starting CMD1 arg 00000000 flags 00000061
[   33.766303] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (1)
[   33.766312] mmc1: req done (CMD1): 1/0/0: 00000000 00000000 00000000 00000000
[   33.766319] mmc1: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
[   33.766331] mmc2: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 21 width 0 timing 0
[   33.767348] mmc2: clock 93750Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[   33.770348] mmc2: clock 93750Hz busmode 1 powermode 2 cs 1 Vdd 21 width 0 timing 0
[   33.772345] mmc2: starting CMD0 arg 00000000 flags 00000040
[   33.773340] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (0)
[   33.773350] mmc2: req done (CMD0): 1/0/0: 00000000 00000000 00000000 00000000
[   33.775342] mmc2: clock 93750Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[   33.777343] mmc2: starting CMD8 arg 000001aa flags 00000075
[   33.777635] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (8)
[   33.777645] mmc2: req done (CMD8): 1/0/0: 00000000 00000000 00000000 00000000
[   33.777720] mmc2: starting CMD55 arg 00000000 flags 00000015
[   33.778333] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
[   33.778342] mmc2: req done (CMD55): 1/0/0: 00000000 00000000 00000000 00000000
[   33.778346] mmc2: starting CMD55 arg 00000000 flags 00000015
[   33.779330] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
[   33.779339] mmc2: req done (CMD55): 1/0/0: 00000000 00000000 00000000 00000000
[   33.779344] mmc2: starting CMD55 arg 00000000 flags 00000015
[   33.780332] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
[   33.780342] mmc2: req done (CMD55): 1/0/0: 00000000 00000000 00000000 00000000
[   33.780348] mmc2: starting CMD55 arg 00000000 flags 00000015
[   33.780455] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
[   33.780464] mmc2: req done (CMD55): 1/0/0: 00000000 00000000 00000000 00000000
[   33.780536] mmc2: starting CMD1 arg 00000000 flags 00000061
[   33.780767] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (1)
[   33.780776] mmc2: req done (CMD1): 1/0/0: 00000000 00000000 00000000 00000000
[   33.780783] mmc2: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
[   33.824123] Yenta: CardBus bridge found at 0000:02:04.0 [103c:308b]
[   33.824210] Yenta: Enabling burst memory read transactions
[   33.824279] Yenta: Using INTVAL to route CSC interrupts to PCI
[   33.824339] Yenta: Routing CardBus interrupts to PCI
[   33.824402] Yenta TI: socket 0000:02:04.0, mfunc 0x01a11b22, devctl 0x64
[   33.932545] Synaptics Touchpad, model: 1, fw: 6.2, id: 0x1a0b1, caps: 0xa04713/0x200000
[   33.976094] input: SynPS/2 Synaptics TouchPad as /class/input/input2
[   33.987772] ieee80211: 802.11 data/management/control stack, git-1.1.13
[   33.987841] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[   34.047954] Yenta: ISA IRQ mask 0x0ef8, PCI irq 20
[   34.048024] Socket status: 30000006
[   34.048084] Yenta: Raising subordinate bus# of parent bus (#02) from #03 to #06
[   34.048170] pcmcia: parent PCI bridge I/O window: 0x2000 - 0x2fff
[   34.048455] pcmcia: parent PCI bridge Memory window: 0xd0000000 - 0xd05fffff
[   34.048516] pcmcia: parent PCI bridge Memory window: 0x50000000 - 0x53ffffff
[   34.049061] PM: Adding info for No Bus:pcmcia_socket0
[   34.049635] ACPI: PCI Interrupt 0000:02:04.3[B] -> GSI 21 (level, low) -> IRQ 21
[   34.244489] bcm43xx driver
[   34.244746] ACPI: PCI Interrupt 0000:02:02.0[A] -> GSI 22 (level, low) -> IRQ 22
[   34.244911] bcm43xx: Chip ID 0x4306, rev 0x3
[   34.244969] bcm43xx: Number of cores: 5
[   34.245027] bcm43xx: Core 0: ID 0x800, rev 0x4, vendor 0x4243
[   34.245092] bcm43xx: Core 1: ID 0x812, rev 0x5, vendor 0x4243
[   34.245158] bcm43xx: Core 2: ID 0x80d, rev 0x2, vendor 0x4243
[   34.245222] bcm43xx: Core 3: ID 0x807, rev 0x2, vendor 0x4243
[   34.245287] bcm43xx: Core 4: ID 0x804, rev 0x9, vendor 0x4243
[   34.248718] bcm43xx: PHY connected
[   34.248791] bcm43xx: Detected PHY: Analog: 2, Type 2, Revision 2
[   34.248871] bcm43xx: Detected Radio: ID: 2205017f (Manuf: 17f Ver: 2050 Rev: 2)
[   34.248969] bcm43xx: Radio turned off
[   34.249152] bcm43xx: Radio turned off
[   34.249334] PM: Adding info for No Bus:eth1
[   34.329776] PM: Adding info for No Bus:timer
[   34.417232] PM: Adding info for No Bus:seq
[   34.501195] PM: Adding info for No Bus:sequencer
[   34.502013] PM: Adding info for No Bus:sequencer2
[   34.775745] ACPI: PCI Interrupt 0000:00:14.6[B] -> GSI 17 (level, low) -> IRQ 17
[   34.775898] PCI: Enabling bus mastering for device 0000:00:14.6
[   34.878755] MC'97 0 converters and GPIO not ready (0x1)
[   34.880165] PM: Adding info for No Bus:card1
[   34.880385] PM: Adding info for No Bus:pcmC1D0p
[   34.880840] PM: Adding info for No Bus:pcmC1D0c
[   34.881045] PM: Adding info for No Bus:dsp1
[   34.881277] PM: Adding info for No Bus:audio1
[   34.881566] PM: Adding info for ac97:1-0:unknown codec
[   34.881611] PM: Adding info for No Bus:controlC1
[   34.881683] PM: Adding info for No Bus:mixer1
[   34.882363] ACPI: PCI Interrupt 0000:00:14.5[B] -> GSI 17 (level, low) -> IRQ 17
[   34.893771] PM: Adding info for No Bus:card0
[   34.893841] PM: Adding info for No Bus:pcmC0D0p
[   34.893896] PM: Adding info for No Bus:pcmC0D0c
[   34.893948] PM: Adding info for No Bus:dsp
[   34.894006] PM: Adding info for No Bus:audio
[   34.894052] PM: Adding info for ac97:0-0:unknown codec
[   34.894097] PM: Adding info for No Bus:controlC0
[   34.894151] PM: Adding info for No Bus:mixer
[   35.036804] bcm43xx: PHY connected
[   35.037445] PM: Adding info for No Bus:0000:02:02.0
[   35.132213] PM: Removing info for No Bus:0000:02:02.0
[   35.133618] PM: Adding info for No Bus:0000:02:02.0
[   35.168167] PM: Removing info for No Bus:0000:02:02.0
[   35.168817] PM: Adding info for No Bus:0000:02:02.0
[   35.210926] PM: Removing info for No Bus:0000:02:02.0
[   35.211490] PM: Adding info for No Bus:0000:02:02.0
[   35.243883] PM: Removing info for No Bus:0000:02:02.0
[   35.309375] bcm43xx: Microcode rev 0x127, pl 0xe (2005-04-18  02:36:27)
[   35.317742] bcm43xx: Radio turned on
[   35.317810] bcm43xx: Radio disabled by hardware
[   35.465839] bcm43xx: Chip initialized
[   35.466275] bcm43xx: 30-bit DMA initialized
[   35.466551] bcm43xx: Keys cleared
[   35.466881] bcm43xx: Selected 802.11 core (phytype 2)
[   35.467599] PM: Adding info for No Bus:hw_random
[   35.536019] NET: Registered protocol family 17
[   35.761697] Adding 1116476k swap on /dev/disk/by-uuid/45b6bcfd-44ec-4878-8110-f2164f9e8051.  Priority:-1 extents:1 across:1116476k
[   35.903997] EXT3 FS on sda2, internal journal
[   36.175287] PM: Adding info for No Bus:device-mapper
[   36.177146] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
[   36.481997] NTFS driver 2.1.28 [Flags: R/O MODULE].
[   36.537944] NTFS volume version 3.1.
[   36.812257] PM: Adding info for No Bus:vcs2
[   36.812455] PM: Adding info for No Bus:vcsa2
[   36.816664] PM: Removing info for No Bus:vcs2
[   36.817011] PM: Removing info for No Bus:vcsa2
[   36.821152] PM: Adding info for No Bus:vcs2
[   36.821323] PM: Adding info for No Bus:vcsa2
[   36.828028] PM: Removing info for No Bus:vcs2
[   36.828227] PM: Removing info for No Bus:vcsa2
[   36.831208] PM: Adding info for No Bus:vcs3
[   36.831358] PM: Adding info for No Bus:vcsa3
[   36.835523] PM: Removing info for No Bus:vcs3
[   36.835700] PM: Removing info for No Bus:vcsa3
[   36.839776] PM: Adding info for No Bus:vcs3
[   36.839976] PM: Adding info for No Bus:vcsa3
[   36.846752] PM: Removing info for No Bus:vcs3
[   36.846958] PM: Removing info for No Bus:vcsa3
[   36.849938] PM: Adding info for No Bus:vcs4
[   36.850089] PM: Adding info for No Bus:vcsa4
[   36.854203] PM: Removing info for No Bus:vcs4
[   36.854381] PM: Removing info for No Bus:vcsa4
[   36.858466] PM: Adding info for No Bus:vcs4
[   36.858643] PM: Adding info for No Bus:vcsa4
[   36.865401] PM: Removing info for No Bus:vcs4
[   36.865597] PM: Removing info for No Bus:vcsa4
[   36.868583] PM: Adding info for No Bus:vcs5
[   36.868732] PM: Adding info for No Bus:vcsa5
[   36.872895] PM: Removing info for No Bus:vcs5
[   36.873069] PM: Removing info for No Bus:vcsa5
[   36.877326] PM: Adding info for No Bus:vcs5
[   36.877500] PM: Adding info for No Bus:vcsa5
[   36.884274] PM: Removing info for No Bus:vcs5
[   36.884477] PM: Removing info for No Bus:vcsa5
[   36.887487] PM: Adding info for No Bus:vcs6
[   36.887635] PM: Adding info for No Bus:vcsa6
[   36.891848] PM: Removing info for No Bus:vcs6
[   36.892027] PM: Removing info for No Bus:vcsa6
[   36.896190] PM: Adding info for No Bus:vcs6
[   36.896366] PM: Adding info for No Bus:vcsa6
[   36.903189] PM: Removing info for No Bus:vcs6
[   36.903389] PM: Removing info for No Bus:vcsa6
[   36.910703] PM: Adding info for No Bus:vcs2
[   36.910881] PM: Adding info for No Bus:vcsa2
[   36.915420] PM: Removing info for No Bus:vcs2
[   36.915605] PM: Removing info for No Bus:vcsa2
[   36.918432] PM: Adding info for No Bus:vcs3
[   36.918581] PM: Adding info for No Bus:vcsa3
[   36.923046] PM: Removing info for No Bus:vcs3
[   36.923233] PM: Removing info for No Bus:vcsa3
[   36.926021] PM: Adding info for No Bus:vcs4
[   36.926171] PM: Adding info for No Bus:vcsa4
[   36.930591] PM: Removing info for No Bus:vcs4
[   36.930794] PM: Removing info for No Bus:vcsa4
[   36.933557] PM: Adding info for No Bus:vcs5
[   36.933718] PM: Adding info for No Bus:vcsa5
[   36.938156] PM: Removing info for No Bus:vcs5
[   36.938340] PM: Removing info for No Bus:vcsa5
[   36.941168] PM: Adding info for No Bus:vcs6
[   36.941315] PM: Adding info for No Bus:vcsa6
[   36.945782] PM: Removing info for No Bus:vcs6
[   36.945967] PM: Removing info for No Bus:vcsa6
[   38.559276] PM: Adding info for No Bus:vcs4
[   38.559454] PM: Adding info for No Bus:vcsa4
[   38.562790] PM: Adding info for No Bus:vcs5
[   38.562928] PM: Adding info for No Bus:vcsa5
[   38.568130] PM: Adding info for No Bus:vcs2
[   38.568304] PM: Adding info for No Bus:vcsa2
[   38.572626] PM: Adding info for No Bus:vcs3
[   38.572798] PM: Adding info for No Bus:vcsa3
[   38.580643] PM: Adding info for No Bus:vcs6
[   38.580837] PM: Adding info for No Bus:vcsa6
[   39.028922] ACPI: Battery Slot [C17C] (battery present)
[   39.029270] ACPI: Battery Slot [C17B] (battery absent)
[   39.056138] ACPI: Video Device [C049] (multi-head: yes  rom: no  post: no)
[   39.072108] toshiba_acpi: Unknown parameter `hotkeys_over_acpi'
[   39.104698] ibm_acpi: ec object not found
[   39.138255] ACPI: AC Adapter [C17A] (on-line)
[   39.195538] input: Power Button (FF) as /class/input/input3
[   39.206965] ACPI: Power Button (FF) [PWRF]
[   39.222476] input: Sleep Button (CM) as /class/input/input4
[   39.233728] ACPI: Sleep Button (CM) [C1F4]
[   39.249158] input: Lid Switch as /class/input/input5
[   39.260425] ACPI: Lid Switch [C1F5]
[   39.456734] powernow-k8: Found 1 AMD Turion(tm) 64 Mobile ML-40                  processors (version 2.00.00)
[   39.467513] powernow-k8:    0 : fid 0xe (2200 MHz), vid 0x4
[   39.467516] powernow-k8:    1 : fid 0xc (2000 MHz), vid 0x6
[   39.467518] powernow-k8:    2 : fid 0xa (1800 MHz), vid 0x8
[   39.467520] powernow-k8:    3 : fid 0x8 (1600 MHz), vid 0xa
[   39.467522] powernow-k8:    4 : fid 0x0 (800 MHz), vid 0x16
[   39.472191] powernow-k8: ph2 null fid transition 0xe
[   40.438162] Time: acpi_pm clocksource has been installed.
[   42.527163] PM: Adding info for No Bus:vcs7
[   42.527675] PM: Adding info for No Bus:vcsa7
[   42.918921] PM: Removing info for No Bus:vcs7
[   42.919227] PM: Removing info for No Bus:vcsa7
[   43.139333] PM: Adding info for No Bus:vcs7
[   43.139653] PM: Adding info for No Bus:vcsa7
[   55.602694] SoftMAC: Associate: Scanning for networks first.
[   55.602769] SoftMAC: Associate: failed to initiate scan. Is device up?
[   55.603494] bcm43xx: set security called, .level = 0, .enabled = 0, .encrypt = 0
[   55.619538] Capability LSM initialized
[   55.829682] SoftMAC: Scanning finished: scanned 14 channels starting with channel 1
[   55.829975] SoftMAC: Associate: Scanning for networks first.
[   56.221102] SoftMAC: Scanning finished: scanned 14 channels starting with channel 1
[   56.221118] SoftMAC: Associate: Scanning for networks first.
[   56.612531] SoftMAC: Scanning finished: scanned 14 channels starting with channel 1
[   56.612550] SoftMAC: Unable to find matching network after scan!
[   57.954165] device eth0 entered promiscuous mode
[   57.954668] audit(1173403779.935:2): dev=eth0 prom=256 old_prom=0 auid=4294967295
[   62.948824] Bluetooth: Core ver 2.11
[   62.948845] PM: Adding info for platform:bluetooth
[   62.948896] NET: Registered protocol family 31
[   62.948898] Bluetooth: HCI device and connection manager initialized
[   62.949100] Bluetooth: HCI socket layer initialized
[   62.978623] Bluetooth: L2CAP ver 2.8
[   62.978627] Bluetooth: L2CAP socket layer initialized
[   63.004441] Bluetooth: RFCOMM socket layer initialized
[   63.004456] Bluetooth: RFCOMM TTY layer initialized
[   63.004458] Bluetooth: RFCOMM ver 1.8
[   67.889244] SoftMAC: Scanning finished: scanned 14 channels starting with channel 1
[   76.317739] SoftMAC: Scanning finished: scanned 14 channels starting with channel 1
[   86.673644] SoftMAC: Scanning finished: scanned 14 channels starting with channel 1
[   94.368186] SoftMAC: Scanning finished: scanned 14 channels starting with channel 1
[   96.000204] APIC error on CPU0: 00(40)
[   96.591701] bcm43xx: Radio hardware status changed to enabled
[   96.718064] usb 1-2: new full speed USB device using ohci_hcd and address 2
[   96.771864] PM: Adding info for usb:1-2
[   96.771934] PM: Adding info for No Bus:usbdev1.2_ep00
[   96.771957] usb 1-2: configuration #1 chosen from 1 choice
[   96.772594] PM: Adding info for usb:1-2:1.0
[   96.772633] PM: Adding info for No Bus:usbdev1.2_ep81
[   96.772669] PM: Adding info for No Bus:usbdev1.2_ep82
[   96.772704] PM: Adding info for No Bus:usbdev1.2_ep02
[   96.772728] PM: Adding info for usb:1-2:1.1
[   96.772770] PM: Adding info for No Bus:usbdev1.2_ep83
[   96.772806] PM: Adding info for No Bus:usbdev1.2_ep03
[   96.772830] PM: Adding info for usb:1-2:1.2
[   96.772871] PM: Adding info for No Bus:usbdev1.2_ep84
[   96.772912] PM: Adding info for No Bus:usbdev1.2_ep04
[   96.772942] PM: Adding info for usb:1-2:1.3
[   96.772994] PM: Adding info for No Bus:usbdev1.2
[   96.902228] Bluetooth: HCI USB driver ver 2.9
[   96.903329] PM: Removing info for No Bus:usbdev1.2_ep83
[   96.903804] PM: Removing info for No Bus:usbdev1.2_ep03
[   96.904218] PM: Adding info for No Bus:usbdev1.2_ep83
[   96.904653] PM: Adding info for No Bus:usbdev1.2_ep03
[   96.905281] PM: Adding info for No Bus:hci0
[   96.966814] usbcore: registered new interface driver hci_usb
[  105.472996] SoftMAC: Scanning finished: scanned 14 channels starting with channel 1
[  105.591439] bcm43xx: set security called, .level = 0, .enabled = 0, .encrypt = 0
[  105.591645] bcm43xx: set security called, .level = 0, .enabled = 0, .encrypt = 0
[  105.591847] bcm43xx: set security called, .level = 0, .enabled = 0, .encrypt = 0
[  105.592042] bcm43xx: set security called, .level = 0, .enabled = 0, .encrypt = 0
[  105.594054] SoftMAC: Associate: Scanning for networks first.
[  105.597686] SoftMAC: Queueing Authentication Request to 00:11:50:d0:a6:e4
[  105.597690] SoftMAC: Cannot associate without being authenticated, requested authentication
[  105.600639] SoftMAC: Sent Authentication Request to 00:11:50:d0:a6:e4.
[  105.601328] SoftMAC: Open Authentication completed with 00:11:50:d0:a6:e4
[  105.604541] SoftMAC: sent association request!
[  105.613037] SoftMAC: associated!
[  105.744244] SoftMAC: Scanning finished: scanned 14 channels starting with channel 1
[  110.384877] tun: Universal TUN/TAP device driver, 1.6
[  110.384882] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[  110.384912] PM: Adding info for No Bus:tun
[  110.386878] PM: Adding info for No Bus:tun0
[  118.384521] SoftMAC: Scanning finished: scanned 14 channels starting with channel 1
[  124.750320] APIC error on CPU0: 40(40)
[  135.292260] APIC error on CPU0: 40(40)
[  142.367094] APIC error on CPU0: 40(40)
[  181.551698] SoftMAC: Scanning finished: scanned 14 channels starting with channel 1
[  229.663655] SoftMAC: Scanning finished: scanned 14 channels starting with channel 1
[  280.463285] SoftMAC: Scanning finished: scanned 14 channels starting with channel 1
[  284.113659] APIC error on CPU0: 40(40)
[  300.795583] APIC error on CPU0: 40(40)
[  325.017202] SoftMAC: Scanning finished: scanned 14 channels starting with channel 1
[  327.798187] APIC error on CPU0: 40(40)
[  369.571839] SoftMAC: Scanning finished: scanned 14 channels starting with channel 1

--------------070303070806090508090900--
