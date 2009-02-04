Return-Path: <linux-kernel-owner+w=401wt.eu-S1755845AbZBDOuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbZBDOuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 09:50:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbZBDOuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 09:50:07 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:58473 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbZBDOt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 09:49:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=w250NncGQZMNyZZnQgmFCgr8PfzmpCZxDE/WSp7M7gJMOHEG8lqnKTtOApYxWwlfE6
         1f8y9i7MfSHOIMNlyGGdAUDuzNWJIHph5DMQwv13O0g3lj+Mlhe8AuDGkk8WJHGYTMFZ
         Sg7670vO2NDrtWW1PHYr472hAu0e+AVTwDvgw=
MIME-Version: 1.0
Date: Wed, 4 Feb 2009 15:49:52 +0100
Message-ID: <c4e36d110902040649v3810c96du1c84caa9052ef4c6@mail.gmail.com>
Subject: BUG: unable to handle kernel paging request at 0000000000002328 
	__d_lookup+0xc8/0x1d0
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Today I've got this ugly oops - my machine T61, 4GB of memory (checked
with memtest), SMP, C2D
kernel commit: 33bfad54b58cf05cfe6678c3ec9235d4bc8db4c2

The only 'strange' thing I've been doing today is testing ext4 and its
online resize functionality.
But this oops happened somewhat later - so I'm not really sure whether
there is some correlation.

(Full kernel log follows)

BUG: unable to handle kernel paging request at 0000000000002328
IP: [<ffffffff802f8248>] __d_lookup+0xc8/0x1d0
PGD bd7df067 PUD bd7c5067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
CPU 0
Modules linked in: usbhid hid udf crc_itu_t tun fuse ipt_MASQUERADE
iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables
bridge stp llc rfcomm sco l2cap autofs4 sunrpc ipv6 binfmt_misc loop
dm_mirror dm_region_hash dm_log dm_mod kvm_intel kvm i915 drm
i2c_algo_bit uinput arc4 ecb cryptomgr aead snd_hda_codec_analog
crypto_blkcipher snd_hda_intel snd_hda_codec snd_seq_oss
snd_seq_midi_event snd_seq crypto_hash snd_seq_device crypto_algapi
iwl3945 btusb snd_pcm_oss mac80211 bluetooth snd_mixer_oss snd_pcm
thinkpad_acpi rfkill snd_timer evdev sdhci_pci snd backlight button
rtc_cmos lib80211 psmouse sdhci soundcore nvram e1000e rtc_core
cfg80211 snd_page_alloc iTCO_wdt iTCO_vendor_support mmc_core
led_class sr_mod cdrom intel_agp battery ac rtc_lib i2c_i801 i2c_core
serio_raw uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded:
microcode]
Pid: 14207, comm: sh Tainted: G        W  2.6.29-rc3 #27
RIP: 0010:[<ffffffff802f8248>]  [<ffffffff802f8248>] __d_lookup+0xc8/0x1d0
RSP: 0000:ffff8800bd6ebc88  EFLAGS: 00010206
RAX: 0000000000002328 RBX: 0000000000002328 RCX: 0000000000000013
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff806ffd40
RBP: ffff8800bd6ebce8 R08: 0000000000000001 R09: 0000000000000000
R10: 00000000085a6ed9 R11: ffff88013b404300 R12: ffff8800028b0000
R13: 018721e0036d5fe5 R14: 0000000000000005 R15: ffff8800bd6ebd78
FS:  00007f420a5876f0(0000) GS:ffffffff80990040(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000002328 CR3: 00000000be2df000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process sh (pid: 14207, threadinfo ffff8800bd6ea000, task ffff880108642260)
Stack:
 ffffffff802f8180 0000000000000046 ffff88013b404300 ffff8801085a6ed9
 000000053b2fdf80 ffff8800bd6ebd88 ffff8800307a11c0 0000000000001d4e
 ffff8800bd6ebd78 ffff88013b404300 ffff8800bd591780 0000000000000000
Call Trace:
 [<ffffffff802f8180>] ? __d_lookup+0x0/0x1d0
 [<ffffffff802f8393>] d_lookup+0x43/0x60
 [<ffffffff802f8429>] d_hash_and_lookup+0x79/0xa0
 [<ffffffff80336755>] proc_flush_task+0xc5/0x2c0
 [<ffffffff80249d10>] release_task+0x40/0x460
 [<ffffffff8024a7aa>] wait_consider_task+0x67a/0xa90
 [<ffffffff8024ad3e>] do_wait+0x17e/0x3c0
 [<ffffffff8023eaa0>] ? default_wake_function+0x0/0x20
 [<ffffffff8024b016>] sys_wait4+0x96/0xf0
 [<ffffffff8020c70b>] system_call_fastpath+0x16/0x1b
Code: 75 c4 4c 31 eb 44 8b 55 b8 41 21 dc 4c 8b 5d b0 4e 8d 24 e0 49
8b 04 24 48 89 c3 48 85 c0 75 0b eb 69 90 48 8b 1b 48 85 db 74 60 <48>
8b 03 4c 8d 63 a8 0f 18 08 45 39 54 24 70 75 e7 4d 39 5c 24
RIP  [<ffffffff802f8248>] __d_lookup+0xc8/0x1d0
 RSP <ffff8800bd6ebc88>
CR2: 0000000000002328
---[ end trace 41c78ad45a69564a ]---
SysRq : Emergency Sync
Emergency Sync complete
SysRq : Emergency Remount R/O


-----

    0.000000 Linux version 2.6.29-rc3 (gcc version 4.3.2 20081105 (Red
Hat 4.3.2-7) (GCC) ) #27 SMP Mon Feb 2 22:18:35 CET 2009
    0.000000 Command line: ro root=/dev/sda2 selinux=0 no_console_suspend
    0.000000 KERNEL supported cpus:
    0.000000   Intel GenuineIntel
    0.000000   AMD AuthenticAMD
    0.000000   Centaur CentaurHauls
    0.000000 BIOS-provided physical RAM map:
    0.000000  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
    0.000000  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
    0.000000  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
    0.000000  BIOS-e820: 0000000000100000 - 00000000bf6b0000 (usable)
    0.000000  BIOS-e820: 00000000bf6b0000 - 00000000bf6cc000 (ACPI data)
    0.000000  BIOS-e820: 00000000bf6cc000 - 00000000bf700000 (ACPI NVS)
    0.000000  BIOS-e820: 00000000bf700000 - 00000000c0000000 (reserved)
    0.000000  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
    0.000000  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
    0.000000  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
    0.000000  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
    0.000000  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
    0.000000  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
    0.000000  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
    0.000000  BIOS-e820: 0000000100000000 - 000000013c000000 (usable)
    0.000000 DMI present.
    0.000000 last_pfn = 0x13c000 max_arch_pfn = 0x100000000
    0.000000 x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
    0.000000 last_pfn = 0xbf6b0 max_arch_pfn = 0x100000000
    0.000000 Scanning 2 areas for low memory corruption
    0.000000 modified physical RAM map:
    0.000000  modified: 0000000000000000 - 0000000000001000 (usable)
    0.000000  modified: 0000000000001000 - 0000000000006000 (reserved)
    0.000000  modified: 0000000000006000 - 0000000000008000 (usable)
    0.000000  modified: 0000000000008000 - 0000000000010000 (reserved)
    0.000000  modified: 0000000000010000 - 0000000000090800 (usable)
    0.000000  modified: 000000000009d800 - 00000000000a0000 (reserved)
    0.000000  modified: 00000000000e0000 - 0000000000100000 (reserved)
    0.000000  modified: 0000000000100000 - 00000000bf6b0000 (usable)
    0.000000  modified: 00000000bf6b0000 - 00000000bf6cc000 (ACPI data)
    0.000000  modified: 00000000bf6cc000 - 00000000bf700000 (ACPI NVS)
    0.000000  modified: 00000000bf700000 - 00000000c0000000 (reserved)
    0.000000  modified: 00000000f0000000 - 00000000f4000000 (reserved)
    0.000000  modified: 00000000fec00000 - 00000000fec10000 (reserved)
    0.000000  modified: 00000000fed00000 - 00000000fed00400 (reserved)
    0.000000  modified: 00000000fed14000 - 00000000fed1a000 (reserved)
    0.000000  modified: 00000000fed1c000 - 00000000fed90000 (reserved)
    0.000000  modified: 00000000fee00000 - 00000000fee01000 (reserved)
    0.000000  modified: 00000000ff000000 - 0000000100000000 (reserved)
    0.000000  modified: 0000000100000000 - 000000013c000000 (usable)
    0.000000 init_memory_mapping: 0000000000000000-00000000bf6b0000
    0.000000 last_map_addr: bf6b0000 end: bf6b0000
    0.000000 init_memory_mapping: 0000000100000000-000000013c000000
    0.000000 last_map_addr: 13c000000 end: 13c000000
    0.000000 RAMDISK: 37caf000 - 37fefd91
    0.000000 ACPI: RSDP 000F68D0, 0024 (r2 LENOVO)
    0.000000 ACPI: XSDT BF6BB66D, 0094 (r1 LENOVO TP-7L        2240
LTP        0)
    0.000000 ACPI: FACP BF6BB800, 00F4 (r3 LENOVO TP-7L        2240
LNVO        1)
    0.000000 ACPI Warning (tbfadt-0568): 32/64X length mismatch in
Gpe0Block: 64/32 [20081204]
    0.000000 ACPI Warning (tbfadt-0568): 32/64X length mismatch in
Gpe1Block: 0/32 [20081204]
    0.000000 ACPI Warning (tbfadt-0596): Optional field Gpe1Block has
zero address or length: 000000000000102C/0 [20081204]
    0.000000 FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
    0.000000 ACPI: DSDT BF6BBC1D, FFE3 (r1 LENOVO TP-7L        2240
MSFT  3000000)
    0.000000 ACPI: FACS BF6E4000, 0040
    0.000000 ACPI: SSDT BF6BB9B4, 0269 (r1 LENOVO TP-7L        2240
MSFT  3000000)
    0.000000 ACPI: ECDT BF6CBC00, 0052 (r1 LENOVO TP-7L        2240
LNVO        1)
    0.000000 ACPI: TCPA BF6CBC52, 0032 (r2 LENOVO TP-7L        2240
LNVO        1)
    0.000000 ACPI: APIC BF6CBC84, 0068 (r1 LENOVO TP-7L        2240
LNVO        1)
    0.000000 ACPI: MCFG BF6CBCEC, 003C (r1 LENOVO TP-7L        2240
LNVO        1)
    0.000000 ACPI: HPET BF6CBD28, 0038 (r1 LENOVO TP-7L        2240
LNVO        1)
    0.000000 ACPI: SLIC BF6CBDF0, 0176 (r1 LENOVO TP-7L        2240
LTP        0)
    0.000000 ACPI: BOOT BF6CBF66, 0028 (r1 LENOVO TP-7L        2240
LTP        1)
    0.000000 ACPI: ASF! BF6CBF8E, 0072 (r16 LENOVO TP-7L        2240
PTL         1)
    0.000000 ACPI: SSDT BF6E26D9, 025F (r1 LENOVO TP-7L        2240
INTL 20050513)
    0.000000 ACPI: SSDT BF6E2938, 00A6 (r1 LENOVO TP-7L        2240
INTL 20050513)
    0.000000 ACPI: SSDT BF6E29DE, 04F7 (r1 LENOVO TP-7L        2240
INTL 20050513)
    0.000000 ACPI: SSDT BF6E2ED5, 01D8 (r1 LENOVO TP-7L        2240
INTL 20050513)
    0.000000 ACPI: DMI detected: Lenovo ThinkPad T61
    0.000000 ACPI: Added _OSI(Linux)
    0.000000 (7 early reservations) ==> bootmem [0000000000 - 013c000000]
    0.000000   #0 [0000000000 - 0000001000]   BIOS data page ==>
[0000000000 - 0000001000]
    0.000000   #1 [0000006000 - 0000008000]       TRAMPOLINE ==>
[0000006000 - 0000008000]
    0.000000   #2 [0000200000 - 00010cf9a0]    TEXT DATA BSS ==>
[0000200000 - 00010cf9a0]
    0.000000   #3 [0037caf000 - 0037fefd91]          RAMDISK ==>
[0037caf000 - 0037fefd91]
    0.000000   #4 [000009d800 - 0000100000]    BIOS reserved ==>
[000009d800 - 0000100000]
    0.000000   #5 [0000010000 - 0000013000]          PGTABLE ==>
[0000010000 - 0000013000]
    0.000000   #6 [0000013000 - 0000014000]          PGTABLE ==>
[0000013000 - 0000014000]
    0.000000 found SMP MP-table at [ffff8800000f6900] 000f6900
    0.000000 Zone PFN ranges:
    0.000000   DMA      0x00000000 -> 0x00001000
    0.000000   DMA32    0x00001000 -> 0x00100000
    0.000000   Normal   0x00100000 -> 0x0013c000
    0.000000 Movable zone start PFN for each node
    0.000000 early_node_map[5] active PFN ranges
    0.000000     0: 0x00000000 -> 0x00000001
    0.000000     0: 0x00000006 -> 0x00000008
    0.000000     0: 0x00000010 -> 0x00000090
    0.000000     0: 0x00000100 -> 0x000bf6b0
    0.000000     0: 0x00100000 -> 0x0013c000
    0.000000 ACPI: PM-Timer IO Port: 0x1008
    0.000000 ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
    0.000000 ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
    0.000000 ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
    0.000000 ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
    0.000000 ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
    0.000000 IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
    0.000000 ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
    0.000000 ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
    0.000000 Using ACPI (MADT) for SMP configuration information
    0.000000 ACPI: HPET id: 0x8086a201 base: 0xfed00000
    0.000000 SMP: Allowing 2 CPUs, 0 hotplug CPUs
    0.000000 PM: Registered nosave memory: 0000000000001000 - 0000000000006000
    0.000000 PM: Registered nosave memory: 0000000000008000 - 0000000000010000
    0.000000 PM: Registered nosave memory: 0000000000090000 - 000000000009e000
    0.000000 PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
    0.000000 PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
    0.000000 PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
    0.000000 PM: Registered nosave memory: 00000000bf6b0000 - 00000000bf6cc000
    0.000000 PM: Registered nosave memory: 00000000bf6cc000 - 00000000bf700000
    0.000000 PM: Registered nosave memory: 00000000bf700000 - 00000000c0000000
    0.000000 PM: Registered nosave memory: 00000000c0000000 - 00000000f0000000
    0.000000 PM: Registered nosave memory: 00000000f0000000 - 00000000f4000000
    0.000000 PM: Registered nosave memory: 00000000f4000000 - 00000000fec00000
    0.000000 PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
    0.000000 PM: Registered nosave memory: 00000000fec10000 - 00000000fed00000
    0.000000 PM: Registered nosave memory: 00000000fed00000 - 00000000fed14000
    0.000000 PM: Registered nosave memory: 00000000fed14000 - 00000000fed1a000
    0.000000 PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
    0.000000 PM: Registered nosave memory: 00000000fed1c000 - 00000000fed90000
    0.000000 PM: Registered nosave memory: 00000000fed90000 - 00000000fee00000
    0.000000 PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
    0.000000 PM: Registered nosave memory: 00000000fee01000 - 00000000ff000000
    0.000000 PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
    0.000000 Allocating PCI resources starting at c4000000 (gap:
c0000000:30000000)
    0.000000 NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:2 nr_node_ids:1
    0.000000 PERCPU: Allocating 1884160 bytes of per cpu data
    0.000000 Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 996712
    0.000000 Kernel command line: ro root=/dev/sda2 selinux=0 no_console_suspend
    0.000000 Initializing CPU#0
    0.000000 PID hash table entries: 4096 (order: 12, 32768 bytes)
    0.000000 Extended CMOS year: 2000
    0.000000 Fast TSC calibration using PIT
    0.000000 Detected 2194.406 MHz processor.
    0.003333 Console: colour VGA+ 80x25
    0.003333 console [tty0] enabled
    0.003333 Lock dependency validator: Copyright (c) 2006 Red Hat,
Inc., Ingo Molnar
    0.003333 ... MAX_LOCKDEP_SUBCLASSES:  8
    0.003333 ... MAX_LOCK_DEPTH:          48
    0.003333 ... MAX_LOCKDEP_KEYS:        8191
    0.003333 ... CLASSHASH_SIZE:          4096
    0.003333 ... MAX_LOCKDEP_ENTRIES:     8192
    0.003333 ... MAX_LOCKDEP_CHAINS:      16384
    0.003333 ... CHAINHASH_SIZE:          8192
    0.003333  memory used by lock dependency info: 4351 kB
    0.003333  per task-struct memory footprint: 2688 bytes
    0.003333 Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
    0.003333 Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
    0.003333 Checking aperture...
    0.003333 No AGP bridge found
    0.003333 PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
    0.003333 Placing 64MB software IO TLB between ffff880020000000 -
ffff880024000000
    0.003333 software IO TLB at phys 0x20000000 - 0x24000000
    0.003333 Memory: 3889872k/5177344k available (3448k kernel code,
1058612k absent, 227908k reserved, 1900k data, 2208k init)
    0.003333 SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0,
CPUs=2, Nodes=1
    0.003333 HPET: 3 timers in total, 0 timers will be used for per-cpu timer
    0.003333 Calibrating delay loop (skipped), value calculated using
timer frequency.. 4390.67 BogoMIPS (lpj=7314686)
    0.003333 Security Framework initialized
    0.003333 SELinux:  Disabled at boot.
    0.003333 Mount-cache hash table entries: 256
    0.003333 CPU: L1 I cache: 32K, L1 D cache: 32K
    0.003333 CPU: L2 cache: 4096K
    0.003333 [ds] using core 2 configuration
    0.003333 CPU: Physical Processor ID: 0
    0.003333 CPU: Processor Core ID: 0
    0.003333 CPU0: Thermal monitoring enabled (TM2)
    0.003333 using mwait in idle threads.
    0.003333 ACPI: Core revision 20081204
    0.046690 ftrace: converting mcount calls to 0f 1f 44 00 00
    0.046777 ftrace: allocating 12644 entries in 100 pages
    0.050143 Setting APIC routing to flat
    0.050796 ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
    0.084916 CPU0: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0a
    0.086666 lockdep: fixing up alternatives.
    0.086666 Booting processor 1 APIC 0x1 ip 0x6000
    0.003333 Initializing CPU#1
    0.003333 Calibrating delay using timer specific routine.. 4390.85
BogoMIPS (lpj=7314973)
    0.003333 CPU: L1 I cache: 32K, L1 D cache: 32K
    0.003333 CPU: L2 cache: 4096K
    0.003333 [ds] using core 2 configuration
    0.003333 CPU: Physical Processor ID: 0
    0.003333 CPU: Processor Core ID: 1
    0.003333 CPU1: Thermal monitoring enabled (TM2)
    0.003333 x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
    0.178146 CPU1: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0a
    0.179029 checking TSC synchronization [CPU#0 -> CPU#1]:
    0.179999 Measured 399278 cycles TSC warp between CPUs, turning off
TSC clock.
    0.179999 Marking TSC unstable due to check_tsc_sync_source failed
    0.180055 Brought up 2 CPUs
    0.180130 Total of 2 processors activated (8781.53 BogoMIPS).
    0.183581 khelper used greatest stack depth: 5496 bytes left
    0.183868 net_namespace: 2112 bytes
    0.183868 regulator: core version 0.5
    0.183932 NET: Registered protocol family 16
    0.183932 ACPI FADT declares the system doesn't support PCIe ASPM,
so disable it
    0.183932 ACPI: bus type pci registered
    0.183932 PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
    0.183932 PCI: MCFG area at f0000000 reserved in E820
    0.198738 PCI: Using MMCONFIG at f0000000 - f3ffffff
    0.198815 PCI: Using configuration type 1 for base access
    0.206856 bio: create slab <bio-0> at 0
    0.219460 ACPI: EC: EC description table is found, configuring boot EC
    0.245921 ACPI: BIOS _OSI(Linux) query honored via DMI
    0.246698 ACPI: EC: non-query interrupt received, switching to interrupt mode
    0.260308 ACPI: Interpreter enabled
    0.260384 ACPI: (supports S0 S3 S4 S5)
    0.260762 ACPI: Using IOAPIC for interrupt routing
    0.295344 ACPI: EC: GPE = 0x12, I/O: command/status = 0x66, data = 0x62
    0.295344 ACPI: EC: driver started in interrupt mode
    0.304467 ACPI: ACPI Dock Station Driver: 3 docks/bays found
    0.305279 ACPI: PCI Root Bridge [PCI0] (0000:00)
    0.305568 pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
    0.305568 pci 0000:00:19.0: PME# disabled
    0.307420 pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
    0.307505 pci 0000:00:1a.7: PME# disabled
    0.307939 pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
    0.308028 pci 0000:00:1b.0: PME# disabled
    0.308370 pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
    0.308453 pci 0000:00:1c.0: PME# disabled
    0.308802 pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
    0.308885 pci 0000:00:1c.1: PME# disabled
    0.309239 pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
    0.309323 pci 0000:00:1c.2: PME# disabled
    0.309681 pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
    0.309769 pci 0000:00:1c.3: PME# disabled
    0.310163 pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
    0.310250 pci 0000:00:1c.4: PME# disabled
    0.311353 pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
    0.311438 pci 0000:00:1d.7: PME# disabled
    0.312001 pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6
ACPI/GPIO/TCO
    0.312091 pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 GPIO
    0.312171 pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at
1600 (mask 007f)
    0.312275 pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at
15e0 (mask 000f)
    0.312371 pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at
1680 (mask 001f)
    0.313163 pci 0000:00:1f.2: PME# supported from D3hot
    0.313247 pci 0000:00:1f.2: PME# disabled
    0.314364 pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
    0.314440 pci 0000:03:00.0: PME# disabled
    0.315593 pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
    0.315677 pci 0000:15:00.0: PME# disabled
    0.316093 pci 0000:15:00.2: PME# supported from D0 D1 D2 D3hot D3cold
    0.316178 pci 0000:15:00.2: PME# disabled
    0.316590 pci 0000:15:00.3: PME# supported from D0 D1 D2 D3hot D3cold
    0.316680 pci 0000:15:00.3: PME# disabled
    0.317087 pci 0000:15:00.4: PME# supported from D0 D1 D2 D3hot D3cold
    0.317173 pci 0000:15:00.4: PME# disabled
    0.317582 pci 0000:15:00.5: PME# supported from D0 D1 D2 D3hot D3cold
    0.317675 pci 0000:15:00.5: PME# disabled
    0.317945 pci 0000:00:1e.0: transparent bridge
    0.340362 ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11)
    0.343703 ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
    0.344775 ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
    0.345840 ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
    0.346998 ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
    0.348057 ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
    0.349113 ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
    0.350175 ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
    0.351099 ACPI: Power Resource [PUBS] (on)
    0.351143 SCSI subsystem initialized
    0.353413 PCI: Using ACPI for IRQ routing
    0.366795 hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
    0.367135 hpet0: 3 comparators, 64-bit 14.318180 MHz counter
    0.387534 pnp: PnP ACPI init
    0.387648 ACPI: bus type pnp registered
    0.396563 pnp: PnP ACPI: found 11 devices
    0.396643 ACPI: ACPI bus type pnp unregistered
    0.396769 system 00:00: iomem range 0x0-0x9ffff could not be reserved
    0.396847 system 00:00: iomem range 0xc0000-0xc3fff has been reserved
    0.396928 system 00:00: iomem range 0xc4000-0xc7fff has been reserved
    0.397009 system 00:00: iomem range 0xc8000-0xcbfff has been reserved
    0.397084 system 00:00: iomem range 0xcc000-0xcffff has been reserved
    0.397163 system 00:00: iomem range 0xe0000-0xe3fff could not be reserved
    0.397249 system 00:00: iomem range 0xe4000-0xe7fff could not be reserved
    0.397326 system 00:00: iomem range 0xe8000-0xebfff could not be reserved
    0.397406 system 00:00: iomem range 0xec000-0xeffff could not be reserved
    0.397484 system 00:00: iomem range 0xf0000-0xfffff could not be reserved
    0.397568 system 00:00: iomem range 0x100000-0xbfffffff could not be reserved
    0.397660 system 00:00: iomem range 0xfec00000-0xfed3ffff could not
be reserved
    0.397751 system 00:00: iomem range 0xfed4c000-0xffffffff could not
be reserved
    0.397853 system 00:02: ioport range 0x164e-0x164f has been reserved
    0.397931 system 00:02: ioport range 0x1000-0x107f has been reserved
    0.398008 system 00:02: ioport range 0x1180-0x11bf has been reserved
    0.398087 system 00:02: ioport range 0x800-0x80f has been reserved
    0.398171 system 00:02: ioport range 0x15e0-0x15ef has been reserved
    0.398251 system 00:02: ioport range 0x1600-0x165f could not be reserved
    0.398330 system 00:02: iomem range 0xf0000000-0xf3ffffff has been reserved
    0.398406 system 00:02: iomem range 0xfed1c000-0xfed1ffff has been reserved
    0.398489 system 00:02: iomem range 0xfed14000-0xfed17fff has been reserved
    0.398569 system 00:02: iomem range 0xfed18000-0xfed18fff has been reserved
    0.398650 system 00:02: iomem range 0xfed19000-0xfed19fff has been reserved
    0.398727 system 00:02: iomem range 0xfed45000-0xfed4bfff has been reserved
    0.405291 pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
    0.405372 pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
    0.405458 pci 0000:00:1c.0:   MEM window: 0xfc000000-0xfdffffff
    0.405551 pci 0000:00:1c.0:   PREFETCH window:
0x000000f8000000-0x000000f80fffff
    0.405659 pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
    0.405740 pci 0000:00:1c.1:   IO window: 0x3000-0x3fff
    0.405828 pci 0000:00:1c.1:   MEM window: 0xdc000000-0xdf3fffff
    0.405914 pci 0000:00:1c.1:   PREFETCH window:
0x000000dfe00000-0x000000dfefffff
    0.406024 pci 0000:00:1c.2: PCI bridge, secondary bus 0000:04
    0.406109 pci 0000:00:1c.2:   IO window: 0x4000-0x4fff
    0.406196 pci 0000:00:1c.2:   MEM window: 0xd8000000-0xd9ffffff
    0.406280 pci 0000:00:1c.2:   PREFETCH window:
0x000000dfb00000-0x000000dfbfffff
    0.406391 pci 0000:00:1c.3: PCI bridge, secondary bus 0000:05
    0.406471 pci 0000:00:1c.3:   IO window: 0x5000-0x5fff
    0.406562 pci 0000:00:1c.3:   MEM window: 0xd4000000-0xd5ffffff
    0.406654 pci 0000:00:1c.3:   PREFETCH window:
0x000000df800000-0x000000df8fffff
    0.406799 pci 0000:00:1c.4: PCI bridge, secondary bus 0000:0d
    0.406880 pci 0000:00:1c.4:   IO window: 0x6000-0x6fff
    0.406969 pci 0000:00:1c.4:   MEM window: 0xd0000000-0xd1ffffff
    0.407062 pci 0000:00:1c.4:   PREFETCH window:
0x000000df500000-0x000000df5fffff
    0.407183 pci 0000:15:00.0: CardBus bridge, secondary bus 0000:16
    0.407873 pci 0000:15:00.0:   IO window: 0x007000-0x0070ff
    0.407960 pci 0000:15:00.0:   IO window: 0x007400-0x0074ff
    0.408046 pci 0000:15:00.0:   PREFETCH window: 0xf4000000-0xf7ffffff
    0.408134 pci 0000:15:00.0:   MEM window: 0xc4000000-0xc7ffffff
    0.408218 pci 0000:00:1e.0: PCI bridge, secondary bus 0000:15
    0.408298 pci 0000:00:1e.0:   IO window: 0x7000-0xafff
    0.408388 pci 0000:00:1e.0:   MEM window: 0xf8300000-0xfbffffff
    0.408478 pci 0000:00:1e.0:   PREFETCH window:
0x000000f4000000-0x000000f7ffffff
    0.408616 pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
    0.408730 pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
    0.408846 pci 0000:00:1c.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
    0.408962 pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
    0.409069 pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
    0.409166 pci 0000:00:1e.0: enabling device (0005 -> 0007)
    0.409285 pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
    0.409473 NET: Registered protocol family 2
    0.443463 IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
    0.444173 TCP established hash table entries: 262144 (order: 10,
4194304 bytes)
    0.446419 TCP bind hash table entries: 32768 (order: 9, 2359296 bytes)
    0.451124 TCP: Hash tables configured (established 262144 bind 32768)
    0.451248 TCP reno registered
    0.460197 NET: Registered protocol family 1
    0.460619 checking if image is initramfs... it is
    0.700298 Freeing initrd memory: 3331k freed
    0.701878 Simple Boot Flag at 0x35 set to 0x1
    0.704522 Scanning for low memory corruption every 60 seconds
    0.705398 audit: initializing netlink socket (disabled)
    0.705510 type=2000 audit(1233659874.703:1): initialized
    0.723109 msgmni has been set to 7605
    0.723566 io scheduler noop registered
    0.723640 io scheduler anticipatory registered
    0.723715 io scheduler deadline registered
    0.723811 io scheduler cfq registered (default)
    0.731877 ACPI: SSDT BF6E1B32, 02C4 (r1  PmRef  Cpu0Ist      100
INTL 20050513)
    0.735550 ACPI: SSDT BF6E1E7B, 085E (r1  PmRef  Cpu0Cst      100
INTL 20050513)
    0.745266 ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
    0.745843 processor ACPI_CPU:00: registered as cooling_device0
    0.745926 ACPI: Processor [CPU0] (supports 8 throttling states)
    0.746824 ACPI: SSDT BF6E1A6A, 00C8 (r1  PmRef  Cpu1Ist      100
INTL 20050513)
    0.750399 ACPI: SSDT BF6E1DF6, 0085 (r1  PmRef  Cpu1Cst      100
INTL 20050513)
    0.755850 ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
    0.756315 processor ACPI_CPU:01: registered as cooling_device1
    0.756401 ACPI: Processor [CPU1] (supports 8 throttling states)
    0.767282 thermal LNXTHERM:01: registered as thermal_zone0
    0.770567 ACPI: Thermal Zone [THM0] (52 C)
    0.772299 thermal LNXTHERM:02: registered as thermal_zone1
    0.774020 ACPI: Thermal Zone [THM1] (50 C)
    0.783885 Linux agpgart interface v0.103
    0.783960 Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
    0.791370 brd: module loaded
    0.791792 Driver 'sd' needs updating - please use bus_type methods
    0.792196 ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
    0.792523 ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 1.5
Gbps 0x5 impl SATA mode
    0.792616 ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part
    0.793043 scsi0 : ahci
    0.793817 scsi1 : ahci
    0.794299 scsi2 : ahci
    0.794809 ata1: SATA max UDMA/133 abar m2048@0xfe226000 port
0xfe226100 irq 29
    0.794896 ata2: DUMMY
    0.794968 ata3: SATA max UDMA/133 abar m2048@0xfe226000 port
0xfe226200 irq 29
    1.113390 ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
    1.115981 ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
    1.117376 ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
    1.119309 ata1.00: ATA-7: ST910021AS, 4.06, max UDMA/100
    1.119387 ata1.00: 195371568 sectors, multi 16: LBA48
    1.122903 ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
    1.124307 ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
    1.126248 ata1.00: configured for UDMA/100
    1.140929 ata1.00: configured for UDMA/100
    1.141008 ata1: EH complete
    1.141567 scsi 0:0:0:0: Direct-Access     ATA      ST910021AS
4.06 PQ: 0 ANSI: 5
    1.142512 sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors:
(100 GB/93.1 GiB)
    1.142651 sd 0:0:0:0: [sda] Write Protect is off
    1.142809 sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
    1.143411 sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors:
(100 GB/93.1 GiB)
    1.143539 sd 0:0:0:0: [sda] Write Protect is off
    1.143693 sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
    1.143805  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 >
    1.282939 sd 0:0:0:0: [sda] Attached SCSI disk
    1.283734 sd 0:0:0:0: Attached scsi generic sg0 type 0
    1.603390 ata3: SATA link down (SStatus 0 SControl 300)
    1.616944 ata_piix 0000:00:1f.1: PCI INT C -> GSI 16 (level, low) -> IRQ 16
    1.617299 scsi3 : ata_piix
    1.617763 scsi4 : ata_piix
    1.619394 ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1c00 irq 14
    1.619474 ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1c08 irq 15
    1.777348 ata4.00: ATAPI: HL-DT-ST DVDRAM GSA-U10N, 1.05, max UDMA/33
    1.790292 ata4.00: configured for UDMA/33
    1.794511 scsi 3:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-U10N
1.05 PQ: 0 ANSI: 5
    1.795251 scsi 3:0:0:0: Attached scsi generic sg1 type 5
    1.796151 Fusion MPT base driver 3.04.07
    1.796223 Copyright (c) 1999-2008 LSI Corporation
    1.796317 Fusion MPT SPI Host driver 3.04.07
    1.796540 Fusion MPT misc device (ioctl) driver 3.04.07
    1.796756 mptctl: Registered with Fusion MPT base driver
    1.796831 mptctl: /dev/mptctl @ (major,minor=10,220)
    1.797180 PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at
0x60,0x64 irq 1,12
    1.805747 serio: i8042 KBD port at 0x60,0x64 irq 1
    1.805862 serio: i8042 AUX port at 0x60,0x64 irq 12
    1.806201 mice: PS/2 mouse device common for all mice
    1.806422 hdaps: inverting axis readings.
    1.806504 hdaps: LENOVO ThinkPad T61 detected.
    1.807722 input: hdaps as /devices/platform/hdaps/input/input0
    1.807801 hdaps: driver successfully loaded.
    1.808852 cpuidle: using governor ladder
    1.811015 cpuidle: using governor menu
    1.811195 TCP cubic registered
    1.811272 NET: Registered protocol family 17
    1.813693 registered taskstats version 1
    1.814400 Freeing unused kernel memory: 2208k freed
    1.815736 Write protecting the kernel read-only data: 1580k
    1.821763 input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input1
    2.000137 Clocksource tsc unstable (delta = -110855137 ns)
    2.126970 setfont used greatest stack depth: 4952 bytes left
    2.466825 usbcore: registered new interface driver usbfs
    2.467389 usbcore: registered new interface driver hub
    2.467965 usbcore: registered new device driver usb
    2.475636 ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
    2.477057 ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
    2.477208 ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
    2.477479 ehci_hcd 0000:00:1a.7: EHCI Host Controller
    2.479794 ehci_hcd 0000:00:1a.7: new USB bus registered, assigned
bus number 1
    2.484402 ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfe226c00
    2.500143 ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
    2.500756 usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
    2.500893 usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
    2.501056 usb usb1: Product: EHCI Host Controller
    2.501168 usb usb1: Manufacturer: Linux 2.6.29-rc3 ehci_hcd
    2.501284 usb usb1: SerialNumber: 0000:00:1a.7
    2.502231 usb usb1: configuration #1 chosen from 1 choice
    2.503114 hub 1-0:1.0: USB hub found
    2.503402 hub 1-0:1.0: 4 ports detected
    2.507864 ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
    2.508018 ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
    2.508202 ehci_hcd 0000:00:1d.7: EHCI Host Controller
    2.508637 ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 2
    2.512807 ehci_hcd 0000:00:1d.7: debug port 1
    2.513028 ehci_hcd 0000:00:1d.7: irq 19, io mem 0xfe227000
    2.526831 ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
    2.527233 usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
    2.527355 usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
    2.527477 usb usb2: Product: EHCI Host Controller
    2.527620 usb usb2: Manufacturer: Linux 2.6.29-rc3 ehci_hcd
    2.527765 usb usb2: SerialNumber: 0000:00:1d.7
    2.528424 usb usb2: configuration #1 chosen from 1 choice
    2.528912 hub 2-0:1.0: USB hub found
    2.529063 hub 2-0:1.0: 6 ports detected
    2.531180 modprobe used greatest stack depth: 3304 bytes left
    2.545078 ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
    2.558934 uhci_hcd: USB Universal Host Controller Interface driver
    2.559516 uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
    2.559680 uhci_hcd 0000:00:1a.0: UHCI Host Controller
    2.560078 uhci_hcd 0000:00:1a.0: new USB bus registered, assigned
bus number 3
    2.560250 uhci_hcd 0000:00:1a.0: detected 2 ports
    2.560503 uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
    2.561004 usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
    2.561126 usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
    2.561259 usb usb3: Product: UHCI Host Controller
    2.561375 usb usb3: Manufacturer: Linux 2.6.29-rc3 uhci_hcd
    2.561490 usb usb3: SerialNumber: 0000:00:1a.0
    2.562074 usb usb3: configuration #1 chosen from 1 choice
    2.562471 hub 3-0:1.0: USB hub found
    2.562739 hub 3-0:1.0: 2 ports detected
    2.565009 uhci_hcd 0000:00:1a.1: power state changed by ACPI to D0
    2.565148 uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
    2.565308 uhci_hcd 0000:00:1a.1: UHCI Host Controller
    2.565750 uhci_hcd 0000:00:1a.1: new USB bus registered, assigned
bus number 4
    2.565894 uhci_hcd 0000:00:1a.1: detected 2 ports
    2.566151 uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
    2.566551 usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
    2.566725 usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
    2.566849 usb usb4: Product: UHCI Host Controller
    2.566964 usb usb4: Manufacturer: Linux 2.6.29-rc3 uhci_hcd
    2.567085 usb usb4: SerialNumber: 0000:00:1a.1
    2.567756 usb usb4: configuration #1 chosen from 1 choice
    2.568248 hub 4-0:1.0: USB hub found
    2.568397 hub 4-0:1.0: 2 ports detected
    2.570777 uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
    2.570981 uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
    2.571142 uhci_hcd 0000:00:1d.0: UHCI Host Controller
    2.571583 uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 5
    2.571728 uhci_hcd 0000:00:1d.0: detected 2 ports
    2.571976 uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018a0
    2.572407 usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
    2.572532 usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
    2.572662 usb usb5: Product: UHCI Host Controller
    2.572767 usb usb5: Manufacturer: Linux 2.6.29-rc3 uhci_hcd
    2.572881 usb usb5: SerialNumber: 0000:00:1d.0
    2.573555 usb usb5: configuration #1 chosen from 1 choice
    2.574043 hub 5-0:1.0: USB hub found
    2.574244 hub 5-0:1.0: 2 ports detected
    2.575622 uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
    2.575783 uhci_hcd 0000:00:1d.1: UHCI Host Controller
    2.576198 uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 6
    2.576345 uhci_hcd 0000:00:1d.1: detected 2 ports
    2.576597 uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018c0
    2.577005 usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
    2.577118 usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
    2.577241 usb usb6: Product: UHCI Host Controller
    2.577354 usb usb6: Manufacturer: Linux 2.6.29-rc3 uhci_hcd
    2.577466 usb usb6: SerialNumber: 0000:00:1d.1
    2.578182 usb usb6: configuration #1 chosen from 1 choice
    2.578844 hub 6-0:1.0: USB hub found
    2.578994 hub 6-0:1.0: 2 ports detected
    2.581607 uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
    2.581756 uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
    2.581901 uhci_hcd 0000:00:1d.2: UHCI Host Controller
    2.582329 uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 7
    2.582476 uhci_hcd 0000:00:1d.2: detected 2 ports
    2.582725 uhci_hcd 0000:00:1d.2: irq 18, io base 0x000018e0
    2.583122 usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
    2.583240 usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
    2.583444 usb usb7: Product: UHCI Host Controller
    2.583553 usb usb7: Manufacturer: Linux 2.6.29-rc3 uhci_hcd
    2.583664 usb usb7: SerialNumber: 0000:00:1d.2
    2.584327 usb usb7: configuration #1 chosen from 1 choice
    2.584817 hub 7-0:1.0: USB hub found
    2.584968 hub 7-0:1.0: 2 ports detected
    3.068080 kjournald starting.  Commit interval 5 seconds
    3.068567 EXT3-fs: mounted filesystem with ordered data mode.
    3.143504 usb 3-1: new full speed USB device using uhci_hcd and address 2
    3.299903 usb 3-1: New USB device found, idVendor=0a5c, idProduct=2110
    3.300057 usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
    3.300177 usb 3-1: Product: BCM2045B
    3.300285 usb 3-1: Manufacturer: Broadcom Corp
    3.301121 usb 3-1: configuration #1 chosen from 1 choice
    3.533498 usb 3-2: new full speed USB device using uhci_hcd and address 3
    3.541819 modprobe used greatest stack depth: 3224 bytes left
    3.702876 usb 3-2: New USB device found, idVendor=0483, idProduct=2016
    3.702978 usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
    3.703102 usb 3-2: Product: Biometric Coprocessor
    3.703219 usb 3-2: Manufacturer: STMicroelectronics
    3.703801 usb 3-2: configuration #1 chosen from 1 choice
    5.108411 cat used greatest stack depth: 3144 bytes left
   12.174802 udev: starting version 137
   12.940314 i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) -> IRQ 23
   13.030994 ACPI: AC Adapter [AC] (on-line)
   13.102136 ACPI: Battery Slot [BAT0] (battery present)
   13.122499 agpgart-intel 0000:00:00.0: Intel 965GM Chipset
   13.125564 agpgart-intel 0000:00:00.0: detected 7676K stolen memory
   13.132355 agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
   13.243263 Driver 'sr' needs updating - please use bus_type methods
   13.255821 sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw
xa/form2 cdda tray
   13.255831 Uniform CD-ROM driver Revision: 3.20
   13.543157 iTCO_vendor_support: vendor-support=0
   13.562331 iTCO_wdt: Intel TCO WatchDog Timer Driver v1.04
   13.563011 iTCO_wdt: Found a ICH8M-E TCO device (Version=2, TCOBASE=0x1060)
   13.563430 iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
   13.820410 cfg80211: Calling CRDA to update world regulatory domain
   14.030835 e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
   14.030843 e1000e: Copyright (c) 1999-2008 Intel Corporation.
   14.031063 e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
   14.060723 Non-volatile memory driver v1.3
   14.147906 sdhci: Secure Digital Host Controller Interface driver
   14.147912 sdhci: Copyright(c) Pierre Ossman
   14.240284 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1)
00:1c:25:14:4a:e2
   14.240291 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
   14.240348 0000:00:19.0: eth0: MAC: 5, PHY: 6, PBA No: ffffff-0ff
   14.408242 lib80211: common routines for IEEE802.11 drivers
   14.441567 rtc_cmos 00:07: RTC can wake from S4
   14.442248 rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
   14.442363 rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
   14.452847 input: Power Button (FF) as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
   14.464943 ACPI: Power Button (FF) [PWRF]
   14.465443 input: Lid Switch as
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input3
   14.466494 ACPI: Lid Switch [LID]
   14.466979 input: Sleep Button (CM) as
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input4
   14.476772 ACPI: Sleep Button (CM) [SLPB]
   14.586914 sdhci-pci 0000:15:00.2: SDHCI controller found [1180:0822] (rev 21)
   14.586981 sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
   14.588447 sdhci-pci 0000:15:00.2: Will use DMA mode even though HW
doesn't fully claim to support it.
   14.590234 Registered led device: mmc0
   14.591808 mmc0: SDHCI controller on PCI [0000:15:00.2] using DMA
   15.063742 Synaptics Touchpad, model: 1, fw: 6.2, id: 0x81a0b1,
caps: 0xa04793/0x300000
   15.063755 serio: Synaptics pass-through port at isa0060/serio1/input0
   15.123717 input: SynPS/2 Synaptics TouchPad as
/devices/platform/i8042/serio1/input/input5
   15.221704 thinkpad_acpi: ThinkPad ACPI Extras v0.22
   15.221709 thinkpad_acpi: http://ibm-acpi.sf.net/
   15.221715 thinkpad_acpi: ThinkPad BIOS 7LETC4WW (2.24 ), EC 7KHT24WW-1.08
   15.221720 thinkpad_acpi: Lenovo ThinkPad T61, model 6464CTO
   15.228965 thinkpad_acpi: ACPI backlight control delay disabled
   15.233613 thinkpad_acpi: radio switch found; radios are enabled
   15.234406 thinkpad_acpi: This ThinkPad has standard ACPI backlight
brightness control, supported by the ACPI video driver
   15.234414 thinkpad_acpi: Disabling thinkpad-acpi brightness events
by default...
   15.258932 Registered led device: tpacpi::thinklight
   15.259269 Registered led device: tpacpi::power
   15.259425 Registered led device: tpacpi:orange:batt
   15.259582 Registered led device: tpacpi:green:batt
   15.259737 Registered led device: tpacpi::dock_active
   15.259891 Registered led device: tpacpi::bay_active
   15.260042 Registered led device: tpacpi::dock_batt
   15.260194 Registered led device: tpacpi::unknown_led
   15.260349 Registered led device: tpacpi::standby
   15.264721 thinkpad_acpi: Standard ACPI backlight interface not
available, thinkpad_acpi native brightness control enabled
   15.264737 thinkpad_acpi: detected a 16-level brightness capable ThinkPad
   15.268237 input: ThinkPad Extra Buttons as /devices/virtual/input/input6
   15.658394 Bluetooth: Core ver 2.14
   15.658808 NET: Registered protocol family 31
   15.658814 Bluetooth: HCI device and connection manager initialized
   15.659012 Bluetooth: HCI socket layer initialized
   16.405044 Bluetooth: Generic Bluetooth USB driver ver 0.4
   16.406385 usbcore: registered new interface driver btusb
   16.720580 iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network
Connection driver for Linux, 1.2.26ks
   16.720588 iwl3945: Copyright(c) 2003-2008 Intel Corporation
   16.721167 iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
   16.783300 iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
   16.783307 iwl3945: Detected Intel Wireless WiFi Link 3945ABG
   16.787079 iwl3945 0000:03:00.0: PCI INT A disabled
   16.789665 wmaster0 (iwl3945): not using net_device_ops yet
   17.512247 HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
   17.512260 hda_intel: probe_mask set to 0x1 for device 17aa:20ac
   18.429236 wlan0 (iwl3945): not using net_device_ops yet
   20.905133 IBM TrackPoint firmware: 0x0e, buttons: 3/3
   21.142819 input: TPPS/2 IBM TrackPoint as
/devices/platform/i8042/serio1/serio2/input/input7
   21.812330 [drm] Initialized drm 1.1.0 20060810
   22.609881 pci 0000:00:02.0: power state changed by ACPI to D0
   22.609912 pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
   22.615952 [drm] Initialized i915 1.6.0 20080730 on minor 0
   24.091348 device-mapper: uevent: version 1.0.3
   24.092732 device-mapper: ioctl: 4.14.0-ioctl (2008-04-23)
initialised: dm-devel@redhat.com
   25.403978 loop: module loaded
   26.936254 EXT3 FS on sda2, internal journal
   27.132499 kjournald starting.  Commit interval 5 seconds
   27.132913 EXT3 FS on sda1, internal journal
   27.133147 EXT3-fs: mounted filesystem with ordered data mode.
   27.151724 kjournald starting.  Commit interval 5 seconds
   27.152295 EXT3 FS on sda7, internal journal
   27.152527 EXT3-fs: mounted filesystem with ordered data mode.
   27.184073 kjournald starting.  Commit interval 5 seconds
   27.184569 EXT3 FS on sda6, internal journal
   27.184804 EXT3-fs: mounted filesystem with ordered data mode.
   27.218271 kjournald starting.  Commit interval 5 seconds
   27.218782 EXT3 FS on sda9, internal journal
   27.219013 EXT3-fs: mounted filesystem with ordered data mode.
   28.976958 platform microcode: firmware: requesting intel-ucode/06-0f-0a
   29.010817 platform microcode: firmware: requesting intel-ucode/06-0f-0a
   29.035824 Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
   29.112956 Microcode Update Driver: v2.00 removed.
   29.549115 NET: Registered protocol family 10
   33.209714 RPC: Registered udp transport module.
   33.209836 RPC: Registered tcp transport module.
   37.851507 Bluetooth: L2CAP ver 2.11
   37.851619 Bluetooth: L2CAP socket layer initialized
   38.338436 Bluetooth: SCO (Voice Link) ver 0.6
   38.338559 Bluetooth: SCO socket layer initialized
   38.630538 Bluetooth: RFCOMM socket layer initialized
   38.630699 Bluetooth: RFCOMM TTY layer initialized
   38.630811 Bluetooth: RFCOMM ver 1.10
   42.816898 Bridge firewalling registered
   42.913311 virbr0: starting userspace STP failed, starting kernel STP
   43.494058 ip_tables: (C) 2000-2006 Netfilter Core Team
   44.011577 nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
   44.012470 CONFIG_NF_CT_ACCT is deprecated and will be removed soon.
Please use
   44.012603 nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack
module option or
   44.012689 sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
   52.169076 ADDRCONF(NETDEV_UP): eth0: link is not ready
   52.172697 iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
   52.173845 iwl3945 0000:03:00.0: firmware: requesting iwlwifi-3945-2.ucode
   52.389138 iwl3945 loaded firmware version 15.28.2.8
   52.452007 ADDRCONF(NETDEV_UP): wlan0: link is not ready
   53.855891 ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
   61.759069 mtrr: type mismatch for e0000000,10000000 old: write-back
new: write-combining
   74.301936 fuse init (API version 7.11)
  155.801785 tun: Universal TUN/TAP device driver, 1.6
  155.801789 tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
  160.746489 gnome-keyring-d[3135] trap int3 ip:7f11ebee6bb6
sp:7f11e5f647e0 error:0
 7325.912917 UDF-fs: No VRS found
17611.748220 mtrr: type mismatch for e0000000,10000000 old: write-back
new: write-combining
19799.234816 CE: hpet increasing min_delta_ns to 15000 nsec
26987.532826 gnome-keyring-d[7317] trap int3 ip:7f437f8afbb6
sp:7f437992d7e0 error:0
49511.342726 usb 3-1: USB disconnect, address 2
49511.344024 btusb_intr_complete: hci0 urb ffff88012b2f5840 failed to
resubmit (19)
49511.345063 btusb_send_frame: hci0 urb ffff88011bec7cc0 submission failed
49511.748411 iwl3945 0000:03:00.0: PCI INT A disabled
49512.946437 PM: Syncing filesystems ... done.
49512.991596 Freezing user space processes ... (elapsed 0.00 seconds) done.
49512.994154 Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
49513.011919 pci 0000:00:02.0: power state changed by ACPI to D3
49514.259364 sd 0:0:0:0: [sda] Synchronizing SCSI cache
49514.260829 sd 0:0:0:0: [sda] Stopping disk
49516.306690 sdhci-pci 0000:15:00.2: PME# disabled
49516.306821 sdhci-pci 0000:15:00.2: PCI INT C disabled
49516.318601 pci 0000:15:00.0: PCI INT A disabled
49516.331852 ------------[ cut here ]------------
49516.331952 WARNING: at drivers/pci/pci-driver.c:368
pci_legacy_suspend+0xdd/0xf0()
49516.332080 Hardware name: 6464CTO
49516.332169 Modules linked in: udf crc_itu_t tun fuse ipt_MASQUERADE
iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables
bridge stp llc rfcomm sco l2cap autofs4 sunrpc ipv6 binfmt_misc loop
dm_mirror dm_region_hash dm_log dm_mod kvm_intel kvm i915 drm
i2c_algo_bit uinput arc4 ecb cryptomgr aead snd_hda_codec_analog
crypto_blkcipher snd_hda_intel snd_hda_codec snd_seq_oss
snd_seq_midi_event snd_seq crypto_hash snd_seq_device crypto_algapi
iwl3945 btusb snd_pcm_oss mac80211 bluetooth snd_mixer_oss snd_pcm
thinkpad_acpi rfkill snd_timer evdev sdhci_pci snd backlight button
rtc_cmos lib80211 psmouse sdhci soundcore nvram e1000e rtc_core
cfg80211 snd_page_alloc iTCO_wdt iTCO_vendor_support mmc_core
led_class sr_mod cdrom intel_agp battery ac rtc_lib i2c_i801 i2c_core
serio_raw uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded:
microcode]
49516.338181 Pid: 9898, comm: pm-suspend Not tainted 2.6.29-rc3 #27
49516.338279 Call Trace:
49516.338368  [<ffffffff802472ef>] warn_slowpath+0xaf/0x110
49516.338486  [<ffffffff80253382>] ? del_timer_sync+0x22/0x30
49516.338593  [<ffffffff805532ab>] ? schedule_timeout+0x6b/0xd0
49516.338692  [<ffffffff80252e20>] ? process_timeout+0x0/0x10
49516.338790  [<ffffffff8055329e>] ? schedule_timeout+0x5e/0xd0
49516.338888  [<ffffffff8055332e>] ? schedule_timeout_uninterruptible+0x1e/0x20
49516.339016  [<ffffffff803c2f9e>] ? pci_raw_set_power_state+0x15e/0x240
49516.339119  [<ffffffff803c3127>] ? pci_set_power_state+0xa7/0x180
49516.339255  [<ffffffff803c613d>] pci_legacy_suspend+0xdd/0xf0
49516.339357  [<ffffffff803c62f5>] pci_pm_suspend+0xa5/0xb0
49516.339455  [<ffffffff804533d2>] pm_op+0x162/0x1b0
49516.339549  [<ffffffff80453cdf>] device_suspend+0x47f/0x630
49516.339652  [<ffffffff80282007>] suspend_devices_and_enter+0x47/0x1c0
49516.339753  [<ffffffff80282316>] enter_state+0x166/0x1e0
49516.339850  [<ffffffff8028244a>] state_store+0xba/0x100
49516.339952  [<ffffffff803b0287>] kobj_attr_store+0x17/0x20
49516.340049  [<ffffffff8034130f>] sysfs_write_file+0xcf/0x140
49516.340148  [<ffffffff802e4cab>] vfs_write+0xcb/0x190
49516.340245  [<ffffffff802e4e75>] sys_write+0x55/0x90
49516.340342  [<ffffffff8020c70b>] system_call_fastpath+0x16/0x1b
49516.340442 ---[ end trace 41c78ad45a695649 ]---
49516.378957 ata_piix 0000:00:1f.1: PCI INT C disabled
49516.379583 ehci_hcd 0000:00:1d.7: PCI INT D disabled
49516.379800 ehci_hcd 0000:00:1d.7: PME# disabled
49516.394971 ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
49516.395410 uhci_hcd 0000:00:1d.2: PCI INT C disabled
49516.395987 uhci_hcd 0000:00:1d.1: PCI INT B disabled
49516.396542 uhci_hcd 0000:00:1d.0: PCI INT A disabled
49516.408808 HDA Intel 0000:00:1b.0: PCI INT B disabled
49516.421927 ehci_hcd 0000:00:1a.7: PCI INT C disabled
49516.422126 ehci_hcd 0000:00:1a.7: PME# disabled
49516.436967 ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
49516.438571 uhci_hcd 0000:00:1a.1: PCI INT B disabled
49516.439137 uhci_hcd 0000:00:1a.0: PCI INT A disabled
49516.439928 e1000e 0000:00:19.0: PME# enabled
49516.440027 e1000e 0000:00:19.0: wake-up capability enabled by ACPI
49516.440133 e1000e 0000:00:19.0: PME# enabled
49516.440230 e1000e 0000:00:19.0: wake-up capability enabled by ACPI
49516.442704 e1000e 0000:00:19.0: PCI INT A disabled
49516.468664 pci 0000:00:02.0: power state changed by ACPI to D3
49516.481180 ACPI: Preparing to enter system sleep state S3
49516.497734 Disabling non-boot CPUs ...
49516.498932 Broke affinity for irq 9
49516.498973 Broke affinity for irq 17
49516.499032 Broke affinity for irq 29
49516.500119 kvm: disabling virtualization on CPU1
49516.500149 CPU 1 is now offline
49516.500672 lockdep: fixing up alternatives.
49516.500769 SMP alternatives: switching to UP code
49516.589184 CPU1 is down
49516.591729 Extended CMOS year: 2000
49516.591729 x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
49516.591729 Extended CMOS year: 2000
49516.614529 Enabling non-boot CPUs ...
49516.614997 lockdep: fixing up alternatives.
49516.615098 SMP alternatives: switching to SMP code
49516.704693 Booting processor 1 APIC 0x1 ip 0x6000
49516.582851 Initializing CPU#1
49516.582851 Calibrating delay using timer specific routine.. 4391.59
BogoMIPS (lpj=7316156)
49516.582851 CPU: L1 I cache: 32K, L1 D cache: 32K
49516.582851 CPU: L2 cache: 4096K
49516.582851 [ds] using core 2 configuration
49516.582851 CPU: Physical Processor ID: 0
49516.582851 CPU: Processor Core ID: 1
49516.582851 CPU1: Thermal monitoring enabled (TM2)
49516.582851 x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
49516.799875 CPU1: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0a
49516.800754 kvm: enabling virtualization on CPU1
49516.815924 CPU1 is up
49516.815995 ACPI: Waking up from system sleep state S3
49516.844332 ACPI: \_SB_.GDCK - docking
49516.884937 acpi IBM0079:00: parent device:00 should not be sleeping
49516.895674 ACPI: EC: non-query interrupt received, switching to interrupt mode
49516.945831 pci 0000:00:02.0: PME# disabled
49516.946020 pci 0000:00:02.1: PME# disabled
49516.946315 e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
49516.946481 e1000e 0000:00:19.0: wake-up capability disabled by ACPI
49516.946561 e1000e 0000:00:19.0: PME# disabled
49516.946633 e1000e 0000:00:19.0: wake-up capability disabled by ACPI
49516.946717 e1000e 0000:00:19.0: PME# disabled
49517.224188 uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
49517.224595 usb usb3: root hub lost power or was reset
49517.228710 uhci_hcd 0000:00:1a.1: power state changed by ACPI to D0
49517.228790 uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
49517.229204 usb usb4: root hub lost power or was reset
49517.229449 ehci_hcd 0000:00:1a.7: PME# disabled
49517.230315 ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
49517.230394 ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
49517.230563 ehci_hcd 0000:00:1a.7: PME# disabled
49517.230730 HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
49517.232494 uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
49517.232578 uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
49517.233015 usb usb5: root hub lost power or was reset
49517.233246 uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
49517.233664 usb usb6: root hub lost power or was reset
49517.234708 uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
49517.234784 uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
49517.235209 usb usb7: root hub lost power or was reset
49517.235475 ehci_hcd 0000:00:1d.7: PME# disabled
49517.236120 ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
49517.236194 ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
49517.236371 ehci_hcd 0000:00:1d.7: PME# disabled
49517.236920 ata_piix 0000:00:1f.1: PCI INT C -> GSI 16 (level, low) -> IRQ 16
49517.239562 pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
49517.240159 sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
49517.240239 sdhci-pci 0000:15:00.2: Will use DMA mode even though HW
doesn't fully claim to support it.
49517.241719 pci 0000:15:00.3: PME# disabled
49517.272415 pci 0000:15:00.4: PME# disabled
49517.272579 pci 0000:15:00.5: PME# disabled
49517.274234 sd 0:0:0:0: [sda] Starting disk
49517.452438 ata4.00: ACPI cmd ef/03:42:00:00:00:a0 filtered out
49517.452508 ata4.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
49517.472075 ata4.00: configured for UDMA/33
49517.561825 ata3: SATA link down (SStatus 0 SControl 300)
49520.068473 ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
49520.078136 ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
49520.078495 ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
49520.082522 ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
49520.082868 ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
49520.084582 ata1.00: configured for UDMA/100
49520.098850 ata1.00: configured for UDMA/100
49520.098934 ata1: EH complete
49520.111921 sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors:
(100 GB/93.1 GiB)
49520.112036 sd 0:0:0:0: [sda] Write Protect is off
49520.112212 sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
49520.112337 sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors:
(100 GB/93.1 GiB)
49520.112439 sd 0:0:0:0: [sda] Write Protect is off
49520.112620 sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
49520.738483 usb 3-2: reset full speed USB device using uhci_hcd and address 3
49520.884872 thinkpad_acpi: ACPI backlight control delay disabled
49520.887896 pci 0000:00:02.0: power state changed by ACPI to D0
49520.888051 pci 0000:00:02.0: power state changed by ACPI to D0
49520.893148 Restarting tasks ... <7>PM: Adding info for No Bus:vcs63
49520.929770 done.
49521.035160 usb 1-4: new high speed USB device using ehci_hcd and address 4
49521.158832 usb 1-4: New USB device found, idVendor=04b3, idProduct=4485
49521.158902 usb 1-4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
49521.159308 usb 1-4: configuration #1 chosen from 1 choice
49521.160082 hub 1-4:1.0: USB hub found
49521.160329 hub 1-4:1.0: 4 ports detected
49521.449583 usb 1-4.4: new low speed USB device using ehci_hcd and address 5
49521.550425 usb 1-4.4: New USB device found, idVendor=046d, idProduct=c016
49521.550429 usb 1-4.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
49521.550431 usb 1-4.4: Product: Optical USB Mouse
49521.550433 usb 1-4.4: Manufacturer: Logitech
49521.550573 usb 1-4.4: configuration #1 chosen from 1 choice
49521.650717 usbcore: registered new interface driver hiddev
49521.652584 input: Logitech Optical USB Mouse as
/devices/pci0000:00/0000:00:1a.7/usb1/1-4/1-4.4/1-4.4:1.0/input/input8
49521.678525 generic-usb 0003:046D:C016.0001: input: USB HID v1.10
Mouse [Logitech Optical USB Mouse] on usb-0000:00:1a.7-4.4/input0
49521.678559 usbcore: registered new interface driver usbhid
49521.678564 usbhid: v2.6:USB HID core driver
49521.939996 ADDRCONF(NETDEV_UP): eth0: link is not ready
49521.941631 iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
49522.010151 ADDRCONF(NETDEV_UP): wlan0: link is not ready
49522.571792 usb 3-1: new full speed USB device using uhci_hcd and address 4
49522.740422 usb 3-1: New USB device found, idVendor=0a5c, idProduct=2110
49522.740427 usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
49522.740430 usb 3-1: Product: BCM2045B
49522.740432 usb 3-1: Manufacturer: Broadcom Corp
49522.740856 usb 3-1: configuration #1 chosen from 1 choice
49524.840771 e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow
Control: None
49524.841223 ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
53169.721399 CE: hpet increasing min_delta_ns to 22500 nsec
57370.468453 mtrr: type mismatch for e0000000,10000000 old: write-back
new: write-combining
66372.901603 BUG: unable to handle kernel paging request at 0000000000002328
66372.901609 IP: [<ffffffff802f8248>] __d_lookup+0xc8/0x1d0
66372.901617 PGD bd7df067 PUD bd7c5067 PMD 0
66372.901622 Oops: 0000 [#1] SMP
66372.901625 last sysfs file:
/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
66372.901629 CPU 0
66372.901631 Modules linked in: usbhid hid udf crc_itu_t tun fuse
ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables
x_tables bridge stp llc rfcomm sco l2cap autofs4 sunrpc ipv6
binfmt_misc loop dm_mirror dm_region_hash dm_log dm_mod kvm_intel kvm
i915 drm i2c_algo_bit uinput arc4 ecb cryptomgr aead
snd_hda_codec_analog crypto_blkcipher snd_hda_intel snd_hda_codec
snd_seq_oss snd_seq_midi_event snd_seq crypto_hash snd_seq_device
crypto_algapi iwl3945 btusb snd_pcm_oss mac80211 bluetooth
snd_mixer_oss snd_pcm thinkpad_acpi rfkill snd_timer evdev sdhci_pci
snd backlight button rtc_cmos lib80211 psmouse sdhci soundcore nvram
e1000e rtc_core cfg80211 snd_page_alloc iTCO_wdt iTCO_vendor_support
mmc_core led_class sr_mod cdrom intel_agp battery ac rtc_lib i2c_i801
i2c_core serio_raw uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded:
microcode]
66372.901720 Pid: 14207, comm: sh Tainted: G        W  2.6.29-rc3 #27
66372.901722 RIP: 0010:[<ffffffff802f8248>]  [<ffffffff802f8248>]
__d_lookup+0xc8/0x1d0
66372.901726 RSP: 0000:ffff8800bd6ebc88  EFLAGS: 00010206
66372.901728 RAX: 0000000000002328 RBX: 0000000000002328 RCX: 0000000000000013
66372.901730 RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff806ffd40
66372.901732 RBP: ffff8800bd6ebce8 R08: 0000000000000001 R09: 0000000000000000
66372.901735 R10: 00000000085a6ed9 R11: ffff88013b404300 R12: ffff8800028b0000
66372.901737 R13: 018721e0036d5fe5 R14: 0000000000000005 R15: ffff8800bd6ebd78
66372.901739 FS:  00007f420a5876f0(0000) GS:ffffffff80990040(0000)
knlGS:0000000000000000
66372.901742 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
66372.901744 CR2: 0000000000002328 CR3: 00000000be2df000 CR4: 00000000000026e0
66372.901746 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
66372.901748 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
66372.901751 Process sh (pid: 14207, threadinfo ffff8800bd6ea000, task
ffff880108642260)
66372.901753 Stack:
66372.901754  ffffffff802f8180 0000000000000046 ffff88013b404300
ffff8801085a6ed9
66372.901759  000000053b2fdf80 ffff8800bd6ebd88 ffff8800307a11c0
0000000000001d4e
66372.901764  ffff8800bd6ebd78 ffff88013b404300 ffff8800bd591780
0000000000000000
66372.901770 Call Trace:
66372.901772  [<ffffffff802f8180>] ? __d_lookup+0x0/0x1d0
66372.901776  [<ffffffff802f8393>] d_lookup+0x43/0x60
66372.901780  [<ffffffff802f8429>] d_hash_and_lookup+0x79/0xa0
66372.901783  [<ffffffff80336755>] proc_flush_task+0xc5/0x2c0
66372.901788  [<ffffffff80249d10>] release_task+0x40/0x460
66372.901793  [<ffffffff8024a7aa>] wait_consider_task+0x67a/0xa90
66372.901796  [<ffffffff8024ad3e>] do_wait+0x17e/0x3c0
66372.901800  [<ffffffff8023eaa0>] ? default_wake_function+0x0/0x20
66372.901804  [<ffffffff8024b016>] sys_wait4+0x96/0xf0
66372.901808  [<ffffffff8020c70b>] system_call_fastpath+0x16/0x1b
66372.901812 Code: 75 c4 4c 31 eb 44 8b 55 b8 41 21 dc 4c 8b 5d b0 4e
8d 24 e0 49 8b 04 24 48 89 c3 48 85 c0 75 0b eb 69 90 48 8b 1b 48 85
db 74 60 <48> 8b 03 4c 8d 63 a8 0f 18 08 45 39 54 24 70 75 e7 4d 39 5c
24
66372.901863 RIP  [<ffffffff802f8248>] __d_lookup+0xc8/0x1d0
66372.901867  RSP <ffff8800bd6ebc88>
66372.901869 CR2: 0000000000002328
66372.901872 ---[ end trace 41c78ad45a69564a ]---
66516.636219 SysRq : Emergency Sync
66516.706821 Emergency Sync complete
66518.389155 SysRq : Emergency Remount R/O


.config

CONFIG_64BIT=y
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
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
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
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y

CONFIG_CLASSIC_RCU=y
CONFIG_IKCONFIG=m
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=18
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_SYSCTL=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
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
CONFIG_SLUB=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_MARKERS=y
CONFIG_OPROFILE=m
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLOCK_COMPAT=y

CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_CFQ=y
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_FREEZER=y

CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_PC=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_MEMTEST=y
CONFIG_MCORE2=y
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
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=4
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_VOLUNTARY=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y

CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_UNEVICTABLE_LRU=y
CONFIG_MMU_NOTIFIER=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_EFI=y
CONFIG_HZ_300=y
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_PHYSICAL_START=0x200000
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_CMDLINE_BOOL=y
CONFIG_CMDLINE=""
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_VERBOSE=y
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
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
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_PCI_SLOT=m
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=m

CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=y

CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_X86_P4_CLOCKMOD=m

CONFIG_X86_ACPI_CPUFREQ_PROC_INTF=y
CONFIG_X86_SPEEDSTEP_LIB=m
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y


CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=m
CONFIG_PCIEAER=y
CONFIG_PCIEASPM=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
CONFIG_PCCARD=m
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_PCMCIA_IOCTL=y
CONFIG_CARDBUS=y

CONFIG_HOTPLUG_PCI=m
CONFIG_HOTPLUG_PCI_ACPI=m
CONFIG_HOTPLUG_PCI_ACPI_IBM=m

CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_MISC=m
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=m
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y

CONFIG_COMPAT_NET_DEV_OPS=y
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_FIB_HASH=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_MROUTE=y
CONFIG_SYN_COOKIES=y
CONFIG_INET_TUNNEL=m
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_DEFAULT_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_IPV6=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NETFILTER_XTABLES=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_STATE=m

CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
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
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_NF_NAT_FTP=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
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
CONFIG_IP_SCTP=m
CONFIG_SCTP_HMAC_NONE=y
CONFIG_STP=m
CONFIG_BRIDGE=m
CONFIG_LLC=m

CONFIG_NET_PKTGEN=m
CONFIG_IRDA=m






CONFIG_BT=m
CONFIG_BT_L2CAP=m
CONFIG_BT_SCO=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_HIDP=m

CONFIG_BT_HCIBTUSB=m
CONFIG_WIRELESS=y
CONFIG_CFG80211=m
CONFIG_NL80211=y
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_LIB80211=m
CONFIG_MAC80211=m

CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"
CONFIG_MAC80211_LEDS=y
CONFIG_RFKILL=m
CONFIG_RFKILL_INPUT=m
CONFIG_RFKILL_LEDS=y


CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_CONNECTOR=m
CONFIG_MTD=m
CONFIG_MTD_DEBUG=y
CONFIG_MTD_DEBUG_VERBOSE=1
CONFIG_MTD_CONCAT=m
CONFIG_MTD_PARTITIONS=y
CONFIG_MTD_TESTS=m
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1

CONFIG_MTD_CHAR=m
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m

CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y


CONFIG_MTD_MTDRAM=m
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTD_BLOCK2MTD=m



CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=m
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=8192
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_VIRTIO_BLK=m
CONFIG_MISC_DEVICES=y

CONFIG_HAVE_IDE=y

CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y

CONFIG_BLK_DEV_SD=y
CONFIG_BLK_DEV_SR=m
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=m

CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

CONFIG_SCSI_SPI_ATTRS=y
CONFIG_ATA=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_AHCI=y
CONFIG_ATA_SFF=y
CONFIG_ATA_PIIX=y
CONFIG_PATA_ACPI=m
CONFIG_ATA_GENERIC=y
CONFIG_PATA_HPT366=y
CONFIG_PATA_MPIIX=y
CONFIG_PATA_OLDPIIX=y
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID456=m
CONFIG_MD_RAID5_RESHAPE=y
CONFIG_MD_FAULTY=m
CONFIG_BLK_DEV_DM=m
CONFIG_DM_DEBUG=y
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_DELAY=m
CONFIG_DM_UEVENT=y
CONFIG_DM_REPLOG=m
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y


CONFIG_NETDEVICES=y
CONFIG_DUMMY=m
CONFIG_TUN=m
CONFIG_VETH=m
CONFIG_NET_ETHERNET=y
CONFIG_MII=m
CONFIG_NET_PCI=y
CONFIG_PCNET32=m
CONFIG_8139CP=m
CONFIG_NETDEV_1000=y
CONFIG_E1000E=m

CONFIG_WLAN_80211=y
CONFIG_IWLWIFI=m
CONFIG_IWLCORE=m
CONFIG_IWL3945=m
CONFIG_IWL3945_RFKILL=y
CONFIG_IWL3945_SPECTRUM_MEASUREMENT=y


CONFIG_USB_HSO=m
CONFIG_NETCONSOLE=m
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_VIRTIO_NET=m

CONFIG_INPUT=y
CONFIG_INPUT_POLLDEV=y

CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_EVDEV=m

CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_SERIAL=m
CONFIG_INPUT_MISC=y
CONFIG_INPUT_UINPUT=m

CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m

CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_DEVKMEM=y

CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=16
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_RSA=y

CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_UNIX98_PTYS=y
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=m
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_VIRTIO=m
CONFIG_NVRAM=m

CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=m
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=m


CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
CONFIG_I2C_PIIX4=m


CONFIG_I2C_TINY_USB=m



CONFIG_I2C_DEBUG_CORE=y
CONFIG_I2C_DEBUG_ALGO=y
CONFIG_I2C_DEBUG_BUS=y
CONFIG_I2C_DEBUG_CHIP=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_POWER_SUPPLY=y
CONFIG_HWMON=y
CONFIG_SENSORS_HDAPS=y
CONFIG_THERMAL=y
CONFIG_WATCHDOG=y

CONFIG_SOFT_WATCHDOG=m
CONFIG_ITCO_WDT=m
CONFIG_ITCO_VENDOR_SUPPORT=y


CONFIG_SSB_POSSIBLE=y


CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m


CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_DVB_CORE=m
CONFIG_VIDEO_MEDIA=m

CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_CUSTOMIZE=y
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L1=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEO_IR=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_IR_I2C=m
CONFIG_VIDEO_VIVI=m
CONFIG_VIDEO_SAA7134=m
CONFIG_VIDEO_SAA7134_ALSA=m
CONFIG_V4L_USB_DRIVERS=y
CONFIG_RADIO_ADAPTERS=y
CONFIG_DVB_DYNAMIC_MINORS=y
CONFIG_DVB_CAPTURE_DRIVERS=y


CONFIG_DVB_USB=m
CONFIG_DVB_USB_DEBUG=y
CONFIG_DVB_USB_AF9015=m






CONFIG_DVB_FE_CUSTOMISE=y


CONFIG_DVB_TDA8261=m
CONFIG_DVB_SI21XX=m





CONFIG_DVB_PLL=m


CONFIG_DVB_DUMMY_FE=m
CONFIG_DVB_AF9013=m

CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=m
CONFIG_DRM=m
CONFIG_DRM_I915=m
CONFIG_DRM_MGA=m
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=m
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
CONFIG_FB_INTEL=m
CONFIG_FB_INTEL_I2C=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=m
CONFIG_BACKLIGHT_GENERIC=m

CONFIG_DISPLAY_SUPPORT=m


CONFIG_VGA_CONSOLE=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VMASTER=y
CONFIG_SND_MPU401_UART=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_DUMMY=m
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=500
CONFIG_SND_PCI=y
CONFIG_SND_EMU10K1=m
CONFIG_SND_ENS1370=m
CONFIG_SND_ENS1371=m
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_ATIHDMI=y
CONFIG_SND_HDA_CODEC_INTELHDMI=y
CONFIG_SND_HDA_ELD=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=500
CONFIG_SND_INTEL8X0=m
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=m

CONFIG_USB_HID=m
CONFIG_USB_HIDDEV=y

CONFIG_HID_A4TECH=m
CONFIG_HID_APPLE=m
CONFIG_HID_BELKIN=m
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
CONFIG_HID_CYPRESS=m
CONFIG_HID_EZKEY=m
CONFIG_HID_GYRATION=m
CONFIG_HID_LOGITECH=m
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_NTRIG=m
CONFIG_HID_PANTHERLORD=m
CONFIG_HID_PETALYNX=m
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_TOPSEED=m
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=m
CONFIG_USB_DEBUG=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
CONFIG_USB_SUSPEND=y
CONFIG_USB_MON=m

CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_OHCI_HCD=m
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=m


CONFIG_USB_PRINTER=m
CONFIG_USB_TMC=m


CONFIG_USB_STORAGE=m



CONFIG_USB_TEST=m

CONFIG_MMC=m

CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_BOUNCE=y

CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_SDRICOH_CS=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m


CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m

CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y



CONFIG_RTC_DRV_CMOS=m

CONFIG_DMADEVICES=y

CONFIG_INTEL_IOATDMA=m
CONFIG_DMA_ENGINE=y

CONFIG_NET_DMA=y
CONFIG_DCA=m
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_THINKPAD_ACPI=m
CONFIG_THINKPAD_ACPI_DEBUGFACILITIES=y
CONFIG_THINKPAD_ACPI_DEBUG=y
CONFIG_THINKPAD_ACPI_BAY=y
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_ACPI_TOSHIBA=m

CONFIG_EDD=m
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_EFI_VARS=m
CONFIG_DMIID=y

CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=m
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_JBD=y
CONFIG_JBD2=m
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=m
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_BTRFS_FS=m
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS_FS=m
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
CONFIG_GENERIC_ACL=y

CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

CONFIG_FAT_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="utf8"
CONFIG_NTFS_FS=m
CONFIG_NTFS_RW=y

CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
CONFIG_JFFS2_FS=m
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
CONFIG_JFFS2_LZO=y
CONFIG_JFFS2_RTIME=y
CONFIG_JFFS2_RUBIN=y
CONFIG_JFFS2_CMODE_PRIORITY=y
CONFIG_SQUASHFS=m
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
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
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_SMB_FS=m
CONFIG_SMB_NLS_DEFAULT=y
CONFIG_SMB_NLS_REMOTE="cp437"
CONFIG_CIFS=m
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_EXPERIMENTAL=y

CONFIG_PARTITION_ADVANCED=y
CONFIG_AMIGA_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_LDM_PARTITION=y
CONFIG_LDM_DEBUG=y
CONFIG_EFI_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_UTF8=m

CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_LATENCYTOP=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_HW_BRANCH_TRACER=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_TRACING=y

CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_SYSPROF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_BOOT_TRACER=y
CONFIG_POWER_TRACER=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_DYNAMIC_PRINTK_DEBUG=y
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
CONFIG_MMIOTRACE=y
CONFIG_MMIOTRACE_TEST=m
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y

CONFIG_SECURITY=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_CRYPTO=y

CONFIG_CRYPTO_ALGAPI=m
CONFIG_CRYPTO_ALGAPI2=m
CONFIG_CRYPTO_AEAD2=m
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_BLKCIPHER2=m
CONFIG_CRYPTO_HASH=m
CONFIG_CRYPTO_HASH2=m
CONFIG_CRYPTO_RNG2=m
CONFIG_CRYPTO_MANAGER=m
CONFIG_CRYPTO_MANAGER2=m


CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_ECB=m

CONFIG_CRYPTO_HMAC=m

CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_MD5=m
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=m

CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_DES=m


CONFIG_CRYPTO_HW=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
CONFIG_KVM_AMD=m
CONFIG_KVM_TRACE=y
CONFIG_VIRTIO=m
CONFIG_VIRTIO_RING=m
CONFIG_VIRTIO_PCI=m
CONFIG_VIRTIO_BALLOON=m

CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=m
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=m
CONFIG_LZO_DECOMPRESS=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
