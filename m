Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbYG2F4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbYG2F4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 01:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754005AbYG2F41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 01:56:27 -0400
Received: from ik-out-1112.google.com ([66.249.90.178]:2214 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912AbYG2F40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 01:56:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=NWBeV2FADa7+x/nf3FcVQld2XgpjirbnAy979yOGCs3BwSnIgCNpnHchIRZSwLVu5y
         DFKWm9KRxaX0QDcWMD2OP/q2/zbfinZXTFm4YbCy/mfAA9xfOhFdk6252T4nVmB2quOZ
         Cghi0jTbk1ZMEaM3OVQjsyp9IjtFGmVZIFdz4=
Date: Tue, 29 Jul 2008 13:57:31 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: [BUG] wireless : cpu stuck for 61s
Message-ID: <20080729055731.GA3265@darkstar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While set my wlan0 to ad-hoc mode and then set the essid to something,
this bug triggered.

I suspect it's related to debugfs or mutex? But I'm not sure.

Jul 29 13:01:46 darkstar kernel: [ 8033.736493] BUG: soft lockup - CPU#0 stuck for 61s! [events/0:9]
Jul 29 13:01:46 darkstar kernel: [ 8033.736493] Modules linked in: radeonfb fb_ddc i2c_algo_bit snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss rfcomm l2cap bluetooth vfat fuse rtc_cmos rtc_core psmouse intel_agp pl2303 rtc_lib ath5k e100 i2c_i801 serio_raw usbserial agpgart 3c59x mii snd_hda_intel snd_pcm mac80211 snd_timer snd_page_alloc cfg80211 snd_hwdep snd soundcore thermal processor button thermal_sys evdev sg
Jul 29 13:01:46 darkstar kernel: [ 8033.736493] 
Jul 29 13:01:46 darkstar kernel: [ 8033.736493] Pid: 9, comm: events/0 Tainted: G        W (2.6.26-smp #3)
Jul 29 13:01:46 darkstar kernel: [ 8033.736493] EIP: 0060:[<c0450bc3>] EFLAGS: 00000246 CPU: 0
Jul 29 13:01:46 darkstar kernel: [ 8033.736493] EIP is at mutex_lock_nested+0x1b3/0x280
Jul 29 13:01:46 darkstar kernel: [ 8033.736493] EAX: 00000000 EBX: f7bf5284 ECX: f7c7e000 EDX: f7bf52a8
Jul 29 13:01:46 darkstar kernel: [ 8033.736493] ESI: f7bf5288 EDI: 00000246 EBP: f7c7fedc ESP: f7c7fe9c
Jul 29 13:01:46 darkstar kernel: [ 8033.736493]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Jul 29 13:01:46 darkstar kernel: [ 8033.736493] CR0: 8005003b CR2: b800c5ac CR3: 36e71000 CR4: 000006d0
Jul 29 13:01:46 darkstar kernel: [ 8033.736493] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
Jul 29 13:01:46 darkstar kernel: [ 8033.736493] DR6: ffff0ff0 DR7: 00000400
Jul 29 13:01:46 darkstar kernel: [ 8033.736493]  [<c02375a6>] ? debugfs_create_file+0x46/0x210
Jul 29 13:01:46 darkstar kernel: [ 8033.736493]  [<c02375a6>] ? debugfs_create_file+0x46/0x210
Jul 29 13:01:46 darkstar kernel: [ 8033.736493]  [<c02375a6>] debugfs_create_file+0x46/0x210
Jul 29 13:01:46 darkstar kernel: [ 8033.736493]  [<c02377f1>] debugfs_create_dir+0x21/0x30
Jul 29 13:01:46 darkstar kernel: [ 8033.736493]  [<f8901f6d>] ieee80211_sta_debugfs_add+0x2d/0x150 [mac80211]
Jul 29 13:01:46 darkstar kernel: [ 8033.736493]  [<f88eba89>] sta_info_debugfs_add_work+0x89/0x130 [mac80211]
Jul 29 13:01:46 darkstar kernel: [ 8033.736493]  [<f890a170>] ? rate_control_pid_add_sta_debugfs+0x0/0x30 [mac80211]
Jul 29 13:01:46 darkstar kernel: [ 8033.736493]  [<c01394c6>] run_workqueue+0x156/0x1d0
Jul 29 13:01:46 darkstar kernel: [ 8033.736493]  [<c0139472>] ? run_workqueue+0x102/0x1d0
Jul 29 13:01:46 darkstar kernel: [ 8033.736493]  [<f88eba00>] ? sta_info_debugfs_add_work+0x0/0x130 [mac80211]
Jul 29 13:01:46 darkstar kernel: [ 8033.736493]  [<c0139f18>] worker_thread+0x88/0xe0
Jul 29 13:01:46 darkstar kernel: [ 8033.736493]  [<c013cd20>] ? autoremove_wake_function+0x0/0x40
Jul 29 13:01:46 darkstar kernel: [ 8033.736493]  [<c0139e90>] ? worker_thread+0x0/0xe0
Jul 29 13:01:46 darkstar kernel: [ 8033.736493]  [<c013ca32>] kthread+0x42/0x70
Jul 29 13:01:46 darkstar kernel: [ 8033.736493]  [<c013c9f0>] ? kthread+0x0/0x70
Jul 29 13:01:46 darkstar kernel: [ 8033.736493]  [<c0104993>] kernel_thread_helper+0x7/0x14
Jul 29 13:01:46 darkstar kernel: [ 8033.736493]  =======================
Jul 29 13:02:51 darkstar kernel: [ 8099.234898] BUG: soft lockup - CPU#0 stuck for 61s! [events/0:9]
Jul 29 13:02:51 darkstar kernel: [ 8099.234898] Modules linked in: radeonfb fb_ddc i2c_algo_bit snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss rfcomm l2cap bluetooth vfat fuse rtc_cmos rtc_core psmouse intel_agp pl2303 rtc_lib ath5k e100 i2c_i801 serio_raw usbserial agpgart 3c59x mii snd_hda_intel snd_pcm mac80211 snd_timer snd_page_alloc cfg80211 snd_hwdep snd soundcore thermal processor button thermal_sys evdev sg
Jul 29 13:02:51 darkstar kernel: [ 8099.234898] 
Jul 29 13:02:51 darkstar kernel: [ 8099.234898] Pid: 9, comm: events/0 Tainted: G        W (2.6.26-smp #3)
Jul 29 13:02:51 darkstar kernel: [ 8099.234898] EIP: 0060:[<c0450bc3>] EFLAGS: 00000246 CPU: 0
Jul 29 13:02:51 darkstar kernel: [ 8099.234898] EIP is at mutex_lock_nested+0x1b3/0x280
Jul 29 13:02:51 darkstar kernel: [ 8099.234898] EAX: 00000000 EBX: f7bf5284 ECX: f7c7e000 EDX: f7bf52a8
Jul 29 13:02:51 darkstar kernel: [ 8099.234898] ESI: f7bf5288 EDI: 00000246 EBP: f7c7fedc ESP: f7c7fe9c
Jul 29 13:02:51 darkstar kernel: [ 8099.234898]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Jul 29 13:02:51 darkstar kernel: [ 8099.234898] CR0: 8005003b CR2: b800c5ac CR3: 36e71000 CR4: 000006d0
Jul 29 13:02:51 darkstar kernel: [ 8099.234898] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
Jul 29 13:02:51 darkstar kernel: [ 8099.234898] DR6: ffff0ff0 DR7: 00000400
Jul 29 13:02:51 darkstar kernel: [ 8099.234898]  [<c02375a6>] ? debugfs_create_file+0x46/0x210
Jul 29 13:02:51 darkstar kernel: [ 8099.234898]  [<c02375a6>] ? debugfs_create_file+0x46/0x210
Jul 29 13:02:51 darkstar kernel: [ 8099.234898]  [<c02375a6>] debugfs_create_file+0x46/0x210
Jul 29 13:02:51 darkstar kernel: [ 8099.234898]  [<c02377f1>] debugfs_create_dir+0x21/0x30
Jul 29 13:02:51 darkstar kernel: [ 8099.234898]  [<f8901f6d>] ieee80211_sta_debugfs_add+0x2d/0x150 [mac80211]
Jul 29 13:02:51 darkstar kernel: [ 8099.234898]  [<f88eba89>] sta_info_debugfs_add_work+0x89/0x130 [mac80211]
Jul 29 13:02:51 darkstar kernel: [ 8099.234898]  [<f890a170>] ? rate_control_pid_add_sta_debugfs+0x0/0x30 [mac80211]
Jul 29 13:02:51 darkstar kernel: [ 8099.234898]  [<c01394c6>] run_workqueue+0x156/0x1d0
Jul 29 13:02:51 darkstar kernel: [ 8099.234898]  [<c0139472>] ? run_workqueue+0x102/0x1d0
Jul 29 13:02:51 darkstar kernel: [ 8099.234898]  [<f88eba00>] ? sta_info_debugfs_add_work+0x0/0x130 [mac80211]
Jul 29 13:02:51 darkstar kernel: [ 8099.234898]  [<c0139f18>] worker_thread+0x88/0xe0
Jul 29 13:02:51 darkstar kernel: [ 8099.234898]  [<c013cd20>] ? autoremove_wake_function+0x0/0x40
Jul 29 13:02:51 darkstar kernel: [ 8099.234898]  [<c0139e90>] ? worker_thread+0x0/0xe0
Jul 29 13:02:51 darkstar kernel: [ 8099.234898]  [<c013ca32>] kthread+0x42/0x70
Jul 29 13:02:51 darkstar kernel: [ 8099.234898]  [<c013c9f0>] ? kthread+0x0/0x70
Jul 29 13:02:51 darkstar kernel: [ 8099.234898]  [<c0104993>] kernel_thread_helper+0x7/0x14
Jul 29 13:02:51 darkstar kernel: [ 8099.234898]  =======================
