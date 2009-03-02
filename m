Return-Path: <linux-kernel-owner+w=401wt.eu-S1753984AbZCBM1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbZCBM1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 07:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbZCBM1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 07:27:34 -0500
Received: from clegg.madduck.net ([193.242.105.96]:42097 "EHLO
	clegg.madduck.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbZCBM1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 07:27:33 -0500
Date: Mon, 2 Mar 2009 13:27:18 +0100
From: martin f krafft <madduck@madduck.net>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: /proc/sys/net/ip*/conf/all/* does not actually affect interfaces
Message-ID: <20090302122718.GA3906@piper.oerlikon.madduck.net>
Mail-Followup-To: linux kernel mailing list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
X-Motto: Keep the good times rollin'
X-OS: Debian GNU/Linux squeeze/sid kernel 2.6.26-1-amd64 x86_64
X-Spamtrap: madduck.bogus@madduck.net
X-Subliminal-Message: debian/rules!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Dear kernel gurus,

I was unpleasantly surprised last night that a rogue machine managed
to alter the IPv6 default route of one of my servers, despite my
sysctl configuration, which disables RA for "all" interfaces during
the boot sequence. It also changes the "default" values:

  net.ipv6.conf.default.autoconf =3D 0
  net.ipv6.conf.default.accept_ra =3D 0
  net.ipv6.conf.default.accept_ra_defrtr =3D 0
  net.ipv6.conf.default.accept_ra_pinfo =3D 0
  net.ipv6.conf.default.accept_source_route =3D 0
  net.ipv6.conf.default.accept_redirects =3D 0
  net.ipv6.conf.default.forwarding =3D 0
  net.ipv6.conf.all.autoconf =3D 0
  net.ipv6.conf.all.accept_ra =3D 0
  net.ipv6.conf.all.accept_ra_defrtr =3D 0
  net.ipv6.conf.all.accept_ra_pinfo =3D 0
  net.ipv6.conf.all.accept_source_route =3D 0
  net.ipv6.conf.all.accept_redirects =3D 0
  net.ipv6.conf.all.forwarding =3D 0

Yet, net.ipv6.conf.eth0.* values were unchanged, and routing
advertisements honoured.

This also applies to files in ipv4/, e.g. accept_redirects

A bit of investigation shows that something fishy is going on, or
at least it's unexpected to me, because I recall the conf/all/*
interface to do what it promised to do a while ago. Not anymore
though.

seamus# pwd
/proc/sys/net
seamus# head ipv4/conf/{all,eth0}/accept_redirects =20
=3D=3D> ipv4/conf/all/accept_redirects <=3D=3D
1

=3D=3D> ipv4/conf/eth0/accept_redirects <=3D=3D
1
seamus# echo 0 >| ipv4/conf/all/accept_redirects =20
seamus# head ipv4/conf/{all,eth0}/accept_redirects =20
=3D=3D> ipv4/conf/all/accept_redirects <=3D=3D
0

=3D=3D> ipv4/conf/eth0/accept_redirects <=3D=3D
1



***** shouldn't ipv4/conf/eth0/accept_redirects be 0 too??


same with ipv6:

seamus# head ipv6/conf/{all,eth0}/accept_ra
=3D=3D> ipv6/conf/all/accept_ra <=3D=3D
1

=3D=3D> ipv6/conf/eth0/accept_ra <=3D=3D
1
seamus# echo 0 >| ipv6/conf/all/accept_ra
seamus# head ipv6/conf/{all,eth0}/accept_ra
=3D=3D> ipv6/conf/all/accept_ra <=3D=3D
0

=3D=3D> ipv6/conf/eth0/accept_ra <=3D=3D
1



What is going on? Is this my fault, did something change in the
kernel, or is this a bug?

--=20
martin | http://madduck.net/ | http://two.sentenc.es/
=20
"in the figure of the president, george w. bush, the incompetence,
 stupidity, and sheer inhumanity that characterize so much of
 america's money-mad corporate elite find their quintessentially
 repulsive expression."
                                 -- journalist, aftermath of katrina
=20
spamtraps: madduck.bogus@madduck.net

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmr0KIACgkQIgvIgzMMSnVFsQCg0RNPgtlbcCY9fwsbDty81r1a
XKsAoJD4YHSqVY8HRT+PuTy10+sYw+EV
=6yxq
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
