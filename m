Return-Path: <linux-kernel-owner+w=401wt.eu-S1758976AbXJaP6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976AbXJaP6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 11:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756115AbXJaP5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 11:57:51 -0400
Received: from empbedex1.empirix.com ([12.38.203.54]:43353 "EHLO
	empbedex1.empirix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799AbXJaP5t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 11:57:49 -0400
X-Greylist: delayed 972 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Oct 2007 11:57:49 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Other Problems with Marvell Driver - 7042 (2.6.23)...
Date: Wed, 31 Oct 2007 11:41:36 -0400
Message-ID: <BD261180E6D35F4D9D32F3E44FD3D9010A7E1B45@EMPBEDEX.empirix.com>
In-Reply-To: <45ED682A.9040408@garzik.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Other Problems with Marvell Driver - 7042 (2.6.23)...
Thread-Index: Acdf8XwRJz8pdbU2TR6ASMix7kLNXS712AzQ
References: <BD261180E6D35F4D9D32F3E44FD3D901053E84BD@EMPBEDEX.empirix.com> <45ED682A.9040408@garzik.org>
From: "Morrison, Tom" <tmorrison@empirix.com>
To: <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: "Jeff Garzik" <jeff@garzik.org>, "Kumar Gala" <galak@kernel.crashing.org>
X-OriginalArrivalTime: 31 Oct 2007 15:41:35.0842 (UTC) FILETIME=[84FF9C20:01C81BD4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am running the 'latest' kernel retrieved from Kumar Gala's
Powerpc git tree (mainly because I am running on a MPC8548 board) 
and it appears to be in the full 2.6.23 version while the sata_mv 
driver version seems to be 1.01. 

I have searched the archives, and there has been some discussion
of a regression in the Marvell driver, but I seem to have a 
different symptom from Olaf's (I am not running a 64bit kernel - 
and I am *not* running with large (36bit) physical and resources - 
so I wouldn't have the same type of IOMMU issues)

Below in the error output (using ATA_DEBUG) the driver sees the 
two drives (3 partitions on /dev/sda & 2 partitions on /dev/sdb)
and apparently sets up everything correctly for standard access...

But, when I try to mount a partition - it freezes up and gets I/O
errors?
Can someone give me any hints of things to try?

Thanks in advance...

Tom Morrison
Principal S/W Engineer
Empirix, Inc (www.empirix.com)
tmorrison@empirix.com
(781) 266 - 3567


====================start related initialization/error output===========

---version---

Linux version 2.6.23-gd85714d8-dirty (tmorrison@linux204.empirix.com) 
(gcc version 3.4.3 20041021 (prerelease)) #33 Wed Oct 31 11:14:34 EDT
2007

 ----bootup----

Scanning CPUs ...
Memory CAM mapping: CAM0=256Mb, CAM1=256Mb, CAM2=256Mb residual: 2304Mb
Linux version 2.6.23-gd85714d8-dirty (tmorrison@linux204.empirix.com)
(gcc version 3.4.3 20041021 (prerelease)) #32 Wed Oct 31 10:47:38 EDT
2007

---pci setup---

Adding PCI host bridge /soc8548@e0000000/pcie@a000
Found FSL PCI host bridge at 0x00000000e000a000.Firmware bus number:
0->255
 ->Hose at 0xc037d000, cfg_addr=0xfdffd000,cfg_data=0xfdffd004
PCI: MEM[0] 0xc0000000 -> 0xdfffffff
PCI: IO 0x0 -> 0xffffff
PCI memory map start 0xe000a000, size 0x1000
PCI MEM resource start 0xc0000000, size 0x20000000.
PCI IO resource start 0x00000000, size 0x01000000, phy base 0xe3000000.

---related pci probing----

PCI: Scanning bus 0000:0c
PCI: Found 0000:0c:00.0 [11ab/7042] 000100 00
PCI: Fixups for bus 0000:0c
io_base_high <ff> new base/limit <fff000/fff000>
pci_busdev_to_OF_node(12,0x0)
pci_busdev_to_OF_node(2,0x40)
pci_busdev_to_OF_node(1,0x0)
pci_busdev_to_OF_node(0,0x0)
 parent is /soc8548@e0000000/pcie@a000
 result is <NULL>
PCI: Bus scan for 0000:0c returning with max=0c

---pci probing results---

PCI: bridge rsrc dab00000..dabfffff (200), parent c2015a58
PCI:0000:0c:00.0: Resource 0: 00000000dab00000-00000000dabfffff (f=204)

=================================
<snip unrelated initialization>
=================================

--- sata_mv init ---

sata_mv 0000:0c:00.0: version 1.01
ata_host_alloc: ENTER
ata_port_alloc: ENTER
ata_port_alloc: ENTER
ata_port_alloc: ENTER
ata_port_alloc: ENTER
sata_mv 0000:0c:00.0: Applying 60X1C0 workarounds to unknown rev
mv_port_init: EDMA cfg=0x0000211f EDMA IRQ err
cause/mask=0x00000000/0xffffffff
mv_port_init: EDMA cfg=0x0000211f EDMA IRQ err
cause/mask=0x00000000/0xffffffff
mv_port_init: EDMA cfg=0x0000211f EDMA IRQ err
cause/mask=0x00000000/0xffffffff
mv_port_init: EDMA cfg=0x0000211f EDMA IRQ err
cause/mask=0x00000000/0xffffffff
mv_init_host: HC0: HC config=0x000100ff HC IRQ cause (before
clear)=0x00000000
mv_init_host: HC MAIN IRQ cause/mask=0x00000000/0x0087ffff PCI int
cause/mask=0x00000000/0x00000000
mv_dump_pci_cfg: 00: 704211ab 00100007 01000002 00000000
mv_dump_pci_cfg: 10: dab00004 00000000 00ffff01 00000000
mv_dump_pci_cfg: 20: 00000000 00000000 00000000 11ab11ab
mv_dump_pci_cfg: 30: 00000000 00000040 00000000 00000100
mv_dump_pci_cfg: 40: 00025001 00000000 00000000 00000000
mv_dump_pci_cfg: 50: 00806005 00000000 00000000 00000000
mv_dump_pci_cfg: 60: 00110010 00640081
sata_mv 0000:0c:00.0: Gen-IIE 32 slots 4 ports SCSI mode IRQ via INTx
__ata_port_freeze: ata4294967295 port frozen
__ata_port_freeze: ata4294967295 port frozen
__ata_port_freeze: ata4294967295 port frozen
__ata_port_freeze: ata4294967295 port frozen
scsi0 : sata_mv
scsi1 : sata_mv
scsi2 : sata_mv
scsi3 : sata_mv
ata1: SATA max UDMA/133 mmio m1048576@0xdab00000 port 0xdab22000 irq 18
ata2: SATA max UDMA/133 mmio m1048576@0xdab00000 port 0xdab24000 irq 18
ata3: SATA max UDMA/133 mmio m1048576@0xdab00000 port 0xdab26000 irq 18
ata4: SATA max UDMA/133 mmio m1048576@0xdab00000 port 0xdab28000 irq 18
ata_host_register: probe begin
ata_port_schedule_eh: port EH scheduled
ata_scsi_error: ENTER
ata_port_flush_task: ENTER
ata_eh_link_autopsy: ENTER
ata_eh_recover: ENTER
__ata_port_freeze: ata1 port frozen
mv_phy_reset: ENTER, port 0, mmio 0xf10a2000
mv_phy_reset: S-regs after ATA_RST: SStat 0x00000004 SErr 0x00000000
SCtrl 0x00000004
mv_phy_reset: S-regs after PHY wake: SStat 0x00000113 SErr 0x04010000
SCtrl 0x00000300
ata_dev_classify: found ATA device by sig
mv_phy_reset: EXIT
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata_eh_thaw_port: ata1 port thawed
ata_eh_revalidate_and_attach: ENTER
ata1: ata_dev_select: ENTER, device 0, wait 1
ata1: ata_dev_select: ENTER, device 0, wait 1
ata_tf_load: feat 0x0 nsect 0x0 lba 0x0 0x0 0x0
ata_tf_load: device 0xA0
ata_exec_command: ata1: cmd 0xEC
ata_hsm_move: ata1: protocol 2 task_state 2 (dev_stat 0x58)
ata_pio_sector: data read
ata_hsm_move: ata1: protocol 2 task_state 3 (dev_stat 0x50)
ata_hsm_move: ata1: dev 0 command complete, drv_stat 0x50
ata_port_flush_task: ENTER
ata1: ata_dev_select: ENTER, device 0, wait 1
ata_tf_load: hob: feat 0x0 nsect 0x0, lba 0x0 0x0 0x0
ata_tf_load: feat 0x0 nsect 0x0 lba 0x0 0x0 0x0
ata_tf_load: device 0xE0
ata_exec_command: ata1: cmd 0x27
ata_hsm_move: ata1: protocol 1 task_state 3 (dev_stat 0x50)
ata_hsm_move: ata1: dev 0 command complete, drv_stat 0x50
ata_port_flush_task: ENTER
ata_dump_id: 49==0x2f00  53==0x0007  63==0x0007  64==0x0003  75==0x001f
ata_dump_id: 80==0x00fe  81==0x0000  82==0x346b  83==0x7d09  84==0x5923
ata_dump_id: 88==0x407f  93==0x0000
ata1.00: ATA-7: ST3250820NS, 3.AEE, max UDMA/133
ata1.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata_dev_set_xfermode: set features - xfer mode
ata1: ata_dev_select: ENTER, device 0, wait 1
ata_tf_load: feat 0x3 nsect 0x46 lba 0x0 0x0 0x0
ata_tf_load: device 0xA0
ata_exec_command: ata1: cmd 0xEF
ata_hsm_move: ata1: protocol 1 task_state 3 (dev_stat 0x50)
ata_hsm_move: ata1: dev 0 command complete, drv_stat 0x50
ata_port_flush_task: ENTER
ata_dev_set_xfermode: EXIT, err_mask=0
ata1: ata_dev_select: ENTER, device 0, wait 1
ata1: ata_dev_select: ENTER, device 0, wait 1
ata_tf_load: feat 0x0 nsect 0x0 lba 0x0 0x0 0x0
ata_tf_load: device 0xA0
ata_exec_command: ata1: cmd 0xEC
ata_hsm_move: ata1: protocol 2 task_state 2 (dev_stat 0x58)
ata_pio_sector: data read
ata_hsm_move: ata1: protocol 2 task_state 3 (dev_stat 0x50)
ata_hsm_move: ata1: dev 0 command complete, drv_stat 0x50
ata_port_flush_task: ENTER
ata1: ata_dev_select: ENTER, device 0, wait 1
ata_tf_load: hob: feat 0x0 nsect 0x0, lba 0x0 0x0 0x0
ata_tf_load: feat 0x0 nsect 0x0 lba 0x0 0x0 0x0
ata_tf_load: device 0xE0
ata_exec_command: ata1: cmd 0x27
ata_hsm_move: ata1: protocol 1 task_state 3 (dev_stat 0x50)
ata_hsm_move: ata1: dev 0 command complete, drv_stat 0x50
ata_port_flush_task: ENTER
ata_dump_id: 49==0x2f00  53==0x0007  63==0x0007  64==0x0003  75==0x001f
ata_dump_id: 80==0x00fe  81==0x0000  82==0x346b  83==0x7d09  84==0x5923
ata_dump_id: 88==0x407f  93==0x0000
ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
ata1.00: configured for UDMA/133
ata_eh_recover: EXIT, rc=0
ata_scsi_error: EXIT
ata_port_schedule_eh: port EH scheduled
ata_scsi_error: ENTER
ata_port_flush_task: ENTER
ata_eh_link_autopsy: ENTER
ata_eh_recover: ENTER
__ata_port_freeze: ata2 port frozen
mv_phy_reset: ENTER, port 1, mmio 0xf10a4000
mv_phy_reset: S-regs after ATA_RST: SStat 0x00000004 SErr 0x04000000
SCtrl 0x00000004
mv_phy_reset: S-regs after PHY wake: SStat 0x00000113 SErr 0x04010000
SCtrl 0x00000300
ata_dev_classify: found ATA device by sig
mv_phy_reset: EXIT
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata_eh_thaw_port: ata2 port thawed
ata_eh_revalidate_and_attach: ENTER
ata2: ata_dev_select: ENTER, device 0, wait 1
ata2: ata_dev_select: ENTER, device 0, wait 1
ata_tf_load: feat 0x0 nsect 0x0 lba 0x0 0x0 0x0
ata_tf_load: device 0xA0
ata_exec_command: ata2: cmd 0xEC
ata_hsm_move: ata2: protocol 2 task_state 2 (dev_stat 0x58)
ata_pio_sector: data read
ata_hsm_move: ata2: protocol 2 task_state 3 (dev_stat 0x50)
ata_hsm_move: ata2: dev 0 command complete, drv_stat 0x50
ata_port_flush_task: ENTER
ata2: ata_dev_select: ENTER, device 0, wait 1
ata_tf_load: hob: feat 0x0 nsect 0x0, lba 0x0 0x0 0x0
ata_tf_load: feat 0x0 nsect 0x0 lba 0x0 0x0 0x0
ata_tf_load: device 0xE0
ata_exec_command: ata2: cmd 0x27
ata_hsm_move: ata2: protocol 1 task_state 3 (dev_stat 0x50)
ata_hsm_move: ata2: dev 0 command complete, drv_stat 0x50
ata_port_flush_task: ENTER
ata_dump_id: 49==0x2f00  53==0x0007  63==0x0007  64==0x0003  75==0x001f
ata_dump_id: 80==0x00fe  81==0x0000  82==0x346b  83==0x7d09  84==0x5923
ata_dump_id: 88==0x407f  93==0x0000
ata2.00: ATA-7: ST3250820NS, 3.AEG, max UDMA/133
ata2.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata_dev_set_xfermode: set features - xfer mode
ata2: ata_dev_select: ENTER, device 0, wait 1
ata_tf_load: feat 0x3 nsect 0x46 lba 0x0 0x0 0x0
ata_tf_load: device 0xA0
ata_exec_command: ata2: cmd 0xEF
ata_hsm_move: ata2: protocol 1 task_state 3 (dev_stat 0x50)
ata_hsm_move: ata2: dev 0 command complete, drv_stat 0x50
ata_port_flush_task: ENTER
ata_dev_set_xfermode: EXIT, err_mask=0
ata2: ata_dev_select: ENTER, device 0, wait 1
ata2: ata_dev_select: ENTER, device 0, wait 1
ata_tf_load: feat 0x0 nsect 0x0 lba 0x0 0x0 0x0
ata_tf_load: device 0xA0
ata_exec_command: ata2: cmd 0xEC
ata_hsm_move: ata2: protocol 2 task_state 2 (dev_stat 0x58)
ata_pio_sector: data read
ata_hsm_move: ata2: protocol 2 task_state 3 (dev_stat 0x50)
ata_hsm_move: ata2: dev 0 command complete, drv_stat 0x50
ata_port_flush_task: ENTER
ata2: ata_dev_select: ENTER, device 0, wait 1
ata_tf_load: hob: feat 0x0 nsect 0x0, lba 0x0 0x0 0x0
ata_tf_load: feat 0x0 nsect 0x0 lba 0x0 0x0 0x0
ata_tf_load: device 0xE0
ata_exec_command: ata2: cmd 0x27
ata_hsm_move: ata2: protocol 1 task_state 3 (dev_stat 0x50)
ata_hsm_move: ata2: dev 0 command complete, drv_stat 0x50
ata_port_flush_task: ENTER
ata_dump_id: 49==0x2f00  53==0x0007  63==0x0007  64==0x0003  75==0x001f
ata_dump_id: 80==0x00fe  81==0x0000  82==0x346b  83==0x7d09  84==0x5923
ata_dump_id: 88==0x407f  93==0x0000
ata_dev_set_mode: xfer_shift=12, xfer_mode=0x46
ata2.00: configured for UDMA/133
ata_eh_recover: EXIT, rc=0
ata_scsi_error: EXIT
ata_port_schedule_eh: port EH scheduled
ata_scsi_error: ENTER
ata_port_flush_task: ENTER
ata_eh_link_autopsy: ENTER
ata_eh_recover: ENTER
__ata_port_freeze: ata3 port frozen
mv_phy_reset: ENTER, port 2, mmio 0xf10a6000
mv_phy_reset: S-regs after ATA_RST: SStat 0x00000004 SErr 0x00000000
SCtrl 0x00000004
mv_phy_reset: S-regs after PHY wake: SStat 0x00000000 SErr 0x00000000
SCtrl 0x00000300
ata3: SATA link down (SStatus 0 SControl 300)
ata_eh_thaw_port: ata3 port thawed
ata_eh_revalidate_and_attach: ENTER
ata_eh_recover: EXIT, rc=0
ata_scsi_error: EXIT
ata_port_schedule_eh: port EH scheduled
ata_scsi_error: ENTER
ata_port_flush_task: ENTER
ata_eh_link_autopsy: ENTER
ata_eh_recover: ENTER
__ata_port_freeze: ata4 port frozen
mv_phy_reset: ENTER, port 3, mmio 0xf10a8000
mv_phy_reset: S-regs after ATA_RST: SStat 0x00000004 SErr 0x00000000
SCtrl 0x00000004
mv_phy_reset: S-regs after PHY wake: SStat 0x00000000 SErr 0x00000000
SCtrl 0x00000300
ata4: SATA link down (SStatus 0 SControl 300)
ata_eh_thaw_port: ata4 port thawed
ata_eh_revalidate_and_attach: ENTER
ata_eh_recover: EXIT, rc=0
ata_scsi_error: EXIT
ata_host_register: host probe begin
ata_scsi_dump_cdb: CDB (1:0,0,0) 12 00 00 00 24 00 45 67 01
ata_scsiop_inq_std: ENTER
ata_scsi_dump_cdb: CDB (1:0,0,0) 12 00 00 00 60 00 45 67 01
ata_scsiop_inq_std: ENTER
scsi 0:0:0:0: Direct-Access     ATA      ST3250820NS      3.AE PQ: 0
ANSI: 5
ata_scsi_dump_cdb: CDB (1:0,0,0) 00 00 00 00 00 00 45 67 01
ata_scsiop_noop: ENTER
ata_scsi_dump_cdb: CDB (1:0,0,0) 25 00 00 00 00 00 00 00 00
ata_scsiop_read_cap: ENTER
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
ata_scsi_dump_cdb: CDB (1:0,0,0) 5a 00 3f 00 00 00 00 00 08
ata_scsiop_mode_sense: ENTER
sd 0:0:0:0: [sda] Write Protect is off
ata_scsi_dump_cdb: CDB (1:0,0,0) 5a 00 08 00 00 00 00 00 08
ata_scsiop_mode_sense: ENTER
ata_scsi_dump_cdb: CDB (1:0,0,0) 5a 00 08 00 00 00 00 00 24
ata_scsiop_mode_sense: ENTER
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
ata_scsi_dump_cdb: CDB (1:0,0,0) 00 00 00 00 00 00 00 00 24
ata_scsiop_noop: ENTER
ata_scsi_dump_cdb: CDB (1:0,0,0) 25 00 00 00 00 00 00 00 00
ata_scsiop_read_cap: ENTER
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
ata_scsi_dump_cdb: CDB (1:0,0,0) 5a 00 3f 00 00 00 00 00 08
ata_scsiop_mode_sense: ENTER
sd 0:0:0:0: [sda] Write Protect is off
ata_scsi_dump_cdb: CDB (1:0,0,0) 5a 00 08 00 00 00 00 00 08
ata_scsiop_mode_sense: ENTER
ata_scsi_dump_cdb: CDB (1:0,0,0) 5a 00 08 00 00 00 00 00 24
ata_scsiop_mode_sense: ENTER
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda:<3>ata_scsi_dump_cdb: CDB (1:0,0,0) 28 00 00 00 00 00 00 00 08
ata_scsi_translate: ENTER
scsi_10_lba_len: ten-byte command
ata_sg_setup: ENTER, ata1
ata_sg_setup: 1 sg elements mapped
ata_scsi_translate: EXIT
mv_host_intr: ENTER, hc0 relevant=0x00000102 HC IRQ cause=0x00000011
ata_sg_clean: unmapping 1 sg elements
mv_host_intr: EXIT
 sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
ata_scsi_dump_cdb: CDB (2:0,0,0) 12 00 00 00 24 00 45 67 01
ata_scsiop_inq_std: ENTER
ata_scsi_dump_cdb: CDB (2:0,0,0) 12 00 00 00 60 00 45 67 01
ata_scsiop_inq_std: ENTER
scsi 1:0:0:0: Direct-Access     ATA      ST3250820NS      3.AE PQ: 0
ANSI: 5
ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 00 00 00 45 67 01
ata_scsiop_noop: ENTER
ata_scsi_dump_cdb: CDB (2:0,0,0) 25 00 00 00 00 00 00 00 00
ata_scsiop_read_cap: ENTER
sd 1:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
ata_scsi_dump_cdb: CDB (2:0,0,0) 5a 00 3f 00 00 00 00 00 08
ata_scsiop_mode_sense: ENTER
sd 1:0:0:0: [sdb] Write Protect is off
ata_scsi_dump_cdb: CDB (2:0,0,0) 5a 00 08 00 00 00 00 00 08
ata_scsiop_mode_sense: ENTER
ata_scsi_dump_cdb: CDB (2:0,0,0) 5a 00 08 00 00 00 00 00 24
ata_scsiop_mode_sense: ENTER
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 00 00 00 00 00 24
ata_scsiop_noop: ENTER
ata_scsi_dump_cdb: CDB (2:0,0,0) 25 00 00 00 00 00 00 00 00
ata_scsiop_read_cap: ENTER
sd 1:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
ata_scsi_dump_cdb: CDB (2:0,0,0) 5a 00 3f 00 00 00 00 00 08
ata_scsiop_mode_sense: ENTER
sd 1:0:0:0: [sdb] Write Protect is off
ata_scsi_dump_cdb: CDB (2:0,0,0) 5a 00 08 00 00 00 00 00 08
ata_scsiop_mode_sense: ENTER
ata_scsi_dump_cdb: CDB (2:0,0,0) 5a 00 08 00 00 00 00 00 24
ata_scsiop_mode_sense: ENTER
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdb:<3>ata_scsi_dump_cdb: CDB (2:0,0,0) 28 00 00 00 00 00 00 00 08
ata_scsi_translate: ENTER
scsi_10_lba_len: ten-byte command
ata_sg_setup: ENTER, ata2
ata_sg_setup: 1 sg elements mapped
ata_scsi_translate: EXIT
mv_host_intr: ENTER, hc0 relevant=0x00000108 HC IRQ cause=0x00000012
ata_sg_clean: unmapping 1 sg elements
mv_host_intr: EXIT
 sdb1 sdb2
sd 1:0:0:0: [sdb] Attached SCSI disk
sd 1:0:0:0: Attached scsi generic sg1 type 0


<snip (rest of boot sequence)>


---- error on mount ---

-bash-2.05b# mount /dev/sda2 /mnt/src
ata_scsi_dump_cdb: CDB (1:0,0,0) 28 00 01 31 6f 5e 00 00 20
ata_scsi_translate: ENTER
scsi_10_lba_len: ten-byte command
ata_sg_setup: ENTER, ata1
ata_sg_setup: 4 sg elements mapped
ata_scsi_translate: EXIT
mv_host_intr: ENTER, hc0 relevant=0x00000102 HC IRQ cause=0x00000011
ata_sg_clean: unmapping 4 sg elements
mv_host_intr: EXIT
ata_scsi_dump_cdb: CDB (1:0,0,0) 28 00 01 31 6f 60 00 00 02
ata_scsi_translate: ENTER
scsi_10_lba_len: ten-byte command
ata_sg_setup: ENTER, ata1
ata_sg_setup: 1 sg elements mapped
ata_scsi_translate: EXIT
mv_host_intr: ENTER, hc0 relevant=0x00000102 HC IRQ cause=0x00000011
ata_sg_clean: unmapping 1 sg elements
mv_host_intr: EXIT
ata_scsi_dump_cdb: CDB (1:0,0,0) 28 00 01 31 6f 5e 00 00 08
ata_scsi_translate: ENTER
scsi_10_lba_len: ten-byte command
ata_sg_setup: ENTER, ata1
ata_sg_setup: 1 sg elements mapped
ata_scsi_translate: EXIT
mv_host_intr: ENTER, hc0 relevant=0x00000102 HC IRQ cause=0x00000011
ata_sg_clean: unmapping 1 sg elements
mv_host_intr: EXIT
ata_scsi_dump_cdb: CDB (1:0,0,0) 28 00 01 31 6f 66 00 00 08
ata_scsi_translate: ENTER
scsi_10_lba_len: ten-byte command
ata_sg_setup: ENTER, ata1
ata_sg_setup: 1 sg elements mapped
ata_scsi_translate: EXIT
mv_host_intr: ENTER, hc0 relevant=0x00000102 HC IRQ cause=0x00000011
ata_sg_clean: unmapping 1 sg elements
mv_host_intr: EXIT
ata_scsi_dump_cdb: CDB (1:0,0,0) 28 00 01 31 79 06 00 00 08
ata_scsi_translate: ENTER
scsi_10_lba_len: ten-byte command
ata_sg_setup: ENTER, ata1
ata_sg_setup: 1 sg elements mapped
ata_scsi_translate: EXIT
mv_host_intr: ENTER, hc0 relevant=0x00000102 HC IRQ cause=0x00000011
ata_sg_clean: unmapping 1 sg elements
mv_host_intr: EXIT
ata_scsi_dump_cdb: CDB (1:0,0,0) 28 00 01 31 88 e6 00 00 08
ata_scsi_translate: ENTER
scsi_10_lba_len: ten-byte command
ata_sg_setup: ENTER, ata1
ata_sg_setup: 1 sg elements mapped
ata_scsi_translate: EXIT
mv_host_intr: ENTER, hc0 relevant=0x00000102 HC IRQ cause=0x00000011
ata_sg_clean: unmapping 1 sg elements
mv_host_intr: EXIT
kjournald starting.  Commit interval 5 seconds
ata_scsi_dump_cdb: CDB (1:0,0,0) 2a 00 01 31 6f 5e 00 00 08
ata_scsi_translate: ENTER
scsi_10_lba_len: ten-byte command
ata_sg_setup: ENTER, ata1
ata_sg_setup: 1 sg elements mapped
ata_scsi_translate: EXIT



----delay of at least 15-30 seconds---

ata_scsi_timed_out: ENTER
ata_scsi_timed_out: EXIT, ret=0
ata_scsi_error: ENTER
ata_port_flush_task: ENTER
__ata_port_freeze: ata1 port frozen
ata_eh_link_autopsy: ENTER
ata_eh_link_autopsy: EXIT
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata1.00: cmd ca/00:08:5e:6f:31/00:00:00:00:00/e1 tag 0 cdb 0x0 data 4096
out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: status: { DRDY }
ata_eh_recover: ENTER
__ata_port_freeze: ata1 port frozen
ata1: port is slow to respond, please be patient (Status 0xd0)
ata1: prereset failed (errno=-16)
ata1: reset failed, giving up
ata_eh_recover: EXIT, rc=-16
ata1.00: disabled
ata_sg_clean: unmapping 1 sg elements
ata1: EH complete
ata_scsi_error: EXIT
ata_scsi_dump_cdb: CDB (1:0,0,0) 2a 00 01 31 6f 5e 00 00 08
sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sda, sector 20016990
Buffer I/O error on device sda2, logical block 0
lost page write due to I/O error on sda2
EXT3 FS on sda2, internal journal
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
