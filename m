Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbZAAUTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbZAAUTW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 15:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbZAAUTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 15:19:14 -0500
Received: from mail.gmx.net ([213.165.64.20]:43553 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751804AbZAAUTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 15:19:13 -0500
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX19/zFIftQR/HLtI1+lCyjSTJbuzZj7njjQGtEvwIo
	TAlWsHiKcWUt9S
Date: Thu, 1 Jan 2009 21:19:14 +0100
From: Eric Sesterhenn <snakebyte@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: dipankar@in.ibm.com
Subject: [BUG] Cpustall with kcore
Message-ID: <20090101201914.GB6698@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.28-rc9-00057-g8960223 (x86_64)
X-Uptime: 21:14:02 up 7 days,  9:20,  7 users,  load average: 0.08, 0.10,
	0.11
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

when i issue a "cat /proc/kcore > /dev/null", the kernel issues  the
following warning and i cant kill the cat process anymore.

[  356.948019] INFO: RCU detected CPU 0 stall (t=2500 jiffies)
[  356.948019] Pid: 4156, comm: cat Not tainted 2.6.28 #77
[  356.948019] Call Trace:
[  356.948019]  [<c05a99f6>] ? printk+0x18/0x1a
[  356.948019]  [<c016d682>] __rcu_pending+0x62/0x250
[  356.948019]  [<c014becb>] ? trace_hardirqs_off+0xb/0x10
[  356.948019]  [<c016d882>] rcu_pending+0x12/0x40
[  356.948019]  [<c0132c5a>] update_process_times+0x2a/0x60
[  356.948019]  [<c0149a65>] tick_sched_timer+0x55/0xc0
[  356.948019]  [<c0149a10>] ? tick_sched_timer+0x0/0xc0
[  356.948019]  [<c0140ab0>] __run_hrtimer+0x70/0xe0
[  356.948019]  [<c0149a10>] ? tick_sched_timer+0x0/0xc0
[  356.948019]  [<c014128d>] hrtimer_interrupt+0xed/0x190
[  356.948019]  [<c01059cb>] timer_interrupt+0x3b/0x50
[  356.948019]  [<c016a779>] handle_IRQ_event+0x29/0x60
[  356.948019]  [<c016c505>] handle_level_irq+0x65/0xe0
[  356.948019]  [<c016c4a0>] ? handle_level_irq+0x0/0xe0
[  356.948019]  <IRQ>  [<c014e321>] ?
trace_hardirqs_on_caller+0x151/0x1c0
[  356.948019]  [<c0103bac>] ? common_interrupt+0x2c/0x34
[  356.948019]  [<c018007b>] ? setup_per_zone_pages_min+0x11b/0x270
[  356.948019]  [<c029fdc2>] ? copy_to_user+0x112/0x120
[  356.948019]  [<c01ec705>] ? read_kcore+0x385/0x440
[  356.948019]  [<c01ec380>] ? read_kcore+0x0/0x440
[  356.948019]  [<c01e38dd>] ? proc_reg_read+0x5d/0x90
[  356.948019]  [<c01a6129>] ? vfs_read+0x99/0x160
[  356.948019]  [<c010357f>] ? sysenter_exit+0xf/0x16
[  356.948019]  [<c01e3880>] ? proc_reg_read+0x0/0x90
[  356.948019]  [<c01a62ad>] ? sys_read+0x3d/0x70
[  356.948019]  [<c0103551>] ? sysenter_do_call+0x12/0x31

RCU options are:
# CONFIG_CLASSIC_RCU is not set
# CONFIG_TREE_RCU is not set
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_TRACE=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_PREEMPT_RCU_TRACE=y
CONFIG_RCU_TORTURE_TEST=m

I tried this on another machine, which completely hangs after the cat,
i cant log in anymore via ssh. This one has

# CONFIG_CLASSIC_RCU is not set
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_TRACE=y
CONFIG_RCU_FANOUT=32
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_TREE_RCU_TRACE=y
# CONFIG_PREEMPT_RCU_TRACE is not set
CONFIG_RCU_TORTURE_TEST=m
CONFIG_RCU_CPU_STALL_DETECTOR=y

Greetings, Eric
