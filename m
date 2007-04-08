Return-Path: <linux-kernel-owner+w=401wt.eu-S965994AbXDHAZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965994AbXDHAZV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 20:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966013AbXDHAZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 20:25:21 -0400
Received: from usermail.globalproof.net ([194.146.153.18]:39494 "EHLO
	usermail.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965994AbXDHAZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 20:25:19 -0400
From: "Denys" <denys@visp.net.lb>
To: linux-kernel@vger.kernel.org
Subject: JFFS2 BUG(), report
Date: Sun, 8 Apr 2007 03:25:05 +0300
Message-Id: <20070408002505.M14936@visp.net.lb>
X-Mailer: OpenWebMail 2.52 20060502
X-OriginatingIP: 195.69.208.251 (denys@visp.net.lb)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Trying to mount filesystem image, mounted over block2mtd to USB Flash (usb-
storage), got OOPS/BUG. Reproduced on latest kernel, 2.6.21-rc6.

Do you need complete JFFS2 image?
Please CC me in reply, cause i am not subscribed to list.

oops text:
[   41.355000] scsi 0:0:0:0: Direct-Access     USB 2.0  Flash Disk       0.00 
PQ: 0 ANSI: 2
[   41.357000] SCSI device sda: 512000 512-byte hdwr sectors (262 MB)
[   41.357000] sda: Write Protect is off
[   41.357000] sda: Mode Sense: 00 00 00 00
[   41.357000] sda: assuming drive cache: write through
[   41.361000] SCSI device sda: 512000 512-byte hdwr sectors (262 MB)
[   41.361000] sda: Write Protect is off
[   41.361000] sda: Mode Sense: 00 00 00 00
[   41.361000] sda: assuming drive cache: write through
[   41.361000]  sda: sda1 sda2
[   41.414000] sd 0:0:0:0: Attached scsi removable disk sda
[   41.414000] usb-storage: device scan complete
[   44.681000] eth0: link down
[   79.680000] block2mtd: mtd0: [d: /dev/sda2] erase_size = 8KiB [8192]
[   79.681000] block2mtd: version $Revision: 1.30 $
[   79.763000] JFFS2 version 2.2. (NAND) (SUMMARY)  (C) 2001-2006 Red Hat, 
Inc.
[   80.209000] Totlen for ref at d56c09b4 (0x00640000-0x0064000c) 
miscalculated as 0x0 instead of c
[   80.209000] next d56c09c0 (0x00640000-0x0064000c)
[   80.209000] jeb->wasted_size 0, dirty_size 0, used_size c, free_size 1ff4
[   80.209000] BUG: at fs/jffs2/nodelist.c:1219 __jffs2_ref_totlen()
[   80.209000]  [<e0348d1a>] __jffs2_ref_totlen+0x1e3/0x22d [jffs2]
[   80.209000]  [<e0348dd4>] jffs2_link_node_ref+0x70/0x121 [jffs2]
[   80.209000]  [<e02ef8b5>] block2mtd_read+0xe4/0x113 [block2mtd]
[   80.209000]  [<e034cf47>] jffs2_scan_make_ino_cache+0x10/0x63 [jffs2]
[   80.209000]  [<e0356b01>] jffs2_sum_scan_sumnode+0x1ab/0x574 [jffs2]
[   80.209000]  [<e034d35c>] jffs2_scan_medium+0x302/0x12da [jffs2]
[   80.209000]  [<c0137cb1>] __alloc_pages+0x59/0x28d
[   80.209000]  [<c0142e43>] __vmalloc+0xf/0x11
[   80.209000]  [<e0356909>] jffs2_sum_init+0x50/0x9d [jffs2]
[   80.209000]  [<e034ff2b>] jffs2_do_mount_fs+0x16f/0x470 [jffs2]
[   80.209000]  [<e035190d>] jffs2_do_fill_super+0xe3/0x1e6 [jffs2]
[   80.209000]  [<e0351b4d>] jffs2_sb_set+0x0/0x1d [jffs2]
[   80.209000]  [<e0351b3c>] jffs2_sb_compare+0x0/0x11 [jffs2]
[   80.209000]  [<e0351d46>] jffs2_get_sb_mtd+0xfd/0x147 [jffs2]
[   80.209000]  [<e0351f7e>] jffs2_get_sb+0x1a3/0x1bd [jffs2]
[   80.209000]  [<c02915ac>] error_code+0x74/0x7c
[   80.209000]  [<c015b4bc>] alloc_vfsmnt+0x8d/0xb4
[   80.209000]  [<c014c434>] vfs_kern_mount+0x40/0x6f
[   80.209000]  [<c014c4a5>] do_kern_mount+0x2d/0x3e
[   80.209000]  [<c015be81>] do_mount+0x56e/0x5e1
[   80.209000]  [<c015ae8b>] mntput_no_expire+0x11/0x47
[   80.209000]  [<c0151d9e>] link_path_walk+0xa5/0xaf
[   80.209000]  [<c013da1a>] __handle_mm_fault+0x271/0x675
[   80.209000]  [<c013db57>] __handle_mm_fault+0x3ae/0x675
[   80.209000]  [<c01511b0>] getname+0x59/0x8f
[   80.209000]  [<c02915ac>] error_code+0x74/0x7c
[   80.209000]  [<c0137eff>] __get_free_pages+0x1a/0x33
[   80.209000]  [<c015ab1f>] copy_mount_options+0x26/0x109
[   80.209000]  [<c015bf66>] sys_mount+0x72/0xa9
[   80.209000]  [<c0103a60>] sysenter_past_esp+0x5d/0x81
[   80.209000]  =======================
[   80.209000] JFFS2 error: (8300) jffs2_link_node_ref: Adding new ref 
d56c09c0 at (0x00640000-0x00640dd4) not immediately after previous 
(0x00640000-0x0064000c)
[   80.209000] ------------[ cut here ]------------
[   80.209000] kernel BUG at fs/jffs2/nodelist.c:1098!
[   80.209000] invalid opcode: 0000 [#1]
[   80.209000] Modules linked in: jffs2 zlib_deflate block2mtd mtdpart 
mtdcore snd_pcm_oss snd_mixer_oss snd_seq_dummy snd_seq_oss 
snd_seq_midi_event snd_seq snd_seq_device ohci_hcd thermal processor battery 
ac usb_storage libusual wlan_scan_sta ath_rate_sample ath_pci rtc_cmos 
rtc_core wlan rtc_lib ath_hal(P) 8139too i2c_i801 ehci_hcd uhci_hcd usbcore 
intelfb i2c_algo_bit cfbcopyarea snd_hda_intel snd_hda_codec snd_pcm 
snd_timer i2c_core snd soundcore snd_page_alloc cfbimgblt cfbfillrect
[   80.209000] CPU:    0
[   80.209000] EIP:    0060:[<e0348e22>]    Tainted: P       VLI
[   80.209000] EFLAGS: 00010296   (2.6.21-rc5 #6)
[   80.209000] EIP is at jffs2_link_node_ref+0xbe/0x121 [jffs2]
[   80.209000] eax: 000000a5   ebx: d65f10f0   ecx: 00000046   edx: 00007324
[   80.209000] esi: d56c09c0   edi: d7129400   ebp: 00000dd4   esp: d6949bdc
[   80.209000] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[   80.209000] Process mount (pid: 8300, ti=d6948000 task=d65f10f0 
task.ti=d6948000)
[   80.209000] Stack: e0357fed 0000206c e035782f d56c09c0 00640000 00640dd4 
00640000 0064000c
[   80.209000]        d605bf44 0000e002 00000000 000000dc e0356b01 00000dd4 
d58b62dc 00000008
[   80.209000]        00000006 c14db0b0 d605bf24 e03af280 d7129400 00002000 
000000dc 00000000
[   80.209000] Call Trace:
[   80.209000]  [<e0356b01>] jffs2_sum_scan_sumnode+0x1ab/0x574 [jffs2]
[   80.209000]  [<e034d35c>] jffs2_scan_medium+0x302/0x12da [jffs2]
[   80.209000]  [<c0137cb1>] __alloc_pages+0x59/0x28d
[   80.209000]  [<c0142e43>] __vmalloc+0xf/0x11
[   80.209000]  [<e0356909>] jffs2_sum_init+0x50/0x9d [jffs2]
[   80.209000]  [<e034ff2b>] jffs2_do_mount_fs+0x16f/0x470 [jffs2]
[   80.209000]  [<e035190d>] jffs2_do_fill_super+0xe3/0x1e6 [jffs2]
[   80.209000]  [<e0351b4d>] jffs2_sb_set+0x0/0x1d [jffs2]
[   80.209000]  [<e0351b3c>] jffs2_sb_compare+0x0/0x11 [jffs2]
[   80.209000]  [<e0351d46>] jffs2_get_sb_mtd+0xfd/0x147 [jffs2]
[   80.209000]  [<e0351f7e>] jffs2_get_sb+0x1a3/0x1bd [jffs2]
[   80.209000]  [<c02915ac>] error_code+0x74/0x7c
[   80.209000]  [<c015b4bc>] alloc_vfsmnt+0x8d/0xb4
[   80.209000]  [<c014c434>] vfs_kern_mount+0x40/0x6f
[   80.209000]  [<c014c4a5>] do_kern_mount+0x2d/0x3e
[   80.209000]  [<c015be81>] do_mount+0x56e/0x5e1
[   80.209000]  [<c015ae8b>] mntput_no_expire+0x11/0x47
[   80.209000]  [<c0151d9e>] link_path_walk+0xa5/0xaf
[   80.209000]  [<c013da1a>] __handle_mm_fault+0x271/0x675
[   80.209000]  [<c013db57>] __handle_mm_fault+0x3ae/0x675
[   80.209000]  [<c01511b0>] getname+0x59/0x8f
[   80.209000]  [<c02915ac>] error_code+0x74/0x7c
[   80.209000]  [<c0137eff>] __get_free_pages+0x1a/0x33
[   80.209000]  [<c015ab1f>] copy_mount_options+0x26/0x109
[   80.209000]  [<c015bf66>] sys_mount+0x72/0xa9
[   80.209000]  [<c0103a60>] sysenter_past_esp+0x5d/0x81
[   80.209000]  =======================
[   80.209000] Code: 24 1c 8d 04 29 89 54 24 18 89 44 24 14 c7 44 24 08 2f 78 
35 e0 8b 83 a4 00 00 00 c7 04 24 ed 7f 35 e0 89 44 24 04 e8 46 d5 dc df <0f> 
0b eb fe 85 d2 89 73 2c 74 0a 8b 42 04 89 06 89 72 04 eb 06
[   80.209000] EIP: [<e0348e22>] jffs2_link_node_ref+0xbe/0x121 [jffs2] 
SS:ESP 0068:d6949bdc


--
Denys Fedoryshchenko
Technical Manager
Virtual ISP S.A.L.

