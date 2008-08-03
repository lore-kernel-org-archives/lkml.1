Return-Path: <linux-kernel-owner+w=401wt.eu-S1758155AbYHCRDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbYHCRDc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 13:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756564AbYHCRDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 13:03:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:53734 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756285AbYHCRDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 13:03:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Mi7nJAZjXb6Bbcsg34BXop0PvZJP2QqijdRhSvwy9lAz0W1yGUIJizrwdf/QH5hlQe
         xQlBnkxBCcx01alzqY43GiXZLNNxuE/V9iROlZqEtk3kPDTVSBcXlEUaPBwYCW/mQIxR
         1HHAUoTjouXHmQPPFBMkGp/jv5YTq9RWsd4Y4=
Date: Sun, 3 Aug 2008 19:02:44 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       "Denis V. Lunev" <den@openvz.org>
Subject: oops in rt_cache_invalidate (2.6.27-rc1-2b12a4c)
Message-ID: <20080803170241.GD5414@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[   21.035097] Adding 1020112k swap on /dev/sda2.  Priority:-1 extents:1 across:1020112k
[   22.340292] BUG: unable to handle kernel NULL pointer dereference at 00000000000002c0
[   22.341002] IP: [<ffffffff80442a7e>] rt_cache_invalidate+0x25/0x32
[   22.341002] PGD 3dc7c067 PUD 3d198067 PMD 0
[   22.341002] Oops: 0002 [1] PREEMPT
[   22.341002] CPU 0
[   22.341002] Modules linked in: usbhid uhci_hcd tuner tea5767 tda8290 tuner_xc2028 xc5000 tda9887 tuner_simple tuner_types mt20xx tea5761 tda9875 ehci_hcd usbcore bttv ir_common compat_ioctl32 videodev v4l1_compat i2c_algo_bit snd_via82xx snd_ac97_codec v4l2_common ac97_bus snd_pcm videobuf_dma_sg snd_timer snd_page_alloc i2c_viapro videobuf_core btcx_risc snd_mpu401_uart snd_rawmidi tveeprom snd_seq_device snd soundcore
[   22.341002] Pid: 2248, comm: sysctl Not tainted 2.6.27-rc1-00507-g75aecb1 #261
[   22.341002] RIP: 0010:[<ffffffff80442a7e>]  [<ffffffff80442a7e>] rt_cache_invalidate+0x25/0x32
[   22.341002] RSP: 0018:ffff88003cd6de08  EFLAGS: 00010202
[   22.341002] RAX: 0000000000000052 RBX: 0000000000000000 RCX: 0000000000000000
[   22.341002] RDX: ffff88003cd6dda8 RSI: ffff88003cd6dda9 RDI: ffff88003cd6ddb2
[   22.341002] RBP: ffff88003cd6de28 R08: 0000000000000000 R09: ffff88003cd6dbb8
[   22.341002] R10: 00000000a94180f7 R11: ffff88003cd6dc0c R12: 0000000000000001
[   22.341002] R13: ffffffff8062a90c R14: 0000000000000000 R15: 0000000000000040
[   22.341002] FS:  00007f0674ee66f0(0000) GS:ffffffff80625200(0000) knlGS:0000000000000000
[   22.341002] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   22.341002] CR2: 00000000000002c0 CR3: 000000003d1a3000 CR4: 00000000000006e0
[   22.341002] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   22.341002] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   22.341002] Process sysctl (pid: 2248, threadinfo ffff88003cd6c000, task ffff88003d0dd900)
[   22.341002] Stack:  ffff88003cd6de38 ffffffff80233c93 51ff88003cd6df48 0000000000000000
[   22.341002]  ffff88003cd6de58 ffffffff80442c4c ffffffff80620740 0000000000000001
[   22.341002]  ffffffff8062a90c 0000000000000000 ffff88003cd6de98 ffffffff8046a63b
[   22.341002] Call Trace:
[   22.341002]  [<ffffffff80233c93>] ? do_proc_dointvec+0x3d/0x3f
[   22.341002]  [<ffffffff80442c4c>] rt_cache_flush+0x17/0xe2
[   22.341002]  [<ffffffff8046a63b>] ipv4_doint_and_flush+0x42/0x52
[   22.341002]  [<ffffffff802d263b>] proc_sys_call_handler+0x96/0xbb
[   22.341002]  [<ffffffff802d2674>] proc_sys_write+0x14/0x16
[   22.341002]  [<ffffffff8028f8fd>] vfs_write+0xb3/0x13c
[   22.341002]  [<ffffffff8028fdd0>] sys_write+0x4c/0x74
[   22.341002]  [<ffffffff8020b3fb>] system_call_fastpath+0x16/0x1b
[   22.341002]
[   22.341002]
[   22.341002] Code: 18 01 00 00 c9 c3 55 48 89 e5 53 48 83 ec 18 66 66 90 66 90 be 01 00 00 00 48 89 fb 48 8d 7d f7 e8 a3 fd f5 ff 0f b6 45 f7 ff c0 <01> 83 c0 02 00 00 48 83 c4 18 5b c9 c3 55 48 89 e5 53 48 83 ec
[   22.341002] RIP  [<ffffffff80442a7e>] rt_cache_invalidate+0x25/0x32
[   22.341002]  RSP <ffff88003cd6de08>
[   22.341002] CR2: 00000000000002c0
[   23.182975] ---[ end trace cc508a4cd3aa37ce ]---
[   33.359352] NET: Registered protocol family 17
[   36.346255] Marking TSC unstable due to cpufreq changes
[   40.893522] Clocksource tsc unstable (delta = -221374484 ns)

It's 2b12a4c524812fb3f6ee590a02e65b95c8c32229 + some unreleated trivial patches.
