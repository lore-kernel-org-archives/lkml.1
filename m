Return-Path: <linux-kernel-owner+w=401wt.eu-S1758532AbZEYFd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532AbZEYFd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 01:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbZEYFdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 01:33:20 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:50733 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbZEYFdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 01:33:19 -0400
Message-Id: <200905250533.n4P5XGx6042820@www262.sakura.ne.jp>
Subject: [2.6.30-rcX] Some ftrace debug option is consuming memory?
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Mon, 25 May 2009 14:33:16 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 25052009 #2025366, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was running a VM with 1024MB of RAM.

I changed it to 512MB of RAM, and now I'm experiencing out of memory error.

[    2.815999] scsi: ***** BusLogic SCSI Driver Version 2.1.16 of 18 July 2002 *****
[    2.818347] scsi: Copyright 1995-1998 by Leonard N. Zubkoff <lnz@dandelion.com>
[    2.822849] Kernel panic - not syncing: Out of memory and no killable processes...
[    2.822857] 
[    2.824546] Pid: 1, comm: swapper Not tainted 2.6.30-rc7 #1
[    2.825677] Call Trace:
[    2.826424]  [<c015105d>] ? printk+0x1d/0x30
[    2.827136]  [<c014fd48>] panic+0x48/0x130
[    2.827832]  [<c01c5b29>] __out_of_memory+0x109/0x110
[    2.828665]  [<c01c5ca1>] out_of_memory+0xb1/0x100
[    2.829772]  [<c01c8df3>] __alloc_pages_internal+0x5b3/0x750
[    2.830686]  [<c01c902b>] __get_free_pages+0x9b/0xa0
[    2.831517]  [<c0200e49>] __kmalloc+0x79/0x360
[    2.832258]  [<c03feb19>] scsi_host_alloc+0x59/0x3d0
[    2.833066]  [<c0411122>] ? BusLogic_AnnounceDriver+0x42/0x50
[    2.834044]  [<c13d3b9b>] BusLogic_init+0x6bb/0xa50
[    2.834839]  [<c03c78c9>] ? driver_register+0xf9/0x160
[    2.835693]  [<c015105d>] ? printk+0x1d/0x30
[    2.836406]  [<c13cfe00>] ? ide_cdrom_init+0x0/0x20
[    2.837253]  [<c13d34e0>] ? BusLogic_init+0x0/0xa50
[    2.838050]  [<c0101058>] do_one_initcall+0x48/0x260
[    2.838862]  [<c05a39bc>] ? __schedule+0x62c/0xad0
[    2.839668]  [<c0188c36>] ? validate_chain+0x3f6/0x510
[    2.840501]  [<c018a92c>] ? __lock_acquire+0x29c/0x830
[    2.842191]  [<c01fcdf9>] ? check_bytes_and_report+0x29/0xe0
[    2.843135]  [<c01fcf53>] ? check_pad_bytes+0xa3/0xb0
[    2.843960]  [<c01fd252>] ? check_object+0x1a2/0x2d0
[    2.844780]  [<c034810b>] ? ida_get_new_above+0x23b/0x260
[    2.846429]  [<c018a92c>] ? __lock_acquire+0x29c/0x830
[    2.847291]  [<c010cd93>] ? sched_clock+0x23/0xc0
[    2.848057]  [<c0186753>] ? lock_release_holdtime+0x73/0xb0
[    2.848961]  [<c027b982>] ? proc_register+0xf2/0x210
[    2.850429]  [<c018b9d7>] ? __lock_release+0x47/0x70
[    2.851522]  [<c027b982>] ? proc_register+0xf2/0x210
[    2.852333]  [<c03659ad>] ? _raw_spin_unlock+0xcd/0x150
[    2.853149]  [<c05a8222>] ? _spin_unlock+0x22/0x30
[    2.854555]  [<c027b982>] ? proc_register+0xf2/0x210
[    2.855379]  [<c027beaa>] ? create_proc_entry+0xaa/0x130
[    2.856241]  [<c01a65e0>] ? register_irq_proc+0xd0/0x100
[    2.857113]  [<c139ce9a>] do_initcalls+0x2a/0x40
[    2.858413]  [<c139cf00>] ? kernel_init+0x0/0xc0
[    2.859183]  [<c139cecc>] do_basic_setup+0x1c/0x20
[    2.859962]  [<c139cf55>] kernel_init+0x55/0xc0
[    2.860702]  [<c0104707>] kernel_thread_helper+0x7/0x10

2.6.29.4 can boot with 512MB of RAM.
2.6.30-rc1 and later cannot boot with 512MB of RAM if some debug options are
enabled.

It seems to me that some debug option is consuming a lot of memory (enough to
trigger BusLogic driver's initialization failure).

Config which can boot with 512MB of RAM is at http://I-love.SAKURA.ne.jp/tmp/config-2.6.30-rc7-ok

Config which cannot boot with 512MB of RAM is at http://I-love.SAKURA.ne.jp/tmp/config-2.6.30-rc7-ng

$ diff config-2.6.30-rc7-ok config-2.6.30-rc7-ng
4c4
< # Mon May 25 12:33:54 2009
---
> # Mon May 25 13:28:39 2009
1519a1520,1521
> CONFIG_NOP_TRACER=y
> CONFIG_HAVE_FTRACE_NMI_ENTER=y
1525a1528,1531
> CONFIG_TRACER_MAX_TRACE=y
> CONFIG_RING_BUFFER=y
> CONFIG_FTRACE_NMI_ENTER=y
> CONFIG_TRACING=y
1531,1535c1537,1542
< # CONFIG_FUNCTION_TRACER is not set
< # CONFIG_IRQSOFF_TRACER is not set
< # CONFIG_SYSPROF_TRACER is not set
< # CONFIG_SCHED_TRACER is not set
< # CONFIG_CONTEXT_SWITCH_TRACER is not set
---
> CONFIG_FUNCTION_TRACER=y
> CONFIG_FUNCTION_GRAPH_TRACER=y
> CONFIG_IRQSOFF_TRACER=y
> CONFIG_SYSPROF_TRACER=y
> CONFIG_SCHED_TRACER=y
> CONFIG_CONTEXT_SWITCH_TRACER=y
1538,1541c1545,1551
< # CONFIG_BOOT_TRACER is not set
< # CONFIG_TRACE_BRANCH_PROFILING is not set
< # CONFIG_POWER_TRACER is not set
< # CONFIG_STACK_TRACER is not set
---
> CONFIG_BOOT_TRACER=y
> CONFIG_TRACE_BRANCH_PROFILING=y
> CONFIG_PROFILE_ALL_BRANCHES=y
> CONFIG_TRACING_BRANCHES=y
> CONFIG_BRANCH_TRACER=y
> CONFIG_POWER_TRACER=y
> CONFIG_STACK_TRACER=y
1544a1555,1557
> CONFIG_DYNAMIC_FTRACE=y
> CONFIG_FTRACE_MCOUNT_RECORD=y
> # CONFIG_FTRACE_STARTUP_TEST is not set
1695c1708
< # CONFIG_BINARY_PRINTF is not set
---
> CONFIG_BINARY_PRINTF=y

Regards.
