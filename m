Return-Path: <linux-kernel-owner+w=401wt.eu-S934585AbYBTQ3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934585AbYBTQ3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:29:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765624AbYBTQMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:12:15 -0500
Received: from gate.crashing.org ([63.228.1.57]:52955 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765607AbYBTQMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:12:10 -0500
Message-Id: <47B18612-66A3-476C-B81C-F2FD11CE9A64@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: a.zummo@towertech.it
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: state of GEN_RTC vs rtc subsystem
Date: Wed, 20 Feb 2008 10:11:23 -0600
Cc: rtc-linux@googlegroups.com, LKML Kernel <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>, rz@linux-m68k.org
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is the functionality provided by drivers/char/gen_rtc.c completely  
handled by the rtc subsystem in drivers/rtc?

I ask for two reasons:
1. should we make it mutually exclusive in Kconfig
2. I've enabled both and get (we'll my defconfig did):

proc_dir_entry 'rtc' already registered
Call Trace:
[df82bd70] [c0006b8c] show_stack+0x3c/0x1b0 (unreliable)
[df82bda0] [c00cda48] proc_register+0xf8/0x1a0
[df82bdd0] [c00cdc44] create_proc_entry+0x64/0xf0
[df82bdf0] [c024a484] rtc_proc_add_device+0x54/0x90
[df82be00] [c0249048] rtc_device_register+0x1d8/0x220
[df82be40] [c046c0bc] cmos_platform_probe+0x13c/0x3c0
[df82be70] [c01cd524] platform_drv_probe+0x24/0x40
[df82be80] [c01cb15c] driver_probe_device+0xbc/0x200
[df82bea0] [c01cb4ac] __driver_attach+0xcc/0x100
[df82bec0] [c01ca0dc] bus_for_each_dev+0x5c/0xa0
[df82bef0] [c01caf44] driver_attach+0x24/0x40
[df82bf00] [c01cad70] bus_add_driver+0x1f0/0x270
[df82bf20] [c01cb778] driver_register+0x48/0x140
[df82bf40] [c01cd948] platform_driver_register+0x98/0xb0
[df82bf50] [c01cd97c] platform_driver_probe+0x1c/0x90
[df82bf60] [c046bf70] cmos_init+0x20/0x30
[df82bf70] [c0450218] kernel_init+0xa8/0x2b0
[df82bff0] [c000e638] kernel_thread+0x44/0x60
rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0

- k
