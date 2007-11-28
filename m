Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbXK1Rv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbXK1Rv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 12:51:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbXK1Rvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 12:51:51 -0500
Received: from mail.anarazel.de ([217.115.131.40]:48999 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671AbXK1Rvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 12:51:50 -0500
X-Greylist: delayed 826 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Nov 2007 12:51:50 EST
From: Andres Freund <andres@anarazel.de>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: "hwcap 0 nosegneg" doesnt work with paravirt_ops xen as of 2.6.23.9
Date: Wed, 28 Nov 2007 18:29:24 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7219305.ctY5eHb2m8";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200711281829.25532.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart7219305.ctY5eHb2m8
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi all,

after converting a host from using a ubuntu patched 2.6.22 domU to using=20
2.6.23 xen via paravirt_ops (no configuration change except devicename chan=
ge=20
in fstab, and another getty running) ldconfig no longer picks up the nosegn=
eg=20
libc leading to segfaults for some programs.

/etc/ld.so.conf.d/xen.conf:
hwcap 0 nosegneg

On ubuntu's 2.6.22-xen:
ldd /usr/bin/perl
        linux-gate.so.1 =3D>  (0xf57fe000)
        libdl.so.2 =3D> /lib/tls/i686/nosegneg/libdl.so.2 (0xb7f90000)
        libm.so.6 =3D> /lib/tls/i686/nosegneg/libm.so.6 (0xb7f6b000)
        libpthread.so.0 =3D> /lib/tls/i686/nosegneg/libpthread.so.0 (0xb7f5=
3000)
        libc.so.6 =3D> /lib/tls/i686/nosegneg/libc.so.6 (0xb7e05000)
        libcrypt.so.1 =3D> /lib/tls/i686/nosegneg/libcrypt.so.1 (0xb7dd7000)
        /lib/ld-linux.so.2 (0xb7f9d000)

On selfcompiled 2.6.23.9:
ldd /usr/bin/perl
        linux-gate.so.1 =3D>  (0xf57fc000)
        libdl.so.2 =3D> /lib/tls/i686/cmov/libdl.so.2 (0xb7f3b000)
        libm.so.6 =3D> /lib/tls/i686/cmov/libm.so.6 (0xb7f16000)
        libpthread.so.0 =3D> /lib/tls/i686/cmov/libpthread.so.0 (0xb7efe000)
        libc.so.6 =3D> /lib/tls/i686/cmov/libc.so.6 (0xb7db3000)
        libcrypt.so.1 =3D> /lib/tls/i686/cmov/libcrypt.so.1 (0xb7d85000)
        /lib/ld-linux.so.2 (0xb7f46000)


I now discover, that after some playing around (during discovering what the=
=20
problem is) i must have changed something, because ldd still shows the use =
of=20
the i686/cmov libraries, but applications reliably causing crashes earlier,=
=20
dont do so anymore.

Perhaps Im all wrong, and paravirt_ops doesnt need the nosegneg versions an=
d=20
just a ldconfig or so (which seems strange because the result before and=20
after the ldconfig were the same).

Greetings,=20

Andres Freund


PS: I did this conversion mainly, because I was getting quite random crashe=
s=20
inside the domU. I guess, as this was a vendor kernel + xensource xen kerne=
l,=20
this isnt appropriate for lkml? As well as the crashes of the Dom0 (ubuntu=
=20
again)?

--nextPart7219305.ctY5eHb2m8
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHTaV1porPraT14igRAs+8AJ9ds+Q5gctd+mV3pdAQIEXRFHIgFwCffKy2
ZTTFths25CqlMeVkAK4u3TQ=
=xhHT
-----END PGP SIGNATURE-----

--nextPart7219305.ctY5eHb2m8--
