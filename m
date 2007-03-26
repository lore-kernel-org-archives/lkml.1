Return-Path: <linux-kernel-owner+w=401wt.eu-S1753690AbXCZTEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbXCZTEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 15:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbXCZTEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 15:04:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:23538 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753690AbXCZTEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 15:04:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,330,1170662400"; 
   d="scan'208"; a="216684190:sNHT977723145"
Date: Mon, 26 Mar 2007 12:03:19 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: 2.6.21-rc5: maxcpus=1 crash in cpufreq: kernel BUG at drivers/cpufreq/cpufreq.c:82!
Message-ID: <20070326190318.GA11068@linux-os.sc.intel.com>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070326090439.GA18484@elte.hu> <44408954-D81A-406B-B509-6390969F2F6A@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44408954-D81A-406B-B509-6390969F2F6A@intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 11:12:02AM -0700, Venki Pallipadi wrote:
> 
> >Calling initcall 0xffffffff8021e003: powernowk8_init+0x0/0x88()
> >powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 3800+  
> >processors (version 2.00.00)
> >powernow-k8: BIOS error - no PSB or ACPI _PSS objects
> >------------[ cut here ]------------
> >kernel BUG at drivers/cpufreq/cpufreq.c:82!
> >invalid opcode: 0000 [1] PREEMPT SMP
> >CPU 0
> >Modules linked in:
> >Pid: 1, comm: swapper Not tainted 2.6.21-rc5 #14
> >RIP: 0010:[<ffffffff804a0edd>]  [<ffffffff804a0edd>]  
> >lock_policy_rwsem_write+0x2b/0x7f
> >RSP: 0000:ffff81003ff31de0  EFLAGS: 00010246
> >RAX: 00000000ffffffff RBX: ffffffff80aa46a8 RCX: 0000000000000000
> >RDX: ffffffff80741080 RSI: 0000000000000202 RDI: 0000000000000001
> >RBP: ffff81003ff31e00 R08: ffff81003ff30000 R09: ffff810002dfdab0
> >R10: ffff810002dfdab0 R11: ffff810002dfdab0 R12: 0000000000000001
> >R13: ffffffff806cc2c0 R14: ffffffff80a37920 R15: 0000000000000000
> >FS:  0000000000000000(0000) GS:ffffffff80741000(0000) knlGS: 
> >0000000000000000
> >CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> >CR2: 0000000000f06f53 CR3: 0000000000201000 CR4: 00000000000006e0
> >Process swapper (pid: 1, threadinfo ffff81003ff30000, task  
> >ffff81003ff2a790)
> >Stack:  ffffffff806cc2c0 ffffffff80aa46a8 ffffffff80aa46a8  
> >ffffffff806cc2c0
> > ffff81003ff31e20 ffffffff804a1538 ffff810002dfdab0 ffffffff806f6a40
> > ffff81003ff31e50 ffffffff803dffdf 00000000ffffffed 00000000ffffffed
> >Call Trace:
> > [<ffffffff804a1538>] cpufreq_remove_dev+0x11/0x26
> > [<ffffffff803dffdf>] sysdev_driver_unregister+0x52/0x98
> > [<ffffffff804a0d3b>] cpufreq_register_driver+0x12d/0x191
> > [<ffffffff8021e082>] powernowk8_init+0x7f/0x88
> > [<ffffffff80a1099e>] init+0x1a8/0x2a9
> > [<ffffffff8023294e>] schedule_tail+0x36/0x9a
> > [<ffffffff8020ab98>] child_rip+0xa/0x12
> > [<ffffffff80a107f6>] init+0x0/0x2a9
> > [<ffffffff8020ab8e>] child_rip+0x0/0x12
> >
> >
> >Code: 0f 0b eb fe 4c 63 e8 48 c7 c3 a0 c1 a6 80 4a 8b 04 ed c0 7a
> >RIP  [<ffffffff804a0edd>] lock_policy_rwsem_write+0x2b/0x7f
> > RSP <ffff81003ff31de0>
> >Kernel panic - not syncing: Attempted to kill init!
> >
> 

Ingo,

Does the patch below help?

Thanks,
Venki


Patch to resolve maxcpus=1 trigerring BUG() as reported by Ingo here

lkml subject:
"2.6.21-rc5: maxcpus=1 crash in cpufreq: kernel BUG at drivers/cpufreq/cpufreq.c:82!"

This check added to remove_dev  is symmetric to one in add_dev and handles
callbacks for offline cpus cleanly.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: new/drivers/cpufreq/cpufreq.c
===================================================================
--- new.orig/drivers/cpufreq/cpufreq.c	2007-03-22 07:43:37.000000000 -0800
+++ new/drivers/cpufreq/cpufreq.c	2007-03-26 10:07:06.000000000 -0800
@@ -1015,6 +1015,10 @@
 {
 	unsigned int cpu = sys_dev->id;
 	int retval;
+
+	if (cpu_is_offline(cpu))
+		return 0;
+
 	if (unlikely(lock_policy_rwsem_write(cpu)))
 		BUG();
 
