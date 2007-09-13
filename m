Return-Path: <linux-kernel-owner+w=401wt.eu-S1753458AbXIMHqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbXIMHqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 03:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbXIMHqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 03:46:12 -0400
Received: from ox.emgs.com ([194.248.190.99]:38150 "EHLO ox.emgs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbXIMHqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 03:46:10 -0400
X-Greylist: delayed 1661 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Sep 2007 03:46:09 EDT
Message-ID: <46E8EABF.3060409@pvv.org>
Date: Thu, 13 Sep 2007 09:46:07 +0200
From: Jon Ivar Rykkelid <jonry@pvv.org>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: sata_nv issues with MCP51 SATA controller
Content-Type: multipart/mixed;
 boundary="------------090408090302080800060304"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090408090302080800060304
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


Hi, I'm resending (didn't see my first attempt appear on the maillist):



I'm having serious disk-issues when using the on-board nvidia controller
for my HDDs (My motherboard is a Gigabyte GA-N650SLI-DS4 with nvidia
chipset, cpu is intel Core2Quad)

excerpt from "lspci":
00:0d.0 IDE interface: nVidia Corporation MCP51 IDE (rev a1)
00:0e.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller
(rev a1)
00:0f.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller
(rev a1)

I have a normal IDE/P-ATA-disk attached to the "IDE"-controller and that
works fine (/dev/hda)

However, any number of disks (I have tried 2 and 4) connected to the
SATA-controller(s), will eventually fail. - See attached log (excerpt /
anything relevant from /var/log/messages)

At first, disks were REALLY unstable, but then I disabled S.M.A.R.T.
(both in BIOS and Linux), and I updated from the CentOS5 (equivalent of
RHEL5) kernel (2.6.18) to the latest (at that time) official kernel from
kernel.org:

  > uname -a
Linux mirakel 2.6.22.5-custom_jir #2 SMP Thu Aug 30 22:06:21 CEST 2007
i686 i686 i386 GNU/Linux

Now it will normally take a day or two before SATA crashes, so things
are better, but still rather useless.

First error when sata_nv get into problems is always:
"exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen"
(as shown in the attached log-file.) - when this happens to one device,
it'll almost instantly happen to the other disk attached to that
controller as well. A couple of minutes (or so) later, the disk(s)
connected to the other controller will start acting up as well (in the
same manner). - I/O freezes, and nothing helps except a reboot...

As I run a rather large (software / md) RAID-5 disk array on this server
(I'm doing a bit of video editing), every crash means a time-consuming
rebuild of the disk-array...

I have given up on the sata_nv / nvidia-controllers for the time being.
I now resort to some old PCI-connected sata-controllers which work fine
(but slow, as they are outdated and "overloaded").

So, if anyone has a good solution / suggestion / improved driver (over
the one supplied with the official 2.6.22.5-kernel) I am eager to give
it a go and see if the situation can be resolved.

I appreciate any sensible suggestions.

BR
Jon Ivar


--------------090408090302080800060304
Content-Type: text/plain;
 name="sata_nv-error.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sata_nv-error.log"

Sep  8 00:05:59 mirakel kernel: ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
Sep  8 00:05:59 mirakel kernel: ata1.00: cmd 35/00:08:47:83:1c/00:00:1d:00:00/e0 tag 0 cdb 0x0 data 4096 out
Sep  8 00:05:59 mirakel kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Sep  8 00:05:59 mirakel kernel: ata1: soft resetting port
Sep  8 00:05:59 mirakel kernel: ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Sep  8 00:06:00 mirakel kernel: ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
Sep  8 00:06:00 mirakel kernel: ata2.00: cmd c8/00:08:d7:6e:6f/00:00:00:00:00/e8 tag 0 cdb 0x0 data 4096 in
Sep  8 00:06:00 mirakel kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Sep  8 00:06:00 mirakel kernel: ata2: soft resetting port
Sep  8 00:06:01 mirakel kernel: ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Sep  8 00:06:30 mirakel kernel: ata1.00: qc timeout (cmd 0x27)
Sep  8 00:06:30 mirakel kernel: ata1.00: ata_hpa_resize 1: hpa sectors (0) is smaller than sectors (490234752)
Sep  8 00:06:30 mirakel kernel: ata1.00: failed to set xfermode (err_mask=0x40)
Sep  8 00:06:30 mirakel kernel: ata1: failed to recover some devices, retrying in 5 secs
Sep  8 00:06:31 mirakel kernel: ata2.00: qc timeout (cmd 0x27)
Sep  8 00:06:31 mirakel kernel: ata2.00: ata_hpa_resize 1: hpa sectors (0) is smaller than sectors (490234752)
Sep  8 00:06:31 mirakel kernel: ata2.00: failed to set xfermode (err_mask=0x40)
Sep  8 00:06:31 mirakel kernel: ata2: failed to recover some devices, retrying in 5 secs
Sep  8 00:06:35 mirakel kernel: ata1: hard resetting port
Sep  8 00:06:35 mirakel kernel: ata1: SRST failed (errno=-19)
Sep  8 00:06:35 mirakel kernel: ata1: reset failed (errno=-19), retrying in 10 secs
Sep  8 00:06:36 mirakel kernel: ata2: hard resetting port
Sep  8 00:06:36 mirakel kernel: ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Sep  8 00:06:45 mirakel kernel: ata1: hard resetting port
Sep  8 00:06:45 mirakel kernel: ata1: SRST failed (errno=-19)
Sep  8 00:06:45 mirakel kernel: ata1: reset failed (errno=-19), retrying in 10 secs
Sep  8 00:06:55 mirakel kernel: ata1: hard resetting port
Sep  8 00:06:55 mirakel kernel: ata1: SRST failed (errno=-19)
Sep  8 00:06:55 mirakel kernel: ata1: reset failed (errno=-19), retrying in 35 secs
Sep  8 00:07:06 mirakel kernel: ata2.00: qc timeout (cmd 0x27)
Sep  8 00:07:06 mirakel kernel: ata2.00: ata_hpa_resize 1: hpa sectors (0) is smaller than sectors (490234752)
Sep  8 00:07:06 mirakel kernel: ata2.00: failed to set xfermode (err_mask=0x40)
Sep  8 00:07:06 mirakel kernel: ata2.00: limiting speed to UDMA/133:PIO3
Sep  8 00:07:06 mirakel kernel: ata2: failed to recover some devices, retrying in 5 secs
Sep  8 00:07:11 mirakel kernel: ata2: hard resetting port
Sep  8 00:07:12 mirakel kernel: ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Sep  8 00:07:30 mirakel kernel: ata1: hard resetting port
Sep  8 00:07:30 mirakel kernel: ata1: SRST failed (errno=-19)
Sep  8 00:07:30 mirakel kernel: ata1: reset failed, giving up
Sep  8 00:07:30 mirakel kernel: ata1.00: disabled
Sep  8 00:07:30 mirakel kernel: ata1: EH complete
Sep  8 00:07:30 mirakel kernel: sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Sep  8 00:07:30 mirakel kernel: end_request: I/O error, dev sda, sector 488407879
Sep  8 00:07:30 mirakel kernel: md: super_written gets error=-5, uptodate=0
Sep  8 00:07:30 mirakel kernel: raid5: Disk failure on dm-0, disabling device. Operation continuing on 7 devices
Sep  8 00:07:30 mirakel kernel: sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Sep  8 00:07:30 mirakel kernel: end_request: I/O error, dev sda, sector 141263543
Sep  8 00:07:30 mirakel kernel: sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Sep  8 00:07:30 mirakel kernel: end_request: I/O error, dev sda, sector 4560055
Sep  8 00:07:30 mirakel kernel: sd 0:0:0:0: [sda] READ CAPACITY failed
Sep  8 00:07:30 mirakel kernel: sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Sep  8 00:07:30 mirakel kernel: sd 0:0:0:0: [sda] Sense not available.
Sep  8 00:07:30 mirakel kernel: sd 0:0:0:0: [sda] Write Protect is off
Sep  8 00:07:30 mirakel kernel: sd 0:0:0:0: [sda] Asking for cache data failed
Sep  8 00:07:30 mirakel kernel: sd 0:0:0:0: [sda] Assuming drive cache: write through
Sep  8 00:07:42 mirakel kernel: ata2.00: qc timeout (cmd 0x27)
Sep  8 00:07:42 mirakel kernel: ata2.00: ata_hpa_resize 1: hpa sectors (0) is smaller than sectors (490234752)
Sep  8 00:07:42 mirakel kernel: ata2.00: failed to set xfermode (err_mask=0x40)
Sep  8 00:07:42 mirakel kernel: ata2.00: disabled
Sep  8 00:07:42 mirakel kernel: ata2: EH complete
Sep  8 00:07:42 mirakel kernel: sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Sep  8 00:07:42 mirakel kernel: end_request: I/O error, dev sdb, sector 141520599
Sep  8 00:07:42 mirakel kernel: sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Sep  8 00:07:42 mirakel kernel: end_request: I/O error, dev sdb, sector 141671879
Sep  8 00:07:42 mirakel kernel: sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Sep  8 00:07:42 mirakel kernel: end_request: I/O error, dev sdb, sector 488407879
Sep  8 00:07:42 mirakel kernel: md: super_written gets error=-5, uptodate=0
Sep  8 00:07:42 mirakel kernel: raid5: Disk failure on dm-1, disabling device. Operation continuing on 6 devices
Sep  8 00:07:42 mirakel kernel: sd 1:0:0:0: [sdb] READ CAPACITY failed
Sep  8 00:07:42 mirakel kernel: sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Sep  8 00:07:42 mirakel kernel: sd 1:0:0:0: [sdb] Sense not available.
Sep  8 00:07:42 mirakel kernel: sd 1:0:0:0: [sdb] Write Protect is off
Sep  8 00:07:42 mirakel kernel: sd 1:0:0:0: [sdb] Asking for cache data failed
Sep  8 00:07:42 mirakel kernel: sd 1:0:0:0: [sdb] Assuming drive cache: write through
Sep  8 00:08:12 mirakel kernel: ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
Sep  8 00:08:12 mirakel kernel: ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
Sep  8 00:08:12 mirakel kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Sep  8 00:08:13 mirakel kernel: ata3: soft resetting port
Sep  8 00:08:13 mirakel kernel: ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Sep  8 00:08:42 mirakel kernel: ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
Sep  8 00:08:42 mirakel kernel: ata4.00: cmd 35/00:08:bf:44:1c/00:00:1d:00:00/e0 tag 0 cdb 0x0 data 4096 out
Sep  8 00:08:42 mirakel kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Sep  8 00:08:43 mirakel kernel: ata4: soft resetting port
Sep  8 00:08:43 mirakel kernel: ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Sep  8 00:08:43 mirakel kernel: ata3.00: qc timeout (cmd 0x27)
Sep  8 00:08:43 mirakel kernel: ata3.00: ata_hpa_resize 1: hpa sectors (0) is smaller than sectors (490234752)
Sep  8 00:08:43 mirakel kernel: ata3.00: failed to set xfermode (err_mask=0x40)
Sep  8 00:08:43 mirakel kernel: ata3: failed to recover some devices, retrying in 5 secs
Sep  8 00:08:48 mirakel kernel: ata3: hard resetting port
Sep  8 00:08:48 mirakel kernel: ata3: SRST failed (errno=-19)
Sep  8 00:08:48 mirakel kernel: ata3: reset failed (errno=-19), retrying in 10 secs
Sep  8 00:08:58 mirakel kernel: ata3: hard resetting port
Sep  8 00:08:58 mirakel kernel: ata3: SRST failed (errno=-19)
Sep  8 00:08:58 mirakel kernel: ata3: reset failed (errno=-19), retrying in 10 secs
Sep  8 00:09:08 mirakel kernel: ata3: hard resetting port
Sep  8 00:09:08 mirakel kernel: ata3: SRST failed (errno=-19)
Sep  8 00:09:08 mirakel kernel: ata3: reset failed (errno=-19), retrying in 35 secs
Sep  8 00:09:13 mirakel kernel: ata4.00: qc timeout (cmd 0x27)
Sep  8 00:09:13 mirakel kernel: ata4.00: ata_hpa_resize 1: hpa sectors (0) is smaller than sectors (490234752)
Sep  8 00:09:13 mirakel kernel: ata4.00: failed to set xfermode (err_mask=0x40)
Sep  8 00:09:13 mirakel kernel: ata4: failed to recover some devices, retrying in 5 secs
Sep  8 00:09:18 mirakel kernel: ata4: hard resetting port
Sep  8 00:09:18 mirakel kernel: ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Sep  8 00:09:43 mirakel kernel: ata3: hard resetting port
Sep  8 00:09:43 mirakel kernel: ata3: SRST failed (errno=-19)
Sep  8 00:09:43 mirakel kernel: ata3: reset failed, giving up
Sep  8 00:09:43 mirakel kernel: ata3.00: disabled
Sep  8 00:09:43 mirakel kernel: ata3: EH complete
Sep  8 00:09:43 mirakel kernel: sd 2:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Sep  8 00:09:43 mirakel kernel: end_request: I/O error, dev sdc, sector 488391871
Sep  8 00:09:43 mirakel kernel: sd 2:0:0:0: [sdc] READ CAPACITY failed
Sep  8 00:09:43 mirakel kernel: sd 2:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Sep  8 00:09:43 mirakel kernel: sd 2:0:0:0: [sdc] Sense not available.
Sep  8 00:09:43 mirakel kernel: sd 2:0:0:0: [sdc] Write Protect is off
Sep  8 00:09:43 mirakel kernel: sd 2:0:0:0: [sdc] Asking for cache data failed
Sep  8 00:09:43 mirakel kernel: sd 2:0:0:0: [sdc] Assuming drive cache: write through
Sep  8 00:09:43 mirakel kernel: md: super_written gets error=-5, uptodate=0
Sep  8 00:09:43 mirakel kernel: raid5: Disk failure on sdc1, disabling device. Operation continuing on 5 devices
Sep  8 00:09:48 mirakel kernel: ata4.00: qc timeout (cmd 0x27)
Sep  8 00:09:48 mirakel kernel: ata4.00: ata_hpa_resize 1: hpa sectors (0) is smaller than sectors (490234752)
Sep  8 00:09:48 mirakel kernel: ata4.00: failed to set xfermode (err_mask=0x40)
Sep  8 00:09:48 mirakel kernel: ata4.00: limiting speed to UDMA/133:PIO3
Sep  8 00:09:48 mirakel kernel: ata4: failed to recover some devices, retrying in 5 secs
Sep  8 00:09:53 mirakel kernel: ata4: hard resetting port
Sep  8 00:09:54 mirakel kernel: ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Sep  8 00:10:24 mirakel kernel: ata4.00: qc timeout (cmd 0x27)
Sep  8 00:10:24 mirakel kernel: ata4.00: ata_hpa_resize 1: hpa sectors (0) is smaller than sectors (490234752)
Sep  8 00:10:24 mirakel kernel: ata4.00: failed to set xfermode (err_mask=0x40)
Sep  8 00:10:24 mirakel kernel: ata4.00: disabled
Sep  8 00:10:25 mirakel kernel: ata4: EH complete
Sep  8 00:10:25 mirakel kernel: sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Sep  8 00:10:25 mirakel kernel: end_request: I/O error, dev sdd, sector 488391871
Sep  8 00:10:25 mirakel kernel: md: super_written gets error=-5, uptodate=0
Sep  8 00:10:25 mirakel kernel: raid5: Disk failure on sdd1, disabling device. Operation continuing on 4 devices
Sep  8 00:10:25 mirakel kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
Sep  8 00:10:25 mirakel kernel: sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Sep  8 00:10:25 mirakel kernel: sd 3:0:0:0: [sdd] Sense not available.
Sep  8 00:10:25 mirakel kernel: sd 3:0:0:0: [sdd] Write Protect is off
Sep  8 00:10:25 mirakel kernel: sd 3:0:0:0: [sdd] Asking for cache data failed
Sep  8 00:10:25 mirakel kernel: sd 3:0:0:0: [sdd] Assuming drive cache: write through
Sep  8 00:10:25 mirakel kernel: RAID5 conf printout:
Sep  8 00:10:25 mirakel kernel:  --- rd:8 wd:4
Sep  8 00:10:25 mirakel kernel: Buffer I/O error on device md0, logical block 123716576
Sep  8 00:10:25 mirakel kernel: lost page write due to I/O error on md0
Sep  8 00:10:25 mirakel kernel:  disk 0, o:1, dev:hdg1
Sep  8 00:10:25 mirakel kernel:  disk 1, o:1, dev:hdo1
Sep  8 00:10:25 mirakel kernel: Buffer I/O error on device md0, logical block 123716499
Sep  8 00:10:25 mirakel kernel: lost page write due to I/O error on md0
Sep  8 00:10:25 mirakel kernel: Buffer I/O error on device md0, logical block 123716500
Sep  8 00:10:25 mirakel kernel: lost page write due to I/O error on md0
Sep  8 00:10:25 mirakel kernel: Buffer I/O error on device md0, logical block 123716501
Sep  8 00:10:25 mirakel kernel: lost page write due to I/O error on md0
Sep  8 00:10:25 mirakel kernel: Buffer I/O error on device md0, logical block 6175
Sep  8 00:10:25 mirakel kernel: lost page write due to I/O error on md0
Sep  8 00:10:25 mirakel kernel: Aborting journal on device md0.
Sep  8 00:10:25 mirakel kernel: EXT3-fs error (device md0) in ext3_reserve_inode_write: Journal has aborted
Sep  8 00:10:25 mirakel kernel:  disk 2, o:0, dev:dm-1
Sep  8 00:10:25 mirakel kernel:  disk 3, o:1, dev:hds1
Sep  8 00:10:25 mirakel kernel:  disk 4, o:0, dev:dm-0
Sep  8 00:10:25 mirakel kernel:  disk 5, o:0, dev:sdc1
Sep  8 00:10:25 mirakel kernel:  disk 6, o:1, dev:hdk1
Sep  8 00:10:25 mirakel kernel:  disk 7, o:0, dev:sdd1
Sep  8 00:10:25 mirakel kernel: Buffer I/O error on device md0, logical block 0
Sep  8 00:10:25 mirakel kernel: lost page write due to I/O error on md0
Sep  8 00:10:25 mirakel kernel: EXT3-fs error (device md0) in ext3_dirty_inode: Journal has aborted
Sep  8 00:10:25 mirakel kernel: Buffer I/O error on device md0, logical block 0
Sep  8 00:10:25 mirakel kernel: lost page write due to I/O error on md0
Sep  8 00:10:25 mirakel kernel: EXT3-fs error (device md0) in ext3_free_blocks_sb: Journal has aborted
Sep  8 00:10:26 mirakel kernel: ext3_abort called.
Sep  8 00:10:26 mirakel kernel: EXT3-fs error (device md0): ext3_journal_start_sb: Detected aborted journal
Sep  8 00:10:26 mirakel kernel: Remounting filesystem read-only
Sep  8 00:10:26 mirakel kernel: Buffer I/O error on device md0, logical block 123686376
Sep  8 00:10:26 mirakel kernel: lost page write due to I/O error on md0
Sep  8 00:10:26 mirakel kernel: Buffer I/O error on device md0, logical block 123689709
Sep  8 00:10:26 mirakel kernel: lost page write due to I/O error on md0
Sep  8 00:10:26 mirakel kernel: Buffer I/O error on device md0, logical block 123689744
Sep  8 00:10:26 mirakel kernel: lost page write due to I/O error on md0
Sep  8 00:10:26 mirakel kernel: RAID5 conf printout:
Sep  8 00:10:26 mirakel kernel:  --- rd:8 wd:4
Sep  8 00:10:26 mirakel kernel:  disk 0, o:1, dev:hdg1
Sep  8 00:10:26 mirakel kernel:  disk 1, o:1, dev:hdo1
Sep  8 00:10:26 mirakel kernel:  disk 2, o:0, dev:dm-1
Sep  8 00:10:26 mirakel kernel:  disk 3, o:1, dev:hds1
Sep  8 00:10:26 mirakel kernel:  disk 4, o:0, dev:dm-0
Sep  8 00:10:26 mirakel kernel:  disk 5, o:0, dev:sdc1
Sep  8 00:10:26 mirakel kernel:  disk 6, o:1, dev:hdk1
Sep  8 00:10:26 mirakel kernel: RAID5 conf printout:
Sep  8 00:10:26 mirakel kernel:  --- rd:8 wd:4
Sep  8 00:10:26 mirakel kernel:  disk 0, o:1, dev:hdg1
Sep  8 00:10:26 mirakel kernel:  disk 1, o:1, dev:hdo1
Sep  8 00:10:26 mirakel kernel:  disk 2, o:0, dev:dm-1
Sep  8 00:10:26 mirakel kernel:  disk 3, o:1, dev:hds1
Sep  8 00:10:26 mirakel kernel:  disk 4, o:0, dev:dm-0
Sep  8 00:10:26 mirakel kernel:  disk 5, o:0, dev:sdc1
Sep  8 00:10:26 mirakel kernel:  disk 6, o:1, dev:hdk1
Sep  8 00:10:26 mirakel kernel: RAID5 conf printout:
Sep  8 00:10:26 mirakel kernel:  --- rd:8 wd:4
Sep  8 00:10:26 mirakel kernel:  disk 0, o:1, dev:hdg1
Sep  8 00:10:26 mirakel kernel:  disk 1, o:1, dev:hdo1
Sep  8 00:10:26 mirakel kernel:  disk 2, o:0, dev:dm-1
Sep  8 00:10:26 mirakel kernel:  disk 3, o:1, dev:hds1
Sep  8 00:10:27 mirakel kernel:  disk 4, o:0, dev:dm-0
Sep  8 00:10:27 mirakel kernel:  disk 6, o:1, dev:hdk1
Sep  8 00:10:27 mirakel kernel: RAID5 conf printout:
Sep  8 00:10:27 mirakel kernel:  --- rd:8 wd:4
Sep  8 00:10:27 mirakel kernel:  disk 0, o:1, dev:hdg1
Sep  8 00:10:27 mirakel kernel:  disk 1, o:1, dev:hdo1
Sep  8 00:10:27 mirakel kernel:  disk 2, o:0, dev:dm-1
Sep  8 00:10:27 mirakel kernel:  disk 3, o:1, dev:hds1
Sep  8 00:10:27 mirakel kernel:  disk 4, o:0, dev:dm-0
Sep  8 00:10:27 mirakel kernel:  disk 6, o:1, dev:hdk1
Sep  8 00:10:27 mirakel kernel: RAID5 conf printout:
Sep  8 00:10:27 mirakel kernel:  --- rd:8 wd:4
Sep  8 00:10:27 mirakel kernel:  disk 0, o:1, dev:hdg1
Sep  8 00:10:27 mirakel kernel:  disk 1, o:1, dev:hdo1
Sep  8 00:10:27 mirakel kernel:  disk 2, o:0, dev:dm-1
Sep  8 00:10:27 mirakel kernel:  disk 3, o:1, dev:hds1
Sep  8 00:10:27 mirakel kernel:  disk 6, o:1, dev:hdk1
Sep  8 00:10:27 mirakel kernel: RAID5 conf printout:
Sep  8 00:10:27 mirakel kernel:  --- rd:8 wd:4
Sep  8 00:10:27 mirakel kernel:  disk 0, o:1, dev:hdg1
Sep  8 00:10:27 mirakel kernel:  disk 1, o:1, dev:hdo1
Sep  8 00:10:27 mirakel kernel:  disk 2, o:0, dev:dm-1
Sep  8 00:10:27 mirakel kernel:  disk 3, o:1, dev:hds1
Sep  8 00:10:27 mirakel kernel:  disk 6, o:1, dev:hdk1
Sep  8 00:10:27 mirakel kernel: RAID5 conf printout:
Sep  8 00:10:27 mirakel kernel:  --- rd:8 wd:4
Sep  8 00:10:27 mirakel kernel:  disk 0, o:1, dev:hdg1
Sep  8 00:10:27 mirakel kernel:  disk 1, o:1, dev:hdo1
Sep  8 00:10:27 mirakel kernel:  disk 3, o:1, dev:hds1
Sep  8 00:10:27 mirakel kernel:  disk 6, o:1, dev:hdk1
Sep  8 00:10:27 mirakel kernel: EXT3-fs error (device md0): ext3_readdir: directory #126337 contains a hole at offset 4096


--------------090408090302080800060304--
