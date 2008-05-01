Return-Path: <linux-kernel-owner+w=401wt.eu-S1764400AbYEATZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764400AbYEATZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 15:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758293AbYEATZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 15:25:31 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:39489 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbYEATZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 15:25:30 -0400
Date: Thu, 1 May 2008 21:25:11 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Subject: 2.6.26-rc0: pcmcia disk changed place, does not work after s2ram
Message-ID: <20080501192432.GA1618@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On thinkpad x60, pcmcia flashcard (CF in pcmcia slot) moved from hda
to hdc. Moreover, it stops working after s2ram/resume.

As a bonus, I now have this in the log after s2ram, but I believe
that's known already.

sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
PM: Writing back config space on device 0000:15:00.2 at offset 4 (was
0, writing e4301800)
PM: Writing back config space on device 0000:15:00.2 at offset 3 (was
800000, writing 804000)
PM: Writing back config space on device 0000:15:00.2 at offset 1 (was
2100000, writing 2100006)
sleepy: scsi_bus_resume start
sleepy: scsi_bus_resume done
mmc0: new SD card at address e624
mmc mmc0:e624: parent mmc0 is sleeping
------------[ cut here ]------------
WARNING: at /data/l/linux/drivers/base/power/main.c:77
device_pm_add+0x60/0xd0()
Modules linked in:
Pid: 293, comm: kmmcd Not tainted 2.6.25 #287
 [<c022a2af>] warn_on_slowpath+0x5f/0x90
 [<c0751dba>] _spin_lock_irqsave+0x3a/0x50
 [<c0241701>] up+0x11/0x40
 [<c022ac2e>] release_console_sem+0x19e/0x1d0
 [<c02bd705>] sysfs_addrm_finish+0x15/0x1e0
 [<c02bd110>] sysfs_ilookup_test+0x0/0x10
 [<c02bd3f1>] sysfs_find_dirent+0x21/0x30
 [<c07507cd>] mutex_lock_nested+0x12d/0x1e0
 [<c0428133>] device_pm_add+0x13/0xd0
 [<c022b23b>] printk+0x1b/0x20
 [<c0428180>] device_pm_add+0x60/0xd0
 [<c04233d8>] device_add+0x388/0x500
 [<c0595171>] mmc_add_card+0xa1/0x120
 [<c0596ce4>] mmc_attach_sd+0x1e4/0x840
 [<c0594db0>] mmc_rescan+0x0/0x180
 [<c0594ed4>] mmc_rescan+0x124/0x180
 [<c023a141>] run_workqueue+0x121/0x1d0
 [<c023a0ed>] run_workqueue+0xcd/0x1d0
 [<c023ab10>] worker_thread+0x0/0xf0
 [<c023abac>] worker_thread+0x9c/0xf0
 [<c023d820>] autoremove_wake_function+0x0/0x50
 [<c023ab10>] worker_thread+0x0/0xf0
 [<c023d522>] kthread+0x42/0x70
 [<c023d4e0>] kthread+0x0/0x70
 [<c02047cb>] kernel_thread_helper+0x7/0x1c
 =======================
---[ end trace 93797a55e35ccd7c ]---
mmcblk0: mmc0:e624 SU128 123008KiB

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
