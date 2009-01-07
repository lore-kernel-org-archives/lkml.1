Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153AbZAGFHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbZAGFHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 00:07:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751014AbZAGFG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 00:06:59 -0500
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:48654 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750784AbZAGFG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 00:06:58 -0500
Message-ID: <49643869.8000500@lwfinger.net>
Date: Tue, 06 Jan 2009 23:06:49 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: BUG in latest GIT 2.6.28-0658-g637b180
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest GIT generates the following BUG.


BUG: sleeping function called from invalid context at mm/slab.c:3046
in_atomic(): 0, irqs_disabled(): 1, pid: 523, name: modprobe
no locks held by modprobe/523.
irq event stamp: 17802
hardirqs last  enabled at (17801): [<ffffffff8045dd99>]
_spin_unlock_irqrestore+0x44/0x4c
hardirqs last disabled at (17802): [<ffffffffa00a4792>]
ide_probe_port+0x6c/0x469 [ide_core]
softirqs last  enabled at (17796): [<ffffffff802431f3>]
__do_softirq+0x159/0x166
softirqs last disabled at (17789): [<ffffffff8020d4bc>]
call_softirq+0x1c/0x28
Pid: 523, comm: modprobe Not tainted 2.6.28-Linus-06858-g637b180 #31
Call Trace:
 [<ffffffff8025dbdd>] ? print_irqtrace_events+0xd0/0xd4
 [<ffffffff80236bcd>] __might_sleep+0xf9/0xfb
 [<ffffffff802b5469>] kmem_cache_alloc+0x2d/0x142
 [<ffffffffa00a489b>] ide_probe_port+0x175/0x469 [ide_core]
 [<ffffffffa00a5750>] ide_host_register+0x2b8/0x611 [ide_core]
 [<ffffffffa00a8526>] ? do_ide_setup_pci_device+0x70/0xd3 [ide_core]
 [<ffffffffa00a8f1d>] ide_pci_init_one+0xcc/0xee [ide_core]
 [<ffffffff8025e852>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8045dd92>] ? _spin_unlock_irqrestore+0x3d/0x4c
 [<ffffffff8023e3ec>] ? release_console_sem+0x1b0/0x1e5
 [<ffffffff8045aac8>] ? printk+0x41/0x49
 [<ffffffffa00bf604>] amd74xx_probe+0x13e/0x145 [amd74xx]
 [<ffffffffa00bf340>] ? init_chipset_amd74xx+0x0/0x160 [amd74xx]
 [<ffffffffa00bf4a0>] ? init_hwif_amd74xx+0x0/0x26 [amd74xx]
 [<ffffffff80345fb6>] pci_device_probe+0xc6/0x11d
 [<ffffffff803b7f1d>] driver_probe_device+0xc3/0x168
 [<ffffffff803b801f>] __driver_attach+0x5d/0x80
 [<ffffffff803b7fc2>] ? __driver_attach+0x0/0x80
 [<ffffffff803b7794>] bus_for_each_dev+0x59/0x90
 [<ffffffff803b7d60>] driver_attach+0x21/0x23
 [<ffffffff803b703b>] bus_add_driver+0xbf/0x20c
 [<ffffffff803b822e>] driver_register+0xb0/0x130
 [<ffffffff8034628d>] __pci_register_driver+0x68/0xa3
 [<ffffffffa0023000>] ? amd74xx_ide_init+0x0/0x20 [amd74xx]
 [<ffffffffa002301e>] amd74xx_ide_init+0x1e/0x20 [amd74xx]
 [<ffffffff8020905b>] _stext+0x5b/0x135
 [<ffffffff802561b0>] ? __blocking_notifier_call_chain+0x5d/0x6f
 [<ffffffff8026af0c>] sys_init_module+0xb0/0x1d3
 [<ffffffff8020c2cb>] system_call_fastpath+0x16/0x1b
