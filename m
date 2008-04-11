Return-Path: <linux-kernel-owner+w=401wt.eu-S1761406AbYDKR4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761406AbYDKR4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 13:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760467AbYDKR40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 13:56:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:11934 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760304AbYDKR4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 13:56:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,642,1199692800"; 
   d="scan'208";a="268552871"
Date: Fri, 11 Apr 2008 10:56:24 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andy Whitcroft <apw@shadowen.org>, akpm@linux-foundation.org
Subject: Re: [BUG] linux-next:  April 10 -  kernel oops at kmem_cache_alloc () regression from April 9 kernel
Message-ID: <20080411175623.GC6542@linux-os.sc.intel.com>
References: <20080410181404.b76939a6.sfr@canb.auug.org.au> <47FE5765.2030401@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FE5765.2030401@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 11:37:33PM +0530, Kamalesh Babulal wrote:
> Hi Stephen,
> 
> When booting the x86_64 boxes with the next-20080409 and 20080410 kernels
> the kernel bug is hit. The same bug was reported for the April 9  kernel
> at http://lkml.org/lkml/2008/4/10/63 (this kernel was compiled with 
> CONFIG_CC_STACKPROTECTOR is not set)
> 
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> IP: [<ffffffff802869b1>] kmem_cache_alloc+0x41/0x130
> PGD 32dc2e067 PUD 32dd6a067 PMD 0 
> Oops: 0000 [1] SMP 
> last sysfs file: /sys/kernel/uevent_seqnum
> CPU 0 
> Modules linked in: sg
> Pid: 1, comm: init Not tainted 2.6.25-rc8-next-20080410-autotest #1
> RIP: 0010:[<ffffffff802869b1>]  [<ffffffff802869b1>] kmem_cache_alloc+0x41/0x130
> RSP: 0000:ffff810bfe4abef8  EFLAGS: 00010046
> RAX: 0000000000000000 RBX: ffff81090e4aa050 RCX: 0000000000405017
> RDX: 00007ffffb4c05b8 RSI: 00000000000000d0 RDI: 0000000000000000
> RBP: 0000000000000292 R08: 0000000000586f00 R09: 0000000000586f20
> R10: 0000000000586f08 R11: 0000000000000246 R12: 00000000000000d0
> R13: 0000000000000000 R14: 0000000000405150 R15: 0000000000000000
> FS:  000000000058b850(0063) GS:ffffffff8067f000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 000000090d0e6000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process init (pid: 1, threadinfo ffff810bfe4aa000, task ffff81090e4aa050)
> Stack:  0000000000000000 ffff81090e4aa050 ffff81090e4aa050 0000000000000001
>  0000000000405110 ffffffff80212f96 0000000000000292 ffff81090e4aa050
>  00007ffffb4c05a8 ffffffff8020cb79 0000000000000000 ffffffff804da339
> Call Trace:
>  [<ffffffff80212f96>] init_fpu+0x96/0xf0
>  [<ffffffff8020cb79>] math_state_restore+0x19/0x60
>  [<ffffffff804da339>] error_exit+0x0/0x51

I noticed in another thread, that you are using gcc 4.1.1. I think
both 4.1.0 and 4.1.1 has some issues with weak symbols. Can you please
try gcc 4.1.2 and see if that fixes your issue.

When I go back to 4.1.0, I am bitten by smilar oops. But not with 4.1.2.

thanks,
suresh
