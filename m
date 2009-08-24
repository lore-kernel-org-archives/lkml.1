Return-Path: <linux-kernel-owner+w=401wt.eu-S1752191AbZHXJtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbZHXJtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 05:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbZHXJti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 05:49:38 -0400
Received: from mail.aixigo.de ([195.14.232.227]:10160 "EHLO gate1.ac.aixigo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752156AbZHXJte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 05:49:34 -0400
Message-ID: <4A92622E.7060103@aixigo.de>
Date: Mon, 24 Aug 2009 11:49:34 +0200
From: Harald Dunkel <harald.dunkel@aixigo.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090821)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.30.5, Linux-HA, NFS: crash in reiserfs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

During a stress test on a Linux-HA cluster I got this:

Aug 24 10:37:44 nasl002a kernel: [250890.883961] nfsd: last server has exited, flushing export cache
Aug 24 10:37:50 nasl002a kernel: [250891.885755] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
Aug 24 10:37:50 nasl002a kernel: [250891.888501] IP: [<ffffffffa0176717>] open_xa_dir+0x2e/0x18c [reiserfs]
Aug 24 10:37:50 nasl002a kernel: [250891.888501] PGD 1854de067 PUD 16d3aa067 PMD 0
Aug 24 10:37:50 nasl002a kernel: [250891.888501] Oops: 0000 [#1] SMP
Aug 24 10:37:50 nasl002a kernel: [250891.888501] last sysfs file: /sys/class/net/bond1/operstate
Aug 24 10:37:50 nasl002a kernel: [250891.888501] CPU 1
Aug 24 10:37:50 nasl002a kernel: [250891.888501] Modules linked in: nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc sha256_generic drbd cn bonding ipv6 loop snd_pcm snd_timer snd soundcore snd_page_alloc psmouse shpchp serio_raw pcspkr i2c_i801 i2c_core pci_hotplug iTCO_wdt button processor joydev evdev reiserfs usbhid hid sg sr_mod cdrom sd_mod 3w_9xxx ahci libata e1000 floppy ehci_hcd scsi_mod uhci_hcd e1000e thermal fan thermal_sys
Aug 24 10:37:50 nasl002a kernel: [250892.714170] Pid: 1575, comm: umount Not tainted 2.6.30.5 #1 S3210SH
Aug 24 10:37:50 nasl002a kernel: [250892.714170] RIP: 0010:[<ffffffffa0176717>]  [<ffffffffa0176717>] open_xa_dir+0x2e/0x18c [reiserfs]
Aug 24 10:37:50 nasl002a kernel: [250892.714170] RSP: 0018:ffff8801cc881c88  EFLAGS: 00010286
Aug 24 10:37:50 nasl002a kernel: [250892.714170] RAX: ffff8801dfc42ac0 RBX: ffff88021d1fe400 RCX: 0000000000000000
Aug 24 10:37:50 nasl002a kernel: [250892.714170] RDX: ffff8801477a94a8 RSI: 0000000000000002 RDI: ffff8801477a94a8
Aug 24 10:37:50 nasl002a kernel: [250892.714170] RBP: ffffffffffffffc3 R08: 0000000000000018 R09: 0000000000000296
Aug 24 10:37:50 nasl002a kernel: [250892.714170] R10: ffff88021c8217c0 R11: ffffffff803176ff R12: 0000000000000000
Aug 24 10:37:50 nasl002a kernel: [250892.714170] R13: ffff8801477a94a8 R14: 0000000000000002 R15: 0000000000000000
Aug 24 10:37:50 nasl002a kernel: [250892.714170] FS:  00007fb71f199730(0000) GS:ffff88002804c000(0000) knlGS:0000000000000000
Aug 24 10:37:50 nasl002a kernel: [250892.714170] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug 24 10:37:50 nasl002a kernel: [250892.714170] CR2: 0000000000000010 CR3: 000000020b563000 CR4: 00000000000406e0
Aug 24 10:37:50 nasl002a kernel: [250892.714170] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug 24 10:37:50 nasl002a kernel: [250892.714170] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug 24 10:37:50 nasl002a kernel: [250892.714170] Process umount (pid: 1575, threadinfo ffff8801cc880000, task ffff88014e7a29c0)
Aug 24 10:37:50 nasl002a kernel: [250892.714170] Stack:
Aug 24 10:37:50 nasl002a kernel: [250892.714170]  ffff88015121f006 0000000000000000 ffff8801cc881e08 ffffffffa0176662
Aug 24 10:37:50 nasl002a kernel: [250892.714170]  ffff8801477a94a8 ffff8801477a94a8 0000000000000024 ffff880175824560
Aug 24 10:37:50 nasl002a kernel: [250892.714170]  0000000000000000 ffffffffa0177080 0000000000000000 0000000000000000
Aug 24 10:37:50 nasl002a kernel: [250892.714170] Call Trace:
Aug 24 10:37:50 nasl002a kernel: [250892.714170]  [<ffffffffa0176662>] ? xattr_lookup_poison+0x47/0x52 [reiserfs]
Aug 24 10:37:50 nasl002a kernel: [250892.714170]  [<ffffffffa0177080>] ? reiserfs_for_each_xattr+0x63/0x25c [reiserfs]
Aug 24 10:37:50 nasl002a kernel: [250892.714170]  [<ffffffffa01779ef>] ? delete_one_xattr+0x0/0xf9 [reiserfs]
Aug 24 10:37:50 nasl002a kernel: [250892.714170]  [<ffffffff8022fc9c>] ? pick_next_task_fair+0x9d/0xa5
Aug 24 10:37:50 nasl002a kernel: [250892.714170]  [<ffffffffa01772da>] ? reiserfs_delete_xattrs+0x17/0x49 [reiserfs]
Aug 24 10:37:50 nasl002a kernel: [250892.714170]  [<ffffffffa015fe2c>] ? reiserfs_delete_inode+0x6a/0x11a [reiserfs]
Aug 24 10:37:50 nasl002a kernel: [250892.714170]  [<ffffffff80346b9e>] ? cpumask_next_and+0x2a/0x3a
Aug 24 10:37:50 nasl002a kernel: [250892.714170]  [<ffffffff8027b0ca>] ? __call_rcu+0xa4/0x10d
Aug 24 10:37:50 nasl002a kernel: [250892.714170]  [<ffffffffa015fdc2>] ? reiserfs_delete_inode+0x0/0x11a [reiserfs]
Aug 24 10:37:50 nasl002a kernel: [250892.714170]  [<ffffffff802ca7ef>] ? generic_delete_inode+0xdb/0x166
Aug 24 10:37:50 nasl002a kernel: [250892.714170]  [<ffffffff802c8622>] ? shrink_dcache_for_umount_subtree+0x209/0x24e
Aug 24 10:37:50 nasl002a kernel: [250892.714170]  [<ffffffff802c8696>] ? shrink_dcache_for_umount+0x2f/0x3d
Aug 24 10:37:50 nasl002a kernel: [250892.714170]  [<ffffffff802bb04e>] ? generic_shutdown_super+0x1d/0xfd
Aug 24 10:37:50 nasl002a kernel: [250892.714170]  [<ffffffff802bb150>] ? kill_block_super+0x22/0x3a
Aug 24 10:37:50 nasl002a kernel: [250892.714170]  [<ffffffff802bb79b>] ? deactivate_super+0x5f/0x78
Aug 24 10:37:50 nasl002a kernel: [250892.714170]  [<ffffffff802cd9d2>] ? sys_umount+0x2d8/0x307
Aug 24 10:37:50 nasl002a kernel: [250892.714170]  [<ffffffff8020ba42>] ? system_call_fastpath+0x16/0x1b
Aug 24 10:37:50 nasl002a kernel: [250892.714170] Code: 89 f6 41 55 49 89 fd 41 54 55 48 c7 c5 c3 ff ff ff 53 48 83 ec 20 48 8b 9f 00 01 00 00 48 8b 83 a8 02 00 00 4c 8b a0 c8 00 00 00 <49> 8b 44 24 10 48 85 c0 0f 84 40 01 00 00 48 8d b8 b8 00 00 00
Aug 24 10:37:50 nasl002a kernel: [250892.714170] RIP  [<ffffffffa0176717>] open_xa_dir+0x2e/0x18c [reiserfs]
Aug 24 10:37:50 nasl002a kernel: [250892.714170]  RSP <ffff8801cc881c88>
Aug 24 10:37:50 nasl002a kernel: [250892.714170] CR2: 0000000000000010
Aug 24 10:37:50 nasl002a kernel: [250897.503187] ---[ end trace 1d0a13a0751dc2a2 ]---

AFAICS this happened when the host tried to unmount the data
partition.

Here is more information about the environment:

I am setting up a Linux-HA cluster (2 hosts) using kernel
2.6.30.5, drbd 8.3.2 and Heartbeat. The data partition is
formatted in reiserfs. It is exported via NFSv3 to 3 other
Linux hosts.

For a stress test I have set up a loop to shutdown heartbeat
on the current primary, wait 5 minutes for the other host to
take over and to make sure the NFS timeouts on the clients
have expired, startup the local heartbeat again, and wait
another 30 seconds. A complete cycle takes 11 minutes.

To put some load on the cluster I started 3 kernel builds
in parallel on each of the 3 NFS clients.


Of course I would be glad to help to track this problem down.
Please mail.


Regards

Harri
