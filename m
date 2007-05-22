Return-Path: <linux-kernel-owner+w=401wt.eu-S1757508AbXEVEKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508AbXEVEKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 00:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755288AbXEVEKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 00:10:39 -0400
Received: from iucha.net ([209.98.146.184]:47538 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185AbXEVEKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 00:10:39 -0400
Date: Mon, 21 May 2007 23:10:36 -0500
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Oops in dentry_iput with 2.6.22-rc2 on AMD64
Message-ID: <20070522041036.GD6074@iucha.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RhUH2Ysw6aD5utA4"
Content-Disposition: inline
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.13 (2006-08-11)
From: florin@iucha.net (Florin Iucha)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--RhUH2Ysw6aD5utA4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I was running a multithreaded perl application that leaks some memory
so it gets to eat up a significant chunk of my 2 GB and even push a
bit into swap.  I left it running before going out for a walk.

When I got back, I found this in the log:

[28818.103829] Unable to handle kernel paging request at ffff910025c9a8b4 R=
IP:=20
[28818.103836]  [<ffffffff80288998>] dentry_iput+0x58/0xbb
[28818.103845] PGD 0=20
[28818.103848] Oops: 0000 [1] SMP=20
[28818.103851] CPU 0=20
[28818.103853] Modules linked in: radeon ntfs sbp2 lp lgdt330x cx88_dvb cx8=
8_vp3054_i2c dvb_pll video_buf_dvb tuner cx8802 cx88_alsa cx8800 cx88xx ir_=
common rtc tveeprom video_buf btcx_risc i2c_nforce2 evdev forcedeth
[28818.103868] Pid: 253, comm: kswapd0 Not tainted 2.6.22-rc2 #1
[28818.103871] RIP: 0010:[<ffffffff80288998>]  [<ffffffff80288998>] dentry_=
iput+0x58/0xbb
[28818.103877] RSP: 0000:ffff81007de75d40  EFLAGS: 00010246
[28818.103880] RAX: 0000000000000000 RBX: ffff810075662e00 RCX: ffff810025c=
9a898
[28818.103883] RDX: ffff810025c9a898 RSI: 0000000000000001 RDI: 00000000000=
00282
[28818.103886] RBP: ffff81007de75d50 R08: 000000000000534d R09: 00000000000=
00064
[28818.103890] R10: ffff81007de75d80 R11: 000000000000000a R12: ffff910025c=
9a868
[28818.103893] R13: ffff810075662e08 R14: 0000000000000000 R15: 00000000000=
0005e
[28818.103897] FS:  0000000042804940(0000) GS:ffffffff806c8000(0000) knlGS:=
0000000000000000
[28818.103900] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[28818.103903] CR2: ffff910025c9a8b4 CR3: 00000000254bf000 CR4: 00000000000=
006e0
[28818.103907] Process kswapd0 (pid: 253, threadinfo ffff81007de74000, task=
 ffff81007de706d0)
[28818.103909] Stack:  ffff810075662e00 0000000000000001 ffff81007de75d70 f=
fffffff80288aaf
[28818.103916]  ffff81007e606070 0000000000000001 ffff81007de75d90 ffffffff=
80289a35
[28818.103921]  ffff81007e606070 ffff810075662e00 ffff81007de75dd0 ffffffff=
80289d3d
[28818.103926] Call Trace:
[28818.103931]  [<ffffffff80288aaf>] d_kill+0x38/0x58
[28818.103935]  [<ffffffff80289a35>] prune_one_dentry+0x3c/0x10f
[28818.103939]  [<ffffffff80289d3d>] prune_dcache+0x137/0x1a0
[28818.103944]  [<ffffffff80289dc2>] shrink_dcache_memory+0x1c/0x35
[28818.103948]  [<ffffffff80261178>] shrink_slab+0xe6/0x162
[28818.103953]  [<ffffffff802615ef>] kswapd+0x329/0x4ca
[28818.103958]  [<ffffffff8024458b>] autoremove_wake_function+0x0/0x38
[28818.103963]  [<ffffffff802612c6>] kswapd+0x0/0x4ca
[28818.103967]  [<ffffffff8024447f>] kthread+0x49/0x76
[28818.103971]  [<ffffffff8020a578>] child_rip+0xa/0x12
[28818.103977]  [<ffffffff80244436>] kthread+0x0/0x76
[28818.103980]  [<ffffffff8020a56e>] child_rip+0x0/0x12
[28818.103982]=20
[28818.103984]=20
[28818.103985] Code: 41 83 7c 24 4c 00 75 1c 4c 89 e7 45 31 c0 31 c9 31 d2 =
be 00=20
[28818.103994] RIP  [<ffffffff80288998>] dentry_iput+0x58/0xbb
[28818.103999]  RSP <ffff81007de75d40>
[28818.104001] CR2: ffff910025c9a8b4

florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--RhUH2Ysw6aD5utA4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGUm08ND0rFCN2b1sRAj8BAJ981puLQziO7qVkiExaewGRj7LYZACfStuY
7RY+p5yINNveWO0R1mgkFjk=
=yS53
-----END PGP SIGNATURE-----

--RhUH2Ysw6aD5utA4--
