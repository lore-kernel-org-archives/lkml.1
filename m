Return-Path: <linux-kernel-owner+w=401wt.eu-S1759438AbZFITLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759438AbZFITLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 15:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbZFITLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 15:11:05 -0400
Received: from smtp4.netcologne.de ([194.8.194.137]:48275 "EHLO
	smtp4.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbZFITLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 15:11:03 -0400
From: Mathias Kretschmer <mathias@blx4.net>
Organization: BLX4
To: Mike Dresser <mdresser_l@windsormachine.com>
Subject: Re: [Bug #13375] Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
Date: Tue, 9 Jun 2009 21:11:53 +0200
User-Agent: KMail/1.9.9
Cc: Mathias Kretschmer <posting@blx4.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alex Samad <alex@samad.com.au>, Dave Chinner <david@fromorbit.com>
References: <sIiXQlfwS3D.A.81.dj7KKB@chimera> <200906080940.14650.posting@blx4.net> <alpine.DEB.1.10.0906091457510.28108@router.windsormachine.com>
In-Reply-To: <alpine.DEB.1.10.0906091457510.28108@router.windsormachine.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906092111.54073.mathias@blx4.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

same observation here. it's kswapd that dies.

swap space itself is hardly ever really used, since my box has 8GB and not 
that much stuff is running on it.

my XFS mount opts: noatime,nodiratime,logbufs=8

drive/fs config:  sata => raid6 => lvm => xfs => nfs

machine is stable for the last 36 hours with nfs turned off.

-Mathias
 
On Tuesday 09 June 2009 21:02:13 Mike Dresser wrote:
> Mine crashed last night, nothing was logged in the local logfiles, but
> fortunately remote syslog got it
>
> Jun  9 01:24:07 x kernel: ------------[ cut here ]------------
> Jun  9 01:24:07 x kernel: kernel BUG at lib/radix-tree.c:485!
> Jun  9 01:24:07 x kernel: invalid opcode: 0000 [#1] SMP
> Jun  9 01:24:07 x kernel: last sysfs file: /sys/class/scsi_host/host0/stats
> Jun  9 01:24:07 x kernel: CPU 0
> Jun  9 01:24:07 x kernel: Pid: 338, comm: kswapd0 Not tainted 2.6.30-rc8 #2
> S2895 Jun  9 01:24:07 x kernel: RIP: 0010:[<ffffffff803a5a04>] 
> [<ffffffff803a5a04>] radix_tree_tag_set+0x6b/0x9c Jun  9 01:24:07 x kernel:
> RSP: 0018:ffff88016e1e9c58  EFLAGS: 00010246 Jun  9 01:24:07 x kernel: RAX:
> 0000000000000038 RBX: 0000000000000000 RCX: 0000000000000038 Jun  9
> 01:24:07 x kernel: RDX: 0000000000000000 RSI: 00000000002faaf8 RDI:
> ffff88016c3b8220 Jun  9 01:24:07 x kernel: RBP: ffff88016e1e9c60 R08:
> 0000000000000000 R09: ffff8800927460b8 Jun  9 01:24:07 x kernel: R10:
> 0000000000000001 R11: 0000000000000000 R12: ffff8800666e61c0 Jun  9
> 01:24:07 x kernel: R13: ffff88016dc21c00 R14: ffff8800666e62c8 R15:
> ffff88016c3b821c Jun  9 01:24:07 x kernel: FS:  00007fda3776f6e0(0000)
> GS:ffff880028028000(0000) knlGS:0000000000000000 Jun  9 01:24:07 x kernel:
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b Jun  9 01:24:07 x kernel:
> CR2: 00007fda368758e0 CR3: 0000000000201000 CR4: 00000000000006e0 Jun  9
> 01:24:07 x kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000 Jun  9 01:24:07 x kernel: DR3: 0000000000000000 DR6:
> 00000000ffff0ff0 DR7: 0000000000000400 Jun  9 01:24:07 x kernel: Process
> kswapd0 (pid: 338, threadinfo ffff88016e1e8000, task ffff88016f245fa0) Jun 
> 9 01:24:07 x kernel: Stack:
> Jun  9 01:24:07 x kernel:  ffff88016c3b81e0 ffff88016e1e9ca0
> ffffffff8038dcd6 ffff88016e1e9d40 Jun  9 01:24:07 x kernel: 
> ffff8800666e6350 ffff8800666e61c0 0000000000000048 ffff88016e1e9d40 Jun  9
> 01:24:07 x kernel:  0000000000000080 ffff88016e1e9cc0 ffffffff8037f2d2
> ffff8800666e6350 Jun  9 01:24:07 x kernel: Call Trace:
> Jun  9 01:24:07 x kernel:  [<ffffffff8038dcd6>]
> xfs_inode_set_reclaim_tag+0x71/0x93 Jun  9 01:24:07 x kernel: 
> [<ffffffff8037f2d2>] xfs_reclaim+0x106/0x10d Jun  9 01:24:07 x kernel: 
> [<ffffffff8038c51e>] xfs_fs_destroy_inode+0x37/0x58 Jun  9 01:24:07 x
> kernel:  [<ffffffff8029dde0>] destroy_inode+0x32/0x47 Jun  9 01:24:07 x
> kernel:  [<ffffffff8029dec9>] dispose_list+0xd4/0x102 Jun  9 01:24:07 x
> kernel:  [<ffffffff8029e0f0>] shrink_icache_memory+0x1f9/0x22f Jun  9
> 01:24:07 x kernel:  [<ffffffff80269660>] shrink_slab+0xdf/0x154 Jun  9
> 01:24:07 x kernel:  [<ffffffff80269e13>] kswapd+0x48d/0x62c Jun  9 01:24:07
> x kernel:  [<ffffffff80267765>] ? isolate_pages_global+0x0/0x219 Jun  9
> 01:24:07 x kernel:  [<ffffffff802481b8>] ?
> autoremove_wake_function+0x0/0x38 Jun  9 01:24:07 x kernel: 
> [<ffffffff80269986>] ? kswapd+0x0/0x62c Jun  9 01:24:07 x kernel: 
> [<ffffffff80269986>] ? kswapd+0x0/0x62c Jun  9 01:24:07 x kernel: 
> [<ffffffff80247e1a>] kthread+0x56/0x83
> Jun  9 01:24:07 x kernel:  [<ffffffff8020c9ba>] child_rip+0xa/0x20
> Jun  9 01:24:07 x kernel:  [<ffffffff80247dc4>] ? kthread+0x0/0x83
> Jun  9 01:24:07 x kernel:  [<ffffffff8020c9b0>] ? child_rip+0x0/0x20
> Jun  9 01:24:07 x kernel: Code: 18 02 00 00 48 d3 e8 89 c1 83 e1 3f 41 0f
> a3 0c 11 19 c0 85 c0 75 07 49 8d 04 11 0f ab 08 48 63 c1 4d 8b 44 c0 18 4d
> 85 c0 75 04 <0f> 0b eb fe 41 83 eb 06 41 ff ca 45$ Jun  9 01:24:07 x
> kernel: RIP  [<ffffffff803a5a04>] radix_tree_tag_set+0x6b/0x9c Jun  9
> 01:24:07 x kernel:  RSP <ffff88016e1e9c58>
> Jun  9 01:24:07 x kernel: ---[ end trace a0564fe308c3b2b4 ]---
>
> CONFIG_XFS_DEBUG was on for this one.
>
> I've noticed it's always kswapd0 that dies?
>
> Mike


