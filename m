Return-Path: <linux-kernel-owner+w=401wt.eu-S1757464AbYIDLke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbYIDLke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 07:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbYIDLk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 07:40:27 -0400
Received: from relay2.globalproof.net ([194.146.153.25]:55137 "EHLO
	relay2.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbYIDLk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 07:40:26 -0400
From: Denys Fedoryshchenko <denys@visp.net.lb>
Organization: Virtual ISP
To: linux-kernel@vger.kernel.org
Subject: USB recursive locking, 2.6.27-rc5 while keyboard unplug/plug
Date: Thu, 4 Sep 2008 14:39:04 +0300
User-Agent: KMail/1.9.9
Cc: linux-usb@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809041439.05542.denys@visp.net.lb>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got a warning, while plugging/unplugging keyboard.

[  120.290895] usb 3-1: USB disconnect, address 2
[  120.334263]
[  120.334267] =============================================
[  120.334456] [ INFO: possible recursive locking detected ]
[  120.334556] 2.6.27-rc5-build-0032-00013-g592edf8-dirty #4
[  120.334654] ---------------------------------------------
[  120.334752] events/0/6 is trying to acquire lock:
[  120.334853]  (&usbhid->reset_work){--..}, at: [<c012e747>] __cancel_work_timer+0x8f/0x16f
[  120.334856]
[  120.334856] but task is already holding lock:
[  120.334856]  (&usbhid->reset_work){--..}, at: [<c012dfd7>] run_workqueue+0x92/0x1a5
[  120.334856]
[  120.334856] other info that might help us debug this:
[  120.334856] 2 locks held by events/0/6:
[  120.334856]  #0:  (events){--..}, at: [<c012dfd7>] run_workqueue+0x92/0x1a5
[  120.334856]  #1:  (&usbhid->reset_work){--..}, at: [<c012dfd7>] run_workqueue+0x92/0x1a5
[  120.334856]
[  120.334856] stack backtrace:
[  120.334856] Pid: 6, comm: events/0 Not tainted 2.6.27-rc5-build-0032-00013-g592edf8-dirty #4
[  120.334856]  [<c02b9570>] ? printk+0xf/0x17
[  120.334856]  [<c013da9e>] __lock_acquire+0xb35/0x1185
[  120.334856]  [<c013b489>] ? add_lock_to_list+0x60/0x92
[  120.334856]  [<c013e136>] lock_acquire+0x48/0x64
[  120.334856]  [<c012e747>] ? __cancel_work_timer+0x8f/0x16f
[  120.334856]  [<c012e75e>] __cancel_work_timer+0xa6/0x16f
[  120.334856]  [<c012e747>] ? __cancel_work_timer+0x8f/0x16f
[  120.334856]  [<c013c6ad>] ? mark_held_locks+0x53/0x6a
[  120.334856]  [<c013c850>] ? trace_hardirqs_on+0xb/0xd
[  120.334856]  [<c013c824>] ? trace_hardirqs_on_caller+0xe1/0x102
[  120.334856]  [<c013c850>] ? trace_hardirqs_on+0xb/0xd
[  120.334856]  [<c0128aa6>] ? try_to_del_timer_sync+0x48/0x4f
[  120.334856]  [<c012e83e>] cancel_work_sync+0xa/0xc
[  120.334856]  [<d08ab2b5>] hid_disconnect+0x7d/0xd2 [usbhid]
[  120.334856]  [<d0895763>] usb_unbind_interface+0x3f/0x7c [usbcore]
[  120.334856]  [<c022913f>] __device_release_driver+0x78/0x96
[  120.334856]  [<c0229212>] device_release_driver+0x1b/0x26
[  120.334856]  [<d08957dd>] usb_driver_release_interface+0x3d/0x7c [usbcore]
[  120.334856]  [<d0895838>] usb_rebind_intf+0x1c/0x5e [usbcore]
[  120.334856]  [<d088fd6a>] usb_reset_device+0xbf/0xd6 [usbcore]
[  120.334856]  [<d08abbd5>] hid_reset+0x9a/0x120 [usbhid]
[  120.334856]  [<c012e01c>] run_workqueue+0xd7/0x1a5
[  120.334856]  [<c012dfd7>] ? run_workqueue+0x92/0x1a5
[  120.334856]  [<c013c850>] ? trace_hardirqs_on+0xb/0xd
[  120.334856]  [<d08abb3b>] ? hid_reset+0x0/0x120 [usbhid]
[  120.334856]  [<c012e1a1>] worker_thread+0xb7/0xc3
[  120.334856]  [<c01310d1>] ? autoremove_wake_function+0x0/0x33
[  120.334856]  [<c012e0ea>] ? worker_thread+0x0/0xc3
[  120.334856]  [<c0130e5d>] kthread+0x3b/0x61
[  120.334856]  [<c0130e22>] ? kthread+0x0/0x61
[  120.334856]  [<c010452f>] kernel_thread_helper+0x7/0x10
[  120.334856]  =======================
[  131.130083] eth0: link down
