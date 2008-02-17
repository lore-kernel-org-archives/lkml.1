Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbYBQIrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbYBQIrW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 03:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbYBQIrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 03:47:12 -0500
Received: from mail-09.jhb.wbs.co.za ([196.2.97.6]:12538 "EHLO
	mail-09.jhb.wbs.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbYBQIrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 03:47:09 -0500
X-Greylist: delayed 641 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Feb 2008 03:47:08 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAAMuAt0fEAmHEh2dsb2JhbACQVAEBAQgKKZpP
From: Bongani Hlope <bonganilinux@mweb.co.za>
To: video4linux-list@redhat.com
Subject: 2.6.25-rc[12] Video4Linux Bttv Regression
Date: Sun, 17 Feb 2008 10:36:19 +0200
User-Agent: KMail/1.9.8
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802171036.19619.bonganilinux@mweb.co.za>
X-Original-Subject: 2.6.25-rc[12] Video4Linux Bttv Regression
X-Scan-Signature: f1a7e279f3b5c113402d8a8324db0cf8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bttv driver seems to be experiencing problems in the 2.6.25-rcX kernels. I 
have the divided by error that  Robert Fitzsimons has already reported (I'll 
test his patch and see if it fixes it for me) and I have the following Oops 
when I try to use the radio:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<ffffffff8045723d>] __mutex_lock_slowpath+0x3b/0xb2
PGD 67671067 PUD 63f47067 PMD 0
Oops: 0002 [1] PREEMPT SMP
CPU 0
Modules linked in: snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq 
binfmt_misc loop nls_cp437 vfat fat nls_iso8859_1 ntfs dm_mod thermal 
processor fan container button pcspkr snd_pcm_oss snd_mixer_oss tuner tea5767 
tda8290 tuner_xc2028 tda9887 tuner_simple mt20xx tea5761 snd_emu10k1 
snd_rawmidi bttv snd_ac97_codec videodev ac97_bus v4l1_compat snd_pcm 
ir_common firewire_ohci firewire_core snd_seq_device compat_ioctl32 snd_timer 
uhci_hcd ehci_hcd v4l2_common ide_cd_mod crc_itu_t snd_page_alloc usbcore 
videobuf_dma_sg snd_util_mem videobuf_core ohci1394 btcx_risc i2c_viapro 
sr_mod snd_hwdep ieee1394 emu10k1_gp snd tg3 cdrom tveeprom gameport sg evdev 
soundcore
Pid: 7197, comm: radio Tainted: G   M     2.6.25-rc1 #20
RIP: 0010:[<ffffffff8045723d>]  [<ffffffff8045723d>] 
__mutex_lock_slowpath+0x3b/0xb2
RSP: 0018:ffff81007df515e8  EFLAGS: 00010246
RAX: ffff81007f13ef10 RBX: ffff81007f13ef08 RCX: 0000000000000000
RDX: ffff81007df515e8 RSI: ffffffff88184050 RDI: ffff81007f13ef0c
RBP: ffff81007df51628 R08: 0000000000000004 R09: ffff81007df51aa8
R10: ffff81007e680a40 R11: 0000000000000202 R12: ffff81007f13ef0c
R13: ffff81007f13ef08 R14: ffff810063cfc040 R15: ffffffff88184050
FS:  00007fa8d92ba6f0(0000) GS:ffffffff805b2000(0000) knlGS:00000000f61fb980
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000000676dc000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process radio (pid: 7197, threadinfo ffff81007df50000, task ffff810063cfc040)
Stack:  ffff81007f13ef10 0005049900000000 018060f7018060fa 0000000000000024
 ffff81007df51aa8 ffff81007f13e800 ffff81007f13ef08 ffff81007e0e5800
 ffff81007df51638 ffffffff80457083 ffff81007df51668 ffffffff88162f2f
Call Trace:
 [<ffffffff80457083>] mutex_lock+0xe/0x10
 [<ffffffff88162f2f>] :bttv:radio_g_tuner+0x40/0xa6
 [<ffffffff8813df7d>] :videodev:__video_do_ioctl+0x2a6e/0x2e25
 [<ffffffff8813503c>] :v4l1_compat:v4l_compat_translate_ioctl+0xea9/0x1af5
 [<ffffffff8813b50f>] ? :videodev:__video_do_ioctl+0x0/0x2e25
 [<ffffffff80301f4b>] ? blk_recount_segments+0x3e/0x62
 [<ffffffff80260f7b>] ? mempool_alloc_slab+0x11/0x13
 [<ffffffff80261085>] ? mempool_alloc+0x48/0xf9
 [<ffffffff802e3369>] ? ext3_get_acl+0x87/0x332
 [<ffffffff80296c65>] ? __d_lookup+0x125/0x137
 [<ffffffff8028d54f>] ? do_lookup+0x63/0x1b1
 [<ffffffff802961c3>] ? dput+0x22/0x120
 [<ffffffff8028f6a6>] ? __link_path_walk+0xbbd/0xd1b
 [<ffffffff802e3369>] ? ext3_get_acl+0x87/0x332
 [<ffffffff802115d1>] ? native_read_tsc+0x11/0x22
 [<ffffffff80310e1b>] ? __delay+0x27/0x59
last message repeated 2 times
 [<ffffffff80310ecf>] ? __udelay+0x40/0x42
 [<ffffffff803c0950>] ? i2c_stop+0x47/0x4b
 [<ffffffff803c1117>] ? bit_xfer+0x412/0x423
 [<ffffffff803bef99>] ? i2c_transfer+0x79/0x85
 [<ffffffff881cc31c>] ? :tuner_simple:simple_set_params+0x2bd/0xc1c
 [<ffffffff80284607>] ? get_unused_fd_flags+0x10d/0x11c
 [<ffffffff8029965b>] ? touch_atime+0xe3/0xec
 [<ffffffff8029b113>] ? mntput_no_expire+0x20/0x8f
 [<ffffffff881e3447>] ? :tuner:fe_set_params+0x46/0x48
 [<ffffffff881e285c>] ? :tuner:set_radio_freq+0x159/0x162
 [<ffffffff80449dfb>] ? klist_dec_and_del+0x14/0x16
 [<ffffffff80449e68>] ? klist_next+0x6b/0x8a
 [<ffffffff803c075a>] ? i2c_cmd+0x0/0x3e
 [<ffffffff8037c62f>] ? device_for_each_child+0x4c/0x5c
 [<ffffffff8813b648>] :videodev:__video_do_ioctl+0x139/0x2e25
 [<ffffffff88168b56>] ? :bttv:bttv_call_i2c_clients+0x16/0x18
 [<ffffffff88161ed2>] ? :bttv:audio_mux+0x105/0x1b5
 [<ffffffff80260d39>] ? filemap_fault+0x1fe/0x371
 [<ffffffff8813e6d4>] :videodev:video_ioctl2+0x1b8/0x259
 [<ffffffff8026dc63>] ? handle_mm_fault+0x341/0x697
 [<ffffffff80291c36>] vfs_ioctl+0x5e/0x77
 [<ffffffff80291e9c>] do_vfs_ioctl+0x24d/0x262
 [<ffffffff8045a9d7>] ? do_page_fault+0x434/0x7aa
 [<ffffffff80291ef3>] sys_ioctl+0x42/0x67
 [<ffffffff8020b36b>] system_call_after_swapgs+0x7b/0x80
Feb 15 08:42:03 bongani64 kernel:
Feb 15 08:42:03 bongani64 kernel:
Code: 89 fb 4c 89 e7 48 83 ec 20 65 4c 8b 34 25 00 00 00 00 e8 19 12 00 00 48 
8d 43 08 48 8d 55 c0 48 8b 48 08 48 89 45 c0 48 89 50 08 <48> 89 11 48 83 ca 
ff 48 89 4d c8 4c 89 75 d0 48 89 d0 87 03 ff
RIP  [<ffffffff8045723d>] __mutex_lock_slowpath+0x3b/0xb2
 RSP <ffff81007df515e8>
CR2: 0000000000000000
---[ end trace fdf145f4fc51dccd ]---
note: radio[7197] exited with preempt_count 1
