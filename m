Return-Path: <linux-kernel-owner+w=401wt.eu-S1756420AbYCTOSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbYCTOSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 10:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755263AbYCTOSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 10:18:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:50317 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135AbYCTOSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 10:18:42 -0400
From: Hans-Peter Jansen <hpj@urpla.net>
To: linux-kernel@vger.kernel.org
Subject: 2.6.24.3: regular sata drive resets - worrisome?
Date: Thu, 20 Mar 2008 15:18:31 +0100
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803201518.32109.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX1+ougzBi6/v6vuiTbWsAqSCV0l2EX/8R5pv/a7
 OInT66gkbOJnFZIX35RwK/lAaFp0v4J1P2fCo2V/ogA7/r7xw5
 MA57u/my00LtTQlEZACBA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

since I upgraded to 2.6.24.3 on one of my production systems, I see 
regular device resets like these:

Mar 20 14:33:03 lisa5 kernel: ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
Mar 20 14:33:03 lisa5 kernel: ata2.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
Mar 20 14:33:03 lisa5 kernel:          res 40/00:00:01:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:33:03 lisa5 kernel: ata2.00: status: { DRDY }
Mar 20 14:33:03 lisa5 kernel: ata2: hard resetting link
Mar 20 14:33:05 lisa5 kernel: ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
Mar 20 14:33:05 lisa5 kernel: ata2.00: configured for UDMA/100
Mar 20 14:33:05 lisa5 kernel: ata2: EH complete
Mar 20 14:33:05 lisa5 kernel: sd 2:0:0:0: [sdc] 488397168 512-byte hardware sectors (250059 MB)
Mar 20 14:33:05 lisa5 kernel: sd 2:0:0:0: [sdc] Write Protect is off
Mar 20 14:33:05 lisa5 kernel: sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
Mar 20 14:33:05 lisa5 kernel: sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar 20 14:36:11 lisa5 kernel: ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
Mar 20 14:36:11 lisa5 kernel: ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
Mar 20 14:36:11 lisa5 kernel:          res 40/00:00:01:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
Mar 20 14:36:11 lisa5 kernel: ata3.00: status: { DRDY }
Mar 20 14:36:11 lisa5 kernel: ata3: hard resetting link
Mar 20 14:36:13 lisa5 kernel: ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
Mar 20 14:36:13 lisa5 kernel: ata3.00: configured for UDMA/100
Mar 20 14:36:13 lisa5 kernel: ata3: EH complete
Mar 20 14:36:13 lisa5 kernel: sd 3:0:0:0: [sdd] 488397168 512-byte hardware sectors (250059 MB)
Mar 20 14:36:13 lisa5 kernel: sd 3:0:0:0: [sdd] Write Protect is off
Mar 20 14:36:13 lisa5 kernel: sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
Mar 20 14:36:13 lisa5 kernel: sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

Should I be worried? smartd doesn't show anything suspicious on those.

It's been 4 samsung drives at all hanging on a sata sil 3124:

29: PCI 202.0: 0104 RAID bus controller
  [Created at pci.273]
  Unique ID: LHB6.kPnnhej1LTC
  Parent ID: bSAa.qlvrYsPk2G3
  SysFS ID: /devices/pci0000:00/0000:00:0a.0/0000:02:02.0
  SysFS BusID: 0000:02:02.0
  Hardware Class: storage
  Model: "Silicon Image, Inc. (formerly CMD Technology Inc) SiI 3124 PCI-X Serial ATA Controller"
  Vendor: pci 0x1095 "Silicon Image, Inc. (formerly CMD Technology Inc)"
  Device: pci 0x3124 "SiI 3124 PCI-X Serial ATA Controller"
  SubVendor: pci 0x1095 "Silicon Image, Inc. (formerly CMD Technology Inc)"
  SubDevice: pci 0x7124 
  Revision: 0x01
  Driver: "sata_sil24"
  Memory Range: 0xfc9ffc00-0xfc9ffc7f (rw,non-prefetchable)
  Memory Range: 0xfc9f0000-0xfc9f7fff (rw,non-prefetchable)
  I/O Ports: 0xac00-0xac0f (rw)
  Memory Range: 0xfc900000-0xfc97ffff (ro,prefetchable,disabled)
  IRQ: 17 (20116954 events)
  Driver Info #0:
    Driver Status: sata_sil24 is active
    Driver Activation Cmd: "modprobe sata_sil24"
  Config Status: cfg=no, avail=yes, need=no, active=unknown
  Attached to: #15 (PCI bridge)

27: IDE 100.0: 10600 Disk
  [Created at block.188]
  Unique ID: DQI9.0o8IZwvZth7
  Parent ID: LHB6.kPnnhej1LTC
  SysFS ID: /block/sdb
  SysFS BusID: 1:0:0:0
  SysFS Device Link: /devices/pci0000:00/0000:00:0a.0/0000:02:02.0/host1/target1:0:0/1:0:0:0
  Hardware Class: disk
  Model: "SAMSUNG SP2504C"
  Vendor: "SAMSUNG"
  Device: "SP2504C"
  Revision: "VT10"
  Serial ID: "S09QJ1GYA03006"
  Driver: "sata_sil24", "sd"
  Device File: /dev/sdb
  Device 
Files: /dev/sdb, /dev/disk/by-path/pci-0000:02:02.0-scsi-0:0:0:0, /dev/disk/by-id/1ATA_SAMSUNG_SP2504C_S09QJ1GYA03006
  Device Number: block 8:16-8:31
  Geometry (Logical): CHS 30401/255/63
  Size: 488397168 sectors a 512 bytes
  Config Status: cfg=no, avail=yes, need=no, active=unknown
  Attached to: #20 (RAID bus controller)

28: IDE 200.0: 10600 Disk
  [Created at block.188]
  Unique ID: gbYD.jbwYSfXQ1s1
  Parent ID: LHB6.kPnnhej1LTC
  SysFS ID: /block/sdc
  SysFS BusID: 2:0:0:0
  SysFS Device Link: /devices/pci0000:00/0000:00:0a.0/0000:02:02.0/host2/target2:0:0/2:0:0:0
  Hardware Class: disk
  Model: "SAMSUNG SP2504C"
  Vendor: "SAMSUNG"
  Device: "SP2504C"
  Revision: "VT10"
  Serial ID: "S09QJ1GYA03003"
  Driver: "sata_sil24", "sd"
  Device File: /dev/sdc
  Device 
Files: /dev/sdc, /dev/disk/by-path/pci-0000:02:02.0-scsi-1:0:0:0, /dev/disk/by-id/1ATA_SAMSUNG_SP2504C_S09QJ1GYA03003
  Device Number: block 8:32-8:47
  Geometry (Logical): CHS 30401/255/63
  Size: 488397168 sectors a 512 bytes
  Config Status: cfg=no, avail=yes, need=no, active=unknown
  Attached to: #20 (RAID bus controller)

29: IDE 300.0: 10600 Disk
  [Created at block.188]
  Unique ID: 8noH.C6Upa9vrTP5
  Parent ID: LHB6.kPnnhej1LTC
  SysFS ID: /block/sdd
  SysFS BusID: 3:0:0:0
  SysFS Device Link: /devices/pci0000:00/0000:00:0a.0/0000:02:02.0/host3/target3:0:0/3:0:0:0
  Hardware Class: disk
  Model: "SAMSUNG SP2504C"
  Vendor: "SAMSUNG"
  Device: "SP2504C"
  Revision: "VT10"
  Serial ID: "S09QJ1GYA02991"
  Driver: "sata_sil24", "sd"
  Device File: /dev/sdd
  Device 
Files: /dev/sdd, /dev/disk/by-path/pci-0000:02:02.0-scsi-2:0:0:0, /dev/disk/by-id/1ATA_SAMSUNG_SP2504C_S09QJ1GYA02991
  Device Number: block 8:48-8:63
  Geometry (Logical): CHS 30401/255/63
  Size: 488397168 sectors a 512 bytes
  Config Status: cfg=no, avail=yes, need=no, active=unknown
  Attached to: #20 (RAID bus controller)

30: IDE 400.0: 10600 Disk
  [Created at block.188]
  Unique ID: by2M.RNPEDP68X7E
  Parent ID: LHB6.kPnnhej1LTC
  SysFS ID: /block/sde
  SysFS BusID: 4:0:0:0
  SysFS Device Link: /devices/pci0000:00/0000:00:0a.0/0000:02:02.0/host4/target4:0:0/4:0:0:0
  Hardware Class: disk
  Model: "SAMSUNG SP2504C"
  Vendor: "SAMSUNG"
  Device: "SP2504C"
  Revision: "VT10"
  Serial ID: "S09QJ1GYA02990"
  Driver: "sata_sil24", "sd"
  Device File: /dev/sde
  Device 
Files: /dev/sde, /dev/disk/by-path/pci-0000:02:02.0-scsi-3:0:0:0, /dev/disk/by-id/1ATA_SAMSUNG_SP2504C_S09QJ1GYA02990
  Device Number: block 8:64-8:79
  Geometry (Logical): CHS 30401/255/63
  Size: 488397168 sectors a 512 bytes
  Config Status: cfg=no, avail=yes, need=no, active=unknown
  Attached to: #20 (RAID bus controller)

