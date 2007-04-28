Return-Path: <linux-kernel-owner+w=401wt.eu-S1030490AbXD1TVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030490AbXD1TVy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 15:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161182AbXD1TUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 15:20:40 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:60607 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031192AbXD1TU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 15:20:26 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v7
Date: Sat, 28 Apr 2007 22:20:12 +0300
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, Willy Tarreau <w@1wt.eu>,
       Gene Heskett <gene.heskett@gmail.com>, Mark Lord <lkml@rtr.ca>,
       Zach Carter <linux@zachcarter.com>, Kasper Sandberg <lkml@metanurb.dk>,
       buddabrod <buddabrod@gmail.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>
References: <20070428152539.GA21601@elte.hu>
In-Reply-To: <20070428152539.GA21601@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart17582755.a5obTXkfY0";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704282220.17689.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart17582755.a5obTXkfY0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

28 Nis 2007 Cts tarihinde, Ingo Molnar =C5=9Funlar=C4=B1 yazm=C4=B1=C5=9Ft=
=C4=B1:=20
>  - feature removal: remove the X auto-renicing feature, CONFIG_BOOST_X.

This the the first time i use CFS with without X auto-renicing and i think =
its=20
not smooth as before :(

While compiling something (say alsa-drivers) with just "make" firefox start=
s=20
to scrolls slowly, kmail frezes time to time, applications are not responsi=
ve=20
as before in that load and also system is not as fast as before while syste=
m=20
idle. Also somehow boot takes longer;

v6;
Apr 28 16:40:41 (up 10.57) /sbin/mudur.py sysinit
Apr 28 13:40:49 (up 17.75) /sbin/mudur.py boot
Apr 28 13:41:00 (up 28.61) /sbin/mudur.py default

v7;
Apr 29 00:35:49 (up 10.61) /sbin/mudur.py sysinit
Apr 28 21:36:14 (up 33.77) /sbin/mudur.py boot
Apr 28 21:36:16 (up 36.21) /sbin/mudur.py default


And i while trying to understand what caused this (or trying to confirm X i=
s=20
the problem), i realized Xorg is not the only reniced process in v6

[caglar@zangetsu][~]> diff -u top.v7 top.v6
=2E..
   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
=2E..
     2 root      RT   0     0    0    0 S  0.0  0.0   0:00.00 migration/0
     3 root      39  19     0    0    0 S  0.0  0.0   0:00.00 ksoftirqd/0
=2D    4 root      15  -5     0    0    0 S  0.0  0.0   0:00.11 events/0
=2D    5 root      15  -5     0    0    0 S  0.0  0.0   0:00.01 khelper
=2D    6 root      15  -5     0    0    0 S  0.0  0.0   0:00.00 kthread
=2D   26 root      15  -5     0    0    0 S  0.0  0.0   0:00.02 kblockd/0
=2D   27 root      15  -5     0    0    0 S  0.0  0.0   0:00.00 kacpid
=2D  124 root      15  -5     0    0    0 S  0.0  0.0   0:00.00 kseriod
=2D  137 root      15  -5     0    0    0 S  0.0  0.0   0:00.00 kapmd
+    4 root      10 -10     0    0    0 S  0.0  0.0   0:00.01 events/0
+    5 root      10 -10     0    0    0 S  0.0  0.0   0:00.01 khelper
+    6 root      10 -10     0    0    0 S  0.0  0.0   0:00.00 kthread
+   26 root      10 -10     0    0    0 S  0.0  0.0   0:00.03 kblockd/0
+   27 root      10 -10     0    0    0 S  0.0  0.0   0:00.00 kacpid
+  124 root      10 -10     0    0    0 S  0.0  0.0   0:00.00 kseriod
+  137 root      10 -10     0    0    0 S  0.0  0.0   0:00.00 kapmd
=2E..

Until now i didn't try to renice X manually to see if it changes anything i=
n=20
v7 but i will (=C4=B1rgh, i simply boot with v6).

> As usual, any sort of feedback, bugreport, fix and suggestion is more
> than welcome,

If you want some more output/info etc. please just say, i have both v6 and =
v7=20
available.

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart17582755.a5obTXkfY0
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBGM55xy7E6i0LKo6YRAmKKAKChZUVN3wkAd1wOTOPU497v+0M3/wCfSuec
8RtaQZ6CpFa/u1ozOXg+pa8=
=Zi+g
-----END PGP SIGNATURE-----

--nextPart17582755.a5obTXkfY0--
