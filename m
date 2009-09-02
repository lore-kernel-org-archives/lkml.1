Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbZIBJU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbZIBJU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 05:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbZIBJU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 05:20:28 -0400
Received: from www.tglx.de ([62.245.132.106]:51459 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbZIBJU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 05:20:27 -0400
Date: Wed, 2 Sep 2009 11:19:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: WARN_ON: fs/buffer.c:1152 mark_buffer_dirty in 2.6.31-rc8-git
Message-ID: <alpine.LFD.2.00.0909021113330.2797@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The warning in fs/buffer.c 1152 triggers with the latest git on my
laptop when I remove an USB stick. Never seen that before.

Thanks,

	tglx
---

WARNING: at /home/tglx/work/kernel/git/linux-2.6/fs/buffer.c:1152 mark_buffer_dirty+0x3f/0xa5()
Hardware name: 7661W1P
Modules linked in: ext2 option usbserial usb_storage fuse ipt_MASQUERADE iptable_nat nf_nat sco bridge stp llc bnep l2cap bluetooth sunrpc ipv6 cpufreq_ondemand acpi_cpufreq freq_table dm_multipath kvm_intel kvm uinput snd_hda_codec_analog arc4 ecb iwlagn firewire_ohci firewire_core snd_hda_intel yenta_socket iwlcore crc_itu_t joydev snd_hda_codec rsrc_nonstatic mac80211 snd_hwdep snd_pcm iTCO_wdt i2c_i801 pcspkr snd_timer iTCO_vendor_support snd thinkpad_acpi cfg80211 soundcore hwmon snd_page_alloc e1000e rfkill wmi i915 drm i2c_algo_bit i2c_core video output [last unloaded: microcode]
Pid: 26, comm: khubd Not tainted 2.6.31-rc8 #1
Call Trace:
 [<ffffffff810610ff>] warn_slowpath_common+0x8d/0xbb
 [<ffffffff81061154>] warn_slowpath_null+0x27/0x3d
 [<ffffffff81150c16>] mark_buffer_dirty+0x3f/0xa5
 [<ffffffffa04420d5>] ext2_sync_fs+0x90/0xba [ext2]
 [<ffffffff8114e383>] __sync_filesystem+0x65/0x90
 [<ffffffff8114e5d0>] sync_filesystem+0x5a/0x75
 [<ffffffff81157667>] fsync_bdev+0x37/0x6c
 [<ffffffff8124b1aa>] invalidate_partition+0x34/0x65
 [<ffffffff8118ad52>] del_gendisk+0x4a/0x10d
 [<ffffffff81347465>] sd_remove+0x5f/0xb3
 [<ffffffff81326db5>] __device_release_driver+0x79/0xd5
 [<ffffffff81326f18>] device_release_driver+0x36/0x59
 [<ffffffff81325e59>] bus_remove_device+0xc5/0x10a
 [<ffffffff81323896>] device_del+0x141/0x1a6
 [<ffffffff81342aba>] __scsi_remove_device+0x5c/0xb1
 [<ffffffff8133f4cf>] scsi_forget_host+0x59/0x91
 [<ffffffff813379b0>] scsi_remove_host+0x93/0x123
 [<ffffffffa042b0d6>] quiesce_and_remove_host+0x72/0xcf [usb_storage]
 [<ffffffffa042b241>] usb_stor_disconnect+0x2c/0x4f [usb_storage]
 [<ffffffff8138ce3c>] usb_unbind_interface+0x7a/0x117
 [<ffffffff81326db5>] __device_release_driver+0x79/0xd5
 [<ffffffff81326f18>] device_release_driver+0x36/0x59
 [<ffffffff81325e59>] bus_remove_device+0xc5/0x10a
 [<ffffffff81323896>] device_del+0x141/0x1a6
 [<ffffffff81389498>] usb_disable_device+0xdd/0x1fb
 [<ffffffff81382b40>] usb_disconnect+0xfa/0x1ca
 [<ffffffff813844bd>] hub_events+0x639/0x11e0
 [<ffffffff813850aa>] hub_thread+0x46/0x1d0
 [<ffffffff8107d6f3>] ? autoremove_wake_function+0x0/0x5f
 [<ffffffff81385064>] ? hub_thread+0x0/0x1d0
 [<ffffffff8107d270>] kthread+0xa0/0xa8
 [<ffffffff8101409a>] child_rip+0xa/0x20
 [<ffffffff810139fd>] ? restore_args+0x0/0x30
 [<ffffffff8107d1d0>] ? kthread+0x0/0xa8
 [<ffffffff81014090>] ? child_rip+0x0/0x20
---[ end trace ccd8dc4f063ddca9 ]---


