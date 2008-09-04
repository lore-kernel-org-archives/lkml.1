Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbYIDGB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbYIDGB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 02:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbYIDGBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 02:01:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751835AbYIDGBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 02:01:46 -0400
Date: Wed, 3 Sep 2008 23:01:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: linux-next: Tree for September 3
Message-Id: <20080903230129.806d54af.akpm@linux-foundation.org>
In-Reply-To: <20080904152015.3145b06e.sfr@canb.auug.org.au>
References: <20080903191619.6b6b230e.sfr@canb.auug.org.au>
	<20080903214634.ea17ff53.akpm@linux-foundation.org>
	<20080903215455.792c78a3.akpm@linux-foundation.org>
	<20080904145744.3f791ca7.sfr@canb.auug.org.au>
	<20080903220546.bd673658.akpm@linux-foundation.org>
	<20080904152015.3145b06e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008 15:20:15 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> On Wed, 3 Sep 2008 22:05:46 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > Thank gawd for that.
> > 
> > This breakage spans over 1000 commits.  Not sure how that can happen in
> > a rebased tree, but whatever.
> 
> It happens because I merge that tree into linux-next early in the
> sequence and the two builds I do after each merge did not get the error
> (*and* David really did not do enough testing ...). The set of builds I
> do after merging all the trees hit that so I added a commit to the end of
> linux-next to fix it.
> 
> That particular build bug will not be in today's linux-next because that
> particular tree has been fixed.
> 

After fix-odd iterations:

netconsole: remote IP 192.168.2.111
netconsole: remote ethernet address 00:19:d1:04:8f:42
netconsole: device eth0 not up yet, forcing it
e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
netconsole: carrier detect appears untrustworthy, waiting 4 seconds
Clocksource tsc unstable (delta = -499885471 ns)
console [netcon0] enabled
NETDEV WATCHDOG: eth0 (e100): transmit timed out
------------[ cut here ]------------
WARNING: at net/sched/sch_generic.c:221 dev_watchdog+0x11c/0x192()
Modules linked in:
Pid: 1, comm: swapper Tainted: G        W 2.6.27-rc5 #7
 [<c011e67e>] warn_on_slowpath+0x41/0x65
 [<c01387f9>] ? print_lock_contention_bug+0x11/0xb2
 [<c0119138>] ? __wake_up+0x31/0x3b
 [<c013805a>] ? trace_hardirqs_off+0xb/0xd
 [<c0326762>] ? _spin_unlock_irqrestore+0x54/0x58
 [<c0119138>] ? __wake_up+0x31/0x3b
 [<c012ba7a>] ? __queue_work+0x26/0x2b
 [<c013a9cd>] ? trace_hardirqs_on+0xb/0xd
 [<c0326762>] ? _spin_unlock_irqrestore+0x54/0x58
 [<c012ba7a>] ? __queue_work+0x26/0x2b
 [<c012bb92>] ? queue_work_on+0x27/0x31
 [<c012bc55>] ? queue_work+0x3f/0x45
 [<c012bc6a>] ? schedule_work+0xf/0x11
 [<c02660e0>] ? e100_tx_timeout+0xd/0xf
 [<c02d2ee2>] dev_watchdog+0x11c/0x192
 [<c01387f9>] ? print_lock_contention_bug+0x11/0xb2
 [<c0125920>] ? run_timer_softirq+0x102/0x16c
 [<c013a9cd>] ? trace_hardirqs_on+0xb/0xd
 [<c012592f>] run_timer_softirq+0x111/0x16c
 [<c02d2dc6>] ? dev_watchdog+0x0/0x192
 [<c02d2dc6>] ? dev_watchdog+0x0/0x192
 [<c012240a>] __do_softirq+0x51/0xa8
 [<c0122490>] do_softirq+0x2f/0x47
 [<c0122712>] irq_exit+0x3b/0x79
 [<c01115f2>] smp_apic_timer_interrupt+0x63/0x6e
 [<c01043dd>] apic_timer_interrupt+0x2d/0x34
 [<c011eb90>] ? release_console_sem+0x16e/0x1ab
 [<c011eb94>] ? release_console_sem+0x172/0x1ab
 [<c011f35b>] register_console+0x20e/0x216
 [<c0493587>] init_netconsole+0x12f/0x185
 [<c0101125>] _stext+0x3d/0x11d
 [<c0493458>] ? init_netconsole+0x0/0x185
 [<c01a98ca>] ? create_proc_entry+0x6c/0x80
 [<c0153692>] ? register_irq_proc+0x74/0x8d
 [<c047a6e2>] kernel_init+0x66/0xb4
 [<c047a67c>] ? kernel_init+0x0/0xb4
 [<c010456f>] kernel_thread_helper+0x7/0x10
 =======================
---[ end trace 4eaa2a86a8e2da22 ]---
netconsole: network logging started
initcall init_netconsole+0x0/0x185 returned 0 after 5916 msecs
calling  init_sd+0x0/0xdf

and it's dead.

This is extremely irritating.   I'll see if I cen reproduce the bug I'm
actually tring to find with E100=n.


