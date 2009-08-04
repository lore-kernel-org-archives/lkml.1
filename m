Return-Path: <linux-kernel-owner+w=401wt.eu-S932365AbZHDBLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365AbZHDBLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 21:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbZHDBLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 21:11:17 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:44866 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112AbZHDBLL (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 21:11:11 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: 31-rc4-mmotm0730 - cfg80211 lockdep issues
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1249348108_4761P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 03 Aug 2009 21:08:28 -0400
Message-ID: <24959.1249348108@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1249348108_4761P
Content-Type: text/plain; charset=us-ascii

Got this while wpa_supplicant was trying to get the 3945 in my laptop
talking to our access points...

[   57.645772] iwl3945 0000:0c:00.0: firmware: requesting iwlwifi-3945-2.ucode
[   57.768773] iwl3945 0000:0c:00.0: loaded firmware version 15.28.2.8
[   57.861089] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   60.600092] wlan0: direct probe to AP 00:11:20:a4:4c:11 (try 1)
[   60.609374] wlan0 direct probe responded
[   60.612715] wlan0: authenticate with AP 00:11:20:a4:4c:11 (try 1)
[   60.618651] wlan0: authenticated
[   60.623914] wlan0: associate with AP 00:11:20:a4:4c:11 (try 1)
[   60.631185] wlan0: RX AssocResp from 00:11:20:a4:4c:11 (capab=0x31 status=0 aid=42)
[   60.634686] wlan0: associated
[   60.646367] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   60.655759] 
[   60.655763] =======================================================
[   60.656592] [ INFO: possible circular locking dependency detected ]
[   60.656592] 2.6.31-rc4-mmotm0730 #6
[   60.656592] -------------------------------------------------------
[   60.656592] phy0/682 is trying to acquire lock:
[   60.656592]  (cfg80211_mutex){+.+.+.}, at: [<ffffffff814a47ef>] regulatory_hint_11d+0x2b/0x574
[   60.656592] 
[   60.656592] but task is already holding lock:
[   60.656592]  (&ifmgd->mtx){+.+.+.}, at: [<ffffffff814bee6c>] ieee80211_sta_work+0x14c/0xebc
[   60.656592] 
[   60.656592] which lock already depends on the new lock.
[   60.656592] 
[   60.656592] 
[   60.656592] the existing dependency chain (in reverse order) is:
[   60.656592] 
[   60.656592] -> #3 (&ifmgd->mtx){+.+.+.}:
[   60.656592]        [<ffffffff81067db2>] __lock_acquire+0xa1b/0xb97
[   60.656592]        [<ffffffff8106801a>] lock_acquire+0xec/0x110
[   60.656592]        [<ffffffff814f01c7>] __mutex_lock_common+0x5a/0x54e
[   60.656592]        [<ffffffff814f075b>] mutex_lock_nested+0x32/0x37
[   60.656592]        [<ffffffff814bd28e>] ieee80211_mgd_auth+0x13a/0x173
[   60.656592]        [<ffffffff814c2983>] ieee80211_auth+0x13/0x15
[   60.656592]        [<ffffffff814af136>] __cfg80211_mlme_auth+0x214/0x267
[   60.656592]        [<ffffffff814b13f3>] cfg80211_conn_do_work+0x124/0x1e6
[   60.656592]        [<ffffffff814b17ff>] __cfg80211_connect+0x34a/0x426
[   60.656592]        [<ffffffff814b490e>] cfg80211_mgd_wext_connect+0x164/0x185
[   60.656592]        [<ffffffff814b4abe>] cfg80211_mgd_wext_siwap+0x18f/0x1c3
[   60.656592]        [<ffffffff814b31f5>] cfg80211_wext_siwap+0x4e/0x10d
[   60.656592]        [<ffffffff814a0188>] ioctl_standard_call+0x53/0xa7
[   60.656592]        [<ffffffff8149fb25>] wext_ioctl_dispatch+0xdc/0x154
[   60.656592]        [<ffffffff8149fc83>] wext_handle_ioctl+0x39/0x71
[   60.656592]        [<ffffffff813c9d29>] dev_ioctl+0x61a/0x643
[   60.656592]        [<ffffffff813b6f1f>] sock_ioctl+0x219/0x226
[   60.656592]        [<ffffffff810de53d>] vfs_ioctl+0x1d/0x82
[   60.656592]        [<ffffffff810deac9>] do_vfs_ioctl+0x4b0/0x4f6
[   60.656592]        [<ffffffff810deb66>] sys_ioctl+0x57/0x95
[   60.656592]        [<ffffffff8100b2ab>] system_call_fastpath+0x16/0x1b
[   60.656592]        [<ffffffffffffffff>] 0xffffffffffffffff
[   60.656592] 
[   60.656592] -> #2 (&wdev->mtx){+.+.+.}:
[   60.656592]        [<ffffffff81067db2>] __lock_acquire+0xa1b/0xb97
[   60.656592]        [<ffffffff8106801a>] lock_acquire+0xec/0x110
[   60.656592]        [<ffffffff814f01c7>] __mutex_lock_common+0x5a/0x54e
[   60.656592]        [<ffffffff814f075b>] mutex_lock_nested+0x32/0x37
[   60.656592]        [<ffffffff814a0764>] cfg80211_netdev_notifier_call+0x267/0x342
[   60.656592]        [<ffffffff814f4885>] notifier_call_chain+0x32/0x5e
[   60.656592]        [<ffffffff8105b648>] raw_notifier_call_chain+0xf/0x11
[   60.656592]        [<ffffffff813c7a80>] call_netdevice_notifiers+0x16/0x18
[   60.656592]        [<ffffffff813c89e9>] dev_open+0xea/0xf4
[   60.656592]        [<ffffffff813c7e90>] dev_change_flags+0xc5/0x185
[   60.656592]        [<ffffffff8141aa29>] devinet_ioctl+0x262/0x53f
[   60.656592]        [<ffffffff8141c21e>] inet_ioctl+0x92/0xaa
[   60.656592]        [<ffffffff813b6f07>] sock_ioctl+0x201/0x226
[   60.656592]        [<ffffffff810de53d>] vfs_ioctl+0x1d/0x82
[   60.656592]        [<ffffffff810deac9>] do_vfs_ioctl+0x4b0/0x4f6
[   60.656592]        [<ffffffff810deb66>] sys_ioctl+0x57/0x95
[   60.656592]        [<ffffffff8100b2ab>] system_call_fastpath+0x16/0x1b
[   60.656592]        [<ffffffffffffffff>] 0xffffffffffffffff
[   60.656592] 
[   60.656592] -> #1 (&rdev->mtx){+.+.+.}:
[   60.656592]        [<ffffffff81067db2>] __lock_acquire+0xa1b/0xb97
[   60.656592]        [<ffffffff8106801a>] lock_acquire+0xec/0x110
[   60.656592]        [<ffffffff814f01c7>] __mutex_lock_common+0x5a/0x54e
[   60.656592]        [<ffffffff814f075b>] mutex_lock_nested+0x32/0x37
[   60.656592]        [<ffffffff814a18b9>] cfg80211_get_dev_from_ifindex+0x57/0x72
[   60.656592]        [<ffffffff814a53e9>] cfg80211_wext_giwscan+0x44/0xa65
[   60.656592]        [<ffffffff814a00a2>] ioctl_standard_iw_point+0x18b/0x21e
[   60.656592]        [<ffffffff814a01c2>] ioctl_standard_call+0x8d/0xa7
[   60.656592]        [<ffffffff8149fb25>] wext_ioctl_dispatch+0xdc/0x154
[   60.656592]        [<ffffffff8149fc83>] wext_handle_ioctl+0x39/0x71
[   60.656592]        [<ffffffff813c9d29>] dev_ioctl+0x61a/0x643
[   60.656592]        [<ffffffff813b6f1f>] sock_ioctl+0x219/0x226
[   60.656592]        [<ffffffff810de53d>] vfs_ioctl+0x1d/0x82
[   60.656592]        [<ffffffff810deac9>] do_vfs_ioctl+0x4b0/0x4f6
[   60.656592]        [<ffffffff810deb66>] sys_ioctl+0x57/0x95
[   60.656592]        [<ffffffff8100b2ab>] system_call_fastpath+0x16/0x1b
[   60.656592]        [<ffffffffffffffff>] 0xffffffffffffffff
[   60.656592] 
[   60.656592] -> #0 (cfg80211_mutex){+.+.+.}:
[   60.656592]        [<ffffffff81067c8f>] __lock_acquire+0x8f8/0xb97
[   60.656592]        [<ffffffff8106801a>] lock_acquire+0xec/0x110
[   60.656592]        [<ffffffff814f01c7>] __mutex_lock_common+0x5a/0x54e
[   60.656592]        [<ffffffff814f075b>] mutex_lock_nested+0x32/0x37
[   60.656592]        [<ffffffff814a47ef>] regulatory_hint_11d+0x2b/0x574
[   60.656592]        [<ffffffff814beafb>] ieee80211_rx_mgmt_beacon+0x408/0x46b
[   60.656592]        [<ffffffff814beee3>] ieee80211_sta_work+0x1c3/0xebc
[   60.656592]        [<ffffffff810524d4>] worker_thread+0x2ba/0x3e9
[   60.656592]        [<ffffffff81056ebf>] kthread+0x85/0x8d
[   60.656592]        [<ffffffff8100c41a>] child_rip+0xa/0x20
[   60.656592]        [<ffffffffffffffff>] 0xffffffffffffffff
[   60.656592] 
[   60.656592] other info that might help us debug this:
[   60.656592] 
[   60.656592] 3 locks held by phy0/682:
[   60.656592]  #0:  ((wiphy_name(local->hw.wiphy))){+.+.+.}, at: [<ffffffff8105247b>] worker_thread+0x261/0x3e9
[   60.656592]  #1:  (&ifmgd->work){+.+.+.}, at: [<ffffffff8105247b>] worker_thread+0x261/0x3e9
[   60.656592]  #2:  (&ifmgd->mtx){+.+.+.}, at: [<ffffffff814bee6c>] ieee80211_sta_work+0x14c/0xebc
[   60.656592] 
[   60.656592] stack backtrace:
[   60.656592] Pid: 682, comm: phy0 Not tainted 2.6.31-rc4-mmotm0730 #6
[   60.656592] Call Trace:
[   60.656592]  [<ffffffff81067032>] print_circular_bug_tail+0x71/0x7c
[   60.656592]  [<ffffffff81067c8f>] __lock_acquire+0x8f8/0xb97
[   60.656592]  [<ffffffff81046700>] ? _local_bh_enable_ip+0x62/0x172
[   60.656592]  [<ffffffff814a47ef>] ? regulatory_hint_11d+0x2b/0x574
[   60.656592]  [<ffffffff8106801a>] lock_acquire+0xec/0x110
[   60.656592]  [<ffffffff814a47ef>] ? regulatory_hint_11d+0x2b/0x574
[   60.656592]  [<ffffffff814f01c7>] __mutex_lock_common+0x5a/0x54e
[   60.656592]  [<ffffffff814a47ef>] ? regulatory_hint_11d+0x2b/0x574
[   60.656592]  [<ffffffff814a473b>] ? regulatory_hint_found_beacon+0x7c/0x105
[   60.656592]  [<ffffffff814a47ef>] ? regulatory_hint_11d+0x2b/0x574
[   60.656592]  [<ffffffff814a67cc>] ? cfg80211_inform_bss_frame+0x1ae/0x1c5
[   60.656592]  [<ffffffff814f075b>] mutex_lock_nested+0x32/0x37
[   60.656592]  [<ffffffff814a47ef>] regulatory_hint_11d+0x2b/0x574
[   60.656592]  [<ffffffff814be69f>] ? ieee80211_rx_bss_info+0x96/0xea
[   60.656592]  [<ffffffff814beafb>] ieee80211_rx_mgmt_beacon+0x408/0x46b
[   60.656592]  [<ffffffff81066506>] ? mark_lock+0x2d/0x227
[   60.656592]  [<ffffffff814beee3>] ieee80211_sta_work+0x1c3/0xebc
[   60.656592]  [<ffffffff814bed20>] ? ieee80211_sta_work+0x0/0xebc
[   60.656592]  [<ffffffff810524d4>] worker_thread+0x2ba/0x3e9
[   60.656592]  [<ffffffff8105247b>] ? worker_thread+0x261/0x3e9
[   60.656592]  [<ffffffff810572cd>] ? autoremove_wake_function+0x0/0x34
[   60.656592]  [<ffffffff8105221a>] ? worker_thread+0x0/0x3e9
[   60.656592]  [<ffffffff81056ebf>] kthread+0x85/0x8d
[   60.656592]  [<ffffffff8100c41a>] child_rip+0xa/0x20
[   60.656592]  [<ffffffff8100bd80>] ? restore_args+0x0/0x30
[   60.656592]  [<ffffffff81056e3a>] ? kthread+0x0/0x8d
[   60.656592]  [<ffffffff8100c410>] ? child_rip+0x0/0x20
[   61.029274] cfg80211: Calling CRDA for country: US
[   61.446726] cfg80211: Current regulatory domain updated by AP to: US
[   61.449487] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   61.452326] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)



--==_Exmh_1249348108_4761P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKd4oMcC3lWbTT17ARAqDnAJ9tWBR1pN87Y8xil6Iy6L5XhGq+tACeKvsw
ePeYR+Fx9wuMCuz3XbHbJ8o=
=Pr8X
-----END PGP SIGNATURE-----

--==_Exmh_1249348108_4761P--
