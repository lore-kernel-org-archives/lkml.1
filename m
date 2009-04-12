Return-Path: <linux-kernel-owner+w=401wt.eu-S1751339AbZDLV7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339AbZDLV7n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 17:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbZDLV7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 17:59:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:58556 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbZDLV7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 17:59:33 -0400
Subject: USB: Buffer I/O error on device dm-0, logical block XYZ
From: Andreas <andreas@maxxle.de>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sun, 12 Apr 2009 23:59:29 +0200
Message-Id: <1239573569.5997.21.camel@legolas>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+XMvIf+UG72VXTTb3jwTfLgLsHIiVfQvVMioz
 Ild4UYXSs5AQMS7QuxGvuoCXiHCOSWcJzSItDmfajknLHaDuPs
 FxWhM54rdUUdkb8df2PCplAjyv2j6ne
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

on heavy disk I/O my external USB device gets re-mounted read-only.
(Ok - scp with 2,5MB/s over WLAN)
After this i get EXT3-Errors.

I've already:
- tweaked kernel parameters (see below)
- changed entries in sys-fs

The only thing that works is if i remove the ehci module for USB2.0.



SysLog-Errors:
==============
Apr 12 17:45:08 elrond kernel: [  628.205804] usb-storage: device found
at 2
Apr 12 17:45:08 elrond kernel: [  628.205825] usb-storage: waiting for
device to settle before scanning
Apr 12 17:45:13 elrond kernel: [  633.206246] usb-storage: device scan
complete
Apr 12 17:45:13 elrond kernel: [  633.218523] scsi 3:0:0:0:
Direct-Access     WD       3200JB External  0412 PQ: 0 ANSI: 0
Apr 12 17:45:13 elrond kernel: [  633.252002] sd 3:0:0:0: [sdc]
625142448 512-byte hardware sectors: (320 GB/298 GiB)
Apr 12 17:45:13 elrond kernel: [  633.262009] sd 3:0:0:0: [sdc] Write
Protect is off
Apr 12 17:45:13 elrond kernel: [  633.262057] sd 3:0:0:0: [sdc] Mode
Sense: 33 00 00 00
Apr 12 17:45:13 elrond kernel: [  633.262083] sd 3:0:0:0: [sdc] Assuming
drive cache: write through
Apr 12 17:45:13 elrond kernel: [  633.285968] sd 3:0:0:0: [sdc]
625142448 512-byte hardware sectors: (320 GB/298 GiB)
Apr 12 17:45:13 elrond kernel: [  633.296113] sd 3:0:0:0: [sdc] Write
Protect is off
Apr 12 17:45:13 elrond kernel: [  633.296148] sd 3:0:0:0: [sdc] Mode
Sense: 33 00 00 00
Apr 12 17:45:13 elrond kernel: [  633.296170] sd 3:0:0:0: [sdc] Assuming
drive cache: write through
Apr 12 17:45:13 elrond kernel: [  633.296313]  sdc: sdc1
Apr 12 17:45:13 elrond kernel: [  633.314525] sd 3:0:0:0: [sdc] Attached
SCSI disk
Apr 12 17:45:13 elrond kernel: [  633.315315] sd 3:0:0:0: Attached scsi
generic sg1 type 0
Apr 12 17:45:16 elrond kernel: [  635.773406] ext3_abort called.
Apr 12 17:45:16 elrond kernel: [  635.773484] EXT3-fs error (device
dm-0): ext3_journal_start_sb: Detected aborted journal
Apr 12 17:45:16 elrond kernel: [  635.773588] Remounting filesystem
read-only
Apr 12 17:46:27 elrond kernel: [  706.828326] EXT3-fs error (device
dm-0): ext3_get_inode_loc: unable to read inode block - inode=1015809
, block=4063234
Apr 12 17:46:27 elrond kernel: [  706.833874] EXT3-fs error (device
dm-0): ext3_get_inode_loc: unable to read inode block - inode=1015809
, block=4063234
Apr 12 17:46:27 elrond kernel: [  706.840217] EXT3-fs error (device
dm-0): ext3_get_inode_loc: unable to read inode block - inode=1015810
, block=4063234
...
...
...



My Setup:
=========
Kernel:
2.6.29-02062901-generic #02062901 SMP (Ubuntu 2.6.29.1)

lspci:
00:00.0 Host bridge: Transmeta Corporation LongRun Northbridge (rev 03)
00:00.1 RAM memory: Transmeta Corporation SDRAM controller
00:00.2 RAM memory: Transmeta Corporation BIOS scratchpad
00:09.0 VGA compatible controller: Silicon Integrated Systems [SiS]
315PRO PCI/AGP VGA Display Adapter
00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 80)
00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 80)
00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 80)
00:10.3 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 82)
00:11.0 ISA bridge: VIA Technologies, Inc. VT8235 ISA Bridge
00:11.1 IDE interface: VIA Technologies, Inc.
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
00:11.5 Multimedia audio controller: VIA Technologies, Inc.
VT8233/A/8235/8237 AC97 Audio Controller (rev 50)
00:12.0 Ethernet controller: VIA Technologies, Inc. VT6102 [Rhine-II]
(rev 74)


/sys-parameters:
echo 1024 > /sys/block/sdb/device/max_sectors
echo 1 > /sys/block/sdb/device/scsi_diskXYZ/allow_restart


grub-parameters:
all_generic_ide combined_mode=ide enable_atapi=1 noapic

