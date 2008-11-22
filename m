Return-Path: <linux-kernel-owner+w=401wt.eu-S1758264AbYKVOHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264AbYKVOHw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 09:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757968AbYKVOHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 09:07:43 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:61730 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757961AbYKVOHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 09:07:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=O0PsDOdaQtwSrpQfSltvvWgzsxZB6oYrqLc+HBOG7xQM+nN50w2xsy918a84gSDdeG
         yWw6bhbaNlV0Dtabawm4e4lLgBCMc6IkDM9B6D72tEKGou6TV08Gc8Rxx8GExTKDucAW
         FE9BwctDROIYksEqZlrQrlcpzq8UPAebeFolA=
Message-ID: <49281226.4070006@gmail.com>
Date: Sat, 22 Nov 2008 15:07:34 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: WARNING: at block/blk-barrier.c:246
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

after running mmotm a while, I got this:
------------[ cut here ]------------
WARNING: at /home/l/latest/xxx/block/blk-barrier.c:246 blk_do_ordered+0x281/0x2e
0()
Modules linked in: usblp usbhid ath5k hid mac80211 floppy cfg80211 rtc_cmos [las
t unloaded: freq_table]
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc5-mm1_64 #477
Call Trace:
 <IRQ>  [<ffffffff8023dfef>] warn_on_slowpath+0x5f/0x90
 [<ffffffff8034a22c>] ? elv_rb_del+0x2c/0x50
 [<ffffffff80356020>] ? __cfq_slice_expired+0x60/0xe0
 [<ffffffff80356c9f>] ? cfq_dispatch_requests+0x9f/0x3c0
 [<ffffffff8034f641>] blk_do_ordered+0x281/0x2e0
 [<ffffffff80349ff4>] elv_next_request+0x44/0x250
 [<ffffffff80415a52>] scsi_request_fn+0x72/0x490
 [<ffffffff8034cac7>] blk_invoke_request_fn+0x47/0x140
 [<ffffffff8034cc75>] __blk_run_queue+0x25/0x30
 [<ffffffff8034ccab>] blk_run_queue+0x2b/0x50
 [<ffffffff80414e2f>] scsi_run_queue+0xdf/0x380
 [<ffffffff803eca65>] ? put_device+0x15/0x20
 [<ffffffff8040ef61>] ? __scsi_put_command+0x61/0xa0
 [<ffffffff8041522d>] scsi_next_command+0x3d/0x60
 [<ffffffff80415304>] scsi_end_request+0xb4/0xd0
 [<ffffffff8041543c>] scsi_io_completion+0x11c/0x440
 [<ffffffff8042308d>] ? ata_qc_complete+0xbd/0x230
 [<ffffffff8040ec1c>] scsi_finish_command+0xac/0xe0
 [<ffffffff80415958>] scsi_softirq_done+0xb8/0x140
 [<ffffffff803513e5>] blk_done_softirq+0x75/0x90
 [<ffffffff80258769>] ? ktime_get_ts+0x59/0x60
 [<ffffffff80243d04>] __do_softirq+0x94/0x160
 [<ffffffff8020d77c>] call_softirq+0x1c/0x30
 [<ffffffff8020ea15>] do_softirq+0x45/0x80
 [<ffffffff80243a8d>] irq_exit+0x8d/0xa0
 [<ffffffff8020ecb9>] do_IRQ+0xc9/0x110
 [<ffffffff8020ca36>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80213fe2>] ? default_idle+0x42/0x50
 [<ffffffff8020ae12>] ? enter_idle+0x22/0x30
 [<ffffffff8020aebe>] ? cpu_idle+0x5e/0xb0
 [<ffffffff8057c43c>] ? rest_init+0x5c/0x70
---[ end trace 73ac849f8acff99f ]---
------------[ cut here ]------------
WARNING: at /home/l/latest/xxx/block/blk-barrier.c:246 blk_do_ordered+0x281/0x2e
0()
Modules linked in: usblp usbhid ath5k hid mac80211 floppy cfg80211 rtc_cmos [las
t unloaded: freq_table]
Pid: 134, comm: kblockd/0 Tainted: G        W  2.6.28-rc5-mm1_64 #477
Call Trace:
 [<ffffffff8023dfef>] warn_on_slowpath+0x5f/0x90
 [<ffffffff80364a23>] ? sg_init_table+0x23/0x50
 [<ffffffff80359309>] ? __next_cpu+0x19/0x30
 [<ffffffff8034f641>] blk_do_ordered+0x281/0x2e0
 [<ffffffff80349ff4>] elv_next_request+0x44/0x250
 [<ffffffff80415a52>] scsi_request_fn+0x72/0x490
 [<ffffffff8034c2fb>] __generic_unplug_device+0x2b/0x40
 [<ffffffff8034c339>] generic_unplug_device+0x29/0x40
 [<ffffffff8034af2b>] blk_unplug_work+0x5b/0x70
 [<ffffffff8034aed0>] ? blk_unplug_work+0x0/0x70
 [<ffffffff802508c0>] run_workqueue+0x70/0x120
 [<ffffffff80250b77>] worker_thread+0xa7/0x120
 [<ffffffff80254ee0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff80250ad0>] ? worker_thread+0x0/0x120
 [<ffffffff80254ac9>] kthread+0x49/0x90
 [<ffffffff8020d419>] child_rip+0xa/0x11
 [<ffffffff80254a80>] ? kthread+0x0/0x90
 [<ffffffff8020d40f>] ? child_rip+0x0/0x11
---[ end trace 73ac849f8acff99f ]---
------------[ cut here ]------------
WARNING: at /home/l/latest/xxx/block/blk-barrier.c:246 blk_do_ordered+0x281/0x2e
0()
Modules linked in: usblp usbhid ath5k hid mac80211 floppy cfg80211 rtc_cmos [las
t unloaded: freq_table]
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc5-mm1_64 #477
Call Trace:
 <IRQ>  [<ffffffff8023dfef>] warn_on_slowpath+0x5f/0x90
 [<ffffffff8034a22c>] ? elv_rb_del+0x2c/0x50
 [<ffffffff80356020>] ? __cfq_slice_expired+0x60/0xe0
 [<ffffffff80356c9f>] ? cfq_dispatch_requests+0x9f/0x3c0
 [<ffffffff8034f641>] blk_do_ordered+0x281/0x2e0
 [<ffffffff80349ff4>] elv_next_request+0x44/0x250
 [<ffffffff80415a52>] scsi_request_fn+0x72/0x490
 [<ffffffff8034cac7>] blk_invoke_request_fn+0x47/0x140
 [<ffffffff8034cc75>] __blk_run_queue+0x25/0x30
 [<ffffffff8034ccab>] blk_run_queue+0x2b/0x50
 [<ffffffff80414e2f>] scsi_run_queue+0xdf/0x380
 [<ffffffff803eca65>] ? put_device+0x15/0x20
 [<ffffffff8040ef61>] ? __scsi_put_command+0x61/0xa0
 [<ffffffff8041522d>] scsi_next_command+0x3d/0x60
 [<ffffffff80415304>] scsi_end_request+0xb4/0xd0
 [<ffffffff8041543c>] scsi_io_completion+0x11c/0x440
 [<ffffffff8042308d>] ? ata_qc_complete+0xbd/0x230
 [<ffffffff8040ec1c>] scsi_finish_command+0xac/0xe0
 [<ffffffff80415958>] scsi_softirq_done+0xb8/0x140
 [<ffffffff803513e5>] blk_done_softirq+0x75/0x90
 [<ffffffff80258769>] ? ktime_get_ts+0x59/0x60
 [<ffffffff80243d04>] __do_softirq+0x94/0x160
 [<ffffffff8020d77c>] call_softirq+0x1c/0x30
 [<ffffffff8020ea15>] do_softirq+0x45/0x80
 [<ffffffff80243a8d>] irq_exit+0x8d/0xa0
 [<ffffffff8020ecb9>] do_IRQ+0xc9/0x110
 [<ffffffff8020ca36>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80213fe2>] ? default_idle+0x42/0x50
 [<ffffffff8020ae12>] ? enter_idle+0x22/0x30
 [<ffffffff8020aebe>] ? cpu_idle+0x5e/0xb0
 [<ffffffff8057c43c>] ? rest_init+0x5c/0x70
---[ end trace 73ac849f8acff99f ]---
------------[ cut here ]------------
WARNING: at /home/l/latest/xxx/block/blk-barrier.c:246 blk_do_ordered+0x281/0x2e
0()
Modules linked in: usblp usbhid ath5k hid mac80211 floppy cfg80211 rtc_cmos [las
t unloaded: freq_table]
Pid: 134, comm: kblockd/0 Tainted: G        W  2.6.28-rc5-mm1_64 #477
Call Trace:
 [<ffffffff8023dfef>] warn_on_slowpath+0x5f/0x90
 [<ffffffff80364a23>] ? sg_init_table+0x23/0x50
 [<ffffffff80359309>] ? __next_cpu+0x19/0x30
 [<ffffffff8034f641>] blk_do_ordered+0x281/0x2e0
 [<ffffffff80349ff4>] elv_next_request+0x44/0x250
 [<ffffffff80415a52>] scsi_request_fn+0x72/0x490
 [<ffffffff8034c2fb>] __generic_unplug_device+0x2b/0x40
 [<ffffffff8034c339>] generic_unplug_device+0x29/0x40
 [<ffffffff8034af2b>] blk_unplug_work+0x5b/0x70
 [<ffffffff8034aed0>] ? blk_unplug_work+0x0/0x70
 [<ffffffff802508c0>] run_workqueue+0x70/0x120
 [<ffffffff80250b77>] worker_thread+0xa7/0x120
 [<ffffffff80254ee0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff80250ad0>] ? worker_thread+0x0/0x120
 [<ffffffff80254ac9>] kthread+0x49/0x90
 [<ffffffff8020d419>] child_rip+0xa/0x11
 [<ffffffff80254a80>] ? kthread+0x0/0x90
 [<ffffffff8020d40f>] ? child_rip+0x0/0x11
---[ end trace 73ac849f8acff99f ]---
------------[ cut here ]------------
WARNING: at /home/l/latest/xxx/block/blk-barrier.c:246 blk_do_ordered+0x281/0x2e
0()
Modules linked in: usblp usbhid ath5k hid mac80211 floppy cfg80211 rtc_cmos [las
t unloaded: freq_table]
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc5-mm1_64 #477
Call Trace:
 <IRQ>  [<ffffffff8023dfef>] warn_on_slowpath+0x5f/0x90
 [<ffffffff8034a22c>] ? elv_rb_del+0x2c/0x50
 [<ffffffff80356020>] ? __cfq_slice_expired+0x60/0xe0
 [<ffffffff80356c9f>] ? cfq_dispatch_requests+0x9f/0x3c0
 [<ffffffff8034f641>] blk_do_ordered+0x281/0x2e0
 [<ffffffff80349ff4>] elv_next_request+0x44/0x250
 [<ffffffff80415a52>] scsi_request_fn+0x72/0x490
 [<ffffffff8034cac7>] blk_invoke_request_fn+0x47/0x140
 [<ffffffff8034cc75>] __blk_run_queue+0x25/0x30
 [<ffffffff8034ccab>] blk_run_queue+0x2b/0x50
 [<ffffffff80414e2f>] scsi_run_queue+0xdf/0x380
 [<ffffffff803eca65>] ? put_device+0x15/0x20
 [<ffffffff8040ef61>] ? __scsi_put_command+0x61/0xa0
 [<ffffffff8041522d>] scsi_next_command+0x3d/0x60
 [<ffffffff80415304>] scsi_end_request+0xb4/0xd0
 [<ffffffff8041543c>] scsi_io_completion+0x11c/0x440
 [<ffffffff8042308d>] ? ata_qc_complete+0xbd/0x230
 [<ffffffff8040ec1c>] scsi_finish_command+0xac/0xe0
 [<ffffffff80415958>] scsi_softirq_done+0xb8/0x140
 [<ffffffff803513e5>] blk_done_softirq+0x75/0x90
 [<ffffffff80258769>] ? ktime_get_ts+0x59/0x60
 [<ffffffff80243d04>] __do_softirq+0x94/0x160
 [<ffffffff8020d77c>] call_softirq+0x1c/0x30
 [<ffffffff8020ea15>] do_softirq+0x45/0x80
 [<ffffffff80243a8d>] irq_exit+0x8d/0xa0
 [<ffffffff8020ecb9>] do_IRQ+0xc9/0x110
 [<ffffffff8020ca36>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80213fe2>] ? default_idle+0x42/0x50
 [<ffffffff8020ae12>] ? enter_idle+0x22/0x30
 [<ffffffff8020aebe>] ? cpu_idle+0x5e/0xb0
 [<ffffffff8057c43c>] ? rest_init+0x5c/0x70
---[ end trace 73ac849f8acff99f ]---
------------[ cut here ]------------
WARNING: at /home/l/latest/xxx/block/blk-barrier.c:246 blk_do_ordered+0x281/0x2e
0()
Modules linked in: usblp usbhid ath5k hid mac80211 floppy cfg80211 rtc_cmos [las
t unloaded: freq_table]
Pid: 134, comm: kblockd/0 Tainted: G        W  2.6.28-rc5-mm1_64 #477
Call Trace:
 [<ffffffff8023dfef>] warn_on_slowpath+0x5f/0x90
 [<ffffffff80364a23>] ? sg_init_table+0x23/0x50
 [<ffffffff80350d9d>] ? blk_rq_map_sg+0x8d/0x2e0
 [<ffffffff80359309>] ? __next_cpu+0x19/0x30
 [<ffffffff8034f641>] blk_do_ordered+0x281/0x2e0
 [<ffffffff80349ff4>] elv_next_request+0x44/0x250
 [<ffffffff80415a52>] scsi_request_fn+0x72/0x490
 [<ffffffff8034c2fb>] __generic_unplug_device+0x2b/0x40
 [<ffffffff8034c339>] generic_unplug_device+0x29/0x40
 [<ffffffff8034af2b>] blk_unplug_work+0x5b/0x70
 [<ffffffff8034aed0>] ? blk_unplug_work+0x0/0x70
 [<ffffffff802508c0>] run_workqueue+0x70/0x120
 [<ffffffff80250b77>] worker_thread+0xa7/0x120
 [<ffffffff80254ee0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff80250ad0>] ? worker_thread+0x0/0x120
 [<ffffffff80254ac9>] kthread+0x49/0x90
 [<ffffffff8020d419>] child_rip+0xa/0x11
 [<ffffffff80254a80>] ? kthread+0x0/0x90
 [<ffffffff8020d40f>] ? child_rip+0x0/0x11
---[ end trace 73ac849f8acff99f ]---

