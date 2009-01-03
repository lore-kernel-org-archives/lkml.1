Return-Path: <linux-kernel-owner+w=401wt.eu-S932579AbZACDYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579AbZACDYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 22:24:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758848AbZACDY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 22:24:26 -0500
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:54152 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758842AbZACDYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 22:24:25 -0500
Message-ID: <495EDA5E.3090506@lwfinger.net>
Date: Fri, 02 Jan 2009 21:24:14 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Kernel warning from latest 2.6.28-gitX
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel v2.6.28-5356-g6680598 generates the following warning at bootup:

WARNING: at kernel/lockdep.c:2197 trace_hardirqs_on_caller+0xb8/0x138()
Hardware name: HP Pavilion dv2700 Notebook PC
Modules linked in: ide_cd_mod(+) k8temp joydev soundcore cfg80211
serio_raw hwmon wmi button battery ac forcedeth snd_page_alloc cdrom
sg sd_mod ohci_hcd uhci_hcd ehci_hcd usbcore edd ext3 mbcache jbd fan
amd74xx ide_core ahci libata scsi_mod thermal processor
Pid: 1243, comm: udevd Not tainted 2.6.28-Linus-05356-g6680598 #28
Call Trace:
 <IRQ>  [<ffffffff8023dde7>] warn_slowpath+0xb6/0xf2
 [<ffffffff8045b152>] ? _spin_unlock_irqrestore+0x3d/0x4c
 [<ffffffff80231af5>] ? enqueue_entity+0x118/0x120
 [<ffffffff8025e6fa>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa00a13bc>] ? ide_do_drive_cmd+0x35/0x69 [ide_core]
 [<ffffffff8045b110>] ? _spin_unlock_irq+0x30/0x35
 [<ffffffff8025fe38>] trace_hardirqs_on_caller+0xb8/0x138
 [<ffffffff8025fec5>] trace_hardirqs_on+0xd/0xf
 [<ffffffff8045b110>] _spin_unlock_irq+0x30/0x35
 [<ffffffffa00a19a8>] do_ide_request+0x58/0x5ac [ide_core]
 [<ffffffff80322273>] blk_start_queueing+0x22/0x2b
 [<ffffffffa00a13d9>] ide_do_drive_cmd+0x52/0x69 [ide_core]
 [<ffffffffa022287c>] cdrom_queue_request_sense+0x93/0x9f [ide_cd_mod]
 [<ffffffffa0222b86>] cdrom_decode_status+0x2fe/0x320 [ide_cd_mod]
 [<ffffffffa02231d8>] cdrom_newpc_intr+0x98/0x5a8 [ide_cd_mod]
 [<ffffffffa0223140>] ? cdrom_newpc_intr+0x0/0x5a8 [ide_cd_mod]
 [<ffffffffa00a15a2>] ide_intr+0x16b/0x1e4 [ide_core]
 [<ffffffff8027967d>] handle_IRQ_event+0x25/0x5a
 [<ffffffff8027a9fb>] handle_edge_irq+0xe7/0x12d
 [<ffffffff8045bb9d>] __irqentry_text_start+0x75/0xe9
 [<ffffffff8020cd13>] ret_from_intr+0x0/0xf
 <EOI> <4>---[ end trace ac9dde4da52e7265 ]---
