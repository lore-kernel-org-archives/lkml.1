Return-Path: <linux-kernel-owner+w=401wt.eu-S1757461AbYGGTDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbYGGTDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 15:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754679AbYGGTDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 15:03:12 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42826 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394AbYGGTDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 15:03:11 -0400
Date: Mon, 7 Jul 2008 20:55:29 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, drzeus-mmc@drzeus.cx
Subject: mmc vs. suspend: WARNING: drivers/base/power/main.c:77
	device_pm_add
Message-ID: <20080707185529.GA1687@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


I got this while suspending with mmc card inserted. 2.6.26-rc8.

rt DPO or FUA
Jul  7 20:29:08 amd kernel: sd 0:0:0:0: [sda] 117210240 512-byte
hardware sectors (60012 MB)
Jul  7 20:29:08 amd kernel: sd 0:0:0:0: [sda] Write Protect is off
Jul  7 20:29:08 amd kernel: sd 0:0:0:0: [sda] Write cache: enabled,
read cache: enabled, doesn't support DPO or FUA
Jul  7 20:29:08 amd kernel: mmc0: new MMC card at address 0001
Jul  7 20:29:08 amd kernel: mmc mmc0:0001: parent mmc0 is sleeping
Jul  7 20:29:08 amd kernel: ------------[ cut here ]------------
Jul  7 20:29:08 amd kernel: WARNING: at
/data/l/linux/drivers/base/power/main.c:77 device_pm_add+0x60/0xd0()
Jul  7 20:29:08 amd kernel: Modules linked in:
Jul  7 20:29:08 amd kernel: Pid: 292, comm: kmmcd Not tainted
2.6.26-rc8 #312
Jul  7 20:29:08 amd kernel:  [<c022910f>] warn_on_slowpath+0x5f/0x90
Jul  7 20:29:08 amd kernel:  [<c0730c4a>] _spin_lock_irqsave+0x3a/0x50
Jul  7 20:29:08 amd kernel:  [<c02405a1>] up+0x11/0x40
Jul  7 20:29:08 amd kernel:  [<c0229a7e>]
release_console_sem+0x19e/0x1d0
Jul  7 20:29:08 amd kernel:  [<c02bcff5>]
sysfs_addrm_finish+0x15/0x1e0
Jul  7 20:29:08 amd kernel:  [<c02bca20>] sysfs_ilookup_test+0x0/0x10
Jul  7 20:29:08 amd kernel:  [<c072f64d>]
mutex_lock_nested+0x13d/0x1f0
Jul  7 20:29:08 amd kernel:  [<c04262b3>] device_pm_add+0x13/0xd0
Jul  7 20:29:08 amd kernel:  [<c04262b3>] device_pm_add+0x13/0xd0
Jul  7 20:29:08 amd kernel:  [<c022a08b>] printk+0x1b/0x20
Jul  7 20:29:08 amd kernel:  [<c0426300>] device_pm_add+0x60/0xd0
Jul  7 20:29:08 amd kernel:  [<c0421528>] device_add+0x388/0x500
Jul  7 20:29:08 amd kernel:  [<c059a191>] mmc_add_card+0xa1/0x120
Jul  7 20:29:08 amd kernel:  [<c059aa3e>] mmc_attach_mmc+0x1ce/0x840
Jul  7 20:29:08 amd kernel:  [<c0599dd0>] mmc_rescan+0x0/0x180
Jul  7 20:29:08 amd kernel:  [<c0599f35>] mmc_rescan+0x165/0x180
Jul  7 20:29:08 amd kernel:  [<c02390d1>] run_workqueue+0x121/0x1d0
Jul  7 20:29:08 amd kernel:  [<c023907d>] run_workqueue+0xcd/0x1d0
Jul  7 20:29:08 amd kernel:  [<c0239a30>] worker_thread+0x0/0xf0
Jul  7 20:29:08 amd kernel:  [<c0239acc>] worker_thread+0x9c/0xf0
Jul  7 20:29:08 amd kernel:  [<c023c6f0>]
autoremove_wake_function+0x0/0x50
Jul  7 20:29:08 amd kernel:  [<c0239a30>] worker_thread+0x0/0xf0
Jul  7 20:29:08 amd kernel:  [<c023c3f2>] kthread+0x42/0x70
Jul  7 20:29:08 amd kernel:  [<c023c3b0>] kthread+0x0/0x70
Jul  7 20:29:08 amd kernel:  [<c02047ab>]
kernel_thread_helper+0x7/0x1c
Jul  7 20:29:08 amd kernel:  =======================
Jul  7 20:29:08 amd kernel: ---[ end trace 24bbd6dd8cd33b0a ]---
Jul  7 20:29:08 amd kernel: mmcblk0: mmc0:0001 MMC    1019392KiB
Jul  7 20:29:08 amd kernel:  mmcblk0: p1

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
