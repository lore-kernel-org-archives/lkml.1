Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbYHZTnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbYHZTnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbYHZTnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:43:43 -0400
Received: from anchor-post-30.mail.demon.net ([194.217.242.88]:4795 "EHLO
	anchor-post-30.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751346AbYHZTnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:43:40 -0400
X-Greylist: delayed 563 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Aug 2008 15:43:39 EDT
Date: Tue, 26 Aug 2008 20:31:08 +0100
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: linux-kernel@vger.kernel.org
Message-ID: <4FDA7ACAE0%linux@youmustbejoking.demon.co.uk>
Mail-Followup-To: linux-kernel@vger.kernel.org, linux@youmustbejoking.demon.co.uk
User-Agent: Gemini/2.29j (Qt/3.3.8b) (Linux-x86_64)
X-SDate: Tue, 5474 Sep 1993 20:31:08 +0100
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1734974150--1102215432--558902121"
X-SA-Exim-Connect-IP: 192.168.0.5
X-SA-Exim-Mail-From: linux@youmustbejoking.demon.co.uk
Subject: Oopses below shrink_slab
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on pentagram.youmustbejoking.demon.co.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message is in MIME format.

--1734974150--1102215432--558902121
Content-Type: text/plain; charset=us-ascii

I've had a few odd oopses recently, both while the computer was busy. The
first was with 2.6.25.9 (while loading resources for a game; uptime was a
little over 49 days), and the second was with 2.6.25.16 (in the middle of a
dpkg run; uptime was a day or so).

"Full" kernel log (less some likely-irrelevant USB & DVD stuff) & config
attached for .16.

(I'll switch to 2.6.26.current soonish, probably when I next *need* to
reboot.)


This one with 2.6.25.9:

-- BUG: unable to handle kernel NULL pointer dereference at 000000000000008e
IP: [<ffffffff80274b14>] dentry_iput+0x63/0x8b
PGD 3c7a1067 PUD a43e067 PMD 0 
Oops: 0000 [1] 
CPU 0 
Modules linked in: vfat fat usb_storage sd_mod mt2060 dvb_usb_dib0700 dib7000p dib7000m dvb_usb dib3000mc dibx000_common dib0070 radeon drm ip6t_LOG xt_tcpudp ip6t_REJECT nf_conntrack_ipv6 xt_state nf_conntrack ip6table_mangle ip6table_filter ip6_tables x_tables snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_emul dvb_pll cx22702 cx88_dvb videobuf_dvb dvb_core snd_emu10k1 snd_seq_midi snd_rawmidi snd_util_mem snd_hwdep cx8800 cx8802 cx88xx ir_common compat_ioctl32 tveeprom videodev v4l1_compat v4l2_common videobuf_dma_sg videobuf_core btcx_risc sata_nv libata dock snd_intel8x0 snd_ac97_codec ac97_bus
Pid: 237, comm: kswapd0 Not tainted 2.6.25.9 #1
RIP: 0010:[<ffffffff80274b14>]  [<ffffffff80274b14>] dentry_iput+0x63/0x8b
RSP: 0000:ffff81003fae3d30  EFLAGS: 00010206
RAX: 0000000000000066 RBX: ffff81002f7e3a80 RCX: ffff81002f7e3ae8
RDX: ffff810004432a48 RSI: ffff8100047ed808 RDI: ffff81002f7e3a80
RBP: ffff810004432a18 R08: 0000000000002b5e R09: ffff81003fae3d50
R10: 0000000000000080 R11: ffffffff80277610 R12: 0000000000000000
R13: 0000000000000049 R14: 00000000000000d0 R15: 0000000000035aad
FS:  00007fc28ffac6f0(0000) GS:ffffffff8063f000(0000) knlGS:00000000f74cb720
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 000000000000008e CR3: 000000001efda000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
Process kswapd0 (pid: 237, threadinfo ffff81003fae2000, task ffff81003fab4080)
Stack:  ffffe200006a9398 ffff81002f7e3a80 ffff81003f3b2870 ffffffff80274bc8
 ffff81003fae3d50 ffff81002f7e3a80 0000000000000000 ffffffff80274c9a
 ffff81002f7e3a80 ffffffff80274da7 ffff81003fae3d80 ffffffff806104a0
Call Trace:
 [<ffffffff80274bc8>] ? d_kill+0x34/0x55
 [<ffffffff80274c9a>] ? prune_one_dentry+0xb1/0xbf
 [<ffffffff80274da7>] ? prune_dcache+0xff/0x14e
 [<ffffffff80274e0d>] ? shrink_dcache_memory+0x17/0x35
 [<ffffffff802515ac>] ? shrink_slab+0xd6/0x13d
 [<ffffffff80251977>] ? kswapd+0x364/0x46f
 [<ffffffff802504a7>] ? isolate_pages_global+0x0/0x2f
 [<ffffffff80236780>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff80251613>] ? kswapd+0x0/0x46f
 [<ffffffff802363aa>] ? kthread+0x47/0x73
 [<ffffffff80224a60>] ? schedule_tail+0x18/0x4d
 [<ffffffff8020b828>] ? child_rip+0xa/0x12
 [<ffffffff80236363>] ? kthread+0x0/0x73
 [<ffffffff8020b81e>] ? child_rip+0x0/0x12

Code: 00 75 1c 48 89 ef 45 31 c0 31 c9 31 d2 be 00 04 00 00 e8 c4 56 01 00 48 89
 ef e8 0d 58 01 00 48 8b 83 80 00 00 00 48 85 c0 74 19 <48> 8b 40 28 48 85 c0 74
 10 41 58 48 89 df 48 89 ee 49 89 c3 5b 
RIP  [<ffffffff80274b14>] dentry_iput+0x63/0x8b
 RSP <ffff81003fae3d30>
CR2: 000000000000008e


This one with 2.6.25.16:

Bad page state in process 'kswapd0'
page:ffff8100279219ee flags:0x0000000000000000 mapping:0000000000000000 mapcount
:1 count:0
Trying to fix it up, but a reboot is needed
Backtrace:
Pid: 237, comm: kswapd0 Not tainted 2.6.25.16 #1

Call Trace:
 [<ffffffff8024f1ce>] remove_mapping+0x86/0x99
 [<ffffffff8024b0de>] bad_page+0x71/0x9b
 [<ffffffff8024b6b3>] free_hot_cold_page+0x6e/0x132
 [<ffffffff8024b7a0>] __pagevec_free+0x29/0x3b
 [<ffffffff8024dd68>] release_pages+0x124/0x131
 [<ffffffff8024e9fd>] isolate_lru_pages+0x7a/0x204
 [<ffffffff8024e08a>] __pagevec_release+0x19/0x22
 [<ffffffff8024e5a9>] __invalidate_mapping_pages+0xc3/0x106
 [<ffffffff8024cb35>] get_dirty_limits+0x1d/0x1a6
 [<ffffffff80274a74>] shrink_icache_memory+0xe8/0x1c7
 [<ffffffff8024fc12>] shrink_slab+0xd9/0x13f
 [<ffffffff80250229>] kswapd+0x30d/0x3ec
 [<ffffffff8024eb87>] isolate_pages_global+0x0/0x2f
 [<ffffffff80235b0f>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8024ff1c>] kswapd+0x0/0x3ec
 [<ffffffff80235937>] kthread+0x47/0x74
 [<ffffffff802232c9>] schedule_tail+0x18/0x4c
 [<ffffffff8020b758>] child_rip+0xa/0x12
 [<ffffffff802358f0>] kthread+0x0/0x74
 [<ffffffff8020b74e>] child_rip+0x0/0x12

BUG: unable to handle kernel paging request at 00000fff805298a8
IP: [<ffffffff8024ad0e>] get_pageblock_flags_group+0x31/0x8f
PGD 0 
Oops: 0000 [1] 
CPU 0 
Modules linked in: vfat fat usb_storage sd_mod radeon drm ip6t_LOG xt_tcpudp ip6t_REJECT nf_conntrack_ipv6 xt_state nf_conntrack ip6table_mangle ip6table_filter ip6_tables x_tables dvb_pll cx22702 cx88_dvb videobuf_dvb dvb_core snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_emul snd_emu10k1 snd_seq_midi snd_rawmidi snd_util_mem snd_hwdep cx8800 sata_nv cx8802 libata cx88xx ir_common tveeprom compat_ioctl32 videodev v4l1_compat v4l2_common videobuf_dma_sg videobuf_core btcx_risc dock snd_intel8x0 snd_ac97_codec ac97_bus
Pid: 237, comm: kswapd0 Tainted: G    B    2.6.25.16 #1
RIP: 0010:[<ffffffff8024ad0e>]  [<ffffffff8024ad0e>] get_pageblock_flags_group+0
x31/0x8f
RSP: 0018:ffff81003fb83b88  EFLAGS: 00010016
RAX: 000001fffffc8925 RBX: ffff8100279219ee RCX: ffffffff806064b8
RDX: fffffe4492fe099b RSI: 0000000000000000 RDI: 0001fffffc8925fc
RBP: ffffffff806064a8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000002 R11: 0000000000000000 R12: ffffffff80606470
R13: 0000000000000246 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f0116b74780(0000) GS:ffffffff80637000(0000) knlGS:00000000f74c0720
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000fff805298a8 CR3: 00000000279bb000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
Process kswapd0 (pid: 237, threadinfo ffff81003fb82000, task ffff81003fa50040)
Stack:  ffffffff8024b73e 0000000000000000 ffff81003fb83bf0 0000000000000001
 0000000000000001 ffff81003fb83cc0 ffffffff8024b7a0 ffffe20000072840
 ffff81003fb83cc0 ffff81003fb83cd8 0000000000000001 0000000000000001
Call Trace:
 [<ffffffff8024b73e>] ? free_hot_cold_page+0xf9/0x132
 [<ffffffff8024b7a0>] ? __pagevec_free+0x29/0x3b
 [<ffffffff8024dd68>] ? release_pages+0x124/0x131
 [<ffffffff8024e9fd>] ? isolate_lru_pages+0x7a/0x204
 [<ffffffff8024e08a>] ? __pagevec_release+0x19/0x22
 [<ffffffff8024e5a9>] ? __invalidate_mapping_pages+0xc3/0x106
 [<ffffffff8024cb35>] ? get_dirty_limits+0x1d/0x1a6
 [<ffffffff80274a74>] ? shrink_icache_memory+0xe8/0x1c7
 [<ffffffff8024fc12>] ? shrink_slab+0xd9/0x13f
 [<ffffffff80250229>] ? kswapd+0x30d/0x3ec
 [<ffffffff8024eb87>] ? isolate_pages_global+0x0/0x2f
 [<ffffffff80235b0f>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff8024ff1c>] ? kswapd+0x0/0x3ec
 [<ffffffff80235937>] ? kthread+0x47/0x74
 [<ffffffff802232c9>] ? schedule_tail+0x18/0x4c
 [<ffffffff8020b758>] ? child_rip+0xa/0x12
 [<ffffffff802358f0>] ? kthread+0x0/0x74
 [<ffffffff8020b74e>] ? child_rip+0x0/0x12

Code: 00 1e 00 00 41 89 d2 48 8d 14 07 48 b8 b7 6d db b6 6d db b6 6d 48 c1 fa 03
 48 0f af d0 48 89 d0 48 89 d7 48 c1 e8 17 48 c1 ef 0f <48> 8b 0c c5 80 4f 6e 80
 31 c0 48 85 c9 74 0c 48 0f b6 c7 48 c1 
RIP  [<ffffffff8024ad0e>] get_pageblock_flags_group+0x31/0x8f
 RSP <ffff81003fb83b88>
CR2: 00000fff805298a8

-- 
| Darren Salt    | linux or ds at              | nr. Ashington, | Toon
| RISC OS, Linux | youmustbejoking,demon,co,uk | Northumberland | Army
| + RIPA NOTICE: NO CONSENT GIVEN FOR INTERCEPTION OF MESSAGE TRANSMISSION

If you refuse to accept anything but the best you very often get it.

--1734974150--1102215432--558902121
Content-Type: text/x-log; name="crash.log"
Content-Disposition: attachment; filename="crash.log"
Content-Transfer-Encoding: quoted-printable

Linux version 2.6.25.16 (root@flibble) (gcc version 4.2.4 (Debian 4.2.4-3=
)) #1 Wed Aug 20 23:28:52 BST 2008=0A=
Command line: BOOT_IMAGE=3DLinux ro root=3D342 video=3Dradeonfb:noaccel l=
og_buf_len=3D64K netconsole=3D6665@192.168.0.5/eth0,666@192.168.0.1/00:00=
:0e:b8:7e:06=0A=
BIOS-provided physical RAM map:=0A=
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)=0A=
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)=0A=
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)=0A=
 BIOS-e820: 0000000000100000 - 000000003fee0000 (usable)=0A=
 BIOS-e820: 000000003fee0000 - 000000003fee3000 (ACPI NVS)=0A=
 BIOS-e820: 000000003fee3000 - 000000003fef0000 (ACPI data)=0A=
 BIOS-e820: 000000003fef0000 - 000000003ff00000 (reserved)=0A=
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)=0A=
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)=0A=
end_pfn_map =3D 1048576=0A=
DMI 2.2 present.=0A=
ACPI: RSDP 000F7810, 0014 (r0 Nvidia)=0A=
ACPI: RSDT 3FEE3040, 0034 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)=0A=
ACPI: FACP 3FEE30C0, 0074 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)=0A=
ACPI: DSDT 3FEE3180, 6786 (r1 NVIDIA AWRDACPI     1000 MSFT  100000E)=0A=
ACPI: FACS 3FEE0000, 0040=0A=
ACPI: SSDT 3FEE9A40, 00F7 (r1 PTLTD  POWERNOW        1  LTP        1)=0A=
ACPI: MCFG 3FEE9B80, 003C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)=0A=
ACPI: APIC 3FEE9980, 007C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)=0A=
early res: 0 [0-fff] BIOS data page=0A=
early res: 1 [200000-708187] TEXT DATA BSS=0A=
early res: 2 [9f800-a07ff] EBDA=0A=
early res: 3 [8000-afff] PGTABLE=0A=
Zone PFN ranges:=0A=
  DMA             0 ->     4096=0A=
  DMA32        4096 ->  1048576=0A=
  Normal    1048576 ->  1048576=0A=
Movable zone start PFN for each node=0A=
early_node_map[2] active PFN ranges=0A=
    0:        0 ->      159=0A=
    0:      256 ->   261856=0A=
Nvidia board detected. Ignoring ACPI timer override.=0A=
If you got timer trouble try acpi_use_timer_override=0A=
ACPI: PM-Timer IO Port: 0x1008=0A=
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)=0A=
Processor #0 (Bootup-CPU)=0A=
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)=0A=
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])=0A=
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])=0A=
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])=0A=
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23=0A=
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)=0A=
ACPI: BIOS IRQ0 pin2 override ignored.=0A=
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)=0A=
ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)=0A=
ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)=0A=
Setting APIC routing to flat=0A=
Using ACPI (MADT) for SMP configuration information=0A=
Allocating PCI resources starting at 40000000 (gap: 3ff00000:a0100000)=0A=
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2568=
84=0A=
Kernel command line: BOOT_IMAGE=3DLinux ro root=3D342 video=3Dradeonfb:no=
accel log_buf_len=3D64K netconsole=3D6665@192.168.0.5/eth0,666@192.168.0.=
1/00:00:0e:b8:7e:06=0A=
Initializing CPU#0=0A=
PID hash table entries: 4096 (order: 12, 32768 bytes)=0A=
TSC calibrated against PM_TIMER=0A=
time.c: Detected 2210.189 MHz processor.=0A=
Console: colour VGA+ 80x25=0A=
console [tty0] enabled=0A=
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)=0A=
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)=0A=
Checking aperture...=0A=
Node 0: aperture @ 4842000000 size 32 MB=0A=
Aperture beyond 4GB. Ignoring.=0A=
No AGP bridge found=0A=
Memory: 1024920k/1047424k available (2760k kernel code, 21408k reserved, =
1552k data, 204k init)=0A=
Calibrating delay using timer specific routine.. 4423.10 BogoMIPS (lpj=3D=
8846212)=0A=
Mount-cache hash table entries: 256=0A=
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)=0A=
CPU: L2 Cache: 512K (64 bytes/line)=0A=
CPU: AMD Athlon(tm) 64 Processor 3500+ stepping 02=0A=
ACPI: Core revision 20070126=0A=
Using local APIC timer interrupts.=0A=
Detected 12.557 MHz APIC timer.=0A=
net_namespace: 992 bytes=0A=
NET: Registered protocol family 16=0A=
ACPI: bus type pci registered=0A=
PCI: Using MMCONFIG at e0000000 - efffffff=0A=
PCI: Using configuration type 1=0A=
ACPI: Interpreter enabled=0A=
ACPI: (supports S0 S5)=0A=
ACPI: Using IOAPIC for interrupt routing=0A=
ACPI: PCI Root Bridge [PCI0] (0000:00)=0A=
PCI: Transparent bridge - 0000:00:09.0=0A=
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 *7 10 11)=0A=
ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 7 10 11) *0, disabled.=0A=
ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 *5 7 10 11)=0A=
ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 7 10 11) *0, disabled.=0A=
ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 7 10 11) *0, disabled.=0A=
ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 *7 10 11)=0A=
ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 7 10 11) *0, disabled.=0A=
ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 7 10 *11)=0A=
ACPI: PCI Interrupt Link [LACI] (IRQs *3 4 5 7 10 11)=0A=
ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 7 *10 11)=0A=
ACPI: PCI Interrupt Link [LSMB] (IRQs *3 4 5 7 10 11)=0A=
ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 *5 7 10 11)=0A=
ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 7 10 11) *0, disabled.=0A=
ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 7 10 *11)=0A=
ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 5 7 *10 11)=0A=
ACPI: PCI Interrupt Link [LPCA] (IRQs 3 4 5 7 10 11) *0, disabled.=0A=
ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0=0A=
ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.=0A=
ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0=0A=
ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.=0A=
ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.=0A=
ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0=0A=
ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabled.=0A=
ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0=0A=
ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0=0A=
ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0=0A=
ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0=0A=
ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0=0A=
ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.=0A=
ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0=0A=
ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0=0A=
ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.=0A=
ACPI: Power Resource [PFAN] (off)=0A=
Linux Plug and Play Support v0.97 (c) Adam Belay=0A=
pnp: PnP ACPI init=0A=
ACPI: bus type pnp registered=0A=
pnp: PnP ACPI: found 13 devices=0A=
ACPI: ACPI bus type pnp unregistered=0A=
SCSI subsystem initialized=0A=
usbcore: registered new interface driver usbfs=0A=
usbcore: registered new interface driver hub=0A=
usbcore: registered new device driver usb=0A=
PCI: Using ACPI for IRQ routing=0A=
PCI: If a device doesn't work, try "pci=3Drouteirq".  If it helps, post a=
 report=0A=
ACPI: RTC can wake from S4=0A=
system 00:01: ioport range 0x1000-0x107f has been reserved=0A=
system 00:01: ioport range 0x1080-0x10ff has been reserved=0A=
system 00:01: ioport range 0x1400-0x147f has been reserved=0A=
system 00:01: ioport range 0x1480-0x14ff has been reserved=0A=
system 00:01: ioport range 0x1800-0x187f has been reserved=0A=
system 00:01: ioport range 0x1880-0x18ff has been reserved=0A=
system 00:02: ioport range 0xb78-0xb7b has been reserved=0A=
system 00:02: ioport range 0xf78-0xf7b has been reserved=0A=
system 00:02: ioport range 0xa78-0xa7b has been reserved=0A=
system 00:02: ioport range 0xe78-0xe7b has been reserved=0A=
system 00:02: ioport range 0xbbc-0xbbf has been reserved=0A=
system 00:02: ioport range 0xfbc-0xfbf has been reserved=0A=
system 00:02: ioport range 0x4d0-0x4d1 has been reserved=0A=
system 00:02: ioport range 0x294-0x297 has been reserved=0A=
system 00:02: ioport range 0x290-0x29f could not be reserved=0A=
system 00:0b: iomem range 0xe0000000-0xefffffff could not be reserved=0A=
system 00:0c: iomem range 0xcd000-0xcffff has been reserved=0A=
system 00:0c: iomem range 0xf0000-0xf7fff could not be reserved=0A=
system 00:0c: iomem range 0xf8000-0xfbfff could not be reserved=0A=
system 00:0c: iomem range 0xfc000-0xfffff could not be reserved=0A=
system 00:0c: iomem range 0x3fee0000-0x3fefffff could not be reserved=0A=
system 00:0c: iomem range 0xffff0000-0xffffffff has been reserved=0A=
system 00:0c: iomem range 0x0-0x9ffff could not be reserved=0A=
system 00:0c: iomem range 0x100000-0x3fedffff could not be reserved=0A=
system 00:0c: iomem range 0xfec00000-0xfec00fff has been reserved=0A=
system 00:0c: iomem range 0xfee00000-0xfeefffff could not be reserved=0A=
system 00:0c: iomem range 0xfefff000-0xfeffffff has been reserved=0A=
system 00:0c: iomem range 0xfff80000-0xfff80fff has been reserved=0A=
system 00:0c: iomem range 0xfff90000-0xfffbffff has been reserved=0A=
system 00:0c: iomem range 0xfffed000-0xfffeffff has been reserved=0A=
PCI: Bridge: 0000:00:09.0=0A=
  IO window: a000-afff=0A=
  MEM window: 0xf7000000-0xfcffffff=0A=
  PREFETCH window: 0x00000000fdf00000-0x00000000fdffffff=0A=
PCI: Bridge: 0000:00:0b.0=0A=
  IO window: 9000-9fff=0A=
  MEM window: 0xfde00000-0xfdefffff=0A=
  PREFETCH window: 0x00000000fdd00000-0x00000000fddfffff=0A=
PCI: Bridge: 0000:00:0c.0=0A=
  IO window: 8000-8fff=0A=
  MEM window: 0xfdc00000-0xfdcfffff=0A=
  PREFETCH window: 0x00000000fdb00000-0x00000000fdbfffff=0A=
PCI: Bridge: 0000:00:0d.0=0A=
  IO window: 7000-7fff=0A=
  MEM window: 0xfda00000-0xfdafffff=0A=
  PREFETCH window: 0x00000000fd900000-0x00000000fd9fffff=0A=
PCI: Bridge: 0000:00:0e.0=0A=
  IO window: 6000-6fff=0A=
  MEM window: 0xfd800000-0xfd8fffff=0A=
  PREFETCH window: 0x00000000d8000000-0x00000000dfffffff=0A=
NET: Registered protocol family 2=0A=
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)=0A=
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)=0A=
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)=0A=
TCP: Hash tables configured (established 131072 bind 65536)=0A=
TCP reno registered=0A=
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).=0A=
io scheduler noop registered=0A=
io scheduler cfq registered (default)=0A=
pci 0000:00:00.0: Enabling HT MSI Mapping=0A=
pci 0000:00:0b.0: Enabling HT MSI Mapping=0A=
pci 0000:00:0b.0: Found enabled HT MSI Mapping=0A=
pci 0000:00:0b.0: Linking AER extended capability=0A=
pci 0000:00:0c.0: Enabling HT MSI Mapping=0A=
pci 0000:00:0c.0: Found enabled HT MSI Mapping=0A=
pci 0000:00:0c.0: Linking AER extended capability=0A=
pci 0000:00:0d.0: Enabling HT MSI Mapping=0A=
pci 0000:00:0d.0: Found enabled HT MSI Mapping=0A=
pci 0000:00:0d.0: Linking AER extended capability=0A=
pci 0000:00:0e.0: Enabling HT MSI Mapping=0A=
pci 0000:00:0e.0: Found enabled HT MSI Mapping=0A=
pci 0000:00:0e.0: Linking AER extended capability=0A=
assign_interrupt_mode Found MSI capability=0A=
assign_interrupt_mode Found MSI capability=0A=
assign_interrupt_mode Found MSI capability=0A=
assign_interrupt_mode Found MSI capability=0A=
ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18=0A=
ACPI: PCI Interrupt 0000:05:00.0[A] -> Link [APC3] -> GSI 18 (level, low)=
 -> IRQ 18=0A=
radeonfb: Found Intel x86 BIOS ROM Image=0A=
radeonfb: Retrieved PLL infos from BIOS=0A=
radeonfb: Reference=3D27.00 MHz (RefDiv=3D12) Memory=3D325.00 Mhz, System=
=3D196.00 MHz=0A=
radeonfb: PLL min 20000 max 40000=0A=
radeonfb: Monitor 1 type DFP found=0A=
radeonfb: EDID probed=0A=
radeonfb: Monitor 2 type CRT found=0A=
radeonfb: EDID probed=0A=
Console: switching to colour frame buffer device 160x64=0A=
radeonfb (0000:05:00.0): ATI Radeon [`=20=0A=
input: Power Button (FF) as /class/input/input0=0A=
ACPI: Power Button (FF) [PWRF]=0A=
input: Power Button (CM) as /class/input/input1=0A=
ACPI: Power Button (CM) [PWRB]=0A=
ACPI: Transitioning device [FAN] to D3=0A=
ACPI: PNP0C0B:00 is registered as cooling_device0=0A=
ACPI: Fan [FAN] (off)=0A=
ACPI: ACPI0007:00 is registered as cooling_device1=0A=
ACPI: LNXTHERM:01 is registered as thermal_zone0=0A=
ACPI: Thermal Zone [THRM] (23 C)=0A=
Linux agpgart interface v0.103=0A=
Serial: 8250/16550 driver $Revision: 1.90 $ 1 ports, IRQ sharing disabled=
=0A=
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A=0A=
00:08: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A=0A=
parport_pc 00:09: reported by Plug and Play ACPI=0A=
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,=
EPP,ECP,DMA]=0A=
Floppy drive(s): fd0 is 1.44M=0A=
FDC 0 is a post-1991 82077=0A=
loop: module loaded=0A=
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.=0A=
ACPI: PCI Interrupt Link [APCH] enabled at IRQ 23=0A=
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [APCH] -> GSI 23 (level, low)=
 -> IRQ 23=0A=
forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x3f1 @ 1, addr 00:50:8d:86:=
b3:9c=0A=
forcedeth 0000:00:0a.0: highdma csum timirq gbit lnktim desc-v3=0A=
netconsole: local port 6665=0A=
netconsole: local IP 192.168.0.5=0A=
netconsole: interface eth0=0A=
netconsole: remote port 666=0A=
netconsole: remote IP 192.168.0.1=0A=
netconsole: remote ethernet address 00:00:0e:b8:7e:06=0A=
netconsole: device eth0 not up yet, forcing it=0A=
eth0: no link during initialization.=0A=
eth0: link up.=0A=
console [netcon0] enabled=0A=
netconsole: network logging started=0A=
Uniform Multi-Platform E-IDE driver=0A=
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=3D=
xx=0A=
NFORCE-CK804: 0000:00:06.0 (rev f2) UDMA133 controller=0A=
NFORCE-CK804: IDE controller (0x10de:0x0053 rev 0xf2) at  PCI slot 0000:0=
0:06.0=0A=
NFORCE-CK804: not 100% native mode: will probe irqs later=0A=
NFORCE-CK804: BIOS didn't set cable bits correctly. Enabling workaround.=0A=
    ide0: BM-DMA at 0xe000-0xe007, BIOS settings: hda:DMA, hdb:DMA=0A=
    ide1: BM-DMA at 0xe008-0xe00f, BIOS settings: hdc:DMA, hdd:DMA=0A=
hdb: Maxtor 6L160P0, ATA DISK drive=0A=
hdb: UDMA/133 mode selected=0A=
hdc: PIONEER DVD-RW DVR-110D, ATAPI CD/DVD-ROM drive=0A=
hdd: SAMSUNG DVD-ROM SD-616Q, ATAPI CD/DVD-ROM drive=0A=
hdc: UDMA/66 mode selected=0A=
hdd: UDMA/33 mode selected=0A=
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14=0A=
ide1 at 0x170-0x177,0x376 on irq 15=0A=
hdb: max request size: 512KiB=0A=
hdb: 320173056 sectors (163928 MB) w/8192KiB Cache, CHS=3D19929/255/63=0A=
hdb: cache flushes supported=0A=
 hdb: hdb1 hdb2 hdb3 hdb4 < hdb5 hdb6 hdb7 hdb8 hdb9 >=0A=
hdc: ATAPI 40X DVD-ROM DVD-R CD-R/RW drive, 2000kB Cache=0A=
Uniform CD-ROM driver Revision: 3.20=0A=
hdd: ATAPI 48X DVD-ROM drive, 512kB Cache=0A=
ACPI: PCI Interrupt Link [APCL] enabled at IRQ 22=0A=
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [APCL] -> GSI 22 (level, low)=
 -> IRQ 22=0A=
ehci_hcd 0000:00:02.1: EHCI Host Controller=0A=
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1=0A=
ehci_hcd 0000:00:02.1: debug port 1=0A=
ehci_hcd 0000:00:02.1: irq 22, io mem 0xfeb00000=0A=
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004=0A=
usb usb1: configuration #1 chosen from 1 choice=0A=
hub 1-0:1.0: USB hub found=0A=
hub 1-0:1.0: 10 ports detected=0A=
ACPI: PCI Interrupt Link [APCF] enabled at IRQ 21=0A=
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [APCF] -> GSI 21 (level, low)=
 -> IRQ 21=0A=
ohci_hcd 0000:00:02.0: OHCI Host Controller=0A=
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2=0A=
ohci_hcd 0000:00:02.0: irq 21, io mem 0xfe02f000=0A=
usb usb2: configuration #1 chosen from 1 choice=0A=
hub 2-0:1.0: USB hub found=0A=
hub 2-0:1.0: 10 ports detected=0A=
hub 1-0:1.0: unable to enumerate USB device on port 1=0A=
PNP: PS/2 Controller [PNP0f13:PS2M] at 0x60,0x64 irq 12=0A=
PNP: PS/2 controller doesn't have KBD irq; using default 1=0A=
serio: i8042 KBD port at 0x60,0x64 irq 1=0A=
serio: i8042 AUX port at 0x60,0x64 irq 12=0A=
mice: PS/2 mouse device common for all mice=0A=
hub 1-0:1.0: unable to enumerate USB device on port 3=0A=
input: PC Speaker as /class/input/input2=0A=
usb 2-1: new low speed USB device using ohci_hcd and address 2=0A=
usb 2-1: configuration #1 chosen from 1 choice=0A=
input: ImPS/2 Generic Wheel Mouse as /class/input/input3=0A=
rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0=0A=
rtc0: alarms up to one year, y3k=0A=
i2c /dev entries driver=0A=
i2c-adapter i2c-4: nForce2 SMBus adapter at 0x1c00=0A=
i2c-adapter i2c-5: nForce2 SMBus adapter at 0x1c40=0A=
w83627hf: Found W83627HF chip at 0x290=0A=
cpuidle: using governor ladder=0A=
cpuidle: using governor menu=0A=
usb 2-3: new low speed USB device using ohci_hcd and address 3=0A=
usb 2-3: configuration #1 chosen from 1 choice=0A=
usbcore: registered new interface driver hiddev=0A=
input: 4-D G Laser Mouse as /class/input/input4=0A=
input,hiddev96: USB HID v1.11 Mouse [4-D G Laser Mouse] on usb-0000:00:02=
.0-1=0A=
input: CHESEN USB Keyboard as /class/input/input5=0A=
input: USB HID v1.10 Keyboard [CHESEN USB Keyboard] on usb-0000:00:02.0-3=
=0A=
input: CHESEN USB Keyboard as /class/input/input6=0A=
input: USB HID v1.10 Device [CHESEN USB Keyboard] on usb-0000:00:02.0-3=0A=
usbcore: registered new interface driver usbhid=0A=
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver=0A=
Advanced Linux Sound Architecture Driver Version 1.0.16rc2 (Thu Jan 31 16=
:40:16 2008 UTC).=0A=
ALSA device list:=0A=
  No soundcards found.=0A=
TCP cubic registered=0A=
NET: Registered protocol family 1=0A=
NET: Registered protocol family 10=0A=
lo: Disabled Privacy Extensions=0A=
IPv6 over IPv4 tunneling driver=0A=
sit0: Disabled Privacy Extensions=0A=
NET: Registered protocol family 17=0A=
NET: Registered protocol family 15=0A=
RPC: Registered udp transport module.=0A=
RPC: Registered tcp transport module.=0A=
powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3500+ processors (1 cpu =
cores) (version 2.20.00)=0A=
powernow-k8:    0 : fid 0xe (2200 MHz), vid 0x6=0A=
powernow-k8:    1 : fid 0xc (2000 MHz), vid 0x8=0A=
powernow-k8:    2 : fid 0xa (1800 MHz), vid 0xa=0A=
powernow-k8:    3 : fid 0x2 (1000 MHz), vid 0x12=0A=
rtc_cmos 00:04: setting system clock to 2008-08-24 16:03:22 UTC (12195938=
02)=0A=
VFS: Mounted root (ext2 filesystem) readonly.=0A=
Freeing unused kernel memory: 204k freed=0A=
Write protecting the kernel read-only data: 4012k=0A=
Marking TSC unstable due to cpufreq changes=0A=
Clocksource tsc unstable (delta =3D -272727903 ns)=0A=
ACPI: PCI Interrupt Link [APCJ] enabled at IRQ 20=0A=
ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [APCJ] -> GSI 20 (level, low)=
 -> IRQ 20=0A=
No dock devices found.=0A=
Linux video capture interface: v2.00=0A=
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded=0A=
cx88/0: cx2388x v4l2 driver version 0.0.6 loaded=0A=
intel8x0_measure_ac97_clock: measured 55869 usecs=0A=
intel8x0: clocking to 46911=0A=
ACPI: PCI Interrupt 0000:01:0a.0[A] -> Link [APC3] -> GSI 18 (level, low)=
 -> IRQ 18=0A=
Audigy2 value: Special config.=0A=
ACPI: PCI Interrupt 0000:01:06.0[A] -> Link [APC3] -> GSI 18 (level, low)=
 -> IRQ 18=0A=
cx88[0]: subsystem: 0070:9002, board: Hauppauge Nova-T DVB-T [card=3D18,a=
utodetected]=0A=
cx88[0]: TV tuner type 4, Radio tuner type -1=0A=
ACPI: PCI Interrupt Link [APSI] enabled at IRQ 23=0A=
ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [APSI] -> GSI 23 (level, low)=
 -> IRQ 23=0A=
sata_nv 0000:00:07.0: Using ADMA mode=0A=
scsi0 : sata_nv=0A=
scsi1 : sata_nv=0A=
ata1: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xcc00 irq 23=0A=
ata2: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xcc08 irq 23=0A=
tveeprom 6-0050: Hauppauge model 90002, rev C176, serial# 123606=0A=
tveeprom 6-0050: MAC address is 00-0D-FE-01-E2-D6=0A=
tveeprom 6-0050: tuner model is Thompson DTT7592 (idx 76, type 4)=0A=
tveeprom 6-0050: TV standards ATSC/DVB Digital (eeprom 0x80)=0A=
tveeprom 6-0050: audio processor is None (idx 0)=0A=
tveeprom 6-0050: decoder processor is CX882 (idx 25)=0A=
tveeprom 6-0050: has no radio, has IR receiver, has no IR transmitter=0A=
cx88[0]: hauppauge eeprom: model=3D90002=0A=
input: cx88 IR (Hauppauge Nova-T DVB-T as /class/input/input7=0A=
cx88[0]/0: found at 0000:01:06.0, rev: 5, irq: 18, latency: 32, mmio: 0xf=
c000000=0A=
cx88[0]/0: registered device video0 [v4l2]=0A=
cx88[0]/0: registered device vbi0=0A=
ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16=0A=
ACPI: PCI Interrupt 0000:01:08.0[A] -> Link [APC1] -> GSI 16 (level, low)=
 -> IRQ 16=0A=
cx88[1]: subsystem: 0070:9002, board: Hauppauge Nova-T DVB-T [card=3D18,a=
utodetected]=0A=
cx88[1]: TV tuner type 4, Radio tuner type -1=0A=
ata1: SATA link down (SStatus 0 SControl 300)=0A=
tveeprom 7-0050: Hauppauge model 90002, rev C176, serial# 469246=0A=
tveeprom 7-0050: MAC address is 00-0D-FE-07-28-FE=0A=
tveeprom 7-0050: tuner model is Thompson DTT7592 (idx 76, type 4)=0A=
tveeprom 7-0050: TV standards ATSC/DVB Digital (eeprom 0x80)=0A=
tveeprom 7-0050: audio processor is None (idx 0)=0A=
tveeprom 7-0050: decoder processor is CX882 (idx 25)=0A=
tveeprom 7-0050: has no radio, has IR receiver, has no IR transmitter=0A=
cx88[1]: hauppauge eeprom: model=3D90002=0A=
input: cx88 IR (Hauppauge Nova-T DVB-T as /class/input/input8=0A=
cx88[1]/0: found at 0000:01:08.0, rev: 5, irq: 16, latency: 32, mmio: 0xf=
9000000=0A=
cx88[1]/0: registered device video1 [v4l2]=0A=
cx88[1]/0: registered device vbi1=0A=
ata2: SATA link down (SStatus 0 SControl 300)=0A=
cx88[0]/2: cx2388x 8802 Driver Manager=0A=
ACPI: PCI Interrupt 0000:01:06.2[A] -> Link [APC3] -> GSI 18 (level, low)=
 -> IRQ 18=0A=
cx88[0]/2: found at 0000:01:06.2, rev: 5, irq: 18, latency: 32, mmio: 0xf=
b000000=0A=
cx88[1]/2: cx2388x 8802 Driver Manager=0A=
ACPI: PCI Interrupt 0000:01:08.2[A] -> Link [APC1] -> GSI 16 (level, low)=
 -> IRQ 16=0A=
cx88[1]/2: found at 0000:01:08.2, rev: 5, irq: 16, latency: 32, mmio: 0xf=
8000000=0A=
ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 22=0A=
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [APSJ] -> GSI 22 (level, low)=
 -> IRQ 22=0A=
sata_nv 0000:00:08.0: Using ADMA mode=0A=
cx88/2: cx2388x dvb driver version 0.0.6 loaded=0A=
cx88/2: registering cx8802 driver, type: dvb access: shared=0A=
cx88[0]/2: subsystem: 0070:9002, board: Hauppauge Nova-T DVB-T [card=3D18=
]=0A=
cx88[0]/2: cx2388x based DVB/ATSC card=0A=
scsi2 : sata_nv=0A=
scsi3 : sata_nv=0A=
ata3: SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xb800 irq 22=0A=
ata4: SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xb808 irq 22=0A=
DVB: registering new adapter (cx88[0])=0A=
DVB: registering frontend 0 (Conexant CX22702 DVB-T)...=0A=
cx88[1]/2: subsystem: 0070:9002, board: Hauppauge Nova-T DVB-T [card=3D18=
]=0A=
cx88[1]/2: cx2388x based DVB/ATSC card=0A=
DVB: registering new adapter (cx88[1])=0A=
DVB: registering frontend 1 (Conexant CX22702 DVB-T)...=0A=
ata3: SATA link down (SStatus 0 SControl 300)=0A=
ata4: SATA link down (SStatus 0 SControl 300)=0A=
Adding 1020116k swap on /dev/hdb3.  Priority:-1 extents:1 across:1020116k=
=0A=
kjournald starting.  Commit interval 5 seconds=0A=
EXT3 FS on hdb5, internal journal=0A=
EXT3-fs: mounted filesystem with ordered data mode.=0A=
kjournald starting.  Commit interval 5 seconds=0A=
EXT3 FS on hdb6, internal journal=0A=
EXT3-fs: mounted filesystem with ordered data mode.=0A=
kjournald starting.  Commit interval 5 seconds=0A=
EXT3 FS on hdb7, internal journal=0A=
EXT3-fs: mounted filesystem with ordered data mode.=0A=
kjournald starting.  Commit interval 5 seconds=0A=
EXT3 FS on hdb8, internal journal=0A=
EXT3-fs: mounted filesystem with ordered data mode.=0A=
kjournald starting.  Commit interval 5 seconds=0A=
EXT3 FS on hdb9, internal journal=0A=
EXT3-fs: mounted filesystem with ordered data mode.=0A=
ip6_tables: (C) 2000-2006 Netfilter Core Team=0A=
nf_conntrack version 0.5.0 (8192 buckets, 32768 max)=0A=
[drm] Initialized drm 1.1.0 20060810=0A=
[drm] Initialized radeon 1.28.0 20060524 on minor 0=0A=
[drm] Setting GART location based on new memory map=0A=
[drm] Loading R300 Microcode=0A=
[drm] writeback test succeeded in 1 usecs=0A=
warning: `growisofs' uses 32-bit capabilities (legacy support in use)=0A=
UDF-fs: Partition marked readonly; forcing readonly mount=0A=
UDF-fs INFO UDF: Mounting volume 'CDROM', timestamp 2008/08/24 17:52 (103=
c)=0A=
   [... snip normal USB & DVD stuff ...]=0A=
Bad page state in process 'kswapd0'=0A=
page:ffff8100279219ee flags:0x0000000000000000 mapping:0000000000000000 m=
apcount:1 count:0=0A=
Trying to fix it up, but a reboot is needed=0A=
Backtrace:=0A=
Pid: 237, comm: kswapd0 Not tainted 2.6.25.16 #1=0A=
=0A=
Call Trace:=0A=
 [<ffffffff8024f1ce>] remove_mapping+0x86/0x99=0A=
 [<ffffffff8024b0de>] bad_page+0x71/0x9b=0A=
 [<ffffffff8024b6b3>] free_hot_cold_page+0x6e/0x132=0A=
 [<ffffffff8024b7a0>] __pagevec_free+0x29/0x3b=0A=
 [<ffffffff8024dd68>] release_pages+0x124/0x131=0A=
 [<ffffffff8024e9fd>] isolate_lru_pages+0x7a/0x204=0A=
 [<ffffffff8024e08a>] __pagevec_release+0x19/0x22=0A=
 [<ffffffff8024e5a9>] __invalidate_mapping_pages+0xc3/0x106=0A=
 [<ffffffff8024cb35>] get_dirty_limits+0x1d/0x1a6=0A=
 [<ffffffff80274a74>] shrink_icache_memory+0xe8/0x1c7=0A=
 [<ffffffff8024fc12>] shrink_slab+0xd9/0x13f=0A=
 [<ffffffff80250229>] kswapd+0x30d/0x3ec=0A=
 [<ffffffff8024eb87>] isolate_pages_global+0x0/0x2f=0A=
 [<ffffffff80235b0f>] autoremove_wake_function+0x0/0x2e=0A=
 [<ffffffff8024ff1c>] kswapd+0x0/0x3ec=0A=
 [<ffffffff80235937>] kthread+0x47/0x74=0A=
 [<ffffffff802232c9>] schedule_tail+0x18/0x4c=0A=
 [<ffffffff8020b758>] child_rip+0xa/0x12=0A=
 [<ffffffff802358f0>] kthread+0x0/0x74=0A=
 [<ffffffff8020b74e>] child_rip+0x0/0x12=0A=
=0A=
BUG: unable to handle kernel paging request at 00000fff805298a8=0A=
IP: [<ffffffff8024ad0e>] get_pageblock_flags_group+0x31/0x8f=0A=
PGD 0=20=0A=
Oops: 0000 [1]=20=0A=
CPU 0=20=0A=
Modules linked in: vfat fat usb_storage sd_mod radeon drm ip6t_LOG xt_tcp=
udp ip6t_REJECT nf_conntrack_ipv6 xt_state nf_conntrack ip6table_mangle i=
p6table_filter ip6_tables x_tables dvb_pll cx22702 cx88_dvb videobuf_dvb =
dvb_core snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_em=
ul snd_emu10k1 snd_seq_midi snd_rawmidi snd_util_mem snd_hwdep cx8800 sat=
a_nv cx8802 libata cx88xx ir_common tveeprom compat_ioctl32 videodev v4l1=
_compat v4l2_common videobuf_dma_sg videobuf_core btcx_risc dock snd_inte=
l8x0 snd_ac97_codec ac97_bus=0A=
Pid: 237, comm: kswapd0 Tainted: G    B    2.6.25.16 #1=0A=
RIP: 0010:[<ffffffff8024ad0e>]  [<ffffffff8024ad0e>] get_pageblock_flags_=
group+0x31/0x8f=0A=
RSP: 0018:ffff81003fb83b88  EFLAGS: 00010016=0A=
RAX: 000001fffffc8925 RBX: ffff8100279219ee RCX: ffffffff806064b8=0A=
RDX: fffffe4492fe099b RSI: 0000000000000000 RDI: 0001fffffc8925fc=0A=
RBP: ffffffff806064a8 R08: 0000000000000000 R09: 0000000000000000=0A=
R10: 0000000000000002 R11: 0000000000000000 R12: ffffffff80606470=0A=
R13: 0000000000000246 R14: 0000000000000000 R15: 0000000000000000=0A=
FS:  00007f0116b74780(0000) GS:ffffffff80637000(0000) knlGS:00000000f74c0=
720=0A=
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b=0A=
CR2: 00000fff805298a8 CR3: 00000000279bb000 CR4: 00000000000006e0=0A=
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000=0A=
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400=0A=
Process kswapd0 (pid: 237, threadinfo ffff81003fb82000, task ffff81003fa5=
0040)=0A=
Stack:  ffffffff8024b73e 0000000000000000 ffff81003fb83bf0 00000000000000=
01=0A=
 0000000000000001 ffff81003fb83cc0 ffffffff8024b7a0 ffffe20000072840=0A=
 ffff81003fb83cc0 ffff81003fb83cd8 0000000000000001 0000000000000001=0A=
Call Trace:=0A=
 [<ffffffff8024b73e>] ? free_hot_cold_page+0xf9/0x132=0A=
 [<ffffffff8024b7a0>] ? __pagevec_free+0x29/0x3b=0A=
 [<ffffffff8024dd68>] ? release_pages+0x124/0x131=0A=
 [<ffffffff8024e9fd>] ? isolate_lru_pages+0x7a/0x204=0A=
 [<ffffffff8024e08a>] ? __pagevec_release+0x19/0x22=0A=
 [<ffffffff8024e5a9>] ? __invalidate_mapping_pages+0xc3/0x106=0A=
 [<ffffffff8024cb35>] ? get_dirty_limits+0x1d/0x1a6=0A=
 [<ffffffff80274a74>] ? shrink_icache_memory+0xe8/0x1c7=0A=
 [<ffffffff8024fc12>] ? shrink_slab+0xd9/0x13f=0A=
 [<ffffffff80250229>] ? kswapd+0x30d/0x3ec=0A=
 [<ffffffff8024eb87>] ? isolate_pages_global+0x0/0x2f=0A=
 [<ffffffff80235b0f>] ? autoremove_wake_function+0x0/0x2e=0A=
 [<ffffffff8024ff1c>] ? kswapd+0x0/0x3ec=0A=
 [<ffffffff80235937>] ? kthread+0x47/0x74=0A=
 [<ffffffff802232c9>] ? schedule_tail+0x18/0x4c=0A=
 [<ffffffff8020b758>] ? child_rip+0xa/0x12=0A=
 [<ffffffff802358f0>] ? kthread+0x0/0x74=0A=
 [<ffffffff8020b74e>] ? child_rip+0x0/0x12=0A=
=0A=
=0A=
Code: 00 1e 00 00 41 89 d2 48 8d 14 07 48 b8 b7 6d db b6 6d db b6 6d 48 c=
1 fa 03 48 0f af d0 48 89 d0 48 89 d7 48 c1 e8 17 48 c1 ef 0f <48> 8b 0c =
c5 80 4f 6e 80 31 c0 48 85 c9 74 0c 48 0f b6 c7 48 c1=20=0A=
RIP  [<ffffffff8024ad0e>] get_pageblock_flags_group+0x31/0x8f=0A=
 RSP <ffff81003fb83b88>=0A=
CR2: 00000fff805298a8=0A=
---[ end trace 369bd67186601302 ]---=0A=
BUG: unable to handle kernel paging request at 00000fff805298a8=0A=
IP: [<ffffffff8024ad0e>] get_pageblock_flags_group+0x31/0x8f=0A=
PGD 0=20=0A=
Oops: 0000 [2]=20=0A=
CPU 0=20=0A=
Modules linked in: vfat fat usb_storage sd_mod radeon drm ip6t_LOG xt_tcp=
udp ip6t_REJECT nf_conntrack_ipv6 xt_state nf_conntrack ip6table_mangle i=
p6table_filter ip6_tables x_tables dvb_pll cx22702 cx88_dvb videobuf_dvb =
dvb_core snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_em=
ul snd_emu10k1 snd_seq_midi snd_rawmidi snd_util_mem snd_hwdep cx8800 sat=
a_nv cx8802 libata cx88xx ir_common tveeprom compat_ioctl32 videodev v4l1=
_compat v4l2_common videobuf_dma_sg videobuf_core btcx_risc dock snd_inte=
l8x0 snd_ac97_codec ac97_bus=0A=
Pid: 28819, comm: dpkg-deb Tainted: G    B D  2.6.25.16 #1=0A=
RIP: 0010:[<ffffffff8024ad0e>]  [<ffffffff8024ad0e>] get_pageblock_flags_=
group+0x31/0x8f=0A=
RSP: 0018:ffff810019435cb0  EFLAGS: 00010016=0A=
RAX: 000001fffffc8925 RBX: ffff8100279219ee RCX: ffffffff806064b8=0A=
RDX: fffffe4492fe099b RSI: 0000000000000000 RDI: 0001fffffc8925fc=0A=
RBP: ffffffff80606470 R08: 0000000000000008 R09: ffff810001400000=0A=
R10: 0000000000000002 R11: 0000000000000246 R12: 0000000000000000=0A=
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000=0A=
FS:  00007fd9260dc6e0(0000) GS:ffffffff80637000(0000) knlGS:00000000f74c0=
720=0A=
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b=0A=
CR2: 00000fff805298a8 CR3: 000000003c9b9000 CR4: 00000000000006e0=0A=
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000=0A=
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400=0A=
Process dpkg-deb (pid: 28819, threadinfo ffff810019434000, task ffff81001=
3a4d080)=0A=
Stack:  ffffffff8024b4c1 0000000000000000 ffffffff806064b8 00000000000000=
00=0A=
 ffffe20000032f10 ffffffff806064a8 ffffffff80606470 0000000000000246=0A=
 0000000000000000 0000000000000001 ffffffff8024b762 0000000000000000=0A=
Call Trace:=0A=
 [<ffffffff8024b4c1>] ? free_pages_bulk+0x91/0x215=0A=
 [<ffffffff8024b762>] ? free_hot_cold_page+0x11d/0x132=0A=
 [<ffffffff80269fbe>] ? pipe_read+0x28b/0x3c4=0A=
 [<ffffffff80264406>] ? do_sync_read+0xd1/0x118=0A=
 [<ffffffff8023803b>] ? ktime_get_ts+0x17/0x48=0A=
 [<ffffffff80235b0f>] ? autoremove_wake_function+0x0/0x2e=0A=
 [<ffffffff80264b72>] ? vfs_read+0xaa/0x132=0A=
 [<ffffffff80264e8e>] ? sys_read+0x45/0x6e=0A=
 [<ffffffff8020adfb>] ? system_call_after_swapgs+0x7b/0x80=0A=
=0A=
=0A=
Code: 00 1e 00 00 41 89 d2 48 8d 14 07 48 b8 b7 6d db b6 6d db b6 6d 48 c=
1 fa 03 48 0f af d0 48 89 d0 48 89 d7 48 c1 e8 17 48 c1 ef 0f <48> 8b 0c =
c5 80 4f 6e 80 31 c0 48 85 c9 74 0c 48 0f b6 c7 48 c1=20=0A=
RIP  [<ffffffff8024ad0e>] get_pageblock_flags_group+0x31/0x8f=0A=
 RSP <ffff810019435cb0>=0A=
CR2: 00000fff805298a8=0A=
---[ end trace 369bd67186601302 ]---=0A=
xfce4-cpufreq-p[2635]: segfault at 1fff8 ip 7ffb2d1a3a25 sp 7fff38175860 =
error 4 in libc-2.7.so[7ffb2d12e000+14a000]=0A=
xfce4-sensors-p[2637] general protection ip:7feefec82a62 sp:7fff0af5a5c0 =
error:0 in libc-2.7.so[7feefec0d000+14a000]=0A=
nfsd: last server has exited=0A=
nfsd: unexporting all filesystems=0A=
SysRq : Emergency Sync=0A=
SysRq : Emergency Remount R/O=0A=
SysRq : Emergency Sync=0A=
SysRq : Resetting=0A=

--1734974150--1102215432--558902121
Content-Type: application/x-gzip; name="config.gz"
Content-Disposition: attachment; filename="config.gz"
Content-Transfer-Encoding: base64

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

--1734974150--1102215432--558902121--
