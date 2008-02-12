Return-Path: <linux-kernel-owner+w=401wt.eu-S1760151AbYBLJ0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760151AbYBLJ0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 04:26:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbYBLJ0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 04:26:30 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:61602 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbYBLJ00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 04:26:26 -0500
From: Hans-Peter Jansen <hpj@urpla.net>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: IDE cdrom problem with PLEXTOR DVDR PX-608AL
Date: Tue, 12 Feb 2008 10:26:17 +0100
User-Agent: KMail/1.9.6 (enterprise 20071221.751182)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802121026.17420.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX18cBolwgQMBVpgcg5p/4wKzKri9Bs7mVZMqVhB
 /WX1DwEYvo9HTu4X4Lqh3t/WYSrv2xpDFH4nYq22WLwkepu4NZ
 7aOXl0Ztt2DOTvVU1JJuQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

I suffer from unreliable cdrom operations (failing DAE and burn sessions) 
with the openSUSE 2.6.18.8-0.7-bigsmp kernel.

Additionally, the syslog is continuesly spammed with:
 
Feb 12 00:03:22 kernel: hdc: cdrom_pc_intr: The drive appears confused (ireason = 0x01).
 Trying to recover by ending request.
Feb 12 00:57:52 kernel: hdc: cdrom_pc_intr: The drive appears confused (ireason = 0x01).
 Trying to recover by ending request.
Feb 12 01:36:21 kernel: hdc: cdrom_pc_intr: The drive appears confused (ireason = 0x01).
 Trying to recover by ending request.
Feb 12 01:38:49 kernel: hde: cdrom_pc_intr: The drive appears confused (ireason = 0x01).
 Trying to recover by ending request.
Feb 12 08:06:07 kernel: hde: cdrom_pc_intr: The drive appears confused (ireason = 0x01).
 Trying to recover by ending request.

I drove that devices on a pdc20268 based Promise Ultra TX/2 100 card for 
some time, which had some IDE/ATAPI issues documented. After exchanging 
that PCI card with a "Silicon Image PCI0680 based one, the problem persists.

Is there any firmware/atapi protocol problem known with these drives?

These are the offenders:

42: IDE 02.0: 10602 CD-ROM (DVD)
  [Created at block.222]
  UDI: /org/freedesktop/Hal/devices/storage_model_PLEXTOR_DVDR_PX_608AL
  Unique ID: 90A1.yYhZwSaKZZ6
  Parent ID: ejN_.zzJBQoyZsp8
  SysFS ID: /block/hdc
  SysFS BusID: 1.0
  SysFS Device Link: /devices/pci0000:00/0000:00:0e.0/0000:02:06.0/ide1/1.0
  Hardware Class: cdrom
  Model: "PLEXTOR DVDR PX-608AL"
  Vendor: "PLEXTOR"
  Device: "DVDR PX-608AL"
  Revision: "1.01"
  Serial ID: "GDDL000676UE"
  Driver: "SiI_IDE", "ide-cdrom"
  Driver Modules: "siimage", "ide_cd"
  Device File: /dev/hdc
  Device Files: /dev/hdc, /dev/disk/by-path/pci-0000:02:06.0-ide-0:0
  Device Number: block 22:0
  Features: CD-R, CD-RW, DVD, DVD-R, DVD-RW, DVD+R, DVD+RW, DVD+DL, DVDRAM
  Drive status: no medium
  Config Status: cfg=no, avail=yes, need=no, active=unknown
  Attached to: #34 (Unknown mass storage controller)
  Drive Speed: 24

43: IDE 04.0: 10602 CD-ROM (DVD)
  [Created at block.222]
  UDI: /org/freedesktop/Hal/devices/storage_model_PLEXTOR_DVDR_PX_608AL_0
  Unique ID: 3Ng9.rKN6BMng3oC
  Parent ID: ejN_.zzJBQoyZsp8
  SysFS ID: /block/hde
  SysFS BusID: 2.0
  SysFS Device Link: /devices/pci0000:00/0000:00:0e.0/0000:02:06.0/ide2/2.0
  Hardware Class: cdrom
  Model: "PLEXTOR DVDR PX-608AL"
  Vendor: "PLEXTOR"
  Device: "DVDR PX-608AL"
  Revision: "1.01"
  Serial ID: "GGDL007101UE"
  Driver: "SiI_IDE", "ide-cdrom"
  Driver Modules: "siimage", "ide_cd"
  Device File: /dev/hde
  Device Files: /dev/hde, /dev/disk/by-path/pci-0000:02:06.0-ide-1:0
  Device Number: block 33:0
  Features: CD-R, CD-RW, DVD, DVD-R, DVD-RW, DVD+R, DVD+RW, DVD+DL, DVDRAM
  Drive status: no medium
  Config Status: cfg=no, avail=yes, need=no, active=unknown
  Attached to: #34 (Unknown mass storage controller)
  Drive Speed: 24

hanging on this controller (now):

44: PCI 206.0: 0180 Unknown mass storage controller
  [Created at pci.286]
  UDI: /org/freedesktop/Hal/devices/pci_1095_680
  Unique ID: ejN_.zzJBQoyZsp8
  Parent ID: vuMS.8LoPsVNGJbF
  SysFS ID: /devices/pci0000:00/0000:00:0e.0/0000:02:06.0
  SysFS BusID: 0000:02:06.0
  Hardware Class: storage
  Model: "Silicon Image PCI0680 Ultra ATA-133 Host Controller"
  Vendor: pci 0x1095 "Silicon Image, Inc."
  Device: pci 0x0680 "PCI0680 Ultra ATA-133 Host Controller"
  SubVendor: pci 0x1095 "Silicon Image, Inc."
  SubDevice: pci 0x0680 
  Revision: 0x02
  Driver: "SiI_IDE"
  Driver Modules: "siimage"
  I/O Ports: 0x9c00-0x9c07 (rw)
  I/O Ports: 0x9800-0x9803 (rw)
  I/O Ports: 0x9400-0x9407 (rw)
  I/O Ports: 0x9000-0x9003 (rw)
  I/O Ports: 0x8c00-0x8c0f (rw)
  Memory Range: 0xfdfff000-0xfdfff0ff (rw,non-prefetchable)
  Memory Range: 0xf4000000-0xf407ffff (ro,prefetchable,disabled)
  IRQ: 169 (1767334 events)
  Module Alias: "pci:v00001095d00000680sv00001095sd00000680bc01sc80i00"
  Driver Info #0:
    Driver Status: siimage is active
    Driver Activation Cmd: "modprobe siimage"
  Driver Info #1:
    Driver Status: pata_sil680 is active
    Driver Activation Cmd: "modprobe pata_sil680"
  Config Status: cfg=no, avail=yes, need=no, active=unknown
  Attached to: #30 (PCI bridge)

Any hints are highly appreciated.

Pete
