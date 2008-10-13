Return-Path: <linux-kernel-owner+w=401wt.eu-S1760715AbYJMXZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760715AbYJMXZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 19:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756113AbYJMXZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 19:25:32 -0400
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:34109 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753952AbYJMXZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 19:25:31 -0400
Message-ID: <48F3D8EA.4080708@lwfinger.net>
Date: Mon, 13 Oct 2008 16:25:30 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Stack dump from GIT HEAD if CONFIG_ATA_SFF is not set
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am using kernel 2.6.27-Linus-03151-g4480f15b-dirty. On booting a system built
with CONFIG_ATA_SFF not set, the following appears in my dmesg output. The
"dirtiness" of the kernel is due to some code included to trace down messages
coming from the usb system, and is not involved here. If CONFIG_ATA_SFF=y, the
message does not appear. From Google results, it seems that this parameter
should be set for most systems, but one should get clean runs without it.

ata1: SATA max UDMA/133 abar m8192@0xfc484000 port 0xfc484100 irq 4349
ata2: SATA max UDMA/133 abar m8192@0xfc484000 port 0xfc484180 irq 4349
ata3: SATA max UDMA/133 abar m8192@0xfc484000 port 0xfc484200 irq 4349
ata4: SATA max UDMA/133 abar m8192@0xfc484000 port 0xfc484280 irq 4349
INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
Pid: 504, comm: scsi_eh_0 Not tainted 2.6.27-Linus-03151-g4480f15b-dirty #174
Call Trace:
 [<ffffffff80255af9>] static_obj+0x51/0x6b
 [<ffffffff80258d16>] __lock_acquire+0xd28/0x142f
 [<ffffffff8022f003>] find_busiest_group+0x329/0x7da
 [<ffffffff8025946f>] lock_acquire+0x52/0x6b
 [<ffffffff802483de>] __cancel_work_timer+0xbf/0x1e6
 [<ffffffff80248415>] __cancel_work_timer+0xf6/0x1e6
 [<ffffffff802483de>] __cancel_work_timer+0xbf/0x1e6
 [<ffffffff8025776c>] trace_hardirqs_on_caller+0xef/0x113
 [<ffffffff8041e3e8>] _spin_unlock_irq+0x24/0x27
 [<ffffffff80234882>] finish_task_switch+0x5f/0xc5
 [<ffffffff80234823>] finish_task_switch+0x0/0xc5
 [<ffffffff8041c18a>] thread_return+0x3d/0xbe
 [<ffffffffa0034dd6>] ata_port_flush_task+0x10/0x3b [libata]
 [<ffffffffa0041d4d>] ata_scsi_error+0x20/0x57b [libata]
 [<ffffffff8041e3e8>] _spin_unlock_irq+0x24/0x27
 [<ffffffff80234823>] finish_task_switch+0x0/0xc5
 [<ffffffffa000c68a>] scsi_error_handler+0xda/0x535 [scsi_mod]
 [<ffffffffa000c5b0>] scsi_error_handler+0x0/0x535 [scsi_mod]
 [<ffffffff8024b2a3>] kthread+0x47/0x73
 [<ffffffff8041e05e>] trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8020ce79>] child_rip+0xa/0x11
 [<ffffffff8020c4af>] restore_args+0x0/0x30
 [<ffffffff8024b237>] kthreadd+0x174/0x199
 [<ffffffff8024b25c>] kthread+0x0/0x73
 [<ffffffff8020ce6f>] child_rip+0x0/0x11
input: PS/2 Mouse as /class/input/input2
input: AlpsPS/2 ALPS GlidePoint as /class/input/input3
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-8: TOSHIBA MK2546GSX, LB014C, max UDMA/100



Larry

