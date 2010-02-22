Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab0BVUdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 15:33:17 -0500
Received: from mx03.syneticon.net ([78.111.66.105]:46534 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab0BVUdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 15:33:14 -0500
Message-ID: <4B82E9FC.2020708@wpkg.org>
Date: Mon, 22 Feb 2010 21:33:00 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [2.6.33-rc8] kernel BUG at mm/slub.c:2969!
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just tried how 2.6.33-rc8 works here, and it doesn't like my hardware very much.

If you need more info, let me know.

[  115.623583] ------------[ cut here ]------------
[  115.623586] kernel BUG at mm/slub.c:2969!
[  115.623588] invalid opcode: 0000 [#1] SMP 
[  115.623590] last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
[  115.623592] CPU 2 
[  115.623594] Pid: 1707, comm: hald-addon-stor Not tainted 2.6.33-desktop-0.rc8.1mnb #1 DX58SO/        
[  115.623596] RIP: 0010:[<ffffffff8111dca3>]  [<ffffffff8111dca3>] kfree+0x133/0x140
[  115.623602] RSP: 0018:ffff8802354a3a58  EFLAGS: 00010246
[  115.623604] RAX: 0200000000100068 RBX: ffffffffa0089318 RCX: 0000000000000001
[  115.623605] RDX: 0000000001000000 RSI: ffffea0007000000 RDI: ffff880200000000
[  115.623606] RBP: ffff8802354a3a78 R08: 0000000000000000 R09: 0000000000000000
[  115.623608] R10: 0000000000000000 R11: ffff880008c55808 R12: ffff880200000000
[  115.623609] R13: ffff880200000000 R14: 0000000000000010 R15: 00000000000000dd
[  115.623611] FS:  00007f9dd5897700(0000) GS:ffff880008c40000(0000) knlGS:0000000000000000
[  115.623613] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  115.623614] CR2: 00007fff3b2fb718 CR3: 000000023543b000 CR4: 00000000000006e0
[  115.623616] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  115.623617] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  115.623619] Process hald-addon-stor (pid: 1707, threadinfo ffff8802354a2000, task ffff880235482ce0)
[  115.623620] Stack:
[  115.623621]  ffff88023d61ce40 ffff88023d61ce40 ffff88023d61ce70 ffff880200000000
[  115.623623] <0> ffff8802354a3b18 ffffffffa0089318 0000000000000001 0000000000000000
[  115.623626] <0> 0000000000000000 ffff8802354a2000 0000000000000000 0000000000000001
[  115.623628] Call Trace:
[  115.623633]  [<ffffffffa0089318>] sr_media_change+0x138/0x300 [sr_mod]
[  115.623638]  [<ffffffff813b8d8d>] ? __reacquire_kernel_lock+0x4d/0x80
[  115.623641]  [<ffffffff812ba820>] media_changed+0x70/0xc0
[  115.623643]  [<ffffffff812ba8a7>] cdrom_media_changed+0x37/0x40
[  115.623646]  [<ffffffffa00883e9>] sr_block_media_changed+0x19/0x20 [sr_mod]
[  115.623650]  [<ffffffff811564a3>] check_disk_change+0x33/0x70
[  115.623653]  [<ffffffff812bd4f8>] cdrom_open+0x248/0x600
[  115.623655]  [<ffffffff811f00fa>] ? kobject_get+0x1a/0x30
[  115.623658]  [<ffffffff81157dc0>] ? blkdev_open+0x0/0xc0
[  115.623661]  [<ffffffff811e15fd>] ? get_disk+0x7d/0xf0
[  115.623663]  [<ffffffff811f00fa>] ? kobject_get+0x1a/0x30
[  115.623665]  [<ffffffffa00885a9>] sr_block_open+0x79/0xd0 [sr_mod]
[  115.623669]  [<ffffffff812a3d49>] ? get_device+0x19/0x20
[  115.623671]  [<ffffffff81157a61>] __blkdev_get+0xa1/0x3e0
[  115.623673]  [<ffffffff81157dc0>] ? blkdev_open+0x0/0xc0
[  115.623674]  [<ffffffff81157db0>] blkdev_get+0x10/0x20
[  115.623676]  [<ffffffff81157e31>] blkdev_open+0x71/0xc0
[  115.623679]  [<ffffffff811267ea>] __dentry_open+0x10a/0x350
[  115.623682]  [<ffffffff811b85df>] ? security_inode_permission+0x1f/0x30
[  115.623685]  [<ffffffff81126b44>] nameidata_to_filp+0x54/0x70
[  115.623687]  [<ffffffff81136ba0>] do_filp_open+0x950/0xd60
[  115.623690]  [<ffffffff812a3dc7>] ? put_device+0x17/0x20
[  115.623696]  [<ffffffffa012d124>] ? scsi_device_put+0x44/0x60 [scsi_mod]
[  115.623699]  [<ffffffff811414a3>] ? alloc_fd+0x53/0x140
[  115.623701]  [<ffffffff81126599>] do_sys_open+0x69/0x140
[  115.623703]  [<ffffffff811266b0>] sys_open+0x20/0x30
[  115.623706]  [<ffffffff8100a002>] system_call_fastpath+0x16/0x1b
[  115.623707] Code: c4 c7 57 00 4d 85 ed 0f 84 1b ff ff ff 49 8b 45 00 49 83 c5 08 4c 89 e6 48 89 df ff d0 49 8b 45 00 48 85 c0 75 eb e9 fd fe ff ff <0f> 0b eb fe 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 0f 1f 44 00 
[  115.623725] RIP  [<ffffffff8111dca3>] kfree+0x133/0x140
[  115.623728]  RSP <ffff8802354a3a58>
[  115.623730] ---[ end trace 638cfe9483a8fb12 ]---



-- 
Tomasz Chmielewski
http://wpkg.org
