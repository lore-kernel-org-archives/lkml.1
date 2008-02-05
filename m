Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565AbYBEI0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbYBEI0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 03:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860AbYBEI0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 03:26:06 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60850 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754762AbYBEI0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 03:26:03 -0500
Date: Tue, 5 Feb 2008 00:25:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu, tglx@linutronix.de,
       apw@shadowen.org, balbir@linux.vnet.ibm.com, randy.dunlap@oracle.com,
       linux-mm@kvack.org
Subject: Re: [BUG] regression from 2.6.24-rc8-mm1 and 2.6.24-mm1 kernel
 panic while bootup
Message-Id: <20080205002544.264a9484.akpm@linux-foundation.org>
In-Reply-To: <47A81BC9.5060600@linux.vnet.ibm.com>
References: <47A81BC9.5060600@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Feb 2008 13:48:17 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> The 2.6.24-mm1 kernel panics while bootup on the x86_64 (Dual Core AMD Opteron)
> box. This was seen in 2.6.24-rc8-mm1 either (http://lkml.org/lkml/2008/1/17/129).
> 
> BUG: unable to handle kernel paging request at 0000000000004a78
> IP: [<ffffffff8026c9e4>] __alloc_pages+0x47/0x337
> PGD 0 
> Oops: 0000 [1] SMP 
> last sysfs file: 
> CPU 0 
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.24-mm1-autotest #1
> RIP: 0010:[<ffffffff8026c9e4>]  [<ffffffff8026c9e4>] __alloc_pages+0x47/0x337
> RSP: 0000:ffff81003f9b9c20  EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000002
> RDX: 0000000000000010 RSI: 0000000000000605 RDI: ffffffff805bf425
> RBP: ffff81003f9b9c80 R08: 00380800000000c0 R09: 000000000003db8d
> R10: ffff81003f9b9d50 R11: 0000000000000001 R12: 00000000000000d0
> R13: 0000000000004a70 R14: 0000000000000000 R15: 0000000000000286
> FS:  0000000000000000(0000) GS:ffffffff8067f000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000004a78 CR3: 0000000000201000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 1, threadinfo ffff81003f9b8000, task ffff81003f9b6000)
> Stack:  0000001000000002 ffff81000000fa78 ffff81003f9b6000 0000000000000000
>  0000000000000303 ffffffff00000000 0000000400000000 0000000000000000
>  0000000000000000 ffffffff80815c90 ffffffff80815c90 0000000000000286
> Call Trace:
>  [<ffffffff8028be79>] new_slab+0x117/0x26c
>  [<ffffffff8028bfef>] get_new_slab+0x21/0xab
>  [<ffffffff8028c194>] __slab_alloc+0x11b/0x175
>  [<ffffffff805070b2>] process_zones+0x6c/0x152
>  [<ffffffff8028c22c>] kmem_cache_alloc_node+0x3e/0x74
>  [<ffffffff805070b2>] process_zones+0x6c/0x152
>  [<ffffffff805071cc>] pageset_cpuup_callback+0x34/0x92
>  [<ffffffff8050c520>] notifier_call_chain+0x33/0x65
>  [<ffffffff80249fa5>] __raw_notifier_call_chain+0x9/0xb
>  [<ffffffff80506cb4>] _cpu_up+0x6c/0x103
>  [<ffffffff80506da2>] cpu_up+0x57/0x67
>  [<ffffffff808be689>] kernel_init+0xc5/0x2fe
>  [<ffffffff8020cd88>] child_rip+0xa/0x12
>  [<ffffffff8036caa8>] acpi_ds_init_one_object+0x0/0x88
>  [<ffffffff808be5c4>] kernel_init+0x0/0x2fe
>  [<ffffffff8020cd7e>] child_rip+0x0/0x12

argh, I'd forgotten about that.  You bisected it down to a clearly-innocent
patch and none of the mm developers appeared interested.

Oh well, it'll probably be in mainline tomorrow.  That should get it
fixed.
