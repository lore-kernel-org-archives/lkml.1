Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab0CBAPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 19:15:53 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:65283 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab0CBAPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 19:15:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=p//TpjsnVtVkGa/RZFeB3HUbtlqAOk1jf+yAoaFgztGO4tIPEcQ6fWcZibTWpNX8bB
         eHVZDI2HPBv9muRKCM8TF4N6d+Ww/Xy/UaDlCdVjuoVm1GToqADG/DPn04wUffMDnhcd
         6sBD2GA53kV/WrXR7xyo8/2vAq7QlfsKfJJ84=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Oops while booting 2.6.34-rc0 (block pull busted)
Date: Mon, 1 Mar 2010 16:15:30 -0800
User-Agent: KMail/1.13.0 (Linux/2.6.33-rc8; KDE/4.4.0; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003011615.31709.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It looks like block tree that has been pulled today into mainline is
busted, I am getting the Opps below on boot with the following commit:

commit b1bf9368407ae7e89d8a005bb40beb70a41df539
Merge: 524df55 4671a13
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Mar 1 09:00:29 2010 -0800

    Merge branch 'for-2.6.34' of git://git.kernel.dk/linux-2.6-block
 

but not with the previous one:

commit 524df55725217b13d5a232fb5badb5846418ea0e
Merge: 0f45339 6679ee1
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Mar 1 08:58:44 2010 -0800

    Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6

This is on plain Fedora 12 VM.

Thanks.

-- 
Dmitry

sd 2:0:0:0: Attached scsi generic sg1 type 0
sd 2:0:0:0: [sda] 16777216 512-byte logical blocks: (8.58 GB/8.00 GiB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Cache data unavailable
sd 2:0:0:0: [sda] Assuming drive cache: write through
sd 2:0:0:0: [sda] Cache data unavailable
sd 2:0:0:0: [sda] Assuming drive cache: write through
 sda: sda1 sda2
sd 2:0:0:0: [sda] Cache data unavailable
sd 2:0:0:0: [sda] Assuming drive cache: write through
sd 2:0:0:0: [sda] Attached SCSI disk
device-mapper: multipath: version 1.1.1 loaded
dracut: Scanning devices sda2  for LVM volume groups 
dracut: Reading all physical volumes. This may take a while...
dracut: Found volume group "VolGroup" using metadata type lvm2
dracut: 2 logical volume(s) in volume group "VolGroup" now active
EXT4-fs (dm-0): mounted filesystem with ordered data mode
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffff81128ee1>] mpage_end_io_read+0x45/0x6f
PGD 3b776067 PUD 3b7b1067 PMD 0 
Oops: 0002 [#1] SMP 
last sysfs file: /sys/kernel/uevent_seqnum
CPU 0 
Modules linked in: dm_multipath mptspi mptscsih mptbase scsi_transport_spi floppy [last unloaded: scsi_wait_scan]

Pid: 1, comm: init Not tainted 2.6.33 #4 440BX Desktop Reference Platform/VMware Virtual Platform
RIP: 0010:[<ffffffff81128ee1>]  [<ffffffff81128ee1>] mpage_end_io_read+0x45/0x6f
RSP: 0018:ffff88003ea957b8  EFLAGS: 00010202
RAX: ffffffff81128e9c RBX: ffff880037740dd0 RCX: 0000000000000000
RDX: ffff880037f9c088 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff88003ea957d8 R08: 0000000000000000 R09: ffff880037e93c08
R10: 0000000000000001 R11: 0000000000000001 R12: ffff880037740d80
R13: 0000000000000001 R14: 0000000000000000 R15: ffff880037740d80
FS:  00007f7cde1ec700(0000) GS:ffff880001e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000003b79e000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process init (pid: 1, threadinfo ffff88003ea94000, task ffff88003ea98000)
Stack:
 ffff88003ea957e8 ffff880037fe9208 ffff880037f9c000 0000000000000000
<0> ffff88003ea957e8 ffffffff811246cd ffff88003ea95838 ffffffff81352f8c
<0> ffff88003ea95828 ffff88003b7072f8 ffff88003ea95838 ffff880037f9c000
Call Trace:
 [<ffffffff811246cd>] bio_endio+0x2b/0x2d
 [<ffffffff81352f8c>] dec_pending+0x13d/0x15c
 [<ffffffff81353bd2>] __split_and_process_bio+0x510/0x52b
 [<ffffffff81353f8c>] dm_request+0x1cd/0x1e0
 [<ffffffff811eb999>] generic_make_request+0x23b/0x2b0
 [<ffffffff81356c78>] ? linear_merge+0x0/0x5d
 [<ffffffff813540bf>] ? dm_merge_bvec+0xcb/0xec
 [<ffffffff811ebae0>] submit_bio+0xd2/0xef
 [<ffffffff81128e25>] mpage_bio_submit+0x27/0x2b
 [<ffffffff811293c6>] do_mpage_readpage+0x3e0/0x483
 [<ffffffff810cb385>] ? ____pagevec_lru_add+0x138/0x14f
 [<ffffffff81129590>] mpage_readpages+0xc5/0x104
 [<ffffffff81175f53>] ? ext4_get_block+0x0/0xe9
 [<ffffffff81175f53>] ? ext4_get_block+0x0/0xe9
 [<ffffffff81173880>] ext4_readpages+0x1d/0x1f
 [<ffffffff810ca855>] __do_page_cache_readahead+0x103/0x176
 [<ffffffff8100a5ce>] ? apic_timer_interrupt+0xe/0x20
 [<ffffffff810ca8e9>] ra_submit+0x21/0x25
 [<ffffffff810cab55>] ondemand_readahead+0x18e/0x1a1
 [<ffffffff810cac25>] page_cache_sync_readahead+0x1c/0x1e
 [<ffffffff810c4209>] generic_file_aio_read+0x201/0x504
 [<ffffffff81101625>] do_sync_read+0xc4/0x101
 [<ffffffff81205803>] ? might_fault+0x21/0x23
 [<ffffffff811c98f3>] ? selinux_file_permission+0x5c/0xb3
 [<ffffffff811bfcfd>] ? security_file_permission+0x16/0x18
 [<ffffffff81101c8c>] vfs_read+0xab/0x108
 [<ffffffff81101da9>] sys_read+0x4a/0x6e
 [<ffffffff81009c32>] system_call_fastpath+0x16/0x1b
Code: 49 89 fc 41 83 e5 01 48 ff cb 48 c1 e3 04 48 03 5f 48 48 8b 3b 48 83 eb 10 49 3b 5c 24 48 72 06 48 8b 03 0f 0d 08 45 85 ed 74 06 <3e> 80 0f 08 eb 08 3e 80 27 f7 
3e 80 0f  
RIP  [<ffffffff81128ee1>] mpage_end_io_read+0x45/0x6f
 RSP <ffff88003ea957b8>
CR2: 0000000000000000
---[ end trace ffacf7730488df2f ]---
Kernel panic - not syncing: Attempted to kill init!
Pid: 1, comm: init Tainted: G      D    2.6.33 #4
Call Trace:
 [<ffffffff8142fd51>] panic+0x7a/0x13d
 [<ffffffff8105628b>] ? exit_ptrace+0x38/0x121
 [<ffffffff8104f5b9>] do_exit+0x7a/0x6f3
 [<ffffffff8104bfc9>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff8104cbe2>] ? kmsg_dump+0x12b/0x145
 [<ffffffff81432ff6>] oops_end+0xbf/0xc7
 [<ffffffff8102f8f5>] no_context+0x1fc/0x20b
 [<ffffffff8100f967>] ? nommu_map_sg+0xd1/0xe5
 [<ffffffff8102fa88>] __bad_area_nosemaphore+0x184/0x1a7
 [<ffffffff8100a5ce>] ? apic_timer_interrupt+0xe/0x20
 [<ffffffff8102fb08>] __bad_area+0x48/0x4f
 [<ffffffff81434aab>] ? do_page_fault+0x1bd/0x2a0
 [<ffffffff8102fb22>] bad_area+0x13/0x15
 [<ffffffff81434ab9>] do_page_fault+0x1cb/0x2a0
 [<ffffffff81432475>] page_fault+0x25/0x30
 [<ffffffff81128e9c>] ? mpage_end_io_read+0x0/0x6f
 [<ffffffff81128ee1>] ? mpage_end_io_read+0x45/0x6f
 [<ffffffff811246cd>] bio_endio+0x2b/0x2d
 [<ffffffff81352f8c>] dec_pending+0x13d/0x15c
 [<ffffffff81353bd2>] __split_and_process_bio+0x510/0x52b
 [<ffffffff81353f8c>] dm_request+0x1cd/0x1e0
 [<ffffffff811eb999>] generic_make_request+0x23b/0x2b0
 [<ffffffff81356c78>] ? linear_merge+0x0/0x5d
 [<ffffffff813540bf>] ? dm_merge_bvec+0xcb/0xec
 [<ffffffff811ebae0>] submit_bio+0xd2/0xef
 [<ffffffff81128e25>] mpage_bio_submit+0x27/0x2b
 [<ffffffff811293c6>] do_mpage_readpage+0x3e0/0x483
 [<ffffffff810cb385>] ? ____pagevec_lru_add+0x138/0x14f
 [<ffffffff81129590>] mpage_readpages+0xc5/0x104
 [<ffffffff81175f53>] ? ext4_get_block+0x0/0xe9
 [<ffffffff81175f53>] ? ext4_get_block+0x0/0xe9
 [<ffffffff81173880>] ext4_readpages+0x1d/0x1f
 [<ffffffff810ca855>] __do_page_cache_readahead+0x103/0x176
 [<ffffffff8100a5ce>] ? apic_timer_interrupt+0xe/0x20
 [<ffffffff810ca8e9>] ra_submit+0x21/0x25
 [<ffffffff810cab55>] ondemand_readahead+0x18e/0x1a1
 [<ffffffff810cac25>] page_cache_sync_readahead+0x1c/0x1e
 [<ffffffff810c4209>] generic_file_aio_read+0x201/0x504
 [<ffffffff81101625>] do_sync_read+0xc4/0x101
 [<ffffffff81205803>] ? might_fault+0x21/0x23
 [<ffffffff811c98f3>] ? selinux_file_permission+0x5c/0xb3
 [<ffffffff811bfcfd>] ? security_file_permission+0x16/0x18
 [<ffffffff81101c8c>] vfs_read+0xab/0x108
 [<ffffffff81101da9>] sys_read+0x4a/0x6e
 [<ffffffff81009c32>] system_call_fastpath+0x16/0x1b
