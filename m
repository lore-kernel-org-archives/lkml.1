Return-Path: <linux-kernel-owner+w=401wt.eu-S1759181AbYDVHyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759181AbYDVHyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 03:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754337AbYDVHyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 03:54:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40368 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435AbYDVHyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 03:54:09 -0400
Date: Tue, 22 Apr 2008 09:53:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: WARNING: at drivers/base/sys.c:183 sysdev_driver_register+0x7a
Message-ID: <20080422075357.GA15651@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi Len,

randconfig boot testing found this new debug warning message in the 
syslog:

[   78.736920] Calling initcall 0xffffffff814792c5: powernowk8_init+0x0/0x9d()
[   78.744921] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ processors (1 cpu cores) (version 2.20.00)
[   78.752921] powernow-k8: BIOS error - no PSB or ACPI _PSS objects
[   78.756922] initcall 0xffffffff814792c5: powernowk8_init+0x0/0x9d() returned -19.
[   78.764922] initcall 0xffffffff814792c5 ran for 11 msecs: powernowk8_init+0x0/0x9d()
[   78.772923] Calling initcall 0xffffffff820ed639: acpi_cpufreq_init+0x0/0x94()
[   78.780923] sysdev: class cpu: driver (ffffffff81f96da0) has already been registered to a class, something is wrong, but will forge on!
[   78.784923] ------------[ cut here ]------------
[   78.788924] WARNING: at drivers/base/sys.c:183 sysdev_driver_register+0x7a/0x12b()
[   78.792924] Modules linked in:
[   78.796924] Pid: 1, comm: swapper Not tainted 2.6.25-sched-devel.git-x86-latest.git #4
[   78.800924] 
[   78.800924] Call Trace:
[   78.804925]  [<ffffffff80259cc2>] warn_on_slowpath+0x5d/0x70
[   78.808925]  [<ffffffff8025ad26>] ? printk+0x6c/0x6e
[   78.812925]  [<ffffffff80279ed9>] ? trace_hardirqs_off+0xd/0xf
[   78.816925]  [<ffffffff8148135a>] ? _spin_unlock_irqrestore+0x4c/0x5c
[   78.820926]  [<ffffffff8027b29f>] ? trace_hardirqs_on+0xd/0xf
[   78.824926]  [<ffffffff802ad2ea>] ? time_hardirqs_on+0x21/0x26
[   78.828926]  [<ffffffff808085f9>] sysdev_driver_register+0x7a/0x12b
[   78.832926]  [<ffffffff80f6c5f1>] cpufreq_register_driver+0xc7/0x1a3
[   78.836927]  [<ffffffff820ed6cb>] acpi_cpufreq_init+0x92/0x94
[   78.840927]  [<ffffffff820e39f3>] kernel_init+0x180/0x302
[   78.844927]  [<ffffffff81480a0e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   78.848927]  [<ffffffff8027b267>] ? trace_hardirqs_on_caller+0x117/0x142
[   78.852928]  [<ffffffff80221768>] child_rip+0xa/0x12
[   78.856928]  [<ffffffff80220cfc>] ? restore_args+0x0/0x30
[   78.860928]  [<ffffffff820e3873>] ? kernel_init+0x0/0x302
[   78.864928]  [<ffffffff8022175e>] ? child_rip+0x0/0x12
[   78.868929] 
[   78.868929] ---[ end trace e4117b3214f66ad9 ]---
[   78.872929] initcall 0xffffffff820ed639: acpi_cpufreq_init+0x0/0x94() returned -19.
[   78.880929] initcall 0xffffffff820ed639 ran for 87 msecs: acpi_cpufreq_init+0x0/0x94()
[   78.888930] Calling initcall 0xffffffff820ed6cd: centrino_init+0x0/0x44()
[   78.896930] initcall 0xffffffff820ed6cd: centrino_init+0x0/0x44() returned -19.

full log and config at:

  http://redhat.com/~mingo/misc/log-Tue_Apr_22_09_33_16_CEST_2008.bad
  http://redhat.com/~mingo/misc/config-Tue_Apr_22_09_33_16_CEST_2008.bad

	Ingo
