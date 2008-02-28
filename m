Return-Path: <linux-kernel-owner+w=401wt.eu-S1763909AbYB1UzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763909AbYB1UzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 15:55:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326AbYB1Uyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 15:54:55 -0500
Received: from the.earth.li ([217.147.81.2]:51305 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbYB1Uyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 15:54:53 -0500
X-Greylist: delayed 2756 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Feb 2008 15:54:53 EST
Date: Thu, 28 Feb 2008 20:08:55 +0000
From: Jonathan McDowell <noodles@earth.li>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org
Subject: 2.6.25 regression/oops on boot (ACPI related?)
Message-ID: <20080228200855.GJ9009@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting a "general protection fault" when trying to boot 2.6.25-rc3
on my AMD64 box; 2.6.24 boots fine. The machine just seems to end up
sitting there at the end, but still responds to a ctrl-alt-del to
cleanly shutdown. The GPF is as follows:

-----
general protection fault: 0000 [1] PREEMPT SMP 
CPU 1 
Modules linked in: thermal(+) processor fan
Pid: 598, comm: modprobe Not tainted 2.6.25-rc3 #1
RIP: 0010:[<ffffffff803590a8>]  [<ffffffff803590a8>] acpi_ns_map_handle_to_node+0x19/0x23
RSP: 0018:ffff81011de5fc68  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000001001 RCX: 0000000000000000
RDX: 0000000000005067 RSI: 0000000000000001 RDI: 4d52454854584e4c
RBP: ffff81011de5fc68 R08: 0000000000000000 R09: ffff81011de5fc78
R10: ffff81011dcc0648 R11: ffffffff802d566a R12: 4d52454854584e4c
R13: ffff81011de5fcf8 R14: ffffffff80362bd3 R15: 0000000000000003
FS:  00007f04840336e0(0000) GS:ffff81011fab1bc0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f0484032000 CR3: 000000011defc000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 598, threadinfo ffff81011de5e000, task ffff81011de38640)
Stack:  ffff81011de5fc98 ffffffff803584ab ffff81011de5fcf8 ffff81011df1a800
 0000000000000000 ffff81011de5fcf8 ffff81011de5fcb8 ffffffff80362382
 ffff81011de52230 0000000000000001 ffff81011de5fd28 ffffffff880113a9
Call Trace:
 [<ffffffff803584ab>] acpi_get_data+0x3f/0x70
 [<ffffffff80362382>] acpi_bus_get_device+0x25/0x39
 [<ffffffff880113a9>] :thermal:acpi_thermal_cooling_device_cb+0x6b/0x166
 [<ffffffff80405ee8>] ? thermal_zone_bind_cooling_device+0x0/0x26e
 [<ffffffff880114c6>] :thermal:acpi_thermal_bind_cooling_device+0x10/0x12
 [<ffffffff80405e68>] thermal_zone_device_register+0x252/0x2d2
 [<ffffffff88011626>] :thermal:acpi_thermal_add+0x15e/0x42b
 [<ffffffff80364138>] acpi_device_probe+0x45/0x92
 [<ffffffff803aac23>] driver_probe_device+0xc0/0x147
 [<ffffffff803aad55>] ? __driver_attach+0x0/0x94
 [<ffffffff803aadb0>] __driver_attach+0x5b/0x94
 [<ffffffff803a9f55>] bus_for_each_dev+0x4f/0x7f
 [<ffffffff803aaa6e>] driver_attach+0x1c/0x1e
 [<ffffffff803aa81e>] bus_add_driver+0xb7/0x201
 [<ffffffff803aafdb>] driver_register+0x5e/0xd6
 [<ffffffff803644ce>] acpi_bus_register_driver+0x3e/0x40
 [<ffffffff88017061>] :thermal:acpi_thermal_init+0x61/0x83
 [<ffffffff80257120>] sys_init_module+0x98/0x16b
 [<ffffffff8020c0eb>] system_call_after_swapgs+0x7b/0x80


Code: 83 c6 04 41 ff c8 45 85 c0 75 a7 c6 06 00 31 c0 c9 c3 48 8d 47 ff 55 48 83 f8 fd 48 89 e5 76 09 48 8b 05 cc 49 3f 00 eb 0a 31 c0 <80> 7f 08 0f 48 0f 44 c7 c9 c3 55 48 89 f8 48 89 e5 c9 c3 55 31 
RIP  [<ffffffff803590a8>] acpi_ns_map_handle_to_node+0x19/0x23
 RSP <ffff81011de5fc68>
---[ end trace c027ad8802a9e766 ]---
Segmentation fault
-----

Full boot log is at:

http://the.earth.li/~noodles/2.6.25-breakage/meepok.console-2.6.25-rc3.log

Config at:

http://the.earth.li/~noodles/2.6.25-breakage/config-2.6.25-rc3

2.6.25-rc1 and 2.6.25-rc2-git6 both show the same issue.

J.

-- 
                                            jid: noodles@jabber.earth.li
In God we trust; all else we walk through.
