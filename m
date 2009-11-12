Return-Path: <linux-kernel-owner+w=401wt.eu-S1751418AbZKLFEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418AbZKLFEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 00:04:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbZKLFEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 00:04:52 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:35220 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbZKLFEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 00:04:52 -0500
To: <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: kernel BUG at /home/eric/projects/linux/linux-2.6.32-rc6-sysctl-simplification/kernel/sched.c:7321!
References: <m1ljiccpiu.fsf@fess.ebiederm.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 11 Nov 2009 21:04:51 -0800
In-Reply-To: <m1ljiccpiu.fsf@fess.ebiederm.org> (Eric W. Biederman's message of "Wed\, 11 Nov 2009 20\:53\:29 -0800")
Message-ID: <m1fx8kcozw.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Exit with error (see exim mainlog)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Bah. I have finally gotten the problem to reproduce with verbose
debugging enabled. It was migrate_dead: BUG_ON(!p->exit_state)
that triggered.

Eric

[ 1591.705444] sd 6:0:0:0: [sdb] Synchronizing SCSI cache
[ 1591.710766] sd 6:0:0:0: [sdb] Stopping disk
[ 1592.062511] sd 5:0:0:0: [sda] Synchronizing SCSI cache
[ 1592.067814] sd 5:0:0:0: [sda] Stopping disk
[ 1592.545072] e1000e 0000:04:00.0: PCI INT A disabled
[ 1592.550008] e1000e 0000:04:00.0: PME# enabled
[ 1592.569415] ACPI: Preparing to enter system sleep state S5
[ 1592.575508] Disabling non-boot CPUs ...
[ 1592.581800] CPU 1 is now offline
[ 1592.602917] CPU1 is down
[ 1592.608352] CPU 2 is now offline
[ 1592.633354] CPU2 is down
[ 1592.641196] CPU 3 is now offline
[ 1592.644483] SMP alternatives: switching to UP code
[ 1592.655745] ------------[ cut here ]------------
[ 1592.656859] kernel BUG at /home/eric/projects/linux/linux-2.6.32-rc6-sysctl-simplification/kernel/sched.c:7321!
[ 1592.656859] invalid opcode: 0000 [#1] SMP 
[ 1592.656859] last sysfs file: /sys/devices/pci0000:00/0000:00:1d.3/usb5/5-0:1.0/bInterfaceProtocol
[ 1592.656859] CPU 0 
[ 1592.656859] Modules linked in:
[ 1592.656859] Pid: 7103, comm: halt Not tainted 2.6.32-rc6x86_64 #22         
[ 1592.656859] RIP: 0010:[<ffffffff813d0ef3>]  [<ffffffff813d0ef3>] migration_call+0x358/0x4cd
[ 1592.656859] RSP: 0018:ffff880037771d48  EFLAGS: 00010046
[ 1592.656859] RAX: 0000000000000003 RBX: 0000000000010000 RCX: ffff880001980000
[ 1592.656859] RDX: 0000000000010000 RSI: ffff880001990088 RDI: ffff88007f17f3e8
[ 1592.656859] RBP: ffff880001990000 R08: ffff88007fbd8698 R09: ffff880001990060
[ 1592.656859] R10: ffff88007fbd8688 R11: 0000000000000001 R12: ffff88007f17f3a0
[ 1592.656859] R13: ffff880001990000 R14: 0000000000000003 R15: 0000000000000000
[ 1592.656859] FS:  00007f12843ea6f0(0000) GS:ffff880001800000(0000) knlGS:0000000000000000
[ 1592.656859] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1592.656859] CR2: 00000000005aae48 CR3: 00000000379c5000 CR4: 00000000000006f0
[ 1592.656859] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1592.656859] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1592.656859] Process halt (pid: 7103, threadinfo ffff880037770000, task ffff88007f18b3e0)
[ 1592.656859] Stack:
[ 1592.656859]  0000000000000003 0000000000000000 0000000000000000 00000000ffffffff
[ 1592.656859] <0> ffffffff81628ec0 0000000000000003 0000000000000017 ffffffff81049014
[ 1592.656859] <0> ffff88007f18b3e0 0000000000000003 0000000000000010 ffffffff8162a0e8
[ 1592.656859] Call Trace:
[ 1592.656859]  [<ffffffff81049014>] ? notifier_call_chain+0x29/0x56
[ 1592.656859]  [<ffffffff813b47f8>] ? _cpu_down+0x1a6/0x284
[ 1592.656859]  [<ffffffff81036189>] ? disable_nonboot_cpus+0x63/0xfa
[ 1592.656859]  [<ffffffff8104108b>] ? kernel_power_off+0x21/0x3a
[ 1592.656859]  [<ffffffff81041333>] ? sys_reboot+0x13b/0x158
[ 1592.656859]  [<ffffffff8103f295>] ? kill_pid_info+0x35/0x46
[ 1592.656859]  [<ffffffff8103fb29>] ? sys_kill+0x72/0x143
[ 1592.656859]  [<ffffffff8109a466>] ? dput+0x2c/0x13a
[ 1592.656859]  [<ffffffff8108c690>] ? __fput+0x198/0x1c8
[ 1592.656859]  [<ffffffff8109ed0d>] ? mntput_no_expire+0x1c/0x8c
[ 1592.656859]  [<ffffffff81089fb0>] ? filp_close+0x5e/0x66
[ 1592.656859]  [<ffffffff8100aceb>] ? system_call_fastpath+0x16/0x1b
[ 1592.656859] Code: 49 8b 44 24 30 4c 89 e6 4c 89 ef ff 50 30 48 c7 c2 00 00 01 00 44 89 f0 41 83 bc 24 48 01 00 00 00 48 8b 0c c5 20 9c 62 81 75 04 <0 
[ 1592.656859] RIP  [<ffffffff813d0ef3>] migration_call+0x358/0x4cd
[ 1592.656859]  RSP <ffff880037771d48>
[ 1592.656859] ---[ end trace bb0b71ca768c73d8 ]---

