Return-Path: <linux-kernel-owner+w=401wt.eu-S1755222AbYFCNcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbYFCNcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 09:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYFCNcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 09:32:24 -0400
Received: from mail.gmx.net ([213.165.64.20]:35465 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751413AbYFCNcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 09:32:23 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+dw1kYyCidO8wL4vb56mcrJFW49q561hVfhUVRty
	JH6M87lDr5BmWD
Date: Tue, 3 Jun 2008 15:32:39 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
cc: David Brownell <david-b@pacbell.net>
Subject: [WARNING] local_bh_enable with irqs disabled:
Message-ID: <Pine.LNX.4.64.0806031529520.21106@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

got this whem rmmod-ing a gpiochip driver. IRQs were disabled in 
gpiochip_remove().

------------[ cut here ]------------
WARNING: at kernel/softirq.c:141 local_bh_enable+0x8c/0xac()
Modules linked in: max7301(-) pxa2xx_spi vfat fat usbhid
[<c0024bd0>] (dump_stack+0x0/0x14) from [<c0032068>] (warn_on_slowpath+0x4c/0x68)
[<c003201c>] (warn_on_slowpath+0x0/0x68) from [<c003823c>] (local_bh_enable+0x8c/0xac)
 r6:c3eac1e0 r5:c03195f0 r4:c3dde000
[<c00381b0>] (local_bh_enable+0x0/0xac) from [<c01f2764>] (sk_filter+0x34/0x94)
 r5:c3eac1e0 r4:00000000
[<c01f2730>] (sk_filter+0x0/0x94) from [<c01f55b0>] (netlink_broadcast+0x1a4/0x438)
 r5:c3db2010 r4:c3db2000
[<c01f540c>] (netlink_broadcast+0x0/0x438) from [<c0115e18>] (kobject_uevent_env+0x338/0x3ec)
[<c0115ae0>] (kobject_uevent_env+0x0/0x3ec) from [<c0115ee0>] (kobject_uevent+0x14/0x18)
[<c0115ecc>] (kobject_uevent+0x0/0x18) from [<c01538c0>] (device_del+0x13c/0x16c)
[<c0153784>] (device_del+0x0/0x16c) from [<c0153908>] (device_unregister+0x18/0x24)
 r6:40000013 r5:c3eab000 r4:c3eab000
[<c01538f0>] (device_unregister+0x0/0x24) from [<c01258b0>] (gpiochip_remove+0xa0/0x13c)
 r4:c3cfb0dc
[<c0125810>] (gpiochip_remove+0x0/0x13c) from [<bf01d0cc>] (max7301_remove+0x40/0x80 [max7301])
 r6:ffffffed r5:c3eade00 r4:c3cfb0c0
[<bf01d08c>] (max7301_remove+0x0/0x80 [max7301]) from [<c0179888>] (spi_drv_remove+0x24/0x28)
 r6:c3dde000 r5:bf01dcac r4:c3eade00
[<c0179864>] (spi_drv_remove+0x0/0x28) from [<c0155c7c>] (__device_release_driver+0x6c/0xa0)
[<c0155c10>] (__device_release_driver+0x0/0xa0) from [<c01561a8>] (driver_detach+0xcc/0xe0)
 r5:c3eade00 r4:c3eadea8
[<c01560dc>] (driver_detach+0x0/0xe0) from [<c0154ed8>] (bus_remove_driver+0x94/0xbc)
 r7:00000000 r6:c030be4c r5:bf01dcac r4:bf01dce0
[<c0154e44>] (bus_remove_driver+0x0/0xbc) from [<c0156234>] (driver_unregister+0x48/0x4c)
 r6:c3dde000 r5:bf01dcac r4:bf01dce0
[<c01561ec>] (driver_unregister+0x0/0x4c) from [<bf01d428>] (max7301_exit+0x14/0x1c [max7301])
 r5:00000000 r4:bf01dce0
[<bf01d414>] (max7301_exit+0x0/0x1c [max7301]) from [<c005a298>] (sys_delete_module+0x150/0x210)
[<c005a148>] (sys_delete_module+0x0/0x210) from [<c0020c00>] (ret_fast_syscall+0x0/0x2c)
 r8:c0020d84 r7:00000081 r6:bec61470 r5:bec61458 r4:bec63c70
---[ end trace 392ec5662fd4fd48 ]---

Thanks
Guennadi
---
Guennadi Liakhovetski
