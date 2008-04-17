Return-Path: <linux-kernel-owner+w=401wt.eu-S1756676AbYDQAlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbYDQAlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 20:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbYDQAkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 20:40:51 -0400
Received: from main.gmane.org ([80.91.229.2]:56316 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbYDQAku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 20:40:50 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Marcus Furlong <furlongm@hotmail.com>
Subject: [BUG] 2.6.25-rc9 Oops (keyboard/mouse related)
Date: Thu, 17 Apr 2008 01:40:35 +0100
Message-ID: <fu66a8$flv$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 84-203-37-37.mysmart.ie
User-Agent: KNode/0.10.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got the following oops on 2.6.25-rc9. The mouse/keyboard are
consistently "jerky" and unresponsive, and between 1 and 15 minutes after
booting the machine hangs.

Possibly the same on 2.6.24.*, I only tried it once and it hung and I had no
more time for testing until now. No problem on 2.6.23.17.

[  854.789883] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  854.792850] Modules linked in: i915 drm iwl3945 mac80211 cfg80211
intel_agp agpgart scsi_wait_scan
[  854.792850] 
[  854.792850] Pid: 9, comm: events/0 Not tainted (2.6.25-rc9 #2)
[  854.792850] EIP: 0060:[<c039e62f>] EFLAGS: 00010093 CPU: 0
[  854.792850] EIP is at alps_process_byte+0x1f/0x80
[  854.792850] EAX: 00000000 EBX: f73e2280 ECX: f68de400 EDX: 00000000
[  854.792850] ESI: f68de400 EDI: f722a400 EBP: c0652f2c ESP: c0652f28
[  854.792850]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  854.792850] Process events/0 (pid: 9, ti=c0652000 task=f787e000
task.ti=f7854000)
[  854.792850] Stack: f68de400 c0652f48 c039baef 00000000 00000002 00000001
c0391d71 00000000 
[  854.792850]        c0652f70 c039c378 00000000 c0652f70 c047a00a 00000000
00000002 f722a400 
[  854.792850]        c05c8560 00000000 c0652f90 c0391d89 00000092 f722a44c
00000096 00000000 
[  854.792850] Call Trace:
[  854.792850]  [<c039baef>] ? psmouse_handle_byte+0xf/0x110
[  854.792850]  [<c0391d71>] ? serio_interrupt+0x21/0x80
[  854.792850]  [<c039c378>] ? psmouse_interrupt+0xc8/0x2a0
[  854.792850]  [<c047a00a>] ? _spin_lock_irqsave+0x4a/0x60
[  854.792850]  [<c0391d89>] ? serio_interrupt+0x39/0x80
[  854.792850]  [<c0392a69>] ? i8042_interrupt+0x109/0x250
[  854.792850]  [<c0157c78>] ? handle_IRQ_event+0x28/0x60
[  854.792850]  [<c01590d3>] ? handle_edge_irq+0xb3/0x140
[  854.792850]  [<c0159020>] ? handle_edge_irq+0x0/0x140
[  854.792850]  [<c010738b>] ? do_IRQ+0x8b/0xf0
[  854.792850]  [<c0104c12>] ? common_interrupt+0x2e/0x34
[  854.792850]  [<c01400d8>] ? posix_cpu_timer_set+0x368/0x430
[  854.792850]  [<c047a3a7>] ? _spin_unlock_irqrestore+0x57/0x70
[  854.792850]  [<c01340b7>] ? __mod_timer+0xa7/0xc0
[  854.792850]  [<c013b2d4>] ? queue_delayed_work_on+0x84/0xc0
[  854.792850]  [<c013b4e1>] ? queue_delayed_work+0x51/0x60
[  854.792850]  [<c013b51a>] ? schedule_delayed_work+0x2a/0x40
[  854.792850]  [<c0168089>] ? vmstat_update+0x39/0x50
[  854.792850]  [<c013aa6c>] ? run_workqueue+0x12c/0x1e0
[  854.792850]  [<c013aa14>] ? run_workqueue+0xd4/0x1e0
[  854.792850]  [<c047a389>] ? _spin_unlock_irqrestore+0x39/0x70
[  854.792850]  [<c0168050>] ? vmstat_update+0x0/0x50
[  854.792850]  [<c013b5c9>] ? worker_thread+0x99/0xf0
[  854.792850]  [<c013e250>] ? autoremove_wake_function+0x0/0x50
[  854.792850]  [<c013b530>] ? worker_thread+0x0/0xf0
[  854.792850]  [<c013df62>] ? kthread+0x42/0x70
[  854.792850]  [<c013df20>] ? kthread+0x0/0x70
[  854.792850]  [<c0104e97>] ? kernel_thread_helper+0x7/0x10
[  854.792850]  =======================
[  854.792850] Code: b6 00 00 00 00 8d bc 27 00 00 00 00 55 89 c1 89 e5 53
0f b6 90 a0 00 00 00 8b 18 0f b6 c2 25 c8 00 00 00 83 f8 08 74 37 8b 43 24
<22> 50 04 3a 50 03 74 09 5b 31 c0 5d c3 8d 74 26 00 0f b6 91 a9 
[  854.792850] EIP: [<c039e62f>] alps_process_byte+0x1f/0x80 SS:ESP
0068:c0652f28

Marcus.

