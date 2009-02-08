Return-Path: <linux-kernel-owner+w=401wt.eu-S1753443AbZBHKVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbZBHKVd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 05:21:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbZBHKVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 05:21:25 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:61670 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbZBHKVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 05:21:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=v4i5FrlIy5G8mM7HXwzb7YcmEyPwaM5OY3jmwIxGOINWSFy2sBqZorBKLKDseHDaLS
         TnfK5c93om6vFZ/E4N+mB/EoaBH2onCInASE8uEijG0lrsx5Olz/roTFa8CtoOIIahUL
         LiyRWjFDMzUQ45w/dcvvdmAZTnQjcJIlayWsU=
MIME-Version: 1.0
Date: Sun, 8 Feb 2009 11:21:20 +0100
Message-ID: <19f34abd0902080221w662635f0h51875a125b156535@mail.gmail.com>
Subject: 2.6.29-rc3: BUG: NMI Watchdog detected LOCKUP
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Not sure exactly what happened here. Was running LTP, and it seems
that the USB flash disk (which held the root device, though I was
running LTP in a chroot on a fixed harddisk) disconnect, although I
didn't touch it.

[ 3344.890073] usb 1-6: unregistering interface 1-6:1.0
[ 3344.895744] sd 2:0:0:0: Device offlined - not ready after error recovery
[ 3344.902893] sd 2:0:0:0: [sdb] Unhandled error code
[ 3344.908051] sd 2:0:0:0: [sdb] Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK
[ 3344.916810] end_request: I/O error, dev sdb, sector 1735619
[ 3344.922746] Write-error on swap-device (8:16:1735627)
[ 3344.928195] Write-error on swap-device (8:16:1735635)
[ 3344.933611] Write-error on swap-device (8:16:1735643)
[ 3344.939020] Write-error on swap-device (8:16:1735651)
[ 3344.944427] Write-error on swap-device (8:16:1735659)
[ 3344.949836] Write-error on swap-device (8:16:1735667)
[ 3344.955320] Write-error on swap-device (8:16:1735675)
[ 3344.960757] sd 2:0:0:0: rejecting I/O to offline device
[ 3344.961735] sd 2:0:0:0: rejecting I/O to offline device
[ 3344.972984] BUG: NMI Watchdog detected LOCKUP on CPU1, ip ffffffff81491f02, :
[ 3344.972984] CPU 1
[ 3344.972984] Modules linked in:
[ 3344.972984] Pid: 11127, comm: hackbench Not tainted 2.6.29-rc3 #219
[ 3344.972984] RIP: 0010:[<ffffffff81491f02>]  [<ffffffff81491f02>] _spin_lock_b
[ 3344.972984] RSP: 0018:ffff880006b01408  EFLAGS: 00000093
[ 3344.972984] RAX: 0000000000003b39 RBX: 0000000000000001 RCX: 6db6db6db6db6db7
[ 3344.972984] RDX: ffff88003ec688d8 RSI: ffff880006b01428 RDI: ffff88003ec68b40
[ 3344.972984] RBP: ffff880006b01408 R08: b000000000000000 R09: 0000000000000000
[ 3344.972984] R10: ffff880006b01918 R11: 0000000000000000 R12: ffff88003ec688d8
[ 3344.972984] R13: 0000000000001000 R14: 00000000001aeeb3 R15: ffff88003ec688d8
[ 3344.972984] FS:  0000000000000000(0000) GS:ffff88003f801a80(0063) knlGS:00000
[ 3344.972984] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[ 3344.972984] CR2: 0000000000b9dea0 CR3: 0000000006ae3000 CR4: 00000000000006a0
[ 3344.972984] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 3344.972984] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 3344.972984] Process hackbench (pid: 11127, threadinfo ffff880006b00000, task)
[ 3344.972984] Stack:
[ 3344.972984]  ffff880006b01468 ffffffff8118d26a ffff88001f7e8000 0000000000001
[ 3344.972984]  ffff88001bc33500 0001121000000010 0000000000000047 ffff88001bc30
[ 3344.972984]  ffff88001bc33500 ffff88003ec688d8 00000000001aeeb3 ffff88003ec68
[ 3344.972984] Call Trace:
[ 3344.972984]  [<ffffffff8118d26a>] __make_request+0x3e/0x412
[ 3344.972984]  [<ffffffff8118bf77>] generic_make_request+0x279/0x2c3
[ 3344.972984]  [<ffffffff8119f189>] ? radix_tree_tag_set+0x6b/0xce
[ 3344.972984]  [<ffffffff8118c087>] submit_bio+0xc6/0xcf
[ 3344.972984]  [<ffffffff8107feb8>] ? unlock_page+0x22/0x26
[ 3344.972984]  [<ffffffff8109ebd4>] swap_writepage+0xa2/0xac
[ 3344.972984]  [<ffffffff8108a076>] shrink_page_list+0x3a7/0x67b
[ 3344.972984]  [<ffffffff810376f1>] ? finish_task_switch+0x68/0x88
[ 3344.972984]  [<ffffffff8101b822>] ? __cpus_empty+0x9/0xb
[ 3344.972984]  [<ffffffff8101ba27>] ? flush_tlb_page+0x66/0x83
[ 3344.972984]  [<ffffffff814908b3>] ? thread_return+0x3d/0xc6
[ 3344.972984]  [<ffffffff8108a98d>] shrink_list+0x29d/0x59f
[ 3344.972984]  [<ffffffff81086c4f>] ? get_dirty_limits+0x22/0x24a
[ 3344.972984]  [<ffffffff8108af10>] shrink_zone+0x281/0x32b
[ 3344.972984]  [<ffffffff8119ff8e>] ? __up_read+0x92/0x9c
[ 3344.972984]  [<ffffffff8108b100>] ? shrink_slab+0x146/0x158
[ 3344.972984]  [<ffffffff8108c022>] try_to_free_pages+0x23d/0x38f
[ 3344.972984]  [<ffffffff81089185>] ? isolate_pages_global+0x0/0x219
[ 3344.972984]  [<ffffffff81085cc9>] __alloc_pages_internal+0x292/0x43d
[ 3344.972984]  [<ffffffff810a6963>] alloc_pages_current+0xb9/0xc2
[ 3344.972984]  [<ffffffff810aa658>] alloc_slab_page+0x19/0x69
[ 3344.972984]  [<ffffffff810aa6f1>] new_slab+0x49/0x1cc
[ 3344.972984]  [<ffffffff8119f8b1>] ? rb_insert_color+0xbd/0xe6
[ 3344.972984]  [<ffffffff810aaad3>] __slab_alloc+0x1f3/0x36c
[ 3344.972984]  [<ffffffff81389fe8>] ? __alloc_skb+0x42/0x130
[ 3344.972984]  [<ffffffff81389fe8>] ? __alloc_skb+0x42/0x130
[ 3344.972984]  [<ffffffff810aaf7c>] kmem_cache_alloc_node+0x69/0xa2
[ 3344.972984]  [<ffffffff81389fe8>] __alloc_skb+0x42/0x130
[ 3344.972984]  [<ffffffff81385bd3>] sock_alloc_send_skb+0xa1/0x200
[ 3344.972984]  [<ffffffff8116700a>] ? security_socket_getpeersec_dgram+0x11/0x3
[ 3344.972984]  [<ffffffff81409250>] unix_stream_sendmsg+0x138/0x2b5
[ 3344.972984]  [<ffffffff8138276b>] __sock_sendmsg+0x59/0x62
[ 3344.972984]  [<ffffffff8138285c>] sock_aio_write+0xe8/0xf8
[ 3344.972984]  [<ffffffff810af9a2>] do_sync_write+0xe7/0x12d
[ 3344.972984]  [<ffffffff8104d980>] ? autoremove_wake_function+0x0/0x38
[ 3344.972984]  [<ffffffff8116d9da>] ? selinux_file_permission+0xbd/0xc6
[ 3344.972984]  [<ffffffff811669d0>] ? security_file_permission+0x11/0x13
[ 3344.972984]  [<ffffffff810b029a>] vfs_write+0xbe/0x105
[ 3344.972984]  [<ffffffff810b03a5>] sys_write+0x47/0x6f
[ 3344.972984]  [<ffffffff8102bba8>] sysenter_dispatch+0x7/0x27
[ 3344.972984] Code: 01 00 00 f0 66 0f c1 17 38 f2 74 06 f3 90 8a 17 eb f6 c9 c
[ 3344.972984] BUG: NMI Watchdog detected LOCKUP<4>---[ end trace 820f38a7b2441-
[ 3344.972984]  on CPU0, ip ffffffff81491f6c, registers:
[ 3344.972984] CPU 0
[ 3344.972984] Modules linked in:
[ 3344.972984] Pid: 742, comm: scsi_eh_2 Tainted: G      D    2.6.29-rc3 #219
[ 3344.972984] RIP: 0010:[<ffffffff81491f6c>]  [<ffffffff81491f6c>] _spin_lock+a
[ 3344.972984] RSP: 0018:ffffffff81856e38  EFLAGS: 00000097
[ 3344.972984] RAX: 0000000000003a39 RBX: ffff88003ec5c400 RCX: 0000000000002002
[ 3344.972984] RDX: 0000000000000707 RSI: 0000000000000000 RDI: ffff88003ec68b40
[ 3344.972984] RBP: ffffffff81856e38 R08: ffff88003edb6000 R09: ffff88003ee85480
[ 3344.972984] R10: 0000000000000012 R11: ffffffff8176cd00 R12: ffff88003ee7e800
[ 3344.972984] R13: ffff88003ee7f000 R14: 0000000000000286 R15: 000000000000000a
[ 3344.972984] FS:  0000000000000000(0000) GS:ffffffff8185f080(0000) knlGS:00000
[ 3344.972984] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[ 3344.972984] CR2: 0000000000b9dea0 CR3: 000000002f514000 CR4: 00000000000006a0
[ 3344.972984] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 3344.972984] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 3344.972984] Process scsi_eh_2 (pid: 742, threadinfo ffff88003edb6000, task f)
[ 3344.972984] Stack:
[ 3344.972984]  ffffffff81856e68 ffffffff812908a0 ffff88003ec5c428 ffff88003ee70
[ 3344.972984]  ffff88003ee7e800 ffff880013dda100 ffffffff81856e98 ffffffff8128c
[ 3344.972984]  ffff880013dda100 0000000000007530 0000000000000005 ffffffff81840
[ 3344.972984] Call Trace:
[ 3344.972984]  <IRQ> <0> [<ffffffff812908a0>] scsi_device_unbusy+0x87/0xa7
[ 3344.972984]  [<ffffffff8128b04c>] scsi_finish_command+0x25/0xb6
[ 3344.972984]  [<ffffffff81290e92>] scsi_softirq_done+0x103/0x10b
[ 3344.972984]  [<ffffffff8119042d>] blk_done_softirq+0x69/0x79
[ 3344.972984]  [<ffffffff8103fb3f>] __do_softirq+0x83/0x144
[ 3344.972984]  [<ffffffff8100d33c>] call_softirq+0x1c/0x28
[ 3344.972984]  [<ffffffff8100e258>] do_softirq+0x34/0x76
[ 3344.972984]  [<ffffffff8103f8d5>] irq_exit+0x3f/0x79
[ 3344.972984]  [<ffffffff8100e51b>] do_IRQ+0x130/0x155
[ 3344.972984]  [<ffffffff8100cc13>] ret_from_intr+0x0/0xa
[ 3344.972984]  <EOI> <0>Code: c9 c3 55 48 89 e5 fa f0 81 2f 00 00 00 01 74 05
[ 3344.972984] ---[ end trace 820f38a7b2441dd8 ]---
[ 3350.650441] Kernel panic - not syncing: Aiee, killing interrupt handler!

I know the log is chopped at 80 chars; that's my bad for not logging
to file, but just copying out of the terminal :-(


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
