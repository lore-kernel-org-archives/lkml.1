Return-Path: <linux-kernel-owner+w=401wt.eu-S1030501AbXDWRHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030501AbXDWRHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 13:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030370AbXDWRHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 13:07:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030501AbXDWRHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 13:07:43 -0400
Date: Mon, 23 Apr 2007 13:07:42 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: serial8250 lockdep report from 2.6.21-rc7
Message-ID: <20070423170742.GA9823@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

=================================
[ INFO: inconsistent lock state ]
2.6.20-1.3094.fc7 #1
---------------------------------
inconsistent {hardirq-on-W} -> {in-hardirq-W} usage.
swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
 (&port_lock_key){++..}, at: [<c0558f96>] serial8250_interrupt+0x4a/0xe0
{hardirq-on-W} state was registered at:
  [<c044021d>] __lock_acquire+0x448/0xba9
  [<c0440d70>] lock_acquire+0x56/0x6f
  [<c060ffd1>] _spin_lock+0x2b/0x38
  [<c055893b>] serial8250_backup_timeout+0x6d/0xe8
  [<c042c972>] run_timer_softirq+0x121/0x189
  [<c0429dfb>] __do_softirq+0x6f/0xe2
  [<c0407a64>] do_softirq+0x61/0xd0
  [<ffffffff>] 0xffffffff
irq event stamp: 332718
hardirqs last  enabled at (332717): [<c0403dde>] default_idle+0x3e/0x59
hardirqs last disabled at (332718): [<c0406054>] common_interrupt+0x24/0x40
softirqs last  enabled at (332708): [<c0429e68>] __do_softirq+0xdc/0xe2
softirqs last disabled at (332691): [<c0407a64>] do_softirq+0x61/0xd0

other info that might help us debug this:
1 lock held by swapper/0:
 #0:  (&irq_lists[i].lock){+...}, at: [<c0558f61>] serial8250_interrupt+0x15/0xe0

stack backtrace:
 [<c0406832>] show_trace_log_lvl+0x1a/0x2f
 [<c0406df1>] show_trace+0x12/0x14
 [<c0406e75>] dump_stack+0x16/0x18
 [<c043ed13>] print_usage_bug+0x141/0x14b
 [<c043f402>] mark_lock+0xa2/0x419
 [<c044018e>] __lock_acquire+0x3b9/0xba9
 [<c0440d70>] lock_acquire+0x56/0x6f
 [<c060ffd1>] _spin_lock+0x2b/0x38
 [<c0558f96>] serial8250_interrupt+0x4a/0xe0
 [<c045699a>] handle_IRQ_event+0x1a/0x46
 [<c0457a8a>] handle_fasteoi_irq+0x7d/0xb6
 [<c0407b84>] do_IRQ+0xb1/0xd9
