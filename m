Return-Path: <linux-kernel-owner+w=401wt.eu-S1754185Ab0AGVrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab0AGVrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 16:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152Ab0AGVrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 16:47:22 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51824 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139Ab0AGVrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 16:47:19 -0500
Date: Thu, 7 Jan 2010 22:47:07 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Subject: 2.6.33-rc3: usb disk disconnects during heavy use?
Message-ID: <20100107214707.GA25538@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Somehow usb2 disk disconnected during rsync on -rc3. Not sure what is
going on, I did not have that problem before.

dmesg says:

									Pavel

usb 1-5:1.0: uevent
usb-storage 1-5:1.0: usb_probe_interface
usb-storage 1-5:1.0: usb_probe_interface - got id
scsi8 : usb-storage 1-5:1.0
drivers/usb/core/inode.c: creating file '008'
scsi 8:0:0:0: Direct-Access     HTS54106 0G9SA00               PQ: 0 ANSI: 2 CCS
sd 8:0:0:0: Attached scsi generic sg2 type 0
sd 8:0:0:0: [sdc] 117210240 512-byte logical blocks: (60.0 GB/55.8 GiB)
sd 8:0:0:0: [sdc] Write Protect is off
sd 8:0:0:0: [sdc] Mode Sense: 3c 00 00 00
sd 8:0:0:0: [sdc] Assuming drive cache: write through
sd 8:0:0:0: [sdc] Assuming drive cache: write through
 sdc: sdc1 sdc2 sdc4
sd 8:0:0:0: [sdc] Assuming drive cache: write through
sd 8:0:0:0: [sdc] Attached SCSI disk
usb 1-5:1.0: uevent
usb 1-5: uevent
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sdc2): using internal journal
EXT3-fs (sdc2): mounted filesystem with ordered data mode
thinkpad_acpi: THERMAL EMERGENCY: a sensor reports something is extremely hot!
thinkpad_acpi: temperatures (Celsius): 95 47 N/A 89 47 N/A 41 N/A 51 61 N/A N/A N/A N/A N/A N/A
ehci_hcd 0000:00:1d.7: port 5 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 5 status 001005 POWER sig=se0 PE CONNECT
usb 1-5: reset high speed USB device using ehci_hcd and address 8
ehci_hcd 0000:00:1d.7: port 5 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 5 status 001005 POWER sig=se0 PE CONNECT
usb 1-5: serial string changed
usb 1-5: device firmware changed
hub 1-0:1.0: logical disconnect on port 5
hub 1-0:1.0: state 7 ports 8 chg 0020 evt 0000
hub 1-0:1.0: port 5, status 0501, change 0000, 480 Mb/s
usb 1-5: USB disconnect, address 8
usb 1-5: unregistering device
usb 1-5: usb_disable_device nuking all URBs
sd 8:0:0:0: Device offlined - not ready after error recovery
sd 8:0:0:0: [sdc] Unhandled error code
sd 8:0:0:0: [sdc] Result: hostbyte=0x05 driverbyte=0x00
sd 8:0:0:0: [sdc] CDB: cdb[0]=0x28: 28 00 00 f5 a9 84 00 00 10 00
end_request: I/O error, dev sdc, sector 16099716
Buffer I/O error on device sdc2, logical block 590712
Buffer I/O error on device sdc2, logical block 590713
sd 8:0:0:0: rejecting I/O to offline device
sd 8:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sdc2): ext3_get_inode_loc: unable to read inode block - inode=6572033, block=13140034
sd 8:0:0:0: [sdc] Unhandled error code
sd 8:0:0:0: [sdc] Result: hostbyte=0x01 driverbyte=0x00
sd 8:0:0:0: [sdc] CDB: cdb[0]=0x28: 28 00 04 d2 0f 64 00 00 08 00
end_request: I/O error, dev sdc, sector 80875364
sd 8:0:0:0: rejecting I/O to offline device
EXT3-fs (sdc2): error in ext3_reserve_inode_write: IO failure
sd 8:0:0:0: rejecting I/O to offline device
------------[ cut here ]------------
WARNING: at fs/buffer.c:1159 mark_buffer_dirty+0x7f/0x90()
Hardware name: 17097HU
Modules linked in:
Pid: 23312, comm: rsync Not tainted 2.6.33-rc2-00433-g4029bc8-dirty #102
Call Trace:
 [<c07a4023>] ? printk+0x18/0x1a
 [<c02c470f>] ? mark_buffer_dirty+0x7f/0x90
 [<c023404c>] warn_slowpath_common+0x6c/0xc0
 [<c02c470f>] ? mark_buffer_dirty+0x7f/0x90
 [<c02340b5>] warn_slowpath_null+0x15/0x20
 [<c02c470f>] mark_buffer_dirty+0x7f/0x90
 [<c02fa014>] ext3_commit_super+0x44/0x80
 [<c02fb5ab>] ext3_handle_error+0x6b/0xc0
 [<c02fa724>] ? ext3_msg+0x44/0x50
 [<c02fb654>] __ext3_std_error+0x54/0x70
 [<c02f1fe1>] ext3_reserve_inode_write+0x41/0x80
 [<c02f203d>] ext3_mark_inode_dirty+0x1d/0x40
 [<c02f11fc>] ext3_new_inode+0x7fc/0x8e0
 [<c030b3ca>] ? start_this_handle+0x34a/0x3d0
 [<c030b378>] ? start_this_handle+0x2f8/0x3d0
 [<c030b5df>] ? journal_start+0x9f/0xe0
 [<c02f8653>] ext3_create+0x93/0xf0
 [<c02abb7c>] vfs_create+0x8c/0xe0
 [<c02f85c0>] ? ext3_create+0x0/0xf0
 [<c02aeb4e>] do_filp_open+0x9ee/0xc00
 [<c02b7ed8>] ? alloc_fd+0xd8/0xf0
 [<c07a738d>] ? _raw_spin_unlock+0x1d/0x20
 [<c02b7ed8>] ? alloc_fd+0xd8/0xf0
 [<c02a0fc5>] do_sys_open+0x65/0x130
 [<c02a10f9>] sys_open+0x29/0x40
 [<c0202c50>] sysenter_do_call+0x12/0x31
---[ end trace 36c2c36b9b27c247 ]---
sd 8:0:0:0: rejecting I/O to offline device
EXT3-fs (sdc2): error in ext3_new_inode: IO failure
sd 8:0:0:0: rejecting I/O to offline device
sd 8:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sdc2): ext3_get_inode_loc: unable to read inode block - inode=6572033, block=13140034
sd 8:0:0:0: rejecting I/O to offline device
EXT3-fs (sdc2): error in ext3_reserve_inode_write: IO failure
sd 8:0:0:0: rejecting I/O to offline device
...
sd 8:0:0:0: rejecting I/O to offline device
usb 1-5: unregistering interface 1-5:1.0
EXT3-fs error (device sdc2): ext3_get_inode_loc: unable to read inode block - inode=6572035, block=13140034
EXT3-fs (sdc2): error in ext3_reserve_inode_write: IO failure
EXT3-fs (sdc2): error in ext3_new_inode: IO failure
EXT3-fs error (device sdc2): ext3_get_inode_loc: unable to read inode block - inode=6572035, block=13140034
EXT3-fs (sdc2): error in ext3_reserve_inode_write: IO failure
EXT3-fs error (device sdc2): ext3_get_inode_loc: unable to read inode block - inode=6572036, block=13140034
EXT3-fs (sdc2): error in ext3_reserve_inode_write: IO failure
EXT3-fs (sdc2): error in ext3_new_inode: IO failure
EXT3-fs error (device sdc2): ext3_get_inode_loc: unable to read inode block - inode=6572036, block=13140034
EXT3-fs (sdc2): error in ext3_reserve_inode_write: IO failure
JBD: Detected IO errors while flushing file data on sdc2
Aborting journal on device sdc2.
usb 1-5:1.0: uevent
usb 1-5: uevent
ehci_hcd 0000:00:1d.7: port 5 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 5 status 001005 POWER sig=se0 PE CONNECT
usb 1-5: new high speed USB device using ehci_hcd and address 9
ehci_hcd 0000:00:1d.7: port 5 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 5 status 001005 POWER sig=se0 PE CONNECT
usb 1-5: default language 0x0409
usb 1-5: udev 9, busnum 1, minor = 8
usb 1-5: New USB device found, idVendor=152d, idProduct=2339
usb 1-5: New USB device strings: Mfr=1, Product=2, SerialNumber=5
usb 1-5: Product: USB to ATA/ATAPI Bridge
usb 1-5: Manufacturer: JMicron
usb 1-5: SerialNumber: BC0FFFFFFFFF
usb 1-5: uevent
usb 1-5: usb_probe_device
usb 1-5: configuration #1 chosen from 1 choice
usb 1-5: adding 1-5:1.0 (config #1, interface 0)
usb 1-5:1.0: uevent
usb-storage 1-5:1.0: usb_probe_interface
usb-storage 1-5:1.0: usb_probe_interface - got id
scsi9 : usb-storage 1-5:1.0
drivers/usb/core/inode.c: creating file '009'
scsi 9:0:0:0: Direct-Access     HTS54106 0G9SA00               PQ: 0 ANSI: 2 CCS
sd 9:0:0:0: Attached scsi generic sg2 type 0
sd 9:0:0:0: [sdd] 117210240 512-byte logical blocks: (60.0 GB/55.8 GiB)
sd 9:0:0:0: [sdd] Write Protect is off
sd 9:0:0:0: [sdd] Mode Sense: 3c 00 00 00
sd 9:0:0:0: [sdd] Assuming drive cache: write through
sd 9:0:0:0: [sdd] Assuming drive cache: write through
 sdd: sdd1 sdd2 sdd4
sd 9:0:0:0: [sdd] Assuming drive cache: write through
sd 9:0:0:0: [sdd] Attached SCSI disk
usb 1-5:1.0: uevent
usb 1-5: uevent
EXT3-fs error (device sdc2): ext3_find_entry: reading directory #6094849 offset 0
EXT3-fs error (device sdc2): ext3_readdir: directory #6094849 contains a hole at offset 0
EXT3-fs (sdc2): error: ext3_journal_start_sb: Detected aborted journal
EXT3-fs (sdc2): error: remounting filesystem read-only
EXT3-fs (sdc2): error: ext3_put_super: Couldn't clean up the journal

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
