Return-Path: <linux-kernel-owner+w=401wt.eu-S1763680AbYENPfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763680AbYENPfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbYENPex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:34:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:9431 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbYENPev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:34:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:x-x-sender:to:cc:subject:message-id:user-agent:mime-version:content-type:from;
        b=Hv8zxCgt/kiAUsVK49CLbb4KyGr0rczpfy5tEFZ5NeN3/SnvVje5FeB31NBo5SjRvWprGHUF0hZvfyeZt1WL5H1VSfMG3CxgPPclnTCmT+3MbE2vFNHUO/dBAyqZwT2uIH5ENQasWyY+G2GC+6wKeujRLA+Cmola1uuRE6+3NVc=
Date: Wed, 14 May 2008 16:34:41 +0100 (BST)
X-X-Sender: bb3081@gamma
To: linux-kernel@vger.kernel.org
cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
       akpm@linux-foundation.org, nico@cam.org, buytenh@wantstofly.org
Subject: 2.6.26-rc2-mm1: oops on ARM while registering GPIO Keys
Message-ID: <alpine.DEB.1.00.0805141620080.3865@gamma>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Byron Bradley <byron.bbradley@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Testing on a QNAP TS-209 (ARM, Marvell Orion 88F5182 SoC). GPIO Keys works 
correctly on 2.6.26-rc2 but panics on 2.6.26-rc2-mm1. If nobody knows the 
cause of this I can look into it/bisect later.

Unable to handle kernel paging request at virtual address 6f697067
pgd = c0004000
[6f697067] *pgd=00000000
Internal error: Oops: 1 [#1] PREEMPT
Modules linked in:
CPU: 0    Not tainted  (2.6.26-rc2-mm1 #4)
PC is at __kmalloc_track_caller+0x50/0xd4
LR is at __kmalloc_track_caller+0x24/0xd4
pc : [<c0099ab4>]    lr : [<c0099a88>]    psr: 20000093
sp : c7c29c78  ip : c7c29c78  fp : c7c29ca4
r10: c04f21ec  r9 : 00000000  r8 : c00e6020
r7 : 000000d0  r6 : a0000013  r5 : 6f697067  r4 : c04d8114
r3 : 00000000  r2 : c04d8000  r1 : 000000d0  r0 : c04d8114
Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: a005317f  Table: 00004000  DAC: 00000017
Process swapper (pid: 1, stack limit = 0xc7c28268)
Stack: (0xc7c29c78 to 0xc7c2a000)
9c60:                                                       c7c29cdc c7c29c88 
9c80: c0252594 00000003 c00e6020 c04b6ec8 c7e02570 00000001 c7c29cc4 c7c29ca8 
9ca0: c008298c c0099a74 c7e02570 c04f21d0 00000001 c7c42ea0 c7c29d04 c7c29cc8 
9cc0: c00e6020 c0082960 000041ed c04b6ec8 c7c29d1c c7c29ce0 c00e617c c04f21d0 
9ce0: 00000001 c7c42ea0 c7e02570 c7c29d54 00000000 c04f21ec c7c29d3c c7c29d08 
9d00: c00e6478 c00e5f28 c7c42ea0 c04f21e0 c7c29d4c c7c29d20 c00e5590 c04f21d0 
9d20: 00000001 c7c42ec4 c7c42ea0 c7c42ea0 c7c29d4c c7c29d40 c00e6568 c00e645c 
9d40: c7c29d84 c7c29d50 c00e7834 c00e655c c00e5d48 c7e02570 c7c29d90 c04f21d0 
9d60: 00000001 c7c42ec4 c7c42ea0 00000000 c04f210c c7c42ea0 c7c29d94 c7c29d88 
9d80: c00e7a0c c00e77f4 c7c29dbc c7c29d98 c028d8bc c00e7a04 00000000 00000000 
9da0: c7c42e38 c7c42ec4 00000000 c04e11c8 c7c29e04 c7c29dc0 c028df90 c028d884 
9dc0: c04f21b4 c04dcb18 c7c42800 c04dcc5c 00000038 c0533f98 c7c29dfc c04dcd10 
9de0: c7c42800 c7c42e38 c7c42800 c04dcc5c 00000038 c0533f98 c7c29e2c c7c29e08 
9e00: c03113f8 c028dcd0 c04dcd10 00000022 c7de9ec8 c7c42800 c04dcc5c 00000001 
9e20: c7c29e7c c7c29e30 c03f8034 c0311368 c04dcb10 c7c29e40 c04dccf4 c04dcb10 
9e40: c7de9e88 00000002 00000000 00000000 c04dcb18 c04dcb18 c04f2958 c04f2958 
9e60: c02902c0 c053224c c0026000 c7e30ea0 c7c29e8c c7c29e80 c0291008 c03f7d5c 
9e80: c7c29eb4 c7c29e90 c02901bc c0290ff8 c7c29ec4 c04dcb18 c04dcbc0 c04f2958 
9ea0: c02902c0 c04ecce0 c7c29ed4 c7c29eb8 c0290334 c0290120 c7c29ed4 00000000 
9ec0: c7c29edc c04f2958 c7c29f04 c7c29ed8 c028f894 c02902d0 c7e30ea0 c7c043b8 
9ee0: c7c043b8 c04dcb60 00000000 c04f2958 c04f2958 c0025b3c c7c29f14 c7c29f08 
9f00: c029001c c028f84c c7c29f44 c7c29f18 c028fe44 c029000c c0479c7c 00000000 
9f20: 00000000 c04f2958 00000000 c0025b3c c7c28000 00000001 c7c29f6c c7c29f48 
9f40: c02905c8 c028fca4 c0026000 00000000 00000000 00000000 c0025b3c c7c28000 
9f60: c7c29f7c c7c29f70 c02911c8 c0290580 c7c29f8c c7c29f80 c001f160 c0291160 
9f80: c7c29ff4 c7c29f90 c00087a8 c001f15c c003f3e8 c003e868 00000000 00000000 
9fa0: 00000000 c7c29fb0 c002dbc4 c003f3dc 00000000 00000000 c0008734 c0049404 
9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
9fe0: 00000000 00000000 00000000 c7c29ff8 c0049404 c0008744 00000000 00000000 
Backtrace: 
[<c0099a64>] (__kmalloc_track_caller+0x0/0xd4) from [<c008298c>] (kstrdup+0x3c/0x58)
 r8:00000001 r7:c7e02570 r6:c04b6ec8 r5:c00e6020 r4:00000003
[<c0082950>] (kstrdup+0x0/0x58) from [<c00e6020>] (sysfs_new_dirent+0x108/0x134)
 r6:c7c42ea0 r5:00000001 r4:c04f21d0
[<c00e5f18>] (sysfs_new_dirent+0x0/0x134) from [<c00e6478>] (create_dir+0x2c/0xb0)
[<c00e644c>] (create_dir+0x0/0xb0) from [<c00e6568>] (sysfs_create_subdir+0x1c/0x20)
 r8:c7c42ea0 r7:c7c42ea0 r6:c7c42ec4 r5:00000001 r4:c04f21d0
[<c00e654c>] (sysfs_create_subdir+0x0/0x20) from [<c00e7834>] (internal_create_group+0x50/0x1f4)
[<c00e77e4>] (internal_create_group+0x0/0x1f4) from [<c00e7a0c>] (sysfs_create_group+0x18/0x1c)
[<c00e79f4>] (sysfs_create_group+0x0/0x1c) from [<c028d8bc>] (device_add_groups+0x48/0x90)
[<c028d874>] (device_add_groups+0x0/0x90) from [<c028df90>] (device_add+0x2d0/0x55c)
 r8:c04e11c8 r7:00000000 r6:c7c42ec4 r5:c7c42e38 r4:00000000
[<c028dcc0>] (device_add+0x0/0x55c) from [<c03113f8>] (input_register_device+0xa0/0x1e4)
[<c0311358>] (input_register_device+0x0/0x1e4) from [<c03f8034>] (gpio_keys_probe+0x2e8/0x3a4)
[<c03f7d4c>] (gpio_keys_probe+0x0/0x3a4) from [<c0291008>] (platform_drv_probe+0x20/0x24)
[<c0290fe8>] (platform_drv_probe+0x0/0x24) from [<c02901bc>] (driver_probe_device+0xac/0x1b0)
[<c0290110>] (driver_probe_device+0x0/0x1b0) from [<c0290334>] (__driver_attach+0x74/0x78)
 r8:c04ecce0 r7:c02902c0 r6:c04f2958 r5:c04dcbc0 r4:c04dcb18
[<c02902c0>] (__driver_attach+0x0/0x78) from [<c028f894>] (bus_for_each_dev+0x58/0x84)
 r6:c04f2958 r5:c7c29edc r4:00000000
[<c028f83c>] (bus_for_each_dev+0x0/0x84) from [<c029001c>] (driver_attach+0x20/0x28)
 r7:c0025b3c r6:c04f2958 r5:c04f2958 r4:00000000
[<c028fffc>] (driver_attach+0x0/0x28) from [<c028fe44>] (bus_add_driver+0x1b0/0x238)
[<c028fc94>] (bus_add_driver+0x0/0x238) from [<c02905c8>] (driver_register+0x58/0x134)
[<c0290570>] (driver_register+0x0/0x134) from [<c02911c8>] (platform_driver_register+0x78/0x94)
 r8:c7c28000 r7:c0025b3c r6:00000000 r5:00000000 r4:00000000
[<c0291150>] (platform_driver_register+0x0/0x94) from [<c001f160>] (gpio_keys_init+0x14/0x1c)
[<c001f14c>] (gpio_keys_init+0x0/0x1c) from [<c00087a8>] (kernel_init+0x74/0x27c)
[<c0008734>] (kernel_init+0x0/0x27c) from [<c0049404>] (do_exit+0x0/0x6d8)
Code: e5945048 e3550000 0a000019 e5943054 (e7952103) 
---[ end trace 59e8e37f43a1ff90 ]---
Kernel panic - not syncing: Attempted to kill init!

-- 
Byron Bradley
