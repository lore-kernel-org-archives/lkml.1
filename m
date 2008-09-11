Return-Path: <linux-kernel-owner+w=401wt.eu-S1754925AbYIKPTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbYIKPTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 11:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYIKPTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 11:19:24 -0400
Received: from lnx500.hrz.tu-darmstadt.de ([130.83.156.225]:57209 "EHLO
	lnx500.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751908AbYIKPTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 11:19:22 -0400
X-Greylist: delayed 1409 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Sep 2008 11:19:22 EDT
Subject: INFO: task python:12803 blocked for more than 120 seconds. ->
	Locking Problem?
From: Erik Tews <e_tews@cdc.informatik.tu-darmstadt.de>
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Ralf-Philipp Weinmann <weinmann@cdc.informatik.tu-darmstadt.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ADQFDmkRrANpn8+o/cqc"
Date: Thu, 11 Sep 2008 16:55:32 +0200
Message-Id: <1221144932.5484.13.camel@tp.cdc.informatik.tu-darmstadt.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-PMX: seen v0.2
X-PMX-SPAMCHECK: outgoing mail: not checked
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ADQFDmkRrANpn8+o/cqc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi

I am running Linux 2.6.25-2-amd64 (Debian) on a Sun X4440 server with 4x
4 Core Opteron CPUs and 128 GB main memory. The box is mostly runnung
some processes doing sientific calculations, which need a lot of main
memory, but don't span a high number of threads or processes. The root
filesystem is xfs, but home directorys are mounted via nfs from another
linux box. The load is usually below 20.

Sometimes, some processes start to block, top shows them at state
running, but not using any CPU time. Strace doesn't show any system
calls on these processes, so there is no visible activity. When that
happens, the kernel prints out backtraces like:

Sep  5 02:51:07 userver2 kernel: [4689104.636007] INFO: task pdflush:13852 =
blocked for more than 120 seconds.
Sep  5 02:51:07 userver2 kernel: [4689104.636074] "echo 0 > /proc/sys/kerne=
l/hung_task_timeout_secs" disables this message.
Sep  5 02:51:07 userver2 kernel: [4689104.636156] pdflush       D ffff81182=
3ecc0f0     0 13852      2
Sep  5 02:51:07 userver2 kernel: [4689104.636211]  ffff810a1c6e5860 0000000=
000000046 ffff8104d86969c0 ffff8104d86969c0
Sep  5 02:51:07 userver2 kernel: [4689104.636300]  ffff81102312f180 ffff812=
023001500 ffff81102312f3f0 000000001c6e59e0
Sep  5 02:51:07 userver2 kernel: [4689104.636384]  ffff810a1c6e59e0 ffff810=
a1c6e59c0 ffff8104d86969a0 ffff810a1c6e5a28
Sep  5 02:51:07 userver2 kernel: [4689104.636440] Call Trace:
Sep  5 02:51:07 userver2 kernel: [4689104.636552]  [<ffffffff8041e162>] sch=
edule_timeout+0x1e/0xad
Sep  5 02:51:07 userver2 kernel: [4689104.636615]  [<ffffffff80246c09>] add=
_wait_queue_exclusive+0x15/0x41
Sep  5 02:51:07 userver2 kernel: [4689104.636723]  [<ffffffff881f2358>] :xf=
s:xlog_grant_log_space+0xc4/0x253
Sep  5 02:51:07 userver2 kernel: [4689104.636784]  [<ffffffff8022d463>] def=
ault_wake_function+0x0/0xe
Sep  5 02:51:07 userver2 kernel: [4689104.636862]  [<ffffffff881f2f4a>] :xf=
s:xfs_log_reserve+0xa0/0xc1
Sep  5 02:51:07 userver2 kernel: [4689104.639956]  [<ffffffff881fb800>] :xf=
s:xfs_trans_reserve+0xdd/0x1b0
Sep  5 02:51:07 userver2 kernel: [4689104.640035]  [<ffffffff881edd4d>] :xf=
s:xfs_iomap_write_allocate+0xe0/0x354
Sep  5 02:51:07 userver2 kernel: [4689104.640111]  [<ffffffff8809f70a>] :aa=
craid:aac_fib_send+0x144/0x26d
Sep  5 02:51:07 userver2 kernel: [4689104.640196]  [<ffffffff881eea22>] :xf=
s:xfs_iomap+0x21b/0x295
Sep  5 02:51:07 userver2 kernel: [4689104.640286]  [<ffffffff88205281>] :xf=
s:xfs_map_blocks+0x2d/0x5f
Sep  5 02:51:07 userver2 kernel: [4689104.640366]  [<ffffffff8820637c>] :xf=
s:xfs_page_state_convert+0x2a2/0x54f
Sep  5 02:51:07 userver2 kernel: [4689104.640462]  [<ffffffff88206788>] :xf=
s:xfs_vm_writepage+0xb4/0xec
Sep  5 02:51:07 userver2 kernel: [4689104.640523]  [<ffffffff802770f3>] __w=
ritepage+0xa/0x23
Sep  5 02:51:07 userver2 kernel: [4689104.640572]  [<ffffffff802775b8>] wri=
te_cache_pages+0x182/0x2b1
Sep  5 02:51:07 userver2 kernel: [4689104.640630]  [<ffffffff802770e9>] __w=
ritepage+0x0/0x23
Sep  5 02:51:07 userver2 kernel: [4689104.640703]  [<ffffffff881ec72d>] :xf=
s:xfs_iflush+0x30c/0x46c
Sep  5 02:51:07 userver2 kernel: [4689104.640763]  [<ffffffff80318e0f>] __u=
p_read+0x13/0x8a
Sep  5 02:51:07 userver2 kernel: [4689104.640835]  [<ffffffff881fc696>] :xf=
s:xfs_trans_unlocked_item+0x24/0x3d
Sep  5 02:51:07 userver2 kernel: [4689104.640900]  [<ffffffff80277723>] do_=
writepages+0x20/0x2d
Sep  5 02:51:07 userver2 kernel: [4689104.640959]  [<ffffffff802b4baa>] __w=
riteback_single_inode+0x144/0x29d
Sep  5 02:51:07 userver2 kernel: [4689104.641029]  [<ffffffff88194de1>] :dm=
_mod:dm_table_put+0x14/0xc8
Sep  5 02:51:07 userver2 kernel: [4689104.641093]  [<ffffffff802b506e>] syn=
c_sb_inodes+0x1b1/0x285
Sep  5 02:51:07 userver2 kernel: [4689104.641148]  [<ffffffff802b548e>] wri=
teback_inodes+0x62/0xb3
Sep  5 02:51:07 userver2 kernel: [4689104.641206]  [<ffffffff80277f63>] wb_=
kupdate+0x9e/0x10d
Sep  5 02:51:07 userver2 kernel: [4689104.641261]  [<ffffffff802782ea>] pdf=
lush+0x0/0x209
Sep  5 02:51:07 userver2 kernel: [4689104.641313]  [<ffffffff80278446>] pdf=
lush+0x15c/0x209
Sep  5 02:51:07 userver2 kernel: [4689104.641361]  [<ffffffff80277ec5>] wb_=
kupdate+0x0/0x10d
Sep  5 02:51:07 userver2 kernel: [4689104.641416]  [<ffffffff8024691b>] kth=
read+0x47/0x74
Sep  5 02:51:07 userver2 kernel: [4689104.641465]  [<ffffffff8023036d>] sch=
edule_tail+0x27/0x5c
Sep  5 02:51:07 userver2 kernel: [4689104.641521]  [<ffffffff8020ce08>] chi=
ld_rip+0xa/0x12
Sep  5 02:51:07 userver2 kernel: [4689104.641577]  [<ffffffff802468d4>] kth=
read+0x0/0x74
Sep  5 02:51:07 userver2 kernel: [4689104.641628]  [<ffffffff8020cdfe>] chi=
ld_rip+0x0/0x12
Sep  5 02:51:07 userver2 kernel: [4689104.641676]=20


Sep  5 02:51:07 userver2 kernel: [4689104.641676]=20
Sep  5 02:51:07 userver2 kernel: [4689104.641756] INFO: task python:12803 b=
locked for more than 120 seconds.
Sep  5 02:51:07 userver2 kernel: [4689104.641813] "echo 0 > /proc/sys/kerne=
l/hung_task_timeout_secs" disables this message.
Sep  5 02:51:07 userver2 kernel: [4689104.641900] python        D 000000000=
0000000     0 12803  12791
Sep  5 02:51:07 userver2 kernel: [4689104.641952]  ffff8117b762dd38 0000000=
000000082 0000000000000000 ffff8101c5e61680
Sep  5 02:51:07 userver2 kernel: [4689104.642043]  ffff8112099de440 ffff812=
024e58080 ffff8112099de6b0 0000000d00000000
Sep  5 02:51:07 userver2 kernel: [4689104.642130]  00000000ffffffff 0000000=
00000000e 0000000000000000 0000000000000000
Sep  5 02:51:07 userver2 kernel: [4689104.642189] Call Trace:
Sep  5 02:51:07 userver2 kernel: [4689104.642270]  [<ffffffff8041e162>] sch=
edule_timeout+0x1e/0xad
Sep  5 02:51:07 userver2 kernel: [4689104.642322]  [<ffffffff802794e0>] pag=
evec_lookup+0x17/0x1e
Sep  5 02:51:07 userver2 kernel: [4689104.642376]  [<ffffffff80279c57>] tru=
ncate_inode_pages_range+0x207/0x2f9
Sep  5 02:51:07 userver2 kernel: [4689104.642433]  [<ffffffff80246c09>] add=
_wait_queue_exclusive+0x15/0x41
Sep  5 02:51:07 userver2 kernel: [4689104.642514]  [<ffffffff881f243d>] :xf=
s:xlog_grant_log_space+0x1a9/0x253
Sep  5 02:51:07 userver2 kernel: [4689104.642573]  [<ffffffff8022d463>] def=
ault_wake_function+0x0/0xe
Sep  5 02:51:07 userver2 kernel: [4689104.642647]  [<ffffffff881f2f4a>] :xf=
s:xfs_log_reserve+0xa0/0xc1
Sep  5 02:51:07 userver2 kernel: [4689104.642727]  [<ffffffff881fb800>] :xf=
s:xfs_trans_reserve+0xdd/0x1b0
Sep  5 02:51:07 userver2 kernel: [4689104.642811]  [<ffffffff88200326>] :xf=
s:xfs_free_eofblocks+0x16b/0x213
Sep  5 02:51:07 userver2 kernel: [4689104.642899]  [<ffffffff88208d9d>] :xf=
s:xfs_file_release+0x10/0x15
Sep  5 02:51:07 userver2 kernel: [4689104.642956]  [<ffffffff8029b45b>] __f=
put+0xa1/0x16c
Sep  5 02:51:07 userver2 kernel: [4689104.643008]  [<ffffffff80298ccb>] fil=
p_close+0x5d/0x65
Sep  5 02:51:07 userver2 kernel: [4689104.643061]  [<ffffffff80299e49>] sys=
_close+0x7e/0xb7
Sep  5 02:51:07 userver2 kernel: [4689104.643110]  [<ffffffff8020bd9a>] sys=
tem_call_after_swapgs+0x8a/0x8f
Sep  5 02:51:07 userver2 kernel: [4689104.643172]=20


Sep  5 02:51:07 userver2 kernel: [4689104.643172]=20
Sep  5 02:51:07 userver2 kernel: [4689104.643207] INFO: task cron:12813 blo=
cked for more than 120 seconds.
Sep  5 02:51:07 userver2 kernel: [4689104.643264] "echo 0 > /proc/sys/kerne=
l/hung_task_timeout_secs" disables this message.
Sep  5 02:51:07 userver2 kernel: [4689104.643923] cron          D 000000000=
0000000     0 12813   5768
Sep  5 02:51:07 userver2 kernel: [4689104.643975]  ffff8119f8103b88 0000000=
000000086 0000000000000000 ffff811022950500
Sep  5 02:51:07 userver2 kernel: [4689104.644066]  ffff812024d56dc0 ffff811=
024ccd140 ffff812024d57030 0000000b22950500
Sep  5 02:51:07 userver2 kernel: [4689104.644156]  00000000ffffffff fffffff=
f802950fc 0000000000000000 0000000000000000
Sep  5 02:51:07 userver2 kernel: [4689104.644220] Call Trace:
Sep  5 02:51:07 userver2 kernel: [4689104.644296]  [<ffffffff802950fc>] cac=
he_grow+0x1c9/0x223
Sep  5 02:51:07 userver2 kernel: [4689104.644351]  [<ffffffff8041e162>] sch=
edule_timeout+0x1e/0xad
Sep  5 02:51:07 userver2 kernel: [4689104.644411]  [<ffffffff80246c09>] add=
_wait_queue_exclusive+0x15/0x41
Sep  5 02:51:07 userver2 kernel: [4689104.644486]  [<ffffffff881f2358>] :xf=
s:xlog_grant_log_space+0xc4/0x253
Sep  5 02:51:07 userver2 kernel: [4689104.644544]  [<ffffffff8022d463>] def=
ault_wake_function+0x0/0xe
Sep  5 02:51:07 userver2 kernel: [4689104.644618]  [<ffffffff881f2f4a>] :xf=
s:xfs_log_reserve+0xa0/0xc1
Sep  5 02:51:07 userver2 kernel: [4689104.644698]  [<ffffffff881fb800>] :xf=
s:xfs_trans_reserve+0xdd/0x1b0
Sep  5 02:51:07 userver2 kernel: [4689104.644757]  [<ffffffff802a1354>] do_=
lookup+0x63/0x1af
Sep  5 02:51:07 userver2 kernel: [4689104.644832]  [<ffffffff88201ab6>] :xf=
s:xfs_create+0x14b/0x4d2
Sep  5 02:51:07 userver2 kernel: [4689104.644910]  [<ffffffff881e7c69>] :xf=
s:xfs_iunlock+0x57/0x79
Sep  5 02:51:07 userver2 kernel: [4689104.644999]  [<ffffffff8820b4ad>] :xf=
s:xfs_vn_mknod+0x148/0x23e
Sep  5 02:51:07 userver2 kernel: [4689104.645058]  [<ffffffff802a278b>] vfs=
_create+0xcf/0x140
Sep  5 02:51:07 userver2 kernel: [4689104.645115]  [<ffffffff802a4a8e>] ope=
n_namei+0x1a0/0x669
Sep  5 02:51:07 userver2 kernel: [4689104.645168]  [<ffffffff8036148f>] rel=
ease_dev+0x43d/0x5f0
Sep  5 02:51:07 userver2 kernel: [4689104.645224]  [<ffffffff80298ff6>] do_=
filp_open+0x1c/0x38
Sep  5 02:51:07 userver2 kernel: [4689104.645284]  [<ffffffff80298d44>] get=
_unused_fd_flags+0x71/0x115
Sep  5 02:51:07 userver2 kernel: [4689104.645339]  [<ffffffff80299058>] do_=
sys_open+0x46/0xc3
Sep  5 02:51:07 userver2 kernel: [4689104.645396]  [<ffffffff8020bd9a>] sys=
tem_call_after_swapgs+0x8a/0x8f
Sep  5 02:51:07 userver2 kernel: [4689104.645456]=20

Sometimes, we can see nfs related functions in the backtraces too.
Usually more then a single process at a time is reported to be blocking.
Does anybody have any suggestions how we can solve this (besides
disabling the hung timeout message). Can we print some more stats about
blocked processes, when the problem happens again? Sometimes sshd blocks
and we are notified by our monitoring system.

--=-ADQFDmkRrANpn8+o/cqc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjJMWQACgkQ1V7s4RB7CAf7cQCfYcC9px1AZr18npRTwMP+NorN
v3EAn1RY2ykebS0ShEDcL6vZqZiZcIMu
=/3hC
-----END PGP SIGNATURE-----

--=-ADQFDmkRrANpn8+o/cqc--

