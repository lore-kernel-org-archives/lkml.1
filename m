Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbZGZKKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbZGZKKf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 06:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbZGZKKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 06:10:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60811 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbZGZKKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 06:10:33 -0400
Date: Sun, 26 Jul 2009 12:10:28 +0200
From: Andi Kleen <andi@firstfloor.org>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: WARN_ON namespace.c:638 mntput_no_expire on umount in 2.6.30
Message-ID: <20090726101028.GA11367@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Saw this when umounting a VFAT USB stick before it got pulled out.
Haven't investigated, but thought I should post it.

-Andi

usb 2-1: new high speed USB device using ehci_hcd and address 4
usb 2-1: configuration #1 chosen from 1 choice
scsi6 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 4
usb-storage: waiting for device to settle before scanning
scsi 6:0:0:0: Direct-Access     USB      Flash Disk       5.00 PQ: 0 ANSI: 2
sd 6:0:0:0: Attached scsi generic sg1 type 0
sd 6:0:0:0: [sdb] 4087808 512-byte hardware sectors: (2.09 GB/1.94 GiB)
usb-storage: device scan complete
sd 6:0:0:0: [sdb] Write Protect is off
sd 6:0:0:0: [sdb] Mode Sense: 0b 00 00 08
sd 6:0:0:0: [sdb] Assuming drive cache: write through
sd 6:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
sd 6:0:0:0: [sdb] Attached SCSI removable disk
------------[ cut here ]------------
WARNING: at /home/lsrc/linux-2.6.30-ak/fs/namespace.c:638 mntput_no_expire+0xcf/0x11b()
Hardware name:         
Modules linked in:  ...
Pid: 8749, comm: umount Not tainted 2.6.30.2-BASIL #7
Call Trace:
 [<ffffffff8020e284>] dump_trace+0x6e/0x292
 [<ffffffff805bccb3>] dump_stack+0x69/0x6f
 [<ffffffff802376db>] warn_slowpath_common+0x77/0xa2
 [<ffffffff802b78a1>] mntput_no_expire+0xcf/0x11b
 [<ffffffff802b7e27>] sys_umount+0x2b7/0x2e2
 [<ffffffff8020ba6b>] system_call_fastpath+0x16/0x1b
 [<00007fe4739421c7>] 0x7fe4739421c7
---[ end trace 6fa485b25ae0195b ]---
usb 2-1: USB disconnect, address 4

-- 
ak@linux.intel.com -- Speaking for myself only.
