Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab0CCSKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 13:10:15 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:51691 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390Ab0CCSKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 13:10:10 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: mmotm 2010-03-02 - kernel BUG at fs/direct-io.c:630
In-Reply-To: Your message of "Tue, 02 Mar 2010 18:39:07 PST."
             <201003030305.o2335F1F015917@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201003030305.o2335F1F015917@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1267639769_3960P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 03 Mar 2010 13:09:29 -0500
Message-ID: <10679.1267639769@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020204.4B8EA5DB.0090,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1267639769_3960P
Content-Type: text/plain; charset=us-ascii

On Tue, 02 Mar 2010 18:39:07 PST, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2010-03-02-18-38 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

This goes kersplat at boot for me. x86_64 on a Dell Latitude E6500.

[   12.807193] dracut: luksOpen /dev/sda2 luks-715ceabf-6f58-4251-9373-ed29e8629a7c
[   29.340174] ------------[ cut here ]------------
[   29.341007] kernel BUG at fs/direct-io.c:630!
[   29.341007] invalid opcode: 0000 [#1] PREEMPT SMP 
[   29.341007] last sysfs file: /sys/devices/virtual/block/dm-0/dm/suspended
[   29.344451] CPU 0 
[   29.344451] Modules linked in:
[   29.344451] 
[   29.344451] Pid: 2008, comm: cryptsetup Not tainted 2.6.33-mmotm0302 #1 0X564R/Latitude E6500                  
[   29.344451] RIP: 0010:[<ffffffff811063b5>]  [<ffffffff811063b5>] dio_send_cur_page+0x9f/0xaa
[   29.344451] RSP: 0018:ffff88011c6f9b68  EFLAGS: 00010202
[   29.344451] RAX: 0000000000000001 RBX: 0000000000000001 RCX: ffff88011f802040
[   29.344451] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff81ac1688
[   29.344451] RBP: ffff88011c6f9b88 R08: ffff88011ba19600 R09: ffff88011ba19208
[   29.344451] R10: 0000000000000001 R11: 000000000001aa5a R12: ffffea0003de87e0
[   29.344451] R13: 0000000000001000 R14: 0000000000000000 R15: 0000000000000002
[   29.344451] FS:  00007f3eb38827e0(0000) GS:ffff880006000000(0000) knlGS:0000000000000000
[   29.344451] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   29.344451] CR2: 00000034478a8440 CR3: 000000011c263000 CR4: 00000000000406f0
[   29.344451] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   29.344451] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   29.344451] Process cryptsetup (pid: 2008, threadinfo ffff88011c6f8000, task ffff88011bb8ed80)
[   29.344451] Stack:
[   29.344451]  ffff88011c6f9b88 ffffffff00000001 ffff88011c217000 ffff88011c217000
[   29.344451] <0> ffff88011c6f9bd8 ffffffff81106472 0000000000000000 ffff88011f8026c8
[   29.344451] <0> ffff88011c6f9bd8 ffffea0003de87e0 ffff88011c217000 0000000000000000
[   29.344451] Call Trace:
[   29.344451]  [<ffffffff81106472>] submit_page_section+0xb2/0x108
[   29.344451]  [<ffffffff81106f7b>] __blockdev_direct_IO+0x8d5/0xc4a
[   29.344451]  [<ffffffff81104ed2>] blkdev_direct_IO+0x49/0x4b
[   29.344451]  [<ffffffff8110430a>] ? blkdev_get_blocks+0x0/0x8b
[   29.344451]  [<ffffffff810ad9c2>] generic_file_aio_read+0xdc/0x63e
[   29.344451]  [<ffffffff810db6c6>] do_sync_read+0xbf/0xfc
[   29.344451]  [<ffffffff811bd22e>] ? security_file_permission+0x5f/0x64
[   29.344451]  [<ffffffff810db825>] ? rw_verify_area+0x122/0x145
[   29.344451]  [<ffffffff810dbeb0>] vfs_read+0xe0/0x140
[   29.344451]  [<ffffffff810dbfc6>] sys_read+0x45/0x69
[   29.344451]  [<ffffffff810025eb>] system_call_fastpath+0x16/0x1b
[   29.344451] Code: 75 2d 48 89 df 31 db e8 0b fd ff ff 48 c7 c7 88 16 ac 81 85 c0 89 45 e8 0f 95 c3 31 d2 89 de e8 5e 2f f9 ff 85 db 8b 45 e8 74 04 <0f> 0b eb fe 48 83 c4 18 5b c9 c3 55 48 89 e5 41 57 4d 89 c7 41 
[   29.344451] RIP  [<ffffffff811063b5>] dio_send_cur_page+0x9f/0xaa
[   29.344451]  RSP <ffff88011c6f9b68>
[   29.397709] ---[ end trace 9c93e8e21ea3b427 ]---
[   29.402214] cryptsetup used greatest stack depth: 4184 bytes left
[   44.741461] SysRq : Resetting



--==_Exmh_1267639769_3960P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLjqXZcC3lWbTT17ARApWtAJ4hks7IfsBo1tjjkIsQeXu5AjYSnwCg29RP
c/ocEzoGvJLZH/BoygTezoM=
=cwOs
-----END PGP SIGNATURE-----

--==_Exmh_1267639769_3960P--

