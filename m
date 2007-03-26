Return-Path: <linux-kernel-owner+w=401wt.eu-S1750719AbXCZJFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750719AbXCZJFN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 05:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbXCZJFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 05:05:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36483 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbXCZJFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 05:05:03 -0400
Date: Mon, 26 Mar 2007 11:04:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: 2.6.21-rc5: maxcpus=1 crash in cpufreq: kernel BUG at drivers/cpufreq/cpufreq.c:82!
Message-ID: <20070326090439.GA18484@elte.hu>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit


trying to debug the forcedeth crash triggered another, new
v2.6.20 -> v2.6.21 regression:

maxcpus=1 on a dual-core system crashes the x86_64 SMP kernel in 
lock_policy_rwsem_write() - see the crash log below. Config attached.

i suspect it could be related to this recent commit:

 commit 5a01f2e8f3ac134e24144d74bb48a60236f7024d
 Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
 Date:   Mon Feb 5 16:12:44 2007 -0800

    [CPUFREQ] Rewrite lock in cpufreq to eliminate cpufreq/hotplug related issue

	Ingo

---------------->
Linux version 2.6.21-rc5 (mingo@dione) (gcc version 4.0.2) #14 SMP PREEMPT Mon Mar 26 10:51:51 CEST 2007
Command line: root=/dev/hda5 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 console=tty 3 profile=0 debug initcall_debug noapic apic=debug maxcpus=1 selinux=0 netconsole=4444@10.0.1.12/eth0,4444@10.0.1.14/00:16:76:ab:6e:84 nmi_watchdog=2 ignore_loglevel debug_dir
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
 BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
 BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 262128) 1 entries of 3200 used
end_pfn_map = 1048576
DMI 2.3 present.
ACPI: RSDP 000F76F0, 0014 (r0 Nvidia)
ACPI: RSDT 3FFF3040, 0034 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 3FFF30C0, 0074 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 3FFF3180, 6264 (r1 NVIDIA AWRDACPI     1000 MSFT  100000E)
ACPI: FACS 3FFF0000, 0040
ACPI: SRAT 3FFF9500, 00A0 (r1 AMD    HAMMER          1 AMD         1)
ACPI: MCFG 3FFF9600, 003C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: APIC 3FFF9440, 007C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: Node 0 PXM 0 0-a0000
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
SRAT: Node 0 PXM 0 0-40000000
Entering add_active_range(0, 0, 159) 1 entries of 3200 used
Entering add_active_range(0, 256, 262128) 1 entries of 3200 used
NUMA: Using 63 for the hash shift.
Bootmem setup node 0 0000000000000000-000000003fff0000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   262128
On node 0 totalpages: 262031
  DMA zone: 56 pages used for memmap
  DMA zone: 2414 pages reserved
  DMA zone: 1529 pages, LIFO batch:0
  DMA32 zone: 3527 pages used for memmap
  DMA32 zone: 254505 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: Skipping IOAPIC probe due to 'noapic' option.
Using ACPI for processor (LAPIC) configuration information
Intel MultiProcessor Specification v1.4
MPTABLE: OEM ID: OEM00000 MPTABLE: Product ID: PROD00000000 MPTABLE: APIC at: 0xFEE00000
I/O APIC #2 at 0xFEC00000.
Setting APIC routing to physical flat
Processors: 2
mapped APIC to ffffffffff5fd000 (        fee00000)
mapped IOAPIC to ffffffffff5fc000 (00000000fec00000)
Nosave address range: 000000000009f000 - 00000000000a0000
Nosave address range: 00000000000a0000 - 00000000000f0000
Nosave address range: 00000000000f0000 - 0000000000100000
Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 68480 bytes of per cpu data
Built 1 zonelists.  Total pages: 256034
Kernel command line: root=/dev/hda5 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 console=tty 3 profile=0 debug initcall_debug noapic apic=debug maxcpus=1 selinux=0 netconsole=4444@10.0.1.12/eth0,4444@10.0.1.14/00:16:76:ab:6e:84 nmi_watchdog=2 ignore_loglevel debug_dir
kernel profiling enabled (shift: 0)
debug: ignoring loglevel setting.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
time.c: Detected 2160.233 MHz processor.
disabling early console
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Checking aperture...
CPU 0: aperture @ 230000000 size 32 MB
Aperture too small (32 MB)
No AGP bridge found
Memory: 1009328k/1048512k available (3246k kernel code, 38796k reserved, 2130k data, 372k init)
Calibrating delay using timer specific routine.. 4321.70 BogoMIPS (lpj=2160852)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 0828)
enabled ExtINT on CPU#0
Using local APIC timer interrupts.
result 13501473
Detected 13.501 MHz APIC timer.
Brought up 1 CPUs
testing NMI watchdog ... OK.
Calling initcall 0xffffffff80a30c7c: init_cpufreq_transition_notifier_list+0x0/0x14()
Calling initcall 0xffffffff80a1879f: cpufreq_tsc+0x0/0x60()
Calling initcall 0xffffffff80216f24: init_smp_flush+0x0/0x51()
Calling initcall 0xffffffff80a20bf1: init_elf32_binfmt+0x0/0x12()
Calling initcall 0xffffffff80a21c6f: sysctl_init+0x0/0x16()
Calling initcall 0xffffffff80a22299: helper_init+0x0/0x2b()
Calling initcall 0xffffffff80a22605: pm_init+0x0/0x29()
Calling initcall 0xffffffff80a2262e: pm_disk_init+0x0/0x19()
Calling initcall 0xffffffff80a22ae7: ksysfs_init+0x0/0x29()
Calling initcall 0xffffffff80a25457: filelock_init+0x0/0x31()
Calling initcall 0xffffffff80a25ec8: init_misc_binfmt+0x0/0x3c()
Calling initcall 0xffffffff80a25f04: init_script_binfmt+0x0/0x12()
Calling initcall 0xffffffff80a25f16: init_elf_binfmt+0x0/0x12()
Calling initcall 0xffffffff80a26918: debugfs_init+0x0/0x47()
Calling initcall 0xffffffff80a26e9d: securityfs_init+0x0/0x47()
Calling initcall 0xffffffff80a27e39: random32_init+0x0/0x57()
Calling initcall 0xffffffff80a30c90: cpufreq_core_init+0x0/0x76()
Calling initcall 0xffffffff80a32b06: sock_init+0x0/0x5f()
Calling initcall 0xffffffff80a3325d: netpoll_init+0x0/0x3b()
Calling initcall 0xffffffff80a334e5: netlink_proto_init+0x0/0x16a()
NET: Registered protocol family 16
Calling initcall 0xffffffff80a27d5d: kobject_uevent_init+0x0/0x3a()
Calling initcall 0xffffffff80a28142: pcibus_class_init+0x0/0x12()
Calling initcall 0xffffffff80a286ff: pci_driver_init+0x0/0x12()
Calling initcall 0xffffffff80a290d8: backlight_class_init+0x0/0x12()
Calling initcall 0xffffffff80a2ad14: dock_init+0x0/0x51()
No dock devices found.
Calling initcall 0xffffffff80a2c4c8: tty_class_init+0x0/0x2a()
Calling initcall 0xffffffff80a2cc16: vtconsole_class_init+0x0/0xba()
Calling initcall 0xffffffff80a2e000: register_node_type+0x0/0x12()
Calling initcall 0xffffffff80a18c45: mtrr_if_init+0x0/0x74()
Calling initcall 0xffffffff80a19bd2: ffh_cstate_init+0x0/0x31()
initcall at 0xffffffff80a19bd2: ffh_cstate_init+0x0/0x31(): returned with error code -1
Calling initcall 0xffffffff80a28c2a: acpi_pci_init+0x0/0x2e()
ACPI: bus type pci registered
Calling initcall 0xffffffff80a2a669: init_acpi_device_notify+0x0/0x4b()
Calling initcall 0xffffffff80a3191f: pci_access_init+0x0/0x43()
PCI: Using MMCONFIG at e0000000 - efffffff
PCI: No mmconfig possible on device 00:18
Calling initcall 0xffffffff80a18ab6: mtrr_init_finialize+0x0/0x34()
Calling initcall 0xffffffff80a1e915: topology_init+0x0/0x8d()
Calling initcall 0xffffffff80a2207f: param_sysfs_init+0x0/0x186()
Calling initcall 0xffffffff8025ce7d: pm_sysrq_init+0x0/0x1b()
Calling initcall 0xffffffff80a25b1b: init_bio+0x0/0x101()
Calling initcall 0xffffffff80a27b33: genhd_device_init+0x0/0x56()
Calling initcall 0xffffffff80a28c58: fbmem_init+0x0/0x95()
Calling initcall 0xffffffff80a2a46c: acpi_init+0x0/0x1fd()
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using PIC for interrupt routing
Calling initcall 0xffffffff80a2a6b4: acpi_scan_init+0x0/0x10e()
Calling initcall 0xffffffff80a2a972: acpi_ec_init+0x0/0x61()
Calling initcall 0xffffffff80a2adc3: acpi_pci_root_init+0x0/0x28()
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
0000:00:06.0: cannot adjust BAR0 (not I/O)
0000:00:06.0: cannot adjust BAR1 (not I/O)
0000:00:06.0: cannot adjust BAR2 (not I/O)
0000:00:06.0: cannot adjust BAR3 (not I/O)
PCI: Transparent bridge - 0000:00:09.0
Boot video device is 0000:01:00.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
Calling initcall 0xffffffff80a2aed8: acpi_pci_link_init+0x0/0x48()
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LACI] (IRQs *3 4 5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LPCA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.
ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0, disabled.
ACPI: PCI Interrupt Link [APC4] (IRQs<7>spurious 8259A interrupt: IRQ7.
 19) *0, disabled.
ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
Calling initcall 0xffffffff80a2afc1: acpi_power_init+0x0/0x77()
Calling initcall 0xffffffff80a2b1b5: acpi_system_init+0x0/0xc6()
Calling initcall 0xffffffff80a2b27b: acpi_event_init+0x0/0x3f()
Calling initcall 0xffffffff80a2be66: acpi_cm_sbs_init+0x0/0x8()
Calling initcall 0xffffffff80a2be6e: pnp_init+0x0/0x20()
Linux Plug and Play Support v0.97 (c) Adam Belay
Calling initcall 0xffffffff80a2bff7: pnpacpi_init+0x0/0x6a()
pnp: PnP ACPI init
pnp: PnP ACPI: found 16 devices
Calling initcall 0xffffffff80a2c938: misc_init+0x0/0x86()
Calling initcall 0xffffffff803d7702: cn_init+0x0/0xce()
Calling initcall 0xffffffff80a2efa8: init_scsi+0x0/0x90()
SCSI subsystem initialized
Calling initcall 0xffffffff80a2f475: ata_init+0x0/0x7b()
libata version 2.20 loaded.
Calling initcall 0xffffffff80a2fa3e: init_pcmcia_cs+0x0/0x38()
Calling initcall 0xffffffff80a30182: usb_init+0x0/0x118()
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Calling initcall 0xffffffff80a30574: serio_init+0x0/0x8b()
Calling initcall 0xffffffff80a3092f: input_init+0x0/0x123()
Calling initcall 0xffffffff80a30d38: leds_init+0x0/0x2a()
Calling initcall 0xffffffff80a313de: dma_bus_init+0x0/0x2c()
Calling initcall 0xffffffff80a31962: pci_acpi_init+0x0/0xab()
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Calling initcall 0xffffffff80a31a0d: pci_legacy_init+0x0/0x124()
Calling initcall 0xffffffff80a31ecd: pcibios_irq_init+0x0/0x494()
Calling initcall 0xffffffff80a32361: pcibios_init+0x0/0x77()
Calling initcall 0xffffffff80a32bc0: proto_init+0x0/0x34()
Calling initcall 0xffffffff80a32d13: net_dev_init+0x0/0x253()
Calling initcall 0xffffffff80a33222: wireless_nlevent_init+0x0/0x3b()
Calling initcall 0xffffffff80a33298: fib_rules_init+0x0/0x12()
Calling initcall 0xffffffff80a333ad: pktsched_init+0x0/0xa6()
Calling initcall 0xffffffff80a33465: tc_filter_init+0x0/0x40()
Calling initcall 0xffffffff80a334a5: tc_action_init+0x0/0x40()
Calling initcall 0xffffffff80a3364f: genl_init+0x0/0xad()
Calling initcall 0xffffffff80a34885: cipso_v4_init+0x0/0x6b()
Calling initcall 0xffffffff80a34c88: netlbl_init+0x0/0x75()
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
Calling initcall 0xffffffff80a184b7: pci_iommu_init+0x0/0x17()
Calling initcall 0xffffffff80a2237e: clocksource_done_booting+0x0/0x12()
Calling initcall 0xffffffff80a253e1<6>Time: tsc clocksource has been installed.
: init_pipe_fs+0x0/0x49()
Calling initcall 0xffffffff80a2bf72: pnp_system_init+0x0/0x12()
pnp: 00:01: ioport range 0x4000-0x407f has been reserved
pnp: 00:01: ioport range 0x4080-0x40ff has been reserved
pnp: 00:01: ioport range 0x4400-0x447f has been reserved
pnp: 00:01: ioport range 0x4480-0x44ff has been reserved
pnp: 00:01: ioport range 0x4800-0x487f has been reserved
pnp: 00:01: ioport range 0x4880-0x48ff has been reserved
pnp: 00:0e: iomem range 0xe0000000-0xefffffff has been reserved
pnp: 00:0f: iomem range 0xf0000-0xf3fff could not be reserved
pnp: 00:0f: iomem range 0xf4000-0xf7fff could not be reserved
pnp: 00:0f: iomem range 0xf8000-0xfbfff could not be reserved
pnp: 00:0f: iomem range 0xfc000-0xfffff could not be reserved
Calling initcall 0xffffffff80a2c3d0: chr_dev_init+0x0/0x88()
Calling initcall 0xffffffff80a2df90: firmware_class_init+0x0/0x70()
Calling initcall 0xffffffff80a2fa76: init_pcmcia_bus+0x0/0x7b()
Calling initcall 0xffffffff80a30d06: cpufreq_gov_performance_init+0x0/0x12()
Calling initcall 0xffffffff80a30d18: cpufreq_gov_userspace_init+0x0/0x20()
Calling initcall 0xffffffff80a31330: init_acpi_pm_clocksource+0x0/0xae()
Calling initcall 0xffffffff80a3140a<6>Time: acpi_pm clocksource has been installed.
: pcibios_assign_resources+0x0/0x8b()
PCI: Bridge: 0000:00:09.0
  IO window: c000-cfff
  MEM window: da000000-da0fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0b.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0d.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0e.0
  IO window: b000-bfff
  MEM window: d8000000-d9ffffff
  PREFETCH window: d0000000-d7ffffff
PCI: Setting latency timer of device 0000:00:09.0 to 64
PCI: Setting latency timer of device 0000:00:0b.0 to 64
PCI: Setting latency timer of device 0000:00:0c.0 to 64
PCI: Setting latency timer of device 0000:00:0d.0 to 64
PCI: Setting latency timer of device 0000:00:0e.0 to 64
Calling initcall 0xffffffff80a32a33: fill_mp_bus_to_cpumask+0x0/0xd3()
Calling initcall 0xffffffff80a34194: inet_init+0x0/0x42d()
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 3145728 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Calling initcall 0xffffffff80a15f52: populate_rootfs+0x0/0xec()
Calling initcall 0xffffffff8020d187: time_init_device+0x0/0x22()
Calling initcall 0xffffffff80a16c9e: init_timer_sysfs+0x0/0x22()
Calling initcall 0xffffffff80a16c7c: i8259A_init_sysfs+0x0/0x22()
Calling initcall 0xffffffff80a17102: vsyscall_init+0x0/0xa8()
Calling initcall 0xffffffff80a173bd: sbf_init+0x0/0xda()
Calling initcall 0xffffffff80a18210: i8237A_init_sysfs+0x0/0x22()
Calling initcall 0xffffffff80a18959: mce_init_device+0x0/0x78()
Calling initcall 0xffffffff80a18870: periodic_mcheck_init+0x0/0x27()
Calling initcall 0xffffffff80a189d1: thermal_throttle_init_device+0x0/0x9b()
Calling initcall 0xffffffff80a18a6c: threshold_init_device+0x0/0x4a()
Calling initcall 0xffffffff80a19c03: msr_init+0x0/0x100()
Calling initcall 0xffffffff80a19d03: cpuid_init+0x0/0x100()
Calling initcall 0xffffffff80a1a353: init_lapic_sysfs+0x0/0x37()
Calling initcall 0xffffffff80a1aebb: ioapic_init_sysfs+0x0/0xb3()
Calling initcall 0xffffffff80a1e717: audit_classes_init+0x0/0x8d()
Calling initcall 0xffffffff8022362d: cache_sysfs_init+0x0/0x5b()
Calling initcall 0xffffffff80a1e9a2: add_pcspkr+0x0/0x43()
Calling initcall 0xffffffff80a1ec6d: x8664_sysctl_init+0x0/0x14()
Calling initcall 0xffffffff80a208c7: aes_init+0x0/0x318()
Calling initcall 0xffffffff80a20bdf: init+0x0/0x12()
Calling initcall 0xffffffff80a20c03: ia32_binfmt_init+0x0/0x14()
Calling initcall 0xffffffff80a20c17: init_syscall32+0x0/0xba()
Calling initcall 0xffffffff80a21782: create_proc_profile+0x0/0x34f()
Calling initcall 0xffffffff80a21b59: ioresources_init+0x0/0x42()
Calling initcall 0xffffffff80a21c85: timekeeping_init_device+0x0/0x22()
Calling initcall 0xffffffff80a21dc1: uid_cache_init+0x0/0x8c()
Calling initcall 0xffffffff80a22205: init_posix_timers+0x0/0x94()
Calling initcall 0xffffffff80a222c4: init_posix_cpu_timers+0x0/0x69()
Calling initcall 0xffffffff80a2235b: latency_init+0x0/0x23()
Calling initcall 0xffffffff80a22390: init_clocksource_sysfs+0x0/0x50()
Calling initcall 0xffffffff80a22474: init_jiffies_clocksource+0x0/0x12()
Calling initcall 0xffffffff80a22486: init_timer_list_procfs+0x0/0x2f()
Calling initcall 0xffffffff80a22503: init_tstats_procfs+0x0/0x2f()
Calling initcall 0xffffffff80a22532: init+0x0/0x86()
Calling initcall 0xffffffff80253e98: init_rttest+0x0/0x14e()
Initializing RT-Tester: OK
Calling initcall 0xffffffff80a225b8: proc_dma_init+0x0/0x25()
Calling initcall 0xffffffff802552ad: percpu_modinit+0x0/0x76()
Calling initcall 0xffffffff80a225dd: kallsyms_init+0x0/0x28()
Calling initcall 0xffffffff80a226bb: snapshot_device_init+0x0/0x12()
Calling initcall 0xffffffff80a226cd: crash_notes_memory_init+0x0/0x3d()
Calling initcall 0xffffffff80a228ef: audit_init+0x0/0x121()
audit: initializing netlink socket (disabled)
audit(1174901870.063:1): initialized
Calling initcall 0xffffffff80a22a95: init_kprobes+0x0/0x52()
Calling initcall 0xffffffff80a22bd9: relay_init+0x0/0x14()
Calling initcall 0xffffffff80a22bed: utsname_sysctl_init+0x0/0x14()
Calling initcall 0xffffffff80a24017: init_per_zone_pages_min+0x0/0x41()
Calling initcall 0xffffffff80a24af6: pdflush_init+0x0/0x1a()
Calling initcall 0xffffffff80a24b3c: kswapd_init+0x0/0x72()
Calling initcall 0xffffffff80a24bae: setup_vmstat+0x0/0x19()
Calling initcall 0xffffffff80a24c0b: procswaps_init+0x0/0x25()
Calling initcall 0xffffffff80a24c63: hugetlb_init+0x0/0x69()
Total HugeTLB memory allocated, 0
Calling initcall 0xffffffff80a24dc1: init_tmpfs+0x0/0xc6()
Calling initcall 0xffffffff80a24f1a: cpucache_init+0x0/0x38()
Calling initcall 0xffffffff80a2542a: fasync_init+0x0/0x2d()
Calling initcall 0xffffffff80a25a58: aio_setup+0x0/0x69()
Calling initcall 0xffffffff80a25c96: inotify_setup+0x0/0x12()
Calling initcall 0xffffffff80a25ca8: inotify_user_setup+0x0/0xbc()
Calling initcall 0xffffffff80a25d64: eventpoll_init+0x0/0xcf()
Calling initcall 0xffffffff80a25e33: init_sys32_ioctl+0x0/0x95()
Calling initcall 0xffffffff80a25f28: init_mbcache+0x0/0x20()
Calling initcall 0xffffffff80a25f48: dquot_init+0x0/0xea()
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Calling initcall 0xffffffff80a26032: init_v2_quota_format+0x0/0x12()
Calling initcall 0xffffffff80a26044: dnotify_init+0x0/0x2d()
Calling initcall 0xffffffff80a264c9: init_devpts_fs+0x0/0x3a()
Calling initcall 0xffffffff80a26503: init_ext3_fs+0x0/0x6b()
Calling initcall 0xffffffff80a2661e: journal_init+0x0/0xbc()
Calling initcall 0xffffffff80a266da: init_ext2_fs+0x0/0x6a()
Calling initcall 0xffffffff80a26778: init_ramfs_fs+0x0/0x12()
Calling initcall 0xffffffff80a2679c: init_hugetlbfs_fs+0x0/0x7f()
Calling initcall 0xffffffff80a2681b: init_iso9660_fs+0x0/0x6e()
Calling initcall 0xffffffff80a268f4: init_nls_cp437+0x0/0x12()
Calling initcall 0xffffffff80a26906: init_nls_ascii+0x0/0x12()
Calling initcall 0xffffffff80a2695f: ipc_init+0x0/0x17()
Calling initcall 0xffffffff80a26bbf: ipc_sysctl_init+0x0/0x14()
Calling initcall 0xffffffff80a26bd3: init_mqueue_fs+0x0/0xcf()
Calling initcall 0xffffffff80a26dff: key_proc_init+0x0/0x55()
Calling initcall 0xffffffff80a26fb8: selinux_nf_ip_init+0x0/0x56()
Calling initcall 0xffffffff80a2717e: init_sel_fs+0x0/0x5d()
Calling initcall 0xffffffff80a271db: selnl_init+0x0/0x42()
Calling initcall 0xffffffff80a2721d: sel_netif_init+0x0/0x67()
Calling initcall 0xffffffff80a27284: aurule_init+0x0/0x37()
Calling initcall 0xffffffff80a272bb: crypto_algapi_init+0x0/0xd()
Calling initcall 0xffffffff80a272eb: cryptomgr_init+0x0/0x12()
Calling initcall 0xffffffff80a272fd: hmac_module_init+0x0/0x12()
Calling initcall 0xffffffff80a2730f: crypto_xcbc_module_init+0x0/0x12()
Calling initcall 0xffffffff80a27321: init+0x0/0x5a()
Calling initcall 0xffffffff80a2737b: init+0x0/0x12()
Calling initcall 0xffffffff80a2738d: init+0x0/0x12()
Calling initcall 0xffffffff80a2739f: init+0x0/0x12()
Calling initcall 0xffffffff80a273b1: init+0x0/0x12()
Calling initcall 0xffffffff80a273c3: init+0x0/0x3c()
Calling initcall 0xffffffff80a273ff: init+0x0/0x61()
Calling initcall 0xffffffff80a27460: init+0x0/0x61()
Calling initcall 0xffffffff80a274c1: crypto_ecb_module_init+0x0/0x12()
Calling initcall 0xffffffff80a274d3: crypto_cbc_module_init+0x0/0x12()
Calling initcall 0xffffffff80a274e5: crypto_module_init+0x0/0x12()
Calling initcall 0xffffffff80a274f7: init+0x0/0x3c()
Calling initcall 0xffffffff80a27533: init+0x0/0x12()
Calling initcall 0xffffffff80a27545: init+0x0/0x12()
Calling initcall 0xffffffff80a27557: init+0x0/0x3c()
Calling initcall 0xffffffff80a27593: aes_init+0x0/0x31a()
Calling initcall 0xffffffff80a278ad: init+0x0/0x12()
Calling initcall 0xffffffff80a278bf: init+0x0/0x12()
Calling initcall 0xffffffff80a278d1: arc4_init+0x0/0x12()
Calling initcall 0xffffffff80a278e3: init+0x0/0x61()
Calling initcall 0xffffffff80a27944: init+0x0/0x12()
Calling initcall 0xffffffff80a27956: init+0x0/0x12()
Calling initcall 0xffffffff80a27968: init+0x0/0x12()
Calling initcall 0xffffffff80a2797a: michael_mic_init+0x0/0x12()
Calling initcall 0xffffffff80a2798c: init+0x0/0x12()
Calling initcall 0xffffffff80a27b89: noop_init+0x0/0x12()
io scheduler noop registered
Calling initcall 0xffffffff80a27b9b: as_init+0x0/0x12()
io scheduler anticipatory registered
Calling initcall 0xffffffff80a27bad: deadline_init+0x0/0x12()
io scheduler deadline registered
Calling initcall 0xffffffff80a27bbf: cfq_init+0x0/0xa6()
io scheduler cfq registered (default)
Calling initcall 0xffffffff80a27c65: blk_trace_init+0x0/0xf8()
Calling initcall 0xffffffff80369039: pci_init+0x0/0x34()
PCI: Found disabled HT MSI Mapping on 0000:00:0b.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Linking AER extended capability on 0000:00:0b.0
PCI: Found disabled HT MSI Mapping on 0000:00:0c.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Linking AER extended capability on 0000:00:0c.0
PCI: Found disabled HT MSI Mapping on 0000:00:0d.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Linking AER extended capability on 0000:00:0d.0
PCI: Found disabled HT MSI Mapping on 0000:00:0e.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Linking AER extended capability on 0000:00:0e.0
Calling initcall 0xffffffff80a28711: pci_sysfs_init+0x0/0x3b()
Calling initcall 0xffffffff80a2874c: pci_proc_init+0x0/0x6f()
Calling initcall 0xffffffff80a287bb: pcie_portdrv_init+0x0/0x49()
PCI: Setting latency timer of device 0000:00:0b.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0b.0:pcie00]
Allocate Port Service[0000:00:0b.0:pcie03]
PCI: Setting latency timer of device 0000:00:0c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0c.0:pcie00]
Allocate Port Service[0000:00:0c.0:pcie03]
PCI: Setting latency timer of device 0000:00:0d.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0d.0:pcie00]
Allocate Port Service[0000:00:0d.0:pcie03]
PCI: Setting latency timer of device 0000:00:0e.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0e.0:pcie00]
Allocate Port Service[0000:00:0e.0:pcie03]
Calling initcall 0xffffffff80a28804: aer_service_init+0x0/0x12()
Calling initcall 0xffffffff80a28816: pci_hotplug_init+0x0/0x59()
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Calling initcall 0xffffffff80a2886f: acpiphp_init+0x0/0x51()
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
Calling initcall 0xffffffff80a28a6b: ibm_acpiphp_init+0x0/0x167()
acpiphp_ibm: ibm_find_acpi_device:  Failed to get device information<3>acpiphp_ibm: ibm_find_acpi_device:  Failed to get device information<3>acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
Calling initcall 0xffffffff80a28fc3: fb_console_init+0x0/0x115()
Calling initcall 0xffffffff80a2979c: vesafb_init+0x0/0x235()
Calling initcall 0xffffffff80a29d87: acpi_reserve_resources+0x0/0xf1()
Calling initcall 0xffffffff80a2a7c2: acpi_ac_init+0x0/0x45()
Calling initcall 0xffffffff80a2a807: acpi_battery_init+0x0/0x45()
Calling initcall 0xffffffff80a2a84c: acpi_button_init+0x0/0x5e()
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
Calling initcall 0xffffffff80a2acb6: acpi_fan_init+0x0/0x5e()
ACPI: Fan [FAN] (on)
Calling initcall 0xffffffff80a2ad65: acpi_video_init+0x0/0x5e()
Calling initcall 0xffffffff80a2aea0: irqrouter_init_sysfs+0x0/0x38()
Calling initcall 0xffffffff80a2b038: acpi_processor_init+0x0/0xdf()
Calling initcall 0xffffffff80a2b117: acpi_container_init+0x0/0x40()
Calling initcall 0xffffffff80a2b157: acpi_thermal_init+0x0/0x5e()
ACPI: Thermal Zone [THRM] (40 C)
Calling initcall 0xffffffff80a2b3ce: asus_acpi_init+0x0/0xe7()
Calling initcall 0xffffffff80a2b5c8: acpi_ibm_init+0x0/0x71b()
ibm_acpi: ec object not found
Calling initcall 0xffffffff80a2bce3: toshiba_acpi_init+0x0/0x183()
Calling initcall 0xffffffff80a2c467: rand_initialize+0x0/0x2c()
Calling initcall 0xffffffff80a2c4f2: tty_init+0x0/0x1c5()
Calling initcall 0xffffffff80a2c6b7: pty_init+0x0/0x281()
Calling initcall 0xffffffff80a2cf41: rtc_init+0x0/0x185()
Real Time Clock Driver v1.12ac
Calling initcall 0xffffffff80a2d0c6: nvram_init+0x0/0x89()
Non-volatile memory driver v1.2
Calling initcall 0xffffffff80a2d14f: agp_init+0x0/0x26()
Linux agpgart interface v0.102 (c) Dave Jones
Calling initcall 0xffffffff80a2d27f: agp_intel_init+0x0/0x29()
Calling initcall 0xffffffff80a2d2a8: agp_sis_init+0x0/0x29()
Calling initcall 0xffffffff80a2d2d1: agp_via_init+0x0/0x29()
Calling initcall 0xffffffff80a2d2fa: cn_proc_init+0x0/0x3a()
Calling initcall 0xffffffff80a2d7cf: serial8250_init+0x0/0x12c()
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
�serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Calling initcall 0xffffffff80a2d8fb: serial8250_pnp_init+0x0/0x12()
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Calling initcall 0xffffffff80a2d90d: serial8250_pci_init+0x0/0x1b()
Calling initcall 0xffffffff803e6d69: topology_sysfs_init+0x0/0x4a()
Calling initcall 0xffffffff80a2e012: rd_init+0x0/0x1ab()
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
Calling initcall 0xffffffff80a2e1fc: e1000_init_module+0x0/0x84()
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
Calling initcall 0xffffffff80a2e280: e100_init_module+0x0/0x62()
e100: Intel(R) PRO/100 Network Driver, 3.5.17-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
Calling initcall 0xffffffff80a2e2e2: sky2_init_module+0x0/0x1b()
Calling initcall 0xffffffff80a2e34f: net_olddevs_init+0x0/0xa9()
Calling initcall 0xffffffff80a2e3f8: loopback_init+0x0/0x12()
Calling initcall 0xffffffff80a2e40a: init_nic+0x0/0x30()
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LMAC] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:0a.0 to 64
forcedeth: using HIGHDMA
eth0: forcedeth.c: subsystem: 01043:8141 bound to 0000:00:0a.0
Calling initcall 0xffffffff80a2e43a: aec62xx_ide_init+0x0/0x1b()
Calling initcall 0xffffffff80a2e455: ali15x3_ide_init+0x0/0x1b()
Calling initcall 0xffffffff80a2e470: amd74xx_ide_init+0x0/0x1b()
Calling initcall 0xffffffff80a2e48b: atiixp_ide_init+0x0/0x1b()
Calling initcall 0xffffffff80a2e4a6: cmd64x_ide_init+0x0/0x1b()
Calling initcall 0xffffffff80a2e4c1: hpt34x_ide_init+0x0/0x1b()
Calling initcall 0xffffffff80a2e4dc: hpt366_ide_init+0x0/0x1b()
Calling initcall 0xffffffff80a2e4f7: it821x_ide_init+0x0/0x1b()
Calling initcall 0xffffffff80a2e512: pdc202xx_ide_init+0x0/0x1b()
Calling initcall 0xffffffff80a2e52d: pdc202new_ide_init+0x0/0x1b()
Calling initcall 0xffffffff80a2e548: piix_ide_init+0x0/0xc9()
Calling initcall 0xffffffff80a2e611: svwks_ide_init+0x0/0x1b()
Calling initcall 0xffffffff80a2e62c: siimage_ide_init+0x0/0x1b()
Calling initcall 0xffffffff80a2e647: sis5513_ide_init+0x0/0x1b()
Calling initcall 0xffffffff80a2e662: via_ide_init+0x0/0x1b()
Calling initcall 0xffffffff80a2e6a0: generic_ide_init+0x0/0x1b()
Calling initcall 0xffffffff80a2edc0: ide_init+0x0/0x8f()
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
NFORCE-CK804: IDE controller at PCI slot 0000:00:06.0
NFORCE-CK804: chipset revision 242
NFORCE-CK804: not 100% native mode: will probe irqs later
NFORCE-CK804: 0000:00:06.0 (rev f2) UDMA133 controller
    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:DMA, hdd:DMA
Probing IDE interface ide0...
hda: MAXTOR 6L040J2, ATA DISK drive
hdb: ST380011A, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
Calling initcall 0xffffffff80a2ef64: ide_generic_init+0x0/0x12()
Probing IDE interface ide1...
Calling initcall 0xffffffff80a2ef76: idedisk_init+0x0/0x12()
hda: max request size: 128KiB
hda: 78177792 sectors (40027 MB) w/1818KiB Cache, CHS=65535/16/63, UDMA(133)
hda: cache flushes supported
 hda: hda1 hda2 hda3 hda4 < hda5 >
hdb: max request size: 512KiB
hdb: 156301488 sectors (80026 MB) w/2048KiB Cache, CHS=16383/255/63, UDMA(100)
hdb: cache flushes supported
 hdb: hdb1 hdb2 hdb3 < hdb5 >
Calling initcall 0xffffffff80a2ef88: idefloppy_init+0x0/0x20()
ide-floppy driver 0.99.newide
Calling initcall 0xffffffff80a2f216: init_sd+0x0/0xf5()
Calling initcall 0xffffffff80a2f30b: init_sg+0x0/0x15d()
Calling initcall 0xffffffff80a2f4f0: ahci_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f50b: k2_sata_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f526: piix_init+0x0/0x2c()
Calling initcall 0xffffffff80a2f552: pdc_ata_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f56d: qs_ata_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f588: sil_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f5a3: sil24_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f5be: svia_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f5d9: vsc_sata_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f5f4: sis_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f60f: pdc_sata_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f62a: nv_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f645: uli_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f660: mv_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f67b: adma_ata_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f696: ali_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f6b1: amd_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f6cc: artop_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f6e7: atiixp_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f702: cmd64x_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f71d: cs5520_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f738: cs5530_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f753: cy82c693_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f76e: efar_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f789: hpt36x_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f7a4: hpt37x_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f7bf: hpt3x2n_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f7da: hpt3x3_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f7f5: it821x_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f810: jmicron_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f82b: netcell_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f846: ns87410_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f861: opti_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f87c: optidma_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f897: marvell_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f8b2: mpiix_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f8cd: oldpiix_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f8e8: pcmcia_init+0x0/0x12()
Calling initcall 0xffffffff80a2f8fa: pdc2027x_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f915: pdc202xx_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f930: radisys_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f94b: rz1000_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f966: sc1200_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f981: serverworks_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f99c: sil680_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f9b7: via_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f9d2: sl82c105_init+0x0/0x1b()
Calling initcall 0xffffffff80a2f9ed: sis_init+0x0/0x1b()
Calling initcall 0xffffffff80a2fa08: triflex_init+0x0/0x1b()
Calling initcall 0xffffffff80a2fa23: ata_generic_init+0x0/0x1b()
Calling initcall 0xffffffff80a2fb6d: nonstatic_sysfs_init+0x0/0x12()
Calling initcall 0xffffffff80a2fb7f: yenta_socket_init+0x0/0x1b()
Calling initcall 0xffffffff80a2fb9a: kvm_init+0x0/0x177()
Calling initcall 0xffffffff80a2fd2a: vmx_init+0x0/0x14()
kvm: no hardware support
initcall at 0xffffffff80a2fd2a: vmx_init+0x0/0x14(): returned with error code -95
Calling initcall 0xffffffff80a2fe01: svm_init+0x0/0x14()
has_svm: svm not available
kvm: no hardware support
initcall at 0xffffffff80a2fe01: svm_init+0x0/0x14(): returned with error code -95
Calling initcall 0xffffffff80a303d9: mon_init+0x0/0xa7()
Calling initcall 0xffffffff80a30544: usb_usual_init+0x0/0x30()
usbcore: registered new interface driver libusual
Calling initcall 0xffffffff80a305ff: i8042_init+0x0/0x2ff()
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
Calling initcall 0xffffffff80a308fe: serport_init+0x0/0x31()
Calling initcall 0xffffffff80a30a52: mousedev_init+0x0/0xc2()
mice: PS/2 mouse device common for all mice
Calling initcall 0xffffffff80a30b14: evdev_init+0x0/0x12()
Calling initcall 0xffffffff80a30b26: atkbd_init+0x0/0x1b()
Calling initcall 0xffffffff80a30b41: psmouse_init+0x0/0x65()
input: AT Translated Set 2 keyboard as /class/input/input2
Calling initcall 0xffffffff80a30ba6: md_init+0x0/0xd6()
Calling initcall 0xffffffff80a30d62: ledtrig_ide_init+0x0/0x1b()
Calling initcall 0xffffffff80a33050: flow_cache_init+0x0/0x19e()
Calling initcall 0xffffffff80a332aa: llc_init+0x0/0x5b()
Calling initcall 0xffffffff80a33305: snap_init+0x0/0x31()
Calling initcall 0xffffffff80a33336: rif_init+0x0/0x77()
Calling initcall 0xffffffff80a33453: blackhole_module_init+0x0/0x12()
Calling initcall 0xffffffff80a3485a: init_syncookies+0x0/0x19()
Calling initcall 0xffffffff805069c2: ipv4_netfilter_init+0x0/0x12()
Calling initcall 0xffffffff80a34873: bictcp_register+0x0/0x12()
TCP bic registered
Calling initcall 0xffffffff80a34ae0: xfrm_user_init+0x0/0x4d()
Initializing XFRM netlink socket
Calling initcall 0xffffffff80a34b2d: af_unix_init+0x0/0x6d()
NET: Registered protocol family 1
Calling initcall 0xffffffff80a34b9a: packet_init+0x0/0x5a()
NET: Registered protocol family 17
Calling initcall 0xffffffff80a34bf4: ipsec_pfkey_init+0x0/0x94()
NET: Registered protocol family 15
Calling initcall 0xffffffff80a1a408: ioapic_insert_resources+0x0/0x4f()
Calling initcall 0xffffffff80a1abf1: init_lapic_nmi_sysfs+0x0/0x38()
Calling initcall 0xffffffff8021e003: powernowk8_init+0x0/0x88()
powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ processors (version 2.00.00)
powernow-k8: BIOS error - no PSB or ACPI _PSS objects
------------[ cut here ]------------
kernel BUG at drivers/cpufreq/cpufreq.c:82!
invalid opcode: 0000 [1] PREEMPT SMP 
CPU 0 
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.21-rc5 #14
RIP: 0010:[<ffffffff804a0edd>]  [<ffffffff804a0edd>] lock_policy_rwsem_write+0x2b/0x7f
RSP: 0000:ffff81003ff31de0  EFLAGS: 00010246
RAX: 00000000ffffffff RBX: ffffffff80aa46a8 RCX: 0000000000000000
RDX: ffffffff80741080 RSI: 0000000000000202 RDI: 0000000000000001
RBP: ffff81003ff31e00 R08: ffff81003ff30000 R09: ffff810002dfdab0
R10: ffff810002dfdab0 R11: ffff810002dfdab0 R12: 0000000000000001
R13: ffffffff806cc2c0 R14: ffffffff80a37920 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff80741000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000f06f53 CR3: 0000000000201000 CR4: 00000000000006e0
Process swapper (pid: 1, threadinfo ffff81003ff30000, task ffff81003ff2a790)
Stack:  ffffffff806cc2c0 ffffffff80aa46a8 ffffffff80aa46a8 ffffffff806cc2c0
 ffff81003ff31e20 ffffffff804a1538 ffff810002dfdab0 ffffffff806f6a40
 ffff81003ff31e50 ffffffff803dffdf 00000000ffffffed 00000000ffffffed
Call Trace:
 [<ffffffff804a1538>] cpufreq_remove_dev+0x11/0x26
 [<ffffffff803dffdf>] sysdev_driver_unregister+0x52/0x98
 [<ffffffff804a0d3b>] cpufreq_register_driver+0x12d/0x191
 [<ffffffff8021e082>] powernowk8_init+0x7f/0x88
 [<ffffffff80a1099e>] init+0x1a8/0x2a9
 [<ffffffff8023294e>] schedule_tail+0x36/0x9a
 [<ffffffff8020ab98>] child_rip+0xa/0x12
 [<ffffffff80a107f6>] init+0x0/0x2a9
 [<ffffffff8020ab8e>] child_rip+0x0/0x12


Code: 0f 0b eb fe 4c 63 e8 48 c7 c3 a0 c1 a6 80 4a 8b 04 ed c0 7a 
RIP  [<ffffffff804a0edd>] lock_policy_rwsem_write+0x2b/0x7f
 RSP <ffff81003ff31de0>
Kernel panic - not syncing: Attempted to kill init!


--n8g4imXOkfNTN/H1
Content-Type: application/x-bzip2
Content-Disposition: attachment; filename="config.bz2"
Content-Transfer-Encoding: base64

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

--n8g4imXOkfNTN/H1--
