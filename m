Return-Path: <linux-kernel-owner+w=401wt.eu-S1763402AbXHIUZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763402AbXHIUZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 16:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754195AbXHIUYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 16:24:50 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:28770 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbXHIUYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 16:24:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=urwdsItwrsP6xVEFX3wXzQiniqLf8MqLR125OsgYJHzyY3RooYZrNxdqHOIgtSXQYiFRiyrRvEZYpdTfNSSdcF7tURfEYIkYcEJF78X/gNGOrsrTYjJQj3RSz8uu7WqkU6tVlIt1waCQb0WpRL+J3jmwWlMyMsTNGXMP4zoQ8WU=
Message-ID: <a44ae5cd0708091324w4f990d3fo364e01207d52200a@mail.gmail.com>
Date: Thu, 9 Aug 2007 16:24:48 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "ACPI Devel Maling List" <linux-acpi@vger.kernel.org>
Subject: 2.6.23-rc2-mm1 -- INFO: possible circular locking dependency detected
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ INFO: possible circular locking dependency detected ]
2.6.23-rc2-mm1 #7
-------------------------------------------------------
kacpid/53 is trying to acquire lock:
 (&ec->lock){--..}, at: [<c03031a7>] mutex_lock+0x1c/0x1f

but task is already holding lock:
 (&dpc->work){--..}, at: [<c012689d>] run_workqueue+0xa0/0x182

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&dpc->work){--..}:
       [<c0133d24>] __lock_acquire+0x9a6/0xb6f
       [<c0133f4e>] lock_acquire+0x61/0x7d
       [<c01268b2>] run_workqueue+0xb5/0x182
       [<c01271a9>] worker_thread+0xb7/0xc2
       [<c01296c4>] kthread+0x39/0x61
       [<c0104913>] kernel_thread_helper+0x7/0x10
       [<ffffffff>] 0xffffffff

-> #1 (kacpid){--..}:
       [<c0133d24>] __lock_acquire+0x9a6/0xb6f
       [<c0133f4e>] lock_acquire+0x61/0x7d
       [<c0126f62>] flush_workqueue+0x2d/0x4f
       [<c01e85e0>] acpi_os_wait_events_complete+0xd/0xf
       [<c01ef605>] acpi_remove_gpe_handler+0x7b/0xdd
       [<c0205981>] ec_remove_handlers+0x26/0x29
       [<c02062b4>] acpi_ec_add+0x8f/0x13e
       [<c0205477>] acpi_device_probe+0x3e/0xdb
       [<c023c4c8>] driver_probe_device+0xd7/0x14d
       [<c023c652>] __driver_attach+0x6a/0xa1
       [<c023baaa>] bus_for_each_dev+0x36/0x5b
       [<c023c32e>] driver_attach+0x14/0x16
       [<c023bd7e>] bus_add_driver+0x70/0x16c
       [<c023c82d>] driver_register+0x60/0x65
       [<c020577b>] acpi_bus_register_driver+0x3a/0x3c
       [<c04292e4>] acpi_ec_init+0x36/0x55
       [<c0416650>] kernel_init+0xc5/0x20f
       [<c0104913>] kernel_thread_helper+0x7/0x10
       [<ffffffff>] 0xffffffff

-> #0 (&ec->lock){--..}:
       [<c0133c44>] __lock_acquire+0x8c6/0xb6f
       [<c0133f4e>] lock_acquire+0x61/0x7d
       [<c0303006>] __mutex_lock_slowpath+0xbc/0x241
       [<c03031a7>] mutex_lock+0x1c/0x1f
       [<c0205bbd>] acpi_ec_transaction+0x65/0x1c1
       [<c0205d44>] acpi_ec_gpe_query+0x2b/0xab
       [<c01e8602>] acpi_os_execute_deferred+0x20/0x31
       [<c01268b7>] run_workqueue+0xba/0x182
       [<c01271a9>] worker_thread+0xb7/0xc2
       [<c01296c4>] kthread+0x39/0x61
       [<c0104913>] kernel_thread_helper+0x7/0x10
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

2 locks held by kacpid/53:
 #0:  (kacpid){--..}, at: [<c0126882>] run_workqueue+0x85/0x182
 #1:  (&dpc->work){--..}, at: [<c012689d>] run_workqueue+0xa0/0x182

stack backtrace:
 [<c0104c6a>] show_trace_log_lvl+0x12/0x25
 [<c0105552>] show_trace+0xd/0x10
 [<c0105656>] dump_stack+0x15/0x17
 [<c0132580>] print_circular_bug_tail+0x5a/0x65
 [<c0133c44>] __lock_acquire+0x8c6/0xb6f
 [<c0133f4e>] lock_acquire+0x61/0x7d
 [<c0303006>] __mutex_lock_slowpath+0xbc/0x241
 [<c03031a7>] mutex_lock+0x1c/0x1f
 [<c0205bbd>] acpi_ec_transaction+0x65/0x1c1
 [<c0205d44>] acpi_ec_gpe_query+0x2b/0xab
 [<c01e8602>] acpi_os_execute_deferred+0x20/0x31
 [<c01268b7>] run_workqueue+0xba/0x182
 [<c01271a9>] worker_thread+0xb7/0xc2
 [<c01296c4>] kthread+0x39/0x61
 [<c0104913>] kernel_thread_helper+0x7/0x10
 =======================
