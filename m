Return-Path: <linux-kernel-owner+w=401wt.eu-S1758709AbZAMNkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709AbZAMNkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:40:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbZAMNj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:39:58 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36190 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbZAMNj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:39:57 -0500
Date: Tue, 13 Jan 2009 14:42:05 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, jack@suse.cz
Subject: ext2 triggers WARN_ON() when media is unplugged.
Message-ID: <20090113134203.GA4354@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-rc1-git, pretty reproducible: mount -osync, start write
workload, pull the drive.
									Pavel


...
scsi 1:0:0:0: Direct-Access     ATA      Hitachi HTS54168 SB2O PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 156301488 512-byte hardware sectors: (80.0 GB/74.5 GiB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sdb] 156301488 512-byte hardware sectors: (80.0 GB/74.5 GiB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3
sd 1:0:0:0: [sdb] Attached SCSI disk
sd 1:0:0:0: Attached scsi generic sg1 type 0
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb1, internal journal
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with writeback data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb1, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb1, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb1, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
ata2.00: configured for UDMA/100
ata2: EH complete
sd 1:0:0:0: [sdb] 156301488 512-byte hardware sectors: (80.0 GB/74.5 GiB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
ata2: exception Emask 0x10 SAct 0x0 SErr 0x90200 action 0xe frozen
ata2: irq_stat 0x00400000, PHY RDY changed
ata2: SError: { Persist PHYRdyChg 10B8B }
ata2: hard resetting link
ata2: SATA link down (SStatus 0 SControl 300)
ata2: hard resetting link
ata2: SATA link down (SStatus 0 SControl 300)
ata2: hard resetting link
ata2: SATA link down (SStatus 0 SControl 300)
ata2.00: disabled
ata2: EH complete
sd 1:0:0:0: rejecting I/O to offline device
sd 1:0:0:0: [sdb] Unhandled error code
sd 1:0:0:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
end_request: I/O error, dev sdb, sector 4991
Buffer I/O error on device sdb1, logical block 616
lost page write due to I/O error on sdb1
ata2.00: detaching (SCSI 1:0:0:0)
ahci: autosuspend disabled
sd 1:0:0:0: [sdb] Stopping disk
sd 1:0:0:0: [sdb] START_STOP FAILED
sd 1:0:0:0: [sdb] Result: hostbyte=0x04 driverbyte=0x00
------------[ cut here ]------------
WARNING: at /data/l/linux/fs/buffer.c:1250 mark_buffer_dirty+0x66/0x80()
Hardware name: ANT
Modules linked in:
Pid: 2970, comm: umount Not tainted 2.6.29-rc1 #263
Call Trace:
 [<ffffffff8023da92>] warn_slowpath+0xf2/0x130
 [<ffffffff80273502>] find_get_pages+0x32/0xd0
 [<ffffffff8027ac67>] pagevec_lookup+0x17/0x20
 [<ffffffff8027b378>] truncate_inode_pages_range+0x188/0x360
 [<ffffffff80297833>] cache_free_debugcheck+0x103/0x230
 [<ffffffff802bcd56>] mark_buffer_dirty+0x66/0x80
 [<ffffffff80331249>] ext2_sync_super+0x39/0x60
 [<ffffffff803320bc>] ext2_put_super+0xdc/0x100
 [<ffffffff8029dfbb>] generic_shutdown_super+0x6b/0x110
 [<ffffffff8029e089>] kill_block_super+0x29/0x50
 [<ffffffff8029e16f>] deactivate_super+0x5f/0x80
 [<ffffffff802b2746>] sys_umount+0x76/0x380
 [<ffffffff8022bb72>] ia32_sysret+0x0/0xa
---[ end trace 1a98d19d85775109 ]---
scsi 1:0:0:0: rejecting I/O to dead device

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
