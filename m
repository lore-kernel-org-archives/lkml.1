Return-Path: <linux-kernel-owner+w=401wt.eu-S1762954AbYHDU54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762954AbYHDU54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756130AbYHDU5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:57:48 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:58613 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755831AbYHDU5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:57:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=HDa742fbtg+RJ3E/6NUDYPfSXCxnfByNARbPIAJaacWdim0dfloWAJZRYLBk+oiE/bSGfn6M8sV3WFfJ1rNyjO4VNxCw8PxXojwrP16qP3FAccoC+1QcivC4vTM5Tam3;
Message-ID: <48976D47.7090708@simon.arlott.org.uk>
Date: Mon, 04 Aug 2008 21:57:43 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: linux-pm@lists.linux-foundation.org
Subject: Re: HOTPLUG_CPU: WARNING: at fs/sysfs/dir.c:465 sysfs_add_one+0x3a/0x42()
 followed by BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
References: <488A20F1.5080309@simon.arlott.org.uk>
In-Reply-To: <488A20F1.5080309@simon.arlott.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've now had the same error as below, but during resume from suspend to ram:
http://img98.imageshack.us/img98/2643/1005526ci3.jpg

On 25/07/08 19:52, Simon Arlott wrote:
> I turned CPU 4 off (using /sys/devices/cpu4/online):
> [ 2438.434629] CPU 4 is now offline
> 
> (Which causes strange /proc/cpuinfo output - it just stops after CPU 3, 
> CPUs 5-7 are missing...)
> 
> And back on again:
> [ 2490.874775] Booting processor 4/4 ip 6000
> [ 2490.878266] Initializing CPU#4
> [ 2490.938748] Calibrating delay using timer specific routine.. 
> <6>4402.25 BogoMIPS (lpj=2201129)
> [ 2490.938761] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
> bytes/line)
> [ 2490.938765] CPU: L2 Cache: 512K (64 bytes/line)
> [ 2490.938769] CPU 4/4 -> Node 1
> [ 2490.938773] CPU: Physical Processor ID: 1
> [ 2490.938775] CPU: Processor Core ID: 0
> [ 2490.939257] x86 PAT enabled: cpu 4, old 0x7040600070406, new 
> 0x7010600070106
> [ 2490.946803] CPU4: Quad-Core AMD Opteron(tm) Processor 2354 stepping 03
> [ 2490.946818] checking TSC synchronization [CPU#2 -> CPU#4]: passed.
> [ 2490.966804] Switched to high resolution mode on CPU 4
> 
> Then this happened:
> [ 2490.970873] sysfs: duplicate filename 'machinecheck4' can not be created
> [ 2490.970883] ------------[ cut here ]------------
> [ 2490.970887] WARNING: at fs/sysfs/dir.c:465 sysfs_add_one+0x3a/0x42()
> [ 2490.970889] Modules linked in: fglrx(P)
> [ 2490.970899] Pid: 30034, comm: bash Tainted: P        W 2.6.26 
> #06912-g8e053ca
> [ 2490.970903] [ 2490.970903] Call Trace:
> [ 2490.970911]  [<ffffffff80231f34>] warn_on_slowpath+0x58/0x86
> [ 2490.970916]  [<ffffffff80232a47>] ? printk+0x67/0x69
> [ 2490.970923]  [<ffffffff80343b9d>] ? ida_get_new_above+0xf8/0x183
> [ 2490.970929]  [<ffffffff8029aae9>] ? ifind+0x59/0xa2
> [ 2490.970934]  [<ffffffff802cc9cd>] ? sysfs_find_dirent+0x1c/0x31
> [ 2490.970939]  [<ffffffff802cca01>] ? __sysfs_add_one+0x1f/0x7c
> [ 2490.970944]  [<ffffffff802cca98>] sysfs_add_one+0x3a/0x42
> [ 2490.970949]  [<ffffffff802cd016>] create_dir+0x58/0x93
> [ 2490.970954]  [<ffffffff802cd089>] sysfs_create_dir+0x38/0x4f
> [ 2490.970959]  [<ffffffff8034463c>] ? kobject_get+0x1a/0x22
> [ 2490.970964]  [<ffffffff80344791>] kobject_add_internal+0xcf/0x18f
> [ 2490.970969]  [<ffffffff80344919>] kobject_add_varg+0x41/0x4e
> [ 2490.970974]  [<ffffffff80344994>] kobject_init_and_add+0x6e/0x7c
> [ 2490.970979]  [<ffffffff803452d0>] ? kobject_uevent_env+0x355/0x384
> [ 2490.970985]  [<ffffffff803bf858>] sysdev_register+0x64/0xc5
> [ 2490.970992]  [<ffffffff805c74ff>] mce_create_device+0xb7/0x15f
> [ 2490.970998]  [<ffffffff805c5394>] ? cpu_vsyscall_init+0x0/0x92
> [ 2490.971003]  [<ffffffff805c75e1>] mce_cpu_callback+0x3a/0xb0
> [ 2490.971010]  [<ffffffff805d2010>] notifier_call_chain+0x33/0x65
> [ 2490.971017]  [<ffffffff802483e9>] __raw_notifier_call_chain+0x9/0xb
> [ 2490.971022]  [<ffffffff802483fa>] raw_notifier_call_chain+0xf/0x11
> [ 2490.971028]  [<ffffffff805cb453>] cpu_up+0x101/0x152
> [ 2490.971032]  [<ffffffff805b9f3f>] store_online+0x4d/0x75
> [ 2490.971037]  [<ffffffff803bf29b>] sysdev_store+0x1b/0x1d
> [ 2490.971043]  [<ffffffff802cc073>] sysfs_write_file+0xe0/0x11c
> [ 2490.971048]  [<ffffffff80288629>] vfs_write+0xae/0x137
> [ 2490.971052]  [<ffffffff80288ad2>] sys_write+0x47/0x6f
> [ 2490.971058]  [<ffffffff8020b4eb>] system_call_fastpath+0x16/0x1b
> [ 2490.971061] [ 2490.971065] ---[ end trace a8f73e07a39bbeae ]---
> [ 2490.971070] kobject_add_internal failed for machinecheck4 with 
> -EEXIST, don't try to register things with the same name in the same 
> directory.
> [ 2490.971076] Pid: 30034, comm: bash Tainted: P        W 2.6.26 
> #06912-g8e053ca
> [ 2490.971080] [ 2490.971081] Call Trace:
> [ 2490.971086]  [<ffffffff80344514>] ? kobject_put+0x4c/0x50
> [ 2490.971090]  [<ffffffff8034480f>] kobject_add_internal+0x14d/0x18f
> [ 2490.971095]  [<ffffffff80344919>] kobject_add_varg+0x41/0x4e
> [ 2490.971100]  [<ffffffff80344994>] kobject_init_and_add+0x6e/0x7c
> [ 2490.971105]  [<ffffffff803452d0>] ? kobject_uevent_env+0x355/0x384
> [ 2490.971110]  [<ffffffff803bf858>] sysdev_register+0x64/0xc5
> [ 2490.971115]  [<ffffffff805c74ff>] mce_create_device+0xb7/0x15f
> [ 2490.971120]  [<ffffffff805c5394>] ? cpu_vsyscall_init+0x0/0x92
> [ 2490.971125]  [<ffffffff805c75e1>] mce_cpu_callback+0x3a/0xb0
> [ 2490.971130]  [<ffffffff805d2010>] notifier_call_chain+0x33/0x65
> [ 2490.971135]  [<ffffffff802483e9>] __raw_notifier_call_chain+0x9/0xb
> [ 2490.971141]  [<ffffffff802483fa>] raw_notifier_call_chain+0xf/0x11
> [ 2490.971146]  [<ffffffff805cb453>] cpu_up+0x101/0x152
> [ 2490.971150]  [<ffffffff805b9f3f>] store_online+0x4d/0x75
> [ 2490.971155]  [<ffffffff803bf29b>] sysdev_store+0x1b/0x1d
> [ 2490.971160]  [<ffffffff802cc073>] sysfs_write_file+0xe0/0x11c
> [ 2490.971164]  [<ffffffff80288629>] vfs_write+0xae/0x137
> [ 2490.971168]  [<ffffffff80288ad2>] sys_write+0x47/0x6f
> [ 2490.971173]  [<ffffffff8020b4eb>] system_call_fastpath+0x16/0x1b
> [ 2490.971176] [ 2490.971191] BUG: unable to handle kernel NULL pointer 
> dereference at 0000000000000038
> [ 2490.971201] IP: [<ffffffff802ccace>] sysfs_addrm_start+0x2e/0x96
> [ 2490.971209] PGD 27d1f7067 PUD 25bde8067 PMD 0 [ 2490.971222] Oops: 
> 0000 [1] PREEMPT SMP [ 2490.971235] CPU 2 [ 2490.971241] Modules linked 
> in: fglrx(P)
> [ 2490.971251] Pid: 30034, comm: bash Tainted: P        W 2.6.26 
> #06912-g8e053ca
> [ 2490.971255] RIP: 0010:[<ffffffff802ccace>]  [<ffffffff802ccace>] 
> sysfs_addrm_start+0x2e/0x96
> [ 2490.971264] RSP: 0018:ffff8804590a5a98  EFLAGS: 00010246
> [ 2490.971268] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 
> 0000000000000000
> [ 2490.971273] RDX: 0000000fc0000008 RSI: 0000000000000000 RDI: 
> ffff88047fc1bc00
> [ 2490.971277] RBP: ffff8804590a5aa8 R08: 0000000000000080 R09: 
> 0000000000000000
> [ 2490.971281] R10: ffff8804590a5bd8 R11: 0000000000000000 R12: 
> ffff8804590a5ab8
> [ 2490.971286] R13: 00000000fffffff4 R14: 0000000000000000 R15: 
> ffff8804590a5b28
> [ 2490.971291] FS:  00007f85bfc166f0(0000) GS:ffff88027f06c8c0(0000) 
> knlGS:00000000f75766d0
> [ 2490.971295] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 2490.971300] CR2: 0000000000000038 CR3: 000000025bc1b000 CR4: 
> 00000000000006e0
> [ 2490.971304] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
> 0000000000000000
> [ 2490.971309] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
> 0000000000000400
> [ 2490.971314] Process bash (pid: 30034, threadinfo ffff8804590a4000, 
> task ffff88043b88ecb0)
> [ 2490.971318] Stack:  ffff8804590a5ab8 ffff88027e199a50 
> ffff8804590a5b08 ffffffff802cd00b
> [ 2490.971336]  0000000000000000 0000000000000000 0000000000000000 
> 0000000000000000
> [ 2490.971352]  ffff8804590a5bb8 ffff88027e1d0c00 ffff88027e1d0c00 
> 00000000fffffffe
> [ 2490.971365] Call Trace:
> [ 2490.971370]  [<ffffffff802cd00b>] create_dir+0x4d/0x93
> [ 2490.971375]  [<ffffffff802cd089>] sysfs_create_dir+0x38/0x4f
> [ 2490.971380]  [<ffffffff8034463c>] ? kobject_get+0x1a/0x22
> [ 2490.971385]  [<ffffffff80344791>] kobject_add_internal+0xcf/0x18f
> [ 2490.971389]  [<ffffffff80344919>] kobject_add_varg+0x41/0x4e
> [ 2490.971394]  [<ffffffff80344cc1>] kobject_add+0x89/0x8b
> [ 2490.971400]  [<ffffffff8034907c>] ? sprintf+0x68/0x6a
> [ 2490.971405]  [<ffffffff803443e1>] ? kobject_init_internal+0x1a/0x36
> [ 2490.971410]  [<ffffffff80344466>] ? kobject_init+0x42/0x6a
> [ 2490.971415]  [<ffffffff803444c1>] ? kobject_create+0x33/0x3a
> [ 2490.971420]  [<ffffffff80344cfa>] kobject_create_and_add+0x37/0x67
> [ 2490.971425]  [<ffffffff805c7b14>] threshold_create_device+0x1a6/0x327
> [ 2490.971430]  [<ffffffff8034530a>] ? kobject_uevent+0xb/0xd
> [ 2490.971435]  [<ffffffff803bf8a9>] ? sysdev_register+0xb5/0xc5
> [ 2490.971441]  [<ffffffff805c7cf3>] threshold_cpu_callback+0x5e/0x2be
> [ 2490.971446]  [<ffffffff805c5394>] ? cpu_vsyscall_init+0x0/0x92
> [ 2490.971451]  [<ffffffff805d2010>] notifier_call_chain+0x33/0x65
> [ 2490.971456]  [<ffffffff802483e9>] __raw_notifier_call_chain+0x9/0xb
> [ 2490.971462]  [<ffffffff802483fa>] raw_notifier_call_chain+0xf/0x11
> [ 2490.971467]  [<ffffffff805cb453>] cpu_up+0x101/0x152
> [ 2490.971472]  [<ffffffff805b9f3f>] store_online+0x4d/0x75
> [ 2490.971476]  [<ffffffff803bf29b>] sysdev_store+0x1b/0x1d
> [ 2490.971481]  [<ffffffff802cc073>] sysfs_write_file+0xe0/0x11c
> [ 2490.971486]  [<ffffffff80288629>] vfs_write+0xae/0x137
> [ 2490.971490]  [<ffffffff80288ad2>] sys_write+0x47/0x6f
> [ 2490.971495]  [<ffffffff8020b4eb>] system_call_fastpath+0x16/0x1b
> [ 2490.971499] [ 2490.971502] [ 2490.971506] Code: b9 08 00 00 00 fc 48 
> 89 e5 41 54 49 89 fc 53 48 89 f3 f3 ab 49 89 34 24 48 c7 c7 a0 8e 74 80 
> e8 a9 18 30 00 48 8b 3d 9a a2 68 00 <48> 8b 73 38 48 89 d9 48 c7 c2 a6 
> c7 2c 80 e8 98 e0 fc ff 48 85 [ 2490.971704] RIP  [<ffffffff802ccace>] 
> sysfs_addrm_start+0x2e/0x96
> [ 2490.971712]  RSP <ffff8804590a5a98>
> [ 2490.971715] CR2: 0000000000000038
> [ 2490.971720] ---[ end trace a8f73e07a39bbeae ]---
> 


-- 
Simon Arlott
