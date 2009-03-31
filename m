Return-Path: <linux-kernel-owner+w=401wt.eu-S1758564AbZCaNUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564AbZCaNUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 09:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbZCaNUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 09:20:40 -0400
Received: from www.tglx.de ([62.245.132.106]:60953 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbZCaNUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 09:20:39 -0400
Date: Tue, 31 Mar 2009 15:19:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Leech <christopher.leech@intel.com>
cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] irq: mask irq before move it
In-Reply-To: <20090330221034.GC27774@cleech-lnx.jf.intel.com>
Message-ID: <alpine.LFD.2.00.0903311306190.12916@localhost.localdomain>
References: <20090326220411.GA16286@cleech-lnx.jf.intel.com> <86802c440903261929s775fe85cv86b900e2610acf1d@mail.gmail.com> <20090327163438.GA10185@cleech-lnx.jf.intel.com> <49CDAAD5.9010202@kernel.org> <20090330221034.GC27774@cleech-lnx.jf.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Mar 2009, Chris Leech wrote:
>   alloc kstat_irqs on cpu 2 node 0
> BUG: spinlock bad magic on CPU#1, swapper/0
> general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
> last sysfs file: /sys/devices/pci0000:00/0000:00:03.0/0000:03:00.1/irq
> CPU 1 
> Modules linked in: netconsole configfs sunrpc ipv6 cpufreq_ondemand acpi_cpufreq freq_table dm_multipath ixgbe igb dca [last unloaded: microcode]
> Pid: 0, comm: swapper Not tainted 2.6.29-cdl-debug #26 
> RIP: 0010:[<ffffffff811b287c>]  [<ffffffff811b287c>] spin_bug+0x77/0xab
> RSP: 0018:ffff88007d157ee8  EFLAGS: 00010002
> RAX: 00000000ffffffff RBX: 6b6b6b6b6b6b6b6b RCX: ffffffff814f83b5
> RDX: 000000007d487d47 RSI: 0000000000000001 RDI: 0000000000000046
> RBP: ffff88007d157f08 R08: 0000000000000002 R09: 000000006b6b6b6b
> R10: ffffffff814e8f2a R11: 000000000000000a R12: ffff88007bde22a8
> R13: ffffffff814e8efc R14: ffff88007bde22a8 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff88007d1503e8(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 00007fb63f3d8000 CR3: 0000000000201000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 0, threadinfo ffff88003e57e000, task ffff88003e584680)
> Stack:
>  ffff88007d157f28 ffff88007bde22a8 0000000000000064 ffff88007b030e10
>  ffff88007d157f28 ffffffff811b28d1 ffff88007bde22a8 ffff88007bde22a8
>  ffff88007d157f48 ffffffff813a0e39 ffff88007bde2238 ffff88007bde2238
> Call Trace:
>  <IRQ> <0> [<ffffffff811b28d1>] _raw_spin_unlock+0x21/0x94
>  [<ffffffff813a0e39>] _spin_unlock+0x2b/0x2f
>  [<ffffffff8109a914>] handle_edge_irq+0x11a/0x123
>  [<ffffffff81013d27>] do_IRQ+0xe1/0x15a
>  [<ffffffff81011f93>] ret_from_intr+0x0/0x2e

Yinghai, you made sure that the irq is masked before we move it. Can
you exclude for sure, that it is not already in progress ?

Thanks,

	tglx
