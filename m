Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbYCCPYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbYCCPYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 10:24:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbYCCPYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 10:24:47 -0500
Received: from dwdmx4.dwd.de ([141.38.3.230]:48641 "EHLO dwdmx4.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438AbYCCPYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 10:24:46 -0500
X-Greylist: delayed 1604 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Mar 2008 10:24:45 EST
Date: Mon, 3 Mar 2008 14:58:00 +0000 (GMT)
From: Holger Kiehl <Holger.Kiehl@dwd.de>
X-X-Sender: kiehl@diagnostix.dwd.de
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: sysfs: duplicate filename '74' can not be created
Message-ID: <Pine.LNX.4.64.0803031444570.17218@diagnostix.dwd.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I get this approx. 4 hours after booting into 2.6.24.3 (2.6.23.16 worked
fine). This system has 4 CPU's (single core) and 8GB ram. Here some more
details:


    Mar  3 13:36:56 helena -- MARK --
    Mar  3 13:50:01 helena kernel: sysfs: duplicate filename '74' can not be created
    Mar  3 13:50:01 helena kernel: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
    Mar  3 13:50:01 helena kernel: Pid: 21911, comm: sshd Not tainted 2.6.24.3 #1
    Mar  3 13:50:01 helena kernel:
    Mar  3 13:50:01 helena kernel: Call Trace:
    Mar  3 13:50:01 helena kernel:  [<ffffffff802b8640>] sysfs_add_one+0x54/0xbd
    Mar  3 13:50:01 helena kernel:  [<ffffffff802b8bc4>] create_dir+0x4f/0x87
    Mar  3 13:50:01 helena kernel:  [<ffffffff802b8c31>] sysfs_create_dir+0x35/0x4a
    Mar  3 13:50:01 helena kernel:  [<ffffffff802eafc5>] kobject_get+0x12/0x17
    Mar  3 13:50:01 helena kernel:  [<ffffffff802eb4ff>] kobject_add+0xf3/0x1a7
    Mar  3 13:50:01 helena kernel:  [<ffffffff80234513>] user_kobject_create+0x77/0xa7
    Mar  3 13:50:01 helena kernel:  [<ffffffff80234914>] alloc_uid+0xc8/0x148
    Mar  3 13:50:01 helena kernel:  [<ffffffff80237e40>] set_user+0x25/0xa8
    Mar  3 13:50:01 helena kernel:  [<ffffffff80239b6a>] sys_setresuid+0xf0/0x18a
    Mar  3 13:50:01 helena kernel:  [<ffffffff8020b61e>] system_call+0x7e/0x83
    Mar  3 13:50:01 helena kernel:
    Mar  3 13:50:01 helena kernel: kobject_add failed for 74 with -EEXIST, don't try to register things with the same name in the same directory.
    Mar  3 13:50:01 helena kernel: Pid: 21911, comm: sshd Not tainted 2.6.24.3 #1
    Mar  3 13:50:01 helena kernel:
    Mar  3 13:50:01 helena kernel: Call Trace:
    Mar  3 13:50:01 helena kernel:  [<ffffffff802eb57e>] kobject_add+0x172/0x1a7
    Mar  3 13:50:01 helena kernel:  [<ffffffff80234513>] user_kobject_create+0x77/0xa7
    Mar  3 13:50:01 helena kernel:  [<ffffffff80234914>] alloc_uid+0xc8/0x148
    Mar  3 13:50:01 helena kernel:  [<ffffffff80237e40>] set_user+0x25/0xa8
    Mar  3 13:50:01 helena kernel:  [<ffffffff80239b6a>] sys_setresuid+0xf0/0x18a
    Mar  3 13:50:01 helena kernel:  [<ffffffff8020b61e>] system_call+0x7e/0x83
    Mar  3 13:50:01 helena kernel:

A short while latter I was getting this message:

    Mar  3 13:54:05 helena kernel: general protection fault: 0000 [1] SMP
    Mar  3 13:54:05 helena kernel: CPU 3
    Mar  3 13:54:05 helena kernel: Modules linked in: w83627hf lm63 lm85 hwmon_vid i2c_amd756_s4882 bonding nf_conntrack_ftp nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack xt_tcpudp iptable_filter ip_tables x_tables binfmt_misc video output ac floppy nvram ohci_hcd i2c_amd756 k8temp i2c_core button usbcore
    Mar  3 13:54:05 helena kernel: Pid: 23587, comm: vsftpd Not tainted 2.6.24.3 #1
    Mar  3 13:54:05 helena kernel: RIP: 0010:[<ffffffff80279170>]  [<ffffffff80279170>] __kmalloc_track_caller+0x85/0xb9
    Mar  3 13:54:05 helena kernel: RSP: 0018:ffff8101dad09da8  EFLAGS: 00010002
    Mar  3 13:54:05 helena kernel: RAX: 0000000000000000 RBX: 00000000000000d0 RCX: fffffffffffffffa
    Mar  3 13:54:05 helena kernel: RDX: 205347414c465f43 RSI: 00000000000000d0 RDI: ffffffff80554e38
    Mar  3 13:54:05 helena kernel: RBP: 0000000000000286 R08: 0000000000000000 R09: ffffffff80554e38
    Mar  3 13:54:05 helena kernel: R10: 0000000000000002 R11: 0000000000000246 R12: ffff810200026800
    Mar  3 13:54:05 helena kernel: R13: ffffffff802b876b R14: 00000000000041ed R15: ffffffff805d6900
    Mar  3 13:54:05 helena kernel: FS:  00002ab9d3d12000(0000) GS:ffff81027e30c300(0000) knlGS:00000000ad97aba0
    Mar  3 13:54:05 helena kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
    Mar  3 13:54:05 helena kernel: CR2: 000055555556bb2d CR3: 00000001fa9ec000 CR4: 00000000000006e0
    Mar  3 13:54:05 helena kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    Mar  3 13:54:05 helena kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
    Mar  3 13:54:05 helena kernel: Process vsftpd (pid: 23587, threadinfo ffff8101dad08000, task ffff8101faafa000)
    Mar  3 13:54:05 helena kernel: Stack:  ffff81027da4b7d0 0000000000000005 ffff81027da4b7d0 0000000000000000
    Mar  3 13:54:05 helena kernel:  0000000000000001 ffffffff802620ef 0000003000000018 0000000000000000
    Mar  3 13:54:05 helena kernel:  ffff81027da4b7d0 ffffffff802b876b 0000000000000007 00002ab9d31ca7e0
    Mar  3 13:54:05 helena kernel: Call Trace:
    Mar  3 13:54:05 helena kernel:  [<ffffffff802620ef>] kstrdup+0x2a/0x3f
    Mar  3 13:54:05 helena kernel:  [<ffffffff802b876b>] sysfs_new_dirent+0x29/0xfe
    Mar  3 13:54:05 helena kernel:  [<ffffffff802b8ba2>] create_dir+0x2d/0x87
    Mar  3 13:54:05 helena kernel:  [<ffffffff80276571>] get_partial_node+0x15/0x7e
    Mar  3 13:54:05 helena kernel:  [<ffffffff80277fc8>] __slab_alloc+0xc3/0x390
    Mar  3 13:54:05 helena kernel:  [<ffffffff802b8c31>] sysfs_create_dir+0x35/0x4a
    Mar  3 13:54:05 helena kernel:  [<ffffffff802eafc5>] kobject_get+0x12/0x17
    Mar  3 13:54:05 helena kernel:  [<ffffffff802eb4ff>] kobject_add+0xf3/0x1a7
    Mar  3 13:54:05 helena kernel:  [<ffffffff80234513>] user_kobject_create+0x77/0xa7
    Mar  3 13:54:05 helena kernel:  [<ffffffff80234914>] alloc_uid+0xc8/0x148
    Mar  3 13:54:05 helena kernel:  [<ffffffff80237e40>] set_user+0x25/0xa8
    Mar  3 13:54:05 helena kernel:  [<ffffffff802399e8>] sys_setuid+0x4a/0xdc
    Mar  3 13:54:05 helena kernel:  [<ffffffff8020b61e>] system_call+0x7e/0x83
    Mar  3 13:54:05 helena kernel:
    Mar  3 13:54:05 helena kernel:
    Mar  3 13:54:05 helena kernel: Code: 48 8b 04 c2 49 89 04 24 55 9d 31 c0 c1 eb 0f 48 85 d2 0f 95
    Mar  3 13:54:05 helena kernel: RIP  [<ffffffff80279170>] __kmalloc_track_caller+0x85/0xb9
    Mar  3 13:54:05 helena kernel:  RSP <ffff8101dad09da8>
    Mar  3 13:54:05 helena kernel: ---[ end trace b8695bfb4832866d ]---

I was getting more and more of these and things become so bad that I had
to reset after about 20 minutes because ftp was no longer working and no
logins where possible.

Any idea what is causing this? Kernel 2.6.23.* seems to be fine.

Holger


PS: Please CC me I am not on the list.

