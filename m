Return-Path: <linux-kernel-owner+w=401wt.eu-S1751715AbZGCBwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715AbZGCBwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 21:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbZGCBw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 21:52:29 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:54099 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbZGCBw2 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 21:52:28 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Subject: mmotm 2009-06-30-12-50 dies during early boot
In-Reply-To: Your message of "Tue, 30 Jun 2009 12:51:30 PDT."
             <200906301951.n5UJpUSY013305@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <200906301951.n5UJpUSY013305@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1246585948_9623P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 02 Jul 2009 21:52:28 -0400
Message-ID: <11314.1246585948@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1246585948_9623P
Content-Type: text/plain; charset=us-ascii

On Tue, 30 Jun 2009 12:51:30 PDT, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2009-06-30-12-50 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

(Would have gotten this out the door earlier, but I got confused about what
that 'G' in the 'Tainted' meant, and put off reporting till I could reproduce
it without the NVidia driver. Turns out it was untainted except for the
warning I already reported...)

Dies fairly early during boot, somewhere in the first few lines of rc.sysinit.

It *looks* like it dies in this call:

	wake_up_interruptible(&current->real_parent->signal->wait_chldexit);

in selinux_bprm_committed_creds().  Not sure which part of that is the duff
pointer, though...

[   16.829082] hub 1-2:1.0: hub_suspend
[   16.848165] usb 1-2: unlink qh256-0001/ffff88007e053140 start 1 [1/0 us]
[   16.867813] usb 1-2: usb auto-suspend
[   17.827106] cat used greatest stack depth: 4280 bytes left
[   17.846392] Oops: 0000 [#1] PREEMPT SMP 
[   17.847007] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/sda2/dev
[   17.847007] CPU 0 
[   17.847007] Modules linked in:
[   17.847007] Pid: 887, comm: mount Tainted: G        W  2.6.31-rc1-mmotm0630 #1 Latitude D820                   
[   17.847007] RIP: 0010:[<ffffffff81040873>]  [<ffffffff81040873>] child_wait_callback+0x3d/0x5f
[   17.847007] RSP: 0018:ffff88007f051c28  EFLAGS: 00010046
[   17.847007] RAX: 000000000000000e RBX: 0000000000000001 RCX: 0000000000000000
[   17.847007] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88007eb9bf20
[   17.847007] RBP: ffff88007f051c28 R08: 0000000000000000 R09: 0000000000000001
[   17.847007] R10: ffff88007f051c68 R11: ffff88007f051c68 R12: 0000000000000001
[   17.847007] R13: ffff88007f9965e0 R14: 0000000000000000 R15: 0000000000000000
[   17.847007] FS:  00007fa8f6c646f0(0000) GS:ffff880002121000(0000) knlGS:0000000000000000
[   17.847007] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   17.847007] CR2: 0000000000000270 CR3: 000000007fb3f000 CR4: 00000000000006f0
[   17.847007] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   17.847007] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   17.847007] Process mount (pid: 887, threadinfo ffff88007f050000, task ffff88007eb96a80)
[   17.847007] Stack:
[   17.847007]  ffff88007f051c78 ffffffff8102df4a 0000000000000000 ffff88007f9965f8
[   17.847007] <0> ffff88007f051c78 ffff88007f9965c8 0000000000000282 ffff88007e3acbc0
[   17.847007] <0> ffff88007f051f58 00007fd172b0faf0 ffff88007f051cb8 ffffffff810305d8
[   17.847007] Call Trace:
[   17.847007]  [<ffffffff8102df4a>] __wake_up_common+0x49/0x7f
[   17.847007]  [<ffffffff810305d8>] __wake_up+0x34/0x48
[   17.847007]  [<ffffffff81176a19>] selinux_bprm_committed_creds+0x11d/0x132
[   17.847007]  [<ffffffff8105be4d>] ? commit_creds+0x1d5/0x1df
[   17.847007]  [<ffffffff8116dc46>] security_bprm_committed_creds+0x11/0x13
[   17.847007]  [<ffffffff810d5420>] install_exec_creds+0x30/0x35
[   17.847007]  [<ffffffff81110de5>] load_elf_binary+0x10d1/0x1990
[   17.847007]  [<ffffffff814a8bc0>] ? sub_preempt_count+0x35/0x48
[   17.847007]  [<ffffffff810d5101>] search_binary_handler+0xbd/0x2cc
[   17.847007]  [<ffffffff8110fd14>] ? load_elf_binary+0x0/0x1990
[   17.847007]  [<ffffffff810d69e8>] do_execve+0x26e/0x3c2
[   17.847007]  [<ffffffff81009b15>] sys_execve+0x5b/0x78
[   17.847007]  [<ffffffff8100b7ca>] stub_execve+0x6a/0xc0
[   17.847007] Code: 81 00 03 00 00 eb 14 89 c0 48 6b c0 18 48 03 81 c0 02 00 00 48 8b 80 00 03 00 00 48 3b 47 e0 75 21 8b 47 dc 41 89 c0 41 c1 e8 1f <83> b9 70 02 00 00 11 41 0f 95 c1 45 38 c1 74 0b a9 00 00 00 40 
[   17.847007] RIP  [<ffffffff81040873>] child_wait_callback+0x3d/0x5f
[   17.847007]  RSP <ffff88007f051c28>
[   17.847007] CR2: 0000000000000270
[   17.847007] ---[ end trace a7919e7f17c0a727 ]---
[   17.847007] note: mount[887] exited with preempt_count 2
[   27.655913] usb 1-8.3: khubd timed out on ep0in len=0/64
[   27.655958] BUG: scheduling while atomic: mount/887/0x10000003
[   27.655960] INFO: lockdep is turned off.
[   27.655962] Modules linked in:
[   27.655965] Pid: 887, comm: mount Tainted: G      D W  2.6.31-rc1-mmotm0630 #1
[   27.655967] Call Trace:
[   27.655973]  [<ffffffff81065361>] ? __debug_show_held_locks+0x1b/0x24
[   27.655978]  [<ffffffff81034afb>] __schedule_bug+0x6d/0x72
[   27.655982]  [<ffffffff814a339e>] schedule+0xf0/0x934
[   27.655987]  [<ffffffff810e73ef>] ? mntput_no_expire+0x24/0x145
[   27.655991]  [<ffffffff810cb61d>] ? __cache_free+0x45/0xf1
[   27.655996]  [<ffffffff81035abf>] __cond_resched+0x24/0x39
[   27.655999]  [<ffffffff814a3dad>] _cond_resched+0x2d/0x38
[   27.656017]  [<ffffffff81040ca0>] put_files_struct+0x6c/0xbe
[   27.656020]  [<ffffffff81040d38>] exit_files+0x46/0x4f
[   27.656024]  [<ffffffff81042a58>] do_exit+0x3a6/0x97d
[   27.656028]  [<ffffffff814a732e>] oops_end+0x89/0x8e
[   27.656032]  [<ffffffff81025a6c>] no_context+0x1f1/0x200
[   27.656036]  [<ffffffff81025c21>] __bad_area_nosemaphore+0x1a6/0x1ef
[   27.656040]  [<ffffffff81065b01>] ? trace_hardirqs_on_caller+0x1f/0x145
[   27.656044]  [<ffffffff81064e9f>] ? trace_hardirqs_off_caller+0x1f/0xa2
[   27.656047]  [<ffffffff81064f2f>] ? trace_hardirqs_off+0xd/0xf
[   27.656051]  [<ffffffff81064e9f>] ? trace_hardirqs_off_caller+0x1f/0xa2
[   27.656055]  [<ffffffff81034117>] ? get_parent_ip+0x11/0x41
[   27.656058]  [<ffffffff81025c78>] bad_area_nosemaphore+0xe/0x10
[   27.656062]  [<ffffffff814a8913>] do_page_fault+0x204/0x47c
[   27.656066]  [<ffffffff814a5739>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   27.656070]  [<ffffffff814a674f>] page_fault+0x1f/0x30
[   27.656074]  [<ffffffff81040873>] ? child_wait_callback+0x3d/0x5f
[   27.656079]  [<ffffffff811bca7e>] ? _raw_spin_lock+0xe3/0x196
[   27.656083]  [<ffffffff8102df4a>] __wake_up_common+0x49/0x7f
[   27.656087]  [<ffffffff810305d8>] __wake_up+0x34/0x48
[   27.656091]  [<ffffffff81176a19>] selinux_bprm_committed_creds+0x11d/0x132
[   27.656095]  [<ffffffff8105be4d>] ? commit_creds+0x1d5/0x1df
[   27.656098]  [<ffffffff8116dc46>] security_bprm_committed_creds+0x11/0x13
[   27.656102]  [<ffffffff810d5420>] install_exec_creds+0x30/0x35
[   27.656106]  [<ffffffff81110de5>] load_elf_binary+0x10d1/0x1990
[   27.656111]  [<ffffffff814a8bc0>] ? sub_preempt_count+0x35/0x48
[   27.656114]  [<ffffffff810d5101>] search_binary_handler+0xbd/0x2cc
[   27.656118]  [<ffffffff8110fd14>] ? load_elf_binary+0x0/0x1990
[   27.656122]  [<ffffffff810d69e8>] do_execve+0x26e/0x3c2
[   27.656126]  [<ffffffff81009b15>] sys_execve+0x5b/0x78
[   27.656130]  [<ffffffff8100b7ca>] stub_execve+0x6a/0xc0
[   27.656157] mount used greatest stack depth: 3920 bytes left


--==_Exmh_1246585948_9623P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKTWRccC3lWbTT17ARAkOUAKDRKViNV3ZlqrPS/h46LnfiLzI8AwCg/tla
nqvpSSLQOPaKyujy4DmGZ34=
=NDsN
-----END PGP SIGNATURE-----

--==_Exmh_1246585948_9623P--
