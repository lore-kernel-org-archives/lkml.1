Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbYGNDTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbYGNDTg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 23:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756382AbYGNDTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 23:19:25 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:55323 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278AbYGNDTW (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 23:19:22 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: 2.6.26-rc9-mmotm oops - suspect kernel-schedc-add-missing-attr-parameter.patch
In-Reply-To: Your message of "Sun, 13 Jul 2008 05:45:53 EDT."
             <3741.1215942353@turing-police.cc.vt.edu>
From: Valdis.Kletnieks@vt.edu
References: <3741.1215942353@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1216005541_5013P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 13 Jul 2008 23:19:01 -0400
Message-ID: <21719.1216005541@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1216005541_5013P
Content-Type: text/plain; charset=us-ascii

On Sun, 13 Jul 2008 05:45:53 EDT, Valdis.Kletnieks@vt.edu said:
> --==_Exmh_1215942353_3043P
> Content-Type: text/plain; charset=us-ascii
> 
> kernel-schedc-add-missing-attr-parameter.patch is my leading suspect, as it's
> the last thing to poke around in the failing code...
> 
> My /etc/rc.local had this in it:
> 
> echo 1 > /sys/devices/system/cpu/sched_mc_power_savings
> 
> Which got me an oops:

powertop 1.11 just pulled another oops on me, that looks related:

[ 9802.991006] BUG: unable to handle kernel paging request at ffffffff802291c0
[ 9802.991006] IP: [<ffffffff8037fba0>] number+0x1e6/0x216
[ 9802.991006] PGD 203067 PUD 207063 PMD 7f84c163 PTE 229161
[ 9802.991006] Oops: 0003 [1] PREEMPT SMP 
[ 9802.991006] last sysfs file: /sys/devices/system/cpu/sched_mc_power_savings
[ 9802.991006] CPU 0 
[ 9802.991006] Modules linked in: irnet ppp_generic slhc irtty_sir sir_dev ircomm_tty ircomm irda crc_ccitt coretemp nf_conntrack_ftp xt_pkttype ipt_REJECT ipt_osf nf_conntrack_ipv4 xt_ipisforif ipt_recent ipt_LOG xt_u32 iptable_filter ip_tables xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6t_LOG xt_limit ip6table_filter ip6_tables x_tables sha256_generic aes_generic rtc acpi_cpufreq tpm_tis tpm tpm_bios pcmcia arc4 ecb iwl3945 yenta_socket rsrc_nonstatic rfkill pcmcia_core dcdbas ohci1394 nvidia(P) iTCO_wdt ieee1394 mac80211 video iTCO_vendor_support snd_hda_intel intel_agp output led_class thermal tg3 processor ac battery firmware_class button cfg80211 libphy [last unloaded: microcode]
[ 9802.991006] Pid: 21426, comm: powertop Tainted: P          2.6.26-rc9-mm1 #2
[ 9802.991006] RIP: 0010:[<ffffffff8037fba0>]  [<ffffffff8037fba0>] number+0x1e6/0x216
[ 9802.991006] RSP: 0018:ffff88005188dba8  EFLAGS: 00010293
[ 9802.991006] RAX: 0000000000000030 RBX: ffff88005188ddb8 RCX: 0000000000000000
[ 9802.991006] RDX: 00000000fffffffc RSI: 0000000000000000 RDI: 0000000000000000
[ 9802.991006] RBP: ffff88005188dc48 R08: 00000000ffffffff R09: 0000000000000000
[ 9802.991006] R10: ffffffffffffffff R11: 000000000000000a R12: ffffffff802291c0
[ 9802.991006] R13: 00000000ffffffff R14: 0000000000000000 R15: 0000000000000000
[ 9802.991006] FS:  00007f85234d76f0(0000) GS:ffffffff80770ec0(0000) knlGS:0000000000000000
[ 9802.991006] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 9802.991006] CR2: ffffffff802291c0 CR3: 0000000067285000 CR4: 00000000000006e0
[ 9802.991006] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 9802.991006] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 9802.991006] Process powertop (pid: 21426, threadinfo ffff88005188c000, task ffff88005afe1600)
[ 9802.991006] Stack:  ffffffff80348e86 0000000000000001 ffff88005188dbf8 00ffffffffffffff
[ 9802.991006]  ffffffff80349430 ffffffff80349e86 0000000000000001 ffff88006bc43fb0
[ 9802.991006]  0000000000000203 000000000000002d ffff88005188dc18 ffffffff80561638
[ 9802.991006] Call Trace:
[ 9802.991006]  [<ffffffff80348e86>] ? avc_has_perm_noaudit+0x4e/0x62b
[ 9802.991006]  [<ffffffff80349430>] ? avc_has_perm_noaudit+0x5f8/0x62b
[ 9802.991006]  [<ffffffff80349e86>] ? avc_has_perm+0x31/0x60
[ 9802.991006]  [<ffffffff80561638>] ? sub_preempt_count+0x60/0x75
[ 9802.991006]  [<ffffffff8025a95a>] ? __lock_acquire+0x6e/0x1131
[ 9802.991006]  [<ffffffff802291c0>] ? sched_mc_power_savings_show+0x0/0x1f
[ 9802.991006]  [<ffffffff803808dc>] vsnprintf+0x59e/0x5f0
[ 9802.991006]  [<ffffffff802291c0>] ? sched_mc_power_savings_show+0x0/0x1f
[ 9802.991006]  [<ffffffff8025903b>] ? trace_hardirqs_off+0xd/0xf
[ 9802.991006]  [<ffffffff8029b1b1>] ? vma_adjust+0x239/0x475
[ 9802.991006]  [<ffffffff80281c68>] ? trace_preempt_on+0x58/0x127
[ 9802.991006]  [<ffffffff8055e52c>] ? _spin_unlock+0x30/0x60
[ 9802.991006]  [<ffffffff8029b37e>] ? vma_adjust+0x406/0x475
[ 9802.991006]  [<ffffffff802816fd>] ? trace_preempt_off+0x3c/0x120
[ 9802.991006]  [<ffffffff80281c68>] ? trace_preempt_on+0x58/0x127
[ 9802.991006]  [<ffffffff8028a344>] ? get_page_from_freelist+0x4eb/0x5ff
[ 9802.991006]  [<ffffffff8028a63d>] ? __alloc_pages_internal+0x10b/0x48f
[ 9802.991006]  [<ffffffff80561638>] ? sub_preempt_count+0x60/0x75
[ 9802.991006]  [<ffffffff8028a367>] ? get_page_from_freelist+0x50e/0x5ff
[ 9802.991006]  [<ffffffff80380996>] sprintf+0x68/0x6a
[ 9802.991006]  [<ffffffff802ffd67>] ? sysfs_get_active+0x6b/0x87
[ 9802.991006]  [<ffffffff802291db>] sched_mc_power_savings_show+0x1b/0x1f
[ 9802.991006]  [<ffffffff803f25cd>] sysdev_class_show+0x20/0x22
[ 9802.991006]  [<ffffffff802ff40b>] sysfs_read_file+0xba/0x13c
[ 9802.991006]  [<ffffffff802adb37>] vfs_read+0xd9/0x186
[ 9802.991006]  [<ffffffff802adcbc>] sys_read+0x47/0x82
[ 9802.991006]  [<ffffffff8020c4a0>] tracesys+0xd5/0xda
[ 9802.991006] 
[ 9802.991006] 
[ 9802.991006] Code: 24 49 ff c4 ff ca 79 f0 eb 0d 4d 39 d4 73 05 41 c6 04 24 30 49 ff c4 ff c9 39 cf 7e ed eb 13 4d 39 d4 73 0b 48 63 c7 8a 44 05 80 <41> 88 04 24 49 ff c4 ff cf 79 e9 eb 0d 4d 39 d4 73 05 41 c6 04 
[ 9802.991006] RIP  [<ffffffff8037fba0>] number+0x1e6/0x216
[ 9802.991006]  RSP <ffff88005188dba8>
[ 9802.991006] CR2: ffffffff802291c0
[ 9802.991006] ---[ end trace 99d439c20d808858 ]---
[ 9802.991006] BUG: sleeping function called from invalid context at kernel/rwsem.c:21
[ 9802.991006] in_atomic():0, irqs_disabled():1
[ 9802.991006] INFO: lockdep is turned off.
[ 9802.991006] irq event stamp: 0
[ 9802.991006] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[ 9802.991006] hardirqs last disabled at (0): [<ffffffff80236b1d>] copy_process+0x466/0x14fa
[ 9802.991006] softirqs last  enabled at (0): [<ffffffff80236b1d>] copy_process+0x466/0x14fa
[ 9802.991006] softirqs last disabled at (0): [<0000000000000000>] 0x0
[ 9802.991006] Pid: 21426, comm: powertop Tainted: P      D   2.6.26-rc9-mm1 #2
[ 9802.991006] 
[ 9802.991006] Call Trace:
[ 9802.991006]  [<ffffffff80258020>] ? print_irqtrace_events+0x10a/0x10f
[ 9802.991006]  [<ffffffff8022f9a5>] __might_sleep+0x107/0x109
[ 9802.991006]  [<ffffffff8055cdb8>] down_read+0x1d/0x45
[ 9802.991006]  [<ffffffff80266732>] acct_collect+0x42/0x1a4
[ 9802.991006]  [<ffffffff8023c0cf>] do_exit+0x2fe/0x91a
[ 9802.991006]  [<ffffffff8055f35c>] oops_begin+0x0/0x90
[ 9802.991006]  [<ffffffff802291c0>] ? sched_mc_power_savings_show+0x0/0x1f
[ 9802.991006]  [<ffffffff805614fc>] do_page_fault+0x92c/0xa08
[ 9802.991006]  [<ffffffff80281c68>] ? trace_preempt_on+0x58/0x127
[ 9802.991006]  [<ffffffff80348e86>] ? avc_has_perm_noaudit+0x4e/0x62b
[ 9802.991006]  [<ffffffff80281c68>] ? trace_preempt_on+0x58/0x127
[ 9802.991006]  [<ffffffff80349408>] ? avc_has_perm_noaudit+0x5d0/0x62b
[ 9802.991006]  [<ffffffff80349e86>] ? avc_has_perm+0x31/0x60
[ 9802.991006]  [<ffffffff80561638>] ? sub_preempt_count+0x60/0x75
[ 9802.991006]  [<ffffffff8034942b>] ? avc_has_perm_noaudit+0x5f3/0x62b
[ 9802.991006]  [<ffffffff8025a95a>] ? __lock_acquire+0x6e/0x1131
[ 9802.991006]  [<ffffffff8025a95a>] ? __lock_acquire+0x6e/0x1131
[ 9802.991006]  [<ffffffff802291c0>] ? sched_mc_power_savings_show+0x0/0x1f
[ 9802.991006]  [<ffffffff8055ec7d>] error_exit+0x0/0xa9
[ 9802.991006]  [<ffffffff802291c0>] ? sched_mc_power_savings_show+0x0/0x1f
[ 9802.991006]  [<ffffffff8037fba0>] ? number+0x1e6/0x216
[ 9802.991006]  [<ffffffff80348e86>] ? avc_has_perm_noaudit+0x4e/0x62b
[ 9802.991006]  [<ffffffff80349430>] ? avc_has_perm_noaudit+0x5f8/0x62b
[ 9802.991006]  [<ffffffff80349e86>] ? avc_has_perm+0x31/0x60
[ 9802.991006]  [<ffffffff80561638>] ? sub_preempt_count+0x60/0x75
[ 9802.991006]  [<ffffffff8025a95a>] ? __lock_acquire+0x6e/0x1131
[ 9802.991006]  [<ffffffff802291c0>] ? sched_mc_power_savings_show+0x0/0x1f
[ 9802.991006]  [<ffffffff803808dc>] vsnprintf+0x59e/0x5f0
[ 9802.991006]  [<ffffffff802291c0>] ? sched_mc_power_savings_show+0x0/0x1f
[ 9802.991006]  [<ffffffff8025903b>] ? trace_hardirqs_off+0xd/0xf
[ 9802.991006]  [<ffffffff8029b1b1>] ? vma_adjust+0x239/0x475
[ 9802.991006]  [<ffffffff80281c68>] ? trace_preempt_on+0x58/0x127
[ 9802.991006]  [<ffffffff8055e52c>] ? _spin_unlock+0x30/0x60
[ 9802.991006]  [<ffffffff8029b37e>] ? vma_adjust+0x406/0x475
[ 9802.991006]  [<ffffffff802816fd>] ? trace_preempt_off+0x3c/0x120
[ 9802.991006]  [<ffffffff80281c68>] ? trace_preempt_on+0x58/0x127
[ 9802.991006]  [<ffffffff8028a344>] ? get_page_from_freelist+0x4eb/0x5ff
[ 9802.991006]  [<ffffffff8028a63d>] ? __alloc_pages_internal+0x10b/0x48f
[ 9802.991006]  [<ffffffff80561638>] ? sub_preempt_count+0x60/0x75
[ 9802.991006]  [<ffffffff8028a367>] ? get_page_from_freelist+0x50e/0x5ff
[ 9802.991006]  [<ffffffff80380996>] sprintf+0x68/0x6a
[ 9802.991006]  [<ffffffff802ffd67>] ? sysfs_get_active+0x6b/0x87
[ 9802.991006]  [<ffffffff802291db>] sched_mc_power_savings_show+0x1b/0x1f
[ 9802.991006]  [<ffffffff803f25cd>] sysdev_class_show+0x20/0x22
[ 9802.991006]  [<ffffffff802ff40b>] sysfs_read_file+0xba/0x13c
[ 9802.991006]  [<ffffffff802adb37>] vfs_read+0xd9/0x186
[ 9802.991006]  [<ffffffff802adcbc>] sys_read+0x47/0x82
[ 9802.991006]  [<ffffffff8020c4a0>] tracesys+0xd5/0xda
[ 9802.991006] 


--==_Exmh_1216005541_5013P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIesWlcC3lWbTT17ARArt/AJ9/zxNzfHPohPhXkI/lveAVZIVHwwCeO/gs
zq98sjuWbMPZNd9ER0e3PWw=
=ZRE+
-----END PGP SIGNATURE-----

--==_Exmh_1216005541_5013P--
