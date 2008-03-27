Return-Path: <linux-kernel-owner+w=401wt.eu-S1760870AbYC0Qky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760870AbYC0Qky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 12:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760651AbYC0Qkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 12:40:42 -0400
Received: from poseidon.rz.tu-clausthal.de ([139.174.2.21]:54229 "EHLO
	poseidon.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760857AbYC0Qke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 12:40:34 -0400
From: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
Date: Thu, 27 Mar 2008 17:40:27 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <200803191108.18577.volker.armin.hemmann@tu-clausthal.de> <47E0FC47.8040902@gmail.com>
In-Reply-To: <47E0FC47.8040902@gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_8386HsjcnVuI372"
Message-Id: <200803271740.28158.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_8386HsjcnVuI372
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

I tried 2.6.25-rc7 and there are some changes.

Bad news first.
With AHCI in bios I get this:
[    0.363838] ------------[ cut here ]------------
[    0.363838] WARNING: at drivers/ata/ahci.c:645 ahci_init_one+0x190/0xa3a=
()
[    0.363838] Modules linked in:
[    0.363838] Pid: 1, comm: swapper Not tainted 2.6.25-rc7 #3
[    0.363838]
[    0.363838] Call Trace:
[    0.363838]  [<ffffffff8022c545>] warn_on_slowpath+0x51/0x63
[    0.363838]  [<ffffffff80220061>] __ioremap+0x8/0x197
[    0.363838]  [<ffffffff8038e218>] pci_conf1_read+0xb2/0xbd
[    0.363841]  [<ffffffff802f3076>] pcim_iomap_release+0x0/0x2c
[    0.363880]  [<ffffffff802f3076>] pcim_iomap_release+0x0/0x2c
[    0.363920]  [<ffffffff80346ca1>] devres_find+0x4b/0x65
[    0.363959]  [<ffffffff8036a405>] ahci_init_one+0x190/0xa3a
[    0.363998]  [<ffffffff802af91f>] sysfs_addrm_finish+0x1d/0x209
[    0.364038]  [<ffffffff80283f98>] ifind+0x34/0x8d
[    0.364076]  [<ffffffff802af636>] sysfs_find_dirent+0x1b/0x2f
[    0.364115]  [<ffffffff802eb4c5>] ida_get_new_above+0xf0/0x180
[    0.364154]  [<ffffffff802af91f>] sysfs_addrm_finish+0x1d/0x209
[    0.364194]  [<ffffffff802b0458>] sysfs_create_link+0xb6/0x102
[    0.364234]  [<ffffffff802f83c4>] pci_device_probe+0x4c/0x72
[    0.364273]  [<ffffffff80344874>] driver_probe_device+0xb5/0x132
[    0.364312]  [<ffffffff80344a07>] __driver_attach+0x6f/0xaf
[    0.364350]  [<ffffffff80344998>] __driver_attach+0x0/0xaf
[    0.364389]  [<ffffffff80344998>] __driver_attach+0x0/0xaf
[    0.364429]  [<ffffffff80343c82>] bus_for_each_dev+0x44/0x6f
[    0.364468]  [<ffffffff803444a0>] bus_add_driver+0xae/0x1f6
[    0.364507]  [<ffffffff80344c36>] driver_register+0x59/0xce
[    0.364546]  [<ffffffff802f8605>] __pci_register_driver+0x4a/0x7d
[    0.364587]  [<ffffffff804dd6b8>] kernel_init+0x14f/0x2b9
[    0.364626]  [<ffffffff8020be98>] child_rip+0xa/0x12
[    0.364670]  [<ffffffff804dd569>] kernel_init+0x0/0x2b9
[    0.364709]  [<ffffffff8020be8e>] child_rip+0x0/0x12
[    0.364746]
[    0.364783] ---[ end trace 1d94b6d2f6a54ae4 ]---
[    1.370499] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0x=
f=20
imp
l SATA mode
[    1.370499] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio
[    1.370499] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[    1.370501] scsi0 : ahci
[    1.370509] scsi1 : ahci
[    1.370517] scsi2 : ahci
[    1.370526] scsi3 : ahci
[    1.370532] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc10=
0=20
irq
 23
[    1.370532] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc18=
0=20
irq
 23
[    1.370532] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc20=
0=20
irq
 23
[    1.370532] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc28=
0=20
irq
 23
[    1.801113] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.801617] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[    1.801617] ata1.00: 312581808 sectors, multi 16: LBA48
[    1.802150] ata1.00: configured for UDMA/133
[    2.434072] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.447930] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[    2.447930] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.449834] ata2.00: configured for UDMA/133
[    2.767054] ata3: SATA link down (SStatus 0 SControl 300)
[    3.086918] ata4: SATA link down (SStatus 0 SControl 300)
[    3.290523] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10=
=2E0=20
PQ
: 0 ANSI: 5
[    3.290535] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (16004=
2=20
MB)
[    3.290535] sd 0:0:0:0: [sda] Write Protect is off
[    3.290535] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.290535] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
does
n't support DPO or FUA
[    3.290535] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (16004=
2=20
MB)
[    3.290535] sd 0:0:0:0: [sda] Write Protect is off
[    3.290535] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.290535] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
does
n't support DPO or FUA
[    3.290535]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    3.122431] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.122593] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR=
10=20
PQ
: 0 ANSI: 5
[    3.122721] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (50010=
8=20
MB)
[    3.122768] sd 1:0:0:0: [sdb] Write Protect is off
[    3.122806] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.122820] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
=20
does
n't support DPO or FUA
[    3.122900] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (50010=
8=20
MB)
[    3.122946] sd 1:0:0:0: [sdb] Write Protect is off
[    3.122984] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.122998] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
=20
does
n't support DPO or FUA
[    3.123047]  sdb: sdb1 sdb2
[    3.148928] sd 1:0:0:0: [sdb] Attached SCSI disk

with nomsi. Without nomsi drives are still not found. Evil or not, it looks=
=20
scary ;)=20

dmesg&config is attached.

Now the good ones. With non-raid set in bios box boots cleanly without hang:

[    0.360492] Driver 'sd' needs updating - please use bus_type methods
[    0.360498] ahci 0000:00:0a.0: version 3.0
[    0.360498] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[    0.360498] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23=
=20
(level, low) -> IRQ 23
[    1.363826] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0x=
f=20
impl IDE mode
[    1.363826] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio
[    1.363826] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[    1.363828] scsi0 : ahci
[    1.363836] scsi1 : ahci
[    1.363844] scsi2 : ahci
[    1.363851] scsi3 : ahci
[    1.363857] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc10=
0=20
irq 315
[    1.363857] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc18=
0=20
irq 315
[    1.363857] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc20=
0=20
irq 315
[    1.363857] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc28=
0=20
irq 315
[    1.794371] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.794871] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[    1.794871] ata1.00: 312581808 sectors, multi 16: LBA48
[    1.795403] ata1.00: configured for UDMA/133
[    2.427327] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.447811] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[    2.447811] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.449717] ata2.00: configured for UDMA/133
[    2.766980] ata3: SATA link down (SStatus 0 SControl 300)
[    3.086847] ata4: SATA link down (SStatus 0 SControl 300)
[    3.290513] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10=
=2E0=20
PQ: 0 ANSI: 5
[    3.290525] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (16004=
2=20
MB)
[    3.290525] sd 0:0:0:0: [sda] Write Protect is off
[    3.290525] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.290525] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[    3.290525] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (16004=
2=20
MB)
[    3.290525] sd 0:0:0:0: [sda] Write Protect is off
[    3.290525] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.290525] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[    3.290525]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    3.123110] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.123121] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR=
10=20
PQ: 0 ANSI: 5
[    3.123131] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (50010=
8=20
MB)
[    3.123131] sd 1:0:0:0: [sdb] Write Protect is off
[    3.123131] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.123131] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[    3.123131] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (50010=
8=20
MB)
[    3.123131] sd 1:0:0:0: [sdb] Write Protect is off
[    3.123131] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.123131] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[    3.123131]  sdb: sdb1 sdb2
[    3.127056] sd 1:0:0:0: [sdb] Attached SCSI disk

again, dmesg is attached.

Gl=FCck Auf,
Volker

--Boundary-00=_8386HsjcnVuI372
Content-Type: text/plain;
  charset="iso-8859-1";
  name="dmesg_2.6.25_rc7"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg_2.6.25_rc7"

[    0.000000] Linux version 2.6.25-rc7 (root@energy) (gcc version 4.2.3 (Gentoo 4.2.3 p1.0)) #3 SMP Thu Mar 27 17:12:28 CET 2008
[    0.000000] Command line: pci=nomsi root=/dev/sda3 nmi_watchdog=0 console=tty6
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cffb0000 (usable)
[    0.000000]  BIOS-e820: 00000000cffb0000 - 00000000cffc0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cffc0000 - 00000000cfff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfff0000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff380000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 used
[    0.000000] end_pfn_map = 1245184
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F98E0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT CFFB0000, 003C (r1 A M I  OEMRSDT  12000731 MSFT       97)
[    0.000000] ACPI: FACP CFFB0200, 0084 (r2 A_M_I  OEMFACP  12000601 MSFT       97)
[    0.000000] ACPI: DSDT CFFB0450, 4FFA (r1  ASR19 ASR19186      186 INTL 20051117)
[    0.000000] ACPI: FACS CFFC0000, 0040
[    0.000000] ACPI: APIC CFFB0390, 0080 (r1 A M I  OEMAPIC  12000731 MSFT       97)
[    0.000000] ACPI: MCFG CFFB0410, 003C (r1 A M I  OEMMCFG  12000731 MSFT       97)
[    0.000000] ACPI: OEMB CFFC0040, 0060 (r1 A M I  AMI_OEM  12000731 MSFT       97)
[    0.000000] ACPI: HPET CFFB5450, 0038 (r1 A M I  OEMHPET0 12000731 MSFT       97)
[    0.000000] ACPI: SSDT CFFB5490, 030E (r1 A M I  POWERNOW        1 AMD         1)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 used
[    0.000000] early res: 0 [0-fff] BIOS data page
[    0.000000] early res: 1 [6000-7fff] SMP_TRAMPOLINE
[    0.000000] early res: 2 [200000-546193] TEXT DATA BSS
[    0.000000] early res: 3 [9fc00-a0bff] EBDA
[    0.000000] early res: 4 [8000-dfff] PGTABLE
[    0.000000] No mptable found.
[    0.000000]  [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
[    0.000000]  [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
[    0.000000]  [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
[    0.000000]  [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
[    0.000000]  [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0
[    0.000000]  [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0
[    0.000000]  [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on node 0
[    0.000000]  [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002e00000 on node 0
[    0.000000]  [ffffe20001000000-ffffe200011fffff] PMD ->ffff810003200000 on node 0
[    0.000000]  [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003600000 on node 0
[    0.000000]  [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003a00000 on node 0
[    0.000000]  [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003e00000 on node 0
[    0.000000]  [ffffe20001800000-ffffe200019fffff] PMD ->ffff810004200000 on node 0
[    0.000000]  [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff810004600000 on node 0
[    0.000000]  [ffffe20001c00000-ffffe20001dfffff] PMD ->ffff810004a00000 on node 0
[    0.000000]  [ffffe20001e00000-ffffe20001ffffff] PMD ->ffff810004e00000 on node 0
[    0.000000]  [ffffe20002000000-ffffe200021fffff] PMD ->ffff810005200000 on node 0
[    0.000000]  [ffffe20002200000-ffffe200023fffff] PMD ->ffff810005600000 on node 0
[    0.000000]  [ffffe20002400000-ffffe200025fffff] PMD ->ffff810005a00000 on node 0
[    0.000000]  [ffffe20002600000-ffffe200027fffff] PMD ->ffff810005e00000 on node 0
[    0.000000]  [ffffe20002800000-ffffe200029fffff] PMD ->ffff810006200000 on node 0
[    0.000000]  [ffffe20002a00000-ffffe20002bfffff] PMD ->ffff810006600000 on node 0
[    0.000000]  [ffffe20002c00000-ffffe20002dfffff] PMD ->ffff810006a00000 on node 0
[    0.000000]  [ffffe20002e00000-ffffe20002ffffff] PMD ->ffff810006e00000 on node 0
[    0.000000]  [ffffe20003000000-ffffe200031fffff] PMD ->ffff810007200000 on node 0
[    0.000000]  [ffffe20003200000-ffffe200033fffff] PMD ->ffff810007600000 on node 0
[    0.000000]  [ffffe20003400000-ffffe200035fffff] PMD ->ffff810007a00000 on node 0
[    0.000000]  [ffffe20003600000-ffffe200037fffff] PMD ->ffff810007e00000 on node 0
[    0.000000]  [ffffe20003800000-ffffe200039fffff] PMD ->ffff810008200000 on node 0
[    0.000000]  [ffffe20003a00000-ffffe20003bfffff] PMD ->ffff810008600000 on node 0
[    0.000000]  [ffffe20003c00000-ffffe20003dfffff] PMD ->ffff810008a00000 on node 0
[    0.000000]  [ffffe20003e00000-ffffe20003ffffff] PMD ->ffff810008e00000 on node 0
[    0.000000]  [ffffe20004000000-ffffe200041fffff] PMD ->ffff810009200000 on node 0
[    0.000000]  [ffffe20004200000-ffffe200043fffff] PMD ->ffff810009600000 on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1245184
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   851888
[    0.000000]     0:  1048576 ->  1245184
[    0.000000] On node 0 totalpages: 1048399
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 848 pages reserved
[    0.000000]   DMA zone: 3095 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833512 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x2008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e6000
[    0.000000] PM: Registered nosave memory: 00000000000e6000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cffb0000 - 00000000cffc0000
[    0.000000] PM: Registered nosave memory: 00000000cffc0000 - 00000000cfff0000
[    0.000000] PM: Registered nosave memory: 00000000cfff0000 - 00000000d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fef00000
[    0.000000] PM: Registered nosave memory: 00000000fef00000 - 00000000ff380000
[    0.000000] PM: Registered nosave memory: 00000000ff380000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at d4000000 (gap: d0000000:2ec00000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 32584 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1030527
[    0.000000] Kernel command line: pci=nomsi root=/dev/sda3 nmi_watchdog=0 console=tty6
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] TSC calibrated against PM_TIMER
[    0.000000] Marking TSC unstable due to TSCs unsynchronized
[    0.000002] time.c: Detected 3013.889 MHz processor.
[    0.000011] spurious 8259A interrupt: IRQ7.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty6] enabled
[    0.003333] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.003333] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.003333] Checking aperture...
[    0.003333] Node 0: aperture @ 8000000 size 32 MB
[    0.003333] Aperture pointing to e820 RAM. Ignoring.
[    0.003333] No AGP bridge found
[    0.003333] Your BIOS doesn't leave a aperture memory hole
[    0.003333] Please enable the IOMMU option in the BIOS setup
[    0.003333] This costs you 64 MB of RAM
[    0.003333] Mapping aperture over 65536 KB of RAM @ c000000
[    0.003333] PM: Registered nosave memory: 000000000c000000 - 0000000010000000
[    0.003333] Memory: 4047784k/4980736k available (1978k kernel code, 145104k reserved, 856k data, 192k init)
[    0.003333] CPA: page pool initialized 1 of 1 pages preallocated
[    0.003333] SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
[    0.003333] hpet clockevent registered
[    0.083330] Calibrating delay using timer specific routine.. 6034.73 BogoMIPS (lpj=10053970)
[    0.083419] Mount-cache hash table entries: 256
[    0.083537] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.083577] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.083615] CPU: Physical Processor ID: 0
[    0.083651] CPU: Processor Core ID: 0
[    0.083700] ACPI: Core revision 20070126
[    0.122295] Using local APIC timer interrupts.
[    0.123326] APIC timer calibration result 12557872
[    0.123327] Detected 12.557 MHz APIC timer.
[    0.123430] Booting processor 1/2 APIC 0x1
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 6030.95 BogoMIPS (lpj=10046334)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.003333] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
[    0.216840] Brought up 2 CPUs
[    0.217286] net_namespace: 296 bytes
[    0.217402] NET: Registered protocol family 16
[    0.217496] No dock devices found.
[    0.217559] ACPI: bus type pci registered
[    0.217638] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
[    0.217677] PCI: Not using MMCONFIG.
[    0.217713] PCI: Using configuration type 1
[    0.220689] ACPI: EC: Look up EC in DSDT
[    0.224824] ACPI: Interpreter enabled
[    0.224861] ACPI: (supports S0 S1 S3 S4 S5)
[    0.225032] ACPI: Using IOAPIC for interrupt routing
[    0.225203] ACPI: Error attaching device data
[    0.225243] ACPI: Error attaching device data
[    0.225282] ACPI: Error attaching device data
[    0.225322] ACPI: Error attaching device data
[    0.230926] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.231439] PCI: Transparent bridge - 0000:00:08.0
[    0.231690] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.231832] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.231946] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[    0.232008] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[    0.232072] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
[    0.232136] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[    0.236396] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *11
[    0.236955] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *5
[    0.237309] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, disabled.
[    0.237690] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disabled.
[    0.238070] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, disabled.
[    0.238450] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[    0.238804] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, disabled.
[    0.239184] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *10
[    0.239538] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *5
[    0.239892] ACPI: PCI Interrupt Link [LMAD] (IRQs 20 21 22 23) *0, disabled.
[    0.240284] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *7
[    0.240638] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, disabled.
[    0.241019] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *0, disabled.
[    0.241399] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[    0.241753] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *0, disabled.
[    0.242133] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *15
[    0.242487] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *0, disabled.
[    0.242892] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, disabled.
[    0.243273] ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *0, disabled.
[    0.243669] ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *0, disabled.
[    0.243997] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.244045] pnp: PnP ACPI init
[    0.244084] ACPI: bus type pnp registered
[    0.247188] pnp: PnP ACPI: found 13 devices
[    0.247225] ACPI: ACPI bus type pnp unregistered
[    0.247332] SCSI subsystem initialized
[    0.247405] libata version 3.00 loaded.
[    0.247444] usbcore: registered new interface driver usbfs
[    0.247495] usbcore: registered new interface driver hub
[    0.247551] usbcore: registered new device driver usb
[    0.247631] PCI: Using ACPI for IRQ routing
[    0.247668] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    0.266652] PCI-DMA: Disabling AGP.
[    0.266652] PCI-DMA: aperture base @ c000000 size 65536 KB
[    0.266652] PCI-DMA: using GART IOMMU.
[    0.266652] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.266652] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    0.266652] hpet0: 3 32-bit timers, 25000000 Hz
[    0.266661] Switched to high resolution mode on CPU 0
[    0.056683] Switched to high resolution mode on CPU 1
[    0.280018] system 00:05: ioport range 0x4d0-0x4d1 has been reserved
[    0.280018] system 00:05: ioport range 0x800-0x80f has been reserved
[    0.280018] system 00:05: ioport range 0x2000-0x207f has been reserved
[    0.280018] system 00:05: ioport range 0x2080-0x20ff has been reserved
[    0.280018] system 00:05: ioport range 0x2400-0x247f has been reserved
[    0.280018] system 00:05: ioport range 0x2480-0x24ff has been reserved
[    0.280018] system 00:05: ioport range 0x2800-0x287f has been reserved
[    0.280018] system 00:05: ioport range 0x2880-0x28ff has been reserved
[    0.280021] system 00:05: ioport range 0x2c00-0x2c7f has been reserved
[    0.280060] system 00:05: ioport range 0x2c80-0x2cff has been reserved
[    0.280100] system 00:05: iomem range 0x0-0x0 could not be reserved
[    0.280140] system 00:05: iomem range 0xfee01000-0xfeefffff has been reserved
[    0.280190] system 00:07: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.280238] system 00:07: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.280289] system 00:0a: ioport range 0x290-0x29f has been reserved
[    0.280332] system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
[    0.280376] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.280415] system 00:0c: iomem range 0xc0000-0xcffff has been reserved
[    0.280455] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[    0.280499] system 00:0c: iomem range 0x100000-0xcfffffff could not be reserved
[    0.280546] system 00:0c: iomem range 0xff380000-0xffffffff could not be reserved
[    0.281003] PCI: Bridge: 0000:00:08.0
[    0.281041]   IO window: d000-dfff
[    0.281078]   MEM window: 0xf9f00000-0xf9ffffff
[    0.281116]   PREFETCH window: disabled.
[    0.281155] PCI: Bridge: 0000:00:0b.0
[    0.281191]   IO window: c000-cfff
[    0.281228]   MEM window: 0xf9e00000-0xf9efffff
[    0.281265]   PREFETCH window: disabled.
[    0.281303] PCI: Bridge: 0000:00:0c.0
[    0.281339]   IO window: disabled.
[    0.281376]   MEM window: disabled.
[    0.281413]   PREFETCH window: disabled.
[    0.281450] PCI: Bridge: 0000:00:0d.0
[    0.281487]   IO window: e000-efff
[    0.281524]   MEM window: 0xfa000000-0xfebfffff
[    0.281562]   PREFETCH window: 0x00000000d0000000-0x00000000dfffffff
[    0.281602] PCI: Bridge: 0000:00:0e.0
[    0.281638]   IO window: disabled.
[    0.281675]   MEM window: disabled.
[    0.281711]   PREFETCH window: disabled.
[    0.281754] PCI: Setting latency timer of device 0000:00:08.0 to 64
[    0.281763] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    0.281768] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    0.281773] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    0.281778] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    0.281785] NET: Registered protocol family 2
[    0.316683] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.316683] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.316683] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.316683] TCP: Hash tables configured (established 262144 bind 65536)
[    0.316683] TCP reno registered
[    0.326992] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    0.326992] io scheduler noop registered
[    0.326992] io scheduler cfq registered (default)
[    0.326992] pci 0000:00:00.0: Enabling HT MSI Mapping
[    0.326992] pci 0000:00:08.0: Enabling HT MSI Mapping
[    0.326992] pci 0000:00:0a.0: Enabling HT MSI Mapping
[    0.326992] pci 0000:00:0b.0: Enabling HT MSI Mapping
[    0.326992] pci 0000:00:0c.0: Enabling HT MSI Mapping
[    0.326992] pci 0000:00:0d.0: Enabling HT MSI Mapping
[    0.326992] pci 0000:00:0e.0: Enabling HT MSI Mapping
[    0.326992] pci 0000:04:00.0: Boot video device
[    0.327000] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    0.327000] assign_interrupt_mode Found MSI capability
[    0.327000] Allocate Port Service[0000:00:0b.0:pcie00]
[    0.327006] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    0.327006] assign_interrupt_mode Found MSI capability
[    0.327006] Allocate Port Service[0000:00:0c.0:pcie00]
[    0.327012] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    0.327012] assign_interrupt_mode Found MSI capability
[    0.327012] Allocate Port Service[0000:00:0d.0:pcie00]
[    0.327018] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    0.327018] assign_interrupt_mode Found MSI capability
[    0.327018] Allocate Port Service[0000:00:0e.0:pcie00]
[    0.327056] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.327056] ACPI: Power Button (FF) [PWRF]
[    0.327062] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.327062] ACPI: Power Button (CM) [PWRB]
[    0.327094] ACPI: ACPI0007:00 is registered as cooling_device0
[    0.327100] ACPI: ACPI0007:01 is registered as cooling_device1
[    0.363802] Real Time Clock Driver v1.12ac
[    0.363806] hpet_resources: 0xfed00000 is busy
[    0.363813] Linux agpgart interface v0.103
[    0.363832] Driver 'sd' needs updating - please use bus_type methods
[    0.363838] ahci 0000:00:0a.0: version 3.0
[    0.363838] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[    0.363838] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23 (level, low) -> IRQ 23
[    0.363838] ------------[ cut here ]------------
[    0.363838] WARNING: at drivers/ata/ahci.c:645 ahci_init_one+0x190/0xa3a()
[    0.363838] Modules linked in:
[    0.363838] Pid: 1, comm: swapper Not tainted 2.6.25-rc7 #3
[    0.363838] 
[    0.363838] Call Trace:
[    0.363838]  [<ffffffff8022c545>] warn_on_slowpath+0x51/0x63
[    0.363838]  [<ffffffff80220061>] __ioremap+0x8/0x197
[    0.363838]  [<ffffffff8038e218>] pci_conf1_read+0xb2/0xbd
[    0.363841]  [<ffffffff802f3076>] pcim_iomap_release+0x0/0x2c
[    0.363880]  [<ffffffff802f3076>] pcim_iomap_release+0x0/0x2c
[    0.363920]  [<ffffffff80346ca1>] devres_find+0x4b/0x65
[    0.363959]  [<ffffffff8036a405>] ahci_init_one+0x190/0xa3a
[    0.363998]  [<ffffffff802af91f>] sysfs_addrm_finish+0x1d/0x209
[    0.364038]  [<ffffffff80283f98>] ifind+0x34/0x8d
[    0.364076]  [<ffffffff802af636>] sysfs_find_dirent+0x1b/0x2f
[    0.364115]  [<ffffffff802eb4c5>] ida_get_new_above+0xf0/0x180
[    0.364154]  [<ffffffff802af91f>] sysfs_addrm_finish+0x1d/0x209
[    0.364194]  [<ffffffff802b0458>] sysfs_create_link+0xb6/0x102
[    0.364234]  [<ffffffff802f83c4>] pci_device_probe+0x4c/0x72
[    0.364273]  [<ffffffff80344874>] driver_probe_device+0xb5/0x132
[    0.364312]  [<ffffffff80344a07>] __driver_attach+0x6f/0xaf
[    0.364350]  [<ffffffff80344998>] __driver_attach+0x0/0xaf
[    0.364389]  [<ffffffff80344998>] __driver_attach+0x0/0xaf
[    0.364429]  [<ffffffff80343c82>] bus_for_each_dev+0x44/0x6f
[    0.364468]  [<ffffffff803444a0>] bus_add_driver+0xae/0x1f6
[    0.364507]  [<ffffffff80344c36>] driver_register+0x59/0xce
[    0.364546]  [<ffffffff802f8605>] __pci_register_driver+0x4a/0x7d
[    0.364587]  [<ffffffff804dd6b8>] kernel_init+0x14f/0x2b9
[    0.364626]  [<ffffffff8020be98>] child_rip+0xa/0x12
[    0.364670]  [<ffffffff804dd569>] kernel_init+0x0/0x2b9
[    0.364709]  [<ffffffff8020be8e>] child_rip+0x0/0x12
[    0.364746] 
[    0.364783] ---[ end trace 1d94b6d2f6a54ae4 ]---
[    1.370499] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[    1.370499] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio 
[    1.370499] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[    1.370501] scsi0 : ahci
[    1.370509] scsi1 : ahci
[    1.370517] scsi2 : ahci
[    1.370526] scsi3 : ahci
[    1.370532] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc100 irq 23
[    1.370532] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc180 irq 23
[    1.370532] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc200 irq 23
[    1.370532] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc280 irq 23
[    1.801113] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.801617] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[    1.801617] ata1.00: 312581808 sectors, multi 16: LBA48 
[    1.802150] ata1.00: configured for UDMA/133
[    2.434072] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.447930] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[    2.447930] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.449834] ata2.00: configured for UDMA/133
[    2.767054] ata3: SATA link down (SStatus 0 SControl 300)
[    3.086918] ata4: SATA link down (SStatus 0 SControl 300)
[    3.290523] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10.0 PQ: 0 ANSI: 5
[    3.290535] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[    3.290535] sd 0:0:0:0: [sda] Write Protect is off
[    3.290535] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.290535] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.290535] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[    3.290535] sd 0:0:0:0: [sda] Write Protect is off
[    3.290535] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.290535] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.290535]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    3.122431] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.122593] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
[    3.122721] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[    3.122768] sd 1:0:0:0: [sdb] Write Protect is off
[    3.122806] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.122820] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.122900] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[    3.122946] sd 1:0:0:0: [sdb] Write Protect is off
[    3.122984] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.122998] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.123047]  sdb: sdb1 sdb2
[    3.148928] sd 1:0:0:0: [sdb] Attached SCSI disk
[    3.148943] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    3.149040] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.149040] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.179062] usbcore: registered new interface driver usbhid
[    3.179062] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[    3.179062] TCP cubic registered
[    3.179062] NET: Registered protocol family 1
[    3.179068] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ processors (2 cpu cores) (version 2.20.00)
[    3.378698] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x6
[    3.378698] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0x8
[    3.378698] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xa
[    3.378698] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xc
[    3.378698] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0xe
[    3.378698] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
[    3.378698] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
[    3.378698] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[    3.211155] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    3.310804] ReiserFS: sda3: found reiserfs format "3.6" with standard journal
[    3.310804] ReiserFS: sda3: using ordered data mode
[    3.323573] ReiserFS: sda3: journal params: device sda3, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[    3.327318] ReiserFS: sda3: checking transaction log (sda3)
[    3.370161] ReiserFS: sda3: Using r5 hash to sort names
[    3.370161] VFS: Mounted root (reiserfs filesystem) readonly.
[    3.370161] Freeing unused kernel memory: 192k freed
[    4.060449] Clocksource tsc unstable (delta = -150866427 ns)
[    8.503418] ReiserFS: sda3: switching to journaled data mode
[    8.884405] r8169 Gigabit Ethernet driver 2.2LK loaded
[    8.884634] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 19
[    8.884639] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNEB] -> GSI 19 (level, low) -> IRQ 19
[    8.884648] PCI: Setting latency timer of device 0000:01:00.0 to 64
[    8.884657] r8169 0000:01:00.0: no MSI. Back to INTx.
[    8.887277] eth0: RTL8168b/8111b at 0xffffc20000170000, 00:19:66:47:f3:cb, XID 38000000 IRQ 19
[    8.934245] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
[    8.934250] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 22 (level, low) -> IRQ 22
[    8.934258] PCI: Setting latency timer of device 0000:00:02.1 to 64
[    8.934260] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    8.934332] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
[    8.934354] ehci_hcd 0000:00:02.1: debug port 1
[    8.934356] PCI: cache line size of 64 is not supported by device 0000:00:02.1
[    8.934363] ehci_hcd 0000:00:02.1: irq 22, io mem 0xf9dfec00
[    8.946541] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    8.946618] usb usb1: configuration #1 chosen from 1 choice
[    8.946633] hub 1-0:1.0: USB hub found
[    8.946639] hub 1-0:1.0: 10 ports detected
[    9.057663] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    9.057663] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    9.057663] usb usb1: Product: EHCI Host Controller
[    9.057663] usb usb1: Manufacturer: Linux 2.6.25-rc7 ehci_hcd
[    9.057663] usb usb1: SerialNumber: 0000:00:02.1
[    9.355067] usb 1-3: new high speed USB device using ehci_hcd and address 2
[    9.450447] usb 1-3: configuration #1 chosen from 1 choice
[    9.450649] hub 1-3:1.0: USB hub found
[    9.457951] hub 1-3:1.0: 4 ports detected
[    9.575226] usb 1-3: New USB device found, idVendor=05e3, idProduct=0608
[    9.575228] usb 1-3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    9.575230] usb 1-3: Product: USB2.0 Hub
[    9.611453] Adding 1951888k swap on /dev/sda2.  Priority:-1 extents:1 across:1951888k
[    9.774119] usb 1-3.1: new low speed USB device using ehci_hcd and address 3
[    9.877429] usb 1-3.1: configuration #1 chosen from 1 choice
[    9.894606] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:02.1/usb1/1-3/1-3.1/1-3.1:1.0/input/input3
[   10.307344] input: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:02.1-3.1
[   10.314064] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:02.1/usb1/1-3/1-3.1/1-3.1:1.1/input/input4
[   10.390680] input: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:02.1-3.1
[   10.390712] usb 1-3.1: New USB device found, idVendor=046d, idProduct=c518
[   10.390714] usb 1-3.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   10.390716] usb 1-3.1: Product: USB Receiver
[   10.390717] usb 1-3.1: Manufacturer: Logitech
[   10.434028] mice: PS/2 mouse device common for all mice
[   13.292848] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 18
[   13.292848] ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [LNKB] -> GSI 18 (level, low) -> IRQ 18
[   13.294716] Audigy2 value: Special config.
[   15.801564] w83627ehf: Found W83627EHG chip at 0x290
[   17.536775] r8169: eth0: link up
[   17.536781] r8169: eth0: link up
[   18.784515] NET: Registered protocol family 17

--Boundary-00=_8386HsjcnVuI372
Content-Type: text/plain;
  charset="iso-8859-1";
  name="dmesg_2.6.25_rc7_non_raid"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg_2.6.25_rc7_non_raid"

[    0.000000] Linux version 2.6.25-rc7 (root@energy) (gcc version 4.2.3 (Gentoo 4.2.3 p1.0)) #3 SMP Thu Mar 27 17:12:28 CET 2008
[    0.000000] Command line: root=/dev/sda3 nmi_watchdog=0 console=tty6
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cffb0000 (usable)
[    0.000000]  BIOS-e820: 00000000cffb0000 - 00000000cffc0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cffc0000 - 00000000cfff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfff0000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff380000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 used
[    0.000000] end_pfn_map = 1245184
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F98E0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT CFFB0000, 003C (r1 A M I  OEMRSDT  12000731 MSFT       97)
[    0.000000] ACPI: FACP CFFB0200, 0084 (r2 A_M_I  OEMFACP  12000601 MSFT       97)
[    0.000000] ACPI: DSDT CFFB0450, 4FFA (r1  ASR19 ASR19186      186 INTL 20051117)
[    0.000000] ACPI: FACS CFFC0000, 0040
[    0.000000] ACPI: APIC CFFB0390, 0080 (r1 A M I  OEMAPIC  12000731 MSFT       97)
[    0.000000] ACPI: MCFG CFFB0410, 003C (r1 A M I  OEMMCFG  12000731 MSFT       97)
[    0.000000] ACPI: OEMB CFFC0040, 0060 (r1 A M I  AMI_OEM  12000731 MSFT       97)
[    0.000000] ACPI: HPET CFFB5450, 0038 (r1 A M I  OEMHPET0 12000731 MSFT       97)
[    0.000000] ACPI: SSDT CFFB5490, 030E (r1 A M I  POWERNOW        1 AMD         1)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 used
[    0.000000] early res: 0 [0-fff] BIOS data page
[    0.000000] early res: 1 [6000-7fff] SMP_TRAMPOLINE
[    0.000000] early res: 2 [200000-546193] TEXT DATA BSS
[    0.000000] early res: 3 [9fc00-a0bff] EBDA
[    0.000000] early res: 4 [8000-dfff] PGTABLE
[    0.000000] No mptable found.
[    0.000000]  [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
[    0.000000]  [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
[    0.000000]  [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
[    0.000000]  [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
[    0.000000]  [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0
[    0.000000]  [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0
[    0.000000]  [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on node 0
[    0.000000]  [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002e00000 on node 0
[    0.000000]  [ffffe20001000000-ffffe200011fffff] PMD ->ffff810003200000 on node 0
[    0.000000]  [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003600000 on node 0
[    0.000000]  [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003a00000 on node 0
[    0.000000]  [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003e00000 on node 0
[    0.000000]  [ffffe20001800000-ffffe200019fffff] PMD ->ffff810004200000 on node 0
[    0.000000]  [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff810004600000 on node 0
[    0.000000]  [ffffe20001c00000-ffffe20001dfffff] PMD ->ffff810004a00000 on node 0
[    0.000000]  [ffffe20001e00000-ffffe20001ffffff] PMD ->ffff810004e00000 on node 0
[    0.000000]  [ffffe20002000000-ffffe200021fffff] PMD ->ffff810005200000 on node 0
[    0.000000]  [ffffe20002200000-ffffe200023fffff] PMD ->ffff810005600000 on node 0
[    0.000000]  [ffffe20002400000-ffffe200025fffff] PMD ->ffff810005a00000 on node 0
[    0.000000]  [ffffe20002600000-ffffe200027fffff] PMD ->ffff810005e00000 on node 0
[    0.000000]  [ffffe20002800000-ffffe200029fffff] PMD ->ffff810006200000 on node 0
[    0.000000]  [ffffe20002a00000-ffffe20002bfffff] PMD ->ffff810006600000 on node 0
[    0.000000]  [ffffe20002c00000-ffffe20002dfffff] PMD ->ffff810006a00000 on node 0
[    0.000000]  [ffffe20002e00000-ffffe20002ffffff] PMD ->ffff810006e00000 on node 0
[    0.000000]  [ffffe20003000000-ffffe200031fffff] PMD ->ffff810007200000 on node 0
[    0.000000]  [ffffe20003200000-ffffe200033fffff] PMD ->ffff810007600000 on node 0
[    0.000000]  [ffffe20003400000-ffffe200035fffff] PMD ->ffff810007a00000 on node 0
[    0.000000]  [ffffe20003600000-ffffe200037fffff] PMD ->ffff810007e00000 on node 0
[    0.000000]  [ffffe20003800000-ffffe200039fffff] PMD ->ffff810008200000 on node 0
[    0.000000]  [ffffe20003a00000-ffffe20003bfffff] PMD ->ffff810008600000 on node 0
[    0.000000]  [ffffe20003c00000-ffffe20003dfffff] PMD ->ffff810008a00000 on node 0
[    0.000000]  [ffffe20003e00000-ffffe20003ffffff] PMD ->ffff810008e00000 on node 0
[    0.000000]  [ffffe20004000000-ffffe200041fffff] PMD ->ffff810009200000 on node 0
[    0.000000]  [ffffe20004200000-ffffe200043fffff] PMD ->ffff810009600000 on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1245184
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   851888
[    0.000000]     0:  1048576 ->  1245184
[    0.000000] On node 0 totalpages: 1048399
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 848 pages reserved
[    0.000000]   DMA zone: 3095 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833512 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x2008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e6000
[    0.000000] PM: Registered nosave memory: 00000000000e6000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cffb0000 - 00000000cffc0000
[    0.000000] PM: Registered nosave memory: 00000000cffc0000 - 00000000cfff0000
[    0.000000] PM: Registered nosave memory: 00000000cfff0000 - 00000000d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fef00000
[    0.000000] PM: Registered nosave memory: 00000000fef00000 - 00000000ff380000
[    0.000000] PM: Registered nosave memory: 00000000ff380000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at d4000000 (gap: d0000000:2ec00000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 32584 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1030527
[    0.000000] Kernel command line: root=/dev/sda3 nmi_watchdog=0 console=tty6
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] TSC calibrated against PM_TIMER
[    0.000001] Marking TSC unstable due to TSCs unsynchronized
[    0.000002] time.c: Detected 3013.892 MHz processor.
[    0.000011] spurious 8259A interrupt: IRQ7.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty6] enabled
[    0.003333] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.003333] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.003333] Checking aperture...
[    0.003333] Node 0: aperture @ c000000 size 32 MB
[    0.003333] Aperture pointing to e820 RAM. Ignoring.
[    0.003333] No AGP bridge found
[    0.003333] Your BIOS doesn't leave a aperture memory hole
[    0.003333] Please enable the IOMMU option in the BIOS setup
[    0.003333] This costs you 64 MB of RAM
[    0.003333] Mapping aperture over 65536 KB of RAM @ c000000
[    0.003333] PM: Registered nosave memory: 000000000c000000 - 0000000010000000
[    0.003333] Memory: 4047784k/4980736k available (1978k kernel code, 145104k reserved, 856k data, 192k init)
[    0.003333] CPA: page pool initialized 1 of 1 pages preallocated
[    0.003333] SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
[    0.003333] hpet clockevent registered
[    0.083330] Calibrating delay using timer specific routine.. 6034.71 BogoMIPS (lpj=10053948)
[    0.083419] Mount-cache hash table entries: 256
[    0.083538] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.083577] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.083615] CPU: Physical Processor ID: 0
[    0.083652] CPU: Processor Core ID: 0
[    0.083700] ACPI: Core revision 20070126
[    0.122294] Using local APIC timer interrupts.
[    0.123326] APIC timer calibration result 12557885
[    0.123327] Detected 12.557 MHz APIC timer.
[    0.123430] Booting processor 1/2 APIC 0x1
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 6030.96 BogoMIPS (lpj=10046343)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.003333] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
[    0.216841] Brought up 2 CPUs
[    0.217286] net_namespace: 296 bytes
[    0.217401] NET: Registered protocol family 16
[    0.217495] No dock devices found.
[    0.217558] ACPI: bus type pci registered
[    0.217637] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
[    0.217676] PCI: Not using MMCONFIG.
[    0.217712] PCI: Using configuration type 1
[    0.220688] ACPI: EC: Look up EC in DSDT
[    0.224821] ACPI: Interpreter enabled
[    0.224858] ACPI: (supports S0 S1 S3 S4 S5)
[    0.225029] ACPI: Using IOAPIC for interrupt routing
[    0.225199] ACPI: Error attaching device data
[    0.225238] ACPI: Error attaching device data
[    0.225278] ACPI: Error attaching device data
[    0.225317] ACPI: Error attaching device data
[    0.233318] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.233318] PCI: Transparent bridge - 0000:00:08.0
[    0.233318] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.233318] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.233318] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[    0.233318] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[    0.233318] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
[    0.233318] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[    0.236692] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *11
[    0.237049] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *5
[    0.237403] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, disabled.
[    0.237782] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disabled.
[    0.238162] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, disabled.
[    0.238541] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[    0.238895] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, disabled.
[    0.239274] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *10
[    0.239628] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *5
[    0.239991] ACPI: PCI Interrupt Link [LMAD] (IRQs 20 21 22 23) *0, disabled.
[    0.240371] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *7
[    0.240724] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, disabled.
[    0.241103] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *0, disabled.
[    0.241483] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[    0.241837] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *0, disabled.
[    0.242217] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *15
[    0.242570] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *0, disabled.
[    0.242975] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, disabled.
[    0.243364] ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *0, disabled.
[    0.243745] ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *0, disabled.
[    0.244072] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.244120] pnp: PnP ACPI init
[    0.244159] ACPI: bus type pnp registered
[    0.247240] pnp: PnP ACPI: found 13 devices
[    0.247278] ACPI: ACPI bus type pnp unregistered
[    0.247384] SCSI subsystem initialized
[    0.247458] libata version 3.00 loaded.
[    0.247497] usbcore: registered new interface driver usbfs
[    0.247547] usbcore: registered new interface driver hub
[    0.247602] usbcore: registered new device driver usb
[    0.247683] PCI: Using ACPI for IRQ routing
[    0.247720] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    0.266663] PCI-DMA: Disabling AGP.
[    0.266663] PCI-DMA: aperture base @ c000000 size 65536 KB
[    0.266663] PCI-DMA: using GART IOMMU.
[    0.266663] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.266663] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    0.266663] hpet0: 3 32-bit timers, 25000000 Hz
[    0.266672] Switched to high resolution mode on CPU 0
[    0.056669] Switched to high resolution mode on CPU 1
[    0.280029] system 00:05: ioport range 0x4d0-0x4d1 has been reserved
[    0.280029] system 00:05: ioport range 0x800-0x80f has been reserved
[    0.280029] system 00:05: ioport range 0x2000-0x207f has been reserved
[    0.280029] system 00:05: ioport range 0x2080-0x20ff has been reserved
[    0.280029] system 00:05: ioport range 0x2400-0x247f has been reserved
[    0.280029] system 00:05: ioport range 0x2480-0x24ff has been reserved
[    0.280029] system 00:05: ioport range 0x2800-0x287f has been reserved
[    0.280029] system 00:05: ioport range 0x2880-0x28ff has been reserved
[    0.280029] system 00:05: ioport range 0x2c00-0x2c7f has been reserved
[    0.280029] system 00:05: ioport range 0x2c80-0x2cff has been reserved
[    0.280029] system 00:05: iomem range 0x0-0x0 could not be reserved
[    0.280032] system 00:05: iomem range 0xfee01000-0xfeefffff has been reserved
[    0.280079] system 00:07: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.280127] system 00:07: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.280178] system 00:0a: ioport range 0x290-0x29f has been reserved
[    0.280221] system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
[    0.280264] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.280303] system 00:0c: iomem range 0xc0000-0xcffff has been reserved
[    0.280343] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[    0.280388] system 00:0c: iomem range 0x100000-0xcfffffff could not be reserved
[    0.280435] system 00:0c: iomem range 0xff380000-0xffffffff could not be reserved
[    0.280892] PCI: Bridge: 0000:00:08.0
[    0.280929]   IO window: d000-dfff
[    0.280966]   MEM window: 0xf9f00000-0xf9ffffff
[    0.281004]   PREFETCH window: disabled.
[    0.281043] PCI: Bridge: 0000:00:0b.0
[    0.281079]   IO window: c000-cfff
[    0.281116]   MEM window: 0xf9e00000-0xf9efffff
[    0.281153]   PREFETCH window: disabled.
[    0.281191] PCI: Bridge: 0000:00:0c.0
[    0.281227]   IO window: disabled.
[    0.281264]   MEM window: disabled.
[    0.281300]   PREFETCH window: disabled.
[    0.281338] PCI: Bridge: 0000:00:0d.0
[    0.281374]   IO window: e000-efff
[    0.281411]   MEM window: 0xfa000000-0xfebfffff
[    0.281449]   PREFETCH window: 0x00000000d0000000-0x00000000dfffffff
[    0.281488] PCI: Bridge: 0000:00:0e.0
[    0.281525]   IO window: disabled.
[    0.281561]   MEM window: disabled.
[    0.281598]   PREFETCH window: disabled.
[    0.281641] PCI: Setting latency timer of device 0000:00:08.0 to 64
[    0.281650] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    0.281655] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    0.281660] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    0.281665] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    0.281671] NET: Registered protocol family 2
[    0.316693] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.316693] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.316693] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.316693] TCP: Hash tables configured (established 262144 bind 65536)
[    0.316693] TCP reno registered
[    0.326990] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    0.326990] io scheduler noop registered
[    0.326990] io scheduler cfq registered (default)
[    0.326990] pci 0000:00:00.0: Enabling HT MSI Mapping
[    0.326990] pci 0000:00:08.0: Enabling HT MSI Mapping
[    0.326990] pci 0000:00:0a.0: Enabling HT MSI Mapping
[    0.326990] pci 0000:00:0b.0: Enabling HT MSI Mapping
[    0.326990] pci 0000:00:0c.0: Enabling HT MSI Mapping
[    0.326990] pci 0000:00:0d.0: Enabling HT MSI Mapping
[    0.326990] pci 0000:00:0e.0: Enabling HT MSI Mapping
[    0.326990] pci 0000:04:00.0: Boot video device
[    0.326998] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    0.326998] assign_interrupt_mode Found MSI capability
[    0.326998] Allocate Port Service[0000:00:0b.0:pcie00]
[    0.327005] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    0.327005] assign_interrupt_mode Found MSI capability
[    0.327005] Allocate Port Service[0000:00:0c.0:pcie00]
[    0.327011] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    0.327011] assign_interrupt_mode Found MSI capability
[    0.327011] Allocate Port Service[0000:00:0d.0:pcie00]
[    0.327017] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    0.327017] assign_interrupt_mode Found MSI capability
[    0.327017] Allocate Port Service[0000:00:0e.0:pcie00]
[    0.327055] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.327055] ACPI: Power Button (FF) [PWRF]
[    0.327061] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.327061] ACPI: Power Button (CM) [PWRB]
[    0.327092] ACPI: ACPI0007:00 is registered as cooling_device0
[    0.327099] ACPI: ACPI0007:01 is registered as cooling_device1
[    0.360462] Real Time Clock Driver v1.12ac
[    0.360466] hpet_resources: 0xfed00000 is busy
[    0.360473] Linux agpgart interface v0.103
[    0.360492] Driver 'sd' needs updating - please use bus_type methods
[    0.360498] ahci 0000:00:0a.0: version 3.0
[    0.360498] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[    0.360498] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23 (level, low) -> IRQ 23
[    1.363826] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl IDE mode
[    1.363826] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio 
[    1.363826] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[    1.363828] scsi0 : ahci
[    1.363836] scsi1 : ahci
[    1.363844] scsi2 : ahci
[    1.363851] scsi3 : ahci
[    1.363857] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc100 irq 315
[    1.363857] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc180 irq 315
[    1.363857] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc200 irq 315
[    1.363857] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc280 irq 315
[    1.794371] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.794871] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[    1.794871] ata1.00: 312581808 sectors, multi 16: LBA48 
[    1.795403] ata1.00: configured for UDMA/133
[    2.427327] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.447811] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[    2.447811] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.449717] ata2.00: configured for UDMA/133
[    2.766980] ata3: SATA link down (SStatus 0 SControl 300)
[    3.086847] ata4: SATA link down (SStatus 0 SControl 300)
[    3.290513] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10.0 PQ: 0 ANSI: 5
[    3.290525] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[    3.290525] sd 0:0:0:0: [sda] Write Protect is off
[    3.290525] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.290525] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.290525] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[    3.290525] sd 0:0:0:0: [sda] Write Protect is off
[    3.290525] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.290525] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.290525]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    3.123110] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.123121] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
[    3.123131] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[    3.123131] sd 1:0:0:0: [sdb] Write Protect is off
[    3.123131] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.123131] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.123131] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[    3.123131] sd 1:0:0:0: [sdb] Write Protect is off
[    3.123131] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.123131] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.123131]  sdb: sdb1 sdb2
[    3.127056] sd 1:0:0:0: [sdb] Attached SCSI disk
[    3.127075] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    3.127908] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.127950] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.170517] usbcore: registered new interface driver usbhid
[    3.170517] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[    3.170517] TCP cubic registered
[    3.170517] NET: Registered protocol family 1
[    3.170521] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ processors (2 cpu cores) (version 2.20.00)
[    3.371502] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x6
[    3.371502] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0x8
[    3.371502] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xa
[    3.371502] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xc
[    3.371502] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0xe
[    3.371502] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
[    3.371502] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
[    3.371502] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[    3.200878] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    3.299367] ReiserFS: sda3: found reiserfs format "3.6" with standard journal
[    3.299367] ReiserFS: sda3: using ordered data mode
[    3.310974] ReiserFS: sda3: journal params: device sda3, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[    3.310974] ReiserFS: sda3: checking transaction log (sda3)
[    3.356310] ReiserFS: sda3: Using r5 hash to sort names
[    3.356310] VFS: Mounted root (reiserfs filesystem) readonly.
[    3.356310] Freeing unused kernel memory: 192k freed
[    4.194202] Clocksource tsc unstable (delta = -248646934 ns)
[    8.519617] ReiserFS: sda3: switching to journaled data mode
[    8.855926] r8169 Gigabit Ethernet driver 2.2LK loaded
[    8.855941] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 19
[    8.855946] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNEB] -> GSI 19 (level, low) -> IRQ 19
[    8.855955] PCI: Setting latency timer of device 0000:01:00.0 to 64
[    8.856327] eth0: RTL8168b/8111b at 0xffffc20000170000, 00:19:66:47:f3:cb, XID 38000000 IRQ 314
[    8.901477] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
[    8.901483] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 22 (level, low) -> IRQ 22
[    8.901490] PCI: Setting latency timer of device 0000:00:02.1 to 64
[    8.901492] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    8.901566] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
[    8.901588] ehci_hcd 0000:00:02.1: debug port 1
[    8.901591] PCI: cache line size of 64 is not supported by device 0000:00:02.1
[    8.901598] ehci_hcd 0000:00:02.1: irq 22, io mem 0xf9dfec00
[    8.914115] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    8.914194] usb usb1: configuration #1 chosen from 1 choice
[    8.914210] hub 1-0:1.0: USB hub found
[    8.914216] hub 1-0:1.0: 10 ports detected
[    9.024962] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    9.024962] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    9.024962] usb usb1: Product: EHCI Host Controller
[    9.024962] usb usb1: Manufacturer: Linux 2.6.25-rc7 ehci_hcd
[    9.024962] usb usb1: SerialNumber: 0000:00:02.1
[    9.310790] usb 1-3: new high speed USB device using ehci_hcd and address 2
[    9.412640] usb 1-3: configuration #1 chosen from 1 choice
[    9.412928] hub 1-3:1.0: USB hub found
[    9.413043] hub 1-3:1.0: 4 ports detected
[    9.532594] usb 1-3: New USB device found, idVendor=05e3, idProduct=0608
[    9.532596] usb 1-3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    9.532598] usb 1-3: Product: USB2.0 Hub
[    9.578589] Adding 1951888k swap on /dev/sda2.  Priority:-1 extents:1 across:1951888k
[    9.737370] usb 1-3.1: new low speed USB device using ehci_hcd and address 3
[    9.830710] usb 1-3.1: configuration #1 chosen from 1 choice
[    9.847857] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:02.1/usb1/1-3/1-3.1/1-3.1:1.0/input/input3
[   10.250586] input: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:02.1-3.1
[   10.257338] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:02.1/usb1/1-3/1-3.1/1-3.1:1.1/input/input4
[   10.329771] input: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:02.1-3.1
[   10.329805] usb 1-3.1: New USB device found, idVendor=046d, idProduct=c518
[   10.329807] usb 1-3.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   10.329808] usb 1-3.1: Product: USB Receiver
[   10.329810] usb 1-3.1: Manufacturer: Logitech
[   10.413530] mice: PS/2 mouse device common for all mice
[   13.678751] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 18
[   13.678757] ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [LNKB] -> GSI 18 (level, low) -> IRQ 18
[   13.682071] Audigy2 value: Special config.
[   17.567723] w83627ehf: Found W83627EHG chip at 0x290
[   18.825463] r8169: eth0: link up
[   18.866514] r8169: eth0: link up
[   20.054043] NET: Registered protocol family 17

--Boundary-00=_8386HsjcnVuI372
Content-Type: text/plain;
  charset="iso-8859-1";
  name=".config"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=".config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.25-rc7
# Thu Mar 27 17:08:31 2008
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
# CONFIG_GENERIC_LOCKBREAK is not set
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
# CONFIG_GENERIC_GPIO is not set
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_AOUT=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_64_SMP=y
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
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=16
# CONFIG_CGROUPS is not set
# CONFIG_GROUP_SCHED is not set
# CONFIG_SYSFS_DEPRECATED_V2 is not set
# CONFIG_RELAY is not set
# CONFIG_NAMESPACES is not set
# CONFIG_BLK_DEV_INITRD is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_EMBEDDED=y
# CONFIG_UID16 is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
# CONFIG_COMPAT_BRK is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_SLUB_DEBUG is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
# CONFIG_MARKERS is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_BLK_DEV_BSG=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_CLASSIC_RCU=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_VSMP is not set
# CONFIG_PARAVIRT_GUEST is not set
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
CONFIG_MK8=y
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_IOMMU_HELPER=y
CONFIG_SWIOTLB=y
CONFIG_NR_CPUS=2
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
# CONFIG_SPARSEMEM_STATIC is not set
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y

#
# Memory hotplug is currently incompatible with Software Suspend
#
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MTRR=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x200000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_PM=y
# CONFIG_PM_LEGACY is not set
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
# CONFIG_ACPI_BAY is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_X86_POWERNOW_K8=y
CONFIG_X86_POWERNOW_K8_ACPI=y
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
# CONFIG_X86_SPEEDSTEP_LIB is not set
# CONFIG_CPU_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_DMAR is not set
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_BINFMT_MISC=m
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=m
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_LRO is not set
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
CONFIG_VLAN_8021Q=m
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_NET_SCHED is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
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
# CONFIG_BT_HCIUSB is not set
# CONFIG_BT_HCIBTUSB is not set
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_LL=y
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
CONFIG_BT_HCIVHCI=m
# CONFIG_AF_RXRPC is not set

#
# Wireless
#
# CONFIG_CFG80211 is not set
# CONFIG_WIRELESS_EXT is not set
# CONFIG_MAC80211 is not set
# CONFIG_IEEE80211 is not set
# CONFIG_RFKILL is not set
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
CONFIG_FW_LOADER=m
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=16
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=m
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=m
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SVW is not set
# CONFIG_ATA_PIIX is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
# CONFIG_PATA_PLATFORM is not set
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_NETDEVICES_MULTIQUEUE is not set
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_E1000E_ENABLED is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_R8169=m
# CONFIG_R8169_NAPI is not set
CONFIG_R8169_VLAN=y
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_SK98LIN is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=m
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1680
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=1050
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set
CONFIG_FIX_EARLYCON_MEM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=m
CONFIG_RTC=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
# CONFIG_HPET_RTC_IRQ is not set
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
# CONFIG_I2C_ALGOPCF is not set
# CONFIG_I2C_ALGOPCA is not set

#
# I2C Hardware Bus support
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=m
# CONFIG_I2C_AMD756_S4882 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_I810 is not set
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=m
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_PROSAVAGE is not set
# CONFIG_I2C_SAVAGE4 is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_TINY_USB is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set
# CONFIG_I2C_VOODOO3 is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
CONFIG_SENSORS_EEPROM=m
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_TPS65010 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7473 is not set
CONFIG_SENSORS_K8TEMP=m
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX6650=m
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
# CONFIG_WATCHDOG is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_TVP5150=m
# CONFIG_VIDEO_VIVI is not set
# CONFIG_VIDEO_BT848 is not set
# CONFIG_VIDEO_CPIA is not set
# CONFIG_VIDEO_CPIA2 is not set
# CONFIG_VIDEO_SAA5246A is not set
# CONFIG_VIDEO_SAA5249 is not set
# CONFIG_TUNER_3036 is not set
# CONFIG_VIDEO_STRADIS is not set
# CONFIG_VIDEO_ZORAN is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_DPC is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_CX88 is not set
# CONFIG_VIDEO_CX23885 is not set
# CONFIG_VIDEO_IVTV is not set
# CONFIG_VIDEO_CAFE_CCIC is not set
CONFIG_V4L_USB_DRIVERS=y
# CONFIG_VIDEO_PVRUSB2 is not set
CONFIG_VIDEO_EM28XX=m
CONFIG_VIDEO_EM28XX_ALSA=m
# CONFIG_VIDEO_USBVISION is not set
# CONFIG_USB_VICAM is not set
# CONFIG_USB_IBMCAM is not set
# CONFIG_USB_KONICAWC is not set
# CONFIG_USB_QUICKCAM_MESSENGER is not set
# CONFIG_USB_ET61X251 is not set
# CONFIG_VIDEO_OVCAMCHIP is not set
# CONFIG_USB_W9968CF is not set
# CONFIG_USB_OV511 is not set
# CONFIG_USB_SE401 is not set
# CONFIG_USB_SN9C102 is not set
# CONFIG_USB_STV680 is not set
# CONFIG_USB_ZC0301 is not set
# CONFIG_USB_PWC is not set
# CONFIG_USB_ZR364XX is not set
# CONFIG_USB_STKWEBCAM is not set
# CONFIG_RADIO_ADAPTERS is not set
CONFIG_DVB_CORE=m
CONFIG_DVB_CORE_ATTACH=y
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#
# CONFIG_TTPCI_EEPROM is not set
# CONFIG_DVB_AV7110 is not set
# CONFIG_DVB_BUDGET_CORE is not set

#
# Supported USB Adapters
#
# CONFIG_DVB_USB is not set
# CONFIG_DVB_TTUSB_BUDGET is not set
# CONFIG_DVB_TTUSB_DEC is not set
# CONFIG_DVB_CINERGYT2 is not set

#
# Supported FlexCopII (B2C2) Adapters
#
# CONFIG_DVB_B2C2_FLEXCOP is not set

#
# Supported BT878 Adapters
#

#
# Supported Pluto2 Adapters
#
# CONFIG_DVB_PLUTO2 is not set

#
# Supported DVB Frontends
#

#
# Customise DVB Frontends
#
# CONFIG_DVB_FE_CUSTOMISE is not set

#
# DVB-S (satellite) frontends
#
# CONFIG_DVB_STV0299 is not set
# CONFIG_DVB_CX24110 is not set
# CONFIG_DVB_CX24123 is not set
# CONFIG_DVB_TDA8083 is not set
# CONFIG_DVB_MT312 is not set
# CONFIG_DVB_VES1X93 is not set
# CONFIG_DVB_S5H1420 is not set
# CONFIG_DVB_TDA10086 is not set

#
# DVB-T (terrestrial) frontends
#
# CONFIG_DVB_SP8870 is not set
# CONFIG_DVB_SP887X is not set
# CONFIG_DVB_CX22700 is not set
# CONFIG_DVB_CX22702 is not set
# CONFIG_DVB_L64781 is not set
# CONFIG_DVB_TDA1004X is not set
# CONFIG_DVB_NXT6000 is not set
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
# CONFIG_DVB_DIB3000MB is not set
# CONFIG_DVB_DIB3000MC is not set
# CONFIG_DVB_DIB7000M is not set
# CONFIG_DVB_DIB7000P is not set

#
# DVB-C (cable) frontends
#
# CONFIG_DVB_VES1820 is not set
# CONFIG_DVB_TDA10021 is not set
# CONFIG_DVB_TDA10023 is not set
# CONFIG_DVB_STV0297 is not set

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
# CONFIG_DVB_NXT200X is not set
# CONFIG_DVB_OR51211 is not set
# CONFIG_DVB_OR51132 is not set
# CONFIG_DVB_BCM3510 is not set
# CONFIG_DVB_LGDT330X is not set
# CONFIG_DVB_S5H1409 is not set

#
# Tuners/PLL support
#
# CONFIG_DVB_PLL is not set
# CONFIG_DVB_TDA826X is not set
CONFIG_DVB_TDA827X=m
CONFIG_DVB_TDA18271=m
# CONFIG_DVB_TUNER_QT1010 is not set
# CONFIG_DVB_TUNER_MT2060 is not set
# CONFIG_DVB_TUNER_MT2266 is not set
# CONFIG_DVB_TUNER_MT2131 is not set
# CONFIG_DVB_TUNER_DIB0070 is not set
CONFIG_DVB_TUNER_XC5000=m

#
# Miscellaneous devices
#
# CONFIG_DVB_LNBP21 is not set
# CONFIG_DVB_ISL6421 is not set
# CONFIG_DVB_TUA6100 is not set
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_TUNER_CUSTOMIZE=y
CONFIG_TUNER_XC2028=m
CONFIG_TUNER_MT20XX=m
CONFIG_TUNER_TDA8290=m
CONFIG_TUNER_TEA5761=m
CONFIG_TUNER_TEA5767=m
CONFIG_TUNER_SIMPLE=m
CONFIG_TUNER_TDA9887=m
CONFIG_VIDEO_IR_I2C=m
CONFIG_VIDEO_IR=m
CONFIG_VIDEO_TVEEPROM=m
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_VIDEO_SELECT=y
CONFIG_DUMMY_CONSOLE=y

#
# Sound
#
CONFIG_SOUND=m

#
# Advanced Linux Sound Architecture
#
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
# CONFIG_SND_PCM_OSS_PLUGINS is not set
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_RTCTIMER=m
CONFIG_SND_SEQ_RTCTIMER_DEFAULT=y
# CONFIG_SND_DYNAMIC_MINORS is not set
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set

#
# Generic devices
#
CONFIG_SND_MPU401_UART=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DUMMY=m
CONFIG_SND_VIRMIDI=m
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=m

#
# PCI devices
#
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
CONFIG_SND_EMU10K1=m
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0

#
# USB devices
#
CONFIG_SND_USB_AUDIO=m
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set

#
# System on Chip audio support
#
# CONFIG_SND_SOC is not set

#
# SoC Audio support for SuperH
#

#
# ALSA SoC audio for Freescale SOCs
#

#
# Open Sound System
#
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
# CONFIG_HID_FF is not set
# CONFIG_USB_HIDDEV is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_PERSIST is not set
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_DPCM is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_MON is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_AUERSWALD is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_GADGET is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set

#
# Userspace I/O
#
# CONFIG_UIO is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y

#
# File systems
#
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4DEV_FS is not set
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
# CONFIG_FS_POSIX_ACL is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

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
CONFIG_FAT_DEFAULT_CODEPAGE=850
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-15"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=m

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=m
CONFIG_NLS_DEFAULT="iso8859-15"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=m
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=m
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_KERNEL is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_BUGVERBOSE is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_SAMPLES is not set
CONFIG_EARLY_PRINTK=y
CONFIG_X86_MPPARSE=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=m
# CONFIG_CRYPTO_SEQIV is not set
# CONFIG_CRYPTO_MANAGER is not set
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_ECB is not set
# CONFIG_CRYPTO_CBC is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_XTS is not set
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_CRYPTD is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_AES is not set
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_TEST is not set
# CONFIG_CRYPTO_AUTHENC is not set
CONFIG_CRYPTO_LZO=m
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
# CONFIG_KVM_INTEL is not set
CONFIG_KVM_AMD=m
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=m
CONFIG_LZO_COMPRESS=m
CONFIG_LZO_DECOMPRESS=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

--Boundary-00=_8386HsjcnVuI372--
