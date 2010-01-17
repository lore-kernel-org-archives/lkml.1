Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226Ab0AQRh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab0AQRh7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 12:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174Ab0AQRh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 12:37:58 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:40275 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab0AQRh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 12:37:58 -0500
Date: Sun, 17 Jan 2010 17:37:36 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: lockdep: possible circular locking dependency detected
	(rfkill_global_mutex){+.+.+.}
Message-ID: <20100117173736.GA13582@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While toggling rfkill during some tests the following appeared in dmesg:

[ 1865.161780] =======================================================
[ 1865.161790] [ INFO: possible circular locking dependency detected ]
[ 1865.161798] 2.6.33-rc4 #17
[ 1865.161803] -------------------------------------------------------
[ 1865.161809] bash/4773 is trying to acquire lock:
[ 1865.161816]  (rfkill_global_mutex){+.+.+.}, at: [<b04fe531>] rfkill_state_store+0x61/0x90
[ 1865.161836] 
[ 1865.161838] but task is already holding lock:
[ 1865.161843]  (s_active){++++.+}, at: [<b02081dd>] sysfs_get_active_two+0x1d/0x60
[ 1865.161862] 
[ 1865.161864] which lock already depends on the new lock.
[ 1865.161867] 
[ 1865.161871] 
[ 1865.161873] the existing dependency chain (in reverse order) is:
[ 1865.161879] 
[ 1865.161881] -> #2 (s_active){++++.+}:
[ 1865.161892]        [<b0162812>] __lock_acquire+0xd62/0x1290
[ 1865.161905]        [<b0162e02>] lock_acquire+0xc2/0xe0
[ 1865.161914]        [<b0208588>] sysfs_addrm_finish+0xb8/0x120
[ 1865.161924]        [<b020680a>] sysfs_hash_and_remove+0x4a/0x70
[ 1865.161934]        [<b020979c>] sysfs_remove_group+0x4c/0xd0
[ 1865.161944]        [<b039a795>] dpm_sysfs_remove+0x15/0x20
[ 1865.161956]        [<b039439e>] device_del+0x3e/0x1a0
[ 1865.161968]        [<b047c433>] netdev_unregister_kobject+0x23/0x30
[ 1865.161980]        [<b046df2b>] rollback_registered_many+0x23b/0x340
[ 1865.161992]        [<b046e045>] unregister_netdevice_many+0x15/0x50
[ 1865.162002]        [<b04e9f3f>] ieee80211_remove_interfaces+0x7f/0xb0
[ 1865.162014]        [<b04dda80>] ieee80211_unregister_hw+0x40/0xe0
[ 1865.162024]        [<b0509bb6>] ath5k_pci_remove+0x26/0xd0
[ 1865.162036]        [<b02e157e>] pci_device_remove+0x1e/0x40
[ 1865.162048]        [<b0396ec8>] __device_release_driver+0x58/0xa0
[ 1865.162058]        [<b0396fd5>] device_release_driver+0x25/0x40
[ 1865.162067]        [<b0396451>] bus_remove_device+0x81/0xb0
[ 1865.162077]        [<b0394474>] device_del+0x114/0x1a0
[ 1865.162086]        [<b0394510>] device_unregister+0x10/0x20
[ 1865.162096]        [<b02dc286>] pci_stop_bus_device+0x76/0x80
[ 1865.162106]        [<b02dc302>] pci_remove_bus_device+0x12/0xb0
[ 1865.162116]        [<b042bc78>] eeepc_rfkill_hotplug+0x78/0xf0
[ 1865.162127]        [<b042bd07>] eeepc_rfkill_notify+0x17/0x20
[ 1865.162136]        [<b030a791>] acpi_ev_notify_dispatch+0x51/0x5c
[ 1865.162149]        [<b02fd3f6>] acpi_os_execute_deferred+0x22/0x2d
[ 1865.162160]        [<b014935d>] worker_thread+0x1bd/0x2d0
[ 1865.162170]        [<b014cdb4>] kthread+0x74/0x80
[ 1865.162180]        [<b01032ba>] kernel_thread_helper+0x6/0x10
[ 1865.162191] 
[ 1865.162193] -> #1 (rtnl_mutex){+.+.+.}:
[ 1865.162203]        [<b0162812>] __lock_acquire+0xd62/0x1290
[ 1865.162213]        [<b0162e02>] lock_acquire+0xc2/0xe0
[ 1865.162222]        [<b050b087>] mutex_lock_nested+0x57/0x2b0
[ 1865.162233]        [<b0478e64>] rtnl_lock+0x14/0x20
[ 1865.162242]        [<b04c6415>] cfg80211_rfkill_set_block+0x25/0x80
[ 1865.162252]        [<b04fe115>] rfkill_set_block+0x65/0xd0
[ 1865.162261]        [<b04fe307>] __rfkill_switch_all+0x67/0x80
[ 1865.162270]        [<b04fe3ea>] rfkill_switch_all+0x6a/0x70
[ 1865.162279]        [<b04febf1>] rfkill_op_handler+0xd1/0x1a0
[ 1865.162288]        [<b014935d>] worker_thread+0x1bd/0x2d0
[ 1865.162297]        [<b014cdb4>] kthread+0x74/0x80
[ 1865.162306]        [<b01032ba>] kernel_thread_helper+0x6/0x10
[ 1865.162316] 
[ 1865.162317] -> #0 (rfkill_global_mutex){+.+.+.}:
[ 1865.162328]        [<b0162b4e>] __lock_acquire+0x109e/0x1290
[ 1865.162338]        [<b0162e02>] lock_acquire+0xc2/0xe0
[ 1865.162347]        [<b050b087>] mutex_lock_nested+0x57/0x2b0
[ 1865.162357]        [<b04fe531>] rfkill_state_store+0x61/0x90
[ 1865.162367]        [<b039345a>] dev_attr_store+0x2a/0x40
[ 1865.162377]        [<b02070e1>] sysfs_write_file+0xa1/0x100
[ 1865.162387]        [<b01c10c0>] vfs_write+0xa0/0x130
[ 1865.162398]        [<b01c1222>] sys_write+0x42/0x70
[ 1865.162407]        [<b0102d90>] sysenter_do_call+0x12/0x36
[ 1865.162416] 
[ 1865.162418] other info that might help us debug this:
[ 1865.162421] 
[ 1865.162427] 3 locks held by bash/4773:
[ 1865.162431]  #0:  (&buffer->mutex){+.+.+.}, at: [<b020706a>] sysfs_write_file+0x2a/0x100
[ 1865.162448]  #1:  (s_active){++++.+}, at: [<b02081f5>] sysfs_get_active_two+0x35/0x60
[ 1865.162465]  #2:  (s_active){++++.+}, at: [<b02081dd>] sysfs_get_active_two+0x1d/0x60
[ 1865.162481] 
[ 1865.162483] stack backtrace:
[ 1865.162490] Pid: 4773, comm: bash Not tainted 2.6.33-rc4 #17
[ 1865.162497] Call Trace:
[ 1865.162506]  [<b0509e6d>] ? printk+0x1d/0x1f
[ 1865.162516]  [<b01607c9>] print_circular_bug+0xd9/0xe0
[ 1865.162526]  [<b0162b4e>] __lock_acquire+0x109e/0x1290
[ 1865.162536]  [<b0162e02>] lock_acquire+0xc2/0xe0
[ 1865.162545]  [<b04fe531>] ? rfkill_state_store+0x61/0x90
[ 1865.162555]  [<b050b087>] mutex_lock_nested+0x57/0x2b0
[ 1865.162563]  [<b04fe531>] ? rfkill_state_store+0x61/0x90
[ 1865.162575]  [<b02c230c>] ? strict_strtoul+0x4c/0x80
[ 1865.162583]  [<b04fe531>] rfkill_state_store+0x61/0x90
[ 1865.162592]  [<b04fe4d0>] ? rfkill_state_store+0x0/0x90
[ 1865.162601]  [<b039345a>] dev_attr_store+0x2a/0x40
[ 1865.162611]  [<b02070e1>] sysfs_write_file+0xa1/0x100
[ 1865.162620]  [<b01c10c0>] vfs_write+0xa0/0x130
[ 1865.162629]  [<b01c2498>] ? fput+0x8/0x30
[ 1865.162638]  [<b0207040>] ? sysfs_write_file+0x0/0x100
[ 1865.162647]  [<b01c1222>] sys_write+0x42/0x70
[ 1865.162655]  [<b0102d90>] sysenter_do_call+0x12/0x36

-- 
Sitsofe | http://sucs.org/~sits/
