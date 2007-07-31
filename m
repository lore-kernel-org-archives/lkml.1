Return-Path: <linux-kernel-owner+w=401wt.eu-S933914AbXGaVoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933914AbXGaVoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756904AbXGaVoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:44:25 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:32866 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756954AbXGaVoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:44:23 -0400
Subject: 2.6.22-rc1-mm1 huge pages VM freeze (maybe?)
From: Zan Lynx <zlynx@acm.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uWfYUKRHVqKejPIYKMK8"
Date: Tue, 31 Jul 2007 15:44:21 -0600
Message-Id: <1185918261.6981.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-Envelope-From: zlynx@acm.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uWfYUKRHVqKejPIYKMK8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I was playing with huge pages and libhugetlbfs.  Small programs like
"ls" work fine.  I tried running Evolution through libhugetlbfs and the
system slowly stops running.  One interesting thing is the "ps" command,
it gets stuck like this:

ps            D ffff81001e57ed40     0 103558 103483
 ffff81001f061dc8 0000000000000096 ffff81003d8586e8 ffff81001cbadc00
 0000000000000006 ffffffff80537009 0000000000000030 ffffffff807ff700
 ffffffff807ff700 ffffffff807ff700 ffffffff807ff700 ffffffff807ff700
Call Trace:
 [<ffffffff80537009>] _spin_unlock+0x29/0x50
 [<ffffffff80536425>] __down_read+0x75/0xaf
 [<ffffffff80295f49>] access_process_vm+0x49/0x190
 [<ffffffff802f3003>] proc_pid_cmdline+0xa3/0x130
 [<ffffffff802f4cea>] proc_info_read+0xba/0x100
 [<ffffffff802b0085>] vfs_read+0xc5/0x180
 [<ffffffff802b0583>] sys_read+0x53/0x90
 [<ffffffff8020c1de>] system_call+0x7e/0x83

and nothing will touch it after that.

Here's my kernel command line:
root=3D/dev/sda2 rootfstype=3Dreiser4 rootflags=3Dno_write_barrier ro
i8042.nomux elevator=3Dcfq resume=3D/dev/sda3 panic=3D5 nmi_watchdog=3D2,pa=
nic
debug hugepages=3D32

Here's the "huge" script I was using to run programs:
#!/bin/sh
export LD_PRELOAD=3Dlibhugetlbfs.so
export HUGETLB_MORECORE=3Dyes
export HUGETLB_PATH=3D/mnt/huge
export HUGETLB_VERBOSE=3D1
exec "$@"

I don't have any more info than that at the moment but I could reproduce
it with whatever, on request.

--=20
Zan Lynx <zlynx@acm.org>

--=-uWfYUKRHVqKejPIYKMK8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.5 (GNU/Linux)

iD8DBQBGr601G8fHaOLTWwgRAn1UAJ9T7oBaTGaPbtAcyi1o4Jz7KQs1/gCdElCH
NLSeo5RpzLApibWdwEwShB8=
=fuFD
-----END PGP SIGNATURE-----

--=-uWfYUKRHVqKejPIYKMK8--

