Return-Path: <linux-kernel-owner+w=401wt.eu-S1755086AbYH0Vav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbYH0Vav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 17:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750784AbYH0Vaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 17:30:39 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:31391 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbYH0Vai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 17:30:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oMt5q3C3ibk7veeytBWZrivQ5raswEwETvDW+Vd9oCrqTmvBDfwwo5/aX2UD4CUQ41
         vgy+I1Sf6E01Jp5hfxYpTcV0eTXFuOJp2s41gYGx6DzaoknqTXTEwM+kLyUc3OvhXMB7
         Wvsr+k51Cpah92VwdjNA5cJnEPHnT8l3QzkM8=
Date: Thu, 28 Aug 2008 01:32:11 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] utrace core
Message-ID: <20080827213211.GA31861@x200.localdomain>
References: <20080826220102.89635154233@magilla.localdomain> <20080826220157.397C7154233@magilla.localdomain> <20080826225519.GC27724@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080826225519.GC27724@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And run to confirm that attach/detach/exec program still crashes it.
> There is PREEMPT_RCU now so it will be even more not funny.

As promised, quickly reproducible via expt_ptratt.c:

kernel/utrace.c:532	if (likely(!utrace->stopped))

BUG: unable to handle kernel paging request at ffff88017c51c958
IP: [<ffffffff8025e38b>] utrace_stop+0x9b/0x120
PGD 202063 PUD b067 PMD 17d8e5163 PTE 800000017c51c160
Oops: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
last sysfs file: /sys/kernel/uevent_seqnum
CPU 0 
Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 sr_mod cdrom
Pid: 32731, comm: exe Tainted: G        W 2.6.27-rc4-next-20080827-utrace #4
RIP: 0010:[<ffffffff8025e38b>]  [<ffffffff8025e38b>] utrace_stop+0x9b/0x120
RSP: 0000:ffff88017c521c38  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88017c02b880 RCX: 0000000000000000
RDX: 000000000000ebea RSI: 00000000ffffffff RDI: 0000000000000001
RBP: ffff88017c521c58 R08: 0000000000000002 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000001 R12: ffff88017c51c8e8
R13: ffff88017c51c918 R14: ffff88017c51c8e8 R15: ffff88017c02b880
FS:  00007fe23dcf66f0(0000) GS:ffffffff8054b600(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffff88017c51c958 CR3: 000000017c077000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process exe (pid: 32731, threadinfo ffff88017c520000, task ffff88017c02b880)
Stack:  ffff88017c51c8e8 ffff88017c521ce8 ffff88017c51c8e8 ffff88017c02b880
 ffff88017c521c88 ffffffff8025e4b0 ffff88017f92e360 ffff88017c51c8f8
 ffff88017f92e360 ffff88017c51c8f0 ffff88017c521d38 ffffffff8025fb05
Call Trace:
 [<ffffffff8025e4b0>] finish_resume_report+0xa0/0xd0
 [<ffffffff8025fb05>] utrace_get_signal+0x305/0x710
 [<ffffffff802408cc>] get_signal_to_deliver+0x24c/0x310
 [<ffffffff8020ab54>] do_notify_resume+0xd4/0x860
 [<ffffffff80253fcd>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff8042d812>] ? _spin_unlock_irqrestore+0x42/0x80
 [<ffffffff8024b43a>] ? hrtimer_start+0x11a/0x1f0
 [<ffffffff8025652d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff8042d886>] ? _spin_unlock_irq+0x36/0x60
 [<ffffffff8022d728>] ? finish_task_switch+0x68/0xe0
 [<ffffffff8022d6c0>] ? finish_task_switch+0x0/0xe0
 [<ffffffff8042a6fc>] ? thread_return+0xa4/0x548
 [<ffffffff8020b7d5>] ? sysret_signal+0x19/0x29
 [<ffffffff8020bab7>] ptregscall_common+0x67/0xb0
Code: 42 78 48 8b bb 60 04 00 00 48 81 c7 08 08 00 00 e8 db f4 1c 00 4c 89 ef e8 33 f3 1c 00 66 83 7b 1a 05 74 1a e8 97 c0 1c 00 31 c0 <41> f6 44 24 70 01 75 32 48 83 c4 08 5b 41 5c 41 5d c9 c3 48 c7 
RIP  [<ffffffff8025e38b>] utrace_stop+0x9b/0x120
 RSP <ffff88017c521c38>
CR2: ffff88017c51c958
---[ end trace 4eaa2a86a8e2da22 ]---

