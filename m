Return-Path: <linux-kernel-owner+w=401wt.eu-S1758589AbXE1Ces@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589AbXE1Ces (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 22:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbXE1Cel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 22:34:41 -0400
Received: from mx27.mail.ru ([194.67.23.64]:21537 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbXE1Cek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 22:34:40 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-kernel@vger.kernel.org
Subject: 2.6.22-rc3: regression: make M=$PWD modules_install does nothing
Date: Mon, 28 May 2007 06:34:36 +0400
User-Agent: KMail/1.9.7
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, sam@ravnborg.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1377374.SdOcRMu0Fh";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705280634.37420.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1377374.SdOcRMu0Fh
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

This has been working up and including -rc2:

{pts/1}% sudo make -C ~/src/linux-git O=3D$HOME/build/linux-2.6.22 M=3DPWD =
V=3D1=20
modules_install
make: Entering directory `/home/bor/src/linux-git'
make -C /home/bor/build/linux-2.6.22 \
        KBUILD_SRC=3D/home/bor/src/linux-git \
        KBUILD_EXTMOD=3D"PWD" -f /home/bor/src/linux-git/Makefile=20
modules_install
test -e include/linux/autoconf.h -a -e include/config/auto.conf || (       =
   =20
\
        echo;                                                           \
        echo "  ERROR: Kernel configuration is invalid.";               \
        echo "         include/linux/autoconf.h or include/config/auto.conf=
=20
are missing.";      \
        echo "         Run 'make oldconfig && make prepare' on kernel src t=
o=20
fix it.";  \
        echo;                                                           \
        /bin/false)
mkdir -p /lib/modules/2.6.22-rc3-1avb/extra
make -f /home/bor/src/linux-git/scripts/Makefile.modinst
  if [ -r System.map -a -x /sbin/depmod ]; then /sbin/depmod -ae -F System.=
map =20
2.6.22-rc3-1avb; fi
make: Leaving directory `/home/bor/src/linux-git'

Makefile is trivial:

{pts/1}% cat Makefile
#
# Makefile for wlags49_cs_xxx
#

EXTRA_CFLAGS=20
+=3D -I$(src) -I$(src)/include -I$(src)/include/hcf -I$(src)/include/wirele=
ss \
                -DBUS_PCMCIA -DUSE_UIL -DUSE_OLD_PARMS -DUSE_WPA \
                -DUSE_WEXT -DWVLAN_49 \
#               -DDBG \
#               -DUSE_PROFILE

obj-m           +=3D wlags49_h1_cs.o

wlags49_h1_cs-y :=3D wl_profile.o \
            wl_sysfs.o \
            wl_wext.o \
            wl_priv.o \
            wl_main.o \
            wl_enc.o \
            wl_util.o \
            wl_netdev.o \
            wl_cs.o \
            mmd.o \
            hcfio.o \
            hcf.o \
            dhf.o \
            sta_h1.o \
            ap_h1.o



ifndef src
src =3D .
endif
foo: foo.c hcf.h dhf.h hcfdef.h sta_h1.c
        $(CC) -o foo $(EXTRA_CFLAGS) foo.c


--nextPart1377374.SdOcRMu0Fh
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGWj+9R6LMutpd94wRAgCmAJ908+y2gSWt3jf0l6mqo/TrsNieLACgpgW0
W4cseJMrZiK1ZZ4cqrVAYrM=
=yK/m
-----END PGP SIGNATURE-----

--nextPart1377374.SdOcRMu0Fh--
