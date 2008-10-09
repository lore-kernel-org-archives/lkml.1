Return-Path: <linux-kernel-owner+w=401wt.eu-S1757511AbYJIBPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbYJIBPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 21:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690AbYJIBO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 21:14:59 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37309 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754608AbYJIBO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 21:14:58 -0400
Date: Wed, 8 Oct 2008 18:14:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org
Subject: kernel BUG at kernel/sched_rt.c:322!
Message-ID: <20081009011456.GB10188@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I enable:

	CONFIG_GROUP_SCHED=y
	CONFIG_FAIR_GROUP_SCHED=y
	CONFIG_USER_SCHED=y

and run a bash script onlining and offlining CPUs in an infinite loop
on x86 using 2.6.27-rc9, after about 1.5 hours I get the following.

On the off-chance that this is new news...

							Thanx, Paul

	[ 5538.091011] kernel BUG at kernel/sched_rt.c:322!
	[ 5538.091011] invalid opcode: 0000 [#1] SMP 
	[ 5538.091011] Modules linked in:
	[ 5538.091011] 
	[ 5538.091011] Pid: 2819, comm: sh Not tainted (2.6.27-rc9-autokern1 #1)
	[ 5538.091011] EIP: 0060:[<c011c287>] EFLAGS: 00010002 CPU: 7
	[ 5538.091011] EIP is at __disable_runtime+0x1c7/0x1d0
	[ 5538.091011] EAX: c9056eec EBX: 00000001 ECX: 00000008 EDX: 00006060
	[ 5538.091011] ESI: 02faf080 EDI: 00000000 EBP: f6df7cd0 ESP: f6df7ca8
	[ 5538.091011]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
	[ 5538.091011] Process sh (pid: 2819, ti=f6df6000 task=f6cbdc00 task.ti=f6df6000)
	[ 5538.091011] Stack: f68c8004 c9056eec f68c8000 c9056b98 00000008 5d353631 c04d0020 c9056b00 
	[ 5538.091011]        c9056b00 c9056b00 f6df7cdc c011d151 c037dfc0 f6df7cec c011aedb f68c8000 
	[ 5538.091011]        c04d2200 f6df7d04 c011f967 00000282 00000000 00000000 00000000 f6df7e48 
	[ 5538.091011] Call Trace:
	[ 5538.091011]  [<c011d151>] ? rq_offline_rt+0x21/0x60
	[ 5538.091011]  [<c011aedb>] ? set_rq_offline+0x2b/0x50
	[ 5538.091011]  [<c011f967>] ? rq_attach_root+0xa7/0xb0
	[ 5538.091011]  [<c0120bbf>] ? cpu_attach_domain+0x30f/0x490
	[ 5538.091011]  [<c013dfc1>] ? sched_clock_cpu+0x121/0x170
	[ 5538.091011]  [<c011b56e>] ? update_curr+0x4e/0x80
	[ 5538.091011]  [<c013ca8f>] ? hrtimer_run_pending+0x1f/0x90
	[ 5538.091011]  [<c013c350>] ? enqueue_hrtimer+0x60/0x80
	[ 5538.091011]  [<c011bc47>] ? __enqueue_entity+0xc7/0x100
	[ 5538.091011]  [<c01223de>] ? partition_sched_domains+0x1ae/0x220
	[ 5538.091011]  [<c012008f>] ? wake_up_process+0xf/0x20
	[ 5538.091011]  [<c0122476>] ? update_sched_domains+0x26/0x40
	[ 5538.091011]  [<c0374907>] ? notifier_call_chain+0x37/0x80
	[ 5538.091011]  [<c013d379>] ? __raw_notifier_call_chain+0x19/0x20
	[ 5538.091011]  [<c013d39a>] ? raw_notifier_call_chain+0x1a/0x20
	[ 5538.091011]  [<c036e9cf>] ? _cpu_up+0xaf/0x100
	[ 5538.091011]  [<c037125e>] ? mutex_lock+0xe/0x20
	[ 5538.091011]  [<c036ea69>] ? cpu_up+0x49/0x70
	[ 5538.091011]  [<c03619d8>] ? store_online+0x58/0x80
	[ 5538.091011]  [<c0361980>] ? store_online+0x0/0x80
	[ 5538.091011]  [<c0266f1c>] ? sysdev_store+0x2c/0x40
	[ 5538.091011]  [<c01b728d>] ? sysfs_write_file+0x9d/0x100
	[ 5538.091011]  [<c0175129>] ? vfs_write+0x99/0x130
	[ 5538.091011]  [<c01b71f0>] ? sysfs_write_file+0x0/0x100
	[ 5538.091011]  [<c017566d>] ? sys_write+0x3d/0x70
	[ 5538.091011]  [<c010318e>] ? syscall_call+0x7/0xb
	[ 5538.091011]  [<c0370000>] ? acpi_processor_start+0x630/0x63f
	[ 5538.091011]  =======================
	[ 5538.091011] Code: 87 72 ff ff ff 29 b3 4c 03 00 00 19 bb 50 03 00 00 31 f6 31 ff eb 9a 09 fe 0f 95 c0 0f b6 d8 8b 45 dc e8 6d 5f 25 00 85 db 74 a4 <0f> 0b eb fe 90 8d 74 26 00 55 89 d0 89 e5 83 ec 08 83 fa 16 89 
	[ 5538.091011] EIP: [<c011c287>] __disable_runtime+0x1c7/0x1d0 SS:ESP 0068:f6df7ca8
	[ 5538.091011] ---[ end trace 5b3bf11f31634d39 ]---
