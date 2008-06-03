Return-Path: <linux-kernel-owner+w=401wt.eu-S1758834AbYFCWGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834AbYFCWGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 18:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753146AbYFCWGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 18:06:25 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:52351 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbYFCWGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 18:06:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=JV+bz8eZyymedfdAl/5z+u14PYb19tocnIRNPO6dcQxuE+VzO1mlnZRbmkYWCghmXM+hccfwIvdx5ZLrQSeNg92bVpn4ME5ax/+ARAkQNyZvDdgMnfwNMr0tbupEOUGggwBQ+PnogIh8nppzXWQXO3RBdfnYNWFXPOxpYG4ddJU=
Message-ID: <dd18b0c30806031506j5ab67014vf1a9f47fb91aa266@mail.gmail.com>
Date: Tue, 3 Jun 2008 22:06:20 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: kgdbts: BP mismatch c010852a expected c02753e0
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello; I decided to turn kgdb on just for the heck of it, I noticed
this once I rebooted:
[    1.691997] kgdb: Registered I/O driver kgdbts.
[    1.692485] kgdbts:RUN plant and detach test
[    1.709377] kgdbts:RUN sw breakpoint test
[    1.709377] kgdbts:RUN bad memory access test
[    1.709377] kgdbts:RUN singlestep test 1000 iterations
[    1.712049] kgdbts:RUN singlestep [0/1000]
[    1.721988] kgdbts:RUN singlestep [100/1000]
[    1.739330] kgdbts:RUN singlestep [200/1000]
[    1.748869] kgdbts: BP mismatch c010852a expected c02753e0
[    1.749213] ------------[ cut here ]------------
[    1.749213] WARNING: at drivers/misc/kgdbts.c:302
check_and_rewind_pc+0x9a/0xb4()
[    1.749213] Modules linked in:
[    1.749213] Pid: 0, comm: swapper Not tainted 2.6.26-rc4-00168-gc3b25b3 #1
[    1.749213]  [<c01227ae>] warn_on_slowpath+0x41/0x6c
[    1.749213]  [<c0122c95>] ? release_console_sem+0x188/0x190
[    1.749213]  [<c0136703>] ? sched_clock_cpu+0x10e/0x11c
[    1.749213]  [<c02753e0>] ? kgdbts_break_test+0x0/0x1e
[    1.749214]  [<c0123159>] ? printk+0x15/0x17
[    1.749214]  [<c02753e0>] ? kgdbts_break_test+0x0/0x1e
[    1.749214]  [<c0275edb>] check_and_rewind_pc+0x9a/0xb4
[    1.749214]  [<c010852a>] ? mwait_idle+0x32/0x40
[    1.749214]  [<c02753e0>] ? kgdbts_break_test+0x0/0x1e
[    1.749214]  [<c02750e2>] validate_simple_test+0x22/0x69
[    1.749214]  [<c0275753>] run_simple_test+0x1a1/0x20e
[    1.749214]  [<c027517d>] kgdbts_put_char+0x14/0x16
[    1.749214]  [<c014e6f2>] put_packet+0x6b/0xbb
[    1.749214]  [<c014f9e1>] kgdb_handle_exception+0xb11/0xbe0
[    1.749214]  [<c01127ae>] kgdb_notify+0x134/0x15d
[    1.749214]  [<c037fe9f>] notifier_call_chain+0x2b/0x4a
[    1.749214]  [<c037fecf>] __atomic_notifier_call_chain+0x11/0x13
[    1.749214]  [<c037fedd>] atomic_notifier_call_chain+0xc/0xe
[    1.749214]  [<c0135d76>] notify_die+0x2d/0x2f
[    1.749214]  [<c037e8bd>] die_nmi+0x1b/0xb7
[    1.749214]  [<c037eea5>] nmi_watchdog_tick+0xb3/0x108
[    1.749214]  [<c037eb28>] do_nmi+0x84/0x22d
[    1.749214]  [<c01084f8>] ? mwait_idle+0x0/0x40
[    1.749214]  [<c037e463>] nmi_stack_correct+0x26/0x2b
[    1.749214]  [<c01084f8>] ? mwait_idle+0x0/0x40
[    1.749214]  [<c010852a>] ? mwait_idle+0x32/0x40
[    1.749214]  [<c0102507>] cpu_idle+0xae/0xce
[    1.749214]  [<c037a74a>] start_secondary+0x15d/0x162
[    1.749214]  =======================
[    1.749214] ---[ end trace 4cb23d4b8b3c3614 ]---
[    1.749214] kgdbts: ERROR PUT: end of test buffer on
'singlestep_breakpoint_test' line 3 expected kgdbts_break_test got
$000000000000000000000000f88410c0a8ffc6f794ffc6f70100000080b051c0
[    1.749214] ------------[ cut here ]------------
[    1.749214] WARNING: at drivers/misc/kgdbts.c:721
run_simple_test+0x1de/0x20e()
[    1.749214] Modules linked in:
[    1.749214] Pid: 0, comm: swapper Tainted: G        W
2.6.26-rc4-00168-gc3b25b3 #1
[    1.749214]  [<c01227ae>] warn_on_slowpath+0x41/0x6c
[    1.749214]  [<c0122c95>] ? release_console_sem+0x188/0x190
[    1.749214]  [<c0136703>] ? sched_clock_cpu+0x10e/0x11c
[    1.749214]  [<c02753e0>] ? kgdbts_break_test+0x0/0x1e
[    1.749214]  [<c0123159>] ? printk+0x15/0x17
[    1.749214]  [<c0123159>] ? printk+0x15/0x17
[    1.749214]  [<c0275790>] run_simple_test+0x1de/0x20e
[    1.749214]  [<c027517d>] kgdbts_put_char+0x14/0x16
[    1.749214]  [<c014e6f2>] put_packet+0x6b/0xbb
[    1.749214]  [<c014f9e1>] kgdb_handle_exception+0xb11/0xbe0
[    1.749214]  [<c01127ae>] kgdb_notify+0x134/0x15d
[    1.749214]  [<c037fe9f>] notifier_call_chain+0x2b/0x4a
[    1.749214]  [<c037fecf>] __atomic_notifier_call_chain+0x11/0x13
[    1.749214]  [<c037fedd>] atomic_notifier_call_chain+0xc/0xe
[    1.749214]  [<c0135d76>] notify_die+0x2d/0x2f
[    1.749214]  [<c037e8bd>] die_nmi+0x1b/0xb7
[    1.749214]  [<c037eea5>] nmi_watchdog_tick+0xb3/0x108
[    1.749214]  [<c037eb28>] do_nmi+0x84/0x22d
[    1.749214]  [<c01084f8>] ? mwait_idle+0x0/0x40
[    1.749214]  [<c037e463>] nmi_stack_correct+0x26/0x2b
[    1.749214]  [<c01084f8>] ? mwait_idle+0x0/0x40
[    1.749214]  [<c010852a>] ? mwait_idle+0x32/0x40
[    1.749214]  [<c0102507>] cpu_idle+0xae/0xce
[    1.749214]  [<c037a74a>] start_secondary+0x15d/0x162
[    1.749214]  =======================
[    1.749214] ---[ end trace 4cb23d4b8b3c3614 ]---
[    1.985151] kgdbts: ERROR PUT: end of test buffer on
'singlestep_breakpoint_test' line 0 expected S0* got
$T05thread:0000000000000001;#a7
[    1.987857] ------------[ cut here ]------------
[    1.987857] WARNING: at drivers/misc/kgdbts.c:721
run_simple_test+0x1de/0x20e()
[    1.987857] Modules linked in:
[    1.987857] Pid: 1, comm: swapper Tainted: G        W
2.6.26-rc4-00168-gc3b25b3 #1
[    1.987857]  [<c01227ae>] warn_on_slowpath+0x41/0x6c
[    1.987857]  [<c0122c95>] ? release_console_sem+0x188/0x190
[    1.987857]  [<c0136703>] ? sched_clock_cpu+0x10e/0x11c
[    1.987857]  [<c0123159>] ? printk+0x15/0x17
[    1.987857]  [<c0275790>] run_simple_test+0x1de/0x20e
[    1.987857]  [<c027517d>] kgdbts_put_char+0x14/0x16
[    1.987857]  [<c014e6f2>] put_packet+0x6b/0xbb
[    1.987857]  [<c014f1b7>] kgdb_handle_exception+0x2e7/0xbe0
[    1.987857]  [<c01127ae>] kgdb_notify+0x134/0x15d
[    1.987857]  [<c037fe9f>] notifier_call_chain+0x2b/0x4a
[    1.987857]  [<c037fecf>] __atomic_notifier_call_chain+0x11/0x13
[    1.987857]  [<c037fedd>] atomic_notifier_call_chain+0xc/0xe
[    1.987857]  [<c0135d76>] notify_die+0x2d/0x2f
[    1.987857]  [<c037ea66>] do_int3+0x29/0x67
[    1.987857]  [<c037e553>] int3+0x27/0x2c
[    1.987857]  [<c014007b>] ? sys_init_module+0x409/0x17ea
[    1.987857]  [<c014e8a3>] ? kgdb_breakpoint+0x13/0x24
[    1.987857]  [<c0275b37>] configure_kgdbts+0x1ba/0x3fa
[    1.987857]  [<c04e0c57>] init_kgdbts+0x13/0x15
[    1.987857]  [<c04c9470>] kernel_init+0x127/0x263
[    1.987857]  [<c04e0c44>] ? init_kgdbts+0x0/0x15
[    1.987857]  [<c011d400>] ? sched_setaffinity+0xca/0xe3
[    1.987857]  [<c011e5bc>] ? schedule_tail+0x18/0x46
[    1.987857]  [<c01037a6>] ? ret_from_fork+0x6/0x1c
[    1.987857]  [<c04c9349>] ? kernel_init+0x0/0x263
[    1.987857]  [<c04c9349>] ? kernel_init+0x0/0x263
[    1.987857]  [<c01044ef>] kernel_thread_helper+0x7/0x10
[    1.987857]  =======================
[    1.987857] ---[ end trace 4cb23d4b8b3c3614 ]---
[    2.125614] kgdbts: BP mismatch c0108536 expected c02753e0
[    2.129360] ------------[ cut here ]------------
[    2.133108] WARNING: at drivers/misc/kgdbts.c:302
check_and_rewind_pc+0x9a/0xb4()
[    2.134178] Modules linked in:
[    2.134178] Pid: 0, comm: swapper Tainted: G        W
2.6.26-rc4-00168-gc3b25b3 #1
[    2.134178]  [<c01227ae>] warn_on_slowpath+0x41/0x6c
[    2.134178]  [<c0122c95>] ? release_console_sem+0x188/0x190
[    2.134178]  [<c0136703>] ? sched_clock_cpu+0x10e/0x11c
[    2.134179]  [<c02753e0>] ? kgdbts_break_test+0x0/0x1e
[    2.134179]  [<c0123159>] ? printk+0x15/0x17
[    2.134179]  [<c02753e0>] ? kgdbts_break_test+0x0/0x1e
[    2.134179]  [<c0275edb>] check_and_rewind_pc+0x9a/0xb4
[    2.134179]  [<c0108536>] ? mwait_idle+0x3e/0x40
[    2.134179]  [<c02753e0>] ? kgdbts_break_test+0x0/0x1e
[    2.134179]  [<c02750e2>] validate_simple_test+0x22/0x69
[    2.134179]  [<c0275753>] run_simple_test+0x1a1/0x20e
[    2.134179]  [<c027517d>] kgdbts_put_char+0x14/0x16
[    2.134179]  [<c014e6f2>] put_packet+0x6b/0xbb
[    2.134179]  [<c014f9e1>] kgdb_handle_exception+0xb11/0xbe0
[    2.134179]  [<c011bda3>] ? rebalance_domains+0x10b/0x361
[    2.134179]  [<c01127ae>] kgdb_notify+0x134/0x15d
[    2.134179]  [<c037fe9f>] notifier_call_chain+0x2b/0x4a
[    2.134179]  [<c037fecf>] __atomic_notifier_call_chain+0x11/0x13
[    2.134179]  [<c037fedd>] atomic_notifier_call_chain+0xc/0xe
[    2.134179]  [<c0135d76>] notify_die+0x2d/0x2f
[    2.134179]  [<c037e9af>] do_debug+0x56/0xe4
[    2.134179]  [<c01084f8>] ? mwait_idle+0x0/0x40
[    2.134179]  [<c037e407>] debug_stack_correct+0x27/0x2c
[    2.134179]  [<c01084f8>] ? mwait_idle+0x0/0x40
[    2.134179]  [<c0108536>] ? mwait_idle+0x3e/0x40
[    2.134179]  [<c0102507>] cpu_idle+0xae/0xce
[    2.134179]  [<c037a74a>] start_secondary+0x15d/0x162
[    2.134179]  =======================
[    2.134179] ---[ end trace 4cb23d4b8b3c3614 ]---
[    2.134179] kgdbts: ERROR PUT: end of test buffer on
'singlestep_breakpoint_test' line 3 expected kgdbts_break_test got
$000000000000000000000000f88410c0a8ffc6f794ffc6f70100000080b051c0
[    2.134179] ------------[ cut here ]------------
[    2.134179] WARNING: at drivers/misc/kgdbts.c:721
run_simple_test+0x1de/0x20e()
[    2.134179] Modules linked in:
[    2.134179] Pid: 0, comm: swapper Tainted: G        W
2.6.26-rc4-00168-gc3b25b3 #1
[    2.134179]  [<c01227ae>] warn_on_slowpath+0x41/0x6c
[    2.134179]  [<c0122c95>] ? release_console_sem+0x188/0x190
[    2.134179]  [<c0136703>] ? sched_clock_cpu+0x10e/0x11c
[    2.134179]  [<c02753e0>] ? kgdbts_break_test+0x0/0x1e
[    2.134179]  [<c0123159>] ? printk+0x15/0x17
[    2.134179]  [<c0123159>] ? printk+0x15/0x17
[    2.134179]  [<c0275790>] run_simple_test+0x1de/0x20e
[    2.134179]  [<c027517d>] kgdbts_put_char+0x14/0x16
[    2.134179]  [<c014e6f2>] put_packet+0x6b/0xbb
[    2.134179]  [<c014f9e1>] kgdb_handle_exception+0xb11/0xbe0
[    2.134179]  [<c011bda3>] ? rebalance_domains+0x10b/0x361
[    2.134179]  [<c01127ae>] kgdb_notify+0x134/0x15d
[    2.134179]  [<c037fe9f>] notifier_call_chain+0x2b/0x4a
[    2.134179]  [<c037fecf>] __atomic_notifier_call_chain+0x11/0x13
[    2.134179]  [<c037fedd>] atomic_notifier_call_chain+0xc/0xe
[    2.134179]  [<c0135d76>] notify_die+0x2d/0x2f
[    2.134179]  [<c037e9af>] do_debug+0x56/0xe4
[    2.134179]  [<c01084f8>] ? mwait_idle+0x0/0x40
[    2.134179]  [<c037e407>] debug_stack_correct+0x27/0x2c
[    2.134179]  [<c01084f8>] ? mwait_idle+0x0/0x40
[    2.134179]  [<c0108536>] ? mwait_idle+0x3e/0x40
[    2.134179]  [<c0102507>] cpu_idle+0xae/0xce
[    2.134179]  [<c037a74a>] start_secondary+0x15d/0x162
[    2.134179]  =======================
[    2.134179] ---[ end trace 4cb23d4b8b3c3614 ]---
[    2.368316] kgdbts: ERROR PUT: end of test buffer on
'singlestep_breakpoint_test' line 0 expected S0* got
$T05thread:0000000000000001;#a7
[    2.376366] ------------[ cut here ]------------
[    2.378308] WARNING: at drivers/misc/kgdbts.c:721
run_simple_test+0x1de/0x20e()
[    2.378308] Modules linked in:
[    2.378308] Pid: 1, comm: swapper Tainted: G        W
2.6.26-rc4-00168-gc3b25b3 #1
[    2.378308]  [<c01227ae>] warn_on_slowpath+0x41/0x6c
[    2.378308]  [<c0122c95>] ? release_console_sem+0x188/0x190
[    2.378308]  [<c014fac9>] ? get_timestamp+0x8/0x11
[    2.378308]  [<c0136703>] ? sched_clock_cpu+0x10e/0x11c
[    2.378308]  [<c0123159>] ? printk+0x15/0x17
[    2.378308]  [<c0275790>] run_simple_test+0x1de/0x20e
[    2.378308]  [<c027517d>] kgdbts_put_char+0x14/0x16
[    2.378308]  [<c014e6f2>] put_packet+0x6b/0xbb
[    2.378308]  [<c014f1b7>] kgdb_handle_exception+0x2e7/0xbe0
[    2.378308]  [<c01127ae>] kgdb_notify+0x134/0x15d
[    2.378308]  [<c037fe9f>] notifier_call_chain+0x2b/0x4a
[    2.378308]  [<c037fecf>] __atomic_notifier_call_chain+0x11/0x13
[    2.378308]  [<c037fedd>] atomic_notifier_call_chain+0xc/0xe
[    2.378308]  [<c0135d76>] notify_die+0x2d/0x2f
[    2.378308]  [<c037ea66>] do_int3+0x29/0x67
[    2.378308]  [<c037e553>] int3+0x27/0x2c
[    2.378308]  [<c014007b>] ? sys_init_module+0x409/0x17ea
[    2.378308]  [<c014e8a3>] ? kgdb_breakpoint+0x13/0x24
[    2.378308]  [<c0275b37>] configure_kgdbts+0x1ba/0x3fa
[    2.378308]  [<c04e0c57>] init_kgdbts+0x13/0x15
[    2.378308]  [<c04c9470>] kernel_init+0x127/0x263
[    2.378308]  [<c04e0c44>] ? init_kgdbts+0x0/0x15
[    2.378308]  [<c011d400>] ? sched_setaffinity+0xca/0xe3
[    2.378308]  [<c011e5bc>] ? schedule_tail+0x18/0x46
[    2.378308]  [<c01037a6>] ? ret_from_fork+0x6/0x1c
[    2.378308]  [<c04c9349>] ? kernel_init+0x0/0x263
[    2.378308]  [<c04c9349>] ? kernel_init+0x0/0x263
[    2.378308]  [<c01044ef>] kernel_thread_helper+0x7/0x10
[    2.378308]  =======================
[    2.378308] ---[ end trace 4cb23d4b8b3c3614 ]---
[    2.512115] kgdbts: BP mismatch c0108537 expected c02753e0
[    2.515884] ------------[ cut here ]------------
[    2.519708] WARNING: at drivers/misc/kgdbts.c:302
check_and_rewind_pc+0x9a/0xb4()
[    2.522103] Modules linked in:
[    2.522103] Pid: 0, comm: swapper Tainted: G        W
2.6.26-rc4-00168-gc3b25b3 #1
[    2.522103]  [<c01227ae>] warn_on_slowpath+0x41/0x6c
[    2.522103]  [<c0122c95>] ? release_console_sem+0x188/0x190
[    2.522103]  [<c0136703>] ? sched_clock_cpu+0x10e/0x11c
[    2.522103]  [<c02753e0>] ? kgdbts_break_test+0x0/0x1e
[    2.522103]  [<c0123159>] ? printk+0x15/0x17
[    2.522103]  [<c02753e0>] ? kgdbts_break_test+0x0/0x1e
[    2.522103]  [<c0275edb>] check_and_rewind_pc+0x9a/0xb4
[    2.522103]  [<c0108537>] ? mwait_idle+0x3f/0x40
[    2.522103]  [<c02753e0>] ? kgdbts_break_test+0x0/0x1e
[    2.522103]  [<c02750e2>] validate_simple_test+0x22/0x69
[    2.522103]  [<c0275753>] run_simple_test+0x1a1/0x20e
[    2.522103]  [<c027517d>] kgdbts_put_char+0x14/0x16
[    2.522103]  [<c014e6f2>] put_packet+0x6b/0xbb
[    2.522103]  [<c014f9e1>] kgdb_handle_exception+0xb11/0xbe0
[    2.522103]  [<c01127ae>] kgdb_notify+0x134/0x15d
[    2.522103]  [<c037fe9f>] notifier_call_chain+0x2b/0x4a
[    2.522103]  [<c037fecf>] __atomic_notifier_call_chain+0x11/0x13
[    2.522103]  [<c037fedd>] atomic_notifier_call_chain+0xc/0xe
[    2.522103]  [<c0135d76>] notify_die+0x2d/0x2f
[    2.522103]  [<c037e9af>] do_debug+0x56/0xe4
[    2.522103]  [<c01084f8>] ? mwait_idle+0x0/0x40
[    2.522103]  [<c037e407>] debug_stack_correct+0x27/0x2c
[    2.522103]  [<c01084f8>] ? mwait_idle+0x0/0x40
[    2.522103]  [<c0108537>] ? mwait_idle+0x3f/0x40
[    2.522103]  [<c0102507>] ? cpu_idle+0xae/0xce
[    2.522103]  [<c037a74a>] start_secondary+0x15d/0x162
[    2.522103]  =======================
[    2.522103] ---[ end trace 4cb23d4b8b3c3614 ]---
[    2.522103] kgdbts: ERROR PUT: end of test buffer on
'singlestep_breakpoint_test' line 3 expected kgdbts_break_test got
$000000000000000000000000f88410c0072510c0a8ffc6f70100000080b051c0
[    2.522103] ------------[ cut here ]------------
[    2.522103] WARNING: at drivers/misc/kgdbts.c:721
run_simple_test+0x1de/0x20e()
[    2.522103] Modules linked in:
[    2.522103] Pid: 0, comm: swapper Tainted: G        W
2.6.26-rc4-00168-gc3b25b3 #1
[    2.522103]  [<c01227ae>] warn_on_slowpath+0x41/0x6c
[    2.522103]  [<c0122c95>] ? release_console_sem+0x188/0x190
[    2.522103]  [<c0136703>] ? sched_clock_cpu+0x10e/0x11c
[    2.522103]  [<c02753e0>] ? kgdbts_break_test+0x0/0x1e
[    2.522103]  [<c0123159>] ? printk+0x15/0x17
[    2.522103]  [<c0123159>] ? printk+0x15/0x17
[    2.522103]  [<c0275790>] run_simple_test+0x1de/0x20e
[    2.522103]  [<c027517d>] kgdbts_put_char+0x14/0x16
[    2.522103]  [<c014e6f2>] put_packet+0x6b/0xbb
[    2.522103]  [<c014f9e1>] kgdb_handle_exception+0xb11/0xbe0
[    2.522103]  [<c01127ae>] kgdb_notify+0x134/0x15d
[    2.522103]  [<c037fe9f>] notifier_call_chain+0x2b/0x4a
[    2.522103]  [<c037fecf>] __atomic_notifier_call_chain+0x11/0x13
[    2.522103]  [<c037fedd>] atomic_notifier_call_chain+0xc/0xe
[    2.522103]  [<c0135d76>] notify_die+0x2d/0x2f
[    2.522103]  [<c037e9af>] do_debug+0x56/0xe4
[    2.522103]  [<c01084f8>] ? mwait_idle+0x0/0x40
[    2.522103]  [<c037e407>] debug_stack_correct+0x27/0x2c
[    2.522103]  [<c01084f8>] ? mwait_idle+0x0/0x40
[    2.522103]  [<c0108537>] ? mwait_idle+0x3f/0x40
[    2.522103]  [<c0102507>] ? cpu_idle+0xae/0xce
[    2.522103]  [<c037a74a>] start_secondary+0x15d/0x162
[    2.522103]  =======================
[    2.522103] ---[ end trace 4cb23d4b8b3c3614 ]---
[    2.755799] kgdbts:RUN singlestep [300/1000]
[    2.765281] kgdbts:RUN singlestep [400/1000]
[    2.775112] kgdbts:RUN singlestep [500/1000]
[    2.793702] kgdbts:RUN singlestep [600/1000]
[    2.811507] kgdbts:RUN singlestep [700/1000]
[    2.828554] kgdbts:RUN singlestep [800/1000]
[    2.845613] kgdbts:RUN singlestep [900/1000]
[    2.863079] kgdbts:RUN hw breakpoint test
[    2.863079] kgdbts:RUN hw write breakpoint test
[    2.868373] kgdbts:RUN access write breakpoint test
[    2.878335] kgdbts:RUN do_fork for 100 breakpoints

I'm going to reboot and see if this appears, if so I will turn this
fuction off, due to not needing it.
As for the above I hope this is useful info.
regards;
-- 
Justin P. Mattock
