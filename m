Return-Path: <linux-kernel-owner+w=401wt.eu-S1752033AbZJTMfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbZJTMfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 08:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbZJTMfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 08:35:21 -0400
Received: from mail-ew0-f217.google.com ([209.85.219.217]:45066 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbZJTMfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 08:35:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=aej+n4UZRQY8Lvw6kOqPcSEJsU+JNm5osJQsy4QNz9L0I3fgoCpo4GLYh+Iye4pjt9
         GwPyqVJ9cvweRfvd+YcgvBUOp84LLMyZ0OJHuQHAvJEGwZmuGh/4OPICi6wuBseUBZIC
         bYKOoThUPMntNQ1EtQX45Z7dgA+gLFQxnNlQ8=
MIME-Version: 1.0
Date: Tue, 20 Oct 2009 08:35:21 -0400
Message-ID: <a44ae5cd0910200535k1a0cee70u60803f649912bb3e@mail.gmail.com>
Subject: 2.6.32-rc5-git1 -- INFO: possible circular locking dependency 
	detected
From: Miles Lane <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Corentin Chary <corentincj@iksaif.net>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Jouni Malinen <jmalinen@atheros.com>,
       Sujith Manoharan <Sujith.Manoharan@atheros.com>,
       Vasanthakumar Thiagarajan <vasanth@atheros.com>,
       Senthil Balasubramanian <senthilkumar@atheros.com>,
       linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oct 20 08:08:21 ubuntu kernel: [   17.543373] [ INFO: possible
circular locking dependency detected ]
Oct 20 08:08:21 ubuntu kernel: [   17.543373] 2.6.32-rc5-git1 #1
Oct 20 08:08:21 ubuntu kernel: [   17.543373]
-------------------------------------------------------
Oct 20 08:08:21 ubuntu kernel: [   17.543373] events/0/9 is trying to
acquire lock:
Oct 20 08:08:21 ubuntu kernel: [   17.543373]
(&rfkill->sync_work){+.+.+.}, at: [<c1039083>]
__cancel_work_timer+0x81/0x181
Oct 20 08:08:21 ubuntu kernel: [   17.543373]
Oct 20 08:08:21 ubuntu kernel: [   17.543373] but task is already holding lock:
Oct 20 08:08:21 ubuntu kernel: [   17.543373]
(&ehotk->hotplug_lock){+.+.+.}, at: [<f8587708>]
eeepc_rfkill_hotplug+0x45/0xda [eeepc_laptop]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]
Oct 20 08:08:21 ubuntu kernel: [   17.543373] which lock already
depends on the new lock.
Oct 20 08:08:21 ubuntu kernel: [   17.543373]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]
Oct 20 08:08:21 ubuntu kernel: [   17.543373] the existing dependency
chain (in reverse order) is:
Oct 20 08:08:21 ubuntu kernel: [   17.543373]
Oct 20 08:08:21 ubuntu kernel: [   17.543373] -> #2
(&ehotk->hotplug_lock){+.+.+.}:
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<c104ac60>]
__lock_acquire+0x9fb/0xb6d
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<c104ae2e>]
lock_acquire+0x5c/0x73
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<c129e223>]
__mutex_lock_common+0x39/0x375
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<c129e5ee>]
mutex_lock_nested+0x2b/0x33
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<f8587708>]
eeepc_rfkill_hotplug+0x45/0xda [eeepc_laptop]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<f858787c>]
eeepc_rfkill_set+0x1d/0x2d [eeepc_laptop]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<f83f4a9f>]
rfkill_set_block+0x6f/0xb1 [rfkill]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<f83f4b78>]
__rfkill_switch_all+0x2e/0x51 [rfkill]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<f83f4c12>]
rfkill_switch_all+0x33/0x41 [rfkill]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<f83f51b0>]
rfkill_op_handler+0xf0/0x11e [rfkill]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<c1038965>]
worker_thread+0x161/0x233
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<c103b883>]
kthread+0x5f/0x64
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<c1003613>]
kernel_thread_helper+0x7/0x10
Oct 20 08:08:21 ubuntu kernel: [   17.543373]
Oct 20 08:08:21 ubuntu kernel: [   17.543373] -> #1
(rfkill_global_mutex){+.+.+.}:
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<c104ac60>]
__lock_acquire+0x9fb/0xb6d
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<c104ae2e>]
lock_acquire+0x5c/0x73
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<c129e223>]
__mutex_lock_common+0x39/0x375
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<c129e5ee>]
mutex_lock_nested+0x2b/0x33
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<f83f4c36>]
rfkill_sync_work+0x16/0x35 [rfkill]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<c1038965>]
worker_thread+0x161/0x233
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<c103b883>]
kthread+0x5f/0x64
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<c1003613>]
kernel_thread_helper+0x7/0x10
Oct 20 08:08:21 ubuntu kernel: [   17.543373]
Oct 20 08:08:21 ubuntu kernel: [   17.543373] -> #0
(&rfkill->sync_work){+.+.+.}:
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<c104ab62>]
__lock_acquire+0x8fd/0xb6d
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<c104ae2e>]
lock_acquire+0x5c/0x73
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<c10390ab>]
__cancel_work_timer+0xa9/0x181
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<c103919a>]
cancel_work_sync+0xa/0xc
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<f83f4e55>]
rfkill_unregister+0x37/0x93 [rfkill]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<f84d95bc>]
wiphy_unregister+0x21/0x14c [cfg80211]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<f885a0ed>]
ieee80211_unregister_hw+0xa7/0xc5 [mac80211]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<f89805d9>]
ath_detach+0x73/0x11b [ath9k]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<f898068c>]
ath_cleanup+0xb/0x35 [ath9k]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<f8987305>]
ath_pci_remove+0x15/0x17 [ath9k]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<c112c7a7>]
pci_device_remove+0x19/0x39
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<c11c5076>]
__device_release_driver+0x59/0x9d
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<c11c5157>]
device_release_driver+0x18/0x23
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<c11c470b>]
bus_remove_device+0x71/0x7e
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<c11c3425>]
device_del+0xf0/0x131
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<c11c3471>]
device_unregister+0xb/0x15
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<c1128d11>]
pci_stop_bus_device+0x45/0x61
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<c1128d91>]
pci_remove_bus_device+0xd/0x90
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<f8587780>]
eeepc_rfkill_hotplug+0xbd/0xda [eeepc_laptop]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<f858787c>]
eeepc_rfkill_set+0x1d/0x2d [eeepc_laptop]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<f83f4a9f>]
rfkill_set_block+0x6f/0xb1 [rfkill]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<f83f4b78>]
__rfkill_switch_all+0x2e/0x51 [rfkill]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<f83f4c12>]
rfkill_switch_all+0x33/0x41 [rfkill]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<f83f51b0>]
rfkill_op_handler+0xf0/0x11e [rfkill]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<c1038965>]
worker_thread+0x161/0x233
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<c103b883>]
kthread+0x5f/0x64
Oct 20 08:08:21 ubuntu kernel: [   17.543373]        [<c1003613>]
kernel_thread_helper+0x7/0x10
Oct 20 08:08:21 ubuntu kernel: [   17.543373]
Oct 20 08:08:21 ubuntu kernel: [   17.543373] other info that might
help us debug this:
Oct 20 08:08:21 ubuntu kernel: [   17.543373]
Oct 20 08:08:21 ubuntu kernel: [   17.543373] 4 locks held by events/0/9:
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  #0:  (events){+.+.+.},
at: [<c1038923>] worker_thread+0x11f/0x233
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  #1:
((rfkill_op_work).work){+.+.+.}, at: [<c1038923>]
worker_thread+0x11f/0x233
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  #2:
(rfkill_global_mutex){+.+.+.}, at: [<f83f4bfd>]
rfkill_switch_all+0x1e/0x41 [rfkill]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  #3:
(&ehotk->hotplug_lock){+.+.+.}, at: [<f8587708>]
eeepc_rfkill_hotplug+0x45/0xda [eeepc_laptop]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]
Oct 20 08:08:21 ubuntu kernel: [   17.543373] stack backtrace:
Oct 20 08:08:21 ubuntu kernel: [   17.543373] Pid: 9, comm: events/0
Not tainted 2.6.32-rc5-git1 #1
Oct 20 08:08:21 ubuntu kernel: [   17.543373] Call Trace:
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<c129d1e0>] ? printk+0xf/0x17
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<c1049f29>]
print_circular_bug+0x8a/0x96
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<c104ab62>]
__lock_acquire+0x8fd/0xb6d
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<c104ae2e>]
lock_acquire+0x5c/0x73
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<c1039083>] ?
__cancel_work_timer+0x81/0x181
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<c10390ab>]
__cancel_work_timer+0xa9/0x181
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<c1039083>] ?
__cancel_work_timer+0x81/0x181
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<c104974c>] ?
mark_lock+0x1e/0x1e2
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<c1049953>] ?
mark_held_locks+0x43/0x5b
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<c108b0d1>] ? kfree+0xbf/0xcb
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<c103919a>]
cancel_work_sync+0xa/0xc
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<f83f4e55>]
rfkill_unregister+0x37/0x93 [rfkill]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<f84d95bc>]
wiphy_unregister+0x21/0x14c [cfg80211]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<c1038d10>] ?
destroy_workqueue+0x72/0x77
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<f885a0ed>]
ieee80211_unregister_hw+0xa7/0xc5 [mac80211]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<f89805d9>]
ath_detach+0x73/0x11b [ath9k]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<f898068c>]
ath_cleanup+0xb/0x35 [ath9k]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<f8987305>]
ath_pci_remove+0x15/0x17 [ath9k]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<c112c7a7>]
pci_device_remove+0x19/0x39
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<c11c5076>]
__device_release_driver+0x59/0x9d
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<c11c5157>]
device_release_driver+0x18/0x23
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<c11c470b>]
bus_remove_device+0x71/0x7e
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<c11c3425>]
device_del+0xf0/0x131
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<c11c3471>]
device_unregister+0xb/0x15
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<c1128d11>]
pci_stop_bus_device+0x45/0x61
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<c1128d91>]
pci_remove_bus_device+0xd/0x90
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<f8587780>]
eeepc_rfkill_hotplug+0xbd/0xda [eeepc_laptop]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<f858787c>]
eeepc_rfkill_set+0x1d/0x2d [eeepc_laptop]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<f83f4a9f>]
rfkill_set_block+0x6f/0xb1 [rfkill]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<f83f4b78>]
__rfkill_switch_all+0x2e/0x51 [rfkill]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<f83f4c12>]
rfkill_switch_all+0x33/0x41 [rfkill]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<f83f51b0>]
rfkill_op_handler+0xf0/0x11e [rfkill]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<c1038965>]
worker_thread+0x161/0x233
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<c1038923>] ?
worker_thread+0x11f/0x233
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<f83f50c0>] ?
rfkill_op_handler+0x0/0x11e [rfkill]
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<c103ba7d>] ?
autoremove_wake_function+0x0/0x2f
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<c1038804>] ?
worker_thread+0x0/0x233
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<c103b883>] kthread+0x5f/0x64
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<c103b824>] ? kthread+0x0/0x64
Oct 20 08:08:21 ubuntu kernel: [   17.543373]  [<c1003613>]
kernel_thread_helper+0x7/0x10
