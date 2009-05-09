Return-Path: <linux-kernel-owner+w=401wt.eu-S1753761AbZEIHDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbZEIHDW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 03:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbZEIHDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 03:03:13 -0400
Received: from nn7.de ([85.214.94.156]:53156 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670AbZEIHDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 03:03:12 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 May 2009 03:03:11 EDT
Subject: regression 2.6.30-rc4+git: oops in rfcomm_tty_open klist_add_tail
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 09 May 2009 08:56:26 +0200
Message-Id: <1241852186.14865.63.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I am seeing the oops below as soon as I try to bring up my internet
connection over rfcomm via a bluetooth device. I think that things were
working ok with 2.6.30-rc3 still but now I see this oops even after a
clean reboot, reproducibly ...

Any ideas?
Soeren 

------------[ cut here ]------------
WARNING: at kernel/workqueue.c:371 flush_cpu_workqueue+0x7d/0x80()
Hardware name: NC10                       
Modules linked in: ath5k mac80211 cfg80211 tun ppp_mppe ppp_async crc_ccitt ppp_generic slhc rfcomm l2cap fuse binfmt_misc snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer uvcvideo snd_seq_device videodev v4l1_compat btusb bluetooth psmouse snd i2c_i801 rtc_cmos rtc_core rtc_lib sky2 evdev soundcore snd_page_alloc [last unloaded: cfg80211]
Pid: 1418, comm: bluetooth Not tainted 2.6.30-rc4-sonne #8
Call Trace:
 [<c051dddf>] ? printk+0x18/0x21
 [<c0136233>] warn_slowpath+0x73/0xd0
 [<c0126709>] ? update_curr+0x99/0x1d0
 [<c0127777>] ? set_next_entity+0xa7/0x190
 [<c012c877>] ? finish_task_switch+0x97/0xd0
 [<c051e5f8>] ? __schedule+0x4e8/0xb20
 [<c0127777>] ? set_next_entity+0xa7/0x190
 [<c012c877>] ? finish_task_switch+0x97/0xd0
 [<c014752d>] flush_cpu_workqueue+0x7d/0x80
 [<c0147760>] flush_workqueue+0x30/0x50
 [<f8ab9cc6>] add_conn+0x16/0x40 [bluetooth]
 [<c0147050>] ? worker_thread+0x0/0x250
 [<c01471aa>] worker_thread+0x15a/0x250
 [<f8ab9cb0>] ? add_conn+0x0/0x40 [bluetooth]
 [<c014b370>] ? autoremove_wake_function+0x0/0x50
 [<c0147050>] ? worker_thread+0x0/0x250
 [<c014af56>] kthread+0x46/0x80
 [<c014af10>] ? kthread+0x0/0x80
 [<c010394f>] kernel_thread_helper+0x7/0x18
---[ end trace c91b55c4d7c5c20d ]---
BUG: unable to handle kernel NULL pointer dereference at 0000000c
IP: [<c050ad5b>] klist_node_init+0x2b/0x60
*pde = 00000000 
Oops: 0000 [#1] PREEMPT SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:1c.0/0000:02:00.0/net/wlan1/statistics/collisions
Modules linked in: ath5k mac80211 cfg80211 tun ppp_mppe ppp_async crc_ccitt ppp_generic slhc rfcomm l2cap fuse binfmt_misc snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer uvcvideo snd_seq_device videodev v4l1_compat btusb bluetooth psmouse snd i2c_i801 rtc_cmos rtc_core rtc_lib sky2 evdev soundcore snd_page_alloc [last unloaded: cfg80211]

Pid: 13288, comm: pppd Tainted: G        W  (2.6.30-rc4-sonne #8) NC10                       
EIP: 0060:[<c050ad5b>] EFLAGS: 00010246 CPU: 1
EIP is at klist_node_init+0x2b/0x60
EAX: e89da560 EBX: e89da554 ECX: c200cae0 EDX: e89da554
ESI: 00000000 EDI: ffffffea EBP: f697dd98 ESP: f697dd84
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process pppd (pid: 13288, ti=f697c000 task=e8926b70 task.ti=f697c000)
Stack:
 c0679ce3 e1e527a0 e1e527a0 00000000 e89da554 f697dda8 c050ae6a eaacf840
 00000000 f697ddd0 c03cb1a3 00000000 00000001 eaacf848 eba32edc eba32ed4
 eba32e00 eba32e16 e88d6f80 f697de30 f91c7330 00000004 e88d6f80 eb9d4a58
Call Trace:
 [<c050ae6a>] ? klist_add_tail+0x1a/0x50
 [<c03cb1a3>] ? device_move+0x83/0x230
 [<f91c7330>] ? rfcomm_tty_open+0x300/0x330 [rfcomm]
 [<c035fc21>] ? check_tty_count+0x51/0xc0
 [<c01315a0>] ? default_wake_function+0x0/0x10
 [<c0362d9a>] ? tty_open+0x1aa/0x4c0
 [<c01a6caa>] ? exact_lock+0xa/0x20
 [<c03d067c>] ? kobj_lookup+0x17c/0x190
 [<c01a6f62>] ? chrdev_open+0xf2/0x1d0
 [<c01a24c2>] ? __dentry_open+0xd2/0x2c0
 [<c01a2799>] ? nameidata_to_filp+0x59/0x70
 [<c01a6e70>] ? chrdev_open+0x0/0x1d0
 [<c01afdb1>] ? do_filp_open+0x1c1/0x7d0
 [<c0120a75>] ? ptep_set_access_flags+0x35/0x50
 [<c018c533>] ? do_wp_page+0x143/0x680
 [<c01b9298>] ? alloc_fd+0xe8/0x100
 [<c01a22a9>] ? do_sys_open+0x59/0xf0
 [<c01a23a9>] ? sys_open+0x29/0x40
 [<c0102f34>] ? sysenter_do_call+0x12/0x26
Code: 55 89 e5 83 ec 14 89 75 fc 89 c6 8d 42 04 89 5d f8 89 d3 89 42 04 89 42 08 8d 42 0c e8 af 2e dd ff f7 c6 01 00 00 00 89 33 75 15 <8b> 56 0c 85 d2 74 04 89 d8 ff d2 8b 5d f8 8b 75 fc 89 ec 5d c3 
EIP: [<c050ad5b>] klist_node_init+0x2b/0x60 SS:ESP 0068:f697dd84
CR2: 000000000000000c
---[ end trace c91b55c4d7c5c20e ]---

