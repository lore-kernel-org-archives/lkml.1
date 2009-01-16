Return-Path: <linux-kernel-owner+w=401wt.eu-S935036AbZAPBJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935036AbZAPBJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 20:09:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756974AbZAPBIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 20:08:52 -0500
Received: from relay3.sgi.com ([192.48.171.31]:40472 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756976AbZAPBIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 20:08:50 -0500
Message-ID: <496FDE20.6070108@sgi.com>
Date: Thu, 15 Jan 2009 17:08:48 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Subject: new (common) WARNING message?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

I've been seeing these on and off for a while now.  They don't
seem to affect anything but perhaps I should track them down?

Do you know what it means?  (I'm asking you because evidently
debugobjects.c is from you?  I read the good explanation in the
changelog of 3ac7fe5a, but it didn't clue me into what's going
on. ;-)

Thanks,
Mike
--

[ 1294.973592] ODEBUG: object is on stack, but not annotated
[ 1294.974067] ------------[ cut here ]------------
[ 1294.974067] WARNING: at /mdata/lwork/polaris3/travis/workareas/ingo-latest/linux-2.6-for-ingo/lib/debugobjects.c:253 __debug_object_init+0x27c/0x2f0()
[ 1294.974067] Hardware name: X7DBT
[ 1294.974067] Pid: 4150, comm: offline-test Tainted: G        W  2.6.29-rc1-4k-defconfig.01151634-00255-gc99dbbe-dirty #89
[ 1294.974067] Call Trace:
[ 1294.974067]  [<ffffffff81047e3f>] warn_slowpath+0xd3/0xf2
[ 1294.974067]  [<ffffffff8106c64f>] ? trace_hardirqs_off+0xd/0xf
[ 1294.974067]  [<ffffffff815ca6ac>] ? _spin_unlock_irqrestore+0x3d/0x4c
[ 1294.974067]  [<ffffffff8125bebe>] ? __debug_check_no_obj_freed+0xf6/0x14c
[ 1294.974067]  [<ffffffff81048d3c>] ? printk+0x6c/0x6e
[ 1294.974067]  [<ffffffff8125c449>] ? __debug_object_init+0xf9/0x2f0
[ 1294.974067]  [<ffffffff8125b3ae>] ? _raw_spin_unlock+0xc7/0xf6
[ 1294.974067]  [<ffffffff8125c5cc>] __debug_object_init+0x27c/0x2f0
[ 1294.974067]  [<ffffffff8125c66d>] debug_object_init+0x14/0x17
[ 1294.974067]  [<ffffffff81052320>] init_timer+0x1d/0x2a
[ 1294.974067]  [<ffffffff81025077>] hpet_cpuhp_notify+0xad/0x124
[ 1294.974067]  [<ffffffff81025233>] ? hpet_work+0x0/0x21a
[ 1294.974067]  [<ffffffff81062057>] notifier_call_chain+0x33/0x5b
[ 1294.974067]  [<ffffffff810620ad>] __raw_notifier_call_chain+0xe/0x10
[ 1294.974067]  [<ffffffff810620c3>] raw_notifier_call_chain+0x14/0x16
[ 1294.974067]  [<ffffffff815c5190>] _cpu_up+0x115/0x155
[ 1294.974067]  [<ffffffff815c527c>] cpu_up+0x65/0x73
[ 1294.974067]  [<ffffffff815ac21d>] store_online+0x52/0x7b
[ 1294.974067]  [<ffffffff812ff775>] sysdev_store+0x20/0x22
[ 1294.974067]  [<ffffffff81134f6b>] sysfs_write_file+0xe9/0x11e
[ 1294.974067]  [<ffffffff810e0da5>] vfs_write+0xea/0x148
[ 1294.974067]  [<ffffffff810e0ec7>] sys_write+0x4c/0x72
[ 1294.974067]  [<ffffffff8100c6cb>] system_call_fastpath+0x16/0x1b
[ 1294.974067] ---[ end trace 4eaa2a86a8e2da24 ]---
