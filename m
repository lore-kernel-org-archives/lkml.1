Return-Path: <linux-kernel-owner+w=401wt.eu-S1752922AbYKZQVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbYKZQVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 11:21:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbYKZQUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 11:20:43 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:38274 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbYKZQUl (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 11:20:41 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.28-rc6-mmotm1126 - BUG in disk quota code
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1227716433_3559P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 26 Nov 2008 11:20:33 -0500
Message-ID: <4270.1227716433@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1227716433_3559P
Content-Type: text/plain; charset=us-ascii

System blew out when /etc/rc.sysinit did a 'quotaon -a'.  Not sure which
of the many quota-related commits in linux-next.patch or in -mm did this...

[   39.588815] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
[   39.589715] IP: [<0000000000000000>] 0x0
[   39.589715] PGD 0
[   39.589715] Oops: 0010 [#1] PREEMPT SMP
[   39.589715] last sysfs file: /sys/devices/virtual/block/dm-13/dev
[   39.589715] Dumping ftrace buffer:
[   39.589715]    (ftrace buffer empty)
[   39.589715] CPU 0
[   39.589715] Modules linked in: rtc acpi_cpufreq tpm_tis tpm tpm_bios arc4 ecb pcmcia iwl3945 rfkill mac80211 led_class lib80211 video yenta_socket output intel_agp cfg80211 button rsrc_nonstatic uhci_hcd ohci1394 thermal battery pcmcia_core iTCO_wdt dcdbas ac ieee1394 processor iTCO_vendor_support snd_hda_intel
[   39.589715] Pid: 1526, comm: quotaon Not tainted 2.6.28-rc6-mmotm1126 #1
[   39.589715] RIP: 0010:[<0000000000000000>]  [<0000000000000000>] 0x0
[   39.589715] RSP: 0018:ffff88007e12fd00  EFLAGS: 00010246
[   39.589715] RAX: ffffffff80740bb0 RBX: 0000000000000000 RCX: 0000000000000fe8
[   39.589715] RDX: 0000000000001514 RSI: 0000000000000001 RDI: ffff88007dc69c00
[   39.589715] RBP: ffff88007e12fd38 R08: ffff88007e12fcf8 R09: 00000000ffffffff
[   39.589715] R10: ffffffff8020ab8e R11: ffff88007e12faa8 R12: ffff88007bc47cb8
[   39.589715] R13: 0000000000000001 R14: ffff88007dc69c00 R15: 0000000000000000
[   39.589715] FS:  00007f1b84c616f0(0000) GS:ffffffff807b5500(0000) knlGS:0000000000000000
[   39.589715] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   39.589715] CR2: 0000000000000000 CR3: 000000007ec7b000 CR4: 00000000000006e0
[   39.589715] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   39.589715] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   39.589715] Process quotaon (pid: 1526, threadinfo ffff88007e12e000, task ffff88007f308040)
[   39.589715] Stack:
[   39.589715]  ffffffff802e974d 0000000000000fe8 0000000000000001 ffff88007bc47cb8
[   39.589715]  ffff88007bc47cc0 0000000000000000 0000000000000001 ffff88007e12fd78
[   39.589715]  ffffffff802e99ce ffff88007e12fd68 000000007bc6b3e0 ffff88007bc6b3e0
[   39.589715] Call Trace:
[   39.589715]  [<ffffffff802e974d>] ? dqget+0x104/0x2fd
[   39.589715]  [<ffffffff802e99ce>] dquot_initialize+0x88/0xbd
[   39.589715]  [<ffffffff8030d853>] ext3_dquot_initialize+0x56/0x77
[   39.589715]  [<ffffffff802e7854>] vfs_load_quota_inode+0x361/0x45e
[   39.589715]  [<ffffffff802e7c1b>] vfs_quota_on_path+0x4c/0x59
[   39.589715]  [<ffffffff80309dcc>] ext3_quota_on+0x153/0x170
[   39.589715]  [<ffffffff802ebff6>] sys_quotactl+0x408/0x6b6
[   39.589715]  [<ffffffff802a7431>] ? __fput+0x1c4/0x1d1
[   39.589715]  [<ffffffff8056a573>] ? trace_hardirqs_off_thunk+0x3a/0x6c
[   39.589715]  [<ffffffff8056a537>] ? trace_hardirqs_on_thunk+0x3a/0x3c
[   39.589715]  [<ffffffff8020bb3b>] system_call_fastpath+0x16/0x1b
[   39.589715] Code:  Bad RIP value.
[   39.589715] RIP  [<0000000000000000>] 0x0
[   39.589715]  RSP <ffff88007e12fd00>
[   39.589715] CR2: 0000000000000000
[   49.575587] ---[ end trace f5b21e7d583dfbbd ]---

I wonder where the system went for the 10 seconds between CR2 and 'end trace'?


--==_Exmh_1227716433_3559P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJLXdRcC3lWbTT17ARAuGdAKCxR8GxRnGsulNJtkKhN/OE+iNY/QCgxJWw
bY5aciyUhvwz+YdcJNHPhRU=
=zo/q
-----END PGP SIGNATURE-----

--==_Exmh_1227716433_3559P--
