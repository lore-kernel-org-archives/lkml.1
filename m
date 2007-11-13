Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbXKMKy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbXKMKy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 05:54:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbXKMKyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 05:54:20 -0500
Received: from mail.phnxsoft.com ([195.227.45.4]:2114 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbXKMKyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 05:54:19 -0500
Message-ID: <47398255.3030309@imap.cc>
Date: Tue, 13 Nov 2007 11:54:13 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       josh@freedesktop.org
Subject: [2.6.24-rc2] make C=1 killed by sparse 0.4 choking on kernel/sched.c
X-Enigmail-Version: 0.95.3
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3CEBCC1179C6BFE6296808C1"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3CEBCC1179C6BFE6296808C1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

When trying to build 2.6.24-rc2 with checking by sparse 0.4,
my "make" run dies with:

  CHECK   kernel/sched.c
kernel/sched.c:3616:15: warning: incorrect type in assignment (different =
signedness)
kernel/sched.c:3616:15:    expected long *switch_count
kernel/sched.c:3616:15:    got unsigned long *<noident>
kernel/sched.c:3638:16: warning: incorrect type in assignment (different =
signedness)
kernel/sched.c:3638:16:    expected long *switch_count
kernel/sched.c:3638:16:    got unsigned long *<noident>
sparse: flow.c:805: rewrite_parent_branch: Assertion `changed' failed.
/bin/sh: line 1: 31460 Aborted                 /home/ts/kernel/sparse-0.4=
/sparse -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise -Wno-d=
ecl
-Wno-shadow -D__i386__ -nostdinc -isystem /usr/lib/gcc/i586-suse-linux/4.=
2.1/include -Wp,-MD,kernel/.sched.o.d -nostdinc -isystem
/usr/lib/gcc/i586-suse-linux/4.2.1/include -D__KERNEL__ -Iinclude -includ=
e include/linux/autoconf.h -Wall -Wundef -Wstrict-prototypes -Wno-trigrap=
hs
-fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -O=
s -pipe -msoft-float -mregparm=3D3 -freg-struct-return -mpreferred-stack-=
boundary=3D2
-march=3Di686 -mtune=3Dpentium4 -ffreestanding -maccumulate-outgoing-args=
 -DCONFIG_AS_CFI=3D1 -DCONFIG_AS_CFI_SIGNAL_FRAME=3D1 -Iinclude/asm-x86/m=
ach-default
-fno-omit-frame-pointer -fno-optimize-sibling-calls -g -fno-stack-protect=
or -Wdeclaration-after-statement -Wno-pointer-sign -fno-omit-frame-pointe=
r
-D"KBUILD_STR(s)=3D#s" -D"KBUILD_BASENAME=3DKBUILD_STR(sched)" -D"KBUILD_=
MODNAME=3DKBUILD_STR(sched)" kernel/sched.c
make[1]: *** [kernel/sched.o] Error 134
make: *** [kernel] Error 2
make: *** Waiting for unfinished jobs....

I don't quite know what to make of this. It looks like a bug in
sparse, but kernel/sched.c is perhaps not quite innocent either.
Also it doesn't seem right that the entire kernel compilation
aborts just because of a failed sparse run.

Opinions?

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig3CEBCC1179C6BFE6296808C1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHOYJVQ3+did9BuFsRAnoaAJ4q/CtVZbGC+a3+2xj+xKGlr5DPSQCeIdM/
FYWnoV53N3E9Bn9bmByrM94=
=2iAu
-----END PGP SIGNATURE-----

--------------enig3CEBCC1179C6BFE6296808C1--
