Return-Path: <linux-kernel-owner+w=401wt.eu-S1760096AbZKLEyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096AbZKLEyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 23:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760075AbZKLEyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 23:54:45 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:39109 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759978AbZKLEyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 23:54:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=S6tD+Ezg3ZU6dtrZRdPxjSHAvHouxrkQlAEkjz60WNQVP9GFT8KTkstQB2ujh9Tkon
         frQ5Z3YKSUKgQFjWWVXQOIlPTBTyc0sL7qXCRtFl+KbMW4fZ57V0sayGBr0o28TZpu+a
         kTOO+xknWGKwgj/zf5GTvKaIO5IfxfkE7JE84=
MIME-Version: 1.0
Date: Thu, 12 Nov 2009 12:54:49 +0800
Message-ID: <804dabb00911112054i36adc7b4h265bd91838926fdf@mail.gmail.com>
Subject: btrfs-related crashes
From: Peter Teoh <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is also reported in bugzilla:

http://bugzilla.kernel.org/show_bug.cgi?id=14589

While playing with the btrfs in the latest linus-git tree (2.6.32-rc5), I got
many dump in dmesg, which I highlight a few here:

------------[ cut here ]------------
WARNING: at fs/btrfs/extent_io.c:3523 map_private_extent_buffer+0xc0/0x119()
Hardware name: System Product Name
Modules linked in: scsi_wait_scan
Pid: 20157, comm: loop0 Tainted: G        W  2.6.32-rc5 #3
Call Trace:
 [<ffffffff81404a89>] ? map_private_extent_buffer+0xc0/0x119
 [<ffffffff81089c27>] warn_slowpath_common+0x8d/0xd0
 [<ffffffff81089c91>] warn_slowpath_null+0x27/0x3d
 [<ffffffff81404a89>] map_private_extent_buffer+0xc0/0x119
 [<ffffffff81089b44>] ? add_taint+0xe/0x64
 [<ffffffff81404b62>] map_extent_buffer+0x80/0xd1
 [<ffffffff813f9d82>] btrfs_key_blockptr+0x84/0xe8
 [<ffffffff813cfdcd>] read_block_for_search+0x63/0x2de
 [<ffffffff813cfa56>] ? unlock_up+0x16/0x105
 [<ffffffff813d51da>] btrfs_search_slot+0x3d7/0x50f
 [<ffffffff81404333>] ? unmap_extent_buffer+0xd/0x41
 [<ffffffff81404de2>] ? free_extent_buffer+0xd/0x56
 [<ffffffff813e2b3d>] btrfs_csum_file_blocks+0x247/0x6bc
 [<ffffffff81416500>] ? copy_items+0x239/0x346
 [<ffffffff810cae23>] ? trace_hardirqs_on+0x20/0x36
 [<ffffffff814165dc>] ? copy_items+0x315/0x346
 [<ffffffff814165c4>] copy_items+0x2fd/0x346
 [<ffffffff81417bad>] btrfs_log_inode+0x355/0x42e
 [<ffffffff810caaa5>] ? mark_held_locks+0x60/0x96
 [<ffffffff810cadc2>] ? trace_hardirqs_on_caller+0x132/0x173
 [<ffffffff810cae23>] ? trace_hardirqs_on+0x20/0x36
 [<ffffffff8141802a>] btrfs_log_inode_parent+0x20d/0x2e2
 [<ffffffff813ea9b4>] ? start_transaction+0x137/0x159
 [<ffffffff814181b8>] btrfs_log_dentry_safe+0x2c/0x42
 [<ffffffff813f5b31>] btrfs_sync_file+0x103/0x18f
 [<ffffffff811a15ba>] vfs_fsync_range+0x90/0xd1
 [<ffffffff811a169f>] vfs_fsync+0x30/0x46
 [<ffffffff8160c74f>] loop_thread+0x2ee/0x53f
 [<ffffffff8160bf6c>] ? do_lo_send_direct_write+0x0/0x8e
 [<ffffffff810b5234>] ? autoremove_wake_function+0x0/0x63
 [<ffffffff8160c461>] ? loop_thread+0x0/0x53f
 [<ffffffff810b4dec>] kthread+0x9d/0xa5
 [<ffffffff8103faba>] child_rip+0xa/0x20
 [<ffffffff8103f47c>] ? restore_args+0x0/0x30
 [<ffffffff810b4d4f>] ? kthread+0x0/0xa5
 [<ffffffff8103fab0>] ? child_rip+0x0/0x20
---[ end trace 8e7402ff37ff58a5 ]---
btrfs bad mapping eb start 56213504 len 4096, wanted 8871 8
------------[ cut here ]------------
WARNING: at fs/btrfs/extent_io.c:3523 map_private_extent_buffer+0xc0/0x119()
Hardware name: System Product Name
Modules linked in: scsi_wait_scan
Pid: 20157, comm: loop0 Tainted: G        W  2.6.32-rc5 #3
Call Trace:
 [<ffffffff81404a89>] ? map_private_extent_buffer+0xc0/0x119
 [<ffffffff81089c27>] warn_slowpath_common+0x8d/0xd0
 [<ffffffff81089c91>] warn_slowpath_null+0x27/0x3d
 [<ffffffff81404a89>] map_private_extent_buffer+0xc0/0x119
 [<ffffffff81089b44>] ? add_taint+0xe/0x64
 [<ffffffff81404b62>] map_extent_buffer+0x80/0xd1
 [<ffffffff813f9c9a>] btrfs_key_generation+0x84/0xe8
 [<ffffffff813cfddf>] read_block_for_search+0x75/0x2de
 [<ffffffff813cfa56>] ? unlock_up+0x16/0x105
 [<ffffffff813d51da>] btrfs_search_slot+0x3d7/0x50f
 [<ffffffff81404333>] ? unmap_extent_buffer+0xd/0x41
 [<ffffffff81404de2>] ? free_extent_buffer+0xd/0x56
 [<ffffffff813e2b3d>] btrfs_csum_file_blocks+0x247/0x6bc
 [<ffffffff81416500>] ? copy_items+0x239/0x346
 [<ffffffff810cae23>] ? trace_hardirqs_on+0x20/0x36
 [<ffffffff814165dc>] ? copy_items+0x315/0x346
 [<ffffffff814165c4>] copy_items+0x2fd/0x346
 [<ffffffff81417bad>] btrfs_log_inode+0x355/0x42e
 [<ffffffff810caaa5>] ? mark_held_locks+0x60/0x96
 [<ffffffff810cadc2>] ? trace_hardirqs_on_caller+0x132/0x173
 [<ffffffff810cae23>] ? trace_hardirqs_on+0x20/0x36
 [<ffffffff8141802a>] btrfs_log_inode_parent+0x20d/0x2e2
 [<ffffffff813ea9b4>] ? start_transaction+0x137/0x159
 [<ffffffff814181b8>] btrfs_log_dentry_safe+0x2c/0x42
 [<ffffffff813f5b31>] btrfs_sync_file+0x103/0x18f
 [<ffffffff811a15ba>] vfs_fsync_range+0x90/0xd1
 [<ffffffff811a169f>] vfs_fsync+0x30/0x46
 [<ffffffff8160c74f>] loop_thread+0x2ee/0x53f
 [<ffffffff8160bf6c>] ? do_lo_send_direct_write+0x0/0x8e
 [<ffffffff810b5234>] ? autoremove_wake_function+0x0/0x63
 [<ffffffff8160c461>] ? loop_thread+0x0/0x53f
 [<ffffffff810b4dec>] kthread+0x9d/0xa5
 [<ffffffff8103faba>] child_rip+0xa/0x20
 [<ffffffff8103f47c>] ? restore_args+0x0/0x30
 [<ffffffff810b4d4f>] ? kthread+0x0/0xa5
 [<ffffffff8103fab0>] ? child_rip+0x0/0x20
---[ end trace 8e7402ff37ff58a6 ]---
------------[ cut here ]------------
kernel BUG at fs/btrfs/extent-tree.c:1229!
invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
last sysfs file: /sys/devices/pci0000:00/0000:00:12.0/0000:04:0b.0/local_cpus
CPU 1
Modules linked in: scsi_wait_scan
Pid: 6818, comm: btrfs-transacti Tainted: G        W  2.6.32-rc5 #3 System
Product Name
RIP: 0010:[<ffffffff813dbcb3>]  [<ffffffff813dbcb3>]
lookup_inline_extent_backref+0x143/0x447
RSP: 0018:ffff8800bb495a00  EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000001 RCX: ffff8800bb4959bc
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff8800bb495ab0 R08: ffff8800bb4958c8 R09: ffff8800bb4958c0
R10: 0000000000000011 R11: 00000000438270d2 R12: ffff880026210088
R13: 0000000000000000 R14: 00000000fffffff4 R15: 0000000000000000
FS:  00007f9df3303950(0000) GS:ffff880008e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007f3c5fd16154 CR3: 00000000b6117000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
Process btrfs-transacti (pid: 6818, threadinfo ffff8800bb494000, task
ffff8800b946d480)
Stack:
 00000000bb495a40 0000000000000000 0000000000000001 0000000000000005
<0> 0000000000000000 0000000003519000 ffff8800bb495b70 ffff88002620f000
<0> ffff8800b6f02090 0000000000000246 0000009000008050 000000b0ffffffff
Call Trace:
 [<ffffffff813dcf4f>] __btrfs_free_extent+0x113/0x717
 [<ffffffff810cd8d2>] ? lock_release_non_nested+0x1d4/0x24b
 [<ffffffff8141daf7>] ? btrfs_delayed_ref_lock+0x4f/0xbf
 [<ffffffff813dfb2b>] ? run_clustered_refs+0x27d/0x2fa
 [<ffffffff813dda34>] run_one_delayed_ref+0x4e1/0x511
 [<ffffffff813dfb41>] run_clustered_refs+0x293/0x2fa
 [<ffffffff813dfc89>] btrfs_run_delayed_refs+0xe1/0x1bd
 [<ffffffff813eaf62>] btrfs_commit_transaction+0x316/0x607
 [<ffffffff810b5234>] ? autoremove_wake_function+0x0/0x63
 [<ffffffff813e61a2>] transaction_kthread+0x195/0x22a
 [<ffffffff813e600d>] ? transaction_kthread+0x0/0x22a
 [<ffffffff810b4dec>] kthread+0x9d/0xa5
 [<ffffffff8103faba>] child_rip+0xa/0x20
 [<ffffffff8103f47c>] ? restore_args+0x0/0x30
 [<ffffffff810b4d4f>] ? kthread+0x0/0xa5
 [<ffffffff8103fab0>] ? child_rip+0x0/0x20
Code: 45 a8 48 8b 4d 88 4c 89 e7 48 8b 75 90 c6 45 b8 a8 48 89 55 b0 48 8d 55
b0 e8 5d 91 ff ff 83 f8 00 89 c3 0f 8c b4 02 00 00 74 04 <0f> 0b eb fe 48 8b 4d
88 48 63 71 40 4c 8b 31 4c 89 f7 48 6b f6
RIP  [<ffffffff813dbcb3>] lookup_inline_extent_backref+0x143/0x447
 RSP <ffff8800bb495a00>
---[ end trace 8e7402ff37ff58a7 ]---

What I did is two thing:

a.   fdisk and allocate the entire partition and mkfs.btrfs, and then mount it.
  subsequently just cp, gzip, gunzip and ln on the files after mounting and
copying to the partition.

b.   "dd" and mounted it via loopback - using losetup as explained in the wiki,
and similarly cp, gzip, gunzip and ln on the files after mounting and copying
to the partition.

Now the symptoms is "blocking" - "sync", ls, cd, cp etc all is not possible to
be accomplished on the mounted filesystem - ie, it will block at the command
line.   OS as a whole is still running fine, as I can still enter my bugzilla
report right now.

--
Regards,
Peter Teoh
