Return-Path: <linux-kernel-owner+w=401wt.eu-S1753363AbZLAPKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbZLAPKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 10:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbZLAPKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 10:10:54 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47154 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbZLAPKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 10:10:53 -0500
Date: Tue, 1 Dec 2009 16:10:52 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: linux-bluetooth@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Subject: warn_on in mutex_lock_nested after hciattach
Message-ID: <20091201151052.GB2262@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I get this, repeatably.

								Pavel

root@amd:~# setserial /dev/ttyBT baud_base 921600
root@amd:~# hciattach -s 921600 /dev/ttyS0 bcsp
Device setup complete
root@amd:~# ------------[ cut here ]------------
WARNING: at kernel/mutex.c:207 mutex_lock_nested+0x219/0x230()
Hardware name: 17097HU
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.32-rc8-00165-g2471433-dirty #92
Call Trace:
 [<c07824d9>] ? printk+0x18/0x1a
 [<c07843c9>] ? mutex_lock_nested+0x219/0x230
 [<c023131c>] warn_slowpath_common+0x6c/0xc0
 [<c07843c9>] ? mutex_lock_nested+0x219/0x230
 [<c0231385>] warn_slowpath_null+0x15/0x20
 [<c07843c9>] mutex_lock_nested+0x219/0x230
 [<c03e1afb>] ? tty_unthrottle+0x1b/0x50
 [<c0594bf2>] ? hci_uart_tty_receive+0x62/0x70
 [<c03e1afb>] tty_unthrottle+0x1b/0x50
 [<c0594bf9>] hci_uart_tty_receive+0x69/0x70
 [<c03e380b>] flush_to_ldisc+0x15b/0x190
 [<c03e38ab>] tty_flip_buffer_push+0x6b/0x80
 [<c0443587>] serial8250_handle_port+0x197/0x230
 [<c078545a>] ? _spin_lock+0x3a/0x40
 [<c044368e>] serial8250_interrupt+0x6e/0xf0
 [<c026801e>] handle_IRQ_event+0x2e/0xc0
 [<c0269ac4>] handle_fasteoi_irq+0x64/0xd0
 [<c02053fa>] handle_irq+0x1a/0x30
 [<c0204bb6>] do_IRQ+0x46/0xc0
 [<c024abb2>] ? sched_clock_local+0xd2/0x170
 [<c02034a9>] common_interrupt+0x29/0x30
 [<c024007b>] ? sys_setpgid+0xfb/0x180
 [<c03cf298>] ? acpi_idle_enter_simple+0x132/0x15d
 [<c03cef8b>] acpi_idle_enter_bm+0xc3/0x29e
 [<c05a360d>] cpuidle_idle_call+0x7d/0xc0
 [<c0201efd>] cpu_idle+0x4d/0x80
 [<c075e943>] rest_init+0x53/0x60
 [<c0a5981a>] start_kernel+0x272/0x2ad
 [<c0a5936e>] ? unknown_bootoption+0x0/0x1e9
 [<c0a5906b>] i386_start_kernel+0x6b/0x6d
---[ end trace bab0b3b26c16fcf5 ]---


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
