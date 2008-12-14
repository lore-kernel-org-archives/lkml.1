Return-Path: <linux-kernel-owner+w=401wt.eu-S1753706AbYLNBjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbYLNBjS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 20:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbYLNBjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 20:39:05 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:51724 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbYLNBjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 20:39:03 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 14 Dec 2008 02:38:04 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: "BUG: MAX_STACK_TRACE_ENTRIES too low!" - reason for concern?
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.7ea353e737215fa2@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is the following anything that anybody should do something about?

# unloading IEEE 1394 drivers (as slightly before linux1394-2.6.git)

Dec 14 01:23:24 stein ieee1394: Node removed: ID:BUS[3-00:1023]  GUID[00d0f5200800613d]
Dec 14 01:23:24 stein ieee1394: Node removed: ID:BUS[2-00:1023]  GUID[0010dc5600fed2d4]
Dec 14 01:23:24 stein ieee1394: Node removed: ID:BUS[1-01:1023]  GUID[0030bd051800064f]
Dec 14 01:23:24 stein ieee1394: Node removed: ID:BUS[1-00:1023]  GUID[0012870035000f94]
Dec 14 01:23:24 stein ieee1394: Node removed: ID:BUS[0-08:1023]  GUID[080028560000319b]

# reloading IEEE 1394 drivers (as in linux1394-2.6.git)

Dec 14 01:23:29 stein BUG: MAX_STACK_TRACE_ENTRIES too low!
Dec 14 01:23:29 stein turning off the locking correctness validator.
Dec 14 01:23:29 stein Pid: 12654, comm: modprobe Not tainted 2.6.28-rc7 #8
Dec 14 01:23:29 stein Call Trace:
Dec 14 01:23:29 stein [<c014293e>] save_trace+0x8e/0xa0
Dec 14 01:23:29 stein [<c0142990>] add_lock_to_list+0x40/0xb0
Dec 14 01:23:29 stein [<c0143c10>] check_noncircular+0x70/0xf0
Dec 14 01:23:29 stein [<c02feb61>] klist_add_tail+0x21/0x40
Dec 14 01:23:29 stein [<c0145bf4>] validate_chain+0x964/0xec0
Dec 14 01:23:29 stein [<c02feb61>] klist_add_tail+0x21/0x40
Dec 14 01:23:29 stein [<c014639a>] __lock_acquire+0x24a/0x990
Dec 14 01:23:29 stein [<c030dfee>] mutex_lock_nested+0x1ae/0x290
Dec 14 01:23:29 stein [<c0146b3f>] lock_acquire+0x5f/0x80
Dec 14 01:23:29 stein [<c02feb61>] klist_add_tail+0x21/0x40
Dec 14 01:23:29 stein [<c030f61a>] _spin_lock+0x3a/0x50
Dec 14 01:23:29 stein [<c02feb61>] klist_add_tail+0x21/0x40
Dec 14 01:23:29 stein [<c02feb61>] klist_add_tail+0x21/0x40
Dec 14 01:23:29 stein [<c026445a>] device_add+0x40a/0x4b0
Dec 14 01:23:29 stein [<f8d68806>] hpsb_alloc_host+0x1e6/0x210 [ieee1394]
Dec 14 01:23:29 stein [<f9aae3c9>] ohci1394_pci_probe+0x59/0x7a5 [ohci1394]
Dec 14 01:23:29 stein [<c020a406>] pci_match_device+0x16/0xc0
Dec 14 01:23:29 stein [<c030fb75>] _spin_unlock+0x25/0x40
Dec 14 01:23:29 stein [<c020a498>] pci_match_device+0xa8/0xc0
Dec 14 01:23:29 stein [<c020a836>] pci_device_probe+0x56/0x80
Dec 14 01:23:29 stein [<c0266438>] driver_probe_device+0x88/0x180
Dec 14 01:23:29 stein [<c0144b64>] trace_hardirqs_on_caller+0xb4/0x130
Dec 14 01:23:29 stein [<c02665b4>] __driver_attach+0x84/0x90
Dec 14 01:23:29 stein [<c0265aec>] bus_for_each_dev+0x3c/0x60
Dec 14 01:23:29 stein [<c0266296>] driver_attach+0x16/0x20
Dec 14 01:23:29 stein [<c0266530>] __driver_attach+0x0/0x90
Dec 14 01:23:29 stein [<c0265f42>] bus_add_driver+0xb2/0x230
Dec 14 01:23:29 stein [<c020a330>] pci_device_shutdown+0x0/0x20
Dec 14 01:23:29 stein [<c020a780>] pci_device_remove+0x0/0x40
Dec 14 01:23:29 stein [<c026673d>] driver_register+0x4d/0x120
Dec 14 01:23:29 stein [<c0204232>] __spin_lock_init+0x32/0x60
Dec 14 01:23:29 stein [<f8d9b000>] ohci1394_init+0x0/0x14 [ohci1394]
Dec 14 01:23:29 stein [<c020aa88>] __pci_register_driver+0x58/0xa0
Dec 14 01:23:29 stein [<f8d9b000>] ohci1394_init+0x0/0x14 [ohci1394]
Dec 14 01:23:29 stein [<c0101126>] do_one_initcall+0x36/0x1b0
Dec 14 01:23:29 stein [<c0144b64>] trace_hardirqs_on_caller+0xb4/0x130
Dec 14 01:23:29 stein [<c014f4d4>] load_module+0x1624/0x1760
Dec 14 01:23:29 stein [<c01383e0>] autoremove_wake_function+0x0/0x50
Dec 14 01:23:29 stein [<f8d66260>] hpsb_bus_reset+0x0/0x110 [ieee1394]
Dec 14 01:23:29 stein [<c030db79>] mutex_lock_interruptible_nested+0x1c9/0x330
Dec 14 01:23:29 stein [<c030dd99>] __mutex_unlock_slowpath+0xb9/0x150
Dec 14 01:23:29 stein [<c014f699>] sys_init_module+0x89/0x1b0
Dec 14 01:23:29 stein [<c0144b64>] trace_hardirqs_on_caller+0xb4/0x130
Dec 14 01:23:29 stein [<c01ffff4>] trace_hardirqs_on_thunk+0xc/0x10
Dec 14 01:23:29 stein [<c0103349>] sysenter_do_call+0x12/0x35
Dec 14 01:23:30 stein ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[18]  MMIO=[fd8ff000-fd8ff7ff]  Max Packet=[4096]  IR/IT contexts=[4/8]
Dec 14 01:23:30 stein ohci1394: fw-host1: OHCI-1394 1.1 (PCI): IRQ=[18]  MMIO=[fbffc000-fbffc7ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
Dec 14 01:23:30 stein ohci1394: fw-host2: OHCI-1394 1.1 (PCI): IRQ=[20]  MMIO=[fbff9000-fbff97ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
Dec 14 01:23:30 stein ohci1394: fw-host3: OHCI-1394 1.0 (PCI): IRQ=[17]  MMIO=[f0000000-f00007ff]  Max Packet=[1024]  IR/IT contexts=[4/4]
Dec 14 01:23:31 stein ieee1394: The root node is not cycle master capable; selecting a new root node and resetting...
Dec 14 01:23:31 stein ieee1394: The root node is not cycle master capable; selecting a new root node and resetting...
Dec 14 01:23:31 stein ieee1394: Host added: ID:BUS[2-00:1023]  GUID[0010dc5600fed2d4]
Dec 14 01:23:31 stein ieee1394: Host added: ID:BUS[0-08:1023]  GUID[080028560000319b]
Dec 14 01:23:31 stein ieee1394: Host added: ID:BUS[3-00:1023]  GUID[00d0f5200800613d]
Dec 14 01:23:31 stein ieee1394: Node added: ID:BUS[1-00:1023]  GUID[0012870035000f94]
Dec 14 01:23:31 stein ieee1394: Host added: ID:BUS[1-01:1023]  GUID[0030bd051800064f]
Dec 14 01:23:31 stein input: FireDTV remote control as /devices/pci0000:00/0000:00:1e.0/0000:05:00.4/fw-host1/input/input7
Dec 14 01:23:31 stein DVB: registering new adapter (FireDTV T/CI)
Dec 14 01:23:31 stein DVB: registering adapter 0 frontend 0 (FireDTV T/CI)...
Dec 14 01:23:31 stein firedtv 0012870035000f94-0: Conditional Access Module not enabled


Thanks,
-- 
Stefan Richter
-=====-==--- ==-- -===-
http://arcgraph.de/sr/

