Return-Path: <linux-kernel-owner+w=401wt.eu-S1753442AbXL0J52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbXL0J52 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 04:57:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbXL0J5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 04:57:21 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59743 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751155AbXL0J5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 04:57:20 -0500
Date: Thu, 27 Dec 2007 01:54:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: 2.6.24-rc6-mm1 Kernel panics at different functions ()
Message-Id: <20071227015410.2c09db2f.akpm@linux-foundation.org>
In-Reply-To: <47736732.7040400@linux.vnet.ibm.com>
References: <20071222233056.d652743e.akpm@linux-foundation.org>
	<47736732.7040400@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Dec 2007 14:19:54 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Hi Andrew,
> 
> The 2.6.24-rc6-mm1 kernel with hotfix x86-fix-system-gate-related-crash.patch applied
> panics while booting on a x86_64 box
> 
> Unable to handle kernel NULL pointer dereference at 0000000000000046 RIP: 
>  [<ffffffff80369a0b>] rb_erase+0xe7/0x2a3
> PGD 17ff65067 PUD 17f1c7067 PMD 0 
> Oops: 0000 [1] SMP 
> last sysfs file: /sys/devices/pci0000:00/0000:00:0a.0/0000:02:04.0/host0/target0:0:6/0:0:6:0/type
> CPU 0 
> Modules linked in:
> Pid: 0, comm: swapper Not tainted 2.6.24-rc6-mm1-autokern1 #1
> RIP: 0010:[<ffffffff80369a0b>]  [<ffffffff80369a0b>] rb_erase+0xe7/0x2a3
> RSP: 0000:ffffffff80650e00  EFLAGS: 00010002
> RAX: ffff8101fe9568c8 RBX: ffff8100010062a8 RCX: ffff8101fe9568b0
> RDX: ffff8101fe9568c8 RSI: 0000000000000046 RDI: 0000000000000000
> RBP: ffffffff80650e10 R08: ffff8101fe9568c8 R09: 0000000000000086
> R10: 0000000000000000 R11: 00000000000001e8 R12: ffff8100010062b8
> R13: 0000000000000002 R14: ffff810001006260 R15: 0000000000000001
> FS:  0000000000000000(0000) GS:ffffffff805dc000(0000) knlGS:00000000f31ffbb0
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000046 CR3: 000000017f0ab000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 0, threadinfo ffffffff805f6000, task ffffffff805a2080)
> Stack:  ffff8100010062a8 ffff8101fe9568b0 ffffffff80650e40 ffffffff8024be16
>  ffffffff80369d65 ffffffff80369d65 ffff8101fe9568b0 ffff8100010062a8
>  ffffffff80650eb0 ffffffff8024c1d5 ffffffffb88cc28e 0000000006e73eff
> Call Trace:
>  <IRQ>  [<ffffffff8024be16>] __remove_hrtimer+0x2e/0x3c
>  [<ffffffff80369d65>] __down_read_trylock+0x16/0x42
>  [<ffffffff80369d65>] __down_read_trylock+0x16/0x42
>  [<ffffffff8024c1d5>] hrtimer_run_queues+0x130/0x191
>  [<ffffffff8023fd09>] run_timer_softirq+0x28/0x1a7
>  [<ffffffff8023c018>] __do_softirq+0x55/0xc2
>  [<ffffffff8020c73c>] call_softirq+0x1c/0x28
>  [<ffffffff8020e719>] do_softirq+0x32/0x9d
>  [<ffffffff8023c0dd>] irq_exit+0x3f/0x41
>  [<ffffffff8021ff85>] smp_apic_timer_interrupt+0x92/0xa7
>  [<ffffffff8020c1e6>] apic_timer_interrupt+0x66/0x70
>  <EOI>  [<ffffffff802095f5>] default_idle+0x36/0x5e
>  [<ffffffff802095f0>] default_idle+0x31/0x5e
>  [<ffffffff802095bf>] default_idle+0x0/0x5e
>  [<ffffffff802096b6>] cpu_idle+0x90/0xb2
>  [<ffffffff804b0126>] rest_init+0x5a/0x5c
>  [<ffffffff806017ee>] start_kernel+0x2b8/0x2c4
>  [<ffffffff8060112b>] _sinittext+0x12b/0x132
> 
> 

It does seem to be mostly hrtimer-related.  But surely the hrtimer system
is initialised by the time tis happens.

The usual refrain: is it possible to run a bisection search?
