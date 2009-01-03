Return-Path: <linux-kernel-owner+w=401wt.eu-S1759712AbZACK64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759712AbZACK64 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 05:58:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbZACK6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 05:58:48 -0500
Received: from mail.gmx.net ([213.165.64.20]:39919 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752982AbZACK6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 05:58:46 -0500
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX19PjJlVqdNPIKaJ/YPz5cqABSC8yljUzxJRcjKr+E
	Pwo62uicIdw+FK
Date: Sat, 3 Jan 2009 11:58:41 +0100
From: Eric Sesterhenn <snakebyte@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: rml@tech9.net
Subject: Preemt warning during boot
Message-ID: <20090103105841.GA17078@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.28-rc9-00057-g8960223 (x86_64)
X-Uptime: 11:51:24 up  2:42,  9 users,  load average: 0.10, 0.10, 0.20
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

with todays -git I get the following oops on startup. I also saw this
with 2.6.28-04980-gb58602a.

[    0.000999] ODEBUG: selftest passed
[    0.001064] ------------[ cut here ]------------
[    0.001172] WARNING: at kernel/sched.c:4398
sub_preempt_count+0x89/0xe3()
[    0.001291] Hardware name: System Name
[    0.001392] Modules linked in:
[    0.001530] Pid: 0, comm: swapper Not tainted 2.6.28-05356-g6680598
#156
[    0.001648] Call Trace:
[    0.001752]  [<c01266da>] warn_slowpath+0x79/0x8f
[    0.001877]  [<c014348f>] ? check_usage_forwards+0x62/0x84
[    0.001993]  [<c0145944>] ? __lock_acquire+0x6cf/0x725
[    0.001999]  [<c0107200>] ? native_sched_clock+0x41/0x68
[    0.001999]  [<c01441cf>] ? trace_hardirqs_on+0xb/0xd
[    0.001999]  [<c07a0989>] ? _spin_unlock_irq+0x27/0x47
[    0.001999]  [<c0144170>] ? trace_hardirqs_on_caller+0x106/0x15a
[    0.001999]  [<c07a0994>] ? _spin_unlock_irq+0x32/0x47
[    0.001999]  [<c07a29f1>] sub_preempt_count+0x89/0xe3
[    0.001999]  [<c012a723>] _local_bh_enable+0x8f/0x91
[    0.001999]  [<c012aa32>] __do_softirq+0xee/0xf6
[    0.001999]  [<c012a944>] ? __do_softirq+0x0/0xf6
[    0.001999]  <IRQ>  [<c016028b>] ? handle_level_irq+0x0/0xc1
[    0.001999]  [<c012a8c1>] ? irq_exit+0x40/0x7c
[    0.001999]  [<c0104409>] ? do_IRQ+0xe1/0xf8
[    0.001999]  [<c01034ec>] ? common_interrupt+0x2c/0x34
[    0.001999]  [<c014007b>] ? tick_do_update_jiffies64+0x6c/0x11b
[    0.001999]  [<c07a0942>] ? _spin_unlock_irqrestore+0x3d/0x5d
[    0.001999]  [<c015f4b1>] ? __setup_irq+0x177/0x1f3
[    0.001999]  [<c015f54b>] ? setup_irq+0x1e/0x22
[    0.001999]  [<c0ab0a95>] ? time_init_hook+0x2b/0x2d
[    0.001999]  [<c0aa500e>] ? hpet_time_init+0x16/0x18
[    0.001999]  [<c0a9f980>] ? start_kernel+0x24c/0x2bc
[    0.001999]  [<c0a9f318>] ? i386_start_kernel+0x83/0x8b
[    0.001999] ---[ end trace 4eaa2a86a8e2da22 ]---

Greetings, Eric
