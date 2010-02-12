Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861Ab0BLCoa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 21:44:30 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:50879 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757810Ab0BLCo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 21:44:28 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: mmotm 2010-02-10 - BUG at fs/dcache.c:677!
In-Reply-To: Your message of "Wed, 10 Feb 2010 16:17:41 PST."
             <201002110043.o1B0hKxW008835@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201002110043.o1B0hKxW008835@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1265942657_4819P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 11 Feb 2010 21:44:17 -0500
Message-ID: <8576.1265942657@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=zidane.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020204.4B74C082.010D,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1265942657_4819P
Content-Type: text/plain; charset=us-ascii

On Wed, 10 Feb 2010 16:17:41 PST, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2010-02-10-16-17 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

Hit this at shutdown. ext4 filesystems.  Brought it up to single-user
mode, then 'shutdown -h now'.

[   58.311786] ------------[ cut here ]------------
[   58.312261] kernel BUG at fs/dcache.c:677!
[   58.312261] invalid opcode: 0000 [#1] PREEMPT SMP 
[   58.312261] last sysfs file: /sys/devices/virtual/block/dm-10/dm/name
[   58.312261] CPU 1 
[   58.312261] Pid: 3007, comm: umount Not tainted 2.6.33-rc7-mmotm0210 #1 0X564R/Latitude E6500                  
[   58.312261] RIP: 0010:[<ffffffff810e7ce8>]  [<ffffffff810e7ce8>] shrink_dcache_for_umount_subtree+0x19b/0x27e
[   58.312261] RSP: 0018:ffff88011bafde08  EFLAGS: 00010292
[   58.312261] RAX: 000000000000006b RBX: ffff88011be58160 RCX: ffffffff81a2b070
[   58.312261] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81aa3fe8
[   58.312261] RBP: ffff88011bafde38 R08: 0000000000000002 R09: 0000000000000000
[   58.312261] R10: 0000000000000005 R11: 0000000000000000 R12: ffff88011be58160
[   58.312261] R13: 0000000000000088 R14: ffff88011be824c0 R15: ffff88011bafdf18
[   58.312261] FS:  00007f1348f7e740(0000) GS:ffff880100300000(0000) knlGS:0000000000000000
[   58.312261] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   58.312261] CR2: 00007f1348642c40 CR3: 000000011ce86000 CR4: 00000000000406e0
[   58.312261] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   58.312261] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   58.312261] Process umount (pid: 3007, threadinfo ffff88011bafc000, task ffff88011d88c640)
[   58.312261] Stack:
[   58.312261]  ffff88010f7e9418 ffff88010f7e9248 ffff88010f7e9000 ffffffff816270b0
[   58.312261] <0> ffff88010f7e9000 ffffffff81b08d28 ffff88011bafde58 ffffffff810e7e02
[   58.312261] <0> ffffffff81a37ed0 ffff88010f7e9000 ffff88011bafde78 ffffffff810d8785
[   58.312261] Call Trace:
[   58.312261]  [<ffffffff810e7e02>] shrink_dcache_for_umount+0x37/0x47
[   58.312261]  [<ffffffff810d8785>] generic_shutdown_super+0x1a/0xc9
[   58.312261]  [<ffffffff810d8856>] kill_block_super+0x22/0x3a
[   58.312261]  [<ffffffff810d8ff5>] deactivate_super+0x68/0x7f
[   58.312261]  [<ffffffff810eda94>] mntput_no_expire+0x10d/0x150
[   58.312261]  [<ffffffff810ee04c>] sys_umount+0x2be/0x2ed
[   58.312261]  [<ffffffff81062361>] ? trace_hardirqs_on_caller+0x16/0x13c
[   58.312261]  [<ffffffff8100252b>] system_call_fastpath+0x16/0x1b
[   58.312261] Code: 0a 48 8b 4b 68 31 d2 48 85 f6 74 04 48 8b 56 40 48 05 18 04 00 00 48 89 de 48 89 04 24 48 c7 c7 48 b0 80 81 31 c0 e8 3e fa 47 00 <0f> 0b eb fe 4c 8b 63 58 4c 39 e3 75 05 45 31 e4 eb 05 f0 41 ff 
[   58.312261] RIP  [<ffffffff810e7ce8>] shrink_dcache_for_umount_subtree+0x19b/0x27e
[   58.312261]  RSP <ffff88011bafde08>
[   58.416414] ---[ end trace b3b044c2cf0d74d7 ]---
[   63.548092] BUG: Dentry ffff88011f9ed430{i=4035,n=l} still in use (4) [unmount of ext4 dm-4]
[   63.550998] ------------[ cut here ]------------
[   63.551945] kernel BUG at fs/dcache.c:677!
[   63.551945] invalid opcode: 0000 [#2] PREEMPT SMP 
[   63.551945] last sysfs file: /sys/devices/virtual/block/dm-10/dm/name
[   63.551945] CPU 0 
[   63.551945] Pid: 3030, comm: umount Tainted: G      D    2.6.33-rc7-mmotm0210 #1 0X564R/Latitude E6500                  
[   63.551945] RIP: 0010:[<ffffffff810e7ce8>]  [<ffffffff810e7ce8>] shrink_dcache_for_umount_subtree+0x19b/0x27e
[   63.551945] RSP: 0018:ffff88011db73e08  EFLAGS: 00010292
[   63.551945] RAX: 0000000000000066 RBX: ffff88011f9ed430 RCX: ffff88011db73cc8
[   63.551945] RDX: ffffffff81bc9634 RSI: 0000000000000000 RDI: 0000000000000246
[   63.551945] RBP: ffff88011db73e38 R08: 0000000000000002 R09: 0000000000000001
[   63.551945] R10: 0000000000000000 R11: ffff88011fd8dd20 R12: ffff88011f9ed430
[   63.551945] R13: 0000000000000008 R14: ffff88011874c230 R15: ffff88011db73f18
[   63.551945] FS:  00007fad57558740(0000) GS:ffff880100200000(0000) knlGS:0000000000000000
[   63.551945] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   63.551945] CR2: 00007fad56c1cc40 CR3: 000000011ba21000 CR4: 00000000000406f0
[   63.551945] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   63.551945] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   63.551945] Process umount (pid: 3030, threadinfo ffff88011db72000, task ffff88011b90e240)
[   63.551945] Stack:
[   63.551945]  ffff88011d0ee418 ffff88011d0ee248 ffff88011d0ee000 ffffffff816270b0
[   63.551945] <0> ffff88011d0ee000 ffffffff81b08d28 ffff88011db73e58 ffffffff810e7e02
[   63.551945] <0> ffffffff81a37ed0 ffff88011d0ee000 ffff88011db73e78 ffffffff810d8785
[   63.551945] Call Trace:
[   63.551945]  [<ffffffff810e7e02>] shrink_dcache_for_umount+0x37/0x47
[   63.551945]  [<ffffffff810d8785>] generic_shutdown_super+0x1a/0xc9
[   63.551945]  [<ffffffff810d8856>] kill_block_super+0x22/0x3a
[   63.551945]  [<ffffffff810d8ff5>] deactivate_super+0x68/0x7f
[   63.551945]  [<ffffffff810eda94>] mntput_no_expire+0x10d/0x150
[   63.551945]  [<ffffffff810ee04c>] sys_umount+0x2be/0x2ed
[   63.551945]  [<ffffffff81062361>] ? trace_hardirqs_on_caller+0x16/0x13c
[   63.551945]  [<ffffffff8100252b>] system_call_fastpath+0x16/0x1b
[   63.551945] Code: 0a 48 8b 4b 68 31 d2 48 85 f6 74 04 48 8b 56 40 48 05 18 04 00 00 48 89 de 48 89 04 24 48 c7 c7 48 b0 80 81 31 c0 e8 3e fa 47 00 <0f> 0b eb fe 4c 8b 63 58 4c 39 e3 75 05 45 31 e4 eb 05 f0 41 ff 
[   63.551945] RIP  [<ffffffff810e7ce8>] shrink_dcache_for_umount_subtree+0x19b/0x27e
[   63.551945]  RSP <ffff88011db73e08>
[   63.652212] ---[ end trace b3b044c2cf0d74d8 ]---
[   68.758158] BUG: Dentry ffff88011fa2b290{i=4002,n=sbin} still in use (2) [unmount of ext4 dm-6]
[   68.761221] ------------[ cut here ]------------
[   68.762191] kernel BUG at fs/dcache.c:677!
[   68.762191] invalid opcode: 0000 [#3] PREEMPT SMP 
[   68.762191] last sysfs file: /sys/devices/virtual/block/dm-10/dm/name
[   68.762191] CPU 0 
[   68.774527] Pid: 3053, comm: umount Tainted: G      D    2.6.33-rc7-mmotm0210 #1 0X564R/Latitude E6500                  
[   68.774527] RIP: 0010:[<ffffffff810e7ce8>]  [<ffffffff810e7ce8>] shrink_dcache_for_umount_subtree+0x19b/0x27e
[   68.774527] RSP: 0018:ffff88010f78de08  EFLAGS: 00010292
[   68.774527] RAX: 0000000000000069 RBX: ffff88011fa2b290 RCX: ffffffff81aaa848
[   68.774527] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81aa3fe8
[   68.774527] RBP: ffff88010f78de38 R08: 0000000000000002 R09: 0000000000000000
[   68.774527] R10: 000000011c699802 R11: 000000000000008d R12: ffff88011fa2b290
[   68.774527] R13: 0000000000000070 R14: ffff88011be0e5f0 R15: ffff88010f78df18
[   68.774527] FS:  00007ffcbc262740(0000) GS:ffff880100200000(0000) knlGS:0000000000000000
[   68.774527] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   68.774527] CR2: 00007ffcbb926c40 CR3: 000000011d2ae000 CR4: 00000000000406f0
[   68.774527] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   68.774527] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   68.774527] Process umount (pid: 3053, threadinfo ffff88010f78c000, task ffff88011d590ec0)
[   68.774527] Stack:
[   68.774527]  ffff88011f666c18 ffff88011f666a48 ffff88011f666800 ffffffff816270b0
[   68.774527] <0> ffff88011f666800 ffffffff81b08d28 ffff88010f78de58 ffffffff810e7e02
[   68.774527] <0> ffffffff81a37ed0 ffff88011f666800 ffff88010f78de78 ffffffff810d8785
[   68.774527] Call Trace:
[   68.774527]  [<ffffffff810e7e02>] shrink_dcache_for_umount+0x37/0x47
[   68.774527]  [<ffffffff810d8785>] generic_shutdown_super+0x1a/0xc9
[   68.774527]  [<ffffffff810d8856>] kill_block_super+0x22/0x3a
[   68.774527]  [<ffffffff810d8ff5>] deactivate_super+0x68/0x7f
[   68.774527]  [<ffffffff810eda94>] mntput_no_expire+0x10d/0x150
[   68.774527]  [<ffffffff810ee04c>] sys_umount+0x2be/0x2ed
[   68.774527]  [<ffffffff81062361>] ? trace_hardirqs_on_caller+0x16/0x13c
[   68.774527]  [<ffffffff8100252b>] system_call_fastpath+0x16/0x1b
[   68.774527] Code: 0a 48 8b 4b 68 31 d2 48 85 f6 74 04 48 8b 56 40 48 05 18 04 00 00 48 89 de 48 89 04 24 48 c7 c7 48 b0 80 81 31 c0 e8 3e fa 47 00 <0f> 0b eb fe 4c 8b 63 58 4c 39 e3 75 05 45 31 e4 eb 05 f0 41 ff 
[   68.774527] RIP  [<ffffffff810e7ce8>] shrink_dcache_for_umount_subtree+0x19b/0x27e
[   68.774527]  RSP <ffff88010f78de08>
[   68.868765] ---[ end trace b3b044c2cf0d74d9 ]---
[   74.422353] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   74.425558] sd 0:0:0:0: [sda] Stopping disk


--==_Exmh_1265942657_4819P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLdMCBcC3lWbTT17ARAsWpAJ0dAZ0qVoACRcEzBGDCAijmdRVDpACfc1z3
ZR3er/3GZMXM6H+GfbymU1Q=
=yxVq
-----END PGP SIGNATURE-----

--==_Exmh_1265942657_4819P--

