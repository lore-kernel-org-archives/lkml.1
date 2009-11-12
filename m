Return-Path: <linux-kernel-owner+w=401wt.eu-S1752951AbZKLLxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbZKLLxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 06:53:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbZKLLxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 06:53:33 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:59936 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbZKLLxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 06:53:32 -0500
Message-ID: <4AFBF73B.5040500@in.ibm.com>
Date: Thu, 12 Nov 2009 17:23:31 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, peterz@infradead.org
Subject: -next: Nov 12 - kernel BUG at kernel/sched.c:7359!
References: <20091112195101.63263490.sfr@canb.auug.org.au>
In-Reply-To: <20091112195101.63263490.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
>
> Changes since 20091111:
>   
I came across the following bug while executing cpu hotplug tests
on a x86_64 box. This is with next version 2.6.32-rc6-20091112.
(20280eab85704dcd05a20903f0de80be1c761c6e)

This is a 4 way box. The problem is not always reproducible and
can be recreated only after some amount of activity.

------------[ cut here ]------------
kernel BUG at kernel/sched.c:7359!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/system/cpu/cpu1/online
CPU 0
Modules linked in: ipv6 fuse loop dm_mod sg mptctl bnx2 rtc_cmos rtc_core
rtc_lib i2c_piix4 tpm_tis serio_raw button shpchp pcspkr tpm i2c_core
pci_hotplug k8temp tpm_bios ohci_hcd ehci_hcd sd_mod crc_t10dif usbcore edd fan
thermal processor thermal_sys hwmon mptsas mptscsih mptbase scsi_transport_sas
scsi_mod
Pid: 11504, comm: hotplug04.sh Not tainted 2.6.32-rc6-autotest-next-20091112 #1
BladeCenter LS21 -[79716AA]-
RIP: 0010:[<ffffffff8134a744>]  [<ffffffff8134a744>] migration_call+0x381/0x51a
RSP: 0018:ffff8801159fdd48  EFLAGS: 00010046
RAX: 0000000000000001 RBX: ffff88011e2de180 RCX: ffffffffff8d8f20
RDX: ffff880028280000 RSI: ffff880028293f88 RDI: ffff880127a3e708
RBP: ffff8801159fdd98 R08: 0000000000000000 R09: 000000046c250cb4
R10: dead000000100100 R11: 7fffffffffffffff R12: ffffffff816d7020
R13: ffff880028293f00 R14: ffff880127a3e6c0 R15: ffff880028293f00
FS:  00007f782aef66f0(0000) GS:ffff880028200000(0000) knlGS:0000000055731b00
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000061f4f0 CR3: 00000001271a0000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process hotplug04.sh (pid: 11504, threadinfo ffff8801159fc000, task
ffff8801293e2600)
Stack:
 0000000000000001 0000000000013f00 0000000100000000 0000000000000001
<0> ffff8801159fddb8 0000000000000000 00000000fffffffe ffffffff8176c800
<0> 0000000000000001 0000000000000007 ffff8801159fddd8 ffffffff81351b16
Call Trace:
 [<ffffffff81351b16>] notifier_call_chain+0x33/0x5b
 [<ffffffff8105db28>] raw_notifier_call_chain+0xf/0x11
 [<ffffffff8133db32>] _cpu_down+0x1f7/0x2f1
 [<ffffffff8134cb6a>] ? wait_for_completion+0x18/0x1a
 [<ffffffff8133dc74>] cpu_down+0x48/0x80
 [<ffffffff8133f89a>] store_online+0x2c/0x6f
 [<ffffffff8128c44b>] sysdev_store+0x1b/0x1d
 [<ffffffff811382f8>] sysfs_write_file+0xdf/0x114
 [<ffffffff810e4401>] vfs_write+0xb4/0x186
 [<ffffffff810e4597>] sys_write+0x47/0x6e
 [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
Code: c6 75 05 48 8b 1b eb ed 49 8b 46 30 4c 89 f6 4c 89 ff ff 50 30 41 83 be
78 04 00 00 00 48 8b 45 b0 48 8b 14 c5 70 4d 77 81 75 04 <0f> 0b eb fe 49 8b 06
48 83 f8 40 75 04 0f 0b eb fe 48 8b 5d b8
RIP  [<ffffffff8134a744>] migration_call+0x381/0x51a

kernel/sched.c:7359 corresponds to

/* called under rq->lock with disabled interrupts */
static void migrate_dead(unsigned int dead_cpu, struct task_struct *p)
{
        struct rq *rq = cpu_rq(dead_cpu);

        /* Must be exiting, otherwise would be on tasklist. */
        BUG_ON(!p->exit_state); <<====

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

