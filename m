Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbZKNA6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbZKNA6I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 19:58:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbZKNA6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 19:58:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46569 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618AbZKNA6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 19:58:05 -0500
Date: Sat, 14 Nov 2009 01:58:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, bhavna.sarathy@amd.com,
       jbarnes@virtuousgeek.org, andreas.herrmann3@amd.com
Subject: Re: [PATCH]: AMD Northbridge: Verify NB's node is online
Message-ID: <20091114005800.GB17512@elte.hu>
References: <20091112180933.12532.98685.sendpatchset@prarit.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091112180933.12532.98685.sendpatchset@prarit.bos.redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Prarit Bhargava <prarit@redhat.com> wrote:

> Panic seen on some IBM and HP systems on 2.6.32-rc6.
> 
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<ffffffff8120bf3f>] find_next_bit+0x77/0x9c
> PGD 2735ba067 PUD 2735d5067 PMD 0 
> Oops: 0000 [#1] SMP 
> last sysfs file: /sys/devices/platform/pcspkr/modalias
> CPU 7 
> Modules linked in: k8temp(+) pcspkr edac_core serio_raw hwmon shpchp cciss dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod
> Pid: 616, comm: modprobe Not tainted 2.6.32-rc6 #2 ProLiant DL585 G2   
> RIP: 0010:[<ffffffff8120bf3f>]  [<ffffffff8120bf3f>] find_next_bit+0x77/0x9c
> RSP: 0018:ffff8802736fdd18  EFLAGS: 00010202
> RAX: 0000000000000000 RBX: ffffffff8182f680 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000008 RDI: 0000000000000008
> RBP: ffff8802736fdd18 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff81d922e0 R11: 0000000000000000 R12: 0000000000000000
> R13: ffffffffa007e720 R14: 0000000000000001 R15: 00000000015b19e0
> FS:  00007f0a474086f0(0000) GS:ffff880036400000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 0000000273cbb000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process modprobe (pid: 616, threadinfo ffff8802736fc000, task ffff8802743b5c00)
> Stack:
>  ffff8802736fdd38 ffffffff8120bbde ffff88027646b0d8 ffff88027646b168
> <0> ffff8802736fdd88 ffffffff81225c62 ffffffffa007e720 ffff88027646b0d8
> <0> ffffffffa007e930 ffffffff812b9be6 ffff88027646b168 ffffffffa007e780
> Call Trace:
>  [<ffffffff8120bbde>] cpumask_next_and+0x2e/0x3b
>  [<ffffffff81225c62>] pci_device_probe+0x8e/0xf5
>  [<ffffffff812b9be6>] ? driver_sysfs_add+0x47/0x6c
>  [<ffffffff812b9da5>] driver_probe_device+0xd9/0x1f9
>  [<ffffffff812b9f1d>] __driver_attach+0x58/0x7c
>  [<ffffffff812b9ec5>] ? __driver_attach+0x0/0x7c
>  [<ffffffff812b9298>] bus_for_each_dev+0x54/0x89
>  [<ffffffff812b9b4f>] driver_attach+0x19/0x1b
>  [<ffffffff812b97ae>] bus_add_driver+0xd3/0x23d
>  [<ffffffff812ba1e7>] driver_register+0x98/0x109
>  [<ffffffff81225ed0>] __pci_register_driver+0x63/0xd3
>  [<ffffffff81072776>] ? up_read+0x26/0x2a
>  [<ffffffffa0081000>] ? k8temp_init+0x0/0x20 [k8temp]
>  [<ffffffffa008101e>] k8temp_init+0x1e/0x20 [k8temp]
>  [<ffffffff8100a073>] do_one_initcall+0x6d/0x185
>  [<ffffffff8108d765>] sys_init_module+0xd3/0x236
>  [<ffffffff81011ac2>] system_call_fastpath+0x16/0x1b
> Code: 49 83 c0 40 eb 14 49 8b 01 48 85 c0 75 39 49 83 c1 08 49 83 c0 40 48 83 ef 40 48 f7 c7 c0 ff ff ff 75 e3 48 85 ff 4c 89 c0 74 23 <49> 8b 01 b9 40 00 00 00 48 83 ca ff 29 f9 48 d3 ea 48 21 d0 75 
> RIP  [<ffffffff8120bf3f>] find_next_bit+0x77/0x9c
>  RSP <ffff8802736fdd18>
> CR2: 0000000000000000
> ---[ end trace a3d7e2941e8a6320 ]---
> 
> Hardware maybe programmed incorrectly and return a bogus node ID.  
> Check to see if the node is actually online before setting the numa 
> node for an AMD northbridge in quirk_amd_nb_node().

Hm, could you stick a printk in there, what precise node ID does the 
hardware return?

	Ingo
