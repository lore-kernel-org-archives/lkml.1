Return-Path: <linux-kernel-owner+w=401wt.eu-S1757669AbXEZLOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669AbXEZLOQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 07:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbXEZLOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 07:14:06 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:59964 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbXEZLOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 07:14:05 -0400
Subject: Re: software suspend doesn't work with 2.6.22-rc3
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Maximilian Engelhardt <maxi@daemonizer.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070526110818.GA7918@gondor.apana.org.au>
References: <200705261128.57332.maxi@daemonizer.de>
	 <1180173233.9773.79.camel@nigel.suspend2.net>
	 <20070526110818.GA7918@gondor.apana.org.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-COtTWeSpbGhL0e+JOm44"
Date: Sat, 26 May 2007 21:14:00 +1000
Message-Id: <1180178040.5493.5.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-COtTWeSpbGhL0e+JOm44
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Sat, 2007-05-26 at 21:08 +1000, Herbert Xu wrote:
> On Sat, May 26, 2007 at 07:53:53PM +1000, Nigel Cunningham wrote:
> >=20
> > Herbert, is this right? If cryptd is going to be used for block devs,
> > the task should probably be PF_NOFREEZE (or whatever it is today)
> > instead.
>=20
> Probably.  However, I don't think this is responsible for the reported
> problem because the code to use cryptd in dm-crypt hasn't been merged
> yet :)

You have the cryptd Kconfig option in (at least in rc3) - presumably
Maximillian has been too keen and turned it on before you were ready :)
It does make sense for it to be the problem. Without PF_NOFREEZE set,
the refrigerator code will try to get it to enter the freezer, and
without the try_to_freeze(), it will just loop and freezing will fail.

Regards,

Nigel

--=-COtTWeSpbGhL0e+JOm44
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGWBZ4N0y+n1M3mo0RAnsLAKC5rbohnZcxXadiL1bMn8GStCwDTwCfXuTM
Kt33ZOTdU6Z2rGAJHn4boJg=
=hDml
-----END PGP SIGNATURE-----

--=-COtTWeSpbGhL0e+JOm44--

