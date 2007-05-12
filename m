Return-Path: <linux-kernel-owner+w=401wt.eu-S1762488AbXELAVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762488AbXELAVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 20:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755741AbXELAVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 20:21:35 -0400
Received: from waste.org ([66.93.16.53]:36878 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755422AbXELAVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 20:21:35 -0400
Date: Fri, 11 May 2007 19:21:15 -0500
From: Matt Mackall <mpm@selenic.com>
To: akpm@linux-foundation.org, rlove@rlove.org
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.21-mm2: HDAPS? BUG: at kernel/mutex.c:311
Message-ID: <20070512002115.GZ11166@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This just hit:

[    7.856000] usbcore: registered new interface driver usbhid
[    7.860000] BUG: at kernel/mutex.c:311 __mutex_trylock_slowpath()
[    7.868000]  [<c0104584>] show_trace_log_lvl+0x1a/0x30
[    7.872000]  [<c0105196>] show_trace+0x12/0x14
[    7.876000]  [<c0105222>] dump_stack+0x15/0x17
[    7.880000]  [<c03cd4c8>] mutex_trylock+0x56/0x15a
[    7.888000]  [<c03172c5>] hdaps_mousedev_poll+0x10/0xcb
[    7.892000]  [<c011f8c5>] run_timer_softirq+0x10e/0x16f
[    7.896000]  [<c011cabc>] __do_softirq+0x5d/0xc0
[    7.900000]  [<c0105c88>] do_softirq+0x6e/0xf0
[    7.904000]  [<c011ca22>] irq_exit+0x3e/0x7b
[    7.912000]  [<c0105da7>] do_IRQ+0x9d/0xb2
[    7.916000]  [<c01040fa>] common_interrupt+0x2e/0x34
[    7.920000]  [<c0118e5f>] printk+0x1b/0x1d
[    7.924000]  [<c02f2f96>] usb_register_driver+0xa0/0xe5
[    7.928000]  [<c0525018>] hid_init+0x28/0x51
[    7.932000]  [<c050e6c4>] kernel_init+0xbc/0x23e
[    7.940000]  [<c010420f>] kernel_thread_helper+0x7/0x10
[    7.944000]  =======================
[    7.948000] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver

Looks like it's triggered by the HDAPS driver.

-- 
Mathematics is the supreme nostalgia of our time.
