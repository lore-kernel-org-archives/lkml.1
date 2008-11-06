Return-Path: <linux-kernel-owner+w=401wt.eu-S1755870AbYKFEYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbYKFEYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 23:24:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbYKFEYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 23:24:39 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41898 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943AbYKFEYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 23:24:38 -0500
Date: Thu, 6 Nov 2008 15:24:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "David S. Miller" <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>,
       "William L. Irwin" <wli@holomorphy.com>, <sparclinux@vger.kernel.org>
Subject: tty warning
Message-Id: <20081106152421.a9cf964f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__6_Nov_2008_15_24_21_+1100_Z0wfL10ez+IsTWD="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Nov_2008_15_24_21_+1100_Z0wfL10ez+IsTWD=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alan,

A sparc allmodconfig build gives these warnings:

drivers/char/n_tty.c: In function 'n_tty_poll':
drivers/char/n_tty.c:1592: warning: array subscript is above array bounds
drivers/char/n_tty.c:1601: warning: array subscript is above array bounds
drivers/char/n_tty.c: In function 'n_tty_read':
drivers/char/n_tty.c:1306: warning: array subscript is above array bounds
drivers/char/tty_ioctl.c: In function 'set_termios':
drivers/char/tty_ioctl.c:574: warning: array subscript is above array bounds
drivers/char/tty_ioctl.c:578: warning: array subscript is above array bounds
drivers/char/tty_ioctl.c: In function 'tty_mode_ioctl':
drivers/char/tty_ioctl.c:729: warning: array subscript is above array bounds
drivers/char/tty_ioctl.c:963: warning: array subscript is above array bounds
drivers/char/tty_ioctl.c:969: warning: array subscript is above array bounds
drivers/char/tty_ioctl.c:618: warning: array subscript is above array bounds
drivers/char/tty_ioctl.c:1007: warning: array subscript is above array boun=
ds
drivers/char/tty_ioctl.c:1015: warning: array subscript is above array boun=
ds

These are things like:

                termios->c_cc[VTIME] =3D 0;

termios is a (struct ktermios *) which has "cc_t c_cc[NCCS];".  NCCS is
17 and VTIME is also 17.  I assume the intention is to actually fill in
_x_cc[0], but why is it done this way and not more directly?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__6_Nov_2008_15_24_21_+1100_Z0wfL10ez+IsTWD=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkScXUACgkQjjKRsyhoI8zjOACfaIsrUtauz/vDsOusCC4UOmrS
DkYAniz2cV2d8H0c0eFJAL2RORS1o9c8
=eQ5O
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Nov_2008_15_24_21_+1100_Z0wfL10ez+IsTWD=--
