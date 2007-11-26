Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbXKZTk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbXKZTk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 14:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbXKZTku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 14:40:50 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493AbXKZTkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 14:40:49 -0500
Date: Mon, 26 Nov 2007 14:39:43 -0500
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-acpi@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc3-mm1 - Kernel Panic on IO-APIC
Message-ID: <20071126143943.0a01665b@cuia.boston.redhat.com>
In-Reply-To: <20071120221839.faab108e.akpm@linux-foundation.org>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	<4743CC0B.9000508@linux.vnet.ibm.com>
	<20071120221839.faab108e.akpm@linux-foundation.org>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007 22:18:39 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> > ..MP-BIOS bug: 8254 timer not connected to IO-APIC
> > Kernel panic - not syncing: IO-APIC + timer doesn't work! Try using the 'noapic' kernel parameter
> 
> ACPI or x86 breakage, I guess.
> 
> Did 'noapic' work?

I got the same bug as above, 'noapic' gets past that point and right to the
next oops.  I'm posting it here because this one is different from the others
in the thread, yet looks vaguely related:

Unable to handle kernel NULL pointer dereference at 0000000000000021 RIP:
 [<ffffffff8108382a>] refresh_zone_stat_thresholds+0x6d/0x90
PGD 0
Oops: 0002 [1] SMP
last sysfs file:
CPU 0
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.24-rc3-mm1 #2
RIP: 0010:[<ffffffff8108382a>]  [<ffffffff8108382a>] refresh_zone_stat_thresholds+0x6d/0x90
RSP: 0000:ffff81007fb59ec0  EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000000001
RDX: 0000000000000001 RSI: ffffffff8146fb38 RDI: 0000000000000001
RBP: ffff81000000c000 R08: 0000000000000000 R09: 0000000000000000
R10: ffff81007fb59e60 R11: 0000000000000028 R12: ffffffff814d4558
R13: 0000000000000000 R14: ffffffff814b62c0 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff813d9000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000021 CR3: 0000000000201000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo FFFF81007FB58000, task FFFF81007FB56000)
Stack:  0000000000000000 0000000000000000 0000000000000000 ffffffff814a3839
 0000000000000000 ffffffff8148e626 ffff81007fb56000 ffffffff8126d36a
 0000000000000000 ffffffffffffffff ffffffff8105786b 0000000000000000
Call Trace:
 [<ffffffff814a3839>] setup_vmstat+0x6/0x40
 [<ffffffff8148e626>] kernel_init+0x169/0x2d8
 [<ffffffff8126d36a>] trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff8105786b>] trace_hardirqs_on+0x115/0x138
 [<ffffffff8100ce48>] child_rip+0xa/0x12
 [<ffffffff8100c55f>] restore_args+0x0/0x30
 [<ffffffff8148e4bd>] kernel_init+0x0/0x2d8
 [<ffffffff8100ce3e>] child_rip+0x0/0x12

INFO: lockdep is turned off.

-- 
All Rights Reversed
