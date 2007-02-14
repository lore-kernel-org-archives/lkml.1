Return-Path: <linux-kernel-owner+w=401wt.eu-S932082AbXBNAA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082AbXBNAA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 19:00:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932071AbXBNAA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 19:00:56 -0500
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:48546 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932079AbXBNAAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 19:00:54 -0500
X-Greylist: delayed 1595 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Feb 2007 19:00:54 EST
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200702140000.l1E00pCL012981@turbo.physics.adelaide.edu.au>
Subject: 2.6.20-rt5: BUG: scheduling while atomic
To: linux-kernel@vger.kernel.org
Date: Wed, 14 Feb 2007 10:30:51 +1030 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe)
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When running 2.6.20-rt5 on a Via Apollo based mainboard with the "low
latency desktop" preemption setting active the following messages were
logged.  This isn't all of them - there were quite a few, some of which
passed out of the message buffer.  I didn't see this with 2.6.19.2.
I don't know about earlier -rt kernels because the machine concerned is
a recent acquisition.

Any ideas?  I'm happy to test things if it will help narrow down the
problem.

Regards
  jonathan

 =======================
BUG: scheduling while atomic: swapper/0x00000001/1, CPU#0
 [<c0360e21>] __sched_text_start+0x91/0x5f5
 [<c036146b>] schedule+0xe6/0x100
 [<c0124ed8>] flush_cpu_workqueue+0x92/0xd0
 [<c01279f1>] autoremove_wake_function+0x0/0x33
 [<c01279f1>] autoremove_wake_function+0x0/0x33
 [<c0152188>] filevec_add_drain_per_cpu+0x0/0x2
 [<c0124f3a>] flush_workqueue+0x24/0x2f
 [<c012536a>] schedule_on_each_cpu_wq+0x82/0x92
 [<c017e44d>] remove_proc_entry+0x110/0x167
 [<c017e379>] remove_proc_entry+0x3c/0x167
 [<c011c1f3>] unregister_proc_table+0x60/0x73
 [<c011c1cf>] unregister_proc_table+0x3c/0x73
 [<c011c1cf>] unregister_proc_table+0x3c/0x73
 [<c011c1cf>] unregister_proc_table+0x3c/0x73
 [<c011c1cf>] unregister_proc_table+0x3c/0x73
 [<c011c07d>] unregister_sysctl_table+0x21/0x3f
 [<c02b2c9c>] parport_device_proc_unregister+0x16/0x22
 [<c02b08bb>] parport_unregister_device+0xc/0xf9
 [<c02b3c11>] parport_device_id+0xa4/0xaf
 [<c02b2e88>] parport_daisy_init+0x130/0x1c0
 [<c0135045>] setup_irq+0x19b/0x1f8
 [<c02b04f4>] parport_announce_port+0x9/0xb4
 [<c02b6496>] parport_pc_probe_port+0x57a/0x5e9
 [<c02b6b9f>] sio_via_probe+0x325/0x398
 [<c011b9f3>] __request_region+0x4e/0x86
 [<c04601aa>] parport_pc_init_superio+0x43/0x67
 [<c04601e7>] parport_pc_find_ports+0x19/0x69
 [<c046062c>] parport_pc_init+0x88/0x91
 [<c044a758>] do_initcalls+0x58/0xf5
 [<c017e241>] proc_mkdir_mode+0x3e/0x51
 [<c0136436>] register_irq_proc+0x5a/0x6a
 [<c0100376>] init+0x0/0x14e
 [<c01003b9>] init+0x43/0x14e
 [<c0103827>] kernel_thread_helper+0x7/0x10
 =======================
BUG: scheduling while atomic: swapper/0x00000001/1, CPU#0
 [<c0360e21>] __sched_text_start+0x91/0x5f5
 [<c036146b>] schedule+0xe6/0x100
 [<c0124ed8>] flush_cpu_workqueue+0x92/0xd0
 [<c01279f1>] autoremove_wake_function+0x0/0x33
 [<c01279f1>] autoremove_wake_function+0x0/0x33
 [<c0152188>] filevec_add_drain_per_cpu+0x0/0x2
 [<c0124f3a>] flush_workqueue+0x24/0x2f
 [<c012536a>] schedule_on_each_cpu_wq+0x82/0x92
 [<c017e44d>] remove_proc_entry+0x110/0x167
 [<c017e379>] remove_proc_entry+0x3c/0x167
 [<c011c1f3>] unregister_proc_table+0x60/0x73
 [<c011c1cf>] unregister_proc_table+0x3c/0x73
 [<c011c1cf>] unregister_proc_table+0x3c/0x73
 [<c011c1cf>] unregister_proc_table+0x3c/0x73
 [<c011c07d>] unregister_sysctl_table+0x21/0x3f
 [<c02b2c9c>] parport_device_proc_unregister+0x16/0x22
 [<c02b08bb>] parport_unregister_device+0xc/0xf9
 [<c02b3c11>] parport_device_id+0xa4/0xaf
 [<c02b2e88>] parport_daisy_init+0x130/0x1c0
 [<c0135045>] setup_irq+0x19b/0x1f8
 [<c02b04f4>] parport_announce_port+0x9/0xb4
 [<c02b6496>] parport_pc_probe_port+0x57a/0x5e9
 [<c02b6b9f>] sio_via_probe+0x325/0x398
 [<c011b9f3>] __request_region+0x4e/0x86
 [<c04601aa>] parport_pc_init_superio+0x43/0x67
 [<c04601e7>] parport_pc_find_ports+0x19/0x69
 [<c046062c>] parport_pc_init+0x88/0x91
 [<c044a758>] do_initcalls+0x58/0xf5
 [<c017e241>] proc_mkdir_mode+0x3e/0x51
 [<c0136436>] register_irq_proc+0x5a/0x6a
 [<c0100376>] init+0x0/0x14e
 [<c01003b9>] init+0x43/0x14e
 [<c0103827>] kernel_thread_helper+0x7/0x10
 =======================
BUG: scheduling while atomic: swapper/0x00000001/1, CPU#0
 [<c0360e21>] __sched_text_start+0x91/0x5f5
 [<c036146b>] schedule+0xe6/0x100
 [<c0124ed8>] flush_cpu_workqueue+0x92/0xd0
 [<c01279f1>] autoremove_wake_function+0x0/0x33
 [<c01279f1>] autoremove_wake_function+0x0/0x33
 [<c0152188>] filevec_add_drain_per_cpu+0x0/0x2
 [<c0124f3a>] flush_workqueue+0x24/0x2f
 [<c012536a>] schedule_on_each_cpu_wq+0x82/0x92
 [<c017e44d>] remove_proc_entry+0x110/0x167
 [<c017e379>] remove_proc_entry+0x3c/0x167
 [<c011c1f3>] unregister_proc_table+0x60/0x73
 [<c011c1cf>] unregister_proc_table+0x3c/0x73
 [<c011c1cf>] unregister_proc_table+0x3c/0x73
 [<c011c07d>] unregister_sysctl_table+0x21/0x3f
 [<c02b2c9c>] parport_device_proc_unregister+0x16/0x22
 [<c02b08bb>] parport_unregister_device+0xc/0xf9
 [<c02b3c11>] parport_device_id+0xa4/0xaf
 [<c02b2e88>] parport_daisy_init+0x130/0x1c0
 [<c0135045>] setup_irq+0x19b/0x1f8
 [<c02b04f4>] parport_announce_port+0x9/0xb4
 [<c02b6496>] parport_pc_probe_port+0x57a/0x5e9
 [<c02b6b9f>] sio_via_probe+0x325/0x398
 [<c011b9f3>] __request_region+0x4e/0x86
 [<c04601aa>] parport_pc_init_superio+0x43/0x67
 [<c04601e7>] parport_pc_find_ports+0x19/0x69
 [<c046062c>] parport_pc_init+0x88/0x91
 [<c044a758>] do_initcalls+0x58/0xf5
 [<c017e241>] proc_mkdir_mode+0x3e/0x51
 [<c0136436>] register_irq_proc+0x5a/0x6a
 [<c0100376>] init+0x0/0x14e
 [<c01003b9>] init+0x43/0x14e
 [<c0103827>] kernel_thread_helper+0x7/0x10
 =======================
lp0: using parport0 (interrupt-driven).
parport_pc: VIA parallel port: io=0x378, irq=7
