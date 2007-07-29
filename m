Return-Path: <linux-kernel-owner+w=401wt.eu-S1761559AbXG2Je2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761559AbXG2Je2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 05:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760964AbXG2JeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 05:34:21 -0400
Received: from piware.de ([213.9.79.162]:53821 "EHLO box79162.elkhouse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759731AbXG2JeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 05:34:21 -0400
Date: Sun, 29 Jul 2007 11:34:18 +0200
From: Martin Pitt <martin.pitt@ubuntu.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Martin Pitt <martin.pitt@ubuntu.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jeremy@goop.org, wwoods@redhat.com,
       Ben Collins <ben.collins@ubuntu.com>
Subject: Re: [PATCH 2/3] core_pattern: allow passing of arguments to user
	mode helper when core_pattern is a pipe
Message-ID: <20070729093418.GA5794@piware.de>
References: <20070727200746.GC18946@hmsreliant.homelinux.net> <20070728092355.GA5808@piware.de> <20070728134627.GA10006@hmsreliant.homelinux.net> <20070728161725.GA5836@piware.de> <20070728172142.GA10555@hmsreliant.homelinux.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <20070728172142.GA10555@hmsreliant.homelinux.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Neil,

Neil Horman [2007-07-28 13:21 -0400]:
> Jeremy asked that I make a patch next week to address split_argv's requir=
ement
> that the argc parameter be non-NULL.  I'll be fixing that next week, and =
what I
> can do is further enhance it such that it ignores spaces in quoted string=
s,
> which should address the case that concerns you.  I.E I can make split_ar=
gv
> behave such that:
> echo "|\"foo bar\" --pid %p" > /proc/sys/kernel/core_pattern
> results in the following argv:
> {{"foo bar"}, {"--pid"}, {"1234"}}
>=20
> Which I think handles what you are looking for.

Oh, handling escaping and quoting is going to make it fairly
complicated, but sure, if you need that for other things, too, that
would solve the remaining case. I just wonder if, instead of
implementing escaping, it wouldn't be easier to first split on spaces
and then escape macros?

> Thank you for clearing me up on this.  So it would seem we're ok with wha=
t we
> have now, correct? =20

Absolutely, yes.

> We just have a potential corner case to address, which I can
> reasonably handle with a modification to split_argv, that I have a
> todo on next week.

Right, it's really just for perfectionism. Spaces in executable names
are EBW anyway, and readlink()ing /proc/<pid>/exe is much more robust
anyway in terms of a small and orthogonal interface.

If the upstream kernel guys don't worry about it and consider it a
blocker for merging, I don't either. :-)

Thanks a lot,

Martin

--=20
Martin Pitt        http://www.piware.de
Ubuntu Developer   http://www.ubuntu.com
Debian Developer   http://www.debian.org

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGrF8aDecnbV4Fd/IRAunuAKDNOiEpWZJlJ24/e+ngQRX7/i9/WACfRzOc
t9InS48Bt5upujBpbWbg26k=
=YLzk
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
