Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbXCZSKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbXCZSKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 14:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbXCZSKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 14:10:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:11321 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646AbXCZSKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 14:10:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,330,1170662400"; 
   d="scan'208"; a="203064040:sNHT23920820"
In-Reply-To: <20070326090439.GA18484@elte.hu>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070326090439.GA18484@elte.hu>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <44408954-D81A-406B-B509-6390969F2F6A@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
Content-Transfer-Encoding: 7bit
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: 2.6.21-rc5: maxcpus=1 crash in cpufreq: kernel BUG at drivers/cpufreq/cpufreq.c:82!
Date: Mon, 26 Mar 2007 11:12:02 -0700
To: Ingo Molnar <mingo@elte.hu>
X-Mailer: Apple Mail (2.752.3)
X-OriginalArrivalTime: 26 Mar 2007 18:10:17.0361 (UTC) FILETIME=[022C2010:01C76FD2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 26, 2007, at 2:04 AM, Ingo Molnar wrote:

>
> trying to debug the forcedeth crash triggered another, new
> v2.6.20 -> v2.6.21 regression:
>
> maxcpus=1 on a dual-core system crashes the x86_64 SMP kernel in
> lock_policy_rwsem_write() - see the crash log below. Config attached.
>
> i suspect it could be related to this recent commit:
>
>  commit 5a01f2e8f3ac134e24144d74bb48a60236f7024d
>  Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>  Date:   Mon Feb 5 16:12:44 2007 -0800
>
>     [CPUFREQ] Rewrite lock in cpufreq to eliminate cpufreq/hotplug  
> related issue
>
> 	Ingo
> Calling initcall 0xffffffff8021e003: powernowk8_init+0x0/0x88()
> powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 3800+  
> processors (version 2.00.00)
> powernow-k8: BIOS error - no PSB or ACPI _PSS objects
> ------------[ cut here ]------------
> kernel BUG at drivers/cpufreq/cpufreq.c:82!
> invalid opcode: 0000 [1] PREEMPT SMP
> CPU 0
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.21-rc5 #14
> RIP: 0010:[<ffffffff804a0edd>]  [<ffffffff804a0edd>]  
> lock_policy_rwsem_write+0x2b/0x7f
> RSP: 0000:ffff81003ff31de0  EFLAGS: 00010246
> RAX: 00000000ffffffff RBX: ffffffff80aa46a8 RCX: 0000000000000000
> RDX: ffffffff80741080 RSI: 0000000000000202 RDI: 0000000000000001
> RBP: ffff81003ff31e00 R08: ffff81003ff30000 R09: ffff810002dfdab0
> R10: ffff810002dfdab0 R11: ffff810002dfdab0 R12: 0000000000000001
> R13: ffffffff806cc2c0 R14: ffffffff80a37920 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffffffff80741000(0000) knlGS: 
> 0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000f06f53 CR3: 0000000000201000 CR4: 00000000000006e0
> Process swapper (pid: 1, threadinfo ffff81003ff30000, task  
> ffff81003ff2a790)
> Stack:  ffffffff806cc2c0 ffffffff80aa46a8 ffffffff80aa46a8  
> ffffffff806cc2c0
>  ffff81003ff31e20 ffffffff804a1538 ffff810002dfdab0 ffffffff806f6a40
>  ffff81003ff31e50 ffffffff803dffdf 00000000ffffffed 00000000ffffffed
> Call Trace:
>  [<ffffffff804a1538>] cpufreq_remove_dev+0x11/0x26
>  [<ffffffff803dffdf>] sysdev_driver_unregister+0x52/0x98
>  [<ffffffff804a0d3b>] cpufreq_register_driver+0x12d/0x191
>  [<ffffffff8021e082>] powernowk8_init+0x7f/0x88
>  [<ffffffff80a1099e>] init+0x1a8/0x2a9
>  [<ffffffff8023294e>] schedule_tail+0x36/0x9a
>  [<ffffffff8020ab98>] child_rip+0xa/0x12
>  [<ffffffff80a107f6>] init+0x0/0x2a9
>  [<ffffffff8020ab8e>] child_rip+0x0/0x12
>
>
> Code: 0f 0b eb fe 4c 63 e8 48 c7 c3 a0 c1 a6 80 4a 8b 04 ed c0 7a
> RIP  [<ffffffff804a0edd>] lock_policy_rwsem_write+0x2b/0x7f
>  RSP <ffff81003ff31de0>
> Kernel panic - not syncing: Attempted to kill init!
>

Looks like some error with cpufreq add_dev and remove_dev got exposed  
by the above patch.

The problem here is:

cpufreq_register_driver() calls sysdev_driver_register()
which in turn calls add() for the CPU already present and ignores the  
return value from that add().
(drivers/base/sys.c:183).
Not if that add had failed, cpufreq will not know and later a remove 
() is being called on the same device, which causes the BUG()  
condition here.

However, I am not sure at this point why this gets triggered only on  
numcpus=1 case and not on normal boot case.

Will dig into this a bit more and hopefully have a patch to fix this  
soon.

Thanks,
~Venki

