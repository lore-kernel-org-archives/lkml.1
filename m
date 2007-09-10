Return-Path: <linux-kernel-owner+w=401wt.eu-S1760473AbXIJRtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760473AbXIJRtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 13:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755381AbXIJRtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 13:49:42 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3221 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982AbXIJRtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 13:49:42 -0400
Date: Mon, 10 Sep 2007 18:49:26 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mel@csn.ul.ie
Subject: Re: 2.6.23-rc4-mm1
Message-ID: <20070910174926.GC30335@shadowen.org>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070831215822.26e1432b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have a couple of old NUMA-Q systems which are unable to read their
boot disks with 2.6.23-rc4-mm1.  The disks appear to be recognised and
even the partition tables read correctly, and then they go pop:

  qla1280: QLA1040 found on PCI bus 0, dev 10
  Clocksource tsc unstable (delta = 99922590 ns)
  Time: jiffies clocksource has been installed.
  scsi(0:0): Resetting SCSI BUS
  scsi0 : QLogic QLA1040 PCI to SCSI Host Adapter
         Firmware version:  7.65.06, Driver version 3.26
  scsi 0:0:0:0: Direct-Access     IBM      DGHS18X          0360 PQ: 0 ANSI: 3
  scsi(0:0:0:0): Sync: period 10, offset 12, Wide
  scsi 0:0:1:0: Direct-Access     IBM OEM  DCHS09X          5454 PQ: 0 ANSI: 2
  scsi(0:0:1:0): Sync: period 10, offset 12, Wide
  scsi 0:0:2:0: Direct-Access     IBM OEM  DCHS09X          5454 PQ: 0 ANSI: 2
  scsi(0:0:2:0): Sync: period 10, offset 12, Wide
  scsi 0:0:3:0: Direct-Access     IBM OEM  DCHS09X          5454 PQ: 0 ANSI: 2
  scsi(0:0:3:0): Sync: period 10, offset 12, Wide
  scsi 0:0:4:0: Direct-Access     IBM OEM  DCHS09X          5454 PQ: 0 ANSI: 2
  scsi(0:0:4:0): Sync: period 10, offset 12, Wide
  st: Version 20070203, fixed bufsize 32768, s/g segs 256
  sd 0:0:0:0: [sda] 35843670 512-byte hardware sectors (18352 MB)
  sd 0:0:0:0: [sda] Write Protect is off
  sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
  sd 0:0:0:0: [sda] 35843670 512-byte hardware sectors (18352 MB)
  sd 0:0:0:0: [sda] Write Protect is off
  sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
   sda: sda1
  sd 0:0:0:0: [sda] Attached SCSI disk
  sd 0:0:1:0: [sdb] 17796077 512-byte hardware sectors (9112 MB)
  sd 0:0:1:0: [sdb] Write Protect is off
  sd 0:0:1:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
  sd 0:0:1:0: [sdb] 17796077 512-byte hardware sectors (9112 MB)
  sd 0:0:1:0: [sdb] Write Protect is off
  sd 0:0:1:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
   sdb: unknown partition table
  sd 0:0:1:0: [sdb] Attached SCSI disk
  sd 0:0:2:0: [sdc] 17796077 512-byte hardware sectors (9112 MB)
  sd 0:0:2:0: [sdc] Write Protect is off
  sd 0:0:2:0: [sdc] Write cache: disabled, read cache: enabled, supports DPO and FUA
  sd 0:0:2:0: [sdc] 17796077 512-byte hardware sectors (9112 MB)
  sd 0:0:2:0: [sdc] Write Protect is off
  sd 0:0:2:0: [sdc] Write cache: disabled, read cache: enabled, supports DPO and FUA
   sdc: sdc1
  sd 0:0:2:0: [sdc] Attached SCSI disk
  sd 0:0:3:0: [sdd] 17796077 512-byte hardware sectors (9112 MB)
  sd 0:0:3:0: [sdd] Write Protect is off
  sd 0:0:3:0: [sdd] Write cache: disabled, read cache: enabled, supports DPO and FUA
  sd 0:0:3:0: [sdd] 17796077 512-byte hardware sectors (9112 MB)
  sd 0:0:3:0: [sdd] Write Protect is off
  sd 0:0:3:0: [sdd] Write cache: disabled, read cache: enabled, supports DPO and FUA
   sdd: sdd1
  sd 0:0:3:0: [sdd] Attached SCSI disk
  sd 0:0:4:0: [sde] 17796077 512-byte hardware sectors (9112 MB)
  sd 0:0:4:0: [sde] Write Protect is off
  sd 0:0:4:0: [sde] Write cache: disabled, read cache: enabled, supports DPO and FUA
  sd 0:0:4:0: [sde] 17796077 512-byte hardware sectors (9112 MB)
  sd 0:0:4:0: [sde] Write Protect is off
  sd 0:0:4:0: [sde] Write cache: disabled, read cache: enabled, supports DPO and FUA
   sde: unknown partition table
  sd 0:0:4:0: [sde] Attached SCSI disk
  sd 0:0:0:0: Attached scsi generic sg0 type 0
  sd 0:0:1:0: Attached scsi generic sg1 type 0
  sd 0:0:2:0: Attached scsi generic sg2 type 0
  sd 0:0:3:0: Attached scsi generic sg3 type 0
  sd 0:0:4:0: Attached scsi generic sg4 type 0
  serio: i8042 KBD port at 0x60,0x64 irq 1
  serio: i8042 AUX port at 0x60,0x64 irq 12
  mice: PS/2 mouse device common for all mice
  input: AT Translated Set 2 keyboard as /class/input/input0
  oprofile: using NMI interrupt.
  TCP cubic registered
  NET: Registered protocol family 1
  NET: Registered protocol family 17
  Using IPI Shortcut mode
  input: PS/2 Logitech Mouse as /class/input/input1
  RAMDISK: cramfs filesystem found at block 0
  RAMDISK: Loading 1244KiB [1 disk] into ram disk... |/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/done.
  VFS: Mounted root (cramfs filesystem) readonly.
  Freeing unused kernel memory: 220k freed
  initrd-tools: 0.1.81.1
  mount: fs type devfs not supported by kernel
  FATAL: Module sd_mod not found.
  umount: devfs: not mounted
  ext3: No journal on filesystem on sda1
  sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
  end_request: I/O error, dev sda, sector 63
  Buffer I/O error on device sda1, logical block 0
  Buffer I/O error on device sda1, logical block 1
  Buffer I/O error on device sda1, logical block 2
  Buffer I/O error on device sda1, logical block 3
  mount: fs type devfs not supported by kernel
  ext3: No journal on filesystem on sda1
  umount: devfs: not mounted
  sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
  end_request: I/O error, dev sda, sector 28010831
  sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
  end_request: I/O error, dev sda, sector 31080815
  sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
  end_request: I/O error, dev sda, sector 31080855
  sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
  end_request: I/O error, dev sda, sector 31080919
  Buffer I/O error on device sda1, logical block 3885107
  sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
  end_request: I/O error, dev sda, sector 28411047
  sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
  end_request: I/O error, dev sda, sector 31135687
  sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00
  end_request: I/O error, dev sda, sector 31138007
  sd 0:0:0:0: [sda] <6>sd 0:0:0:0: [sda] Result: hostbyte=0x07 driverbyte=0x00

-apw
