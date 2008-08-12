Return-Path: <linux-kernel-owner+w=401wt.eu-S1752693AbYHLCXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbYHLCXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 22:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbYHLCXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 22:23:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62935 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbYHLCXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 22:23:09 -0400
Date: Mon, 11 Aug 2008 22:23:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       x86@kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Subject: Re: Only three cores found on quad-core machine.
Message-ID: <20080812022306.GA31444@goodmis.org>
References: <20080801181532.GC6304@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801181532.GC6304@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 02:15:32PM -0400, Dave Jones wrote:
> I just installed .27rc1 on a fairly recent quad-core machine.
> The first thing that seemed out of the ordinary was only 3 penguins
> showing up in the framebuffer.  Closer examination after it had
> booted revealed the backtrace-o-rama that is below.
> 
> 	Dave
> 

[...]

> khelper used greatest stack depth: 5728 bytes left
> net_namespace: 1680 bytes
> Booting paravirtualized kernel on bare hardware
> Time: 13:32:13  Date: 07/31/08
> NET: Registered protocol family 16
> No dock devices found.
> ACPI: bus type pci registered
> PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 127
> PCI: Not using MMCONFIG.
> PCI: Using configuration type 1 for base access
> khelper used greatest stack depth: 5016 bytes left
> general protection fault: 0000 [1] SMP DEBUG_PAGEALLOC
> CPU 2 
> Modules linked in:
> Pid: 0, comm: swapper Not tainted 2.6.27-0.205.rc1.git2.fc10.x86_64 #1
> RIP: 0010:[<ffffffff81094d61>]  [<ffffffff81094d61>] ftrace_record_ip+0x214/0x22b

Dave,

Would it be possible to pull this kernel into gdb and show me the output
of:

gdb> li *0xffffffff81094d61

and a

gdb> disass 0xffffffff81094d61


Thanks,

-- Steve

> RSP: 0018:ffff88007f04fe08  EFLAGS: 00010292
> RAX: ffffffff816b26c0 RBX: 000000000000010d RCX: 000000000000020f
> RDX: ffff880001027f80 RSI: 0000000000000000 RDI: 0000000000000292
> RBP: ffff88007f04fe38 R08: 0000000000000075 R09: ffff88007fbd2090
> R10: 0000000000000046 R11: ffffffff81b68de8 R12: 00000040812fba2b
> R13: 000a81a000000002 R14: ffffffff81b68de8 R15: 0000000000000292
> FS:  0000000000000000(0000) GS:ffff88007f821898(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006a0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 0, threadinfo ffff88007f04e000, task ffff88007f050000)
> Stack:  ffff88007f04fe78 0000002649d25248 00000040fffb6cbf 000a81a000000002
>  000000000051621c 0000000000000002 ffff88007f04fe98 ffffffff81010164
>  00000000fffb8093 0000000049d25248 ffff88007f050000 000000231a06706a
> Call Trace:
>  [<ffffffff81010164>] mcount_call+0x5/0x31
>  [<ffffffff812fba30>] ? read_current_timer+0xe/0x30
>  [<ffffffff8130150b>] calibrate_delay+0xe2/0x2a7
>  [<ffffffff8130615b>] start_secondary+0xc0/0x16e
> 
> 
