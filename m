Return-Path: <linux-kernel-owner+w=401wt.eu-S1752136AbZJTNiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbZJTNiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 09:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbZJTNiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 09:38:00 -0400
Received: from mail-qy0-f194.google.com ([209.85.221.194]:53746 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbZJTNh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 09:37:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=VkjZZOwSouv980f5fIOBZyJmEKMyLHEbUhKMjOz7/ED2DeQW/JIW9iFXw7beer8gst
         4dEmn3KR5Ehdqj8MAa2ARhOVlLAoyFp01NM2+w+hXqdI7Mym7+cyPymzPY4l5uYDLtvd
         Y22ZURkfUZ1nAET2q9ITpOZiefKVyPt/EylwQ=
Message-ID: <4ADDBD2A.7070807@gmail.com>
Date: Tue, 20 Oct 2009 09:37:46 -0400
From: Miles Lane <miles.lane@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       olger Schurig <hs4233@mail.mn-solutions.de>
Subject: 2.6.32-rc5-git1 -- INFO: possible circular locking dependency detected
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending with wrapping off and time info removed:


[ INFO: possible circular locking dependency detected ]
 2.6.32-rc5-git1 #1
 -------------------------------------------------------
 events/0/9 is trying to acquire lock:
  (&rfkill->sync_work){+.+.+.}, at: [<c1039083>] 
__cancel_work_timer+0x81/0x181
 
 but task is already holding lock:
  (&ehotk->hotplug_lock){+.+.+.}, at: [<f8587708>] 
eeepc_rfkill_hotplug+0x45/0xda [eeepc_laptop]
 
 which lock already depends on the new lock.
 
 
 the existing dependency chain (in reverse order) is:
 
 -> #2 (&ehotk->hotplug_lock){+.+.+.}:
        [<c104ac60>] __lock_acquire+0x9fb/0xb6d
        [<c104ae2e>] lock_acquire+0x5c/0x73
        [<c129e223>] __mutex_lock_common+0x39/0x375
        [<c129e5ee>] mutex_lock_nested+0x2b/0x33
        [<f8587708>] eeepc_rfkill_hotplug+0x45/0xda [eeepc_laptop]
        [<f858787c>] eeepc_rfkill_set+0x1d/0x2d [eeepc_laptop]
        [<f83f4a9f>] rfkill_set_block+0x6f/0xb1 [rfkill]
        [<f83f4b78>] __rfkill_switch_all+0x2e/0x51 [rfkill]
        [<f83f4c12>] rfkill_switch_all+0x33/0x41 [rfkill]
        [<f83f51b0>] rfkill_op_handler+0xf0/0x11e [rfkill]
        [<c1038965>] worker_thread+0x161/0x233
        [<c103b883>] kthread+0x5f/0x64
        [<c1003613>] kernel_thread_helper+0x7/0x10
 
 -> #1 (rfkill_global_mutex){+.+.+.}:
        [<c104ac60>] __lock_acquire+0x9fb/0xb6d
        [<c104ae2e>] lock_acquire+0x5c/0x73
        [<c129e223>] __mutex_lock_common+0x39/0x375
        [<c129e5ee>] mutex_lock_nested+0x2b/0x33
        [<f83f4c36>] rfkill_sync_work+0x16/0x35 [rfkill]
        [<c1038965>] worker_thread+0x161/0x233
        [<c103b883>] kthread+0x5f/0x64
        [<c1003613>] kernel_thread_helper+0x7/0x10
 
 -> #0 (&rfkill->sync_work){+.+.+.}:
        [<c104ab62>] __lock_acquire+0x8fd/0xb6d
        [<c104ae2e>] lock_acquire+0x5c/0x73
        [<c10390ab>] __cancel_work_timer+0xa9/0x181
        [<c103919a>] cancel_work_sync+0xa/0xc
        [<f83f4e55>] rfkill_unregister+0x37/0x93 [rfkill]
        [<f84d95bc>] wiphy_unregister+0x21/0x14c [cfg80211]
        [<f885a0ed>] ieee80211_unregister_hw+0xa7/0xc5 [mac80211]
        [<f89805d9>] ath_detach+0x73/0x11b [ath9k]
        [<f898068c>] ath_cleanup+0xb/0x35 [ath9k]
        [<f8987305>] ath_pci_remove+0x15/0x17 [ath9k]
        [<c112c7a7>] pci_device_remove+0x19/0x39
        [<c11c5076>] __device_release_driver+0x59/0x9d
        [<c11c5157>] device_release_driver+0x18/0x23
        [<c11c470b>] bus_remove_device+0x71/0x7e
        [<c11c3425>] device_del+0xf0/0x131
        [<c11c3471>] device_unregister+0xb/0x15
        [<c1128d11>] pci_stop_bus_device+0x45/0x61
        [<c1128d91>] pci_remove_bus_device+0xd/0x90
        [<f8587780>] eeepc_rfkill_hotplug+0xbd/0xda [eeepc_laptop]
        [<f858787c>] eeepc_rfkill_set+0x1d/0x2d [eeepc_laptop]
        [<f83f4a9f>] rfkill_set_block+0x6f/0xb1 [rfkill]
        [<f83f4b78>] __rfkill_switch_all+0x2e/0x51 [rfkill]
        [<f83f4c12>] rfkill_switch_all+0x33/0x41 [rfkill]
        [<f83f51b0>] rfkill_op_handler+0xf0/0x11e [rfkill]
        [<c1038965>] worker_thread+0x161/0x233
        [<c103b883>] kthread+0x5f/0x64
        [<c1003613>] kernel_thread_helper+0x7/0x10
 
 other info that might help us debug this:
 
 4 locks held by events/0/9:
  #0:  (events){+.+.+.}, at: [<c1038923>] worker_thread+0x11f/0x233
  #1:  ((rfkill_op_work).work){+.+.+.}, at: [<c1038923>] 
worker_thread+0x11f/0x233
  #2:  (rfkill_global_mutex){+.+.+.}, at: [<f83f4bfd>] 
rfkill_switch_all+0x1e/0x41 [rfkill]
  #3:  (&ehotk->hotplug_lock){+.+.+.}, at: [<f8587708>] 
eeepc_rfkill_hotplug+0x45/0xda [eeepc_laptop]
 
 stack backtrace:
 Pid: 9, comm: events/0 Not tainted 2.6.32-rc5-git1 #1
 Call Trace:
  [<c129d1e0>] ? printk+0xf/0x17
  [<c1049f29>] print_circular_bug+0x8a/0x96
  [<c104ab62>] __lock_acquire+0x8fd/0xb6d
  [<c104ae2e>] lock_acquire+0x5c/0x73
  [<c1039083>] ? __cancel_work_timer+0x81/0x181
  [<c10390ab>] __cancel_work_timer+0xa9/0x181
  [<c1039083>] ? __cancel_work_timer+0x81/0x181
  [<c104974c>] ? mark_lock+0x1e/0x1e2
  [<c1049953>] ? mark_held_locks+0x43/0x5b
  [<c108b0d1>] ? kfree+0xbf/0xcb
  [<c103919a>] cancel_work_sync+0xa/0xc
  [<f83f4e55>] rfkill_unregister+0x37/0x93 [rfkill]
  [<f84d95bc>] wiphy_unregister+0x21/0x14c [cfg80211]
  [<c1038d10>] ? destroy_workqueue+0x72/0x77
  [<f885a0ed>] ieee80211_unregister_hw+0xa7/0xc5 [mac80211]
  [<f89805d9>] ath_detach+0x73/0x11b [ath9k]
  [<f898068c>] ath_cleanup+0xb/0x35 [ath9k]
  [<f8987305>] ath_pci_remove+0x15/0x17 [ath9k]
  [<c112c7a7>] pci_device_remove+0x19/0x39
  [<c11c5076>] __device_release_driver+0x59/0x9d
  [<c11c5157>] device_release_driver+0x18/0x23
  [<c11c470b>] bus_remove_device+0x71/0x7e
  [<c11c3425>] device_del+0xf0/0x131
  [<c11c3471>] device_unregister+0xb/0x15
  [<c1128d11>] pci_stop_bus_device+0x45/0x61
  [<c1128d91>] pci_remove_bus_device+0xd/0x90
  [<f8587780>] eeepc_rfkill_hotplug+0xbd/0xda [eeepc_laptop]
  [<f858787c>] eeepc_rfkill_set+0x1d/0x2d [eeepc_laptop]
  [<f83f4a9f>] rfkill_set_block+0x6f/0xb1 [rfkill]
  [<f83f4b78>] __rfkill_switch_all+0x2e/0x51 [rfkill]
  [<f83f4c12>] rfkill_switch_all+0x33/0x41 [rfkill]
  [<f83f51b0>] rfkill_op_handler+0xf0/0x11e [rfkill]
  [<c1038965>] worker_thread+0x161/0x233
  [<c1038923>] ? worker_thread+0x11f/0x233
  [<f83f50c0>] ? rfkill_op_handler+0x0/0x11e [rfkill]
  [<c103ba7d>] ? autoremove_wake_function+0x0/0x2f
  [<c1038804>] ? worker_thread+0x0/0x233
  [<c103b883>] kthread+0x5f/0x64
  [<c103b824>] ? kthread+0x0/0x64
  [<c1003613>] kernel_thread_helper+0x7/0x10
