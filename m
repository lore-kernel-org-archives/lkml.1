Return-Path: <linux-kernel-owner+w=401wt.eu-S1758038AbXH1LPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038AbXH1LPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 07:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbXH1LO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 07:14:57 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:48005 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbXH1LO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 07:14:56 -0400
Date: Tue, 28 Aug 2007 15:14:31 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: torvalds@osdl.org, len.brown@intel.com, ak@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc4: maxcpus still broken
Message-ID: <20070828111431.GA27707@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Every time I try to boot with maxcpus=1 it dies show_stat():

        for_each_possible_cpu(i) {
                int j;

HERE ==>        user = cputime64_add(user, kstat_cpu(i).cpustat.user);


$ grep ACPI .config
$ grep APIC .config
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_LOCAL_APIC=y


Unable to handle kernel paging request at ffffffff804ed6e0 RIP: 
 [<ffffffff802a5cd0>] show_stat+0xc8/0x3a6
PGD 203067 PUD 207063 PMD 17fc27163 PTE 4ed000
Oops: 0000 [1] SMP 
CPU 0 
Modules linked in:
Pid: 380, comm: udevd Not tainted 2.6.23-rc4-utrace #1
RIP: 0010:[<ffffffff802a5cd0>]  [<ffffffff802a5cd0>] show_stat+0xc8/0x3a6
RSP: 0018:ffff81017ed77d88  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000001
RDX: ffffffff804ed6e0 RSI: 0000000000000000 RDI: 0000000000000001
RBP: 0000000000000022 R08: 0000000000000000 R09: 0000000000000000
R10: ffff81017fd52080 R11: 0000000000000246 R12: 0000000000000000
R13: 000000000000011d R14: 0000000000000000 R15: 00007fff33944ef0
FS:  00002b32774b26d0(0000) GS:ffffffff804aa000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffff804ed6e0 CR3: 000000017f38f000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process udevd (pid: 380, threadinfo ffff81017ed76000, task ffff81017fd52080)
Stack:  ffff81017fd52080 ffffffff802418ac ffff81017fd52810 ffff81017fd52080
 0000000000000003 ffffffff80241d15 ffff81017fd52810 ffff81017f79d668
 0000000046d3d6bf ffffffff80241e73 ffff81017f79d698 ffff81017fd52080
Call Trace:
 [<ffffffff802418ac>] check_usage_backwards+0x1e/0x43
 [<ffffffff80241d15>] mark_lock+0x367/0x47c
 [<ffffffff80241e73>] mark_held_locks+0x49/0x67
 [<ffffffff803b1cf8>] __mutex_lock_slowpath+0x254/0x26a
 [<ffffffff803b1d03>] __mutex_lock_slowpath+0x25f/0x26a
 [<ffffffff8028a216>] seq_read+0x10b/0x2a1
 [<ffffffff8028a10b>] seq_read+0x0/0x2a1
 [<ffffffff802a0590>] proc_reg_read+0x80/0x9a
 [<ffffffff80272a9b>] vfs_read+0x91/0xb5
 [<ffffffff80272dd3>] sys_read+0x45/0x6e
 [<ffffffff8020b5ae>] system_call+0x7e/0x83


Code: 48 8b 0c 02 48 01 4c 24 68 48 8b 4c 02 08 48 01 4c 24 70 48 
RIP  [<ffffffff802a5cd0>] show_stat+0xc8/0x3a6
 RSP <ffff81017ed77d88>
CR2: ffffffff804ed6e0
awk used greatest stack depth: 4272 bytes left

