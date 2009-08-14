Return-Path: <linux-kernel-owner+w=401wt.eu-S1752111AbZHNJLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbZHNJLw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 05:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbZHNJLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 05:11:51 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:55550 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbZHNJLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 05:11:50 -0400
Date: Fri, 14 Aug 2009 11:11:50 +0200
To: linux-kernel@vger.kernel.org
Subject: kernel bug at shut down
Message-ID: <20090814091150.GA20856@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

shutting down 2.6.31-rc5 I got that one:

[ 9978.061946] BUG: unable to handle kernel paging request at 0000000100000444
[ 9978.062076] IP: [<ffffffff811d51ee>] device_shutdown+0x1f/0x81
[ 9978.062176] PGD 10d520067 PUD 0 
[ 9978.062297] Oops: 0000 [#1] PREEMPT SMP 
[ 9978.062456] last sysfs file: /sys/devices/pci0000:00/0000:00:1c.1/0000:06:00.0/power_level
[ 9978.062523] CPU 0 
[ 9978.062608] Modules linked in: udf usb_storage binfmt_misc bnep rfcomm sco l2cap hso isofs vfat fat dm_crypt dm_mod loop snd_hda_codec_realtek arc4 snd_hda_intel iwlagn snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss iwlcore snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi_event mac80211 snd_seq snd_timer btusb snd_seq_device sony_laptop snd bluetooth cfg80211 soundcore snd_page_alloc firewire_ohci rfkill joydev firewire_core crc_itu_t tpm_infineon [last unloaded: fuse]
[ 9978.064415] Pid: 21763, comm: reboot Not tainted 2.6.31-rc5 #4 VGN-Z11VN_B
[ 9978.064470] RIP: 0010:[<ffffffff811d51ee>]  [<ffffffff811d51ee>] device_shutdown+0x1f/0x81
[ 9978.064575] RSP: 0018:ffff880130ae1e28  EFLAGS: 00010202
[ 9978.064579] RAX: 0000000100000404 RBX: ffff88013f983368 RCX: 0000000000000001
[ 9978.064579] RDX: 0000000000000303 RSI: 0000000000000003 RDI: ffff88013fa56b38
[ 9978.064579] RBP: 0000000028121969 R08: 0000000000000000 R09: 0000000000000002
[ 9978.064579] R10: ffffffff813ede02 R11: ffffffff813ede02 R12: 00000000fee1dead
[ 9978.064579] R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000000
[ 9978.064579] FS:  00007f8de7d746f0(0000) GS:ffff880028023000(0000) knlGS:0000000000000000
[ 9978.064579] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 9978.064579] CR2: 0000000100000444 CR3: 00000001058a4000 CR4: 00000000000006f0
[ 9978.064579] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 9978.064579] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 9978.064579] Process reboot (pid: 21763, threadinfo ffff880130ae0000, task ffff88013ea12300)
[ 9978.064579] Stack:
[ 9978.064579]  0000000000000000 ffffffff81044837 0000000000000000 ffffffff8104486d
[ 9978.064579] <0> 0000000001234567 ffffffff810449c6 0000000000000000 ffff880133940d88
[ 9978.064579] <0> ffff880133a3e180 ffffffff8131a0ce 00007ffff5e7ce50 0000000000000246
[ 9978.064579] Call Trace:
[ 9978.064579]  [<ffffffff81044837>] ? kernel_restart_prepare+0x27/0x2d
[ 9978.064579]  [<ffffffff8104486d>] ? kernel_restart+0x9/0x38
[ 9978.064579]  [<ffffffff810449c6>] ? sys_reboot+0x123/0x14e
[ 9978.064579]  [<ffffffff8131a0ce>] ? _spin_unlock+0x2f/0x3b
[ 9978.064579]  [<ffffffff8109f6e0>] ? d_kill+0x4c/0x55
[ 9978.064579]  [<ffffffff8109fda6>] ? dput+0x23/0x144
[ 9978.064579]  [<ffffffff810a5985>] ? mntput_no_expire+0x23/0xf1
[ 9978.064579]  [<ffffffff810900fe>] ? filp_close+0x5b/0x62
[ 9978.064579]  [<ffffffff810901a4>] ? sys_close+0x9f/0xdd
[ 9978.064579]  [<ffffffff8100afab>] ? system_call_fastpath+0x16/0x1b
[ 9978.064579] Code: f5 ff c3 48 8b 7f 60 e9 e8 ff ff ff 53 48 8b 05 a1 f6 38 00 48 8b 40 08 48 8d 78 e8 48 8b 47 20 eb 30 48 8b 47 78 48 85 c0 74 09 <48> 8b 40 40 48 85 c0 75 15 48 8b 87 80 00 00 00 48 85 c0 74 0b 
[ 9978.064579] RIP  [<ffffffff811d51ee>] device_shutdown+0x1f/0x81
[ 9978.064579]  RSP <ffff880130ae1e28>
[ 9978.064579] CR2: 0000000100000444
[ 9978.069233] ---[ end trace 3b64919c3e911cb8 ]---

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
RAMSGATE (n.)
All institutional buildings must, by law, contain at least twenty
ramsgates. These are doors which open the opposite way to the one you
expect.
			--- Douglas Adams, The Meaning of Liff
