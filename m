Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbXKBHf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbXKBHf1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 03:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbXKBHfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 03:35:16 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:48958 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358AbXKBHfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 03:35:12 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: lenb@kernel.org
Subject: [2.6.24-rc1][BUG] Oops on battery removal
Date: Fri, 2 Nov 2007 08:03:44 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-acpi@vger.kernel.org, astarikovskiy@suse.de,
       kernel list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1650252.MMvfe6pOBv";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200711020803.49608.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1650252.MMvfe6pOBv
Content-Type: multipart/mixed;
  boundary="Boundary-01=_QvsKH6Hxqj1h8fq"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_QvsKH6Hxqj1h8fq
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

this happened while I removed my battery on bootup. Complete dmesg is=20
attached. Kernel is 2.6.24-rc1-git of yesterday (last commit was=20
d919fd433b5823d1cf9d0688eb2eec183de9b74c).

Greetings,

Eike

BUG: unable to handle kernel NULL pointer dereference at virtual address=20
0000001c
printing eip: c02a82cb *pde =3D 00000000=20
Oops: 0000 [#1] SMP=20
Modules linked in: iptable_filter ip_tables ip6table_filter ip6_tables=20
x_tables ipv6 af_packet cpufreq_conservative cpufreq_ondemand=20
cpufreq_userspace cpufreq_powersave acpi_cpufreq speedstep_lib freq_table=20
snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device twofish twofish_common cbc=
=20
blkcipher dm_crypt nls_utf8 ntfs ext3 jbd loop mmc_block pcmcia container=20
battery iwl3945 firmware_class yenta_socket button ohci1394 backlight outpu=
t=20
ac power_supply rsrc_nonstatic pcmcia_core mmc_core ieee1394 intel_agp joyd=
ev=20
agpgart snd_hda_intel sr_mod cdrom r8169 snd_pcm snd_timer mac80211 snd=20
soundcore snd_page_alloc i2c_i801 i2c_core cfg80211 serio_raw sg usbhid=20
ehci_hcd uhci_hcd sd_mod usbcore dm_snapshot edd dm_mod fan ata_piix libata=
=20
scsi_mod thermal processor

Pid: 47, comm: kacpi_notify Not tainted (2.6.24-rc1-git #68)
EIP: 0060:[<c02a82cb>] EFLAGS: 00010286 CPU: 0
EIP is at klist_del+0xc/0x39
EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
ESI: c2e2bc00 EDI: c2e2bc20 EBP: c1c88d7c ESP: c1c88d70
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process kacpi_notify (pid: 47, ti=3Dc1c88000 task=3Dc1cb5350 task.ti=3Dc1c8=
8000)
Stack: c2e2bc00 c2e2bc00 c1ce960c c1c88d90 c0231ab6 c2e2bc00 c2e2ba00 c1c88=
e1c=20
       c1c88d9c c0231ced c2e2ba1c c1c88da8 f8bee01a c2e2ba00 c1c88db4 f8c39=
04b=20
       c2e2ba00 c1c88de4 f8c391a2 c01d47bc c01d47bc 00000001 00000000 00008=
0d0=20
Call Trace:
 [<c0104edd>] show_trace_log_lvl+0x1a/0x2f
 [<c0104f8d>] show_stack_log_lvl+0x9b/0xa3
 [<c010503c>] show_registers+0xa7/0x179
 [<c0105222>] die+0x114/0x1f5
 [<c02abced>] do_page_fault+0x4b0/0x589
 [<c02aa58a>] error_code+0x72/0x78
 [<c0231ab6>] device_del+0x1a/0x246
 [<c0231ced>] device_unregister+0xb/0x15
 [<f8bee01a>] power_supply_unregister+0x1a/0x1d [power_supply]
 [<f8c3904b>] sysfs_remove_battery+0x1f/0x22 [battery]
 [<f8c391a2>] acpi_battery_update+0x3f/0x255 [battery]
 [<f8c396e9>] acpi_battery_get_property+0x2b/0x149 [battery]
 [<f8bee2c2>] power_supply_show_property+0x32/0xf0 [power_supply]
 [<f8bee59e>] power_supply_uevent+0xfd/0x187 [power_supply]
 [<c02322d8>] dev_uevent+0xca/0xe8
 [<c01d1a28>] kobject_uevent_env+0x15a/0x376
 [<c01d1c4e>] kobject_uevent+0xa/0xc
 [<c0231cb9>] device_del+0x21d/0x246
 [<c0231ced>] device_unregister+0xb/0x15
 [<f8bee01a>] power_supply_unregister+0x1a/0x1d [power_supply]
 [<f8c3904b>] sysfs_remove_battery+0x1f/0x22 [battery]
 [<f8c391a2>] acpi_battery_update+0x3f/0x255 [battery]
 [<f8c398ff>] acpi_battery_notify+0x1e/0x73 [battery]
 [<c01f9b50>] acpi_ev_notify_dispatch+0x4f/0x5a
 [<c01f447d>] acpi_os_execute_notify+0x24/0x2f
 [<c0130d05>] run_workqueue+0x7d/0x110
 [<c01316f5>] worker_thread+0xbe/0xcd
 [<c0134247>] kthread+0x3b/0x64
 [<c0104b63>] kernel_thread_helper+0x7/0x10
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Code: 08 e8 63 20 00 00 83 7d f0 00 74 09 85 ff 74 05 89 f8 ff 55 f0 8b 45 =
ec=20
5a 59 5b 5e 5f 5d c3 55 89 e5 57 89 c7 56 53 8b 18 89 d8 <8b> 73 1c e8 7b 2=
0=20
00 00 89 f8 e8 58 ff ff ff 85 c0 b8 00 00 00=20
EIP: [<c02a82cb>] klist_del+0xc/0x39 SS:ESP 0068:c1c88d70
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 3
  groups: 1 2
CPU1 attaching sched-domain:
 domain 0: span 3
  groups: 2 1
BUG: unable to handle kernel NULL pointer dereference at virtual address=20
0000001c
printing eip: c02a82cb *pde =3D 00000000=20
Oops: 0000 [#2] SMP=20
Modules linked in: iptable_filter ip_tables ip6table_filter ip6_tables=20
x_tables ipv6 af_packet cpufreq_conservative cpufreq_ondemand=20
cpufreq_userspace cpufreq_powersave acpi_cpufreq speedstep_lib freq_table=20
snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device twofish twofish_common cbc=
=20
blkcipher dm_crypt nls_utf8 ntfs ext3 jbd loop mmc_block pcmcia container=20
battery iwl3945 firmware_class yenta_socket button ohci1394 backlight outpu=
t=20
ac power_supply rsrc_nonstatic pcmcia_core mmc_core ieee1394 intel_agp joyd=
ev=20
agpgart snd_hda_intel sr_mod cdrom r8169 snd_pcm snd_timer mac80211 snd=20
soundcore snd_page_alloc i2c_i801 i2c_core cfg80211 serio_raw sg usbhid=20
ehci_hcd uhci_hcd sd_mod usbcore dm_snapshot edd dm_mod fan ata_piix libata=
=20
scsi_mod thermal processor

Pid: 2773, comm: hald Tainted: G      D (2.6.24-rc1-git #68)
EIP: 0060:[<c02a82cb>] EFLAGS: 00010286 CPU: 1
EIP is at klist_del+0xc/0x39
EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
ESI: c2e2bc00 EDI: c2e2bc20 EBP: c33b9e8c ESP: c33b9e80
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process hald (pid: 2773, ti=3Dc33b9000 task=3Dc3304d30 task.ti=3Dc33b9000)
Stack: c2e2bc00 c2e2bc00 c1ce960c c33b9ea0 c0231ab6 c2e2bc00 c2e2ba00 00000=
001=20
       c33b9eac c0231ced c2e2ba1c c33b9eb8 f8bee01a c2e2ba00 c33b9ec4 f8c39=
04b=20
       c39b3ec0 c33b9ef4 f8c391a2 c0163a98 c27f1cbc 00000246 c3bf9cf8 c33b9=
efc=20
Call Trace:
 [<c0104edd>] show_trace_log_lvl+0x1a/0x2f
 [<c0104f8d>] show_stack_log_lvl+0x9b/0xa3
 [<c010503c>] show_registers+0xa7/0x179
 [<c0105222>] die+0x114/0x1f5
 [<c02abced>] do_page_fault+0x4b0/0x589
 [<c02aa58a>] error_code+0x72/0x78
 [<c0231ab6>] device_del+0x1a/0x246
 [<c0231ced>] device_unregister+0xb/0x15
 [<f8bee01a>] power_supply_unregister+0x1a/0x1d [power_supply]
 [<f8c3904b>] sysfs_remove_battery+0x1f/0x22 [battery]
 [<f8c391a2>] acpi_battery_update+0x3f/0x255 [battery]
 [<f8c393ed>] acpi_battery_read+0x11/0x20 [battery]
 [<f8c3941c>] acpi_battery_read_state+0xf/0x11 [battery]
 [<c01889de>] seq_read+0xea/0x264
 [<c019fdef>] proc_reg_read+0x63/0x76
 [<c0172645>] vfs_read+0xa6/0x12f
 [<c0172a3e>] sys_read+0x3d/0x61
 [<c0103f12>] sysenter_past_esp+0x5f/0x85
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Code: 08 e8 63 20 00 00 83 7d f0 00 74 09 85 ff 74 05 89 f8 ff 55 f0 8b 45 =
ec=20
5a 59 5b 5e 5f 5d c3 55 89 e5 57 89 c7 56 53 8b 18 89 d8 <8b> 73 1c e8 7b 2=
0=20
00 00 89 f8 e8 58 ff ff ff 85 c0 b8 00 00 00=20
EIP: [<c02a82cb>] klist_del+0xc/0x39 SS:ESP 0068:c33b9e80

--Boundary-01=_QvsKH6Hxqj1h8fq
Content-Type: text/plain;
  charset="utf-8";
  name="acpibuf"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="acpibuf"

Linux version 2.6.24-rc1-git (eike@donald) (gcc version 4.2.1 (SUSE Linux))=
 #68 SMP Thu Nov 1 09:45:08 CET 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003f680000 (usable)
 BIOS-e820: 000000003f680000 - 000000003f700000 (ACPI NVS)
 BIOS-e820: 000000003f700000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
118MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000f7670
Entering add_active_range(0, 0, 259712) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   259712
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   259712
On node 0 totalpages: 259712
  DMA zone: 40 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4056 pages, LIFO batch:0
  Normal zone: 2200 pages used for memmap
  Normal zone: 223080 pages, LIFO batch:31
  HighMem zone: 296 pages used for memmap
  HighMem zone: 30040 pages, LIFO batch:7
  Movable zone: 0 pages used for memmap
DMI present.
ACPI: RSDP 000F75E0, 0014 (r0 TOSCPL)
ACPI: RSDT 3F680AA2, 0048 (r1 TOSCPL Capell00  6040000  LTP        0)
ACPI: FACP 3F687DEE, 0074 (r1 TOSCPL CALISTGA  6040000 LOHR       5A)
ACPI: DSDT 3F682181, 5C6D (r1 TOSCPL CALISTGA  6040000 INTL 20050624)
ACPI: FACS 3F688FC0, 0040
ACPI: APIC 3F687E62, 0068 (r1 INTEL  CALISTGA  6040000 LOHR       5A)
ACPI: HPET 3F687ECA, 0038 (r1 INTEL  CALISTGA  6040000 LOHR       5A)
ACPI: MCFG 3F687F02, 003C (r1 INTEL  CALISTGA  6040000 LOHR       5A)
ACPI: BOOT 3F687FD8, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
ACPI: APIC 3F687F70, 0068 (r1 PTLTD  	 APIC    6040000  LTP        0)
ACPI: SSDT 3F681B2E, 064F (r1 SataRe  SataPri     1000 INTL 20050624)
ACPI: SSDT 3F68149C, 0692 (r1 SataRe  SataSec     1000 INTL 20050624)
ACPI: SSDT 3F680AEA, 04F6 (r1  PmRef    CpuPm     3000 INTL 20050624)
ACPI: BIOS bug: multiple APIC/MADT found, using 0
ACPI: If "acpi_apic_instance=3D2" works better, notify linux-acpi@vger.kern=
el.org
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 6:14 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 6:14 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000dc000
swsusp: Registered nosave memory region: 00000000000dc000 - 0000000000100000
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 257176
Kernel command line: root=3D/dev/system/root32 vga=3D0x314 resume=3D/dev/sd=
a3 showopts
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=3Dc039c000 soft=3Dc0398000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1596.150 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1016716k/1038848k available (1717k kernel code, 21436k reserved, 70=
7k data, 200k init, 121344k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff81000 - 0xfffff000   ( 504 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0363000 - 0xc0395000   ( 200 kB)
      .data : 0xc02ad7f3 - 0xc035e5b8   ( 707 kB)
      .text : 0xc0100000 - 0xc02ad7f3   (1717 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
hpet clockevent registered
Calibrating delay using timer specific routine.. 3195.73 BogoMIPS (lpj=3D63=
91470)
Security Framework initialized
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfe9fbff 00100000 00000000 00000000 0000=
c189 00000000 00000000 00000000
monitor/mwait feature present.
using mwait in idle threads.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: After all inits, caps: bfe9fbff 00100000 00000000 00002940 0000c189 00=
000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
CPU0: Intel Genuine Intel(R) CPU           T2050  @ 1.60GHz stepping 08
SMP alternatives: switching to SMP code
Booting processor 1/1 eip 3000
CPU 1 irqstacks, hard=3Dc039d000 soft=3Dc0399000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3192.06 BogoMIPS (lpj=3D63=
84132)
CPU: After generic identify, caps: bfe9fbff 00100000 00000000 00000000 0000=
c189 00000000 00000000 00000000
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: After all inits, caps: bfe9fbff 00100000 00000000 00002940 0000c189 00=
000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel Genuine Intel(R) CPU           T2050  @ 1.60GHz stepping 08
Total of 2 processors activated (6387.80 BogoMIPS).
ENABLING IO-APIC IRQs
=2E.TIMER: vector=3D0x31 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
CPU0 attaching sched-domain:
 domain 0: span 3
  groups: 1 2
CPU1 attaching sched-domain:
 domain 0: span 3
  groups: 2 1
net_namespace: 64 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: System BIOS is requesting _OSI(Linux)
ACPI: If "acpi_osi=3DLinux" works better,
Please send dmidecode to linux-acpi@vger.kernel.org
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE =3D 0x19, I/O: command/status =3D 0x66, data =3D 0x62
ACPI: EC: driver started in poll mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 1180-11bf claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 *11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=3Drouteirq".  If it helps, post a r=
eport
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
Time: tsc clocksource has been installed.
system 00:01: ioport range 0xfe00-0xfe7f has been reserved
system 00:01: ioport range 0xfe80-0xfeff has been reserved
system 00:01: ioport range 0xff00-0xff7f has been reserved
system 00:01: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:01: iomem range 0xfed14000-0xfed17fff could not be reserved
system 00:01: iomem range 0xfed18000-0xfed18fff could not be reserved
system 00:01: iomem range 0xfed19000-0xfed19fff could not be reserved
system 00:04: iomem range 0xfed00000-0xfed003ff could not be reserved
PCI: Bridge: 0000:00:1c.0
  IO window: 2000-2fff
  MEM window: d6000000-d7ffffff
  PREFETCH window: d0000000-d1ffffff
PCI: Bridge: 0000:00:1c.1
  IO window: 3000-3fff
  MEM window: d8000000-d9ffffff
  PREFETCH window: d2000000-d3ffffff
PCI: Bridge: 0000:00:1c.2
  IO window: 4000-4fff
  MEM window: da000000-dbffffff
  PREFETCH window: d4000000-d5ffffff
PCI: Bus 7, cardbus bridge: 0000:06:04.0
  IO window: 00005400-000054ff
  IO window: 00005800-000058ff
  PREFETCH window: 50000000-53ffffff
  MEM window: 54000000-57ffffff
PCI: Bridge: 0000:00:1e.0
  IO window: 5000-5fff
  MEM window: dc000000-dc0fffff
  PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.1 to 64
ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1c.2 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
ACPI: PCI Interrupt 0000:06:04.0[A] -> GSI 16 (level, low) -> IRQ 17
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 9, 3145728 bytes)
TCP bind hash table entries: 65536 (order: 8, 1310720 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs...<6>Switched to NOHz mode on CPU #1
Switched to NOHz mode on CPU #0
 it is
ACPI: EC: non-query interrupt received, switching to interrupt mode
=46reeing initrd memory: 7229k freed
Simple Boot Flag at 0x36 set to 0x1
audit: initializing netlink socket (disabled)
audit(1193989289.144:1): initialized
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:00:02.0
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
Allocate Port Service[0000:00:1c.0:pcie03]
PCI: Setting latency timer of device 0000:00:1c.1 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.1:pcie00]
Allocate Port Service[0000:00:1c.1:pcie02]
Allocate Port Service[0000:00:1c.1:pcie03]
PCI: Setting latency timer of device 0000:00:1c.2 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.2:pcie00]
Allocate Port Service[0000:00:1c.2:pcie02]
Allocate Port Service[0000:00:1c.2:pcie03]
vesafb: framebuffer at 0xc0000000, mapped to 0xf8880000, using 1875k, total=
 7872k
vesafb: mode is 800x600x16, linelength=3D1600, pages=3D7
vesafb: scrolling: redraw
vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
Console: switching to colour frame buffer device 100x37
fb0: VESA VGA frame buffer device
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
toshiba: not a supported Toshiba laptop
intel_rng: FWH not detected
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
RAMDISK driver initialized: 16 RAM disks of 64000K size 1024 blocksize
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input=
/input0
input: PC Speaker as /devices/platform/pcspkr/input/input1
input: PS/2 Mouse as /devices/virtual/input/input2
input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio4/input/inp=
ut3
cpuidle: using governor ladder
cpuidle: using governor menu
NET: Registered protocol family 1
Using IPI No-Shortcut mode
registered taskstats version 1
=46reeing unused kernel memory: 200k freed
Write protecting the kernel read-only data: 520k
ACPI: SSDT 3F681241, 01DE (r1  PmRef  Cpu0Ist     3000 INTL 20050624)
ACPI: SSDT 3F680FE0, 01DC (r1  PmRef  Cpu0Cst     3001 INTL 20050624)
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: SSDT 3F68141F, 007D (r1  PmRef  Cpu1Ist     3000 INTL 20050624)
ACPI: SSDT 3F6811BC, 0085 (r1  PmRef  Cpu1Cst     3000 INTL 20050624)
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
Marking TSC unstable due to: TSC halts in idle.
Time: hpet clocksource has been installed.
SCSI subsystem initialized
libata version 3.00 loaded.
ata_piix 0000:00:1f.2: version 2.12
ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x18b0 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x18b8 irq 15
Clocksource tsc unstable (delta =3D -202565412 ns)
ata1.00: ATA-7: HTS541010G9SA00, MBZOC60R, max UDMA/100
ata1.00: 195371568 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/100
ata2.00: ATAPI: HL-DT-ST DVDRAM GMA-4082N, HV02, max UDMA/33
ata2.00: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      HTS541010G9SA00  MBZO PQ: 0 ANSI: 5
scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GMA-4082N HV02 PQ: 0 ANSI: 5
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: dm-devel@redha=
t.com
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
usbcore: registered new device driver usb
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
 sda:<6>USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
 sda1 sda2 sda3 sda4
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xdc444000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
sd 0:0:0:0: [sda] Attached SCSI disk
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 20, io base 0x00001820
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001840
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001860
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 17, io base 0x00001880
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb 3-2: new low speed USB device using uhci_hcd and address 2
usb 3-2: configuration #1 chosen from 1 choice
usbcore: registered new interface driver hiddev
input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1d.1/=
usb3/3-2/3-2:1.0/input/input4
input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00=
:1d.1-2
usbcore: registered new interface driver usbhid
/home/eike/repos/linux-2.6/drivers/hid/usbhid/hid-core.c: v2.6:USB HID core=
 driver
swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
swsusp: Basic memory bitmaps created
swsusp: Basic memory bitmaps freed
Attempting manual resume
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Attached scsi generic sg1 type 5
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 19 (level, low) -> IRQ 19
r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:05:00.0 to 64
eth0: RTL8101e at 0xf8ac2000, 00:16:d4:20:d3:3a, XID 34000000 IRQ 220
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1b.0 to 64
Linux agpgart interface v0.102
ACPI: AC Adapter [ACAD] (on-line)
sdhci: Unknown parameter `debug_nodma'
sdhci: Unknown parameter `debug_nodma'
sdhci: Unknown parameter `debug_nodma'
input: Power Button (FF) as /devices/virtual/input/input5
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /devices/virtual/input/input6
iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Lin=
ux, 1.1.17ks
iwl3945: Copyright(c) 2003-2007 Intel Corporation
ACPI: Lid Switch [LID0]
input: Power Button (CM) as /devices/virtual/input/input7
ACPI: Power Button (CM) [PWRB]
ACPI: Battery Slot [BAT1] (battery present)
ALSA /home/eike/repos/linux-2.6/sound/pci/hda/hda_intel.c:576: hda_intel: a=
zx_get_response timeout, switching to polling mode: last cmd=3D0x011b2000
agpgart: Detected an Intel 945GM Chipset.
agpgart: Detected 7932K stolen memory.
agpgart: AGP aperture is 256M @ 0xc0000000
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 17 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:04:00.0 to 64
iwl3945: Detected Intel PRO/Wireless 3945ABG Network Connection
ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 20 (level, low) -> IRQ 22
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=3D[22]  MMIO=3D[dc001000-dc001=
7ff]  Max Packet=3D[2048]  IR/IT contexts=3D[4/8]
Yenta: CardBus bridge found at 0000:06:04.0 [1179:ff01]
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:06:04.0, mfunc 0x89501212, devctl 0x44
iwl3945: Radio Frequency Kill Switch is On:
Kill switch must be turned off for wireless networking to work.
iwl3945: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl3945: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl3945: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl3945: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
Yenta: ISA IRQ mask 0x0cf8, PCI irq 17
Socket status: 30000006
Yenta: Raising subordinate bus# of parent bus (#06) from #07 to #0a
pcmcia: parent PCI bridge I/O window: 0x5000 - 0x5fff
pcmcia: parent PCI bridge Memory window: 0xdc000000 - 0xdc0fffff
sdhci: Unknown parameter `debug_nodma'
Adding 2104504k swap on /dev/sda3.  Priority:-1 extents:1 across:2104504k
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023f6599400d44]
loop: module loaded
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
NTFS driver 2.1.29 [Flags: R/W MODULE].
NTFS volume version 3.1.
NTFS-fs warning (device sda1): load_system_files(): Unsupported volume flag=
s 0x4000 encountered.
NTFS-fs warning (device sda1): load_system_files(): Volume has unsupported =
flags set.  Will not be able to remount read-write.  Run chkdsk and mount i=
n Windows.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
audit(1193985722.358:2): audit_pid=3D2906 old=3D0 by auid=3D4294967295
r8169: eth0: link up
r8169: eth0: link up
NET: Registered protocol family 17
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ip6_tables: (C) 2000-2006 Netfilter Core Team
ip_tables: (C) 2000-2006 Netfilter Core Team
eth0: no IPv6 routers present
BUG: unable to handle kernel NULL pointer dereference at virtual address 00=
00001c
printing eip: c02a82cb *pde =3D 00000000=20
Oops: 0000 [#1] SMP=20
Modules linked in: iptable_filter ip_tables ip6table_filter ip6_tables x_ta=
bles ipv6 af_packet cpufreq_conservative cpufreq_ondemand cpufreq_userspace=
 cpufreq_powersave acpi_cpufreq speedstep_lib freq_table snd_pcm_oss snd_mi=
xer_oss snd_seq snd_seq_device twofish twofish_common cbc blkcipher dm_cryp=
t nls_utf8 ntfs ext3 jbd loop mmc_block pcmcia container battery iwl3945 fi=
rmware_class yenta_socket button ohci1394 backlight output ac power_supply =
rsrc_nonstatic pcmcia_core mmc_core ieee1394 intel_agp joydev agpgart snd_h=
da_intel sr_mod cdrom r8169 snd_pcm snd_timer mac80211 snd soundcore snd_pa=
ge_alloc i2c_i801 i2c_core cfg80211 serio_raw sg usbhid ehci_hcd uhci_hcd s=
d_mod usbcore dm_snapshot edd dm_mod fan ata_piix libata scsi_mod thermal p=
rocessor

Pid: 47, comm: kacpi_notify Not tainted (2.6.24-rc1-git #68)
EIP: 0060:[<c02a82cb>] EFLAGS: 00010286 CPU: 0
EIP is at klist_del+0xc/0x39
EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
ESI: c2e2bc00 EDI: c2e2bc20 EBP: c1c88d7c ESP: c1c88d70
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process kacpi_notify (pid: 47, ti=3Dc1c88000 task=3Dc1cb5350 task.ti=3Dc1c8=
8000)
Stack: c2e2bc00 c2e2bc00 c1ce960c c1c88d90 c0231ab6 c2e2bc00 c2e2ba00 c1c88=
e1c=20
       c1c88d9c c0231ced c2e2ba1c c1c88da8 f8bee01a c2e2ba00 c1c88db4 f8c39=
04b=20
       c2e2ba00 c1c88de4 f8c391a2 c01d47bc c01d47bc 00000001 00000000 00008=
0d0=20
Call Trace:
 [<c0104edd>] show_trace_log_lvl+0x1a/0x2f
 [<c0104f8d>] show_stack_log_lvl+0x9b/0xa3
 [<c010503c>] show_registers+0xa7/0x179
 [<c0105222>] die+0x114/0x1f5
 [<c02abced>] do_page_fault+0x4b0/0x589
 [<c02aa58a>] error_code+0x72/0x78
 [<c0231ab6>] device_del+0x1a/0x246
 [<c0231ced>] device_unregister+0xb/0x15
 [<f8bee01a>] power_supply_unregister+0x1a/0x1d [power_supply]
 [<f8c3904b>] sysfs_remove_battery+0x1f/0x22 [battery]
 [<f8c391a2>] acpi_battery_update+0x3f/0x255 [battery]
 [<f8c396e9>] acpi_battery_get_property+0x2b/0x149 [battery]
 [<f8bee2c2>] power_supply_show_property+0x32/0xf0 [power_supply]
 [<f8bee59e>] power_supply_uevent+0xfd/0x187 [power_supply]
 [<c02322d8>] dev_uevent+0xca/0xe8
 [<c01d1a28>] kobject_uevent_env+0x15a/0x376
 [<c01d1c4e>] kobject_uevent+0xa/0xc
 [<c0231cb9>] device_del+0x21d/0x246
 [<c0231ced>] device_unregister+0xb/0x15
 [<f8bee01a>] power_supply_unregister+0x1a/0x1d [power_supply]
 [<f8c3904b>] sysfs_remove_battery+0x1f/0x22 [battery]
 [<f8c391a2>] acpi_battery_update+0x3f/0x255 [battery]
 [<f8c398ff>] acpi_battery_notify+0x1e/0x73 [battery]
 [<c01f9b50>] acpi_ev_notify_dispatch+0x4f/0x5a
 [<c01f447d>] acpi_os_execute_notify+0x24/0x2f
 [<c0130d05>] run_workqueue+0x7d/0x110
 [<c01316f5>] worker_thread+0xbe/0xcd
 [<c0134247>] kthread+0x3b/0x64
 [<c0104b63>] kernel_thread_helper+0x7/0x10
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Code: 08 e8 63 20 00 00 83 7d f0 00 74 09 85 ff 74 05 89 f8 ff 55 f0 8b 45 =
ec 5a 59 5b 5e 5f 5d c3 55 89 e5 57 89 c7 56 53 8b 18 89 d8 <8b> 73 1c e8 7=
b 20 00 00 89 f8 e8 58 ff ff ff 85 c0 b8 00 00 00=20
EIP: [<c02a82cb>] klist_del+0xc/0x39 SS:ESP 0068:c1c88d70
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 3
  groups: 1 2
CPU1 attaching sched-domain:
 domain 0: span 3
  groups: 2 1
BUG: unable to handle kernel NULL pointer dereference at virtual address 00=
00001c
printing eip: c02a82cb *pde =3D 00000000=20
Oops: 0000 [#2] SMP=20
Modules linked in: iptable_filter ip_tables ip6table_filter ip6_tables x_ta=
bles ipv6 af_packet cpufreq_conservative cpufreq_ondemand cpufreq_userspace=
 cpufreq_powersave acpi_cpufreq speedstep_lib freq_table snd_pcm_oss snd_mi=
xer_oss snd_seq snd_seq_device twofish twofish_common cbc blkcipher dm_cryp=
t nls_utf8 ntfs ext3 jbd loop mmc_block pcmcia container battery iwl3945 fi=
rmware_class yenta_socket button ohci1394 backlight output ac power_supply =
rsrc_nonstatic pcmcia_core mmc_core ieee1394 intel_agp joydev agpgart snd_h=
da_intel sr_mod cdrom r8169 snd_pcm snd_timer mac80211 snd soundcore snd_pa=
ge_alloc i2c_i801 i2c_core cfg80211 serio_raw sg usbhid ehci_hcd uhci_hcd s=
d_mod usbcore dm_snapshot edd dm_mod fan ata_piix libata scsi_mod thermal p=
rocessor

Pid: 2773, comm: hald Tainted: G      D (2.6.24-rc1-git #68)
EIP: 0060:[<c02a82cb>] EFLAGS: 00010286 CPU: 1
EIP is at klist_del+0xc/0x39
EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
ESI: c2e2bc00 EDI: c2e2bc20 EBP: c33b9e8c ESP: c33b9e80
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process hald (pid: 2773, ti=3Dc33b9000 task=3Dc3304d30 task.ti=3Dc33b9000)
Stack: c2e2bc00 c2e2bc00 c1ce960c c33b9ea0 c0231ab6 c2e2bc00 c2e2ba00 00000=
001=20
       c33b9eac c0231ced c2e2ba1c c33b9eb8 f8bee01a c2e2ba00 c33b9ec4 f8c39=
04b=20
       c39b3ec0 c33b9ef4 f8c391a2 c0163a98 c27f1cbc 00000246 c3bf9cf8 c33b9=
efc=20
Call Trace:
 [<c0104edd>] show_trace_log_lvl+0x1a/0x2f
 [<c0104f8d>] show_stack_log_lvl+0x9b/0xa3
 [<c010503c>] show_registers+0xa7/0x179
 [<c0105222>] die+0x114/0x1f5
 [<c02abced>] do_page_fault+0x4b0/0x589
 [<c02aa58a>] error_code+0x72/0x78
 [<c0231ab6>] device_del+0x1a/0x246
 [<c0231ced>] device_unregister+0xb/0x15
 [<f8bee01a>] power_supply_unregister+0x1a/0x1d [power_supply]
 [<f8c3904b>] sysfs_remove_battery+0x1f/0x22 [battery]
 [<f8c391a2>] acpi_battery_update+0x3f/0x255 [battery]
 [<f8c393ed>] acpi_battery_read+0x11/0x20 [battery]
 [<f8c3941c>] acpi_battery_read_state+0xf/0x11 [battery]
 [<c01889de>] seq_read+0xea/0x264
 [<c019fdef>] proc_reg_read+0x63/0x76
 [<c0172645>] vfs_read+0xa6/0x12f
 [<c0172a3e>] sys_read+0x3d/0x61
 [<c0103f12>] sysenter_past_esp+0x5f/0x85
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Code: 08 e8 63 20 00 00 83 7d f0 00 74 09 85 ff 74 05 89 f8 ff 55 f0 8b 45 =
ec 5a 59 5b 5e 5f 5d c3 55 89 e5 57 89 c7 56 53 8b 18 89 d8 <8b> 73 1c e8 7=
b 20 00 00 89 f8 e8 58 ff ff ff 85 c0 b8 00 00 00=20
EIP: [<c02a82cb>] klist_del+0xc/0x39 SS:ESP 0068:c33b9e80
omnibook: Driver version 2.20070211-trunk.
omnibook: Forced load with EC type 12.
omnibook: LCD backlight turn off at console blanking is enabled.
omnibook: Enabling all hotkeys.
omnibook: Enabled features: blank bluetooth cooling display hotkeys dmi ver=
sion lcd temperature touchpad wifi throttling.

--Boundary-01=_QvsKH6Hxqj1h8fq--

--nextPart1650252.MMvfe6pOBv
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHKsvVXKSJPmm5/E4RAvBCAJ9tc+170ZNypaVjkL1Hbb8o9rolHACfQ/V2
o1Idta6BoQcpHXIzq9LvM9Y=
=5Pqj
-----END PGP SIGNATURE-----

--nextPart1650252.MMvfe6pOBv--
