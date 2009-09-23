Return-Path: <linux-kernel-owner+w=401wt.eu-S1753106AbZIWTCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbZIWTCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 15:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbZIWTCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 15:02:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43897 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbZIWTCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 15:02:51 -0400
Date: Wed, 23 Sep 2009 21:02:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jason Wessel <jason.wessel@windriver.com>, Len Brown <lenb@kernel.org>
Cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [origin tree boot hang] [PATCH] Revert "early_printk: Allow
	morethan one early console"
Message-ID: <20090923190239.GC24251@elte.hu>
References: <20090923135539.GA6542@kroah.com> <20090923173709.GA18056@elte.hu> <4ABA6182.1000106@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ABA6182.1000106@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jason Wessel <jason.wessel@windriver.com> wrote:

> Ingo Molnar wrote:
> >>       early_printk: Allow more than one early console
> >>     
> >
> > this patch broke things pretty badly on x86, with pretty much any 
> > config, as long as the early console is used - which most of my 
> > test-systems do :-(
> >   
> 
> Ingo,
> 
> Can you send me the boot args and kernel config you are using?  I'd 
> like to figure out which part was at fault and fix it up.

will do. Will take some time though - trying to track down a new boot 
crash as well:

acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
initcall acpiphp_init+0x0/0x83 returned -19 after 16410 usecs
calling  ibm_acpiphp_init+0x0/0x190 @ 1
BUG: unable to handle kernel NULL pointer dereference at 0000000000000003
IP: [<ffffffff82b07130>] ibm_find_acpi_device+0x5c/0xf5
PGD 0 
Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
last sysfs file: 
CPU 0 
Pid: 1, comm: swapper Not tainted 2.6.31-tip #16786 System Product Name
RIP: 0010:[<ffffffff82b07130>]  [<ffffffff82b07130>] ibm_find_acpi_device+0x5c/0xf5
RSP: 0018:ffff88003f2d1d60  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88003f2d1d68 RSI: 00000000000001e4 RDI: 0000000000000000
RBP: ffff88003f2d1d90 R08: 0000000000000001 R09: ffffffff824b645b
R10: 000000002d0ef63b R11: ffff88003f2d1a80 R12: ffff88003fa780d0
R13: ffffffff83940dc8 R14: 0000000000000001 R15: ffffffff83942e10
FS:  0000000000000000(0000) GS:ffff880005800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000003 CR3: 0000000001001000 CR4: 00000000000006b0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff88003f2d0000, task ffff88003f2c8000)
Stack:
 ffff88003f2c8000 ffff88003cfbb690 000000002d0ef63b 0000000000000000
<0> 0000000000000000 ffff88003fa780d0 ffff88003f2d1e10 ffffffff8156b6b6
<0> 0000000000000001 0000000100000000 0000000000000000 ffffffff83940dc8
Call Trace:
 [<ffffffff8156b6b6>] acpi_ns_walk_namespace+0x11d/0x234
 [<ffffffff82b070d4>] ? ibm_find_acpi_device+0x0/0xf5
 [<ffffffff8157b159>] ? acpi_ut_acquire_mutex+0xd9/0x12e
 [<ffffffff82b070d4>] ? ibm_find_acpi_device+0x0/0xf5
 [<ffffffff81566dfa>] acpi_walk_namespace+0x105/0x162
 [<ffffffff81d067bf>] ? acpi_pm_read+0xd/0x3e
 [<ffffffff82b06f44>] ? ibm_acpiphp_init+0x0/0x190
 [<ffffffff82b06fa8>] ibm_acpiphp_init+0x64/0x190
 [<ffffffff810090b4>] do_one_initcall+0x82/0x1a6
 [<ffffffff810edecc>] ? init_irq_proc+0x77/0x9a
 [<ffffffff82ad8975>] do_basic_setup+0x5e/0x87
 [<ffffffff82ad8a26>] kernel_init+0x88/0xe2
 [<ffffffff8103ddfa>] child_rip+0xa/0x20
 [<ffffffff8103d7bc>] ? restore_args+0x0/0x30
 [<ffffffff82ad899e>] ? kernel_init+0x0/0xe2
 [<ffffffff8103ddf0>] ? child_rip+0x0/0x20
Code: 48 c7 c2 c0 7b 0b 82 48 c7 c6 95 39 4a 82 48 c7 c7 1a 3c 4a 82 31 c0 e8 02 84 4b ff 31 c0 e9 82 00 00 00 48 8b 45 d8 48 8b 40 30 <c6> 40 03 00 48 8b 45 d8 83 78 18 00 74 5f f6 40 0d 04 74 59 48 
RIP  [<ffffffff82b07130>] ibm_find_acpi_device+0x5c/0xf5
 RSP <ffff88003f2d1d60>
CR2: 0000000000000003
---[ end trace 5a5d197966b56a2e ]---
Kernel panic - not syncing: Fatal exception
Pid: 1, comm: swapper Tainted: G      D    2.6.31-tip #16786

/me looks in the general direction of Len ;-)

	Ingo
