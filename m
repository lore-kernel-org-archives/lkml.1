Return-Path: <linux-kernel-owner+w=401wt.eu-S1759186AbYCGHYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759186AbYCGHYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 02:24:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754515AbYCGHY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 02:24:28 -0500
Received: from dwdmx4.dwd.de ([141.38.3.230]:53124 "EHLO dwdmx4.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbYCGHY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 02:24:27 -0500
Date: Fri, 7 Mar 2008 07:24:17 +0000 (GMT)
From: Holger Kiehl <Holger.Kiehl@dwd.de>
X-X-Sender: kiehl@diagnostix.dwd.de
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, dhaval@linux.vnet.ibm.com,
       vatsa@linux.vnet.ibm.com, mingo@elte.hu, Greg KH <gregkh@suse.de>
Subject: Re: sysfs: duplicate filename '74' can not be created
In-Reply-To: <20080304160940.GC19059@localhost.sw.ru>
Message-ID: <Pine.LNX.4.64.0803070719260.22139@diagnostix.dwd.de>
References: <20080304160940.GC19059@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008, Alexey Dobriyan wrote:

> [Cc'ing /sys/kernel/uids guys]
>
>> Mar  3 13:50:01 helena kernel: sysfs: duplicate filename '74' can not be created
>> Mar  3 13:50:01 helena kernel: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
>> Mar  3 13:50:01 helena kernel: Pid: 21911, comm: sshd Not tainted 2.6.24.3 #1
>
> I see only one suspicious place: KOBJ_ADD is sent even if sysfs file
> creation failed and kobject is happily removed. But this almost
> certainly separate bug.
>
>
>
> You can try this debugging patch. Post several first consecutive messages.
> [crosses fingers]
>
Applied the patch and this time it oopsed immediatly. I just got one:

    Mar  7 07:09:04 helena kernel: general protection fault: 0000 [1] SMP
    Mar  7 07:09:04 helena kernel: CPU 3
    Mar  7 07:09:04 helena kernel: Modules linked in: lm85 hwmon_vid i2c_amd756_s4882 bonding nf_conntrack_ftp nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack xt_tcpudp iptable_filter ip_tables x_tables binfmt_misc video output ac floppy nvram ohci_hcd k8temp i2c_amd756 i2c_core button usbcore
    Mar  7 07:09:04 helena kernel: Pid: 2983, comm: modprobe Not tainted 2.6.24.3-alexey #3
    Mar  7 07:09:04 helena kernel: RIP: 0010:[<ffffffff8027931d>]  [<ffffffff8027931d>] __kmalloc_node+0x95/0xc9
    Mar  7 07:09:04 helena kernel: RSP: 0018:ffff81017d571de8  EFLAGS: 00010046
    Mar  7 07:09:04 helena kernel: RAX: 0000000000000000 RBX: 00000000000080d0 RCX: ffffffff8026d2b1
    Mar  7 07:09:04 helena kernel: RDX: ffff007265776f70 RSI: 00000000000080d0 RDI: ffffffff80554e38
    Mar  7 07:09:04 helena kernel: RBP: ffff810200026800 R08: 00000000005184b0 R09: ffffffff80554e38
    Mar  7 07:09:04 helena kernel: R10: 0000000000000000 R11: 0000000000000002 R12: 0000000000000286
    Mar  7 07:09:04 helena kernel: R13: 00000000ffffffff R14: 00000000ffffffff R15: 00000000005184b0
    Mar  7 07:09:04 helena kernel: FS:  00002b66d114c6f0(0000) GS:ffff81027e30e300(0000) knlGS:0000000000000000
    Mar  7 07:09:04 helena kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
    Mar  7 07:09:04 helena kernel: CR2: 0000003254acc030 CR3: 000000017d530000 CR4: 00000000000006e0
    Mar  7 07:09:04 helena kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    Mar  7 07:09:04 helena kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
    Mar  7 07:09:04 helena kernel: Process modprobe (pid: 2983, threadinfo ffff81017d570000, task ffff81017df3d5c0)
    Mar  7 07:09:04 helena kernel: Stack:  ffff81027d2fb740 ffffc200017e39a8 ffff81027d2fba00 00000000000000d0
    Mar  7 07:09:04 helena kernel:  ffffc200017e33e8 ffffffff8026d2b1 0000000000000163 ffffc200017e39a8
    Mar  7 07:09:04 helena kernel:  0000000000000018 ffffc200017e39a8 0000000000000018 ffffc200017e2f80
    Mar  7 07:09:04 helena kernel: Call Trace:
    Mar  7 07:09:04 helena kernel:  [<ffffffff8026d2b1>] __vmalloc_area_node+0x71/0x185
    Mar  7 07:09:04 helena kernel:  [<ffffffff80248ec0>] sys_init_module+0x94d/0x1872
    Mar  7 07:09:04 helena kernel:  [<ffffffff8020b61e>] system_call+0x7e/0x83
    Mar  7 07:09:04 helena kernel:
    Mar  7 07:09:04 helena kernel:
    Mar  7 07:09:04 helena kernel: Code: 48 8b 04 c2 48 89 45 00 41 54 9d 31 c0 c1 eb 0f 48 85 d2 0f
    Mar  7 07:09:04 helena kernel: RIP  [<ffffffff8027931d>] __kmalloc_node+0x95/0xc9
    Mar  7 07:09:04 helena kernel:  RSP <ffff81017d571de8>
    Mar  7 07:09:04 helena kernel: ---[ end trace 82b7eaeeb11c3ab5 ]---

After this the system was no longer reachable. Note, as before it always
happens on CPU3.

Holger

