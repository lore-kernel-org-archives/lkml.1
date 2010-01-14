Return-Path: <linux-kernel-owner+w=401wt.eu-S932289Ab0ANStw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab0ANStw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 13:49:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997Ab0ANStv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 13:49:51 -0500
Received: from www17.your-server.de ([213.133.104.17]:59176 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab0ANStu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 13:49:50 -0500
Subject: WARNING: at fs/btrfs/free-space-cache.c:702 and kernel BUG at
 fs/btrfs/inode.c:5595
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jan 2010 19:47:34 +0100
Message-ID: <1263494854.2306.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


[   45.389946] ------------[ cut here ]------------
[   45.389956] WARNING: at fs/btrfs/free-space-cache.c:702 btrfs_remove_free_space+0x2d9/0x30c()
[   45.389960] Hardware name: Aspire 1810T
[   45.389962] Modules linked in: ext2 sha256_generic aes_i586 aes_generic cbc dm_crypt kvm_intel kvm uinput snd_hda_codec_intelhdmi snd_hda_codec_realtek arc4 ecb snd_hda_intel snd_hda_codec iwlagn snd_hwdep snd_seq iwlcore snd_seq_device uvcvideo snd_pcm snd_timer videodev mac80211 snd acer_wmi wmi serio_raw v4l1_compat soundcore joydev cfg80211 i2c_i801 pcspkr iTCO_wdt snd_page_alloc rfkill iTCO_vendor_support dm_multipath [last unloaded: scsi_wait_scan]
[   45.390014] Pid: 900, comm: mount Tainted: G        W  2.6.32.3 #45
[   45.390017] Call Trace:
[   45.390024]  [<c0425eff>] warn_slowpath_common+0x6a/0x81
[   45.390030]  [<c056ec59>] ? btrfs_remove_free_space+0x2d9/0x30c
[   45.390034]  [<c0425f28>] warn_slowpath_null+0x12/0x15
[   45.390039]  [<c056ec59>] btrfs_remove_free_space+0x2d9/0x30c
[   45.390045]  [<c0530bdb>] ? btrfs_set_path_blocking+0x21/0x2b
[   45.390051]  [<c0539262>] btrfs_alloc_logged_file_extent+0xf6/0x239
[   45.390057]  [<c056ae54>] replay_one_extent+0x3a8/0x531
[   45.390062]  [<c055c41b>] ? map_private_extent_buffer+0x94/0xb6
[   45.390067]  [<c055c48c>] ? map_extent_buffer+0x4f/0x7f
[   45.390072]  [<c0553e7e>] ? btrfs_item_size+0x5f/0xa2
[   45.390077]  [<c055bedc>] ? unmap_extent_buffer+0x11/0x13
[   45.390082]  [<c0553eb7>] ? btrfs_item_size+0x98/0xa2
[   45.390087]  [<c056cb5a>] replay_one_buffer+0x1ef/0x23d
[   45.390092]  [<c0569341>] walk_down_log_tree+0x13f/0x3a9
[   45.390097]  [<c056960c>] walk_log_tree+0x61/0x16a
[   45.390102]  [<c056c889>] btrfs_recover_log_trees+0x14c/0x22e
[   45.390107]  [<c056c96b>] ? replay_one_buffer+0x0/0x23d
[   45.390113]  [<c0545a0c>] open_ctree+0xd0e/0xf16
[   45.390120]  [<c05b7682>] ? strlcpy+0x13/0x3d
[   45.390124]  [<c052ff0d>] btrfs_get_sb+0x20e/0x3b3
[   45.390130]  [<c049d7b6>] ? __kmalloc_track_caller+0x107/0x113
[   45.390136]  [<c04b4741>] ? alloc_vfsmnt+0x73/0x100
[   45.390142]  [<c0487a17>] ? kstrdup+0x30/0x4c
[   45.390147]  [<c04a49b5>] vfs_kern_mount+0x86/0x11f
[   45.390152]  [<c04a4a9d>] do_kern_mount+0x38/0xc3
[   45.390157]  [<c04b5463>] do_mount+0x5cc/0x612
[   45.390162]  [<c05b9d02>] ? copy_from_user+0x32/0x11a
[   45.390166]  [<c0487ac8>] ? strndup_user+0x4a/0x6a
[   45.390171]  [<c04b550f>] sys_mount+0x66/0x94
[   45.390176]  [<c0402a4b>] sysenter_do_call+0x12/0x22
[   45.390179] ---[ end trace a7919e7f17c0a727 ]---

and:

[  129.674122] btrfs csum failed ino 1439095 off 0 csum 1431100861 private 2517934686
[  129.677218] btrfs csum failed ino 1439095 off 0 csum 1431100861 private 2517934686
[  129.680385] btrfs csum failed ino 1439095 off 0 csum 1431100861 private 2517934686
[  129.683637] btrfs csum failed ino 1439095 off 0 csum 1431100861 private 2517934686

and:
[  258.590846] ------------[ cut here ]------------
[  258.590860] kernel BUG at fs/btrfs/inode.c:5595!
[  258.590867] invalid opcode: 0000 [#1] 
[  258.590873] last sysfs file: /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0A:00/power_supply/BAT1/voltage_now
[  258.590879] Modules linked in: fuse cpufreq_ondemand acpi_cpufreq ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 ext2 sha256_generic aes_i586 aes_generic cbc dm_crypt kvm_intel kvm uinput snd_hda_codec_intelhdmi snd_hda_codec_realtek arc4 snd_hda_intel ecb iwlagn snd_hda_codec iwlcore uvcvideo snd_hwdep snd_seq snd_seq_device videodev snd_pcm mac80211 wmi pcspkr serio_raw i2c_i801 v4l1_compat joydev snd_timer snd cfg80211 iTCO_wdt iTCO_vendor_support soundcore snd_page_alloc rfkill dm_multipath [last unloaded: scsi_wait_scan]
[  258.590947] 
[  258.590955] Pid: 2242, comm: evolution Tainted: G        W  2.6.33-rc4 #51 Base Board Product Name/Aspire 1810T
[  258.590963] EIP: 0060:[<c05b43e8>] EFLAGS: 00210282 CPU: 0
[  258.590977] EIP is at btrfs_rename+0x438/0x510
[  258.590982] EAX: ffffffef EBX: f4b3c0fc ECX: f6ec8000 EDX: ffffffef
[  258.590987] ESI: f4b2d600 EDI: f440f380 EBP: f3501e68 ESP: f3501e0c
[  258.590993]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[  258.591000] Process evolution (pid: 2242, ti=f3500000 task=f34c6200 task.ti=f3500000)
[  258.591004] Stack:
[  258.591007]  f4b3c9dc f4b2d658 0000001c 000001b1 00000000 00001e23 00000000 00000000
[  258.591020] <0> 01000000 f59f4090 f4b3c000 1416a30f 4b4f5ed7 f4b3c9dc f4f60400 f4f60400
[  258.591032] <0> f4424334 f4b3c0fc 00001e23 00000000 c08b8560 f440f380 f4b2d600 f3501eb0
[  258.591045] Call Trace:
[  258.591058]  [<c04e01ac>] ? vfs_rename+0x38c/0x400
[  258.591067]  [<c04e0424>] ? __lookup_hash+0x44/0x110
[  258.591075]  [<c04e165f>] ? sys_renameat+0x1ff/0x220
[  258.591086]  [<c043e6c5>] ? run_timer_softirq+0x125/0x290
[  258.591094]  [<c04d7c08>] ? file_free_rcu+0x28/0x30
[  258.591103]  [<c063ab24>] ? rb_insert_color+0x84/0x110
[  258.591112]  [<c0450555>] ? sched_clock_local.clone.0+0x15/0x1b0
[  258.591123]  [<c042a9c4>] ? finish_task_switch.clone.0+0x34/0xa0
[  258.591132]  [<c0479173>] ? audit_syscall_entry+0x1d3/0x200
[  258.591139]  [<c04e16ad>] ? sys_rename+0x2d/0x30
[  258.591148]  [<c0402fd3>] ? sysenter_do_call+0x12/0x22
[  258.591153] Code: 8b 82 10 01 00 00 05 60 18 00 00 e8 93 ac e9 ff e9 9d fd ff ff 8b 75 08 8b 45 c8 8b 56 0c e8 90 70 ff ff 85 c0 0f 84 09 ff ff ff <0f> 0b eb fe 0f 0b 66 90 eb fc 89 f1 8b 55 e0 8b 45 c8 e8 11 07 
[  258.591210] EIP: [<c05b43e8>] btrfs_rename+0x438/0x510 SS:ESP 0068:f3501e0c
[  258.591223] ---[ end trace a7919e7f17c0a727 ]---

greets
thomas


