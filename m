Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbZABMwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbZABMwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 07:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757562AbZABMwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 07:52:24 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:40892 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757514AbZABMwX (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 07:52:23 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.28-mmotm1230 - BUG during 'shutdown -h'
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1230900738_3517P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 02 Jan 2009 07:52:18 -0500
Message-ID: <4491.1230900738@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1230900738_3517P
Content-Type: text/plain; charset=us-ascii

100% repeatable.  I haven't had a chance to bisect and track this down yet,
though most of the obvious suspects are in either origin.patch or linux-next.patch
so a bisect of -mmotm probably won't tell us much.

It makes it *almost* all the way down, and then loses. Oddly enough,
'shutdown -r' seems to work just fine - not sure why that would make a difference.

[   54.525193] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   54.566540] sd 0:0:0:0: [sda] Stopping disk
[   56.612216] ACPI: Preparing to enter system sleep state S5
[   56.652997] Disabling non-boot CPUs ...
[   56.692364] BUG: unable to handle kernel <3>hub 2-0:1.0: hub_port_status failed (err = -110)
[   56.692388] hub 2-0:1.0: hub_port_status failed (err = -110)
[   56.693298] paging request at 000077ff81ab133f
[   56.693298] IP: [<ffffffff8024605e>] queue_work_on+0x39/0x4b
[   56.693298] PGD 0 
[   56.693298] Oops: 0000 [#1] PREEMPT SMP 
[   56.693298] last sysfs file: /sys/devices/virtual/block/dm-13/dev
[   56.693298] CPU 0 
[   56.693298] Modules linked in: sha256_generic aes_x86_64 aes_generic rtc acpi_cpufreq tpm_tis tpm tpm_bios arc4 ecb gspca_spca561 iwl3945 gspca_main v4l2_compat_ioctl32 videodev mac80211 pcmcia snd_hda_codec_idt ohci1394 snd_hda_intel thermal led_class yenta_socket ieee1394 video intel_agp dell_laptop output rsrc_nonstatic iTCO_wdt pcmcia_core lib80211 uhci_hcd iTCO_vendor_support processor snd_hda_codec cfg80211 rfkill dcdbas ac battery button
[   56.693298] Pid: 1750, comm: halt Not tainted 2.6.28-mmotm1230 #2
[   56.693298] RIP: 0010:[<ffffffff8024605e>]  [<ffffffff8024605e>] queue_work_on+0x39/0x4b
[   56.693298] RSP: 0018:ffff88007ca2dd68  EFLAGS: 00010206
[   56.693298] RAX: 000077ff81ab133f RBX: 0000000000000000 RCX: ffff88007e54ef40
[   56.693298] RDX: 0000000000000000 RSI: ffff88007f22d9c0 RDI: 0000000000000000
[   56.693298] RBP: ffff88007ca2dd68 R08: 0000000000000002 R09: ffffffff806f9768
[   56.693298] R10: ffff88007ca2dd48 R11: 00000000000003c0 R12: ffffffff80535270
[   56.693298] R13: ffff88007ca2dda8 R14: ffffffff806f9768 R15: 0000000000000001
[   56.693298] FS:  00007f841a03b6f0(0000) GS:ffffffff806f9400(0000) knlGS:0000000000000000
[   56.693298] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   56.693298] CR2: 000077ff81ab133f CR3: 000000007ddc2000 CR4: 00000000000006e0
[   56.693298] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   56.693298] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   56.693298] Process halt (pid: 1750, threadinfo ffff88007ca2c000, task ffff88007e691800)
[   56.693298] Stack:
[   56.693298]  ffff88007ca2dd98 ffffffff8025f7b2 ffffffff806f9768 0000000000000001
[   56.693298]  0000000000000010 00000000ffffffea ffff88007ca2ddf8 ffffffff805353e5
[   56.693298]  0000000000000010 0000000000000001 0000000000000003 0000002100000000
[   56.693298] Call Trace:
[   56.693298]  [<ffffffff8025f7b2>] __stop_machine+0xc6/0x130
[   56.693298]  [<ffffffff805353e5>] _cpu_down+0x13d/0x298
[   56.693298]  [<ffffffff80236d46>] disable_nonboot_cpus+0x64/0x106
[   56.693298]  [<ffffffff8024460a>] kernel_power_off+0x21/0x3b
[   56.693298]  [<ffffffff80244872>] sys_reboot+0xe3/0x151
[   56.693298]  [<ffffffff8024bda9>] ? hrtimer_cancel+0x14/0x20
[   56.693298]  [<ffffffff80549b9d>] ? do_nanosleep+0x6c/0xa7
[   56.693298]  [<ffffffff8024bfc0>] ? hrtimer_nanosleep+0x8b/0xfc
[   56.693298]  [<ffffffff8024b853>] ? hrtimer_wakeup+0x0/0x21
[   56.693298]  [<ffffffff80549b7a>] ? do_nanosleep+0x49/0xa7
[   56.693298]  [<ffffffff8054a797>] ? trace_hardirqs_on_thunk+0x3a/0x3c
[   56.693298]  [<ffffffff8020b8db>] system_call_fastpath+0x16/0x1b
[   56.693298] Code: 00 19 c0 31 d2 85 c0 75 30 48 8d 46 08 48 39 46 08 74 04 0f 0b eb fe 83 79 20 00 48 8b 01 0f 45 3d 28 37 4b 00 48 f7 d0 48 63 d7 <48> 8b 3c d0 e8 45 ff ff ff ba 01 00 00 00 89 d0 c9 c3 55 48 89 
[   56.693298] RIP  [<ffffffff8024605e>] queue_work_on+0x39/0x4b
[   56.693298]  RSP <ffff88007ca2dd68>
[   56.693298] CR2: 000077ff81ab133f




--==_Exmh_1230900738_3517P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJXg4CcC3lWbTT17ARAsi9AKD2VjG0enQ3VyB6w4dOnkMrt9UjugCeLWAk
EseA7By/wd5NvkzxZi9mUU8=
=uUGh
-----END PGP SIGNATURE-----

--==_Exmh_1230900738_3517P--
