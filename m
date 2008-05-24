Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbYEXIH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbYEXIH7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 04:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbYEXIHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 04:07:48 -0400
Received: from mx1.ukfsn.org ([77.75.108.10]:45172 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751348AbYEXIHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 04:07:44 -0400
Message-ID: <4837CCC6.3040904@dgreaves.com>
Date: Sat, 24 May 2008 09:07:34 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080406)
MIME-Version: 1.0
To: mingo@elte.hu,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: [REPORT] anticipatory: forced dispatching is broken
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am guessing these things are linked..

[24243.778594] anticipatory: forced dispatching is broken (nr_sorted=1), please
report this

[24243.831710] ------------[ cut here ]------------
[24243.831808] WARNING: at block/blk-barrier.c:252 blk_do_ordered+0x1f0/0x228()
[24243.831901] Modules linked in: lirc_serial lirc_dev dm_mod stv0299 msp3400
saa7127 saa7115 tuner tea5767 tda8290 tda18271 tda827x tuner_xc2028 tda9887
tuner_simple mt20xx tea5761 psmouse budget_ci budget_core ivtv dvb_core saa7146
ttpci_eeprom firmware_class cx2341x tveeprom iTCO_wdt ir_common dcdbas evdev
[24243.832117] Pid: 8774, comm: rsync Not tainted 2.6.25.4-xfspatch-dirty #8
[24243.832117]  [<c0118b8e>] warn_on_slowpath+0x3e/0x51
[24243.832117]  [<c03243dd>] tcp_recvmsg+0x674/0x6ab
[24243.832117]  [<c032fe94>] tcp_v4_send_check+0x7c/0xae
[24243.832117]  [<c02bee02>] sil24_qc_prep+0x148/0x19b
[24243.832117]  [<c02a6251>] scsi_get_cmd_from_req+0x1a/0x36
[24243.832117]  [<c0220779>] elv_dispatch_sort+0x25/0xcc
[24243.832117]  [<c0227fe3>] as_move_to_dispatch+0xc5/0xe8
[24243.832117]  [<c0223c74>] blk_do_ordered+0x1f0/0x228
[24243.832117]  [<c0220c99>] elv_next_request+0x18/0x12f
[24243.832117]  [<c02a6627>] scsi_request_fn+0x64/0x2e2
[24243.832117]  [<c0221974>] blk_run_queue+0x36/0x6e
[24243.832117]  [<c02a5c49>] scsi_next_command+0x25/0x2f
[24243.832117]  [<c02a5cdd>] scsi_end_request+0x5f/0x66
[24243.832117]  [<c02a5fa1>] scsi_io_completion+0x12a/0x2e1
[24243.832117]  [<c02a65be>] scsi_softirq_done+0xb6/0xbb
[24243.832117]  [<c0222b6d>] blk_done_softirq+0x51/0x5d
[24243.832117]  [<c011c964>] __do_softirq+0x35/0x73
[24243.832117]  [<c011c9c4>] do_softirq+0x22/0x26
[24243.832117]  [<c011ca00>] irq_exit+0x29/0x34
[24243.832117]  [<c0105b38>] do_IRQ+0x4e/0x5d
[24243.832117]  [<c01044af>] common_interrupt+0x23/0x28
[24243.832117]  =======================
[24243.832117] ---[ end trace 869513b72e05b190 ]---
[24243.836211] ------------[ cut here ]------------
[24243.836301] WARNING: at block/blk-barrier.c:252 blk_do_ordered+0x1f0/0x228()
[24243.836389] Modules linked in: lirc_serial lirc_dev dm_mod stv0299 msp3400
saa7127 saa7115 tuner tea5767 tda8290 tda18271 tda827x tuner_xc2028 tda9887
tuner_simple mt20xx tea5761 psmouse budget_ci budget_core ivtv dvb_core saa7146
ttpci_eeprom firmware_class cx2341x tveeprom iTCO_wdt ir_common dcdbas evdev
[24243.837508] Pid: 52, comm: kblockd/0 Not tainted 2.6.25.4-xfspatch-dirty #8
[24243.837600]  [<c0118b8e>] warn_on_slowpath+0x3e/0x51
[24243.837717]  [<c0293ada>] tg3_rx+0x32b/0x356
[24243.837833]  [<c0293b7e>] tg3_poll_work+0x79/0x82
[24243.837944]  [<c028ff1a>] tg3_restart_ints+0x11/0x63
[24243.838055]  [<c0293c50>] tg3_poll+0xc9/0x10a
[24243.838165]  [<c03071e3>] net_rx_action+0x9e/0x1b9
[24243.838278]  [<c011c964>] __do_softirq+0x35/0x73
[24243.838390]  [<c011ca00>] irq_exit+0x29/0x34
[24243.838499]  [<c0105b38>] do_IRQ+0x4e/0x5d
[24243.838607]  [<c0223c74>] blk_do_ordered+0x1f0/0x228
[24243.838718]  [<c0220c99>] elv_next_request+0x18/0x12f
[24243.838832]  [<c02a6627>] scsi_request_fn+0x64/0x2e2
[24243.838943]  [<c0114f92>] finish_task_switch+0x1a/0x69
[24243.839057]  [<c022189e>] blk_unplug_work+0x0/0xc
[24243.839168]  [<c022186c>] __generic_unplug_device+0x1a/0x1c
[24243.839283]  [<c022187f>] generic_unplug_device+0x11/0x28
[24243.839395]  [<c02218a9>] blk_unplug_work+0xb/0xc
[24243.839504]  [<c0125348>] run_workqueue+0x83/0x10f
[24243.839616]  [<c0125493>] worker_thread+0xbf/0xcb
[24243.839726]  [<c0127e14>] autoremove_wake_function+0x0/0x2d
[24243.839840]  [<c0114faf>] finish_task_switch+0x37/0x69
[24243.839951]  [<c0127e14>] autoremove_wake_function+0x0/0x2d
[24243.840065]  [<c01253d4>] worker_thread+0x0/0xcb
[24243.840117]  [<c0127965>] kthread+0x33/0x54
[24243.840117]  [<c0127932>] kthread+0x0/0x54
[24243.840117]  [<c010465f>] kernel_thread_helper+0x7/0x10
[24243.840117]  =======================
[24243.840117] ---[ end trace 869513b72e05b190 ]---

No further errors in dmesg.

This is 2.6.25.4-xfspatch-dirty - it has the patch for xfs on partitioned raid
arrays. It also has the external lirc module loaded.

The system was in the process of rsync-restoring 1Tb of data to a new 5x1Tb
raid5 that was running degraded. The filesystem is xfs.

The rsync ended like this:
rsync error: received SIGINT, SIGTERM, or SIGHUP (code 20) at rsync.c(541)
[generator=3.0.2]
rsync error: received SIGUSR1 (code 19) at main.c(1295) [receiver=3.0.2]
which may be linked but I don't have timestamps for that.

David

