Return-Path: <linux-kernel-owner+w=401wt.eu-S933622AbZLKBfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933622AbZLKBfe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 20:35:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933148AbZLKBfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 20:35:33 -0500
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:33719 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933356AbZLKBf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 20:35:27 -0500
X-Greylist: delayed 576 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Dec 2009 20:35:27 EST
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: linux-kernel@vger.kernel.org
Subject: [OOPS] Radeon KMS with 2.6.32 and agp not compiled in
Date: Fri, 11 Dec 2009 02:25:51 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.31.6-fglrx2; KDE/4.3.80; x86_64; ; )
Cc: dri-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912110225.52141.johannes.hirte@fem.tu-ilmenau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the agp driver is not compiled in but is build as module, the kernel oopes on modprobing radeon with modeset=1. 

Dec  7 22:08:53 datengrab kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000074
Dec  7 22:08:53 datengrab kernel: IP: [<ffffffffa01f693c>] radeon_agp_init+0x18/0x23c [radeon]
Dec  7 22:08:53 datengrab kernel: PGD 0
Dec  7 22:08:53 datengrab kernel: Oops: 0000 [#1] SMP
Dec  7 22:08:53 datengrab kernel: last sysfs file: /sys/module/agpgart/initstate
Dec  7 22:08:53 datengrab kernel: CPU 0
Dec  7 22:08:53 datengrab kernel: Modules linked in: radeon(+) ttm drm_kms_helper drm i2c_algo_bit snd_seq_midi snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_emul snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss aes_x86_64 aes_generic xts gf128mul dm_crypt snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm snd_seq_device snd_timer snd_page_alloc snd_util_mem snd_hwdep ohci_hcd i2c_amd8111 uhci_hcd sg snd amd64_agp sata_sil k8temp agpgart i2c_amd756 sr_mod hwmon
Dec  7 22:08:53 datengrab kernel: Pid: 2531, comm: work_for_cpu Not tainted 2.6.32 #2 To Be Filled By O.E.M.
Dec  7 22:08:53 datengrab kernel: RIP: 0010:[<ffffffffa01f693c>]  [<ffffffffa01f693c>] radeon_agp_init+0x18/0x23c [radeon]
Dec  7 22:08:53 datengrab kernel: RSP: 0018:ffff8801172c3d80  EFLAGS: 00010282
Dec  7 22:08:53 datengrab kernel: RAX: 0000000000000000 RBX: ffff880118410000 RCX: ffff88011fb97800
Dec  7 22:08:53 datengrab kernel: RDX: 00000000c0000000 RSI: 0000000000000000 RDI: ffff88011e43d800
Dec  7 22:08:53 datengrab kernel: RBP: 0000000000000000 R08: ffffffffa0238201 R09: ffff8801172c3d90
Dec  7 22:08:53 datengrab kernel: R10: ffffffff81589940 R11: 0000000000000400 R12: ffff88011fb97800
Dec  7 22:08:53 datengrab kernel: R13: 0000000000000020 R14: ffffffffa0243240 R15: ffff88011e43dbc0
Dec  7 22:08:53 datengrab kernel: FS:  00007f0e85a7f700(0000) GS:ffff880028200000(0000) knlGS:0000000000000000
Dec  7 22:08:53 datengrab kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Dec  7 22:08:53 datengrab kernel: CR2: 0000000000000074 CR3: 0000000001001000 CR4: 00000000000006f0
Dec  7 22:08:53 datengrab kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Dec  7 22:08:53 datengrab kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Dec  7 22:08:53 datengrab kernel: Process work_for_cpu (pid: 2531, threadinfo ffff8801172c2000, task ffff8801188d2280)
Dec  7 22:08:53 datengrab kernel: Stack:
Dec  7 22:08:53 datengrab kernel: ffff88011e43dbc0 ffffffff813436f0 ffff880100000008 ffff8801172c3df0
Dec  7 22:08:53 datengrab kernel: <0> ffff8801172c3db0 0000000000000246 ffff880118410000 ffff880118410144
Dec  7 22:08:53 datengrab kernel: <0> 0000000000000282 ffff880118410000 0000000000000000 ffff88011fb97800
Dec  7 22:08:53 datengrab kernel: Call Trace:
Dec  7 22:08:53 datengrab kernel: [<ffffffff813436f0>] ? printk+0x40/0x48
Dec  7 22:08:53 datengrab kernel: [<ffffffffa021f0b0>] ? r600_mc_init+0xf0/0x251 [radeon]
Dec  7 22:08:53 datengrab kernel: [<ffffffffa021fb91>] ? r600_init+0x154/0x2b7 [radeon]
Dec  7 22:08:53 datengrab kernel: [<ffffffffa01f4369>] ? radeon_device_init+0x1fe/0x276 [radeon]
Dec  7 22:08:53 datengrab kernel: [<ffffffffa01f4bda>] ? radeon_driver_load_kms+0xb2/0xec [radeon]
Dec  7 22:08:53 datengrab kernel: [<ffffffffa019ba34>] ? drm_get_dev+0x322/0x42e [drm]
Dec  7 22:08:53 datengrab kernel: [<ffffffff810452d2>] ? do_work_for_cpu+0x0/0x1b
Dec  7 22:08:53 datengrab kernel: [<ffffffff811b9ae1>] ? local_pci_probe+0x12/0x16
Dec  7 22:08:53 datengrab kernel: [<ffffffff810452dd>] ? do_work_for_cpu+0xb/0x1b
Dec  7 22:08:53 datengrab kernel: [<ffffffff8104827c>] ? kthread+0x75/0x7d
Dec  7 22:08:53 datengrab kernel: [<ffffffff8100bc7a>] ? child_rip+0xa/0x20
Dec  7 22:08:53 datengrab kernel: [<ffffffff81048207>] ? kthread+0x0/0x7d
Dec  7 22:08:53 datengrab kernel: [<ffffffff8100bc70>] ? child_rip+0x0/0x20
Dec  7 22:08:53 datengrab kernel: Code: 48 85 c0 74 0c 83 78 74 00 74 06 5a e9 c3 5e fa ff 58 c3 41 55 41 54 55 53 48 89 fb 48 83 ec 48 48 8b 7f 08 48 8b 87 48 03 00 00 <83> 78 74 00 75 1d e8 38 5e fa ff 85 c0 89 c5 74 12 89 c2 48 c7
Dec  7 22:08:53 datengrab kernel: RIP  [<ffffffffa01f693c>] radeon_agp_init+0x18/0x23c [radeon]
Dec  7 22:08:53 datengrab kernel: RSP <ffff8801172c3d80>
Dec  7 22:08:53 datengrab kernel: CR2: 0000000000000074
Dec  7 22:08:53 datengrab kernel: ---[ end trace b9e94e547b237285 ]---
