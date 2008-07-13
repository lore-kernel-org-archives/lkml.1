Return-Path: <linux-kernel-owner+w=401wt.eu-S1755701AbYGNAcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbYGNAcV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 20:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbYGNAcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 20:32:10 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:51175 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916AbYGNAcI (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 20:32:08 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: 2.6.26-rc9-mmotm oops - suspect kernel-schedc-add-missing-attr-parameter.patch
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1215942353_3043P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 13 Jul 2008 05:45:53 -0400
Message-ID: <3741.1215942353@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1215942353_3043P
Content-Type: text/plain; charset=us-ascii

kernel-schedc-add-missing-attr-parameter.patch is my leading suspect, as it's
the last thing to poke around in the failing code...

My /etc/rc.local had this in it:

echo 1 > /sys/devices/system/cpu/sched_mc_power_savings

Which got me an oops:

[   84.048766] BUG: unable to handle kernel NULL pointer dereference at 0000000000000002
[   84.064254] IP: [<ffffffff8023092c>] sched_mc_power_savings_store+0x13/0x41
[   84.069253] PGD 7416d067 PUD 7438a067 PMD 0 
[   84.069253] Oops: 0000 [2] PREEMPT SMP 
[   84.069253] last sysfs file: /sys/devices/system/cpu/sched_mc_power_savings
[   84.069253] CPU 1 
[   84.069253] Modules linked in: irnet ppp_generic slhc irtty_sir sir_dev ircomm_tty ircomm irda crc_ccitt coretemp nf_conntrack_ftp xt_pkttype ipt_REJECT ipt_osf nf_conntrack_ipv4 xt_ipisforif ipt_recent ipt_LOG xt_u32 iptable_filter ip_tables xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6t_LOG xt_limit ip6table_filter ip6_tables x_tables sha256_generic aes_generic rtc acpi_cpufreq tpm_tis tpm tpm_bios pcmcia arc4 ecb dcdbas iwl3945 yenta_socket rfkill rsrc_nonstatic mac80211 gspca_spca561 pcmcia_core iTCO_wdt gspca_main ohci1394 video led_class compat_ioctl32 ieee1394 thermal tg3 iTCO_vendor_support output cfg80211 videodev firmware_class processor v4l1_compat libphy ac intel_agp button battery snd_hda_intel [last unloaded: microcode]
[   84.069253] Pid: 2649, comm: S99local Tainted: G      D   2.6.26-rc9-mm1 #2
[   84.069253] RIP: 0010:[<ffffffff8023092c>]  [<ffffffff8023092c>] sched_mc_power_savings_store+0x13/0x41
[   84.069253] RSP: 0018:ffff8800742ffe88  EFLAGS: 00010296
[   84.069253] RAX: fffffffffffffffb RBX: 0000000000000002 RCX: ffffffffffffffea
[   84.069253] RDX: 0000000000000002 RSI: ffff880074164000 RDI: ffffffff8072f850
[   84.069253] RBP: ffff8800742ffe98 R08: ffffffff80230919 R09: ffff880074164000
[   84.069253] R10: 000000000007050c R11: ffff8800742ffea8 R12: ffff88007433ff00
[   84.069253] R13: ffff88007f83bd78 R14: 00000000ffffffed R15: ffffffff8072f8c0
[   84.069253] FS:  00007f6fac7b96f0(0000) GS:ffff88007f877340(0000) knlGS:0000000000000000
[   84.069253] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   84.069253] CR2: 0000000000000002 CR3: 00000000742be000 CR4: 00000000000006e0
[   84.069253] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   84.069253] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   84.069254] Process S99local (pid: 2649, threadinfo ffff8800742fe000, task ffff880074134bc0)
[   84.069254] Stack:  ffff8800742ffea8 ffffffff8072f0d0 ffff8800742ffea8 ffffffff803f25f3
[   84.069254]  ffff8800742ffef8 ffffffff802ff31c ffff8800742fff48 ffff88007433ff20
[   84.069254]  ffffffff8072f0d0 ffff88007c805300 ffff8800742fff48 00007f6fac7cf000
[   84.069254] Call Trace:
[   84.069254]  [<ffffffff803f25f3>] sysdev_class_store+0x24/0x26
[   84.069254]  [<ffffffff802ff31c>] sysfs_write_file+0xe4/0x119
[   84.069254]  [<ffffffff802ad89d>] vfs_write+0xdc/0x188
[   84.069254]  [<ffffffff802ada21>] sys_write+0x47/0x84
[   84.069254]  [<ffffffff8020c4a0>] tracesys+0xd5/0xda
[   84.069254] 
[   84.069254] 
[   84.069254] Code: c7 40 7e 6e 80 89 c3 e8 09 c3 32 00 e8 d1 93 00 00 89 d8 41 58 5b c9 c3 55 48 89 e5 53 48 89 cb 48 83 ec 08 48 c7 c1 ea ff ff ff <8a> 12 8d 42 d0 3c 01 77 1d 31 c0 80 fa 31 0f 94 c0 89 05 c9 6a 
[   84.069254] RIP  [<ffffffff8023092c>] sched_mc_power_savings_store+0x13/0x41
[   84.069254]  RSP <ffff8800742ffe88>
[   84.069254] CR2: 0000000000000002
[   84.839443] ---[ end trace 1645799174bde4a2 ]---

Any ideas?


--==_Exmh_1215942353_3043P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIec7RcC3lWbTT17ARAq1eAKD0HBeTZEWeUim+gcUvBQV48nYJegCfZF0n
EEre8/hxj57UCThHjqi/Ns0=
=kaUZ
-----END PGP SIGNATURE-----

--==_Exmh_1215942353_3043P--
