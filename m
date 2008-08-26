Return-Path: <linux-kernel-owner+w=401wt.eu-S1758473AbYHZQDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473AbYHZQDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 12:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755648AbYHZQDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 12:03:09 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:34870 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755857AbYHZQDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 12:03:08 -0400
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.2
To: linux-kernel@vger.kernel.org
Subject: 2.6.25.15 bug?
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Tue, 26 Aug 2008 18:03:02 +0200
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080826160303.BA84E93CB6E@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.237.76
X-Scan-Result: No virus found in message 1KY10c-00036O-9T.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1KY10c-00036O-9T a9b4861a65808014bea69c86a9afba3e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Trying to track down a hard freeze bug, I enabled various hacker options. This 
one turned up in dmesg. I'm pretty sure it souldn't be there. 

This on seems to be unrealted to the bug I'm hunting though...


kobject: 'vcsa11' (d643fed8): kobject_uevent_env
kobject: 'vcsa11' (d643fed8): fill_kobj_path: path = '/class/vc/vcsa11'
IRQ handler type mismatch for IRQ 3
current handler: MPU401 UART
Pid: 4799, comm: hald-probe-seri Not tainted 2.6.25.15 #30
 [<c013d4e7>] setup_irq+0x1a4/0x1bc
 [<c013d644>] request_irq+0xc7/0xe5
 [<c023a18f>] ? serial8250_interrupt+0x0/0x114
 [<c0239f9d>] serial8250_startup+0x3b6/0x50d
 [<c02360c0>] uart_startup+0x70/0x125
 [<c023766d>] uart_open+0x158/0x390
 [<c0399705>] ? _spin_unlock+0x27/0x3c
 [<c02257e1>] ? check_tty_count+0x3b/0x8a
 [<c0228df9>] tty_open+0x164/0x2a9
 [<c015e60c>] chrdev_open+0x140/0x18c
 [<c015ad28>] __dentry_open+0xfb/0x1ad
 [<c015adf9>] nameidata_to_filp+0x1f/0x33
 [<c015e4cc>] ? chrdev_open+0x0/0x18c
 [<c015ae3b>] do_filp_open+0x2e/0x35
 [<c015ac17>] ? get_unused_fd_flags+0xcc/0xd6
 [<c0399705>] ? _spin_unlock+0x27/0x3c
 [<c015ae84>] do_sys_open+0x42/0xbc
 [<c015af40>] sys_open+0x1e/0x26
 [<c0102aba>] sysenter_past_esp+0x5f/0xa5
 =======================
kobject: 'microcode' (dc839e28): kobject_add_internal: parent: 'module', set: 'module'
kobject: 'holders' (d6072c30): kobject_add_internal: parent: 'microcode', set: '<NULL>'
kobject: 'microcode' (dc839e28): kobject_uevent_env
kobject: 'microcode' (dc839e28): fill_kobj_path: path = '/module/microcode'


