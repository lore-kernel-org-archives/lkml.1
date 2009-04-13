Return-Path: <linux-kernel-owner+w=401wt.eu-S1753066AbZDMTz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbZDMTz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 15:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbZDMTzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 15:55:08 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36957 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbZDMTzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 15:55:06 -0400
Date: Mon, 13 Apr 2009 12:55:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, hugh@veritas.com,
       jmorris@namei.org, akpm@linux-foundation.org
Subject: Re: [2.6.30-rc1] RCU detected CPU 1 stall
Message-ID: <20090413195504.GF6983@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <200904080057.n380vZAH051872@www262.sakura.ne.jp> <20090410142203.GA6719@linux.vnet.ibm.com> <20090410150353.GL26366@ZenIV.linux.org.uk> <20090410153229.GB6719@linux.vnet.ibm.com> <200904110608.IED21123.FQOVMtSOOHFFLJ@I-love.SAKURA.ne.jp> <20090410231245.GF6719@linux.vnet.ibm.com> <20090410233919.GS26366@ZenIV.linux.org.uk> <200904130048.n3D0mw1f077050@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904130048.n3D0mw1f077050@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 09:48:58AM +0900, Tetsuo Handa wrote:
> Hello.
> 
> Paul E. McKenney wrote:
> > Is this reproducible?
> Not always, but it is reproducible.

Does it reproduce well enough to bisect?

> Al Viro wrote:
> > I'd really love to see results of repeated alt-sysrq-p/alt-sysrq-l, just
> > to see where was it actually spinning.
> Below is sysrq message.
> Maybe something related to khelper's current->mm == NULL warning problem.
> Full log is at http://I-love.SAKURA.ne.jp/tmp/dmesg-2.6.30-rc1-200904130930.txt .

I have to defer to the mm guys on this one.

							Thanx, Paul

> [   47.412519] SysRq : Show Regs
> [   47.413986] 
> [   47.414584] Pid: 3655, comm: khelper Tainted: G        W  (2.6.30-rc1 #1) VMware Virtual Platform
> [   47.415804] EIP: 0060:[<c0379c3d>] EFLAGS: 00000293 CPU: 0
> [   47.415804] EIP is at __get_user_4+0x11/0x17
> [   47.415804] EAX: f7150003 EBX: f7150000 ECX: 00000000 EDX: f6744000
> [   47.415804] ESI: 000007b8 EDI: 7fffffff EBP: f6744f20 ESP: f6744f10
> [   47.415804]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [   47.415804] CR0: 8005003b CR2: f7150000 CR3: 3599a000 CR4: 000006d0
> [   47.415804] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [   47.415804] DR6: ffff0ff0 DR7: 00000400
> [   47.415804] Call Trace:
> [   47.415804]  [<c0225f4e>] ? count+0x3e/0xb0
> [   47.415804]  [<c0228581>] do_execve+0x621/0x890
> [   47.415804]  [<c022bd8b>] ? getname+0x6b/0xa0
> [   47.415804]  [<c010237e>] sys_execve+0x5e/0xb0
> [   47.415804]  [<c0103d19>] syscall_call+0x7/0xb
> [   47.415804]  [<c010aee4>] ? kernel_execve+0x24/0x30
> [   47.415804]  [<c0172b6f>] ? ____call_usermodehelper+0xff/0x170
> [   47.415804]  [<c0172a70>] ? ____call_usermodehelper+0x0/0x170
> [   47.415804]  [<c0104707>] ? kernel_thread_helper+0x7/0x10
> [   52.551469] SysRq : Show backtrace of all active CPUs
> [   52.551803] CPU0:
> [   52.551803] 
> [   52.551803] Pid: 3655, comm: khelper Tainted: G        W  (2.6.30-rc1 #1) VMware Virtual Platform
> [   52.551803] EIP: 0060:[<c0379c3d>] EFLAGS: 00000293 CPU: 0
> [   52.551803] EIP is at __get_user_4+0x11/0x17
> [   52.551803] EAX: f7150003 EBX: f7150000 ECX: 00000000 EDX: f6744000
> [   52.551803] ESI: 000007b8 EDI: 7fffffff EBP: f6744f20 ESP: f6744f10
> [   52.551803]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [   52.551803] CR0: 8005003b CR2: f7150000 CR3: 3599a000 CR4: 000006d0
> [   52.551803] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [   52.551803] DR6: ffff0ff0 DR7: 00000400
> [   52.551803] Call Trace:
> [   52.551803]  [<c0225f4e>] ? count+0x3e/0xb0
> [   52.551803]  [<c0228581>] do_execve+0x621/0x890
> [   52.551803]  [<c022bd8b>] ? getname+0x6b/0xa0
> [   52.551803]  [<c010237e>] sys_execve+0x5e/0xb0
> [   52.551803]  [<c0103d19>] syscall_call+0x7/0xb
> [   52.551803]  [<c010aee4>] ? kernel_execve+0x24/0x30
> [   52.551803]  [<c0172b6f>] ? ____call_usermodehelper+0xff/0x170
> [   52.551803]  [<c0172a70>] ? ____call_usermodehelper+0x0/0x170
> [   52.551803]  [<c0104707>] ? kernel_thread_helper+0x7/0x10
> [   60.956967] SysRq : Show Regs
> [   60.958362] 
> [   60.958896] Pid: 3655, comm: khelper Tainted: G        W  (2.6.30-rc1 #1) VMware Virtual Platform
> [   60.959802] EIP: 0060:[<c0379c3d>] EFLAGS: 00000293 CPU: 0
> [   60.959802] EIP is at __get_user_4+0x11/0x17
> [   60.959802] EAX: f7150003 EBX: f7150000 ECX: 00000000 EDX: f6744000
> [   60.959802] ESI: 000007b8 EDI: 7fffffff EBP: f6744f20 ESP: f6744f10
> [   60.959802]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [   60.959802] CR0: 8005003b CR2: f7150000 CR3: 3599a000 CR4: 000006d0
> [   60.959802] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [   60.959802] DR6: ffff0ff0 DR7: 00000400
> [   60.959802] Call Trace:
> [   60.959802]  [<c0225f4e>] ? count+0x3e/0xb0
> [   60.959802]  [<c0228581>] do_execve+0x621/0x890
> [   60.959802]  [<c022bd8b>] ? getname+0x6b/0xa0
> [   60.959802]  [<c010237e>] sys_execve+0x5e/0xb0
> [   60.959802]  [<c0103d19>] syscall_call+0x7/0xb
> [   60.959802]  [<c010aee4>] ? kernel_execve+0x24/0x30
> [   60.959802]  [<c0172b6f>] ? ____call_usermodehelper+0xff/0x170
> [   60.959802]  [<c0172a70>] ? ____call_usermodehelper+0x0/0x170
> [   60.959802]  [<c0104707>] ? kernel_thread_helper+0x7/0x10
> [   69.014489] SysRq : Show backtrace of all active CPUs
> [   69.015802] CPU0:
> [   69.015802] 
> [   69.015802] Pid: 3655, comm: khelper Tainted: G        W  (2.6.30-rc1 #1) VMware Virtual Platform
> [   69.015802] EIP: 0060:[<c0379c3d>] EFLAGS: 00000293 CPU: 0
> [   69.015802] EIP is at __get_user_4+0x11/0x17
> [   69.015802] EAX: f7150003 EBX: f7150000 ECX: 00000000 EDX: f6744000
> [   69.015802] ESI: 000007b8 EDI: 7fffffff EBP: f6744f20 ESP: f6744f10
> [   69.015802]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [   69.015802] CR0: 8005003b CR2: f7150000 CR3: 3599a000 CR4: 000006d0
> [   69.015802] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [   69.015802] DR6: ffff0ff0 DR7: 00000400
> [   69.015802] Call Trace:
> [   69.015802]  [<c0225f4e>] ? count+0x3e/0xb0
> [   69.015802]  [<c0228581>] do_execve+0x621/0x890
> [   69.015802]  [<c022bd8b>] ? getname+0x6b/0xa0
> [   69.015802]  [<c010237e>] sys_execve+0x5e/0xb0
> [   69.015802]  [<c0103d19>] syscall_call+0x7/0xb
> [   69.015802]  [<c010aee4>] ? kernel_execve+0x24/0x30
> [   69.015802]  [<c0172b6f>] ? ____call_usermodehelper+0xff/0x170
> [   69.015802]  [<c0172a70>] ? ____call_usermodehelper+0x0/0x170
> [   69.015802]  [<c0104707>] ? kernel_thread_helper+0x7/0x10
> [   73.695801] INFO: RCU detected CPU 0 stall (t=4294910558/10000 jiffies)
> [   73.695801] Pid: 3655, comm: khelper Tainted: G        W  2.6.30-rc1 #1
> [   73.695801] Call Trace:
> [   73.695801]  [<c015949d>] ? printk+0x1d/0x30
> [   73.695801]  [<c01b38b5>] print_cpu_stall+0x45/0xa0
> [   73.695801]  [<c01b39f8>] check_cpu_stall+0xe8/0x190
> [   73.695801]  [<c01ad59d>] ? get_timestamp+0xd/0x20
> [   73.695801]  [<c01b43ab>] __rcu_pending+0x1b/0x160
> [   73.695801]  [<c01b451e>] rcu_pending+0x2e/0x70
> [   73.695801]  [<c01692ab>] update_process_times+0x3b/0x80
> [   73.695801]  [<c018bcf0>] tick_periodic+0x40/0x90
> [   73.695801]  [<c018bd5e>] tick_handle_periodic+0x1e/0xa0
> [   73.695801]  [<c01045e0>] ? apic_timer_interrupt+0x28/0x34
> [   73.695801]  [<c012215f>] local_apic_timer_interrupt+0x6f/0x80
> [   73.695801]  [<c0161184>] ? irq_enter+0x14/0x60
> [   73.695801]  [<c05e7d83>] smp_apic_timer_interrupt+0x33/0x42
> [   73.695801]  [<c01045e7>] apic_timer_interrupt+0x2f/0x34
> [   73.695801]  [<c0379c3d>] ? __get_user_4+0x11/0x17
> [   73.695801]  [<c0225f4e>] ? count+0x3e/0xb0
> [   73.695801]  [<c0228581>] do_execve+0x621/0x890
> [   73.695801]  [<c022bd8b>] ? getname+0x6b/0xa0
> [   73.695801]  [<c010237e>] sys_execve+0x5e/0xb0
> [   73.695801]  [<c0103d19>] syscall_call+0x7/0xb
> [   73.695801]  [<c010aee4>] ? kernel_execve+0x24/0x30
> [   73.695801]  [<c0172b6f>] ? ____call_usermodehelper+0xff/0x170
> [   73.695801]  [<c0172a70>] ? ____call_usermodehelper+0x0/0x170
> [   73.695801]  [<c0104707>] ? kernel_thread_helper+0x7/0x10
> [   79.029887] SysRq : Show Regs
> [   79.030975] 
> [   79.031578] Pid: 3655, comm: khelper Tainted: G        W  (2.6.30-rc1 #1) VMware Virtual Platform
> [   79.031800] EIP: 0060:[<c0379c3d>] EFLAGS: 00000293 CPU: 0
> [   79.031800] EIP is at __get_user_4+0x11/0x17
> [   79.031800] EAX: f7150003 EBX: f7150000 ECX: 00000000 EDX: f6744000
> [   79.031800] ESI: 000007b8 EDI: 7fffffff EBP: f6744f20 ESP: f6744f10
> [   79.031800]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [   79.031800] CR0: 8005003b CR2: f7150000 CR3: 3599a000 CR4: 000006d0
> [   79.031800] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [   79.031800] DR6: ffff0ff0 DR7: 00000400
> [   79.031800] Call Trace:
> [   79.031800]  [<c0225f4e>] ? count+0x3e/0xb0
> [   79.031800]  [<c0228581>] do_execve+0x621/0x890
> [   79.031800]  [<c022bd8b>] ? getname+0x6b/0xa0
> [   79.031800]  [<c010237e>] sys_execve+0x5e/0xb0
> [   79.031800]  [<c0103d19>] syscall_call+0x7/0xb
> [   79.031800]  [<c010aee4>] ? kernel_execve+0x24/0x30
> [   79.031800]  [<c0172b6f>] ? ____call_usermodehelper+0xff/0x170
> [   79.031800]  [<c0172a70>] ? ____call_usermodehelper+0x0/0x170
> [   79.031800]  [<c0104707>] ? kernel_thread_helper+0x7/0x10
> [   87.925907] SysRq : Show backtrace of all active CPUs
> [   87.927799] CPU0:
> [   87.927799] 
> [   87.927799] Pid: 3655, comm: khelper Tainted: G        W  (2.6.30-rc1 #1) VMware Virtual Platform
> [   87.927799] EIP: 0060:[<c0379c3d>] EFLAGS: 00000293 CPU: 0
> [   87.927799] EIP is at __get_user_4+0x11/0x17
> [   87.927799] EAX: f7150003 EBX: f7150000 ECX: 00000000 EDX: f6744000
> [   87.927799] ESI: 000007b8 EDI: 7fffffff EBP: f6744f20 ESP: f6744f10
> [   87.927799]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [   87.927799] CR0: 8005003b CR2: f7150000 CR3: 3599a000 CR4: 000006d0
> [   87.927799] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [   87.927799] DR6: ffff0ff0 DR7: 00000400
> [   87.927799] Call Trace:
> [   87.927799]  [<c0225f4e>] ? count+0x3e/0xb0
> [   87.927799]  [<c0228581>] do_execve+0x621/0x890
> [   87.927799]  [<c022bd8b>] ? getname+0x6b/0xa0
> [   87.927799]  [<c010237e>] sys_execve+0x5e/0xb0
> [   87.927799]  [<c0103d19>] syscall_call+0x7/0xb
> [   87.927799]  [<c010aee4>] ? kernel_execve+0x24/0x30
> [   87.927799]  [<c0172b6f>] ? ____call_usermodehelper+0xff/0x170
> [   87.927799]  [<c0172a70>] ? ____call_usermodehelper+0x0/0x170
> [   87.927799]  [<c0104707>] ? kernel_thread_helper+0x7/0x10
> [   98.785592] BUG: soft lockup - CPU#1 stuck for 61s! [khelper:3657]
> [   98.785592] Modules linked in: ipv6 pcnet32 crc32
> [   98.785592] irq event stamp: 0
> [   98.785592] hardirqs last  enabled at (0): [<(null)>] (null)
> [   98.785592] hardirqs last disabled at (0): [<c0155bcb>] copy_process+0x2ab/0x11a0
> [   98.785592] softirqs last  enabled at (0): [<c0155bcb>] copy_process+0x2ab/0x11a0
> [   98.785592] softirqs last disabled at (0): [<(null)>] (null)
> [   98.785592] 
> 
> Regards.
